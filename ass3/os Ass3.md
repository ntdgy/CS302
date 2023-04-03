Ass3:

(1).

1. Virtualization: Process Management, Memory Management. 
   This allows multiple operating systems or applications to run on the same physical machine without interfering with each other
2. Concurrency : Process Synchronization
   make process synchronized when accessing shared resources
3. Persistence -> Storage Management & File System 
   store information in persistent media

(2).

1. Save the current state
2. jump into kernel codes
3. handle IO or handle syscall
4. Select a new process or thread
5. Load the new state
6. Resume execution

(3). 
			1.

  		1. System call mechanism: makes a system call to the kernel by executing an interrupt instruction, switches the CPU into kernel mode
  		2. PCB: kernel creates a new Process Control Block
  		3. memory allocation: kernel creates a new address space for the child process. copy the parent process's address space
  		4. CPU scheduler: The kernel adds the child process to the list of running processes in the CPU scheduler. 
  		5. Context switch: kernel performs a context switch to switch from the parent process to the child process
  		6. Return values of the system call: parent return child's pid, and child return 0

​	2.

	1. System call mechanism: The CPU transitions from user mode to kernel mode and the kernel takes over control.
	1. PCB update: The kernel updates the process state of PCB of the process to terminate.
	1. Zombie state: it has terminated, but the kernel has not yet released all of its resources.
	1. Wait() system call: The parent process can call the wait() system call to retrieve the exit status of the child process
	1. Release resources: kernel release the remaining resources of the child process

(4). 

	1. syscall (traps): called by user initiatively, synchronized to cpu clock, request a service from the operating system
	1. exceptions: an event that occurs during the execution of a program that requires the attention of the operating system
	1. Interrupts: a signal sent by a hardware device,  asynchronous to cpu clock

(5).

![image-20230402202420489](pic\image-20230402202420489.png)

 1. New: The process is being created by the operating system.

 2. Ready: The process is waiting to be executed by the CPU

 3. Running: The process is currently executing on the CPU

 4. running -> ready: this process is scheduled away from CPU, and be ready to run on CPU

 5. Blocked: The process is waiting for an event or resource

 6. waiting -> running: IO or events completed, this process is ready to return from blocking IO requests

 7. Terminated: The process has completed execution

    



