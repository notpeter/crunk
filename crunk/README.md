# crunk

[Crunk: Missing Libs for Lua and Playdate](https://github.com/notpeter/crunk)

## API:

- [crunk.qrcode](qrcode): Generate QRCodes Quickly (Lua Interface, C + PlaydateSDK)
    - crunk.qrcode.generate

- [crunk.ds](ds): Data structures (Pure Lua)
    - crunk.ds.queue
    - crunk.ds.deque
    - crunk.ds.stack
    - crunk.ds.set
- [crunk.image.format](image_format): Debug Print Playdate images (Lua + PlaydateSDK)
    - crunk.image.ascii
    - crunk.image.color
    - crunk.image.blocks
- [crunk.math](math): Math helper functions
    - crunk.math.sign
    - crunk.math.negative
    - crunk.math.nonnegative
    - crunk.math.natural

- [pd_pixel](pd_pixel): C Macros for Playdate Images (C + PlaydateSDK)
    - samplepixel
    - setpixel
    - clearpixel
    - drawpixel
- [pd_print](pd_print): C Macros for Playdate Debug Printing (C + PlaydateSDK)
    - pd_print
    - pd_error
    - pd_debug
