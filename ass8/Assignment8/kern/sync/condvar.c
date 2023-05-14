#include <stdio.h>
#include <condvar.h>
#include <kmalloc.h>
#include <assert.h>


void     
cond_init (condvar_t *cvp) {
    monitor_t * mtp = (monitor_t *)kmalloc(sizeof(monitor_t));
    mtp->next_count = 0;
    mtp->cv = cvp;
    sem_init(&(mtp->mutex), 1);
    sem_init(&(mtp->next), 0);
    cvp->count = 0;
    cvp->owner = mtp;
    sem_init(&(cvp->sem), 0);
}

void 
cond_signal (condvar_t *cvp) {
    // cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
    /*
     *      cond_signal(cv) {
     *          if(cv.count>0) {
     *             mt.next_count ++;
     *             signal(cv.sem);
     *             wait(mt.next);
     *             mt.next_count--;
     *          }
     *       }
     */
    if(cvp->count>0) {
        cvp->owner->next_count ++;
        up(&(cvp->sem));
        down(&(cvp->owner->next));
        cvp->owner->next_count --;
    }
    // cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}

void
cond_wait (condvar_t *cvp, semaphore_t *mutex) {
    // cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
    /*
     *         cv.count ++;
     *         if(mt.next_count>0)
     *            signal(mt.next)
     *         else
     *            signal(mt.mutex);
     *         wait(cv.sem);
     *         cv.count --;
     */

    cvp->count++;
    if(cvp->owner->next_count > 0)
        up(&(cvp->owner->next));
    else
        up(&(cvp->owner->mutex));
    up(mutex);
    down(&(cvp->sem));
    cvp->count --;

    // cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}   