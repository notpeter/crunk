#pragma once

// Copyright 2023 Peter Tripp (GitHub: notpeter)
// https://github.com/notpeter/crunk
// Copyright 2022 Dustin Mierau (GitHub: @mierau, Twitter: @dmierau)
// https://devforum.play.date/t/c-macros-for-working-with-playdate-bitmap-data/7706

#ifndef samplepixel
/** Determine pixel at x, y is black or white.
 * @param data uint8_t from pd->graphics->getBitmapData()
 * @param x int X Position
 * @param y int Y Position
 * @param rowbytes int Rowbytes from pd->graphics->getBitmapData()
 * @return on_off int whether the pixel is set
 */
#define samplepixel(data, x, y, rowbytes) (((data[(y)*rowbytes+(x)/8] & (1 << (uint8_t)(7 - ((x) % 8)))) != 0) ? kColorWhite : kColorBlack)
#endif

#ifndef setpixel
/** Set the pixel at x, y to black.
 * @param data uint8_t from pd->graphics->getBitmapData()
 * @param x int X Position
 * @param y int Y Position
 * @param rowbytes int Rowbytes from pd->graphics->getBitmapData()
 */
#define setpixel(data, x, y, rowbytes) (data[(y)*rowbytes+(x)/8] &= ~(1 << (uint8_t)(7 - ((x) % 8))))
#endif

#ifndef clearpixel
/** Set the pixel at x, y to white.
 * @param data uint8_t from PDLCDBitmap struct
 * @param x int X Position
 * @param y int Y Position
 * @param rowbytes int Rowbytes from pd->graphics->getBitmapData()
 */
#define clearpixel(data, x, y, rowbytes) (data[(y)*rowbytes+(x)/8] |= (1 << (uint8_t)(7 - ((x) % 8))))
#endif

#ifndef drawpixel
/** Set the pixel at x, y to the specified color.
 * @param data uint8_t from PDLCDBitmap struct
 * @param x int X Position
 * @param y int Y Position
 * @param rowbytes int Rowbytes from pd->graphics->getBitmapData()
 */
#define drawpixel(data, x, y, rowbytes, color) (((color) == kColorBlack) ? setpixel((data), (x), (y), (rowbytes)) : clearpixel((data), (x), (y), (rowbytes)))
#endif
