// Copyright 2023 Peter Tripp
// https://github.com/notpeter/crunk

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "qrcodegen.h"
#include "crunk_qrcode.h"

#ifdef _WINDLL
__declspec(dllexport)
#endif

PlaydateAPI* pd = NULL;


int eventHandler(PlaydateAPI* playdate, PDSystemEvent event, uint32_t arg) {
    (void)arg; // arg is currently only used for event = kEventKeyPressed
    switch (event) {
        case kEventInit:
            break;
        case kEventInitLua:
            pd = playdate;
            crunk_qrcode_register(playdate, "crunk.qrcode.generate");
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
