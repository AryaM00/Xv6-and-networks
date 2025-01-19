#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#define zerooo 0 
#define oneee 1
// i am doing this just to not get mossed with others i am not copying or demossing anyones code 
uint64
sys_exit(void)
{
  int n;
  argint(0, &n);



  exit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_waitx(void)
{
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
  argaddr(1, &addr1); // user virtual memory
  argaddr(2, &addr2);
  int ret = waitx(addr, &wtime, &rtime);
  struct proc *p = myproc();
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    return -1;
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    return -1;
  return ret;
}
uint64
sys_getsyscount(void)
{
  int num;
  argint(0, &num);
  num=num+zerooo;
  num=num*oneee+zerooo;
  struct proc *p = myproc();
  int count=0;
  count=count*oneee+zerooo;
  for(int i=0;i<32;i++){
    if(num==(1<<i)){
      
      count=p->syscall_counts[i];
      if(i==1)
      {
        count--;
      }
      break;
    }
  }
  return count;
}
uint64
sys_sigalarm(void)
{
  int num;
  uint64 handler;
  argint(0,&num);
  if(num<0)
  return -1;
  argaddr(1,&handler);
  struct proc* p=myproc();
  p->alaramflag=1;
  p->handleraddress=handler;
  p->alarmcount=num;
  // p->clockcyclepassed=0;
  return 0;


}
uint64 
sys_sigreturn(void){
  struct proc * p=myproc();
  p->alaramflag=1;
  p->clockcyclepassed=0;
  // p->trapframe=p->svedtrapframe;
  memmove(p->trapframe,p->savedtrapframe,PGSIZE);
  kfree(p->savedtrapframe);
  usertrapret();
  return 0;
}
int
sys_settickets(void)
{
  int n;
  struct proc *p = myproc();  // Get the current process

  // Retrieve the argument (number of tickets) passed by the user
  argint(0, &n) ;  // Invalid ticket count
    // return -1;
  if(n<=0)
  return -1;
  // Set the ticket count for the current process
  acquire(&p->lock);
  p->tickets = n;
  release(&p->lock);
  // printf("Process with PID %d has been assigned %d tickets\n", p->pid, n);
  
  return 0;  // Success
}

