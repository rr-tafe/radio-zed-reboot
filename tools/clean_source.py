"""Turn FFDec's export of the 17 Sep build (radiozed.swf) into a readable source tree.

The sponsor's obfuscator renamed classes/packages to control-character identifiers
(shown by FFDec as e.g. §\\x1b\\x17§). Member names survived, so each class can be
identified from the assets it embeds and the fields it declares. This script applies
that mapping and drops the Flex/Mochi/asset-stub noise.

usage: python3 -I tools/clean_source.py extracted/radiozed/ffdec/scripts source_recovered/radiozed
"""
import os, re, sys

# Identified by hand from embedded asset classes and declared fields (see README notes).
NAMES = {
    r'\x1b\x1c': 'PlayLvl',        # playLvl_* assets, main gameplay state
    r'\x1a\x1b': 'Shop',           # Shop_* assets
    r'\x1a\x1a': 'ShopStatistics', # Shop_statistics_* assets, achievements screen
    r'\x19\x1a': 'WinScreenDialog',
    r'\x12': 'BlackScreenDialog',
    r'\x13': 'BlackScreen',        # game-over fade + fail sound
    r'\x1b\x17': 'Params',         # weapon/bot/player stats + save data
    r'\x1d\t': 'Texts',            # UI strings, achievement descriptions
    r'\x18': 'PlayerArm',          # arm_with_pistol_* weapons
    r'\x10': 'BotArm',             # bot_arm_with_gun_*
    r'\x0f': 'BotFriend',          # Bot_friend_*
    r'\x15': 'Barricade',
    r'\x1b\x14': 'Radio',
    r'\x1a\x16': 'Spawner',
    r'\x11': 'Block',
    r'\x0e': 'BulletBlock',
    r'\x04': 'Cursor',
    r'\x01': 'DoorUp',
    r'\x02': 'DoorDown',
    # Flixel 2.23 library classes that lost their names
    r'\x1c\t': 'org.flixel',
    r'\x1c\b': 'org.flixel.data',
    r'\x1e\x05': 'FlxPreloader',
    r'\x1e\r': 'FlxGame',
    r'\x1e\x07': 'FlxPause',
    r'\x1e\t': 'FlxMouse',
    r'\x1e\b': 'FlxPanel',
    r'\x1e\x12': 'FlxButton',      # (off, on) graphics + click callback
    r'\x1e\x10': 'FlxEmitter',     # setXSpeed / createSprites / start
    r'\x1e\x06': 'FlxPoint',
    r'\x1e\x03': 'FlxRect',
}

SKIP = re.compile(r'(_Img|_Snd|_embed_css|_dataClass|FlxGame_junk|FlxGame_testt|Mochi)')


def decode_fs(name):
    return name.replace('%5C', '\\')


def main(src, dst):
    # Only obfuscated identifiers; FFDec's own "§§push(...)" markers are left alone.
    tok = re.compile(r'§((?:\\x[0-9a-f]{2}|\\[a-z])+)§')
    esc = {'t': 9, 'n': 10, 'f': 12, 'r': 13, 'b': 8}

    def sub(m):
        codes = [int(c[2:], 16) if c.startswith('\\x') else esc[c[1]] for c in re.findall(r'\\x[0-9a-f]{2}|\\[a-z]', m.group(1))]
        return NAMES.get(m.group(1), 'OBF_' + ''.join(f'{c:02x}' for c in codes))

    count = 0
    for dp, dn, fn in os.walk(src):
        rel = os.path.relpath(dp, src)
        if rel.startswith('mx') or rel.startswith('com'):
            continue
        for f in fn:
            if not f.endswith('.as') or SKIP.search(f):
                continue
            text = open(os.path.join(dp, f), encoding='utf-8', errors='replace').read()
            if 'mx.core.IFlexModuleFactory' in text and 'FlxSprite' not in text and 'FlxState' not in text:
                continue  # Flex style/resource boilerplate
            out_name = tok.sub(sub, decode_fs(f[:-3])) + '.as'
            out_dir = os.path.join(dst, *[tok.sub(sub, decode_fs(p)).replace('.', os.sep) for p in rel.split(os.sep) if p != '.'])
            os.makedirs(out_dir, exist_ok=True)
            open(os.path.join(out_dir, out_name), 'w').write(tok.sub(sub, text))
            count += 1
    print(count, 'files written to', dst)


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
