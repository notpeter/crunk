# crunk.image.format

Part of [Crunk](https://github.com/notpeter/crunk).

## crunk.image.format

See [image.lua](image.lua)

Take a playdate.graphics.image and convert it to text. Useful for debugging.

```lua
local text = crunk.image.format_blocks(img)
print(text)

text = crunk.image.format_ascii(img)
text = crunk.image.format_color(img)
text = crunk.image.format_blocks(img)
--- etc
```

## Usage

Copy `crunk_image_format.lua` into your project and then in your `main.lua` add:
```lua
import "crunk_image_format"
```

## Screenshots

![image_screenshot1.png](image_screenshot1.png)
![image_screenshot2.png](image_screenshot2.png)
![image_screenshot3.png](image_screenshot3.png)

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
