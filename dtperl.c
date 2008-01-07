#include <EXTERN.h>
#include <perl.h>
#include "runops.h"

static PerlInterpreter *my_perl;

EXTERN_C void boot_DynaLoader( pTHX_ CV * cv );

static void
xs_init( pTHX ) {
    static char file[] = __FILE__;
    dXSUB_SYS;
    newXS( "DynaLoader::boot_DynaLoader", boot_DynaLoader, file );
}

/* Stolen from 5.11.0 */

int
main( int argc, char **argv, char **env ) {
#ifdef dVAR
    dVAR;
#endif
    int exit_status;

#ifdef PERL_GLOBAL_STRUCT
    struct perl_vars *plvarsp = init_global_struct(  );
#  ifdef PERL_GLOBAL_STRUCT_PRIVATE
    my_vars = my_plvarsp = plvarsp;
#  endif
#endif

#ifndef PERL_USE_SAFE_PUTENV
    PL_use_safe_putenv = 0;
#endif

    PERL_SYS_INIT3( &argc, &argv, &env );

#if defined(USE_ITHREADS)
    PTHREAD_ATFORK( Perl_atfork_lock,
                    Perl_atfork_unlock, Perl_atfork_unlock );
#endif

    if ( !PL_do_undump ) {
        my_perl = perl_alloc(  );
        if ( !my_perl ) {
            exit( 1 );
        }
        perl_construct( my_perl );
        PL_perl_destruct_level = 0;
    }

    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;

    exit_status =
        perl_parse( my_perl, xs_init, argc, argv, ( char ** ) NULL );

    if ( !exit_status ) {
        runops_hook(  );
        perl_run( my_perl );
    }

    exit_status = perl_destruct( my_perl );

    perl_free( my_perl );

#if defined(USE_ENVIRON_ARRAY) \
    && defined(PERL_TRACK_MEMPOOL) \
    && !defined(NO_ENV_ARRAY_IN_MAIN)
    environ = env;
#endif

#ifdef PERL_GLOBAL_STRUCT
    free_global_struct( plvarsp );
#endif

    PERL_SYS_TERM(  );

    exit( exit_status );
    return exit_status;
}
