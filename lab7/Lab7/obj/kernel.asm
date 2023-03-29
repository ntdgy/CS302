
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02092b7          	lui	t0,0xc0209
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc020001c:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200020:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc0200024:	c0209137          	lui	sp,0xc0209

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:

int kern_init(void) __attribute__((noreturn));
int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	0002a517          	auipc	a0,0x2a
ffffffffc0200036:	85e50513          	addi	a0,a0,-1954 # ffffffffc0229890 <buf>
ffffffffc020003a:	00035617          	auipc	a2,0x35
ffffffffc020003e:	d5e60613          	addi	a2,a2,-674 # ffffffffc0234d98 <end>
kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	51d040ef          	jal	ra,ffffffffc0204d66 <memset>
    cons_init();                // init the console
ffffffffc020004e:	51c000ef          	jal	ra,ffffffffc020056a <cons_init>

    const char *message = "OS is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200052:	00005597          	auipc	a1,0x5
ffffffffc0200056:	d3e58593          	addi	a1,a1,-706 # ffffffffc0204d90 <etext>
ffffffffc020005a:	00005517          	auipc	a0,0x5
ffffffffc020005e:	d4e50513          	addi	a0,a0,-690 # ffffffffc0204da8 <etext+0x18>
ffffffffc0200062:	11a000ef          	jal	ra,ffffffffc020017c <cprintf>

    pmm_init();                 // init physical memory management
ffffffffc0200066:	45b010ef          	jal	ra,ffffffffc0201cc0 <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	5d4000ef          	jal	ra,ffffffffc020063e <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020006e:	785020ef          	jal	ra,ffffffffc0202ff2 <vmm_init>
    sched_init();
ffffffffc0200072:	5cc040ef          	jal	ra,ffffffffc020463e <sched_init>
    proc_init();                // init process table
ffffffffc0200076:	2d8040ef          	jal	ra,ffffffffc020434e <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc020007a:	562000ef          	jal	ra,ffffffffc02005dc <ide_init>
    swap_init();                // init swap
ffffffffc020007e:	5cc020ef          	jal	ra,ffffffffc020264a <swap_init>

    clock_init();               // init clock interrupt
ffffffffc0200082:	4a0000ef          	jal	ra,ffffffffc0200522 <clock_init>
    intr_enable();              // enable irq interrupt
ffffffffc0200086:	5ac000ef          	jal	ra,ffffffffc0200632 <intr_enable>
    
    cpu_idle();                 // run idle process
ffffffffc020008a:	45a040ef          	jal	ra,ffffffffc02044e4 <cpu_idle>

ffffffffc020008e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020008e:	715d                	addi	sp,sp,-80
ffffffffc0200090:	e486                	sd	ra,72(sp)
ffffffffc0200092:	e0a6                	sd	s1,64(sp)
ffffffffc0200094:	fc4a                	sd	s2,56(sp)
ffffffffc0200096:	f84e                	sd	s3,48(sp)
ffffffffc0200098:	f452                	sd	s4,40(sp)
ffffffffc020009a:	f056                	sd	s5,32(sp)
ffffffffc020009c:	ec5a                	sd	s6,24(sp)
ffffffffc020009e:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000a0:	c901                	beqz	a0,ffffffffc02000b0 <readline+0x22>
ffffffffc02000a2:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000a4:	00005517          	auipc	a0,0x5
ffffffffc02000a8:	d0c50513          	addi	a0,a0,-756 # ffffffffc0204db0 <etext+0x20>
ffffffffc02000ac:	0d0000ef          	jal	ra,ffffffffc020017c <cprintf>
readline(const char *prompt) {
ffffffffc02000b0:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000b2:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000b4:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000b6:	4aa9                	li	s5,10
ffffffffc02000b8:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000ba:	00029b97          	auipc	s7,0x29
ffffffffc02000be:	7d6b8b93          	addi	s7,s7,2006 # ffffffffc0229890 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c2:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000c6:	12e000ef          	jal	ra,ffffffffc02001f4 <getchar>
        if (c < 0) {
ffffffffc02000ca:	00054a63          	bltz	a0,ffffffffc02000de <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	00a95a63          	bge	s2,a0,ffffffffc02000e2 <readline+0x54>
ffffffffc02000d2:	029a5263          	bge	s4,s1,ffffffffc02000f6 <readline+0x68>
        c = getchar();
ffffffffc02000d6:	11e000ef          	jal	ra,ffffffffc02001f4 <getchar>
        if (c < 0) {
ffffffffc02000da:	fe055ae3          	bgez	a0,ffffffffc02000ce <readline+0x40>
            return NULL;
ffffffffc02000de:	4501                	li	a0,0
ffffffffc02000e0:	a091                	j	ffffffffc0200124 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000e2:	03351463          	bne	a0,s3,ffffffffc020010a <readline+0x7c>
ffffffffc02000e6:	e8a9                	bnez	s1,ffffffffc0200138 <readline+0xaa>
        c = getchar();
ffffffffc02000e8:	10c000ef          	jal	ra,ffffffffc02001f4 <getchar>
        if (c < 0) {
ffffffffc02000ec:	fe0549e3          	bltz	a0,ffffffffc02000de <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000f0:	fea959e3          	bge	s2,a0,ffffffffc02000e2 <readline+0x54>
ffffffffc02000f4:	4481                	li	s1,0
            cputchar(c);
ffffffffc02000f6:	e42a                	sd	a0,8(sp)
ffffffffc02000f8:	0ba000ef          	jal	ra,ffffffffc02001b2 <cputchar>
            buf[i ++] = c;
ffffffffc02000fc:	6522                	ld	a0,8(sp)
ffffffffc02000fe:	009b87b3          	add	a5,s7,s1
ffffffffc0200102:	2485                	addiw	s1,s1,1
ffffffffc0200104:	00a78023          	sb	a0,0(a5)
ffffffffc0200108:	bf7d                	j	ffffffffc02000c6 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc020010a:	01550463          	beq	a0,s5,ffffffffc0200112 <readline+0x84>
ffffffffc020010e:	fb651ce3          	bne	a0,s6,ffffffffc02000c6 <readline+0x38>
            cputchar(c);
ffffffffc0200112:	0a0000ef          	jal	ra,ffffffffc02001b2 <cputchar>
            buf[i] = '\0';
ffffffffc0200116:	00029517          	auipc	a0,0x29
ffffffffc020011a:	77a50513          	addi	a0,a0,1914 # ffffffffc0229890 <buf>
ffffffffc020011e:	94aa                	add	s1,s1,a0
ffffffffc0200120:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200124:	60a6                	ld	ra,72(sp)
ffffffffc0200126:	6486                	ld	s1,64(sp)
ffffffffc0200128:	7962                	ld	s2,56(sp)
ffffffffc020012a:	79c2                	ld	s3,48(sp)
ffffffffc020012c:	7a22                	ld	s4,40(sp)
ffffffffc020012e:	7a82                	ld	s5,32(sp)
ffffffffc0200130:	6b62                	ld	s6,24(sp)
ffffffffc0200132:	6bc2                	ld	s7,16(sp)
ffffffffc0200134:	6161                	addi	sp,sp,80
ffffffffc0200136:	8082                	ret
            cputchar(c);
ffffffffc0200138:	4521                	li	a0,8
ffffffffc020013a:	078000ef          	jal	ra,ffffffffc02001b2 <cputchar>
            i --;
ffffffffc020013e:	34fd                	addiw	s1,s1,-1
ffffffffc0200140:	b759                	j	ffffffffc02000c6 <readline+0x38>

ffffffffc0200142 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200142:	1141                	addi	sp,sp,-16
ffffffffc0200144:	e022                	sd	s0,0(sp)
ffffffffc0200146:	e406                	sd	ra,8(sp)
ffffffffc0200148:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020014a:	422000ef          	jal	ra,ffffffffc020056c <cons_putc>
    (*cnt) ++;
ffffffffc020014e:	401c                	lw	a5,0(s0)
}
ffffffffc0200150:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200152:	2785                	addiw	a5,a5,1
ffffffffc0200154:	c01c                	sw	a5,0(s0)
}
ffffffffc0200156:	6402                	ld	s0,0(sp)
ffffffffc0200158:	0141                	addi	sp,sp,16
ffffffffc020015a:	8082                	ret

ffffffffc020015c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020015c:	1101                	addi	sp,sp,-32
ffffffffc020015e:	862a                	mv	a2,a0
ffffffffc0200160:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200162:	00000517          	auipc	a0,0x0
ffffffffc0200166:	fe050513          	addi	a0,a0,-32 # ffffffffc0200142 <cputch>
ffffffffc020016a:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc020016c:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc020016e:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200170:	00b040ef          	jal	ra,ffffffffc020497a <vprintfmt>
    return cnt;
}
ffffffffc0200174:	60e2                	ld	ra,24(sp)
ffffffffc0200176:	4532                	lw	a0,12(sp)
ffffffffc0200178:	6105                	addi	sp,sp,32
ffffffffc020017a:	8082                	ret

ffffffffc020017c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc020017c:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc020017e:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc0200182:	8e2a                	mv	t3,a0
ffffffffc0200184:	f42e                	sd	a1,40(sp)
ffffffffc0200186:	f832                	sd	a2,48(sp)
ffffffffc0200188:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fb850513          	addi	a0,a0,-72 # ffffffffc0200142 <cputch>
ffffffffc0200192:	004c                	addi	a1,sp,4
ffffffffc0200194:	869a                	mv	a3,t1
ffffffffc0200196:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc0200198:	ec06                	sd	ra,24(sp)
ffffffffc020019a:	e0ba                	sd	a4,64(sp)
ffffffffc020019c:	e4be                	sd	a5,72(sp)
ffffffffc020019e:	e8c2                	sd	a6,80(sp)
ffffffffc02001a0:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001a2:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001a4:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02001a6:	7d4040ef          	jal	ra,ffffffffc020497a <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001aa:	60e2                	ld	ra,24(sp)
ffffffffc02001ac:	4512                	lw	a0,4(sp)
ffffffffc02001ae:	6125                	addi	sp,sp,96
ffffffffc02001b0:	8082                	ret

ffffffffc02001b2 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02001b2:	ae6d                	j	ffffffffc020056c <cons_putc>

ffffffffc02001b4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02001b4:	1101                	addi	sp,sp,-32
ffffffffc02001b6:	e822                	sd	s0,16(sp)
ffffffffc02001b8:	ec06                	sd	ra,24(sp)
ffffffffc02001ba:	e426                	sd	s1,8(sp)
ffffffffc02001bc:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02001be:	00054503          	lbu	a0,0(a0)
ffffffffc02001c2:	c51d                	beqz	a0,ffffffffc02001f0 <cputs+0x3c>
ffffffffc02001c4:	0405                	addi	s0,s0,1
ffffffffc02001c6:	4485                	li	s1,1
ffffffffc02001c8:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001ca:	3a2000ef          	jal	ra,ffffffffc020056c <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001ce:	00044503          	lbu	a0,0(s0)
ffffffffc02001d2:	008487bb          	addw	a5,s1,s0
ffffffffc02001d6:	0405                	addi	s0,s0,1
ffffffffc02001d8:	f96d                	bnez	a0,ffffffffc02001ca <cputs+0x16>
    (*cnt) ++;
ffffffffc02001da:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001de:	4529                	li	a0,10
ffffffffc02001e0:	38c000ef          	jal	ra,ffffffffc020056c <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001e4:	60e2                	ld	ra,24(sp)
ffffffffc02001e6:	8522                	mv	a0,s0
ffffffffc02001e8:	6442                	ld	s0,16(sp)
ffffffffc02001ea:	64a2                	ld	s1,8(sp)
ffffffffc02001ec:	6105                	addi	sp,sp,32
ffffffffc02001ee:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001f0:	4405                	li	s0,1
ffffffffc02001f2:	b7f5                	j	ffffffffc02001de <cputs+0x2a>

ffffffffc02001f4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02001f4:	1141                	addi	sp,sp,-16
ffffffffc02001f6:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001f8:	3a8000ef          	jal	ra,ffffffffc02005a0 <cons_getc>
ffffffffc02001fc:	dd75                	beqz	a0,ffffffffc02001f8 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001fe:	60a2                	ld	ra,8(sp)
ffffffffc0200200:	0141                	addi	sp,sp,16
ffffffffc0200202:	8082                	ret

ffffffffc0200204 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200204:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200206:	00005517          	auipc	a0,0x5
ffffffffc020020a:	bb250513          	addi	a0,a0,-1102 # ffffffffc0204db8 <etext+0x28>
void print_kerninfo(void) {
ffffffffc020020e:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200210:	f6dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200214:	00000597          	auipc	a1,0x0
ffffffffc0200218:	e1e58593          	addi	a1,a1,-482 # ffffffffc0200032 <kern_init>
ffffffffc020021c:	00005517          	auipc	a0,0x5
ffffffffc0200220:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0204dd8 <etext+0x48>
ffffffffc0200224:	f59ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200228:	00005597          	auipc	a1,0x5
ffffffffc020022c:	b6858593          	addi	a1,a1,-1176 # ffffffffc0204d90 <etext>
ffffffffc0200230:	00005517          	auipc	a0,0x5
ffffffffc0200234:	bc850513          	addi	a0,a0,-1080 # ffffffffc0204df8 <etext+0x68>
ffffffffc0200238:	f45ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020023c:	00029597          	auipc	a1,0x29
ffffffffc0200240:	65458593          	addi	a1,a1,1620 # ffffffffc0229890 <buf>
ffffffffc0200244:	00005517          	auipc	a0,0x5
ffffffffc0200248:	bd450513          	addi	a0,a0,-1068 # ffffffffc0204e18 <etext+0x88>
ffffffffc020024c:	f31ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200250:	00035597          	auipc	a1,0x35
ffffffffc0200254:	b4858593          	addi	a1,a1,-1208 # ffffffffc0234d98 <end>
ffffffffc0200258:	00005517          	auipc	a0,0x5
ffffffffc020025c:	be050513          	addi	a0,a0,-1056 # ffffffffc0204e38 <etext+0xa8>
ffffffffc0200260:	f1dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200264:	00035597          	auipc	a1,0x35
ffffffffc0200268:	f3358593          	addi	a1,a1,-205 # ffffffffc0235197 <end+0x3ff>
ffffffffc020026c:	00000797          	auipc	a5,0x0
ffffffffc0200270:	dc678793          	addi	a5,a5,-570 # ffffffffc0200032 <kern_init>
ffffffffc0200274:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200278:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020027c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020027e:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200282:	95be                	add	a1,a1,a5
ffffffffc0200284:	85a9                	srai	a1,a1,0xa
ffffffffc0200286:	00005517          	auipc	a0,0x5
ffffffffc020028a:	bd250513          	addi	a0,a0,-1070 # ffffffffc0204e58 <etext+0xc8>
}
ffffffffc020028e:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	b5f5                	j	ffffffffc020017c <cprintf>

ffffffffc0200292 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200292:	1141                	addi	sp,sp,-16
     * and line number, etc.
     *    (3.5) popup a calling stackframe
     *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     *                   the calling funciton's ebp = ss:[ebp]
     */
    panic("Not Implemented!");
ffffffffc0200294:	00005617          	auipc	a2,0x5
ffffffffc0200298:	bf460613          	addi	a2,a2,-1036 # ffffffffc0204e88 <etext+0xf8>
ffffffffc020029c:	05b00593          	li	a1,91
ffffffffc02002a0:	00005517          	auipc	a0,0x5
ffffffffc02002a4:	c0050513          	addi	a0,a0,-1024 # ffffffffc0204ea0 <etext+0x110>
void print_stackframe(void) {
ffffffffc02002a8:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002aa:	1cc000ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02002ae <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002ae:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002b0:	00005617          	auipc	a2,0x5
ffffffffc02002b4:	c0860613          	addi	a2,a2,-1016 # ffffffffc0204eb8 <etext+0x128>
ffffffffc02002b8:	00005597          	auipc	a1,0x5
ffffffffc02002bc:	c2058593          	addi	a1,a1,-992 # ffffffffc0204ed8 <etext+0x148>
ffffffffc02002c0:	00005517          	auipc	a0,0x5
ffffffffc02002c4:	c2050513          	addi	a0,a0,-992 # ffffffffc0204ee0 <etext+0x150>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002c8:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ca:	eb3ff0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc02002ce:	00005617          	auipc	a2,0x5
ffffffffc02002d2:	c2260613          	addi	a2,a2,-990 # ffffffffc0204ef0 <etext+0x160>
ffffffffc02002d6:	00005597          	auipc	a1,0x5
ffffffffc02002da:	c4258593          	addi	a1,a1,-958 # ffffffffc0204f18 <etext+0x188>
ffffffffc02002de:	00005517          	auipc	a0,0x5
ffffffffc02002e2:	c0250513          	addi	a0,a0,-1022 # ffffffffc0204ee0 <etext+0x150>
ffffffffc02002e6:	e97ff0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc02002ea:	00005617          	auipc	a2,0x5
ffffffffc02002ee:	c3e60613          	addi	a2,a2,-962 # ffffffffc0204f28 <etext+0x198>
ffffffffc02002f2:	00005597          	auipc	a1,0x5
ffffffffc02002f6:	c5658593          	addi	a1,a1,-938 # ffffffffc0204f48 <etext+0x1b8>
ffffffffc02002fa:	00005517          	auipc	a0,0x5
ffffffffc02002fe:	be650513          	addi	a0,a0,-1050 # ffffffffc0204ee0 <etext+0x150>
ffffffffc0200302:	e7bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    }
    return 0;
}
ffffffffc0200306:	60a2                	ld	ra,8(sp)
ffffffffc0200308:	4501                	li	a0,0
ffffffffc020030a:	0141                	addi	sp,sp,16
ffffffffc020030c:	8082                	ret

ffffffffc020030e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020030e:	1141                	addi	sp,sp,-16
ffffffffc0200310:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200312:	ef3ff0ef          	jal	ra,ffffffffc0200204 <print_kerninfo>
    return 0;
}
ffffffffc0200316:	60a2                	ld	ra,8(sp)
ffffffffc0200318:	4501                	li	a0,0
ffffffffc020031a:	0141                	addi	sp,sp,16
ffffffffc020031c:	8082                	ret

ffffffffc020031e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020031e:	1141                	addi	sp,sp,-16
ffffffffc0200320:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200322:	f71ff0ef          	jal	ra,ffffffffc0200292 <print_stackframe>
    return 0;
}
ffffffffc0200326:	60a2                	ld	ra,8(sp)
ffffffffc0200328:	4501                	li	a0,0
ffffffffc020032a:	0141                	addi	sp,sp,16
ffffffffc020032c:	8082                	ret

ffffffffc020032e <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020032e:	7115                	addi	sp,sp,-224
ffffffffc0200330:	ed5e                	sd	s7,152(sp)
ffffffffc0200332:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200334:	00005517          	auipc	a0,0x5
ffffffffc0200338:	c2450513          	addi	a0,a0,-988 # ffffffffc0204f58 <etext+0x1c8>
kmonitor(struct trapframe *tf) {
ffffffffc020033c:	ed86                	sd	ra,216(sp)
ffffffffc020033e:	e9a2                	sd	s0,208(sp)
ffffffffc0200340:	e5a6                	sd	s1,200(sp)
ffffffffc0200342:	e1ca                	sd	s2,192(sp)
ffffffffc0200344:	fd4e                	sd	s3,184(sp)
ffffffffc0200346:	f952                	sd	s4,176(sp)
ffffffffc0200348:	f556                	sd	s5,168(sp)
ffffffffc020034a:	f15a                	sd	s6,160(sp)
ffffffffc020034c:	e962                	sd	s8,144(sp)
ffffffffc020034e:	e566                	sd	s9,136(sp)
ffffffffc0200350:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200352:	e2bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200356:	00005517          	auipc	a0,0x5
ffffffffc020035a:	c2a50513          	addi	a0,a0,-982 # ffffffffc0204f80 <etext+0x1f0>
ffffffffc020035e:	e1fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    if (tf != NULL) {
ffffffffc0200362:	000b8563          	beqz	s7,ffffffffc020036c <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200366:	855e                	mv	a0,s7
ffffffffc0200368:	4bc000ef          	jal	ra,ffffffffc0200824 <print_trapframe>
ffffffffc020036c:	00005c17          	auipc	s8,0x5
ffffffffc0200370:	c84c0c13          	addi	s8,s8,-892 # ffffffffc0204ff0 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200374:	00005917          	auipc	s2,0x5
ffffffffc0200378:	c3490913          	addi	s2,s2,-972 # ffffffffc0204fa8 <etext+0x218>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020037c:	00005497          	auipc	s1,0x5
ffffffffc0200380:	c3448493          	addi	s1,s1,-972 # ffffffffc0204fb0 <etext+0x220>
        if (argc == MAXARGS - 1) {
ffffffffc0200384:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200386:	00005b17          	auipc	s6,0x5
ffffffffc020038a:	c32b0b13          	addi	s6,s6,-974 # ffffffffc0204fb8 <etext+0x228>
        argv[argc ++] = buf;
ffffffffc020038e:	00005a17          	auipc	s4,0x5
ffffffffc0200392:	b4aa0a13          	addi	s4,s4,-1206 # ffffffffc0204ed8 <etext+0x148>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200396:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200398:	854a                	mv	a0,s2
ffffffffc020039a:	cf5ff0ef          	jal	ra,ffffffffc020008e <readline>
ffffffffc020039e:	842a                	mv	s0,a0
ffffffffc02003a0:	dd65                	beqz	a0,ffffffffc0200398 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a2:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003a6:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a8:	e1bd                	bnez	a1,ffffffffc020040e <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc02003aa:	fe0c87e3          	beqz	s9,ffffffffc0200398 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ae:	6582                	ld	a1,0(sp)
ffffffffc02003b0:	00005d17          	auipc	s10,0x5
ffffffffc02003b4:	c40d0d13          	addi	s10,s10,-960 # ffffffffc0204ff0 <commands>
        argv[argc ++] = buf;
ffffffffc02003b8:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ba:	4401                	li	s0,0
ffffffffc02003bc:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003be:	175040ef          	jal	ra,ffffffffc0204d32 <strcmp>
ffffffffc02003c2:	c919                	beqz	a0,ffffffffc02003d8 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003c4:	2405                	addiw	s0,s0,1
ffffffffc02003c6:	0b540063          	beq	s0,s5,ffffffffc0200466 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ca:	000d3503          	ld	a0,0(s10)
ffffffffc02003ce:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d0:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003d2:	161040ef          	jal	ra,ffffffffc0204d32 <strcmp>
ffffffffc02003d6:	f57d                	bnez	a0,ffffffffc02003c4 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003d8:	00141793          	slli	a5,s0,0x1
ffffffffc02003dc:	97a2                	add	a5,a5,s0
ffffffffc02003de:	078e                	slli	a5,a5,0x3
ffffffffc02003e0:	97e2                	add	a5,a5,s8
ffffffffc02003e2:	6b9c                	ld	a5,16(a5)
ffffffffc02003e4:	865e                	mv	a2,s7
ffffffffc02003e6:	002c                	addi	a1,sp,8
ffffffffc02003e8:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003ec:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003ee:	fa0555e3          	bgez	a0,ffffffffc0200398 <kmonitor+0x6a>
}
ffffffffc02003f2:	60ee                	ld	ra,216(sp)
ffffffffc02003f4:	644e                	ld	s0,208(sp)
ffffffffc02003f6:	64ae                	ld	s1,200(sp)
ffffffffc02003f8:	690e                	ld	s2,192(sp)
ffffffffc02003fa:	79ea                	ld	s3,184(sp)
ffffffffc02003fc:	7a4a                	ld	s4,176(sp)
ffffffffc02003fe:	7aaa                	ld	s5,168(sp)
ffffffffc0200400:	7b0a                	ld	s6,160(sp)
ffffffffc0200402:	6bea                	ld	s7,152(sp)
ffffffffc0200404:	6c4a                	ld	s8,144(sp)
ffffffffc0200406:	6caa                	ld	s9,136(sp)
ffffffffc0200408:	6d0a                	ld	s10,128(sp)
ffffffffc020040a:	612d                	addi	sp,sp,224
ffffffffc020040c:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020040e:	8526                	mv	a0,s1
ffffffffc0200410:	141040ef          	jal	ra,ffffffffc0204d50 <strchr>
ffffffffc0200414:	c901                	beqz	a0,ffffffffc0200424 <kmonitor+0xf6>
ffffffffc0200416:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc020041a:	00040023          	sb	zero,0(s0)
ffffffffc020041e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200420:	d5c9                	beqz	a1,ffffffffc02003aa <kmonitor+0x7c>
ffffffffc0200422:	b7f5                	j	ffffffffc020040e <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200424:	00044783          	lbu	a5,0(s0)
ffffffffc0200428:	d3c9                	beqz	a5,ffffffffc02003aa <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc020042a:	033c8963          	beq	s9,s3,ffffffffc020045c <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc020042e:	003c9793          	slli	a5,s9,0x3
ffffffffc0200432:	0118                	addi	a4,sp,128
ffffffffc0200434:	97ba                	add	a5,a5,a4
ffffffffc0200436:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020043a:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020043e:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200440:	e591                	bnez	a1,ffffffffc020044c <kmonitor+0x11e>
ffffffffc0200442:	b7b5                	j	ffffffffc02003ae <kmonitor+0x80>
ffffffffc0200444:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200448:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020044a:	d1a5                	beqz	a1,ffffffffc02003aa <kmonitor+0x7c>
ffffffffc020044c:	8526                	mv	a0,s1
ffffffffc020044e:	103040ef          	jal	ra,ffffffffc0204d50 <strchr>
ffffffffc0200452:	d96d                	beqz	a0,ffffffffc0200444 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200454:	00044583          	lbu	a1,0(s0)
ffffffffc0200458:	d9a9                	beqz	a1,ffffffffc02003aa <kmonitor+0x7c>
ffffffffc020045a:	bf55                	j	ffffffffc020040e <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020045c:	45c1                	li	a1,16
ffffffffc020045e:	855a                	mv	a0,s6
ffffffffc0200460:	d1dff0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc0200464:	b7e9                	j	ffffffffc020042e <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200466:	6582                	ld	a1,0(sp)
ffffffffc0200468:	00005517          	auipc	a0,0x5
ffffffffc020046c:	b7050513          	addi	a0,a0,-1168 # ffffffffc0204fd8 <etext+0x248>
ffffffffc0200470:	d0dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    return 0;
ffffffffc0200474:	b715                	j	ffffffffc0200398 <kmonitor+0x6a>

ffffffffc0200476 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200476:	00035317          	auipc	t1,0x35
ffffffffc020047a:	88230313          	addi	t1,t1,-1918 # ffffffffc0234cf8 <is_panic>
ffffffffc020047e:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200482:	715d                	addi	sp,sp,-80
ffffffffc0200484:	ec06                	sd	ra,24(sp)
ffffffffc0200486:	e822                	sd	s0,16(sp)
ffffffffc0200488:	f436                	sd	a3,40(sp)
ffffffffc020048a:	f83a                	sd	a4,48(sp)
ffffffffc020048c:	fc3e                	sd	a5,56(sp)
ffffffffc020048e:	e0c2                	sd	a6,64(sp)
ffffffffc0200490:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200492:	020e1a63          	bnez	t3,ffffffffc02004c6 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200496:	4785                	li	a5,1
ffffffffc0200498:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc020049c:	8432                	mv	s0,a2
ffffffffc020049e:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004a0:	862e                	mv	a2,a1
ffffffffc02004a2:	85aa                	mv	a1,a0
ffffffffc02004a4:	00005517          	auipc	a0,0x5
ffffffffc02004a8:	b9450513          	addi	a0,a0,-1132 # ffffffffc0205038 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004ac:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004ae:	ccfff0ef          	jal	ra,ffffffffc020017c <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004b2:	65a2                	ld	a1,8(sp)
ffffffffc02004b4:	8522                	mv	a0,s0
ffffffffc02004b6:	ca7ff0ef          	jal	ra,ffffffffc020015c <vcprintf>
    cprintf("\n");
ffffffffc02004ba:	00006517          	auipc	a0,0x6
ffffffffc02004be:	da650513          	addi	a0,a0,-602 # ffffffffc0206260 <default_pmm_manager+0x790>
ffffffffc02004c2:	cbbff0ef          	jal	ra,ffffffffc020017c <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004c6:	4501                	li	a0,0
ffffffffc02004c8:	4581                	li	a1,0
ffffffffc02004ca:	4601                	li	a2,0
ffffffffc02004cc:	48a1                	li	a7,8
ffffffffc02004ce:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004d2:	166000ef          	jal	ra,ffffffffc0200638 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004d6:	4501                	li	a0,0
ffffffffc02004d8:	e57ff0ef          	jal	ra,ffffffffc020032e <kmonitor>
    while (1) {
ffffffffc02004dc:	bfed                	j	ffffffffc02004d6 <__panic+0x60>

ffffffffc02004de <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004de:	715d                	addi	sp,sp,-80
ffffffffc02004e0:	832e                	mv	t1,a1
ffffffffc02004e2:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004e4:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004e6:	8432                	mv	s0,a2
ffffffffc02004e8:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ea:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc02004ec:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004ee:	00005517          	auipc	a0,0x5
ffffffffc02004f2:	b6a50513          	addi	a0,a0,-1174 # ffffffffc0205058 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004f6:	ec06                	sd	ra,24(sp)
ffffffffc02004f8:	f436                	sd	a3,40(sp)
ffffffffc02004fa:	f83a                	sd	a4,48(sp)
ffffffffc02004fc:	e0c2                	sd	a6,64(sp)
ffffffffc02004fe:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200500:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	c7bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200506:	65a2                	ld	a1,8(sp)
ffffffffc0200508:	8522                	mv	a0,s0
ffffffffc020050a:	c53ff0ef          	jal	ra,ffffffffc020015c <vcprintf>
    cprintf("\n");
ffffffffc020050e:	00006517          	auipc	a0,0x6
ffffffffc0200512:	d5250513          	addi	a0,a0,-686 # ffffffffc0206260 <default_pmm_manager+0x790>
ffffffffc0200516:	c67ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    va_end(ap);
}
ffffffffc020051a:	60e2                	ld	ra,24(sp)
ffffffffc020051c:	6442                	ld	s0,16(sp)
ffffffffc020051e:	6161                	addi	sp,sp,80
ffffffffc0200520:	8082                	ret

ffffffffc0200522 <clock_init>:

static uint64_t timebase = 100000;


void clock_init(void) {
    set_csr(sie, MIP_STIP);
ffffffffc0200522:	02000793          	li	a5,32
ffffffffc0200526:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020052a:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020052e:	67e1                	lui	a5,0x18
ffffffffc0200530:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_rr_out_size+0xd600>
ffffffffc0200534:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200536:	4581                	li	a1,0
ffffffffc0200538:	4601                	li	a2,0
ffffffffc020053a:	4881                	li	a7,0
ffffffffc020053c:	00000073          	ecall
    cprintf("setup timer interrupts\n");
ffffffffc0200540:	00005517          	auipc	a0,0x5
ffffffffc0200544:	b3850513          	addi	a0,a0,-1224 # ffffffffc0205078 <commands+0x88>
    ticks = 0;
ffffffffc0200548:	00034797          	auipc	a5,0x34
ffffffffc020054c:	7a07bc23          	sd	zero,1976(a5) # ffffffffc0234d00 <ticks>
    cprintf("setup timer interrupts\n");
ffffffffc0200550:	b135                	j	ffffffffc020017c <cprintf>

ffffffffc0200552 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200552:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200556:	67e1                	lui	a5,0x18
ffffffffc0200558:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_rr_out_size+0xd600>
ffffffffc020055c:	953e                	add	a0,a0,a5
ffffffffc020055e:	4581                	li	a1,0
ffffffffc0200560:	4601                	li	a2,0
ffffffffc0200562:	4881                	li	a7,0
ffffffffc0200564:	00000073          	ecall
ffffffffc0200568:	8082                	ret

ffffffffc020056a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020056a:	8082                	ret

ffffffffc020056c <cons_putc>:
#include <riscv.h>
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020056c:	100027f3          	csrr	a5,sstatus
ffffffffc0200570:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200572:	0ff57513          	andi	a0,a0,255
ffffffffc0200576:	e799                	bnez	a5,ffffffffc0200584 <cons_putc+0x18>
ffffffffc0200578:	4581                	li	a1,0
ffffffffc020057a:	4601                	li	a2,0
ffffffffc020057c:	4885                	li	a7,1
ffffffffc020057e:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200582:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200584:	1101                	addi	sp,sp,-32
ffffffffc0200586:	ec06                	sd	ra,24(sp)
ffffffffc0200588:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020058a:	0ae000ef          	jal	ra,ffffffffc0200638 <intr_disable>
ffffffffc020058e:	6522                	ld	a0,8(sp)
ffffffffc0200590:	4581                	li	a1,0
ffffffffc0200592:	4601                	li	a2,0
ffffffffc0200594:	4885                	li	a7,1
ffffffffc0200596:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020059a:	60e2                	ld	ra,24(sp)
ffffffffc020059c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020059e:	a851                	j	ffffffffc0200632 <intr_enable>

ffffffffc02005a0 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02005a0:	100027f3          	csrr	a5,sstatus
ffffffffc02005a4:	8b89                	andi	a5,a5,2
ffffffffc02005a6:	eb89                	bnez	a5,ffffffffc02005b8 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005a8:	4501                	li	a0,0
ffffffffc02005aa:	4581                	li	a1,0
ffffffffc02005ac:	4601                	li	a2,0
ffffffffc02005ae:	4889                	li	a7,2
ffffffffc02005b0:	00000073          	ecall
ffffffffc02005b4:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005b6:	8082                	ret
int cons_getc(void) {
ffffffffc02005b8:	1101                	addi	sp,sp,-32
ffffffffc02005ba:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005bc:	07c000ef          	jal	ra,ffffffffc0200638 <intr_disable>
ffffffffc02005c0:	4501                	li	a0,0
ffffffffc02005c2:	4581                	li	a1,0
ffffffffc02005c4:	4601                	li	a2,0
ffffffffc02005c6:	4889                	li	a7,2
ffffffffc02005c8:	00000073          	ecall
ffffffffc02005cc:	2501                	sext.w	a0,a0
ffffffffc02005ce:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005d0:	062000ef          	jal	ra,ffffffffc0200632 <intr_enable>
}
ffffffffc02005d4:	60e2                	ld	ra,24(sp)
ffffffffc02005d6:	6522                	ld	a0,8(sp)
ffffffffc02005d8:	6105                	addi	sp,sp,32
ffffffffc02005da:	8082                	ret

ffffffffc02005dc <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02005dc:	8082                	ret

ffffffffc02005de <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02005de:	00253513          	sltiu	a0,a0,2
ffffffffc02005e2:	8082                	ret

ffffffffc02005e4 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02005e4:	03800513          	li	a0,56
ffffffffc02005e8:	8082                	ret

ffffffffc02005ea <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02005ea:	00029797          	auipc	a5,0x29
ffffffffc02005ee:	6a678793          	addi	a5,a5,1702 # ffffffffc0229c90 <ide>
    int iobase = secno * SECTSIZE;
ffffffffc02005f2:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02005f6:	1141                	addi	sp,sp,-16
ffffffffc02005f8:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02005fa:	95be                	add	a1,a1,a5
ffffffffc02005fc:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc0200600:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc0200602:	776040ef          	jal	ra,ffffffffc0204d78 <memcpy>
    return 0;
}
ffffffffc0200606:	60a2                	ld	ra,8(sp)
ffffffffc0200608:	4501                	li	a0,0
ffffffffc020060a:	0141                	addi	sp,sp,16
ffffffffc020060c:	8082                	ret

ffffffffc020060e <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc020060e:	0095979b          	slliw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200612:	00029517          	auipc	a0,0x29
ffffffffc0200616:	67e50513          	addi	a0,a0,1662 # ffffffffc0229c90 <ide>
                   size_t nsecs) {
ffffffffc020061a:	1141                	addi	sp,sp,-16
ffffffffc020061c:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020061e:	953e                	add	a0,a0,a5
ffffffffc0200620:	00969613          	slli	a2,a3,0x9
                   size_t nsecs) {
ffffffffc0200624:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200626:	752040ef          	jal	ra,ffffffffc0204d78 <memcpy>
    return 0;
}
ffffffffc020062a:	60a2                	ld	ra,8(sp)
ffffffffc020062c:	4501                	li	a0,0
ffffffffc020062e:	0141                	addi	sp,sp,16
ffffffffc0200630:	8082                	ret

ffffffffc0200632 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200632:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200636:	8082                	ret

ffffffffc0200638 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200638:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020063c:	8082                	ret

ffffffffc020063e <idt_init>:
void
idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020063e:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200642:	00000797          	auipc	a5,0x0
ffffffffc0200646:	62a78793          	addi	a5,a5,1578 # ffffffffc0200c6c <__alltraps>
ffffffffc020064a:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020064e:	000407b7          	lui	a5,0x40
ffffffffc0200652:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200656:	8082                	ret

ffffffffc0200658 <print_regs>:
    cprintf("  tval 0x%08x\n", tf->tval);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs* gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200658:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs* gpr) {
ffffffffc020065a:	1141                	addi	sp,sp,-16
ffffffffc020065c:	e022                	sd	s0,0(sp)
ffffffffc020065e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200660:	00005517          	auipc	a0,0x5
ffffffffc0200664:	a3050513          	addi	a0,a0,-1488 # ffffffffc0205090 <commands+0xa0>
void print_regs(struct pushregs* gpr) {
ffffffffc0200668:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020066a:	b13ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020066e:	640c                	ld	a1,8(s0)
ffffffffc0200670:	00005517          	auipc	a0,0x5
ffffffffc0200674:	a3850513          	addi	a0,a0,-1480 # ffffffffc02050a8 <commands+0xb8>
ffffffffc0200678:	b05ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020067c:	680c                	ld	a1,16(s0)
ffffffffc020067e:	00005517          	auipc	a0,0x5
ffffffffc0200682:	a4250513          	addi	a0,a0,-1470 # ffffffffc02050c0 <commands+0xd0>
ffffffffc0200686:	af7ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020068a:	6c0c                	ld	a1,24(s0)
ffffffffc020068c:	00005517          	auipc	a0,0x5
ffffffffc0200690:	a4c50513          	addi	a0,a0,-1460 # ffffffffc02050d8 <commands+0xe8>
ffffffffc0200694:	ae9ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200698:	700c                	ld	a1,32(s0)
ffffffffc020069a:	00005517          	auipc	a0,0x5
ffffffffc020069e:	a5650513          	addi	a0,a0,-1450 # ffffffffc02050f0 <commands+0x100>
ffffffffc02006a2:	adbff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02006a6:	740c                	ld	a1,40(s0)
ffffffffc02006a8:	00005517          	auipc	a0,0x5
ffffffffc02006ac:	a6050513          	addi	a0,a0,-1440 # ffffffffc0205108 <commands+0x118>
ffffffffc02006b0:	acdff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02006b4:	780c                	ld	a1,48(s0)
ffffffffc02006b6:	00005517          	auipc	a0,0x5
ffffffffc02006ba:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0205120 <commands+0x130>
ffffffffc02006be:	abfff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02006c2:	7c0c                	ld	a1,56(s0)
ffffffffc02006c4:	00005517          	auipc	a0,0x5
ffffffffc02006c8:	a7450513          	addi	a0,a0,-1420 # ffffffffc0205138 <commands+0x148>
ffffffffc02006cc:	ab1ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02006d0:	602c                	ld	a1,64(s0)
ffffffffc02006d2:	00005517          	auipc	a0,0x5
ffffffffc02006d6:	a7e50513          	addi	a0,a0,-1410 # ffffffffc0205150 <commands+0x160>
ffffffffc02006da:	aa3ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02006de:	642c                	ld	a1,72(s0)
ffffffffc02006e0:	00005517          	auipc	a0,0x5
ffffffffc02006e4:	a8850513          	addi	a0,a0,-1400 # ffffffffc0205168 <commands+0x178>
ffffffffc02006e8:	a95ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02006ec:	682c                	ld	a1,80(s0)
ffffffffc02006ee:	00005517          	auipc	a0,0x5
ffffffffc02006f2:	a9250513          	addi	a0,a0,-1390 # ffffffffc0205180 <commands+0x190>
ffffffffc02006f6:	a87ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02006fa:	6c2c                	ld	a1,88(s0)
ffffffffc02006fc:	00005517          	auipc	a0,0x5
ffffffffc0200700:	a9c50513          	addi	a0,a0,-1380 # ffffffffc0205198 <commands+0x1a8>
ffffffffc0200704:	a79ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200708:	702c                	ld	a1,96(s0)
ffffffffc020070a:	00005517          	auipc	a0,0x5
ffffffffc020070e:	aa650513          	addi	a0,a0,-1370 # ffffffffc02051b0 <commands+0x1c0>
ffffffffc0200712:	a6bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200716:	742c                	ld	a1,104(s0)
ffffffffc0200718:	00005517          	auipc	a0,0x5
ffffffffc020071c:	ab050513          	addi	a0,a0,-1360 # ffffffffc02051c8 <commands+0x1d8>
ffffffffc0200720:	a5dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200724:	782c                	ld	a1,112(s0)
ffffffffc0200726:	00005517          	auipc	a0,0x5
ffffffffc020072a:	aba50513          	addi	a0,a0,-1350 # ffffffffc02051e0 <commands+0x1f0>
ffffffffc020072e:	a4fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200732:	7c2c                	ld	a1,120(s0)
ffffffffc0200734:	00005517          	auipc	a0,0x5
ffffffffc0200738:	ac450513          	addi	a0,a0,-1340 # ffffffffc02051f8 <commands+0x208>
ffffffffc020073c:	a41ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200740:	604c                	ld	a1,128(s0)
ffffffffc0200742:	00005517          	auipc	a0,0x5
ffffffffc0200746:	ace50513          	addi	a0,a0,-1330 # ffffffffc0205210 <commands+0x220>
ffffffffc020074a:	a33ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020074e:	644c                	ld	a1,136(s0)
ffffffffc0200750:	00005517          	auipc	a0,0x5
ffffffffc0200754:	ad850513          	addi	a0,a0,-1320 # ffffffffc0205228 <commands+0x238>
ffffffffc0200758:	a25ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020075c:	684c                	ld	a1,144(s0)
ffffffffc020075e:	00005517          	auipc	a0,0x5
ffffffffc0200762:	ae250513          	addi	a0,a0,-1310 # ffffffffc0205240 <commands+0x250>
ffffffffc0200766:	a17ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020076a:	6c4c                	ld	a1,152(s0)
ffffffffc020076c:	00005517          	auipc	a0,0x5
ffffffffc0200770:	aec50513          	addi	a0,a0,-1300 # ffffffffc0205258 <commands+0x268>
ffffffffc0200774:	a09ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200778:	704c                	ld	a1,160(s0)
ffffffffc020077a:	00005517          	auipc	a0,0x5
ffffffffc020077e:	af650513          	addi	a0,a0,-1290 # ffffffffc0205270 <commands+0x280>
ffffffffc0200782:	9fbff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200786:	744c                	ld	a1,168(s0)
ffffffffc0200788:	00005517          	auipc	a0,0x5
ffffffffc020078c:	b0050513          	addi	a0,a0,-1280 # ffffffffc0205288 <commands+0x298>
ffffffffc0200790:	9edff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200794:	784c                	ld	a1,176(s0)
ffffffffc0200796:	00005517          	auipc	a0,0x5
ffffffffc020079a:	b0a50513          	addi	a0,a0,-1270 # ffffffffc02052a0 <commands+0x2b0>
ffffffffc020079e:	9dfff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02007a2:	7c4c                	ld	a1,184(s0)
ffffffffc02007a4:	00005517          	auipc	a0,0x5
ffffffffc02007a8:	b1450513          	addi	a0,a0,-1260 # ffffffffc02052b8 <commands+0x2c8>
ffffffffc02007ac:	9d1ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02007b0:	606c                	ld	a1,192(s0)
ffffffffc02007b2:	00005517          	auipc	a0,0x5
ffffffffc02007b6:	b1e50513          	addi	a0,a0,-1250 # ffffffffc02052d0 <commands+0x2e0>
ffffffffc02007ba:	9c3ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02007be:	646c                	ld	a1,200(s0)
ffffffffc02007c0:	00005517          	auipc	a0,0x5
ffffffffc02007c4:	b2850513          	addi	a0,a0,-1240 # ffffffffc02052e8 <commands+0x2f8>
ffffffffc02007c8:	9b5ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02007cc:	686c                	ld	a1,208(s0)
ffffffffc02007ce:	00005517          	auipc	a0,0x5
ffffffffc02007d2:	b3250513          	addi	a0,a0,-1230 # ffffffffc0205300 <commands+0x310>
ffffffffc02007d6:	9a7ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02007da:	6c6c                	ld	a1,216(s0)
ffffffffc02007dc:	00005517          	auipc	a0,0x5
ffffffffc02007e0:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0205318 <commands+0x328>
ffffffffc02007e4:	999ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02007e8:	706c                	ld	a1,224(s0)
ffffffffc02007ea:	00005517          	auipc	a0,0x5
ffffffffc02007ee:	b4650513          	addi	a0,a0,-1210 # ffffffffc0205330 <commands+0x340>
ffffffffc02007f2:	98bff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02007f6:	746c                	ld	a1,232(s0)
ffffffffc02007f8:	00005517          	auipc	a0,0x5
ffffffffc02007fc:	b5050513          	addi	a0,a0,-1200 # ffffffffc0205348 <commands+0x358>
ffffffffc0200800:	97dff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200804:	786c                	ld	a1,240(s0)
ffffffffc0200806:	00005517          	auipc	a0,0x5
ffffffffc020080a:	b5a50513          	addi	a0,a0,-1190 # ffffffffc0205360 <commands+0x370>
ffffffffc020080e:	96fff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200812:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200814:	6402                	ld	s0,0(sp)
ffffffffc0200816:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200818:	00005517          	auipc	a0,0x5
ffffffffc020081c:	b6050513          	addi	a0,a0,-1184 # ffffffffc0205378 <commands+0x388>
}
ffffffffc0200820:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200822:	baa9                	j	ffffffffc020017c <cprintf>

ffffffffc0200824 <print_trapframe>:
print_trapframe(struct trapframe *tf) {
ffffffffc0200824:	1141                	addi	sp,sp,-16
ffffffffc0200826:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200828:	85aa                	mv	a1,a0
print_trapframe(struct trapframe *tf) {
ffffffffc020082a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020082c:	00005517          	auipc	a0,0x5
ffffffffc0200830:	b6450513          	addi	a0,a0,-1180 # ffffffffc0205390 <commands+0x3a0>
print_trapframe(struct trapframe *tf) {
ffffffffc0200834:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200836:	947ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    print_regs(&tf->gpr);
ffffffffc020083a:	8522                	mv	a0,s0
ffffffffc020083c:	e1dff0ef          	jal	ra,ffffffffc0200658 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200840:	10043583          	ld	a1,256(s0)
ffffffffc0200844:	00005517          	auipc	a0,0x5
ffffffffc0200848:	b6450513          	addi	a0,a0,-1180 # ffffffffc02053a8 <commands+0x3b8>
ffffffffc020084c:	931ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200850:	10843583          	ld	a1,264(s0)
ffffffffc0200854:	00005517          	auipc	a0,0x5
ffffffffc0200858:	b6c50513          	addi	a0,a0,-1172 # ffffffffc02053c0 <commands+0x3d0>
ffffffffc020085c:	921ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200860:	11043583          	ld	a1,272(s0)
ffffffffc0200864:	00005517          	auipc	a0,0x5
ffffffffc0200868:	b7450513          	addi	a0,a0,-1164 # ffffffffc02053d8 <commands+0x3e8>
ffffffffc020086c:	911ff0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200870:	11843583          	ld	a1,280(s0)
}
ffffffffc0200874:	6402                	ld	s0,0(sp)
ffffffffc0200876:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200878:	00005517          	auipc	a0,0x5
ffffffffc020087c:	b7050513          	addi	a0,a0,-1168 # ffffffffc02053e8 <commands+0x3f8>
}
ffffffffc0200880:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200882:	8fbff06f          	j	ffffffffc020017c <cprintf>

ffffffffc0200886 <pgfault_handler>:
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int
pgfault_handler(struct trapframe *tf) {
ffffffffc0200886:	1101                	addi	sp,sp,-32
ffffffffc0200888:	e426                	sd	s1,8(sp)
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { 
ffffffffc020088a:	00034497          	auipc	s1,0x34
ffffffffc020088e:	4ce48493          	addi	s1,s1,1230 # ffffffffc0234d58 <check_mm_struct>
ffffffffc0200892:	609c                	ld	a5,0(s1)
pgfault_handler(struct trapframe *tf) {
ffffffffc0200894:	e822                	sd	s0,16(sp)
ffffffffc0200896:	ec06                	sd	ra,24(sp)
ffffffffc0200898:	842a                	mv	s0,a0
    if(check_mm_struct !=NULL) { 
ffffffffc020089a:	cbad                	beqz	a5,ffffffffc020090c <pgfault_handler+0x86>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020089c:	10053783          	ld	a5,256(a0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008a0:	11053583          	ld	a1,272(a0)
ffffffffc02008a4:	04b00613          	li	a2,75
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02008a8:	1007f793          	andi	a5,a5,256
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008ac:	c7b1                	beqz	a5,ffffffffc02008f8 <pgfault_handler+0x72>
ffffffffc02008ae:	11843703          	ld	a4,280(s0)
ffffffffc02008b2:	47bd                	li	a5,15
ffffffffc02008b4:	05700693          	li	a3,87
ffffffffc02008b8:	00f70463          	beq	a4,a5,ffffffffc02008c0 <pgfault_handler+0x3a>
ffffffffc02008bc:	05200693          	li	a3,82
ffffffffc02008c0:	00005517          	auipc	a0,0x5
ffffffffc02008c4:	b4050513          	addi	a0,a0,-1216 # ffffffffc0205400 <commands+0x410>
ffffffffc02008c8:	8b5ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            print_pgfault(tf);
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
ffffffffc02008cc:	6088                	ld	a0,0(s1)
ffffffffc02008ce:	cd1d                	beqz	a0,ffffffffc020090c <pgfault_handler+0x86>
        assert(current == idleproc);
ffffffffc02008d0:	00034717          	auipc	a4,0x34
ffffffffc02008d4:	49873703          	ld	a4,1176(a4) # ffffffffc0234d68 <current>
ffffffffc02008d8:	00034797          	auipc	a5,0x34
ffffffffc02008dc:	4987b783          	ld	a5,1176(a5) # ffffffffc0234d70 <idleproc>
ffffffffc02008e0:	04f71663          	bne	a4,a5,ffffffffc020092c <pgfault_handler+0xa6>
            print_pgfault(tf);
            panic("unhandled page fault.\n");
        }
        mm = current->mm;
    }
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008e4:	11043603          	ld	a2,272(s0)
ffffffffc02008e8:	11843583          	ld	a1,280(s0)
}
ffffffffc02008ec:	6442                	ld	s0,16(sp)
ffffffffc02008ee:	60e2                	ld	ra,24(sp)
ffffffffc02008f0:	64a2                	ld	s1,8(sp)
ffffffffc02008f2:	6105                	addi	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008f4:	7000206f          	j	ffffffffc0202ff4 <do_pgfault>
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008f8:	11843703          	ld	a4,280(s0)
ffffffffc02008fc:	47bd                	li	a5,15
ffffffffc02008fe:	05500613          	li	a2,85
ffffffffc0200902:	05700693          	li	a3,87
ffffffffc0200906:	faf71be3          	bne	a4,a5,ffffffffc02008bc <pgfault_handler+0x36>
ffffffffc020090a:	bf5d                	j	ffffffffc02008c0 <pgfault_handler+0x3a>
        if (current == NULL) {
ffffffffc020090c:	00034797          	auipc	a5,0x34
ffffffffc0200910:	45c7b783          	ld	a5,1116(a5) # ffffffffc0234d68 <current>
ffffffffc0200914:	cf85                	beqz	a5,ffffffffc020094c <pgfault_handler+0xc6>
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200916:	11043603          	ld	a2,272(s0)
ffffffffc020091a:	11843583          	ld	a1,280(s0)
}
ffffffffc020091e:	6442                	ld	s0,16(sp)
ffffffffc0200920:	60e2                	ld	ra,24(sp)
ffffffffc0200922:	64a2                	ld	s1,8(sp)
        mm = current->mm;
ffffffffc0200924:	7788                	ld	a0,40(a5)
}
ffffffffc0200926:	6105                	addi	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200928:	6cc0206f          	j	ffffffffc0202ff4 <do_pgfault>
        assert(current == idleproc);
ffffffffc020092c:	00005697          	auipc	a3,0x5
ffffffffc0200930:	af468693          	addi	a3,a3,-1292 # ffffffffc0205420 <commands+0x430>
ffffffffc0200934:	00005617          	auipc	a2,0x5
ffffffffc0200938:	b0460613          	addi	a2,a2,-1276 # ffffffffc0205438 <commands+0x448>
ffffffffc020093c:	06800593          	li	a1,104
ffffffffc0200940:	00005517          	auipc	a0,0x5
ffffffffc0200944:	b1050513          	addi	a0,a0,-1264 # ffffffffc0205450 <commands+0x460>
ffffffffc0200948:	b2fff0ef          	jal	ra,ffffffffc0200476 <__panic>
            print_trapframe(tf);
ffffffffc020094c:	8522                	mv	a0,s0
ffffffffc020094e:	ed7ff0ef          	jal	ra,ffffffffc0200824 <print_trapframe>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200952:	10043783          	ld	a5,256(s0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200956:	11043583          	ld	a1,272(s0)
ffffffffc020095a:	04b00613          	li	a2,75
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020095e:	1007f793          	andi	a5,a5,256
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200962:	e399                	bnez	a5,ffffffffc0200968 <pgfault_handler+0xe2>
ffffffffc0200964:	05500613          	li	a2,85
ffffffffc0200968:	11843703          	ld	a4,280(s0)
ffffffffc020096c:	47bd                	li	a5,15
ffffffffc020096e:	02f70663          	beq	a4,a5,ffffffffc020099a <pgfault_handler+0x114>
ffffffffc0200972:	05200693          	li	a3,82
ffffffffc0200976:	00005517          	auipc	a0,0x5
ffffffffc020097a:	a8a50513          	addi	a0,a0,-1398 # ffffffffc0205400 <commands+0x410>
ffffffffc020097e:	ffeff0ef          	jal	ra,ffffffffc020017c <cprintf>
            panic("unhandled page fault.\n");
ffffffffc0200982:	00005617          	auipc	a2,0x5
ffffffffc0200986:	ae660613          	addi	a2,a2,-1306 # ffffffffc0205468 <commands+0x478>
ffffffffc020098a:	06f00593          	li	a1,111
ffffffffc020098e:	00005517          	auipc	a0,0x5
ffffffffc0200992:	ac250513          	addi	a0,a0,-1342 # ffffffffc0205450 <commands+0x460>
ffffffffc0200996:	ae1ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc020099a:	05700693          	li	a3,87
ffffffffc020099e:	bfe1                	j	ffffffffc0200976 <pgfault_handler+0xf0>

ffffffffc02009a0 <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02009a0:	11853783          	ld	a5,280(a0)
ffffffffc02009a4:	472d                	li	a4,11
ffffffffc02009a6:	0786                	slli	a5,a5,0x1
ffffffffc02009a8:	8385                	srli	a5,a5,0x1
ffffffffc02009aa:	06f76d63          	bltu	a4,a5,ffffffffc0200a24 <interrupt_handler+0x84>
ffffffffc02009ae:	00005717          	auipc	a4,0x5
ffffffffc02009b2:	b7270713          	addi	a4,a4,-1166 # ffffffffc0205520 <commands+0x530>
ffffffffc02009b6:	078a                	slli	a5,a5,0x2
ffffffffc02009b8:	97ba                	add	a5,a5,a4
ffffffffc02009ba:	439c                	lw	a5,0(a5)
ffffffffc02009bc:	97ba                	add	a5,a5,a4
ffffffffc02009be:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02009c0:	00005517          	auipc	a0,0x5
ffffffffc02009c4:	b2050513          	addi	a0,a0,-1248 # ffffffffc02054e0 <commands+0x4f0>
ffffffffc02009c8:	fb4ff06f          	j	ffffffffc020017c <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02009cc:	00005517          	auipc	a0,0x5
ffffffffc02009d0:	af450513          	addi	a0,a0,-1292 # ffffffffc02054c0 <commands+0x4d0>
ffffffffc02009d4:	fa8ff06f          	j	ffffffffc020017c <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02009d8:	00005517          	auipc	a0,0x5
ffffffffc02009dc:	aa850513          	addi	a0,a0,-1368 # ffffffffc0205480 <commands+0x490>
ffffffffc02009e0:	f9cff06f          	j	ffffffffc020017c <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02009e4:	00005517          	auipc	a0,0x5
ffffffffc02009e8:	abc50513          	addi	a0,a0,-1348 # ffffffffc02054a0 <commands+0x4b0>
ffffffffc02009ec:	f90ff06f          	j	ffffffffc020017c <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02009f0:	1141                	addi	sp,sp,-16
ffffffffc02009f2:	e406                	sd	ra,8(sp)
            break;
        case IRQ_U_TIMER:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_TIMER:
            clock_set_next_event();
ffffffffc02009f4:	b5fff0ef          	jal	ra,ffffffffc0200552 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0 ) {
ffffffffc02009f8:	00034717          	auipc	a4,0x34
ffffffffc02009fc:	30870713          	addi	a4,a4,776 # ffffffffc0234d00 <ticks>
ffffffffc0200a00:	631c                	ld	a5,0(a4)
                //print_ticks()
            }
            if (current){
ffffffffc0200a02:	00034517          	auipc	a0,0x34
ffffffffc0200a06:	36653503          	ld	a0,870(a0) # ffffffffc0234d68 <current>
            if (++ticks % TICK_NUM == 0 ) {
ffffffffc0200a0a:	0785                	addi	a5,a5,1
ffffffffc0200a0c:	e31c                	sd	a5,0(a4)
            if (current){
ffffffffc0200a0e:	cd01                	beqz	a0,ffffffffc0200a26 <interrupt_handler+0x86>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a10:	60a2                	ld	ra,8(sp)
ffffffffc0200a12:	0141                	addi	sp,sp,16
                sched_class_proc_tick(current); 
ffffffffc0200a14:	4030306f          	j	ffffffffc0204616 <sched_class_proc_tick>
            cprintf("Supervisor external interrupt\n");
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	ae850513          	addi	a0,a0,-1304 # ffffffffc0205500 <commands+0x510>
ffffffffc0200a20:	f5cff06f          	j	ffffffffc020017c <cprintf>
            print_trapframe(tf);
ffffffffc0200a24:	b501                	j	ffffffffc0200824 <print_trapframe>
}
ffffffffc0200a26:	60a2                	ld	ra,8(sp)
ffffffffc0200a28:	0141                	addi	sp,sp,16
ffffffffc0200a2a:	8082                	ret

ffffffffc0200a2c <exception_handler>:

void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc0200a2c:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200a30:	1101                	addi	sp,sp,-32
ffffffffc0200a32:	e822                	sd	s0,16(sp)
ffffffffc0200a34:	ec06                	sd	ra,24(sp)
ffffffffc0200a36:	e426                	sd	s1,8(sp)
ffffffffc0200a38:	473d                	li	a4,15
ffffffffc0200a3a:	842a                	mv	s0,a0
ffffffffc0200a3c:	16f76163          	bltu	a4,a5,ffffffffc0200b9e <exception_handler+0x172>
ffffffffc0200a40:	00005717          	auipc	a4,0x5
ffffffffc0200a44:	ca870713          	addi	a4,a4,-856 # ffffffffc02056e8 <commands+0x6f8>
ffffffffc0200a48:	078a                	slli	a5,a5,0x2
ffffffffc0200a4a:	97ba                	add	a5,a5,a4
ffffffffc0200a4c:	439c                	lw	a5,0(a5)
ffffffffc0200a4e:	97ba                	add	a5,a5,a4
ffffffffc0200a50:	8782                	jr	a5
            //cprintf("Environment call from U-mode\n");
            tf->epc += 4;
            syscall();
            break;
        case CAUSE_SUPERVISOR_ECALL:
            cprintf("Environment call from S-mode\n");
ffffffffc0200a52:	00005517          	auipc	a0,0x5
ffffffffc0200a56:	bee50513          	addi	a0,a0,-1042 # ffffffffc0205640 <commands+0x650>
ffffffffc0200a5a:	f22ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            tf->epc += 4;
ffffffffc0200a5e:	10843783          	ld	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a62:	60e2                	ld	ra,24(sp)
ffffffffc0200a64:	64a2                	ld	s1,8(sp)
            tf->epc += 4;
ffffffffc0200a66:	0791                	addi	a5,a5,4
ffffffffc0200a68:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200a6c:	6442                	ld	s0,16(sp)
ffffffffc0200a6e:	6105                	addi	sp,sp,32
            syscall();
ffffffffc0200a70:	6090306f          	j	ffffffffc0204878 <syscall>
            cprintf("Environment call from H-mode\n");
ffffffffc0200a74:	00005517          	auipc	a0,0x5
ffffffffc0200a78:	bec50513          	addi	a0,a0,-1044 # ffffffffc0205660 <commands+0x670>
}
ffffffffc0200a7c:	6442                	ld	s0,16(sp)
ffffffffc0200a7e:	60e2                	ld	ra,24(sp)
ffffffffc0200a80:	64a2                	ld	s1,8(sp)
ffffffffc0200a82:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc0200a84:	ef8ff06f          	j	ffffffffc020017c <cprintf>
            cprintf("Environment call from M-mode\n");
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	bf850513          	addi	a0,a0,-1032 # ffffffffc0205680 <commands+0x690>
ffffffffc0200a90:	b7f5                	j	ffffffffc0200a7c <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200a92:	00005517          	auipc	a0,0x5
ffffffffc0200a96:	c0e50513          	addi	a0,a0,-1010 # ffffffffc02056a0 <commands+0x6b0>
ffffffffc0200a9a:	b7cd                	j	ffffffffc0200a7c <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	c1c50513          	addi	a0,a0,-996 # ffffffffc02056b8 <commands+0x6c8>
ffffffffc0200aa4:	ed8ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200aa8:	8522                	mv	a0,s0
ffffffffc0200aaa:	dddff0ef          	jal	ra,ffffffffc0200886 <pgfault_handler>
ffffffffc0200aae:	84aa                	mv	s1,a0
ffffffffc0200ab0:	10051963          	bnez	a0,ffffffffc0200bc2 <exception_handler+0x196>
}
ffffffffc0200ab4:	60e2                	ld	ra,24(sp)
ffffffffc0200ab6:	6442                	ld	s0,16(sp)
ffffffffc0200ab8:	64a2                	ld	s1,8(sp)
ffffffffc0200aba:	6105                	addi	sp,sp,32
ffffffffc0200abc:	8082                	ret
            cprintf("Store/AMO page fault\n");
ffffffffc0200abe:	00005517          	auipc	a0,0x5
ffffffffc0200ac2:	c1250513          	addi	a0,a0,-1006 # ffffffffc02056d0 <commands+0x6e0>
ffffffffc0200ac6:	eb6ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200aca:	8522                	mv	a0,s0
ffffffffc0200acc:	dbbff0ef          	jal	ra,ffffffffc0200886 <pgfault_handler>
ffffffffc0200ad0:	84aa                	mv	s1,a0
ffffffffc0200ad2:	d16d                	beqz	a0,ffffffffc0200ab4 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200ad4:	8522                	mv	a0,s0
ffffffffc0200ad6:	d4fff0ef          	jal	ra,ffffffffc0200824 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200ada:	86a6                	mv	a3,s1
ffffffffc0200adc:	00005617          	auipc	a2,0x5
ffffffffc0200ae0:	b1460613          	addi	a2,a2,-1260 # ffffffffc02055f0 <commands+0x600>
ffffffffc0200ae4:	0f100593          	li	a1,241
ffffffffc0200ae8:	00005517          	auipc	a0,0x5
ffffffffc0200aec:	96850513          	addi	a0,a0,-1688 # ffffffffc0205450 <commands+0x460>
ffffffffc0200af0:	987ff0ef          	jal	ra,ffffffffc0200476 <__panic>
            cprintf("Instruction address misaligned\n");
ffffffffc0200af4:	00005517          	auipc	a0,0x5
ffffffffc0200af8:	a5c50513          	addi	a0,a0,-1444 # ffffffffc0205550 <commands+0x560>
ffffffffc0200afc:	b741                	j	ffffffffc0200a7c <exception_handler+0x50>
            cprintf("Instruction access fault\n");
ffffffffc0200afe:	00005517          	auipc	a0,0x5
ffffffffc0200b02:	a7250513          	addi	a0,a0,-1422 # ffffffffc0205570 <commands+0x580>
ffffffffc0200b06:	bf9d                	j	ffffffffc0200a7c <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc0200b08:	00005517          	auipc	a0,0x5
ffffffffc0200b0c:	a8850513          	addi	a0,a0,-1400 # ffffffffc0205590 <commands+0x5a0>
ffffffffc0200b10:	b7b5                	j	ffffffffc0200a7c <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc0200b12:	00005517          	auipc	a0,0x5
ffffffffc0200b16:	a9650513          	addi	a0,a0,-1386 # ffffffffc02055a8 <commands+0x5b8>
ffffffffc0200b1a:	e62ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if(tf->gpr.a7 == 10){
ffffffffc0200b1e:	6458                	ld	a4,136(s0)
ffffffffc0200b20:	47a9                	li	a5,10
ffffffffc0200b22:	f8f719e3          	bne	a4,a5,ffffffffc0200ab4 <exception_handler+0x88>
ffffffffc0200b26:	bf25                	j	ffffffffc0200a5e <exception_handler+0x32>
            cprintf("Load address misaligned\n");
ffffffffc0200b28:	00005517          	auipc	a0,0x5
ffffffffc0200b2c:	a9050513          	addi	a0,a0,-1392 # ffffffffc02055b8 <commands+0x5c8>
ffffffffc0200b30:	b7b1                	j	ffffffffc0200a7c <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200b32:	00005517          	auipc	a0,0x5
ffffffffc0200b36:	aa650513          	addi	a0,a0,-1370 # ffffffffc02055d8 <commands+0x5e8>
ffffffffc0200b3a:	e42ff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200b3e:	8522                	mv	a0,s0
ffffffffc0200b40:	d47ff0ef          	jal	ra,ffffffffc0200886 <pgfault_handler>
ffffffffc0200b44:	84aa                	mv	s1,a0
ffffffffc0200b46:	d53d                	beqz	a0,ffffffffc0200ab4 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200b48:	8522                	mv	a0,s0
ffffffffc0200b4a:	cdbff0ef          	jal	ra,ffffffffc0200824 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b4e:	86a6                	mv	a3,s1
ffffffffc0200b50:	00005617          	auipc	a2,0x5
ffffffffc0200b54:	aa060613          	addi	a2,a2,-1376 # ffffffffc02055f0 <commands+0x600>
ffffffffc0200b58:	0c600593          	li	a1,198
ffffffffc0200b5c:	00005517          	auipc	a0,0x5
ffffffffc0200b60:	8f450513          	addi	a0,a0,-1804 # ffffffffc0205450 <commands+0x460>
ffffffffc0200b64:	913ff0ef          	jal	ra,ffffffffc0200476 <__panic>
            cprintf("Store/AMO access fault\n");
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	ac050513          	addi	a0,a0,-1344 # ffffffffc0205628 <commands+0x638>
ffffffffc0200b70:	e0cff0ef          	jal	ra,ffffffffc020017c <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200b74:	8522                	mv	a0,s0
ffffffffc0200b76:	d11ff0ef          	jal	ra,ffffffffc0200886 <pgfault_handler>
ffffffffc0200b7a:	84aa                	mv	s1,a0
ffffffffc0200b7c:	dd05                	beqz	a0,ffffffffc0200ab4 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200b7e:	8522                	mv	a0,s0
ffffffffc0200b80:	ca5ff0ef          	jal	ra,ffffffffc0200824 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b84:	86a6                	mv	a3,s1
ffffffffc0200b86:	00005617          	auipc	a2,0x5
ffffffffc0200b8a:	a6a60613          	addi	a2,a2,-1430 # ffffffffc02055f0 <commands+0x600>
ffffffffc0200b8e:	0d000593          	li	a1,208
ffffffffc0200b92:	00005517          	auipc	a0,0x5
ffffffffc0200b96:	8be50513          	addi	a0,a0,-1858 # ffffffffc0205450 <commands+0x460>
ffffffffc0200b9a:	8ddff0ef          	jal	ra,ffffffffc0200476 <__panic>
            print_trapframe(tf);
ffffffffc0200b9e:	8522                	mv	a0,s0
}
ffffffffc0200ba0:	6442                	ld	s0,16(sp)
ffffffffc0200ba2:	60e2                	ld	ra,24(sp)
ffffffffc0200ba4:	64a2                	ld	s1,8(sp)
ffffffffc0200ba6:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200ba8:	b9b5                	j	ffffffffc0200824 <print_trapframe>
            panic("AMO address misaligned\n");
ffffffffc0200baa:	00005617          	auipc	a2,0x5
ffffffffc0200bae:	a6660613          	addi	a2,a2,-1434 # ffffffffc0205610 <commands+0x620>
ffffffffc0200bb2:	0ca00593          	li	a1,202
ffffffffc0200bb6:	00005517          	auipc	a0,0x5
ffffffffc0200bba:	89a50513          	addi	a0,a0,-1894 # ffffffffc0205450 <commands+0x460>
ffffffffc0200bbe:	8b9ff0ef          	jal	ra,ffffffffc0200476 <__panic>
                print_trapframe(tf);
ffffffffc0200bc2:	8522                	mv	a0,s0
ffffffffc0200bc4:	c61ff0ef          	jal	ra,ffffffffc0200824 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200bc8:	86a6                	mv	a3,s1
ffffffffc0200bca:	00005617          	auipc	a2,0x5
ffffffffc0200bce:	a2660613          	addi	a2,a2,-1498 # ffffffffc02055f0 <commands+0x600>
ffffffffc0200bd2:	0ea00593          	li	a1,234
ffffffffc0200bd6:	00005517          	auipc	a0,0x5
ffffffffc0200bda:	87a50513          	addi	a0,a0,-1926 # ffffffffc0205450 <commands+0x460>
ffffffffc0200bde:	899ff0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0200be2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
ffffffffc0200be2:	1101                	addi	sp,sp,-32
ffffffffc0200be4:	e822                	sd	s0,16(sp)

    if (current == NULL) {
ffffffffc0200be6:	00034417          	auipc	s0,0x34
ffffffffc0200bea:	18240413          	addi	s0,s0,386 # ffffffffc0234d68 <current>
ffffffffc0200bee:	6018                	ld	a4,0(s0)
trap(struct trapframe *tf) {
ffffffffc0200bf0:	ec06                	sd	ra,24(sp)
ffffffffc0200bf2:	e426                	sd	s1,8(sp)
ffffffffc0200bf4:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bf6:	11853683          	ld	a3,280(a0)
    if (current == NULL) {
ffffffffc0200bfa:	cf1d                	beqz	a4,ffffffffc0200c38 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200bfc:	10053483          	ld	s1,256(a0)
        trap_dispatch(tf);
    } else {
        struct trapframe *otf = current->tf;
ffffffffc0200c00:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200c04:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200c06:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c0a:	0206c463          	bltz	a3,ffffffffc0200c32 <trap+0x50>
        exception_handler(tf);
ffffffffc0200c0e:	e1fff0ef          	jal	ra,ffffffffc0200a2c <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200c12:	601c                	ld	a5,0(s0)
ffffffffc0200c14:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel) {
ffffffffc0200c18:	e499                	bnez	s1,ffffffffc0200c26 <trap+0x44>
            if (current->flags & PF_EXITING) {
ffffffffc0200c1a:	0b07a703          	lw	a4,176(a5)
ffffffffc0200c1e:	8b05                	andi	a4,a4,1
ffffffffc0200c20:	e329                	bnez	a4,ffffffffc0200c62 <trap+0x80>
                do_exit(-E_KILLED);
            }
            if (current->need_resched) {
ffffffffc0200c22:	6f9c                	ld	a5,24(a5)
ffffffffc0200c24:	eb85                	bnez	a5,ffffffffc0200c54 <trap+0x72>
                schedule();
            }
        }
    }
}
ffffffffc0200c26:	60e2                	ld	ra,24(sp)
ffffffffc0200c28:	6442                	ld	s0,16(sp)
ffffffffc0200c2a:	64a2                	ld	s1,8(sp)
ffffffffc0200c2c:	6902                	ld	s2,0(sp)
ffffffffc0200c2e:	6105                	addi	sp,sp,32
ffffffffc0200c30:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200c32:	d6fff0ef          	jal	ra,ffffffffc02009a0 <interrupt_handler>
ffffffffc0200c36:	bff1                	j	ffffffffc0200c12 <trap+0x30>
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c38:	0006c863          	bltz	a3,ffffffffc0200c48 <trap+0x66>
}
ffffffffc0200c3c:	6442                	ld	s0,16(sp)
ffffffffc0200c3e:	60e2                	ld	ra,24(sp)
ffffffffc0200c40:	64a2                	ld	s1,8(sp)
ffffffffc0200c42:	6902                	ld	s2,0(sp)
ffffffffc0200c44:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200c46:	b3dd                	j	ffffffffc0200a2c <exception_handler>
}
ffffffffc0200c48:	6442                	ld	s0,16(sp)
ffffffffc0200c4a:	60e2                	ld	ra,24(sp)
ffffffffc0200c4c:	64a2                	ld	s1,8(sp)
ffffffffc0200c4e:	6902                	ld	s2,0(sp)
ffffffffc0200c50:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200c52:	b3b9                	j	ffffffffc02009a0 <interrupt_handler>
}
ffffffffc0200c54:	6442                	ld	s0,16(sp)
ffffffffc0200c56:	60e2                	ld	ra,24(sp)
ffffffffc0200c58:	64a2                	ld	s1,8(sp)
ffffffffc0200c5a:	6902                	ld	s2,0(sp)
ffffffffc0200c5c:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200c5e:	2e50306f          	j	ffffffffc0204742 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200c62:	555d                	li	a0,-9
ffffffffc0200c64:	4d3020ef          	jal	ra,ffffffffc0203936 <do_exit>
            if (current->need_resched) {
ffffffffc0200c68:	601c                	ld	a5,0(s0)
ffffffffc0200c6a:	bf65                	j	ffffffffc0200c22 <trap+0x40>

ffffffffc0200c6c <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200c6c:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200c70:	00011463          	bnez	sp,ffffffffc0200c78 <__alltraps+0xc>
ffffffffc0200c74:	14002173          	csrr	sp,sscratch
ffffffffc0200c78:	712d                	addi	sp,sp,-288
ffffffffc0200c7a:	e002                	sd	zero,0(sp)
ffffffffc0200c7c:	e406                	sd	ra,8(sp)
ffffffffc0200c7e:	ec0e                	sd	gp,24(sp)
ffffffffc0200c80:	f012                	sd	tp,32(sp)
ffffffffc0200c82:	f416                	sd	t0,40(sp)
ffffffffc0200c84:	f81a                	sd	t1,48(sp)
ffffffffc0200c86:	fc1e                	sd	t2,56(sp)
ffffffffc0200c88:	e0a2                	sd	s0,64(sp)
ffffffffc0200c8a:	e4a6                	sd	s1,72(sp)
ffffffffc0200c8c:	e8aa                	sd	a0,80(sp)
ffffffffc0200c8e:	ecae                	sd	a1,88(sp)
ffffffffc0200c90:	f0b2                	sd	a2,96(sp)
ffffffffc0200c92:	f4b6                	sd	a3,104(sp)
ffffffffc0200c94:	f8ba                	sd	a4,112(sp)
ffffffffc0200c96:	fcbe                	sd	a5,120(sp)
ffffffffc0200c98:	e142                	sd	a6,128(sp)
ffffffffc0200c9a:	e546                	sd	a7,136(sp)
ffffffffc0200c9c:	e94a                	sd	s2,144(sp)
ffffffffc0200c9e:	ed4e                	sd	s3,152(sp)
ffffffffc0200ca0:	f152                	sd	s4,160(sp)
ffffffffc0200ca2:	f556                	sd	s5,168(sp)
ffffffffc0200ca4:	f95a                	sd	s6,176(sp)
ffffffffc0200ca6:	fd5e                	sd	s7,184(sp)
ffffffffc0200ca8:	e1e2                	sd	s8,192(sp)
ffffffffc0200caa:	e5e6                	sd	s9,200(sp)
ffffffffc0200cac:	e9ea                	sd	s10,208(sp)
ffffffffc0200cae:	edee                	sd	s11,216(sp)
ffffffffc0200cb0:	f1f2                	sd	t3,224(sp)
ffffffffc0200cb2:	f5f6                	sd	t4,232(sp)
ffffffffc0200cb4:	f9fa                	sd	t5,240(sp)
ffffffffc0200cb6:	fdfe                	sd	t6,248(sp)
ffffffffc0200cb8:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200cbc:	100024f3          	csrr	s1,sstatus
ffffffffc0200cc0:	14102973          	csrr	s2,sepc
ffffffffc0200cc4:	143029f3          	csrr	s3,stval
ffffffffc0200cc8:	14202a73          	csrr	s4,scause
ffffffffc0200ccc:	e822                	sd	s0,16(sp)
ffffffffc0200cce:	e226                	sd	s1,256(sp)
ffffffffc0200cd0:	e64a                	sd	s2,264(sp)
ffffffffc0200cd2:	ea4e                	sd	s3,272(sp)
ffffffffc0200cd4:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200cd6:	850a                	mv	a0,sp
    jal trap
ffffffffc0200cd8:	f0bff0ef          	jal	ra,ffffffffc0200be2 <trap>

ffffffffc0200cdc <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200cdc:	6492                	ld	s1,256(sp)
ffffffffc0200cde:	6932                	ld	s2,264(sp)
ffffffffc0200ce0:	1004f413          	andi	s0,s1,256
ffffffffc0200ce4:	e401                	bnez	s0,ffffffffc0200cec <__trapret+0x10>
ffffffffc0200ce6:	1200                	addi	s0,sp,288
ffffffffc0200ce8:	14041073          	csrw	sscratch,s0
ffffffffc0200cec:	10049073          	csrw	sstatus,s1
ffffffffc0200cf0:	14191073          	csrw	sepc,s2
ffffffffc0200cf4:	60a2                	ld	ra,8(sp)
ffffffffc0200cf6:	61e2                	ld	gp,24(sp)
ffffffffc0200cf8:	7202                	ld	tp,32(sp)
ffffffffc0200cfa:	72a2                	ld	t0,40(sp)
ffffffffc0200cfc:	7342                	ld	t1,48(sp)
ffffffffc0200cfe:	73e2                	ld	t2,56(sp)
ffffffffc0200d00:	6406                	ld	s0,64(sp)
ffffffffc0200d02:	64a6                	ld	s1,72(sp)
ffffffffc0200d04:	6546                	ld	a0,80(sp)
ffffffffc0200d06:	65e6                	ld	a1,88(sp)
ffffffffc0200d08:	7606                	ld	a2,96(sp)
ffffffffc0200d0a:	76a6                	ld	a3,104(sp)
ffffffffc0200d0c:	7746                	ld	a4,112(sp)
ffffffffc0200d0e:	77e6                	ld	a5,120(sp)
ffffffffc0200d10:	680a                	ld	a6,128(sp)
ffffffffc0200d12:	68aa                	ld	a7,136(sp)
ffffffffc0200d14:	694a                	ld	s2,144(sp)
ffffffffc0200d16:	69ea                	ld	s3,152(sp)
ffffffffc0200d18:	7a0a                	ld	s4,160(sp)
ffffffffc0200d1a:	7aaa                	ld	s5,168(sp)
ffffffffc0200d1c:	7b4a                	ld	s6,176(sp)
ffffffffc0200d1e:	7bea                	ld	s7,184(sp)
ffffffffc0200d20:	6c0e                	ld	s8,192(sp)
ffffffffc0200d22:	6cae                	ld	s9,200(sp)
ffffffffc0200d24:	6d4e                	ld	s10,208(sp)
ffffffffc0200d26:	6dee                	ld	s11,216(sp)
ffffffffc0200d28:	7e0e                	ld	t3,224(sp)
ffffffffc0200d2a:	7eae                	ld	t4,232(sp)
ffffffffc0200d2c:	7f4e                	ld	t5,240(sp)
ffffffffc0200d2e:	7fee                	ld	t6,248(sp)
ffffffffc0200d30:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200d32:	10200073          	sret

ffffffffc0200d36 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200d36:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200d38:	b755                	j	ffffffffc0200cdc <__trapret>

ffffffffc0200d3a <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200d3a:	00030797          	auipc	a5,0x30
ffffffffc0200d3e:	f5678793          	addi	a5,a5,-170 # ffffffffc0230c90 <free_area>
ffffffffc0200d42:	e79c                	sd	a5,8(a5)
ffffffffc0200d44:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200d46:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200d4a:	8082                	ret

ffffffffc0200d4c <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200d4c:	00030517          	auipc	a0,0x30
ffffffffc0200d50:	f5456503          	lwu	a0,-172(a0) # ffffffffc0230ca0 <free_area+0x10>
ffffffffc0200d54:	8082                	ret

ffffffffc0200d56 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200d56:	715d                	addi	sp,sp,-80
ffffffffc0200d58:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200d5a:	00030417          	auipc	s0,0x30
ffffffffc0200d5e:	f3640413          	addi	s0,s0,-202 # ffffffffc0230c90 <free_area>
ffffffffc0200d62:	641c                	ld	a5,8(s0)
ffffffffc0200d64:	e486                	sd	ra,72(sp)
ffffffffc0200d66:	fc26                	sd	s1,56(sp)
ffffffffc0200d68:	f84a                	sd	s2,48(sp)
ffffffffc0200d6a:	f44e                	sd	s3,40(sp)
ffffffffc0200d6c:	f052                	sd	s4,32(sp)
ffffffffc0200d6e:	ec56                	sd	s5,24(sp)
ffffffffc0200d70:	e85a                	sd	s6,16(sp)
ffffffffc0200d72:	e45e                	sd	s7,8(sp)
ffffffffc0200d74:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d76:	2a878d63          	beq	a5,s0,ffffffffc0201030 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200d7a:	4481                	li	s1,0
ffffffffc0200d7c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200d7e:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200d82:	8b09                	andi	a4,a4,2
ffffffffc0200d84:	2a070a63          	beqz	a4,ffffffffc0201038 <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0200d88:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d8c:	679c                	ld	a5,8(a5)
ffffffffc0200d8e:	2905                	addiw	s2,s2,1
ffffffffc0200d90:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d92:	fe8796e3          	bne	a5,s0,ffffffffc0200d7e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200d96:	89a6                	mv	s3,s1
ffffffffc0200d98:	6ef000ef          	jal	ra,ffffffffc0201c86 <nr_free_pages>
ffffffffc0200d9c:	6f351e63          	bne	a0,s3,ffffffffc0201498 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200da0:	4505                	li	a0,1
ffffffffc0200da2:	613000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200da6:	8aaa                	mv	s5,a0
ffffffffc0200da8:	42050863          	beqz	a0,ffffffffc02011d8 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200dac:	4505                	li	a0,1
ffffffffc0200dae:	607000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200db2:	89aa                	mv	s3,a0
ffffffffc0200db4:	70050263          	beqz	a0,ffffffffc02014b8 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200db8:	4505                	li	a0,1
ffffffffc0200dba:	5fb000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200dbe:	8a2a                	mv	s4,a0
ffffffffc0200dc0:	48050c63          	beqz	a0,ffffffffc0201258 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200dc4:	293a8a63          	beq	s5,s3,ffffffffc0201058 <default_check+0x302>
ffffffffc0200dc8:	28aa8863          	beq	s5,a0,ffffffffc0201058 <default_check+0x302>
ffffffffc0200dcc:	28a98663          	beq	s3,a0,ffffffffc0201058 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200dd0:	000aa783          	lw	a5,0(s5)
ffffffffc0200dd4:	2a079263          	bnez	a5,ffffffffc0201078 <default_check+0x322>
ffffffffc0200dd8:	0009a783          	lw	a5,0(s3)
ffffffffc0200ddc:	28079e63          	bnez	a5,ffffffffc0201078 <default_check+0x322>
ffffffffc0200de0:	411c                	lw	a5,0(a0)
ffffffffc0200de2:	28079b63          	bnez	a5,ffffffffc0201078 <default_check+0x322>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0200de6:	00034797          	auipc	a5,0x34
ffffffffc0200dea:	f427b783          	ld	a5,-190(a5) # ffffffffc0234d28 <pages>
ffffffffc0200dee:	40fa8733          	sub	a4,s5,a5
ffffffffc0200df2:	00006617          	auipc	a2,0x6
ffffffffc0200df6:	dbe63603          	ld	a2,-578(a2) # ffffffffc0206bb0 <nbase>
ffffffffc0200dfa:	8719                	srai	a4,a4,0x6
ffffffffc0200dfc:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200dfe:	00034697          	auipc	a3,0x34
ffffffffc0200e02:	f226b683          	ld	a3,-222(a3) # ffffffffc0234d20 <npage>
ffffffffc0200e06:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e08:	0732                	slli	a4,a4,0xc
ffffffffc0200e0a:	28d77763          	bgeu	a4,a3,ffffffffc0201098 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200e0e:	40f98733          	sub	a4,s3,a5
ffffffffc0200e12:	8719                	srai	a4,a4,0x6
ffffffffc0200e14:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e16:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200e18:	4cd77063          	bgeu	a4,a3,ffffffffc02012d8 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200e1c:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e20:	8799                	srai	a5,a5,0x6
ffffffffc0200e22:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e24:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200e26:	30d7f963          	bgeu	a5,a3,ffffffffc0201138 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200e2a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e2c:	00043c03          	ld	s8,0(s0)
ffffffffc0200e30:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200e34:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200e38:	e400                	sd	s0,8(s0)
ffffffffc0200e3a:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200e3c:	00030797          	auipc	a5,0x30
ffffffffc0200e40:	e607a223          	sw	zero,-412(a5) # ffffffffc0230ca0 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200e44:	571000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200e48:	2c051863          	bnez	a0,ffffffffc0201118 <default_check+0x3c2>
    free_page(p0);
ffffffffc0200e4c:	4585                	li	a1,1
ffffffffc0200e4e:	8556                	mv	a0,s5
ffffffffc0200e50:	5f7000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    free_page(p1);
ffffffffc0200e54:	4585                	li	a1,1
ffffffffc0200e56:	854e                	mv	a0,s3
ffffffffc0200e58:	5ef000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    free_page(p2);
ffffffffc0200e5c:	4585                	li	a1,1
ffffffffc0200e5e:	8552                	mv	a0,s4
ffffffffc0200e60:	5e7000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    assert(nr_free == 3);
ffffffffc0200e64:	4818                	lw	a4,16(s0)
ffffffffc0200e66:	478d                	li	a5,3
ffffffffc0200e68:	28f71863          	bne	a4,a5,ffffffffc02010f8 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e6c:	4505                	li	a0,1
ffffffffc0200e6e:	547000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200e72:	89aa                	mv	s3,a0
ffffffffc0200e74:	26050263          	beqz	a0,ffffffffc02010d8 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e78:	4505                	li	a0,1
ffffffffc0200e7a:	53b000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200e7e:	8aaa                	mv	s5,a0
ffffffffc0200e80:	3a050c63          	beqz	a0,ffffffffc0201238 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e84:	4505                	li	a0,1
ffffffffc0200e86:	52f000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200e8a:	8a2a                	mv	s4,a0
ffffffffc0200e8c:	38050663          	beqz	a0,ffffffffc0201218 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200e90:	4505                	li	a0,1
ffffffffc0200e92:	523000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200e96:	36051163          	bnez	a0,ffffffffc02011f8 <default_check+0x4a2>
    free_page(p0);
ffffffffc0200e9a:	4585                	li	a1,1
ffffffffc0200e9c:	854e                	mv	a0,s3
ffffffffc0200e9e:	5a9000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200ea2:	641c                	ld	a5,8(s0)
ffffffffc0200ea4:	20878a63          	beq	a5,s0,ffffffffc02010b8 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0200ea8:	4505                	li	a0,1
ffffffffc0200eaa:	50b000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200eae:	30a99563          	bne	s3,a0,ffffffffc02011b8 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0200eb2:	4505                	li	a0,1
ffffffffc0200eb4:	501000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200eb8:	2e051063          	bnez	a0,ffffffffc0201198 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0200ebc:	481c                	lw	a5,16(s0)
ffffffffc0200ebe:	2a079d63          	bnez	a5,ffffffffc0201178 <default_check+0x422>
    free_page(p);
ffffffffc0200ec2:	854e                	mv	a0,s3
ffffffffc0200ec4:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200ec6:	01843023          	sd	s8,0(s0)
ffffffffc0200eca:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200ece:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200ed2:	575000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    free_page(p1);
ffffffffc0200ed6:	4585                	li	a1,1
ffffffffc0200ed8:	8556                	mv	a0,s5
ffffffffc0200eda:	56d000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    free_page(p2);
ffffffffc0200ede:	4585                	li	a1,1
ffffffffc0200ee0:	8552                	mv	a0,s4
ffffffffc0200ee2:	565000ef          	jal	ra,ffffffffc0201c46 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200ee6:	4515                	li	a0,5
ffffffffc0200ee8:	4cd000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200eec:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200eee:	26050563          	beqz	a0,ffffffffc0201158 <default_check+0x402>
ffffffffc0200ef2:	651c                	ld	a5,8(a0)
ffffffffc0200ef4:	8385                	srli	a5,a5,0x1
ffffffffc0200ef6:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0200ef8:	54079063          	bnez	a5,ffffffffc0201438 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200efc:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200efe:	00043b03          	ld	s6,0(s0)
ffffffffc0200f02:	00843a83          	ld	s5,8(s0)
ffffffffc0200f06:	e000                	sd	s0,0(s0)
ffffffffc0200f08:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200f0a:	4ab000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200f0e:	50051563          	bnez	a0,ffffffffc0201418 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200f12:	08098a13          	addi	s4,s3,128
ffffffffc0200f16:	8552                	mv	a0,s4
ffffffffc0200f18:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200f1a:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200f1e:	00030797          	auipc	a5,0x30
ffffffffc0200f22:	d807a123          	sw	zero,-638(a5) # ffffffffc0230ca0 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200f26:	521000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200f2a:	4511                	li	a0,4
ffffffffc0200f2c:	489000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200f30:	4c051463          	bnez	a0,ffffffffc02013f8 <default_check+0x6a2>
ffffffffc0200f34:	0889b783          	ld	a5,136(s3)
ffffffffc0200f38:	8385                	srli	a5,a5,0x1
ffffffffc0200f3a:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200f3c:	48078e63          	beqz	a5,ffffffffc02013d8 <default_check+0x682>
ffffffffc0200f40:	0909a703          	lw	a4,144(s3)
ffffffffc0200f44:	478d                	li	a5,3
ffffffffc0200f46:	48f71963          	bne	a4,a5,ffffffffc02013d8 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200f4a:	450d                	li	a0,3
ffffffffc0200f4c:	469000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200f50:	8c2a                	mv	s8,a0
ffffffffc0200f52:	46050363          	beqz	a0,ffffffffc02013b8 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0200f56:	4505                	li	a0,1
ffffffffc0200f58:	45d000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200f5c:	42051e63          	bnez	a0,ffffffffc0201398 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0200f60:	418a1c63          	bne	s4,s8,ffffffffc0201378 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200f64:	4585                	li	a1,1
ffffffffc0200f66:	854e                	mv	a0,s3
ffffffffc0200f68:	4df000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    free_pages(p1, 3);
ffffffffc0200f6c:	458d                	li	a1,3
ffffffffc0200f6e:	8552                	mv	a0,s4
ffffffffc0200f70:	4d7000ef          	jal	ra,ffffffffc0201c46 <free_pages>
ffffffffc0200f74:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0200f78:	04098c13          	addi	s8,s3,64
ffffffffc0200f7c:	8385                	srli	a5,a5,0x1
ffffffffc0200f7e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200f80:	3c078c63          	beqz	a5,ffffffffc0201358 <default_check+0x602>
ffffffffc0200f84:	0109a703          	lw	a4,16(s3)
ffffffffc0200f88:	4785                	li	a5,1
ffffffffc0200f8a:	3cf71763          	bne	a4,a5,ffffffffc0201358 <default_check+0x602>
ffffffffc0200f8e:	008a3783          	ld	a5,8(s4)
ffffffffc0200f92:	8385                	srli	a5,a5,0x1
ffffffffc0200f94:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200f96:	3a078163          	beqz	a5,ffffffffc0201338 <default_check+0x5e2>
ffffffffc0200f9a:	010a2703          	lw	a4,16(s4)
ffffffffc0200f9e:	478d                	li	a5,3
ffffffffc0200fa0:	38f71c63          	bne	a4,a5,ffffffffc0201338 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200fa4:	4505                	li	a0,1
ffffffffc0200fa6:	40f000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200faa:	36a99763          	bne	s3,a0,ffffffffc0201318 <default_check+0x5c2>
    free_page(p0);
ffffffffc0200fae:	4585                	li	a1,1
ffffffffc0200fb0:	497000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200fb4:	4509                	li	a0,2
ffffffffc0200fb6:	3ff000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200fba:	32aa1f63          	bne	s4,a0,ffffffffc02012f8 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0200fbe:	4589                	li	a1,2
ffffffffc0200fc0:	487000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    free_page(p2);
ffffffffc0200fc4:	4585                	li	a1,1
ffffffffc0200fc6:	8562                	mv	a0,s8
ffffffffc0200fc8:	47f000ef          	jal	ra,ffffffffc0201c46 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200fcc:	4515                	li	a0,5
ffffffffc0200fce:	3e7000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200fd2:	89aa                	mv	s3,a0
ffffffffc0200fd4:	48050263          	beqz	a0,ffffffffc0201458 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0200fd8:	4505                	li	a0,1
ffffffffc0200fda:	3db000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0200fde:	2c051d63          	bnez	a0,ffffffffc02012b8 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0200fe2:	481c                	lw	a5,16(s0)
ffffffffc0200fe4:	2a079a63          	bnez	a5,ffffffffc0201298 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200fe8:	4595                	li	a1,5
ffffffffc0200fea:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200fec:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0200ff0:	01643023          	sd	s6,0(s0)
ffffffffc0200ff4:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0200ff8:	44f000ef          	jal	ra,ffffffffc0201c46 <free_pages>
    return listelm->next;
ffffffffc0200ffc:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200ffe:	00878963          	beq	a5,s0,ffffffffc0201010 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201002:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201006:	679c                	ld	a5,8(a5)
ffffffffc0201008:	397d                	addiw	s2,s2,-1
ffffffffc020100a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020100c:	fe879be3          	bne	a5,s0,ffffffffc0201002 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0201010:	26091463          	bnez	s2,ffffffffc0201278 <default_check+0x522>
    assert(total == 0);
ffffffffc0201014:	46049263          	bnez	s1,ffffffffc0201478 <default_check+0x722>
}
ffffffffc0201018:	60a6                	ld	ra,72(sp)
ffffffffc020101a:	6406                	ld	s0,64(sp)
ffffffffc020101c:	74e2                	ld	s1,56(sp)
ffffffffc020101e:	7942                	ld	s2,48(sp)
ffffffffc0201020:	79a2                	ld	s3,40(sp)
ffffffffc0201022:	7a02                	ld	s4,32(sp)
ffffffffc0201024:	6ae2                	ld	s5,24(sp)
ffffffffc0201026:	6b42                	ld	s6,16(sp)
ffffffffc0201028:	6ba2                	ld	s7,8(sp)
ffffffffc020102a:	6c02                	ld	s8,0(sp)
ffffffffc020102c:	6161                	addi	sp,sp,80
ffffffffc020102e:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201030:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201032:	4481                	li	s1,0
ffffffffc0201034:	4901                	li	s2,0
ffffffffc0201036:	b38d                	j	ffffffffc0200d98 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201038:	00004697          	auipc	a3,0x4
ffffffffc020103c:	6f068693          	addi	a3,a3,1776 # ffffffffc0205728 <commands+0x738>
ffffffffc0201040:	00004617          	auipc	a2,0x4
ffffffffc0201044:	3f860613          	addi	a2,a2,1016 # ffffffffc0205438 <commands+0x448>
ffffffffc0201048:	0f000593          	li	a1,240
ffffffffc020104c:	00004517          	auipc	a0,0x4
ffffffffc0201050:	6ec50513          	addi	a0,a0,1772 # ffffffffc0205738 <commands+0x748>
ffffffffc0201054:	c22ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201058:	00004697          	auipc	a3,0x4
ffffffffc020105c:	77868693          	addi	a3,a3,1912 # ffffffffc02057d0 <commands+0x7e0>
ffffffffc0201060:	00004617          	auipc	a2,0x4
ffffffffc0201064:	3d860613          	addi	a2,a2,984 # ffffffffc0205438 <commands+0x448>
ffffffffc0201068:	0bd00593          	li	a1,189
ffffffffc020106c:	00004517          	auipc	a0,0x4
ffffffffc0201070:	6cc50513          	addi	a0,a0,1740 # ffffffffc0205738 <commands+0x748>
ffffffffc0201074:	c02ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201078:	00004697          	auipc	a3,0x4
ffffffffc020107c:	78068693          	addi	a3,a3,1920 # ffffffffc02057f8 <commands+0x808>
ffffffffc0201080:	00004617          	auipc	a2,0x4
ffffffffc0201084:	3b860613          	addi	a2,a2,952 # ffffffffc0205438 <commands+0x448>
ffffffffc0201088:	0be00593          	li	a1,190
ffffffffc020108c:	00004517          	auipc	a0,0x4
ffffffffc0201090:	6ac50513          	addi	a0,a0,1708 # ffffffffc0205738 <commands+0x748>
ffffffffc0201094:	be2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201098:	00004697          	auipc	a3,0x4
ffffffffc020109c:	7a068693          	addi	a3,a3,1952 # ffffffffc0205838 <commands+0x848>
ffffffffc02010a0:	00004617          	auipc	a2,0x4
ffffffffc02010a4:	39860613          	addi	a2,a2,920 # ffffffffc0205438 <commands+0x448>
ffffffffc02010a8:	0c000593          	li	a1,192
ffffffffc02010ac:	00004517          	auipc	a0,0x4
ffffffffc02010b0:	68c50513          	addi	a0,a0,1676 # ffffffffc0205738 <commands+0x748>
ffffffffc02010b4:	bc2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02010b8:	00005697          	auipc	a3,0x5
ffffffffc02010bc:	80868693          	addi	a3,a3,-2040 # ffffffffc02058c0 <commands+0x8d0>
ffffffffc02010c0:	00004617          	auipc	a2,0x4
ffffffffc02010c4:	37860613          	addi	a2,a2,888 # ffffffffc0205438 <commands+0x448>
ffffffffc02010c8:	0d900593          	li	a1,217
ffffffffc02010cc:	00004517          	auipc	a0,0x4
ffffffffc02010d0:	66c50513          	addi	a0,a0,1644 # ffffffffc0205738 <commands+0x748>
ffffffffc02010d4:	ba2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010d8:	00004697          	auipc	a3,0x4
ffffffffc02010dc:	69868693          	addi	a3,a3,1688 # ffffffffc0205770 <commands+0x780>
ffffffffc02010e0:	00004617          	auipc	a2,0x4
ffffffffc02010e4:	35860613          	addi	a2,a2,856 # ffffffffc0205438 <commands+0x448>
ffffffffc02010e8:	0d200593          	li	a1,210
ffffffffc02010ec:	00004517          	auipc	a0,0x4
ffffffffc02010f0:	64c50513          	addi	a0,a0,1612 # ffffffffc0205738 <commands+0x748>
ffffffffc02010f4:	b82ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(nr_free == 3);
ffffffffc02010f8:	00004697          	auipc	a3,0x4
ffffffffc02010fc:	7b868693          	addi	a3,a3,1976 # ffffffffc02058b0 <commands+0x8c0>
ffffffffc0201100:	00004617          	auipc	a2,0x4
ffffffffc0201104:	33860613          	addi	a2,a2,824 # ffffffffc0205438 <commands+0x448>
ffffffffc0201108:	0d000593          	li	a1,208
ffffffffc020110c:	00004517          	auipc	a0,0x4
ffffffffc0201110:	62c50513          	addi	a0,a0,1580 # ffffffffc0205738 <commands+0x748>
ffffffffc0201114:	b62ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201118:	00004697          	auipc	a3,0x4
ffffffffc020111c:	78068693          	addi	a3,a3,1920 # ffffffffc0205898 <commands+0x8a8>
ffffffffc0201120:	00004617          	auipc	a2,0x4
ffffffffc0201124:	31860613          	addi	a2,a2,792 # ffffffffc0205438 <commands+0x448>
ffffffffc0201128:	0cb00593          	li	a1,203
ffffffffc020112c:	00004517          	auipc	a0,0x4
ffffffffc0201130:	60c50513          	addi	a0,a0,1548 # ffffffffc0205738 <commands+0x748>
ffffffffc0201134:	b42ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201138:	00004697          	auipc	a3,0x4
ffffffffc020113c:	74068693          	addi	a3,a3,1856 # ffffffffc0205878 <commands+0x888>
ffffffffc0201140:	00004617          	auipc	a2,0x4
ffffffffc0201144:	2f860613          	addi	a2,a2,760 # ffffffffc0205438 <commands+0x448>
ffffffffc0201148:	0c200593          	li	a1,194
ffffffffc020114c:	00004517          	auipc	a0,0x4
ffffffffc0201150:	5ec50513          	addi	a0,a0,1516 # ffffffffc0205738 <commands+0x748>
ffffffffc0201154:	b22ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(p0 != NULL);
ffffffffc0201158:	00004697          	auipc	a3,0x4
ffffffffc020115c:	7b068693          	addi	a3,a3,1968 # ffffffffc0205908 <commands+0x918>
ffffffffc0201160:	00004617          	auipc	a2,0x4
ffffffffc0201164:	2d860613          	addi	a2,a2,728 # ffffffffc0205438 <commands+0x448>
ffffffffc0201168:	0f800593          	li	a1,248
ffffffffc020116c:	00004517          	auipc	a0,0x4
ffffffffc0201170:	5cc50513          	addi	a0,a0,1484 # ffffffffc0205738 <commands+0x748>
ffffffffc0201174:	b02ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(nr_free == 0);
ffffffffc0201178:	00004697          	auipc	a3,0x4
ffffffffc020117c:	78068693          	addi	a3,a3,1920 # ffffffffc02058f8 <commands+0x908>
ffffffffc0201180:	00004617          	auipc	a2,0x4
ffffffffc0201184:	2b860613          	addi	a2,a2,696 # ffffffffc0205438 <commands+0x448>
ffffffffc0201188:	0df00593          	li	a1,223
ffffffffc020118c:	00004517          	auipc	a0,0x4
ffffffffc0201190:	5ac50513          	addi	a0,a0,1452 # ffffffffc0205738 <commands+0x748>
ffffffffc0201194:	ae2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201198:	00004697          	auipc	a3,0x4
ffffffffc020119c:	70068693          	addi	a3,a3,1792 # ffffffffc0205898 <commands+0x8a8>
ffffffffc02011a0:	00004617          	auipc	a2,0x4
ffffffffc02011a4:	29860613          	addi	a2,a2,664 # ffffffffc0205438 <commands+0x448>
ffffffffc02011a8:	0dd00593          	li	a1,221
ffffffffc02011ac:	00004517          	auipc	a0,0x4
ffffffffc02011b0:	58c50513          	addi	a0,a0,1420 # ffffffffc0205738 <commands+0x748>
ffffffffc02011b4:	ac2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02011b8:	00004697          	auipc	a3,0x4
ffffffffc02011bc:	72068693          	addi	a3,a3,1824 # ffffffffc02058d8 <commands+0x8e8>
ffffffffc02011c0:	00004617          	auipc	a2,0x4
ffffffffc02011c4:	27860613          	addi	a2,a2,632 # ffffffffc0205438 <commands+0x448>
ffffffffc02011c8:	0dc00593          	li	a1,220
ffffffffc02011cc:	00004517          	auipc	a0,0x4
ffffffffc02011d0:	56c50513          	addi	a0,a0,1388 # ffffffffc0205738 <commands+0x748>
ffffffffc02011d4:	aa2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011d8:	00004697          	auipc	a3,0x4
ffffffffc02011dc:	59868693          	addi	a3,a3,1432 # ffffffffc0205770 <commands+0x780>
ffffffffc02011e0:	00004617          	auipc	a2,0x4
ffffffffc02011e4:	25860613          	addi	a2,a2,600 # ffffffffc0205438 <commands+0x448>
ffffffffc02011e8:	0b900593          	li	a1,185
ffffffffc02011ec:	00004517          	auipc	a0,0x4
ffffffffc02011f0:	54c50513          	addi	a0,a0,1356 # ffffffffc0205738 <commands+0x748>
ffffffffc02011f4:	a82ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011f8:	00004697          	auipc	a3,0x4
ffffffffc02011fc:	6a068693          	addi	a3,a3,1696 # ffffffffc0205898 <commands+0x8a8>
ffffffffc0201200:	00004617          	auipc	a2,0x4
ffffffffc0201204:	23860613          	addi	a2,a2,568 # ffffffffc0205438 <commands+0x448>
ffffffffc0201208:	0d600593          	li	a1,214
ffffffffc020120c:	00004517          	auipc	a0,0x4
ffffffffc0201210:	52c50513          	addi	a0,a0,1324 # ffffffffc0205738 <commands+0x748>
ffffffffc0201214:	a62ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201218:	00004697          	auipc	a3,0x4
ffffffffc020121c:	59868693          	addi	a3,a3,1432 # ffffffffc02057b0 <commands+0x7c0>
ffffffffc0201220:	00004617          	auipc	a2,0x4
ffffffffc0201224:	21860613          	addi	a2,a2,536 # ffffffffc0205438 <commands+0x448>
ffffffffc0201228:	0d400593          	li	a1,212
ffffffffc020122c:	00004517          	auipc	a0,0x4
ffffffffc0201230:	50c50513          	addi	a0,a0,1292 # ffffffffc0205738 <commands+0x748>
ffffffffc0201234:	a42ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201238:	00004697          	auipc	a3,0x4
ffffffffc020123c:	55868693          	addi	a3,a3,1368 # ffffffffc0205790 <commands+0x7a0>
ffffffffc0201240:	00004617          	auipc	a2,0x4
ffffffffc0201244:	1f860613          	addi	a2,a2,504 # ffffffffc0205438 <commands+0x448>
ffffffffc0201248:	0d300593          	li	a1,211
ffffffffc020124c:	00004517          	auipc	a0,0x4
ffffffffc0201250:	4ec50513          	addi	a0,a0,1260 # ffffffffc0205738 <commands+0x748>
ffffffffc0201254:	a22ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201258:	00004697          	auipc	a3,0x4
ffffffffc020125c:	55868693          	addi	a3,a3,1368 # ffffffffc02057b0 <commands+0x7c0>
ffffffffc0201260:	00004617          	auipc	a2,0x4
ffffffffc0201264:	1d860613          	addi	a2,a2,472 # ffffffffc0205438 <commands+0x448>
ffffffffc0201268:	0bb00593          	li	a1,187
ffffffffc020126c:	00004517          	auipc	a0,0x4
ffffffffc0201270:	4cc50513          	addi	a0,a0,1228 # ffffffffc0205738 <commands+0x748>
ffffffffc0201274:	a02ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(count == 0);
ffffffffc0201278:	00004697          	auipc	a3,0x4
ffffffffc020127c:	7e068693          	addi	a3,a3,2016 # ffffffffc0205a58 <commands+0xa68>
ffffffffc0201280:	00004617          	auipc	a2,0x4
ffffffffc0201284:	1b860613          	addi	a2,a2,440 # ffffffffc0205438 <commands+0x448>
ffffffffc0201288:	12500593          	li	a1,293
ffffffffc020128c:	00004517          	auipc	a0,0x4
ffffffffc0201290:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205738 <commands+0x748>
ffffffffc0201294:	9e2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(nr_free == 0);
ffffffffc0201298:	00004697          	auipc	a3,0x4
ffffffffc020129c:	66068693          	addi	a3,a3,1632 # ffffffffc02058f8 <commands+0x908>
ffffffffc02012a0:	00004617          	auipc	a2,0x4
ffffffffc02012a4:	19860613          	addi	a2,a2,408 # ffffffffc0205438 <commands+0x448>
ffffffffc02012a8:	11a00593          	li	a1,282
ffffffffc02012ac:	00004517          	auipc	a0,0x4
ffffffffc02012b0:	48c50513          	addi	a0,a0,1164 # ffffffffc0205738 <commands+0x748>
ffffffffc02012b4:	9c2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012b8:	00004697          	auipc	a3,0x4
ffffffffc02012bc:	5e068693          	addi	a3,a3,1504 # ffffffffc0205898 <commands+0x8a8>
ffffffffc02012c0:	00004617          	auipc	a2,0x4
ffffffffc02012c4:	17860613          	addi	a2,a2,376 # ffffffffc0205438 <commands+0x448>
ffffffffc02012c8:	11800593          	li	a1,280
ffffffffc02012cc:	00004517          	auipc	a0,0x4
ffffffffc02012d0:	46c50513          	addi	a0,a0,1132 # ffffffffc0205738 <commands+0x748>
ffffffffc02012d4:	9a2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02012d8:	00004697          	auipc	a3,0x4
ffffffffc02012dc:	58068693          	addi	a3,a3,1408 # ffffffffc0205858 <commands+0x868>
ffffffffc02012e0:	00004617          	auipc	a2,0x4
ffffffffc02012e4:	15860613          	addi	a2,a2,344 # ffffffffc0205438 <commands+0x448>
ffffffffc02012e8:	0c100593          	li	a1,193
ffffffffc02012ec:	00004517          	auipc	a0,0x4
ffffffffc02012f0:	44c50513          	addi	a0,a0,1100 # ffffffffc0205738 <commands+0x748>
ffffffffc02012f4:	982ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012f8:	00004697          	auipc	a3,0x4
ffffffffc02012fc:	72068693          	addi	a3,a3,1824 # ffffffffc0205a18 <commands+0xa28>
ffffffffc0201300:	00004617          	auipc	a2,0x4
ffffffffc0201304:	13860613          	addi	a2,a2,312 # ffffffffc0205438 <commands+0x448>
ffffffffc0201308:	11200593          	li	a1,274
ffffffffc020130c:	00004517          	auipc	a0,0x4
ffffffffc0201310:	42c50513          	addi	a0,a0,1068 # ffffffffc0205738 <commands+0x748>
ffffffffc0201314:	962ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201318:	00004697          	auipc	a3,0x4
ffffffffc020131c:	6e068693          	addi	a3,a3,1760 # ffffffffc02059f8 <commands+0xa08>
ffffffffc0201320:	00004617          	auipc	a2,0x4
ffffffffc0201324:	11860613          	addi	a2,a2,280 # ffffffffc0205438 <commands+0x448>
ffffffffc0201328:	11000593          	li	a1,272
ffffffffc020132c:	00004517          	auipc	a0,0x4
ffffffffc0201330:	40c50513          	addi	a0,a0,1036 # ffffffffc0205738 <commands+0x748>
ffffffffc0201334:	942ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201338:	00004697          	auipc	a3,0x4
ffffffffc020133c:	69868693          	addi	a3,a3,1688 # ffffffffc02059d0 <commands+0x9e0>
ffffffffc0201340:	00004617          	auipc	a2,0x4
ffffffffc0201344:	0f860613          	addi	a2,a2,248 # ffffffffc0205438 <commands+0x448>
ffffffffc0201348:	10e00593          	li	a1,270
ffffffffc020134c:	00004517          	auipc	a0,0x4
ffffffffc0201350:	3ec50513          	addi	a0,a0,1004 # ffffffffc0205738 <commands+0x748>
ffffffffc0201354:	922ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201358:	00004697          	auipc	a3,0x4
ffffffffc020135c:	65068693          	addi	a3,a3,1616 # ffffffffc02059a8 <commands+0x9b8>
ffffffffc0201360:	00004617          	auipc	a2,0x4
ffffffffc0201364:	0d860613          	addi	a2,a2,216 # ffffffffc0205438 <commands+0x448>
ffffffffc0201368:	10d00593          	li	a1,269
ffffffffc020136c:	00004517          	auipc	a0,0x4
ffffffffc0201370:	3cc50513          	addi	a0,a0,972 # ffffffffc0205738 <commands+0x748>
ffffffffc0201374:	902ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201378:	00004697          	auipc	a3,0x4
ffffffffc020137c:	62068693          	addi	a3,a3,1568 # ffffffffc0205998 <commands+0x9a8>
ffffffffc0201380:	00004617          	auipc	a2,0x4
ffffffffc0201384:	0b860613          	addi	a2,a2,184 # ffffffffc0205438 <commands+0x448>
ffffffffc0201388:	10800593          	li	a1,264
ffffffffc020138c:	00004517          	auipc	a0,0x4
ffffffffc0201390:	3ac50513          	addi	a0,a0,940 # ffffffffc0205738 <commands+0x748>
ffffffffc0201394:	8e2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201398:	00004697          	auipc	a3,0x4
ffffffffc020139c:	50068693          	addi	a3,a3,1280 # ffffffffc0205898 <commands+0x8a8>
ffffffffc02013a0:	00004617          	auipc	a2,0x4
ffffffffc02013a4:	09860613          	addi	a2,a2,152 # ffffffffc0205438 <commands+0x448>
ffffffffc02013a8:	10700593          	li	a1,263
ffffffffc02013ac:	00004517          	auipc	a0,0x4
ffffffffc02013b0:	38c50513          	addi	a0,a0,908 # ffffffffc0205738 <commands+0x748>
ffffffffc02013b4:	8c2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02013b8:	00004697          	auipc	a3,0x4
ffffffffc02013bc:	5c068693          	addi	a3,a3,1472 # ffffffffc0205978 <commands+0x988>
ffffffffc02013c0:	00004617          	auipc	a2,0x4
ffffffffc02013c4:	07860613          	addi	a2,a2,120 # ffffffffc0205438 <commands+0x448>
ffffffffc02013c8:	10600593          	li	a1,262
ffffffffc02013cc:	00004517          	auipc	a0,0x4
ffffffffc02013d0:	36c50513          	addi	a0,a0,876 # ffffffffc0205738 <commands+0x748>
ffffffffc02013d4:	8a2ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02013d8:	00004697          	auipc	a3,0x4
ffffffffc02013dc:	57068693          	addi	a3,a3,1392 # ffffffffc0205948 <commands+0x958>
ffffffffc02013e0:	00004617          	auipc	a2,0x4
ffffffffc02013e4:	05860613          	addi	a2,a2,88 # ffffffffc0205438 <commands+0x448>
ffffffffc02013e8:	10500593          	li	a1,261
ffffffffc02013ec:	00004517          	auipc	a0,0x4
ffffffffc02013f0:	34c50513          	addi	a0,a0,844 # ffffffffc0205738 <commands+0x748>
ffffffffc02013f4:	882ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02013f8:	00004697          	auipc	a3,0x4
ffffffffc02013fc:	53868693          	addi	a3,a3,1336 # ffffffffc0205930 <commands+0x940>
ffffffffc0201400:	00004617          	auipc	a2,0x4
ffffffffc0201404:	03860613          	addi	a2,a2,56 # ffffffffc0205438 <commands+0x448>
ffffffffc0201408:	10400593          	li	a1,260
ffffffffc020140c:	00004517          	auipc	a0,0x4
ffffffffc0201410:	32c50513          	addi	a0,a0,812 # ffffffffc0205738 <commands+0x748>
ffffffffc0201414:	862ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201418:	00004697          	auipc	a3,0x4
ffffffffc020141c:	48068693          	addi	a3,a3,1152 # ffffffffc0205898 <commands+0x8a8>
ffffffffc0201420:	00004617          	auipc	a2,0x4
ffffffffc0201424:	01860613          	addi	a2,a2,24 # ffffffffc0205438 <commands+0x448>
ffffffffc0201428:	0fe00593          	li	a1,254
ffffffffc020142c:	00004517          	auipc	a0,0x4
ffffffffc0201430:	30c50513          	addi	a0,a0,780 # ffffffffc0205738 <commands+0x748>
ffffffffc0201434:	842ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(!PageProperty(p0));
ffffffffc0201438:	00004697          	auipc	a3,0x4
ffffffffc020143c:	4e068693          	addi	a3,a3,1248 # ffffffffc0205918 <commands+0x928>
ffffffffc0201440:	00004617          	auipc	a2,0x4
ffffffffc0201444:	ff860613          	addi	a2,a2,-8 # ffffffffc0205438 <commands+0x448>
ffffffffc0201448:	0f900593          	li	a1,249
ffffffffc020144c:	00004517          	auipc	a0,0x4
ffffffffc0201450:	2ec50513          	addi	a0,a0,748 # ffffffffc0205738 <commands+0x748>
ffffffffc0201454:	822ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201458:	00004697          	auipc	a3,0x4
ffffffffc020145c:	5e068693          	addi	a3,a3,1504 # ffffffffc0205a38 <commands+0xa48>
ffffffffc0201460:	00004617          	auipc	a2,0x4
ffffffffc0201464:	fd860613          	addi	a2,a2,-40 # ffffffffc0205438 <commands+0x448>
ffffffffc0201468:	11700593          	li	a1,279
ffffffffc020146c:	00004517          	auipc	a0,0x4
ffffffffc0201470:	2cc50513          	addi	a0,a0,716 # ffffffffc0205738 <commands+0x748>
ffffffffc0201474:	802ff0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(total == 0);
ffffffffc0201478:	00004697          	auipc	a3,0x4
ffffffffc020147c:	5f068693          	addi	a3,a3,1520 # ffffffffc0205a68 <commands+0xa78>
ffffffffc0201480:	00004617          	auipc	a2,0x4
ffffffffc0201484:	fb860613          	addi	a2,a2,-72 # ffffffffc0205438 <commands+0x448>
ffffffffc0201488:	12600593          	li	a1,294
ffffffffc020148c:	00004517          	auipc	a0,0x4
ffffffffc0201490:	2ac50513          	addi	a0,a0,684 # ffffffffc0205738 <commands+0x748>
ffffffffc0201494:	fe3fe0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(total == nr_free_pages());
ffffffffc0201498:	00004697          	auipc	a3,0x4
ffffffffc020149c:	2b868693          	addi	a3,a3,696 # ffffffffc0205750 <commands+0x760>
ffffffffc02014a0:	00004617          	auipc	a2,0x4
ffffffffc02014a4:	f9860613          	addi	a2,a2,-104 # ffffffffc0205438 <commands+0x448>
ffffffffc02014a8:	0f300593          	li	a1,243
ffffffffc02014ac:	00004517          	auipc	a0,0x4
ffffffffc02014b0:	28c50513          	addi	a0,a0,652 # ffffffffc0205738 <commands+0x748>
ffffffffc02014b4:	fc3fe0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014b8:	00004697          	auipc	a3,0x4
ffffffffc02014bc:	2d868693          	addi	a3,a3,728 # ffffffffc0205790 <commands+0x7a0>
ffffffffc02014c0:	00004617          	auipc	a2,0x4
ffffffffc02014c4:	f7860613          	addi	a2,a2,-136 # ffffffffc0205438 <commands+0x448>
ffffffffc02014c8:	0ba00593          	li	a1,186
ffffffffc02014cc:	00004517          	auipc	a0,0x4
ffffffffc02014d0:	26c50513          	addi	a0,a0,620 # ffffffffc0205738 <commands+0x748>
ffffffffc02014d4:	fa3fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02014d8 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02014d8:	1141                	addi	sp,sp,-16
ffffffffc02014da:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02014dc:	12058f63          	beqz	a1,ffffffffc020161a <default_free_pages+0x142>
    for (; p != base + n; p ++) {
ffffffffc02014e0:	00659693          	slli	a3,a1,0x6
ffffffffc02014e4:	96aa                	add	a3,a3,a0
ffffffffc02014e6:	87aa                	mv	a5,a0
ffffffffc02014e8:	02d50263          	beq	a0,a3,ffffffffc020150c <default_free_pages+0x34>
ffffffffc02014ec:	6798                	ld	a4,8(a5)
ffffffffc02014ee:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02014f0:	10071563          	bnez	a4,ffffffffc02015fa <default_free_pages+0x122>
ffffffffc02014f4:	6798                	ld	a4,8(a5)
ffffffffc02014f6:	8b09                	andi	a4,a4,2
ffffffffc02014f8:	10071163          	bnez	a4,ffffffffc02015fa <default_free_pages+0x122>
        p->flags = 0;
ffffffffc02014fc:	0007b423          	sd	zero,8(a5)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc0201500:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201504:	04078793          	addi	a5,a5,64
ffffffffc0201508:	fed792e3          	bne	a5,a3,ffffffffc02014ec <default_free_pages+0x14>
    base->property = n;
ffffffffc020150c:	2581                	sext.w	a1,a1
ffffffffc020150e:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201510:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201514:	4789                	li	a5,2
ffffffffc0201516:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020151a:	0002f697          	auipc	a3,0x2f
ffffffffc020151e:	77668693          	addi	a3,a3,1910 # ffffffffc0230c90 <free_area>
ffffffffc0201522:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201524:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201526:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020152a:	9db9                	addw	a1,a1,a4
ffffffffc020152c:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020152e:	08d78f63          	beq	a5,a3,ffffffffc02015cc <default_free_pages+0xf4>
            struct Page* page = le2page(le, page_link);
ffffffffc0201532:	fe878713          	addi	a4,a5,-24
ffffffffc0201536:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020153a:	4581                	li	a1,0
            if (base < page) {
ffffffffc020153c:	00e56a63          	bltu	a0,a4,ffffffffc0201550 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0201540:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201542:	04d70a63          	beq	a4,a3,ffffffffc0201596 <default_free_pages+0xbe>
    for (; p != base + n; p ++) {
ffffffffc0201546:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201548:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc020154c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201540 <default_free_pages+0x68>
ffffffffc0201550:	c199                	beqz	a1,ffffffffc0201556 <default_free_pages+0x7e>
ffffffffc0201552:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201556:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201558:	e390                	sd	a2,0(a5)
ffffffffc020155a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020155c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020155e:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201560:	00d70c63          	beq	a4,a3,ffffffffc0201578 <default_free_pages+0xa0>
        if (p + p->property == base) {
ffffffffc0201564:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201568:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc020156c:	02059793          	slli	a5,a1,0x20
ffffffffc0201570:	83e9                	srli	a5,a5,0x1a
ffffffffc0201572:	97b2                	add	a5,a5,a2
ffffffffc0201574:	02f50b63          	beq	a0,a5,ffffffffc02015aa <default_free_pages+0xd2>
    return listelm->next;
ffffffffc0201578:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc020157a:	00d70b63          	beq	a4,a3,ffffffffc0201590 <default_free_pages+0xb8>
        if (base + base->property == p) {
ffffffffc020157e:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201580:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0201584:	02061793          	slli	a5,a2,0x20
ffffffffc0201588:	83e9                	srli	a5,a5,0x1a
ffffffffc020158a:	97aa                	add	a5,a5,a0
ffffffffc020158c:	04f68763          	beq	a3,a5,ffffffffc02015da <default_free_pages+0x102>
}
ffffffffc0201590:	60a2                	ld	ra,8(sp)
ffffffffc0201592:	0141                	addi	sp,sp,16
ffffffffc0201594:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201596:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201598:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020159a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020159c:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020159e:	02d70463          	beq	a4,a3,ffffffffc02015c6 <default_free_pages+0xee>
    prev->next = next->prev = elm;
ffffffffc02015a2:	8832                	mv	a6,a2
ffffffffc02015a4:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02015a6:	87ba                	mv	a5,a4
ffffffffc02015a8:	b745                	j	ffffffffc0201548 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc02015aa:	491c                	lw	a5,16(a0)
ffffffffc02015ac:	9dbd                	addw	a1,a1,a5
ffffffffc02015ae:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02015b2:	57f5                	li	a5,-3
ffffffffc02015b4:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015b8:	6d0c                	ld	a1,24(a0)
ffffffffc02015ba:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc02015bc:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02015be:	e59c                	sd	a5,8(a1)
    return listelm->next;
ffffffffc02015c0:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc02015c2:	e38c                	sd	a1,0(a5)
ffffffffc02015c4:	bf5d                	j	ffffffffc020157a <default_free_pages+0xa2>
ffffffffc02015c6:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02015c8:	873e                	mv	a4,a5
ffffffffc02015ca:	bf69                	j	ffffffffc0201564 <default_free_pages+0x8c>
}
ffffffffc02015cc:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02015ce:	e390                	sd	a2,0(a5)
ffffffffc02015d0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02015d2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02015d4:	ed1c                	sd	a5,24(a0)
ffffffffc02015d6:	0141                	addi	sp,sp,16
ffffffffc02015d8:	8082                	ret
            base->property += p->property;
ffffffffc02015da:	ff872783          	lw	a5,-8(a4)
ffffffffc02015de:	ff070693          	addi	a3,a4,-16
ffffffffc02015e2:	9e3d                	addw	a2,a2,a5
ffffffffc02015e4:	c910                	sw	a2,16(a0)
ffffffffc02015e6:	57f5                	li	a5,-3
ffffffffc02015e8:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015ec:	6314                	ld	a3,0(a4)
ffffffffc02015ee:	671c                	ld	a5,8(a4)
}
ffffffffc02015f0:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02015f2:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02015f4:	e394                	sd	a3,0(a5)
ffffffffc02015f6:	0141                	addi	sp,sp,16
ffffffffc02015f8:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02015fa:	00004697          	auipc	a3,0x4
ffffffffc02015fe:	48668693          	addi	a3,a3,1158 # ffffffffc0205a80 <commands+0xa90>
ffffffffc0201602:	00004617          	auipc	a2,0x4
ffffffffc0201606:	e3660613          	addi	a2,a2,-458 # ffffffffc0205438 <commands+0x448>
ffffffffc020160a:	08300593          	li	a1,131
ffffffffc020160e:	00004517          	auipc	a0,0x4
ffffffffc0201612:	12a50513          	addi	a0,a0,298 # ffffffffc0205738 <commands+0x748>
ffffffffc0201616:	e61fe0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(n > 0);
ffffffffc020161a:	00004697          	auipc	a3,0x4
ffffffffc020161e:	45e68693          	addi	a3,a3,1118 # ffffffffc0205a78 <commands+0xa88>
ffffffffc0201622:	00004617          	auipc	a2,0x4
ffffffffc0201626:	e1660613          	addi	a2,a2,-490 # ffffffffc0205438 <commands+0x448>
ffffffffc020162a:	08000593          	li	a1,128
ffffffffc020162e:	00004517          	auipc	a0,0x4
ffffffffc0201632:	10a50513          	addi	a0,a0,266 # ffffffffc0205738 <commands+0x748>
ffffffffc0201636:	e41fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc020163a <default_alloc_pages>:
    assert(n > 0);
ffffffffc020163a:	c941                	beqz	a0,ffffffffc02016ca <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc020163c:	0002f597          	auipc	a1,0x2f
ffffffffc0201640:	65458593          	addi	a1,a1,1620 # ffffffffc0230c90 <free_area>
ffffffffc0201644:	0105a803          	lw	a6,16(a1)
ffffffffc0201648:	872a                	mv	a4,a0
ffffffffc020164a:	02081793          	slli	a5,a6,0x20
ffffffffc020164e:	9381                	srli	a5,a5,0x20
ffffffffc0201650:	00a7ee63          	bltu	a5,a0,ffffffffc020166c <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201654:	87ae                	mv	a5,a1
ffffffffc0201656:	a801                	j	ffffffffc0201666 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201658:	ff87a683          	lw	a3,-8(a5)
ffffffffc020165c:	02069613          	slli	a2,a3,0x20
ffffffffc0201660:	9201                	srli	a2,a2,0x20
ffffffffc0201662:	00e67763          	bgeu	a2,a4,ffffffffc0201670 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201666:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201668:	feb798e3          	bne	a5,a1,ffffffffc0201658 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc020166c:	4501                	li	a0,0
}
ffffffffc020166e:	8082                	ret
    return listelm->prev;
ffffffffc0201670:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201674:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201678:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc020167c:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0201680:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0201684:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0201688:	02c77863          	bgeu	a4,a2,ffffffffc02016b8 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc020168c:	071a                	slli	a4,a4,0x6
ffffffffc020168e:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201690:	41c686bb          	subw	a3,a3,t3
ffffffffc0201694:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201696:	00870613          	addi	a2,a4,8
ffffffffc020169a:	4689                	li	a3,2
ffffffffc020169c:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02016a0:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02016a4:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc02016a8:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02016ac:	e290                	sd	a2,0(a3)
ffffffffc02016ae:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02016b2:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc02016b4:	01173c23          	sd	a7,24(a4)
ffffffffc02016b8:	41c8083b          	subw	a6,a6,t3
ffffffffc02016bc:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02016c0:	5775                	li	a4,-3
ffffffffc02016c2:	17c1                	addi	a5,a5,-16
ffffffffc02016c4:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02016c8:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02016ca:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02016cc:	00004697          	auipc	a3,0x4
ffffffffc02016d0:	3ac68693          	addi	a3,a3,940 # ffffffffc0205a78 <commands+0xa88>
ffffffffc02016d4:	00004617          	auipc	a2,0x4
ffffffffc02016d8:	d6460613          	addi	a2,a2,-668 # ffffffffc0205438 <commands+0x448>
ffffffffc02016dc:	06200593          	li	a1,98
ffffffffc02016e0:	00004517          	auipc	a0,0x4
ffffffffc02016e4:	05850513          	addi	a0,a0,88 # ffffffffc0205738 <commands+0x748>
default_alloc_pages(size_t n) {
ffffffffc02016e8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016ea:	d8dfe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02016ee <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02016ee:	1141                	addi	sp,sp,-16
ffffffffc02016f0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016f2:	c5f1                	beqz	a1,ffffffffc02017be <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc02016f4:	00659693          	slli	a3,a1,0x6
ffffffffc02016f8:	96aa                	add	a3,a3,a0
ffffffffc02016fa:	87aa                	mv	a5,a0
ffffffffc02016fc:	00d50f63          	beq	a0,a3,ffffffffc020171a <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201700:	6798                	ld	a4,8(a5)
ffffffffc0201702:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201704:	cf49                	beqz	a4,ffffffffc020179e <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201706:	0007a823          	sw	zero,16(a5)
ffffffffc020170a:	0007b423          	sd	zero,8(a5)
ffffffffc020170e:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201712:	04078793          	addi	a5,a5,64
ffffffffc0201716:	fed795e3          	bne	a5,a3,ffffffffc0201700 <default_init_memmap+0x12>
    base->property = n;
ffffffffc020171a:	2581                	sext.w	a1,a1
ffffffffc020171c:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020171e:	4789                	li	a5,2
ffffffffc0201720:	00850713          	addi	a4,a0,8
ffffffffc0201724:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201728:	0002f697          	auipc	a3,0x2f
ffffffffc020172c:	56868693          	addi	a3,a3,1384 # ffffffffc0230c90 <free_area>
ffffffffc0201730:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201732:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201734:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201738:	9db9                	addw	a1,a1,a4
ffffffffc020173a:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc020173c:	04d78a63          	beq	a5,a3,ffffffffc0201790 <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc0201740:	fe878713          	addi	a4,a5,-24
ffffffffc0201744:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201748:	4581                	li	a1,0
            if (base < page) {
ffffffffc020174a:	00e56a63          	bltu	a0,a4,ffffffffc020175e <default_init_memmap+0x70>
    return listelm->next;
ffffffffc020174e:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201750:	02d70263          	beq	a4,a3,ffffffffc0201774 <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc0201754:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201756:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc020175a:	fee57ae3          	bgeu	a0,a4,ffffffffc020174e <default_init_memmap+0x60>
ffffffffc020175e:	c199                	beqz	a1,ffffffffc0201764 <default_init_memmap+0x76>
ffffffffc0201760:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201764:	6398                	ld	a4,0(a5)
}
ffffffffc0201766:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201768:	e390                	sd	a2,0(a5)
ffffffffc020176a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020176c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020176e:	ed18                	sd	a4,24(a0)
ffffffffc0201770:	0141                	addi	sp,sp,16
ffffffffc0201772:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201774:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201776:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201778:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020177a:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020177c:	00d70663          	beq	a4,a3,ffffffffc0201788 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201780:	8832                	mv	a6,a2
ffffffffc0201782:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201784:	87ba                	mv	a5,a4
ffffffffc0201786:	bfc1                	j	ffffffffc0201756 <default_init_memmap+0x68>
}
ffffffffc0201788:	60a2                	ld	ra,8(sp)
ffffffffc020178a:	e290                	sd	a2,0(a3)
ffffffffc020178c:	0141                	addi	sp,sp,16
ffffffffc020178e:	8082                	ret
ffffffffc0201790:	60a2                	ld	ra,8(sp)
ffffffffc0201792:	e390                	sd	a2,0(a5)
ffffffffc0201794:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201796:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201798:	ed1c                	sd	a5,24(a0)
ffffffffc020179a:	0141                	addi	sp,sp,16
ffffffffc020179c:	8082                	ret
        assert(PageReserved(p));
ffffffffc020179e:	00004697          	auipc	a3,0x4
ffffffffc02017a2:	30a68693          	addi	a3,a3,778 # ffffffffc0205aa8 <commands+0xab8>
ffffffffc02017a6:	00004617          	auipc	a2,0x4
ffffffffc02017aa:	c9260613          	addi	a2,a2,-878 # ffffffffc0205438 <commands+0x448>
ffffffffc02017ae:	04900593          	li	a1,73
ffffffffc02017b2:	00004517          	auipc	a0,0x4
ffffffffc02017b6:	f8650513          	addi	a0,a0,-122 # ffffffffc0205738 <commands+0x748>
ffffffffc02017ba:	cbdfe0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(n > 0);
ffffffffc02017be:	00004697          	auipc	a3,0x4
ffffffffc02017c2:	2ba68693          	addi	a3,a3,698 # ffffffffc0205a78 <commands+0xa88>
ffffffffc02017c6:	00004617          	auipc	a2,0x4
ffffffffc02017ca:	c7260613          	addi	a2,a2,-910 # ffffffffc0205438 <commands+0x448>
ffffffffc02017ce:	04600593          	li	a1,70
ffffffffc02017d2:	00004517          	auipc	a0,0x4
ffffffffc02017d6:	f6650513          	addi	a0,a0,-154 # ffffffffc0205738 <commands+0x748>
ffffffffc02017da:	c9dfe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02017de <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc02017de:	c94d                	beqz	a0,ffffffffc0201890 <slob_free+0xb2>
{
ffffffffc02017e0:	1141                	addi	sp,sp,-16
ffffffffc02017e2:	e022                	sd	s0,0(sp)
ffffffffc02017e4:	e406                	sd	ra,8(sp)
ffffffffc02017e6:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc02017e8:	e9c1                	bnez	a1,ffffffffc0201878 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017ea:	100027f3          	csrr	a5,sstatus
ffffffffc02017ee:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02017f0:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017f2:	ebd9                	bnez	a5,ffffffffc0201888 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02017f4:	00028617          	auipc	a2,0x28
ffffffffc02017f8:	08c60613          	addi	a2,a2,140 # ffffffffc0229880 <slobfree>
ffffffffc02017fc:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02017fe:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201800:	679c                	ld	a5,8(a5)
ffffffffc0201802:	02877a63          	bgeu	a4,s0,ffffffffc0201836 <slob_free+0x58>
ffffffffc0201806:	00f46463          	bltu	s0,a5,ffffffffc020180e <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020180a:	fef76ae3          	bltu	a4,a5,ffffffffc02017fe <slob_free+0x20>
			break;

	if (b + b->units == cur->next) {
ffffffffc020180e:	400c                	lw	a1,0(s0)
ffffffffc0201810:	00459693          	slli	a3,a1,0x4
ffffffffc0201814:	96a2                	add	a3,a3,s0
ffffffffc0201816:	02d78a63          	beq	a5,a3,ffffffffc020184a <slob_free+0x6c>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc020181a:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc020181c:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc020181e:	00469793          	slli	a5,a3,0x4
ffffffffc0201822:	97ba                	add	a5,a5,a4
ffffffffc0201824:	02f40e63          	beq	s0,a5,ffffffffc0201860 <slob_free+0x82>
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;
ffffffffc0201828:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc020182a:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc020182c:	e129                	bnez	a0,ffffffffc020186e <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc020182e:	60a2                	ld	ra,8(sp)
ffffffffc0201830:	6402                	ld	s0,0(sp)
ffffffffc0201832:	0141                	addi	sp,sp,16
ffffffffc0201834:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201836:	fcf764e3          	bltu	a4,a5,ffffffffc02017fe <slob_free+0x20>
ffffffffc020183a:	fcf472e3          	bgeu	s0,a5,ffffffffc02017fe <slob_free+0x20>
	if (b + b->units == cur->next) {
ffffffffc020183e:	400c                	lw	a1,0(s0)
ffffffffc0201840:	00459693          	slli	a3,a1,0x4
ffffffffc0201844:	96a2                	add	a3,a3,s0
ffffffffc0201846:	fcd79ae3          	bne	a5,a3,ffffffffc020181a <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc020184a:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020184c:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc020184e:	9db5                	addw	a1,a1,a3
ffffffffc0201850:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b) {
ffffffffc0201852:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201854:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b) {
ffffffffc0201856:	00469793          	slli	a5,a3,0x4
ffffffffc020185a:	97ba                	add	a5,a5,a4
ffffffffc020185c:	fcf416e3          	bne	s0,a5,ffffffffc0201828 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201860:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201862:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201864:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201866:	9ebd                	addw	a3,a3,a5
ffffffffc0201868:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc020186a:	e70c                	sd	a1,8(a4)
ffffffffc020186c:	d169                	beqz	a0,ffffffffc020182e <slob_free+0x50>
}
ffffffffc020186e:	6402                	ld	s0,0(sp)
ffffffffc0201870:	60a2                	ld	ra,8(sp)
ffffffffc0201872:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201874:	dbffe06f          	j	ffffffffc0200632 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201878:	25bd                	addiw	a1,a1,15
ffffffffc020187a:	8191                	srli	a1,a1,0x4
ffffffffc020187c:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020187e:	100027f3          	csrr	a5,sstatus
ffffffffc0201882:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201884:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201886:	d7bd                	beqz	a5,ffffffffc02017f4 <slob_free+0x16>
        intr_disable();
ffffffffc0201888:	db1fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc020188c:	4505                	li	a0,1
ffffffffc020188e:	b79d                	j	ffffffffc02017f4 <slob_free+0x16>
ffffffffc0201890:	8082                	ret

ffffffffc0201892 <__slob_get_free_pages.constprop.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc0201892:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201894:	1141                	addi	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc0201896:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020189a:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc020189c:	318000ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
  if(!page)
ffffffffc02018a0:	c91d                	beqz	a0,ffffffffc02018d6 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc02018a2:	00033697          	auipc	a3,0x33
ffffffffc02018a6:	4866b683          	ld	a3,1158(a3) # ffffffffc0234d28 <pages>
ffffffffc02018aa:	8d15                	sub	a0,a0,a3
ffffffffc02018ac:	8519                	srai	a0,a0,0x6
ffffffffc02018ae:	00005697          	auipc	a3,0x5
ffffffffc02018b2:	3026b683          	ld	a3,770(a3) # ffffffffc0206bb0 <nbase>
ffffffffc02018b6:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc02018b8:	00c51793          	slli	a5,a0,0xc
ffffffffc02018bc:	83b1                	srli	a5,a5,0xc
ffffffffc02018be:	00033717          	auipc	a4,0x33
ffffffffc02018c2:	46273703          	ld	a4,1122(a4) # ffffffffc0234d20 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02018c6:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc02018c8:	00e7fa63          	bgeu	a5,a4,ffffffffc02018dc <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02018cc:	00033697          	auipc	a3,0x33
ffffffffc02018d0:	46c6b683          	ld	a3,1132(a3) # ffffffffc0234d38 <va_pa_offset>
ffffffffc02018d4:	9536                	add	a0,a0,a3
}
ffffffffc02018d6:	60a2                	ld	ra,8(sp)
ffffffffc02018d8:	0141                	addi	sp,sp,16
ffffffffc02018da:	8082                	ret
ffffffffc02018dc:	86aa                	mv	a3,a0
ffffffffc02018de:	00004617          	auipc	a2,0x4
ffffffffc02018e2:	22a60613          	addi	a2,a2,554 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc02018e6:	06900593          	li	a1,105
ffffffffc02018ea:	00004517          	auipc	a0,0x4
ffffffffc02018ee:	24650513          	addi	a0,a0,582 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc02018f2:	b85fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02018f6 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02018f6:	1101                	addi	sp,sp,-32
ffffffffc02018f8:	ec06                	sd	ra,24(sp)
ffffffffc02018fa:	e822                	sd	s0,16(sp)
ffffffffc02018fc:	e426                	sd	s1,8(sp)
ffffffffc02018fe:	e04a                	sd	s2,0(sp)
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc0201900:	01050713          	addi	a4,a0,16
ffffffffc0201904:	6785                	lui	a5,0x1
ffffffffc0201906:	0cf77363          	bgeu	a4,a5,ffffffffc02019cc <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc020190a:	00f50493          	addi	s1,a0,15
ffffffffc020190e:	8091                	srli	s1,s1,0x4
ffffffffc0201910:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201912:	10002673          	csrr	a2,sstatus
ffffffffc0201916:	8a09                	andi	a2,a2,2
ffffffffc0201918:	e25d                	bnez	a2,ffffffffc02019be <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc020191a:	00028917          	auipc	s2,0x28
ffffffffc020191e:	f6690913          	addi	s2,s2,-154 # ffffffffc0229880 <slobfree>
ffffffffc0201922:	00093683          	ld	a3,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201926:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201928:	4398                	lw	a4,0(a5)
ffffffffc020192a:	08975e63          	bge	a4,s1,ffffffffc02019c6 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree) {
ffffffffc020192e:	00f68b63          	beq	a3,a5,ffffffffc0201944 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201932:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201934:	4018                	lw	a4,0(s0)
ffffffffc0201936:	02975a63          	bge	a4,s1,ffffffffc020196a <slob_alloc.constprop.0+0x74>
		if (cur == slobfree) {
ffffffffc020193a:	00093683          	ld	a3,0(s2)
ffffffffc020193e:	87a2                	mv	a5,s0
ffffffffc0201940:	fef699e3          	bne	a3,a5,ffffffffc0201932 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc0201944:	ee31                	bnez	a2,ffffffffc02019a0 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201946:	4501                	li	a0,0
ffffffffc0201948:	f4bff0ef          	jal	ra,ffffffffc0201892 <__slob_get_free_pages.constprop.0>
ffffffffc020194c:	842a                	mv	s0,a0
			if (!cur)
ffffffffc020194e:	cd05                	beqz	a0,ffffffffc0201986 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201950:	6585                	lui	a1,0x1
ffffffffc0201952:	e8dff0ef          	jal	ra,ffffffffc02017de <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201956:	10002673          	csrr	a2,sstatus
ffffffffc020195a:	8a09                	andi	a2,a2,2
ffffffffc020195c:	ee05                	bnez	a2,ffffffffc0201994 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc020195e:	00093783          	ld	a5,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201962:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201964:	4018                	lw	a4,0(s0)
ffffffffc0201966:	fc974ae3          	blt	a4,s1,ffffffffc020193a <slob_alloc.constprop.0+0x44>
			if (cur->units == units) /* exact fit? */
ffffffffc020196a:	04e48763          	beq	s1,a4,ffffffffc02019b8 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc020196e:	00449693          	slli	a3,s1,0x4
ffffffffc0201972:	96a2                	add	a3,a3,s0
ffffffffc0201974:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201976:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201978:	9f05                	subw	a4,a4,s1
ffffffffc020197a:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc020197c:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc020197e:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201980:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc0201984:	e20d                	bnez	a2,ffffffffc02019a6 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201986:	60e2                	ld	ra,24(sp)
ffffffffc0201988:	8522                	mv	a0,s0
ffffffffc020198a:	6442                	ld	s0,16(sp)
ffffffffc020198c:	64a2                	ld	s1,8(sp)
ffffffffc020198e:	6902                	ld	s2,0(sp)
ffffffffc0201990:	6105                	addi	sp,sp,32
ffffffffc0201992:	8082                	ret
        intr_disable();
ffffffffc0201994:	ca5fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
			cur = slobfree;
ffffffffc0201998:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc020199c:	4605                	li	a2,1
ffffffffc020199e:	b7d1                	j	ffffffffc0201962 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02019a0:	c93fe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc02019a4:	b74d                	j	ffffffffc0201946 <slob_alloc.constprop.0+0x50>
ffffffffc02019a6:	c8dfe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
}
ffffffffc02019aa:	60e2                	ld	ra,24(sp)
ffffffffc02019ac:	8522                	mv	a0,s0
ffffffffc02019ae:	6442                	ld	s0,16(sp)
ffffffffc02019b0:	64a2                	ld	s1,8(sp)
ffffffffc02019b2:	6902                	ld	s2,0(sp)
ffffffffc02019b4:	6105                	addi	sp,sp,32
ffffffffc02019b6:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc02019b8:	6418                	ld	a4,8(s0)
ffffffffc02019ba:	e798                	sd	a4,8(a5)
ffffffffc02019bc:	b7d1                	j	ffffffffc0201980 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc02019be:	c7bfe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc02019c2:	4605                	li	a2,1
ffffffffc02019c4:	bf99                	j	ffffffffc020191a <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02019c6:	843e                	mv	s0,a5
ffffffffc02019c8:	87b6                	mv	a5,a3
ffffffffc02019ca:	b745                	j	ffffffffc020196a <slob_alloc.constprop.0+0x74>
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02019cc:	00004697          	auipc	a3,0x4
ffffffffc02019d0:	17468693          	addi	a3,a3,372 # ffffffffc0205b40 <default_pmm_manager+0x70>
ffffffffc02019d4:	00004617          	auipc	a2,0x4
ffffffffc02019d8:	a6460613          	addi	a2,a2,-1436 # ffffffffc0205438 <commands+0x448>
ffffffffc02019dc:	06400593          	li	a1,100
ffffffffc02019e0:	00004517          	auipc	a0,0x4
ffffffffc02019e4:	18050513          	addi	a0,a0,384 # ffffffffc0205b60 <default_pmm_manager+0x90>
ffffffffc02019e8:	a8ffe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02019ec <kmalloc_init>:

inline void 
kmalloc_init(void) {
    slob_init();
    //cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc02019ec:	8082                	ret

ffffffffc02019ee <kallocated>:
}

size_t
kallocated(void) {
   return slob_allocated();
}
ffffffffc02019ee:	4501                	li	a0,0
ffffffffc02019f0:	8082                	ret

ffffffffc02019f2 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc02019f2:	1101                	addi	sp,sp,-32
ffffffffc02019f4:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02019f6:	6905                	lui	s2,0x1
{
ffffffffc02019f8:	e822                	sd	s0,16(sp)
ffffffffc02019fa:	ec06                	sd	ra,24(sp)
ffffffffc02019fc:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02019fe:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_hello_out_size-0x8d91>
{
ffffffffc0201a02:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0201a04:	04a7f963          	bgeu	a5,a0,ffffffffc0201a56 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201a08:	4561                	li	a0,24
ffffffffc0201a0a:	eedff0ef          	jal	ra,ffffffffc02018f6 <slob_alloc.constprop.0>
ffffffffc0201a0e:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201a10:	c929                	beqz	a0,ffffffffc0201a62 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201a12:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201a16:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201a18:	00f95763          	bge	s2,a5,ffffffffc0201a26 <kmalloc+0x34>
ffffffffc0201a1c:	6705                	lui	a4,0x1
ffffffffc0201a1e:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201a20:	2505                	addiw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc0201a22:	fef74ee3          	blt	a4,a5,ffffffffc0201a1e <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201a26:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201a28:	e6bff0ef          	jal	ra,ffffffffc0201892 <__slob_get_free_pages.constprop.0>
ffffffffc0201a2c:	e488                	sd	a0,8(s1)
ffffffffc0201a2e:	842a                	mv	s0,a0
	if (bb->pages) {
ffffffffc0201a30:	c525                	beqz	a0,ffffffffc0201a98 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a32:	100027f3          	csrr	a5,sstatus
ffffffffc0201a36:	8b89                	andi	a5,a5,2
ffffffffc0201a38:	ef8d                	bnez	a5,ffffffffc0201a72 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201a3a:	00033797          	auipc	a5,0x33
ffffffffc0201a3e:	2ce78793          	addi	a5,a5,718 # ffffffffc0234d08 <bigblocks>
ffffffffc0201a42:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201a44:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201a46:	e898                	sd	a4,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc0201a48:	60e2                	ld	ra,24(sp)
ffffffffc0201a4a:	8522                	mv	a0,s0
ffffffffc0201a4c:	6442                	ld	s0,16(sp)
ffffffffc0201a4e:	64a2                	ld	s1,8(sp)
ffffffffc0201a50:	6902                	ld	s2,0(sp)
ffffffffc0201a52:	6105                	addi	sp,sp,32
ffffffffc0201a54:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201a56:	0541                	addi	a0,a0,16
ffffffffc0201a58:	e9fff0ef          	jal	ra,ffffffffc02018f6 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201a5c:	01050413          	addi	s0,a0,16
ffffffffc0201a60:	f565                	bnez	a0,ffffffffc0201a48 <kmalloc+0x56>
ffffffffc0201a62:	4401                	li	s0,0
}
ffffffffc0201a64:	60e2                	ld	ra,24(sp)
ffffffffc0201a66:	8522                	mv	a0,s0
ffffffffc0201a68:	6442                	ld	s0,16(sp)
ffffffffc0201a6a:	64a2                	ld	s1,8(sp)
ffffffffc0201a6c:	6902                	ld	s2,0(sp)
ffffffffc0201a6e:	6105                	addi	sp,sp,32
ffffffffc0201a70:	8082                	ret
        intr_disable();
ffffffffc0201a72:	bc7fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201a76:	00033797          	auipc	a5,0x33
ffffffffc0201a7a:	29278793          	addi	a5,a5,658 # ffffffffc0234d08 <bigblocks>
ffffffffc0201a7e:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201a80:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201a82:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201a84:	baffe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
		return bb->pages;
ffffffffc0201a88:	6480                	ld	s0,8(s1)
}
ffffffffc0201a8a:	60e2                	ld	ra,24(sp)
ffffffffc0201a8c:	64a2                	ld	s1,8(sp)
ffffffffc0201a8e:	8522                	mv	a0,s0
ffffffffc0201a90:	6442                	ld	s0,16(sp)
ffffffffc0201a92:	6902                	ld	s2,0(sp)
ffffffffc0201a94:	6105                	addi	sp,sp,32
ffffffffc0201a96:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a98:	45e1                	li	a1,24
ffffffffc0201a9a:	8526                	mv	a0,s1
ffffffffc0201a9c:	d43ff0ef          	jal	ra,ffffffffc02017de <slob_free>
  return __kmalloc(size, 0);
ffffffffc0201aa0:	b765                	j	ffffffffc0201a48 <kmalloc+0x56>

ffffffffc0201aa2 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201aa2:	c169                	beqz	a0,ffffffffc0201b64 <kfree+0xc2>
{
ffffffffc0201aa4:	1101                	addi	sp,sp,-32
ffffffffc0201aa6:	e822                	sd	s0,16(sp)
ffffffffc0201aa8:	ec06                	sd	ra,24(sp)
ffffffffc0201aaa:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc0201aac:	03451793          	slli	a5,a0,0x34
ffffffffc0201ab0:	842a                	mv	s0,a0
ffffffffc0201ab2:	e3d9                	bnez	a5,ffffffffc0201b38 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201ab4:	100027f3          	csrr	a5,sstatus
ffffffffc0201ab8:	8b89                	andi	a5,a5,2
ffffffffc0201aba:	e7d9                	bnez	a5,ffffffffc0201b48 <kfree+0xa6>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201abc:	00033797          	auipc	a5,0x33
ffffffffc0201ac0:	24c7b783          	ld	a5,588(a5) # ffffffffc0234d08 <bigblocks>
    return 0;
ffffffffc0201ac4:	4601                	li	a2,0
ffffffffc0201ac6:	cbad                	beqz	a5,ffffffffc0201b38 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201ac8:	00033697          	auipc	a3,0x33
ffffffffc0201acc:	24068693          	addi	a3,a3,576 # ffffffffc0234d08 <bigblocks>
ffffffffc0201ad0:	a021                	j	ffffffffc0201ad8 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201ad2:	01048693          	addi	a3,s1,16
ffffffffc0201ad6:	c3a5                	beqz	a5,ffffffffc0201b36 <kfree+0x94>
			if (bb->pages == block) {
ffffffffc0201ad8:	6798                	ld	a4,8(a5)
ffffffffc0201ada:	84be                	mv	s1,a5
				*last = bb->next;
ffffffffc0201adc:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block) {
ffffffffc0201ade:	fe871ae3          	bne	a4,s0,ffffffffc0201ad2 <kfree+0x30>
				*last = bb->next;
ffffffffc0201ae2:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201ae4:	ee2d                	bnez	a2,ffffffffc0201b5e <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201ae6:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201aea:	4098                	lw	a4,0(s1)
ffffffffc0201aec:	08f46963          	bltu	s0,a5,ffffffffc0201b7e <kfree+0xdc>
ffffffffc0201af0:	00033697          	auipc	a3,0x33
ffffffffc0201af4:	2486b683          	ld	a3,584(a3) # ffffffffc0234d38 <va_pa_offset>
ffffffffc0201af8:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage) {
ffffffffc0201afa:	8031                	srli	s0,s0,0xc
ffffffffc0201afc:	00033797          	auipc	a5,0x33
ffffffffc0201b00:	2247b783          	ld	a5,548(a5) # ffffffffc0234d20 <npage>
ffffffffc0201b04:	06f47163          	bgeu	s0,a5,ffffffffc0201b66 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201b08:	00005517          	auipc	a0,0x5
ffffffffc0201b0c:	0a853503          	ld	a0,168(a0) # ffffffffc0206bb0 <nbase>
ffffffffc0201b10:	8c09                	sub	s0,s0,a0
ffffffffc0201b12:	041a                	slli	s0,s0,0x6
  free_pages(kva2page(kva), 1 << order);
ffffffffc0201b14:	00033517          	auipc	a0,0x33
ffffffffc0201b18:	21453503          	ld	a0,532(a0) # ffffffffc0234d28 <pages>
ffffffffc0201b1c:	4585                	li	a1,1
ffffffffc0201b1e:	9522                	add	a0,a0,s0
ffffffffc0201b20:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201b24:	122000ef          	jal	ra,ffffffffc0201c46 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201b28:	6442                	ld	s0,16(sp)
ffffffffc0201b2a:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b2c:	8526                	mv	a0,s1
}
ffffffffc0201b2e:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b30:	45e1                	li	a1,24
}
ffffffffc0201b32:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201b34:	b16d                	j	ffffffffc02017de <slob_free>
ffffffffc0201b36:	e20d                	bnez	a2,ffffffffc0201b58 <kfree+0xb6>
ffffffffc0201b38:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201b3c:	6442                	ld	s0,16(sp)
ffffffffc0201b3e:	60e2                	ld	ra,24(sp)
ffffffffc0201b40:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201b42:	4581                	li	a1,0
}
ffffffffc0201b44:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201b46:	b961                	j	ffffffffc02017de <slob_free>
        intr_disable();
ffffffffc0201b48:	af1fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201b4c:	00033797          	auipc	a5,0x33
ffffffffc0201b50:	1bc7b783          	ld	a5,444(a5) # ffffffffc0234d08 <bigblocks>
        return 1;
ffffffffc0201b54:	4605                	li	a2,1
ffffffffc0201b56:	fbad                	bnez	a5,ffffffffc0201ac8 <kfree+0x26>
        intr_enable();
ffffffffc0201b58:	adbfe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc0201b5c:	bff1                	j	ffffffffc0201b38 <kfree+0x96>
ffffffffc0201b5e:	ad5fe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc0201b62:	b751                	j	ffffffffc0201ae6 <kfree+0x44>
ffffffffc0201b64:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201b66:	00004617          	auipc	a2,0x4
ffffffffc0201b6a:	03a60613          	addi	a2,a2,58 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc0201b6e:	06200593          	li	a1,98
ffffffffc0201b72:	00004517          	auipc	a0,0x4
ffffffffc0201b76:	fbe50513          	addi	a0,a0,-66 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0201b7a:	8fdfe0ef          	jal	ra,ffffffffc0200476 <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201b7e:	86a2                	mv	a3,s0
ffffffffc0201b80:	00004617          	auipc	a2,0x4
ffffffffc0201b84:	ff860613          	addi	a2,a2,-8 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc0201b88:	06e00593          	li	a1,110
ffffffffc0201b8c:	00004517          	auipc	a0,0x4
ffffffffc0201b90:	fa450513          	addi	a0,a0,-92 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0201b94:	8e3fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0201b98 <pa2page.part.0>:
pa2page(uintptr_t pa) {
ffffffffc0201b98:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201b9a:	00004617          	auipc	a2,0x4
ffffffffc0201b9e:	00660613          	addi	a2,a2,6 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc0201ba2:	06200593          	li	a1,98
ffffffffc0201ba6:	00004517          	auipc	a0,0x4
ffffffffc0201baa:	f8a50513          	addi	a0,a0,-118 # ffffffffc0205b30 <default_pmm_manager+0x60>
pa2page(uintptr_t pa) {
ffffffffc0201bae:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201bb0:	8c7fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0201bb4 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0201bb4:	7139                	addi	sp,sp,-64
ffffffffc0201bb6:	f426                	sd	s1,40(sp)
ffffffffc0201bb8:	f04a                	sd	s2,32(sp)
ffffffffc0201bba:	ec4e                	sd	s3,24(sp)
ffffffffc0201bbc:	e852                	sd	s4,16(sp)
ffffffffc0201bbe:	e456                	sd	s5,8(sp)
ffffffffc0201bc0:	e05a                	sd	s6,0(sp)
ffffffffc0201bc2:	fc06                	sd	ra,56(sp)
ffffffffc0201bc4:	f822                	sd	s0,48(sp)
ffffffffc0201bc6:	84aa                	mv	s1,a0
ffffffffc0201bc8:	00033917          	auipc	s2,0x33
ffffffffc0201bcc:	16890913          	addi	s2,s2,360 # ffffffffc0234d30 <pmm_manager>
        {
            page = pmm_manager->alloc_pages(n);
        }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201bd0:	4a05                	li	s4,1
ffffffffc0201bd2:	00033a97          	auipc	s5,0x33
ffffffffc0201bd6:	17ea8a93          	addi	s5,s5,382 # ffffffffc0234d50 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0201bda:	0005099b          	sext.w	s3,a0
ffffffffc0201bde:	00033b17          	auipc	s6,0x33
ffffffffc0201be2:	17ab0b13          	addi	s6,s6,378 # ffffffffc0234d58 <check_mm_struct>
ffffffffc0201be6:	a01d                	j	ffffffffc0201c0c <alloc_pages+0x58>
            page = pmm_manager->alloc_pages(n);
ffffffffc0201be8:	00093783          	ld	a5,0(s2)
ffffffffc0201bec:	6f9c                	ld	a5,24(a5)
ffffffffc0201bee:	9782                	jalr	a5
ffffffffc0201bf0:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0201bf2:	4601                	li	a2,0
ffffffffc0201bf4:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201bf6:	ec0d                	bnez	s0,ffffffffc0201c30 <alloc_pages+0x7c>
ffffffffc0201bf8:	029a6c63          	bltu	s4,s1,ffffffffc0201c30 <alloc_pages+0x7c>
ffffffffc0201bfc:	000aa783          	lw	a5,0(s5)
ffffffffc0201c00:	2781                	sext.w	a5,a5
ffffffffc0201c02:	c79d                	beqz	a5,ffffffffc0201c30 <alloc_pages+0x7c>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201c04:	000b3503          	ld	a0,0(s6)
ffffffffc0201c08:	2e1000ef          	jal	ra,ffffffffc02026e8 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c0c:	100027f3          	csrr	a5,sstatus
ffffffffc0201c10:	8b89                	andi	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0201c12:	8526                	mv	a0,s1
ffffffffc0201c14:	dbf1                	beqz	a5,ffffffffc0201be8 <alloc_pages+0x34>
        intr_disable();
ffffffffc0201c16:	a23fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
ffffffffc0201c1a:	00093783          	ld	a5,0(s2)
ffffffffc0201c1e:	8526                	mv	a0,s1
ffffffffc0201c20:	6f9c                	ld	a5,24(a5)
ffffffffc0201c22:	9782                	jalr	a5
ffffffffc0201c24:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201c26:	a0dfe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201c2a:	4601                	li	a2,0
ffffffffc0201c2c:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201c2e:	d469                	beqz	s0,ffffffffc0201bf8 <alloc_pages+0x44>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0201c30:	70e2                	ld	ra,56(sp)
ffffffffc0201c32:	8522                	mv	a0,s0
ffffffffc0201c34:	7442                	ld	s0,48(sp)
ffffffffc0201c36:	74a2                	ld	s1,40(sp)
ffffffffc0201c38:	7902                	ld	s2,32(sp)
ffffffffc0201c3a:	69e2                	ld	s3,24(sp)
ffffffffc0201c3c:	6a42                	ld	s4,16(sp)
ffffffffc0201c3e:	6aa2                	ld	s5,8(sp)
ffffffffc0201c40:	6b02                	ld	s6,0(sp)
ffffffffc0201c42:	6121                	addi	sp,sp,64
ffffffffc0201c44:	8082                	ret

ffffffffc0201c46 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c46:	100027f3          	csrr	a5,sstatus
ffffffffc0201c4a:	8b89                	andi	a5,a5,2
ffffffffc0201c4c:	e799                	bnez	a5,ffffffffc0201c5a <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201c4e:	00033797          	auipc	a5,0x33
ffffffffc0201c52:	0e27b783          	ld	a5,226(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc0201c56:	739c                	ld	a5,32(a5)
ffffffffc0201c58:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201c5a:	1101                	addi	sp,sp,-32
ffffffffc0201c5c:	ec06                	sd	ra,24(sp)
ffffffffc0201c5e:	e822                	sd	s0,16(sp)
ffffffffc0201c60:	e426                	sd	s1,8(sp)
ffffffffc0201c62:	842a                	mv	s0,a0
ffffffffc0201c64:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201c66:	9d3fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201c6a:	00033797          	auipc	a5,0x33
ffffffffc0201c6e:	0c67b783          	ld	a5,198(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc0201c72:	739c                	ld	a5,32(a5)
ffffffffc0201c74:	85a6                	mv	a1,s1
ffffffffc0201c76:	8522                	mv	a0,s0
ffffffffc0201c78:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201c7a:	6442                	ld	s0,16(sp)
ffffffffc0201c7c:	60e2                	ld	ra,24(sp)
ffffffffc0201c7e:	64a2                	ld	s1,8(sp)
ffffffffc0201c80:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201c82:	9b1fe06f          	j	ffffffffc0200632 <intr_enable>

ffffffffc0201c86 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c86:	100027f3          	csrr	a5,sstatus
ffffffffc0201c8a:	8b89                	andi	a5,a5,2
ffffffffc0201c8c:	e799                	bnez	a5,ffffffffc0201c9a <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201c8e:	00033797          	auipc	a5,0x33
ffffffffc0201c92:	0a27b783          	ld	a5,162(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc0201c96:	779c                	ld	a5,40(a5)
ffffffffc0201c98:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201c9a:	1141                	addi	sp,sp,-16
ffffffffc0201c9c:	e406                	sd	ra,8(sp)
ffffffffc0201c9e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201ca0:	999fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201ca4:	00033797          	auipc	a5,0x33
ffffffffc0201ca8:	08c7b783          	ld	a5,140(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc0201cac:	779c                	ld	a5,40(a5)
ffffffffc0201cae:	9782                	jalr	a5
ffffffffc0201cb0:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201cb2:	981fe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201cb6:	60a2                	ld	ra,8(sp)
ffffffffc0201cb8:	8522                	mv	a0,s0
ffffffffc0201cba:	6402                	ld	s0,0(sp)
ffffffffc0201cbc:	0141                	addi	sp,sp,16
ffffffffc0201cbe:	8082                	ret

ffffffffc0201cc0 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201cc0:	00004797          	auipc	a5,0x4
ffffffffc0201cc4:	e1078793          	addi	a5,a5,-496 # ffffffffc0205ad0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201cc8:	638c                	ld	a1,0(a5)
}

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup
// paging mechanism
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void) {
ffffffffc0201cca:	1101                	addi	sp,sp,-32
ffffffffc0201ccc:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201cce:	00004517          	auipc	a0,0x4
ffffffffc0201cd2:	f1a50513          	addi	a0,a0,-230 # ffffffffc0205be8 <default_pmm_manager+0x118>
    pmm_manager = &default_pmm_manager;
ffffffffc0201cd6:	00033497          	auipc	s1,0x33
ffffffffc0201cda:	05a48493          	addi	s1,s1,90 # ffffffffc0234d30 <pmm_manager>
void pmm_init(void) {
ffffffffc0201cde:	ec06                	sd	ra,24(sp)
ffffffffc0201ce0:	e822                	sd	s0,16(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201ce2:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201ce4:	c98fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    pmm_manager->init();
ffffffffc0201ce8:	609c                	ld	a5,0(s1)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201cea:	00033417          	auipc	s0,0x33
ffffffffc0201cee:	04e40413          	addi	s0,s0,78 # ffffffffc0234d38 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201cf2:	679c                	ld	a5,8(a5)
ffffffffc0201cf4:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201cf6:	57f5                	li	a5,-3
ffffffffc0201cf8:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201cfa:	00004517          	auipc	a0,0x4
ffffffffc0201cfe:	f0650513          	addi	a0,a0,-250 # ffffffffc0205c00 <default_pmm_manager+0x130>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201d02:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc0201d04:	c78fe0ef          	jal	ra,ffffffffc020017c <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201d08:	44300693          	li	a3,1091
ffffffffc0201d0c:	06d6                	slli	a3,a3,0x15
ffffffffc0201d0e:	40100613          	li	a2,1025
ffffffffc0201d12:	0656                	slli	a2,a2,0x15
ffffffffc0201d14:	088005b7          	lui	a1,0x8800
ffffffffc0201d18:	16fd                	addi	a3,a3,-1
ffffffffc0201d1a:	00004517          	auipc	a0,0x4
ffffffffc0201d1e:	efe50513          	addi	a0,a0,-258 # ffffffffc0205c18 <default_pmm_manager+0x148>
ffffffffc0201d22:	c5afe0ef          	jal	ra,ffffffffc020017c <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201d26:	777d                	lui	a4,0xfffff
ffffffffc0201d28:	00034797          	auipc	a5,0x34
ffffffffc0201d2c:	06f78793          	addi	a5,a5,111 # ffffffffc0235d97 <end+0xfff>
ffffffffc0201d30:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201d32:	00088737          	lui	a4,0x88
ffffffffc0201d36:	60070713          	addi	a4,a4,1536 # 88600 <_binary_obj___user_rr_out_size+0x7d560>
ffffffffc0201d3a:	00033597          	auipc	a1,0x33
ffffffffc0201d3e:	fe658593          	addi	a1,a1,-26 # ffffffffc0234d20 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201d42:	00033617          	auipc	a2,0x33
ffffffffc0201d46:	fe660613          	addi	a2,a2,-26 # ffffffffc0234d28 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201d4a:	e198                	sd	a4,0(a1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201d4c:	e21c                	sd	a5,0(a2)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201d4e:	4701                	li	a4,0
ffffffffc0201d50:	4505                	li	a0,1
ffffffffc0201d52:	fff80837          	lui	a6,0xfff80
ffffffffc0201d56:	a011                	j	ffffffffc0201d5a <pmm_init+0x9a>
        SetPageReserved(pages + i);
ffffffffc0201d58:	621c                	ld	a5,0(a2)
ffffffffc0201d5a:	00671693          	slli	a3,a4,0x6
ffffffffc0201d5e:	97b6                	add	a5,a5,a3
ffffffffc0201d60:	07a1                	addi	a5,a5,8
ffffffffc0201d62:	40a7b02f          	amoor.d	zero,a0,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201d66:	619c                	ld	a5,0(a1)
ffffffffc0201d68:	0705                	addi	a4,a4,1
ffffffffc0201d6a:	010786b3          	add	a3,a5,a6
ffffffffc0201d6e:	fed765e3          	bltu	a4,a3,ffffffffc0201d58 <pmm_init+0x98>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201d72:	6218                	ld	a4,0(a2)
ffffffffc0201d74:	069a                	slli	a3,a3,0x6
ffffffffc0201d76:	c0200637          	lui	a2,0xc0200
ffffffffc0201d7a:	96ba                	add	a3,a3,a4
ffffffffc0201d7c:	06c6e563          	bltu	a3,a2,ffffffffc0201de6 <pmm_init+0x126>
ffffffffc0201d80:	6010                	ld	a2,0(s0)
    if (freemem < mem_end) {
ffffffffc0201d82:	44300593          	li	a1,1091
ffffffffc0201d86:	05d6                	slli	a1,a1,0x15
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201d88:	8e91                	sub	a3,a3,a2
    if (freemem < mem_end) {
ffffffffc0201d8a:	02b6e963          	bltu	a3,a1,ffffffffc0201dbc <pmm_init+0xfc>
    // pmm
    //check_alloc_page();

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    extern char boot_page_table_sv39[];
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201d8e:	00007697          	auipc	a3,0x7
ffffffffc0201d92:	27268693          	addi	a3,a3,626 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc0201d96:	00033797          	auipc	a5,0x33
ffffffffc0201d9a:	f8d7b123          	sd	a3,-126(a5) # ffffffffc0234d18 <boot_pgdir>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201d9e:	c02007b7          	lui	a5,0xc0200
ffffffffc0201da2:	04f6ee63          	bltu	a3,a5,ffffffffc0201dfe <pmm_init+0x13e>
ffffffffc0201da6:	601c                	ld	a5,0(s0)
    // check the correctness of the basic virtual memory map.
    //check_boot_pgdir();


    kmalloc_init();
}
ffffffffc0201da8:	6442                	ld	s0,16(sp)
ffffffffc0201daa:	60e2                	ld	ra,24(sp)
ffffffffc0201dac:	64a2                	ld	s1,8(sp)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201dae:	8e9d                	sub	a3,a3,a5
ffffffffc0201db0:	00033797          	auipc	a5,0x33
ffffffffc0201db4:	f6d7b023          	sd	a3,-160(a5) # ffffffffc0234d10 <boot_cr3>
}
ffffffffc0201db8:	6105                	addi	sp,sp,32
    kmalloc_init();
ffffffffc0201dba:	b90d                	j	ffffffffc02019ec <kmalloc_init>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201dbc:	6605                	lui	a2,0x1
ffffffffc0201dbe:	167d                	addi	a2,a2,-1
ffffffffc0201dc0:	96b2                	add	a3,a3,a2
ffffffffc0201dc2:	767d                	lui	a2,0xfffff
ffffffffc0201dc4:	8ef1                	and	a3,a3,a2
    if (PPN(pa) >= npage) {
ffffffffc0201dc6:	00c6d613          	srli	a2,a3,0xc
ffffffffc0201dca:	00f67c63          	bgeu	a2,a5,ffffffffc0201de2 <pmm_init+0x122>
    pmm_manager->init_memmap(base, n);
ffffffffc0201dce:	609c                	ld	a5,0(s1)
    return &pages[PPN(pa) - nbase];
ffffffffc0201dd0:	9642                	add	a2,a2,a6
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201dd2:	8d95                	sub	a1,a1,a3
    pmm_manager->init_memmap(base, n);
ffffffffc0201dd4:	6b9c                	ld	a5,16(a5)
ffffffffc0201dd6:	00661513          	slli	a0,a2,0x6
ffffffffc0201dda:	81b1                	srli	a1,a1,0xc
ffffffffc0201ddc:	953a                	add	a0,a0,a4
ffffffffc0201dde:	9782                	jalr	a5
}
ffffffffc0201de0:	b77d                	j	ffffffffc0201d8e <pmm_init+0xce>
ffffffffc0201de2:	db7ff0ef          	jal	ra,ffffffffc0201b98 <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201de6:	00004617          	auipc	a2,0x4
ffffffffc0201dea:	d9260613          	addi	a2,a2,-622 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc0201dee:	07f00593          	li	a1,127
ffffffffc0201df2:	00004517          	auipc	a0,0x4
ffffffffc0201df6:	e4e50513          	addi	a0,a0,-434 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0201dfa:	e7cfe0ef          	jal	ra,ffffffffc0200476 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201dfe:	00004617          	auipc	a2,0x4
ffffffffc0201e02:	d7a60613          	addi	a2,a2,-646 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc0201e06:	0c100593          	li	a1,193
ffffffffc0201e0a:	00004517          	auipc	a0,0x4
ffffffffc0201e0e:	e3650513          	addi	a0,a0,-458 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0201e12:	e64fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0201e16 <get_pte>:
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e16:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201e1a:	1ff7f793          	andi	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201e1e:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e20:	078e                	slli	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201e22:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201e24:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201e28:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201e2a:	f04a                	sd	s2,32(sp)
ffffffffc0201e2c:	ec4e                	sd	s3,24(sp)
ffffffffc0201e2e:	e852                	sd	s4,16(sp)
ffffffffc0201e30:	fc06                	sd	ra,56(sp)
ffffffffc0201e32:	f822                	sd	s0,48(sp)
ffffffffc0201e34:	e456                	sd	s5,8(sp)
ffffffffc0201e36:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201e38:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201e3c:	892e                	mv	s2,a1
ffffffffc0201e3e:	89b2                	mv	s3,a2
ffffffffc0201e40:	00033a17          	auipc	s4,0x33
ffffffffc0201e44:	ee0a0a13          	addi	s4,s4,-288 # ffffffffc0234d20 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201e48:	e7b5                	bnez	a5,ffffffffc0201eb4 <get_pte+0x9e>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201e4a:	12060b63          	beqz	a2,ffffffffc0201f80 <get_pte+0x16a>
ffffffffc0201e4e:	4505                	li	a0,1
ffffffffc0201e50:	d65ff0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0201e54:	842a                	mv	s0,a0
ffffffffc0201e56:	12050563          	beqz	a0,ffffffffc0201f80 <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201e5a:	00033b17          	auipc	s6,0x33
ffffffffc0201e5e:	eceb0b13          	addi	s6,s6,-306 # ffffffffc0234d28 <pages>
ffffffffc0201e62:	000b3503          	ld	a0,0(s6)
ffffffffc0201e66:	00080ab7          	lui	s5,0x80
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e6a:	00033a17          	auipc	s4,0x33
ffffffffc0201e6e:	eb6a0a13          	addi	s4,s4,-330 # ffffffffc0234d20 <npage>
ffffffffc0201e72:	40a40533          	sub	a0,s0,a0
ffffffffc0201e76:	8519                	srai	a0,a0,0x6
ffffffffc0201e78:	9556                	add	a0,a0,s5
ffffffffc0201e7a:	000a3703          	ld	a4,0(s4)
ffffffffc0201e7e:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201e82:	4685                	li	a3,1
ffffffffc0201e84:	c014                	sw	a3,0(s0)
ffffffffc0201e86:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e88:	0532                	slli	a0,a0,0xc
ffffffffc0201e8a:	14e7f263          	bgeu	a5,a4,ffffffffc0201fce <get_pte+0x1b8>
ffffffffc0201e8e:	00033797          	auipc	a5,0x33
ffffffffc0201e92:	eaa7b783          	ld	a5,-342(a5) # ffffffffc0234d38 <va_pa_offset>
ffffffffc0201e96:	6605                	lui	a2,0x1
ffffffffc0201e98:	4581                	li	a1,0
ffffffffc0201e9a:	953e                	add	a0,a0,a5
ffffffffc0201e9c:	6cb020ef          	jal	ra,ffffffffc0204d66 <memset>
    return page - pages + nbase;
ffffffffc0201ea0:	000b3683          	ld	a3,0(s6)
ffffffffc0201ea4:	40d406b3          	sub	a3,s0,a3
ffffffffc0201ea8:	8699                	srai	a3,a3,0x6
ffffffffc0201eaa:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vm");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201eac:	06aa                	slli	a3,a3,0xa
ffffffffc0201eae:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201eb2:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201eb4:	77fd                	lui	a5,0xfffff
ffffffffc0201eb6:	068a                	slli	a3,a3,0x2
ffffffffc0201eb8:	000a3703          	ld	a4,0(s4)
ffffffffc0201ebc:	8efd                	and	a3,a3,a5
ffffffffc0201ebe:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201ec2:	0ce7f163          	bgeu	a5,a4,ffffffffc0201f84 <get_pte+0x16e>
ffffffffc0201ec6:	00033a97          	auipc	s5,0x33
ffffffffc0201eca:	e72a8a93          	addi	s5,s5,-398 # ffffffffc0234d38 <va_pa_offset>
ffffffffc0201ece:	000ab403          	ld	s0,0(s5)
ffffffffc0201ed2:	01595793          	srli	a5,s2,0x15
ffffffffc0201ed6:	1ff7f793          	andi	a5,a5,511
ffffffffc0201eda:	96a2                	add	a3,a3,s0
ffffffffc0201edc:	00379413          	slli	s0,a5,0x3
ffffffffc0201ee0:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V)) {
ffffffffc0201ee2:	6014                	ld	a3,0(s0)
ffffffffc0201ee4:	0016f793          	andi	a5,a3,1
ffffffffc0201ee8:	e3ad                	bnez	a5,ffffffffc0201f4a <get_pte+0x134>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201eea:	08098b63          	beqz	s3,ffffffffc0201f80 <get_pte+0x16a>
ffffffffc0201eee:	4505                	li	a0,1
ffffffffc0201ef0:	cc5ff0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0201ef4:	84aa                	mv	s1,a0
ffffffffc0201ef6:	c549                	beqz	a0,ffffffffc0201f80 <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201ef8:	00033b17          	auipc	s6,0x33
ffffffffc0201efc:	e30b0b13          	addi	s6,s6,-464 # ffffffffc0234d28 <pages>
ffffffffc0201f00:	000b3503          	ld	a0,0(s6)
ffffffffc0201f04:	000809b7          	lui	s3,0x80
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f08:	000a3703          	ld	a4,0(s4)
ffffffffc0201f0c:	40a48533          	sub	a0,s1,a0
ffffffffc0201f10:	8519                	srai	a0,a0,0x6
ffffffffc0201f12:	954e                	add	a0,a0,s3
ffffffffc0201f14:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201f18:	4685                	li	a3,1
ffffffffc0201f1a:	c094                	sw	a3,0(s1)
ffffffffc0201f1c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201f1e:	0532                	slli	a0,a0,0xc
ffffffffc0201f20:	08e7fa63          	bgeu	a5,a4,ffffffffc0201fb4 <get_pte+0x19e>
ffffffffc0201f24:	000ab783          	ld	a5,0(s5)
ffffffffc0201f28:	6605                	lui	a2,0x1
ffffffffc0201f2a:	4581                	li	a1,0
ffffffffc0201f2c:	953e                	add	a0,a0,a5
ffffffffc0201f2e:	639020ef          	jal	ra,ffffffffc0204d66 <memset>
    return page - pages + nbase;
ffffffffc0201f32:	000b3683          	ld	a3,0(s6)
ffffffffc0201f36:	40d486b3          	sub	a3,s1,a3
ffffffffc0201f3a:	8699                	srai	a3,a3,0x6
ffffffffc0201f3c:	96ce                	add	a3,a3,s3
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201f3e:	06aa                	slli	a3,a3,0xa
ffffffffc0201f40:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201f44:	e014                	sd	a3,0(s0)
        }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f46:	000a3703          	ld	a4,0(s4)
ffffffffc0201f4a:	068a                	slli	a3,a3,0x2
ffffffffc0201f4c:	757d                	lui	a0,0xfffff
ffffffffc0201f4e:	8ee9                	and	a3,a3,a0
ffffffffc0201f50:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201f54:	04e7f463          	bgeu	a5,a4,ffffffffc0201f9c <get_pte+0x186>
ffffffffc0201f58:	000ab503          	ld	a0,0(s5)
ffffffffc0201f5c:	00c95913          	srli	s2,s2,0xc
ffffffffc0201f60:	1ff97913          	andi	s2,s2,511
ffffffffc0201f64:	96aa                	add	a3,a3,a0
ffffffffc0201f66:	00391513          	slli	a0,s2,0x3
ffffffffc0201f6a:	9536                	add	a0,a0,a3
}
ffffffffc0201f6c:	70e2                	ld	ra,56(sp)
ffffffffc0201f6e:	7442                	ld	s0,48(sp)
ffffffffc0201f70:	74a2                	ld	s1,40(sp)
ffffffffc0201f72:	7902                	ld	s2,32(sp)
ffffffffc0201f74:	69e2                	ld	s3,24(sp)
ffffffffc0201f76:	6a42                	ld	s4,16(sp)
ffffffffc0201f78:	6aa2                	ld	s5,8(sp)
ffffffffc0201f7a:	6b02                	ld	s6,0(sp)
ffffffffc0201f7c:	6121                	addi	sp,sp,64
ffffffffc0201f7e:	8082                	ret
            return NULL;
ffffffffc0201f80:	4501                	li	a0,0
ffffffffc0201f82:	b7ed                	j	ffffffffc0201f6c <get_pte+0x156>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f84:	00004617          	auipc	a2,0x4
ffffffffc0201f88:	b8460613          	addi	a2,a2,-1148 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc0201f8c:	0fe00593          	li	a1,254
ffffffffc0201f90:	00004517          	auipc	a0,0x4
ffffffffc0201f94:	cb050513          	addi	a0,a0,-848 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0201f98:	cdefe0ef          	jal	ra,ffffffffc0200476 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f9c:	00004617          	auipc	a2,0x4
ffffffffc0201fa0:	b6c60613          	addi	a2,a2,-1172 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc0201fa4:	10900593          	li	a1,265
ffffffffc0201fa8:	00004517          	auipc	a0,0x4
ffffffffc0201fac:	c9850513          	addi	a0,a0,-872 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0201fb0:	cc6fe0ef          	jal	ra,ffffffffc0200476 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fb4:	86aa                	mv	a3,a0
ffffffffc0201fb6:	00004617          	auipc	a2,0x4
ffffffffc0201fba:	b5260613          	addi	a2,a2,-1198 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc0201fbe:	10600593          	li	a1,262
ffffffffc0201fc2:	00004517          	auipc	a0,0x4
ffffffffc0201fc6:	c7e50513          	addi	a0,a0,-898 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0201fca:	cacfe0ef          	jal	ra,ffffffffc0200476 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fce:	86aa                	mv	a3,a0
ffffffffc0201fd0:	00004617          	auipc	a2,0x4
ffffffffc0201fd4:	b3860613          	addi	a2,a2,-1224 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc0201fd8:	0fa00593          	li	a1,250
ffffffffc0201fdc:	00004517          	auipc	a0,0x4
ffffffffc0201fe0:	c6450513          	addi	a0,a0,-924 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0201fe4:	c92fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0201fe8 <unmap_range>:
        *ptep = 0;                  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0201fe8:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0201fea:	00c5e7b3          	or	a5,a1,a2
void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0201fee:	f486                	sd	ra,104(sp)
ffffffffc0201ff0:	f0a2                	sd	s0,96(sp)
ffffffffc0201ff2:	eca6                	sd	s1,88(sp)
ffffffffc0201ff4:	e8ca                	sd	s2,80(sp)
ffffffffc0201ff6:	e4ce                	sd	s3,72(sp)
ffffffffc0201ff8:	e0d2                	sd	s4,64(sp)
ffffffffc0201ffa:	fc56                	sd	s5,56(sp)
ffffffffc0201ffc:	f85a                	sd	s6,48(sp)
ffffffffc0201ffe:	f45e                	sd	s7,40(sp)
ffffffffc0202000:	f062                	sd	s8,32(sp)
ffffffffc0202002:	ec66                	sd	s9,24(sp)
ffffffffc0202004:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202006:	17d2                	slli	a5,a5,0x34
ffffffffc0202008:	e3ed                	bnez	a5,ffffffffc02020ea <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020200a:	002007b7          	lui	a5,0x200
ffffffffc020200e:	842e                	mv	s0,a1
ffffffffc0202010:	0ef5ed63          	bltu	a1,a5,ffffffffc020210a <unmap_range+0x122>
ffffffffc0202014:	8932                	mv	s2,a2
ffffffffc0202016:	0ec5fa63          	bgeu	a1,a2,ffffffffc020210a <unmap_range+0x122>
ffffffffc020201a:	4785                	li	a5,1
ffffffffc020201c:	07fe                	slli	a5,a5,0x1f
ffffffffc020201e:	0ec7e663          	bltu	a5,a2,ffffffffc020210a <unmap_range+0x122>
ffffffffc0202022:	89aa                	mv	s3,a0
            continue;
        }
        if (*ptep != 0) {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202024:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202026:	00033c97          	auipc	s9,0x33
ffffffffc020202a:	cfac8c93          	addi	s9,s9,-774 # ffffffffc0234d20 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020202e:	00033c17          	auipc	s8,0x33
ffffffffc0202032:	cfac0c13          	addi	s8,s8,-774 # ffffffffc0234d28 <pages>
ffffffffc0202036:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020203a:	00033d17          	auipc	s10,0x33
ffffffffc020203e:	cf6d0d13          	addi	s10,s10,-778 # ffffffffc0234d30 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202042:	00200b37          	lui	s6,0x200
ffffffffc0202046:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020204a:	4601                	li	a2,0
ffffffffc020204c:	85a2                	mv	a1,s0
ffffffffc020204e:	854e                	mv	a0,s3
ffffffffc0202050:	dc7ff0ef          	jal	ra,ffffffffc0201e16 <get_pte>
ffffffffc0202054:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc0202056:	cd29                	beqz	a0,ffffffffc02020b0 <unmap_range+0xc8>
        if (*ptep != 0) {
ffffffffc0202058:	611c                	ld	a5,0(a0)
ffffffffc020205a:	e395                	bnez	a5,ffffffffc020207e <unmap_range+0x96>
        start += PGSIZE;
ffffffffc020205c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020205e:	ff2466e3          	bltu	s0,s2,ffffffffc020204a <unmap_range+0x62>
}
ffffffffc0202062:	70a6                	ld	ra,104(sp)
ffffffffc0202064:	7406                	ld	s0,96(sp)
ffffffffc0202066:	64e6                	ld	s1,88(sp)
ffffffffc0202068:	6946                	ld	s2,80(sp)
ffffffffc020206a:	69a6                	ld	s3,72(sp)
ffffffffc020206c:	6a06                	ld	s4,64(sp)
ffffffffc020206e:	7ae2                	ld	s5,56(sp)
ffffffffc0202070:	7b42                	ld	s6,48(sp)
ffffffffc0202072:	7ba2                	ld	s7,40(sp)
ffffffffc0202074:	7c02                	ld	s8,32(sp)
ffffffffc0202076:	6ce2                	ld	s9,24(sp)
ffffffffc0202078:	6d42                	ld	s10,16(sp)
ffffffffc020207a:	6165                	addi	sp,sp,112
ffffffffc020207c:	8082                	ret
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc020207e:	0017f713          	andi	a4,a5,1
ffffffffc0202082:	df69                	beqz	a4,ffffffffc020205c <unmap_range+0x74>
    if (PPN(pa) >= npage) {
ffffffffc0202084:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202088:	078a                	slli	a5,a5,0x2
ffffffffc020208a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020208c:	08e7ff63          	bgeu	a5,a4,ffffffffc020212a <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202090:	000c3503          	ld	a0,0(s8)
ffffffffc0202094:	97de                	add	a5,a5,s7
ffffffffc0202096:	079a                	slli	a5,a5,0x6
ffffffffc0202098:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020209a:	411c                	lw	a5,0(a0)
ffffffffc020209c:	fff7871b          	addiw	a4,a5,-1
ffffffffc02020a0:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc02020a2:	cf11                	beqz	a4,ffffffffc02020be <unmap_range+0xd6>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc02020a4:	0004b023          	sd	zero,0(s1)
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020a8:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02020ac:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02020ae:	bf45                	j	ffffffffc020205e <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02020b0:	945a                	add	s0,s0,s6
ffffffffc02020b2:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02020b6:	d455                	beqz	s0,ffffffffc0202062 <unmap_range+0x7a>
ffffffffc02020b8:	f92469e3          	bltu	s0,s2,ffffffffc020204a <unmap_range+0x62>
ffffffffc02020bc:	b75d                	j	ffffffffc0202062 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02020be:	100027f3          	csrr	a5,sstatus
ffffffffc02020c2:	8b89                	andi	a5,a5,2
ffffffffc02020c4:	e799                	bnez	a5,ffffffffc02020d2 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02020c6:	000d3783          	ld	a5,0(s10)
ffffffffc02020ca:	4585                	li	a1,1
ffffffffc02020cc:	739c                	ld	a5,32(a5)
ffffffffc02020ce:	9782                	jalr	a5
    if (flag) {
ffffffffc02020d0:	bfd1                	j	ffffffffc02020a4 <unmap_range+0xbc>
ffffffffc02020d2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02020d4:	d64fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
ffffffffc02020d8:	000d3783          	ld	a5,0(s10)
ffffffffc02020dc:	6522                	ld	a0,8(sp)
ffffffffc02020de:	4585                	li	a1,1
ffffffffc02020e0:	739c                	ld	a5,32(a5)
ffffffffc02020e2:	9782                	jalr	a5
        intr_enable();
ffffffffc02020e4:	d4efe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc02020e8:	bf75                	j	ffffffffc02020a4 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020ea:	00004697          	auipc	a3,0x4
ffffffffc02020ee:	b6668693          	addi	a3,a3,-1178 # ffffffffc0205c50 <default_pmm_manager+0x180>
ffffffffc02020f2:	00003617          	auipc	a2,0x3
ffffffffc02020f6:	34660613          	addi	a2,a2,838 # ffffffffc0205438 <commands+0x448>
ffffffffc02020fa:	14000593          	li	a1,320
ffffffffc02020fe:	00004517          	auipc	a0,0x4
ffffffffc0202102:	b4250513          	addi	a0,a0,-1214 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202106:	b70fe0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020210a:	00004697          	auipc	a3,0x4
ffffffffc020210e:	b7668693          	addi	a3,a3,-1162 # ffffffffc0205c80 <default_pmm_manager+0x1b0>
ffffffffc0202112:	00003617          	auipc	a2,0x3
ffffffffc0202116:	32660613          	addi	a2,a2,806 # ffffffffc0205438 <commands+0x448>
ffffffffc020211a:	14100593          	li	a1,321
ffffffffc020211e:	00004517          	auipc	a0,0x4
ffffffffc0202122:	b2250513          	addi	a0,a0,-1246 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202126:	b50fe0ef          	jal	ra,ffffffffc0200476 <__panic>
ffffffffc020212a:	a6fff0ef          	jal	ra,ffffffffc0201b98 <pa2page.part.0>

ffffffffc020212e <exit_range>:
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc020212e:	711d                	addi	sp,sp,-96
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202130:	00c5e7b3          	or	a5,a1,a2
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0202134:	ec86                	sd	ra,88(sp)
ffffffffc0202136:	e8a2                	sd	s0,80(sp)
ffffffffc0202138:	e4a6                	sd	s1,72(sp)
ffffffffc020213a:	e0ca                	sd	s2,64(sp)
ffffffffc020213c:	fc4e                	sd	s3,56(sp)
ffffffffc020213e:	f852                	sd	s4,48(sp)
ffffffffc0202140:	f456                	sd	s5,40(sp)
ffffffffc0202142:	f05a                	sd	s6,32(sp)
ffffffffc0202144:	ec5e                	sd	s7,24(sp)
ffffffffc0202146:	e862                	sd	s8,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202148:	17d2                	slli	a5,a5,0x34
ffffffffc020214a:	e3e9                	bnez	a5,ffffffffc020220c <exit_range+0xde>
    assert(USER_ACCESS(start, end));
ffffffffc020214c:	002007b7          	lui	a5,0x200
ffffffffc0202150:	0ef5ea63          	bltu	a1,a5,ffffffffc0202244 <exit_range+0x116>
ffffffffc0202154:	8ab2                	mv	s5,a2
ffffffffc0202156:	0ec5f763          	bgeu	a1,a2,ffffffffc0202244 <exit_range+0x116>
ffffffffc020215a:	4785                	li	a5,1
    start = ROUNDDOWN(start, PTSIZE);
ffffffffc020215c:	ffe004b7          	lui	s1,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc0202160:	07fe                	slli	a5,a5,0x1f
    start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202162:	8ced                	and	s1,s1,a1
    assert(USER_ACCESS(start, end));
ffffffffc0202164:	0ec7e063          	bltu	a5,a2,ffffffffc0202244 <exit_range+0x116>
ffffffffc0202168:	8b2a                	mv	s6,a0
    if (PPN(pa) >= npage) {
ffffffffc020216a:	00033b97          	auipc	s7,0x33
ffffffffc020216e:	bb6b8b93          	addi	s7,s7,-1098 # ffffffffc0234d20 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202172:	00033c17          	auipc	s8,0x33
ffffffffc0202176:	bb6c0c13          	addi	s8,s8,-1098 # ffffffffc0234d28 <pages>
ffffffffc020217a:	fff809b7          	lui	s3,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020217e:	00033917          	auipc	s2,0x33
ffffffffc0202182:	bb290913          	addi	s2,s2,-1102 # ffffffffc0234d30 <pmm_manager>
        start += PTSIZE;
ffffffffc0202186:	00200a37          	lui	s4,0x200
ffffffffc020218a:	a029                	j	ffffffffc0202194 <exit_range+0x66>
ffffffffc020218c:	94d2                	add	s1,s1,s4
    } while (start != 0 && start < end);
ffffffffc020218e:	c4a9                	beqz	s1,ffffffffc02021d8 <exit_range+0xaa>
ffffffffc0202190:	0554f463          	bgeu	s1,s5,ffffffffc02021d8 <exit_range+0xaa>
        int pde_idx = PDX1(start);
ffffffffc0202194:	01e4d413          	srli	s0,s1,0x1e
        if (pgdir[pde_idx] & PTE_V) {
ffffffffc0202198:	1ff47413          	andi	s0,s0,511
ffffffffc020219c:	040e                	slli	s0,s0,0x3
ffffffffc020219e:	945a                	add	s0,s0,s6
ffffffffc02021a0:	601c                	ld	a5,0(s0)
ffffffffc02021a2:	0017f713          	andi	a4,a5,1
ffffffffc02021a6:	d37d                	beqz	a4,ffffffffc020218c <exit_range+0x5e>
    if (PPN(pa) >= npage) {
ffffffffc02021a8:	000bb703          	ld	a4,0(s7)
    return pa2page(PDE_ADDR(pde));
ffffffffc02021ac:	078a                	slli	a5,a5,0x2
ffffffffc02021ae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02021b0:	06e7fe63          	bgeu	a5,a4,ffffffffc020222c <exit_range+0xfe>
    return &pages[PPN(pa) - nbase];
ffffffffc02021b4:	000c3503          	ld	a0,0(s8)
ffffffffc02021b8:	97ce                	add	a5,a5,s3
ffffffffc02021ba:	079a                	slli	a5,a5,0x6
ffffffffc02021bc:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02021be:	100027f3          	csrr	a5,sstatus
ffffffffc02021c2:	8b89                	andi	a5,a5,2
ffffffffc02021c4:	e795                	bnez	a5,ffffffffc02021f0 <exit_range+0xc2>
        pmm_manager->free_pages(base, n);
ffffffffc02021c6:	00093783          	ld	a5,0(s2)
ffffffffc02021ca:	4585                	li	a1,1
ffffffffc02021cc:	739c                	ld	a5,32(a5)
ffffffffc02021ce:	9782                	jalr	a5
            pgdir[pde_idx] = 0;
ffffffffc02021d0:	00043023          	sd	zero,0(s0)
        start += PTSIZE;
ffffffffc02021d4:	94d2                	add	s1,s1,s4
    } while (start != 0 && start < end);
ffffffffc02021d6:	fccd                	bnez	s1,ffffffffc0202190 <exit_range+0x62>
}
ffffffffc02021d8:	60e6                	ld	ra,88(sp)
ffffffffc02021da:	6446                	ld	s0,80(sp)
ffffffffc02021dc:	64a6                	ld	s1,72(sp)
ffffffffc02021de:	6906                	ld	s2,64(sp)
ffffffffc02021e0:	79e2                	ld	s3,56(sp)
ffffffffc02021e2:	7a42                	ld	s4,48(sp)
ffffffffc02021e4:	7aa2                	ld	s5,40(sp)
ffffffffc02021e6:	7b02                	ld	s6,32(sp)
ffffffffc02021e8:	6be2                	ld	s7,24(sp)
ffffffffc02021ea:	6c42                	ld	s8,16(sp)
ffffffffc02021ec:	6125                	addi	sp,sp,96
ffffffffc02021ee:	8082                	ret
ffffffffc02021f0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02021f2:	c46fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02021f6:	00093783          	ld	a5,0(s2)
ffffffffc02021fa:	6522                	ld	a0,8(sp)
ffffffffc02021fc:	4585                	li	a1,1
ffffffffc02021fe:	739c                	ld	a5,32(a5)
ffffffffc0202200:	9782                	jalr	a5
        intr_enable();
ffffffffc0202202:	c30fe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
            pgdir[pde_idx] = 0;
ffffffffc0202206:	00043023          	sd	zero,0(s0)
ffffffffc020220a:	b7e9                	j	ffffffffc02021d4 <exit_range+0xa6>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020220c:	00004697          	auipc	a3,0x4
ffffffffc0202210:	a4468693          	addi	a3,a3,-1468 # ffffffffc0205c50 <default_pmm_manager+0x180>
ffffffffc0202214:	00003617          	auipc	a2,0x3
ffffffffc0202218:	22460613          	addi	a2,a2,548 # ffffffffc0205438 <commands+0x448>
ffffffffc020221c:	15100593          	li	a1,337
ffffffffc0202220:	00004517          	auipc	a0,0x4
ffffffffc0202224:	a2050513          	addi	a0,a0,-1504 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202228:	a4efe0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020222c:	00004617          	auipc	a2,0x4
ffffffffc0202230:	97460613          	addi	a2,a2,-1676 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc0202234:	06200593          	li	a1,98
ffffffffc0202238:	00004517          	auipc	a0,0x4
ffffffffc020223c:	8f850513          	addi	a0,a0,-1800 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0202240:	a36fe0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202244:	00004697          	auipc	a3,0x4
ffffffffc0202248:	a3c68693          	addi	a3,a3,-1476 # ffffffffc0205c80 <default_pmm_manager+0x1b0>
ffffffffc020224c:	00003617          	auipc	a2,0x3
ffffffffc0202250:	1ec60613          	addi	a2,a2,492 # ffffffffc0205438 <commands+0x448>
ffffffffc0202254:	15200593          	li	a1,338
ffffffffc0202258:	00004517          	auipc	a0,0x4
ffffffffc020225c:	9e850513          	addi	a0,a0,-1560 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202260:	a16fe0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202264 <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202264:	7139                	addi	sp,sp,-64
ffffffffc0202266:	e852                	sd	s4,16(sp)
ffffffffc0202268:	8a32                	mv	s4,a2
ffffffffc020226a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020226c:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc020226e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202270:	85d2                	mv	a1,s4
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202272:	f426                	sd	s1,40(sp)
ffffffffc0202274:	fc06                	sd	ra,56(sp)
ffffffffc0202276:	f04a                	sd	s2,32(sp)
ffffffffc0202278:	ec4e                	sd	s3,24(sp)
ffffffffc020227a:	e456                	sd	s5,8(sp)
ffffffffc020227c:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020227e:	b99ff0ef          	jal	ra,ffffffffc0201e16 <get_pte>
    if (ptep == NULL) {
ffffffffc0202282:	c961                	beqz	a0,ffffffffc0202352 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202284:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc0202286:	611c                	ld	a5,0(a0)
ffffffffc0202288:	89aa                	mv	s3,a0
ffffffffc020228a:	0016871b          	addiw	a4,a3,1
ffffffffc020228e:	c018                	sw	a4,0(s0)
ffffffffc0202290:	0017f713          	andi	a4,a5,1
ffffffffc0202294:	ef05                	bnez	a4,ffffffffc02022cc <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202296:	00033717          	auipc	a4,0x33
ffffffffc020229a:	a9273703          	ld	a4,-1390(a4) # ffffffffc0234d28 <pages>
ffffffffc020229e:	8c19                	sub	s0,s0,a4
ffffffffc02022a0:	000807b7          	lui	a5,0x80
ffffffffc02022a4:	8419                	srai	s0,s0,0x6
ffffffffc02022a6:	943e                	add	s0,s0,a5
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02022a8:	042a                	slli	s0,s0,0xa
ffffffffc02022aa:	8cc1                	or	s1,s1,s0
ffffffffc02022ac:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02022b0:	0099b023          	sd	s1,0(s3) # fffffffffff80000 <end+0x3fd4b268>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022b4:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02022b8:	4501                	li	a0,0
}
ffffffffc02022ba:	70e2                	ld	ra,56(sp)
ffffffffc02022bc:	7442                	ld	s0,48(sp)
ffffffffc02022be:	74a2                	ld	s1,40(sp)
ffffffffc02022c0:	7902                	ld	s2,32(sp)
ffffffffc02022c2:	69e2                	ld	s3,24(sp)
ffffffffc02022c4:	6a42                	ld	s4,16(sp)
ffffffffc02022c6:	6aa2                	ld	s5,8(sp)
ffffffffc02022c8:	6121                	addi	sp,sp,64
ffffffffc02022ca:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02022cc:	078a                	slli	a5,a5,0x2
ffffffffc02022ce:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02022d0:	00033717          	auipc	a4,0x33
ffffffffc02022d4:	a5073703          	ld	a4,-1456(a4) # ffffffffc0234d20 <npage>
ffffffffc02022d8:	06e7ff63          	bgeu	a5,a4,ffffffffc0202356 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02022dc:	00033a97          	auipc	s5,0x33
ffffffffc02022e0:	a4ca8a93          	addi	s5,s5,-1460 # ffffffffc0234d28 <pages>
ffffffffc02022e4:	000ab703          	ld	a4,0(s5)
ffffffffc02022e8:	fff80937          	lui	s2,0xfff80
ffffffffc02022ec:	993e                	add	s2,s2,a5
ffffffffc02022ee:	091a                	slli	s2,s2,0x6
ffffffffc02022f0:	993a                	add	s2,s2,a4
        if (p == page) {
ffffffffc02022f2:	01240c63          	beq	s0,s2,ffffffffc020230a <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02022f6:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd4b268>
ffffffffc02022fa:	fff7869b          	addiw	a3,a5,-1
ffffffffc02022fe:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0202302:	c691                	beqz	a3,ffffffffc020230e <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202304:	120a0073          	sfence.vma	s4
}
ffffffffc0202308:	bf59                	j	ffffffffc020229e <page_insert+0x3a>
ffffffffc020230a:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc020230c:	bf49                	j	ffffffffc020229e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020230e:	100027f3          	csrr	a5,sstatus
ffffffffc0202312:	8b89                	andi	a5,a5,2
ffffffffc0202314:	ef91                	bnez	a5,ffffffffc0202330 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202316:	00033797          	auipc	a5,0x33
ffffffffc020231a:	a1a7b783          	ld	a5,-1510(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc020231e:	739c                	ld	a5,32(a5)
ffffffffc0202320:	4585                	li	a1,1
ffffffffc0202322:	854a                	mv	a0,s2
ffffffffc0202324:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202326:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020232a:	120a0073          	sfence.vma	s4
ffffffffc020232e:	bf85                	j	ffffffffc020229e <page_insert+0x3a>
        intr_disable();
ffffffffc0202330:	b08fe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202334:	00033797          	auipc	a5,0x33
ffffffffc0202338:	9fc7b783          	ld	a5,-1540(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc020233c:	739c                	ld	a5,32(a5)
ffffffffc020233e:	4585                	li	a1,1
ffffffffc0202340:	854a                	mv	a0,s2
ffffffffc0202342:	9782                	jalr	a5
        intr_enable();
ffffffffc0202344:	aeefe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc0202348:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020234c:	120a0073          	sfence.vma	s4
ffffffffc0202350:	b7b9                	j	ffffffffc020229e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202352:	5571                	li	a0,-4
ffffffffc0202354:	b79d                	j	ffffffffc02022ba <page_insert+0x56>
ffffffffc0202356:	843ff0ef          	jal	ra,ffffffffc0201b98 <pa2page.part.0>

ffffffffc020235a <copy_range>:
               bool share) {
ffffffffc020235a:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020235c:	00d667b3          	or	a5,a2,a3
               bool share) {
ffffffffc0202360:	f486                	sd	ra,104(sp)
ffffffffc0202362:	f0a2                	sd	s0,96(sp)
ffffffffc0202364:	eca6                	sd	s1,88(sp)
ffffffffc0202366:	e8ca                	sd	s2,80(sp)
ffffffffc0202368:	e4ce                	sd	s3,72(sp)
ffffffffc020236a:	e0d2                	sd	s4,64(sp)
ffffffffc020236c:	fc56                	sd	s5,56(sp)
ffffffffc020236e:	f85a                	sd	s6,48(sp)
ffffffffc0202370:	f45e                	sd	s7,40(sp)
ffffffffc0202372:	f062                	sd	s8,32(sp)
ffffffffc0202374:	ec66                	sd	s9,24(sp)
ffffffffc0202376:	e86a                	sd	s10,16(sp)
ffffffffc0202378:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020237a:	17d2                	slli	a5,a5,0x34
ffffffffc020237c:	1e079763          	bnez	a5,ffffffffc020256a <copy_range+0x210>
    assert(USER_ACCESS(start, end));
ffffffffc0202380:	002007b7          	lui	a5,0x200
ffffffffc0202384:	8432                	mv	s0,a2
ffffffffc0202386:	16f66a63          	bltu	a2,a5,ffffffffc02024fa <copy_range+0x1a0>
ffffffffc020238a:	8936                	mv	s2,a3
ffffffffc020238c:	16d67763          	bgeu	a2,a3,ffffffffc02024fa <copy_range+0x1a0>
ffffffffc0202390:	4785                	li	a5,1
ffffffffc0202392:	07fe                	slli	a5,a5,0x1f
ffffffffc0202394:	16d7e363          	bltu	a5,a3,ffffffffc02024fa <copy_range+0x1a0>
    return KADDR(page2pa(page));
ffffffffc0202398:	5b7d                	li	s6,-1
ffffffffc020239a:	8aaa                	mv	s5,a0
ffffffffc020239c:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc020239e:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage) {
ffffffffc02023a0:	00033c97          	auipc	s9,0x33
ffffffffc02023a4:	980c8c93          	addi	s9,s9,-1664 # ffffffffc0234d20 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02023a8:	00033c17          	auipc	s8,0x33
ffffffffc02023ac:	980c0c13          	addi	s8,s8,-1664 # ffffffffc0234d28 <pages>
    return page - pages + nbase;
ffffffffc02023b0:	00080bb7          	lui	s7,0x80
    return KADDR(page2pa(page));
ffffffffc02023b4:	00cb5b13          	srli	s6,s6,0xc
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02023b8:	4601                	li	a2,0
ffffffffc02023ba:	85a2                	mv	a1,s0
ffffffffc02023bc:	854e                	mv	a0,s3
ffffffffc02023be:	a59ff0ef          	jal	ra,ffffffffc0201e16 <get_pte>
ffffffffc02023c2:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc02023c4:	c175                	beqz	a0,ffffffffc02024a8 <copy_range+0x14e>
        if (*ptep & PTE_V) {
ffffffffc02023c6:	611c                	ld	a5,0(a0)
ffffffffc02023c8:	8b85                	andi	a5,a5,1
ffffffffc02023ca:	e785                	bnez	a5,ffffffffc02023f2 <copy_range+0x98>
        start += PGSIZE;
ffffffffc02023cc:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02023ce:	ff2465e3          	bltu	s0,s2,ffffffffc02023b8 <copy_range+0x5e>
    return 0;
ffffffffc02023d2:	4501                	li	a0,0
}
ffffffffc02023d4:	70a6                	ld	ra,104(sp)
ffffffffc02023d6:	7406                	ld	s0,96(sp)
ffffffffc02023d8:	64e6                	ld	s1,88(sp)
ffffffffc02023da:	6946                	ld	s2,80(sp)
ffffffffc02023dc:	69a6                	ld	s3,72(sp)
ffffffffc02023de:	6a06                	ld	s4,64(sp)
ffffffffc02023e0:	7ae2                	ld	s5,56(sp)
ffffffffc02023e2:	7b42                	ld	s6,48(sp)
ffffffffc02023e4:	7ba2                	ld	s7,40(sp)
ffffffffc02023e6:	7c02                	ld	s8,32(sp)
ffffffffc02023e8:	6ce2                	ld	s9,24(sp)
ffffffffc02023ea:	6d42                	ld	s10,16(sp)
ffffffffc02023ec:	6da2                	ld	s11,8(sp)
ffffffffc02023ee:	6165                	addi	sp,sp,112
ffffffffc02023f0:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL) {
ffffffffc02023f2:	4605                	li	a2,1
ffffffffc02023f4:	85a2                	mv	a1,s0
ffffffffc02023f6:	8556                	mv	a0,s5
ffffffffc02023f8:	a1fff0ef          	jal	ra,ffffffffc0201e16 <get_pte>
ffffffffc02023fc:	c161                	beqz	a0,ffffffffc02024bc <copy_range+0x162>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02023fe:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V)) {
ffffffffc0202400:	0017f713          	andi	a4,a5,1
ffffffffc0202404:	01f7f493          	andi	s1,a5,31
ffffffffc0202408:	14070563          	beqz	a4,ffffffffc0202552 <copy_range+0x1f8>
    if (PPN(pa) >= npage) {
ffffffffc020240c:	000cb683          	ld	a3,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202410:	078a                	slli	a5,a5,0x2
ffffffffc0202412:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202416:	12d77263          	bgeu	a4,a3,ffffffffc020253a <copy_range+0x1e0>
    return &pages[PPN(pa) - nbase];
ffffffffc020241a:	000c3783          	ld	a5,0(s8)
ffffffffc020241e:	fff806b7          	lui	a3,0xfff80
ffffffffc0202422:	9736                	add	a4,a4,a3
ffffffffc0202424:	071a                	slli	a4,a4,0x6
            struct Page *npage = alloc_page();
ffffffffc0202426:	4505                	li	a0,1
ffffffffc0202428:	00e78db3          	add	s11,a5,a4
ffffffffc020242c:	f88ff0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0202430:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc0202432:	0a0d8463          	beqz	s11,ffffffffc02024da <copy_range+0x180>
            assert(npage != NULL);
ffffffffc0202436:	c175                	beqz	a0,ffffffffc020251a <copy_range+0x1c0>
    return page - pages + nbase;
ffffffffc0202438:	000c3703          	ld	a4,0(s8)
    return KADDR(page2pa(page));
ffffffffc020243c:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0202440:	40ed86b3          	sub	a3,s11,a4
ffffffffc0202444:	8699                	srai	a3,a3,0x6
ffffffffc0202446:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc0202448:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020244c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020244e:	06c7fa63          	bgeu	a5,a2,ffffffffc02024c2 <copy_range+0x168>
    return page - pages + nbase;
ffffffffc0202452:	40e507b3          	sub	a5,a0,a4
    return KADDR(page2pa(page));
ffffffffc0202456:	00033717          	auipc	a4,0x33
ffffffffc020245a:	8e270713          	addi	a4,a4,-1822 # ffffffffc0234d38 <va_pa_offset>
ffffffffc020245e:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0202460:	8799                	srai	a5,a5,0x6
ffffffffc0202462:	97de                	add	a5,a5,s7
    return KADDR(page2pa(page));
ffffffffc0202464:	0167f733          	and	a4,a5,s6
ffffffffc0202468:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020246c:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020246e:	04c77963          	bgeu	a4,a2,ffffffffc02024c0 <copy_range+0x166>
            memcpy(kva_dst, kva_src, PGSIZE);
ffffffffc0202472:	6605                	lui	a2,0x1
ffffffffc0202474:	953e                	add	a0,a0,a5
ffffffffc0202476:	103020ef          	jal	ra,ffffffffc0204d78 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc020247a:	86a6                	mv	a3,s1
ffffffffc020247c:	8622                	mv	a2,s0
ffffffffc020247e:	85ea                	mv	a1,s10
ffffffffc0202480:	8556                	mv	a0,s5
ffffffffc0202482:	de3ff0ef          	jal	ra,ffffffffc0202264 <page_insert>
            assert(ret == 0);
ffffffffc0202486:	d139                	beqz	a0,ffffffffc02023cc <copy_range+0x72>
ffffffffc0202488:	00004697          	auipc	a3,0x4
ffffffffc020248c:	83068693          	addi	a3,a3,-2000 # ffffffffc0205cb8 <default_pmm_manager+0x1e8>
ffffffffc0202490:	00003617          	auipc	a2,0x3
ffffffffc0202494:	fa860613          	addi	a2,a2,-88 # ffffffffc0205438 <commands+0x448>
ffffffffc0202498:	19900593          	li	a1,409
ffffffffc020249c:	00003517          	auipc	a0,0x3
ffffffffc02024a0:	7a450513          	addi	a0,a0,1956 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc02024a4:	fd3fd0ef          	jal	ra,ffffffffc0200476 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02024a8:	00200637          	lui	a2,0x200
ffffffffc02024ac:	9432                	add	s0,s0,a2
ffffffffc02024ae:	ffe00637          	lui	a2,0xffe00
ffffffffc02024b2:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc02024b4:	dc19                	beqz	s0,ffffffffc02023d2 <copy_range+0x78>
ffffffffc02024b6:	f12461e3          	bltu	s0,s2,ffffffffc02023b8 <copy_range+0x5e>
ffffffffc02024ba:	bf21                	j	ffffffffc02023d2 <copy_range+0x78>
                return -E_NO_MEM;
ffffffffc02024bc:	5571                	li	a0,-4
ffffffffc02024be:	bf19                	j	ffffffffc02023d4 <copy_range+0x7a>
ffffffffc02024c0:	86be                	mv	a3,a5
ffffffffc02024c2:	00003617          	auipc	a2,0x3
ffffffffc02024c6:	64660613          	addi	a2,a2,1606 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc02024ca:	06900593          	li	a1,105
ffffffffc02024ce:	00003517          	auipc	a0,0x3
ffffffffc02024d2:	66250513          	addi	a0,a0,1634 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc02024d6:	fa1fd0ef          	jal	ra,ffffffffc0200476 <__panic>
            assert(page != NULL);
ffffffffc02024da:	00003697          	auipc	a3,0x3
ffffffffc02024de:	7be68693          	addi	a3,a3,1982 # ffffffffc0205c98 <default_pmm_manager+0x1c8>
ffffffffc02024e2:	00003617          	auipc	a2,0x3
ffffffffc02024e6:	f5660613          	addi	a2,a2,-170 # ffffffffc0205438 <commands+0x448>
ffffffffc02024ea:	17e00593          	li	a1,382
ffffffffc02024ee:	00003517          	auipc	a0,0x3
ffffffffc02024f2:	75250513          	addi	a0,a0,1874 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc02024f6:	f81fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02024fa:	00003697          	auipc	a3,0x3
ffffffffc02024fe:	78668693          	addi	a3,a3,1926 # ffffffffc0205c80 <default_pmm_manager+0x1b0>
ffffffffc0202502:	00003617          	auipc	a2,0x3
ffffffffc0202506:	f3660613          	addi	a2,a2,-202 # ffffffffc0205438 <commands+0x448>
ffffffffc020250a:	16a00593          	li	a1,362
ffffffffc020250e:	00003517          	auipc	a0,0x3
ffffffffc0202512:	73250513          	addi	a0,a0,1842 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202516:	f61fd0ef          	jal	ra,ffffffffc0200476 <__panic>
            assert(npage != NULL);
ffffffffc020251a:	00003697          	auipc	a3,0x3
ffffffffc020251e:	78e68693          	addi	a3,a3,1934 # ffffffffc0205ca8 <default_pmm_manager+0x1d8>
ffffffffc0202522:	00003617          	auipc	a2,0x3
ffffffffc0202526:	f1660613          	addi	a2,a2,-234 # ffffffffc0205438 <commands+0x448>
ffffffffc020252a:	17f00593          	li	a1,383
ffffffffc020252e:	00003517          	auipc	a0,0x3
ffffffffc0202532:	71250513          	addi	a0,a0,1810 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202536:	f41fd0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020253a:	00003617          	auipc	a2,0x3
ffffffffc020253e:	66660613          	addi	a2,a2,1638 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc0202542:	06200593          	li	a1,98
ffffffffc0202546:	00003517          	auipc	a0,0x3
ffffffffc020254a:	5ea50513          	addi	a0,a0,1514 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc020254e:	f29fd0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0202552:	00003617          	auipc	a2,0x3
ffffffffc0202556:	66e60613          	addi	a2,a2,1646 # ffffffffc0205bc0 <default_pmm_manager+0xf0>
ffffffffc020255a:	07400593          	li	a1,116
ffffffffc020255e:	00003517          	auipc	a0,0x3
ffffffffc0202562:	5d250513          	addi	a0,a0,1490 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0202566:	f11fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020256a:	00003697          	auipc	a3,0x3
ffffffffc020256e:	6e668693          	addi	a3,a3,1766 # ffffffffc0205c50 <default_pmm_manager+0x180>
ffffffffc0202572:	00003617          	auipc	a2,0x3
ffffffffc0202576:	ec660613          	addi	a2,a2,-314 # ffffffffc0205438 <commands+0x448>
ffffffffc020257a:	16900593          	li	a1,361
ffffffffc020257e:	00003517          	auipc	a0,0x3
ffffffffc0202582:	6c250513          	addi	a0,a0,1730 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202586:	ef1fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc020258a <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020258a:	12058073          	sfence.vma	a1
}
ffffffffc020258e:	8082                	ret

ffffffffc0202590 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202590:	7179                	addi	sp,sp,-48
ffffffffc0202592:	e84a                	sd	s2,16(sp)
ffffffffc0202594:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0202596:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202598:	f022                	sd	s0,32(sp)
ffffffffc020259a:	ec26                	sd	s1,24(sp)
ffffffffc020259c:	e44e                	sd	s3,8(sp)
ffffffffc020259e:	f406                	sd	ra,40(sp)
ffffffffc02025a0:	84ae                	mv	s1,a1
ffffffffc02025a2:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc02025a4:	e10ff0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc02025a8:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc02025aa:	cd05                	beqz	a0,ffffffffc02025e2 <pgdir_alloc_page+0x52>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc02025ac:	85aa                	mv	a1,a0
ffffffffc02025ae:	86ce                	mv	a3,s3
ffffffffc02025b0:	8626                	mv	a2,s1
ffffffffc02025b2:	854a                	mv	a0,s2
ffffffffc02025b4:	cb1ff0ef          	jal	ra,ffffffffc0202264 <page_insert>
ffffffffc02025b8:	ed0d                	bnez	a0,ffffffffc02025f2 <pgdir_alloc_page+0x62>
            free_page(page);
            return NULL;
        }
        if (swap_init_ok) {
ffffffffc02025ba:	00032797          	auipc	a5,0x32
ffffffffc02025be:	7967a783          	lw	a5,1942(a5) # ffffffffc0234d50 <swap_init_ok>
ffffffffc02025c2:	c385                	beqz	a5,ffffffffc02025e2 <pgdir_alloc_page+0x52>
            if (check_mm_struct != NULL) {
ffffffffc02025c4:	00032517          	auipc	a0,0x32
ffffffffc02025c8:	79453503          	ld	a0,1940(a0) # ffffffffc0234d58 <check_mm_struct>
ffffffffc02025cc:	c919                	beqz	a0,ffffffffc02025e2 <pgdir_alloc_page+0x52>
                swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc02025ce:	4681                	li	a3,0
ffffffffc02025d0:	8622                	mv	a2,s0
ffffffffc02025d2:	85a6                	mv	a1,s1
ffffffffc02025d4:	108000ef          	jal	ra,ffffffffc02026dc <swap_map_swappable>
                page->pra_vaddr = la;
                assert(page_ref(page) == 1);
ffffffffc02025d8:	4018                	lw	a4,0(s0)
                page->pra_vaddr = la;
ffffffffc02025da:	fc04                	sd	s1,56(s0)
                assert(page_ref(page) == 1);
ffffffffc02025dc:	4785                	li	a5,1
ffffffffc02025de:	04f71663          	bne	a4,a5,ffffffffc020262a <pgdir_alloc_page+0x9a>
            }
        }
    }

    return page;
}
ffffffffc02025e2:	70a2                	ld	ra,40(sp)
ffffffffc02025e4:	8522                	mv	a0,s0
ffffffffc02025e6:	7402                	ld	s0,32(sp)
ffffffffc02025e8:	64e2                	ld	s1,24(sp)
ffffffffc02025ea:	6942                	ld	s2,16(sp)
ffffffffc02025ec:	69a2                	ld	s3,8(sp)
ffffffffc02025ee:	6145                	addi	sp,sp,48
ffffffffc02025f0:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02025f2:	100027f3          	csrr	a5,sstatus
ffffffffc02025f6:	8b89                	andi	a5,a5,2
ffffffffc02025f8:	eb99                	bnez	a5,ffffffffc020260e <pgdir_alloc_page+0x7e>
        pmm_manager->free_pages(base, n);
ffffffffc02025fa:	00032797          	auipc	a5,0x32
ffffffffc02025fe:	7367b783          	ld	a5,1846(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc0202602:	739c                	ld	a5,32(a5)
ffffffffc0202604:	8522                	mv	a0,s0
ffffffffc0202606:	4585                	li	a1,1
ffffffffc0202608:	9782                	jalr	a5
            return NULL;
ffffffffc020260a:	4401                	li	s0,0
ffffffffc020260c:	bfd9                	j	ffffffffc02025e2 <pgdir_alloc_page+0x52>
        intr_disable();
ffffffffc020260e:	82afe0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202612:	00032797          	auipc	a5,0x32
ffffffffc0202616:	71e7b783          	ld	a5,1822(a5) # ffffffffc0234d30 <pmm_manager>
ffffffffc020261a:	739c                	ld	a5,32(a5)
ffffffffc020261c:	8522                	mv	a0,s0
ffffffffc020261e:	4585                	li	a1,1
ffffffffc0202620:	9782                	jalr	a5
            return NULL;
ffffffffc0202622:	4401                	li	s0,0
        intr_enable();
ffffffffc0202624:	80efe0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc0202628:	bf6d                	j	ffffffffc02025e2 <pgdir_alloc_page+0x52>
                assert(page_ref(page) == 1);
ffffffffc020262a:	00003697          	auipc	a3,0x3
ffffffffc020262e:	69e68693          	addi	a3,a3,1694 # ffffffffc0205cc8 <default_pmm_manager+0x1f8>
ffffffffc0202632:	00003617          	auipc	a2,0x3
ffffffffc0202636:	e0660613          	addi	a2,a2,-506 # ffffffffc0205438 <commands+0x448>
ffffffffc020263a:	1d800593          	li	a1,472
ffffffffc020263e:	00003517          	auipc	a0,0x3
ffffffffc0202642:	60250513          	addi	a0,a0,1538 # ffffffffc0205c40 <default_pmm_manager+0x170>
ffffffffc0202646:	e31fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc020264a <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc020264a:	1101                	addi	sp,sp,-32
ffffffffc020264c:	ec06                	sd	ra,24(sp)
ffffffffc020264e:	e822                	sd	s0,16(sp)
ffffffffc0202650:	e426                	sd	s1,8(sp)
     swapfs_init();
ffffffffc0202652:	339000ef          	jal	ra,ffffffffc020318a <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc0202656:	00032697          	auipc	a3,0x32
ffffffffc020265a:	6ea6b683          	ld	a3,1770(a3) # ffffffffc0234d40 <max_swap_offset>
ffffffffc020265e:	010007b7          	lui	a5,0x1000
ffffffffc0202662:	ff968713          	addi	a4,a3,-7
ffffffffc0202666:	17e1                	addi	a5,a5,-8
ffffffffc0202668:	04e7e863          	bltu	a5,a4,ffffffffc02026b8 <swap_init+0x6e>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }
     

     sm = &swap_manager_fifo;
ffffffffc020266c:	00027797          	auipc	a5,0x27
ffffffffc0202670:	1a478793          	addi	a5,a5,420 # ffffffffc0229810 <swap_manager_fifo>
     int r = sm->init();
ffffffffc0202674:	6798                	ld	a4,8(a5)
     sm = &swap_manager_fifo;
ffffffffc0202676:	00032497          	auipc	s1,0x32
ffffffffc020267a:	6d248493          	addi	s1,s1,1746 # ffffffffc0234d48 <sm>
ffffffffc020267e:	e09c                	sd	a5,0(s1)
     int r = sm->init();
ffffffffc0202680:	9702                	jalr	a4
ffffffffc0202682:	842a                	mv	s0,a0
     
     if (r == 0)
ffffffffc0202684:	c519                	beqz	a0,ffffffffc0202692 <swap_init+0x48>
          cprintf("SWAP: manager = %s\n", sm->name);
          //check_swap();
     }

     return r;
}
ffffffffc0202686:	60e2                	ld	ra,24(sp)
ffffffffc0202688:	8522                	mv	a0,s0
ffffffffc020268a:	6442                	ld	s0,16(sp)
ffffffffc020268c:	64a2                	ld	s1,8(sp)
ffffffffc020268e:	6105                	addi	sp,sp,32
ffffffffc0202690:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202692:	609c                	ld	a5,0(s1)
ffffffffc0202694:	00003517          	auipc	a0,0x3
ffffffffc0202698:	67c50513          	addi	a0,a0,1660 # ffffffffc0205d10 <default_pmm_manager+0x240>
ffffffffc020269c:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc020269e:	4785                	li	a5,1
ffffffffc02026a0:	00032717          	auipc	a4,0x32
ffffffffc02026a4:	6af72823          	sw	a5,1712(a4) # ffffffffc0234d50 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc02026a8:	ad5fd0ef          	jal	ra,ffffffffc020017c <cprintf>
}
ffffffffc02026ac:	60e2                	ld	ra,24(sp)
ffffffffc02026ae:	8522                	mv	a0,s0
ffffffffc02026b0:	6442                	ld	s0,16(sp)
ffffffffc02026b2:	64a2                	ld	s1,8(sp)
ffffffffc02026b4:	6105                	addi	sp,sp,32
ffffffffc02026b6:	8082                	ret
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc02026b8:	00003617          	auipc	a2,0x3
ffffffffc02026bc:	62860613          	addi	a2,a2,1576 # ffffffffc0205ce0 <default_pmm_manager+0x210>
ffffffffc02026c0:	02800593          	li	a1,40
ffffffffc02026c4:	00003517          	auipc	a0,0x3
ffffffffc02026c8:	63c50513          	addi	a0,a0,1596 # ffffffffc0205d00 <default_pmm_manager+0x230>
ffffffffc02026cc:	dabfd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02026d0 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
     return sm->init_mm(mm);
ffffffffc02026d0:	00032797          	auipc	a5,0x32
ffffffffc02026d4:	6787b783          	ld	a5,1656(a5) # ffffffffc0234d48 <sm>
ffffffffc02026d8:	6b9c                	ld	a5,16(a5)
ffffffffc02026da:	8782                	jr	a5

ffffffffc02026dc <swap_map_swappable>:
}

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc02026dc:	00032797          	auipc	a5,0x32
ffffffffc02026e0:	66c7b783          	ld	a5,1644(a5) # ffffffffc0234d48 <sm>
ffffffffc02026e4:	739c                	ld	a5,32(a5)
ffffffffc02026e6:	8782                	jr	a5

ffffffffc02026e8 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
ffffffffc02026e8:	711d                	addi	sp,sp,-96
ffffffffc02026ea:	ec86                	sd	ra,88(sp)
ffffffffc02026ec:	e8a2                	sd	s0,80(sp)
ffffffffc02026ee:	e4a6                	sd	s1,72(sp)
ffffffffc02026f0:	e0ca                	sd	s2,64(sp)
ffffffffc02026f2:	fc4e                	sd	s3,56(sp)
ffffffffc02026f4:	f852                	sd	s4,48(sp)
ffffffffc02026f6:	f456                	sd	s5,40(sp)
ffffffffc02026f8:	f05a                	sd	s6,32(sp)
ffffffffc02026fa:	ec5e                	sd	s7,24(sp)
ffffffffc02026fc:	e862                	sd	s8,16(sp)
     int i;
     for (i = 0; i != n; ++ i)
ffffffffc02026fe:	cde9                	beqz	a1,ffffffffc02027d8 <swap_out+0xf0>
ffffffffc0202700:	8a2e                	mv	s4,a1
ffffffffc0202702:	892a                	mv	s2,a0
ffffffffc0202704:	8ab2                	mv	s5,a2
ffffffffc0202706:	4401                	li	s0,0
ffffffffc0202708:	00032997          	auipc	s3,0x32
ffffffffc020270c:	64098993          	addi	s3,s3,1600 # ffffffffc0234d48 <sm>
                    cprintf("SWAP: failed to save\n");
                    sm->map_swappable(mm, v, page, 0);
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202710:	00003b17          	auipc	s6,0x3
ffffffffc0202714:	678b0b13          	addi	s6,s6,1656 # ffffffffc0205d88 <default_pmm_manager+0x2b8>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202718:	00003b97          	auipc	s7,0x3
ffffffffc020271c:	658b8b93          	addi	s7,s7,1624 # ffffffffc0205d70 <default_pmm_manager+0x2a0>
ffffffffc0202720:	a825                	j	ffffffffc0202758 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202722:	67a2                	ld	a5,8(sp)
ffffffffc0202724:	8626                	mv	a2,s1
ffffffffc0202726:	85a2                	mv	a1,s0
ffffffffc0202728:	7f94                	ld	a3,56(a5)
ffffffffc020272a:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc020272c:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc020272e:	82b1                	srli	a3,a3,0xc
ffffffffc0202730:	0685                	addi	a3,a3,1
ffffffffc0202732:	a4bfd0ef          	jal	ra,ffffffffc020017c <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202736:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0202738:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc020273a:	7d1c                	ld	a5,56(a0)
ffffffffc020273c:	83b1                	srli	a5,a5,0xc
ffffffffc020273e:	0785                	addi	a5,a5,1
ffffffffc0202740:	07a2                	slli	a5,a5,0x8
ffffffffc0202742:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0202746:	d00ff0ef          	jal	ra,ffffffffc0201c46 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
ffffffffc020274a:	01893503          	ld	a0,24(s2)
ffffffffc020274e:	85a6                	mv	a1,s1
ffffffffc0202750:	e3bff0ef          	jal	ra,ffffffffc020258a <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0202754:	048a0d63          	beq	s4,s0,ffffffffc02027ae <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0202758:	0009b783          	ld	a5,0(s3)
ffffffffc020275c:	8656                	mv	a2,s5
ffffffffc020275e:	002c                	addi	a1,sp,8
ffffffffc0202760:	7b9c                	ld	a5,48(a5)
ffffffffc0202762:	854a                	mv	a0,s2
ffffffffc0202764:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0202766:	e12d                	bnez	a0,ffffffffc02027c8 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0202768:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020276a:	01893503          	ld	a0,24(s2)
ffffffffc020276e:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0202770:	7f84                	ld	s1,56(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202772:	85a6                	mv	a1,s1
ffffffffc0202774:	ea2ff0ef          	jal	ra,ffffffffc0201e16 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0202778:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020277a:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc020277c:	8b85                	andi	a5,a5,1
ffffffffc020277e:	cfb9                	beqz	a5,ffffffffc02027dc <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0202780:	65a2                	ld	a1,8(sp)
ffffffffc0202782:	7d9c                	ld	a5,56(a1)
ffffffffc0202784:	83b1                	srli	a5,a5,0xc
ffffffffc0202786:	0785                	addi	a5,a5,1
ffffffffc0202788:	00879513          	slli	a0,a5,0x8
ffffffffc020278c:	2c5000ef          	jal	ra,ffffffffc0203250 <swapfs_write>
ffffffffc0202790:	d949                	beqz	a0,ffffffffc0202722 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202792:	855e                	mv	a0,s7
ffffffffc0202794:	9e9fd0ef          	jal	ra,ffffffffc020017c <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0202798:	0009b783          	ld	a5,0(s3)
ffffffffc020279c:	6622                	ld	a2,8(sp)
ffffffffc020279e:	4681                	li	a3,0
ffffffffc02027a0:	739c                	ld	a5,32(a5)
ffffffffc02027a2:	85a6                	mv	a1,s1
ffffffffc02027a4:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc02027a6:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc02027a8:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc02027aa:	fa8a17e3          	bne	s4,s0,ffffffffc0202758 <swap_out+0x70>
     }
     return i;
}
ffffffffc02027ae:	60e6                	ld	ra,88(sp)
ffffffffc02027b0:	8522                	mv	a0,s0
ffffffffc02027b2:	6446                	ld	s0,80(sp)
ffffffffc02027b4:	64a6                	ld	s1,72(sp)
ffffffffc02027b6:	6906                	ld	s2,64(sp)
ffffffffc02027b8:	79e2                	ld	s3,56(sp)
ffffffffc02027ba:	7a42                	ld	s4,48(sp)
ffffffffc02027bc:	7aa2                	ld	s5,40(sp)
ffffffffc02027be:	7b02                	ld	s6,32(sp)
ffffffffc02027c0:	6be2                	ld	s7,24(sp)
ffffffffc02027c2:	6c42                	ld	s8,16(sp)
ffffffffc02027c4:	6125                	addi	sp,sp,96
ffffffffc02027c6:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc02027c8:	85a2                	mv	a1,s0
ffffffffc02027ca:	00003517          	auipc	a0,0x3
ffffffffc02027ce:	55e50513          	addi	a0,a0,1374 # ffffffffc0205d28 <default_pmm_manager+0x258>
ffffffffc02027d2:	9abfd0ef          	jal	ra,ffffffffc020017c <cprintf>
                  break;
ffffffffc02027d6:	bfe1                	j	ffffffffc02027ae <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc02027d8:	4401                	li	s0,0
ffffffffc02027da:	bfd1                	j	ffffffffc02027ae <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc02027dc:	00003697          	auipc	a3,0x3
ffffffffc02027e0:	57c68693          	addi	a3,a3,1404 # ffffffffc0205d58 <default_pmm_manager+0x288>
ffffffffc02027e4:	00003617          	auipc	a2,0x3
ffffffffc02027e8:	c5460613          	addi	a2,a2,-940 # ffffffffc0205438 <commands+0x448>
ffffffffc02027ec:	06800593          	li	a1,104
ffffffffc02027f0:	00003517          	auipc	a0,0x3
ffffffffc02027f4:	51050513          	addi	a0,a0,1296 # ffffffffc0205d00 <default_pmm_manager+0x230>
ffffffffc02027f8:	c7ffd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02027fc <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
ffffffffc02027fc:	7179                	addi	sp,sp,-48
ffffffffc02027fe:	e84a                	sd	s2,16(sp)
ffffffffc0202800:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0202802:	4505                	li	a0,1
{
ffffffffc0202804:	ec26                	sd	s1,24(sp)
ffffffffc0202806:	e44e                	sd	s3,8(sp)
ffffffffc0202808:	f406                	sd	ra,40(sp)
ffffffffc020280a:	f022                	sd	s0,32(sp)
ffffffffc020280c:	84ae                	mv	s1,a1
ffffffffc020280e:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0202810:	ba4ff0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
     assert(result!=NULL);
ffffffffc0202814:	c129                	beqz	a0,ffffffffc0202856 <swap_in+0x5a>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0202816:	842a                	mv	s0,a0
ffffffffc0202818:	01893503          	ld	a0,24(s2)
ffffffffc020281c:	4601                	li	a2,0
ffffffffc020281e:	85a6                	mv	a1,s1
ffffffffc0202820:	df6ff0ef          	jal	ra,ffffffffc0201e16 <get_pte>
ffffffffc0202824:	892a                	mv	s2,a0
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0202826:	6108                	ld	a0,0(a0)
ffffffffc0202828:	85a2                	mv	a1,s0
ffffffffc020282a:	199000ef          	jal	ra,ffffffffc02031c2 <swapfs_read>
     {
        assert(r!=0);
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc020282e:	00093583          	ld	a1,0(s2)
ffffffffc0202832:	8626                	mv	a2,s1
ffffffffc0202834:	00003517          	auipc	a0,0x3
ffffffffc0202838:	5a450513          	addi	a0,a0,1444 # ffffffffc0205dd8 <default_pmm_manager+0x308>
ffffffffc020283c:	81a1                	srli	a1,a1,0x8
ffffffffc020283e:	93ffd0ef          	jal	ra,ffffffffc020017c <cprintf>
     *ptr_result=result;
     return 0;
}
ffffffffc0202842:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0202844:	0089b023          	sd	s0,0(s3)
}
ffffffffc0202848:	7402                	ld	s0,32(sp)
ffffffffc020284a:	64e2                	ld	s1,24(sp)
ffffffffc020284c:	6942                	ld	s2,16(sp)
ffffffffc020284e:	69a2                	ld	s3,8(sp)
ffffffffc0202850:	4501                	li	a0,0
ffffffffc0202852:	6145                	addi	sp,sp,48
ffffffffc0202854:	8082                	ret
     assert(result!=NULL);
ffffffffc0202856:	00003697          	auipc	a3,0x3
ffffffffc020285a:	57268693          	addi	a3,a3,1394 # ffffffffc0205dc8 <default_pmm_manager+0x2f8>
ffffffffc020285e:	00003617          	auipc	a2,0x3
ffffffffc0202862:	bda60613          	addi	a2,a2,-1062 # ffffffffc0205438 <commands+0x448>
ffffffffc0202866:	07e00593          	li	a1,126
ffffffffc020286a:	00003517          	auipc	a0,0x3
ffffffffc020286e:	49650513          	addi	a0,a0,1174 # ffffffffc0205d00 <default_pmm_manager+0x230>
ffffffffc0202872:	c05fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202876 <_fifo_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc0202876:	0002e797          	auipc	a5,0x2e
ffffffffc020287a:	43278793          	addi	a5,a5,1074 # ffffffffc0230ca8 <pra_list_head>
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc020287e:	f51c                	sd	a5,40(a0)
ffffffffc0202880:	e79c                	sd	a5,8(a5)
ffffffffc0202882:	e39c                	sd	a5,0(a5)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc0202884:	4501                	li	a0,0
ffffffffc0202886:	8082                	ret

ffffffffc0202888 <_fifo_init>:

static int
_fifo_init(void)
{
    return 0;
}
ffffffffc0202888:	4501                	li	a0,0
ffffffffc020288a:	8082                	ret

ffffffffc020288c <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc020288c:	4501                	li	a0,0
ffffffffc020288e:	8082                	ret

ffffffffc0202890 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc0202890:	4501                	li	a0,0
ffffffffc0202892:	8082                	ret

ffffffffc0202894 <_fifo_check_swap>:
_fifo_check_swap(void) {
ffffffffc0202894:	711d                	addi	sp,sp,-96
ffffffffc0202896:	fc4e                	sd	s3,56(sp)
ffffffffc0202898:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc020289a:	00003517          	auipc	a0,0x3
ffffffffc020289e:	57e50513          	addi	a0,a0,1406 # ffffffffc0205e18 <default_pmm_manager+0x348>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02028a2:	698d                	lui	s3,0x3
ffffffffc02028a4:	4a31                	li	s4,12
_fifo_check_swap(void) {
ffffffffc02028a6:	e0ca                	sd	s2,64(sp)
ffffffffc02028a8:	ec86                	sd	ra,88(sp)
ffffffffc02028aa:	e8a2                	sd	s0,80(sp)
ffffffffc02028ac:	e4a6                	sd	s1,72(sp)
ffffffffc02028ae:	f456                	sd	s5,40(sp)
ffffffffc02028b0:	f05a                	sd	s6,32(sp)
ffffffffc02028b2:	ec5e                	sd	s7,24(sp)
ffffffffc02028b4:	e862                	sd	s8,16(sp)
ffffffffc02028b6:	e466                	sd	s9,8(sp)
ffffffffc02028b8:	e06a                	sd	s10,0(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02028ba:	8c3fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02028be:	01498023          	sb	s4,0(s3) # 3000 <_binary_obj___user_hello_out_size-0x6d80>
    assert(pgfault_num==4);
ffffffffc02028c2:	00032917          	auipc	s2,0x32
ffffffffc02028c6:	49e92903          	lw	s2,1182(s2) # ffffffffc0234d60 <pgfault_num>
ffffffffc02028ca:	4791                	li	a5,4
ffffffffc02028cc:	14f91e63          	bne	s2,a5,ffffffffc0202a28 <_fifo_check_swap+0x194>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc02028d0:	00003517          	auipc	a0,0x3
ffffffffc02028d4:	59850513          	addi	a0,a0,1432 # ffffffffc0205e68 <default_pmm_manager+0x398>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02028d8:	6a85                	lui	s5,0x1
ffffffffc02028da:	4b29                	li	s6,10
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc02028dc:	8a1fd0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc02028e0:	00032417          	auipc	s0,0x32
ffffffffc02028e4:	48040413          	addi	s0,s0,1152 # ffffffffc0234d60 <pgfault_num>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02028e8:	016a8023          	sb	s6,0(s5) # 1000 <_binary_obj___user_hello_out_size-0x8d80>
    assert(pgfault_num==4);
ffffffffc02028ec:	4004                	lw	s1,0(s0)
ffffffffc02028ee:	2481                	sext.w	s1,s1
ffffffffc02028f0:	2b249c63          	bne	s1,s2,ffffffffc0202ba8 <_fifo_check_swap+0x314>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc02028f4:	00003517          	auipc	a0,0x3
ffffffffc02028f8:	59c50513          	addi	a0,a0,1436 # ffffffffc0205e90 <default_pmm_manager+0x3c0>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02028fc:	6b91                	lui	s7,0x4
ffffffffc02028fe:	4c35                	li	s8,13
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0202900:	87dfd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202904:	018b8023          	sb	s8,0(s7) # 4000 <_binary_obj___user_hello_out_size-0x5d80>
    assert(pgfault_num==4);
ffffffffc0202908:	00042903          	lw	s2,0(s0)
ffffffffc020290c:	2901                	sext.w	s2,s2
ffffffffc020290e:	26991d63          	bne	s2,s1,ffffffffc0202b88 <_fifo_check_swap+0x2f4>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0202912:	00003517          	auipc	a0,0x3
ffffffffc0202916:	5a650513          	addi	a0,a0,1446 # ffffffffc0205eb8 <default_pmm_manager+0x3e8>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020291a:	6c89                	lui	s9,0x2
ffffffffc020291c:	4d2d                	li	s10,11
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020291e:	85ffd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202922:	01ac8023          	sb	s10,0(s9) # 2000 <_binary_obj___user_hello_out_size-0x7d80>
    assert(pgfault_num==4);
ffffffffc0202926:	401c                	lw	a5,0(s0)
ffffffffc0202928:	2781                	sext.w	a5,a5
ffffffffc020292a:	23279f63          	bne	a5,s2,ffffffffc0202b68 <_fifo_check_swap+0x2d4>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc020292e:	00003517          	auipc	a0,0x3
ffffffffc0202932:	5b250513          	addi	a0,a0,1458 # ffffffffc0205ee0 <default_pmm_manager+0x410>
ffffffffc0202936:	847fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc020293a:	6795                	lui	a5,0x5
ffffffffc020293c:	4739                	li	a4,14
ffffffffc020293e:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_hello_out_size-0x4d80>
    assert(pgfault_num==5);
ffffffffc0202942:	4004                	lw	s1,0(s0)
ffffffffc0202944:	4795                	li	a5,5
ffffffffc0202946:	2481                	sext.w	s1,s1
ffffffffc0202948:	20f49063          	bne	s1,a5,ffffffffc0202b48 <_fifo_check_swap+0x2b4>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020294c:	00003517          	auipc	a0,0x3
ffffffffc0202950:	56c50513          	addi	a0,a0,1388 # ffffffffc0205eb8 <default_pmm_manager+0x3e8>
ffffffffc0202954:	829fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202958:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==5);
ffffffffc020295c:	401c                	lw	a5,0(s0)
ffffffffc020295e:	2781                	sext.w	a5,a5
ffffffffc0202960:	1c979463          	bne	a5,s1,ffffffffc0202b28 <_fifo_check_swap+0x294>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202964:	00003517          	auipc	a0,0x3
ffffffffc0202968:	50450513          	addi	a0,a0,1284 # ffffffffc0205e68 <default_pmm_manager+0x398>
ffffffffc020296c:	811fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202970:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc0202974:	401c                	lw	a5,0(s0)
ffffffffc0202976:	4719                	li	a4,6
ffffffffc0202978:	2781                	sext.w	a5,a5
ffffffffc020297a:	18e79763          	bne	a5,a4,ffffffffc0202b08 <_fifo_check_swap+0x274>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020297e:	00003517          	auipc	a0,0x3
ffffffffc0202982:	53a50513          	addi	a0,a0,1338 # ffffffffc0205eb8 <default_pmm_manager+0x3e8>
ffffffffc0202986:	ff6fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020298a:	01ac8023          	sb	s10,0(s9)
    assert(pgfault_num==7);
ffffffffc020298e:	401c                	lw	a5,0(s0)
ffffffffc0202990:	471d                	li	a4,7
ffffffffc0202992:	2781                	sext.w	a5,a5
ffffffffc0202994:	14e79a63          	bne	a5,a4,ffffffffc0202ae8 <_fifo_check_swap+0x254>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0202998:	00003517          	auipc	a0,0x3
ffffffffc020299c:	48050513          	addi	a0,a0,1152 # ffffffffc0205e18 <default_pmm_manager+0x348>
ffffffffc02029a0:	fdcfd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02029a4:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc02029a8:	401c                	lw	a5,0(s0)
ffffffffc02029aa:	4721                	li	a4,8
ffffffffc02029ac:	2781                	sext.w	a5,a5
ffffffffc02029ae:	10e79d63          	bne	a5,a4,ffffffffc0202ac8 <_fifo_check_swap+0x234>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc02029b2:	00003517          	auipc	a0,0x3
ffffffffc02029b6:	4de50513          	addi	a0,a0,1246 # ffffffffc0205e90 <default_pmm_manager+0x3c0>
ffffffffc02029ba:	fc2fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02029be:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc02029c2:	401c                	lw	a5,0(s0)
ffffffffc02029c4:	4725                	li	a4,9
ffffffffc02029c6:	2781                	sext.w	a5,a5
ffffffffc02029c8:	0ee79063          	bne	a5,a4,ffffffffc0202aa8 <_fifo_check_swap+0x214>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc02029cc:	00003517          	auipc	a0,0x3
ffffffffc02029d0:	51450513          	addi	a0,a0,1300 # ffffffffc0205ee0 <default_pmm_manager+0x410>
ffffffffc02029d4:	fa8fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02029d8:	6795                	lui	a5,0x5
ffffffffc02029da:	4739                	li	a4,14
ffffffffc02029dc:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_hello_out_size-0x4d80>
    assert(pgfault_num==10);
ffffffffc02029e0:	4004                	lw	s1,0(s0)
ffffffffc02029e2:	47a9                	li	a5,10
ffffffffc02029e4:	2481                	sext.w	s1,s1
ffffffffc02029e6:	0af49163          	bne	s1,a5,ffffffffc0202a88 <_fifo_check_swap+0x1f4>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc02029ea:	00003517          	auipc	a0,0x3
ffffffffc02029ee:	47e50513          	addi	a0,a0,1150 # ffffffffc0205e68 <default_pmm_manager+0x398>
ffffffffc02029f2:	f8afd0ef          	jal	ra,ffffffffc020017c <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc02029f6:	6785                	lui	a5,0x1
ffffffffc02029f8:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_obj___user_hello_out_size-0x8d80>
ffffffffc02029fc:	06979663          	bne	a5,s1,ffffffffc0202a68 <_fifo_check_swap+0x1d4>
    assert(pgfault_num==11);
ffffffffc0202a00:	401c                	lw	a5,0(s0)
ffffffffc0202a02:	472d                	li	a4,11
ffffffffc0202a04:	2781                	sext.w	a5,a5
ffffffffc0202a06:	04e79163          	bne	a5,a4,ffffffffc0202a48 <_fifo_check_swap+0x1b4>
}
ffffffffc0202a0a:	60e6                	ld	ra,88(sp)
ffffffffc0202a0c:	6446                	ld	s0,80(sp)
ffffffffc0202a0e:	64a6                	ld	s1,72(sp)
ffffffffc0202a10:	6906                	ld	s2,64(sp)
ffffffffc0202a12:	79e2                	ld	s3,56(sp)
ffffffffc0202a14:	7a42                	ld	s4,48(sp)
ffffffffc0202a16:	7aa2                	ld	s5,40(sp)
ffffffffc0202a18:	7b02                	ld	s6,32(sp)
ffffffffc0202a1a:	6be2                	ld	s7,24(sp)
ffffffffc0202a1c:	6c42                	ld	s8,16(sp)
ffffffffc0202a1e:	6ca2                	ld	s9,8(sp)
ffffffffc0202a20:	6d02                	ld	s10,0(sp)
ffffffffc0202a22:	4501                	li	a0,0
ffffffffc0202a24:	6125                	addi	sp,sp,96
ffffffffc0202a26:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0202a28:	00003697          	auipc	a3,0x3
ffffffffc0202a2c:	41868693          	addi	a3,a3,1048 # ffffffffc0205e40 <default_pmm_manager+0x370>
ffffffffc0202a30:	00003617          	auipc	a2,0x3
ffffffffc0202a34:	a0860613          	addi	a2,a2,-1528 # ffffffffc0205438 <commands+0x448>
ffffffffc0202a38:	05100593          	li	a1,81
ffffffffc0202a3c:	00003517          	auipc	a0,0x3
ffffffffc0202a40:	41450513          	addi	a0,a0,1044 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202a44:	a33fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==11);
ffffffffc0202a48:	00003697          	auipc	a3,0x3
ffffffffc0202a4c:	54868693          	addi	a3,a3,1352 # ffffffffc0205f90 <default_pmm_manager+0x4c0>
ffffffffc0202a50:	00003617          	auipc	a2,0x3
ffffffffc0202a54:	9e860613          	addi	a2,a2,-1560 # ffffffffc0205438 <commands+0x448>
ffffffffc0202a58:	07300593          	li	a1,115
ffffffffc0202a5c:	00003517          	auipc	a0,0x3
ffffffffc0202a60:	3f450513          	addi	a0,a0,1012 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202a64:	a13fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202a68:	00003697          	auipc	a3,0x3
ffffffffc0202a6c:	50068693          	addi	a3,a3,1280 # ffffffffc0205f68 <default_pmm_manager+0x498>
ffffffffc0202a70:	00003617          	auipc	a2,0x3
ffffffffc0202a74:	9c860613          	addi	a2,a2,-1592 # ffffffffc0205438 <commands+0x448>
ffffffffc0202a78:	07100593          	li	a1,113
ffffffffc0202a7c:	00003517          	auipc	a0,0x3
ffffffffc0202a80:	3d450513          	addi	a0,a0,980 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202a84:	9f3fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==10);
ffffffffc0202a88:	00003697          	auipc	a3,0x3
ffffffffc0202a8c:	4d068693          	addi	a3,a3,1232 # ffffffffc0205f58 <default_pmm_manager+0x488>
ffffffffc0202a90:	00003617          	auipc	a2,0x3
ffffffffc0202a94:	9a860613          	addi	a2,a2,-1624 # ffffffffc0205438 <commands+0x448>
ffffffffc0202a98:	06f00593          	li	a1,111
ffffffffc0202a9c:	00003517          	auipc	a0,0x3
ffffffffc0202aa0:	3b450513          	addi	a0,a0,948 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202aa4:	9d3fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==9);
ffffffffc0202aa8:	00003697          	auipc	a3,0x3
ffffffffc0202aac:	4a068693          	addi	a3,a3,1184 # ffffffffc0205f48 <default_pmm_manager+0x478>
ffffffffc0202ab0:	00003617          	auipc	a2,0x3
ffffffffc0202ab4:	98860613          	addi	a2,a2,-1656 # ffffffffc0205438 <commands+0x448>
ffffffffc0202ab8:	06c00593          	li	a1,108
ffffffffc0202abc:	00003517          	auipc	a0,0x3
ffffffffc0202ac0:	39450513          	addi	a0,a0,916 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202ac4:	9b3fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==8);
ffffffffc0202ac8:	00003697          	auipc	a3,0x3
ffffffffc0202acc:	47068693          	addi	a3,a3,1136 # ffffffffc0205f38 <default_pmm_manager+0x468>
ffffffffc0202ad0:	00003617          	auipc	a2,0x3
ffffffffc0202ad4:	96860613          	addi	a2,a2,-1688 # ffffffffc0205438 <commands+0x448>
ffffffffc0202ad8:	06900593          	li	a1,105
ffffffffc0202adc:	00003517          	auipc	a0,0x3
ffffffffc0202ae0:	37450513          	addi	a0,a0,884 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202ae4:	993fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==7);
ffffffffc0202ae8:	00003697          	auipc	a3,0x3
ffffffffc0202aec:	44068693          	addi	a3,a3,1088 # ffffffffc0205f28 <default_pmm_manager+0x458>
ffffffffc0202af0:	00003617          	auipc	a2,0x3
ffffffffc0202af4:	94860613          	addi	a2,a2,-1720 # ffffffffc0205438 <commands+0x448>
ffffffffc0202af8:	06600593          	li	a1,102
ffffffffc0202afc:	00003517          	auipc	a0,0x3
ffffffffc0202b00:	35450513          	addi	a0,a0,852 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202b04:	973fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==6);
ffffffffc0202b08:	00003697          	auipc	a3,0x3
ffffffffc0202b0c:	41068693          	addi	a3,a3,1040 # ffffffffc0205f18 <default_pmm_manager+0x448>
ffffffffc0202b10:	00003617          	auipc	a2,0x3
ffffffffc0202b14:	92860613          	addi	a2,a2,-1752 # ffffffffc0205438 <commands+0x448>
ffffffffc0202b18:	06300593          	li	a1,99
ffffffffc0202b1c:	00003517          	auipc	a0,0x3
ffffffffc0202b20:	33450513          	addi	a0,a0,820 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202b24:	953fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==5);
ffffffffc0202b28:	00003697          	auipc	a3,0x3
ffffffffc0202b2c:	3e068693          	addi	a3,a3,992 # ffffffffc0205f08 <default_pmm_manager+0x438>
ffffffffc0202b30:	00003617          	auipc	a2,0x3
ffffffffc0202b34:	90860613          	addi	a2,a2,-1784 # ffffffffc0205438 <commands+0x448>
ffffffffc0202b38:	06000593          	li	a1,96
ffffffffc0202b3c:	00003517          	auipc	a0,0x3
ffffffffc0202b40:	31450513          	addi	a0,a0,788 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202b44:	933fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==5);
ffffffffc0202b48:	00003697          	auipc	a3,0x3
ffffffffc0202b4c:	3c068693          	addi	a3,a3,960 # ffffffffc0205f08 <default_pmm_manager+0x438>
ffffffffc0202b50:	00003617          	auipc	a2,0x3
ffffffffc0202b54:	8e860613          	addi	a2,a2,-1816 # ffffffffc0205438 <commands+0x448>
ffffffffc0202b58:	05d00593          	li	a1,93
ffffffffc0202b5c:	00003517          	auipc	a0,0x3
ffffffffc0202b60:	2f450513          	addi	a0,a0,756 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202b64:	913fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==4);
ffffffffc0202b68:	00003697          	auipc	a3,0x3
ffffffffc0202b6c:	2d868693          	addi	a3,a3,728 # ffffffffc0205e40 <default_pmm_manager+0x370>
ffffffffc0202b70:	00003617          	auipc	a2,0x3
ffffffffc0202b74:	8c860613          	addi	a2,a2,-1848 # ffffffffc0205438 <commands+0x448>
ffffffffc0202b78:	05a00593          	li	a1,90
ffffffffc0202b7c:	00003517          	auipc	a0,0x3
ffffffffc0202b80:	2d450513          	addi	a0,a0,724 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202b84:	8f3fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==4);
ffffffffc0202b88:	00003697          	auipc	a3,0x3
ffffffffc0202b8c:	2b868693          	addi	a3,a3,696 # ffffffffc0205e40 <default_pmm_manager+0x370>
ffffffffc0202b90:	00003617          	auipc	a2,0x3
ffffffffc0202b94:	8a860613          	addi	a2,a2,-1880 # ffffffffc0205438 <commands+0x448>
ffffffffc0202b98:	05700593          	li	a1,87
ffffffffc0202b9c:	00003517          	auipc	a0,0x3
ffffffffc0202ba0:	2b450513          	addi	a0,a0,692 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202ba4:	8d3fd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgfault_num==4);
ffffffffc0202ba8:	00003697          	auipc	a3,0x3
ffffffffc0202bac:	29868693          	addi	a3,a3,664 # ffffffffc0205e40 <default_pmm_manager+0x370>
ffffffffc0202bb0:	00003617          	auipc	a2,0x3
ffffffffc0202bb4:	88860613          	addi	a2,a2,-1912 # ffffffffc0205438 <commands+0x448>
ffffffffc0202bb8:	05400593          	li	a1,84
ffffffffc0202bbc:	00003517          	auipc	a0,0x3
ffffffffc0202bc0:	29450513          	addi	a0,a0,660 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202bc4:	8b3fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202bc8 <_fifo_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0202bc8:	751c                	ld	a5,40(a0)
{
ffffffffc0202bca:	1141                	addi	sp,sp,-16
ffffffffc0202bcc:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc0202bce:	cf91                	beqz	a5,ffffffffc0202bea <_fifo_swap_out_victim+0x22>
     assert(in_tick==0);
ffffffffc0202bd0:	ee0d                	bnez	a2,ffffffffc0202c0a <_fifo_swap_out_victim+0x42>
    return listelm->next;
ffffffffc0202bd2:	679c                	ld	a5,8(a5)
}
ffffffffc0202bd4:	60a2                	ld	ra,8(sp)
ffffffffc0202bd6:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0202bd8:	6394                	ld	a3,0(a5)
ffffffffc0202bda:	6798                	ld	a4,8(a5)
    *ptr_page = le2page(entry, pra_page_link);
ffffffffc0202bdc:	fd878793          	addi	a5,a5,-40
    prev->next = next;
ffffffffc0202be0:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0202be2:	e314                	sd	a3,0(a4)
ffffffffc0202be4:	e19c                	sd	a5,0(a1)
}
ffffffffc0202be6:	0141                	addi	sp,sp,16
ffffffffc0202be8:	8082                	ret
         assert(head != NULL);
ffffffffc0202bea:	00003697          	auipc	a3,0x3
ffffffffc0202bee:	3b668693          	addi	a3,a3,950 # ffffffffc0205fa0 <default_pmm_manager+0x4d0>
ffffffffc0202bf2:	00003617          	auipc	a2,0x3
ffffffffc0202bf6:	84660613          	addi	a2,a2,-1978 # ffffffffc0205438 <commands+0x448>
ffffffffc0202bfa:	04100593          	li	a1,65
ffffffffc0202bfe:	00003517          	auipc	a0,0x3
ffffffffc0202c02:	25250513          	addi	a0,a0,594 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202c06:	871fd0ef          	jal	ra,ffffffffc0200476 <__panic>
     assert(in_tick==0);
ffffffffc0202c0a:	00003697          	auipc	a3,0x3
ffffffffc0202c0e:	3a668693          	addi	a3,a3,934 # ffffffffc0205fb0 <default_pmm_manager+0x4e0>
ffffffffc0202c12:	00003617          	auipc	a2,0x3
ffffffffc0202c16:	82660613          	addi	a2,a2,-2010 # ffffffffc0205438 <commands+0x448>
ffffffffc0202c1a:	04200593          	li	a1,66
ffffffffc0202c1e:	00003517          	auipc	a0,0x3
ffffffffc0202c22:	23250513          	addi	a0,a0,562 # ffffffffc0205e50 <default_pmm_manager+0x380>
ffffffffc0202c26:	851fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202c2a <_fifo_map_swappable>:
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0202c2a:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc0202c2c:	cb91                	beqz	a5,ffffffffc0202c40 <_fifo_map_swappable+0x16>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202c2e:	6394                	ld	a3,0(a5)
ffffffffc0202c30:	02860713          	addi	a4,a2,40
    prev->next = next->prev = elm;
ffffffffc0202c34:	e398                	sd	a4,0(a5)
ffffffffc0202c36:	e698                	sd	a4,8(a3)
}
ffffffffc0202c38:	4501                	li	a0,0
    elm->next = next;
ffffffffc0202c3a:	fa1c                	sd	a5,48(a2)
    elm->prev = prev;
ffffffffc0202c3c:	f614                	sd	a3,40(a2)
ffffffffc0202c3e:	8082                	ret
{
ffffffffc0202c40:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc0202c42:	00003697          	auipc	a3,0x3
ffffffffc0202c46:	37e68693          	addi	a3,a3,894 # ffffffffc0205fc0 <default_pmm_manager+0x4f0>
ffffffffc0202c4a:	00002617          	auipc	a2,0x2
ffffffffc0202c4e:	7ee60613          	addi	a2,a2,2030 # ffffffffc0205438 <commands+0x448>
ffffffffc0202c52:	03200593          	li	a1,50
ffffffffc0202c56:	00003517          	auipc	a0,0x3
ffffffffc0202c5a:	1fa50513          	addi	a0,a0,506 # ffffffffc0205e50 <default_pmm_manager+0x380>
{
ffffffffc0202c5e:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc0202c60:	817fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202c64 <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202c64:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202c66:	00003697          	auipc	a3,0x3
ffffffffc0202c6a:	39268693          	addi	a3,a3,914 # ffffffffc0205ff8 <default_pmm_manager+0x528>
ffffffffc0202c6e:	00002617          	auipc	a2,0x2
ffffffffc0202c72:	7ca60613          	addi	a2,a2,1994 # ffffffffc0205438 <commands+0x448>
ffffffffc0202c76:	06d00593          	li	a1,109
ffffffffc0202c7a:	00003517          	auipc	a0,0x3
ffffffffc0202c7e:	39e50513          	addi	a0,a0,926 # ffffffffc0206018 <default_pmm_manager+0x548>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202c82:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202c84:	ff2fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202c88 <mm_create>:
mm_create(void) {
ffffffffc0202c88:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202c8a:	04000513          	li	a0,64
mm_create(void) {
ffffffffc0202c8e:	e022                	sd	s0,0(sp)
ffffffffc0202c90:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202c92:	d61fe0ef          	jal	ra,ffffffffc02019f2 <kmalloc>
ffffffffc0202c96:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0202c98:	c505                	beqz	a0,ffffffffc0202cc0 <mm_create+0x38>
    elm->prev = elm->next = elm;
ffffffffc0202c9a:	e408                	sd	a0,8(s0)
ffffffffc0202c9c:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0202c9e:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202ca2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202ca6:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0202caa:	00032797          	auipc	a5,0x32
ffffffffc0202cae:	0a67a783          	lw	a5,166(a5) # ffffffffc0234d50 <swap_init_ok>
ffffffffc0202cb2:	ef81                	bnez	a5,ffffffffc0202cca <mm_create+0x42>
        else mm->sm_priv = NULL;
ffffffffc0202cb4:	02053423          	sd	zero,40(a0)
    return mm->mm_count;
}

static inline void
set_mm_count(struct mm_struct *mm, int val) {
    mm->mm_count = val;
ffffffffc0202cb8:	02042823          	sw	zero,48(s0)

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
    *lock = 0;
ffffffffc0202cbc:	02043c23          	sd	zero,56(s0)
}
ffffffffc0202cc0:	60a2                	ld	ra,8(sp)
ffffffffc0202cc2:	8522                	mv	a0,s0
ffffffffc0202cc4:	6402                	ld	s0,0(sp)
ffffffffc0202cc6:	0141                	addi	sp,sp,16
ffffffffc0202cc8:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0202cca:	a07ff0ef          	jal	ra,ffffffffc02026d0 <swap_init_mm>
ffffffffc0202cce:	b7ed                	j	ffffffffc0202cb8 <mm_create+0x30>

ffffffffc0202cd0 <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc0202cd0:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc0202cd2:	c505                	beqz	a0,ffffffffc0202cfa <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0202cd4:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202cd6:	c501                	beqz	a0,ffffffffc0202cde <find_vma+0xe>
ffffffffc0202cd8:	651c                	ld	a5,8(a0)
ffffffffc0202cda:	02f5f263          	bgeu	a1,a5,ffffffffc0202cfe <find_vma+0x2e>
    return listelm->next;
ffffffffc0202cde:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc0202ce0:	00f68d63          	beq	a3,a5,ffffffffc0202cfa <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0202ce4:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202ce8:	00e5e663          	bltu	a1,a4,ffffffffc0202cf4 <find_vma+0x24>
ffffffffc0202cec:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202cf0:	00e5ec63          	bltu	a1,a4,ffffffffc0202d08 <find_vma+0x38>
ffffffffc0202cf4:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0202cf6:	fef697e3          	bne	a3,a5,ffffffffc0202ce4 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0202cfa:	4501                	li	a0,0
}
ffffffffc0202cfc:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202cfe:	691c                	ld	a5,16(a0)
ffffffffc0202d00:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202cde <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0202d04:	ea88                	sd	a0,16(a3)
ffffffffc0202d06:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0202d08:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202d0c:	ea88                	sd	a0,16(a3)
ffffffffc0202d0e:	8082                	ret

ffffffffc0202d10 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202d10:	6590                	ld	a2,8(a1)
ffffffffc0202d12:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0202d16:	1141                	addi	sp,sp,-16
ffffffffc0202d18:	e406                	sd	ra,8(sp)
ffffffffc0202d1a:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202d1c:	01066763          	bltu	a2,a6,ffffffffc0202d2a <insert_vma_struct+0x1a>
ffffffffc0202d20:	a085                	j	ffffffffc0202d80 <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202d22:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202d26:	04e66863          	bltu	a2,a4,ffffffffc0202d76 <insert_vma_struct+0x66>
ffffffffc0202d2a:	86be                	mv	a3,a5
ffffffffc0202d2c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0202d2e:	fef51ae3          	bne	a0,a5,ffffffffc0202d22 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0202d32:	02a68463          	beq	a3,a0,ffffffffc0202d5a <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202d36:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202d3a:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202d3e:	08e8f163          	bgeu	a7,a4,ffffffffc0202dc0 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202d42:	04e66f63          	bltu	a2,a4,ffffffffc0202da0 <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc0202d46:	00f50a63          	beq	a0,a5,ffffffffc0202d5a <insert_vma_struct+0x4a>
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202d4a:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202d4e:	05076963          	bltu	a4,a6,ffffffffc0202da0 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0202d52:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202d56:	02c77363          	bgeu	a4,a2,ffffffffc0202d7c <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0202d5a:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202d5c:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202d5e:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202d62:	e390                	sd	a2,0(a5)
ffffffffc0202d64:	e690                	sd	a2,8(a3)
}
ffffffffc0202d66:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202d68:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202d6a:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0202d6c:	0017079b          	addiw	a5,a4,1
ffffffffc0202d70:	d11c                	sw	a5,32(a0)
}
ffffffffc0202d72:	0141                	addi	sp,sp,16
ffffffffc0202d74:	8082                	ret
    if (le_prev != list) {
ffffffffc0202d76:	fca690e3          	bne	a3,a0,ffffffffc0202d36 <insert_vma_struct+0x26>
ffffffffc0202d7a:	bfd1                	j	ffffffffc0202d4e <insert_vma_struct+0x3e>
ffffffffc0202d7c:	ee9ff0ef          	jal	ra,ffffffffc0202c64 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202d80:	00003697          	auipc	a3,0x3
ffffffffc0202d84:	2a868693          	addi	a3,a3,680 # ffffffffc0206028 <default_pmm_manager+0x558>
ffffffffc0202d88:	00002617          	auipc	a2,0x2
ffffffffc0202d8c:	6b060613          	addi	a2,a2,1712 # ffffffffc0205438 <commands+0x448>
ffffffffc0202d90:	07400593          	li	a1,116
ffffffffc0202d94:	00003517          	auipc	a0,0x3
ffffffffc0202d98:	28450513          	addi	a0,a0,644 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202d9c:	edafd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202da0:	00003697          	auipc	a3,0x3
ffffffffc0202da4:	2c868693          	addi	a3,a3,712 # ffffffffc0206068 <default_pmm_manager+0x598>
ffffffffc0202da8:	00002617          	auipc	a2,0x2
ffffffffc0202dac:	69060613          	addi	a2,a2,1680 # ffffffffc0205438 <commands+0x448>
ffffffffc0202db0:	06c00593          	li	a1,108
ffffffffc0202db4:	00003517          	auipc	a0,0x3
ffffffffc0202db8:	26450513          	addi	a0,a0,612 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202dbc:	ebafd0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202dc0:	00003697          	auipc	a3,0x3
ffffffffc0202dc4:	28868693          	addi	a3,a3,648 # ffffffffc0206048 <default_pmm_manager+0x578>
ffffffffc0202dc8:	00002617          	auipc	a2,0x2
ffffffffc0202dcc:	67060613          	addi	a2,a2,1648 # ffffffffc0205438 <commands+0x448>
ffffffffc0202dd0:	06b00593          	li	a1,107
ffffffffc0202dd4:	00003517          	auipc	a0,0x3
ffffffffc0202dd8:	24450513          	addi	a0,a0,580 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202ddc:	e9afd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202de0 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);
ffffffffc0202de0:	591c                	lw	a5,48(a0)
mm_destroy(struct mm_struct *mm) {
ffffffffc0202de2:	1141                	addi	sp,sp,-16
ffffffffc0202de4:	e406                	sd	ra,8(sp)
ffffffffc0202de6:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0202de8:	e78d                	bnez	a5,ffffffffc0202e12 <mm_destroy+0x32>
ffffffffc0202dea:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0202dec:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0202dee:	00a40c63          	beq	s0,a0,ffffffffc0202e06 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202df2:	6118                	ld	a4,0(a0)
ffffffffc0202df4:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0202df6:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0202df8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202dfa:	e398                	sd	a4,0(a5)
ffffffffc0202dfc:	ca7fe0ef          	jal	ra,ffffffffc0201aa2 <kfree>
    return listelm->next;
ffffffffc0202e00:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0202e02:	fea418e3          	bne	s0,a0,ffffffffc0202df2 <mm_destroy+0x12>
    }
    kfree(mm); //kfree mm
ffffffffc0202e06:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0202e08:	6402                	ld	s0,0(sp)
ffffffffc0202e0a:	60a2                	ld	ra,8(sp)
ffffffffc0202e0c:	0141                	addi	sp,sp,16
    kfree(mm); //kfree mm
ffffffffc0202e0e:	c95fe06f          	j	ffffffffc0201aa2 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0202e12:	00003697          	auipc	a3,0x3
ffffffffc0202e16:	27668693          	addi	a3,a3,630 # ffffffffc0206088 <default_pmm_manager+0x5b8>
ffffffffc0202e1a:	00002617          	auipc	a2,0x2
ffffffffc0202e1e:	61e60613          	addi	a2,a2,1566 # ffffffffc0205438 <commands+0x448>
ffffffffc0202e22:	09400593          	li	a1,148
ffffffffc0202e26:	00003517          	auipc	a0,0x3
ffffffffc0202e2a:	1f250513          	addi	a0,a0,498 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202e2e:	e48fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202e32 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
ffffffffc0202e32:	7139                	addi	sp,sp,-64
ffffffffc0202e34:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202e36:	6405                	lui	s0,0x1
ffffffffc0202e38:	147d                	addi	s0,s0,-1
ffffffffc0202e3a:	77fd                	lui	a5,0xfffff
ffffffffc0202e3c:	9622                	add	a2,a2,s0
ffffffffc0202e3e:	962e                	add	a2,a2,a1
       struct vma_struct **vma_store) {
ffffffffc0202e40:	f426                	sd	s1,40(sp)
ffffffffc0202e42:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202e44:	00f5f4b3          	and	s1,a1,a5
       struct vma_struct **vma_store) {
ffffffffc0202e48:	f04a                	sd	s2,32(sp)
ffffffffc0202e4a:	ec4e                	sd	s3,24(sp)
ffffffffc0202e4c:	e852                	sd	s4,16(sp)
ffffffffc0202e4e:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end)) {
ffffffffc0202e50:	002005b7          	lui	a1,0x200
ffffffffc0202e54:	00f67433          	and	s0,a2,a5
ffffffffc0202e58:	06b4e363          	bltu	s1,a1,ffffffffc0202ebe <mm_map+0x8c>
ffffffffc0202e5c:	0684f163          	bgeu	s1,s0,ffffffffc0202ebe <mm_map+0x8c>
ffffffffc0202e60:	4785                	li	a5,1
ffffffffc0202e62:	07fe                	slli	a5,a5,0x1f
ffffffffc0202e64:	0487ed63          	bltu	a5,s0,ffffffffc0202ebe <mm_map+0x8c>
ffffffffc0202e68:	89aa                	mv	s3,a0
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0202e6a:	cd21                	beqz	a0,ffffffffc0202ec2 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
ffffffffc0202e6c:	85a6                	mv	a1,s1
ffffffffc0202e6e:	8ab6                	mv	s5,a3
ffffffffc0202e70:	8a3a                	mv	s4,a4
ffffffffc0202e72:	e5fff0ef          	jal	ra,ffffffffc0202cd0 <find_vma>
ffffffffc0202e76:	c501                	beqz	a0,ffffffffc0202e7e <mm_map+0x4c>
ffffffffc0202e78:	651c                	ld	a5,8(a0)
ffffffffc0202e7a:	0487e263          	bltu	a5,s0,ffffffffc0202ebe <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202e7e:	03000513          	li	a0,48
ffffffffc0202e82:	b71fe0ef          	jal	ra,ffffffffc02019f2 <kmalloc>
ffffffffc0202e86:	892a                	mv	s2,a0
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0202e88:	5571                	li	a0,-4
    if (vma != NULL) {
ffffffffc0202e8a:	02090163          	beqz	s2,ffffffffc0202eac <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0202e8e:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0202e90:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0202e94:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0202e98:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0202e9c:	85ca                	mv	a1,s2
ffffffffc0202e9e:	e73ff0ef          	jal	ra,ffffffffc0202d10 <insert_vma_struct>
    if (vma_store != NULL) {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0202ea2:	4501                	li	a0,0
    if (vma_store != NULL) {
ffffffffc0202ea4:	000a0463          	beqz	s4,ffffffffc0202eac <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0202ea8:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_hello_out_size-0x8d80>

out:
    return ret;
}
ffffffffc0202eac:	70e2                	ld	ra,56(sp)
ffffffffc0202eae:	7442                	ld	s0,48(sp)
ffffffffc0202eb0:	74a2                	ld	s1,40(sp)
ffffffffc0202eb2:	7902                	ld	s2,32(sp)
ffffffffc0202eb4:	69e2                	ld	s3,24(sp)
ffffffffc0202eb6:	6a42                	ld	s4,16(sp)
ffffffffc0202eb8:	6aa2                	ld	s5,8(sp)
ffffffffc0202eba:	6121                	addi	sp,sp,64
ffffffffc0202ebc:	8082                	ret
        return -E_INVAL;
ffffffffc0202ebe:	5575                	li	a0,-3
ffffffffc0202ec0:	b7f5                	j	ffffffffc0202eac <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0202ec2:	00003697          	auipc	a3,0x3
ffffffffc0202ec6:	1de68693          	addi	a3,a3,478 # ffffffffc02060a0 <default_pmm_manager+0x5d0>
ffffffffc0202eca:	00002617          	auipc	a2,0x2
ffffffffc0202ece:	56e60613          	addi	a2,a2,1390 # ffffffffc0205438 <commands+0x448>
ffffffffc0202ed2:	0a700593          	li	a1,167
ffffffffc0202ed6:	00003517          	auipc	a0,0x3
ffffffffc0202eda:	14250513          	addi	a0,a0,322 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202ede:	d98fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202ee2 <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
ffffffffc0202ee2:	7139                	addi	sp,sp,-64
ffffffffc0202ee4:	fc06                	sd	ra,56(sp)
ffffffffc0202ee6:	f822                	sd	s0,48(sp)
ffffffffc0202ee8:	f426                	sd	s1,40(sp)
ffffffffc0202eea:	f04a                	sd	s2,32(sp)
ffffffffc0202eec:	ec4e                	sd	s3,24(sp)
ffffffffc0202eee:	e852                	sd	s4,16(sp)
ffffffffc0202ef0:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0202ef2:	c52d                	beqz	a0,ffffffffc0202f5c <dup_mmap+0x7a>
ffffffffc0202ef4:	892a                	mv	s2,a0
ffffffffc0202ef6:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0202ef8:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0202efa:	e595                	bnez	a1,ffffffffc0202f26 <dup_mmap+0x44>
ffffffffc0202efc:	a085                	j	ffffffffc0202f5c <dup_mmap+0x7a>
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        if (nvma == NULL) {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0202efe:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0202f00:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_rr_out_size+0x1f4f68>
        vma->vm_end = vm_end;
ffffffffc0202f04:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0202f08:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0202f0c:	e05ff0ef          	jal	ra,ffffffffc0202d10 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
ffffffffc0202f10:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_hello_out_size-0x8d90>
ffffffffc0202f14:	fe843603          	ld	a2,-24(s0)
ffffffffc0202f18:	6c8c                	ld	a1,24(s1)
ffffffffc0202f1a:	01893503          	ld	a0,24(s2)
ffffffffc0202f1e:	4701                	li	a4,0
ffffffffc0202f20:	c3aff0ef          	jal	ra,ffffffffc020235a <copy_range>
ffffffffc0202f24:	e105                	bnez	a0,ffffffffc0202f44 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0202f26:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list) {
ffffffffc0202f28:	02848863          	beq	s1,s0,ffffffffc0202f58 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f2c:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0202f30:	fe843a83          	ld	s5,-24(s0)
ffffffffc0202f34:	ff043a03          	ld	s4,-16(s0)
ffffffffc0202f38:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f3c:	ab7fe0ef          	jal	ra,ffffffffc02019f2 <kmalloc>
ffffffffc0202f40:	85aa                	mv	a1,a0
    if (vma != NULL) {
ffffffffc0202f42:	fd55                	bnez	a0,ffffffffc0202efe <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0202f44:	5571                	li	a0,-4
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0202f46:	70e2                	ld	ra,56(sp)
ffffffffc0202f48:	7442                	ld	s0,48(sp)
ffffffffc0202f4a:	74a2                	ld	s1,40(sp)
ffffffffc0202f4c:	7902                	ld	s2,32(sp)
ffffffffc0202f4e:	69e2                	ld	s3,24(sp)
ffffffffc0202f50:	6a42                	ld	s4,16(sp)
ffffffffc0202f52:	6aa2                	ld	s5,8(sp)
ffffffffc0202f54:	6121                	addi	sp,sp,64
ffffffffc0202f56:	8082                	ret
    return 0;
ffffffffc0202f58:	4501                	li	a0,0
ffffffffc0202f5a:	b7f5                	j	ffffffffc0202f46 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0202f5c:	00003697          	auipc	a3,0x3
ffffffffc0202f60:	15468693          	addi	a3,a3,340 # ffffffffc02060b0 <default_pmm_manager+0x5e0>
ffffffffc0202f64:	00002617          	auipc	a2,0x2
ffffffffc0202f68:	4d460613          	addi	a2,a2,1236 # ffffffffc0205438 <commands+0x448>
ffffffffc0202f6c:	0c000593          	li	a1,192
ffffffffc0202f70:	00003517          	auipc	a0,0x3
ffffffffc0202f74:	0a850513          	addi	a0,a0,168 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202f78:	cfefd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202f7c <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
ffffffffc0202f7c:	1101                	addi	sp,sp,-32
ffffffffc0202f7e:	ec06                	sd	ra,24(sp)
ffffffffc0202f80:	e822                	sd	s0,16(sp)
ffffffffc0202f82:	e426                	sd	s1,8(sp)
ffffffffc0202f84:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202f86:	c531                	beqz	a0,ffffffffc0202fd2 <exit_mmap+0x56>
ffffffffc0202f88:	591c                	lw	a5,48(a0)
ffffffffc0202f8a:	84aa                	mv	s1,a0
ffffffffc0202f8c:	e3b9                	bnez	a5,ffffffffc0202fd2 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0202f8e:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0202f90:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
ffffffffc0202f94:	02850663          	beq	a0,s0,ffffffffc0202fc0 <exit_mmap+0x44>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202f98:	ff043603          	ld	a2,-16(s0)
ffffffffc0202f9c:	fe843583          	ld	a1,-24(s0)
ffffffffc0202fa0:	854a                	mv	a0,s2
ffffffffc0202fa2:	846ff0ef          	jal	ra,ffffffffc0201fe8 <unmap_range>
ffffffffc0202fa6:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0202fa8:	fe8498e3          	bne	s1,s0,ffffffffc0202f98 <exit_mmap+0x1c>
ffffffffc0202fac:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list) {
ffffffffc0202fae:	00848c63          	beq	s1,s0,ffffffffc0202fc6 <exit_mmap+0x4a>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202fb2:	ff043603          	ld	a2,-16(s0)
ffffffffc0202fb6:	fe843583          	ld	a1,-24(s0)
ffffffffc0202fba:	854a                	mv	a0,s2
ffffffffc0202fbc:	972ff0ef          	jal	ra,ffffffffc020212e <exit_range>
ffffffffc0202fc0:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0202fc2:	fe8498e3          	bne	s1,s0,ffffffffc0202fb2 <exit_mmap+0x36>
    }
}
ffffffffc0202fc6:	60e2                	ld	ra,24(sp)
ffffffffc0202fc8:	6442                	ld	s0,16(sp)
ffffffffc0202fca:	64a2                	ld	s1,8(sp)
ffffffffc0202fcc:	6902                	ld	s2,0(sp)
ffffffffc0202fce:	6105                	addi	sp,sp,32
ffffffffc0202fd0:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202fd2:	00003697          	auipc	a3,0x3
ffffffffc0202fd6:	0fe68693          	addi	a3,a3,254 # ffffffffc02060d0 <default_pmm_manager+0x600>
ffffffffc0202fda:	00002617          	auipc	a2,0x2
ffffffffc0202fde:	45e60613          	addi	a2,a2,1118 # ffffffffc0205438 <commands+0x448>
ffffffffc0202fe2:	0d600593          	li	a1,214
ffffffffc0202fe6:	00003517          	auipc	a0,0x3
ffffffffc0202fea:	03250513          	addi	a0,a0,50 # ffffffffc0206018 <default_pmm_manager+0x548>
ffffffffc0202fee:	c88fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0202ff2 <vmm_init>:
// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
    //check_vmm();
}
ffffffffc0202ff2:	8082                	ret

ffffffffc0202ff4 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0202ff4:	7139                	addi	sp,sp,-64
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0202ff6:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0202ff8:	f822                	sd	s0,48(sp)
ffffffffc0202ffa:	f426                	sd	s1,40(sp)
ffffffffc0202ffc:	fc06                	sd	ra,56(sp)
ffffffffc0202ffe:	f04a                	sd	s2,32(sp)
ffffffffc0203000:	ec4e                	sd	s3,24(sp)
ffffffffc0203002:	8432                	mv	s0,a2
ffffffffc0203004:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203006:	ccbff0ef          	jal	ra,ffffffffc0202cd0 <find_vma>

    pgfault_num++;
ffffffffc020300a:	00032797          	auipc	a5,0x32
ffffffffc020300e:	d567a783          	lw	a5,-682(a5) # ffffffffc0234d60 <pgfault_num>
ffffffffc0203012:	2785                	addiw	a5,a5,1
ffffffffc0203014:	00032717          	auipc	a4,0x32
ffffffffc0203018:	d4f72623          	sw	a5,-692(a4) # ffffffffc0234d60 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc020301c:	c545                	beqz	a0,ffffffffc02030c4 <do_pgfault+0xd0>
ffffffffc020301e:	651c                	ld	a5,8(a0)
ffffffffc0203020:	0af46263          	bltu	s0,a5,ffffffffc02030c4 <do_pgfault+0xd0>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0203024:	4d1c                	lw	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0203026:	49c1                	li	s3,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0203028:	8b89                	andi	a5,a5,2
ffffffffc020302a:	efb1                	bnez	a5,ffffffffc0203086 <do_pgfault+0x92>
        perm |= READ_WRITE;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc020302c:	75fd                	lui	a1,0xfffff
    *   mm->pgdir : the PDT of these vma
    *
    */
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc020302e:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203030:	8c6d                	and	s0,s0,a1
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0203032:	4605                	li	a2,1
ffffffffc0203034:	85a2                	mv	a1,s0
ffffffffc0203036:	de1fe0ef          	jal	ra,ffffffffc0201e16 <get_pte>
ffffffffc020303a:	c555                	beqz	a0,ffffffffc02030e6 <do_pgfault+0xf2>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc020303c:	610c                	ld	a1,0(a0)
ffffffffc020303e:	c5a5                	beqz	a1,ffffffffc02030a6 <do_pgfault+0xb2>
            goto failed;
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
ffffffffc0203040:	00032797          	auipc	a5,0x32
ffffffffc0203044:	d107a783          	lw	a5,-752(a5) # ffffffffc0234d50 <swap_init_ok>
ffffffffc0203048:	c7d9                	beqz	a5,ffffffffc02030d6 <do_pgfault+0xe2>
            struct Page *page=NULL;
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc020304a:	0030                	addi	a2,sp,8
ffffffffc020304c:	85a2                	mv	a1,s0
ffffffffc020304e:	8526                	mv	a0,s1
            struct Page *page=NULL;
ffffffffc0203050:	e402                	sd	zero,8(sp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc0203052:	faaff0ef          	jal	ra,ffffffffc02027fc <swap_in>
ffffffffc0203056:	892a                	mv	s2,a0
ffffffffc0203058:	e90d                	bnez	a0,ffffffffc020308a <do_pgfault+0x96>
                cprintf("swap_in in do_pgfault failed\n");
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
ffffffffc020305a:	65a2                	ld	a1,8(sp)
ffffffffc020305c:	6c88                	ld	a0,24(s1)
ffffffffc020305e:	86ce                	mv	a3,s3
ffffffffc0203060:	8622                	mv	a2,s0
ffffffffc0203062:	a02ff0ef          	jal	ra,ffffffffc0202264 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
ffffffffc0203066:	6622                	ld	a2,8(sp)
ffffffffc0203068:	4685                	li	a3,1
ffffffffc020306a:	85a2                	mv	a1,s0
ffffffffc020306c:	8526                	mv	a0,s1
ffffffffc020306e:	e6eff0ef          	jal	ra,ffffffffc02026dc <swap_map_swappable>
            page->pra_vaddr = addr;
ffffffffc0203072:	67a2                	ld	a5,8(sp)
ffffffffc0203074:	ff80                	sd	s0,56(a5)
        }
   }
   ret = 0;
failed:
    return ret;
}
ffffffffc0203076:	70e2                	ld	ra,56(sp)
ffffffffc0203078:	7442                	ld	s0,48(sp)
ffffffffc020307a:	74a2                	ld	s1,40(sp)
ffffffffc020307c:	69e2                	ld	s3,24(sp)
ffffffffc020307e:	854a                	mv	a0,s2
ffffffffc0203080:	7902                	ld	s2,32(sp)
ffffffffc0203082:	6121                	addi	sp,sp,64
ffffffffc0203084:	8082                	ret
        perm |= READ_WRITE;
ffffffffc0203086:	49dd                	li	s3,23
ffffffffc0203088:	b755                	j	ffffffffc020302c <do_pgfault+0x38>
                cprintf("swap_in in do_pgfault failed\n");
ffffffffc020308a:	00003517          	auipc	a0,0x3
ffffffffc020308e:	0de50513          	addi	a0,a0,222 # ffffffffc0206168 <default_pmm_manager+0x698>
ffffffffc0203092:	8eafd0ef          	jal	ra,ffffffffc020017c <cprintf>
}
ffffffffc0203096:	70e2                	ld	ra,56(sp)
ffffffffc0203098:	7442                	ld	s0,48(sp)
ffffffffc020309a:	74a2                	ld	s1,40(sp)
ffffffffc020309c:	69e2                	ld	s3,24(sp)
ffffffffc020309e:	854a                	mv	a0,s2
ffffffffc02030a0:	7902                	ld	s2,32(sp)
ffffffffc02030a2:	6121                	addi	sp,sp,64
ffffffffc02030a4:	8082                	ret
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc02030a6:	6c88                	ld	a0,24(s1)
ffffffffc02030a8:	864e                	mv	a2,s3
ffffffffc02030aa:	85a2                	mv	a1,s0
ffffffffc02030ac:	ce4ff0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
   ret = 0;
ffffffffc02030b0:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc02030b2:	f171                	bnez	a0,ffffffffc0203076 <do_pgfault+0x82>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc02030b4:	00003517          	auipc	a0,0x3
ffffffffc02030b8:	08c50513          	addi	a0,a0,140 # ffffffffc0206140 <default_pmm_manager+0x670>
ffffffffc02030bc:	8c0fd0ef          	jal	ra,ffffffffc020017c <cprintf>
    ret = -E_NO_MEM;
ffffffffc02030c0:	5971                	li	s2,-4
            goto failed;
ffffffffc02030c2:	bf55                	j	ffffffffc0203076 <do_pgfault+0x82>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc02030c4:	85a2                	mv	a1,s0
ffffffffc02030c6:	00003517          	auipc	a0,0x3
ffffffffc02030ca:	02a50513          	addi	a0,a0,42 # ffffffffc02060f0 <default_pmm_manager+0x620>
ffffffffc02030ce:	8aefd0ef          	jal	ra,ffffffffc020017c <cprintf>
    int ret = -E_INVAL;
ffffffffc02030d2:	5975                	li	s2,-3
        goto failed;
ffffffffc02030d4:	b74d                	j	ffffffffc0203076 <do_pgfault+0x82>
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
ffffffffc02030d6:	00003517          	auipc	a0,0x3
ffffffffc02030da:	0b250513          	addi	a0,a0,178 # ffffffffc0206188 <default_pmm_manager+0x6b8>
ffffffffc02030de:	89efd0ef          	jal	ra,ffffffffc020017c <cprintf>
    ret = -E_NO_MEM;
ffffffffc02030e2:	5971                	li	s2,-4
            goto failed;
ffffffffc02030e4:	bf49                	j	ffffffffc0203076 <do_pgfault+0x82>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc02030e6:	00003517          	auipc	a0,0x3
ffffffffc02030ea:	03a50513          	addi	a0,a0,58 # ffffffffc0206120 <default_pmm_manager+0x650>
ffffffffc02030ee:	88efd0ef          	jal	ra,ffffffffc020017c <cprintf>
    ret = -E_NO_MEM;
ffffffffc02030f2:	5971                	li	s2,-4
        goto failed;
ffffffffc02030f4:	b749                	j	ffffffffc0203076 <do_pgfault+0x82>

ffffffffc02030f6 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
ffffffffc02030f6:	7179                	addi	sp,sp,-48
ffffffffc02030f8:	f022                	sd	s0,32(sp)
ffffffffc02030fa:	f406                	sd	ra,40(sp)
ffffffffc02030fc:	ec26                	sd	s1,24(sp)
ffffffffc02030fe:	e84a                	sd	s2,16(sp)
ffffffffc0203100:	e44e                	sd	s3,8(sp)
ffffffffc0203102:	e052                	sd	s4,0(sp)
ffffffffc0203104:	842e                	mv	s0,a1
    if (mm != NULL) {
ffffffffc0203106:	c135                	beqz	a0,ffffffffc020316a <user_mem_check+0x74>
        if (!USER_ACCESS(addr, addr + len)) {
ffffffffc0203108:	002007b7          	lui	a5,0x200
ffffffffc020310c:	04f5e663          	bltu	a1,a5,ffffffffc0203158 <user_mem_check+0x62>
ffffffffc0203110:	00c584b3          	add	s1,a1,a2
ffffffffc0203114:	0495f263          	bgeu	a1,s1,ffffffffc0203158 <user_mem_check+0x62>
ffffffffc0203118:	4785                	li	a5,1
ffffffffc020311a:	07fe                	slli	a5,a5,0x1f
ffffffffc020311c:	0297ee63          	bltu	a5,s1,ffffffffc0203158 <user_mem_check+0x62>
ffffffffc0203120:	892a                	mv	s2,a0
ffffffffc0203122:	89b6                	mv	s3,a3
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK)) {
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc0203124:	6a05                	lui	s4,0x1
ffffffffc0203126:	a821                	j	ffffffffc020313e <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc0203128:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc020312c:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc020312e:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc0203130:	c685                	beqz	a3,ffffffffc0203158 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc0203132:	c399                	beqz	a5,ffffffffc0203138 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc0203134:	02e46263          	bltu	s0,a4,ffffffffc0203158 <user_mem_check+0x62>
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203138:	6900                	ld	s0,16(a0)
        while (start < end) {
ffffffffc020313a:	04947663          	bgeu	s0,s1,ffffffffc0203186 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
ffffffffc020313e:	85a2                	mv	a1,s0
ffffffffc0203140:	854a                	mv	a0,s2
ffffffffc0203142:	b8fff0ef          	jal	ra,ffffffffc0202cd0 <find_vma>
ffffffffc0203146:	c909                	beqz	a0,ffffffffc0203158 <user_mem_check+0x62>
ffffffffc0203148:	6518                	ld	a4,8(a0)
ffffffffc020314a:	00e46763          	bltu	s0,a4,ffffffffc0203158 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc020314e:	4d1c                	lw	a5,24(a0)
ffffffffc0203150:	fc099ce3          	bnez	s3,ffffffffc0203128 <user_mem_check+0x32>
ffffffffc0203154:	8b85                	andi	a5,a5,1
ffffffffc0203156:	f3ed                	bnez	a5,ffffffffc0203138 <user_mem_check+0x42>
            return 0;
ffffffffc0203158:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc020315a:	70a2                	ld	ra,40(sp)
ffffffffc020315c:	7402                	ld	s0,32(sp)
ffffffffc020315e:	64e2                	ld	s1,24(sp)
ffffffffc0203160:	6942                	ld	s2,16(sp)
ffffffffc0203162:	69a2                	ld	s3,8(sp)
ffffffffc0203164:	6a02                	ld	s4,0(sp)
ffffffffc0203166:	6145                	addi	sp,sp,48
ffffffffc0203168:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc020316a:	c02007b7          	lui	a5,0xc0200
ffffffffc020316e:	4501                	li	a0,0
ffffffffc0203170:	fef5e5e3          	bltu	a1,a5,ffffffffc020315a <user_mem_check+0x64>
ffffffffc0203174:	962e                	add	a2,a2,a1
ffffffffc0203176:	fec5f2e3          	bgeu	a1,a2,ffffffffc020315a <user_mem_check+0x64>
ffffffffc020317a:	c8000537          	lui	a0,0xc8000
ffffffffc020317e:	0505                	addi	a0,a0,1
ffffffffc0203180:	00a63533          	sltu	a0,a2,a0
ffffffffc0203184:	bfd9                	j	ffffffffc020315a <user_mem_check+0x64>
        return 1;
ffffffffc0203186:	4505                	li	a0,1
ffffffffc0203188:	bfc9                	j	ffffffffc020315a <user_mem_check+0x64>

ffffffffc020318a <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc020318a:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc020318c:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc020318e:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203190:	c4efd0ef          	jal	ra,ffffffffc02005de <ide_device_valid>
ffffffffc0203194:	cd01                	beqz	a0,ffffffffc02031ac <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203196:	4505                	li	a0,1
ffffffffc0203198:	c4cfd0ef          	jal	ra,ffffffffc02005e4 <ide_device_size>
}
ffffffffc020319c:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc020319e:	810d                	srli	a0,a0,0x3
ffffffffc02031a0:	00032797          	auipc	a5,0x32
ffffffffc02031a4:	baa7b023          	sd	a0,-1120(a5) # ffffffffc0234d40 <max_swap_offset>
}
ffffffffc02031a8:	0141                	addi	sp,sp,16
ffffffffc02031aa:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc02031ac:	00003617          	auipc	a2,0x3
ffffffffc02031b0:	00460613          	addi	a2,a2,4 # ffffffffc02061b0 <default_pmm_manager+0x6e0>
ffffffffc02031b4:	45b5                	li	a1,13
ffffffffc02031b6:	00003517          	auipc	a0,0x3
ffffffffc02031ba:	01a50513          	addi	a0,a0,26 # ffffffffc02061d0 <default_pmm_manager+0x700>
ffffffffc02031be:	ab8fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02031c2 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc02031c2:	1141                	addi	sp,sp,-16
ffffffffc02031c4:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02031c6:	00855793          	srli	a5,a0,0x8
ffffffffc02031ca:	cbb1                	beqz	a5,ffffffffc020321e <swapfs_read+0x5c>
ffffffffc02031cc:	00032717          	auipc	a4,0x32
ffffffffc02031d0:	b7473703          	ld	a4,-1164(a4) # ffffffffc0234d40 <max_swap_offset>
ffffffffc02031d4:	04e7f563          	bgeu	a5,a4,ffffffffc020321e <swapfs_read+0x5c>
    return page - pages + nbase;
ffffffffc02031d8:	00032617          	auipc	a2,0x32
ffffffffc02031dc:	b5063603          	ld	a2,-1200(a2) # ffffffffc0234d28 <pages>
ffffffffc02031e0:	8d91                	sub	a1,a1,a2
ffffffffc02031e2:	4065d613          	srai	a2,a1,0x6
ffffffffc02031e6:	00004717          	auipc	a4,0x4
ffffffffc02031ea:	9ca73703          	ld	a4,-1590(a4) # ffffffffc0206bb0 <nbase>
ffffffffc02031ee:	963a                	add	a2,a2,a4
    return KADDR(page2pa(page));
ffffffffc02031f0:	00c61713          	slli	a4,a2,0xc
ffffffffc02031f4:	8331                	srli	a4,a4,0xc
ffffffffc02031f6:	00032697          	auipc	a3,0x32
ffffffffc02031fa:	b2a6b683          	ld	a3,-1238(a3) # ffffffffc0234d20 <npage>
ffffffffc02031fe:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203202:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0203204:	02d77963          	bgeu	a4,a3,ffffffffc0203236 <swapfs_read+0x74>
}
ffffffffc0203208:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020320a:	00032797          	auipc	a5,0x32
ffffffffc020320e:	b2e7b783          	ld	a5,-1234(a5) # ffffffffc0234d38 <va_pa_offset>
ffffffffc0203212:	46a1                	li	a3,8
ffffffffc0203214:	963e                	add	a2,a2,a5
ffffffffc0203216:	4505                	li	a0,1
}
ffffffffc0203218:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020321a:	bd0fd06f          	j	ffffffffc02005ea <ide_read_secs>
ffffffffc020321e:	86aa                	mv	a3,a0
ffffffffc0203220:	00003617          	auipc	a2,0x3
ffffffffc0203224:	fc860613          	addi	a2,a2,-56 # ffffffffc02061e8 <default_pmm_manager+0x718>
ffffffffc0203228:	45d1                	li	a1,20
ffffffffc020322a:	00003517          	auipc	a0,0x3
ffffffffc020322e:	fa650513          	addi	a0,a0,-90 # ffffffffc02061d0 <default_pmm_manager+0x700>
ffffffffc0203232:	a44fd0ef          	jal	ra,ffffffffc0200476 <__panic>
ffffffffc0203236:	86b2                	mv	a3,a2
ffffffffc0203238:	06900593          	li	a1,105
ffffffffc020323c:	00003617          	auipc	a2,0x3
ffffffffc0203240:	8cc60613          	addi	a2,a2,-1844 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc0203244:	00003517          	auipc	a0,0x3
ffffffffc0203248:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc020324c:	a2afd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0203250 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203250:	1141                	addi	sp,sp,-16
ffffffffc0203252:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203254:	00855793          	srli	a5,a0,0x8
ffffffffc0203258:	cbb1                	beqz	a5,ffffffffc02032ac <swapfs_write+0x5c>
ffffffffc020325a:	00032717          	auipc	a4,0x32
ffffffffc020325e:	ae673703          	ld	a4,-1306(a4) # ffffffffc0234d40 <max_swap_offset>
ffffffffc0203262:	04e7f563          	bgeu	a5,a4,ffffffffc02032ac <swapfs_write+0x5c>
    return page - pages + nbase;
ffffffffc0203266:	00032617          	auipc	a2,0x32
ffffffffc020326a:	ac263603          	ld	a2,-1342(a2) # ffffffffc0234d28 <pages>
ffffffffc020326e:	8d91                	sub	a1,a1,a2
ffffffffc0203270:	4065d613          	srai	a2,a1,0x6
ffffffffc0203274:	00004717          	auipc	a4,0x4
ffffffffc0203278:	93c73703          	ld	a4,-1732(a4) # ffffffffc0206bb0 <nbase>
ffffffffc020327c:	963a                	add	a2,a2,a4
    return KADDR(page2pa(page));
ffffffffc020327e:	00c61713          	slli	a4,a2,0xc
ffffffffc0203282:	8331                	srli	a4,a4,0xc
ffffffffc0203284:	00032697          	auipc	a3,0x32
ffffffffc0203288:	a9c6b683          	ld	a3,-1380(a3) # ffffffffc0234d20 <npage>
ffffffffc020328c:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203290:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0203292:	02d77963          	bgeu	a4,a3,ffffffffc02032c4 <swapfs_write+0x74>
}
ffffffffc0203296:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203298:	00032797          	auipc	a5,0x32
ffffffffc020329c:	aa07b783          	ld	a5,-1376(a5) # ffffffffc0234d38 <va_pa_offset>
ffffffffc02032a0:	46a1                	li	a3,8
ffffffffc02032a2:	963e                	add	a2,a2,a5
ffffffffc02032a4:	4505                	li	a0,1
}
ffffffffc02032a6:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02032a8:	b66fd06f          	j	ffffffffc020060e <ide_write_secs>
ffffffffc02032ac:	86aa                	mv	a3,a0
ffffffffc02032ae:	00003617          	auipc	a2,0x3
ffffffffc02032b2:	f3a60613          	addi	a2,a2,-198 # ffffffffc02061e8 <default_pmm_manager+0x718>
ffffffffc02032b6:	45e5                	li	a1,25
ffffffffc02032b8:	00003517          	auipc	a0,0x3
ffffffffc02032bc:	f1850513          	addi	a0,a0,-232 # ffffffffc02061d0 <default_pmm_manager+0x700>
ffffffffc02032c0:	9b6fd0ef          	jal	ra,ffffffffc0200476 <__panic>
ffffffffc02032c4:	86b2                	mv	a3,a2
ffffffffc02032c6:	06900593          	li	a1,105
ffffffffc02032ca:	00003617          	auipc	a2,0x3
ffffffffc02032ce:	83e60613          	addi	a2,a2,-1986 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc02032d2:	00003517          	auipc	a0,0x3
ffffffffc02032d6:	85e50513          	addi	a0,a0,-1954 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc02032da:	99cfd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02032de <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc02032de:	8526                	mv	a0,s1
	jalr s0
ffffffffc02032e0:	9402                	jalr	s0

	jal do_exit
ffffffffc02032e2:	654000ef          	jal	ra,ffffffffc0203936 <do_exit>

ffffffffc02032e6 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc02032e6:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02032e8:	14800513          	li	a0,328
alloc_proc(void) {
ffffffffc02032ec:	e022                	sd	s0,0(sp)
ffffffffc02032ee:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02032f0:	f02fe0ef          	jal	ra,ffffffffc02019f2 <kmalloc>
ffffffffc02032f4:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc02032f6:	c535                	beqz	a0,ffffffffc0203362 <alloc_proc+0x7c>
        proc->state = PROC_UNINIT;
ffffffffc02032f8:	57fd                	li	a5,-1
ffffffffc02032fa:	1782                	slli	a5,a5,0x20
ffffffffc02032fc:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02032fe:	07000613          	li	a2,112
ffffffffc0203302:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203304:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203308:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc020330c:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203310:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203314:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203318:	03050513          	addi	a0,a0,48
ffffffffc020331c:	24b010ef          	jal	ra,ffffffffc0204d66 <memset>
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
ffffffffc0203320:	00032797          	auipc	a5,0x32
ffffffffc0203324:	9f07b783          	ld	a5,-1552(a5) # ffffffffc0234d10 <boot_cr3>
        proc->tf = NULL;
ffffffffc0203328:	0a043023          	sd	zero,160(s0)
        proc->cr3 = boot_cr3;
ffffffffc020332c:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc020332e:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN);
ffffffffc0203332:	463d                	li	a2,15
ffffffffc0203334:	4581                	li	a1,0
ffffffffc0203336:	0b440513          	addi	a0,s0,180
ffffffffc020333a:	22d010ef          	jal	ra,ffffffffc0204d66 <memset>
        proc->wait_state = 0;
ffffffffc020333e:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->optr = proc->yptr = NULL;
ffffffffc0203342:	0e043c23          	sd	zero,248(s0)
ffffffffc0203346:	10043023          	sd	zero,256(s0)
ffffffffc020334a:	0e043823          	sd	zero,240(s0)
        proc->time_slice = 0;
ffffffffc020334e:	12042023          	sw	zero,288(s0)
        proc->labschedule_run_pool.left = proc->labschedule_run_pool.right = proc->labschedule_run_pool.parent = NULL;
ffffffffc0203352:	12043423          	sd	zero,296(s0)
ffffffffc0203356:	12043823          	sd	zero,304(s0)
ffffffffc020335a:	12043c23          	sd	zero,312(s0)
        proc->labschedule_stride = 0;
ffffffffc020335e:	14043023          	sd	zero,320(s0)
        proc->labschedule_priority = 0;
    }
    return proc;
}
ffffffffc0203362:	60a2                	ld	ra,8(sp)
ffffffffc0203364:	8522                	mv	a0,s0
ffffffffc0203366:	6402                	ld	s0,0(sp)
ffffffffc0203368:	0141                	addi	sp,sp,16
ffffffffc020336a:	8082                	ret

ffffffffc020336c <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc020336c:	00032797          	auipc	a5,0x32
ffffffffc0203370:	9fc7b783          	ld	a5,-1540(a5) # ffffffffc0234d68 <current>
ffffffffc0203374:	73c8                	ld	a0,160(a5)
ffffffffc0203376:	9c1fd06f          	j	ffffffffc0200d36 <forkrets>

ffffffffc020337a <user_main>:
static int
user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(rr);
ffffffffc020337a:	00032797          	auipc	a5,0x32
ffffffffc020337e:	9ee7b783          	ld	a5,-1554(a5) # ffffffffc0234d68 <current>
ffffffffc0203382:	43cc                	lw	a1,4(a5)
user_main(void *arg) {
ffffffffc0203384:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE(rr);
ffffffffc0203386:	00003617          	auipc	a2,0x3
ffffffffc020338a:	e8260613          	addi	a2,a2,-382 # ffffffffc0206208 <default_pmm_manager+0x738>
ffffffffc020338e:	00003517          	auipc	a0,0x3
ffffffffc0203392:	e8250513          	addi	a0,a0,-382 # ffffffffc0206210 <default_pmm_manager+0x740>
user_main(void *arg) {
ffffffffc0203396:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(rr);
ffffffffc0203398:	de5fc0ef          	jal	ra,ffffffffc020017c <cprintf>
ffffffffc020339c:	3fe08797          	auipc	a5,0x3fe08
ffffffffc02033a0:	d0478793          	addi	a5,a5,-764 # b0a0 <_binary_obj___user_rr_out_size>
ffffffffc02033a4:	e43e                	sd	a5,8(sp)
ffffffffc02033a6:	00003517          	auipc	a0,0x3
ffffffffc02033aa:	e6250513          	addi	a0,a0,-414 # ffffffffc0206208 <default_pmm_manager+0x738>
ffffffffc02033ae:	0001b797          	auipc	a5,0x1b
ffffffffc02033b2:	3b278793          	addi	a5,a5,946 # ffffffffc021e760 <_binary_obj___user_rr_out_start>
ffffffffc02033b6:	f03e                	sd	a5,32(sp)
ffffffffc02033b8:	f42a                	sd	a0,40(sp)
    int64_t ret=0, len = strlen(name);
ffffffffc02033ba:	e802                	sd	zero,16(sp)
ffffffffc02033bc:	141010ef          	jal	ra,ffffffffc0204cfc <strlen>
ffffffffc02033c0:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc02033c2:	4511                	li	a0,4
ffffffffc02033c4:	55a2                	lw	a1,40(sp)
ffffffffc02033c6:	4662                	lw	a2,24(sp)
ffffffffc02033c8:	5682                	lw	a3,32(sp)
ffffffffc02033ca:	4722                	lw	a4,8(sp)
ffffffffc02033cc:	48a9                	li	a7,10
ffffffffc02033ce:	9002                	ebreak
ffffffffc02033d0:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02033d2:	65c2                	ld	a1,16(sp)
ffffffffc02033d4:	00003517          	auipc	a0,0x3
ffffffffc02033d8:	e6450513          	addi	a0,a0,-412 # ffffffffc0206238 <default_pmm_manager+0x768>
ffffffffc02033dc:	da1fc0ef          	jal	ra,ffffffffc020017c <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc02033e0:	00003617          	auipc	a2,0x3
ffffffffc02033e4:	e6860613          	addi	a2,a2,-408 # ffffffffc0206248 <default_pmm_manager+0x778>
ffffffffc02033e8:	30700593          	li	a1,775
ffffffffc02033ec:	00003517          	auipc	a0,0x3
ffffffffc02033f0:	e7c50513          	addi	a0,a0,-388 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc02033f4:	882fd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02033f8 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc02033f8:	6d14                	ld	a3,24(a0)
put_pgdir(struct mm_struct *mm) {
ffffffffc02033fa:	1141                	addi	sp,sp,-16
ffffffffc02033fc:	e406                	sd	ra,8(sp)
ffffffffc02033fe:	c02007b7          	lui	a5,0xc0200
ffffffffc0203402:	02f6ee63          	bltu	a3,a5,ffffffffc020343e <put_pgdir+0x46>
ffffffffc0203406:	00032517          	auipc	a0,0x32
ffffffffc020340a:	93253503          	ld	a0,-1742(a0) # ffffffffc0234d38 <va_pa_offset>
ffffffffc020340e:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage) {
ffffffffc0203410:	82b1                	srli	a3,a3,0xc
ffffffffc0203412:	00032797          	auipc	a5,0x32
ffffffffc0203416:	90e7b783          	ld	a5,-1778(a5) # ffffffffc0234d20 <npage>
ffffffffc020341a:	02f6fe63          	bgeu	a3,a5,ffffffffc0203456 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc020341e:	00003517          	auipc	a0,0x3
ffffffffc0203422:	79253503          	ld	a0,1938(a0) # ffffffffc0206bb0 <nbase>
}
ffffffffc0203426:	60a2                	ld	ra,8(sp)
ffffffffc0203428:	8e89                	sub	a3,a3,a0
ffffffffc020342a:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc020342c:	00032517          	auipc	a0,0x32
ffffffffc0203430:	8fc53503          	ld	a0,-1796(a0) # ffffffffc0234d28 <pages>
ffffffffc0203434:	4585                	li	a1,1
ffffffffc0203436:	9536                	add	a0,a0,a3
}
ffffffffc0203438:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc020343a:	80dfe06f          	j	ffffffffc0201c46 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc020343e:	00002617          	auipc	a2,0x2
ffffffffc0203442:	73a60613          	addi	a2,a2,1850 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc0203446:	06e00593          	li	a1,110
ffffffffc020344a:	00002517          	auipc	a0,0x2
ffffffffc020344e:	6e650513          	addi	a0,a0,1766 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0203452:	824fd0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203456:	00002617          	auipc	a2,0x2
ffffffffc020345a:	74a60613          	addi	a2,a2,1866 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc020345e:	06200593          	li	a1,98
ffffffffc0203462:	00002517          	auipc	a0,0x2
ffffffffc0203466:	6ce50513          	addi	a0,a0,1742 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc020346a:	80cfd0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc020346e <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc020346e:	7179                	addi	sp,sp,-48
ffffffffc0203470:	ec4a                	sd	s2,24(sp)
    if (proc != current) {
ffffffffc0203472:	00032917          	auipc	s2,0x32
ffffffffc0203476:	8f690913          	addi	s2,s2,-1802 # ffffffffc0234d68 <current>
proc_run(struct proc_struct *proc) {
ffffffffc020347a:	f026                	sd	s1,32(sp)
    if (proc != current) {
ffffffffc020347c:	00093483          	ld	s1,0(s2)
proc_run(struct proc_struct *proc) {
ffffffffc0203480:	f406                	sd	ra,40(sp)
ffffffffc0203482:	e84e                	sd	s3,16(sp)
    if (proc != current) {
ffffffffc0203484:	02a48863          	beq	s1,a0,ffffffffc02034b4 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203488:	100027f3          	csrr	a5,sstatus
ffffffffc020348c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020348e:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203490:	ef9d                	bnez	a5,ffffffffc02034ce <proc_run+0x60>

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned long cr3) {
    write_csr(satp, 0x8000000000000000 | (cr3 >> RISCV_PGSHIFT));
ffffffffc0203492:	755c                	ld	a5,168(a0)
ffffffffc0203494:	577d                	li	a4,-1
ffffffffc0203496:	177e                	slli	a4,a4,0x3f
ffffffffc0203498:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc020349a:	00a93023          	sd	a0,0(s2)
ffffffffc020349e:	8fd9                	or	a5,a5,a4
ffffffffc02034a0:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc02034a4:	03050593          	addi	a1,a0,48
ffffffffc02034a8:	03048513          	addi	a0,s1,48
ffffffffc02034ac:	052010ef          	jal	ra,ffffffffc02044fe <switch_to>
    if (flag) {
ffffffffc02034b0:	00099863          	bnez	s3,ffffffffc02034c0 <proc_run+0x52>
}
ffffffffc02034b4:	70a2                	ld	ra,40(sp)
ffffffffc02034b6:	7482                	ld	s1,32(sp)
ffffffffc02034b8:	6962                	ld	s2,24(sp)
ffffffffc02034ba:	69c2                	ld	s3,16(sp)
ffffffffc02034bc:	6145                	addi	sp,sp,48
ffffffffc02034be:	8082                	ret
ffffffffc02034c0:	70a2                	ld	ra,40(sp)
ffffffffc02034c2:	7482                	ld	s1,32(sp)
ffffffffc02034c4:	6962                	ld	s2,24(sp)
ffffffffc02034c6:	69c2                	ld	s3,16(sp)
ffffffffc02034c8:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02034ca:	968fd06f          	j	ffffffffc0200632 <intr_enable>
ffffffffc02034ce:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02034d0:	968fd0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc02034d4:	6522                	ld	a0,8(sp)
ffffffffc02034d6:	4985                	li	s3,1
ffffffffc02034d8:	bf6d                	j	ffffffffc0203492 <proc_run+0x24>

ffffffffc02034da <do_fork>:
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc02034da:	7119                	addi	sp,sp,-128
ffffffffc02034dc:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc02034de:	00032917          	auipc	s2,0x32
ffffffffc02034e2:	8a290913          	addi	s2,s2,-1886 # ffffffffc0234d80 <nr_process>
ffffffffc02034e6:	00092703          	lw	a4,0(s2)
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc02034ea:	fc86                	sd	ra,120(sp)
ffffffffc02034ec:	f8a2                	sd	s0,112(sp)
ffffffffc02034ee:	f4a6                	sd	s1,104(sp)
ffffffffc02034f0:	ecce                	sd	s3,88(sp)
ffffffffc02034f2:	e8d2                	sd	s4,80(sp)
ffffffffc02034f4:	e4d6                	sd	s5,72(sp)
ffffffffc02034f6:	e0da                	sd	s6,64(sp)
ffffffffc02034f8:	fc5e                	sd	s7,56(sp)
ffffffffc02034fa:	f862                	sd	s8,48(sp)
ffffffffc02034fc:	f466                	sd	s9,40(sp)
ffffffffc02034fe:	f06a                	sd	s10,32(sp)
ffffffffc0203500:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0203502:	6785                	lui	a5,0x1
ffffffffc0203504:	32f75f63          	bge	a4,a5,ffffffffc0203842 <do_fork+0x368>
ffffffffc0203508:	8a2a                	mv	s4,a0
ffffffffc020350a:	89ae                	mv	s3,a1
ffffffffc020350c:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc020350e:	dd9ff0ef          	jal	ra,ffffffffc02032e6 <alloc_proc>
ffffffffc0203512:	84aa                	mv	s1,a0
ffffffffc0203514:	30050863          	beqz	a0,ffffffffc0203824 <do_fork+0x34a>
    proc->parent = current;
ffffffffc0203518:	00032c17          	auipc	s8,0x32
ffffffffc020351c:	850c0c13          	addi	s8,s8,-1968 # ffffffffc0234d68 <current>
ffffffffc0203520:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state == 0);
ffffffffc0203524:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_hello_out_size-0x8c94>
    proc->parent = current;
ffffffffc0203528:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc020352a:	32071163          	bnez	a4,ffffffffc020384c <do_fork+0x372>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020352e:	4509                	li	a0,2
ffffffffc0203530:	e84fe0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
    if (page != NULL) {
ffffffffc0203534:	2e050563          	beqz	a0,ffffffffc020381e <do_fork+0x344>
    return page - pages + nbase;
ffffffffc0203538:	00031a97          	auipc	s5,0x31
ffffffffc020353c:	7f0a8a93          	addi	s5,s5,2032 # ffffffffc0234d28 <pages>
ffffffffc0203540:	000ab683          	ld	a3,0(s5)
ffffffffc0203544:	00003b17          	auipc	s6,0x3
ffffffffc0203548:	66cb0b13          	addi	s6,s6,1644 # ffffffffc0206bb0 <nbase>
ffffffffc020354c:	000b3783          	ld	a5,0(s6)
ffffffffc0203550:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0203554:	00031b97          	auipc	s7,0x31
ffffffffc0203558:	7ccb8b93          	addi	s7,s7,1996 # ffffffffc0234d20 <npage>
    return page - pages + nbase;
ffffffffc020355c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020355e:	5dfd                	li	s11,-1
ffffffffc0203560:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0203564:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203566:	00cddd93          	srli	s11,s11,0xc
ffffffffc020356a:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020356e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203570:	2ee67e63          	bgeu	a2,a4,ffffffffc020386c <do_fork+0x392>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203574:	000c3603          	ld	a2,0(s8)
ffffffffc0203578:	00031c17          	auipc	s8,0x31
ffffffffc020357c:	7c0c0c13          	addi	s8,s8,1984 # ffffffffc0234d38 <va_pa_offset>
ffffffffc0203580:	000c3703          	ld	a4,0(s8)
ffffffffc0203584:	02863d03          	ld	s10,40(a2)
ffffffffc0203588:	e43e                	sd	a5,8(sp)
ffffffffc020358a:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020358c:	e894                	sd	a3,16(s1)
    if (oldmm == NULL) {
ffffffffc020358e:	020d0863          	beqz	s10,ffffffffc02035be <do_fork+0xe4>
    if (clone_flags & CLONE_VM) {
ffffffffc0203592:	100a7a13          	andi	s4,s4,256
ffffffffc0203596:	1c0a0563          	beqz	s4,ffffffffc0203760 <do_fork+0x286>
}

static inline int
mm_count_inc(struct mm_struct *mm) {
    mm->mm_count += 1;
ffffffffc020359a:	030d2703          	lw	a4,48(s10)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc020359e:	018d3783          	ld	a5,24(s10)
ffffffffc02035a2:	c02006b7          	lui	a3,0xc0200
ffffffffc02035a6:	2705                	addiw	a4,a4,1
ffffffffc02035a8:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc02035ac:	03a4b423          	sd	s10,40(s1)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc02035b0:	2ed7e663          	bltu	a5,a3,ffffffffc020389c <do_fork+0x3c2>
ffffffffc02035b4:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02035b8:	6894                	ld	a3,16(s1)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc02035ba:	8f99                	sub	a5,a5,a4
ffffffffc02035bc:	f4dc                	sd	a5,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02035be:	6709                	lui	a4,0x2
ffffffffc02035c0:	ee070713          	addi	a4,a4,-288 # 1ee0 <_binary_obj___user_hello_out_size-0x7ea0>
ffffffffc02035c4:	9736                	add	a4,a4,a3
    *(proc->tf) = *tf;
ffffffffc02035c6:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02035c8:	f0d8                	sd	a4,160(s1)
    *(proc->tf) = *tf;
ffffffffc02035ca:	87ba                	mv	a5,a4
ffffffffc02035cc:	12040313          	addi	t1,s0,288
ffffffffc02035d0:	00063883          	ld	a7,0(a2)
ffffffffc02035d4:	00863803          	ld	a6,8(a2)
ffffffffc02035d8:	6a08                	ld	a0,16(a2)
ffffffffc02035da:	6e0c                	ld	a1,24(a2)
ffffffffc02035dc:	0117b023          	sd	a7,0(a5)
ffffffffc02035e0:	0107b423          	sd	a6,8(a5)
ffffffffc02035e4:	eb88                	sd	a0,16(a5)
ffffffffc02035e6:	ef8c                	sd	a1,24(a5)
ffffffffc02035e8:	02060613          	addi	a2,a2,32
ffffffffc02035ec:	02078793          	addi	a5,a5,32
ffffffffc02035f0:	fe6610e3          	bne	a2,t1,ffffffffc02035d0 <do_fork+0xf6>
    proc->tf->gpr.a0 = 0;
ffffffffc02035f4:	04073823          	sd	zero,80(a4)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf - 4 : esp;
ffffffffc02035f8:	12098e63          	beqz	s3,ffffffffc0203734 <do_fork+0x25a>
ffffffffc02035fc:	01373823          	sd	s3,16(a4)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203600:	00000797          	auipc	a5,0x0
ffffffffc0203604:	d6c78793          	addi	a5,a5,-660 # ffffffffc020336c <forkret>
ffffffffc0203608:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020360a:	fc98                	sd	a4,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020360c:	100027f3          	csrr	a5,sstatus
ffffffffc0203610:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203612:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203614:	14079263          	bnez	a5,ffffffffc0203758 <do_fork+0x27e>
    if (++ last_pid >= MAX_PID) {
ffffffffc0203618:	00026817          	auipc	a6,0x26
ffffffffc020361c:	27080813          	addi	a6,a6,624 # ffffffffc0229888 <last_pid.1>
ffffffffc0203620:	00082783          	lw	a5,0(a6)
ffffffffc0203624:	6709                	lui	a4,0x2
ffffffffc0203626:	0017851b          	addiw	a0,a5,1
ffffffffc020362a:	00a82023          	sw	a0,0(a6)
ffffffffc020362e:	08e55c63          	bge	a0,a4,ffffffffc02036c6 <do_fork+0x1ec>
    if (last_pid >= next_safe) {
ffffffffc0203632:	00026317          	auipc	t1,0x26
ffffffffc0203636:	25a30313          	addi	t1,t1,602 # ffffffffc022988c <next_safe.0>
ffffffffc020363a:	00032783          	lw	a5,0(t1)
ffffffffc020363e:	00031417          	auipc	s0,0x31
ffffffffc0203642:	67a40413          	addi	s0,s0,1658 # ffffffffc0234cb8 <proc_list>
ffffffffc0203646:	08f55863          	bge	a0,a5,ffffffffc02036d6 <do_fork+0x1fc>
        proc->pid = get_pid();
ffffffffc020364a:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020364c:	45a9                	li	a1,10
ffffffffc020364e:	2501                	sext.w	a0,a0
ffffffffc0203650:	2a8010ef          	jal	ra,ffffffffc02048f8 <hash32>
ffffffffc0203654:	02051793          	slli	a5,a0,0x20
ffffffffc0203658:	0002d717          	auipc	a4,0x2d
ffffffffc020365c:	66070713          	addi	a4,a4,1632 # ffffffffc0230cb8 <hash_list>
ffffffffc0203660:	83f1                	srli	a5,a5,0x1c
ffffffffc0203662:	97ba                	add	a5,a5,a4
    __list_add(elm, listelm, listelm->next);
ffffffffc0203664:	6788                	ld	a0,8(a5)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc0203666:	7090                	ld	a2,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203668:	0d848713          	addi	a4,s1,216
    prev->next = next->prev = elm;
ffffffffc020366c:	e118                	sd	a4,0(a0)
    __list_add(elm, listelm, listelm->next);
ffffffffc020366e:	640c                	ld	a1,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203670:	e798                	sd	a4,8(a5)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc0203672:	7a74                	ld	a3,240(a2)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0203674:	0c848713          	addi	a4,s1,200
    elm->next = next;
ffffffffc0203678:	f0e8                	sd	a0,224(s1)
    elm->prev = prev;
ffffffffc020367a:	ecfc                	sd	a5,216(s1)
    prev->next = next->prev = elm;
ffffffffc020367c:	e198                	sd	a4,0(a1)
ffffffffc020367e:	e418                	sd	a4,8(s0)
    elm->next = next;
ffffffffc0203680:	e8ec                	sd	a1,208(s1)
    elm->prev = prev;
ffffffffc0203682:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0203684:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc0203688:	10d4b023          	sd	a3,256(s1)
ffffffffc020368c:	c291                	beqz	a3,ffffffffc0203690 <do_fork+0x1b6>
        proc->optr->yptr = proc;
ffffffffc020368e:	fee4                	sd	s1,248(a3)
    nr_process ++;
ffffffffc0203690:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0203694:	fa64                	sd	s1,240(a2)
    nr_process ++;
ffffffffc0203696:	2785                	addiw	a5,a5,1
ffffffffc0203698:	00f92023          	sw	a5,0(s2)
    if (flag) {
ffffffffc020369c:	18099663          	bnez	s3,ffffffffc0203828 <do_fork+0x34e>
    wakeup_proc(proc);
ffffffffc02036a0:	8526                	mv	a0,s1
ffffffffc02036a2:	7ef000ef          	jal	ra,ffffffffc0204690 <wakeup_proc>
    ret = proc->pid;
ffffffffc02036a6:	40c8                	lw	a0,4(s1)
}
ffffffffc02036a8:	70e6                	ld	ra,120(sp)
ffffffffc02036aa:	7446                	ld	s0,112(sp)
ffffffffc02036ac:	74a6                	ld	s1,104(sp)
ffffffffc02036ae:	7906                	ld	s2,96(sp)
ffffffffc02036b0:	69e6                	ld	s3,88(sp)
ffffffffc02036b2:	6a46                	ld	s4,80(sp)
ffffffffc02036b4:	6aa6                	ld	s5,72(sp)
ffffffffc02036b6:	6b06                	ld	s6,64(sp)
ffffffffc02036b8:	7be2                	ld	s7,56(sp)
ffffffffc02036ba:	7c42                	ld	s8,48(sp)
ffffffffc02036bc:	7ca2                	ld	s9,40(sp)
ffffffffc02036be:	7d02                	ld	s10,32(sp)
ffffffffc02036c0:	6de2                	ld	s11,24(sp)
ffffffffc02036c2:	6109                	addi	sp,sp,128
ffffffffc02036c4:	8082                	ret
        last_pid = 1;
ffffffffc02036c6:	4785                	li	a5,1
ffffffffc02036c8:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02036cc:	4505                	li	a0,1
ffffffffc02036ce:	00026317          	auipc	t1,0x26
ffffffffc02036d2:	1be30313          	addi	t1,t1,446 # ffffffffc022988c <next_safe.0>
    return listelm->next;
ffffffffc02036d6:	00031417          	auipc	s0,0x31
ffffffffc02036da:	5e240413          	addi	s0,s0,1506 # ffffffffc0234cb8 <proc_list>
ffffffffc02036de:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02036e2:	6789                	lui	a5,0x2
ffffffffc02036e4:	00f32023          	sw	a5,0(t1)
ffffffffc02036e8:	86aa                	mv	a3,a0
ffffffffc02036ea:	4581                	li	a1,0
        while ((le = list_next(le)) != list) {
ffffffffc02036ec:	6e89                	lui	t4,0x2
ffffffffc02036ee:	148e0563          	beq	t3,s0,ffffffffc0203838 <do_fork+0x35e>
ffffffffc02036f2:	88ae                	mv	a7,a1
ffffffffc02036f4:	87f2                	mv	a5,t3
ffffffffc02036f6:	6609                	lui	a2,0x2
ffffffffc02036f8:	a811                	j	ffffffffc020370c <do_fork+0x232>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc02036fa:	00e6d663          	bge	a3,a4,ffffffffc0203706 <do_fork+0x22c>
ffffffffc02036fe:	00c75463          	bge	a4,a2,ffffffffc0203706 <do_fork+0x22c>
ffffffffc0203702:	863a                	mv	a2,a4
ffffffffc0203704:	4885                	li	a7,1
ffffffffc0203706:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0203708:	00878d63          	beq	a5,s0,ffffffffc0203722 <do_fork+0x248>
            if (proc->pid == last_pid) {
ffffffffc020370c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_hello_out_size-0x7e44>
ffffffffc0203710:	fed715e3          	bne	a4,a3,ffffffffc02036fa <do_fork+0x220>
                if (++ last_pid >= next_safe) {
ffffffffc0203714:	2685                	addiw	a3,a3,1
ffffffffc0203716:	10c6dc63          	bge	a3,a2,ffffffffc020382e <do_fork+0x354>
ffffffffc020371a:	679c                	ld	a5,8(a5)
ffffffffc020371c:	4585                	li	a1,1
        while ((le = list_next(le)) != list) {
ffffffffc020371e:	fe8797e3          	bne	a5,s0,ffffffffc020370c <do_fork+0x232>
ffffffffc0203722:	c581                	beqz	a1,ffffffffc020372a <do_fork+0x250>
ffffffffc0203724:	00d82023          	sw	a3,0(a6)
ffffffffc0203728:	8536                	mv	a0,a3
ffffffffc020372a:	f20880e3          	beqz	a7,ffffffffc020364a <do_fork+0x170>
ffffffffc020372e:	00c32023          	sw	a2,0(t1)
ffffffffc0203732:	bf21                	j	ffffffffc020364a <do_fork+0x170>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf - 4 : esp;
ffffffffc0203734:	6989                	lui	s3,0x2
ffffffffc0203736:	edc98993          	addi	s3,s3,-292 # 1edc <_binary_obj___user_hello_out_size-0x7ea4>
ffffffffc020373a:	99b6                	add	s3,s3,a3
ffffffffc020373c:	01373823          	sd	s3,16(a4)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203740:	00000797          	auipc	a5,0x0
ffffffffc0203744:	c2c78793          	addi	a5,a5,-980 # ffffffffc020336c <forkret>
ffffffffc0203748:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020374a:	fc98                	sd	a4,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020374c:	100027f3          	csrr	a5,sstatus
ffffffffc0203750:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203752:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203754:	ec0782e3          	beqz	a5,ffffffffc0203618 <do_fork+0x13e>
        intr_disable();
ffffffffc0203758:	ee1fc0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc020375c:	4985                	li	s3,1
ffffffffc020375e:	bd6d                	j	ffffffffc0203618 <do_fork+0x13e>
    if ((mm = mm_create()) == NULL) {
ffffffffc0203760:	d28ff0ef          	jal	ra,ffffffffc0202c88 <mm_create>
ffffffffc0203764:	8caa                	mv	s9,a0
ffffffffc0203766:	c541                	beqz	a0,ffffffffc02037ee <do_fork+0x314>
    if ((page = alloc_page()) == NULL) {
ffffffffc0203768:	4505                	li	a0,1
ffffffffc020376a:	c4afe0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc020376e:	cd2d                	beqz	a0,ffffffffc02037e8 <do_fork+0x30e>
    return page - pages + nbase;
ffffffffc0203770:	000ab683          	ld	a3,0(s5)
ffffffffc0203774:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc0203776:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020377a:	40d506b3          	sub	a3,a0,a3
ffffffffc020377e:	8699                	srai	a3,a3,0x6
ffffffffc0203780:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203782:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0203786:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203788:	0eedf263          	bgeu	s11,a4,ffffffffc020386c <do_fork+0x392>
ffffffffc020378c:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0203790:	6605                	lui	a2,0x1
ffffffffc0203792:	00031597          	auipc	a1,0x31
ffffffffc0203796:	5865b583          	ld	a1,1414(a1) # ffffffffc0234d18 <boot_pgdir>
ffffffffc020379a:	9a36                	add	s4,s4,a3
ffffffffc020379c:	8552                	mv	a0,s4
ffffffffc020379e:	5da010ef          	jal	ra,ffffffffc0204d78 <memcpy>
}

static inline void
lock_mm(struct mm_struct *mm) {
    if (mm != NULL) {
        lock(&(mm->mm_lock));
ffffffffc02037a2:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc02037a6:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02037aa:	4785                	li	a5,1
ffffffffc02037ac:	40fdb7af          	amoor.d	a5,a5,(s11)
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
ffffffffc02037b0:	8b85                	andi	a5,a5,1
ffffffffc02037b2:	4a05                	li	s4,1
ffffffffc02037b4:	c799                	beqz	a5,ffffffffc02037c2 <do_fork+0x2e8>
        schedule();
ffffffffc02037b6:	78d000ef          	jal	ra,ffffffffc0204742 <schedule>
ffffffffc02037ba:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock)) {
ffffffffc02037be:	8b85                	andi	a5,a5,1
ffffffffc02037c0:	fbfd                	bnez	a5,ffffffffc02037b6 <do_fork+0x2dc>
        ret = dup_mmap(mm, oldmm);
ffffffffc02037c2:	85ea                	mv	a1,s10
ffffffffc02037c4:	8566                	mv	a0,s9
ffffffffc02037c6:	f1cff0ef          	jal	ra,ffffffffc0202ee2 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02037ca:	57f9                	li	a5,-2
ffffffffc02037cc:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02037d0:	8b85                	andi	a5,a5,1
    }
}

static inline void
unlock(lock_t *lock) {
    if (!test_and_clear_bit(0, lock)) {
ffffffffc02037d2:	0e078e63          	beqz	a5,ffffffffc02038ce <do_fork+0x3f4>
good_mm:
ffffffffc02037d6:	8d66                	mv	s10,s9
    if (ret != 0) {
ffffffffc02037d8:	dc0501e3          	beqz	a0,ffffffffc020359a <do_fork+0xc0>
    exit_mmap(mm);
ffffffffc02037dc:	8566                	mv	a0,s9
ffffffffc02037de:	f9eff0ef          	jal	ra,ffffffffc0202f7c <exit_mmap>
    put_pgdir(mm);
ffffffffc02037e2:	8566                	mv	a0,s9
ffffffffc02037e4:	c15ff0ef          	jal	ra,ffffffffc02033f8 <put_pgdir>
    mm_destroy(mm);
ffffffffc02037e8:	8566                	mv	a0,s9
ffffffffc02037ea:	df6ff0ef          	jal	ra,ffffffffc0202de0 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02037ee:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc02037f0:	c02007b7          	lui	a5,0xc0200
ffffffffc02037f4:	0cf6e163          	bltu	a3,a5,ffffffffc02038b6 <do_fork+0x3dc>
ffffffffc02037f8:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage) {
ffffffffc02037fc:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0203800:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0203804:	83b1                	srli	a5,a5,0xc
ffffffffc0203806:	06e7ff63          	bgeu	a5,a4,ffffffffc0203884 <do_fork+0x3aa>
    return &pages[PPN(pa) - nbase];
ffffffffc020380a:	000b3703          	ld	a4,0(s6)
ffffffffc020380e:	000ab503          	ld	a0,0(s5)
ffffffffc0203812:	4589                	li	a1,2
ffffffffc0203814:	8f99                	sub	a5,a5,a4
ffffffffc0203816:	079a                	slli	a5,a5,0x6
ffffffffc0203818:	953e                	add	a0,a0,a5
ffffffffc020381a:	c2cfe0ef          	jal	ra,ffffffffc0201c46 <free_pages>
    kfree(proc);
ffffffffc020381e:	8526                	mv	a0,s1
ffffffffc0203820:	a82fe0ef          	jal	ra,ffffffffc0201aa2 <kfree>
    ret = -E_NO_MEM;
ffffffffc0203824:	5571                	li	a0,-4
    return ret;
ffffffffc0203826:	b549                	j	ffffffffc02036a8 <do_fork+0x1ce>
        intr_enable();
ffffffffc0203828:	e0bfc0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc020382c:	bd95                	j	ffffffffc02036a0 <do_fork+0x1c6>
                    if (last_pid >= MAX_PID) {
ffffffffc020382e:	01d6c363          	blt	a3,t4,ffffffffc0203834 <do_fork+0x35a>
                        last_pid = 1;
ffffffffc0203832:	4685                	li	a3,1
                    goto repeat;
ffffffffc0203834:	4585                	li	a1,1
ffffffffc0203836:	bd65                	j	ffffffffc02036ee <do_fork+0x214>
ffffffffc0203838:	c599                	beqz	a1,ffffffffc0203846 <do_fork+0x36c>
ffffffffc020383a:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020383e:	8536                	mv	a0,a3
ffffffffc0203840:	b529                	j	ffffffffc020364a <do_fork+0x170>
    int ret = -E_NO_FREE_PROC;
ffffffffc0203842:	556d                	li	a0,-5
ffffffffc0203844:	b595                	j	ffffffffc02036a8 <do_fork+0x1ce>
    return last_pid;
ffffffffc0203846:	00082503          	lw	a0,0(a6)
ffffffffc020384a:	b501                	j	ffffffffc020364a <do_fork+0x170>
    assert(current->wait_state == 0);
ffffffffc020384c:	00003697          	auipc	a3,0x3
ffffffffc0203850:	a3468693          	addi	a3,a3,-1484 # ffffffffc0206280 <default_pmm_manager+0x7b0>
ffffffffc0203854:	00002617          	auipc	a2,0x2
ffffffffc0203858:	be460613          	addi	a2,a2,-1052 # ffffffffc0205438 <commands+0x448>
ffffffffc020385c:	17400593          	li	a1,372
ffffffffc0203860:	00003517          	auipc	a0,0x3
ffffffffc0203864:	a0850513          	addi	a0,a0,-1528 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203868:	c0ffc0ef          	jal	ra,ffffffffc0200476 <__panic>
    return KADDR(page2pa(page));
ffffffffc020386c:	00002617          	auipc	a2,0x2
ffffffffc0203870:	29c60613          	addi	a2,a2,668 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc0203874:	06900593          	li	a1,105
ffffffffc0203878:	00002517          	auipc	a0,0x2
ffffffffc020387c:	2b850513          	addi	a0,a0,696 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0203880:	bf7fc0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203884:	00002617          	auipc	a2,0x2
ffffffffc0203888:	31c60613          	addi	a2,a2,796 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc020388c:	06200593          	li	a1,98
ffffffffc0203890:	00002517          	auipc	a0,0x2
ffffffffc0203894:	2a050513          	addi	a0,a0,672 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0203898:	bdffc0ef          	jal	ra,ffffffffc0200476 <__panic>
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc020389c:	86be                	mv	a3,a5
ffffffffc020389e:	00002617          	auipc	a2,0x2
ffffffffc02038a2:	2da60613          	addi	a2,a2,730 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc02038a6:	14700593          	li	a1,327
ffffffffc02038aa:	00003517          	auipc	a0,0x3
ffffffffc02038ae:	9be50513          	addi	a0,a0,-1602 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc02038b2:	bc5fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02038b6:	00002617          	auipc	a2,0x2
ffffffffc02038ba:	2c260613          	addi	a2,a2,706 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc02038be:	06e00593          	li	a1,110
ffffffffc02038c2:	00002517          	auipc	a0,0x2
ffffffffc02038c6:	26e50513          	addi	a0,a0,622 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc02038ca:	badfc0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("Unlock failed.\n");
ffffffffc02038ce:	00003617          	auipc	a2,0x3
ffffffffc02038d2:	9d260613          	addi	a2,a2,-1582 # ffffffffc02062a0 <default_pmm_manager+0x7d0>
ffffffffc02038d6:	03200593          	li	a1,50
ffffffffc02038da:	00003517          	auipc	a0,0x3
ffffffffc02038de:	9d650513          	addi	a0,a0,-1578 # ffffffffc02062b0 <default_pmm_manager+0x7e0>
ffffffffc02038e2:	b95fc0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02038e6 <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02038e6:	7129                	addi	sp,sp,-320
ffffffffc02038e8:	fa22                	sd	s0,304(sp)
ffffffffc02038ea:	f626                	sd	s1,296(sp)
ffffffffc02038ec:	f24a                	sd	s2,288(sp)
ffffffffc02038ee:	84ae                	mv	s1,a1
ffffffffc02038f0:	892a                	mv	s2,a0
ffffffffc02038f2:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02038f4:	4581                	li	a1,0
ffffffffc02038f6:	12000613          	li	a2,288
ffffffffc02038fa:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02038fc:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02038fe:	468010ef          	jal	ra,ffffffffc0204d66 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0203902:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0203904:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203906:	100027f3          	csrr	a5,sstatus
ffffffffc020390a:	edd7f793          	andi	a5,a5,-291
ffffffffc020390e:	1207e793          	ori	a5,a5,288
ffffffffc0203912:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203914:	860a                	mv	a2,sp
ffffffffc0203916:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020391a:	00000797          	auipc	a5,0x0
ffffffffc020391e:	9c478793          	addi	a5,a5,-1596 # ffffffffc02032de <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203922:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203924:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203926:	bb5ff0ef          	jal	ra,ffffffffc02034da <do_fork>
}
ffffffffc020392a:	70f2                	ld	ra,312(sp)
ffffffffc020392c:	7452                	ld	s0,304(sp)
ffffffffc020392e:	74b2                	ld	s1,296(sp)
ffffffffc0203930:	7912                	ld	s2,288(sp)
ffffffffc0203932:	6131                	addi	sp,sp,320
ffffffffc0203934:	8082                	ret

ffffffffc0203936 <do_exit>:
do_exit(int error_code) {
ffffffffc0203936:	7179                	addi	sp,sp,-48
ffffffffc0203938:	f022                	sd	s0,32(sp)
    if (current == idleproc) {
ffffffffc020393a:	00031417          	auipc	s0,0x31
ffffffffc020393e:	42e40413          	addi	s0,s0,1070 # ffffffffc0234d68 <current>
ffffffffc0203942:	601c                	ld	a5,0(s0)
do_exit(int error_code) {
ffffffffc0203944:	f406                	sd	ra,40(sp)
ffffffffc0203946:	ec26                	sd	s1,24(sp)
ffffffffc0203948:	e84a                	sd	s2,16(sp)
ffffffffc020394a:	e44e                	sd	s3,8(sp)
ffffffffc020394c:	e052                	sd	s4,0(sp)
    if (current == idleproc) {
ffffffffc020394e:	00031717          	auipc	a4,0x31
ffffffffc0203952:	42273703          	ld	a4,1058(a4) # ffffffffc0234d70 <idleproc>
ffffffffc0203956:	0ce78c63          	beq	a5,a4,ffffffffc0203a2e <do_exit+0xf8>
    if (current == initproc) {
ffffffffc020395a:	00031497          	auipc	s1,0x31
ffffffffc020395e:	41e48493          	addi	s1,s1,1054 # ffffffffc0234d78 <initproc>
ffffffffc0203962:	6098                	ld	a4,0(s1)
ffffffffc0203964:	0ee78b63          	beq	a5,a4,ffffffffc0203a5a <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0203968:	0287b983          	ld	s3,40(a5)
ffffffffc020396c:	892a                	mv	s2,a0
    if (mm != NULL) {
ffffffffc020396e:	02098663          	beqz	s3,ffffffffc020399a <do_exit+0x64>
ffffffffc0203972:	00031797          	auipc	a5,0x31
ffffffffc0203976:	39e7b783          	ld	a5,926(a5) # ffffffffc0234d10 <boot_cr3>
ffffffffc020397a:	577d                	li	a4,-1
ffffffffc020397c:	177e                	slli	a4,a4,0x3f
ffffffffc020397e:	83b1                	srli	a5,a5,0xc
ffffffffc0203980:	8fd9                	or	a5,a5,a4
ffffffffc0203982:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0203986:	0309a783          	lw	a5,48(s3)
ffffffffc020398a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020398e:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0) {
ffffffffc0203992:	cb55                	beqz	a4,ffffffffc0203a46 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0203994:	601c                	ld	a5,0(s0)
ffffffffc0203996:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020399a:	601c                	ld	a5,0(s0)
ffffffffc020399c:	470d                	li	a4,3
ffffffffc020399e:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02039a0:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02039a4:	100027f3          	csrr	a5,sstatus
ffffffffc02039a8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02039aa:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02039ac:	e3f9                	bnez	a5,ffffffffc0203a72 <do_exit+0x13c>
        proc = current->parent;
ffffffffc02039ae:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD) {
ffffffffc02039b0:	800007b7          	lui	a5,0x80000
ffffffffc02039b4:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02039b6:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD) {
ffffffffc02039b8:	0ec52703          	lw	a4,236(a0)
ffffffffc02039bc:	0af70f63          	beq	a4,a5,ffffffffc0203a7a <do_exit+0x144>
        while (current->cptr != NULL) {
ffffffffc02039c0:	6018                	ld	a4,0(s0)
ffffffffc02039c2:	7b7c                	ld	a5,240(a4)
ffffffffc02039c4:	c3a1                	beqz	a5,ffffffffc0203a04 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02039c6:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02039ca:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02039cc:	0985                	addi	s3,s3,1
ffffffffc02039ce:	a021                	j	ffffffffc02039d6 <do_exit+0xa0>
        while (current->cptr != NULL) {
ffffffffc02039d0:	6018                	ld	a4,0(s0)
ffffffffc02039d2:	7b7c                	ld	a5,240(a4)
ffffffffc02039d4:	cb85                	beqz	a5,ffffffffc0203a04 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02039d6:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_rr_out_size+0xffffffff7fff5060>
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02039da:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02039dc:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02039de:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02039e0:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02039e4:	10e7b023          	sd	a4,256(a5)
ffffffffc02039e8:	c311                	beqz	a4,ffffffffc02039ec <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02039ea:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02039ec:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02039ee:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02039f0:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02039f2:	fd271fe3          	bne	a4,s2,ffffffffc02039d0 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02039f6:	0ec52783          	lw	a5,236(a0)
ffffffffc02039fa:	fd379be3          	bne	a5,s3,ffffffffc02039d0 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02039fe:	493000ef          	jal	ra,ffffffffc0204690 <wakeup_proc>
ffffffffc0203a02:	b7f9                	j	ffffffffc02039d0 <do_exit+0x9a>
    if (flag) {
ffffffffc0203a04:	020a1263          	bnez	s4,ffffffffc0203a28 <do_exit+0xf2>
    schedule();
ffffffffc0203a08:	53b000ef          	jal	ra,ffffffffc0204742 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0203a0c:	601c                	ld	a5,0(s0)
ffffffffc0203a0e:	00003617          	auipc	a2,0x3
ffffffffc0203a12:	8da60613          	addi	a2,a2,-1830 # ffffffffc02062e8 <default_pmm_manager+0x818>
ffffffffc0203a16:	1c700593          	li	a1,455
ffffffffc0203a1a:	43d4                	lw	a3,4(a5)
ffffffffc0203a1c:	00003517          	auipc	a0,0x3
ffffffffc0203a20:	84c50513          	addi	a0,a0,-1972 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203a24:	a53fc0ef          	jal	ra,ffffffffc0200476 <__panic>
        intr_enable();
ffffffffc0203a28:	c0bfc0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc0203a2c:	bff1                	j	ffffffffc0203a08 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0203a2e:	00003617          	auipc	a2,0x3
ffffffffc0203a32:	89a60613          	addi	a2,a2,-1894 # ffffffffc02062c8 <default_pmm_manager+0x7f8>
ffffffffc0203a36:	19b00593          	li	a1,411
ffffffffc0203a3a:	00003517          	auipc	a0,0x3
ffffffffc0203a3e:	82e50513          	addi	a0,a0,-2002 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203a42:	a35fc0ef          	jal	ra,ffffffffc0200476 <__panic>
            exit_mmap(mm);
ffffffffc0203a46:	854e                	mv	a0,s3
ffffffffc0203a48:	d34ff0ef          	jal	ra,ffffffffc0202f7c <exit_mmap>
            put_pgdir(mm);
ffffffffc0203a4c:	854e                	mv	a0,s3
ffffffffc0203a4e:	9abff0ef          	jal	ra,ffffffffc02033f8 <put_pgdir>
            mm_destroy(mm);
ffffffffc0203a52:	854e                	mv	a0,s3
ffffffffc0203a54:	b8cff0ef          	jal	ra,ffffffffc0202de0 <mm_destroy>
ffffffffc0203a58:	bf35                	j	ffffffffc0203994 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0203a5a:	00003617          	auipc	a2,0x3
ffffffffc0203a5e:	87e60613          	addi	a2,a2,-1922 # ffffffffc02062d8 <default_pmm_manager+0x808>
ffffffffc0203a62:	19e00593          	li	a1,414
ffffffffc0203a66:	00003517          	auipc	a0,0x3
ffffffffc0203a6a:	80250513          	addi	a0,a0,-2046 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203a6e:	a09fc0ef          	jal	ra,ffffffffc0200476 <__panic>
        intr_disable();
ffffffffc0203a72:	bc7fc0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc0203a76:	4a05                	li	s4,1
ffffffffc0203a78:	bf1d                	j	ffffffffc02039ae <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0203a7a:	417000ef          	jal	ra,ffffffffc0204690 <wakeup_proc>
ffffffffc0203a7e:	b789                	j	ffffffffc02039c0 <do_exit+0x8a>

ffffffffc0203a80 <do_wait.part.0>:
do_wait(int pid, int *code_store) {
ffffffffc0203a80:	715d                	addi	sp,sp,-80
ffffffffc0203a82:	fc26                	sd	s1,56(sp)
ffffffffc0203a84:	f84a                	sd	s2,48(sp)
        current->wait_state = WT_CHILD;
ffffffffc0203a86:	800004b7          	lui	s1,0x80000
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203a8a:	6909                	lui	s2,0x2
do_wait(int pid, int *code_store) {
ffffffffc0203a8c:	f44e                	sd	s3,40(sp)
ffffffffc0203a8e:	f052                	sd	s4,32(sp)
ffffffffc0203a90:	ec56                	sd	s5,24(sp)
ffffffffc0203a92:	e85a                	sd	s6,16(sp)
ffffffffc0203a94:	e45e                	sd	s7,8(sp)
ffffffffc0203a96:	e486                	sd	ra,72(sp)
ffffffffc0203a98:	e0a2                	sd	s0,64(sp)
ffffffffc0203a9a:	8b2a                	mv	s6,a0
ffffffffc0203a9c:	89ae                	mv	s3,a1
        proc = current->cptr;
ffffffffc0203a9e:	00031b97          	auipc	s7,0x31
ffffffffc0203aa2:	2cab8b93          	addi	s7,s7,714 # ffffffffc0234d68 <current>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203aa6:	00050a9b          	sext.w	s5,a0
ffffffffc0203aaa:	fff50a1b          	addiw	s4,a0,-1
ffffffffc0203aae:	1979                	addi	s2,s2,-2
        current->wait_state = WT_CHILD;
ffffffffc0203ab0:	0485                	addi	s1,s1,1
    if (pid != 0) {
ffffffffc0203ab2:	060b0f63          	beqz	s6,ffffffffc0203b30 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203ab6:	03496763          	bltu	s2,s4,ffffffffc0203ae4 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203aba:	45a9                	li	a1,10
ffffffffc0203abc:	8556                	mv	a0,s5
ffffffffc0203abe:	63b000ef          	jal	ra,ffffffffc02048f8 <hash32>
ffffffffc0203ac2:	02051713          	slli	a4,a0,0x20
ffffffffc0203ac6:	8371                	srli	a4,a4,0x1c
ffffffffc0203ac8:	0002d797          	auipc	a5,0x2d
ffffffffc0203acc:	1f078793          	addi	a5,a5,496 # ffffffffc0230cb8 <hash_list>
ffffffffc0203ad0:	973e                	add	a4,a4,a5
ffffffffc0203ad2:	843a                	mv	s0,a4
        while ((le = list_next(le)) != list) {
ffffffffc0203ad4:	a029                	j	ffffffffc0203ade <do_wait.part.0+0x5e>
            if (proc->pid == pid) {
ffffffffc0203ad6:	f2c42783          	lw	a5,-212(s0)
ffffffffc0203ada:	03678163          	beq	a5,s6,ffffffffc0203afc <do_wait.part.0+0x7c>
ffffffffc0203ade:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list) {
ffffffffc0203ae0:	fe871be3          	bne	a4,s0,ffffffffc0203ad6 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc0203ae4:	5579                	li	a0,-2
}
ffffffffc0203ae6:	60a6                	ld	ra,72(sp)
ffffffffc0203ae8:	6406                	ld	s0,64(sp)
ffffffffc0203aea:	74e2                	ld	s1,56(sp)
ffffffffc0203aec:	7942                	ld	s2,48(sp)
ffffffffc0203aee:	79a2                	ld	s3,40(sp)
ffffffffc0203af0:	7a02                	ld	s4,32(sp)
ffffffffc0203af2:	6ae2                	ld	s5,24(sp)
ffffffffc0203af4:	6b42                	ld	s6,16(sp)
ffffffffc0203af6:	6ba2                	ld	s7,8(sp)
ffffffffc0203af8:	6161                	addi	sp,sp,80
ffffffffc0203afa:	8082                	ret
        if (proc != NULL && proc->parent == current) {
ffffffffc0203afc:	000bb683          	ld	a3,0(s7)
ffffffffc0203b00:	f4843783          	ld	a5,-184(s0)
ffffffffc0203b04:	fed790e3          	bne	a5,a3,ffffffffc0203ae4 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203b08:	f2842703          	lw	a4,-216(s0)
ffffffffc0203b0c:	478d                	li	a5,3
ffffffffc0203b0e:	0ef70b63          	beq	a4,a5,ffffffffc0203c04 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0203b12:	4785                	li	a5,1
ffffffffc0203b14:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0203b16:	0e96a623          	sw	s1,236(a3)
        schedule();
ffffffffc0203b1a:	429000ef          	jal	ra,ffffffffc0204742 <schedule>
        if (current->flags & PF_EXITING) {
ffffffffc0203b1e:	000bb783          	ld	a5,0(s7)
ffffffffc0203b22:	0b07a783          	lw	a5,176(a5)
ffffffffc0203b26:	8b85                	andi	a5,a5,1
ffffffffc0203b28:	d7c9                	beqz	a5,ffffffffc0203ab2 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0203b2a:	555d                	li	a0,-9
ffffffffc0203b2c:	e0bff0ef          	jal	ra,ffffffffc0203936 <do_exit>
        proc = current->cptr;
ffffffffc0203b30:	000bb683          	ld	a3,0(s7)
ffffffffc0203b34:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr) {
ffffffffc0203b36:	d45d                	beqz	s0,ffffffffc0203ae4 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203b38:	470d                	li	a4,3
ffffffffc0203b3a:	a021                	j	ffffffffc0203b42 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr) {
ffffffffc0203b3c:	10043403          	ld	s0,256(s0)
ffffffffc0203b40:	d869                	beqz	s0,ffffffffc0203b12 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203b42:	401c                	lw	a5,0(s0)
ffffffffc0203b44:	fee79ce3          	bne	a5,a4,ffffffffc0203b3c <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc) {
ffffffffc0203b48:	00031797          	auipc	a5,0x31
ffffffffc0203b4c:	2287b783          	ld	a5,552(a5) # ffffffffc0234d70 <idleproc>
ffffffffc0203b50:	0c878963          	beq	a5,s0,ffffffffc0203c22 <do_wait.part.0+0x1a2>
ffffffffc0203b54:	00031797          	auipc	a5,0x31
ffffffffc0203b58:	2247b783          	ld	a5,548(a5) # ffffffffc0234d78 <initproc>
ffffffffc0203b5c:	0cf40363          	beq	s0,a5,ffffffffc0203c22 <do_wait.part.0+0x1a2>
    if (code_store != NULL) {
ffffffffc0203b60:	00098663          	beqz	s3,ffffffffc0203b6c <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0203b64:	0e842783          	lw	a5,232(s0)
ffffffffc0203b68:	00f9a023          	sw	a5,0(s3) # ffffffff80000000 <_binary_obj___user_rr_out_size+0xffffffff7fff4f60>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203b6c:	100027f3          	csrr	a5,sstatus
ffffffffc0203b70:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203b72:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203b74:	e7c1                	bnez	a5,ffffffffc0203bfc <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203b76:	6c70                	ld	a2,216(s0)
ffffffffc0203b78:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL) {
ffffffffc0203b7a:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0203b7e:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0203b80:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0203b82:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203b84:	6470                	ld	a2,200(s0)
ffffffffc0203b86:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0203b88:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0203b8a:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL) {
ffffffffc0203b8c:	c319                	beqz	a4,ffffffffc0203b92 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0203b8e:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL) {
ffffffffc0203b90:	7c7c                	ld	a5,248(s0)
ffffffffc0203b92:	c3b5                	beqz	a5,ffffffffc0203bf6 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0203b94:	10e7b023          	sd	a4,256(a5)
    nr_process --;
ffffffffc0203b98:	00031717          	auipc	a4,0x31
ffffffffc0203b9c:	1e870713          	addi	a4,a4,488 # ffffffffc0234d80 <nr_process>
ffffffffc0203ba0:	431c                	lw	a5,0(a4)
ffffffffc0203ba2:	37fd                	addiw	a5,a5,-1
ffffffffc0203ba4:	c31c                	sw	a5,0(a4)
    if (flag) {
ffffffffc0203ba6:	e5a9                	bnez	a1,ffffffffc0203bf0 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0203ba8:	6814                	ld	a3,16(s0)
ffffffffc0203baa:	c02007b7          	lui	a5,0xc0200
ffffffffc0203bae:	04f6ee63          	bltu	a3,a5,ffffffffc0203c0a <do_wait.part.0+0x18a>
ffffffffc0203bb2:	00031797          	auipc	a5,0x31
ffffffffc0203bb6:	1867b783          	ld	a5,390(a5) # ffffffffc0234d38 <va_pa_offset>
ffffffffc0203bba:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0203bbc:	82b1                	srli	a3,a3,0xc
ffffffffc0203bbe:	00031797          	auipc	a5,0x31
ffffffffc0203bc2:	1627b783          	ld	a5,354(a5) # ffffffffc0234d20 <npage>
ffffffffc0203bc6:	06f6fa63          	bgeu	a3,a5,ffffffffc0203c3a <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0203bca:	00003517          	auipc	a0,0x3
ffffffffc0203bce:	fe653503          	ld	a0,-26(a0) # ffffffffc0206bb0 <nbase>
ffffffffc0203bd2:	8e89                	sub	a3,a3,a0
ffffffffc0203bd4:	069a                	slli	a3,a3,0x6
ffffffffc0203bd6:	00031517          	auipc	a0,0x31
ffffffffc0203bda:	15253503          	ld	a0,338(a0) # ffffffffc0234d28 <pages>
ffffffffc0203bde:	9536                	add	a0,a0,a3
ffffffffc0203be0:	4589                	li	a1,2
ffffffffc0203be2:	864fe0ef          	jal	ra,ffffffffc0201c46 <free_pages>
    kfree(proc);
ffffffffc0203be6:	8522                	mv	a0,s0
ffffffffc0203be8:	ebbfd0ef          	jal	ra,ffffffffc0201aa2 <kfree>
    return 0;
ffffffffc0203bec:	4501                	li	a0,0
ffffffffc0203bee:	bde5                	j	ffffffffc0203ae6 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc0203bf0:	a43fc0ef          	jal	ra,ffffffffc0200632 <intr_enable>
ffffffffc0203bf4:	bf55                	j	ffffffffc0203ba8 <do_wait.part.0+0x128>
       proc->parent->cptr = proc->optr;
ffffffffc0203bf6:	701c                	ld	a5,32(s0)
ffffffffc0203bf8:	fbf8                	sd	a4,240(a5)
ffffffffc0203bfa:	bf79                	j	ffffffffc0203b98 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc0203bfc:	a3dfc0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc0203c00:	4585                	li	a1,1
ffffffffc0203c02:	bf95                	j	ffffffffc0203b76 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0203c04:	f2840413          	addi	s0,s0,-216
ffffffffc0203c08:	b781                	j	ffffffffc0203b48 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0203c0a:	00002617          	auipc	a2,0x2
ffffffffc0203c0e:	f6e60613          	addi	a2,a2,-146 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc0203c12:	06e00593          	li	a1,110
ffffffffc0203c16:	00002517          	auipc	a0,0x2
ffffffffc0203c1a:	f1a50513          	addi	a0,a0,-230 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0203c1e:	859fc0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0203c22:	00002617          	auipc	a2,0x2
ffffffffc0203c26:	6e660613          	addi	a2,a2,1766 # ffffffffc0206308 <default_pmm_manager+0x838>
ffffffffc0203c2a:	2b600593          	li	a1,694
ffffffffc0203c2e:	00002517          	auipc	a0,0x2
ffffffffc0203c32:	63a50513          	addi	a0,a0,1594 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203c36:	841fc0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203c3a:	00002617          	auipc	a2,0x2
ffffffffc0203c3e:	f6660613          	addi	a2,a2,-154 # ffffffffc0205ba0 <default_pmm_manager+0xd0>
ffffffffc0203c42:	06200593          	li	a1,98
ffffffffc0203c46:	00002517          	auipc	a0,0x2
ffffffffc0203c4a:	eea50513          	addi	a0,a0,-278 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc0203c4e:	829fc0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0203c52 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
ffffffffc0203c52:	1141                	addi	sp,sp,-16
ffffffffc0203c54:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0203c56:	830fe0ef          	jal	ra,ffffffffc0201c86 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0203c5a:	d95fd0ef          	jal	ra,ffffffffc02019ee <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0203c5e:	4601                	li	a2,0
ffffffffc0203c60:	4581                	li	a1,0
ffffffffc0203c62:	fffff517          	auipc	a0,0xfffff
ffffffffc0203c66:	71850513          	addi	a0,a0,1816 # ffffffffc020337a <user_main>
ffffffffc0203c6a:	c7dff0ef          	jal	ra,ffffffffc02038e6 <kernel_thread>
    if (pid <= 0) {
ffffffffc0203c6e:	00a04563          	bgtz	a0,ffffffffc0203c78 <init_main+0x26>
ffffffffc0203c72:	a071                	j	ffffffffc0203cfe <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
ffffffffc0203c74:	2cf000ef          	jal	ra,ffffffffc0204742 <schedule>
    if (code_store != NULL) {
ffffffffc0203c78:	4581                	li	a1,0
ffffffffc0203c7a:	4501                	li	a0,0
ffffffffc0203c7c:	e05ff0ef          	jal	ra,ffffffffc0203a80 <do_wait.part.0>
    while (do_wait(0, NULL) == 0) {
ffffffffc0203c80:	d975                	beqz	a0,ffffffffc0203c74 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0203c82:	00002517          	auipc	a0,0x2
ffffffffc0203c86:	6c650513          	addi	a0,a0,1734 # ffffffffc0206348 <default_pmm_manager+0x878>
ffffffffc0203c8a:	cf2fc0ef          	jal	ra,ffffffffc020017c <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0203c8e:	00031797          	auipc	a5,0x31
ffffffffc0203c92:	0ea7b783          	ld	a5,234(a5) # ffffffffc0234d78 <initproc>
ffffffffc0203c96:	7bf8                	ld	a4,240(a5)
ffffffffc0203c98:	e339                	bnez	a4,ffffffffc0203cde <init_main+0x8c>
ffffffffc0203c9a:	7ff8                	ld	a4,248(a5)
ffffffffc0203c9c:	e329                	bnez	a4,ffffffffc0203cde <init_main+0x8c>
ffffffffc0203c9e:	1007b703          	ld	a4,256(a5)
ffffffffc0203ca2:	ef15                	bnez	a4,ffffffffc0203cde <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0203ca4:	00031697          	auipc	a3,0x31
ffffffffc0203ca8:	0dc6a683          	lw	a3,220(a3) # ffffffffc0234d80 <nr_process>
ffffffffc0203cac:	4709                	li	a4,2
ffffffffc0203cae:	0ae69463          	bne	a3,a4,ffffffffc0203d56 <init_main+0x104>
    return listelm->next;
ffffffffc0203cb2:	00031697          	auipc	a3,0x31
ffffffffc0203cb6:	00668693          	addi	a3,a3,6 # ffffffffc0234cb8 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0203cba:	6698                	ld	a4,8(a3)
ffffffffc0203cbc:	0c878793          	addi	a5,a5,200
ffffffffc0203cc0:	06f71b63          	bne	a4,a5,ffffffffc0203d36 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0203cc4:	629c                	ld	a5,0(a3)
ffffffffc0203cc6:	04f71863          	bne	a4,a5,ffffffffc0203d16 <init_main+0xc4>

    //cprintf("init check memory pass.\n");
    cprintf("The end of init_main\n");
ffffffffc0203cca:	00002517          	auipc	a0,0x2
ffffffffc0203cce:	76650513          	addi	a0,a0,1894 # ffffffffc0206430 <default_pmm_manager+0x960>
ffffffffc0203cd2:	caafc0ef          	jal	ra,ffffffffc020017c <cprintf>
    return 0;
}
ffffffffc0203cd6:	60a2                	ld	ra,8(sp)
ffffffffc0203cd8:	4501                	li	a0,0
ffffffffc0203cda:	0141                	addi	sp,sp,16
ffffffffc0203cdc:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0203cde:	00002697          	auipc	a3,0x2
ffffffffc0203ce2:	69268693          	addi	a3,a3,1682 # ffffffffc0206370 <default_pmm_manager+0x8a0>
ffffffffc0203ce6:	00001617          	auipc	a2,0x1
ffffffffc0203cea:	75260613          	addi	a2,a2,1874 # ffffffffc0205438 <commands+0x448>
ffffffffc0203cee:	31a00593          	li	a1,794
ffffffffc0203cf2:	00002517          	auipc	a0,0x2
ffffffffc0203cf6:	57650513          	addi	a0,a0,1398 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203cfa:	f7cfc0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("create user_main failed.\n");
ffffffffc0203cfe:	00002617          	auipc	a2,0x2
ffffffffc0203d02:	62a60613          	addi	a2,a2,1578 # ffffffffc0206328 <default_pmm_manager+0x858>
ffffffffc0203d06:	31200593          	li	a1,786
ffffffffc0203d0a:	00002517          	auipc	a0,0x2
ffffffffc0203d0e:	55e50513          	addi	a0,a0,1374 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203d12:	f64fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0203d16:	00002697          	auipc	a3,0x2
ffffffffc0203d1a:	6ea68693          	addi	a3,a3,1770 # ffffffffc0206400 <default_pmm_manager+0x930>
ffffffffc0203d1e:	00001617          	auipc	a2,0x1
ffffffffc0203d22:	71a60613          	addi	a2,a2,1818 # ffffffffc0205438 <commands+0x448>
ffffffffc0203d26:	31d00593          	li	a1,797
ffffffffc0203d2a:	00002517          	auipc	a0,0x2
ffffffffc0203d2e:	53e50513          	addi	a0,a0,1342 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203d32:	f44fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0203d36:	00002697          	auipc	a3,0x2
ffffffffc0203d3a:	69a68693          	addi	a3,a3,1690 # ffffffffc02063d0 <default_pmm_manager+0x900>
ffffffffc0203d3e:	00001617          	auipc	a2,0x1
ffffffffc0203d42:	6fa60613          	addi	a2,a2,1786 # ffffffffc0205438 <commands+0x448>
ffffffffc0203d46:	31c00593          	li	a1,796
ffffffffc0203d4a:	00002517          	auipc	a0,0x2
ffffffffc0203d4e:	51e50513          	addi	a0,a0,1310 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203d52:	f24fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(nr_process == 2);
ffffffffc0203d56:	00002697          	auipc	a3,0x2
ffffffffc0203d5a:	66a68693          	addi	a3,a3,1642 # ffffffffc02063c0 <default_pmm_manager+0x8f0>
ffffffffc0203d5e:	00001617          	auipc	a2,0x1
ffffffffc0203d62:	6da60613          	addi	a2,a2,1754 # ffffffffc0205438 <commands+0x448>
ffffffffc0203d66:	31b00593          	li	a1,795
ffffffffc0203d6a:	00002517          	auipc	a0,0x2
ffffffffc0203d6e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203d72:	f04fc0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0203d76 <do_execve>:
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203d76:	7171                	addi	sp,sp,-176
ffffffffc0203d78:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0203d7a:	00031d97          	auipc	s11,0x31
ffffffffc0203d7e:	feed8d93          	addi	s11,s11,-18 # ffffffffc0234d68 <current>
ffffffffc0203d82:	000db783          	ld	a5,0(s11)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203d86:	e54e                	sd	s3,136(sp)
ffffffffc0203d88:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0203d8a:	0287b983          	ld	s3,40(a5)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203d8e:	e94a                	sd	s2,144(sp)
ffffffffc0203d90:	f4de                	sd	s7,104(sp)
ffffffffc0203d92:	892a                	mv	s2,a0
ffffffffc0203d94:	8bb2                	mv	s7,a2
ffffffffc0203d96:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc0203d98:	862e                	mv	a2,a1
ffffffffc0203d9a:	4681                	li	a3,0
ffffffffc0203d9c:	85aa                	mv	a1,a0
ffffffffc0203d9e:	854e                	mv	a0,s3
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203da0:	f506                	sd	ra,168(sp)
ffffffffc0203da2:	f122                	sd	s0,160(sp)
ffffffffc0203da4:	e152                	sd	s4,128(sp)
ffffffffc0203da6:	fcd6                	sd	s5,120(sp)
ffffffffc0203da8:	f8da                	sd	s6,112(sp)
ffffffffc0203daa:	f0e2                	sd	s8,96(sp)
ffffffffc0203dac:	ece6                	sd	s9,88(sp)
ffffffffc0203dae:	e8ea                	sd	s10,80(sp)
ffffffffc0203db0:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc0203db2:	b44ff0ef          	jal	ra,ffffffffc02030f6 <user_mem_check>
ffffffffc0203db6:	40050863          	beqz	a0,ffffffffc02041c6 <do_execve+0x450>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0203dba:	4641                	li	a2,16
ffffffffc0203dbc:	4581                	li	a1,0
ffffffffc0203dbe:	1808                	addi	a0,sp,48
ffffffffc0203dc0:	7a7000ef          	jal	ra,ffffffffc0204d66 <memset>
    memcpy(local_name, name, len);
ffffffffc0203dc4:	47bd                	li	a5,15
ffffffffc0203dc6:	8626                	mv	a2,s1
ffffffffc0203dc8:	1e97e063          	bltu	a5,s1,ffffffffc0203fa8 <do_execve+0x232>
ffffffffc0203dcc:	85ca                	mv	a1,s2
ffffffffc0203dce:	1808                	addi	a0,sp,48
ffffffffc0203dd0:	7a9000ef          	jal	ra,ffffffffc0204d78 <memcpy>
    if (mm != NULL) {
ffffffffc0203dd4:	1e098163          	beqz	s3,ffffffffc0203fb6 <do_execve+0x240>
        cputs("mm != NULL");
ffffffffc0203dd8:	00002517          	auipc	a0,0x2
ffffffffc0203ddc:	2c850513          	addi	a0,a0,712 # ffffffffc02060a0 <default_pmm_manager+0x5d0>
ffffffffc0203de0:	bd4fc0ef          	jal	ra,ffffffffc02001b4 <cputs>
ffffffffc0203de4:	00031797          	auipc	a5,0x31
ffffffffc0203de8:	f2c7b783          	ld	a5,-212(a5) # ffffffffc0234d10 <boot_cr3>
ffffffffc0203dec:	577d                	li	a4,-1
ffffffffc0203dee:	177e                	slli	a4,a4,0x3f
ffffffffc0203df0:	83b1                	srli	a5,a5,0xc
ffffffffc0203df2:	8fd9                	or	a5,a5,a4
ffffffffc0203df4:	18079073          	csrw	satp,a5
ffffffffc0203df8:	0309a783          	lw	a5,48(s3)
ffffffffc0203dfc:	fff7871b          	addiw	a4,a5,-1
ffffffffc0203e00:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0) {
ffffffffc0203e04:	2c070263          	beqz	a4,ffffffffc02040c8 <do_execve+0x352>
        current->mm = NULL;
ffffffffc0203e08:	000db783          	ld	a5,0(s11)
ffffffffc0203e0c:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL) {
ffffffffc0203e10:	e79fe0ef          	jal	ra,ffffffffc0202c88 <mm_create>
ffffffffc0203e14:	84aa                	mv	s1,a0
ffffffffc0203e16:	1c050b63          	beqz	a0,ffffffffc0203fec <do_execve+0x276>
    if ((page = alloc_page()) == NULL) {
ffffffffc0203e1a:	4505                	li	a0,1
ffffffffc0203e1c:	d99fd0ef          	jal	ra,ffffffffc0201bb4 <alloc_pages>
ffffffffc0203e20:	3a050763          	beqz	a0,ffffffffc02041ce <do_execve+0x458>
    return page - pages + nbase;
ffffffffc0203e24:	00031c97          	auipc	s9,0x31
ffffffffc0203e28:	f04c8c93          	addi	s9,s9,-252 # ffffffffc0234d28 <pages>
ffffffffc0203e2c:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0203e30:	00031c17          	auipc	s8,0x31
ffffffffc0203e34:	ef0c0c13          	addi	s8,s8,-272 # ffffffffc0234d20 <npage>
    return page - pages + nbase;
ffffffffc0203e38:	00003717          	auipc	a4,0x3
ffffffffc0203e3c:	d7873703          	ld	a4,-648(a4) # ffffffffc0206bb0 <nbase>
ffffffffc0203e40:	40d506b3          	sub	a3,a0,a3
ffffffffc0203e44:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203e46:	5afd                	li	s5,-1
ffffffffc0203e48:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0203e4c:	96ba                	add	a3,a3,a4
ffffffffc0203e4e:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0203e50:	00cad713          	srli	a4,s5,0xc
ffffffffc0203e54:	ec3a                	sd	a4,24(sp)
ffffffffc0203e56:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203e58:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203e5a:	36f77e63          	bgeu	a4,a5,ffffffffc02041d6 <do_execve+0x460>
ffffffffc0203e5e:	00031b17          	auipc	s6,0x31
ffffffffc0203e62:	edab0b13          	addi	s6,s6,-294 # ffffffffc0234d38 <va_pa_offset>
ffffffffc0203e66:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0203e6a:	6605                	lui	a2,0x1
ffffffffc0203e6c:	00031597          	auipc	a1,0x31
ffffffffc0203e70:	eac5b583          	ld	a1,-340(a1) # ffffffffc0234d18 <boot_pgdir>
ffffffffc0203e74:	9936                	add	s2,s2,a3
ffffffffc0203e76:	854a                	mv	a0,s2
ffffffffc0203e78:	701000ef          	jal	ra,ffffffffc0204d78 <memcpy>
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0203e7c:	7782                	ld	a5,32(sp)
ffffffffc0203e7e:	4398                	lw	a4,0(a5)
ffffffffc0203e80:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0203e84:	0124bc23          	sd	s2,24(s1) # ffffffff80000018 <_binary_obj___user_rr_out_size+0xffffffff7fff4f78>
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0203e88:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_rr_out_size+0x464b94df>
ffffffffc0203e8c:	14f71663          	bne	a4,a5,ffffffffc0203fd8 <do_execve+0x262>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0203e90:	7682                	ld	a3,32(sp)
ffffffffc0203e92:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0203e96:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0203e9a:	00371793          	slli	a5,a4,0x3
ffffffffc0203e9e:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0203ea0:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0203ea2:	078e                	slli	a5,a5,0x3
ffffffffc0203ea4:	97ce                	add	a5,a5,s3
ffffffffc0203ea6:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph ++) {
ffffffffc0203ea8:	00f9fc63          	bgeu	s3,a5,ffffffffc0203ec0 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD) {
ffffffffc0203eac:	0009a783          	lw	a5,0(s3)
ffffffffc0203eb0:	4705                	li	a4,1
ffffffffc0203eb2:	12e78f63          	beq	a5,a4,ffffffffc0203ff0 <do_execve+0x27a>
    for (; ph < ph_end; ph ++) {
ffffffffc0203eb6:	77a2                	ld	a5,40(sp)
ffffffffc0203eb8:	03898993          	addi	s3,s3,56
ffffffffc0203ebc:	fef9e8e3          	bltu	s3,a5,ffffffffc0203eac <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
ffffffffc0203ec0:	4701                	li	a4,0
ffffffffc0203ec2:	46ad                	li	a3,11
ffffffffc0203ec4:	00100637          	lui	a2,0x100
ffffffffc0203ec8:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0203ecc:	8526                	mv	a0,s1
ffffffffc0203ece:	f65fe0ef          	jal	ra,ffffffffc0202e32 <mm_map>
ffffffffc0203ed2:	8a2a                	mv	s4,a0
ffffffffc0203ed4:	1e051063          	bnez	a0,ffffffffc02040b4 <do_execve+0x33e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc0203ed8:	6c88                	ld	a0,24(s1)
ffffffffc0203eda:	467d                	li	a2,31
ffffffffc0203edc:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0203ee0:	eb0fe0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
ffffffffc0203ee4:	38050163          	beqz	a0,ffffffffc0204266 <do_execve+0x4f0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc0203ee8:	6c88                	ld	a0,24(s1)
ffffffffc0203eea:	467d                	li	a2,31
ffffffffc0203eec:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0203ef0:	ea0fe0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
ffffffffc0203ef4:	34050963          	beqz	a0,ffffffffc0204246 <do_execve+0x4d0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc0203ef8:	6c88                	ld	a0,24(s1)
ffffffffc0203efa:	467d                	li	a2,31
ffffffffc0203efc:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0203f00:	e90fe0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
ffffffffc0203f04:	32050163          	beqz	a0,ffffffffc0204226 <do_execve+0x4b0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0203f08:	6c88                	ld	a0,24(s1)
ffffffffc0203f0a:	467d                	li	a2,31
ffffffffc0203f0c:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0203f10:	e80fe0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
ffffffffc0203f14:	2e050963          	beqz	a0,ffffffffc0204206 <do_execve+0x490>
    mm->mm_count += 1;
ffffffffc0203f18:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0203f1a:	000db603          	ld	a2,0(s11)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0203f1e:	6c94                	ld	a3,24(s1)
ffffffffc0203f20:	2785                	addiw	a5,a5,1
ffffffffc0203f22:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0203f24:	f604                	sd	s1,40(a2)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0203f26:	c02007b7          	lui	a5,0xc0200
ffffffffc0203f2a:	2cf6e263          	bltu	a3,a5,ffffffffc02041ee <do_execve+0x478>
ffffffffc0203f2e:	000b3783          	ld	a5,0(s6)
ffffffffc0203f32:	577d                	li	a4,-1
ffffffffc0203f34:	177e                	slli	a4,a4,0x3f
ffffffffc0203f36:	8e9d                	sub	a3,a3,a5
ffffffffc0203f38:	00c6d793          	srli	a5,a3,0xc
ffffffffc0203f3c:	f654                	sd	a3,168(a2)
ffffffffc0203f3e:	8fd9                	or	a5,a5,a4
ffffffffc0203f40:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0203f44:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0203f46:	4581                	li	a1,0
ffffffffc0203f48:	12000613          	li	a2,288
ffffffffc0203f4c:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0203f4e:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0203f52:	615000ef          	jal	ra,ffffffffc0204d66 <memset>
    tf->epc = elf->e_entry;
ffffffffc0203f56:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f58:	000db483          	ld	s1,0(s11)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0203f5c:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0203f60:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0203f62:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f64:	0b448493          	addi	s1,s1,180
    tf->gpr.sp = USTACKTOP;
ffffffffc0203f68:	07fe                	slli	a5,a5,0x1f
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f6a:	4641                	li	a2,16
ffffffffc0203f6c:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0203f6e:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0203f70:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0203f74:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f78:	8526                	mv	a0,s1
ffffffffc0203f7a:	5ed000ef          	jal	ra,ffffffffc0204d66 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203f7e:	463d                	li	a2,15
ffffffffc0203f80:	180c                	addi	a1,sp,48
ffffffffc0203f82:	8526                	mv	a0,s1
ffffffffc0203f84:	5f5000ef          	jal	ra,ffffffffc0204d78 <memcpy>
}
ffffffffc0203f88:	70aa                	ld	ra,168(sp)
ffffffffc0203f8a:	740a                	ld	s0,160(sp)
ffffffffc0203f8c:	64ea                	ld	s1,152(sp)
ffffffffc0203f8e:	694a                	ld	s2,144(sp)
ffffffffc0203f90:	69aa                	ld	s3,136(sp)
ffffffffc0203f92:	7ae6                	ld	s5,120(sp)
ffffffffc0203f94:	7b46                	ld	s6,112(sp)
ffffffffc0203f96:	7ba6                	ld	s7,104(sp)
ffffffffc0203f98:	7c06                	ld	s8,96(sp)
ffffffffc0203f9a:	6ce6                	ld	s9,88(sp)
ffffffffc0203f9c:	6d46                	ld	s10,80(sp)
ffffffffc0203f9e:	6da6                	ld	s11,72(sp)
ffffffffc0203fa0:	8552                	mv	a0,s4
ffffffffc0203fa2:	6a0a                	ld	s4,128(sp)
ffffffffc0203fa4:	614d                	addi	sp,sp,176
ffffffffc0203fa6:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0203fa8:	463d                	li	a2,15
ffffffffc0203faa:	85ca                	mv	a1,s2
ffffffffc0203fac:	1808                	addi	a0,sp,48
ffffffffc0203fae:	5cb000ef          	jal	ra,ffffffffc0204d78 <memcpy>
    if (mm != NULL) {
ffffffffc0203fb2:	e20993e3          	bnez	s3,ffffffffc0203dd8 <do_execve+0x62>
    if (current->mm != NULL) {
ffffffffc0203fb6:	000db783          	ld	a5,0(s11)
ffffffffc0203fba:	779c                	ld	a5,40(a5)
ffffffffc0203fbc:	e4078ae3          	beqz	a5,ffffffffc0203e10 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0203fc0:	00002617          	auipc	a2,0x2
ffffffffc0203fc4:	48860613          	addi	a2,a2,1160 # ffffffffc0206448 <default_pmm_manager+0x978>
ffffffffc0203fc8:	1d100593          	li	a1,465
ffffffffc0203fcc:	00002517          	auipc	a0,0x2
ffffffffc0203fd0:	29c50513          	addi	a0,a0,668 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0203fd4:	ca2fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    put_pgdir(mm);
ffffffffc0203fd8:	8526                	mv	a0,s1
ffffffffc0203fda:	c1eff0ef          	jal	ra,ffffffffc02033f8 <put_pgdir>
    mm_destroy(mm);
ffffffffc0203fde:	8526                	mv	a0,s1
ffffffffc0203fe0:	e01fe0ef          	jal	ra,ffffffffc0202de0 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0203fe4:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0203fe6:	8552                	mv	a0,s4
ffffffffc0203fe8:	94fff0ef          	jal	ra,ffffffffc0203936 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0203fec:	5a71                	li	s4,-4
ffffffffc0203fee:	bfe5                	j	ffffffffc0203fe6 <do_execve+0x270>
        if (ph->p_filesz > ph->p_memsz) {
ffffffffc0203ff0:	0289b603          	ld	a2,40(s3)
ffffffffc0203ff4:	0209b783          	ld	a5,32(s3)
ffffffffc0203ff8:	1cf66d63          	bltu	a2,a5,ffffffffc02041d2 <do_execve+0x45c>
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc0203ffc:	0049a783          	lw	a5,4(s3)
ffffffffc0204000:	0017f693          	andi	a3,a5,1
ffffffffc0204004:	c291                	beqz	a3,ffffffffc0204008 <do_execve+0x292>
ffffffffc0204006:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0204008:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc020400c:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc020400e:	e779                	bnez	a4,ffffffffc02040dc <do_execve+0x366>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204010:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0204012:	c781                	beqz	a5,ffffffffc020401a <do_execve+0x2a4>
ffffffffc0204014:	0016e693          	ori	a3,a3,1
        if (vm_flags & VM_READ) perm |= PTE_R;
ffffffffc0204018:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc020401a:	0026f793          	andi	a5,a3,2
ffffffffc020401e:	e3f1                	bnez	a5,ffffffffc02040e2 <do_execve+0x36c>
        if (vm_flags & VM_EXEC) perm |= PTE_X;
ffffffffc0204020:	0046f793          	andi	a5,a3,4
ffffffffc0204024:	c399                	beqz	a5,ffffffffc020402a <do_execve+0x2b4>
ffffffffc0204026:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
ffffffffc020402a:	0109b583          	ld	a1,16(s3)
ffffffffc020402e:	4701                	li	a4,0
ffffffffc0204030:	8526                	mv	a0,s1
ffffffffc0204032:	e01fe0ef          	jal	ra,ffffffffc0202e32 <mm_map>
ffffffffc0204036:	8a2a                	mv	s4,a0
ffffffffc0204038:	ed35                	bnez	a0,ffffffffc02040b4 <do_execve+0x33e>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc020403a:	0109bb83          	ld	s7,16(s3)
ffffffffc020403e:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204040:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204044:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204048:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc020404c:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc020404e:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204050:	993e                	add	s2,s2,a5
        while (start < end) {
ffffffffc0204052:	054be963          	bltu	s7,s4,ffffffffc02040a4 <do_execve+0x32e>
ffffffffc0204056:	aa95                	j	ffffffffc02041ca <do_execve+0x454>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204058:	6785                	lui	a5,0x1
ffffffffc020405a:	415b8533          	sub	a0,s7,s5
ffffffffc020405e:	9abe                	add	s5,s5,a5
ffffffffc0204060:	417a8633          	sub	a2,s5,s7
            if (end < la) {
ffffffffc0204064:	015a7463          	bgeu	s4,s5,ffffffffc020406c <do_execve+0x2f6>
                size -= la - end;
ffffffffc0204068:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc020406c:	000cb683          	ld	a3,0(s9)
ffffffffc0204070:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204072:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204076:	40d406b3          	sub	a3,s0,a3
ffffffffc020407a:	8699                	srai	a3,a3,0x6
ffffffffc020407c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020407e:	67e2                	ld	a5,24(sp)
ffffffffc0204080:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204084:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204086:	14b87863          	bgeu	a6,a1,ffffffffc02041d6 <do_execve+0x460>
ffffffffc020408a:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc020408e:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204090:	9bb2                	add	s7,s7,a2
ffffffffc0204092:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204094:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204096:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204098:	4e1000ef          	jal	ra,ffffffffc0204d78 <memcpy>
            start += size, from += size;
ffffffffc020409c:	6622                	ld	a2,8(sp)
ffffffffc020409e:	9932                	add	s2,s2,a2
        while (start < end) {
ffffffffc02040a0:	054bf363          	bgeu	s7,s4,ffffffffc02040e6 <do_execve+0x370>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc02040a4:	6c88                	ld	a0,24(s1)
ffffffffc02040a6:	866a                	mv	a2,s10
ffffffffc02040a8:	85d6                	mv	a1,s5
ffffffffc02040aa:	ce6fe0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
ffffffffc02040ae:	842a                	mv	s0,a0
ffffffffc02040b0:	f545                	bnez	a0,ffffffffc0204058 <do_execve+0x2e2>
        ret = -E_NO_MEM;
ffffffffc02040b2:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc02040b4:	8526                	mv	a0,s1
ffffffffc02040b6:	ec7fe0ef          	jal	ra,ffffffffc0202f7c <exit_mmap>
    put_pgdir(mm);
ffffffffc02040ba:	8526                	mv	a0,s1
ffffffffc02040bc:	b3cff0ef          	jal	ra,ffffffffc02033f8 <put_pgdir>
    mm_destroy(mm);
ffffffffc02040c0:	8526                	mv	a0,s1
ffffffffc02040c2:	d1ffe0ef          	jal	ra,ffffffffc0202de0 <mm_destroy>
    return ret;
ffffffffc02040c6:	b705                	j	ffffffffc0203fe6 <do_execve+0x270>
            exit_mmap(mm);
ffffffffc02040c8:	854e                	mv	a0,s3
ffffffffc02040ca:	eb3fe0ef          	jal	ra,ffffffffc0202f7c <exit_mmap>
            put_pgdir(mm);
ffffffffc02040ce:	854e                	mv	a0,s3
ffffffffc02040d0:	b28ff0ef          	jal	ra,ffffffffc02033f8 <put_pgdir>
            mm_destroy(mm);
ffffffffc02040d4:	854e                	mv	a0,s3
ffffffffc02040d6:	d0bfe0ef          	jal	ra,ffffffffc0202de0 <mm_destroy>
ffffffffc02040da:	b33d                	j	ffffffffc0203e08 <do_execve+0x92>
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc02040dc:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc02040e0:	fb95                	bnez	a5,ffffffffc0204014 <do_execve+0x29e>
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc02040e2:	4d5d                	li	s10,23
ffffffffc02040e4:	bf35                	j	ffffffffc0204020 <do_execve+0x2aa>
        end = ph->p_va + ph->p_memsz;
ffffffffc02040e6:	0109b683          	ld	a3,16(s3)
ffffffffc02040ea:	0289b903          	ld	s2,40(s3)
ffffffffc02040ee:	9936                	add	s2,s2,a3
        if (start < la) {
ffffffffc02040f0:	075bfd63          	bgeu	s7,s5,ffffffffc020416a <do_execve+0x3f4>
            if (start == end) {
ffffffffc02040f4:	dd7901e3          	beq	s2,s7,ffffffffc0203eb6 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc02040f8:	6785                	lui	a5,0x1
ffffffffc02040fa:	00fb8533          	add	a0,s7,a5
ffffffffc02040fe:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204102:	41790a33          	sub	s4,s2,s7
            if (end < la) {
ffffffffc0204106:	0b597d63          	bgeu	s2,s5,ffffffffc02041c0 <do_execve+0x44a>
    return page - pages + nbase;
ffffffffc020410a:	000cb683          	ld	a3,0(s9)
ffffffffc020410e:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204110:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204114:	40d406b3          	sub	a3,s0,a3
ffffffffc0204118:	8699                	srai	a3,a3,0x6
ffffffffc020411a:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020411c:	67e2                	ld	a5,24(sp)
ffffffffc020411e:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204122:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204124:	0ac5f963          	bgeu	a1,a2,ffffffffc02041d6 <do_execve+0x460>
ffffffffc0204128:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc020412c:	8652                	mv	a2,s4
ffffffffc020412e:	4581                	li	a1,0
ffffffffc0204130:	96c2                	add	a3,a3,a6
ffffffffc0204132:	9536                	add	a0,a0,a3
ffffffffc0204134:	433000ef          	jal	ra,ffffffffc0204d66 <memset>
            start += size;
ffffffffc0204138:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc020413c:	03597463          	bgeu	s2,s5,ffffffffc0204164 <do_execve+0x3ee>
ffffffffc0204140:	d6e90be3          	beq	s2,a4,ffffffffc0203eb6 <do_execve+0x140>
ffffffffc0204144:	00002697          	auipc	a3,0x2
ffffffffc0204148:	32c68693          	addi	a3,a3,812 # ffffffffc0206470 <default_pmm_manager+0x9a0>
ffffffffc020414c:	00001617          	auipc	a2,0x1
ffffffffc0204150:	2ec60613          	addi	a2,a2,748 # ffffffffc0205438 <commands+0x448>
ffffffffc0204154:	22600593          	li	a1,550
ffffffffc0204158:	00002517          	auipc	a0,0x2
ffffffffc020415c:	11050513          	addi	a0,a0,272 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204160:	b16fc0ef          	jal	ra,ffffffffc0200476 <__panic>
ffffffffc0204164:	ff5710e3          	bne	a4,s5,ffffffffc0204144 <do_execve+0x3ce>
ffffffffc0204168:	8bd6                	mv	s7,s5
        while (start < end) {
ffffffffc020416a:	d52bf6e3          	bgeu	s7,s2,ffffffffc0203eb6 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc020416e:	6c88                	ld	a0,24(s1)
ffffffffc0204170:	866a                	mv	a2,s10
ffffffffc0204172:	85d6                	mv	a1,s5
ffffffffc0204174:	c1cfe0ef          	jal	ra,ffffffffc0202590 <pgdir_alloc_page>
ffffffffc0204178:	842a                	mv	s0,a0
ffffffffc020417a:	dd05                	beqz	a0,ffffffffc02040b2 <do_execve+0x33c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc020417c:	6785                	lui	a5,0x1
ffffffffc020417e:	415b8533          	sub	a0,s7,s5
ffffffffc0204182:	9abe                	add	s5,s5,a5
ffffffffc0204184:	417a8633          	sub	a2,s5,s7
            if (end < la) {
ffffffffc0204188:	01597463          	bgeu	s2,s5,ffffffffc0204190 <do_execve+0x41a>
                size -= la - end;
ffffffffc020418c:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204190:	000cb683          	ld	a3,0(s9)
ffffffffc0204194:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204196:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc020419a:	40d406b3          	sub	a3,s0,a3
ffffffffc020419e:	8699                	srai	a3,a3,0x6
ffffffffc02041a0:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02041a2:	67e2                	ld	a5,24(sp)
ffffffffc02041a4:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc02041a8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02041aa:	02b87663          	bgeu	a6,a1,ffffffffc02041d6 <do_execve+0x460>
ffffffffc02041ae:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc02041b2:	4581                	li	a1,0
            start += size;
ffffffffc02041b4:	9bb2                	add	s7,s7,a2
ffffffffc02041b6:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc02041b8:	9536                	add	a0,a0,a3
ffffffffc02041ba:	3ad000ef          	jal	ra,ffffffffc0204d66 <memset>
ffffffffc02041be:	b775                	j	ffffffffc020416a <do_execve+0x3f4>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc02041c0:	417a8a33          	sub	s4,s5,s7
ffffffffc02041c4:	b799                	j	ffffffffc020410a <do_execve+0x394>
        return -E_INVAL;
ffffffffc02041c6:	5a75                	li	s4,-3
ffffffffc02041c8:	b3c1                	j	ffffffffc0203f88 <do_execve+0x212>
        while (start < end) {
ffffffffc02041ca:	86de                	mv	a3,s7
ffffffffc02041cc:	bf39                	j	ffffffffc02040ea <do_execve+0x374>
    int ret = -E_NO_MEM;
ffffffffc02041ce:	5a71                	li	s4,-4
ffffffffc02041d0:	bdc5                	j	ffffffffc02040c0 <do_execve+0x34a>
            ret = -E_INVAL_ELF;
ffffffffc02041d2:	5a61                	li	s4,-8
ffffffffc02041d4:	b5c5                	j	ffffffffc02040b4 <do_execve+0x33e>
ffffffffc02041d6:	00002617          	auipc	a2,0x2
ffffffffc02041da:	93260613          	addi	a2,a2,-1742 # ffffffffc0205b08 <default_pmm_manager+0x38>
ffffffffc02041de:	06900593          	li	a1,105
ffffffffc02041e2:	00002517          	auipc	a0,0x2
ffffffffc02041e6:	94e50513          	addi	a0,a0,-1714 # ffffffffc0205b30 <default_pmm_manager+0x60>
ffffffffc02041ea:	a8cfc0ef          	jal	ra,ffffffffc0200476 <__panic>
    current->cr3 = PADDR(mm->pgdir);
ffffffffc02041ee:	00002617          	auipc	a2,0x2
ffffffffc02041f2:	98a60613          	addi	a2,a2,-1654 # ffffffffc0205b78 <default_pmm_manager+0xa8>
ffffffffc02041f6:	24100593          	li	a1,577
ffffffffc02041fa:	00002517          	auipc	a0,0x2
ffffffffc02041fe:	06e50513          	addi	a0,a0,110 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204202:	a74fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0204206:	00002697          	auipc	a3,0x2
ffffffffc020420a:	38268693          	addi	a3,a3,898 # ffffffffc0206588 <default_pmm_manager+0xab8>
ffffffffc020420e:	00001617          	auipc	a2,0x1
ffffffffc0204212:	22a60613          	addi	a2,a2,554 # ffffffffc0205438 <commands+0x448>
ffffffffc0204216:	23c00593          	li	a1,572
ffffffffc020421a:	00002517          	auipc	a0,0x2
ffffffffc020421e:	04e50513          	addi	a0,a0,78 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204222:	a54fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc0204226:	00002697          	auipc	a3,0x2
ffffffffc020422a:	31a68693          	addi	a3,a3,794 # ffffffffc0206540 <default_pmm_manager+0xa70>
ffffffffc020422e:	00001617          	auipc	a2,0x1
ffffffffc0204232:	20a60613          	addi	a2,a2,522 # ffffffffc0205438 <commands+0x448>
ffffffffc0204236:	23b00593          	li	a1,571
ffffffffc020423a:	00002517          	auipc	a0,0x2
ffffffffc020423e:	02e50513          	addi	a0,a0,46 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204242:	a34fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc0204246:	00002697          	auipc	a3,0x2
ffffffffc020424a:	2b268693          	addi	a3,a3,690 # ffffffffc02064f8 <default_pmm_manager+0xa28>
ffffffffc020424e:	00001617          	auipc	a2,0x1
ffffffffc0204252:	1ea60613          	addi	a2,a2,490 # ffffffffc0205438 <commands+0x448>
ffffffffc0204256:	23a00593          	li	a1,570
ffffffffc020425a:	00002517          	auipc	a0,0x2
ffffffffc020425e:	00e50513          	addi	a0,a0,14 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204262:	a14fc0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc0204266:	00002697          	auipc	a3,0x2
ffffffffc020426a:	24a68693          	addi	a3,a3,586 # ffffffffc02064b0 <default_pmm_manager+0x9e0>
ffffffffc020426e:	00001617          	auipc	a2,0x1
ffffffffc0204272:	1ca60613          	addi	a2,a2,458 # ffffffffc0205438 <commands+0x448>
ffffffffc0204276:	23900593          	li	a1,569
ffffffffc020427a:	00002517          	auipc	a0,0x2
ffffffffc020427e:	fee50513          	addi	a0,a0,-18 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204282:	9f4fc0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0204286 <do_yield>:
    current->need_resched = 1;
ffffffffc0204286:	00031797          	auipc	a5,0x31
ffffffffc020428a:	ae27b783          	ld	a5,-1310(a5) # ffffffffc0234d68 <current>
ffffffffc020428e:	4705                	li	a4,1
ffffffffc0204290:	ef98                	sd	a4,24(a5)
}
ffffffffc0204292:	4501                	li	a0,0
ffffffffc0204294:	8082                	ret

ffffffffc0204296 <do_wait>:
do_wait(int pid, int *code_store) {
ffffffffc0204296:	1101                	addi	sp,sp,-32
ffffffffc0204298:	e822                	sd	s0,16(sp)
ffffffffc020429a:	e426                	sd	s1,8(sp)
ffffffffc020429c:	ec06                	sd	ra,24(sp)
ffffffffc020429e:	842e                	mv	s0,a1
ffffffffc02042a0:	84aa                	mv	s1,a0
    if (code_store != NULL) {
ffffffffc02042a2:	c999                	beqz	a1,ffffffffc02042b8 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc02042a4:	00031797          	auipc	a5,0x31
ffffffffc02042a8:	ac47b783          	ld	a5,-1340(a5) # ffffffffc0234d68 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
ffffffffc02042ac:	7788                	ld	a0,40(a5)
ffffffffc02042ae:	4685                	li	a3,1
ffffffffc02042b0:	4611                	li	a2,4
ffffffffc02042b2:	e45fe0ef          	jal	ra,ffffffffc02030f6 <user_mem_check>
ffffffffc02042b6:	c909                	beqz	a0,ffffffffc02042c8 <do_wait+0x32>
ffffffffc02042b8:	85a2                	mv	a1,s0
}
ffffffffc02042ba:	6442                	ld	s0,16(sp)
ffffffffc02042bc:	60e2                	ld	ra,24(sp)
ffffffffc02042be:	8526                	mv	a0,s1
ffffffffc02042c0:	64a2                	ld	s1,8(sp)
ffffffffc02042c2:	6105                	addi	sp,sp,32
ffffffffc02042c4:	fbcff06f          	j	ffffffffc0203a80 <do_wait.part.0>
ffffffffc02042c8:	60e2                	ld	ra,24(sp)
ffffffffc02042ca:	6442                	ld	s0,16(sp)
ffffffffc02042cc:	64a2                	ld	s1,8(sp)
ffffffffc02042ce:	5575                	li	a0,-3
ffffffffc02042d0:	6105                	addi	sp,sp,32
ffffffffc02042d2:	8082                	ret

ffffffffc02042d4 <do_kill>:
do_kill(int pid) {
ffffffffc02042d4:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID) {
ffffffffc02042d6:	6789                	lui	a5,0x2
do_kill(int pid) {
ffffffffc02042d8:	e406                	sd	ra,8(sp)
ffffffffc02042da:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID) {
ffffffffc02042dc:	fff5071b          	addiw	a4,a0,-1
ffffffffc02042e0:	17f9                	addi	a5,a5,-2
ffffffffc02042e2:	02e7e863          	bltu	a5,a4,ffffffffc0204312 <do_kill+0x3e>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02042e6:	842a                	mv	s0,a0
ffffffffc02042e8:	45a9                	li	a1,10
ffffffffc02042ea:	2501                	sext.w	a0,a0
ffffffffc02042ec:	60c000ef          	jal	ra,ffffffffc02048f8 <hash32>
ffffffffc02042f0:	02051693          	slli	a3,a0,0x20
ffffffffc02042f4:	82f1                	srli	a3,a3,0x1c
ffffffffc02042f6:	0002d797          	auipc	a5,0x2d
ffffffffc02042fa:	9c278793          	addi	a5,a5,-1598 # ffffffffc0230cb8 <hash_list>
ffffffffc02042fe:	96be                	add	a3,a3,a5
ffffffffc0204300:	8536                	mv	a0,a3
        while ((le = list_next(le)) != list) {
ffffffffc0204302:	a029                	j	ffffffffc020430c <do_kill+0x38>
            if (proc->pid == pid) {
ffffffffc0204304:	f2c52703          	lw	a4,-212(a0)
ffffffffc0204308:	00870b63          	beq	a4,s0,ffffffffc020431e <do_kill+0x4a>
ffffffffc020430c:	6508                	ld	a0,8(a0)
        while ((le = list_next(le)) != list) {
ffffffffc020430e:	fea69be3          	bne	a3,a0,ffffffffc0204304 <do_kill+0x30>
    return -E_INVAL;
ffffffffc0204312:	5475                	li	s0,-3
}
ffffffffc0204314:	60a2                	ld	ra,8(sp)
ffffffffc0204316:	8522                	mv	a0,s0
ffffffffc0204318:	6402                	ld	s0,0(sp)
ffffffffc020431a:	0141                	addi	sp,sp,16
ffffffffc020431c:	8082                	ret
        if (!(proc->flags & PF_EXITING)) {
ffffffffc020431e:	fd852703          	lw	a4,-40(a0)
ffffffffc0204322:	00177693          	andi	a3,a4,1
ffffffffc0204326:	e295                	bnez	a3,ffffffffc020434a <do_kill+0x76>
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc0204328:	4954                	lw	a3,20(a0)
            proc->flags |= PF_EXITING;
ffffffffc020432a:	00176713          	ori	a4,a4,1
ffffffffc020432e:	fce52c23          	sw	a4,-40(a0)
            return 0;
ffffffffc0204332:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc0204334:	fe06d0e3          	bgez	a3,ffffffffc0204314 <do_kill+0x40>
                wakeup_proc(proc);
ffffffffc0204338:	f2850513          	addi	a0,a0,-216
ffffffffc020433c:	354000ef          	jal	ra,ffffffffc0204690 <wakeup_proc>
}
ffffffffc0204340:	60a2                	ld	ra,8(sp)
ffffffffc0204342:	8522                	mv	a0,s0
ffffffffc0204344:	6402                	ld	s0,0(sp)
ffffffffc0204346:	0141                	addi	sp,sp,16
ffffffffc0204348:	8082                	ret
        return -E_KILLED;
ffffffffc020434a:	545d                	li	s0,-9
ffffffffc020434c:	b7e1                	j	ffffffffc0204314 <do_kill+0x40>

ffffffffc020434e <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc020434e:	1101                	addi	sp,sp,-32
ffffffffc0204350:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204352:	00031797          	auipc	a5,0x31
ffffffffc0204356:	96678793          	addi	a5,a5,-1690 # ffffffffc0234cb8 <proc_list>
ffffffffc020435a:	ec06                	sd	ra,24(sp)
ffffffffc020435c:	e822                	sd	s0,16(sp)
ffffffffc020435e:	e04a                	sd	s2,0(sp)
ffffffffc0204360:	0002d497          	auipc	s1,0x2d
ffffffffc0204364:	95848493          	addi	s1,s1,-1704 # ffffffffc0230cb8 <hash_list>
ffffffffc0204368:	e79c                	sd	a5,8(a5)
ffffffffc020436a:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc020436c:	00031717          	auipc	a4,0x31
ffffffffc0204370:	94c70713          	addi	a4,a4,-1716 # ffffffffc0234cb8 <proc_list>
ffffffffc0204374:	87a6                	mv	a5,s1
ffffffffc0204376:	e79c                	sd	a5,8(a5)
ffffffffc0204378:	e39c                	sd	a5,0(a5)
ffffffffc020437a:	07c1                	addi	a5,a5,16
ffffffffc020437c:	fef71de3          	bne	a4,a5,ffffffffc0204376 <proc_init+0x28>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0204380:	f67fe0ef          	jal	ra,ffffffffc02032e6 <alloc_proc>
ffffffffc0204384:	00031917          	auipc	s2,0x31
ffffffffc0204388:	9ec90913          	addi	s2,s2,-1556 # ffffffffc0234d70 <idleproc>
ffffffffc020438c:	00a93023          	sd	a0,0(s2)
ffffffffc0204390:	0e050e63          	beqz	a0,ffffffffc020448c <proc_init+0x13e>
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204394:	4789                	li	a5,2
ffffffffc0204396:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204398:	00003797          	auipc	a5,0x3
ffffffffc020439c:	c6878793          	addi	a5,a5,-920 # ffffffffc0207000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02043a0:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02043a4:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc02043a6:	4785                	li	a5,1
ffffffffc02043a8:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02043aa:	4641                	li	a2,16
ffffffffc02043ac:	4581                	li	a1,0
ffffffffc02043ae:	8522                	mv	a0,s0
ffffffffc02043b0:	1b7000ef          	jal	ra,ffffffffc0204d66 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02043b4:	463d                	li	a2,15
ffffffffc02043b6:	00002597          	auipc	a1,0x2
ffffffffc02043ba:	23258593          	addi	a1,a1,562 # ffffffffc02065e8 <default_pmm_manager+0xb18>
ffffffffc02043be:	8522                	mv	a0,s0
ffffffffc02043c0:	1b9000ef          	jal	ra,ffffffffc0204d78 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc02043c4:	00031717          	auipc	a4,0x31
ffffffffc02043c8:	9bc70713          	addi	a4,a4,-1604 # ffffffffc0234d80 <nr_process>
ffffffffc02043cc:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02043ce:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02043d2:	4601                	li	a2,0
    nr_process ++;
ffffffffc02043d4:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02043d6:	4581                	li	a1,0
ffffffffc02043d8:	00000517          	auipc	a0,0x0
ffffffffc02043dc:	87a50513          	addi	a0,a0,-1926 # ffffffffc0203c52 <init_main>
    nr_process ++;
ffffffffc02043e0:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02043e2:	00031797          	auipc	a5,0x31
ffffffffc02043e6:	98d7b323          	sd	a3,-1658(a5) # ffffffffc0234d68 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02043ea:	cfcff0ef          	jal	ra,ffffffffc02038e6 <kernel_thread>
ffffffffc02043ee:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc02043f0:	08a05263          	blez	a0,ffffffffc0204474 <proc_init+0x126>
    if (0 < pid && pid < MAX_PID) {
ffffffffc02043f4:	6789                	lui	a5,0x2
ffffffffc02043f6:	fff5071b          	addiw	a4,a0,-1
ffffffffc02043fa:	17f9                	addi	a5,a5,-2
ffffffffc02043fc:	2501                	sext.w	a0,a0
ffffffffc02043fe:	02e7e263          	bltu	a5,a4,ffffffffc0204422 <proc_init+0xd4>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204402:	45a9                	li	a1,10
ffffffffc0204404:	4f4000ef          	jal	ra,ffffffffc02048f8 <hash32>
ffffffffc0204408:	02051693          	slli	a3,a0,0x20
ffffffffc020440c:	82f1                	srli	a3,a3,0x1c
ffffffffc020440e:	96a6                	add	a3,a3,s1
ffffffffc0204410:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0204412:	a029                	j	ffffffffc020441c <proc_init+0xce>
            if (proc->pid == pid) {
ffffffffc0204414:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_hello_out_size-0x7e54>
ffffffffc0204418:	04870b63          	beq	a4,s0,ffffffffc020446e <proc_init+0x120>
    return listelm->next;
ffffffffc020441c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc020441e:	fef69be3          	bne	a3,a5,ffffffffc0204414 <proc_init+0xc6>
    return NULL;
ffffffffc0204422:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204424:	0b478493          	addi	s1,a5,180
ffffffffc0204428:	4641                	li	a2,16
ffffffffc020442a:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020442c:	00031417          	auipc	s0,0x31
ffffffffc0204430:	94c40413          	addi	s0,s0,-1716 # ffffffffc0234d78 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204434:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204436:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204438:	12f000ef          	jal	ra,ffffffffc0204d66 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020443c:	463d                	li	a2,15
ffffffffc020443e:	00002597          	auipc	a1,0x2
ffffffffc0204442:	1d258593          	addi	a1,a1,466 # ffffffffc0206610 <default_pmm_manager+0xb40>
ffffffffc0204446:	8526                	mv	a0,s1
ffffffffc0204448:	131000ef          	jal	ra,ffffffffc0204d78 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020444c:	00093783          	ld	a5,0(s2)
ffffffffc0204450:	cbb5                	beqz	a5,ffffffffc02044c4 <proc_init+0x176>
ffffffffc0204452:	43dc                	lw	a5,4(a5)
ffffffffc0204454:	eba5                	bnez	a5,ffffffffc02044c4 <proc_init+0x176>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204456:	601c                	ld	a5,0(s0)
ffffffffc0204458:	c7b1                	beqz	a5,ffffffffc02044a4 <proc_init+0x156>
ffffffffc020445a:	43d8                	lw	a4,4(a5)
ffffffffc020445c:	4785                	li	a5,1
ffffffffc020445e:	04f71363          	bne	a4,a5,ffffffffc02044a4 <proc_init+0x156>
}
ffffffffc0204462:	60e2                	ld	ra,24(sp)
ffffffffc0204464:	6442                	ld	s0,16(sp)
ffffffffc0204466:	64a2                	ld	s1,8(sp)
ffffffffc0204468:	6902                	ld	s2,0(sp)
ffffffffc020446a:	6105                	addi	sp,sp,32
ffffffffc020446c:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020446e:	f2878793          	addi	a5,a5,-216
ffffffffc0204472:	bf4d                	j	ffffffffc0204424 <proc_init+0xd6>
        panic("create init_main failed.\n");
ffffffffc0204474:	00002617          	auipc	a2,0x2
ffffffffc0204478:	17c60613          	addi	a2,a2,380 # ffffffffc02065f0 <default_pmm_manager+0xb20>
ffffffffc020447c:	33e00593          	li	a1,830
ffffffffc0204480:	00002517          	auipc	a0,0x2
ffffffffc0204484:	de850513          	addi	a0,a0,-536 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc0204488:	feffb0ef          	jal	ra,ffffffffc0200476 <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc020448c:	00002617          	auipc	a2,0x2
ffffffffc0204490:	14460613          	addi	a2,a2,324 # ffffffffc02065d0 <default_pmm_manager+0xb00>
ffffffffc0204494:	33000593          	li	a1,816
ffffffffc0204498:	00002517          	auipc	a0,0x2
ffffffffc020449c:	dd050513          	addi	a0,a0,-560 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc02044a0:	fd7fb0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02044a4:	00002697          	auipc	a3,0x2
ffffffffc02044a8:	19c68693          	addi	a3,a3,412 # ffffffffc0206640 <default_pmm_manager+0xb70>
ffffffffc02044ac:	00001617          	auipc	a2,0x1
ffffffffc02044b0:	f8c60613          	addi	a2,a2,-116 # ffffffffc0205438 <commands+0x448>
ffffffffc02044b4:	34500593          	li	a1,837
ffffffffc02044b8:	00002517          	auipc	a0,0x2
ffffffffc02044bc:	db050513          	addi	a0,a0,-592 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc02044c0:	fb7fb0ef          	jal	ra,ffffffffc0200476 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02044c4:	00002697          	auipc	a3,0x2
ffffffffc02044c8:	15468693          	addi	a3,a3,340 # ffffffffc0206618 <default_pmm_manager+0xb48>
ffffffffc02044cc:	00001617          	auipc	a2,0x1
ffffffffc02044d0:	f6c60613          	addi	a2,a2,-148 # ffffffffc0205438 <commands+0x448>
ffffffffc02044d4:	34400593          	li	a1,836
ffffffffc02044d8:	00002517          	auipc	a0,0x2
ffffffffc02044dc:	d9050513          	addi	a0,a0,-624 # ffffffffc0206268 <default_pmm_manager+0x798>
ffffffffc02044e0:	f97fb0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02044e4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc02044e4:	1141                	addi	sp,sp,-16
ffffffffc02044e6:	e022                	sd	s0,0(sp)
ffffffffc02044e8:	e406                	sd	ra,8(sp)
ffffffffc02044ea:	00031417          	auipc	s0,0x31
ffffffffc02044ee:	87e40413          	addi	s0,s0,-1922 # ffffffffc0234d68 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc02044f2:	6018                	ld	a4,0(s0)
ffffffffc02044f4:	6f1c                	ld	a5,24(a4)
ffffffffc02044f6:	dffd                	beqz	a5,ffffffffc02044f4 <cpu_idle+0x10>
            schedule();
ffffffffc02044f8:	24a000ef          	jal	ra,ffffffffc0204742 <schedule>
ffffffffc02044fc:	bfdd                	j	ffffffffc02044f2 <cpu_idle+0xe>

ffffffffc02044fe <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02044fe:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204502:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204506:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204508:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020450a:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc020450e:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204512:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204516:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020451a:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc020451e:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204522:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204526:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020452a:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020452e:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204532:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204536:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020453a:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020453c:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020453e:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204542:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204546:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020454a:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020454e:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204552:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204556:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020455a:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020455e:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204562:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204566:	8082                	ret

ffffffffc0204568 <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc0204568:	e508                	sd	a0,8(a0)
ffffffffc020456a:	e108                	sd	a0,0(a0)
#include <default_sched.h>

static void
RR_init(struct run_queue *rq) {
    list_init(&(rq->run_list));
    rq->proc_num = 0;
ffffffffc020456c:	00052823          	sw	zero,16(a0)
}
ffffffffc0204570:	8082                	ret

ffffffffc0204572 <RR_enqueue>:
    __list_add(elm, listelm->prev, listelm);
ffffffffc0204572:	611c                	ld	a5,0(a0)

static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {
    list_add_before(&(rq->run_list), &(proc->run_link));
ffffffffc0204574:	11058713          	addi	a4,a1,272
    prev->next = next->prev = elm;
ffffffffc0204578:	e118                	sd	a4,0(a0)
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc020457a:	1205a683          	lw	a3,288(a1)
ffffffffc020457e:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc0204580:	10f5b823          	sd	a5,272(a1)
    elm->next = next;
ffffffffc0204584:	10a5bc23          	sd	a0,280(a1)
ffffffffc0204588:	495c                	lw	a5,20(a0)
ffffffffc020458a:	c299                	beqz	a3,ffffffffc0204590 <RR_enqueue+0x1e>
ffffffffc020458c:	00d7d463          	bge	a5,a3,ffffffffc0204594 <RR_enqueue+0x22>
        proc->time_slice = rq->max_time_slice;
ffffffffc0204590:	12f5a023          	sw	a5,288(a1)
    }
    proc->rq = rq;
    rq->proc_num ++;
ffffffffc0204594:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0204596:	10a5b423          	sd	a0,264(a1)
    rq->proc_num ++;
ffffffffc020459a:	2785                	addiw	a5,a5,1
ffffffffc020459c:	c91c                	sw	a5,16(a0)
}
ffffffffc020459e:	8082                	ret

ffffffffc02045a0 <RR_pick_next>:
    return listelm->next;
ffffffffc02045a0:	651c                	ld	a5,8(a0)
}

static struct proc_struct *
RR_pick_next(struct run_queue *rq) {
    list_entry_t *le = list_next(&(rq->run_list));
    if (le != &(rq->run_list)) {
ffffffffc02045a2:	00f50563          	beq	a0,a5,ffffffffc02045ac <RR_pick_next+0xc>
        return le2proc(le, run_link);
ffffffffc02045a6:	ef078513          	addi	a0,a5,-272
ffffffffc02045aa:	8082                	ret
    }
    return NULL;
ffffffffc02045ac:	4501                	li	a0,0
}
ffffffffc02045ae:	8082                	ret

ffffffffc02045b0 <RR_proc_tick>:

static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
ffffffffc02045b0:	1205a783          	lw	a5,288(a1)
ffffffffc02045b4:	00f05563          	blez	a5,ffffffffc02045be <RR_proc_tick+0xe>
        proc->time_slice --;
ffffffffc02045b8:	37fd                	addiw	a5,a5,-1
ffffffffc02045ba:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc02045be:	e399                	bnez	a5,ffffffffc02045c4 <RR_proc_tick+0x14>
        proc->need_resched = 1;
ffffffffc02045c0:	4785                	li	a5,1
ffffffffc02045c2:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc02045c4:	8082                	ret

ffffffffc02045c6 <RR_dequeue>:
    return list->next == list;
ffffffffc02045c6:	1185b703          	ld	a4,280(a1)
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
ffffffffc02045ca:	11058793          	addi	a5,a1,272
ffffffffc02045ce:	02e78363          	beq	a5,a4,ffffffffc02045f4 <RR_dequeue+0x2e>
ffffffffc02045d2:	1085b683          	ld	a3,264(a1)
ffffffffc02045d6:	00a69f63          	bne	a3,a0,ffffffffc02045f4 <RR_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc02045da:	1105b503          	ld	a0,272(a1)
    rq->proc_num --;
ffffffffc02045de:	4a90                	lw	a2,16(a3)
    prev->next = next;
ffffffffc02045e0:	e518                	sd	a4,8(a0)
    next->prev = prev;
ffffffffc02045e2:	e308                	sd	a0,0(a4)
    elm->prev = elm->next = elm;
ffffffffc02045e4:	10f5bc23          	sd	a5,280(a1)
ffffffffc02045e8:	10f5b823          	sd	a5,272(a1)
ffffffffc02045ec:	fff6079b          	addiw	a5,a2,-1
ffffffffc02045f0:	ca9c                	sw	a5,16(a3)
ffffffffc02045f2:	8082                	ret
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
ffffffffc02045f4:	1141                	addi	sp,sp,-16
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
ffffffffc02045f6:	00002697          	auipc	a3,0x2
ffffffffc02045fa:	07268693          	addi	a3,a3,114 # ffffffffc0206668 <default_pmm_manager+0xb98>
ffffffffc02045fe:	00001617          	auipc	a2,0x1
ffffffffc0204602:	e3a60613          	addi	a2,a2,-454 # ffffffffc0205438 <commands+0x448>
ffffffffc0204606:	45e5                	li	a1,25
ffffffffc0204608:	00002517          	auipc	a0,0x2
ffffffffc020460c:	09850513          	addi	a0,a0,152 # ffffffffc02066a0 <default_pmm_manager+0xbd0>
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
ffffffffc0204610:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
ffffffffc0204612:	e65fb0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0204616 <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void
sched_class_proc_tick(struct proc_struct *proc) {
    if (proc != idleproc) {
ffffffffc0204616:	00030797          	auipc	a5,0x30
ffffffffc020461a:	75a7b783          	ld	a5,1882(a5) # ffffffffc0234d70 <idleproc>
sched_class_proc_tick(struct proc_struct *proc) {
ffffffffc020461e:	85aa                	mv	a1,a0
    if (proc != idleproc) {
ffffffffc0204620:	00a78c63          	beq	a5,a0,ffffffffc0204638 <sched_class_proc_tick+0x22>
        sched_class->proc_tick(rq, proc);
ffffffffc0204624:	00030797          	auipc	a5,0x30
ffffffffc0204628:	76c7b783          	ld	a5,1900(a5) # ffffffffc0234d90 <sched_class>
ffffffffc020462c:	779c                	ld	a5,40(a5)
ffffffffc020462e:	00030517          	auipc	a0,0x30
ffffffffc0204632:	75a53503          	ld	a0,1882(a0) # ffffffffc0234d88 <rq>
ffffffffc0204636:	8782                	jr	a5
    }
    else {
        proc->need_resched = 1;
ffffffffc0204638:	4705                	li	a4,1
ffffffffc020463a:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc020463c:	8082                	ret

ffffffffc020463e <sched_init>:

static struct run_queue __rq;

void
sched_init(void) {
ffffffffc020463e:	1141                	addi	sp,sp,-16
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc0204640:	00025717          	auipc	a4,0x25
ffffffffc0204644:	21070713          	addi	a4,a4,528 # ffffffffc0229850 <default_sched_class>
sched_init(void) {
ffffffffc0204648:	e022                	sd	s0,0(sp)
ffffffffc020464a:	e406                	sd	ra,8(sp)
ffffffffc020464c:	00030797          	auipc	a5,0x30
ffffffffc0204650:	69c78793          	addi	a5,a5,1692 # ffffffffc0234ce8 <timer_list>
    //sched_class = &stride_sched_class;

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc0204654:	6714                	ld	a3,8(a4)
    rq = &__rq;
ffffffffc0204656:	00030517          	auipc	a0,0x30
ffffffffc020465a:	67250513          	addi	a0,a0,1650 # ffffffffc0234cc8 <__rq>
ffffffffc020465e:	e79c                	sd	a5,8(a5)
ffffffffc0204660:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0204662:	4795                	li	a5,5
ffffffffc0204664:	c95c                	sw	a5,20(a0)
    sched_class = &default_sched_class;
ffffffffc0204666:	00030417          	auipc	s0,0x30
ffffffffc020466a:	72a40413          	addi	s0,s0,1834 # ffffffffc0234d90 <sched_class>
    rq = &__rq;
ffffffffc020466e:	00030797          	auipc	a5,0x30
ffffffffc0204672:	70a7bd23          	sd	a0,1818(a5) # ffffffffc0234d88 <rq>
    sched_class = &default_sched_class;
ffffffffc0204676:	e018                	sd	a4,0(s0)
    sched_class->init(rq);
ffffffffc0204678:	9682                	jalr	a3

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020467a:	601c                	ld	a5,0(s0)
}
ffffffffc020467c:	6402                	ld	s0,0(sp)
ffffffffc020467e:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0204680:	638c                	ld	a1,0(a5)
ffffffffc0204682:	00002517          	auipc	a0,0x2
ffffffffc0204686:	04e50513          	addi	a0,a0,78 # ffffffffc02066d0 <default_pmm_manager+0xc00>
}
ffffffffc020468a:	0141                	addi	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020468c:	af1fb06f          	j	ffffffffc020017c <cprintf>

ffffffffc0204690 <wakeup_proc>:

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204690:	4118                	lw	a4,0(a0)
wakeup_proc(struct proc_struct *proc) {
ffffffffc0204692:	1101                	addi	sp,sp,-32
ffffffffc0204694:	ec06                	sd	ra,24(sp)
ffffffffc0204696:	e822                	sd	s0,16(sp)
ffffffffc0204698:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020469a:	478d                	li	a5,3
ffffffffc020469c:	08f70363          	beq	a4,a5,ffffffffc0204722 <wakeup_proc+0x92>
ffffffffc02046a0:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02046a2:	100027f3          	csrr	a5,sstatus
ffffffffc02046a6:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02046a8:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02046aa:	e7bd                	bnez	a5,ffffffffc0204718 <wakeup_proc+0x88>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
ffffffffc02046ac:	4789                	li	a5,2
ffffffffc02046ae:	04f70863          	beq	a4,a5,ffffffffc02046fe <wakeup_proc+0x6e>
            proc->state = PROC_RUNNABLE;
ffffffffc02046b2:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02046b4:	0e042623          	sw	zero,236(s0)
            if (proc != current) {
ffffffffc02046b8:	00030797          	auipc	a5,0x30
ffffffffc02046bc:	6b07b783          	ld	a5,1712(a5) # ffffffffc0234d68 <current>
ffffffffc02046c0:	02878363          	beq	a5,s0,ffffffffc02046e6 <wakeup_proc+0x56>
    if (proc != idleproc) {
ffffffffc02046c4:	00030797          	auipc	a5,0x30
ffffffffc02046c8:	6ac7b783          	ld	a5,1708(a5) # ffffffffc0234d70 <idleproc>
ffffffffc02046cc:	00f40d63          	beq	s0,a5,ffffffffc02046e6 <wakeup_proc+0x56>
        sched_class->enqueue(rq, proc);
ffffffffc02046d0:	00030797          	auipc	a5,0x30
ffffffffc02046d4:	6c07b783          	ld	a5,1728(a5) # ffffffffc0234d90 <sched_class>
ffffffffc02046d8:	6b9c                	ld	a5,16(a5)
ffffffffc02046da:	85a2                	mv	a1,s0
ffffffffc02046dc:	00030517          	auipc	a0,0x30
ffffffffc02046e0:	6ac53503          	ld	a0,1708(a0) # ffffffffc0234d88 <rq>
ffffffffc02046e4:	9782                	jalr	a5
    if (flag) {
ffffffffc02046e6:	e491                	bnez	s1,ffffffffc02046f2 <wakeup_proc+0x62>
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02046e8:	60e2                	ld	ra,24(sp)
ffffffffc02046ea:	6442                	ld	s0,16(sp)
ffffffffc02046ec:	64a2                	ld	s1,8(sp)
ffffffffc02046ee:	6105                	addi	sp,sp,32
ffffffffc02046f0:	8082                	ret
ffffffffc02046f2:	6442                	ld	s0,16(sp)
ffffffffc02046f4:	60e2                	ld	ra,24(sp)
ffffffffc02046f6:	64a2                	ld	s1,8(sp)
ffffffffc02046f8:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02046fa:	f39fb06f          	j	ffffffffc0200632 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc02046fe:	00002617          	auipc	a2,0x2
ffffffffc0204702:	02260613          	addi	a2,a2,34 # ffffffffc0206720 <default_pmm_manager+0xc50>
ffffffffc0204706:	04900593          	li	a1,73
ffffffffc020470a:	00002517          	auipc	a0,0x2
ffffffffc020470e:	ffe50513          	addi	a0,a0,-2 # ffffffffc0206708 <default_pmm_manager+0xc38>
ffffffffc0204712:	dcdfb0ef          	jal	ra,ffffffffc02004de <__warn>
ffffffffc0204716:	bfc1                	j	ffffffffc02046e6 <wakeup_proc+0x56>
        intr_disable();
ffffffffc0204718:	f21fb0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        if (proc->state != PROC_RUNNABLE) {
ffffffffc020471c:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020471e:	4485                	li	s1,1
ffffffffc0204720:	b771                	j	ffffffffc02046ac <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204722:	00002697          	auipc	a3,0x2
ffffffffc0204726:	fc668693          	addi	a3,a3,-58 # ffffffffc02066e8 <default_pmm_manager+0xc18>
ffffffffc020472a:	00001617          	auipc	a2,0x1
ffffffffc020472e:	d0e60613          	addi	a2,a2,-754 # ffffffffc0205438 <commands+0x448>
ffffffffc0204732:	03d00593          	li	a1,61
ffffffffc0204736:	00002517          	auipc	a0,0x2
ffffffffc020473a:	fd250513          	addi	a0,a0,-46 # ffffffffc0206708 <default_pmm_manager+0xc38>
ffffffffc020473e:	d39fb0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc0204742 <schedule>:

void
schedule(void) {
ffffffffc0204742:	7179                	addi	sp,sp,-48
ffffffffc0204744:	f406                	sd	ra,40(sp)
ffffffffc0204746:	f022                	sd	s0,32(sp)
ffffffffc0204748:	ec26                	sd	s1,24(sp)
ffffffffc020474a:	e84a                	sd	s2,16(sp)
ffffffffc020474c:	e44e                	sd	s3,8(sp)
ffffffffc020474e:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204750:	100027f3          	csrr	a5,sstatus
ffffffffc0204754:	8b89                	andi	a5,a5,2
ffffffffc0204756:	4a01                	li	s4,0
ffffffffc0204758:	ebc5                	bnez	a5,ffffffffc0204808 <schedule+0xc6>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020475a:	00030497          	auipc	s1,0x30
ffffffffc020475e:	60e48493          	addi	s1,s1,1550 # ffffffffc0234d68 <current>
ffffffffc0204762:	608c                	ld	a1,0(s1)
        sched_class->enqueue(rq, proc);
ffffffffc0204764:	00030997          	auipc	s3,0x30
ffffffffc0204768:	62c98993          	addi	s3,s3,1580 # ffffffffc0234d90 <sched_class>
ffffffffc020476c:	00030917          	auipc	s2,0x30
ffffffffc0204770:	61c90913          	addi	s2,s2,1564 # ffffffffc0234d88 <rq>
        if (current->state == PROC_RUNNABLE) {
ffffffffc0204774:	4194                	lw	a3,0(a1)
        current->need_resched = 0;
ffffffffc0204776:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE) {
ffffffffc020477a:	4709                	li	a4,2
        sched_class->enqueue(rq, proc);
ffffffffc020477c:	0009b783          	ld	a5,0(s3)
ffffffffc0204780:	00093503          	ld	a0,0(s2)
        if (current->state == PROC_RUNNABLE) {
ffffffffc0204784:	06e68563          	beq	a3,a4,ffffffffc02047ee <schedule+0xac>
    return sched_class->pick_next(rq);
ffffffffc0204788:	739c                	ld	a5,32(a5)
ffffffffc020478a:	9782                	jalr	a5
ffffffffc020478c:	842a                	mv	s0,a0
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL) {
ffffffffc020478e:	c939                	beqz	a0,ffffffffc02047e4 <schedule+0xa2>
    sched_class->dequeue(rq, proc);
ffffffffc0204790:	0009b783          	ld	a5,0(s3)
ffffffffc0204794:	00093503          	ld	a0,0(s2)
ffffffffc0204798:	85a2                	mv	a1,s0
ffffffffc020479a:	6f9c                	ld	a5,24(a5)
ffffffffc020479c:	9782                	jalr	a5
            sched_class_dequeue(next);
        }
        if (next == NULL) {
            next = idleproc;
        }
        next->runs ++;
ffffffffc020479e:	441c                	lw	a5,8(s0)
        if (next != current) {
ffffffffc02047a0:	6098                	ld	a4,0(s1)
        next->runs ++;
ffffffffc02047a2:	2785                	addiw	a5,a5,1
ffffffffc02047a4:	c41c                	sw	a5,8(s0)
        if (next != current) {
ffffffffc02047a6:	00870c63          	beq	a4,s0,ffffffffc02047be <schedule+0x7c>
            cprintf("The next proc is pid:%d\n",next->pid);
ffffffffc02047aa:	404c                	lw	a1,4(s0)
ffffffffc02047ac:	00002517          	auipc	a0,0x2
ffffffffc02047b0:	f9450513          	addi	a0,a0,-108 # ffffffffc0206740 <default_pmm_manager+0xc70>
ffffffffc02047b4:	9c9fb0ef          	jal	ra,ffffffffc020017c <cprintf>
            proc_run(next);
ffffffffc02047b8:	8522                	mv	a0,s0
ffffffffc02047ba:	cb5fe0ef          	jal	ra,ffffffffc020346e <proc_run>
    if (flag) {
ffffffffc02047be:	000a1a63          	bnez	s4,ffffffffc02047d2 <schedule+0x90>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02047c2:	70a2                	ld	ra,40(sp)
ffffffffc02047c4:	7402                	ld	s0,32(sp)
ffffffffc02047c6:	64e2                	ld	s1,24(sp)
ffffffffc02047c8:	6942                	ld	s2,16(sp)
ffffffffc02047ca:	69a2                	ld	s3,8(sp)
ffffffffc02047cc:	6a02                	ld	s4,0(sp)
ffffffffc02047ce:	6145                	addi	sp,sp,48
ffffffffc02047d0:	8082                	ret
ffffffffc02047d2:	7402                	ld	s0,32(sp)
ffffffffc02047d4:	70a2                	ld	ra,40(sp)
ffffffffc02047d6:	64e2                	ld	s1,24(sp)
ffffffffc02047d8:	6942                	ld	s2,16(sp)
ffffffffc02047da:	69a2                	ld	s3,8(sp)
ffffffffc02047dc:	6a02                	ld	s4,0(sp)
ffffffffc02047de:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02047e0:	e53fb06f          	j	ffffffffc0200632 <intr_enable>
            next = idleproc;
ffffffffc02047e4:	00030417          	auipc	s0,0x30
ffffffffc02047e8:	58c43403          	ld	s0,1420(s0) # ffffffffc0234d70 <idleproc>
ffffffffc02047ec:	bf4d                	j	ffffffffc020479e <schedule+0x5c>
    if (proc != idleproc) {
ffffffffc02047ee:	00030717          	auipc	a4,0x30
ffffffffc02047f2:	58273703          	ld	a4,1410(a4) # ffffffffc0234d70 <idleproc>
ffffffffc02047f6:	f8e589e3          	beq	a1,a4,ffffffffc0204788 <schedule+0x46>
        sched_class->enqueue(rq, proc);
ffffffffc02047fa:	6b9c                	ld	a5,16(a5)
ffffffffc02047fc:	9782                	jalr	a5
    return sched_class->pick_next(rq);
ffffffffc02047fe:	0009b783          	ld	a5,0(s3)
ffffffffc0204802:	00093503          	ld	a0,0(s2)
ffffffffc0204806:	b749                	j	ffffffffc0204788 <schedule+0x46>
        intr_disable();
ffffffffc0204808:	e31fb0ef          	jal	ra,ffffffffc0200638 <intr_disable>
        return 1;
ffffffffc020480c:	4a05                	li	s4,1
ffffffffc020480e:	b7b1                	j	ffffffffc020475a <schedule+0x18>

ffffffffc0204810 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0204810:	00030797          	auipc	a5,0x30
ffffffffc0204814:	5587b783          	ld	a5,1368(a5) # ffffffffc0234d68 <current>
}
ffffffffc0204818:	43c8                	lw	a0,4(a5)
ffffffffc020481a:	8082                	ret

ffffffffc020481c <sys_gettime>:
    cputchar(c);
    return 0;
}

static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc020481c:	00030797          	auipc	a5,0x30
ffffffffc0204820:	4e47b783          	ld	a5,1252(a5) # ffffffffc0234d00 <ticks>
ffffffffc0204824:	0027951b          	slliw	a0,a5,0x2
ffffffffc0204828:	9d3d                	addw	a0,a0,a5
}
ffffffffc020482a:	0015151b          	slliw	a0,a0,0x1
ffffffffc020482e:	8082                	ret

ffffffffc0204830 <sys_putc>:
    cputchar(c);
ffffffffc0204830:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0204832:	1141                	addi	sp,sp,-16
ffffffffc0204834:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0204836:	97dfb0ef          	jal	ra,ffffffffc02001b2 <cputchar>
}
ffffffffc020483a:	60a2                	ld	ra,8(sp)
ffffffffc020483c:	4501                	li	a0,0
ffffffffc020483e:	0141                	addi	sp,sp,16
ffffffffc0204840:	8082                	ret

ffffffffc0204842 <sys_kill>:
    return do_kill(pid);
ffffffffc0204842:	4108                	lw	a0,0(a0)
ffffffffc0204844:	a91ff06f          	j	ffffffffc02042d4 <do_kill>

ffffffffc0204848 <sys_yield>:
    return do_yield();
ffffffffc0204848:	a3fff06f          	j	ffffffffc0204286 <do_yield>

ffffffffc020484c <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020484c:	6d14                	ld	a3,24(a0)
ffffffffc020484e:	6910                	ld	a2,16(a0)
ffffffffc0204850:	650c                	ld	a1,8(a0)
ffffffffc0204852:	6108                	ld	a0,0(a0)
ffffffffc0204854:	d22ff06f          	j	ffffffffc0203d76 <do_execve>

ffffffffc0204858 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0204858:	650c                	ld	a1,8(a0)
ffffffffc020485a:	4108                	lw	a0,0(a0)
ffffffffc020485c:	a3bff06f          	j	ffffffffc0204296 <do_wait>

ffffffffc0204860 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0204860:	00030797          	auipc	a5,0x30
ffffffffc0204864:	5087b783          	ld	a5,1288(a5) # ffffffffc0234d68 <current>
ffffffffc0204868:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020486a:	4501                	li	a0,0
ffffffffc020486c:	6a0c                	ld	a1,16(a2)
ffffffffc020486e:	c6dfe06f          	j	ffffffffc02034da <do_fork>

ffffffffc0204872 <sys_exit>:
    return do_exit(error_code);
ffffffffc0204872:	4108                	lw	a0,0(a0)
ffffffffc0204874:	8c2ff06f          	j	ffffffffc0203936 <do_exit>

ffffffffc0204878 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0204878:	715d                	addi	sp,sp,-80
ffffffffc020487a:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020487c:	00030497          	auipc	s1,0x30
ffffffffc0204880:	4ec48493          	addi	s1,s1,1260 # ffffffffc0234d68 <current>
ffffffffc0204884:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0204886:	e0a2                	sd	s0,64(sp)
ffffffffc0204888:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020488a:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020488c:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020488e:	47f9                	li	a5,30
    int num = tf->gpr.a0;
ffffffffc0204890:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0204894:	0327ee63          	bltu	a5,s2,ffffffffc02048d0 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc0204898:	00391713          	slli	a4,s2,0x3
ffffffffc020489c:	00002797          	auipc	a5,0x2
ffffffffc02048a0:	f0c78793          	addi	a5,a5,-244 # ffffffffc02067a8 <syscalls>
ffffffffc02048a4:	97ba                	add	a5,a5,a4
ffffffffc02048a6:	639c                	ld	a5,0(a5)
ffffffffc02048a8:	c785                	beqz	a5,ffffffffc02048d0 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02048aa:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02048ac:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02048ae:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02048b0:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02048b2:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02048b4:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02048b6:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02048b8:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02048ba:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02048bc:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02048be:	0028                	addi	a0,sp,8
ffffffffc02048c0:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02048c2:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02048c4:	e828                	sd	a0,80(s0)
}
ffffffffc02048c6:	6406                	ld	s0,64(sp)
ffffffffc02048c8:	74e2                	ld	s1,56(sp)
ffffffffc02048ca:	7942                	ld	s2,48(sp)
ffffffffc02048cc:	6161                	addi	sp,sp,80
ffffffffc02048ce:	8082                	ret
    print_trapframe(tf);
ffffffffc02048d0:	8522                	mv	a0,s0
ffffffffc02048d2:	f53fb0ef          	jal	ra,ffffffffc0200824 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02048d6:	609c                	ld	a5,0(s1)
ffffffffc02048d8:	86ca                	mv	a3,s2
ffffffffc02048da:	00002617          	auipc	a2,0x2
ffffffffc02048de:	e8660613          	addi	a2,a2,-378 # ffffffffc0206760 <default_pmm_manager+0xc90>
ffffffffc02048e2:	43d8                	lw	a4,4(a5)
ffffffffc02048e4:	06100593          	li	a1,97
ffffffffc02048e8:	0b478793          	addi	a5,a5,180
ffffffffc02048ec:	00002517          	auipc	a0,0x2
ffffffffc02048f0:	ea450513          	addi	a0,a0,-348 # ffffffffc0206790 <default_pmm_manager+0xcc0>
ffffffffc02048f4:	b83fb0ef          	jal	ra,ffffffffc0200476 <__panic>

ffffffffc02048f8 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc02048f8:	9e3707b7          	lui	a5,0x9e370
ffffffffc02048fc:	2785                	addiw	a5,a5,1
ffffffffc02048fe:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0204902:	02000793          	li	a5,32
ffffffffc0204906:	9f8d                	subw	a5,a5,a1
}
ffffffffc0204908:	00f5553b          	srlw	a0,a0,a5
ffffffffc020490c:	8082                	ret

ffffffffc020490e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020490e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204912:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0204914:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204918:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020491a:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020491e:	f022                	sd	s0,32(sp)
ffffffffc0204920:	ec26                	sd	s1,24(sp)
ffffffffc0204922:	e84a                	sd	s2,16(sp)
ffffffffc0204924:	f406                	sd	ra,40(sp)
ffffffffc0204926:	e44e                	sd	s3,8(sp)
ffffffffc0204928:	84aa                	mv	s1,a0
ffffffffc020492a:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020492c:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0204930:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0204932:	03067e63          	bgeu	a2,a6,ffffffffc020496e <printnum+0x60>
ffffffffc0204936:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0204938:	00805763          	blez	s0,ffffffffc0204946 <printnum+0x38>
ffffffffc020493c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020493e:	85ca                	mv	a1,s2
ffffffffc0204940:	854e                	mv	a0,s3
ffffffffc0204942:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0204944:	fc65                	bnez	s0,ffffffffc020493c <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204946:	1a02                	slli	s4,s4,0x20
ffffffffc0204948:	00002797          	auipc	a5,0x2
ffffffffc020494c:	f5878793          	addi	a5,a5,-168 # ffffffffc02068a0 <syscalls+0xf8>
ffffffffc0204950:	020a5a13          	srli	s4,s4,0x20
ffffffffc0204954:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0204956:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204958:	000a4503          	lbu	a0,0(s4) # 1000 <_binary_obj___user_hello_out_size-0x8d80>
}
ffffffffc020495c:	70a2                	ld	ra,40(sp)
ffffffffc020495e:	69a2                	ld	s3,8(sp)
ffffffffc0204960:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204962:	85ca                	mv	a1,s2
ffffffffc0204964:	87a6                	mv	a5,s1
}
ffffffffc0204966:	6942                	ld	s2,16(sp)
ffffffffc0204968:	64e2                	ld	s1,24(sp)
ffffffffc020496a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020496c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020496e:	03065633          	divu	a2,a2,a6
ffffffffc0204972:	8722                	mv	a4,s0
ffffffffc0204974:	f9bff0ef          	jal	ra,ffffffffc020490e <printnum>
ffffffffc0204978:	b7f9                	j	ffffffffc0204946 <printnum+0x38>

ffffffffc020497a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020497a:	7119                	addi	sp,sp,-128
ffffffffc020497c:	f4a6                	sd	s1,104(sp)
ffffffffc020497e:	f0ca                	sd	s2,96(sp)
ffffffffc0204980:	ecce                	sd	s3,88(sp)
ffffffffc0204982:	e8d2                	sd	s4,80(sp)
ffffffffc0204984:	e4d6                	sd	s5,72(sp)
ffffffffc0204986:	e0da                	sd	s6,64(sp)
ffffffffc0204988:	fc5e                	sd	s7,56(sp)
ffffffffc020498a:	f06a                	sd	s10,32(sp)
ffffffffc020498c:	fc86                	sd	ra,120(sp)
ffffffffc020498e:	f8a2                	sd	s0,112(sp)
ffffffffc0204990:	f862                	sd	s8,48(sp)
ffffffffc0204992:	f466                	sd	s9,40(sp)
ffffffffc0204994:	ec6e                	sd	s11,24(sp)
ffffffffc0204996:	892a                	mv	s2,a0
ffffffffc0204998:	84ae                	mv	s1,a1
ffffffffc020499a:	8d32                	mv	s10,a2
ffffffffc020499c:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020499e:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02049a2:	5b7d                	li	s6,-1
ffffffffc02049a4:	00002a97          	auipc	s5,0x2
ffffffffc02049a8:	f28a8a93          	addi	s5,s5,-216 # ffffffffc02068cc <syscalls+0x124>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02049ac:	00002b97          	auipc	s7,0x2
ffffffffc02049b0:	13cb8b93          	addi	s7,s7,316 # ffffffffc0206ae8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02049b4:	000d4503          	lbu	a0,0(s10)
ffffffffc02049b8:	001d0413          	addi	s0,s10,1
ffffffffc02049bc:	01350a63          	beq	a0,s3,ffffffffc02049d0 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02049c0:	c121                	beqz	a0,ffffffffc0204a00 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02049c2:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02049c4:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02049c6:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02049c8:	fff44503          	lbu	a0,-1(s0)
ffffffffc02049cc:	ff351ae3          	bne	a0,s3,ffffffffc02049c0 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02049d0:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02049d4:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02049d8:	4c81                	li	s9,0
ffffffffc02049da:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02049dc:	5c7d                	li	s8,-1
ffffffffc02049de:	5dfd                	li	s11,-1
ffffffffc02049e0:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02049e4:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02049e6:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02049ea:	0ff5f593          	andi	a1,a1,255
ffffffffc02049ee:	00140d13          	addi	s10,s0,1
ffffffffc02049f2:	04b56263          	bltu	a0,a1,ffffffffc0204a36 <vprintfmt+0xbc>
ffffffffc02049f6:	058a                	slli	a1,a1,0x2
ffffffffc02049f8:	95d6                	add	a1,a1,s5
ffffffffc02049fa:	4194                	lw	a3,0(a1)
ffffffffc02049fc:	96d6                	add	a3,a3,s5
ffffffffc02049fe:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0204a00:	70e6                	ld	ra,120(sp)
ffffffffc0204a02:	7446                	ld	s0,112(sp)
ffffffffc0204a04:	74a6                	ld	s1,104(sp)
ffffffffc0204a06:	7906                	ld	s2,96(sp)
ffffffffc0204a08:	69e6                	ld	s3,88(sp)
ffffffffc0204a0a:	6a46                	ld	s4,80(sp)
ffffffffc0204a0c:	6aa6                	ld	s5,72(sp)
ffffffffc0204a0e:	6b06                	ld	s6,64(sp)
ffffffffc0204a10:	7be2                	ld	s7,56(sp)
ffffffffc0204a12:	7c42                	ld	s8,48(sp)
ffffffffc0204a14:	7ca2                	ld	s9,40(sp)
ffffffffc0204a16:	7d02                	ld	s10,32(sp)
ffffffffc0204a18:	6de2                	ld	s11,24(sp)
ffffffffc0204a1a:	6109                	addi	sp,sp,128
ffffffffc0204a1c:	8082                	ret
            padc = '0';
ffffffffc0204a1e:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0204a20:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204a24:	846a                	mv	s0,s10
ffffffffc0204a26:	00140d13          	addi	s10,s0,1
ffffffffc0204a2a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0204a2e:	0ff5f593          	andi	a1,a1,255
ffffffffc0204a32:	fcb572e3          	bgeu	a0,a1,ffffffffc02049f6 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0204a36:	85a6                	mv	a1,s1
ffffffffc0204a38:	02500513          	li	a0,37
ffffffffc0204a3c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0204a3e:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204a42:	8d22                	mv	s10,s0
ffffffffc0204a44:	f73788e3          	beq	a5,s3,ffffffffc02049b4 <vprintfmt+0x3a>
ffffffffc0204a48:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0204a4c:	1d7d                	addi	s10,s10,-1
ffffffffc0204a4e:	ff379de3          	bne	a5,s3,ffffffffc0204a48 <vprintfmt+0xce>
ffffffffc0204a52:	b78d                	j	ffffffffc02049b4 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0204a54:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0204a58:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204a5c:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0204a5e:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0204a62:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204a66:	02d86463          	bltu	a6,a3,ffffffffc0204a8e <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0204a6a:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204a6e:	002c169b          	slliw	a3,s8,0x2
ffffffffc0204a72:	0186873b          	addw	a4,a3,s8
ffffffffc0204a76:	0017171b          	slliw	a4,a4,0x1
ffffffffc0204a7a:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0204a7c:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0204a80:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0204a82:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0204a86:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204a8a:	fed870e3          	bgeu	a6,a3,ffffffffc0204a6a <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0204a8e:	f40ddce3          	bgez	s11,ffffffffc02049e6 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0204a92:	8de2                	mv	s11,s8
ffffffffc0204a94:	5c7d                	li	s8,-1
ffffffffc0204a96:	bf81                	j	ffffffffc02049e6 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0204a98:	fffdc693          	not	a3,s11
ffffffffc0204a9c:	96fd                	srai	a3,a3,0x3f
ffffffffc0204a9e:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204aa2:	00144603          	lbu	a2,1(s0)
ffffffffc0204aa6:	2d81                	sext.w	s11,s11
ffffffffc0204aa8:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204aaa:	bf35                	j	ffffffffc02049e6 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0204aac:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204ab0:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0204ab4:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204ab6:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0204ab8:	bfd9                	j	ffffffffc0204a8e <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0204aba:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204abc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204ac0:	01174463          	blt	a4,a7,ffffffffc0204ac8 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0204ac4:	1a088e63          	beqz	a7,ffffffffc0204c80 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0204ac8:	000a3603          	ld	a2,0(s4)
ffffffffc0204acc:	46c1                	li	a3,16
ffffffffc0204ace:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204ad0:	2781                	sext.w	a5,a5
ffffffffc0204ad2:	876e                	mv	a4,s11
ffffffffc0204ad4:	85a6                	mv	a1,s1
ffffffffc0204ad6:	854a                	mv	a0,s2
ffffffffc0204ad8:	e37ff0ef          	jal	ra,ffffffffc020490e <printnum>
            break;
ffffffffc0204adc:	bde1                	j	ffffffffc02049b4 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0204ade:	000a2503          	lw	a0,0(s4)
ffffffffc0204ae2:	85a6                	mv	a1,s1
ffffffffc0204ae4:	0a21                	addi	s4,s4,8
ffffffffc0204ae6:	9902                	jalr	s2
            break;
ffffffffc0204ae8:	b5f1                	j	ffffffffc02049b4 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204aea:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204aec:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204af0:	01174463          	blt	a4,a7,ffffffffc0204af8 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0204af4:	18088163          	beqz	a7,ffffffffc0204c76 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0204af8:	000a3603          	ld	a2,0(s4)
ffffffffc0204afc:	46a9                	li	a3,10
ffffffffc0204afe:	8a2e                	mv	s4,a1
ffffffffc0204b00:	bfc1                	j	ffffffffc0204ad0 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b02:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0204b06:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b08:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204b0a:	bdf1                	j	ffffffffc02049e6 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0204b0c:	85a6                	mv	a1,s1
ffffffffc0204b0e:	02500513          	li	a0,37
ffffffffc0204b12:	9902                	jalr	s2
            break;
ffffffffc0204b14:	b545                	j	ffffffffc02049b4 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b16:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0204b1a:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b1c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204b1e:	b5e1                	j	ffffffffc02049e6 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0204b20:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204b22:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0204b26:	01174463          	blt	a4,a7,ffffffffc0204b2e <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0204b2a:	14088163          	beqz	a7,ffffffffc0204c6c <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0204b2e:	000a3603          	ld	a2,0(s4)
ffffffffc0204b32:	46a1                	li	a3,8
ffffffffc0204b34:	8a2e                	mv	s4,a1
ffffffffc0204b36:	bf69                	j	ffffffffc0204ad0 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0204b38:	03000513          	li	a0,48
ffffffffc0204b3c:	85a6                	mv	a1,s1
ffffffffc0204b3e:	e03e                	sd	a5,0(sp)
ffffffffc0204b40:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0204b42:	85a6                	mv	a1,s1
ffffffffc0204b44:	07800513          	li	a0,120
ffffffffc0204b48:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204b4a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0204b4c:	6782                	ld	a5,0(sp)
ffffffffc0204b4e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204b50:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0204b54:	bfb5                	j	ffffffffc0204ad0 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204b56:	000a3403          	ld	s0,0(s4)
ffffffffc0204b5a:	008a0713          	addi	a4,s4,8
ffffffffc0204b5e:	e03a                	sd	a4,0(sp)
ffffffffc0204b60:	14040263          	beqz	s0,ffffffffc0204ca4 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0204b64:	0fb05763          	blez	s11,ffffffffc0204c52 <vprintfmt+0x2d8>
ffffffffc0204b68:	02d00693          	li	a3,45
ffffffffc0204b6c:	0cd79163          	bne	a5,a3,ffffffffc0204c2e <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204b70:	00044783          	lbu	a5,0(s0)
ffffffffc0204b74:	0007851b          	sext.w	a0,a5
ffffffffc0204b78:	cf85                	beqz	a5,ffffffffc0204bb0 <vprintfmt+0x236>
ffffffffc0204b7a:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204b7e:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204b82:	000c4563          	bltz	s8,ffffffffc0204b8c <vprintfmt+0x212>
ffffffffc0204b86:	3c7d                	addiw	s8,s8,-1
ffffffffc0204b88:	036c0263          	beq	s8,s6,ffffffffc0204bac <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0204b8c:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204b8e:	0e0c8e63          	beqz	s9,ffffffffc0204c8a <vprintfmt+0x310>
ffffffffc0204b92:	3781                	addiw	a5,a5,-32
ffffffffc0204b94:	0ef47b63          	bgeu	s0,a5,ffffffffc0204c8a <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0204b98:	03f00513          	li	a0,63
ffffffffc0204b9c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204b9e:	000a4783          	lbu	a5,0(s4)
ffffffffc0204ba2:	3dfd                	addiw	s11,s11,-1
ffffffffc0204ba4:	0a05                	addi	s4,s4,1
ffffffffc0204ba6:	0007851b          	sext.w	a0,a5
ffffffffc0204baa:	ffe1                	bnez	a5,ffffffffc0204b82 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0204bac:	01b05963          	blez	s11,ffffffffc0204bbe <vprintfmt+0x244>
ffffffffc0204bb0:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204bb2:	85a6                	mv	a1,s1
ffffffffc0204bb4:	02000513          	li	a0,32
ffffffffc0204bb8:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0204bba:	fe0d9be3          	bnez	s11,ffffffffc0204bb0 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204bbe:	6a02                	ld	s4,0(sp)
ffffffffc0204bc0:	bbd5                	j	ffffffffc02049b4 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204bc2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0204bc4:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0204bc8:	01174463          	blt	a4,a7,ffffffffc0204bd0 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0204bcc:	08088d63          	beqz	a7,ffffffffc0204c66 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0204bd0:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204bd4:	0a044d63          	bltz	s0,ffffffffc0204c8e <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0204bd8:	8622                	mv	a2,s0
ffffffffc0204bda:	8a66                	mv	s4,s9
ffffffffc0204bdc:	46a9                	li	a3,10
ffffffffc0204bde:	bdcd                	j	ffffffffc0204ad0 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0204be0:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204be4:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0204be6:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0204be8:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204bec:	8fb5                	xor	a5,a5,a3
ffffffffc0204bee:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204bf2:	02d74163          	blt	a4,a3,ffffffffc0204c14 <vprintfmt+0x29a>
ffffffffc0204bf6:	00369793          	slli	a5,a3,0x3
ffffffffc0204bfa:	97de                	add	a5,a5,s7
ffffffffc0204bfc:	639c                	ld	a5,0(a5)
ffffffffc0204bfe:	cb99                	beqz	a5,ffffffffc0204c14 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204c00:	86be                	mv	a3,a5
ffffffffc0204c02:	00000617          	auipc	a2,0x0
ffffffffc0204c06:	1ae60613          	addi	a2,a2,430 # ffffffffc0204db0 <etext+0x20>
ffffffffc0204c0a:	85a6                	mv	a1,s1
ffffffffc0204c0c:	854a                	mv	a0,s2
ffffffffc0204c0e:	0ce000ef          	jal	ra,ffffffffc0204cdc <printfmt>
ffffffffc0204c12:	b34d                	j	ffffffffc02049b4 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204c14:	00002617          	auipc	a2,0x2
ffffffffc0204c18:	cac60613          	addi	a2,a2,-852 # ffffffffc02068c0 <syscalls+0x118>
ffffffffc0204c1c:	85a6                	mv	a1,s1
ffffffffc0204c1e:	854a                	mv	a0,s2
ffffffffc0204c20:	0bc000ef          	jal	ra,ffffffffc0204cdc <printfmt>
ffffffffc0204c24:	bb41                	j	ffffffffc02049b4 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0204c26:	00002417          	auipc	s0,0x2
ffffffffc0204c2a:	c9240413          	addi	s0,s0,-878 # ffffffffc02068b8 <syscalls+0x110>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204c2e:	85e2                	mv	a1,s8
ffffffffc0204c30:	8522                	mv	a0,s0
ffffffffc0204c32:	e43e                	sd	a5,8(sp)
ffffffffc0204c34:	0e2000ef          	jal	ra,ffffffffc0204d16 <strnlen>
ffffffffc0204c38:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0204c3c:	01b05b63          	blez	s11,ffffffffc0204c52 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0204c40:	67a2                	ld	a5,8(sp)
ffffffffc0204c42:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204c46:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0204c48:	85a6                	mv	a1,s1
ffffffffc0204c4a:	8552                	mv	a0,s4
ffffffffc0204c4c:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204c4e:	fe0d9ce3          	bnez	s11,ffffffffc0204c46 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204c52:	00044783          	lbu	a5,0(s0)
ffffffffc0204c56:	00140a13          	addi	s4,s0,1
ffffffffc0204c5a:	0007851b          	sext.w	a0,a5
ffffffffc0204c5e:	d3a5                	beqz	a5,ffffffffc0204bbe <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204c60:	05e00413          	li	s0,94
ffffffffc0204c64:	bf39                	j	ffffffffc0204b82 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0204c66:	000a2403          	lw	s0,0(s4)
ffffffffc0204c6a:	b7ad                	j	ffffffffc0204bd4 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0204c6c:	000a6603          	lwu	a2,0(s4)
ffffffffc0204c70:	46a1                	li	a3,8
ffffffffc0204c72:	8a2e                	mv	s4,a1
ffffffffc0204c74:	bdb1                	j	ffffffffc0204ad0 <vprintfmt+0x156>
ffffffffc0204c76:	000a6603          	lwu	a2,0(s4)
ffffffffc0204c7a:	46a9                	li	a3,10
ffffffffc0204c7c:	8a2e                	mv	s4,a1
ffffffffc0204c7e:	bd89                	j	ffffffffc0204ad0 <vprintfmt+0x156>
ffffffffc0204c80:	000a6603          	lwu	a2,0(s4)
ffffffffc0204c84:	46c1                	li	a3,16
ffffffffc0204c86:	8a2e                	mv	s4,a1
ffffffffc0204c88:	b5a1                	j	ffffffffc0204ad0 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0204c8a:	9902                	jalr	s2
ffffffffc0204c8c:	bf09                	j	ffffffffc0204b9e <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0204c8e:	85a6                	mv	a1,s1
ffffffffc0204c90:	02d00513          	li	a0,45
ffffffffc0204c94:	e03e                	sd	a5,0(sp)
ffffffffc0204c96:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0204c98:	6782                	ld	a5,0(sp)
ffffffffc0204c9a:	8a66                	mv	s4,s9
ffffffffc0204c9c:	40800633          	neg	a2,s0
ffffffffc0204ca0:	46a9                	li	a3,10
ffffffffc0204ca2:	b53d                	j	ffffffffc0204ad0 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0204ca4:	03b05163          	blez	s11,ffffffffc0204cc6 <vprintfmt+0x34c>
ffffffffc0204ca8:	02d00693          	li	a3,45
ffffffffc0204cac:	f6d79de3          	bne	a5,a3,ffffffffc0204c26 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0204cb0:	00002417          	auipc	s0,0x2
ffffffffc0204cb4:	c0840413          	addi	s0,s0,-1016 # ffffffffc02068b8 <syscalls+0x110>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204cb8:	02800793          	li	a5,40
ffffffffc0204cbc:	02800513          	li	a0,40
ffffffffc0204cc0:	00140a13          	addi	s4,s0,1
ffffffffc0204cc4:	bd6d                	j	ffffffffc0204b7e <vprintfmt+0x204>
ffffffffc0204cc6:	00002a17          	auipc	s4,0x2
ffffffffc0204cca:	bf3a0a13          	addi	s4,s4,-1037 # ffffffffc02068b9 <syscalls+0x111>
ffffffffc0204cce:	02800513          	li	a0,40
ffffffffc0204cd2:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204cd6:	05e00413          	li	s0,94
ffffffffc0204cda:	b565                	j	ffffffffc0204b82 <vprintfmt+0x208>

ffffffffc0204cdc <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204cdc:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204cde:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204ce2:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204ce4:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204ce6:	ec06                	sd	ra,24(sp)
ffffffffc0204ce8:	f83a                	sd	a4,48(sp)
ffffffffc0204cea:	fc3e                	sd	a5,56(sp)
ffffffffc0204cec:	e0c2                	sd	a6,64(sp)
ffffffffc0204cee:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204cf0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204cf2:	c89ff0ef          	jal	ra,ffffffffc020497a <vprintfmt>
}
ffffffffc0204cf6:	60e2                	ld	ra,24(sp)
ffffffffc0204cf8:	6161                	addi	sp,sp,80
ffffffffc0204cfa:	8082                	ret

ffffffffc0204cfc <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0204cfc:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0204d00:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0204d02:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0204d04:	cb81                	beqz	a5,ffffffffc0204d14 <strlen+0x18>
        cnt ++;
ffffffffc0204d06:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0204d08:	00a707b3          	add	a5,a4,a0
ffffffffc0204d0c:	0007c783          	lbu	a5,0(a5)
ffffffffc0204d10:	fbfd                	bnez	a5,ffffffffc0204d06 <strlen+0xa>
ffffffffc0204d12:	8082                	ret
    }
    return cnt;
}
ffffffffc0204d14:	8082                	ret

ffffffffc0204d16 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0204d16:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204d18:	e589                	bnez	a1,ffffffffc0204d22 <strnlen+0xc>
ffffffffc0204d1a:	a811                	j	ffffffffc0204d2e <strnlen+0x18>
        cnt ++;
ffffffffc0204d1c:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204d1e:	00f58863          	beq	a1,a5,ffffffffc0204d2e <strnlen+0x18>
ffffffffc0204d22:	00f50733          	add	a4,a0,a5
ffffffffc0204d26:	00074703          	lbu	a4,0(a4)
ffffffffc0204d2a:	fb6d                	bnez	a4,ffffffffc0204d1c <strnlen+0x6>
ffffffffc0204d2c:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0204d2e:	852e                	mv	a0,a1
ffffffffc0204d30:	8082                	ret

ffffffffc0204d32 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204d32:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204d36:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204d3a:	cb89                	beqz	a5,ffffffffc0204d4c <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0204d3c:	0505                	addi	a0,a0,1
ffffffffc0204d3e:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204d40:	fee789e3          	beq	a5,a4,ffffffffc0204d32 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204d44:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204d48:	9d19                	subw	a0,a0,a4
ffffffffc0204d4a:	8082                	ret
ffffffffc0204d4c:	4501                	li	a0,0
ffffffffc0204d4e:	bfed                	j	ffffffffc0204d48 <strcmp+0x16>

ffffffffc0204d50 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0204d50:	00054783          	lbu	a5,0(a0)
ffffffffc0204d54:	c799                	beqz	a5,ffffffffc0204d62 <strchr+0x12>
        if (*s == c) {
ffffffffc0204d56:	00f58763          	beq	a1,a5,ffffffffc0204d64 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0204d5a:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0204d5e:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0204d60:	fbfd                	bnez	a5,ffffffffc0204d56 <strchr+0x6>
    }
    return NULL;
ffffffffc0204d62:	4501                	li	a0,0
}
ffffffffc0204d64:	8082                	ret

ffffffffc0204d66 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0204d66:	ca01                	beqz	a2,ffffffffc0204d76 <memset+0x10>
ffffffffc0204d68:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0204d6a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0204d6c:	0785                	addi	a5,a5,1
ffffffffc0204d6e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0204d72:	fec79de3          	bne	a5,a2,ffffffffc0204d6c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0204d76:	8082                	ret

ffffffffc0204d78 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204d78:	ca19                	beqz	a2,ffffffffc0204d8e <memcpy+0x16>
ffffffffc0204d7a:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0204d7c:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0204d7e:	0005c703          	lbu	a4,0(a1)
ffffffffc0204d82:	0585                	addi	a1,a1,1
ffffffffc0204d84:	0785                	addi	a5,a5,1
ffffffffc0204d86:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0204d8a:	fec59ae3          	bne	a1,a2,ffffffffc0204d7e <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0204d8e:	8082                	ret
