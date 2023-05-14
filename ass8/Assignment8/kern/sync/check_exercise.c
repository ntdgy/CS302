// kern/sync/check_exercise.c
#include <stdio.h>
#include <proc.h>
#include <sem.h>
#include <assert.h>
#include <condvar.h>

struct proc_struct *pworker1,*pworker2,*pworker3;


void worker1(int i)
{
    while (1)
    {   
        cprintf("make a bike rack\n");

    }
}


void worker2(int i)
{
    while (1)
    {        
        cprintf("make two wheels\n");
    }
}




void worker3(int i){
    while (1)
    {
        cprintf("assemble a bike\n");
    }
}


void check_exercise(void){

	//initial
	
	
    int pids[3];
    int i =0;
    pids[0]=kernel_thread(worker1, (void *)i, 0);
    pids[1]=kernel_thread(worker2, (void *)i, 0);
    pids[2]=kernel_thread(worker3, (void *)i, 0);
    pworker1 = find_proc(pids[0]);
    set_proc_name(pworker1, "worker1");
    pworker2 = find_proc(pids[1]);
    set_proc_name(pworker2, "worker2");
    pworker3 = find_proc(pids[2]);
    set_proc_name(pworker3, "worker3");
}
