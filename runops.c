
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "plxsdtrace.h"
#include "runops.h"

// STATIC const char *_eval_ = "(eval)";

STATIC CV *
_idxcv( pTHX_ I32 ix ) {
    const PERL_CONTEXT *const cx = &cxstack[ix];
    if ( CxTYPE( cx ) == CXt_SUB || CxTYPE( cx ) == CXt_FORMAT ) {
        return cx->blk_sub.cv;
    }
    else if ( CxTYPE( cx ) == CXt_EVAL && !CxTRYBLOCK( cx ) ) {
        return PL_compcv;
    }
    else if ( ix == 0 && PL_curstackinfo->si_type == PERLSI_MAIN ) {
        return PL_main_cv;
    }
    else {
        return NULL;
    }
}

STATIC const CV *
_curcv( pTHX_ I32 ix ) {
    const CV *cv;
    for ( ; ix >= 0; ix-- ) {
        if ( cv = _idxcv( aTHX_ ix ), cv != NULL ) {
            return cv;
        }
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

STATIC void
_stack_probe( pTHX_ const char *func, const char *file, I32 line ) {
    I32 ix;
    const CV *cv;

    fprintf( stderr, "# %ld\n", cxstack_ix );

    for ( ix = cxstack_ix; ix >= 0; ix-- ) {
        if ( cv = _idxcv( aTHX_ ix ), cv != NULL ) {
            const GV *const gv = CvGV( cv );
            if ( gv ) {
                char *this_func = GvENAME( gv );
                char *this_file = CopFILE( ( COP * ) CvSTART( cv ) );
                I32 this_line = CopLINE( ( COP * ) CvSTART( cv ) );
                if ( this_func && this_file ) {
                    fprintf( stderr, "# at %s, %s, %ld\n", this_func,
                             this_file, this_line );
                }
            }
        }
    }

    PERLXS_SUB_STACK( "", "", 0, "", 0 );
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
