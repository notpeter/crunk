# crunk/pd_print

Part of [Crunk](https://github.com/notpeter/crunk)

C preprocessor macros enabling debug print statements

## Features

[pd_print.h](pd_print.h)

- `pd_print(fmt, ...)` - Print to console (`pd->system->logToConsole`)
- `pd_error(fmt, ...)` - Print to console in red and pause execution (`pd->system->error`)
- `pd_debug(fmt, ...)` - Print to console (like `pd_print`) but only if `#define PD_DEBUG 1` is set; otherwise a no-op.

## Usage

These macro needs a PlaydateAPI reference in the variable `pd`.

The easiest way to do this is via an `extern PlaydateAPI* pd` in any file where
these macros are used and then ensuring this global vairable is set during
initialization in your main.c. For example:

```
PlaydateAPI *pd = NULL;
int eventHandler(PlaydateAPI *playdate, PDSystemEvent event, uint32_t arg) {
    switch (event) {
        case kEventInitLua:
            pd = playdate;
            break;
    }
    return 0;
}
```

Then you can use these macros anywhere.

## License

MIT License

Copyright (c) 2023 Peter Tripp

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
