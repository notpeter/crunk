#include "crunk_qrcode.h"

/* Statically allocated buffers so code is no longer thread safe.
   Could be made smaller with qrcodegen_BUFFER_LEN_FOR_VERSION(n)
   by enforcing a maximum size < 40 (177x177 pixels).
   Maybe n=25 (117x117 can scale 2x)
*/

// Statically allocated temporary buffer (3918 bytes)
static uint8_t tempBuffer[qrcodegen_BUFFER_LEN_MAX];
// Statically allocated output buffer (3918 bytes)
static uint8_t qrcode[qrcodegen_BUFFER_LEN_MAX];

static PlaydateAPI* pd = NULL;

char* check_new_args(const char* text, int ecl, int mask, int minVersion, int maxVersion, int boostEcl) {
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
    // debug(
    //     "DEBUG: qrq_lua_generate(text=\"%s\", ecl=%d, mask=%d, minVersion=%d, maxVersion=%d, boostEcl=%d)",
    //     text, ecl, mask, minVersion, maxVersion, boostEcl
    // );
    return "";
}

// lua: crunk.qrcode.generate(text, ecc_level, mask, min_version, max_version)
static int qrq_lua_generate(lua_State* L) {
    int count = pd->lua->getArgCount();
    int border = 2;
    const char* text= (count < 1 || pd->lua->argIsNil(1)) ? "" : pd->lua->getArgString(1);
    int ecl         = (count < 2 || pd->lua->argIsNil(2)) ?  3 : pd->lua->getArgInt(2);
    int mask        = (count < 3 || pd->lua->argIsNil(3)) ? -1 : pd->lua->getArgInt(3);
    int minVersion  = (count < 4 || pd->lua->argIsNil(4)) ?  1 : pd->lua->getArgInt(4);
    int maxVersion  = (count < 5 || pd->lua->argIsNil(5)) ? 40 : pd->lua->getArgInt(5);
    int boostEcl    = (count < 6 || pd->lua->argIsNil(6)) ?  1 : pd->lua->getArgInt(6);

    char* err = check_new_args(text, ecl, mask, minVersion, maxVersion, boostEcl);
    if (strcmp(err, "")) {
        pd->system->logToConsole(err);
        return 0;
    }

    // tempBuffer and qrcode are statically allocated global buffers.
    bool ok = qrcodegen_encodeText(text, tempBuffer, qrcode, ecl, minVersion, maxVersion, mask, boostEcl);
    if (!ok) {
        pd->system->logToConsole("Failed to encode text into QR code.");
        return 0;
    }

    int size = qrcodegen_getSize(qrcode); // side length (21x21 to 177x177)
    int image_size = (size + 2 * border >= 32) ? (size + 2 * border) : 32; //min LCDBitmap is 32x32.

    LCDBitmap* bitmap = pd->graphics->newBitmap(image_size, image_size, kColorWhite);
    int width, height, rowbytes;
    uint8_t *data = NULL;
    pd->graphics->getBitmapData(bitmap, &width, &height, &rowbytes, NULL, &data);
    // debug("bitmap(width=%d, height=%d, rowbytes=%d", width, height, rowbytes);

    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            drawpixel(data, x + border, y + border, rowbytes, qrcodegen_getModule(qrcode, x, y));
        }
    }
    pd->lua->pushBitmap(bitmap);
    return 1;
}

static const lua_val qrqConst[] = {
    {.name = "kEccLow",       .type = kInt, {qrcodegen_Ecc_LOW}},         // 7% erroneous codewords
    {.name = "kEccMedium",    .type = kInt, {qrcodegen_Ecc_MEDIUM}},      // 15% erroneous codewords
    {.name = "kEccHigh",      .type = kInt, {qrcodegen_Ecc_QUARTILE}},    // 25% erroneous codewords
    {.name = "kEccMaximum",   .type = kInt, {qrcodegen_Ecc_HIGH}},        // 30% erroneous codewords
};

static const lua_reg qrqLib[] = {
    { "generate", qrq_lua_generate },
};

void registerQRQ(PlaydateAPI* playdate, const char* name) {
    pd = playdate;
    const char* err;
    int ok = 0;
	// See: https://devforum.play.date/t/playdate-lua-registerclass-lua-val-crashes-on-device/13899
    // TODO: Restore once we figure out why this is broken on-device.
    // ok = pd->lua->registerClass(name, qrqLib, qrqConst, 1, &err);
    ok = pd->lua->registerClass(name, qrqLib, NULL, 1, &err);
    if ( !ok )
        pd->system->logToConsole("%s:%i: registerClass failed, %s", __FILE__, __LINE__, err);
}
