# crunk-qrcode

> QRCode for Playdate (C accelerated)

This library is part of the Crunk Playdate project: [notpeter/crunk](http://github.com/notpeter/crunk).

It provides Lua API and a C for Playdate Games to rapidly generate QRCode images.

## Why?

The QRCode library [included in the PlaydateSDK](https://github.com/notpeter/playdate-luaqrcode)
is a fork [speedata/luaqrcode](https://github.com/speedata/luaqrcode) and
is written in Pure Lua. Which is super cool, but also super slow.

This library includes a copy of qrcodegen.c from
[nayuki/QR-Code-generator](https://github.com/nayuki/QR-Code-generator/tree/master/c)
and is written in C.

## Benchmarks

The Lua QRCode implementation is so slow that Panic had to
[patch qrencode.lua](https://github.com/notpeter/playdate-luaqrcode/commit/ecfb836fe7718773c4c5aa2633511b69d228ad97)
with `coroutine.yield()` and create a wrapper with callbacks so
it could be used async so your game didn't hang for a few seconds
whenever you needed a QRCode.

In practice this means that even the smallest QRCodes (e.g. "https://play.date/" 16 characters)
took longer than a second for luaqrcode to generate.

The C implementation is faster. Much faster:

Length | Lua     | C     |   Speedup
------ | --------| ------| ---------
16     | 1050ms  | 7ms   | 150x
100    | 2267ms  | 21ms  | 100x
254    | 3934ms  | 46ms  | 85x
1323   | 16114ms | 214ms | 75x

## License

Copyright (c) Peter Tripp

The crunk-qrcode project and qrencode.c are available under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
