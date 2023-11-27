-- Copyright 2023 Peter Tripp
-- https://github.com/notpeter/crunk

--[[--------------------------------------------------------------------------
crunk/ds/queue.lua: Minimal queue datastructures for in pure Lua.
license: MIT

These are simple queue data structures atop Lua tables.
They are intentionally lightweight with minimal complexity OOP objects.

Every object is a Lua table (no metatables) using numeric indexes (1+) for
    values referenced, three or four integers (first, last, data, [size])
    necessary for implementing the data structure and a few function references
    which take the instance as the first argument for the functional interface.

The Queue/Deque structures will cease operation (always returning nil) if the indexes
    overflow.  On 64bit Lua this is after at least 2^63 operations (~9 quintillion)
    while on 32bit Lua this occurs after at least 2^31 operations (~2 billion).
    Stack, and CircularQueue do not have this limitation.
    This saves us a bounds check on every operation at the expense of breaking
    if you use the datastructure for a really long time. On 64bit you will never
    reach this, and on 32bit it's extremely unlikely (60 ops/sec for a year).

These structures **MAY** be used to store nil values, but it is generally poor
    practice to do so since behavior changes when nil values are stored:
    1. Normally pop() / pop_front() / pop_back() only return nil if called
        on an empty structure, but they will return nil if nil was stored.
    2. circular.len() returns the count of non-nil members, not the
        number of members in the table.

The implementation could be altered if your use-cases has different tradeoffs:
    * Use metatable for functioon references shared across all instances.
      Lower memory usage with large number of queues (slower calls)
    * Create one-off functional closures memoizing the instance specific self reference.
      More memory overhead per-queue (faster calls)
    * Add explicit bounds check on push so indexes don't overflow and a bad-case to rebuild
      the table before the indexes overflow. (slower calls, no overflow)
    * Switch indexes from [1, math.maxinteger] to [math.mininteger + 1, math.maxinteger]
      Support 2X queue operations before overflow, but indexes start negative.
      (no performance impact, triviall worse ergonomics)

In the future, when LuaLS generics are available we should be able to provide
    generically typed datastructures (e.g. Queue<string>, Queue<integer>, etc.)
    For now if you want this, duplicate this file and replace `any` with the
    types you're using.

--]]--------------------------------------------------------------------------

--- Abstract Base Class for Queues
---@class _ABCQueue
---@field first         integer
---@field last          integer
---@field data          table<integer, any>
---@field empty         fun(self:_ABCQueue):nil

--- Queue (Single Ended Queue)
---@class _Queue: _ABCQueue
---@field enqueue       fun(self:_Queue, val:any):integer
---@field dequeue       fun(self:_Queue):any
---@field len           fun(self:_Queue):integer

--- Deque (Double Ended Queue)
---@class _Deque: _ABCQueue
---@field push_front    fun(self:_Deque, val:any):integer
---@field push_back     fun(self:_Deque, val:any):integer
---@field pop_front     fun(self:_Deque):any
---@field pop_back      fun(self:_Deque):any
---@field len           fun(self:_Deque):integer

--- Stack
---@class _Stack: _ABCQueue (note: .first is always 1)
---@field push          fun(self:_Stack, val:any):integer
---@field pop           fun(self:_Stack):any
---@field len           fun(self:_Stack):integer

--- Circular Queue
---@class _CircularQueue: _ABCQueue
---@field size          integer
---@field data          table
---@field push          fun(self:_CircularQueue, val:any):integer
---@field pop           fun(self:_CircularQueue):any


---Push an element onto the front of a queue (unshift)
---@param self _ABCQueue
---@param val any
local function push_front(self, val)
    self.first = self.first - 1
    self.data[self.first] = val
end

---Push an element onto the back of a queue (push)
---@param self _ABCQueue
---@param val any
local function push_back(self, val)
    self.last = self.last + 1
    self.data[self.last] = val
end

---Pop an element from the front of a queue (shift)
---@param self _ABCQueue
---@return any? val The popped (nil if empty)
local function pop_front(self)
    if self.first > self.last then
        return nil
    end
    local val = self.data[self.first]
    self.data[self.first] = nil
    self.first = self.first + 1
    return val
end

---Pop and element from the back of the queue (pop)
---@param self any
---@return any? val The popped (nil if empty)
local function pop_back(self)
    if self.first > self.last then
        return nil
    end
    local val = self.data[self.last]
    self.data[self.last] = nil
    self.last = self.last - 1
    return val
end

---Empty the queue
---@param self any
---@return nil
local function empty(self)
    self.first = 1
    self.last = 0
    self.data = {}
end

--- Returns the number of elements in the datastructure
---@param self _ABCQueue
---@return integer number of elements in the datastructure
local function len(self)
    return self.last - self.first + 1
end

--- Returns the number of non-nil elements in the datastructure
---@param self _ABCQueue
---@return integer number of non-nil elements in the datastructure
local function len_circular(self)
    return #self.data
end

--- Push a value into the Circular Buffer
---@param self _CircularQueue
---@param val any
---@return integer idx The index of the pushed value
local function circular_push(self, val)
    local idx = self.last
    self.data[idx] = val
    self.last = (idx % self.size) + 1
    return idx
end

--- Pop a value from the Circular Buffer
---@param self _CircularQueue
---@return any? val The popped (nil if empty)
local function circular_pop(self)
    local idx = self.first
    local val = self.data[idx]
    self.data[idx] = nil
    self.first = (idx % self.size) + 1
    return val
end

---Creates a new Queue
---@return _Queue
local function new_queue()
    return {
        first = 1,
        last = 0,
        data = {},
        insert = push_back,
        delete = pop_front,
        empty = empty,
        len = len,
    }
end

---Creates a new Deque (Double Ended Queue)
---@return _Deque
local function new_deque()
    return {
        first = 1,
        last = 0,
        data = {},
        push_front = push_front,
        push_back = push_back,
        pop_front = pop_front,
        pop_back = pop_back,
        empty = empty,
        len = len,
    }
end

--- Creates a new Stack
---@return _Stack
local function new_stack()
    return {
        first = 1,
        last = 0,
        data = {},
        push = push_back,
        pop = pop_back,
        empty = empty,
        len = len,
    }
end

--- Creae a new Circular buffer
---@param size integer How many entries in the table
---@return _CircularQueue
local function new_circular(size)
    return {
        size = size,
        first = 1,
        last = 1,
        data = {},
        -- data = table.create(size, 0),
        push = circular_push,
        pop = circular_pop,
        len = len_circular,
    }
end

crunk = crunk or {}
crunk.ds = crunk.ds or {}
crunk.ds.queue = new_queue
crunk.ds.deque = new_deque
crunk.ds.stack = new_stack
crunk.ds.circular = new_circular
