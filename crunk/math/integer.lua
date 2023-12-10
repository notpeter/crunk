-- Copyright 2023 Peter Tripp
-- https://github.com/notpeter/crunk

---Returns the sign of a number (-1, 0, or 1)
---@param v integer|number
---@return integer
local math_sign = function(v)
    return (v > 0 and 1) or (v == 0 and 0) or -1
end

---Returns true if the number is negative
---@param v integer|number
---@return boolean
local math_negative = function(v)
    return v < 0
end

---Returns true if the number is non-negative
---@param v integer|number
---@return boolean
local math_nonnegative = function (v)
    return v >= 0
end

---Returns true if the number is positive
---@param v integer|number
---@return boolean
local math_positive = function(v)
    return v > 0
end

---Returns true if the number is natural (positive and non-zero)
---@param v integer|number
---@return boolean
local math_natural = function(v)
    return v > 0
end

if playdate then
    crunk = crunk or {}
    crunk.math = crunk.math or {}
    crunk.math.sign = math_sign
    crunk.math.negative = math_negative
    crunk.math.nonnegative = math_nonnegative
    crunk.math.positive = math_positive
    crunk.math.natural = math_natural
end
return {
    sign = math_sign,
    negative = math_negative,
    nonnegative = math_nonnegative,
    positive = math_positive,
    natural = math_natural,
}
