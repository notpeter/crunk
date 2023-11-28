--- Copyright 2023 Peter Tripp
--- https://github.com/notpeter/crunk

local color_black <const> = playdate.graphics.kColorBlack
local color_white <const> = playdate.graphics.kColorWhite
local color_clear <const> = playdate.graphics.kColorClear

---Convert an image to a string of characters (1:1 pixels)
---@param img _Image
---@param on string Character to use for black pixels
---@param off string Character to use for white pixels
---@param other string Character to use for other pixels (transparent)
---@param newline string Character to use for newlines
---@return string
local function image_str(img, on, off, other, newline)
    local out = {}
    local w, h = img:getSize()
    local sample = img.sample
    for y = 0,h-1 do
        local s = {}
        for x = 0,w-1 do
            local p = sample(img, x,y)
            if p == color_black then
                s[#s+1] = on
            elseif p == color_white then
                s[#s+1] = off
            else
                s[#s+1] = other
            end
        end
        out[#out+1] = table.concat(s)
    end
    return table.concat(out, newline)
end

--- Takes a playdate image and returns a unicode multiline string for printing.
---
--- Defaults to image_color(img, "⬛", "⬜", "🟨", "\n")
---
--- Works well with: ⬛⬜🟨🟧🟥🟩🟦🟪🟫
---@param img _Image
---@param on? string Character to use for black pixels
---@param off? string Character to use for white pixels
---@param other? string Character to use for other pixels (transparent)
---@param newline? string Character to use for newlines
---@return string
local function image_color(img, on, off, other, newline)
    on = on or "⬛"
    off = off or "🟨"
    other = other or "⬜"
    newline = newline or "\n"
    return image_str(img, on, off, other, newline)
end

--- Takes a playdate image and returns an ascii multiline string for printing.
---@param on? string Character to use for black pixels
---@param off? string Character to use for white pixels
---@param other? string Character to use for other pixels (transparent)
---@param newline? string Character to use for newlines
---@return string
local function image_ascii(img, on, off, other, newline)
    on = on or "X"
    off = off or " "
    other = other or "*"
    newline = newline or "\n"
    return image_str(img, on, off, other, newline)
end

--- Takes a playdate image and returns a string with unicode block characters for printing.
---
--- The reduces the image to 1/4th the size.
--- Each 2x2 pixel square becomes a single unicode block character.
---@param img _Image
---@return string multiline_string of unicode block characters for the image
local function image_blocks(img)
    local black <const> = playdate.graphics.kColorBlack
    local map = {
        ["X   "] = "▘", [" X  "] = "▝", ["  X "] = "▖", ["   X"] = "▗",
        ["XX  "] = "▀", [" X X"] = "▐", ["  XX"] = "▄", ["X X "] = "▌",
        ["    "] = " ", ["XXXX"] = "█", ["X  X"] = "▚", [" XX "] = "▞",
        ["XXX "] = "▛", ["XX X"] = "▜", ["X XX"] = "▙", [" XXX"] = "▟",
    }
    local out = {}
    local w, h = img:getSize()
    local sample = img.sample
    for y = 0,h-1,2 do
        local l = {}
        for x = 0,w-1,2 do
            local s = table.concat({
                sample(img, x,y)     == color_black and "X" or " ",
                sample(img, x+1,y)   == color_black and "X" or " ",
                sample(img, x,y+1)   == color_black and "X" or " ",
                sample(img, x+1,y+1) == color_black and "X" or " ",
            })
            l[#l+1] = map[s]
        end
        out[#out+1] = table.concat(l)
    end
    return table.concat(out, "\n")
end

if playdate then
    crunk = crunk or {}
    crunk.image = crunk.image or {}
    crunk.image.format_ascii = image_ascii
    crunk.image.format_color = image_color
    crunk.image.format_blocks = image_blocks
end
return {
    ascii = image_ascii,
    color = image_color,
    blocks = image_blocks,
}
