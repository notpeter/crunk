//
//  main.c
// Playdate C Template
//
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "qrcodegen.h"
#include "crunk_qrcode.h"

LCDBitmap *bitmap = NULL;

static bool qr_done = false;

#ifdef _WINDLL
__declspec(dllexport)
#endif

int eventHandler(PlaydateAPI* pd, PDSystemEvent event, uint32_t arg) {
    (void)arg; // arg is currently only used for event = kEventKeyPressed
    switch (event) {
        case kEventInit:
            break;
        case kEventInitLua:
			crunk_qrcode_register(pd, "crunk.qrcode.generate");
            break;
        case kEventLock:
			break;
        case kEventUnlock:
			break;
        case kEventLowPower:
			break;
        case kEventPause:
			break;
        case kEventResume:
			break;
        case kEventTerminate:
			break;
        case kEventKeyPressed:
			break;
        case kEventKeyReleased:
			break;
    }
    return 0;
}
