// Copyright 2023 Peter Tripp (GitHub: @notpeter)
// https://github.com/notpeter/crunk

#include "crunk_qrcode.h"
#include "qrcodegen.h"

/* Statically allocated buffers; qrcodegen is no longer thread safe.
 * Could be made smaller with qrcodegen_BUFFER_LEN_FOR_VERSION(n)
   currently size=40 (max 177x177 pixels);
   consider  size=24 (max 111x111 pixels) - 119x119 Bitmap including border.
*/

// Statically allocated temporary buffer and output buffer (3918 bytes each)
static uint8_t tempBuffer[qrcodegen_BUFFER_LEN_MAX];
static uint8_t outBuffer[qrcodegen_BUFFER_LEN_MAX];

// Global reference to PlaydateAPI. Set by crunk_qrcode_register().
static PlaydateAPI* pd = NULL;

/** Check the arguments for qrq.generate()
 * @param text char* Text to encode
 * @param ecl int Error Correction Level (0-3)
 * @param mask int Mask (0-7) or -1 for auto
 * @param minVersion int Minimum QR Code Version (1-40)
 * @param maxVersion int Maximum QR Code Version (1-40)
 * @param boostEcl int Boost Error Correction Level (0-1)
 * @return err char* Error message or empty string
 */
static char* check_new_args(const char* text, int ecl, int mask, int minVersion, int maxVersion, int boostEcl) {
    if (!text || strcmp(text, "") == 0)
        return "crunk_qrcode: Invalid argument value for text.";
    if (ecl < -1 || ecl > 3)
        return "crunk_qrcode: Invalid argument value for ecc_level.";
    if (mask < -1 || mask > 7)
        return "crunk_qrcode: Invalid argument value for mask.";
    if (minVersion < 1 || minVersion > 40 || maxVersion < 1 || maxVersion > 40 || minVersion > maxVersion)
        return "crunk_qrcode: Invalid argument value for min_ver/max_ver.";
    if (boostEcl < 0 || boostEcl > 1)
        return "crunk_qrcode: Invalid argument value for boostEcl";
    return "";
}

/** Generate a QR Code from text (called from Lua)
 *
 * lua: crunk.qrcode.generate(text, ecc_level, mask, min_version, max_version)
 * @param lua_State* L Lua State
 * @return ok bool Whether the QR Code was generated
 */
int qrq_lua_generate(lua_State* L) {
    int count = pd->lua->getArgCount();
    int border = 4; // QRCodes require a four module "quiet zone" around the code.
    const char* text= (count < 1 || pd->lua->argIsNil(1)) ? "" : pd->lua->getArgString(1);
    int ecl         = (count < 2 || pd->lua->argIsNil(2)) ?  3 : pd->lua->getArgInt(2);
    int mask        = (count < 3 || pd->lua->argIsNil(3)) ? -1 : pd->lua->getArgInt(3);
    int minVersion  = (count < 4 || pd->lua->argIsNil(4)) ?  1 : pd->lua->getArgInt(4);
    int maxVersion  = (count < 5 || pd->lua->argIsNil(5)) ? 40 : pd->lua->getArgInt(5);
    int boostEcl    = (count < 6 || pd->lua->argIsNil(6)) ?  1 : pd->lua->getArgInt(6);

    char* err = check_new_args(text, ecl, mask, minVersion, maxVersion, boostEcl);
    if (strcmp(err, "") != 0) {
        pd->system->logToConsole(err);
        return 0;
    }

	/* Ask qrcodegen to generate a QRCode (tempBuffer, outBuffer are static buffers) */
    bool ok = qrcodegen_encodeText(text, tempBuffer, outBuffer, ecl, minVersion, maxVersion, mask, boostEcl);
    if (!ok) {
        pd->system->logToConsole("Failed to encode text into QR code.");
        return 1;
    }

	/* Convert the qrcode buffer to a newly allocated Playdate LCDBitmap */
    int width, height, rowbytes;
    uint8_t *data = NULL;
    int size = qrcodegen_getSize(outBuffer); // side length (21x21 to 177x177)
    int image_size = (size + 2 * border >= 32) ? (size + 2 * border) : 32; //min LCDBitmap is 32x32.
    // This allocates a new bitmap. When we return, Lua is responsible for freeing/GC (I think).
	LCDBitmap* bitmap = pd->graphics->newBitmap(image_size, image_size, kColorWhite);
    pd->graphics->getBitmapData(bitmap, &width, &height, &rowbytes, NULL, &data);
	for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
			if (qrcodegen_getModule(outBuffer, x, y)) {
				crunk_setpixel(data, x + border, y + border, rowbytes);
			}
        }
    }
	if (!ok) {
		pd->system->logToConsole("QRCode generation failed.");
		return 0;
	}
	pd->lua->pushBitmap(bitmap);
	return 1;
}

void crunk_qrcode_register(PlaydateAPI* playdate, const char* name) {
    pd = playdate;
    const char* err;
    int ok = 0;
	ok = pd->lua->addFunction(qrq_lua_generate, name, &err);
    if ( !ok )
        pd->system->logToConsole("%s:%i: registerFunction '%s' failed, %s", __FILE__, __LINE__, name, err);
}
