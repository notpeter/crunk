//  crunk_qrcode.h
//
//  Copyright (c) Peter Tripp 2023, All rights reserved.

#pragma once

#define DEBUG 0
#define debug(fmt, ...) do { if (DEBUG) pd->system->logToConsole(fmt, __VA_ARGS__); } while (0)

#define TARGET_EXTENSION 1
#include "pd_api.h"
#include "qrcodegen.h"

#define QRQ_LUA_NAME "crunk.qrcode"

// Converts QRCode Version (1-40) to Modules (21x21 - 177x177)
#define version_to_modules(v) (17 + v * 4)

typedef uint8_t qrcode_buf[qrcodegen_BUFFER_LEN_MAX];

static bool qrq_generate(char* text, uint8_t qrcode[]);

int qrq_generate_image(PlaydateAPI* pd, char *text, LCDBitmap **bitmap);
void registerQRQ(PlaydateAPI* playdate, const char* name);
void logQr(PlaydateAPI* pd, const uint8_t qrcode[]);
