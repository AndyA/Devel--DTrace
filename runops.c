
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "plxsdtrace.h"
#include "runops.h"

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

STATIC char *
_sub_name( pTHX ) {
    const CV *const cv = _curcv( aTHX_ cxstack_ix );
    if ( cv ) {
        const GV *const gv = CvGV( cv );
        if ( gv ) {
            return GvENAME( gv );
        }
    }

    return "???";
}

STATIC int
_runops_dtrace( pTHX ) {
    const OP *last_op = NULL;
    I32 last_cxstack_ix = 0;
    const char *last_func = NULL;

    while ( ( PL_op = CALL_FPTR( PL_op->op_ppaddr ) ( aTHX ) ) ) {
        PERL_ASYNC_CHECK(  );

        if ( last_op && last_op->op_type == OP_ENTERSUB ) {
            /* last OP was OP_ENTERSUB so we're inside the sub now */
            last_func = _sub_name( aTHX );
            PERLXS_SUB_ENTRY( ( char * ) last_func,
                              CopFILE( PL_curcop ), CopLINE( PL_curcop ) );
        }
        else if ( cxstack_ix < last_cxstack_ix ) {
            /* stack popped so we've left the sub */
            PERLXS_SUB_RETURN( ( char * ) last_func,
                               CopFILE( PL_curcop ),
                               CopLINE( PL_curcop ) );
            last_func = _sub_name( aTHX );
        }

        last_op = PL_op;
        last_cxstack_ix = cxstack_ix;
    }

    TAINT_NOT;
    return 0;
}

void
runops_hook( void ) {
    if ( PL_runops != _runops_dtrace ) {
        PL_runops = _runops_dtrace;
    }
}
