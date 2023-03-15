#include <clock.h>
#include <console.h>
#include <defs.h>
#include <intr.h>
#include <kdebug.h>
#include <kmonitor.h>
#include <pmm.h>
#include <riscv.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <sbi.h>

int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);

    const char *message = "os is loading ...\n";
    cputs(message);
    idt_init();
    intr_enable();
    // asm volatile("ebreak"::);

    // cputs("start testing illegal instructions");
    // asm volatile("mret"::);
    // cputs("end testing illegal instructions");
    cputs("The system will close.\n");
    sbi_shutdown();




    clock_init(); 
    // ----------start-------------




    // -----------end--------------
    
    while (1)
        ;
}
