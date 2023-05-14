#include <stdio.h>
#include <proc.h>
#include <sem.h>
#include <assert.h>

#define N 5 /* 哲学家数目 */
#define LEFT (i-1+N)%N /* i的左邻号码 */
#define RIGHT (i+1)%N /* i的右邻号码 */
#define THINKING 0 /* 哲学家正在思考 */
#define HUNGRY 1 /* 哲学家想取得叉子 */
#define EATING 2 /* 哲学家正在吃面 */
#define TIMES  4 /* 吃4次饭 */
#define SLEEP_TIME 10

#define sem_wait down
#define sem_post up
#define sem_signal up
//---------- philosophers problem using semaphore ----------------------
int state_sema[N]; /* 记录每个人状态的数组 */
int request[N]; /* 记录每个人是否需要叉子 */
semaphore_t mutex; 
semaphore_t s[N]; 

struct proc_struct *philosopher_proc_sema[N];

//---------------part2-----------------
void phi_test_sema(int i) {
    if (state_sema[i] == 1 && !request[(i + 1) % N]) {
        state_sema[i] = 2;
        sem_signal(&s[i]);
    } else if (state_sema[i] == 1 && !request[(i + N - 1) % N]) {
        state_sema[i] = 2;
        sem_signal(&s[(i + N - 1) % N]);
    }
}

void phi_take_forks_sema(int i) {
    sem_wait(&mutex);
    state_sema[i] = 1;
    phi_test_sema(i);
    sem_post(&mutex);
    sem_wait(&s[i]);
}

void phi_put_forks_sema(int i) {
    sem_wait(&mutex);
    state_sema[i] = 0;
    phi_test_sema((i + N - 1) % N);
    phi_test_sema((i + 1) % N);
    sem_post(&mutex);
}
//---------------end-----------------


//---------------part1-----------------
// void phi_take_forks_sema(int i) 
// { 
//         down(&mutex); 
//         down(&s[i]); 
//         down(&s[RIGHT]);
//         up(&mutex); 
// }

// void phi_put_forks_sema(int i) 
// { 
//         up(&s[RIGHT]); 
//         up(&s[i]);
// }
// //---------------end-----------------

int philosopher_using_semaphore(void * arg) 
{
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_sema\n",i);
    while(iter++<TIMES)
    { 
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); 
        do_sleep(SLEEP_TIME);
        phi_take_forks_sema(i); 
      
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); 
        

        do_sleep(SLEEP_TIME);
        phi_put_forks_sema(i); 

    }
    cprintf("No.%d philosopher_sema quit\n",i);
    return 0;    
}



void check_sync(void){
    int i;
    //check semaphore
    sem_init(&mutex, 1);
    for(i=0;i<N;i++){
        sem_init(&s[i], 1);
        int pid = kernel_thread(philosopher_using_semaphore, (void *)i, 0);
        if (pid <= 0) {
            panic("create No.%d philosopher_using_semaphore failed.\n");
        }
        philosopher_proc_sema[i] = find_proc(pid);
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
    }
}
