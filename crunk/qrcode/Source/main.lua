import "CoreLibs/graphics"

local qrcode_generate = crunk.qrcode.generate

local function update()
end

local function setup()
    local text = "https://news.ycombinator.com/item?id=19986106"
    local before = playdate.getCurrentTimeMilliseconds()
    local image = qrcode_generate(text)
    local after = playdate.getCurrentTimeMilliseconds() - before
    if image == nil then
        error("Failed to generate QRCode")
    end
    print("Generated QRCode in " .. after .. "ms")
    image:drawScaled(20, 20, 4, 4)
    playdate.update = update
end

setup()
