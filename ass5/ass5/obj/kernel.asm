
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop
    80200000:	00005117          	auipc	sp,0x5
    80200004:	00010113          	mv	sp,sp

    tail kern_init
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
void grade_backtrace(void);
static void lab1_switch_test(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    8020000a:	00005517          	auipc	a0,0x5
    8020000e:	ffe50513          	add	a0,a0,-2 # 80205008 <free_area1>
    80200012:	00005617          	auipc	a2,0x5
    80200016:	04660613          	add	a2,a2,70 # 80205058 <end>
int kern_init(void) {
    8020001a:	1141                	add	sp,sp,-16 # 80204ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
int kern_init(void) {
    80200020:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
    80200022:	532010ef          	jal	80201554 <memset>
    cons_init();  // init the console
    80200026:	138000ef          	jal	8020015e <cons_init>
    const char *message = "os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
    8020002a:	00001517          	auipc	a0,0x1
    8020002e:	53e50513          	add	a0,a0,1342 # 80201568 <etext+0x2>
    80200032:	086000ef          	jal	802000b8 <cputs>


    idt_init();  // init interrupt descriptor table
    80200036:	13e000ef          	jal	80200174 <idt_init>

    pmm_init();  // init physical memory management
    8020003a:	781000ef          	jal	80200fba <pmm_init>

    idt_init();  // init interrupt descriptor table
    8020003e:	136000ef          	jal	80200174 <idt_init>

    intr_enable();  // enable irq interrupt
    80200042:	126000ef          	jal	80200168 <intr_enable>


    /* do nothing */
    while (1)
    80200046:	a001                	j	80200046 <kern_init+0x3c>

0000000080200048 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
    80200048:	1141                	add	sp,sp,-16
    8020004a:	e022                	sd	s0,0(sp)
    8020004c:	e406                	sd	ra,8(sp)
    8020004e:	842e                	mv	s0,a1
    cons_putc(c);
    80200050:	110000ef          	jal	80200160 <cons_putc>
    (*cnt) ++;
    80200054:	401c                	lw	a5,0(s0)
}
    80200056:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
    80200058:	2785                	addw	a5,a5,1
    8020005a:	c01c                	sw	a5,0(s0)
}
    8020005c:	6402                	ld	s0,0(sp)
    8020005e:	0141                	add	sp,sp,16
    80200060:	8082                	ret

0000000080200062 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
    80200062:	1101                	add	sp,sp,-32
    80200064:	862a                	mv	a2,a0
    80200066:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
    80200068:	00000517          	auipc	a0,0x0
    8020006c:	fe050513          	add	a0,a0,-32 # 80200048 <cputch>
    80200070:	006c                	add	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
    80200072:	ec06                	sd	ra,24(sp)
    int cnt = 0;
    80200074:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
    80200076:	112010ef          	jal	80201188 <vprintfmt>
    return cnt;
}
    8020007a:	60e2                	ld	ra,24(sp)
    8020007c:	4532                	lw	a0,12(sp)
    8020007e:	6105                	add	sp,sp,32
    80200080:	8082                	ret

0000000080200082 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
    80200082:	711d                	add	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    80200084:	02810313          	add	t1,sp,40
cprintf(const char *fmt, ...) {
    80200088:	8e2a                	mv	t3,a0
    8020008a:	f42e                	sd	a1,40(sp)
    8020008c:	f832                	sd	a2,48(sp)
    8020008e:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
    80200090:	00000517          	auipc	a0,0x0
    80200094:	fb850513          	add	a0,a0,-72 # 80200048 <cputch>
    80200098:	004c                	add	a1,sp,4
    8020009a:	869a                	mv	a3,t1
    8020009c:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
    8020009e:	ec06                	sd	ra,24(sp)
    802000a0:	e0ba                	sd	a4,64(sp)
    802000a2:	e4be                	sd	a5,72(sp)
    802000a4:	e8c2                	sd	a6,80(sp)
    802000a6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
    802000a8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
    802000aa:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
    802000ac:	0dc010ef          	jal	80201188 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
    802000b0:	60e2                	ld	ra,24(sp)
    802000b2:	4512                	lw	a0,4(sp)
    802000b4:	6125                	add	sp,sp,96
    802000b6:	8082                	ret

00000000802000b8 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
    802000b8:	1101                	add	sp,sp,-32
    802000ba:	ec06                	sd	ra,24(sp)
    802000bc:	e822                	sd	s0,16(sp)
    802000be:	e426                	sd	s1,8(sp)
    802000c0:	87aa                	mv	a5,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
    802000c2:	00054503          	lbu	a0,0(a0)
    802000c6:	c51d                	beqz	a0,802000f4 <cputs+0x3c>
    802000c8:	00178493          	add	s1,a5,1
    802000cc:	8426                	mv	s0,s1
    cons_putc(c);
    802000ce:	092000ef          	jal	80200160 <cons_putc>
    while ((c = *str ++) != '\0') {
    802000d2:	00044503          	lbu	a0,0(s0)
    802000d6:	87a2                	mv	a5,s0
    802000d8:	0405                	add	s0,s0,1
    802000da:	f975                	bnez	a0,802000ce <cputs+0x16>
    (*cnt) ++;
    802000dc:	9f85                	subw	a5,a5,s1
    802000de:	0027841b          	addw	s0,a5,2
    cons_putc(c);
    802000e2:	4529                	li	a0,10
    802000e4:	07c000ef          	jal	80200160 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
    802000e8:	60e2                	ld	ra,24(sp)
    802000ea:	8522                	mv	a0,s0
    802000ec:	6442                	ld	s0,16(sp)
    802000ee:	64a2                	ld	s1,8(sp)
    802000f0:	6105                	add	sp,sp,32
    802000f2:	8082                	ret
    while ((c = *str ++) != '\0') {
    802000f4:	4405                	li	s0,1
    802000f6:	b7f5                	j	802000e2 <cputs+0x2a>

00000000802000f8 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
    802000f8:	00005317          	auipc	t1,0x5
    802000fc:	f2830313          	add	t1,t1,-216 # 80205020 <is_panic>
    80200100:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
    80200104:	715d                	add	sp,sp,-80
    80200106:	ec06                	sd	ra,24(sp)
    80200108:	e822                	sd	s0,16(sp)
    8020010a:	f436                	sd	a3,40(sp)
    8020010c:	f83a                	sd	a4,48(sp)
    8020010e:	fc3e                	sd	a5,56(sp)
    80200110:	e0c2                	sd	a6,64(sp)
    80200112:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
    80200114:	020e1a63          	bnez	t3,80200148 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
    80200118:	4785                	li	a5,1
    8020011a:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    8020011e:	8432                	mv	s0,a2
    80200120:	103c                	add	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
    80200122:	862e                	mv	a2,a1
    80200124:	85aa                	mv	a1,a0
    80200126:	00001517          	auipc	a0,0x1
    8020012a:	45a50513          	add	a0,a0,1114 # 80201580 <etext+0x1a>
    va_start(ap, fmt);
    8020012e:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
    80200130:	f53ff0ef          	jal	80200082 <cprintf>
    vcprintf(fmt, ap);
    80200134:	65a2                	ld	a1,8(sp)
    80200136:	8522                	mv	a0,s0
    80200138:	f2bff0ef          	jal	80200062 <vcprintf>
    cprintf("\n");
    8020013c:	00002517          	auipc	a0,0x2
    80200140:	87c50513          	add	a0,a0,-1924 # 802019b8 <etext+0x452>
    80200144:	f3fff0ef          	jal	80200082 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
    80200148:	026000ef          	jal	8020016e <intr_disable>
    while (1) {
    8020014c:	a001                	j	8020014c <__panic+0x54>

000000008020014e <clock_set_next_event>:
volatile size_t ticks;

static inline uint64_t get_cycles(void) {
#if __riscv_xlen == 64
    uint64_t n;
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    8020014e:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    80200152:	67e1                	lui	a5,0x18
    80200154:	6a078793          	add	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200158:	953e                	add	a0,a0,a5
    8020015a:	3c40106f          	j	8020151e <sbi_set_timer>

000000008020015e <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
    8020015e:	8082                	ret

0000000080200160 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
    80200160:	0ff57513          	zext.b	a0,a0
    80200164:	3a00106f          	j	80201504 <sbi_console_putchar>

0000000080200168 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
    80200168:	100167f3          	csrrs	a5,sstatus,2
    8020016c:	8082                	ret

000000008020016e <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
    8020016e:	100177f3          	csrrc	a5,sstatus,2
    80200172:	8082                	ret

0000000080200174 <idt_init>:
/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S
 */
void idt_init(void) {
    extern void __alltraps(void);

    write_csr(sscratch, 0);
    80200174:	14005073          	csrw	sscratch,0
    
    write_csr(stvec, &__alltraps);
    80200178:	00000797          	auipc	a5,0x0
    8020017c:	2e478793          	add	a5,a5,740 # 8020045c <__alltraps>
    80200180:	10579073          	csrw	stvec,a5
}
    80200184:	8082                	ret

0000000080200186 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200186:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    80200188:	1141                	add	sp,sp,-16
    8020018a:	e022                	sd	s0,0(sp)
    8020018c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    8020018e:	00001517          	auipc	a0,0x1
    80200192:	41250513          	add	a0,a0,1042 # 802015a0 <etext+0x3a>
void print_regs(struct pushregs *gpr) {
    80200196:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200198:	eebff0ef          	jal	80200082 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    8020019c:	640c                	ld	a1,8(s0)
    8020019e:	00001517          	auipc	a0,0x1
    802001a2:	41a50513          	add	a0,a0,1050 # 802015b8 <etext+0x52>
    802001a6:	eddff0ef          	jal	80200082 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001aa:	680c                	ld	a1,16(s0)
    802001ac:	00001517          	auipc	a0,0x1
    802001b0:	42450513          	add	a0,a0,1060 # 802015d0 <etext+0x6a>
    802001b4:	ecfff0ef          	jal	80200082 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001b8:	6c0c                	ld	a1,24(s0)
    802001ba:	00001517          	auipc	a0,0x1
    802001be:	42e50513          	add	a0,a0,1070 # 802015e8 <etext+0x82>
    802001c2:	ec1ff0ef          	jal	80200082 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001c6:	700c                	ld	a1,32(s0)
    802001c8:	00001517          	auipc	a0,0x1
    802001cc:	43850513          	add	a0,a0,1080 # 80201600 <etext+0x9a>
    802001d0:	eb3ff0ef          	jal	80200082 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001d4:	740c                	ld	a1,40(s0)
    802001d6:	00001517          	auipc	a0,0x1
    802001da:	44250513          	add	a0,a0,1090 # 80201618 <etext+0xb2>
    802001de:	ea5ff0ef          	jal	80200082 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001e2:	780c                	ld	a1,48(s0)
    802001e4:	00001517          	auipc	a0,0x1
    802001e8:	44c50513          	add	a0,a0,1100 # 80201630 <etext+0xca>
    802001ec:	e97ff0ef          	jal	80200082 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    802001f0:	7c0c                	ld	a1,56(s0)
    802001f2:	00001517          	auipc	a0,0x1
    802001f6:	45650513          	add	a0,a0,1110 # 80201648 <etext+0xe2>
    802001fa:	e89ff0ef          	jal	80200082 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    802001fe:	602c                	ld	a1,64(s0)
    80200200:	00001517          	auipc	a0,0x1
    80200204:	46050513          	add	a0,a0,1120 # 80201660 <etext+0xfa>
    80200208:	e7bff0ef          	jal	80200082 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    8020020c:	642c                	ld	a1,72(s0)
    8020020e:	00001517          	auipc	a0,0x1
    80200212:	46a50513          	add	a0,a0,1130 # 80201678 <etext+0x112>
    80200216:	e6dff0ef          	jal	80200082 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    8020021a:	682c                	ld	a1,80(s0)
    8020021c:	00001517          	auipc	a0,0x1
    80200220:	47450513          	add	a0,a0,1140 # 80201690 <etext+0x12a>
    80200224:	e5fff0ef          	jal	80200082 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    80200228:	6c2c                	ld	a1,88(s0)
    8020022a:	00001517          	auipc	a0,0x1
    8020022e:	47e50513          	add	a0,a0,1150 # 802016a8 <etext+0x142>
    80200232:	e51ff0ef          	jal	80200082 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200236:	702c                	ld	a1,96(s0)
    80200238:	00001517          	auipc	a0,0x1
    8020023c:	48850513          	add	a0,a0,1160 # 802016c0 <etext+0x15a>
    80200240:	e43ff0ef          	jal	80200082 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200244:	742c                	ld	a1,104(s0)
    80200246:	00001517          	auipc	a0,0x1
    8020024a:	49250513          	add	a0,a0,1170 # 802016d8 <etext+0x172>
    8020024e:	e35ff0ef          	jal	80200082 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    80200252:	782c                	ld	a1,112(s0)
    80200254:	00001517          	auipc	a0,0x1
    80200258:	49c50513          	add	a0,a0,1180 # 802016f0 <etext+0x18a>
    8020025c:	e27ff0ef          	jal	80200082 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    80200260:	7c2c                	ld	a1,120(s0)
    80200262:	00001517          	auipc	a0,0x1
    80200266:	4a650513          	add	a0,a0,1190 # 80201708 <etext+0x1a2>
    8020026a:	e19ff0ef          	jal	80200082 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    8020026e:	604c                	ld	a1,128(s0)
    80200270:	00001517          	auipc	a0,0x1
    80200274:	4b050513          	add	a0,a0,1200 # 80201720 <etext+0x1ba>
    80200278:	e0bff0ef          	jal	80200082 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    8020027c:	644c                	ld	a1,136(s0)
    8020027e:	00001517          	auipc	a0,0x1
    80200282:	4ba50513          	add	a0,a0,1210 # 80201738 <etext+0x1d2>
    80200286:	dfdff0ef          	jal	80200082 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    8020028a:	684c                	ld	a1,144(s0)
    8020028c:	00001517          	auipc	a0,0x1
    80200290:	4c450513          	add	a0,a0,1220 # 80201750 <etext+0x1ea>
    80200294:	defff0ef          	jal	80200082 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    80200298:	6c4c                	ld	a1,152(s0)
    8020029a:	00001517          	auipc	a0,0x1
    8020029e:	4ce50513          	add	a0,a0,1230 # 80201768 <etext+0x202>
    802002a2:	de1ff0ef          	jal	80200082 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002a6:	704c                	ld	a1,160(s0)
    802002a8:	00001517          	auipc	a0,0x1
    802002ac:	4d850513          	add	a0,a0,1240 # 80201780 <etext+0x21a>
    802002b0:	dd3ff0ef          	jal	80200082 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002b4:	744c                	ld	a1,168(s0)
    802002b6:	00001517          	auipc	a0,0x1
    802002ba:	4e250513          	add	a0,a0,1250 # 80201798 <etext+0x232>
    802002be:	dc5ff0ef          	jal	80200082 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002c2:	784c                	ld	a1,176(s0)
    802002c4:	00001517          	auipc	a0,0x1
    802002c8:	4ec50513          	add	a0,a0,1260 # 802017b0 <etext+0x24a>
    802002cc:	db7ff0ef          	jal	80200082 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002d0:	7c4c                	ld	a1,184(s0)
    802002d2:	00001517          	auipc	a0,0x1
    802002d6:	4f650513          	add	a0,a0,1270 # 802017c8 <etext+0x262>
    802002da:	da9ff0ef          	jal	80200082 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002de:	606c                	ld	a1,192(s0)
    802002e0:	00001517          	auipc	a0,0x1
    802002e4:	50050513          	add	a0,a0,1280 # 802017e0 <etext+0x27a>
    802002e8:	d9bff0ef          	jal	80200082 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002ec:	646c                	ld	a1,200(s0)
    802002ee:	00001517          	auipc	a0,0x1
    802002f2:	50a50513          	add	a0,a0,1290 # 802017f8 <etext+0x292>
    802002f6:	d8dff0ef          	jal	80200082 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    802002fa:	686c                	ld	a1,208(s0)
    802002fc:	00001517          	auipc	a0,0x1
    80200300:	51450513          	add	a0,a0,1300 # 80201810 <etext+0x2aa>
    80200304:	d7fff0ef          	jal	80200082 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    80200308:	6c6c                	ld	a1,216(s0)
    8020030a:	00001517          	auipc	a0,0x1
    8020030e:	51e50513          	add	a0,a0,1310 # 80201828 <etext+0x2c2>
    80200312:	d71ff0ef          	jal	80200082 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200316:	706c                	ld	a1,224(s0)
    80200318:	00001517          	auipc	a0,0x1
    8020031c:	52850513          	add	a0,a0,1320 # 80201840 <etext+0x2da>
    80200320:	d63ff0ef          	jal	80200082 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200324:	746c                	ld	a1,232(s0)
    80200326:	00001517          	auipc	a0,0x1
    8020032a:	53250513          	add	a0,a0,1330 # 80201858 <etext+0x2f2>
    8020032e:	d55ff0ef          	jal	80200082 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    80200332:	786c                	ld	a1,240(s0)
    80200334:	00001517          	auipc	a0,0x1
    80200338:	53c50513          	add	a0,a0,1340 # 80201870 <etext+0x30a>
    8020033c:	d47ff0ef          	jal	80200082 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200340:	7c6c                	ld	a1,248(s0)
}
    80200342:	6402                	ld	s0,0(sp)
    80200344:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200346:	00001517          	auipc	a0,0x1
    8020034a:	54250513          	add	a0,a0,1346 # 80201888 <etext+0x322>
}
    8020034e:	0141                	add	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200350:	bb0d                	j	80200082 <cprintf>

0000000080200352 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    80200352:	1141                	add	sp,sp,-16
    80200354:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200356:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    80200358:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    8020035a:	00001517          	auipc	a0,0x1
    8020035e:	54650513          	add	a0,a0,1350 # 802018a0 <etext+0x33a>
void print_trapframe(struct trapframe *tf) {
    80200362:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200364:	d1fff0ef          	jal	80200082 <cprintf>
    print_regs(&tf->gpr);
    80200368:	8522                	mv	a0,s0
    8020036a:	e1dff0ef          	jal	80200186 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    8020036e:	10043583          	ld	a1,256(s0)
    80200372:	00001517          	auipc	a0,0x1
    80200376:	54650513          	add	a0,a0,1350 # 802018b8 <etext+0x352>
    8020037a:	d09ff0ef          	jal	80200082 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    8020037e:	10843583          	ld	a1,264(s0)
    80200382:	00001517          	auipc	a0,0x1
    80200386:	54e50513          	add	a0,a0,1358 # 802018d0 <etext+0x36a>
    8020038a:	cf9ff0ef          	jal	80200082 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    8020038e:	11043583          	ld	a1,272(s0)
    80200392:	00001517          	auipc	a0,0x1
    80200396:	55650513          	add	a0,a0,1366 # 802018e8 <etext+0x382>
    8020039a:	ce9ff0ef          	jal	80200082 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    8020039e:	11843583          	ld	a1,280(s0)
}
    802003a2:	6402                	ld	s0,0(sp)
    802003a4:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003a6:	00001517          	auipc	a0,0x1
    802003aa:	55a50513          	add	a0,a0,1370 # 80201900 <etext+0x39a>
}
    802003ae:	0141                	add	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b0:	b9c9                	j	80200082 <cprintf>

00000000802003b2 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
    802003b2:	11853783          	ld	a5,280(a0)
    802003b6:	472d                	li	a4,11
    802003b8:	0786                	sll	a5,a5,0x1
    802003ba:	8385                	srl	a5,a5,0x1
    802003bc:	06f76c63          	bltu	a4,a5,80200434 <interrupt_handler+0x82>
    802003c0:	00001717          	auipc	a4,0x1
    802003c4:	62070713          	add	a4,a4,1568 # 802019e0 <etext+0x47a>
    802003c8:	078a                	sll	a5,a5,0x2
    802003ca:	97ba                	add	a5,a5,a4
    802003cc:	439c                	lw	a5,0(a5)
    802003ce:	97ba                	add	a5,a5,a4
    802003d0:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003d2:	00001517          	auipc	a0,0x1
    802003d6:	5a650513          	add	a0,a0,1446 # 80201978 <etext+0x412>
    802003da:	b165                	j	80200082 <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003dc:	00001517          	auipc	a0,0x1
    802003e0:	57c50513          	add	a0,a0,1404 # 80201958 <etext+0x3f2>
    802003e4:	b979                	j	80200082 <cprintf>
            cprintf("User software interrupt\n");
    802003e6:	00001517          	auipc	a0,0x1
    802003ea:	53250513          	add	a0,a0,1330 # 80201918 <etext+0x3b2>
    802003ee:	b951                	j	80200082 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
    802003f0:	00001517          	auipc	a0,0x1
    802003f4:	5a850513          	add	a0,a0,1448 # 80201998 <etext+0x432>
    802003f8:	b169                	j	80200082 <cprintf>
void interrupt_handler(struct trapframe *tf) {
    802003fa:	1141                	add	sp,sp,-16
    802003fc:	e406                	sd	ra,8(sp)
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
    802003fe:	d51ff0ef          	jal	8020014e <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
    80200402:	00005697          	auipc	a3,0x5
    80200406:	c2668693          	add	a3,a3,-986 # 80205028 <ticks>
    8020040a:	629c                	ld	a5,0(a3)
    8020040c:	06400713          	li	a4,100
    80200410:	0785                	add	a5,a5,1
    80200412:	02e7f733          	remu	a4,a5,a4
    80200416:	e29c                	sd	a5,0(a3)
    80200418:	cf19                	beqz	a4,80200436 <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    8020041a:	60a2                	ld	ra,8(sp)
    8020041c:	0141                	add	sp,sp,16
    8020041e:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    80200420:	00001517          	auipc	a0,0x1
    80200424:	5a050513          	add	a0,a0,1440 # 802019c0 <etext+0x45a>
    80200428:	b9a9                	j	80200082 <cprintf>
            cprintf("Supervisor software interrupt\n");
    8020042a:	00001517          	auipc	a0,0x1
    8020042e:	50e50513          	add	a0,a0,1294 # 80201938 <etext+0x3d2>
    80200432:	b981                	j	80200082 <cprintf>
            print_trapframe(tf);
    80200434:	bf39                	j	80200352 <print_trapframe>
}
    80200436:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
    80200438:	06400593          	li	a1,100
    8020043c:	00001517          	auipc	a0,0x1
    80200440:	57450513          	add	a0,a0,1396 # 802019b0 <etext+0x44a>
}
    80200444:	0141                	add	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
    80200446:	b935                	j	80200082 <cprintf>

0000000080200448 <trap>:
            break;
    }
}

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    80200448:	11853783          	ld	a5,280(a0)
    8020044c:	0007c763          	bltz	a5,8020045a <trap+0x12>
    switch (tf->cause) {
    80200450:	472d                	li	a4,11
    80200452:	00f76363          	bltu	a4,a5,80200458 <trap+0x10>
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
}
    80200456:	8082                	ret
            print_trapframe(tf);
    80200458:	bded                	j	80200352 <print_trapframe>
        interrupt_handler(tf);
    8020045a:	bfa1                	j	802003b2 <interrupt_handler>

000000008020045c <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
    8020045c:	14011073          	csrw	sscratch,sp
    80200460:	712d                	add	sp,sp,-288
    80200462:	e002                	sd	zero,0(sp)
    80200464:	e406                	sd	ra,8(sp)
    80200466:	ec0e                	sd	gp,24(sp)
    80200468:	f012                	sd	tp,32(sp)
    8020046a:	f416                	sd	t0,40(sp)
    8020046c:	f81a                	sd	t1,48(sp)
    8020046e:	fc1e                	sd	t2,56(sp)
    80200470:	e0a2                	sd	s0,64(sp)
    80200472:	e4a6                	sd	s1,72(sp)
    80200474:	e8aa                	sd	a0,80(sp)
    80200476:	ecae                	sd	a1,88(sp)
    80200478:	f0b2                	sd	a2,96(sp)
    8020047a:	f4b6                	sd	a3,104(sp)
    8020047c:	f8ba                	sd	a4,112(sp)
    8020047e:	fcbe                	sd	a5,120(sp)
    80200480:	e142                	sd	a6,128(sp)
    80200482:	e546                	sd	a7,136(sp)
    80200484:	e94a                	sd	s2,144(sp)
    80200486:	ed4e                	sd	s3,152(sp)
    80200488:	f152                	sd	s4,160(sp)
    8020048a:	f556                	sd	s5,168(sp)
    8020048c:	f95a                	sd	s6,176(sp)
    8020048e:	fd5e                	sd	s7,184(sp)
    80200490:	e1e2                	sd	s8,192(sp)
    80200492:	e5e6                	sd	s9,200(sp)
    80200494:	e9ea                	sd	s10,208(sp)
    80200496:	edee                	sd	s11,216(sp)
    80200498:	f1f2                	sd	t3,224(sp)
    8020049a:	f5f6                	sd	t4,232(sp)
    8020049c:	f9fa                	sd	t5,240(sp)
    8020049e:	fdfe                	sd	t6,248(sp)
    802004a0:	14001473          	csrrw	s0,sscratch,zero
    802004a4:	100024f3          	csrr	s1,sstatus
    802004a8:	14102973          	csrr	s2,sepc
    802004ac:	143029f3          	csrr	s3,stval
    802004b0:	14202a73          	csrr	s4,scause
    802004b4:	e822                	sd	s0,16(sp)
    802004b6:	e226                	sd	s1,256(sp)
    802004b8:	e64a                	sd	s2,264(sp)
    802004ba:	ea4e                	sd	s3,272(sp)
    802004bc:	ee52                	sd	s4,280(sp)

    move  x10, sp
    802004be:	850a                	mv	a0,sp
    jal trap
    802004c0:	f89ff0ef          	jal	80200448 <trap>

00000000802004c4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
    802004c4:	6492                	ld	s1,256(sp)
    802004c6:	6932                	ld	s2,264(sp)
    802004c8:	10049073          	csrw	sstatus,s1
    802004cc:	14191073          	csrw	sepc,s2
    802004d0:	60a2                	ld	ra,8(sp)
    802004d2:	61e2                	ld	gp,24(sp)
    802004d4:	7202                	ld	tp,32(sp)
    802004d6:	72a2                	ld	t0,40(sp)
    802004d8:	7342                	ld	t1,48(sp)
    802004da:	73e2                	ld	t2,56(sp)
    802004dc:	6406                	ld	s0,64(sp)
    802004de:	64a6                	ld	s1,72(sp)
    802004e0:	6546                	ld	a0,80(sp)
    802004e2:	65e6                	ld	a1,88(sp)
    802004e4:	7606                	ld	a2,96(sp)
    802004e6:	76a6                	ld	a3,104(sp)
    802004e8:	7746                	ld	a4,112(sp)
    802004ea:	77e6                	ld	a5,120(sp)
    802004ec:	680a                	ld	a6,128(sp)
    802004ee:	68aa                	ld	a7,136(sp)
    802004f0:	694a                	ld	s2,144(sp)
    802004f2:	69ea                	ld	s3,152(sp)
    802004f4:	7a0a                	ld	s4,160(sp)
    802004f6:	7aaa                	ld	s5,168(sp)
    802004f8:	7b4a                	ld	s6,176(sp)
    802004fa:	7bea                	ld	s7,184(sp)
    802004fc:	6c0e                	ld	s8,192(sp)
    802004fe:	6cae                	ld	s9,200(sp)
    80200500:	6d4e                	ld	s10,208(sp)
    80200502:	6dee                	ld	s11,216(sp)
    80200504:	7e0e                	ld	t3,224(sp)
    80200506:	7eae                	ld	t4,232(sp)
    80200508:	7f4e                	ld	t5,240(sp)
    8020050a:	7fee                	ld	t6,248(sp)
    8020050c:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
    8020050e:	10200073          	sret

0000000080200512 <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
    80200512:	00005797          	auipc	a5,0x5
    80200516:	af678793          	add	a5,a5,-1290 # 80205008 <free_area1>
    8020051a:	e79c                	sd	a5,8(a5)
    8020051c:	e39c                	sd	a5,0(a5)

static void
best_fit_init(void)
{
    list_init(&free_list);
    nr_free = 0;
    8020051e:	0007a823          	sw	zero,16(a5)

}
    80200522:	8082                	ret

0000000080200524 <best_fit_nr_free_pages>:

static size_t
best_fit_nr_free_pages(void)
{
    return nr_free;
}
    80200524:	00005517          	auipc	a0,0x5
    80200528:	af456503          	lwu	a0,-1292(a0) # 80205018 <free_area1+0x10>
    8020052c:	8082                	ret

000000008020052e <best_fit_check>:

// below code is used to check the best fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void)
{
    8020052e:	715d                	add	sp,sp,-80
    80200530:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
    80200532:	00005417          	auipc	s0,0x5
    80200536:	ad640413          	add	s0,s0,-1322 # 80205008 <free_area1>
    8020053a:	641c                	ld	a5,8(s0)
    8020053c:	e486                	sd	ra,72(sp)
    8020053e:	fc26                	sd	s1,56(sp)
    80200540:	f84a                	sd	s2,48(sp)
    80200542:	f44e                	sd	s3,40(sp)
    80200544:	f052                	sd	s4,32(sp)
    80200546:	ec56                	sd	s5,24(sp)
    80200548:	e85a                	sd	s6,16(sp)
    8020054a:	e45e                	sd	s7,8(sp)
    8020054c:	e062                	sd	s8,0(sp)
    int score = 0, sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
    8020054e:	26878b63          	beq	a5,s0,802007c4 <best_fit_check+0x296>
    int count = 0, total = 0;
    80200552:	4481                	li	s1,0
    80200554:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
    80200556:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
    8020055a:	8b09                	and	a4,a4,2
    8020055c:	26070863          	beqz	a4,802007cc <best_fit_check+0x29e>
        count++, total += p->property;
    80200560:	ff87a703          	lw	a4,-8(a5)
    80200564:	679c                	ld	a5,8(a5)
    80200566:	2905                	addw	s2,s2,1
    80200568:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
    8020056a:	fe8796e3          	bne	a5,s0,80200556 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
    8020056e:	89a6                	mv	s3,s1
    80200570:	211000ef          	jal	80200f80 <nr_free_pages>
    80200574:	33351c63          	bne	a0,s3,802008ac <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
    80200578:	4505                	li	a0,1
    8020057a:	189000ef          	jal	80200f02 <alloc_pages>
    8020057e:	8a2a                	mv	s4,a0
    80200580:	36050663          	beqz	a0,802008ec <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
    80200584:	4505                	li	a0,1
    80200586:	17d000ef          	jal	80200f02 <alloc_pages>
    8020058a:	89aa                	mv	s3,a0
    8020058c:	34050063          	beqz	a0,802008cc <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
    80200590:	4505                	li	a0,1
    80200592:	171000ef          	jal	80200f02 <alloc_pages>
    80200596:	8aaa                	mv	s5,a0
    80200598:	2c050a63          	beqz	a0,8020086c <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    8020059c:	253a0863          	beq	s4,s3,802007ec <best_fit_check+0x2be>
    802005a0:	24aa0663          	beq	s4,a0,802007ec <best_fit_check+0x2be>
    802005a4:	24a98463          	beq	s3,a0,802007ec <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
    802005a8:	000a2783          	lw	a5,0(s4)
    802005ac:	26079063          	bnez	a5,8020080c <best_fit_check+0x2de>
    802005b0:	0009a783          	lw	a5,0(s3)
    802005b4:	24079c63          	bnez	a5,8020080c <best_fit_check+0x2de>
    802005b8:	411c                	lw	a5,0(a0)
    802005ba:	24079963          	bnez	a5,8020080c <best_fit_check+0x2de>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
    802005be:	00005797          	auipc	a5,0x5
    802005c2:	a8a7b783          	ld	a5,-1398(a5) # 80205048 <pages>
    802005c6:	40fa0733          	sub	a4,s4,a5
    802005ca:	870d                	sra	a4,a4,0x3
    802005cc:	00002597          	auipc	a1,0x2
    802005d0:	b045b583          	ld	a1,-1276(a1) # 802020d0 <error_string+0x38>
    802005d4:	02b70733          	mul	a4,a4,a1
    802005d8:	00002617          	auipc	a2,0x2
    802005dc:	b0063603          	ld	a2,-1280(a2) # 802020d8 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
    802005e0:	00005697          	auipc	a3,0x5
    802005e4:	a606b683          	ld	a3,-1440(a3) # 80205040 <npage>
    802005e8:	06b2                	sll	a3,a3,0xc
    802005ea:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
    802005ec:	0732                	sll	a4,a4,0xc
    802005ee:	22d77f63          	bgeu	a4,a3,8020082c <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
    802005f2:	40f98733          	sub	a4,s3,a5
    802005f6:	870d                	sra	a4,a4,0x3
    802005f8:	02b70733          	mul	a4,a4,a1
    802005fc:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
    802005fe:	0732                	sll	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
    80200600:	3ed77663          	bgeu	a4,a3,802009ec <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
    80200604:	40f507b3          	sub	a5,a0,a5
    80200608:	878d                	sra	a5,a5,0x3
    8020060a:	02b787b3          	mul	a5,a5,a1
    8020060e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
    80200610:	07b2                	sll	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
    80200612:	3ad7fd63          	bgeu	a5,a3,802009cc <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
    80200616:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
    80200618:	00043c03          	ld	s8,0(s0)
    8020061c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
    80200620:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
    80200624:	e400                	sd	s0,8(s0)
    80200626:	e000                	sd	s0,0(s0)
    nr_free = 0;
    80200628:	00005797          	auipc	a5,0x5
    8020062c:	9e07a823          	sw	zero,-1552(a5) # 80205018 <free_area1+0x10>
    assert(alloc_page() == NULL);
    80200630:	0d3000ef          	jal	80200f02 <alloc_pages>
    80200634:	36051c63          	bnez	a0,802009ac <best_fit_check+0x47e>
    free_page(p0);
    80200638:	4585                	li	a1,1
    8020063a:	8552                	mv	a0,s4
    8020063c:	105000ef          	jal	80200f40 <free_pages>
    free_page(p1);
    80200640:	4585                	li	a1,1
    80200642:	854e                	mv	a0,s3
    80200644:	0fd000ef          	jal	80200f40 <free_pages>
    free_page(p2);
    80200648:	4585                	li	a1,1
    8020064a:	8556                	mv	a0,s5
    8020064c:	0f5000ef          	jal	80200f40 <free_pages>
    assert(nr_free == 3);
    80200650:	4818                	lw	a4,16(s0)
    80200652:	478d                	li	a5,3
    80200654:	32f71c63          	bne	a4,a5,8020098c <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
    80200658:	4505                	li	a0,1
    8020065a:	0a9000ef          	jal	80200f02 <alloc_pages>
    8020065e:	89aa                	mv	s3,a0
    80200660:	30050663          	beqz	a0,8020096c <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
    80200664:	4505                	li	a0,1
    80200666:	09d000ef          	jal	80200f02 <alloc_pages>
    8020066a:	8aaa                	mv	s5,a0
    8020066c:	2e050063          	beqz	a0,8020094c <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
    80200670:	4505                	li	a0,1
    80200672:	091000ef          	jal	80200f02 <alloc_pages>
    80200676:	8a2a                	mv	s4,a0
    80200678:	2a050a63          	beqz	a0,8020092c <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
    8020067c:	4505                	li	a0,1
    8020067e:	085000ef          	jal	80200f02 <alloc_pages>
    80200682:	28051563          	bnez	a0,8020090c <best_fit_check+0x3de>
    free_page(p0);
    80200686:	4585                	li	a1,1
    80200688:	854e                	mv	a0,s3
    8020068a:	0b7000ef          	jal	80200f40 <free_pages>
    assert(!list_empty(&free_list));
    8020068e:	641c                	ld	a5,8(s0)
    80200690:	1a878e63          	beq	a5,s0,8020084c <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
    80200694:	4505                	li	a0,1
    80200696:	06d000ef          	jal	80200f02 <alloc_pages>
    8020069a:	52a99963          	bne	s3,a0,80200bcc <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
    8020069e:	4505                	li	a0,1
    802006a0:	063000ef          	jal	80200f02 <alloc_pages>
    802006a4:	50051463          	bnez	a0,80200bac <best_fit_check+0x67e>
    assert(nr_free == 0);
    802006a8:	481c                	lw	a5,16(s0)
    802006aa:	4e079163          	bnez	a5,80200b8c <best_fit_check+0x65e>
    free_page(p);
    802006ae:	854e                	mv	a0,s3
    802006b0:	4585                	li	a1,1
    free_list = free_list_store;
    802006b2:	01843023          	sd	s8,0(s0)
    802006b6:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
    802006ba:	01642823          	sw	s6,16(s0)
    free_page(p);
    802006be:	083000ef          	jal	80200f40 <free_pages>
    free_page(p1);
    802006c2:	4585                	li	a1,1
    802006c4:	8556                	mv	a0,s5
    802006c6:	07b000ef          	jal	80200f40 <free_pages>
    free_page(p2);
    802006ca:	4585                	li	a1,1
    802006cc:	8552                	mv	a0,s4
    802006ce:	073000ef          	jal	80200f40 <free_pages>

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
    802006d2:	4515                	li	a0,5
    802006d4:	02f000ef          	jal	80200f02 <alloc_pages>
    802006d8:	89aa                	mv	s3,a0
    assert(p0 != NULL);
    802006da:	48050963          	beqz	a0,80200b6c <best_fit_check+0x63e>
    802006de:	651c                	ld	a5,8(a0)
    802006e0:	8385                	srl	a5,a5,0x1
    assert(!PageProperty(p0));
    802006e2:	8b85                	and	a5,a5,1
    802006e4:	46079463          	bnez	a5,80200b4c <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
    802006e8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
    802006ea:	00043a83          	ld	s5,0(s0)
    802006ee:	00843a03          	ld	s4,8(s0)
    802006f2:	e000                	sd	s0,0(s0)
    802006f4:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
    802006f6:	00d000ef          	jal	80200f02 <alloc_pages>
    802006fa:	42051963          	bnez	a0,80200b2c <best_fit_check+0x5fe>
#endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
    802006fe:	4589                	li	a1,2
    80200700:	02898513          	add	a0,s3,40
    unsigned int nr_free_store = nr_free;
    80200704:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
    80200708:	0a098c13          	add	s8,s3,160
    nr_free = 0;
    8020070c:	00005797          	auipc	a5,0x5
    80200710:	9007a623          	sw	zero,-1780(a5) # 80205018 <free_area1+0x10>
    free_pages(p0 + 1, 2);
    80200714:	02d000ef          	jal	80200f40 <free_pages>
    free_pages(p0 + 4, 1);
    80200718:	8562                	mv	a0,s8
    8020071a:	4585                	li	a1,1
    8020071c:	025000ef          	jal	80200f40 <free_pages>
    assert(alloc_pages(4) == NULL);
    80200720:	4511                	li	a0,4
    80200722:	7e0000ef          	jal	80200f02 <alloc_pages>
    80200726:	3e051363          	bnez	a0,80200b0c <best_fit_check+0x5de>
    8020072a:	0309b783          	ld	a5,48(s3)
    8020072e:	8385                	srl	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
    80200730:	8b85                	and	a5,a5,1
    80200732:	3a078d63          	beqz	a5,80200aec <best_fit_check+0x5be>
    80200736:	0389a703          	lw	a4,56(s3)
    8020073a:	4789                	li	a5,2
    8020073c:	3af71863          	bne	a4,a5,80200aec <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
    80200740:	4505                	li	a0,1
    80200742:	7c0000ef          	jal	80200f02 <alloc_pages>
    80200746:	8baa                	mv	s7,a0
    80200748:	38050263          	beqz	a0,80200acc <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL); 
    8020074c:	4509                	li	a0,2
    8020074e:	7b4000ef          	jal	80200f02 <alloc_pages>
    80200752:	34050d63          	beqz	a0,80200aac <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
    80200756:	337c1b63          	bne	s8,s7,80200a8c <best_fit_check+0x55e>
#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
    p2 = p0 + 1;
    free_pages(p0, 5);
    8020075a:	854e                	mv	a0,s3
    8020075c:	4595                	li	a1,5
    8020075e:	7e2000ef          	jal	80200f40 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
    80200762:	4515                	li	a0,5
    80200764:	79e000ef          	jal	80200f02 <alloc_pages>
    80200768:	89aa                	mv	s3,a0
    8020076a:	30050163          	beqz	a0,80200a6c <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
    8020076e:	4505                	li	a0,1
    80200770:	792000ef          	jal	80200f02 <alloc_pages>
    80200774:	2c051c63          	bnez	a0,80200a4c <best_fit_check+0x51e>

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
    assert(nr_free == 0);
    80200778:	481c                	lw	a5,16(s0)
    8020077a:	2a079963          	bnez	a5,80200a2c <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
    8020077e:	4595                	li	a1,5
    80200780:	854e                	mv	a0,s3
    nr_free = nr_free_store;
    80200782:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
    80200786:	01543023          	sd	s5,0(s0)
    8020078a:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
    8020078e:	7b2000ef          	jal	80200f40 <free_pages>
    return listelm->next;
    80200792:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
    80200794:	00878963          	beq	a5,s0,802007a6 <best_fit_check+0x278>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
    80200798:	ff87a703          	lw	a4,-8(a5)
    8020079c:	679c                	ld	a5,8(a5)
    8020079e:	397d                	addw	s2,s2,-1
    802007a0:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
    802007a2:	fe879be3          	bne	a5,s0,80200798 <best_fit_check+0x26a>
    }
    assert(count == 0);
    802007a6:	26091363          	bnez	s2,80200a0c <best_fit_check+0x4de>
    assert(total == 0);
    802007aa:	e0ed                	bnez	s1,8020088c <best_fit_check+0x35e>
#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
}
    802007ac:	60a6                	ld	ra,72(sp)
    802007ae:	6406                	ld	s0,64(sp)
    802007b0:	74e2                	ld	s1,56(sp)
    802007b2:	7942                	ld	s2,48(sp)
    802007b4:	79a2                	ld	s3,40(sp)
    802007b6:	7a02                	ld	s4,32(sp)
    802007b8:	6ae2                	ld	s5,24(sp)
    802007ba:	6b42                	ld	s6,16(sp)
    802007bc:	6ba2                	ld	s7,8(sp)
    802007be:	6c02                	ld	s8,0(sp)
    802007c0:	6161                	add	sp,sp,80
    802007c2:	8082                	ret
    while ((le = list_next(le)) != &free_list)
    802007c4:	4981                	li	s3,0
    int count = 0, total = 0;
    802007c6:	4481                	li	s1,0
    802007c8:	4901                	li	s2,0
    802007ca:	b35d                	j	80200570 <best_fit_check+0x42>
        assert(PageProperty(p));
    802007cc:	00001697          	auipc	a3,0x1
    802007d0:	24468693          	add	a3,a3,580 # 80201a10 <etext+0x4aa>
    802007d4:	00001617          	auipc	a2,0x1
    802007d8:	24c60613          	add	a2,a2,588 # 80201a20 <etext+0x4ba>
    802007dc:	0cf00593          	li	a1,207
    802007e0:	00001517          	auipc	a0,0x1
    802007e4:	25850513          	add	a0,a0,600 # 80201a38 <etext+0x4d2>
    802007e8:	911ff0ef          	jal	802000f8 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    802007ec:	00001697          	auipc	a3,0x1
    802007f0:	2e468693          	add	a3,a3,740 # 80201ad0 <etext+0x56a>
    802007f4:	00001617          	auipc	a2,0x1
    802007f8:	22c60613          	add	a2,a2,556 # 80201a20 <etext+0x4ba>
    802007fc:	09900593          	li	a1,153
    80200800:	00001517          	auipc	a0,0x1
    80200804:	23850513          	add	a0,a0,568 # 80201a38 <etext+0x4d2>
    80200808:	8f1ff0ef          	jal	802000f8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
    8020080c:	00001697          	auipc	a3,0x1
    80200810:	2ec68693          	add	a3,a3,748 # 80201af8 <etext+0x592>
    80200814:	00001617          	auipc	a2,0x1
    80200818:	20c60613          	add	a2,a2,524 # 80201a20 <etext+0x4ba>
    8020081c:	09a00593          	li	a1,154
    80200820:	00001517          	auipc	a0,0x1
    80200824:	21850513          	add	a0,a0,536 # 80201a38 <etext+0x4d2>
    80200828:	8d1ff0ef          	jal	802000f8 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
    8020082c:	00001697          	auipc	a3,0x1
    80200830:	30c68693          	add	a3,a3,780 # 80201b38 <etext+0x5d2>
    80200834:	00001617          	auipc	a2,0x1
    80200838:	1ec60613          	add	a2,a2,492 # 80201a20 <etext+0x4ba>
    8020083c:	09c00593          	li	a1,156
    80200840:	00001517          	auipc	a0,0x1
    80200844:	1f850513          	add	a0,a0,504 # 80201a38 <etext+0x4d2>
    80200848:	8b1ff0ef          	jal	802000f8 <__panic>
    assert(!list_empty(&free_list));
    8020084c:	00001697          	auipc	a3,0x1
    80200850:	37468693          	add	a3,a3,884 # 80201bc0 <etext+0x65a>
    80200854:	00001617          	auipc	a2,0x1
    80200858:	1cc60613          	add	a2,a2,460 # 80201a20 <etext+0x4ba>
    8020085c:	0b500593          	li	a1,181
    80200860:	00001517          	auipc	a0,0x1
    80200864:	1d850513          	add	a0,a0,472 # 80201a38 <etext+0x4d2>
    80200868:	891ff0ef          	jal	802000f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
    8020086c:	00001697          	auipc	a3,0x1
    80200870:	24468693          	add	a3,a3,580 # 80201ab0 <etext+0x54a>
    80200874:	00001617          	auipc	a2,0x1
    80200878:	1ac60613          	add	a2,a2,428 # 80201a20 <etext+0x4ba>
    8020087c:	09700593          	li	a1,151
    80200880:	00001517          	auipc	a0,0x1
    80200884:	1b850513          	add	a0,a0,440 # 80201a38 <etext+0x4d2>
    80200888:	871ff0ef          	jal	802000f8 <__panic>
    assert(total == 0);
    8020088c:	00001697          	auipc	a3,0x1
    80200890:	46468693          	add	a3,a3,1124 # 80201cf0 <etext+0x78a>
    80200894:	00001617          	auipc	a2,0x1
    80200898:	18c60613          	add	a2,a2,396 # 80201a20 <etext+0x4ba>
    8020089c:	11200593          	li	a1,274
    802008a0:	00001517          	auipc	a0,0x1
    802008a4:	19850513          	add	a0,a0,408 # 80201a38 <etext+0x4d2>
    802008a8:	851ff0ef          	jal	802000f8 <__panic>
    assert(total == nr_free_pages());
    802008ac:	00001697          	auipc	a3,0x1
    802008b0:	1a468693          	add	a3,a3,420 # 80201a50 <etext+0x4ea>
    802008b4:	00001617          	auipc	a2,0x1
    802008b8:	16c60613          	add	a2,a2,364 # 80201a20 <etext+0x4ba>
    802008bc:	0d200593          	li	a1,210
    802008c0:	00001517          	auipc	a0,0x1
    802008c4:	17850513          	add	a0,a0,376 # 80201a38 <etext+0x4d2>
    802008c8:	831ff0ef          	jal	802000f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
    802008cc:	00001697          	auipc	a3,0x1
    802008d0:	1c468693          	add	a3,a3,452 # 80201a90 <etext+0x52a>
    802008d4:	00001617          	auipc	a2,0x1
    802008d8:	14c60613          	add	a2,a2,332 # 80201a20 <etext+0x4ba>
    802008dc:	09600593          	li	a1,150
    802008e0:	00001517          	auipc	a0,0x1
    802008e4:	15850513          	add	a0,a0,344 # 80201a38 <etext+0x4d2>
    802008e8:	811ff0ef          	jal	802000f8 <__panic>
    assert((p0 = alloc_page()) != NULL);
    802008ec:	00001697          	auipc	a3,0x1
    802008f0:	18468693          	add	a3,a3,388 # 80201a70 <etext+0x50a>
    802008f4:	00001617          	auipc	a2,0x1
    802008f8:	12c60613          	add	a2,a2,300 # 80201a20 <etext+0x4ba>
    802008fc:	09500593          	li	a1,149
    80200900:	00001517          	auipc	a0,0x1
    80200904:	13850513          	add	a0,a0,312 # 80201a38 <etext+0x4d2>
    80200908:	ff0ff0ef          	jal	802000f8 <__panic>
    assert(alloc_page() == NULL);
    8020090c:	00001697          	auipc	a3,0x1
    80200910:	28c68693          	add	a3,a3,652 # 80201b98 <etext+0x632>
    80200914:	00001617          	auipc	a2,0x1
    80200918:	10c60613          	add	a2,a2,268 # 80201a20 <etext+0x4ba>
    8020091c:	0b200593          	li	a1,178
    80200920:	00001517          	auipc	a0,0x1
    80200924:	11850513          	add	a0,a0,280 # 80201a38 <etext+0x4d2>
    80200928:	fd0ff0ef          	jal	802000f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
    8020092c:	00001697          	auipc	a3,0x1
    80200930:	18468693          	add	a3,a3,388 # 80201ab0 <etext+0x54a>
    80200934:	00001617          	auipc	a2,0x1
    80200938:	0ec60613          	add	a2,a2,236 # 80201a20 <etext+0x4ba>
    8020093c:	0b000593          	li	a1,176
    80200940:	00001517          	auipc	a0,0x1
    80200944:	0f850513          	add	a0,a0,248 # 80201a38 <etext+0x4d2>
    80200948:	fb0ff0ef          	jal	802000f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
    8020094c:	00001697          	auipc	a3,0x1
    80200950:	14468693          	add	a3,a3,324 # 80201a90 <etext+0x52a>
    80200954:	00001617          	auipc	a2,0x1
    80200958:	0cc60613          	add	a2,a2,204 # 80201a20 <etext+0x4ba>
    8020095c:	0af00593          	li	a1,175
    80200960:	00001517          	auipc	a0,0x1
    80200964:	0d850513          	add	a0,a0,216 # 80201a38 <etext+0x4d2>
    80200968:	f90ff0ef          	jal	802000f8 <__panic>
    assert((p0 = alloc_page()) != NULL);
    8020096c:	00001697          	auipc	a3,0x1
    80200970:	10468693          	add	a3,a3,260 # 80201a70 <etext+0x50a>
    80200974:	00001617          	auipc	a2,0x1
    80200978:	0ac60613          	add	a2,a2,172 # 80201a20 <etext+0x4ba>
    8020097c:	0ae00593          	li	a1,174
    80200980:	00001517          	auipc	a0,0x1
    80200984:	0b850513          	add	a0,a0,184 # 80201a38 <etext+0x4d2>
    80200988:	f70ff0ef          	jal	802000f8 <__panic>
    assert(nr_free == 3);
    8020098c:	00001697          	auipc	a3,0x1
    80200990:	22468693          	add	a3,a3,548 # 80201bb0 <etext+0x64a>
    80200994:	00001617          	auipc	a2,0x1
    80200998:	08c60613          	add	a2,a2,140 # 80201a20 <etext+0x4ba>
    8020099c:	0ac00593          	li	a1,172
    802009a0:	00001517          	auipc	a0,0x1
    802009a4:	09850513          	add	a0,a0,152 # 80201a38 <etext+0x4d2>
    802009a8:	f50ff0ef          	jal	802000f8 <__panic>
    assert(alloc_page() == NULL);
    802009ac:	00001697          	auipc	a3,0x1
    802009b0:	1ec68693          	add	a3,a3,492 # 80201b98 <etext+0x632>
    802009b4:	00001617          	auipc	a2,0x1
    802009b8:	06c60613          	add	a2,a2,108 # 80201a20 <etext+0x4ba>
    802009bc:	0a700593          	li	a1,167
    802009c0:	00001517          	auipc	a0,0x1
    802009c4:	07850513          	add	a0,a0,120 # 80201a38 <etext+0x4d2>
    802009c8:	f30ff0ef          	jal	802000f8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
    802009cc:	00001697          	auipc	a3,0x1
    802009d0:	1ac68693          	add	a3,a3,428 # 80201b78 <etext+0x612>
    802009d4:	00001617          	auipc	a2,0x1
    802009d8:	04c60613          	add	a2,a2,76 # 80201a20 <etext+0x4ba>
    802009dc:	09e00593          	li	a1,158
    802009e0:	00001517          	auipc	a0,0x1
    802009e4:	05850513          	add	a0,a0,88 # 80201a38 <etext+0x4d2>
    802009e8:	f10ff0ef          	jal	802000f8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
    802009ec:	00001697          	auipc	a3,0x1
    802009f0:	16c68693          	add	a3,a3,364 # 80201b58 <etext+0x5f2>
    802009f4:	00001617          	auipc	a2,0x1
    802009f8:	02c60613          	add	a2,a2,44 # 80201a20 <etext+0x4ba>
    802009fc:	09d00593          	li	a1,157
    80200a00:	00001517          	auipc	a0,0x1
    80200a04:	03850513          	add	a0,a0,56 # 80201a38 <etext+0x4d2>
    80200a08:	ef0ff0ef          	jal	802000f8 <__panic>
    assert(count == 0);
    80200a0c:	00001697          	auipc	a3,0x1
    80200a10:	2d468693          	add	a3,a3,724 # 80201ce0 <etext+0x77a>
    80200a14:	00001617          	auipc	a2,0x1
    80200a18:	00c60613          	add	a2,a2,12 # 80201a20 <etext+0x4ba>
    80200a1c:	11100593          	li	a1,273
    80200a20:	00001517          	auipc	a0,0x1
    80200a24:	01850513          	add	a0,a0,24 # 80201a38 <etext+0x4d2>
    80200a28:	ed0ff0ef          	jal	802000f8 <__panic>
    assert(nr_free == 0);
    80200a2c:	00001697          	auipc	a3,0x1
    80200a30:	1cc68693          	add	a3,a3,460 # 80201bf8 <etext+0x692>
    80200a34:	00001617          	auipc	a2,0x1
    80200a38:	fec60613          	add	a2,a2,-20 # 80201a20 <etext+0x4ba>
    80200a3c:	10500593          	li	a1,261
    80200a40:	00001517          	auipc	a0,0x1
    80200a44:	ff850513          	add	a0,a0,-8 # 80201a38 <etext+0x4d2>
    80200a48:	eb0ff0ef          	jal	802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200a4c:	00001697          	auipc	a3,0x1
    80200a50:	14c68693          	add	a3,a3,332 # 80201b98 <etext+0x632>
    80200a54:	00001617          	auipc	a2,0x1
    80200a58:	fcc60613          	add	a2,a2,-52 # 80201a20 <etext+0x4ba>
    80200a5c:	0ff00593          	li	a1,255
    80200a60:	00001517          	auipc	a0,0x1
    80200a64:	fd850513          	add	a0,a0,-40 # 80201a38 <etext+0x4d2>
    80200a68:	e90ff0ef          	jal	802000f8 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
    80200a6c:	00001697          	auipc	a3,0x1
    80200a70:	25468693          	add	a3,a3,596 # 80201cc0 <etext+0x75a>
    80200a74:	00001617          	auipc	a2,0x1
    80200a78:	fac60613          	add	a2,a2,-84 # 80201a20 <etext+0x4ba>
    80200a7c:	0fe00593          	li	a1,254
    80200a80:	00001517          	auipc	a0,0x1
    80200a84:	fb850513          	add	a0,a0,-72 # 80201a38 <etext+0x4d2>
    80200a88:	e70ff0ef          	jal	802000f8 <__panic>
    assert(p0 + 4 == p1);
    80200a8c:	00001697          	auipc	a3,0x1
    80200a90:	22468693          	add	a3,a3,548 # 80201cb0 <etext+0x74a>
    80200a94:	00001617          	auipc	a2,0x1
    80200a98:	f8c60613          	add	a2,a2,-116 # 80201a20 <etext+0x4ba>
    80200a9c:	0f600593          	li	a1,246
    80200aa0:	00001517          	auipc	a0,0x1
    80200aa4:	f9850513          	add	a0,a0,-104 # 80201a38 <etext+0x4d2>
    80200aa8:	e50ff0ef          	jal	802000f8 <__panic>
    assert(alloc_pages(2) != NULL); 
    80200aac:	00001697          	auipc	a3,0x1
    80200ab0:	1ec68693          	add	a3,a3,492 # 80201c98 <etext+0x732>
    80200ab4:	00001617          	auipc	a2,0x1
    80200ab8:	f6c60613          	add	a2,a2,-148 # 80201a20 <etext+0x4ba>
    80200abc:	0f500593          	li	a1,245
    80200ac0:	00001517          	auipc	a0,0x1
    80200ac4:	f7850513          	add	a0,a0,-136 # 80201a38 <etext+0x4d2>
    80200ac8:	e30ff0ef          	jal	802000f8 <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
    80200acc:	00001697          	auipc	a3,0x1
    80200ad0:	1ac68693          	add	a3,a3,428 # 80201c78 <etext+0x712>
    80200ad4:	00001617          	auipc	a2,0x1
    80200ad8:	f4c60613          	add	a2,a2,-180 # 80201a20 <etext+0x4ba>
    80200adc:	0f400593          	li	a1,244
    80200ae0:	00001517          	auipc	a0,0x1
    80200ae4:	f5850513          	add	a0,a0,-168 # 80201a38 <etext+0x4d2>
    80200ae8:	e10ff0ef          	jal	802000f8 <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
    80200aec:	00001697          	auipc	a3,0x1
    80200af0:	15c68693          	add	a3,a3,348 # 80201c48 <etext+0x6e2>
    80200af4:	00001617          	auipc	a2,0x1
    80200af8:	f2c60613          	add	a2,a2,-212 # 80201a20 <etext+0x4ba>
    80200afc:	0f200593          	li	a1,242
    80200b00:	00001517          	auipc	a0,0x1
    80200b04:	f3850513          	add	a0,a0,-200 # 80201a38 <etext+0x4d2>
    80200b08:	df0ff0ef          	jal	802000f8 <__panic>
    assert(alloc_pages(4) == NULL);
    80200b0c:	00001697          	auipc	a3,0x1
    80200b10:	12468693          	add	a3,a3,292 # 80201c30 <etext+0x6ca>
    80200b14:	00001617          	auipc	a2,0x1
    80200b18:	f0c60613          	add	a2,a2,-244 # 80201a20 <etext+0x4ba>
    80200b1c:	0f100593          	li	a1,241
    80200b20:	00001517          	auipc	a0,0x1
    80200b24:	f1850513          	add	a0,a0,-232 # 80201a38 <etext+0x4d2>
    80200b28:	dd0ff0ef          	jal	802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200b2c:	00001697          	auipc	a3,0x1
    80200b30:	06c68693          	add	a3,a3,108 # 80201b98 <etext+0x632>
    80200b34:	00001617          	auipc	a2,0x1
    80200b38:	eec60613          	add	a2,a2,-276 # 80201a20 <etext+0x4ba>
    80200b3c:	0e500593          	li	a1,229
    80200b40:	00001517          	auipc	a0,0x1
    80200b44:	ef850513          	add	a0,a0,-264 # 80201a38 <etext+0x4d2>
    80200b48:	db0ff0ef          	jal	802000f8 <__panic>
    assert(!PageProperty(p0));
    80200b4c:	00001697          	auipc	a3,0x1
    80200b50:	0cc68693          	add	a3,a3,204 # 80201c18 <etext+0x6b2>
    80200b54:	00001617          	auipc	a2,0x1
    80200b58:	ecc60613          	add	a2,a2,-308 # 80201a20 <etext+0x4ba>
    80200b5c:	0dc00593          	li	a1,220
    80200b60:	00001517          	auipc	a0,0x1
    80200b64:	ed850513          	add	a0,a0,-296 # 80201a38 <etext+0x4d2>
    80200b68:	d90ff0ef          	jal	802000f8 <__panic>
    assert(p0 != NULL);
    80200b6c:	00001697          	auipc	a3,0x1
    80200b70:	09c68693          	add	a3,a3,156 # 80201c08 <etext+0x6a2>
    80200b74:	00001617          	auipc	a2,0x1
    80200b78:	eac60613          	add	a2,a2,-340 # 80201a20 <etext+0x4ba>
    80200b7c:	0db00593          	li	a1,219
    80200b80:	00001517          	auipc	a0,0x1
    80200b84:	eb850513          	add	a0,a0,-328 # 80201a38 <etext+0x4d2>
    80200b88:	d70ff0ef          	jal	802000f8 <__panic>
    assert(nr_free == 0);
    80200b8c:	00001697          	auipc	a3,0x1
    80200b90:	06c68693          	add	a3,a3,108 # 80201bf8 <etext+0x692>
    80200b94:	00001617          	auipc	a2,0x1
    80200b98:	e8c60613          	add	a2,a2,-372 # 80201a20 <etext+0x4ba>
    80200b9c:	0bb00593          	li	a1,187
    80200ba0:	00001517          	auipc	a0,0x1
    80200ba4:	e9850513          	add	a0,a0,-360 # 80201a38 <etext+0x4d2>
    80200ba8:	d50ff0ef          	jal	802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200bac:	00001697          	auipc	a3,0x1
    80200bb0:	fec68693          	add	a3,a3,-20 # 80201b98 <etext+0x632>
    80200bb4:	00001617          	auipc	a2,0x1
    80200bb8:	e6c60613          	add	a2,a2,-404 # 80201a20 <etext+0x4ba>
    80200bbc:	0b900593          	li	a1,185
    80200bc0:	00001517          	auipc	a0,0x1
    80200bc4:	e7850513          	add	a0,a0,-392 # 80201a38 <etext+0x4d2>
    80200bc8:	d30ff0ef          	jal	802000f8 <__panic>
    assert((p = alloc_page()) == p0);
    80200bcc:	00001697          	auipc	a3,0x1
    80200bd0:	00c68693          	add	a3,a3,12 # 80201bd8 <etext+0x672>
    80200bd4:	00001617          	auipc	a2,0x1
    80200bd8:	e4c60613          	add	a2,a2,-436 # 80201a20 <etext+0x4ba>
    80200bdc:	0b800593          	li	a1,184
    80200be0:	00001517          	auipc	a0,0x1
    80200be4:	e5850513          	add	a0,a0,-424 # 80201a38 <etext+0x4d2>
    80200be8:	d10ff0ef          	jal	802000f8 <__panic>

0000000080200bec <best_fit_free_pages>:
{
    80200bec:	1141                	add	sp,sp,-16
    80200bee:	e406                	sd	ra,8(sp)
    assert(n > 0);
    80200bf0:	12058e63          	beqz	a1,80200d2c <best_fit_free_pages+0x140>
    for (; p != base + n; p ++) {
    80200bf4:	00259713          	sll	a4,a1,0x2
    80200bf8:	972e                	add	a4,a4,a1
    80200bfa:	070e                	sll	a4,a4,0x3
    80200bfc:	00e506b3          	add	a3,a0,a4
    80200c00:	87aa                	mv	a5,a0
    80200c02:	c305                	beqz	a4,80200c22 <best_fit_free_pages+0x36>
    80200c04:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
    80200c06:	8b05                	and	a4,a4,1
    80200c08:	10071263          	bnez	a4,80200d0c <best_fit_free_pages+0x120>
    80200c0c:	6798                	ld	a4,8(a5)
    80200c0e:	8b09                	and	a4,a4,2
    80200c10:	ef75                	bnez	a4,80200d0c <best_fit_free_pages+0x120>
        p->flags = 0;
    80200c12:	0007b423          	sd	zero,8(a5)
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
    80200c16:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
    80200c1a:	02878793          	add	a5,a5,40
    80200c1e:	fed793e3          	bne	a5,a3,80200c04 <best_fit_free_pages+0x18>
    base->property = n;
    80200c22:	2581                	sext.w	a1,a1
    80200c24:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
    80200c26:	4789                	li	a5,2
    80200c28:	00850713          	add	a4,a0,8
    80200c2c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
    80200c30:	00004697          	auipc	a3,0x4
    80200c34:	3d868693          	add	a3,a3,984 # 80205008 <free_area1>
    80200c38:	4a98                	lw	a4,16(a3)
    return list->next == list;
    80200c3a:	669c                	ld	a5,8(a3)
    80200c3c:	9f2d                	addw	a4,a4,a1
    80200c3e:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
    80200c40:	00d79763          	bne	a5,a3,80200c4e <best_fit_free_pages+0x62>
    80200c44:	a845                	j	80200cf4 <best_fit_free_pages+0x108>
    return listelm->next;
    80200c46:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
    80200c48:	0ad70d63          	beq	a4,a3,80200d02 <best_fit_free_pages+0x116>
    80200c4c:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
    80200c4e:	fe878713          	add	a4,a5,-24
            if (base < page) {
    80200c52:	fee57ae3          	bgeu	a0,a4,80200c46 <best_fit_free_pages+0x5a>
        if(next - base == base->property){
    80200c56:	8f09                	sub	a4,a4,a0
    80200c58:	00001617          	auipc	a2,0x1
    80200c5c:	47863603          	ld	a2,1144(a2) # 802020d0 <error_string+0x38>
    80200c60:	870d                	sra	a4,a4,0x3
    80200c62:	02c70733          	mul	a4,a4,a2
    80200c66:	01052803          	lw	a6,16(a0)
    __list_add(elm, listelm->prev, listelm);
    80200c6a:	6390                	ld	a2,0(a5)
                list_add_before(le, &(base->page_link));
    80200c6c:	01850593          	add	a1,a0,24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
    80200c70:	e38c                	sd	a1,0(a5)
    80200c72:	e60c                	sd	a1,8(a2)
        if(next - base == base->property){
    80200c74:	02081593          	sll	a1,a6,0x20
    elm->next = next;
    80200c78:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200c7a:	ed10                	sd	a2,24(a0)
    80200c7c:	9181                	srl	a1,a1,0x20
    80200c7e:	04b70963          	beq	a4,a1,80200cd0 <best_fit_free_pages+0xe4>
    return listelm->prev;
    80200c82:	87b2                	mv	a5,a2
    if (next_entry!=&free_list){
    80200c84:	04d78363          	beq	a5,a3,80200cca <best_fit_free_pages+0xde>
        struct Page *next = le2page(next_entry, page_link);
    80200c88:	fe878713          	add	a4,a5,-24
        if(base - next == next->property){
    80200c8c:	40e50733          	sub	a4,a0,a4
    80200c90:	00001697          	auipc	a3,0x1
    80200c94:	4406b683          	ld	a3,1088(a3) # 802020d0 <error_string+0x38>
    80200c98:	870d                	sra	a4,a4,0x3
    80200c9a:	02d70733          	mul	a4,a4,a3
    80200c9e:	ff87a683          	lw	a3,-8(a5)
    80200ca2:	02069613          	sll	a2,a3,0x20
    80200ca6:	9201                	srl	a2,a2,0x20
    80200ca8:	02c71163          	bne	a4,a2,80200cca <best_fit_free_pages+0xde>
            next->property += base->property;
    80200cac:	4918                	lw	a4,16(a0)
    80200cae:	9f35                	addw	a4,a4,a3
    80200cb0:	fee7ac23          	sw	a4,-8(a5)
            base->property = 0;
    80200cb4:	00052823          	sw	zero,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
    80200cb8:	57f5                	li	a5,-3
    80200cba:	00850713          	add	a4,a0,8
    80200cbe:	60f7302f          	amoand.d	zero,a5,(a4)
    __list_del(listelm->prev, listelm->next);
    80200cc2:	6d18                	ld	a4,24(a0)
    80200cc4:	711c                	ld	a5,32(a0)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
    80200cc6:	e71c                	sd	a5,8(a4)
    next->prev = prev;
    80200cc8:	e398                	sd	a4,0(a5)
}
    80200cca:	60a2                	ld	ra,8(sp)
    80200ccc:	0141                	add	sp,sp,16
    80200cce:	8082                	ret
            base->property += next->property;
    80200cd0:	ff87a703          	lw	a4,-8(a5)
    80200cd4:	ff078613          	add	a2,a5,-16
    80200cd8:	0107073b          	addw	a4,a4,a6
    80200cdc:	c918                	sw	a4,16(a0)
            next->property = 0;
    80200cde:	fe07ac23          	sw	zero,-8(a5)
    80200ce2:	5775                	li	a4,-3
    80200ce4:	60e6302f          	amoand.d	zero,a4,(a2)
    __list_del(listelm->prev, listelm->next);
    80200ce8:	6398                	ld	a4,0(a5)
    80200cea:	679c                	ld	a5,8(a5)
    prev->next = next;
    80200cec:	e71c                	sd	a5,8(a4)
    next->prev = prev;
    80200cee:	e398                	sd	a4,0(a5)
    return listelm->prev;
    80200cf0:	6d1c                	ld	a5,24(a0)
}
    80200cf2:	bf49                	j	80200c84 <best_fit_free_pages+0x98>
        list_add(&free_list, &(base->page_link));
    80200cf4:	01850713          	add	a4,a0,24
    prev->next = next->prev = elm;
    80200cf8:	e398                	sd	a4,0(a5)
    80200cfa:	e798                	sd	a4,8(a5)
    elm->next = next;
    80200cfc:	f114                	sd	a3,32(a0)
    elm->prev = prev;
    80200cfe:	ed1c                	sd	a5,24(a0)
    if (next_entry!=&free_list){
    80200d00:	b751                	j	80200c84 <best_fit_free_pages+0x98>
                list_add(le, &(base->page_link));
    80200d02:	01850713          	add	a4,a0,24
    prev->next = next->prev = elm;
    80200d06:	e298                	sd	a4,0(a3)
    80200d08:	e798                	sd	a4,8(a5)
}
    80200d0a:	bfcd                	j	80200cfc <best_fit_free_pages+0x110>
        assert(!PageReserved(p) && !PageProperty(p));
    80200d0c:	00001697          	auipc	a3,0x1
    80200d10:	ffc68693          	add	a3,a3,-4 # 80201d08 <etext+0x7a2>
    80200d14:	00001617          	auipc	a2,0x1
    80200d18:	d0c60613          	add	a2,a2,-756 # 80201a20 <etext+0x4ba>
    80200d1c:	05b00593          	li	a1,91
    80200d20:	00001517          	auipc	a0,0x1
    80200d24:	d1850513          	add	a0,a0,-744 # 80201a38 <etext+0x4d2>
    80200d28:	bd0ff0ef          	jal	802000f8 <__panic>
    assert(n > 0);
    80200d2c:	00001697          	auipc	a3,0x1
    80200d30:	fd468693          	add	a3,a3,-44 # 80201d00 <etext+0x79a>
    80200d34:	00001617          	auipc	a2,0x1
    80200d38:	cec60613          	add	a2,a2,-788 # 80201a20 <etext+0x4ba>
    80200d3c:	05800593          	li	a1,88
    80200d40:	00001517          	auipc	a0,0x1
    80200d44:	cf850513          	add	a0,a0,-776 # 80201a38 <etext+0x4d2>
    80200d48:	bb0ff0ef          	jal	802000f8 <__panic>

0000000080200d4c <best_fit_alloc_pages>:
    assert(n > 0);
    80200d4c:	c14d                	beqz	a0,80200dee <best_fit_alloc_pages+0xa2>
    if (n > nr_free) {
    80200d4e:	00004617          	auipc	a2,0x4
    80200d52:	2ba60613          	add	a2,a2,698 # 80205008 <free_area1>
    80200d56:	01062803          	lw	a6,16(a2)
    80200d5a:	86aa                	mv	a3,a0
    80200d5c:	02081793          	sll	a5,a6,0x20
    80200d60:	9381                	srl	a5,a5,0x20
    80200d62:	08a7e463          	bltu	a5,a0,80200dea <best_fit_alloc_pages+0x9e>
    return listelm->next;
    80200d66:	661c                	ld	a5,8(a2)
    struct Page *page = NULL;
    80200d68:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list) {
    80200d6a:	06c78f63          	beq	a5,a2,80200de8 <best_fit_alloc_pages+0x9c>
    size_t min = 0x7fffffff;
    80200d6e:	800005b7          	lui	a1,0x80000
    80200d72:	fff5c593          	not	a1,a1
        if (p->property >= n) {
    80200d76:	ff87e703          	lwu	a4,-8(a5)
    80200d7a:	00d76763          	bltu	a4,a3,80200d88 <best_fit_alloc_pages+0x3c>
            if (p->property < min) {
    80200d7e:	00b77563          	bgeu	a4,a1,80200d88 <best_fit_alloc_pages+0x3c>
        struct Page *p = le2page(le, page_link);
    80200d82:	fe878513          	add	a0,a5,-24
        if (p->property >= n) {
    80200d86:	85ba                	mv	a1,a4
    80200d88:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
    80200d8a:	fec796e3          	bne	a5,a2,80200d76 <best_fit_alloc_pages+0x2a>
    if (page != NULL) {
    80200d8e:	cd29                	beqz	a0,80200de8 <best_fit_alloc_pages+0x9c>
    __list_del(listelm->prev, listelm->next);
    80200d90:	711c                	ld	a5,32(a0)
    return listelm->prev;
    80200d92:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
    80200d94:	490c                	lw	a1,16(a0)
            p->property = page->property - n;
    80200d96:	0006889b          	sext.w	a7,a3
    prev->next = next;
    80200d9a:	e71c                	sd	a5,8(a4)
    next->prev = prev;
    80200d9c:	e398                	sd	a4,0(a5)
        if (page->property > n) {
    80200d9e:	02059793          	sll	a5,a1,0x20
    80200da2:	9381                	srl	a5,a5,0x20
    80200da4:	02f6f863          	bgeu	a3,a5,80200dd4 <best_fit_alloc_pages+0x88>
            struct Page *p = page + n;
    80200da8:	00269793          	sll	a5,a3,0x2
    80200dac:	97b6                	add	a5,a5,a3
    80200dae:	078e                	sll	a5,a5,0x3
    80200db0:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
    80200db2:	411585bb          	subw	a1,a1,a7
    80200db6:	cb8c                	sw	a1,16(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
    80200db8:	4689                	li	a3,2
    80200dba:	00878593          	add	a1,a5,8
    80200dbe:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
    80200dc2:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
    80200dc4:	01878593          	add	a1,a5,24
        nr_free -= n;
    80200dc8:	01062803          	lw	a6,16(a2)
    prev->next = next->prev = elm;
    80200dcc:	e28c                	sd	a1,0(a3)
    80200dce:	e70c                	sd	a1,8(a4)
    elm->next = next;
    80200dd0:	f394                	sd	a3,32(a5)
    elm->prev = prev;
    80200dd2:	ef98                	sd	a4,24(a5)
    80200dd4:	4118083b          	subw	a6,a6,a7
    80200dd8:	01062823          	sw	a6,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
    80200ddc:	57f5                	li	a5,-3
    80200dde:	00850713          	add	a4,a0,8
    80200de2:	60f7302f          	amoand.d	zero,a5,(a4)
}
    80200de6:	8082                	ret
}
    80200de8:	8082                	ret
        return NULL;
    80200dea:	4501                	li	a0,0
    80200dec:	8082                	ret
{
    80200dee:	1141                	add	sp,sp,-16
    assert(n > 0);
    80200df0:	00001697          	auipc	a3,0x1
    80200df4:	f1068693          	add	a3,a3,-240 # 80201d00 <etext+0x79a>
    80200df8:	00001617          	auipc	a2,0x1
    80200dfc:	c2860613          	add	a2,a2,-984 # 80201a20 <etext+0x4ba>
    80200e00:	03500593          	li	a1,53
    80200e04:	00001517          	auipc	a0,0x1
    80200e08:	c3450513          	add	a0,a0,-972 # 80201a38 <etext+0x4d2>
{
    80200e0c:	e406                	sd	ra,8(sp)
    assert(n > 0);
    80200e0e:	aeaff0ef          	jal	802000f8 <__panic>

0000000080200e12 <best_fit_init_memmap>:
{
    80200e12:	1141                	add	sp,sp,-16
    80200e14:	e406                	sd	ra,8(sp)
    assert(n > 0);
    80200e16:	c5f9                	beqz	a1,80200ee4 <best_fit_init_memmap+0xd2>
    for (; p != base + n; p ++) {
    80200e18:	00259713          	sll	a4,a1,0x2
    80200e1c:	972e                	add	a4,a4,a1
    80200e1e:	070e                	sll	a4,a4,0x3
    80200e20:	00e506b3          	add	a3,a0,a4
    80200e24:	87aa                	mv	a5,a0
    80200e26:	cf11                	beqz	a4,80200e42 <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
    80200e28:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
    80200e2a:	8b05                	and	a4,a4,1
    80200e2c:	cf49                	beqz	a4,80200ec6 <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
    80200e2e:	0007a823          	sw	zero,16(a5)
    80200e32:	0007b423          	sd	zero,8(a5)
    80200e36:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
    80200e3a:	02878793          	add	a5,a5,40
    80200e3e:	fed795e3          	bne	a5,a3,80200e28 <best_fit_init_memmap+0x16>
    base->property = n;
    80200e42:	2581                	sext.w	a1,a1
    80200e44:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
    80200e46:	4789                	li	a5,2
    80200e48:	00850713          	add	a4,a0,8
    80200e4c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
    80200e50:	00004697          	auipc	a3,0x4
    80200e54:	1b868693          	add	a3,a3,440 # 80205008 <free_area1>
    80200e58:	4a98                	lw	a4,16(a3)
    return list->next == list;
    80200e5a:	669c                	ld	a5,8(a3)
    80200e5c:	9f2d                	addw	a4,a4,a1
    80200e5e:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
    80200e60:	04d78663          	beq	a5,a3,80200eac <best_fit_init_memmap+0x9a>
            struct Page* page = le2page(le, page_link);
    80200e64:	fe878713          	add	a4,a5,-24
    80200e68:	4581                	li	a1,0
    80200e6a:	01850613          	add	a2,a0,24
            if (base < page) {
    80200e6e:	00e56a63          	bltu	a0,a4,80200e82 <best_fit_init_memmap+0x70>
    return listelm->next;
    80200e72:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
    80200e74:	02d70263          	beq	a4,a3,80200e98 <best_fit_init_memmap+0x86>
    for (; p != base + n; p ++) {
    80200e78:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
    80200e7a:	fe878713          	add	a4,a5,-24
            if (base < page) {
    80200e7e:	fee57ae3          	bgeu	a0,a4,80200e72 <best_fit_init_memmap+0x60>
    80200e82:	c199                	beqz	a1,80200e88 <best_fit_init_memmap+0x76>
    80200e84:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
    80200e88:	6398                	ld	a4,0(a5)
}
    80200e8a:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
    80200e8c:	e390                	sd	a2,0(a5)
    80200e8e:	e710                	sd	a2,8(a4)
    elm->next = next;
    80200e90:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200e92:	ed18                	sd	a4,24(a0)
    80200e94:	0141                	add	sp,sp,16
    80200e96:	8082                	ret
    prev->next = next->prev = elm;
    80200e98:	e790                	sd	a2,8(a5)
    elm->next = next;
    80200e9a:	f114                	sd	a3,32(a0)
    return listelm->next;
    80200e9c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
    80200e9e:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
    80200ea0:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
    80200ea2:	00d70e63          	beq	a4,a3,80200ebe <best_fit_init_memmap+0xac>
    80200ea6:	4585                	li	a1,1
    for (; p != base + n; p ++) {
    80200ea8:	87ba                	mv	a5,a4
    80200eaa:	bfc1                	j	80200e7a <best_fit_init_memmap+0x68>
}
    80200eac:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
    80200eae:	01850713          	add	a4,a0,24
    prev->next = next->prev = elm;
    80200eb2:	e398                	sd	a4,0(a5)
    80200eb4:	e798                	sd	a4,8(a5)
    elm->next = next;
    80200eb6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200eb8:	ed1c                	sd	a5,24(a0)
}
    80200eba:	0141                	add	sp,sp,16
    80200ebc:	8082                	ret
    80200ebe:	60a2                	ld	ra,8(sp)
    80200ec0:	e290                	sd	a2,0(a3)
    80200ec2:	0141                	add	sp,sp,16
    80200ec4:	8082                	ret
        assert(PageReserved(p));
    80200ec6:	00001697          	auipc	a3,0x1
    80200eca:	e6a68693          	add	a3,a3,-406 # 80201d30 <etext+0x7ca>
    80200ece:	00001617          	auipc	a2,0x1
    80200ed2:	b5260613          	add	a2,a2,-1198 # 80201a20 <etext+0x4ba>
    80200ed6:	45e9                	li	a1,26
    80200ed8:	00001517          	auipc	a0,0x1
    80200edc:	b6050513          	add	a0,a0,-1184 # 80201a38 <etext+0x4d2>
    80200ee0:	a18ff0ef          	jal	802000f8 <__panic>
    assert(n > 0);
    80200ee4:	00001697          	auipc	a3,0x1
    80200ee8:	e1c68693          	add	a3,a3,-484 # 80201d00 <etext+0x79a>
    80200eec:	00001617          	auipc	a2,0x1
    80200ef0:	b3460613          	add	a2,a2,-1228 # 80201a20 <etext+0x4ba>
    80200ef4:	45dd                	li	a1,23
    80200ef6:	00001517          	auipc	a0,0x1
    80200efa:	b4250513          	add	a0,a0,-1214 # 80201a38 <etext+0x4d2>
    80200efe:	9faff0ef          	jal	802000f8 <__panic>

0000000080200f02 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
    80200f02:	100027f3          	csrr	a5,sstatus
    80200f06:	8b89                	and	a5,a5,2
    80200f08:	e799                	bnez	a5,80200f16 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
    80200f0a:	00004797          	auipc	a5,0x4
    80200f0e:	1267b783          	ld	a5,294(a5) # 80205030 <pmm_manager>
    80200f12:	6f9c                	ld	a5,24(a5)
    80200f14:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
    80200f16:	1141                	add	sp,sp,-16
    80200f18:	e406                	sd	ra,8(sp)
    80200f1a:	e022                	sd	s0,0(sp)
    80200f1c:	842a                	mv	s0,a0
        intr_disable();
    80200f1e:	a50ff0ef          	jal	8020016e <intr_disable>
        page = pmm_manager->alloc_pages(n);
    80200f22:	00004797          	auipc	a5,0x4
    80200f26:	10e7b783          	ld	a5,270(a5) # 80205030 <pmm_manager>
    80200f2a:	6f9c                	ld	a5,24(a5)
    80200f2c:	8522                	mv	a0,s0
    80200f2e:	9782                	jalr	a5
    80200f30:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    80200f32:	a36ff0ef          	jal	80200168 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
    80200f36:	60a2                	ld	ra,8(sp)
    80200f38:	8522                	mv	a0,s0
    80200f3a:	6402                	ld	s0,0(sp)
    80200f3c:	0141                	add	sp,sp,16
    80200f3e:	8082                	ret

0000000080200f40 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
    80200f40:	100027f3          	csrr	a5,sstatus
    80200f44:	8b89                	and	a5,a5,2
    80200f46:	e799                	bnez	a5,80200f54 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
    80200f48:	00004797          	auipc	a5,0x4
    80200f4c:	0e87b783          	ld	a5,232(a5) # 80205030 <pmm_manager>
    80200f50:	739c                	ld	a5,32(a5)
    80200f52:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
    80200f54:	1101                	add	sp,sp,-32
    80200f56:	ec06                	sd	ra,24(sp)
    80200f58:	e822                	sd	s0,16(sp)
    80200f5a:	e426                	sd	s1,8(sp)
    80200f5c:	842a                	mv	s0,a0
    80200f5e:	84ae                	mv	s1,a1
        intr_disable();
    80200f60:	a0eff0ef          	jal	8020016e <intr_disable>
        pmm_manager->free_pages(base, n);
    80200f64:	00004797          	auipc	a5,0x4
    80200f68:	0cc7b783          	ld	a5,204(a5) # 80205030 <pmm_manager>
    80200f6c:	739c                	ld	a5,32(a5)
    80200f6e:	85a6                	mv	a1,s1
    80200f70:	8522                	mv	a0,s0
    80200f72:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
    80200f74:	6442                	ld	s0,16(sp)
    80200f76:	60e2                	ld	ra,24(sp)
    80200f78:	64a2                	ld	s1,8(sp)
    80200f7a:	6105                	add	sp,sp,32
        intr_enable();
    80200f7c:	9ecff06f          	j	80200168 <intr_enable>

0000000080200f80 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
    80200f80:	100027f3          	csrr	a5,sstatus
    80200f84:	8b89                	and	a5,a5,2
    80200f86:	e799                	bnez	a5,80200f94 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
    80200f88:	00004797          	auipc	a5,0x4
    80200f8c:	0a87b783          	ld	a5,168(a5) # 80205030 <pmm_manager>
    80200f90:	779c                	ld	a5,40(a5)
    80200f92:	8782                	jr	a5
size_t nr_free_pages(void) {
    80200f94:	1141                	add	sp,sp,-16
    80200f96:	e406                	sd	ra,8(sp)
    80200f98:	e022                	sd	s0,0(sp)
        intr_disable();
    80200f9a:	9d4ff0ef          	jal	8020016e <intr_disable>
        ret = pmm_manager->nr_free_pages();
    80200f9e:	00004797          	auipc	a5,0x4
    80200fa2:	0927b783          	ld	a5,146(a5) # 80205030 <pmm_manager>
    80200fa6:	779c                	ld	a5,40(a5)
    80200fa8:	9782                	jalr	a5
    80200faa:	842a                	mv	s0,a0
        intr_enable();
    80200fac:	9bcff0ef          	jal	80200168 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
    80200fb0:	60a2                	ld	ra,8(sp)
    80200fb2:	8522                	mv	a0,s0
    80200fb4:	6402                	ld	s0,0(sp)
    80200fb6:	0141                	add	sp,sp,16
    80200fb8:	8082                	ret

0000000080200fba <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
    80200fba:	00001797          	auipc	a5,0x1
    80200fbe:	d9e78793          	add	a5,a5,-610 # 80201d58 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
    80200fc2:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
    80200fc4:	1141                	add	sp,sp,-16
    80200fc6:	e406                	sd	ra,8(sp)
    80200fc8:	e022                	sd	s0,0(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
    80200fca:	00001517          	auipc	a0,0x1
    80200fce:	dc650513          	add	a0,a0,-570 # 80201d90 <best_fit_pmm_manager+0x38>
    pmm_manager = &best_fit_pmm_manager;
    80200fd2:	00004417          	auipc	s0,0x4
    80200fd6:	05e40413          	add	s0,s0,94 # 80205030 <pmm_manager>
    80200fda:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
    80200fdc:	8a6ff0ef          	jal	80200082 <cprintf>
    pmm_manager->init();
    80200fe0:	601c                	ld	a5,0(s0)
    80200fe2:	679c                	ld	a5,8(a5)
    80200fe4:	9782                	jalr	a5
    cprintf("physcial memory map:\n");
    80200fe6:	00001517          	auipc	a0,0x1
    80200fea:	dc250513          	add	a0,a0,-574 # 80201da8 <best_fit_pmm_manager+0x50>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET; 
    80200fee:	00004797          	auipc	a5,0x4
    80200ff2:	0407b523          	sd	zero,74(a5) # 80205038 <va_pa_offset>
    cprintf("physcial memory map:\n");
    80200ff6:	88cff0ef          	jal	80200082 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
    80200ffa:	46c5                	li	a3,17
    80200ffc:	06ee                	sll	a3,a3,0x1b
    80200ffe:	40100613          	li	a2,1025
    80201002:	16fd                	add	a3,a3,-1
    80201004:	0656                	sll	a2,a2,0x15
    80201006:	07e005b7          	lui	a1,0x7e00
    8020100a:	00001517          	auipc	a0,0x1
    8020100e:	db650513          	add	a0,a0,-586 # 80201dc0 <best_fit_pmm_manager+0x68>
    80201012:	870ff0ef          	jal	80200082 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    80201016:	777d                	lui	a4,0xfffff
    80201018:	00005797          	auipc	a5,0x5
    8020101c:	03f78793          	add	a5,a5,63 # 80206057 <end+0xfff>
    80201020:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
    80201022:	00004517          	auipc	a0,0x4
    80201026:	01e50513          	add	a0,a0,30 # 80205040 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    8020102a:	00004597          	auipc	a1,0x4
    8020102e:	01e58593          	add	a1,a1,30 # 80205048 <pages>
    npage = maxpa / PGSIZE;
    80201032:	00088737          	lui	a4,0x88
    80201036:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
    80201038:	e19c                	sd	a5,0(a1)
    8020103a:	4705                	li	a4,1
    8020103c:	07a1                	add	a5,a5,8
    8020103e:	40e7b02f          	amoor.d	zero,a4,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
    80201042:	02800693          	li	a3,40
    80201046:	4885                	li	a7,1
    80201048:	fff80837          	lui	a6,0xfff80
        SetPageReserved(pages + i);
    8020104c:	619c                	ld	a5,0(a1)
    8020104e:	97b6                	add	a5,a5,a3
    80201050:	07a1                	add	a5,a5,8
    80201052:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
    80201056:	611c                	ld	a5,0(a0)
    80201058:	0705                	add	a4,a4,1 # 88001 <kern_entry-0x80177fff>
    8020105a:	02868693          	add	a3,a3,40
    8020105e:	01078633          	add	a2,a5,a6
    80201062:	fec765e3          	bltu	a4,a2,8020104c <pmm_init+0x92>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
    80201066:	6190                	ld	a2,0(a1)
    80201068:	00279693          	sll	a3,a5,0x2
    8020106c:	96be                	add	a3,a3,a5
    8020106e:	fec00737          	lui	a4,0xfec00
    80201072:	9732                	add	a4,a4,a2
    80201074:	068e                	sll	a3,a3,0x3
    80201076:	96ba                	add	a3,a3,a4
    80201078:	40100713          	li	a4,1025
    8020107c:	0756                	sll	a4,a4,0x15
    8020107e:	08e6e263          	bltu	a3,a4,80201102 <pmm_init+0x148>
    80201082:	00004717          	auipc	a4,0x4
    80201086:	fb673703          	ld	a4,-74(a4) # 80205038 <va_pa_offset>
    if (freemem < mem_end) {
    8020108a:	45c5                	li	a1,17
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
    8020108c:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
    8020108e:	05ee                	sll	a1,a1,0x1b
    80201090:	02b6e463          	bltu	a3,a1,802010b8 <pmm_init+0xfe>
    check_alloc_page();

}

static void check_alloc_page(void) {
    cprintf("starting check\n");
    80201094:	00001517          	auipc	a0,0x1
    80201098:	dc450513          	add	a0,a0,-572 # 80201e58 <best_fit_pmm_manager+0x100>
    8020109c:	fe7fe0ef          	jal	80200082 <cprintf>
    pmm_manager->check();
    802010a0:	601c                	ld	a5,0(s0)
    802010a2:	7b9c                	ld	a5,48(a5)
    802010a4:	9782                	jalr	a5
}
    802010a6:	6402                	ld	s0,0(sp)
    802010a8:	60a2                	ld	ra,8(sp)
    cprintf("check_alloc_page() succeeded!\n");
    802010aa:	00001517          	auipc	a0,0x1
    802010ae:	dbe50513          	add	a0,a0,-578 # 80201e68 <best_fit_pmm_manager+0x110>
}
    802010b2:	0141                	add	sp,sp,16
    cprintf("check_alloc_page() succeeded!\n");
    802010b4:	fcffe06f          	j	80200082 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
    802010b8:	6705                	lui	a4,0x1
    802010ba:	177d                	add	a4,a4,-1 # fff <kern_entry-0x801ff001>
    802010bc:	96ba                	add	a3,a3,a4
    802010be:	777d                	lui	a4,0xfffff
    802010c0:	8ef9                	and	a3,a3,a4
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa)
{
    if (PPN(pa) >= npage)
    802010c2:	00c6d713          	srl	a4,a3,0xc
    802010c6:	02f77263          	bgeu	a4,a5,802010ea <pmm_init+0x130>
    pmm_manager->init_memmap(base, n);
    802010ca:	00043803          	ld	a6,0(s0)
    {
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
    802010ce:	fff807b7          	lui	a5,0xfff80
    802010d2:	97ba                	add	a5,a5,a4
    802010d4:	00279513          	sll	a0,a5,0x2
    802010d8:	953e                	add	a0,a0,a5
    802010da:	01083783          	ld	a5,16(a6) # fffffffffff80010 <end+0xffffffff7fd7afb8>
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    802010de:	8d95                	sub	a1,a1,a3
    802010e0:	050e                	sll	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
    802010e2:	81b1                	srl	a1,a1,0xc
    802010e4:	9532                	add	a0,a0,a2
    802010e6:	9782                	jalr	a5
}
    802010e8:	b775                	j	80201094 <pmm_init+0xda>
        panic("pa2page called with invalid pa");
    802010ea:	00001617          	auipc	a2,0x1
    802010ee:	d3e60613          	add	a2,a2,-706 # 80201e28 <best_fit_pmm_manager+0xd0>
    802010f2:	06f00593          	li	a1,111
    802010f6:	00001517          	auipc	a0,0x1
    802010fa:	d5250513          	add	a0,a0,-686 # 80201e48 <best_fit_pmm_manager+0xf0>
    802010fe:	ffbfe0ef          	jal	802000f8 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
    80201102:	00001617          	auipc	a2,0x1
    80201106:	cee60613          	add	a2,a2,-786 # 80201df0 <best_fit_pmm_manager+0x98>
    8020110a:	06f00593          	li	a1,111
    8020110e:	00001517          	auipc	a0,0x1
    80201112:	d0a50513          	add	a0,a0,-758 # 80201e18 <best_fit_pmm_manager+0xc0>
    80201116:	fe3fe0ef          	jal	802000f8 <__panic>

000000008020111a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
    8020111a:	02069813          	sll	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    8020111e:	7179                	add	sp,sp,-48
    unsigned mod = do_div(result, base);
    80201120:	02085813          	srl	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    80201124:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
    80201126:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
    8020112a:	f022                	sd	s0,32(sp)
    8020112c:	ec26                	sd	s1,24(sp)
    8020112e:	e84a                	sd	s2,16(sp)
    80201130:	f406                	sd	ra,40(sp)
    80201132:	e44e                	sd	s3,8(sp)
    80201134:	84aa                	mv	s1,a0
    80201136:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
    80201138:	fff7041b          	addw	s0,a4,-1 # ffffffffffffefff <end+0xffffffff7fdf9fa7>
    unsigned mod = do_div(result, base);
    8020113c:	2a01                	sext.w	s4,s4
    if (num >= base) {
    8020113e:	03067f63          	bgeu	a2,a6,8020117c <printnum+0x62>
    80201142:	89be                	mv	s3,a5
        while (-- width > 0)
    80201144:	4785                	li	a5,1
    80201146:	00e7d763          	bge	a5,a4,80201154 <printnum+0x3a>
    8020114a:	347d                	addw	s0,s0,-1
            putch(padc, putdat);
    8020114c:	85ca                	mv	a1,s2
    8020114e:	854e                	mv	a0,s3
    80201150:	9482                	jalr	s1
        while (-- width > 0)
    80201152:	fc65                	bnez	s0,8020114a <printnum+0x30>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
    80201154:	1a02                	sll	s4,s4,0x20
    80201156:	020a5a13          	srl	s4,s4,0x20
    8020115a:	00001797          	auipc	a5,0x1
    8020115e:	d2e78793          	add	a5,a5,-722 # 80201e88 <best_fit_pmm_manager+0x130>
    80201162:	97d2                	add	a5,a5,s4
}
    80201164:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
    80201166:	0007c503          	lbu	a0,0(a5)
}
    8020116a:	70a2                	ld	ra,40(sp)
    8020116c:	69a2                	ld	s3,8(sp)
    8020116e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
    80201170:	85ca                	mv	a1,s2
    80201172:	87a6                	mv	a5,s1
}
    80201174:	6942                	ld	s2,16(sp)
    80201176:	64e2                	ld	s1,24(sp)
    80201178:	6145                	add	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
    8020117a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
    8020117c:	03065633          	divu	a2,a2,a6
    80201180:	8722                	mv	a4,s0
    80201182:	f99ff0ef          	jal	8020111a <printnum>
    80201186:	b7f9                	j	80201154 <printnum+0x3a>

0000000080201188 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
    80201188:	7119                	add	sp,sp,-128
    8020118a:	f4a6                	sd	s1,104(sp)
    8020118c:	f0ca                	sd	s2,96(sp)
    8020118e:	ecce                	sd	s3,88(sp)
    80201190:	e8d2                	sd	s4,80(sp)
    80201192:	e4d6                	sd	s5,72(sp)
    80201194:	e0da                	sd	s6,64(sp)
    80201196:	f862                	sd	s8,48(sp)
    80201198:	fc86                	sd	ra,120(sp)
    8020119a:	f8a2                	sd	s0,112(sp)
    8020119c:	fc5e                	sd	s7,56(sp)
    8020119e:	f466                	sd	s9,40(sp)
    802011a0:	f06a                	sd	s10,32(sp)
    802011a2:	ec6e                	sd	s11,24(sp)
    802011a4:	892a                	mv	s2,a0
    802011a6:	84ae                	mv	s1,a1
    802011a8:	8c32                	mv	s8,a2
    802011aa:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802011ac:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
    802011b0:	05500b13          	li	s6,85
    802011b4:	00001a97          	auipc	s5,0x1
    802011b8:	d08a8a93          	add	s5,s5,-760 # 80201ebc <best_fit_pmm_manager+0x164>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802011bc:	000c4503          	lbu	a0,0(s8)
    802011c0:	001c0413          	add	s0,s8,1
    802011c4:	01350a63          	beq	a0,s3,802011d8 <vprintfmt+0x50>
            if (ch == '\0') {
    802011c8:	cd0d                	beqz	a0,80201202 <vprintfmt+0x7a>
            putch(ch, putdat);
    802011ca:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802011cc:	0405                	add	s0,s0,1
            putch(ch, putdat);
    802011ce:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802011d0:	fff44503          	lbu	a0,-1(s0)
    802011d4:	ff351ae3          	bne	a0,s3,802011c8 <vprintfmt+0x40>
        char padc = ' ';
    802011d8:	02000d93          	li	s11,32
        lflag = altflag = 0;
    802011dc:	4b81                	li	s7,0
    802011de:	4601                	li	a2,0
        width = precision = -1;
    802011e0:	5d7d                	li	s10,-1
    802011e2:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
    802011e4:	00044683          	lbu	a3,0(s0)
    802011e8:	00140c13          	add	s8,s0,1
    802011ec:	fdd6859b          	addw	a1,a3,-35
    802011f0:	0ff5f593          	zext.b	a1,a1
    802011f4:	02bb6663          	bltu	s6,a1,80201220 <vprintfmt+0x98>
    802011f8:	058a                	sll	a1,a1,0x2
    802011fa:	95d6                	add	a1,a1,s5
    802011fc:	4198                	lw	a4,0(a1)
    802011fe:	9756                	add	a4,a4,s5
    80201200:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
    80201202:	70e6                	ld	ra,120(sp)
    80201204:	7446                	ld	s0,112(sp)
    80201206:	74a6                	ld	s1,104(sp)
    80201208:	7906                	ld	s2,96(sp)
    8020120a:	69e6                	ld	s3,88(sp)
    8020120c:	6a46                	ld	s4,80(sp)
    8020120e:	6aa6                	ld	s5,72(sp)
    80201210:	6b06                	ld	s6,64(sp)
    80201212:	7be2                	ld	s7,56(sp)
    80201214:	7c42                	ld	s8,48(sp)
    80201216:	7ca2                	ld	s9,40(sp)
    80201218:	7d02                	ld	s10,32(sp)
    8020121a:	6de2                	ld	s11,24(sp)
    8020121c:	6109                	add	sp,sp,128
    8020121e:	8082                	ret
            putch('%', putdat);
    80201220:	85a6                	mv	a1,s1
    80201222:	02500513          	li	a0,37
    80201226:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
    80201228:	fff44703          	lbu	a4,-1(s0)
    8020122c:	02500793          	li	a5,37
    80201230:	8c22                	mv	s8,s0
    80201232:	f8f705e3          	beq	a4,a5,802011bc <vprintfmt+0x34>
    80201236:	02500713          	li	a4,37
    8020123a:	ffec4783          	lbu	a5,-2(s8)
    8020123e:	1c7d                	add	s8,s8,-1
    80201240:	fee79de3          	bne	a5,a4,8020123a <vprintfmt+0xb2>
    80201244:	bfa5                	j	802011bc <vprintfmt+0x34>
                ch = *fmt;
    80201246:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
    8020124a:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
    8020124c:	fd068d1b          	addw	s10,a3,-48
                if (ch < '0' || ch > '9') {
    80201250:	fd07859b          	addw	a1,a5,-48
                ch = *fmt;
    80201254:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
    80201258:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
    8020125a:	02b76563          	bltu	a4,a1,80201284 <vprintfmt+0xfc>
    8020125e:	4525                	li	a0,9
                ch = *fmt;
    80201260:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
    80201264:	002d171b          	sllw	a4,s10,0x2
    80201268:	01a7073b          	addw	a4,a4,s10
    8020126c:	0017171b          	sllw	a4,a4,0x1
    80201270:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
    80201272:	fd07859b          	addw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
    80201276:	0405                	add	s0,s0,1
                precision = precision * 10 + ch - '0';
    80201278:	fd070d1b          	addw	s10,a4,-48
                ch = *fmt;
    8020127c:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
    80201280:	feb570e3          	bgeu	a0,a1,80201260 <vprintfmt+0xd8>
            if (width < 0)
    80201284:	f60cd0e3          	bgez	s9,802011e4 <vprintfmt+0x5c>
                width = precision, precision = -1;
    80201288:	8cea                	mv	s9,s10
    8020128a:	5d7d                	li	s10,-1
    8020128c:	bfa1                	j	802011e4 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
    8020128e:	8db6                	mv	s11,a3
    80201290:	8462                	mv	s0,s8
    80201292:	bf89                	j	802011e4 <vprintfmt+0x5c>
    80201294:	8462                	mv	s0,s8
            altflag = 1;
    80201296:	4b85                	li	s7,1
            goto reswitch;
    80201298:	b7b1                	j	802011e4 <vprintfmt+0x5c>
    if (lflag >= 2) {
    8020129a:	4785                	li	a5,1
            precision = va_arg(ap, int);
    8020129c:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
    802012a0:	00c7c463          	blt	a5,a2,802012a8 <vprintfmt+0x120>
    else if (lflag) {
    802012a4:	1a060263          	beqz	a2,80201448 <vprintfmt+0x2c0>
        return va_arg(*ap, unsigned long);
    802012a8:	000a3603          	ld	a2,0(s4)
    802012ac:	46c1                	li	a3,16
    802012ae:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
    802012b0:	000d879b          	sext.w	a5,s11
    802012b4:	8766                	mv	a4,s9
    802012b6:	85a6                	mv	a1,s1
    802012b8:	854a                	mv	a0,s2
    802012ba:	e61ff0ef          	jal	8020111a <printnum>
            break;
    802012be:	bdfd                	j	802011bc <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
    802012c0:	000a2503          	lw	a0,0(s4)
    802012c4:	85a6                	mv	a1,s1
    802012c6:	0a21                	add	s4,s4,8
    802012c8:	9902                	jalr	s2
            break;
    802012ca:	bdcd                	j	802011bc <vprintfmt+0x34>
    if (lflag >= 2) {
    802012cc:	4785                	li	a5,1
            precision = va_arg(ap, int);
    802012ce:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
    802012d2:	00c7c463          	blt	a5,a2,802012da <vprintfmt+0x152>
    else if (lflag) {
    802012d6:	16060463          	beqz	a2,8020143e <vprintfmt+0x2b6>
        return va_arg(*ap, unsigned long);
    802012da:	000a3603          	ld	a2,0(s4)
    802012de:	46a9                	li	a3,10
    802012e0:	8a3a                	mv	s4,a4
    802012e2:	b7f9                	j	802012b0 <vprintfmt+0x128>
            putch('0', putdat);
    802012e4:	03000513          	li	a0,48
    802012e8:	85a6                	mv	a1,s1
    802012ea:	9902                	jalr	s2
            putch('x', putdat);
    802012ec:	85a6                	mv	a1,s1
    802012ee:	07800513          	li	a0,120
    802012f2:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
    802012f4:	0a21                	add	s4,s4,8
            goto number;
    802012f6:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
    802012f8:	ff8a3603          	ld	a2,-8(s4)
            goto number;
    802012fc:	bf55                	j	802012b0 <vprintfmt+0x128>
            putch(ch, putdat);
    802012fe:	85a6                	mv	a1,s1
    80201300:	02500513          	li	a0,37
    80201304:	9902                	jalr	s2
            break;
    80201306:	bd5d                	j	802011bc <vprintfmt+0x34>
            precision = va_arg(ap, int);
    80201308:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
    8020130c:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
    8020130e:	0a21                	add	s4,s4,8
            goto process_precision;
    80201310:	bf95                	j	80201284 <vprintfmt+0xfc>
    if (lflag >= 2) {
    80201312:	4785                	li	a5,1
            precision = va_arg(ap, int);
    80201314:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
    80201318:	00c7c463          	blt	a5,a2,80201320 <vprintfmt+0x198>
    else if (lflag) {
    8020131c:	10060c63          	beqz	a2,80201434 <vprintfmt+0x2ac>
        return va_arg(*ap, unsigned long);
    80201320:	000a3603          	ld	a2,0(s4)
    80201324:	46a1                	li	a3,8
    80201326:	8a3a                	mv	s4,a4
    80201328:	b761                	j	802012b0 <vprintfmt+0x128>
            if (width < 0)
    8020132a:	fffcc793          	not	a5,s9
    8020132e:	97fd                	sra	a5,a5,0x3f
    80201330:	00fcf7b3          	and	a5,s9,a5
    80201334:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
    80201338:	8462                	mv	s0,s8
            goto reswitch;
    8020133a:	b56d                	j	802011e4 <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
    8020133c:	000a3403          	ld	s0,0(s4)
    80201340:	008a0793          	add	a5,s4,8
    80201344:	e43e                	sd	a5,8(sp)
    80201346:	12040163          	beqz	s0,80201468 <vprintfmt+0x2e0>
            if (width > 0 && padc != '-') {
    8020134a:	0d905963          	blez	s9,8020141c <vprintfmt+0x294>
    8020134e:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80201352:	00140a13          	add	s4,s0,1
            if (width > 0 && padc != '-') {
    80201356:	12fd9863          	bne	s11,a5,80201486 <vprintfmt+0x2fe>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    8020135a:	00044783          	lbu	a5,0(s0)
    8020135e:	0007851b          	sext.w	a0,a5
    80201362:	cb9d                	beqz	a5,80201398 <vprintfmt+0x210>
    80201364:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
    80201366:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    8020136a:	000d4563          	bltz	s10,80201374 <vprintfmt+0x1ec>
    8020136e:	3d7d                	addw	s10,s10,-1
    80201370:	028d0263          	beq	s10,s0,80201394 <vprintfmt+0x20c>
                    putch('?', putdat);
    80201374:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
    80201376:	0c0b8e63          	beqz	s7,80201452 <vprintfmt+0x2ca>
    8020137a:	3781                	addw	a5,a5,-32
    8020137c:	0cfdfb63          	bgeu	s11,a5,80201452 <vprintfmt+0x2ca>
                    putch('?', putdat);
    80201380:	03f00513          	li	a0,63
    80201384:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80201386:	000a4783          	lbu	a5,0(s4)
    8020138a:	3cfd                	addw	s9,s9,-1
    8020138c:	0a05                	add	s4,s4,1
    8020138e:	0007851b          	sext.w	a0,a5
    80201392:	ffe1                	bnez	a5,8020136a <vprintfmt+0x1e2>
            for (; width > 0; width --) {
    80201394:	01905963          	blez	s9,802013a6 <vprintfmt+0x21e>
    80201398:	3cfd                	addw	s9,s9,-1
                putch(' ', putdat);
    8020139a:	85a6                	mv	a1,s1
    8020139c:	02000513          	li	a0,32
    802013a0:	9902                	jalr	s2
            for (; width > 0; width --) {
    802013a2:	fe0c9be3          	bnez	s9,80201398 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
    802013a6:	6a22                	ld	s4,8(sp)
    802013a8:	bd11                	j	802011bc <vprintfmt+0x34>
    if (lflag >= 2) {
    802013aa:	4785                	li	a5,1
            precision = va_arg(ap, int);
    802013ac:	008a0b93          	add	s7,s4,8
    if (lflag >= 2) {
    802013b0:	00c7c363          	blt	a5,a2,802013b6 <vprintfmt+0x22e>
    else if (lflag) {
    802013b4:	ce2d                	beqz	a2,8020142e <vprintfmt+0x2a6>
        return va_arg(*ap, long);
    802013b6:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
    802013ba:	08044e63          	bltz	s0,80201456 <vprintfmt+0x2ce>
            num = getint(&ap, lflag);
    802013be:	8622                	mv	a2,s0
    802013c0:	8a5e                	mv	s4,s7
    802013c2:	46a9                	li	a3,10
    802013c4:	b5f5                	j	802012b0 <vprintfmt+0x128>
            if (err < 0) {
    802013c6:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    802013ca:	4619                	li	a2,6
            if (err < 0) {
    802013cc:	41f7d71b          	sraw	a4,a5,0x1f
    802013d0:	8fb9                	xor	a5,a5,a4
    802013d2:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    802013d6:	02d64663          	blt	a2,a3,80201402 <vprintfmt+0x27a>
    802013da:	00369713          	sll	a4,a3,0x3
    802013de:	00001797          	auipc	a5,0x1
    802013e2:	cba78793          	add	a5,a5,-838 # 80202098 <error_string>
    802013e6:	97ba                	add	a5,a5,a4
    802013e8:	639c                	ld	a5,0(a5)
    802013ea:	cf81                	beqz	a5,80201402 <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
    802013ec:	86be                	mv	a3,a5
    802013ee:	00001617          	auipc	a2,0x1
    802013f2:	aca60613          	add	a2,a2,-1334 # 80201eb8 <best_fit_pmm_manager+0x160>
    802013f6:	85a6                	mv	a1,s1
    802013f8:	854a                	mv	a0,s2
    802013fa:	0ea000ef          	jal	802014e4 <printfmt>
            err = va_arg(ap, int);
    802013fe:	0a21                	add	s4,s4,8
    80201400:	bb75                	j	802011bc <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
    80201402:	00001617          	auipc	a2,0x1
    80201406:	aa660613          	add	a2,a2,-1370 # 80201ea8 <best_fit_pmm_manager+0x150>
    8020140a:	85a6                	mv	a1,s1
    8020140c:	854a                	mv	a0,s2
    8020140e:	0d6000ef          	jal	802014e4 <printfmt>
            err = va_arg(ap, int);
    80201412:	0a21                	add	s4,s4,8
    80201414:	b365                	j	802011bc <vprintfmt+0x34>
            lflag ++;
    80201416:	2605                	addw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
    80201418:	8462                	mv	s0,s8
            goto reswitch;
    8020141a:	b3e9                	j	802011e4 <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    8020141c:	00044783          	lbu	a5,0(s0)
    80201420:	00140a13          	add	s4,s0,1
    80201424:	0007851b          	sext.w	a0,a5
    80201428:	ff95                	bnez	a5,80201364 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
    8020142a:	6a22                	ld	s4,8(sp)
    8020142c:	bb41                	j	802011bc <vprintfmt+0x34>
        return va_arg(*ap, int);
    8020142e:	000a2403          	lw	s0,0(s4)
    80201432:	b761                	j	802013ba <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
    80201434:	000a6603          	lwu	a2,0(s4)
    80201438:	46a1                	li	a3,8
    8020143a:	8a3a                	mv	s4,a4
    8020143c:	bd95                	j	802012b0 <vprintfmt+0x128>
    8020143e:	000a6603          	lwu	a2,0(s4)
    80201442:	46a9                	li	a3,10
    80201444:	8a3a                	mv	s4,a4
    80201446:	b5ad                	j	802012b0 <vprintfmt+0x128>
    80201448:	000a6603          	lwu	a2,0(s4)
    8020144c:	46c1                	li	a3,16
    8020144e:	8a3a                	mv	s4,a4
    80201450:	b585                	j	802012b0 <vprintfmt+0x128>
                    putch(ch, putdat);
    80201452:	9902                	jalr	s2
    80201454:	bf0d                	j	80201386 <vprintfmt+0x1fe>
                putch('-', putdat);
    80201456:	85a6                	mv	a1,s1
    80201458:	02d00513          	li	a0,45
    8020145c:	9902                	jalr	s2
                num = -(long long)num;
    8020145e:	8a5e                	mv	s4,s7
    80201460:	40800633          	neg	a2,s0
    80201464:	46a9                	li	a3,10
    80201466:	b5a9                	j	802012b0 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
    80201468:	01905663          	blez	s9,80201474 <vprintfmt+0x2ec>
    8020146c:	02d00793          	li	a5,45
    80201470:	04fd9263          	bne	s11,a5,802014b4 <vprintfmt+0x32c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    80201474:	00001a17          	auipc	s4,0x1
    80201478:	a2da0a13          	add	s4,s4,-1491 # 80201ea1 <best_fit_pmm_manager+0x149>
    8020147c:	02800513          	li	a0,40
    80201480:	02800793          	li	a5,40
    80201484:	b5c5                	j	80201364 <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
    80201486:	85ea                	mv	a1,s10
    80201488:	8522                	mv	a0,s0
    8020148a:	0ae000ef          	jal	80201538 <strnlen>
    8020148e:	40ac8cbb          	subw	s9,s9,a0
    80201492:	01905963          	blez	s9,802014a4 <vprintfmt+0x31c>
                    putch(padc, putdat);
    80201496:	2d81                	sext.w	s11,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
    80201498:	3cfd                	addw	s9,s9,-1
                    putch(padc, putdat);
    8020149a:	85a6                	mv	a1,s1
    8020149c:	856e                	mv	a0,s11
    8020149e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
    802014a0:	fe0c9ce3          	bnez	s9,80201498 <vprintfmt+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802014a4:	00044783          	lbu	a5,0(s0)
    802014a8:	0007851b          	sext.w	a0,a5
    802014ac:	ea079ce3          	bnez	a5,80201364 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
    802014b0:	6a22                	ld	s4,8(sp)
    802014b2:	b329                	j	802011bc <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
    802014b4:	85ea                	mv	a1,s10
    802014b6:	00001517          	auipc	a0,0x1
    802014ba:	9ea50513          	add	a0,a0,-1558 # 80201ea0 <best_fit_pmm_manager+0x148>
    802014be:	07a000ef          	jal	80201538 <strnlen>
    802014c2:	40ac8cbb          	subw	s9,s9,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802014c6:	00001a17          	auipc	s4,0x1
    802014ca:	9dba0a13          	add	s4,s4,-1573 # 80201ea1 <best_fit_pmm_manager+0x149>
                p = "(null)";
    802014ce:	00001417          	auipc	s0,0x1
    802014d2:	9d240413          	add	s0,s0,-1582 # 80201ea0 <best_fit_pmm_manager+0x148>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802014d6:	02800513          	li	a0,40
    802014da:	02800793          	li	a5,40
                for (width -= strnlen(p, precision); width > 0; width --) {
    802014de:	fb904ce3          	bgtz	s9,80201496 <vprintfmt+0x30e>
    802014e2:	b549                	j	80201364 <vprintfmt+0x1dc>

00000000802014e4 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802014e4:	715d                	add	sp,sp,-80
    va_start(ap, fmt);
    802014e6:	02810313          	add	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802014ea:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
    802014ec:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    802014ee:	ec06                	sd	ra,24(sp)
    802014f0:	f83a                	sd	a4,48(sp)
    802014f2:	fc3e                	sd	a5,56(sp)
    802014f4:	e0c2                	sd	a6,64(sp)
    802014f6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
    802014f8:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
    802014fa:	c8fff0ef          	jal	80201188 <vprintfmt>
}
    802014fe:	60e2                	ld	ra,24(sp)
    80201500:	6161                	add	sp,sp,80
    80201502:	8082                	ret

0000000080201504 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
    80201504:	4781                	li	a5,0
    80201506:	00004717          	auipc	a4,0x4
    8020150a:	afa73703          	ld	a4,-1286(a4) # 80205000 <SBI_CONSOLE_PUTCHAR>
    8020150e:	88ba                	mv	a7,a4
    80201510:	852a                	mv	a0,a0
    80201512:	85be                	mv	a1,a5
    80201514:	863e                	mv	a2,a5
    80201516:	00000073          	ecall
    8020151a:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
    8020151c:	8082                	ret

000000008020151e <sbi_set_timer>:
    __asm__ volatile (
    8020151e:	4781                	li	a5,0
    80201520:	00004717          	auipc	a4,0x4
    80201524:	b3073703          	ld	a4,-1232(a4) # 80205050 <SBI_SET_TIMER>
    80201528:	88ba                	mv	a7,a4
    8020152a:	852a                	mv	a0,a0
    8020152c:	85be                	mv	a1,a5
    8020152e:	863e                	mv	a2,a5
    80201530:	00000073          	ecall
    80201534:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
    80201536:	8082                	ret

0000000080201538 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    80201538:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
    8020153a:	e589                	bnez	a1,80201544 <strnlen+0xc>
    8020153c:	a811                	j	80201550 <strnlen+0x18>
        cnt ++;
    8020153e:	0785                	add	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
    80201540:	00f58863          	beq	a1,a5,80201550 <strnlen+0x18>
    80201544:	00f50733          	add	a4,a0,a5
    80201548:	00074703          	lbu	a4,0(a4)
    8020154c:	fb6d                	bnez	a4,8020153e <strnlen+0x6>
    8020154e:	85be                	mv	a1,a5
    }
    return cnt;
}
    80201550:	852e                	mv	a0,a1
    80201552:	8082                	ret

0000000080201554 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
    80201554:	ca01                	beqz	a2,80201564 <memset+0x10>
    80201556:	962a                	add	a2,a2,a0
    char *p = s;
    80201558:	87aa                	mv	a5,a0
        *p ++ = c;
    8020155a:	0785                	add	a5,a5,1
    8020155c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
    80201560:	fec79de3          	bne	a5,a2,8020155a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
    80201564:	8082                	ret
