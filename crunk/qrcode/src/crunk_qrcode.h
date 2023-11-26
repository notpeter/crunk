// Copyright 2023 Peter Tripp

#pragma once

#define TARGET_EXTENSION 1
#include "pd_api.h"

#ifndef CRUNK_DEBUG
#define CRUNK_DEBUG 0
#endif

// Converts QRCode Version (1-40) to Modules (e.g. version 40 is 177x177)

/** Converts QRCode Version (1-40) to number of modules in QR code.
 * @param v int QRCode Version (1-40)
 * @return int QRCode Modules (e.g. version 40 is 177x177)
*/
#define version_to_modules(v) (17 + v * 4)

/** Log to console if CRUNK_DEBUG is set.
 * @param fmt const char* Format string
 * @param ... Arguments
 */
#define crunk_debug(fmt, ...) do { if (CRUNK_DEBUG) pd->system->logToConsole(fmt, __VA_ARGS__); } while (0)

/** Set the pixel at x, y to the specified color.
 * @param data uint8_t from PDLCDBitmap struct
 * @param x int X Position
 * @param y int Y Position
 * @param rowbytes int Rowbytes from pd->graphics->getBitmapData()
 */
#define crunk_setpixel(data, x, y, rowbytes) (data[(y)*rowbytes+(x)/8] &= ~(1 << (uint8_t)(7 - ((x) % 8))))

int qrq_lua_generate(lua_State* L);
void crunk_qrcode_register(PlaydateAPI* playdate, const char* name);
