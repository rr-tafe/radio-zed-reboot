"""Export DefineBitsLossless2 bitmaps (PNG) and DefineSound MP3s from an uncompressed SWF,
named by their SymbolClass names."""
import os, struct, sys, zlib, json

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import io, contextlib
from swfinfo import parse


def png(w, h, rgba):
    def chunk(t, d):
        c = t + d
        return struct.pack('>I', len(d)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
    raw = b''.join(b'\0' + rgba[y*w*4:(y+1)*w*4] for y in range(h))
    return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))


def main(swf, out):
    with contextlib.redirect_stdout(io.StringIO()):
        tags = parse(swf)
    names = {}
    for code, data in tags:
        if code == 76:
            n = struct.unpack('<H', data[:2])[0]; p = 2
            for _ in range(n):
                cid = struct.unpack('<H', data[p:p+2])[0]; p += 2
                e = data.index(0, p); names.setdefault(cid, []).append(data[p:e].decode('latin1')); p = e + 1
    os.makedirs(f'{out}/images', exist_ok=True); os.makedirs(f'{out}/sounds', exist_ok=True)
    manifest = {'images': {}, 'sounds': {}}
    for code, data in tags:
        if code in (20, 36):
            cid, fmt, w, h = struct.unpack('<HBHH', data[:7])
            body = data[7:]
            if fmt == 3:
                ncol = body[0] + 1; px = zlib.decompress(body[1:])
                cw = 4 if code == 36 else 3
                pal = [px[i*cw:(i+1)*cw] for i in range(ncol)]
                stride = (w + 3) & ~3; idx = px[ncol*cw:]
                rgba = bytearray()
                for y in range(h):
                    for x in range(w):
                        c = pal[idx[y*stride + x]]
                        rgba += c if cw == 4 else c + b'\xff'
                rgba = bytes(rgba)
            elif fmt == 5:
                px = zlib.decompress(body)
                rgba = bytearray(w*h*4)
                for i in range(w*h):
                    a, r, g, b = px[i*4:i*4+4]
                    if code == 20: a = 255
                    if 0 < a < 255:  # un-premultiply
                        r, g, b = min(255, r*255//a), min(255, g*255//a), min(255, b*255//a)
                    rgba[i*4:i*4+4] = bytes((r, g, b, a))
                rgba = bytes(rgba)
            else:
                print('skip fmt', fmt, cid); continue
            nm = names.get(cid, [f'bitmap_{cid}'])
            fn = f'{nm[0]}.png'
            open(f'{out}/images/{fn}', 'wb').write(png(w, h, rgba))
            manifest['images'][fn] = {'id': cid, 'w': w, 'h': h, 'aliases': nm[1:]}
        elif code == 14:
            cid = struct.unpack('<H', data[:2])[0]; flags = data[2]
            fmt = flags >> 4; rate = [5512, 11025, 22050, 44100][(flags >> 2) & 3]
            samples = struct.unpack('<I', data[3:7])[0]
            nm = names.get(cid, [f'sound_{cid}'])
            if fmt == 2:
                fn = f'{nm[0]}.mp3'
                open(f'{out}/sounds/{fn}', 'wb').write(data[9:])  # skip SeekSamples
            else:
                fn = f'{nm[0]}.fmt{fmt}.raw'; open(f'{out}/sounds/{fn}', 'wb').write(data[7:])
            manifest['sounds'][fn] = {'id': cid, 'rate': rate, 'samples': samples, 'seconds': round(samples/rate, 2), 'stereo': bool(flags & 1), 'aliases': nm[1:]}
        elif code == 87:
            cid = struct.unpack('<H', data[:2])[0]
            nm = names.get(cid, [f'binary_{cid}'])
            os.makedirs(f'{out}/binary', exist_ok=True)
            open(f'{out}/binary/{nm[0]}.bin', 'wb').write(data[6:])
    json.dump(manifest, open(f'{out}/manifest.json', 'w'), indent=1, sort_keys=True)
    print(swf, len(manifest['images']), 'images', len(manifest['sounds']), 'sounds')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
