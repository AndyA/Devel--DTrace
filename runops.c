
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "plxsdtrace.h"
#include "runops.h"

// STATIC const char *_eval_ = "(eval)";

STATIC CV *
_curcv( pTHX_ I32 ix ) {
    for ( ; ix > 0; ix-- ) {
        const PERL_CONTEXT *const cx = &cxstack[ix];
        if ( CxTYPE( cx ) == CXt_SUB || CxTYPE( cx ) == CXt_FORMAT )
            return cx->blk_sub.cv;
        else if ( CxTYPE( cx ) == CXt_EVAL && !CxTRYBLOCK( cx ) )
            return PL_compcv;
        else if ( ix == 0 && PL_curstackinfo->si_type == PERLSI_MAIN )
            return PL_main_cv;
    }

    return NULL;
}

STATIC const char *
_sub_name( pTHX ) {
    const CV *const cv = _curcv( aTHX_ cxstack_ix );
    if ( cv ) {
        const GV *const gv = CvGV( cv );
        if ( gv ) {
            return GvENAME( gv );
        }
    }

    return NULL;
}

#undef RUNOPS_FAKE
#include "runops-loop.h"
#define RUNOPS_FAKE
#include "runops-loop.h"

STATIC bool
_should_fake(  ) {
    const char *fake = getenv( FAKE_ENV );
    return fake && atoi( fake );
}

void
runops_hook(  ) {
    runops_proc_t runops =
        _should_fake(  )? _runops_dtrace_fake : _runops_dtrace;

    if ( PL_runops != runops ) {
        PL_runops = runops;
    }
}
