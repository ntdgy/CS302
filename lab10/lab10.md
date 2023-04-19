1.

Offset = VA[11:0] 

VPN0 = VA[21:12] 

VPN1 = VA[31:22] 

VPN2 = VA[38:30] 

Step 1: Find 1st PTE at PA: [ satp.PPN | VPN2 ] 

Step 2: if 1st PTE points to next level of page table: 

​	Find 2nd PTE at PA: [ 1st PTE.PPN | VPN1 ] 

Step 3: if 2nd PTE points to next level of page table: 

​	Find 3rd PTE at PA: [2nd PTE.PPN | VPN 0] 

Step 4: Finally translated PA: [3rd.PPN | Offset]

2.

2^(12 bits + 9 bits) = 2^21 bits = 2048 KiB = 2MiB

3.

PTE_size = 4KiB / (2^10) entries = 4 B per PTE entry 

4 MiB = 2^22 B 

3张 level 2, ⼀张 level 1

4.

page2kva: page 2 kernel virtual address 

Step 1: calculate PPN 

Step 2: calculate corresponding PA 

Step 3: add a VA_PA_offset, convert it into a virtual address mapped in kernel virtual space