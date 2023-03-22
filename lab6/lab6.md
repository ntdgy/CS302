1.  通过 `ebreak` 手动触发一个中断，然后在中断里面修改 `epc` 然后 `mask`掉 `SSTATUS_SPP` 这样，`eret` 之后就是 `usermode`了
2. 首先通过 `ecall` 进入到了 `trap handler` 然后被 `dispatch`到 `syscall`， 最后通过 `syscall id`调用相应的函数
3. `user mode` 的 `entry point` 定义在 `_start` 中， `_start` 会调用 `umain`
   其次，`umain` 中会调用 `main` 最后调用 `exit()`
   `exit()` 这个过程会发起 `syscall exit`
4. `exit` 之后 `parent proc` 没有在 `wait` ， 就设置进程状态为 `PROC_ZOMBIE`
   
