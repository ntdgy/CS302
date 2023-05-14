1. polling:
    
    Pros:  1. simple to implement

         2. maybe more efficient when a device is frequently reached and checked

     Cons: 1. consumes cpu time waiting for io
          	  2.  may make the system response late
    
    
    
    Interrupt-based I/O:
     Pros: 1. Allow cpu to perform other tasks when waiting for io
    
                   2. system can response to other events when waiting for io
    
     cons: 1. more complex to implement
                2. if the device is frequently reached, the context switch will cost more time than waiting

2. | PIO                                                    | DMA                                                          |
   | ------------------------------------------------------ | ------------------------------------------------------------ |
   | cpu directly controls the tranfer of data              | a independent controller from cpu                            |
   | perform data tranfer and wait for io or context switch | faster, allow cpu to perform other tasks                     |
   | do not need additional hardware                        | requires additional hardware and software to manage data transfer |
   | can be used for almost all devices                     | limited to devices supporting DMA transfers                  |

3. 

   1. limit user level access to memory, only allow privileged processes directly access devices

   2. hardware protection: some devices provides a privileged bit to indicate the identity of access
   3. Input validation: check the invalidation of the input params and ensure they are in their range
