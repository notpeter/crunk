// Copyright 2023 Peter Tripp
// Copyright 2022 Dustin Mierau
// https://github.com/notpeter/crunk

#pragma once

#define TARGET_EXTENSION 1
#include "pd_api.h"

/** Converts QRCode Version (1-40) to number of modules in QR code.
 * @param v int QRCode Version (1-40)
 * @return int QRCode Modules (e.g. version 40 is 177x177)
*/
#define version_to_modules(v) (17 + v * 4)

/** Set the pixel at x, y to the specified color.
 * @param data uint8_t from PDLCDBitmap struct
 * @param x int X Position
 * @param y int Y Position
 * @param rowbytes int Rowbytes from pd->graphics->getBitmapData()
 */
#define crunk_setpixel(data, x, y, rowbytes) (data[(y)*rowbytes+(x)/8] &= ~(1 << (uint8_t)(7 - ((x) % 8))))

int qrq_lua_generate(lua_State* L);
void crunk_qrcode_register(PlaydateAPI* playdate, const char* name);
