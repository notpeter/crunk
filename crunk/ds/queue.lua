-- Copyright 2023 Peter Tripp
-- https://github.com/notpeter/crunk

--[[--------------------------------------------------------------------------
crunk/ds/queue.lua: Minimal queue datastructures for in pure Lua.
license: MIT

These are simple queue data structures atop Lua tables:
    * Queue (Single Ended Queue) - FIFO queue, growable with no limit on size
    * Deque (Double Ended Queue)
    * Stack - LIFO queue

Every object is a Lua table using numeric indexes (1+) for values referenced,
    with queue state tracked a sliding window of indexes:
    * first - the index of the first element in the queue
    * last - the index of the last element in the queue
    Whenever you push an element onto the queue, `last` is incremented.
    Whenever you pop an element from the queue, `first` is incremented.
    As a result, `first`/`last` will monotonoically increase with each operation.

These structures **MAY** be used to store nil values, but some care must be
    taken in practice. Normally pop() / pop_front() / pop_back() only
    return nil when the structure is empty.  When pushing/queueing nil values
    you will need to explicitly check the length of the structure (#queue).

When these indexes overflow Queue/Deque structures always returning nil.
    On 64bit Lua this is after 2^63 operations (~9 quintillion)
    But will never happen in practice (2B ops/sec for 100 years)

    On 32bit Lua this occurs after 2^31 operations (~2 billion).
    Which is possible, but unlikely in a Playdate game (60 ops/sec for 1 year)

    If this concerns you, changes you could:
    * Add bounds check so indexes don't overflow and rebalance the table first.
    * Switch indexes from [1, math.maxinteger] to [math.mininteger + 1, math.maxinteger]
        This would support 2X queue operations before overflow, but indexes start negative.

In the future, with LuaLS generics it should be possible to provide typed datastructures
    like (e.g. Queue<string>, Queue<integer>, etc.). In the meantime, create your own
    LuaCATS typed datastructures with inheritance and changing `any` to `string`:

    ```
    ---QueueString
    ---@class _QueueString: _Queue
    ---@field enqueue       fun(self:_QueueString, val:string):integer
    ---@field dequeue       fun(self:_QueueString):string

    local q = crunk.ds.queue.new() ---@type _QueueString
    ```
--]]--------------------------------------------------------------------------

--- Abstract Base Class for Queues
---@class _ABCQueue: table<(integer|string), any>
---@field first         integer
---@field last          integer
---@field empty         fun(self:_ABCQueue):nil
---@field __len         fun(self:_ABCQueue):integer
---@field __tostring    fun(self:_ABCQueue):string

--- Queue (Single Ended Queue)
---@class _Queue: _ABCQueue
---@field new           fun():_Queue
---@field enqueue       fun(self:_Queue, val:any):integer
---@field dequeue       fun(self:_Queue):any
---@field empty         fun(self:_Queue):nil
---@field __len         fun(self:_Queue):integer
---@field __tostring    fun(self:_Queue):string
local queue_meta -- forward declaration

--- Deque (Double Ended Queue)
---@class _Deque: _ABCQueue
---@field new           fun():_Deque
---@field push_front    fun(self:_Deque, val:any):integer
---@field push_back     fun(self:_Deque, val:any):integer
---@field pop_front     fun(self:_Deque):any
---@field pop_back      fun(self:_Deque):any
---@field empty         fun(self:_Deque):nil
---@field __len         fun(self:_Deque):integer
---@field __tostring    fun(self:_Deque):string
local deque_meta -- forward declaration

--- Stack
---@class _Stack: _ABCQueue (note: .first is always 1)
---@field new           fun():_Stack
---@field push          fun(self:_Stack, val:any):integer
---@field pop           fun(self:_Stack):any
---@field empty         fun(self:_Stack):nil
---@field __len         fun(self:_Stack):integer
---@field __tostring    fun(self:_Stack):string
local stack_meta -- forward declaration

--------------------------------------------------------------------------------
-- Constructors
--------------------------------------------------------------------------------

---Creates a new Queue
---@return _Queue
local function new_queue()
    local o = { first = 1, last = 0 }
    return setmetatable(o, queue_meta)
end

---Creates a new Deque (Double Ended Queue)
---@return _Deque
local function new_deque()
    local o = { first = 1, last = 0 }
    return setmetatable(o, deque_meta)
end

--- Creates a new Stack
---@return _Stack
local function new_stack()
    local o = { first = 1, last = 0 }
    return setmetatable(o, stack_meta)
end

--------------------------------------------------------------------------------
-- Shared Metamethods
--------------------------------------------------------------------------------

---Push an element onto the front of a queue (unshift)
---@param self _ABCQueue
---@param val any
local function push_front(self, val)
    self.first = self.first - 1
    self[self.first] = val
end

---Push an element onto the back of a queue (push)
---@param self _ABCQueue
---@param val any
local function push_back(self, val)
    self.last = self.last + 1
    self[self.last] = val
end

---Pop an element from the front of a queue (shift)
---@param self _ABCQueue
---@return any? val The popped (nil if empty)
local function pop_front(self)
    if self.first > self.last then
        return nil
    end
    local val = self[self.first]
    self[self.first] = nil
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
    local val = self[self.last]
    self[self.last] = nil
    self.last = self.last - 1
    return val
end

---Empty the queue
---@param self _ABCQueue
---@return nil
local function empty(self)
    for i = self.first, self.last do
        self[i] = nil
    end
    self.first = 1
    self.last = 0
end

--- Returns the number of elements in the datastructure
---@param self _ABCQueue
---@return integer number of elements in the datastructure
local function len(self)
    return self.last - self.first + 1
end

---Returns a string representation of the queue
---@param self _ABCQueue
local function tostring(self)
    local tbl = {}
    for i = self.first, self.last do
        tbl[#tbl + 1] = tostring(self[i])
    end
    return "{" .. table.concat(tbl, ", ") .. "}"
end

queue_meta = {
    new = new_queue,
    enqueue = push_back,
    dequeue = pop_front,
    empty = empty,
    __len = len,
    __tostring = tostring,
}
queue_meta.__index = queue_meta

deque_meta = {
    new = new_deque,
    push_front = push_front,
    push_back = push_back,
    pop_front = pop_front,
    pop_back = pop_back,
    empty = empty,
    __len = len,
    __tostring = tostring,
}
deque_meta.__index = deque_meta

stack_meta = {
    new = new_stack,
    push = push_back,
    pop = pop_back,
    empty = empty,
    __len = len,
    __tostring = tostring,
}
stack_meta.__index = stack_meta

if playdate then
    crunk = crunk or {}
    crunk.ds = crunk.ds or {}
    crunk.ds.queue = queue_meta
    crunk.ds.deque = deque_meta
    crunk.ds.stack = stack_meta
end
return {
    queue = queue_meta,
    deque = deque_meta,
    stack = stack_meta,
}
