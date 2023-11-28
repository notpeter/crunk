-- Copyright 2023 Peter Tripp
-- https://github.com/notpeter/crunk
--
-- Simple sets in pure Lua for the Playdate modeled after Python's set

local set_meta -- forward declaration

---Create a new set
---@param tbl? table<any, any> Table whose keys will be used to initialize the set
---@return _Set
local function set_new(tbl)
    local set = {}
    for _, v in pairs(tbl or {}) do
        set[v] = true
    end
    return setmetatable(set, set_meta)
end

---Union of two sets
---@param a _Set
---@param b _Set
---@return _Set
local function set_union(a, b)
    local res = set_new {}
    for k in pairs(a) do
        res[k] = true
    end
    for k in pairs(b) do
        res[k] = true
    end
    return res
end

---Intersection of two sets
---@param a _Set
---@param b _Set
---@return _Set
local function set_intersection(a, b)
    local res = set_new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

---Difference of two sets
---
---Elements present on one set, but not on the other.
---@param a _Set
---@param b _Set
---@return _Set
local function set_difference(a, b)
    local res = set_new{}
    for k in pairs(a) do
        if not b[k] then
            res[k] = true
        end
    end
    return res
end

---Symmetric difference of two sets
---
---Elements from both sets, that are not present on the other.
---@param a _Set
---@param b _Set
---@return _Set
local function set_symmetric_difference(a, b)
    local res = set_new{}
    for k in pairs(a) do
        if not b[k] then
            res[k] = true
        end
    end
    for k in pairs(b) do
        if not a[k] then
            res[k] = true
        end
    end
    return res
end

---Report whether another set contains this set.
---@param a _Set
---@param b _Set
---@return boolean
local function set_issubset(a, b)
    for k in pairs(a) do
        if not b[k] then
            return false
        end
    end
    return true
end

---Report whether this set contains another set.
---@param a _Set
---@param b _Set
---@return boolean
local function set_issuperset(a, b)
    return set_issubset(b, a)
end

---Return True if two sets have a null intersection.
---@param a _Set
---@param b _Set
---@return boolean
local function set_isdisjoint(a, b)
    for k in pairs(a) do
        if b[k] then
            return false
        end
    end
    return true
end

---Update a set with the intersection of itself and another.
---
---While set.intersection(a, b) returns a new set,
---set.intersection_update(a, b) modifies a in-place.
---@param a _Set
---@param b _Set
local function set_intersection_update(a, b)
    for k in pairs(a) do
        if not b[k] then
            a[k] = nil
        end
    end
end

---Update a set with the union of itself and another.
---
---While set.union(a, b) returns a new set,
---set.union_update(a, b) modifies a in-place.
---@param a _Set
---@param b _Set
local function set_union_update(a, b)
    for k in pairs(b) do
        a[k] = true
    end
end

---Update a set with the difference of itself and another.
---
---While set.difference(a, b) returns a new set,
---set.difference_update(a, b) modifies a in-place.
---@param a _Set
---@param b _Set
local function set_difference_update(a, b)
    for k in pairs(b) do
        a[k] = nil
    end
end

---Pop an element from a set.
---@param a _Set
---@return any?
local function set_pop(a)
    local k = next(a)
    if k then
        a[k] = nil
        return k
    end
end

---Push an element to a set.
---@param a _Set
---@param e any
local function set_push(a, e)
    a[e] = true
end

---Clear the contents of a set.
---@param a _Set
local function set_clear(a)
    for k in pairs(a) do
        a[k] = nil
    end
end

local function set_equal(a, b)
    return set_issubset(a, b) and set_issubset(b, a)
end

---Create a copy of a set
---@param a _Set
---@return _Set
local function set_copy(a)
    return set_new(a)
end

---Convert a set to a string
---@param set _Set
---@return string
local function set_tostring(set)
    local tbl = {}
    for e in pairs(set) do
        tbl[#tbl + 1] = tostring(e)
    end
    return "{" .. table.concat(tbl, ", ") .. "}"
end

---@class _Set: table<any, boolean>
set_meta = {
    -- Return new sets
    new = set_new,
    union = set_union,
    intersection = set_intersection,
    difference = set_difference,
    symmetric_difference = set_symmetric_difference,
    -- Return boolean
    issubset = set_issubset,
    issuperset = set_issuperset,
    isdisjoint = set_isdisjoint,
    -- Update in place
    intersection_update = set_intersection_update,
    difference_update = set_difference_update,
    union_update = set_union_update,
    -- Convenience methods
    pop = set_pop,
    push = set_push,                    -- set[k] = true
    clear = set_clear,
    copy = set_copy,                    -- set_new(set)
    -- overload operators
    __add = set_union,                  -- a + b
    __sub = set_difference,             -- a - b
    __eq = set_equal,                   -- a == b
    -- bitwise operators
    __band = set_intersection,          -- a & b
    __bor = set_union,                  -- a | b
    __bxor = set_symmetric_difference,  -- a ~ b
    -- Note, we don't implement __gt, __lt, __le, __ge
    -- Personally I never internalized (> is strict_supersset) vs  (>= is superset)
    __tostring = set_tostring,
}
set_meta.__index = set_meta

crunk = crunk or {}
crunk.ds = crunk.ds or {}
crunk.ds.set = set_meta
