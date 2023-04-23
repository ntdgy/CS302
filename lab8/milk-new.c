/*dad_mem_mutex.c*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <time.h> 
#include <sys/stat.h>

int milk = 0;
pthread_mutex_t mutex;
pthread_cond_t cond;
#define LOCK pthread_mutex_lock(&mutex)
#define TRYLOCK pthread_mutex_trylock(&mutex)
#define UNLOCK pthread_mutex_unlock(&mutex)
#define WAIT pthread_cond_wait(&cond, &mutex)
#define SIGNAL pthread_cond_signal(&cond)

void *mom(){
    while (1){
        TRYLOCK;
        printf("Mon adds lock.\n");
        while(milk>0){
            printf("Mom is waiting for the fridge.\n");
            WAIT;
        }
        milk++;
        printf("Mom puts milk in fridge and leaves, and remaining milk is %d.\n", milk);
        UNLOCK;
    }
}


void *sister(){
    while (1){
        TRYLOCK;
        printf("Sister adds lock.\n");
        while(milk>0){
            printf("Sister is waiting for the fridge.\n");
            WAIT;
        }
        milk++;
        printf("Sister puts milk in fridge and leaves, and remaining milk is %d.\n", milk);
        UNLOCK;
    }
}


void *dad(){
    while (1){
        TRYLOCK;
        printf("Dad adds lock.\n");
        if (milk>0){
            milk--;
            printf("Dad takes milk from fridge and leaves, and remaining milk is %d.\n", milk);
        }else{
            printf("Dad closes the fridge and leaves.\n");
            SIGNAL;
        }
        printf("Dad removes lock.\n");
        UNLOCK;
        sleep(rand()%2+1);
    }
}

void *me(){
    while (1){
        TRYLOCK;
        printf("me adds lock.\n");
        if (milk>0){
            milk--;
            printf("me takes milk from fridge and leaves, and remaining milk is %d.\n", milk);
        }else{
            printf("me closes the fridge and leaves.\n");
            SIGNAL;
        }
        printf("me removes lock.\n");
        UNLOCK;
        sleep(rand()%2+1);
    }
}


int main(int argc, char * argv[]) {
    srand(time(0));
    pthread_t p1, p2, p3, p4;
    int fd = open("fridge", O_CREAT|O_RDWR|O_TRUNC , 0777);  //empty the fridge
    close(fd);
    // Create two threads (both run func)  
    pthread_create(&p1, NULL, mom, NULL); 
    pthread_create(&p2, NULL, dad, NULL); 
    pthread_create(&p3, NULL, sister, NULL);
    pthread_create(&p4, NULL, me, NULL);
  
    // Wait for the threads to end. 
    pthread_join(p1, NULL); 
    pthread_join(p2, NULL); 
    pthread_join(p3, NULL);
    pthread_join(p4, NULL);
}
