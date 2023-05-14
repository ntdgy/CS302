#ifndef __KERN_SYNC_MONITOR_CONDVAR_H__
#define __KERN_SYNC_MOINTOR_CONDVAR_H__

#include <sem.h>
typedef struct monitor monitor_t;


typedef struct condvar{
//================your code=====================
    semaphore_t sem;       
    int count;  
    monitor_t *owner;            
} condvar_t;

typedef struct monitor {
//================your code=====================
    semaphore_t mutex;
    semaphore_t next;
    int next_count;     
    condvar_t *cv;  
} monitor_t;



void     cond_init (condvar_t *cvp);

void     cond_signal (condvar_t *cvp);

void     cond_wait (condvar_t *cvp, semaphore_t *mutex);
     
#endif /* !__KERN_SYNC_MONITOR_CONDVAR_H__ */
