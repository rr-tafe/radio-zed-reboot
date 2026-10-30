import sys, struct, zlib, collections

NAMES = {0:'End',1:'ShowFrame',2:'DefineShape',4:'PlaceObject',5:'RemoveObject',6:'DefineBits',7:'DefineButton',8:'JPEGTables',9:'SetBackgroundColor',10:'DefineFont',11:'DefineText',12:'DoAction',13:'DefineFontInfo',14:'DefineSound',15:'StartSound',18:'SoundStreamHead',19:'SoundStreamBlock',20:'DefineBitsLossless',21:'DefineBitsJPEG2',22:'DefineShape2',24:'Protect',26:'PlaceObject2',28:'RemoveObject2',32:'DefineShape3',33:'DefineText2',34:'DefineButton2',35:'DefineBitsJPEG3',36:'DefineBitsLossless2',37:'DefineEditText',39:'DefineSprite',43:'FrameLabel',45:'SoundStreamHead2',46:'DefineMorphShape',48:'DefineFont2',56:'ExportAssets',57:'ImportAssets',58:'EnableDebugger',59:'DoInitAction',60:'DefineVideoStream',61:'VideoFrame',62:'DefineFontInfo2',64:'EnableDebugger2',65:'ScriptLimits',66:'SetTabIndex',69:'FileAttributes',70:'PlaceObject3',71:'ImportAssets2',73:'DefineFontAlignZones',74:'CSMTextSettings',75:'DefineFont3',76:'SymbolClass',77:'Metadata',78:'DefineScalingGrid',82:'DoABC',83:'DefineShape4',84:'DefineMorphShape2',86:'DefineSceneAndFrameLabelData',87:'DefineBinaryData',88:'DefineFontName',89:'StartSound2',90:'DefineBitsJPEG4',91:'DefineFont4',41:'ProductInfo',255:'?'}

def parse(path, verbose=False):
    d = open(path,'rb').read()
    sig, ver, length = d[:3], d[3], struct.unpack('<I', d[4:8])[0]
    body = d[8:]
    if sig == b'CWS': body = zlib.decompress(body)
    nbits = body[0] >> 3
    rbytes = (5 + 4*nbits + 7)//8
    # rect
    bits = int.from_bytes(body[:rbytes],'big')
    tot = rbytes*8
    vals=[]
    for i in range(4):
        vals.append((bits >> (tot-5-(i+1)*nbits)) & ((1<<nbits)-1))
    rate = body[rbytes+1] + body[rbytes]/256
    frames = struct.unpack('<H', body[rbytes+2:rbytes+4])[0]
    print(f'{path}: sig={sig} ver={ver} len={length} stage={vals[1]/20}x{vals[3]/20} fps={rate} frames={frames}')
    pos = rbytes+4
    counts = collections.Counter(); sizes = collections.Counter()
    tags=[]
    while pos < len(body):
        h = struct.unpack('<H', body[pos:pos+2])[0]; pos+=2
        code, l = h>>6, h & 0x3f
        if l == 0x3f: l = struct.unpack('<I', body[pos:pos+4])[0]; pos+=4
        counts[code]+=1; sizes[code]+=l
        tags.append((code, body[pos:pos+l]))
        pos += l
        if code == 0: break
    for c,n in sorted(counts.items(), key=lambda x:-sizes[x[0]]):
        print(f'  {NAMES.get(c,c):28s} n={n:5d} bytes={sizes[c]}')
    return tags

if __name__ == '__main__':
    for p in sys.argv[1:]:
        tags = parse(p)
        for code, data in tags:
            if code == 69: print('  FileAttributes flags', bin(data[0]))
            if code == 77: print('  Metadata', data[:600])
            if code == 82:
                flags = struct.unpack('<I', data[:4])[0]; name = data[4:data.index(0,4)]
                print('  DoABC', name, len(data))
            if code == 76:
                n = struct.unpack('<H', data[:2])[0]; p2=2; out=[]
                for i in range(n):
                    cid = struct.unpack('<H', data[p2:p2+2])[0]; p2+=2
                    e = data.index(0,p2); out.append((cid, data[p2:e].decode('latin1'))); p2=e+1
                print('  SymbolClass', len(out), out[:400])
            if code == 43: print('  FrameLabel', data.rstrip(b'\0'))
        print()
