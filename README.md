# Crunk: Extra Libs for Playdate

## Introduction

Crunk is a collection of open source Lua and C snippets and
libraries to assist in Playdate app development.
It is designed to be simple and modular.

Just take the Lua and/or C files, drop them into your
project and away you go. If you only need one function
just copy/paste and away you go
(but don't forget to retain the Copyright and License).

## Components:

Mixed C/Lua:
- [crunk/qrcode](crunk/qrcode) - Fast QR Code generation
    - `crunk.qrcode.generate(text)`
    - `crunk.qrcode.generate(text, ecc_level, mask, min_version, max_version)`

Pure Lua:
- [crunk/image_format](crunk/image_format) - Convert Playdate images to text for debugging.
    - `crunk.image.format_ascii`
    - `crunk.image.format_color`
    - `crunk.image.format_blocks`
- [crunk/ds/queue](crunk/ds/queue) - Simple queue-like data structures for Lua
    - `crunk.ds.queue` - Queue
    - `crunk.ds.deque` - Deque (Double Ended Queue)
    - `crunk.ds.stack` - Stack
    - `crunk.ds.circular` - Circular Queue
- [crunk/ds/set](crunk/ds/set) - Simple set data structure for Lua
    - `crunk.ds.set` -

Pure C:
- [crunk/pixel](crunk/pd_pixel/pd_pixel.h) -
C macros for working with individual Playdate LCDImage pixels.
- [crunk/print](crunk/print) -
C macros for printing and logging to console (pd_print, pd_error, pd_debug)

## Giving Thanks

If you find this software useful, please consider:

1. [Sponsoring me on GitHub](https://github.com/sponsors/notpeter/)
2. [Purchasing something from my Itch Store](https://notpeter.itch.io)
3. Sending me free copies of your Playdate apps using Crunk.

## Types

Wherever possible we include LuaCATS types for use with the
Lua Language Server so VSCode/NeoVim get offer autocompletion
and static analysis.

Please configure [playdate-luacats](https://github.com/notpeter/playdate-luacats)
for the best experience with this.

To get LuaCATS type hints for functions with C implementations
(e.g. `crunk.qrcode`) just create a `library` subdirectory in your
project and drop [`library/stub.lua`](library/stub.lua) inside it.

Then add a `.luarc.json` in your project containing:
```json
{ "workspace.library": [ "library/" ] }
```

Or do the same via `.vscode/settings.json`
```json
{ "Lua.workspace.library": [ "library/" ] }
```

## License

MIT License

Copyright 2023 Peter Tripp

See [LICENSE](LICENSE) for full terms.

## 3rd Party Licenses

- [qrcodegen](crunk/qrcode/LICENSE) (MIT) - Copyright Project Nayuki
- [pd_pixel.h](crunk/pd_pixel/pd_pixel.h) (Unknown) - Copyright Dustin Mierau
