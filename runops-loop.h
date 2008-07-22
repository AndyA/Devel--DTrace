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
#undef RUNOPS_SUB_EXIT

#ifdef RUNOPS_FAKE

#define PROBE_ENTRY(func, file, line)               \
    if ( func && file ) {                           \
        printf( "ENTRY(%s, %s, %d)\n", func, file, line ); \
    }

#define PROBE_RETURN(func, file, line)              \
    if ( func && file ) {                           \
        printf( "RETURN(%s, %s, %d)\n", func, file, line ); \
    }

#define RUNOPS_DTRACE   _runops_dtrace_fake
#define RUNOPS_SUB_EXIT _runops_sub_exit_fake

#else

#define PROBE_ENTRY(func, file, line)                       \
if ( PERLXS_SUB_ENTRY_ENABLED(  ) && func && file ) {       \
    PERLXS_SUB_ENTRY( func, file, line );                   \
}

#define PROBE_RETURN(func, file, line)                      \
    if ( PERLXS_SUB_RETURN_ENABLED(  ) && func && file ) {  \
        PERLXS_SUB_RETURN( func, file, line );              \
    }

#define RUNOPS_DTRACE   _runops_dtrace
#define RUNOPS_SUB_EXIT _runops_sub_exit

#endif

#define IS_ENTERSUB(op) \
    ((op->op_type) == OP_ENTERSUB)

STATIC void
RUNOPS_SUB_EXIT( pTHX_ void *sub_name ) {
    PROBE_RETURN( ( char * ) sub_name,
                  CopFILE( PL_curcop ), CopLINE( PL_curcop ) );
}

STATIC int
RUNOPS_DTRACE( pTHX ) {
    const OP *last_op = NULL;
    const OP *next_op = NULL;

    while ( PL_op ) {
        last_op = PL_op;
        next_op = PL_op->op_next;

        if ( PL_op = CALL_FPTR( PL_op->op_ppaddr ) ( aTHX ), PL_op ) {
            PERL_ASYNC_CHECK(  );
        }

        if ( IS_ENTERSUB( last_op ) && PL_op != next_op ) {
            /* If we just called XS we'll now be at the next op. If we
             * called a Perl subroutine we'll be executing its first op
             * instead. 
             */
            char *sub_name = ( char * ) _sub_name( aTHX );
            PROBE_ENTRY( sub_name, CopFILE( PL_curcop ),
                         CopLINE( PL_curcop ) );
            save_destructor_x( RUNOPS_SUB_EXIT, sub_name );
        }
    }

    TAINT_NOT;
    return 0;
}
