/* DTrace.xs */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

STATIC const char *
_op_name( int t ) {
    switch ( t ) {
    case OP_NULL:
        return "OP_NULL";
    case OP_STUB:
        return "OP_STUB";
    case OP_SCALAR:
        return "OP_SCALAR";
    case OP_PUSHMARK:
        return "OP_PUSHMARK";
    case OP_WANTARRAY:
        return "OP_WANTARRAY";
    case OP_CONST:
        return "OP_CONST";
    case OP_GVSV:
        return "OP_GVSV";
    case OP_GV:
        return "OP_GV";
    case OP_GELEM:
        return "OP_GELEM";
    case OP_PADSV:
        return "OP_PADSV";
    case OP_PADAV:
        return "OP_PADAV";
    case OP_PADHV:
        return "OP_PADHV";
    case OP_PADANY:
        return "OP_PADANY";
    case OP_PUSHRE:
        return "OP_PUSHRE";
    case OP_RV2GV:
        return "OP_RV2GV";
    case OP_RV2SV:
        return "OP_RV2SV";
    case OP_AV2ARYLEN:
        return "OP_AV2ARYLEN";
    case OP_RV2CV:
        return "OP_RV2CV";
    case OP_ANONCODE:
        return "OP_ANONCODE";
    case OP_PROTOTYPE:
        return "OP_PROTOTYPE";
    case OP_REFGEN:
        return "OP_REFGEN";
    case OP_SREFGEN:
        return "OP_SREFGEN";
    case OP_REF:
        return "OP_REF";
    case OP_BLESS:
        return "OP_BLESS";
    case OP_BACKTICK:
        return "OP_BACKTICK";
    case OP_GLOB:
        return "OP_GLOB";
    case OP_READLINE:
        return "OP_READLINE";
    case OP_RCATLINE:
        return "OP_RCATLINE";
    case OP_REGCMAYBE:
        return "OP_REGCMAYBE";
    case OP_REGCRESET:
        return "OP_REGCRESET";
    case OP_REGCOMP:
        return "OP_REGCOMP";
    case OP_MATCH:
        return "OP_MATCH";
    case OP_QR:
        return "OP_QR";
    case OP_SUBST:
        return "OP_SUBST";
    case OP_SUBSTCONT:
        return "OP_SUBSTCONT";
    case OP_TRANS:
        return "OP_TRANS";
    case OP_SASSIGN:
        return "OP_SASSIGN";
    case OP_AASSIGN:
        return "OP_AASSIGN";
    case OP_CHOP:
        return "OP_CHOP";
    case OP_SCHOP:
        return "OP_SCHOP";
    case OP_CHOMP:
        return "OP_CHOMP";
    case OP_SCHOMP:
        return "OP_SCHOMP";
    case OP_DEFINED:
        return "OP_DEFINED";
    case OP_UNDEF:
        return "OP_UNDEF";
    case OP_STUDY:
        return "OP_STUDY";
    case OP_POS:
        return "OP_POS";
    case OP_PREINC:
        return "OP_PREINC";
    case OP_I_PREINC:
        return "OP_I_PREINC";
    case OP_PREDEC:
        return "OP_PREDEC";
    case OP_I_PREDEC:
        return "OP_I_PREDEC";
    case OP_POSTINC:
        return "OP_POSTINC";
    case OP_I_POSTINC:
        return "OP_I_POSTINC";
    case OP_POSTDEC:
        return "OP_POSTDEC";
    case OP_I_POSTDEC:
        return "OP_I_POSTDEC";
    case OP_POW:
        return "OP_POW";
    case OP_MULTIPLY:
        return "OP_MULTIPLY";
    case OP_I_MULTIPLY:
        return "OP_I_MULTIPLY";
    case OP_DIVIDE:
        return "OP_DIVIDE";
    case OP_I_DIVIDE:
        return "OP_I_DIVIDE";
    case OP_MODULO:
        return "OP_MODULO";
    case OP_I_MODULO:
        return "OP_I_MODULO";
    case OP_REPEAT:
        return "OP_REPEAT";
    case OP_ADD:
        return "OP_ADD";
    case OP_I_ADD:
        return "OP_I_ADD";
    case OP_SUBTRACT:
        return "OP_SUBTRACT";
    case OP_I_SUBTRACT:
        return "OP_I_SUBTRACT";
    case OP_CONCAT:
        return "OP_CONCAT";
    case OP_STRINGIFY:
        return "OP_STRINGIFY";
    case OP_LEFT_SHIFT:
        return "OP_LEFT_SHIFT";
    case OP_RIGHT_SHIFT:
        return "OP_RIGHT_SHIFT";
    case OP_LT:
        return "OP_LT";
    case OP_I_LT:
        return "OP_I_LT";
    case OP_GT:
        return "OP_GT";
    case OP_I_GT:
        return "OP_I_GT";
    case OP_LE:
        return "OP_LE";
    case OP_I_LE:
        return "OP_I_LE";
    case OP_GE:
        return "OP_GE";
    case OP_I_GE:
        return "OP_I_GE";
    case OP_EQ:
        return "OP_EQ";
    case OP_I_EQ:
        return "OP_I_EQ";
    case OP_NE:
        return "OP_NE";
    case OP_I_NE:
        return "OP_I_NE";
    case OP_NCMP:
        return "OP_NCMP";
    case OP_I_NCMP:
        return "OP_I_NCMP";
    case OP_SLT:
        return "OP_SLT";
    case OP_SGT:
        return "OP_SGT";
    case OP_SLE:
        return "OP_SLE";
    case OP_SGE:
        return "OP_SGE";
    case OP_SEQ:
        return "OP_SEQ";
    case OP_SNE:
        return "OP_SNE";
    case OP_SCMP:
        return "OP_SCMP";
    case OP_BIT_AND:
        return "OP_BIT_AND";
    case OP_BIT_XOR:
        return "OP_BIT_XOR";
    case OP_BIT_OR:
        return "OP_BIT_OR";
    case OP_NEGATE:
        return "OP_NEGATE";
    case OP_I_NEGATE:
        return "OP_I_NEGATE";
    case OP_NOT:
        return "OP_NOT";
    case OP_COMPLEMENT:
        return "OP_COMPLEMENT";
    case OP_SMARTMATCH:
        return "OP_SMARTMATCH";
    case OP_ATAN2:
        return "OP_ATAN2";
    case OP_SIN:
        return "OP_SIN";
    case OP_COS:
        return "OP_COS";
    case OP_RAND:
        return "OP_RAND";
    case OP_SRAND:
        return "OP_SRAND";
    case OP_EXP:
        return "OP_EXP";
    case OP_LOG:
        return "OP_LOG";
    case OP_SQRT:
        return "OP_SQRT";
    case OP_INT:
        return "OP_INT";
    case OP_HEX:
        return "OP_HEX";
    case OP_OCT:
        return "OP_OCT";
    case OP_ABS:
        return "OP_ABS";
    case OP_LENGTH:
        return "OP_LENGTH";
    case OP_SUBSTR:
        return "OP_SUBSTR";
    case OP_VEC:
        return "OP_VEC";
    case OP_INDEX:
        return "OP_INDEX";
    case OP_RINDEX:
        return "OP_RINDEX";
    case OP_SPRINTF:
        return "OP_SPRINTF";
    case OP_FORMLINE:
        return "OP_FORMLINE";
    case OP_ORD:
        return "OP_ORD";
    case OP_CHR:
        return "OP_CHR";
    case OP_CRYPT:
        return "OP_CRYPT";
    case OP_UCFIRST:
        return "OP_UCFIRST";
    case OP_LCFIRST:
        return "OP_LCFIRST";
    case OP_UC:
        return "OP_UC";
    case OP_LC:
        return "OP_LC";
    case OP_QUOTEMETA:
        return "OP_QUOTEMETA";
    case OP_RV2AV:
        return "OP_RV2AV";
    case OP_AELEMFAST:
        return "OP_AELEMFAST";
    case OP_AELEM:
        return "OP_AELEM";
    case OP_ASLICE:
        return "OP_ASLICE";
    case OP_EACH:
        return "OP_EACH";
    case OP_VALUES:
        return "OP_VALUES";
    case OP_KEYS:
        return "OP_KEYS";
    case OP_DELETE:
        return "OP_DELETE";
    case OP_EXISTS:
        return "OP_EXISTS";
    case OP_RV2HV:
        return "OP_RV2HV";
    case OP_HELEM:
        return "OP_HELEM";
    case OP_HSLICE:
        return "OP_HSLICE";
    case OP_UNPACK:
        return "OP_UNPACK";
    case OP_PACK:
        return "OP_PACK";
    case OP_SPLIT:
        return "OP_SPLIT";
    case OP_JOIN:
        return "OP_JOIN";
    case OP_LIST:
        return "OP_LIST";
    case OP_LSLICE:
        return "OP_LSLICE";
    case OP_ANONLIST:
        return "OP_ANONLIST";
    case OP_ANONHASH:
        return "OP_ANONHASH";
    case OP_SPLICE:
        return "OP_SPLICE";
    case OP_PUSH:
        return "OP_PUSH";
    case OP_POP:
        return "OP_POP";
    case OP_SHIFT:
        return "OP_SHIFT";
    case OP_UNSHIFT:
        return "OP_UNSHIFT";
    case OP_SORT:
        return "OP_SORT";
    case OP_REVERSE:
        return "OP_REVERSE";
    case OP_GREPSTART:
        return "OP_GREPSTART";
    case OP_GREPWHILE:
        return "OP_GREPWHILE";
    case OP_MAPSTART:
        return "OP_MAPSTART";
    case OP_MAPWHILE:
        return "OP_MAPWHILE";
    case OP_RANGE:
        return "OP_RANGE";
    case OP_FLIP:
        return "OP_FLIP";
    case OP_FLOP:
        return "OP_FLOP";
    case OP_AND:
        return "OP_AND";
    case OP_OR:
        return "OP_OR";
    case OP_XOR:
        return "OP_XOR";
    case OP_DOR:
        return "OP_DOR";
    case OP_COND_EXPR:
        return "OP_COND_EXPR";
    case OP_ANDASSIGN:
        return "OP_ANDASSIGN";
    case OP_ORASSIGN:
        return "OP_ORASSIGN";
    case OP_DORASSIGN:
        return "OP_DORASSIGN";
    case OP_METHOD:
        return "OP_METHOD";
    case OP_ENTERSUB:
        return "OP_ENTERSUB";
    case OP_LEAVESUB:
        return "OP_LEAVESUB";
    case OP_LEAVESUBLV:
        return "OP_LEAVESUBLV";
    case OP_CALLER:
        return "OP_CALLER";
    case OP_WARN:
        return "OP_WARN";
    case OP_DIE:
        return "OP_DIE";
    case OP_RESET:
        return "OP_RESET";
    case OP_LINESEQ:
        return "OP_LINESEQ";
    case OP_NEXTSTATE:
        return "OP_NEXTSTATE";
    case OP_DBSTATE:
        return "OP_DBSTATE";
    case OP_UNSTACK:
        return "OP_UNSTACK";
    case OP_ENTER:
        return "OP_ENTER";
    case OP_LEAVE:
        return "OP_LEAVE";
    case OP_SCOPE:
        return "OP_SCOPE";
    case OP_ENTERITER:
        return "OP_ENTERITER";
    case OP_ITER:
        return "OP_ITER";
    case OP_ENTERLOOP:
        return "OP_ENTERLOOP";
    case OP_LEAVELOOP:
        return "OP_LEAVELOOP";
    case OP_RETURN:
        return "OP_RETURN";
    case OP_LAST:
        return "OP_LAST";
    case OP_NEXT:
        return "OP_NEXT";
    case OP_REDO:
        return "OP_REDO";
    case OP_DUMP:
        return "OP_DUMP";
    case OP_GOTO:
        return "OP_GOTO";
    case OP_EXIT:
        return "OP_EXIT";
    case OP_SETSTATE:
        return "OP_SETSTATE";
    case OP_METHOD_NAMED:
        return "OP_METHOD_NAMED";
    case OP_ENTERGIVEN:
        return "OP_ENTERGIVEN";
    case OP_LEAVEGIVEN:
        return "OP_LEAVEGIVEN";
    case OP_ENTERWHEN:
        return "OP_ENTERWHEN";
    case OP_LEAVEWHEN:
        return "OP_LEAVEWHEN";
    case OP_BREAK:
        return "OP_BREAK";
    case OP_CONTINUE:
        return "OP_CONTINUE";
    case OP_OPEN:
        return "OP_OPEN";
    case OP_CLOSE:
        return "OP_CLOSE";
    case OP_PIPE_OP:
        return "OP_PIPE_OP";
    case OP_FILENO:
        return "OP_FILENO";
    case OP_UMASK:
        return "OP_UMASK";
    case OP_BINMODE:
        return "OP_BINMODE";
    case OP_TIE:
        return "OP_TIE";
    case OP_UNTIE:
        return "OP_UNTIE";
    case OP_TIED:
        return "OP_TIED";
    case OP_DBMOPEN:
        return "OP_DBMOPEN";
    case OP_DBMCLOSE:
        return "OP_DBMCLOSE";
    case OP_SSELECT:
        return "OP_SSELECT";
    case OP_SELECT:
        return "OP_SELECT";
    case OP_GETC:
        return "OP_GETC";
    case OP_READ:
        return "OP_READ";
    case OP_ENTERWRITE:
        return "OP_ENTERWRITE";
    case OP_LEAVEWRITE:
        return "OP_LEAVEWRITE";
    case OP_PRTF:
        return "OP_PRTF";
    case OP_PRINT:
        return "OP_PRINT";
    case OP_SAY:
        return "OP_SAY";
    case OP_SYSOPEN:
        return "OP_SYSOPEN";
    case OP_SYSSEEK:
        return "OP_SYSSEEK";
    case OP_SYSREAD:
        return "OP_SYSREAD";
    case OP_SYSWRITE:
        return "OP_SYSWRITE";
    case OP_SEND:
        return "OP_SEND";
    case OP_RECV:
        return "OP_RECV";
    case OP_EOF:
        return "OP_EOF";
    case OP_TELL:
        return "OP_TELL";
    case OP_SEEK:
        return "OP_SEEK";
    case OP_TRUNCATE:
        return "OP_TRUNCATE";
    case OP_FCNTL:
        return "OP_FCNTL";
    case OP_IOCTL:
        return "OP_IOCTL";
    case OP_FLOCK:
        return "OP_FLOCK";
    case OP_SOCKET:
        return "OP_SOCKET";
    case OP_SOCKPAIR:
        return "OP_SOCKPAIR";
    case OP_BIND:
        return "OP_BIND";
    case OP_CONNECT:
        return "OP_CONNECT";
    case OP_LISTEN:
        return "OP_LISTEN";
    case OP_ACCEPT:
        return "OP_ACCEPT";
    case OP_SHUTDOWN:
        return "OP_SHUTDOWN";
    case OP_GSOCKOPT:
        return "OP_GSOCKOPT";
    case OP_SSOCKOPT:
        return "OP_SSOCKOPT";
    case OP_GETSOCKNAME:
        return "OP_GETSOCKNAME";
    case OP_GETPEERNAME:
        return "OP_GETPEERNAME";
    case OP_LSTAT:
        return "OP_LSTAT";
    case OP_STAT:
        return "OP_STAT";
    case OP_FTRREAD:
        return "OP_FTRREAD";
    case OP_FTRWRITE:
        return "OP_FTRWRITE";
    case OP_FTREXEC:
        return "OP_FTREXEC";
    case OP_FTEREAD:
        return "OP_FTEREAD";
    case OP_FTEWRITE:
        return "OP_FTEWRITE";
    case OP_FTEEXEC:
        return "OP_FTEEXEC";
    case OP_FTIS:
        return "OP_FTIS";
    case OP_FTSIZE:
        return "OP_FTSIZE";
    case OP_FTMTIME:
        return "OP_FTMTIME";
    case OP_FTATIME:
        return "OP_FTATIME";
    case OP_FTCTIME:
        return "OP_FTCTIME";
    case OP_FTROWNED:
        return "OP_FTROWNED";
    case OP_FTEOWNED:
        return "OP_FTEOWNED";
    case OP_FTZERO:
        return "OP_FTZERO";
    case OP_FTSOCK:
        return "OP_FTSOCK";
    case OP_FTCHR:
        return "OP_FTCHR";
    case OP_FTBLK:
        return "OP_FTBLK";
    case OP_FTFILE:
        return "OP_FTFILE";
    case OP_FTDIR:
        return "OP_FTDIR";
    case OP_FTPIPE:
        return "OP_FTPIPE";
    case OP_FTSUID:
        return "OP_FTSUID";
    case OP_FTSGID:
        return "OP_FTSGID";
    case OP_FTSVTX:
        return "OP_FTSVTX";
    case OP_FTLINK:
        return "OP_FTLINK";
    case OP_FTTTY:
        return "OP_FTTTY";
    case OP_FTTEXT:
        return "OP_FTTEXT";
    case OP_FTBINARY:
        return "OP_FTBINARY";
    case OP_CHDIR:
        return "OP_CHDIR";
    case OP_CHOWN:
        return "OP_CHOWN";
    case OP_CHROOT:
        return "OP_CHROOT";
    case OP_UNLINK:
        return "OP_UNLINK";
    case OP_CHMOD:
        return "OP_CHMOD";
    case OP_UTIME:
        return "OP_UTIME";
    case OP_RENAME:
        return "OP_RENAME";
    case OP_LINK:
        return "OP_LINK";
    case OP_SYMLINK:
        return "OP_SYMLINK";
    case OP_READLINK:
        return "OP_READLINK";
    case OP_MKDIR:
        return "OP_MKDIR";
    case OP_RMDIR:
        return "OP_RMDIR";
    case OP_OPEN_DIR:
        return "OP_OPEN_DIR";
    case OP_READDIR:
        return "OP_READDIR";
    case OP_TELLDIR:
        return "OP_TELLDIR";
    case OP_SEEKDIR:
        return "OP_SEEKDIR";
    case OP_REWINDDIR:
        return "OP_REWINDDIR";
    case OP_CLOSEDIR:
        return "OP_CLOSEDIR";
    case OP_FORK:
        return "OP_FORK";
    case OP_WAIT:
        return "OP_WAIT";
    case OP_WAITPID:
        return "OP_WAITPID";
    case OP_SYSTEM:
        return "OP_SYSTEM";
    case OP_EXEC:
        return "OP_EXEC";
    case OP_KILL:
        return "OP_KILL";
    case OP_GETPPID:
        return "OP_GETPPID";
    case OP_GETPGRP:
        return "OP_GETPGRP";
    case OP_SETPGRP:
        return "OP_SETPGRP";
    case OP_GETPRIORITY:
        return "OP_GETPRIORITY";
    case OP_SETPRIORITY:
        return "OP_SETPRIORITY";
    case OP_TIME:
        return "OP_TIME";
    case OP_TMS:
        return "OP_TMS";
    case OP_LOCALTIME:
        return "OP_LOCALTIME";
    case OP_GMTIME:
        return "OP_GMTIME";
    case OP_ALARM:
        return "OP_ALARM";
    case OP_SLEEP:
        return "OP_SLEEP";
    case OP_SHMGET:
        return "OP_SHMGET";
    case OP_SHMCTL:
        return "OP_SHMCTL";
    case OP_SHMREAD:
        return "OP_SHMREAD";
    case OP_SHMWRITE:
        return "OP_SHMWRITE";
    case OP_MSGGET:
        return "OP_MSGGET";
    case OP_MSGCTL:
        return "OP_MSGCTL";
    case OP_MSGSND:
        return "OP_MSGSND";
    case OP_MSGRCV:
        return "OP_MSGRCV";
    case OP_SEMOP:
        return "OP_SEMOP";
    case OP_SEMGET:
        return "OP_SEMGET";
    case OP_SEMCTL:
        return "OP_SEMCTL";
    case OP_REQUIRE:
        return "OP_REQUIRE";
    case OP_DOFILE:
        return "OP_DOFILE";
    case OP_ENTEREVAL:
        return "OP_ENTEREVAL";
    case OP_LEAVEEVAL:
        return "OP_LEAVEEVAL";
    case OP_ENTERTRY:
        return "OP_ENTERTRY";
    case OP_LEAVETRY:
        return "OP_LEAVETRY";
    case OP_GHBYNAME:
        return "OP_GHBYNAME";
    case OP_GHBYADDR:
        return "OP_GHBYADDR";
    case OP_GHOSTENT:
        return "OP_GHOSTENT";
    case OP_GNBYNAME:
        return "OP_GNBYNAME";
    case OP_GNBYADDR:
        return "OP_GNBYADDR";
    case OP_GNETENT:
        return "OP_GNETENT";
    case OP_GPBYNAME:
        return "OP_GPBYNAME";
    case OP_GPBYNUMBER:
        return "OP_GPBYNUMBER";
    case OP_GPROTOENT:
        return "OP_GPROTOENT";
    case OP_GSBYNAME:
        return "OP_GSBYNAME";
    case OP_GSBYPORT:
        return "OP_GSBYPORT";
    case OP_GSERVENT:
        return "OP_GSERVENT";
    case OP_SHOSTENT:
        return "OP_SHOSTENT";
    case OP_SNETENT:
        return "OP_SNETENT";
    case OP_SPROTOENT:
        return "OP_SPROTOENT";
    case OP_SSERVENT:
        return "OP_SSERVENT";
    case OP_EHOSTENT:
        return "OP_EHOSTENT";
    case OP_ENETENT:
        return "OP_ENETENT";
    case OP_EPROTOENT:
        return "OP_EPROTOENT";
    case OP_ESERVENT:
        return "OP_ESERVENT";
    case OP_GPWNAM:
        return "OP_GPWNAM";
    case OP_GPWUID:
        return "OP_GPWUID";
    case OP_GPWENT:
        return "OP_GPWENT";
    case OP_SPWENT:
        return "OP_SPWENT";
    case OP_EPWENT:
        return "OP_EPWENT";
    case OP_GGRNAM:
        return "OP_GGRNAM";
    case OP_GGRGID:
        return "OP_GGRGID";
    case OP_GGRENT:
        return "OP_GGRENT";
    case OP_SGRENT:
        return "OP_SGRENT";
    case OP_EGRENT:
        return "OP_EGRENT";
    case OP_GETLOGIN:
        return "OP_GETLOGIN";
    case OP_SYSCALL:
        return "OP_SYSCALL";
    case OP_LOCK:
        return "OP_LOCK";
    case OP_ONCE:
        return "OP_ONCE";
    case OP_CUSTOM:
        return "OP_CUSTOM";
    default:
        return "unknown";
    }
}

STATIC CV *
_curcv( pTHX_ I32 ix ) {
    dVAR;
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

STATIC void
_indent( I32 depth ) {
    while ( depth-- > 0 ) {
        fprintf( stderr, "  " );
    }
}

STATIC char *
_sub_name( void ) {
    CV *const cv = _curcv( aTHX_ cxstack_ix );
    return cv == NULL ? "?" : GvENAME( CvGV( cv ) );
}

STATIC int
_runops_dtrace( pTHX ) {
    OP *last_op = NULL;
    I32 last_cxstack_ix = 0;
    const char *last_func = NULL;

    while ( ( PL_op = CALL_FPTR( PL_op->op_ppaddr ) ( aTHX ) ) ) {
        PERL_ASYNC_CHECK(  );

        if ( last_op && last_op->op_type == OP_ENTERSUB ) {
            last_func = _sub_name(  );
            _indent( cxstack_ix );
            fprintf( stderr, "enter %s at %s, %lu\n",
                     last_func,
                     CopFILE( PL_curcop ),
                     ( unsigned long ) CopLINE( PL_curcop ) );
        }
        else if ( cxstack_ix < last_cxstack_ix ) {
            _indent( last_cxstack_ix );
            fprintf( stderr, "leave %s at %s, %lu\n",
                     last_func,
                     CopFILE( PL_curcop ),
                     ( unsigned long ) CopLINE( PL_curcop ) );
            last_func = _sub_name(  );
        }

        last_op = PL_op;
        last_cxstack_ix = cxstack_ix;
    }

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
