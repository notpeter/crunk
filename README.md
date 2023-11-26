# Crunk: Extra Libs for Playdate

## Introduction

Crunk is a collection of open source Lua and C snippets and
libraries to assist in Playdate app development.
It is designed to be simple and modular.

Just take the Lua and/or C files, drop them into your
project and away you go.

## Components:

- [crunk.qrcode](crunk/qrcode) - Fast QR Code generation
    - `crunk.qrcode.generate(text)`
    - `crunk.qrcode.generate(text, ecc_level, mask, min_version, max_version)`
- [crunk.pixel](crunk/crunk_pixel.h) -
C macros for working with individual Playdate LCDImage pixels.
- [crunk.format.image](crunk/format/image) - Convert Playdate images to text for debugging.

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

Each subdirectory includes specific copyright information
and license terms.

Most of it is MIT licensed.
