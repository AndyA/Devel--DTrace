/* This file is included twice to generate both versions of the
 * runops loop.
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "plxsdtrace.h"
#include "runops.h"

#undef PROBE_ENTRY
#undef PROBE_RETURN
#undef RUNOPS_DTRACE

#ifdef RUNOPS_FAKE

#define PROBE_ENTRY(func, file, line)               \
    if ( func && file ) {                           \
        printf( "ENTRY(%s, %s, %d)\n", func, file, line ); \
    }

#define PROBE_RETURN(func, file, line)              \
    if ( func && file ) {                           \
        printf( "RETURN(%s, %s, %d)\n", func, file, line ); \
    }

#define RUNOPS_DTRACE _runops_dtrace_fake

#else

#define PROBE_ENTRY(func, file, line)                       \
if ( PERLXS_SUB_ENTRY_ENABLED(  ) && func && file ) {       \
    PERLXS_SUB_ENTRY( func, file, line );                   \
}

#define PROBE_RETURN(func, file, line)                      \
    if ( PERLXS_SUB_RETURN_ENABLED(  ) && func && file ) {  \
        PERLXS_SUB_RETURN( func, file, line );              \
    }

#define RUNOPS_DTRACE _runops_dtrace

#endif

#define IS_ENTERSUB(op) \
    ((op->op_type) == OP_ENTERSUB)

#define IS_ENTEREVAL(op) \
    ((op->op_type) == OP_ENTEREVAL || \
     (op->op_type) == OP_ENTERTRY)

STATIC int
RUNOPS_DTRACE( pTHX ) {
    const OP *last_op = NULL;
    I32 last_cxstack_ix = 0;
    const char *last_func = NULL;
    I32 eval_depth = 0;

    while ( ( PL_op = CALL_FPTR( PL_op->op_ppaddr ) ( aTHX ) ) ) {
        PERL_ASYNC_CHECK(  );

        if ( last_op && IS_ENTEREVAL( last_op ) ) {
            /* enter eval */
            eval_depth++;
        }
        else if ( last_op && IS_ENTERSUB( last_op ) ) {
            /* enter sub */
            /* need to check the sp has actually changed because
             * OP_ENTERSUB is used for XS too. 
             */
            if ( last_cxstack_ix != cxstack_ix ) {
                last_func = _sub_name( aTHX );
                PROBE_ENTRY( ( char * ) last_func, CopFILE( PL_curcop ),
                             CopLINE( PL_curcop ) );
            }
        }
        else if ( cxstack_ix < last_cxstack_ix ) {
            /* leave sub or eval */
            /* TODO: This doesn't feel quite right. What happens when a
             * number of stack frames are dropped by a die for example? 
             */
            if ( eval_depth > 0 ) {
                eval_depth--;
            }
            else {
                PROBE_RETURN( ( char * ) last_func,
                              CopFILE( PL_curcop ), CopLINE( PL_curcop ) );
                last_func = _sub_name( aTHX );
            }
        }

        last_op = PL_op;
        last_cxstack_ix = cxstack_ix;
    }

    TAINT_NOT;
    return 0;
}
