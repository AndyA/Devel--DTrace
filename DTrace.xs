/* DTrace.xs */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static int
_runops_dtrace( pTHX ) {
    // char *lastfile = NULL;
    // int lastline = 0;

    while ( ( PL_op = CALL_FPTR( PL_op->op_ppaddr ) ( aTHX ) ) ) {
        PERL_ASYNC_CHECK(  );

        // if ( interesting_op( PL_op->op_type ) ) {
        //     /*fprintf(stderr, "%s, line %d\n", lastfile, lastline); */
        //     NOTE_NEW_VARS( lastline, lastfile );
        //     lastfile = CopFILE( cCOP );
        //     lastline = CopLINE( cCOP );
        // }
    }

    /*fprintf(stderr, "%s, line %d\n", lastfile, lastline); */

    TAINT_NOT;
    return 0;
}

static void
_hook_runops( void ) {
    if ( PL_runops != _runops_dtrace ) {
        // runops_old = PL_runops;
        PL_runops = _runops_dtrace;
    }
}

/* *INDENT-OFF* */

MODULE = Devel::DTrace PACKAGE = Devel::DTrace
PROTOTYPES: ENABLE

void
_dtrace_hook_runops()
PPCODE:
{
    _hook_runops();
}
