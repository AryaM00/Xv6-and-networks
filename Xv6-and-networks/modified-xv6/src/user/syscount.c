#include "../kernel/types.h"  
#include "../kernel/stat.h"     
#include "../kernel/syscall.h"   
#include "../kernel/param.h"  
#include "user.h"


char* syscall_name(int mask) {
    for (int i = 0; i < 32; i++) {
        if (mask == (1 << i)) {
            switch (i) {
                case SYS_fork: return "fork";
                case SYS_exit: return "exit";
                case SYS_wait: return "wait";
                case SYS_pipe: return "pipe";
                case SYS_read: return "read";
                case SYS_kill: return "kill";
                case SYS_exec: return "exec";
                case SYS_fstat: return "fstat";
                case SYS_chdir: return "chdir";
                case SYS_dup: return "dup";
                case SYS_getpid: return "getpid";
                case SYS_sbrk: return "sbrk";
                case SYS_sleep: return "sleep";
                case SYS_uptime: return "uptime";
                case SYS_open: return "open";
                case SYS_write: return "write";
                case SYS_mknod: return "mknod";
                case SYS_unlink: return "unlink";
                case SYS_link: return "link";
                case SYS_mkdir: return "mkdir";
                case SYS_close: return "close";
                case SYS_waitx: return "waitx";
                case SYS_getsyscount: return "getsyscount";

        
            }
        }
    }
    return "unknown";
}
int 
main(int argc,char *argv[]){
    
    if(argc<3){
        fprintf(2,"Usage: syscount <mask> command [args]\n");
        exit(1);

    }
    int mask = atoi(argv[1]);
    int pid = fork();
    if(pid<0){
        fprintf(2,"fork failed\n");
        exit(1);
    }
    if(pid==0){
        // child
        exec(argv[2],&argv[2]);
        // fprintf(2,"exec %s failed\n",argv[2]);
        // i want to copy syscount array of child to syscount array of parent


        exit(1);
    }
    else{
        // parent
        wait(0);

        int count = getsyscount(mask);
        printf("PID %d called %s %d times.\n", pid, syscall_name(mask), count);
        exit(0);
    }
    return 0;

}

