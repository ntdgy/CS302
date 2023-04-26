1. 1个, 管理该进程的的所有⻚表 
2.  管理⼀块连续的 Virtual Memory 
3.  访问不在⻚表中的地址, 或者在usermode下访问⾮usermode可操作的⻚表 
4.  访问的虚拟地址内容不在内存中，需要swap in![image-20230426161224989](pic/lab11.md)
5. swapin: 访问的虚拟地址内容不在内存中 swapout: page塞满了需要腾出空间来