#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    pid_t pid = fork();
    if (pid < 0) {
        printf("Fork error\n");
        exit(1);
    } else if (pid == 0) {
        // 子进程
        printf("I'm the child process\n");
        exit(0);
    } else {
        // 父进程
        printf("I'm the parent process\n");
        sleep(10);
    }
    return 0;
}
