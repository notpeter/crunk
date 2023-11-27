# crunk-ds

Part of [Crunk](https://github.com/notpeter/crunk)

## Simple Datastructures

[queue.lua](queue.lua)
- crunk.ds.queue() Queue datastructure (insert, delete, empty, len)
- crunk.ds.deque() Deque datastructure (push_front, push_back, pop_front, pop_back, empty, len)
- crunk.ds.stack() Stack datastructure (push, pop, empty, len)
- crunk.ds.circular(size) Circular queue of a fixed size (push, pop)

[set.lua](set.lua)
- crunk.ds.set.new() Set datastructure
(push, pop, clear, copy, union, intersection, difference, symmetric_difference,
issubset, issuperset, isdisjoint, intersection_update, difference_update, union_update
and various operators: `+`, `-`, `==`, `&`, `|`, `~`)

## Usage

Copy the file you need into your project, import and use:


If you only need one of the datastructures,
you can easily delete everything you don't need or just
paste what you need into your own project.
Please remember to preserve the copyright notice and license.

Example usage:
```lua
import "queue"

q = crunk.ds.deque()
q:push_front("A")
q:push_front("B")
q:push_back("C")

for k,v in pairs(q.data) do print(k, v) end
--  1	C
--  0	A
--  -1	B
while q:len() > 0 do
    print(q:pop_back())  -- "C"
    print(q:pop_front()) -- "B"
    print(q:pop_front()) -- "A"
end
```

## Why?

I created these datastructures because I needed them.  Lua
doesn't include them out of the box because they can be easily
implemented on top of Lua tables so this is what I did.

I chose to implement these structures without metatables as
an academic exercise.  I find that novice Lua programmers are
very likely to be confused `__index` and `setmetatable()`.

When teaching / learning Lua which of these would you prefer:

```lua
local stack_mt = {}
stack_mt.__index = stack_mt
function new_stack()
    return setmetatable({
        first = 1,
        last = 0,
        data = {},
        push = push_back,
        pop = pop_back,
        empty = empty,
        len = len,
    }, stack_mt)
end
```

```lua
function new_stack()
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
```

Speed is effectively identical between the two,
while the metatable version uses less memory with >2 objects.

## Giving Thanks

If you find this software useful, please consider:

1. [Sponsoring me on GitHub](https://github.com/sponsors/notpeter/)
2. [Purchasing something from my Itch Store](https://notpeter.itch.io)
3. Sending me free copies of your Playdate apps and games.

## License

```
MIT License

Copyright (c) 2023 Peter Tripp
Copyright (c) Project Nayuki

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
