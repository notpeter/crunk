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

```lua
import "queue"

q = crunk.ds.deque.new()
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

(Don't forget to preserve the copyright notice and license)

## Why?

I created these datastructures because I needed them.  Lua
doesn't include them out of the box because they can be easily
implemented on top of Lua tables so this is what I did.

## Types

These files include
[LuaCATS (**L**ua **C**omments **A**nd **T**ype **S**ystem) types](https://luals.github.io/wiki/annotations/)
as comments.  If you are using the [sumneko.lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua)
VSCode extension or [NeoVim with LuaLS](https://luals.github.io/#neovim-install)
you will get type-checking and autocomplete suggestions.

We provide the following types: `_Queue`, `_Deque`, `_Stack` and `_Set`.

These are implemented generically such that the values in each can be of any Lua type (`any`).
You can also extend these to support more strictly typed datastructures. For example if you know
your Queue will only be storing strings (and want LuaLS to warn/error otherwise) just
create a new class that inherits from _Queue and replaces all the `any` with `string`.

For example:

```lua
---@class _QueueString: _Queue
---@field enqueue fun(self:_QueueString, val:string):integer
---@field dequeue fun(self:_QueueString):string

local qs = crunk.ds.queue.new()  ---@type QueueString

qs:enqueue(1) -- Warning: "Lua Diagnostics.(param-type-mismatch)"
```

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
