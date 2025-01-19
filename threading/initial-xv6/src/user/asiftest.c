#include "kernel/types.h"
#include "kernel/memlayout.h"
#include "user/user.h"





int main() {
    int ipf = cow();

    int variable = 0;

    // Fork a few read-only children
    for (int i = 0; i < 3; i++) {
        if (fork() == 0) {
           int in = variable;
           if (in == 0) exit(0);
           exit(0);
        }
    }
    for (int i=0 ; i<3 ; i++){
        wait(0);
    }
    int pf = cow();
    printf("Page faults in reading: %d\n", pf - ipf);
    // Fork a few write children
    ipf = cow();
    for (int i = 0; i < 30; i++) {
        int newvar = 0;
        if (fork() == 0) {
            newvar++;
            exit(0);
        }
    }
    for (int i=0 ; i<30 ; i++){
        wait(0);
    }

    pf = cow();
    printf("Page faults in writing: %d",  pf - ipf);

    exit(0);
}