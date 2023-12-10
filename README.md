# Crunk: Missing Libs for Lua and Playdate

## Introduction

Crunk is a collection of open source Lua and C snippets and
libraries to assist in Lua app/game development for Playdate.

The code is designed to be simple, modular and permissively licensed.
This means you if you want a `Set` data structure you can
just copy [`set.lua`](crunk/ds/set.lua) into your project,
`import "set.lua"` (PlayDate Lua) or `Set = require "set.lua"` (Lua)
and away you go.

Where possibel, each Lua file stands alone. In order to support both
PUC-Lua and Playdate-Lua our Lua files support both
`require` and `import` mechanisms but use neither themselves.

## Components:

Mixed C/Lua:
- [crunk/qrcode](crunk/qrcode) - Fast QR Code generation (70x faster than PlayDate SDK)
    - `crunk.qrcode.generate(text)`
    - `crunk.qrcode.generate(text, ecc_level, mask, min_version, max_version)`

Pure Lua:
- [crunk/image_format](crunk/image_format) - Convert Playdate images to text for debugging.
    - `crunk.image.format_ascii`
    - `crunk.image.format_color`
    - `crunk.image.format_blocks`
- [crunk/ds](crunk/ds) - Simple queue-like data structures for Lua
    - `crunk.ds.queue` - Queue
    - `crunk.ds.deque` - Deque (Double Ended Queue)
    - `crunk.ds.stack` - Stack
    - `crunk.ds.set` - Set
- [crunk/math](crunk/math) - Math Helper functions

Pure C:
- [crunk/pd_pixel](crunk/pd_pixel/pd_pixel.h) -
C macros for working with individual Playdate LCDImage pixels.
- [crunk/pd_print](crunk/pd_print) -
C macros for printing and logging to console (pd_print, pd_error, pd_debug)

## Types

Wherever possible we include LuaCATS types for use with the
Lua Language Server so VSCode/NeoVim get offer autocompletion
and static analysis.

Please configure [playdate-luacats](https://github.com/notpeter/playdate-luacats)
for the best experience with this.

## Giving Thanks

If you find this software useful, please consider:

1. [Sponsoring me on GitHub](https://github.com/sponsors/notpeter/)
2. [Purchasing something from my Itch Store](https://notpeter.itch.io)
3. Sending me free copies of your Playdate apps using Crunk.

## License

MIT License

Copyright 2023 Peter Tripp

See [LICENSE](LICENSE) for full terms.

## 3rd Party Licenses

- [qrcodegen](crunk/qrcode/LICENSE) (MIT) - Copyright Project Nayuki
- [pd_pixel.h](crunk/pd_pixel/pd_pixel.h) (Unknown) - Copyright Dustin Mierau
