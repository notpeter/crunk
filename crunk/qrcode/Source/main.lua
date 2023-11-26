-- Copyright 2023 Peter Tripp
-- https://github.com/notpeter/crunk

import "CoreLibs/graphics"

local function update()
end

local function setup()
    local text = "https://news.ycombinator.com/item?id=19986106"
    local before = playdate.getCurrentTimeMilliseconds()
    local image = crunk.qrcode.generate(text)
    local elapsed = playdate.getCurrentTimeMilliseconds() - before
    if image == nil then
        error("Failed to generate QRCode")
    end
    print("Generated QRCode in " .. elapsed .. "ms")
    image:drawScaled(20, 20, 4, 4)
    playdate.update = update
end

setup()
