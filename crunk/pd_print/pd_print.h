#pragma once
// Copyright 2023 Peter Tripp (@notpeter)
// https://github.com/notpeter/crunk

#include "pd_api.h"

/* In order to use these you will need initialize `pd` in your main.c like so:
```c
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
And then in every C file, include `extern PlaydateAPI* pd;` reference as below.
*/

extern PlaydateAPI* pd;

#ifndef pd_print
/** Prints to the console
 * @param s const char* Format string
 * @param ... Arguments
 */
#define pd_print(fmt, ...) pd->system->logToConsole((fmt), ##__VA_ARGS__)
#endif

#ifndef pd_error
/** Prints to the console in red and a pauses execution
 * @param s const char* Format string
 * @param ... Arguments
*/
#define pd_error(fmt, ...) pd->system->error((fmt), ##__VA_ARGS__)
#endif

//#define PD_DEBUG 1
#ifndef pd_debug
/** Log to console if PD_DEBUG is 1 (otherwise no-op)
 * @param fmt const char* Format string
 * @param ... Arguments
 */
#define pd_debug(fmt, ...) do { if (PD_DEBUG) pd->system->logToConsole((fmt), __VA_ARGS__); } while (0)
#endif
