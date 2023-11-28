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
    -- image:drawScaled(20, 20, 4, 4)

    local image2 = crunk.qrcode.generate("https://panic.com", 0, 3, nil, 9, 9)
    if image2 == nil then
        error("Failed to generate QRCode")
    end
    image2:drawScaled(0, 0, 4, 4)
    local size = image2.width
    playdate.graphics.fillRect(0 + size * 1.3, 0 + size * 1.3, size * 1.4, size * 1.4)

    playdate.update = update
end

setup()
