#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <unistd.h>
#include <time.h>
#include <sys/time.h>

#if defined(HAVE_MACH_TIME)
#include <mach/mach.h>
#include <mach/mach_time.h>
#endif

static NV
monotime(pTHX) {
#if defined(HAVE_GETHRTIME)
    return gethrtime() * 1e-9;
#elif defined(HAVE_CLOCK_GETTIME)
    struct timespec ts;

    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0)
        croak("clock_gettime() failed: %s", Strerror(errno));

    return ts.tv_sec + 1e-9 * ts.tv_nsec;
#elif defined(HAVE_MACH_TIME)
    static NV factor = 0.0;

    if (factor == 0.0) {
        mach_timebase_info_data_t timebase;
        kern_return_t ret;

        ret = mach_timebase_info(&timebase);
        if (ret != KERN_SUCCESS)
            croak("mach_timebase_info() failed: %s", mach_error_string(ret));

        if (timebase.denom == 0)
            croak("mach_timebase_info() returned a zero denominator");

        factor = 1e-9 * ((NV)timebase.numer / (NV)timebase.denom);
    }
    return mach_absolute_time() * factor;
#else
#error "unknown monotonic clock source"
#endif
}

MODULE = Time::Monotonic    PACKAGE = Time::Monotonic

PROTOTYPES: DISABLE

NV
monotime()
  CODE:
    RETVAL = monotime(aTHX);
  OUTPUT:
    RETVAL

