// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

int refscount[1000000] = {0};
struct spinlock ref_lock;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&ref_lock, "ref_lock");
  acquire(&ref_lock);
  for (int i = 0;i < 1000000;i++) {
    refscount[i] = 1;
  }
  release(&ref_lock);
  freerange(end, (void*)PHYSTOP);
}
// int iter = 0;

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    // iter++;
    struct run *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

    int present = -1;
    acquire(&ref_lock);
    present = refscount[getindex(pa)];
    release(&ref_lock);
    // if (present <= 0) panic("kfreee");

    decr_refs(pa);
    acquire(&ref_lock);
    present = refscount[getindex(pa)];
    release(&ref_lock);
    if (present <= 0) {

        // Fill with junk to catch dangling refs.
        memset(pa, 1, PGSIZE);

        r = (struct run*)pa;

        acquire(&kmem.lock);
        r->next = kmem.freelist;
        kmem.freelist = r;
        release(&kmem.lock);
        acquire(&ref_lock);
        refscount[getindex(r)] = 0;
        release(&ref_lock);
    }
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    acquire(&ref_lock);
    refscount[getindex(r)] = 1;
    release(&ref_lock);
  }
  return (void*)r;
}

void add_refs(void* pa) {
    acquire(&ref_lock);
    refscount[getindex(pa)]++;
    release(&ref_lock);
}

void decr_refs(void* pa) {
    acquire(&ref_lock);
    refscount[getindex(pa)]--;
    release(&ref_lock);
}

int getindex(void* pa) {
    uint64 index = (uint64)pa;
    index >>= 12;
    // index -= KERNBASE;
    // index /= PGSIZE;
    return index;
}
