1. save context, handle exception/interrupt, restore context and return.

2. When a trap is taken into S-mode, sepc is written with the virtual address of the instruction that was interrupted or that encountered the exception. When return from trap, xRET sets the pc to the value stored in the xepc register.

3. ![image-20230308131344657](pic/image-20230308131344657.png)

  ![image-20230308131353044](pic/image-20230308131353044.png)

![image-20230308131426789](pic/image-20230308131426789.png)