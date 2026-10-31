"""Cut a region from an original game PNG, scale it up with hard pixel edges and put it on
white, to use as a style reference for image models.

usage: python3 -I tools/art_reference.py <src.png> <x> <y> <w> <h> <scale> <out.png>

Works on the PNGs written by tools/extract_assets.py (8-bit RGBA, filter type 0).
"""
import struct, sys, zlib


def read_png(path):
    d = open(path, 'rb').read()
    pos, idat = 8, b''
    while pos < len(d):
        n = struct.unpack('>I', d[pos:pos + 4])[0]
        kind, chunk = d[pos + 4:pos + 8], d[pos + 8:pos + 8 + n]
        if kind == b'IHDR':
            w, h, depth, ctype = struct.unpack('>IIBB', chunk[:10])
            assert depth == 8 and ctype == 6, 'expects 8-bit RGBA'
        elif kind == b'IDAT':
            idat += chunk
        pos += 12 + n
    raw = zlib.decompress(idat)
    stride = w * 4
    rows = []
    for y in range(h):
        line = raw[y * (stride + 1):(y + 1) * (stride + 1)]
        assert line[0] == 0, 'expects unfiltered rows'
        rows.append(line[1:])
    return w, h, rows


def write_png(path, w, h, rgb_rows):
    def chunk(kind, data):
        c = kind + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
    raw = b''.join(b'\0' + r for r in rgb_rows)
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0))
                           + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))


def main(src, x, y, w, h, scale, out):
    _, _, rows = read_png(src)
    pad = 8 * scale
    W, H = w * scale + pad * 2, h * scale + pad * 2
    white = bytes([255, 255, 255])
    out_rows = []
    for oy in range(H):
        sy = (oy - pad) // scale
        line = bytearray()
        for ox in range(W):
            sx = (ox - pad) // scale
            if 0 <= sx < w and 0 <= sy < h:
                r, g, b, a = rows[y + sy][(x + sx) * 4:(x + sx) * 4 + 4]
                # Composite over white.
                line += bytes(((r * a + 255 * (255 - a)) // 255, (g * a + 255 * (255 - a)) // 255, (b * a + 255 * (255 - a)) // 255))
            else:
                line += white
        out_rows.append(bytes(line))
    write_png(out, W, H, out_rows)
    print(f'{out}: {W}x{H}')


if __name__ == '__main__':
    a = sys.argv[1:]
    main(a[0], int(a[1]), int(a[2]), int(a[3]), int(a[4]), int(a[5]), a[6])
