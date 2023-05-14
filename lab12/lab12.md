 

1.  local_intr_save(intr_flag);  `local_intr_save` 宏会将 `intr_flag` 的值设置为当前中断状态，并将中断禁止。
2. 这个算法采用了信号量来实现多进程之间的同步，哲学家先尝试获取互斥锁，然后通过修改信号量来使得自己成功获取到叉子。如果哲学家没有获取到叉子，由于其不会释放锁，所以会等待其他人释放叉子之后才会继续下去，其他人也会在获得锁之后尝试获取叉子，因此不会造成死锁。
3. ![image-20230506173116292](/home/dgy/.config/Typora/typora-user-images/image-20230506173116292.png)
   

![image-20230506173209032](/home/dgy/.config/Typora/typora-user-images/image-20230506173209032.png)
