---@meta
--- Copyright 2023 Peter Tripp
--- This is a stub containing LuaCATS Annotations
--- for use with the Lua Language Server and Lua VSCode Extensions.
--- It should be placed outside your project's Source directory.

--- Crunk: Useful utilities for Playdate development
---@class crunk
crunk = crunk or {}

--- Crunk QRCodes: Generate QR Codes with qrcodegen (C accelerated)
---@class crunk.qrcode
crunk.qrcode = crunk.qrcode or {}

---Quickly Create a QRCode
---@param text string
---@param border? integer Border size. Standard requires white-out border of >=4 modules (default: 4)
---@param ecc_level? integer Error correcting duplication. -1: auto; 0: 7%, 1: 15%, 2: 25%, 3: 30%
---@param mask? integer Mask pattern. -1: auto; 0-7: fixed
---@param min_version? integer Minimum QRCode version (size). 1-40 (default: 1)
---@param max_version? integer Maximum QRCode version (size). 1-40 (default: 40)
---@return _Image? image The generated QRCode as an image (playdate.graphics.image)
function crunk.qrcode.generate(text, border, ecc_level, mask, min_version, max_version) end
