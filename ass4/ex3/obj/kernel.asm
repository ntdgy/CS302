
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c020a2b7          	lui	t0,0xc020a
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addw	t1,zero,-3
ffffffffc0200008:	037a                	sll	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc020000e:	00c2d293          	srl	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200012:	fff0031b          	addw	t1,zero,-1
ffffffffc0200016:	137e                	sll	t1,t1,0x3f
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
ffffffffc0200024:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	add	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:

int kern_init(void) __attribute__((noreturn));
int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	00049517          	auipc	a0,0x49
ffffffffc0200036:	5c650513          	add	a0,a0,1478 # ffffffffc02495f8 <buf>
ffffffffc020003a:	00055617          	auipc	a2,0x55
ffffffffc020003e:	ac660613          	add	a2,a2,-1338 # ffffffffc0254b00 <end>
kern_init(void) {
ffffffffc0200042:	1141                	add	sp,sp,-16 # ffffffffc0209ff0 <bootstack+0x1ff0>
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	5c3040ef          	jal	ffffffffc0204e0c <memset>
    cons_init();                // init the console
ffffffffc020004e:	4e0000ef          	jal	ffffffffc020052e <cons_init>

    const char *message = "OS is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200052:	00005597          	auipc	a1,0x5
ffffffffc0200056:	de658593          	add	a1,a1,-538 # ffffffffc0204e38 <etext+0x2>
ffffffffc020005a:	00005517          	auipc	a0,0x5
ffffffffc020005e:	df650513          	add	a0,a0,-522 # ffffffffc0204e50 <etext+0x1a>
ffffffffc0200062:	120000ef          	jal	ffffffffc0200182 <cprintf>

    pmm_init();                 // init physical memory management
ffffffffc0200066:	40b010ef          	jal	ffffffffc0201c70 <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006a:	598000ef          	jal	ffffffffc0200602 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020006e:	719020ef          	jal	ffffffffc0202f86 <vmm_init>
    sched_init();
ffffffffc0200072:	5a4040ef          	jal	ffffffffc0204616 <sched_init>
    proc_init();                // init process table
ffffffffc0200076:	270040ef          	jal	ffffffffc02042e6 <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc020007a:	526000ef          	jal	ffffffffc02005a0 <ide_init>
    swap_init();                // init swap
ffffffffc020007e:	56e020ef          	jal	ffffffffc02025ec <swap_init>

    // clock_init();               // init clock interrupt
    intr_enable();              // enable irq interrupt
ffffffffc0200082:	574000ef          	jal	ffffffffc02005f6 <intr_enable>
    
    cpu_idle();                 // run idle process
ffffffffc0200086:	3fa040ef          	jal	ffffffffc0204480 <cpu_idle>

ffffffffc020008a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020008a:	715d                	add	sp,sp,-80
ffffffffc020008c:	e486                	sd	ra,72(sp)
ffffffffc020008e:	e0a2                	sd	s0,64(sp)
ffffffffc0200090:	fc26                	sd	s1,56(sp)
ffffffffc0200092:	f84a                	sd	s2,48(sp)
ffffffffc0200094:	f44e                	sd	s3,40(sp)
ffffffffc0200096:	f052                	sd	s4,32(sp)
ffffffffc0200098:	ec56                	sd	s5,24(sp)
ffffffffc020009a:	e85a                	sd	s6,16(sp)
ffffffffc020009c:	e45e                	sd	s7,8(sp)
    if (prompt != NULL) {
ffffffffc020009e:	c901                	beqz	a0,ffffffffc02000ae <readline+0x24>
ffffffffc02000a0:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000a2:	00005517          	auipc	a0,0x5
ffffffffc02000a6:	db650513          	add	a0,a0,-586 # ffffffffc0204e58 <etext+0x22>
ffffffffc02000aa:	0d8000ef          	jal	ffffffffc0200182 <cprintf>
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cputchar(c);
            buf[i ++] = c;
ffffffffc02000ae:	4481                	li	s1,0
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000b0:	497d                	li	s2,31
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000b2:	4a21                	li	s4,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000b4:	4aa9                	li	s5,10
ffffffffc02000b6:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000b8:	00049b97          	auipc	s7,0x49
ffffffffc02000bc:	540b8b93          	add	s7,s7,1344 # ffffffffc02495f8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000c0:	3fe00993          	li	s3,1022
        c = getchar();
ffffffffc02000c4:	136000ef          	jal	ffffffffc02001fa <getchar>
ffffffffc02000c8:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc02000ca:	02054363          	bltz	a0,ffffffffc02000f0 <readline+0x66>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ce:	02a95363          	bge	s2,a0,ffffffffc02000f4 <readline+0x6a>
ffffffffc02000d2:	fe99c9e3          	blt	s3,s1,ffffffffc02000c4 <readline+0x3a>
            cputchar(c);
ffffffffc02000d6:	8522                	mv	a0,s0
ffffffffc02000d8:	0e0000ef          	jal	ffffffffc02001b8 <cputchar>
            buf[i ++] = c;
ffffffffc02000dc:	009b87b3          	add	a5,s7,s1
ffffffffc02000e0:	00878023          	sb	s0,0(a5)
        c = getchar();
ffffffffc02000e4:	116000ef          	jal	ffffffffc02001fa <getchar>
            buf[i ++] = c;
ffffffffc02000e8:	2485                	addw	s1,s1,1
        c = getchar();
ffffffffc02000ea:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc02000ec:	fe0551e3          	bgez	a0,ffffffffc02000ce <readline+0x44>
            return NULL;
ffffffffc02000f0:	4501                	li	a0,0
ffffffffc02000f2:	a081                	j	ffffffffc0200132 <readline+0xa8>
        else if (c == '\b' && i > 0) {
ffffffffc02000f4:	03451163          	bne	a0,s4,ffffffffc0200116 <readline+0x8c>
ffffffffc02000f8:	c489                	beqz	s1,ffffffffc0200102 <readline+0x78>
            cputchar(c);
ffffffffc02000fa:	0be000ef          	jal	ffffffffc02001b8 <cputchar>
            i --;
ffffffffc02000fe:	34fd                	addw	s1,s1,-1
ffffffffc0200100:	b7d1                	j	ffffffffc02000c4 <readline+0x3a>
        c = getchar();
ffffffffc0200102:	0f8000ef          	jal	ffffffffc02001fa <getchar>
ffffffffc0200106:	842a                	mv	s0,a0
        else if (c == '\b' && i > 0) {
ffffffffc0200108:	47a1                	li	a5,8
        if (c < 0) {
ffffffffc020010a:	fe0543e3          	bltz	a0,ffffffffc02000f0 <readline+0x66>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020010e:	fca944e3          	blt	s2,a0,ffffffffc02000d6 <readline+0x4c>
        else if (c == '\b' && i > 0) {
ffffffffc0200112:	fef508e3          	beq	a0,a5,ffffffffc0200102 <readline+0x78>
        else if (c == '\n' || c == '\r') {
ffffffffc0200116:	01540463          	beq	s0,s5,ffffffffc020011e <readline+0x94>
ffffffffc020011a:	fb6415e3          	bne	s0,s6,ffffffffc02000c4 <readline+0x3a>
            cputchar(c);
ffffffffc020011e:	8522                	mv	a0,s0
ffffffffc0200120:	098000ef          	jal	ffffffffc02001b8 <cputchar>
            buf[i] = '\0';
ffffffffc0200124:	00049517          	auipc	a0,0x49
ffffffffc0200128:	4d450513          	add	a0,a0,1236 # ffffffffc02495f8 <buf>
ffffffffc020012c:	94aa                	add	s1,s1,a0
ffffffffc020012e:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200132:	60a6                	ld	ra,72(sp)
ffffffffc0200134:	6406                	ld	s0,64(sp)
ffffffffc0200136:	74e2                	ld	s1,56(sp)
ffffffffc0200138:	7942                	ld	s2,48(sp)
ffffffffc020013a:	79a2                	ld	s3,40(sp)
ffffffffc020013c:	7a02                	ld	s4,32(sp)
ffffffffc020013e:	6ae2                	ld	s5,24(sp)
ffffffffc0200140:	6b42                	ld	s6,16(sp)
ffffffffc0200142:	6ba2                	ld	s7,8(sp)
ffffffffc0200144:	6161                	add	sp,sp,80
ffffffffc0200146:	8082                	ret

ffffffffc0200148 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200148:	1141                	add	sp,sp,-16
ffffffffc020014a:	e022                	sd	s0,0(sp)
ffffffffc020014c:	e406                	sd	ra,8(sp)
ffffffffc020014e:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200150:	3e0000ef          	jal	ffffffffc0200530 <cons_putc>
    (*cnt) ++;
ffffffffc0200154:	401c                	lw	a5,0(s0)
}
ffffffffc0200156:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200158:	2785                	addw	a5,a5,1
ffffffffc020015a:	c01c                	sw	a5,0(s0)
}
ffffffffc020015c:	6402                	ld	s0,0(sp)
ffffffffc020015e:	0141                	add	sp,sp,16
ffffffffc0200160:	8082                	ret

ffffffffc0200162 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200162:	1101                	add	sp,sp,-32
ffffffffc0200164:	862a                	mv	a2,a0
ffffffffc0200166:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200168:	00000517          	auipc	a0,0x0
ffffffffc020016c:	fe050513          	add	a0,a0,-32 # ffffffffc0200148 <cputch>
ffffffffc0200170:	006c                	add	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200172:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200174:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200176:	097040ef          	jal	ffffffffc0204a0c <vprintfmt>
    return cnt;
}
ffffffffc020017a:	60e2                	ld	ra,24(sp)
ffffffffc020017c:	4532                	lw	a0,12(sp)
ffffffffc020017e:	6105                	add	sp,sp,32
ffffffffc0200180:	8082                	ret

ffffffffc0200182 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc0200182:	711d                	add	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200184:	02810313          	add	t1,sp,40
cprintf(const char *fmt, ...) {
ffffffffc0200188:	8e2a                	mv	t3,a0
ffffffffc020018a:	f42e                	sd	a1,40(sp)
ffffffffc020018c:	f832                	sd	a2,48(sp)
ffffffffc020018e:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200190:	00000517          	auipc	a0,0x0
ffffffffc0200194:	fb850513          	add	a0,a0,-72 # ffffffffc0200148 <cputch>
ffffffffc0200198:	004c                	add	a1,sp,4
ffffffffc020019a:	869a                	mv	a3,t1
ffffffffc020019c:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc020019e:	ec06                	sd	ra,24(sp)
ffffffffc02001a0:	e0ba                	sd	a4,64(sp)
ffffffffc02001a2:	e4be                	sd	a5,72(sp)
ffffffffc02001a4:	e8c2                	sd	a6,80(sp)
ffffffffc02001a6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001a8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001aa:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02001ac:	061040ef          	jal	ffffffffc0204a0c <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001b0:	60e2                	ld	ra,24(sp)
ffffffffc02001b2:	4512                	lw	a0,4(sp)
ffffffffc02001b4:	6125                	add	sp,sp,96
ffffffffc02001b6:	8082                	ret

ffffffffc02001b8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02001b8:	aea5                	j	ffffffffc0200530 <cons_putc>

ffffffffc02001ba <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02001ba:	1101                	add	sp,sp,-32
ffffffffc02001bc:	ec06                	sd	ra,24(sp)
ffffffffc02001be:	e822                	sd	s0,16(sp)
ffffffffc02001c0:	e426                	sd	s1,8(sp)
ffffffffc02001c2:	87aa                	mv	a5,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02001c4:	00054503          	lbu	a0,0(a0)
ffffffffc02001c8:	c51d                	beqz	a0,ffffffffc02001f6 <cputs+0x3c>
ffffffffc02001ca:	00178493          	add	s1,a5,1
ffffffffc02001ce:	8426                	mv	s0,s1
    cons_putc(c);
ffffffffc02001d0:	360000ef          	jal	ffffffffc0200530 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc02001d4:	00044503          	lbu	a0,0(s0)
ffffffffc02001d8:	87a2                	mv	a5,s0
ffffffffc02001da:	0405                	add	s0,s0,1
ffffffffc02001dc:	f975                	bnez	a0,ffffffffc02001d0 <cputs+0x16>
    (*cnt) ++;
ffffffffc02001de:	9f85                	subw	a5,a5,s1
ffffffffc02001e0:	0027841b          	addw	s0,a5,2
    cons_putc(c);
ffffffffc02001e4:	4529                	li	a0,10
ffffffffc02001e6:	34a000ef          	jal	ffffffffc0200530 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001ea:	60e2                	ld	ra,24(sp)
ffffffffc02001ec:	8522                	mv	a0,s0
ffffffffc02001ee:	6442                	ld	s0,16(sp)
ffffffffc02001f0:	64a2                	ld	s1,8(sp)
ffffffffc02001f2:	6105                	add	sp,sp,32
ffffffffc02001f4:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc02001f6:	4405                	li	s0,1
ffffffffc02001f8:	b7f5                	j	ffffffffc02001e4 <cputs+0x2a>

ffffffffc02001fa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02001fa:	1141                	add	sp,sp,-16
ffffffffc02001fc:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001fe:	366000ef          	jal	ffffffffc0200564 <cons_getc>
ffffffffc0200202:	dd75                	beqz	a0,ffffffffc02001fe <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200204:	60a2                	ld	ra,8(sp)
ffffffffc0200206:	0141                	add	sp,sp,16
ffffffffc0200208:	8082                	ret

ffffffffc020020a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020020a:	1141                	add	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020020c:	00005517          	auipc	a0,0x5
ffffffffc0200210:	c5450513          	add	a0,a0,-940 # ffffffffc0204e60 <etext+0x2a>
void print_kerninfo(void) {
ffffffffc0200214:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200216:	f6dff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020021a:	00000597          	auipc	a1,0x0
ffffffffc020021e:	e1858593          	add	a1,a1,-488 # ffffffffc0200032 <kern_init>
ffffffffc0200222:	00005517          	auipc	a0,0x5
ffffffffc0200226:	c5e50513          	add	a0,a0,-930 # ffffffffc0204e80 <etext+0x4a>
ffffffffc020022a:	f59ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020022e:	00005597          	auipc	a1,0x5
ffffffffc0200232:	c0858593          	add	a1,a1,-1016 # ffffffffc0204e36 <etext>
ffffffffc0200236:	00005517          	auipc	a0,0x5
ffffffffc020023a:	c6a50513          	add	a0,a0,-918 # ffffffffc0204ea0 <etext+0x6a>
ffffffffc020023e:	f45ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200242:	00049597          	auipc	a1,0x49
ffffffffc0200246:	3b658593          	add	a1,a1,950 # ffffffffc02495f8 <buf>
ffffffffc020024a:	00005517          	auipc	a0,0x5
ffffffffc020024e:	c7650513          	add	a0,a0,-906 # ffffffffc0204ec0 <etext+0x8a>
ffffffffc0200252:	f31ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200256:	00055597          	auipc	a1,0x55
ffffffffc020025a:	8aa58593          	add	a1,a1,-1878 # ffffffffc0254b00 <end>
ffffffffc020025e:	00005517          	auipc	a0,0x5
ffffffffc0200262:	c8250513          	add	a0,a0,-894 # ffffffffc0204ee0 <etext+0xaa>
ffffffffc0200266:	f1dff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020026a:	00055797          	auipc	a5,0x55
ffffffffc020026e:	c9578793          	add	a5,a5,-875 # ffffffffc0254eff <end+0x3ff>
ffffffffc0200272:	00000717          	auipc	a4,0x0
ffffffffc0200276:	dc070713          	add	a4,a4,-576 # ffffffffc0200032 <kern_init>
ffffffffc020027a:	8f99                	sub	a5,a5,a4
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020027c:	43f7d593          	sra	a1,a5,0x3f
}
ffffffffc0200280:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200282:	3ff5f593          	and	a1,a1,1023
ffffffffc0200286:	95be                	add	a1,a1,a5
ffffffffc0200288:	85a9                	sra	a1,a1,0xa
ffffffffc020028a:	00005517          	auipc	a0,0x5
ffffffffc020028e:	c7650513          	add	a0,a0,-906 # ffffffffc0204f00 <etext+0xca>
}
ffffffffc0200292:	0141                	add	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200294:	b5fd                	j	ffffffffc0200182 <cprintf>

ffffffffc0200296 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200296:	1141                	add	sp,sp,-16
     * and line number, etc.
     *    (3.5) popup a calling stackframe
     *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     *                   the calling funciton's ebp = ss:[ebp]
     */
    panic("Not Implemented!");
ffffffffc0200298:	00005617          	auipc	a2,0x5
ffffffffc020029c:	c9860613          	add	a2,a2,-872 # ffffffffc0204f30 <etext+0xfa>
ffffffffc02002a0:	05b00593          	li	a1,91
ffffffffc02002a4:	00005517          	auipc	a0,0x5
ffffffffc02002a8:	ca450513          	add	a0,a0,-860 # ffffffffc0204f48 <etext+0x112>
void print_stackframe(void) {
ffffffffc02002ac:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002ae:	1bc000ef          	jal	ffffffffc020046a <__panic>

ffffffffc02002b2 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002b2:	1141                	add	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002b4:	00005617          	auipc	a2,0x5
ffffffffc02002b8:	cac60613          	add	a2,a2,-852 # ffffffffc0204f60 <etext+0x12a>
ffffffffc02002bc:	00005597          	auipc	a1,0x5
ffffffffc02002c0:	cc458593          	add	a1,a1,-828 # ffffffffc0204f80 <etext+0x14a>
ffffffffc02002c4:	00005517          	auipc	a0,0x5
ffffffffc02002c8:	cc450513          	add	a0,a0,-828 # ffffffffc0204f88 <etext+0x152>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002cc:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002ce:	eb5ff0ef          	jal	ffffffffc0200182 <cprintf>
ffffffffc02002d2:	00005617          	auipc	a2,0x5
ffffffffc02002d6:	cc660613          	add	a2,a2,-826 # ffffffffc0204f98 <etext+0x162>
ffffffffc02002da:	00005597          	auipc	a1,0x5
ffffffffc02002de:	ce658593          	add	a1,a1,-794 # ffffffffc0204fc0 <etext+0x18a>
ffffffffc02002e2:	00005517          	auipc	a0,0x5
ffffffffc02002e6:	ca650513          	add	a0,a0,-858 # ffffffffc0204f88 <etext+0x152>
ffffffffc02002ea:	e99ff0ef          	jal	ffffffffc0200182 <cprintf>
ffffffffc02002ee:	00005617          	auipc	a2,0x5
ffffffffc02002f2:	ce260613          	add	a2,a2,-798 # ffffffffc0204fd0 <etext+0x19a>
ffffffffc02002f6:	00005597          	auipc	a1,0x5
ffffffffc02002fa:	cfa58593          	add	a1,a1,-774 # ffffffffc0204ff0 <etext+0x1ba>
ffffffffc02002fe:	00005517          	auipc	a0,0x5
ffffffffc0200302:	c8a50513          	add	a0,a0,-886 # ffffffffc0204f88 <etext+0x152>
ffffffffc0200306:	e7dff0ef          	jal	ffffffffc0200182 <cprintf>
    }
    return 0;
}
ffffffffc020030a:	60a2                	ld	ra,8(sp)
ffffffffc020030c:	4501                	li	a0,0
ffffffffc020030e:	0141                	add	sp,sp,16
ffffffffc0200310:	8082                	ret

ffffffffc0200312 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200312:	1141                	add	sp,sp,-16
ffffffffc0200314:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200316:	ef5ff0ef          	jal	ffffffffc020020a <print_kerninfo>
    return 0;
}
ffffffffc020031a:	60a2                	ld	ra,8(sp)
ffffffffc020031c:	4501                	li	a0,0
ffffffffc020031e:	0141                	add	sp,sp,16
ffffffffc0200320:	8082                	ret

ffffffffc0200322 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200322:	1141                	add	sp,sp,-16
ffffffffc0200324:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200326:	f71ff0ef          	jal	ffffffffc0200296 <print_stackframe>
    return 0;
}
ffffffffc020032a:	60a2                	ld	ra,8(sp)
ffffffffc020032c:	4501                	li	a0,0
ffffffffc020032e:	0141                	add	sp,sp,16
ffffffffc0200330:	8082                	ret

ffffffffc0200332 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200332:	7115                	add	sp,sp,-224
ffffffffc0200334:	f15a                	sd	s6,160(sp)
ffffffffc0200336:	8b2a                	mv	s6,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200338:	00005517          	auipc	a0,0x5
ffffffffc020033c:	cc850513          	add	a0,a0,-824 # ffffffffc0205000 <etext+0x1ca>
kmonitor(struct trapframe *tf) {
ffffffffc0200340:	ed86                	sd	ra,216(sp)
ffffffffc0200342:	e9a2                	sd	s0,208(sp)
ffffffffc0200344:	e5a6                	sd	s1,200(sp)
ffffffffc0200346:	e1ca                	sd	s2,192(sp)
ffffffffc0200348:	fd4e                	sd	s3,184(sp)
ffffffffc020034a:	f952                	sd	s4,176(sp)
ffffffffc020034c:	f556                	sd	s5,168(sp)
ffffffffc020034e:	ed5e                	sd	s7,152(sp)
ffffffffc0200350:	e962                	sd	s8,144(sp)
ffffffffc0200352:	e566                	sd	s9,136(sp)
ffffffffc0200354:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200356:	e2dff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020035a:	00005517          	auipc	a0,0x5
ffffffffc020035e:	cce50513          	add	a0,a0,-818 # ffffffffc0205028 <etext+0x1f2>
ffffffffc0200362:	e21ff0ef          	jal	ffffffffc0200182 <cprintf>
    if (tf != NULL) {
ffffffffc0200366:	000b0563          	beqz	s6,ffffffffc0200370 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020036a:	855a                	mv	a0,s6
ffffffffc020036c:	47c000ef          	jal	ffffffffc02007e8 <print_trapframe>
ffffffffc0200370:	00005c17          	auipc	s8,0x5
ffffffffc0200374:	d28c0c13          	add	s8,s8,-728 # ffffffffc0205098 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200378:	00005917          	auipc	s2,0x5
ffffffffc020037c:	cd890913          	add	s2,s2,-808 # ffffffffc0205050 <etext+0x21a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200380:	00005497          	auipc	s1,0x5
ffffffffc0200384:	cd848493          	add	s1,s1,-808 # ffffffffc0205058 <etext+0x222>
        if (argc == MAXARGS - 1) {
ffffffffc0200388:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020038a:	00005a97          	auipc	s5,0x5
ffffffffc020038e:	cd6a8a93          	add	s5,s5,-810 # ffffffffc0205060 <etext+0x22a>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200392:	4a0d                	li	s4,3
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200394:	00005b97          	auipc	s7,0x5
ffffffffc0200398:	cecb8b93          	add	s7,s7,-788 # ffffffffc0205080 <etext+0x24a>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020039c:	854a                	mv	a0,s2
ffffffffc020039e:	cedff0ef          	jal	ffffffffc020008a <readline>
ffffffffc02003a2:	842a                	mv	s0,a0
ffffffffc02003a4:	dd65                	beqz	a0,ffffffffc020039c <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a6:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003aa:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ac:	e59d                	bnez	a1,ffffffffc02003da <kmonitor+0xa8>
    if (argc == 0) {
ffffffffc02003ae:	fe0c87e3          	beqz	s9,ffffffffc020039c <kmonitor+0x6a>
ffffffffc02003b2:	00005d17          	auipc	s10,0x5
ffffffffc02003b6:	ce6d0d13          	add	s10,s10,-794 # ffffffffc0205098 <commands>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ba:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003bc:	000d3503          	ld	a0,0(s10)
ffffffffc02003c0:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003c2:	0d61                	add	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003c4:	1fb040ef          	jal	ffffffffc0204dbe <strcmp>
ffffffffc02003c8:	c535                	beqz	a0,ffffffffc0200434 <kmonitor+0x102>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003ca:	2405                	addw	s0,s0,1
ffffffffc02003cc:	ff4418e3          	bne	s0,s4,ffffffffc02003bc <kmonitor+0x8a>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003d0:	6582                	ld	a1,0(sp)
ffffffffc02003d2:	855e                	mv	a0,s7
ffffffffc02003d4:	dafff0ef          	jal	ffffffffc0200182 <cprintf>
    return 0;
ffffffffc02003d8:	b7d1                	j	ffffffffc020039c <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003da:	8526                	mv	a0,s1
ffffffffc02003dc:	21b040ef          	jal	ffffffffc0204df6 <strchr>
ffffffffc02003e0:	c901                	beqz	a0,ffffffffc02003f0 <kmonitor+0xbe>
ffffffffc02003e2:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003e6:	00040023          	sb	zero,0(s0)
ffffffffc02003ea:	0405                	add	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ec:	d1e9                	beqz	a1,ffffffffc02003ae <kmonitor+0x7c>
ffffffffc02003ee:	b7f5                	j	ffffffffc02003da <kmonitor+0xa8>
        if (*buf == '\0') {
ffffffffc02003f0:	00044783          	lbu	a5,0(s0)
ffffffffc02003f4:	dfcd                	beqz	a5,ffffffffc02003ae <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc02003f6:	033c8a63          	beq	s9,s3,ffffffffc020042a <kmonitor+0xf8>
        argv[argc ++] = buf;
ffffffffc02003fa:	003c9793          	sll	a5,s9,0x3
ffffffffc02003fe:	08078793          	add	a5,a5,128
ffffffffc0200402:	978a                	add	a5,a5,sp
ffffffffc0200404:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200408:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020040c:	2c85                	addw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020040e:	e591                	bnez	a1,ffffffffc020041a <kmonitor+0xe8>
ffffffffc0200410:	b74d                	j	ffffffffc02003b2 <kmonitor+0x80>
ffffffffc0200412:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200416:	0405                	add	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200418:	d9d9                	beqz	a1,ffffffffc02003ae <kmonitor+0x7c>
ffffffffc020041a:	8526                	mv	a0,s1
ffffffffc020041c:	1db040ef          	jal	ffffffffc0204df6 <strchr>
ffffffffc0200420:	d96d                	beqz	a0,ffffffffc0200412 <kmonitor+0xe0>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200422:	00044583          	lbu	a1,0(s0)
ffffffffc0200426:	d5c1                	beqz	a1,ffffffffc02003ae <kmonitor+0x7c>
ffffffffc0200428:	bf4d                	j	ffffffffc02003da <kmonitor+0xa8>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020042a:	45c1                	li	a1,16
ffffffffc020042c:	8556                	mv	a0,s5
ffffffffc020042e:	d55ff0ef          	jal	ffffffffc0200182 <cprintf>
ffffffffc0200432:	b7e1                	j	ffffffffc02003fa <kmonitor+0xc8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200434:	00141793          	sll	a5,s0,0x1
ffffffffc0200438:	97a2                	add	a5,a5,s0
ffffffffc020043a:	078e                	sll	a5,a5,0x3
ffffffffc020043c:	97e2                	add	a5,a5,s8
ffffffffc020043e:	6b9c                	ld	a5,16(a5)
ffffffffc0200440:	865a                	mv	a2,s6
ffffffffc0200442:	002c                	add	a1,sp,8
ffffffffc0200444:	fffc851b          	addw	a0,s9,-1
ffffffffc0200448:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020044a:	f40559e3          	bgez	a0,ffffffffc020039c <kmonitor+0x6a>
}
ffffffffc020044e:	60ee                	ld	ra,216(sp)
ffffffffc0200450:	644e                	ld	s0,208(sp)
ffffffffc0200452:	64ae                	ld	s1,200(sp)
ffffffffc0200454:	690e                	ld	s2,192(sp)
ffffffffc0200456:	79ea                	ld	s3,184(sp)
ffffffffc0200458:	7a4a                	ld	s4,176(sp)
ffffffffc020045a:	7aaa                	ld	s5,168(sp)
ffffffffc020045c:	7b0a                	ld	s6,160(sp)
ffffffffc020045e:	6bea                	ld	s7,152(sp)
ffffffffc0200460:	6c4a                	ld	s8,144(sp)
ffffffffc0200462:	6caa                	ld	s9,136(sp)
ffffffffc0200464:	6d0a                	ld	s10,128(sp)
ffffffffc0200466:	612d                	add	sp,sp,224
ffffffffc0200468:	8082                	ret

ffffffffc020046a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020046a:	00054317          	auipc	t1,0x54
ffffffffc020046e:	5f630313          	add	t1,t1,1526 # ffffffffc0254a60 <is_panic>
ffffffffc0200472:	00033e03          	ld	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200476:	715d                	add	sp,sp,-80
ffffffffc0200478:	ec06                	sd	ra,24(sp)
ffffffffc020047a:	e822                	sd	s0,16(sp)
ffffffffc020047c:	f436                	sd	a3,40(sp)
ffffffffc020047e:	f83a                	sd	a4,48(sp)
ffffffffc0200480:	fc3e                	sd	a5,56(sp)
ffffffffc0200482:	e0c2                	sd	a6,64(sp)
ffffffffc0200484:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200486:	020e1a63          	bnez	t3,ffffffffc02004ba <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020048a:	4785                	li	a5,1
ffffffffc020048c:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200490:	8432                	mv	s0,a2
ffffffffc0200492:	103c                	add	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200494:	862e                	mv	a2,a1
ffffffffc0200496:	85aa                	mv	a1,a0
ffffffffc0200498:	00005517          	auipc	a0,0x5
ffffffffc020049c:	c4850513          	add	a0,a0,-952 # ffffffffc02050e0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004a0:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004a2:	ce1ff0ef          	jal	ffffffffc0200182 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004a6:	65a2                	ld	a1,8(sp)
ffffffffc02004a8:	8522                	mv	a0,s0
ffffffffc02004aa:	cb9ff0ef          	jal	ffffffffc0200162 <vcprintf>
    cprintf("\n");
ffffffffc02004ae:	00006517          	auipc	a0,0x6
ffffffffc02004b2:	e4250513          	add	a0,a0,-446 # ffffffffc02062f0 <default_pmm_manager+0x790>
ffffffffc02004b6:	ccdff0ef          	jal	ffffffffc0200182 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004ba:	4501                	li	a0,0
ffffffffc02004bc:	4581                	li	a1,0
ffffffffc02004be:	4601                	li	a2,0
ffffffffc02004c0:	48a1                	li	a7,8
ffffffffc02004c2:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004c6:	136000ef          	jal	ffffffffc02005fc <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004ca:	4501                	li	a0,0
ffffffffc02004cc:	e67ff0ef          	jal	ffffffffc0200332 <kmonitor>
    while (1) {
ffffffffc02004d0:	bfed                	j	ffffffffc02004ca <__panic+0x60>

ffffffffc02004d2 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004d2:	715d                	add	sp,sp,-80
ffffffffc02004d4:	832e                	mv	t1,a1
ffffffffc02004d6:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004d8:	85aa                	mv	a1,a0
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004da:	8432                	mv	s0,a2
ffffffffc02004dc:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004de:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc02004e0:	103c                	add	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004e2:	00005517          	auipc	a0,0x5
ffffffffc02004e6:	c1e50513          	add	a0,a0,-994 # ffffffffc0205100 <commands+0x68>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc02004ea:	ec06                	sd	ra,24(sp)
ffffffffc02004ec:	f436                	sd	a3,40(sp)
ffffffffc02004ee:	f83a                	sd	a4,48(sp)
ffffffffc02004f0:	e0c2                	sd	a6,64(sp)
ffffffffc02004f2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02004f4:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004f6:	c8dff0ef          	jal	ffffffffc0200182 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004fa:	65a2                	ld	a1,8(sp)
ffffffffc02004fc:	8522                	mv	a0,s0
ffffffffc02004fe:	c65ff0ef          	jal	ffffffffc0200162 <vcprintf>
    cprintf("\n");
ffffffffc0200502:	00006517          	auipc	a0,0x6
ffffffffc0200506:	dee50513          	add	a0,a0,-530 # ffffffffc02062f0 <default_pmm_manager+0x790>
ffffffffc020050a:	c79ff0ef          	jal	ffffffffc0200182 <cprintf>
    va_end(ap);
}
ffffffffc020050e:	60e2                	ld	ra,24(sp)
ffffffffc0200510:	6442                	ld	s0,16(sp)
ffffffffc0200512:	6161                	add	sp,sp,80
ffffffffc0200514:	8082                	ret

ffffffffc0200516 <clock_set_next_event>:
volatile size_t ticks;

static inline uint64_t get_cycles(void) {
#if __riscv_xlen == 64
    uint64_t n;
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200516:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020051a:	67e1                	lui	a5,0x18
ffffffffc020051c:	6a078793          	add	a5,a5,1696 # 186a0 <_binary_obj___user_ex3_out_size+0xd410>
ffffffffc0200520:	953e                	add	a0,a0,a5
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc0200522:	4581                	li	a1,0
ffffffffc0200524:	4601                	li	a2,0
ffffffffc0200526:	4881                	li	a7,0
ffffffffc0200528:	00000073          	ecall
ffffffffc020052c:	8082                	ret

ffffffffc020052e <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020052e:	8082                	ret

ffffffffc0200530 <cons_putc>:
#include <riscv.h>
#include <assert.h>
#include <atomic.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200530:	100027f3          	csrr	a5,sstatus
ffffffffc0200534:	8b89                	and	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200536:	0ff57513          	zext.b	a0,a0
ffffffffc020053a:	e799                	bnez	a5,ffffffffc0200548 <cons_putc+0x18>
ffffffffc020053c:	4581                	li	a1,0
ffffffffc020053e:	4601                	li	a2,0
ffffffffc0200540:	4885                	li	a7,1
ffffffffc0200542:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200546:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200548:	1101                	add	sp,sp,-32
ffffffffc020054a:	ec06                	sd	ra,24(sp)
ffffffffc020054c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020054e:	0ae000ef          	jal	ffffffffc02005fc <intr_disable>
ffffffffc0200552:	6522                	ld	a0,8(sp)
ffffffffc0200554:	4581                	li	a1,0
ffffffffc0200556:	4601                	li	a2,0
ffffffffc0200558:	4885                	li	a7,1
ffffffffc020055a:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020055e:	60e2                	ld	ra,24(sp)
ffffffffc0200560:	6105                	add	sp,sp,32
        intr_enable();
ffffffffc0200562:	a851                	j	ffffffffc02005f6 <intr_enable>

ffffffffc0200564 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200564:	100027f3          	csrr	a5,sstatus
ffffffffc0200568:	8b89                	and	a5,a5,2
ffffffffc020056a:	eb89                	bnez	a5,ffffffffc020057c <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020056c:	4501                	li	a0,0
ffffffffc020056e:	4581                	li	a1,0
ffffffffc0200570:	4601                	li	a2,0
ffffffffc0200572:	4889                	li	a7,2
ffffffffc0200574:	00000073          	ecall
ffffffffc0200578:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc020057a:	8082                	ret
int cons_getc(void) {
ffffffffc020057c:	1101                	add	sp,sp,-32
ffffffffc020057e:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200580:	07c000ef          	jal	ffffffffc02005fc <intr_disable>
ffffffffc0200584:	4501                	li	a0,0
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4889                	li	a7,2
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	2501                	sext.w	a0,a0
ffffffffc0200592:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200594:	062000ef          	jal	ffffffffc02005f6 <intr_enable>
}
ffffffffc0200598:	60e2                	ld	ra,24(sp)
ffffffffc020059a:	6522                	ld	a0,8(sp)
ffffffffc020059c:	6105                	add	sp,sp,32
ffffffffc020059e:	8082                	ret

ffffffffc02005a0 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02005a0:	8082                	ret

ffffffffc02005a2 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02005a2:	00253513          	sltiu	a0,a0,2
ffffffffc02005a6:	8082                	ret

ffffffffc02005a8 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02005a8:	03800513          	li	a0,56
ffffffffc02005ac:	8082                	ret

ffffffffc02005ae <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02005ae:	00049797          	auipc	a5,0x49
ffffffffc02005b2:	44a78793          	add	a5,a5,1098 # ffffffffc02499f8 <ide>
    int iobase = secno * SECTSIZE;
ffffffffc02005b6:	0095959b          	sllw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02005ba:	1141                	add	sp,sp,-16
ffffffffc02005bc:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02005be:	95be                	add	a1,a1,a5
ffffffffc02005c0:	00969613          	sll	a2,a3,0x9
                  size_t nsecs) {
ffffffffc02005c4:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02005c6:	059040ef          	jal	ffffffffc0204e1e <memcpy>
    return 0;
}
ffffffffc02005ca:	60a2                	ld	ra,8(sp)
ffffffffc02005cc:	4501                	li	a0,0
ffffffffc02005ce:	0141                	add	sp,sp,16
ffffffffc02005d0:	8082                	ret

ffffffffc02005d2 <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
    int iobase = secno * SECTSIZE;
ffffffffc02005d2:	0095979b          	sllw	a5,a1,0x9
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02005d6:	00049517          	auipc	a0,0x49
ffffffffc02005da:	42250513          	add	a0,a0,1058 # ffffffffc02499f8 <ide>
                   size_t nsecs) {
ffffffffc02005de:	1141                	add	sp,sp,-16
ffffffffc02005e0:	85b2                	mv	a1,a2
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02005e2:	953e                	add	a0,a0,a5
ffffffffc02005e4:	00969613          	sll	a2,a3,0x9
                   size_t nsecs) {
ffffffffc02005e8:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02005ea:	035040ef          	jal	ffffffffc0204e1e <memcpy>
    return 0;
}
ffffffffc02005ee:	60a2                	ld	ra,8(sp)
ffffffffc02005f0:	4501                	li	a0,0
ffffffffc02005f2:	0141                	add	sp,sp,16
ffffffffc02005f4:	8082                	ret

ffffffffc02005f6 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02005f6:	100167f3          	csrrs	a5,sstatus,2
ffffffffc02005fa:	8082                	ret

ffffffffc02005fc <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02005fc:	100177f3          	csrrc	a5,sstatus,2
ffffffffc0200600:	8082                	ret

ffffffffc0200602 <idt_init>:
void
idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200602:	14005073          	csrw	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200606:	00000797          	auipc	a5,0x0
ffffffffc020060a:	61a78793          	add	a5,a5,1562 # ffffffffc0200c20 <__alltraps>
ffffffffc020060e:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200612:	000407b7          	lui	a5,0x40
ffffffffc0200616:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020061a:	8082                	ret

ffffffffc020061c <print_regs>:
    cprintf("  tval 0x%08x\n", tf->tval);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs* gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020061c:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs* gpr) {
ffffffffc020061e:	1141                	add	sp,sp,-16
ffffffffc0200620:	e022                	sd	s0,0(sp)
ffffffffc0200622:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200624:	00005517          	auipc	a0,0x5
ffffffffc0200628:	afc50513          	add	a0,a0,-1284 # ffffffffc0205120 <commands+0x88>
void print_regs(struct pushregs* gpr) {
ffffffffc020062c:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020062e:	b55ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200632:	640c                	ld	a1,8(s0)
ffffffffc0200634:	00005517          	auipc	a0,0x5
ffffffffc0200638:	b0450513          	add	a0,a0,-1276 # ffffffffc0205138 <commands+0xa0>
ffffffffc020063c:	b47ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200640:	680c                	ld	a1,16(s0)
ffffffffc0200642:	00005517          	auipc	a0,0x5
ffffffffc0200646:	b0e50513          	add	a0,a0,-1266 # ffffffffc0205150 <commands+0xb8>
ffffffffc020064a:	b39ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020064e:	6c0c                	ld	a1,24(s0)
ffffffffc0200650:	00005517          	auipc	a0,0x5
ffffffffc0200654:	b1850513          	add	a0,a0,-1256 # ffffffffc0205168 <commands+0xd0>
ffffffffc0200658:	b2bff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc020065c:	700c                	ld	a1,32(s0)
ffffffffc020065e:	00005517          	auipc	a0,0x5
ffffffffc0200662:	b2250513          	add	a0,a0,-1246 # ffffffffc0205180 <commands+0xe8>
ffffffffc0200666:	b1dff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020066a:	740c                	ld	a1,40(s0)
ffffffffc020066c:	00005517          	auipc	a0,0x5
ffffffffc0200670:	b2c50513          	add	a0,a0,-1236 # ffffffffc0205198 <commands+0x100>
ffffffffc0200674:	b0fff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200678:	780c                	ld	a1,48(s0)
ffffffffc020067a:	00005517          	auipc	a0,0x5
ffffffffc020067e:	b3650513          	add	a0,a0,-1226 # ffffffffc02051b0 <commands+0x118>
ffffffffc0200682:	b01ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200686:	7c0c                	ld	a1,56(s0)
ffffffffc0200688:	00005517          	auipc	a0,0x5
ffffffffc020068c:	b4050513          	add	a0,a0,-1216 # ffffffffc02051c8 <commands+0x130>
ffffffffc0200690:	af3ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200694:	602c                	ld	a1,64(s0)
ffffffffc0200696:	00005517          	auipc	a0,0x5
ffffffffc020069a:	b4a50513          	add	a0,a0,-1206 # ffffffffc02051e0 <commands+0x148>
ffffffffc020069e:	ae5ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02006a2:	642c                	ld	a1,72(s0)
ffffffffc02006a4:	00005517          	auipc	a0,0x5
ffffffffc02006a8:	b5450513          	add	a0,a0,-1196 # ffffffffc02051f8 <commands+0x160>
ffffffffc02006ac:	ad7ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02006b0:	682c                	ld	a1,80(s0)
ffffffffc02006b2:	00005517          	auipc	a0,0x5
ffffffffc02006b6:	b5e50513          	add	a0,a0,-1186 # ffffffffc0205210 <commands+0x178>
ffffffffc02006ba:	ac9ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02006be:	6c2c                	ld	a1,88(s0)
ffffffffc02006c0:	00005517          	auipc	a0,0x5
ffffffffc02006c4:	b6850513          	add	a0,a0,-1176 # ffffffffc0205228 <commands+0x190>
ffffffffc02006c8:	abbff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02006cc:	702c                	ld	a1,96(s0)
ffffffffc02006ce:	00005517          	auipc	a0,0x5
ffffffffc02006d2:	b7250513          	add	a0,a0,-1166 # ffffffffc0205240 <commands+0x1a8>
ffffffffc02006d6:	aadff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc02006da:	742c                	ld	a1,104(s0)
ffffffffc02006dc:	00005517          	auipc	a0,0x5
ffffffffc02006e0:	b7c50513          	add	a0,a0,-1156 # ffffffffc0205258 <commands+0x1c0>
ffffffffc02006e4:	a9fff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc02006e8:	782c                	ld	a1,112(s0)
ffffffffc02006ea:	00005517          	auipc	a0,0x5
ffffffffc02006ee:	b8650513          	add	a0,a0,-1146 # ffffffffc0205270 <commands+0x1d8>
ffffffffc02006f2:	a91ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc02006f6:	7c2c                	ld	a1,120(s0)
ffffffffc02006f8:	00005517          	auipc	a0,0x5
ffffffffc02006fc:	b9050513          	add	a0,a0,-1136 # ffffffffc0205288 <commands+0x1f0>
ffffffffc0200700:	a83ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200704:	604c                	ld	a1,128(s0)
ffffffffc0200706:	00005517          	auipc	a0,0x5
ffffffffc020070a:	b9a50513          	add	a0,a0,-1126 # ffffffffc02052a0 <commands+0x208>
ffffffffc020070e:	a75ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200712:	644c                	ld	a1,136(s0)
ffffffffc0200714:	00005517          	auipc	a0,0x5
ffffffffc0200718:	ba450513          	add	a0,a0,-1116 # ffffffffc02052b8 <commands+0x220>
ffffffffc020071c:	a67ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200720:	684c                	ld	a1,144(s0)
ffffffffc0200722:	00005517          	auipc	a0,0x5
ffffffffc0200726:	bae50513          	add	a0,a0,-1106 # ffffffffc02052d0 <commands+0x238>
ffffffffc020072a:	a59ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020072e:	6c4c                	ld	a1,152(s0)
ffffffffc0200730:	00005517          	auipc	a0,0x5
ffffffffc0200734:	bb850513          	add	a0,a0,-1096 # ffffffffc02052e8 <commands+0x250>
ffffffffc0200738:	a4bff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc020073c:	704c                	ld	a1,160(s0)
ffffffffc020073e:	00005517          	auipc	a0,0x5
ffffffffc0200742:	bc250513          	add	a0,a0,-1086 # ffffffffc0205300 <commands+0x268>
ffffffffc0200746:	a3dff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc020074a:	744c                	ld	a1,168(s0)
ffffffffc020074c:	00005517          	auipc	a0,0x5
ffffffffc0200750:	bcc50513          	add	a0,a0,-1076 # ffffffffc0205318 <commands+0x280>
ffffffffc0200754:	a2fff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200758:	784c                	ld	a1,176(s0)
ffffffffc020075a:	00005517          	auipc	a0,0x5
ffffffffc020075e:	bd650513          	add	a0,a0,-1066 # ffffffffc0205330 <commands+0x298>
ffffffffc0200762:	a21ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200766:	7c4c                	ld	a1,184(s0)
ffffffffc0200768:	00005517          	auipc	a0,0x5
ffffffffc020076c:	be050513          	add	a0,a0,-1056 # ffffffffc0205348 <commands+0x2b0>
ffffffffc0200770:	a13ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200774:	606c                	ld	a1,192(s0)
ffffffffc0200776:	00005517          	auipc	a0,0x5
ffffffffc020077a:	bea50513          	add	a0,a0,-1046 # ffffffffc0205360 <commands+0x2c8>
ffffffffc020077e:	a05ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200782:	646c                	ld	a1,200(s0)
ffffffffc0200784:	00005517          	auipc	a0,0x5
ffffffffc0200788:	bf450513          	add	a0,a0,-1036 # ffffffffc0205378 <commands+0x2e0>
ffffffffc020078c:	9f7ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200790:	686c                	ld	a1,208(s0)
ffffffffc0200792:	00005517          	auipc	a0,0x5
ffffffffc0200796:	bfe50513          	add	a0,a0,-1026 # ffffffffc0205390 <commands+0x2f8>
ffffffffc020079a:	9e9ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc020079e:	6c6c                	ld	a1,216(s0)
ffffffffc02007a0:	00005517          	auipc	a0,0x5
ffffffffc02007a4:	c0850513          	add	a0,a0,-1016 # ffffffffc02053a8 <commands+0x310>
ffffffffc02007a8:	9dbff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02007ac:	706c                	ld	a1,224(s0)
ffffffffc02007ae:	00005517          	auipc	a0,0x5
ffffffffc02007b2:	c1250513          	add	a0,a0,-1006 # ffffffffc02053c0 <commands+0x328>
ffffffffc02007b6:	9cdff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02007ba:	746c                	ld	a1,232(s0)
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	c1c50513          	add	a0,a0,-996 # ffffffffc02053d8 <commands+0x340>
ffffffffc02007c4:	9bfff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc02007c8:	786c                	ld	a1,240(s0)
ffffffffc02007ca:	00005517          	auipc	a0,0x5
ffffffffc02007ce:	c2650513          	add	a0,a0,-986 # ffffffffc02053f0 <commands+0x358>
ffffffffc02007d2:	9b1ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007d6:	7c6c                	ld	a1,248(s0)
}
ffffffffc02007d8:	6402                	ld	s0,0(sp)
ffffffffc02007da:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007dc:	00005517          	auipc	a0,0x5
ffffffffc02007e0:	c2c50513          	add	a0,a0,-980 # ffffffffc0205408 <commands+0x370>
}
ffffffffc02007e4:	0141                	add	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc02007e6:	ba71                	j	ffffffffc0200182 <cprintf>

ffffffffc02007e8 <print_trapframe>:
print_trapframe(struct trapframe *tf) {
ffffffffc02007e8:	1141                	add	sp,sp,-16
ffffffffc02007ea:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc02007ec:	85aa                	mv	a1,a0
print_trapframe(struct trapframe *tf) {
ffffffffc02007ee:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc02007f0:	00005517          	auipc	a0,0x5
ffffffffc02007f4:	c3050513          	add	a0,a0,-976 # ffffffffc0205420 <commands+0x388>
print_trapframe(struct trapframe *tf) {
ffffffffc02007f8:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc02007fa:	989ff0ef          	jal	ffffffffc0200182 <cprintf>
    print_regs(&tf->gpr);
ffffffffc02007fe:	8522                	mv	a0,s0
ffffffffc0200800:	e1dff0ef          	jal	ffffffffc020061c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200804:	10043583          	ld	a1,256(s0)
ffffffffc0200808:	00005517          	auipc	a0,0x5
ffffffffc020080c:	c3050513          	add	a0,a0,-976 # ffffffffc0205438 <commands+0x3a0>
ffffffffc0200810:	973ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200814:	10843583          	ld	a1,264(s0)
ffffffffc0200818:	00005517          	auipc	a0,0x5
ffffffffc020081c:	c3850513          	add	a0,a0,-968 # ffffffffc0205450 <commands+0x3b8>
ffffffffc0200820:	963ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200824:	11043583          	ld	a1,272(s0)
ffffffffc0200828:	00005517          	auipc	a0,0x5
ffffffffc020082c:	c4050513          	add	a0,a0,-960 # ffffffffc0205468 <commands+0x3d0>
ffffffffc0200830:	953ff0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200834:	11843583          	ld	a1,280(s0)
}
ffffffffc0200838:	6402                	ld	s0,0(sp)
ffffffffc020083a:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020083c:	00005517          	auipc	a0,0x5
ffffffffc0200840:	c3c50513          	add	a0,a0,-964 # ffffffffc0205478 <commands+0x3e0>
}
ffffffffc0200844:	0141                	add	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200846:	93dff06f          	j	ffffffffc0200182 <cprintf>

ffffffffc020084a <pgfault_handler>:
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int
pgfault_handler(struct trapframe *tf) {
ffffffffc020084a:	1101                	add	sp,sp,-32
ffffffffc020084c:	e426                	sd	s1,8(sp)
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { 
ffffffffc020084e:	00054497          	auipc	s1,0x54
ffffffffc0200852:	27a48493          	add	s1,s1,634 # ffffffffc0254ac8 <check_mm_struct>
ffffffffc0200856:	609c                	ld	a5,0(s1)
pgfault_handler(struct trapframe *tf) {
ffffffffc0200858:	e822                	sd	s0,16(sp)
ffffffffc020085a:	ec06                	sd	ra,24(sp)
ffffffffc020085c:	842a                	mv	s0,a0
    if(check_mm_struct !=NULL) { 
ffffffffc020085e:	cfb9                	beqz	a5,ffffffffc02008bc <pgfault_handler+0x72>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200860:	10053783          	ld	a5,256(a0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200864:	11053583          	ld	a1,272(a0)
ffffffffc0200868:	05500613          	li	a2,85
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020086c:	1007f793          	and	a5,a5,256
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200870:	c399                	beqz	a5,ffffffffc0200876 <pgfault_handler+0x2c>
ffffffffc0200872:	04b00613          	li	a2,75
ffffffffc0200876:	11843703          	ld	a4,280(s0)
ffffffffc020087a:	47bd                	li	a5,15
ffffffffc020087c:	05200693          	li	a3,82
ffffffffc0200880:	04f70e63          	beq	a4,a5,ffffffffc02008dc <pgfault_handler+0x92>
ffffffffc0200884:	00005517          	auipc	a0,0x5
ffffffffc0200888:	c0c50513          	add	a0,a0,-1012 # ffffffffc0205490 <commands+0x3f8>
ffffffffc020088c:	8f7ff0ef          	jal	ffffffffc0200182 <cprintf>
            print_pgfault(tf);
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
ffffffffc0200890:	6088                	ld	a0,0(s1)
ffffffffc0200892:	c50d                	beqz	a0,ffffffffc02008bc <pgfault_handler+0x72>
        assert(current == idleproc);
ffffffffc0200894:	00054717          	auipc	a4,0x54
ffffffffc0200898:	24473703          	ld	a4,580(a4) # ffffffffc0254ad8 <current>
ffffffffc020089c:	00054797          	auipc	a5,0x54
ffffffffc02008a0:	24c7b783          	ld	a5,588(a5) # ffffffffc0254ae8 <idleproc>
ffffffffc02008a4:	02f71f63          	bne	a4,a5,ffffffffc02008e2 <pgfault_handler+0x98>
            print_pgfault(tf);
            panic("unhandled page fault.\n");
        }
        mm = current->mm;
    }
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008a8:	11043603          	ld	a2,272(s0)
ffffffffc02008ac:	11843583          	ld	a1,280(s0)
}
ffffffffc02008b0:	6442                	ld	s0,16(sp)
ffffffffc02008b2:	60e2                	ld	ra,24(sp)
ffffffffc02008b4:	64a2                	ld	s1,8(sp)
ffffffffc02008b6:	6105                	add	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008b8:	6d00206f          	j	ffffffffc0202f88 <do_pgfault>
        if (current == NULL) {
ffffffffc02008bc:	00054797          	auipc	a5,0x54
ffffffffc02008c0:	21c7b783          	ld	a5,540(a5) # ffffffffc0254ad8 <current>
ffffffffc02008c4:	cf9d                	beqz	a5,ffffffffc0200902 <pgfault_handler+0xb8>
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008c6:	11043603          	ld	a2,272(s0)
ffffffffc02008ca:	11843583          	ld	a1,280(s0)
}
ffffffffc02008ce:	6442                	ld	s0,16(sp)
ffffffffc02008d0:	60e2                	ld	ra,24(sp)
ffffffffc02008d2:	64a2                	ld	s1,8(sp)
        mm = current->mm;
ffffffffc02008d4:	7788                	ld	a0,40(a5)
}
ffffffffc02008d6:	6105                	add	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc02008d8:	6b00206f          	j	ffffffffc0202f88 <do_pgfault>
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008dc:	05700693          	li	a3,87
ffffffffc02008e0:	b755                	j	ffffffffc0200884 <pgfault_handler+0x3a>
        assert(current == idleproc);
ffffffffc02008e2:	00005697          	auipc	a3,0x5
ffffffffc02008e6:	bce68693          	add	a3,a3,-1074 # ffffffffc02054b0 <commands+0x418>
ffffffffc02008ea:	00005617          	auipc	a2,0x5
ffffffffc02008ee:	bde60613          	add	a2,a2,-1058 # ffffffffc02054c8 <commands+0x430>
ffffffffc02008f2:	06800593          	li	a1,104
ffffffffc02008f6:	00005517          	auipc	a0,0x5
ffffffffc02008fa:	bea50513          	add	a0,a0,-1046 # ffffffffc02054e0 <commands+0x448>
ffffffffc02008fe:	b6dff0ef          	jal	ffffffffc020046a <__panic>
            print_trapframe(tf);
ffffffffc0200902:	8522                	mv	a0,s0
ffffffffc0200904:	ee5ff0ef          	jal	ffffffffc02007e8 <print_trapframe>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200908:	10043783          	ld	a5,256(s0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc020090c:	11043583          	ld	a1,272(s0)
ffffffffc0200910:	05500613          	li	a2,85
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200914:	1007f793          	and	a5,a5,256
    cprintf("page falut at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200918:	c399                	beqz	a5,ffffffffc020091e <pgfault_handler+0xd4>
ffffffffc020091a:	04b00613          	li	a2,75
ffffffffc020091e:	11843703          	ld	a4,280(s0)
ffffffffc0200922:	47bd                	li	a5,15
ffffffffc0200924:	05200693          	li	a3,82
ffffffffc0200928:	00f71463          	bne	a4,a5,ffffffffc0200930 <pgfault_handler+0xe6>
ffffffffc020092c:	05700693          	li	a3,87
ffffffffc0200930:	00005517          	auipc	a0,0x5
ffffffffc0200934:	b6050513          	add	a0,a0,-1184 # ffffffffc0205490 <commands+0x3f8>
ffffffffc0200938:	84bff0ef          	jal	ffffffffc0200182 <cprintf>
            panic("unhandled page fault.\n");
ffffffffc020093c:	00005617          	auipc	a2,0x5
ffffffffc0200940:	bbc60613          	add	a2,a2,-1092 # ffffffffc02054f8 <commands+0x460>
ffffffffc0200944:	06f00593          	li	a1,111
ffffffffc0200948:	00005517          	auipc	a0,0x5
ffffffffc020094c:	b9850513          	add	a0,a0,-1128 # ffffffffc02054e0 <commands+0x448>
ffffffffc0200950:	b1bff0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0200954 <interrupt_handler>:
static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    switch (cause) {
ffffffffc0200954:	11853783          	ld	a5,280(a0)
ffffffffc0200958:	472d                	li	a4,11
ffffffffc020095a:	0786                	sll	a5,a5,0x1
ffffffffc020095c:	8385                	srl	a5,a5,0x1
ffffffffc020095e:	06f76d63          	bltu	a4,a5,ffffffffc02009d8 <interrupt_handler+0x84>
ffffffffc0200962:	00005717          	auipc	a4,0x5
ffffffffc0200966:	c4e70713          	add	a4,a4,-946 # ffffffffc02055b0 <commands+0x518>
ffffffffc020096a:	078a                	sll	a5,a5,0x2
ffffffffc020096c:	97ba                	add	a5,a5,a4
ffffffffc020096e:	439c                	lw	a5,0(a5)
ffffffffc0200970:	97ba                	add	a5,a5,a4
ffffffffc0200972:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	bfc50513          	add	a0,a0,-1028 # ffffffffc0205570 <commands+0x4d8>
ffffffffc020097c:	807ff06f          	j	ffffffffc0200182 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	bd050513          	add	a0,a0,-1072 # ffffffffc0205550 <commands+0x4b8>
ffffffffc0200988:	ffaff06f          	j	ffffffffc0200182 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc020098c:	00005517          	auipc	a0,0x5
ffffffffc0200990:	b8450513          	add	a0,a0,-1148 # ffffffffc0205510 <commands+0x478>
ffffffffc0200994:	feeff06f          	j	ffffffffc0200182 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200998:	00005517          	auipc	a0,0x5
ffffffffc020099c:	b9850513          	add	a0,a0,-1128 # ffffffffc0205530 <commands+0x498>
ffffffffc02009a0:	fe2ff06f          	j	ffffffffc0200182 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02009a4:	1141                	add	sp,sp,-16
ffffffffc02009a6:	e406                	sd	ra,8(sp)
            break;
        case IRQ_U_TIMER:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_TIMER:
            clock_set_next_event();
ffffffffc02009a8:	b6fff0ef          	jal	ffffffffc0200516 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0 ) {
ffffffffc02009ac:	00054717          	auipc	a4,0x54
ffffffffc02009b0:	0bc70713          	add	a4,a4,188 # ffffffffc0254a68 <ticks>
ffffffffc02009b4:	631c                	ld	a5,0(a4)
                //print_ticks()
            }
            if (current){
ffffffffc02009b6:	00054517          	auipc	a0,0x54
ffffffffc02009ba:	12253503          	ld	a0,290(a0) # ffffffffc0254ad8 <current>
            if (++ticks % TICK_NUM == 0 ) {
ffffffffc02009be:	0785                	add	a5,a5,1
ffffffffc02009c0:	e31c                	sd	a5,0(a4)
            if (current){
ffffffffc02009c2:	cd01                	beqz	a0,ffffffffc02009da <interrupt_handler+0x86>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc02009c4:	60a2                	ld	ra,8(sp)
ffffffffc02009c6:	0141                	add	sp,sp,16
                sched_class_proc_tick(current); 
ffffffffc02009c8:	4270306f          	j	ffffffffc02045ee <sched_class_proc_tick>
            cprintf("Supervisor external interrupt\n");
ffffffffc02009cc:	00005517          	auipc	a0,0x5
ffffffffc02009d0:	bc450513          	add	a0,a0,-1084 # ffffffffc0205590 <commands+0x4f8>
ffffffffc02009d4:	faeff06f          	j	ffffffffc0200182 <cprintf>
            print_trapframe(tf);
ffffffffc02009d8:	bd01                	j	ffffffffc02007e8 <print_trapframe>
}
ffffffffc02009da:	60a2                	ld	ra,8(sp)
ffffffffc02009dc:	0141                	add	sp,sp,16
ffffffffc02009de:	8082                	ret

ffffffffc02009e0 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc02009e0:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc02009e4:	1101                	add	sp,sp,-32
ffffffffc02009e6:	e822                	sd	s0,16(sp)
ffffffffc02009e8:	ec06                	sd	ra,24(sp)
ffffffffc02009ea:	e426                	sd	s1,8(sp)
    switch (tf->cause) {
ffffffffc02009ec:	473d                	li	a4,15
void exception_handler(struct trapframe *tf) {
ffffffffc02009ee:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc02009f0:	16f76163          	bltu	a4,a5,ffffffffc0200b52 <exception_handler+0x172>
ffffffffc02009f4:	00005717          	auipc	a4,0x5
ffffffffc02009f8:	d8470713          	add	a4,a4,-636 # ffffffffc0205778 <commands+0x6e0>
ffffffffc02009fc:	078a                	sll	a5,a5,0x2
ffffffffc02009fe:	97ba                	add	a5,a5,a4
ffffffffc0200a00:	439c                	lw	a5,0(a5)
ffffffffc0200a02:	97ba                	add	a5,a5,a4
ffffffffc0200a04:	8782                	jr	a5
            //cprintf("Environment call from U-mode\n");
            tf->epc += 4;
            syscall();
            break;
        case CAUSE_SUPERVISOR_ECALL:
            cprintf("Environment call from S-mode\n");
ffffffffc0200a06:	00005517          	auipc	a0,0x5
ffffffffc0200a0a:	cca50513          	add	a0,a0,-822 # ffffffffc02056d0 <commands+0x638>
ffffffffc0200a0e:	f74ff0ef          	jal	ffffffffc0200182 <cprintf>
            tf->epc += 4;
ffffffffc0200a12:	10843783          	ld	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a16:	60e2                	ld	ra,24(sp)
ffffffffc0200a18:	64a2                	ld	s1,8(sp)
            tf->epc += 4;
ffffffffc0200a1a:	0791                	add	a5,a5,4
ffffffffc0200a1c:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200a20:	6442                	ld	s0,16(sp)
ffffffffc0200a22:	6105                	add	sp,sp,32
            syscall();
ffffffffc0200a24:	6e30306f          	j	ffffffffc0204906 <syscall>
            cprintf("Environment call from H-mode\n");
ffffffffc0200a28:	00005517          	auipc	a0,0x5
ffffffffc0200a2c:	cc850513          	add	a0,a0,-824 # ffffffffc02056f0 <commands+0x658>
}
ffffffffc0200a30:	6442                	ld	s0,16(sp)
ffffffffc0200a32:	60e2                	ld	ra,24(sp)
ffffffffc0200a34:	64a2                	ld	s1,8(sp)
ffffffffc0200a36:	6105                	add	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc0200a38:	f4aff06f          	j	ffffffffc0200182 <cprintf>
            cprintf("Environment call from M-mode\n");
ffffffffc0200a3c:	00005517          	auipc	a0,0x5
ffffffffc0200a40:	cd450513          	add	a0,a0,-812 # ffffffffc0205710 <commands+0x678>
ffffffffc0200a44:	b7f5                	j	ffffffffc0200a30 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200a46:	00005517          	auipc	a0,0x5
ffffffffc0200a4a:	cea50513          	add	a0,a0,-790 # ffffffffc0205730 <commands+0x698>
ffffffffc0200a4e:	b7cd                	j	ffffffffc0200a30 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	cf850513          	add	a0,a0,-776 # ffffffffc0205748 <commands+0x6b0>
ffffffffc0200a58:	f2aff0ef          	jal	ffffffffc0200182 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200a5c:	8522                	mv	a0,s0
ffffffffc0200a5e:	dedff0ef          	jal	ffffffffc020084a <pgfault_handler>
ffffffffc0200a62:	84aa                	mv	s1,a0
ffffffffc0200a64:	10051963          	bnez	a0,ffffffffc0200b76 <exception_handler+0x196>
}
ffffffffc0200a68:	60e2                	ld	ra,24(sp)
ffffffffc0200a6a:	6442                	ld	s0,16(sp)
ffffffffc0200a6c:	64a2                	ld	s1,8(sp)
ffffffffc0200a6e:	6105                	add	sp,sp,32
ffffffffc0200a70:	8082                	ret
            cprintf("Store/AMO page fault\n");
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	cee50513          	add	a0,a0,-786 # ffffffffc0205760 <commands+0x6c8>
ffffffffc0200a7a:	f08ff0ef          	jal	ffffffffc0200182 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200a7e:	8522                	mv	a0,s0
ffffffffc0200a80:	dcbff0ef          	jal	ffffffffc020084a <pgfault_handler>
ffffffffc0200a84:	84aa                	mv	s1,a0
ffffffffc0200a86:	d16d                	beqz	a0,ffffffffc0200a68 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200a88:	8522                	mv	a0,s0
ffffffffc0200a8a:	d5fff0ef          	jal	ffffffffc02007e8 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a8e:	86a6                	mv	a3,s1
ffffffffc0200a90:	00005617          	auipc	a2,0x5
ffffffffc0200a94:	bf060613          	add	a2,a2,-1040 # ffffffffc0205680 <commands+0x5e8>
ffffffffc0200a98:	0f100593          	li	a1,241
ffffffffc0200a9c:	00005517          	auipc	a0,0x5
ffffffffc0200aa0:	a4450513          	add	a0,a0,-1468 # ffffffffc02054e0 <commands+0x448>
ffffffffc0200aa4:	9c7ff0ef          	jal	ffffffffc020046a <__panic>
            cprintf("Instruction address misaligned\n");
ffffffffc0200aa8:	00005517          	auipc	a0,0x5
ffffffffc0200aac:	b3850513          	add	a0,a0,-1224 # ffffffffc02055e0 <commands+0x548>
ffffffffc0200ab0:	b741                	j	ffffffffc0200a30 <exception_handler+0x50>
            cprintf("Instruction access fault\n");
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	b4e50513          	add	a0,a0,-1202 # ffffffffc0205600 <commands+0x568>
ffffffffc0200aba:	bf9d                	j	ffffffffc0200a30 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc0200abc:	00005517          	auipc	a0,0x5
ffffffffc0200ac0:	b6450513          	add	a0,a0,-1180 # ffffffffc0205620 <commands+0x588>
ffffffffc0200ac4:	b7b5                	j	ffffffffc0200a30 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	b7250513          	add	a0,a0,-1166 # ffffffffc0205638 <commands+0x5a0>
ffffffffc0200ace:	eb4ff0ef          	jal	ffffffffc0200182 <cprintf>
            if(tf->gpr.a7 == 10){
ffffffffc0200ad2:	6458                	ld	a4,136(s0)
ffffffffc0200ad4:	47a9                	li	a5,10
ffffffffc0200ad6:	f8f719e3          	bne	a4,a5,ffffffffc0200a68 <exception_handler+0x88>
ffffffffc0200ada:	bf25                	j	ffffffffc0200a12 <exception_handler+0x32>
            cprintf("Load address misaligned\n");
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	b6c50513          	add	a0,a0,-1172 # ffffffffc0205648 <commands+0x5b0>
ffffffffc0200ae4:	b7b1                	j	ffffffffc0200a30 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200ae6:	00005517          	auipc	a0,0x5
ffffffffc0200aea:	b8250513          	add	a0,a0,-1150 # ffffffffc0205668 <commands+0x5d0>
ffffffffc0200aee:	e94ff0ef          	jal	ffffffffc0200182 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200af2:	8522                	mv	a0,s0
ffffffffc0200af4:	d57ff0ef          	jal	ffffffffc020084a <pgfault_handler>
ffffffffc0200af8:	84aa                	mv	s1,a0
ffffffffc0200afa:	d53d                	beqz	a0,ffffffffc0200a68 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200afc:	8522                	mv	a0,s0
ffffffffc0200afe:	cebff0ef          	jal	ffffffffc02007e8 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b02:	86a6                	mv	a3,s1
ffffffffc0200b04:	00005617          	auipc	a2,0x5
ffffffffc0200b08:	b7c60613          	add	a2,a2,-1156 # ffffffffc0205680 <commands+0x5e8>
ffffffffc0200b0c:	0c600593          	li	a1,198
ffffffffc0200b10:	00005517          	auipc	a0,0x5
ffffffffc0200b14:	9d050513          	add	a0,a0,-1584 # ffffffffc02054e0 <commands+0x448>
ffffffffc0200b18:	953ff0ef          	jal	ffffffffc020046a <__panic>
            cprintf("Store/AMO access fault\n");
ffffffffc0200b1c:	00005517          	auipc	a0,0x5
ffffffffc0200b20:	b9c50513          	add	a0,a0,-1124 # ffffffffc02056b8 <commands+0x620>
ffffffffc0200b24:	e5eff0ef          	jal	ffffffffc0200182 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200b28:	8522                	mv	a0,s0
ffffffffc0200b2a:	d21ff0ef          	jal	ffffffffc020084a <pgfault_handler>
ffffffffc0200b2e:	84aa                	mv	s1,a0
ffffffffc0200b30:	dd05                	beqz	a0,ffffffffc0200a68 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200b32:	8522                	mv	a0,s0
ffffffffc0200b34:	cb5ff0ef          	jal	ffffffffc02007e8 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b38:	86a6                	mv	a3,s1
ffffffffc0200b3a:	00005617          	auipc	a2,0x5
ffffffffc0200b3e:	b4660613          	add	a2,a2,-1210 # ffffffffc0205680 <commands+0x5e8>
ffffffffc0200b42:	0d000593          	li	a1,208
ffffffffc0200b46:	00005517          	auipc	a0,0x5
ffffffffc0200b4a:	99a50513          	add	a0,a0,-1638 # ffffffffc02054e0 <commands+0x448>
ffffffffc0200b4e:	91dff0ef          	jal	ffffffffc020046a <__panic>
            print_trapframe(tf);
ffffffffc0200b52:	8522                	mv	a0,s0
}
ffffffffc0200b54:	6442                	ld	s0,16(sp)
ffffffffc0200b56:	60e2                	ld	ra,24(sp)
ffffffffc0200b58:	64a2                	ld	s1,8(sp)
ffffffffc0200b5a:	6105                	add	sp,sp,32
            print_trapframe(tf);
ffffffffc0200b5c:	b171                	j	ffffffffc02007e8 <print_trapframe>
            panic("AMO address misaligned\n");
ffffffffc0200b5e:	00005617          	auipc	a2,0x5
ffffffffc0200b62:	b4260613          	add	a2,a2,-1214 # ffffffffc02056a0 <commands+0x608>
ffffffffc0200b66:	0ca00593          	li	a1,202
ffffffffc0200b6a:	00005517          	auipc	a0,0x5
ffffffffc0200b6e:	97650513          	add	a0,a0,-1674 # ffffffffc02054e0 <commands+0x448>
ffffffffc0200b72:	8f9ff0ef          	jal	ffffffffc020046a <__panic>
                print_trapframe(tf);
ffffffffc0200b76:	8522                	mv	a0,s0
ffffffffc0200b78:	c71ff0ef          	jal	ffffffffc02007e8 <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b7c:	86a6                	mv	a3,s1
ffffffffc0200b7e:	00005617          	auipc	a2,0x5
ffffffffc0200b82:	b0260613          	add	a2,a2,-1278 # ffffffffc0205680 <commands+0x5e8>
ffffffffc0200b86:	0ea00593          	li	a1,234
ffffffffc0200b8a:	00005517          	auipc	a0,0x5
ffffffffc0200b8e:	95650513          	add	a0,a0,-1706 # ffffffffc02054e0 <commands+0x448>
ffffffffc0200b92:	8d9ff0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0200b96 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
ffffffffc0200b96:	1101                	add	sp,sp,-32
ffffffffc0200b98:	e822                	sd	s0,16(sp)

    if (current == NULL) {
ffffffffc0200b9a:	00054417          	auipc	s0,0x54
ffffffffc0200b9e:	f3e40413          	add	s0,s0,-194 # ffffffffc0254ad8 <current>
ffffffffc0200ba2:	6018                	ld	a4,0(s0)
trap(struct trapframe *tf) {
ffffffffc0200ba4:	ec06                	sd	ra,24(sp)
ffffffffc0200ba6:	e426                	sd	s1,8(sp)
ffffffffc0200ba8:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200baa:	11853683          	ld	a3,280(a0)
    if (current == NULL) {
ffffffffc0200bae:	cf1d                	beqz	a4,ffffffffc0200bec <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200bb0:	10053483          	ld	s1,256(a0)
        trap_dispatch(tf);
    } else {
        struct trapframe *otf = current->tf;
ffffffffc0200bb4:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200bb8:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200bba:	1004f493          	and	s1,s1,256
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bbe:	0206c463          	bltz	a3,ffffffffc0200be6 <trap+0x50>
        exception_handler(tf);
ffffffffc0200bc2:	e1fff0ef          	jal	ffffffffc02009e0 <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200bc6:	601c                	ld	a5,0(s0)
ffffffffc0200bc8:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel) {
ffffffffc0200bcc:	e499                	bnez	s1,ffffffffc0200bda <trap+0x44>
            if (current->flags & PF_EXITING) {
ffffffffc0200bce:	0b07a703          	lw	a4,176(a5)
ffffffffc0200bd2:	8b05                	and	a4,a4,1
ffffffffc0200bd4:	e329                	bnez	a4,ffffffffc0200c16 <trap+0x80>
                do_exit(-E_KILLED);
            }
            if (current->need_resched) {
ffffffffc0200bd6:	6f9c                	ld	a5,24(a5)
ffffffffc0200bd8:	eb85                	bnez	a5,ffffffffc0200c08 <trap+0x72>
                schedule();
            }
        }
    }
}
ffffffffc0200bda:	60e2                	ld	ra,24(sp)
ffffffffc0200bdc:	6442                	ld	s0,16(sp)
ffffffffc0200bde:	64a2                	ld	s1,8(sp)
ffffffffc0200be0:	6902                	ld	s2,0(sp)
ffffffffc0200be2:	6105                	add	sp,sp,32
ffffffffc0200be4:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200be6:	d6fff0ef          	jal	ffffffffc0200954 <interrupt_handler>
ffffffffc0200bea:	bff1                	j	ffffffffc0200bc6 <trap+0x30>
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bec:	0006c863          	bltz	a3,ffffffffc0200bfc <trap+0x66>
}
ffffffffc0200bf0:	6442                	ld	s0,16(sp)
ffffffffc0200bf2:	60e2                	ld	ra,24(sp)
ffffffffc0200bf4:	64a2                	ld	s1,8(sp)
ffffffffc0200bf6:	6902                	ld	s2,0(sp)
ffffffffc0200bf8:	6105                	add	sp,sp,32
        exception_handler(tf);
ffffffffc0200bfa:	b3dd                	j	ffffffffc02009e0 <exception_handler>
}
ffffffffc0200bfc:	6442                	ld	s0,16(sp)
ffffffffc0200bfe:	60e2                	ld	ra,24(sp)
ffffffffc0200c00:	64a2                	ld	s1,8(sp)
ffffffffc0200c02:	6902                	ld	s2,0(sp)
ffffffffc0200c04:	6105                	add	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200c06:	b3b9                	j	ffffffffc0200954 <interrupt_handler>
}
ffffffffc0200c08:	6442                	ld	s0,16(sp)
ffffffffc0200c0a:	60e2                	ld	ra,24(sp)
ffffffffc0200c0c:	64a2                	ld	s1,8(sp)
ffffffffc0200c0e:	6902                	ld	s2,0(sp)
ffffffffc0200c10:	6105                	add	sp,sp,32
                schedule();
ffffffffc0200c12:	35d0306f          	j	ffffffffc020476e <schedule>
                do_exit(-E_KILLED);
ffffffffc0200c16:	555d                	li	a0,-9
ffffffffc0200c18:	4a1020ef          	jal	ffffffffc02038b8 <do_exit>
            if (current->need_resched) {
ffffffffc0200c1c:	601c                	ld	a5,0(s0)
ffffffffc0200c1e:	bf65                	j	ffffffffc0200bd6 <trap+0x40>

ffffffffc0200c20 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200c20:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200c24:	00011463          	bnez	sp,ffffffffc0200c2c <__alltraps+0xc>
ffffffffc0200c28:	14002173          	csrr	sp,sscratch
ffffffffc0200c2c:	712d                	add	sp,sp,-288
ffffffffc0200c2e:	e002                	sd	zero,0(sp)
ffffffffc0200c30:	e406                	sd	ra,8(sp)
ffffffffc0200c32:	ec0e                	sd	gp,24(sp)
ffffffffc0200c34:	f012                	sd	tp,32(sp)
ffffffffc0200c36:	f416                	sd	t0,40(sp)
ffffffffc0200c38:	f81a                	sd	t1,48(sp)
ffffffffc0200c3a:	fc1e                	sd	t2,56(sp)
ffffffffc0200c3c:	e0a2                	sd	s0,64(sp)
ffffffffc0200c3e:	e4a6                	sd	s1,72(sp)
ffffffffc0200c40:	e8aa                	sd	a0,80(sp)
ffffffffc0200c42:	ecae                	sd	a1,88(sp)
ffffffffc0200c44:	f0b2                	sd	a2,96(sp)
ffffffffc0200c46:	f4b6                	sd	a3,104(sp)
ffffffffc0200c48:	f8ba                	sd	a4,112(sp)
ffffffffc0200c4a:	fcbe                	sd	a5,120(sp)
ffffffffc0200c4c:	e142                	sd	a6,128(sp)
ffffffffc0200c4e:	e546                	sd	a7,136(sp)
ffffffffc0200c50:	e94a                	sd	s2,144(sp)
ffffffffc0200c52:	ed4e                	sd	s3,152(sp)
ffffffffc0200c54:	f152                	sd	s4,160(sp)
ffffffffc0200c56:	f556                	sd	s5,168(sp)
ffffffffc0200c58:	f95a                	sd	s6,176(sp)
ffffffffc0200c5a:	fd5e                	sd	s7,184(sp)
ffffffffc0200c5c:	e1e2                	sd	s8,192(sp)
ffffffffc0200c5e:	e5e6                	sd	s9,200(sp)
ffffffffc0200c60:	e9ea                	sd	s10,208(sp)
ffffffffc0200c62:	edee                	sd	s11,216(sp)
ffffffffc0200c64:	f1f2                	sd	t3,224(sp)
ffffffffc0200c66:	f5f6                	sd	t4,232(sp)
ffffffffc0200c68:	f9fa                	sd	t5,240(sp)
ffffffffc0200c6a:	fdfe                	sd	t6,248(sp)
ffffffffc0200c6c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c70:	100024f3          	csrr	s1,sstatus
ffffffffc0200c74:	14102973          	csrr	s2,sepc
ffffffffc0200c78:	143029f3          	csrr	s3,stval
ffffffffc0200c7c:	14202a73          	csrr	s4,scause
ffffffffc0200c80:	e822                	sd	s0,16(sp)
ffffffffc0200c82:	e226                	sd	s1,256(sp)
ffffffffc0200c84:	e64a                	sd	s2,264(sp)
ffffffffc0200c86:	ea4e                	sd	s3,272(sp)
ffffffffc0200c88:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200c8a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200c8c:	f0bff0ef          	jal	ffffffffc0200b96 <trap>

ffffffffc0200c90 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200c90:	6492                	ld	s1,256(sp)
ffffffffc0200c92:	6932                	ld	s2,264(sp)
ffffffffc0200c94:	1004f413          	and	s0,s1,256
ffffffffc0200c98:	e401                	bnez	s0,ffffffffc0200ca0 <__trapret+0x10>
ffffffffc0200c9a:	1200                	add	s0,sp,288
ffffffffc0200c9c:	14041073          	csrw	sscratch,s0
ffffffffc0200ca0:	10049073          	csrw	sstatus,s1
ffffffffc0200ca4:	14191073          	csrw	sepc,s2
ffffffffc0200ca8:	60a2                	ld	ra,8(sp)
ffffffffc0200caa:	61e2                	ld	gp,24(sp)
ffffffffc0200cac:	7202                	ld	tp,32(sp)
ffffffffc0200cae:	72a2                	ld	t0,40(sp)
ffffffffc0200cb0:	7342                	ld	t1,48(sp)
ffffffffc0200cb2:	73e2                	ld	t2,56(sp)
ffffffffc0200cb4:	6406                	ld	s0,64(sp)
ffffffffc0200cb6:	64a6                	ld	s1,72(sp)
ffffffffc0200cb8:	6546                	ld	a0,80(sp)
ffffffffc0200cba:	65e6                	ld	a1,88(sp)
ffffffffc0200cbc:	7606                	ld	a2,96(sp)
ffffffffc0200cbe:	76a6                	ld	a3,104(sp)
ffffffffc0200cc0:	7746                	ld	a4,112(sp)
ffffffffc0200cc2:	77e6                	ld	a5,120(sp)
ffffffffc0200cc4:	680a                	ld	a6,128(sp)
ffffffffc0200cc6:	68aa                	ld	a7,136(sp)
ffffffffc0200cc8:	694a                	ld	s2,144(sp)
ffffffffc0200cca:	69ea                	ld	s3,152(sp)
ffffffffc0200ccc:	7a0a                	ld	s4,160(sp)
ffffffffc0200cce:	7aaa                	ld	s5,168(sp)
ffffffffc0200cd0:	7b4a                	ld	s6,176(sp)
ffffffffc0200cd2:	7bea                	ld	s7,184(sp)
ffffffffc0200cd4:	6c0e                	ld	s8,192(sp)
ffffffffc0200cd6:	6cae                	ld	s9,200(sp)
ffffffffc0200cd8:	6d4e                	ld	s10,208(sp)
ffffffffc0200cda:	6dee                	ld	s11,216(sp)
ffffffffc0200cdc:	7e0e                	ld	t3,224(sp)
ffffffffc0200cde:	7eae                	ld	t4,232(sp)
ffffffffc0200ce0:	7f4e                	ld	t5,240(sp)
ffffffffc0200ce2:	7fee                	ld	t6,248(sp)
ffffffffc0200ce4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200ce6:	10200073          	sret

ffffffffc0200cea <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200cea:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200cec:	b755                	j	ffffffffc0200c90 <__trapret>

ffffffffc0200cee <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200cee:	00050797          	auipc	a5,0x50
ffffffffc0200cf2:	d0a78793          	add	a5,a5,-758 # ffffffffc02509f8 <free_area>
ffffffffc0200cf6:	e79c                	sd	a5,8(a5)
ffffffffc0200cf8:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200cfa:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200cfe:	8082                	ret

ffffffffc0200d00 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200d00:	00050517          	auipc	a0,0x50
ffffffffc0200d04:	d0856503          	lwu	a0,-760(a0) # ffffffffc0250a08 <free_area+0x10>
ffffffffc0200d08:	8082                	ret

ffffffffc0200d0a <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200d0a:	715d                	add	sp,sp,-80
ffffffffc0200d0c:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200d0e:	00050417          	auipc	s0,0x50
ffffffffc0200d12:	cea40413          	add	s0,s0,-790 # ffffffffc02509f8 <free_area>
ffffffffc0200d16:	641c                	ld	a5,8(s0)
ffffffffc0200d18:	e486                	sd	ra,72(sp)
ffffffffc0200d1a:	fc26                	sd	s1,56(sp)
ffffffffc0200d1c:	f84a                	sd	s2,48(sp)
ffffffffc0200d1e:	f44e                	sd	s3,40(sp)
ffffffffc0200d20:	f052                	sd	s4,32(sp)
ffffffffc0200d22:	ec56                	sd	s5,24(sp)
ffffffffc0200d24:	e85a                	sd	s6,16(sp)
ffffffffc0200d26:	e45e                	sd	s7,8(sp)
ffffffffc0200d28:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d2a:	2a878d63          	beq	a5,s0,ffffffffc0200fe4 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200d2e:	4481                	li	s1,0
ffffffffc0200d30:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200d32:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200d36:	8b09                	and	a4,a4,2
ffffffffc0200d38:	2a070a63          	beqz	a4,ffffffffc0200fec <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0200d3c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d40:	679c                	ld	a5,8(a5)
ffffffffc0200d42:	2905                	addw	s2,s2,1
ffffffffc0200d44:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d46:	fe8796e3          	bne	a5,s0,ffffffffc0200d32 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200d4a:	89a6                	mv	s3,s1
ffffffffc0200d4c:	6eb000ef          	jal	ffffffffc0201c36 <nr_free_pages>
ffffffffc0200d50:	6f351e63          	bne	a0,s3,ffffffffc020144c <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d54:	4505                	li	a0,1
ffffffffc0200d56:	611000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200d5a:	8aaa                	mv	s5,a0
ffffffffc0200d5c:	42050863          	beqz	a0,ffffffffc020118c <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d60:	4505                	li	a0,1
ffffffffc0200d62:	605000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200d66:	89aa                	mv	s3,a0
ffffffffc0200d68:	70050263          	beqz	a0,ffffffffc020146c <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d6c:	4505                	li	a0,1
ffffffffc0200d6e:	5f9000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200d72:	8a2a                	mv	s4,a0
ffffffffc0200d74:	48050c63          	beqz	a0,ffffffffc020120c <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200d78:	293a8a63          	beq	s5,s3,ffffffffc020100c <default_check+0x302>
ffffffffc0200d7c:	28aa8863          	beq	s5,a0,ffffffffc020100c <default_check+0x302>
ffffffffc0200d80:	28a98663          	beq	s3,a0,ffffffffc020100c <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200d84:	000aa783          	lw	a5,0(s5)
ffffffffc0200d88:	2a079263          	bnez	a5,ffffffffc020102c <default_check+0x322>
ffffffffc0200d8c:	0009a783          	lw	a5,0(s3)
ffffffffc0200d90:	28079e63          	bnez	a5,ffffffffc020102c <default_check+0x322>
ffffffffc0200d94:	411c                	lw	a5,0(a0)
ffffffffc0200d96:	28079b63          	bnez	a5,ffffffffc020102c <default_check+0x322>
extern size_t npage;
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page) {
    return page - pages + nbase;
ffffffffc0200d9a:	00054797          	auipc	a5,0x54
ffffffffc0200d9e:	d067b783          	ld	a5,-762(a5) # ffffffffc0254aa0 <pages>
ffffffffc0200da2:	40fa8733          	sub	a4,s5,a5
ffffffffc0200da6:	00006617          	auipc	a2,0x6
ffffffffc0200daa:	5f263603          	ld	a2,1522(a2) # ffffffffc0207398 <nbase>
ffffffffc0200dae:	8719                	sra	a4,a4,0x6
ffffffffc0200db0:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200db2:	00054697          	auipc	a3,0x54
ffffffffc0200db6:	ce66b683          	ld	a3,-794(a3) # ffffffffc0254a98 <npage>
ffffffffc0200dba:	06b2                	sll	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200dbc:	0732                	sll	a4,a4,0xc
ffffffffc0200dbe:	28d77763          	bgeu	a4,a3,ffffffffc020104c <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200dc2:	40f98733          	sub	a4,s3,a5
ffffffffc0200dc6:	8719                	sra	a4,a4,0x6
ffffffffc0200dc8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200dca:	0732                	sll	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200dcc:	4cd77063          	bgeu	a4,a3,ffffffffc020128c <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200dd0:	40f507b3          	sub	a5,a0,a5
ffffffffc0200dd4:	8799                	sra	a5,a5,0x6
ffffffffc0200dd6:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200dd8:	07b2                	sll	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200dda:	30d7f963          	bgeu	a5,a3,ffffffffc02010ec <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200dde:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200de0:	00043c03          	ld	s8,0(s0)
ffffffffc0200de4:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200de8:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200dec:	e400                	sd	s0,8(s0)
ffffffffc0200dee:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200df0:	00050797          	auipc	a5,0x50
ffffffffc0200df4:	c007ac23          	sw	zero,-1000(a5) # ffffffffc0250a08 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200df8:	56f000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200dfc:	2c051863          	bnez	a0,ffffffffc02010cc <default_check+0x3c2>
    free_page(p0);
ffffffffc0200e00:	4585                	li	a1,1
ffffffffc0200e02:	8556                	mv	a0,s5
ffffffffc0200e04:	5f3000ef          	jal	ffffffffc0201bf6 <free_pages>
    free_page(p1);
ffffffffc0200e08:	4585                	li	a1,1
ffffffffc0200e0a:	854e                	mv	a0,s3
ffffffffc0200e0c:	5eb000ef          	jal	ffffffffc0201bf6 <free_pages>
    free_page(p2);
ffffffffc0200e10:	4585                	li	a1,1
ffffffffc0200e12:	8552                	mv	a0,s4
ffffffffc0200e14:	5e3000ef          	jal	ffffffffc0201bf6 <free_pages>
    assert(nr_free == 3);
ffffffffc0200e18:	4818                	lw	a4,16(s0)
ffffffffc0200e1a:	478d                	li	a5,3
ffffffffc0200e1c:	28f71863          	bne	a4,a5,ffffffffc02010ac <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e20:	4505                	li	a0,1
ffffffffc0200e22:	545000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200e26:	89aa                	mv	s3,a0
ffffffffc0200e28:	26050263          	beqz	a0,ffffffffc020108c <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e2c:	4505                	li	a0,1
ffffffffc0200e2e:	539000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200e32:	8aaa                	mv	s5,a0
ffffffffc0200e34:	3a050c63          	beqz	a0,ffffffffc02011ec <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e38:	4505                	li	a0,1
ffffffffc0200e3a:	52d000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200e3e:	8a2a                	mv	s4,a0
ffffffffc0200e40:	38050663          	beqz	a0,ffffffffc02011cc <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200e44:	4505                	li	a0,1
ffffffffc0200e46:	521000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200e4a:	36051163          	bnez	a0,ffffffffc02011ac <default_check+0x4a2>
    free_page(p0);
ffffffffc0200e4e:	4585                	li	a1,1
ffffffffc0200e50:	854e                	mv	a0,s3
ffffffffc0200e52:	5a5000ef          	jal	ffffffffc0201bf6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200e56:	641c                	ld	a5,8(s0)
ffffffffc0200e58:	20878a63          	beq	a5,s0,ffffffffc020106c <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0200e5c:	4505                	li	a0,1
ffffffffc0200e5e:	509000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200e62:	30a99563          	bne	s3,a0,ffffffffc020116c <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0200e66:	4505                	li	a0,1
ffffffffc0200e68:	4ff000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200e6c:	2e051063          	bnez	a0,ffffffffc020114c <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0200e70:	481c                	lw	a5,16(s0)
ffffffffc0200e72:	2a079d63          	bnez	a5,ffffffffc020112c <default_check+0x422>
    free_page(p);
ffffffffc0200e76:	854e                	mv	a0,s3
ffffffffc0200e78:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200e7a:	01843023          	sd	s8,0(s0)
ffffffffc0200e7e:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200e82:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200e86:	571000ef          	jal	ffffffffc0201bf6 <free_pages>
    free_page(p1);
ffffffffc0200e8a:	4585                	li	a1,1
ffffffffc0200e8c:	8556                	mv	a0,s5
ffffffffc0200e8e:	569000ef          	jal	ffffffffc0201bf6 <free_pages>
    free_page(p2);
ffffffffc0200e92:	4585                	li	a1,1
ffffffffc0200e94:	8552                	mv	a0,s4
ffffffffc0200e96:	561000ef          	jal	ffffffffc0201bf6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200e9a:	4515                	li	a0,5
ffffffffc0200e9c:	4cb000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200ea0:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200ea2:	26050563          	beqz	a0,ffffffffc020110c <default_check+0x402>
ffffffffc0200ea6:	651c                	ld	a5,8(a0)
ffffffffc0200ea8:	8385                	srl	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200eaa:	8b85                	and	a5,a5,1
ffffffffc0200eac:	54079063          	bnez	a5,ffffffffc02013ec <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200eb0:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200eb2:	00043b03          	ld	s6,0(s0)
ffffffffc0200eb6:	00843a83          	ld	s5,8(s0)
ffffffffc0200eba:	e000                	sd	s0,0(s0)
ffffffffc0200ebc:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200ebe:	4a9000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200ec2:	50051563          	bnez	a0,ffffffffc02013cc <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200ec6:	08098a13          	add	s4,s3,128
ffffffffc0200eca:	8552                	mv	a0,s4
ffffffffc0200ecc:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200ece:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200ed2:	00050797          	auipc	a5,0x50
ffffffffc0200ed6:	b207ab23          	sw	zero,-1226(a5) # ffffffffc0250a08 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200eda:	51d000ef          	jal	ffffffffc0201bf6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200ede:	4511                	li	a0,4
ffffffffc0200ee0:	487000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200ee4:	4c051463          	bnez	a0,ffffffffc02013ac <default_check+0x6a2>
ffffffffc0200ee8:	0889b783          	ld	a5,136(s3)
ffffffffc0200eec:	8385                	srl	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200eee:	8b85                	and	a5,a5,1
ffffffffc0200ef0:	48078e63          	beqz	a5,ffffffffc020138c <default_check+0x682>
ffffffffc0200ef4:	0909a703          	lw	a4,144(s3)
ffffffffc0200ef8:	478d                	li	a5,3
ffffffffc0200efa:	48f71963          	bne	a4,a5,ffffffffc020138c <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200efe:	450d                	li	a0,3
ffffffffc0200f00:	467000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200f04:	8c2a                	mv	s8,a0
ffffffffc0200f06:	46050363          	beqz	a0,ffffffffc020136c <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0200f0a:	4505                	li	a0,1
ffffffffc0200f0c:	45b000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200f10:	42051e63          	bnez	a0,ffffffffc020134c <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0200f14:	418a1c63          	bne	s4,s8,ffffffffc020132c <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0200f18:	4585                	li	a1,1
ffffffffc0200f1a:	854e                	mv	a0,s3
ffffffffc0200f1c:	4db000ef          	jal	ffffffffc0201bf6 <free_pages>
    free_pages(p1, 3);
ffffffffc0200f20:	458d                	li	a1,3
ffffffffc0200f22:	8552                	mv	a0,s4
ffffffffc0200f24:	4d3000ef          	jal	ffffffffc0201bf6 <free_pages>
ffffffffc0200f28:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0200f2c:	04098c13          	add	s8,s3,64
ffffffffc0200f30:	8385                	srl	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0200f32:	8b85                	and	a5,a5,1
ffffffffc0200f34:	3c078c63          	beqz	a5,ffffffffc020130c <default_check+0x602>
ffffffffc0200f38:	0109a703          	lw	a4,16(s3)
ffffffffc0200f3c:	4785                	li	a5,1
ffffffffc0200f3e:	3cf71763          	bne	a4,a5,ffffffffc020130c <default_check+0x602>
ffffffffc0200f42:	008a3783          	ld	a5,8(s4)
ffffffffc0200f46:	8385                	srl	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0200f48:	8b85                	and	a5,a5,1
ffffffffc0200f4a:	3a078163          	beqz	a5,ffffffffc02012ec <default_check+0x5e2>
ffffffffc0200f4e:	010a2703          	lw	a4,16(s4)
ffffffffc0200f52:	478d                	li	a5,3
ffffffffc0200f54:	38f71c63          	bne	a4,a5,ffffffffc02012ec <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0200f58:	4505                	li	a0,1
ffffffffc0200f5a:	40d000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200f5e:	36a99763          	bne	s3,a0,ffffffffc02012cc <default_check+0x5c2>
    free_page(p0);
ffffffffc0200f62:	4585                	li	a1,1
ffffffffc0200f64:	493000ef          	jal	ffffffffc0201bf6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0200f68:	4509                	li	a0,2
ffffffffc0200f6a:	3fd000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200f6e:	32aa1f63          	bne	s4,a0,ffffffffc02012ac <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0200f72:	4589                	li	a1,2
ffffffffc0200f74:	483000ef          	jal	ffffffffc0201bf6 <free_pages>
    free_page(p2);
ffffffffc0200f78:	4585                	li	a1,1
ffffffffc0200f7a:	8562                	mv	a0,s8
ffffffffc0200f7c:	47b000ef          	jal	ffffffffc0201bf6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200f80:	4515                	li	a0,5
ffffffffc0200f82:	3e5000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200f86:	89aa                	mv	s3,a0
ffffffffc0200f88:	48050263          	beqz	a0,ffffffffc020140c <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0200f8c:	4505                	li	a0,1
ffffffffc0200f8e:	3d9000ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0200f92:	2c051d63          	bnez	a0,ffffffffc020126c <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0200f96:	481c                	lw	a5,16(s0)
ffffffffc0200f98:	2a079a63          	bnez	a5,ffffffffc020124c <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200f9c:	4595                	li	a1,5
ffffffffc0200f9e:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200fa0:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0200fa4:	01643023          	sd	s6,0(s0)
ffffffffc0200fa8:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0200fac:	44b000ef          	jal	ffffffffc0201bf6 <free_pages>
    return listelm->next;
ffffffffc0200fb0:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fb2:	00878963          	beq	a5,s0,ffffffffc0200fc4 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200fb6:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200fba:	679c                	ld	a5,8(a5)
ffffffffc0200fbc:	397d                	addw	s2,s2,-1
ffffffffc0200fbe:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fc0:	fe879be3          	bne	a5,s0,ffffffffc0200fb6 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0200fc4:	26091463          	bnez	s2,ffffffffc020122c <default_check+0x522>
    assert(total == 0);
ffffffffc0200fc8:	46049263          	bnez	s1,ffffffffc020142c <default_check+0x722>
}
ffffffffc0200fcc:	60a6                	ld	ra,72(sp)
ffffffffc0200fce:	6406                	ld	s0,64(sp)
ffffffffc0200fd0:	74e2                	ld	s1,56(sp)
ffffffffc0200fd2:	7942                	ld	s2,48(sp)
ffffffffc0200fd4:	79a2                	ld	s3,40(sp)
ffffffffc0200fd6:	7a02                	ld	s4,32(sp)
ffffffffc0200fd8:	6ae2                	ld	s5,24(sp)
ffffffffc0200fda:	6b42                	ld	s6,16(sp)
ffffffffc0200fdc:	6ba2                	ld	s7,8(sp)
ffffffffc0200fde:	6c02                	ld	s8,0(sp)
ffffffffc0200fe0:	6161                	add	sp,sp,80
ffffffffc0200fe2:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fe4:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200fe6:	4481                	li	s1,0
ffffffffc0200fe8:	4901                	li	s2,0
ffffffffc0200fea:	b38d                	j	ffffffffc0200d4c <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0200fec:	00004697          	auipc	a3,0x4
ffffffffc0200ff0:	7cc68693          	add	a3,a3,1996 # ffffffffc02057b8 <commands+0x720>
ffffffffc0200ff4:	00004617          	auipc	a2,0x4
ffffffffc0200ff8:	4d460613          	add	a2,a2,1236 # ffffffffc02054c8 <commands+0x430>
ffffffffc0200ffc:	0f000593          	li	a1,240
ffffffffc0201000:	00004517          	auipc	a0,0x4
ffffffffc0201004:	7c850513          	add	a0,a0,1992 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201008:	c62ff0ef          	jal	ffffffffc020046a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020100c:	00005697          	auipc	a3,0x5
ffffffffc0201010:	85468693          	add	a3,a3,-1964 # ffffffffc0205860 <commands+0x7c8>
ffffffffc0201014:	00004617          	auipc	a2,0x4
ffffffffc0201018:	4b460613          	add	a2,a2,1204 # ffffffffc02054c8 <commands+0x430>
ffffffffc020101c:	0bd00593          	li	a1,189
ffffffffc0201020:	00004517          	auipc	a0,0x4
ffffffffc0201024:	7a850513          	add	a0,a0,1960 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201028:	c42ff0ef          	jal	ffffffffc020046a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020102c:	00005697          	auipc	a3,0x5
ffffffffc0201030:	85c68693          	add	a3,a3,-1956 # ffffffffc0205888 <commands+0x7f0>
ffffffffc0201034:	00004617          	auipc	a2,0x4
ffffffffc0201038:	49460613          	add	a2,a2,1172 # ffffffffc02054c8 <commands+0x430>
ffffffffc020103c:	0be00593          	li	a1,190
ffffffffc0201040:	00004517          	auipc	a0,0x4
ffffffffc0201044:	78850513          	add	a0,a0,1928 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201048:	c22ff0ef          	jal	ffffffffc020046a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020104c:	00005697          	auipc	a3,0x5
ffffffffc0201050:	87c68693          	add	a3,a3,-1924 # ffffffffc02058c8 <commands+0x830>
ffffffffc0201054:	00004617          	auipc	a2,0x4
ffffffffc0201058:	47460613          	add	a2,a2,1140 # ffffffffc02054c8 <commands+0x430>
ffffffffc020105c:	0c000593          	li	a1,192
ffffffffc0201060:	00004517          	auipc	a0,0x4
ffffffffc0201064:	76850513          	add	a0,a0,1896 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201068:	c02ff0ef          	jal	ffffffffc020046a <__panic>
    assert(!list_empty(&free_list));
ffffffffc020106c:	00005697          	auipc	a3,0x5
ffffffffc0201070:	8e468693          	add	a3,a3,-1820 # ffffffffc0205950 <commands+0x8b8>
ffffffffc0201074:	00004617          	auipc	a2,0x4
ffffffffc0201078:	45460613          	add	a2,a2,1108 # ffffffffc02054c8 <commands+0x430>
ffffffffc020107c:	0d900593          	li	a1,217
ffffffffc0201080:	00004517          	auipc	a0,0x4
ffffffffc0201084:	74850513          	add	a0,a0,1864 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201088:	be2ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020108c:	00004697          	auipc	a3,0x4
ffffffffc0201090:	77468693          	add	a3,a3,1908 # ffffffffc0205800 <commands+0x768>
ffffffffc0201094:	00004617          	auipc	a2,0x4
ffffffffc0201098:	43460613          	add	a2,a2,1076 # ffffffffc02054c8 <commands+0x430>
ffffffffc020109c:	0d200593          	li	a1,210
ffffffffc02010a0:	00004517          	auipc	a0,0x4
ffffffffc02010a4:	72850513          	add	a0,a0,1832 # ffffffffc02057c8 <commands+0x730>
ffffffffc02010a8:	bc2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(nr_free == 3);
ffffffffc02010ac:	00005697          	auipc	a3,0x5
ffffffffc02010b0:	89468693          	add	a3,a3,-1900 # ffffffffc0205940 <commands+0x8a8>
ffffffffc02010b4:	00004617          	auipc	a2,0x4
ffffffffc02010b8:	41460613          	add	a2,a2,1044 # ffffffffc02054c8 <commands+0x430>
ffffffffc02010bc:	0d000593          	li	a1,208
ffffffffc02010c0:	00004517          	auipc	a0,0x4
ffffffffc02010c4:	70850513          	add	a0,a0,1800 # ffffffffc02057c8 <commands+0x730>
ffffffffc02010c8:	ba2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010cc:	00005697          	auipc	a3,0x5
ffffffffc02010d0:	85c68693          	add	a3,a3,-1956 # ffffffffc0205928 <commands+0x890>
ffffffffc02010d4:	00004617          	auipc	a2,0x4
ffffffffc02010d8:	3f460613          	add	a2,a2,1012 # ffffffffc02054c8 <commands+0x430>
ffffffffc02010dc:	0cb00593          	li	a1,203
ffffffffc02010e0:	00004517          	auipc	a0,0x4
ffffffffc02010e4:	6e850513          	add	a0,a0,1768 # ffffffffc02057c8 <commands+0x730>
ffffffffc02010e8:	b82ff0ef          	jal	ffffffffc020046a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010ec:	00005697          	auipc	a3,0x5
ffffffffc02010f0:	81c68693          	add	a3,a3,-2020 # ffffffffc0205908 <commands+0x870>
ffffffffc02010f4:	00004617          	auipc	a2,0x4
ffffffffc02010f8:	3d460613          	add	a2,a2,980 # ffffffffc02054c8 <commands+0x430>
ffffffffc02010fc:	0c200593          	li	a1,194
ffffffffc0201100:	00004517          	auipc	a0,0x4
ffffffffc0201104:	6c850513          	add	a0,a0,1736 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201108:	b62ff0ef          	jal	ffffffffc020046a <__panic>
    assert(p0 != NULL);
ffffffffc020110c:	00005697          	auipc	a3,0x5
ffffffffc0201110:	88c68693          	add	a3,a3,-1908 # ffffffffc0205998 <commands+0x900>
ffffffffc0201114:	00004617          	auipc	a2,0x4
ffffffffc0201118:	3b460613          	add	a2,a2,948 # ffffffffc02054c8 <commands+0x430>
ffffffffc020111c:	0f800593          	li	a1,248
ffffffffc0201120:	00004517          	auipc	a0,0x4
ffffffffc0201124:	6a850513          	add	a0,a0,1704 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201128:	b42ff0ef          	jal	ffffffffc020046a <__panic>
    assert(nr_free == 0);
ffffffffc020112c:	00005697          	auipc	a3,0x5
ffffffffc0201130:	85c68693          	add	a3,a3,-1956 # ffffffffc0205988 <commands+0x8f0>
ffffffffc0201134:	00004617          	auipc	a2,0x4
ffffffffc0201138:	39460613          	add	a2,a2,916 # ffffffffc02054c8 <commands+0x430>
ffffffffc020113c:	0df00593          	li	a1,223
ffffffffc0201140:	00004517          	auipc	a0,0x4
ffffffffc0201144:	68850513          	add	a0,a0,1672 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201148:	b22ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020114c:	00004697          	auipc	a3,0x4
ffffffffc0201150:	7dc68693          	add	a3,a3,2012 # ffffffffc0205928 <commands+0x890>
ffffffffc0201154:	00004617          	auipc	a2,0x4
ffffffffc0201158:	37460613          	add	a2,a2,884 # ffffffffc02054c8 <commands+0x430>
ffffffffc020115c:	0dd00593          	li	a1,221
ffffffffc0201160:	00004517          	auipc	a0,0x4
ffffffffc0201164:	66850513          	add	a0,a0,1640 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201168:	b02ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020116c:	00004697          	auipc	a3,0x4
ffffffffc0201170:	7fc68693          	add	a3,a3,2044 # ffffffffc0205968 <commands+0x8d0>
ffffffffc0201174:	00004617          	auipc	a2,0x4
ffffffffc0201178:	35460613          	add	a2,a2,852 # ffffffffc02054c8 <commands+0x430>
ffffffffc020117c:	0dc00593          	li	a1,220
ffffffffc0201180:	00004517          	auipc	a0,0x4
ffffffffc0201184:	64850513          	add	a0,a0,1608 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201188:	ae2ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020118c:	00004697          	auipc	a3,0x4
ffffffffc0201190:	67468693          	add	a3,a3,1652 # ffffffffc0205800 <commands+0x768>
ffffffffc0201194:	00004617          	auipc	a2,0x4
ffffffffc0201198:	33460613          	add	a2,a2,820 # ffffffffc02054c8 <commands+0x430>
ffffffffc020119c:	0b900593          	li	a1,185
ffffffffc02011a0:	00004517          	auipc	a0,0x4
ffffffffc02011a4:	62850513          	add	a0,a0,1576 # ffffffffc02057c8 <commands+0x730>
ffffffffc02011a8:	ac2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011ac:	00004697          	auipc	a3,0x4
ffffffffc02011b0:	77c68693          	add	a3,a3,1916 # ffffffffc0205928 <commands+0x890>
ffffffffc02011b4:	00004617          	auipc	a2,0x4
ffffffffc02011b8:	31460613          	add	a2,a2,788 # ffffffffc02054c8 <commands+0x430>
ffffffffc02011bc:	0d600593          	li	a1,214
ffffffffc02011c0:	00004517          	auipc	a0,0x4
ffffffffc02011c4:	60850513          	add	a0,a0,1544 # ffffffffc02057c8 <commands+0x730>
ffffffffc02011c8:	aa2ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011cc:	00004697          	auipc	a3,0x4
ffffffffc02011d0:	67468693          	add	a3,a3,1652 # ffffffffc0205840 <commands+0x7a8>
ffffffffc02011d4:	00004617          	auipc	a2,0x4
ffffffffc02011d8:	2f460613          	add	a2,a2,756 # ffffffffc02054c8 <commands+0x430>
ffffffffc02011dc:	0d400593          	li	a1,212
ffffffffc02011e0:	00004517          	auipc	a0,0x4
ffffffffc02011e4:	5e850513          	add	a0,a0,1512 # ffffffffc02057c8 <commands+0x730>
ffffffffc02011e8:	a82ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02011ec:	00004697          	auipc	a3,0x4
ffffffffc02011f0:	63468693          	add	a3,a3,1588 # ffffffffc0205820 <commands+0x788>
ffffffffc02011f4:	00004617          	auipc	a2,0x4
ffffffffc02011f8:	2d460613          	add	a2,a2,724 # ffffffffc02054c8 <commands+0x430>
ffffffffc02011fc:	0d300593          	li	a1,211
ffffffffc0201200:	00004517          	auipc	a0,0x4
ffffffffc0201204:	5c850513          	add	a0,a0,1480 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201208:	a62ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020120c:	00004697          	auipc	a3,0x4
ffffffffc0201210:	63468693          	add	a3,a3,1588 # ffffffffc0205840 <commands+0x7a8>
ffffffffc0201214:	00004617          	auipc	a2,0x4
ffffffffc0201218:	2b460613          	add	a2,a2,692 # ffffffffc02054c8 <commands+0x430>
ffffffffc020121c:	0bb00593          	li	a1,187
ffffffffc0201220:	00004517          	auipc	a0,0x4
ffffffffc0201224:	5a850513          	add	a0,a0,1448 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201228:	a42ff0ef          	jal	ffffffffc020046a <__panic>
    assert(count == 0);
ffffffffc020122c:	00005697          	auipc	a3,0x5
ffffffffc0201230:	8bc68693          	add	a3,a3,-1860 # ffffffffc0205ae8 <commands+0xa50>
ffffffffc0201234:	00004617          	auipc	a2,0x4
ffffffffc0201238:	29460613          	add	a2,a2,660 # ffffffffc02054c8 <commands+0x430>
ffffffffc020123c:	12500593          	li	a1,293
ffffffffc0201240:	00004517          	auipc	a0,0x4
ffffffffc0201244:	58850513          	add	a0,a0,1416 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201248:	a22ff0ef          	jal	ffffffffc020046a <__panic>
    assert(nr_free == 0);
ffffffffc020124c:	00004697          	auipc	a3,0x4
ffffffffc0201250:	73c68693          	add	a3,a3,1852 # ffffffffc0205988 <commands+0x8f0>
ffffffffc0201254:	00004617          	auipc	a2,0x4
ffffffffc0201258:	27460613          	add	a2,a2,628 # ffffffffc02054c8 <commands+0x430>
ffffffffc020125c:	11a00593          	li	a1,282
ffffffffc0201260:	00004517          	auipc	a0,0x4
ffffffffc0201264:	56850513          	add	a0,a0,1384 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201268:	a02ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020126c:	00004697          	auipc	a3,0x4
ffffffffc0201270:	6bc68693          	add	a3,a3,1724 # ffffffffc0205928 <commands+0x890>
ffffffffc0201274:	00004617          	auipc	a2,0x4
ffffffffc0201278:	25460613          	add	a2,a2,596 # ffffffffc02054c8 <commands+0x430>
ffffffffc020127c:	11800593          	li	a1,280
ffffffffc0201280:	00004517          	auipc	a0,0x4
ffffffffc0201284:	54850513          	add	a0,a0,1352 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201288:	9e2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020128c:	00004697          	auipc	a3,0x4
ffffffffc0201290:	65c68693          	add	a3,a3,1628 # ffffffffc02058e8 <commands+0x850>
ffffffffc0201294:	00004617          	auipc	a2,0x4
ffffffffc0201298:	23460613          	add	a2,a2,564 # ffffffffc02054c8 <commands+0x430>
ffffffffc020129c:	0c100593          	li	a1,193
ffffffffc02012a0:	00004517          	auipc	a0,0x4
ffffffffc02012a4:	52850513          	add	a0,a0,1320 # ffffffffc02057c8 <commands+0x730>
ffffffffc02012a8:	9c2ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012ac:	00004697          	auipc	a3,0x4
ffffffffc02012b0:	7fc68693          	add	a3,a3,2044 # ffffffffc0205aa8 <commands+0xa10>
ffffffffc02012b4:	00004617          	auipc	a2,0x4
ffffffffc02012b8:	21460613          	add	a2,a2,532 # ffffffffc02054c8 <commands+0x430>
ffffffffc02012bc:	11200593          	li	a1,274
ffffffffc02012c0:	00004517          	auipc	a0,0x4
ffffffffc02012c4:	50850513          	add	a0,a0,1288 # ffffffffc02057c8 <commands+0x730>
ffffffffc02012c8:	9a2ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02012cc:	00004697          	auipc	a3,0x4
ffffffffc02012d0:	7bc68693          	add	a3,a3,1980 # ffffffffc0205a88 <commands+0x9f0>
ffffffffc02012d4:	00004617          	auipc	a2,0x4
ffffffffc02012d8:	1f460613          	add	a2,a2,500 # ffffffffc02054c8 <commands+0x430>
ffffffffc02012dc:	11000593          	li	a1,272
ffffffffc02012e0:	00004517          	auipc	a0,0x4
ffffffffc02012e4:	4e850513          	add	a0,a0,1256 # ffffffffc02057c8 <commands+0x730>
ffffffffc02012e8:	982ff0ef          	jal	ffffffffc020046a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02012ec:	00004697          	auipc	a3,0x4
ffffffffc02012f0:	77468693          	add	a3,a3,1908 # ffffffffc0205a60 <commands+0x9c8>
ffffffffc02012f4:	00004617          	auipc	a2,0x4
ffffffffc02012f8:	1d460613          	add	a2,a2,468 # ffffffffc02054c8 <commands+0x430>
ffffffffc02012fc:	10e00593          	li	a1,270
ffffffffc0201300:	00004517          	auipc	a0,0x4
ffffffffc0201304:	4c850513          	add	a0,a0,1224 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201308:	962ff0ef          	jal	ffffffffc020046a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020130c:	00004697          	auipc	a3,0x4
ffffffffc0201310:	72c68693          	add	a3,a3,1836 # ffffffffc0205a38 <commands+0x9a0>
ffffffffc0201314:	00004617          	auipc	a2,0x4
ffffffffc0201318:	1b460613          	add	a2,a2,436 # ffffffffc02054c8 <commands+0x430>
ffffffffc020131c:	10d00593          	li	a1,269
ffffffffc0201320:	00004517          	auipc	a0,0x4
ffffffffc0201324:	4a850513          	add	a0,a0,1192 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201328:	942ff0ef          	jal	ffffffffc020046a <__panic>
    assert(p0 + 2 == p1);
ffffffffc020132c:	00004697          	auipc	a3,0x4
ffffffffc0201330:	6fc68693          	add	a3,a3,1788 # ffffffffc0205a28 <commands+0x990>
ffffffffc0201334:	00004617          	auipc	a2,0x4
ffffffffc0201338:	19460613          	add	a2,a2,404 # ffffffffc02054c8 <commands+0x430>
ffffffffc020133c:	10800593          	li	a1,264
ffffffffc0201340:	00004517          	auipc	a0,0x4
ffffffffc0201344:	48850513          	add	a0,a0,1160 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201348:	922ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_page() == NULL);
ffffffffc020134c:	00004697          	auipc	a3,0x4
ffffffffc0201350:	5dc68693          	add	a3,a3,1500 # ffffffffc0205928 <commands+0x890>
ffffffffc0201354:	00004617          	auipc	a2,0x4
ffffffffc0201358:	17460613          	add	a2,a2,372 # ffffffffc02054c8 <commands+0x430>
ffffffffc020135c:	10700593          	li	a1,263
ffffffffc0201360:	00004517          	auipc	a0,0x4
ffffffffc0201364:	46850513          	add	a0,a0,1128 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201368:	902ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020136c:	00004697          	auipc	a3,0x4
ffffffffc0201370:	69c68693          	add	a3,a3,1692 # ffffffffc0205a08 <commands+0x970>
ffffffffc0201374:	00004617          	auipc	a2,0x4
ffffffffc0201378:	15460613          	add	a2,a2,340 # ffffffffc02054c8 <commands+0x430>
ffffffffc020137c:	10600593          	li	a1,262
ffffffffc0201380:	00004517          	auipc	a0,0x4
ffffffffc0201384:	44850513          	add	a0,a0,1096 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201388:	8e2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020138c:	00004697          	auipc	a3,0x4
ffffffffc0201390:	64c68693          	add	a3,a3,1612 # ffffffffc02059d8 <commands+0x940>
ffffffffc0201394:	00004617          	auipc	a2,0x4
ffffffffc0201398:	13460613          	add	a2,a2,308 # ffffffffc02054c8 <commands+0x430>
ffffffffc020139c:	10500593          	li	a1,261
ffffffffc02013a0:	00004517          	auipc	a0,0x4
ffffffffc02013a4:	42850513          	add	a0,a0,1064 # ffffffffc02057c8 <commands+0x730>
ffffffffc02013a8:	8c2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02013ac:	00004697          	auipc	a3,0x4
ffffffffc02013b0:	61468693          	add	a3,a3,1556 # ffffffffc02059c0 <commands+0x928>
ffffffffc02013b4:	00004617          	auipc	a2,0x4
ffffffffc02013b8:	11460613          	add	a2,a2,276 # ffffffffc02054c8 <commands+0x430>
ffffffffc02013bc:	10400593          	li	a1,260
ffffffffc02013c0:	00004517          	auipc	a0,0x4
ffffffffc02013c4:	40850513          	add	a0,a0,1032 # ffffffffc02057c8 <commands+0x730>
ffffffffc02013c8:	8a2ff0ef          	jal	ffffffffc020046a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013cc:	00004697          	auipc	a3,0x4
ffffffffc02013d0:	55c68693          	add	a3,a3,1372 # ffffffffc0205928 <commands+0x890>
ffffffffc02013d4:	00004617          	auipc	a2,0x4
ffffffffc02013d8:	0f460613          	add	a2,a2,244 # ffffffffc02054c8 <commands+0x430>
ffffffffc02013dc:	0fe00593          	li	a1,254
ffffffffc02013e0:	00004517          	auipc	a0,0x4
ffffffffc02013e4:	3e850513          	add	a0,a0,1000 # ffffffffc02057c8 <commands+0x730>
ffffffffc02013e8:	882ff0ef          	jal	ffffffffc020046a <__panic>
    assert(!PageProperty(p0));
ffffffffc02013ec:	00004697          	auipc	a3,0x4
ffffffffc02013f0:	5bc68693          	add	a3,a3,1468 # ffffffffc02059a8 <commands+0x910>
ffffffffc02013f4:	00004617          	auipc	a2,0x4
ffffffffc02013f8:	0d460613          	add	a2,a2,212 # ffffffffc02054c8 <commands+0x430>
ffffffffc02013fc:	0f900593          	li	a1,249
ffffffffc0201400:	00004517          	auipc	a0,0x4
ffffffffc0201404:	3c850513          	add	a0,a0,968 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201408:	862ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020140c:	00004697          	auipc	a3,0x4
ffffffffc0201410:	6bc68693          	add	a3,a3,1724 # ffffffffc0205ac8 <commands+0xa30>
ffffffffc0201414:	00004617          	auipc	a2,0x4
ffffffffc0201418:	0b460613          	add	a2,a2,180 # ffffffffc02054c8 <commands+0x430>
ffffffffc020141c:	11700593          	li	a1,279
ffffffffc0201420:	00004517          	auipc	a0,0x4
ffffffffc0201424:	3a850513          	add	a0,a0,936 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201428:	842ff0ef          	jal	ffffffffc020046a <__panic>
    assert(total == 0);
ffffffffc020142c:	00004697          	auipc	a3,0x4
ffffffffc0201430:	6cc68693          	add	a3,a3,1740 # ffffffffc0205af8 <commands+0xa60>
ffffffffc0201434:	00004617          	auipc	a2,0x4
ffffffffc0201438:	09460613          	add	a2,a2,148 # ffffffffc02054c8 <commands+0x430>
ffffffffc020143c:	12600593          	li	a1,294
ffffffffc0201440:	00004517          	auipc	a0,0x4
ffffffffc0201444:	38850513          	add	a0,a0,904 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201448:	822ff0ef          	jal	ffffffffc020046a <__panic>
    assert(total == nr_free_pages());
ffffffffc020144c:	00004697          	auipc	a3,0x4
ffffffffc0201450:	39468693          	add	a3,a3,916 # ffffffffc02057e0 <commands+0x748>
ffffffffc0201454:	00004617          	auipc	a2,0x4
ffffffffc0201458:	07460613          	add	a2,a2,116 # ffffffffc02054c8 <commands+0x430>
ffffffffc020145c:	0f300593          	li	a1,243
ffffffffc0201460:	00004517          	auipc	a0,0x4
ffffffffc0201464:	36850513          	add	a0,a0,872 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201468:	802ff0ef          	jal	ffffffffc020046a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020146c:	00004697          	auipc	a3,0x4
ffffffffc0201470:	3b468693          	add	a3,a3,948 # ffffffffc0205820 <commands+0x788>
ffffffffc0201474:	00004617          	auipc	a2,0x4
ffffffffc0201478:	05460613          	add	a2,a2,84 # ffffffffc02054c8 <commands+0x430>
ffffffffc020147c:	0ba00593          	li	a1,186
ffffffffc0201480:	00004517          	auipc	a0,0x4
ffffffffc0201484:	34850513          	add	a0,a0,840 # ffffffffc02057c8 <commands+0x730>
ffffffffc0201488:	fe3fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc020148c <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc020148c:	1141                	add	sp,sp,-16
ffffffffc020148e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201490:	14058463          	beqz	a1,ffffffffc02015d8 <default_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0201494:	00659713          	sll	a4,a1,0x6
ffffffffc0201498:	00e506b3          	add	a3,a0,a4
ffffffffc020149c:	87aa                	mv	a5,a0
ffffffffc020149e:	c30d                	beqz	a4,ffffffffc02014c0 <default_free_pages+0x34>
ffffffffc02014a0:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02014a2:	8b05                	and	a4,a4,1
ffffffffc02014a4:	10071a63          	bnez	a4,ffffffffc02015b8 <default_free_pages+0x12c>
ffffffffc02014a8:	6798                	ld	a4,8(a5)
ffffffffc02014aa:	8b09                	and	a4,a4,2
ffffffffc02014ac:	10071663          	bnez	a4,ffffffffc02015b8 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc02014b0:	0007b423          	sd	zero,8(a5)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc02014b4:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02014b8:	04078793          	add	a5,a5,64
ffffffffc02014bc:	fed792e3          	bne	a5,a3,ffffffffc02014a0 <default_free_pages+0x14>
    base->property = n;
ffffffffc02014c0:	2581                	sext.w	a1,a1
ffffffffc02014c2:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02014c4:	00850893          	add	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02014c8:	4789                	li	a5,2
ffffffffc02014ca:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02014ce:	0004f697          	auipc	a3,0x4f
ffffffffc02014d2:	52a68693          	add	a3,a3,1322 # ffffffffc02509f8 <free_area>
ffffffffc02014d6:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02014d8:	669c                	ld	a5,8(a3)
ffffffffc02014da:	9f2d                	addw	a4,a4,a1
ffffffffc02014dc:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02014de:	0ad78163          	beq	a5,a3,ffffffffc0201580 <default_free_pages+0xf4>
            struct Page* page = le2page(le, page_link);
ffffffffc02014e2:	fe878713          	add	a4,a5,-24
ffffffffc02014e6:	4581                	li	a1,0
ffffffffc02014e8:	01850613          	add	a2,a0,24
            if (base < page) {
ffffffffc02014ec:	00e56a63          	bltu	a0,a4,ffffffffc0201500 <default_free_pages+0x74>
    return listelm->next;
ffffffffc02014f0:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02014f2:	04d70c63          	beq	a4,a3,ffffffffc020154a <default_free_pages+0xbe>
    for (; p != base + n; p ++) {
ffffffffc02014f6:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02014f8:	fe878713          	add	a4,a5,-24
            if (base < page) {
ffffffffc02014fc:	fee57ae3          	bgeu	a0,a4,ffffffffc02014f0 <default_free_pages+0x64>
ffffffffc0201500:	c199                	beqz	a1,ffffffffc0201506 <default_free_pages+0x7a>
ffffffffc0201502:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201506:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201508:	e390                	sd	a2,0(a5)
ffffffffc020150a:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020150c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020150e:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201510:	00d70d63          	beq	a4,a3,ffffffffc020152a <default_free_pages+0x9e>
        if (p + p->property == base) {
ffffffffc0201514:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201518:	fe870613          	add	a2,a4,-24
        if (p + p->property == base) {
ffffffffc020151c:	02059813          	sll	a6,a1,0x20
ffffffffc0201520:	01a85793          	srl	a5,a6,0x1a
ffffffffc0201524:	97b2                	add	a5,a5,a2
ffffffffc0201526:	02f50c63          	beq	a0,a5,ffffffffc020155e <default_free_pages+0xd2>
    return listelm->next;
ffffffffc020152a:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc020152c:	00d78c63          	beq	a5,a3,ffffffffc0201544 <default_free_pages+0xb8>
        if (base + base->property == p) {
ffffffffc0201530:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201532:	fe878693          	add	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0201536:	02061593          	sll	a1,a2,0x20
ffffffffc020153a:	01a5d713          	srl	a4,a1,0x1a
ffffffffc020153e:	972a                	add	a4,a4,a0
ffffffffc0201540:	04e68c63          	beq	a3,a4,ffffffffc0201598 <default_free_pages+0x10c>
}
ffffffffc0201544:	60a2                	ld	ra,8(sp)
ffffffffc0201546:	0141                	add	sp,sp,16
ffffffffc0201548:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020154a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020154c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020154e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201550:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201552:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201554:	02d70f63          	beq	a4,a3,ffffffffc0201592 <default_free_pages+0x106>
ffffffffc0201558:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020155a:	87ba                	mv	a5,a4
ffffffffc020155c:	bf71                	j	ffffffffc02014f8 <default_free_pages+0x6c>
            p->property += base->property;
ffffffffc020155e:	491c                	lw	a5,16(a0)
ffffffffc0201560:	9fad                	addw	a5,a5,a1
ffffffffc0201562:	fef72c23          	sw	a5,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201566:	57f5                	li	a5,-3
ffffffffc0201568:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020156c:	01853803          	ld	a6,24(a0)
ffffffffc0201570:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201572:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201574:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201578:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020157a:	0105b023          	sd	a6,0(a1)
ffffffffc020157e:	b77d                	j	ffffffffc020152c <default_free_pages+0xa0>
}
ffffffffc0201580:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201582:	01850713          	add	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201586:	e398                	sd	a4,0(a5)
ffffffffc0201588:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020158a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020158c:	ed1c                	sd	a5,24(a0)
}
ffffffffc020158e:	0141                	add	sp,sp,16
ffffffffc0201590:	8082                	ret
ffffffffc0201592:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0201594:	873e                	mv	a4,a5
ffffffffc0201596:	bfad                	j	ffffffffc0201510 <default_free_pages+0x84>
            base->property += p->property;
ffffffffc0201598:	ff87a703          	lw	a4,-8(a5)
ffffffffc020159c:	ff078693          	add	a3,a5,-16
ffffffffc02015a0:	9f31                	addw	a4,a4,a2
ffffffffc02015a2:	c918                	sw	a4,16(a0)
ffffffffc02015a4:	5775                	li	a4,-3
ffffffffc02015a6:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02015aa:	6398                	ld	a4,0(a5)
ffffffffc02015ac:	679c                	ld	a5,8(a5)
}
ffffffffc02015ae:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02015b0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02015b2:	e398                	sd	a4,0(a5)
ffffffffc02015b4:	0141                	add	sp,sp,16
ffffffffc02015b6:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02015b8:	00004697          	auipc	a3,0x4
ffffffffc02015bc:	55868693          	add	a3,a3,1368 # ffffffffc0205b10 <commands+0xa78>
ffffffffc02015c0:	00004617          	auipc	a2,0x4
ffffffffc02015c4:	f0860613          	add	a2,a2,-248 # ffffffffc02054c8 <commands+0x430>
ffffffffc02015c8:	08300593          	li	a1,131
ffffffffc02015cc:	00004517          	auipc	a0,0x4
ffffffffc02015d0:	1fc50513          	add	a0,a0,508 # ffffffffc02057c8 <commands+0x730>
ffffffffc02015d4:	e97fe0ef          	jal	ffffffffc020046a <__panic>
    assert(n > 0);
ffffffffc02015d8:	00004697          	auipc	a3,0x4
ffffffffc02015dc:	53068693          	add	a3,a3,1328 # ffffffffc0205b08 <commands+0xa70>
ffffffffc02015e0:	00004617          	auipc	a2,0x4
ffffffffc02015e4:	ee860613          	add	a2,a2,-280 # ffffffffc02054c8 <commands+0x430>
ffffffffc02015e8:	08000593          	li	a1,128
ffffffffc02015ec:	00004517          	auipc	a0,0x4
ffffffffc02015f0:	1dc50513          	add	a0,a0,476 # ffffffffc02057c8 <commands+0x730>
ffffffffc02015f4:	e77fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02015f8 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02015f8:	c949                	beqz	a0,ffffffffc020168a <default_alloc_pages+0x92>
    if (n > nr_free) {
ffffffffc02015fa:	0004f617          	auipc	a2,0x4f
ffffffffc02015fe:	3fe60613          	add	a2,a2,1022 # ffffffffc02509f8 <free_area>
ffffffffc0201602:	4a0c                	lw	a1,16(a2)
ffffffffc0201604:	872a                	mv	a4,a0
ffffffffc0201606:	02059793          	sll	a5,a1,0x20
ffffffffc020160a:	9381                	srl	a5,a5,0x20
ffffffffc020160c:	00a7eb63          	bltu	a5,a0,ffffffffc0201622 <default_alloc_pages+0x2a>
    list_entry_t *le = &free_list;
ffffffffc0201610:	87b2                	mv	a5,a2
ffffffffc0201612:	a029                	j	ffffffffc020161c <default_alloc_pages+0x24>
        if (p->property >= n) {
ffffffffc0201614:	ff87e683          	lwu	a3,-8(a5)
ffffffffc0201618:	00e6f763          	bgeu	a3,a4,ffffffffc0201626 <default_alloc_pages+0x2e>
    return listelm->next;
ffffffffc020161c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc020161e:	fec79be3          	bne	a5,a2,ffffffffc0201614 <default_alloc_pages+0x1c>
        return NULL;
ffffffffc0201622:	4501                	li	a0,0
}
ffffffffc0201624:	8082                	ret
    __list_del(listelm->prev, listelm->next);
ffffffffc0201626:	0087b883          	ld	a7,8(a5)
        if (page->property > n) {
ffffffffc020162a:	ff87a803          	lw	a6,-8(a5)
    return listelm->prev;
ffffffffc020162e:	6394                	ld	a3,0(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201630:	fe878513          	add	a0,a5,-24
        if (page->property > n) {
ffffffffc0201634:	02081313          	sll	t1,a6,0x20
    prev->next = next;
ffffffffc0201638:	0116b423          	sd	a7,8(a3)
    next->prev = prev;
ffffffffc020163c:	00d8b023          	sd	a3,0(a7)
ffffffffc0201640:	02035313          	srl	t1,t1,0x20
            p->property = page->property - n;
ffffffffc0201644:	0007089b          	sext.w	a7,a4
        if (page->property > n) {
ffffffffc0201648:	02677963          	bgeu	a4,t1,ffffffffc020167a <default_alloc_pages+0x82>
            struct Page *p = page + n;
ffffffffc020164c:	071a                	sll	a4,a4,0x6
ffffffffc020164e:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0201650:	4118083b          	subw	a6,a6,a7
ffffffffc0201654:	01072823          	sw	a6,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201658:	4589                	li	a1,2
ffffffffc020165a:	00870813          	add	a6,a4,8
ffffffffc020165e:	40b8302f          	amoor.d	zero,a1,(a6)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201662:	0086b803          	ld	a6,8(a3)
            list_add(prev, &(p->page_link));
ffffffffc0201666:	01870313          	add	t1,a4,24
        nr_free -= n;
ffffffffc020166a:	4a0c                	lw	a1,16(a2)
    prev->next = next->prev = elm;
ffffffffc020166c:	00683023          	sd	t1,0(a6)
ffffffffc0201670:	0066b423          	sd	t1,8(a3)
    elm->next = next;
ffffffffc0201674:	03073023          	sd	a6,32(a4)
    elm->prev = prev;
ffffffffc0201678:	ef14                	sd	a3,24(a4)
ffffffffc020167a:	411585bb          	subw	a1,a1,a7
ffffffffc020167e:	ca0c                	sw	a1,16(a2)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201680:	5775                	li	a4,-3
ffffffffc0201682:	17c1                	add	a5,a5,-16
ffffffffc0201684:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201688:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020168a:	1141                	add	sp,sp,-16
    assert(n > 0);
ffffffffc020168c:	00004697          	auipc	a3,0x4
ffffffffc0201690:	47c68693          	add	a3,a3,1148 # ffffffffc0205b08 <commands+0xa70>
ffffffffc0201694:	00004617          	auipc	a2,0x4
ffffffffc0201698:	e3460613          	add	a2,a2,-460 # ffffffffc02054c8 <commands+0x430>
ffffffffc020169c:	06200593          	li	a1,98
ffffffffc02016a0:	00004517          	auipc	a0,0x4
ffffffffc02016a4:	12850513          	add	a0,a0,296 # ffffffffc02057c8 <commands+0x730>
default_alloc_pages(size_t n) {
ffffffffc02016a8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016aa:	dc1fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02016ae <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc02016ae:	1141                	add	sp,sp,-16
ffffffffc02016b0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016b2:	c5f1                	beqz	a1,ffffffffc020177e <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc02016b4:	00659713          	sll	a4,a1,0x6
ffffffffc02016b8:	00e506b3          	add	a3,a0,a4
ffffffffc02016bc:	87aa                	mv	a5,a0
ffffffffc02016be:	cf11                	beqz	a4,ffffffffc02016da <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02016c0:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02016c2:	8b05                	and	a4,a4,1
ffffffffc02016c4:	cf49                	beqz	a4,ffffffffc020175e <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02016c6:	0007a823          	sw	zero,16(a5)
ffffffffc02016ca:	0007b423          	sd	zero,8(a5)
ffffffffc02016ce:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02016d2:	04078793          	add	a5,a5,64
ffffffffc02016d6:	fed795e3          	bne	a5,a3,ffffffffc02016c0 <default_init_memmap+0x12>
    base->property = n;
ffffffffc02016da:	2581                	sext.w	a1,a1
ffffffffc02016dc:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016de:	4789                	li	a5,2
ffffffffc02016e0:	00850713          	add	a4,a0,8
ffffffffc02016e4:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02016e8:	0004f697          	auipc	a3,0x4f
ffffffffc02016ec:	31068693          	add	a3,a3,784 # ffffffffc02509f8 <free_area>
ffffffffc02016f0:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02016f2:	669c                	ld	a5,8(a3)
ffffffffc02016f4:	9f2d                	addw	a4,a4,a1
ffffffffc02016f6:	ca98                	sw	a4,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02016f8:	04d78663          	beq	a5,a3,ffffffffc0201744 <default_init_memmap+0x96>
            struct Page* page = le2page(le, page_link);
ffffffffc02016fc:	fe878713          	add	a4,a5,-24
ffffffffc0201700:	4581                	li	a1,0
ffffffffc0201702:	01850613          	add	a2,a0,24
            if (base < page) {
ffffffffc0201706:	00e56a63          	bltu	a0,a4,ffffffffc020171a <default_init_memmap+0x6c>
    return listelm->next;
ffffffffc020170a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020170c:	02d70263          	beq	a4,a3,ffffffffc0201730 <default_init_memmap+0x82>
    for (; p != base + n; p ++) {
ffffffffc0201710:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201712:	fe878713          	add	a4,a5,-24
            if (base < page) {
ffffffffc0201716:	fee57ae3          	bgeu	a0,a4,ffffffffc020170a <default_init_memmap+0x5c>
ffffffffc020171a:	c199                	beqz	a1,ffffffffc0201720 <default_init_memmap+0x72>
ffffffffc020171c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201720:	6398                	ld	a4,0(a5)
}
ffffffffc0201722:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201724:	e390                	sd	a2,0(a5)
ffffffffc0201726:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201728:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020172a:	ed18                	sd	a4,24(a0)
ffffffffc020172c:	0141                	add	sp,sp,16
ffffffffc020172e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201730:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201732:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201734:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201736:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0201738:	8832                	mv	a6,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc020173a:	00d70e63          	beq	a4,a3,ffffffffc0201756 <default_init_memmap+0xa8>
ffffffffc020173e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201740:	87ba                	mv	a5,a4
ffffffffc0201742:	bfc1                	j	ffffffffc0201712 <default_init_memmap+0x64>
}
ffffffffc0201744:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201746:	01850713          	add	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc020174a:	e398                	sd	a4,0(a5)
ffffffffc020174c:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020174e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201750:	ed1c                	sd	a5,24(a0)
}
ffffffffc0201752:	0141                	add	sp,sp,16
ffffffffc0201754:	8082                	ret
ffffffffc0201756:	60a2                	ld	ra,8(sp)
ffffffffc0201758:	e290                	sd	a2,0(a3)
ffffffffc020175a:	0141                	add	sp,sp,16
ffffffffc020175c:	8082                	ret
        assert(PageReserved(p));
ffffffffc020175e:	00004697          	auipc	a3,0x4
ffffffffc0201762:	3da68693          	add	a3,a3,986 # ffffffffc0205b38 <commands+0xaa0>
ffffffffc0201766:	00004617          	auipc	a2,0x4
ffffffffc020176a:	d6260613          	add	a2,a2,-670 # ffffffffc02054c8 <commands+0x430>
ffffffffc020176e:	04900593          	li	a1,73
ffffffffc0201772:	00004517          	auipc	a0,0x4
ffffffffc0201776:	05650513          	add	a0,a0,86 # ffffffffc02057c8 <commands+0x730>
ffffffffc020177a:	cf1fe0ef          	jal	ffffffffc020046a <__panic>
    assert(n > 0);
ffffffffc020177e:	00004697          	auipc	a3,0x4
ffffffffc0201782:	38a68693          	add	a3,a3,906 # ffffffffc0205b08 <commands+0xa70>
ffffffffc0201786:	00004617          	auipc	a2,0x4
ffffffffc020178a:	d4260613          	add	a2,a2,-702 # ffffffffc02054c8 <commands+0x430>
ffffffffc020178e:	04600593          	li	a1,70
ffffffffc0201792:	00004517          	auipc	a0,0x4
ffffffffc0201796:	03650513          	add	a0,a0,54 # ffffffffc02057c8 <commands+0x730>
ffffffffc020179a:	cd1fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc020179e <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc020179e:	c955                	beqz	a0,ffffffffc0201852 <slob_free+0xb4>
{
ffffffffc02017a0:	1141                	add	sp,sp,-16
ffffffffc02017a2:	e022                	sd	s0,0(sp)
ffffffffc02017a4:	e406                	sd	ra,8(sp)
ffffffffc02017a6:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc02017a8:	e9c9                	bnez	a1,ffffffffc020183a <slob_free+0x9c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017aa:	100027f3          	csrr	a5,sstatus
ffffffffc02017ae:	8b89                	and	a5,a5,2
    return 0;
ffffffffc02017b0:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02017b2:	efc1                	bnez	a5,ffffffffc020184a <slob_free+0xac>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02017b4:	00048617          	auipc	a2,0x48
ffffffffc02017b8:	e3460613          	add	a2,a2,-460 # ffffffffc02495e8 <slobfree>
ffffffffc02017bc:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02017be:	873e                	mv	a4,a5
ffffffffc02017c0:	679c                	ld	a5,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02017c2:	02877a63          	bgeu	a4,s0,ffffffffc02017f6 <slob_free+0x58>
ffffffffc02017c6:	00f46463          	bltu	s0,a5,ffffffffc02017ce <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02017ca:	fef76ae3          	bltu	a4,a5,ffffffffc02017be <slob_free+0x20>
			break;

	if (b + b->units == cur->next) {
ffffffffc02017ce:	400c                	lw	a1,0(s0)
ffffffffc02017d0:	00459693          	sll	a3,a1,0x4
ffffffffc02017d4:	96a2                	add	a3,a3,s0
ffffffffc02017d6:	02d78a63          	beq	a5,a3,ffffffffc020180a <slob_free+0x6c>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc02017da:	430c                	lw	a1,0(a4)
ffffffffc02017dc:	e41c                	sd	a5,8(s0)
ffffffffc02017de:	00459693          	sll	a3,a1,0x4
ffffffffc02017e2:	96ba                	add	a3,a3,a4
ffffffffc02017e4:	02d40e63          	beq	s0,a3,ffffffffc0201820 <slob_free+0x82>
ffffffffc02017e8:	e700                	sd	s0,8(a4)
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;

	slobfree = cur;
ffffffffc02017ea:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc02017ec:	e131                	bnez	a0,ffffffffc0201830 <slob_free+0x92>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02017ee:	60a2                	ld	ra,8(sp)
ffffffffc02017f0:	6402                	ld	s0,0(sp)
ffffffffc02017f2:	0141                	add	sp,sp,16
ffffffffc02017f4:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02017f6:	fcf764e3          	bltu	a4,a5,ffffffffc02017be <slob_free+0x20>
ffffffffc02017fa:	fcf472e3          	bgeu	s0,a5,ffffffffc02017be <slob_free+0x20>
	if (b + b->units == cur->next) {
ffffffffc02017fe:	400c                	lw	a1,0(s0)
ffffffffc0201800:	00459693          	sll	a3,a1,0x4
ffffffffc0201804:	96a2                	add	a3,a3,s0
ffffffffc0201806:	fcd79ae3          	bne	a5,a3,ffffffffc02017da <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc020180a:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020180c:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc020180e:	9ead                	addw	a3,a3,a1
ffffffffc0201810:	c014                	sw	a3,0(s0)
	if (cur + cur->units == b) {
ffffffffc0201812:	430c                	lw	a1,0(a4)
ffffffffc0201814:	e41c                	sd	a5,8(s0)
ffffffffc0201816:	00459693          	sll	a3,a1,0x4
ffffffffc020181a:	96ba                	add	a3,a3,a4
ffffffffc020181c:	fcd416e3          	bne	s0,a3,ffffffffc02017e8 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201820:	4014                	lw	a3,0(s0)
		cur->next = b->next;
ffffffffc0201822:	843e                	mv	s0,a5
ffffffffc0201824:	e700                	sd	s0,8(a4)
		cur->units += b->units;
ffffffffc0201826:	00b687bb          	addw	a5,a3,a1
ffffffffc020182a:	c31c                	sw	a5,0(a4)
	slobfree = cur;
ffffffffc020182c:	e218                	sd	a4,0(a2)
ffffffffc020182e:	d161                	beqz	a0,ffffffffc02017ee <slob_free+0x50>
}
ffffffffc0201830:	6402                	ld	s0,0(sp)
ffffffffc0201832:	60a2                	ld	ra,8(sp)
ffffffffc0201834:	0141                	add	sp,sp,16
        intr_enable();
ffffffffc0201836:	dc1fe06f          	j	ffffffffc02005f6 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc020183a:	25bd                	addw	a1,a1,15
ffffffffc020183c:	8191                	srl	a1,a1,0x4
ffffffffc020183e:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201840:	100027f3          	csrr	a5,sstatus
ffffffffc0201844:	8b89                	and	a5,a5,2
    return 0;
ffffffffc0201846:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201848:	d7b5                	beqz	a5,ffffffffc02017b4 <slob_free+0x16>
        intr_disable();
ffffffffc020184a:	db3fe0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc020184e:	4505                	li	a0,1
ffffffffc0201850:	b795                	j	ffffffffc02017b4 <slob_free+0x16>
ffffffffc0201852:	8082                	ret

ffffffffc0201854 <__slob_get_free_pages.constprop.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc0201854:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201856:	1141                	add	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc0201858:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020185c:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc020185e:	308000ef          	jal	ffffffffc0201b66 <alloc_pages>
  if(!page)
ffffffffc0201862:	c91d                	beqz	a0,ffffffffc0201898 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201864:	00053797          	auipc	a5,0x53
ffffffffc0201868:	23c7b783          	ld	a5,572(a5) # ffffffffc0254aa0 <pages>
ffffffffc020186c:	8d1d                	sub	a0,a0,a5
ffffffffc020186e:	8519                	sra	a0,a0,0x6
ffffffffc0201870:	00006797          	auipc	a5,0x6
ffffffffc0201874:	b287b783          	ld	a5,-1240(a5) # ffffffffc0207398 <nbase>
ffffffffc0201878:	953e                	add	a0,a0,a5
    return KADDR(page2pa(page));
ffffffffc020187a:	00c51793          	sll	a5,a0,0xc
ffffffffc020187e:	83b1                	srl	a5,a5,0xc
ffffffffc0201880:	00053717          	auipc	a4,0x53
ffffffffc0201884:	21873703          	ld	a4,536(a4) # ffffffffc0254a98 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201888:	0532                	sll	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020188a:	00e7fa63          	bgeu	a5,a4,ffffffffc020189e <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc020188e:	00053797          	auipc	a5,0x53
ffffffffc0201892:	2027b783          	ld	a5,514(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc0201896:	953e                	add	a0,a0,a5
}
ffffffffc0201898:	60a2                	ld	ra,8(sp)
ffffffffc020189a:	0141                	add	sp,sp,16
ffffffffc020189c:	8082                	ret
ffffffffc020189e:	86aa                	mv	a3,a0
ffffffffc02018a0:	00004617          	auipc	a2,0x4
ffffffffc02018a4:	2f860613          	add	a2,a2,760 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc02018a8:	06900593          	li	a1,105
ffffffffc02018ac:	00004517          	auipc	a0,0x4
ffffffffc02018b0:	31450513          	add	a0,a0,788 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc02018b4:	bb7fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02018b8 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02018b8:	1101                	add	sp,sp,-32
ffffffffc02018ba:	ec06                	sd	ra,24(sp)
ffffffffc02018bc:	e822                	sd	s0,16(sp)
ffffffffc02018be:	e426                	sd	s1,8(sp)
ffffffffc02018c0:	e04a                	sd	s2,0(sp)
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02018c2:	01050713          	add	a4,a0,16
ffffffffc02018c6:	6785                	lui	a5,0x1
ffffffffc02018c8:	0cf77363          	bgeu	a4,a5,ffffffffc020198e <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02018cc:	00f50493          	add	s1,a0,15
ffffffffc02018d0:	8091                	srl	s1,s1,0x4
ffffffffc02018d2:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02018d4:	10002673          	csrr	a2,sstatus
ffffffffc02018d8:	8a09                	and	a2,a2,2
ffffffffc02018da:	e25d                	bnez	a2,ffffffffc0201980 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc02018dc:	00048917          	auipc	s2,0x48
ffffffffc02018e0:	d0c90913          	add	s2,s2,-756 # ffffffffc02495e8 <slobfree>
ffffffffc02018e4:	00093683          	ld	a3,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02018e8:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02018ea:	4398                	lw	a4,0(a5)
ffffffffc02018ec:	08975e63          	bge	a4,s1,ffffffffc0201988 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree) {
ffffffffc02018f0:	00f68b63          	beq	a3,a5,ffffffffc0201906 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02018f4:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02018f6:	4018                	lw	a4,0(s0)
ffffffffc02018f8:	02975a63          	bge	a4,s1,ffffffffc020192c <slob_alloc.constprop.0+0x74>
		if (cur == slobfree) {
ffffffffc02018fc:	00093683          	ld	a3,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201900:	87a2                	mv	a5,s0
		if (cur == slobfree) {
ffffffffc0201902:	fef699e3          	bne	a3,a5,ffffffffc02018f4 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc0201906:	ee31                	bnez	a2,ffffffffc0201962 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201908:	4501                	li	a0,0
ffffffffc020190a:	f4bff0ef          	jal	ffffffffc0201854 <__slob_get_free_pages.constprop.0>
ffffffffc020190e:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201910:	cd05                	beqz	a0,ffffffffc0201948 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201912:	6585                	lui	a1,0x1
ffffffffc0201914:	e8bff0ef          	jal	ffffffffc020179e <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201918:	10002673          	csrr	a2,sstatus
ffffffffc020191c:	8a09                	and	a2,a2,2
ffffffffc020191e:	ee05                	bnez	a2,ffffffffc0201956 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201920:	00093783          	ld	a5,0(s2)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201924:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0201926:	4018                	lw	a4,0(s0)
ffffffffc0201928:	fc974ae3          	blt	a4,s1,ffffffffc02018fc <slob_alloc.constprop.0+0x44>
			if (cur->units == units) /* exact fit? */
ffffffffc020192c:	04e48763          	beq	s1,a4,ffffffffc020197a <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201930:	00449693          	sll	a3,s1,0x4
ffffffffc0201934:	96a2                	add	a3,a3,s0
ffffffffc0201936:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201938:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc020193a:	9f05                	subw	a4,a4,s1
ffffffffc020193c:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc020193e:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201940:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201942:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc0201946:	e20d                	bnez	a2,ffffffffc0201968 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201948:	60e2                	ld	ra,24(sp)
ffffffffc020194a:	8522                	mv	a0,s0
ffffffffc020194c:	6442                	ld	s0,16(sp)
ffffffffc020194e:	64a2                	ld	s1,8(sp)
ffffffffc0201950:	6902                	ld	s2,0(sp)
ffffffffc0201952:	6105                	add	sp,sp,32
ffffffffc0201954:	8082                	ret
        intr_disable();
ffffffffc0201956:	ca7fe0ef          	jal	ffffffffc02005fc <intr_disable>
			cur = slobfree;
ffffffffc020195a:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc020195e:	4605                	li	a2,1
ffffffffc0201960:	b7d1                	j	ffffffffc0201924 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201962:	c95fe0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc0201966:	b74d                	j	ffffffffc0201908 <slob_alloc.constprop.0+0x50>
ffffffffc0201968:	c8ffe0ef          	jal	ffffffffc02005f6 <intr_enable>
}
ffffffffc020196c:	60e2                	ld	ra,24(sp)
ffffffffc020196e:	8522                	mv	a0,s0
ffffffffc0201970:	6442                	ld	s0,16(sp)
ffffffffc0201972:	64a2                	ld	s1,8(sp)
ffffffffc0201974:	6902                	ld	s2,0(sp)
ffffffffc0201976:	6105                	add	sp,sp,32
ffffffffc0201978:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc020197a:	6418                	ld	a4,8(s0)
ffffffffc020197c:	e798                	sd	a4,8(a5)
ffffffffc020197e:	b7d1                	j	ffffffffc0201942 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201980:	c7dfe0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc0201984:	4605                	li	a2,1
ffffffffc0201986:	bf99                	j	ffffffffc02018dc <slob_alloc.constprop.0+0x24>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0201988:	843e                	mv	s0,a5
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020198a:	87b6                	mv	a5,a3
ffffffffc020198c:	b745                	j	ffffffffc020192c <slob_alloc.constprop.0+0x74>
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc020198e:	00004697          	auipc	a3,0x4
ffffffffc0201992:	24268693          	add	a3,a3,578 # ffffffffc0205bd0 <default_pmm_manager+0x70>
ffffffffc0201996:	00004617          	auipc	a2,0x4
ffffffffc020199a:	b3260613          	add	a2,a2,-1230 # ffffffffc02054c8 <commands+0x430>
ffffffffc020199e:	06400593          	li	a1,100
ffffffffc02019a2:	00004517          	auipc	a0,0x4
ffffffffc02019a6:	24e50513          	add	a0,a0,590 # ffffffffc0205bf0 <default_pmm_manager+0x90>
ffffffffc02019aa:	ac1fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02019ae <kmalloc_init>:

inline void 
kmalloc_init(void) {
    slob_init();
    //cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc02019ae:	8082                	ret

ffffffffc02019b0 <kallocated>:
}

size_t
kallocated(void) {
   return slob_allocated();
}
ffffffffc02019b0:	4501                	li	a0,0
ffffffffc02019b2:	8082                	ret

ffffffffc02019b4 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc02019b4:	1101                	add	sp,sp,-32
ffffffffc02019b6:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02019b8:	6905                	lui	s2,0x1
{
ffffffffc02019ba:	e822                	sd	s0,16(sp)
ffffffffc02019bc:	ec06                	sd	ra,24(sp)
ffffffffc02019be:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02019c0:	fef90793          	add	a5,s2,-17 # fef <_binary_obj___user_ex1_out_size-0x8bd9>
{
ffffffffc02019c4:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02019c6:	04a7f763          	bgeu	a5,a0,ffffffffc0201a14 <kmalloc+0x60>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc02019ca:	4561                	li	a0,24
ffffffffc02019cc:	eedff0ef          	jal	ffffffffc02018b8 <slob_alloc.constprop.0>
ffffffffc02019d0:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc02019d2:	c539                	beqz	a0,ffffffffc0201a20 <kmalloc+0x6c>
	bb->order = find_order(size);
ffffffffc02019d4:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc02019d8:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc02019da:	00f95763          	bge	s2,a5,ffffffffc02019e8 <kmalloc+0x34>
ffffffffc02019de:	6705                	lui	a4,0x1
ffffffffc02019e0:	8785                	sra	a5,a5,0x1
		order++;
ffffffffc02019e2:	2505                	addw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc02019e4:	fef74ee3          	blt	a4,a5,ffffffffc02019e0 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc02019e8:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc02019ea:	e6bff0ef          	jal	ffffffffc0201854 <__slob_get_free_pages.constprop.0>
ffffffffc02019ee:	e488                	sd	a0,8(s1)
	if (bb->pages) {
ffffffffc02019f0:	cd21                	beqz	a0,ffffffffc0201a48 <kmalloc+0x94>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019f2:	100027f3          	csrr	a5,sstatus
ffffffffc02019f6:	8b89                	and	a5,a5,2
ffffffffc02019f8:	e795                	bnez	a5,ffffffffc0201a24 <kmalloc+0x70>
		bb->next = bigblocks;
ffffffffc02019fa:	00053797          	auipc	a5,0x53
ffffffffc02019fe:	07678793          	add	a5,a5,118 # ffffffffc0254a70 <bigblocks>
ffffffffc0201a02:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201a04:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201a06:	e898                	sd	a4,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc0201a08:	60e2                	ld	ra,24(sp)
ffffffffc0201a0a:	6442                	ld	s0,16(sp)
ffffffffc0201a0c:	64a2                	ld	s1,8(sp)
ffffffffc0201a0e:	6902                	ld	s2,0(sp)
ffffffffc0201a10:	6105                	add	sp,sp,32
ffffffffc0201a12:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201a14:	0541                	add	a0,a0,16
ffffffffc0201a16:	ea3ff0ef          	jal	ffffffffc02018b8 <slob_alloc.constprop.0>
ffffffffc0201a1a:	87aa                	mv	a5,a0
		return m ? (void *)(m + 1) : 0;
ffffffffc0201a1c:	0541                	add	a0,a0,16
ffffffffc0201a1e:	f7ed                	bnez	a5,ffffffffc0201a08 <kmalloc+0x54>
		return 0;
ffffffffc0201a20:	4501                	li	a0,0
  return __kmalloc(size, 0);
ffffffffc0201a22:	b7dd                	j	ffffffffc0201a08 <kmalloc+0x54>
        intr_disable();
ffffffffc0201a24:	bd9fe0ef          	jal	ffffffffc02005fc <intr_disable>
		bb->next = bigblocks;
ffffffffc0201a28:	00053797          	auipc	a5,0x53
ffffffffc0201a2c:	04878793          	add	a5,a5,72 # ffffffffc0254a70 <bigblocks>
ffffffffc0201a30:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201a32:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201a34:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201a36:	bc1fe0ef          	jal	ffffffffc02005f6 <intr_enable>
}
ffffffffc0201a3a:	60e2                	ld	ra,24(sp)
ffffffffc0201a3c:	6442                	ld	s0,16(sp)
		return bb->pages;
ffffffffc0201a3e:	6488                	ld	a0,8(s1)
}
ffffffffc0201a40:	6902                	ld	s2,0(sp)
ffffffffc0201a42:	64a2                	ld	s1,8(sp)
ffffffffc0201a44:	6105                	add	sp,sp,32
ffffffffc0201a46:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201a48:	8526                	mv	a0,s1
ffffffffc0201a4a:	45e1                	li	a1,24
ffffffffc0201a4c:	d53ff0ef          	jal	ffffffffc020179e <slob_free>
		return 0;
ffffffffc0201a50:	4501                	li	a0,0
ffffffffc0201a52:	bf5d                	j	ffffffffc0201a08 <kmalloc+0x54>

ffffffffc0201a54 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201a54:	c169                	beqz	a0,ffffffffc0201b16 <kfree+0xc2>
{
ffffffffc0201a56:	1101                	add	sp,sp,-32
ffffffffc0201a58:	e822                	sd	s0,16(sp)
ffffffffc0201a5a:	ec06                	sd	ra,24(sp)
ffffffffc0201a5c:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc0201a5e:	03451793          	sll	a5,a0,0x34
ffffffffc0201a62:	842a                	mv	s0,a0
ffffffffc0201a64:	e3d9                	bnez	a5,ffffffffc0201aea <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a66:	100027f3          	csrr	a5,sstatus
ffffffffc0201a6a:	8b89                	and	a5,a5,2
ffffffffc0201a6c:	e7d9                	bnez	a5,ffffffffc0201afa <kfree+0xa6>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201a6e:	00053797          	auipc	a5,0x53
ffffffffc0201a72:	0027b783          	ld	a5,2(a5) # ffffffffc0254a70 <bigblocks>
    return 0;
ffffffffc0201a76:	4601                	li	a2,0
ffffffffc0201a78:	cbad                	beqz	a5,ffffffffc0201aea <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201a7a:	00053697          	auipc	a3,0x53
ffffffffc0201a7e:	ff668693          	add	a3,a3,-10 # ffffffffc0254a70 <bigblocks>
ffffffffc0201a82:	a021                	j	ffffffffc0201a8a <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201a84:	01048693          	add	a3,s1,16
ffffffffc0201a88:	c3a5                	beqz	a5,ffffffffc0201ae8 <kfree+0x94>
			if (bb->pages == block) {
ffffffffc0201a8a:	6798                	ld	a4,8(a5)
ffffffffc0201a8c:	84be                	mv	s1,a5
				*last = bb->next;
ffffffffc0201a8e:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block) {
ffffffffc0201a90:	fe871ae3          	bne	a4,s0,ffffffffc0201a84 <kfree+0x30>
				*last = bb->next;
ffffffffc0201a94:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201a96:	ee2d                	bnez	a2,ffffffffc0201b10 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201a98:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201a9c:	4098                	lw	a4,0(s1)
ffffffffc0201a9e:	08f46963          	bltu	s0,a5,ffffffffc0201b30 <kfree+0xdc>
ffffffffc0201aa2:	00053797          	auipc	a5,0x53
ffffffffc0201aa6:	fee7b783          	ld	a5,-18(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc0201aaa:	8c1d                	sub	s0,s0,a5
    if (PPN(pa) >= npage) {
ffffffffc0201aac:	8031                	srl	s0,s0,0xc
ffffffffc0201aae:	00053797          	auipc	a5,0x53
ffffffffc0201ab2:	fea7b783          	ld	a5,-22(a5) # ffffffffc0254a98 <npage>
ffffffffc0201ab6:	06f47163          	bgeu	s0,a5,ffffffffc0201b18 <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201aba:	00006797          	auipc	a5,0x6
ffffffffc0201abe:	8de7b783          	ld	a5,-1826(a5) # ffffffffc0207398 <nbase>
ffffffffc0201ac2:	8c1d                	sub	s0,s0,a5
ffffffffc0201ac4:	041a                	sll	s0,s0,0x6
  free_pages(kva2page(kva), 1 << order);
ffffffffc0201ac6:	00053517          	auipc	a0,0x53
ffffffffc0201aca:	fda53503          	ld	a0,-38(a0) # ffffffffc0254aa0 <pages>
ffffffffc0201ace:	4585                	li	a1,1
ffffffffc0201ad0:	9522                	add	a0,a0,s0
ffffffffc0201ad2:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201ad6:	120000ef          	jal	ffffffffc0201bf6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201ada:	6442                	ld	s0,16(sp)
ffffffffc0201adc:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ade:	8526                	mv	a0,s1
}
ffffffffc0201ae0:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201ae2:	45e1                	li	a1,24
}
ffffffffc0201ae4:	6105                	add	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ae6:	b965                	j	ffffffffc020179e <slob_free>
ffffffffc0201ae8:	e20d                	bnez	a2,ffffffffc0201b0a <kfree+0xb6>
ffffffffc0201aea:	ff040513          	add	a0,s0,-16
}
ffffffffc0201aee:	6442                	ld	s0,16(sp)
ffffffffc0201af0:	60e2                	ld	ra,24(sp)
ffffffffc0201af2:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201af4:	4581                	li	a1,0
}
ffffffffc0201af6:	6105                	add	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201af8:	b15d                	j	ffffffffc020179e <slob_free>
        intr_disable();
ffffffffc0201afa:	b03fe0ef          	jal	ffffffffc02005fc <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0201afe:	00053797          	auipc	a5,0x53
ffffffffc0201b02:	f727b783          	ld	a5,-142(a5) # ffffffffc0254a70 <bigblocks>
        return 1;
ffffffffc0201b06:	4605                	li	a2,1
ffffffffc0201b08:	fbad                	bnez	a5,ffffffffc0201a7a <kfree+0x26>
        intr_enable();
ffffffffc0201b0a:	aedfe0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc0201b0e:	bff1                	j	ffffffffc0201aea <kfree+0x96>
ffffffffc0201b10:	ae7fe0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc0201b14:	b751                	j	ffffffffc0201a98 <kfree+0x44>
ffffffffc0201b16:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201b18:	00004617          	auipc	a2,0x4
ffffffffc0201b1c:	11860613          	add	a2,a2,280 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc0201b20:	06200593          	li	a1,98
ffffffffc0201b24:	00004517          	auipc	a0,0x4
ffffffffc0201b28:	09c50513          	add	a0,a0,156 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0201b2c:	93ffe0ef          	jal	ffffffffc020046a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201b30:	86a2                	mv	a3,s0
ffffffffc0201b32:	00004617          	auipc	a2,0x4
ffffffffc0201b36:	0d660613          	add	a2,a2,214 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0201b3a:	06e00593          	li	a1,110
ffffffffc0201b3e:	00004517          	auipc	a0,0x4
ffffffffc0201b42:	08250513          	add	a0,a0,130 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0201b46:	925fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0201b4a <pa2page.part.0>:
    local_intr_restore(intr_flag);
    return ret;
}

/* pmm_init - initialize the physical memory management */
static void page_init(void) {
ffffffffc0201b4a:	1141                	add	sp,sp,-16
    extern char kern_entry[];

ffffffffc0201b4c:	00004617          	auipc	a2,0x4
ffffffffc0201b50:	0e460613          	add	a2,a2,228 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc0201b54:	06200593          	li	a1,98
ffffffffc0201b58:	00004517          	auipc	a0,0x4
ffffffffc0201b5c:	06850513          	add	a0,a0,104 # ffffffffc0205bc0 <default_pmm_manager+0x60>
static void page_init(void) {
ffffffffc0201b60:	e406                	sd	ra,8(sp)

ffffffffc0201b62:	909fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0201b66 <alloc_pages>:
struct Page *alloc_pages(size_t n) {
ffffffffc0201b66:	7139                	add	sp,sp,-64
ffffffffc0201b68:	f426                	sd	s1,40(sp)
ffffffffc0201b6a:	f04a                	sd	s2,32(sp)
ffffffffc0201b6c:	ec4e                	sd	s3,24(sp)
ffffffffc0201b6e:	e852                	sd	s4,16(sp)
ffffffffc0201b70:	e456                	sd	s5,8(sp)
ffffffffc0201b72:	e05a                	sd	s6,0(sp)
ffffffffc0201b74:	fc06                	sd	ra,56(sp)
ffffffffc0201b76:	f822                	sd	s0,48(sp)
ffffffffc0201b78:	84aa                	mv	s1,a0
ffffffffc0201b7a:	00053917          	auipc	s2,0x53
ffffffffc0201b7e:	efe90913          	add	s2,s2,-258 # ffffffffc0254a78 <pmm_manager>
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201b82:	4a05                	li	s4,1
ffffffffc0201b84:	00053a97          	auipc	s5,0x53
ffffffffc0201b88:	f24a8a93          	add	s5,s5,-220 # ffffffffc0254aa8 <swap_init_ok>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201b8c:	0005099b          	sext.w	s3,a0
ffffffffc0201b90:	00053b17          	auipc	s6,0x53
ffffffffc0201b94:	f38b0b13          	add	s6,s6,-200 # ffffffffc0254ac8 <check_mm_struct>
ffffffffc0201b98:	a015                	j	ffffffffc0201bbc <alloc_pages+0x56>
            page = pmm_manager->alloc_pages(n);
ffffffffc0201b9a:	00093783          	ld	a5,0(s2)
ffffffffc0201b9e:	6f9c                	ld	a5,24(a5)
ffffffffc0201ba0:	9782                	jalr	a5
ffffffffc0201ba2:	842a                	mv	s0,a0
        swap_out(check_mm_struct, n, 0);
ffffffffc0201ba4:	4601                	li	a2,0
ffffffffc0201ba6:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201ba8:	ec05                	bnez	s0,ffffffffc0201be0 <alloc_pages+0x7a>
ffffffffc0201baa:	029a6b63          	bltu	s4,s1,ffffffffc0201be0 <alloc_pages+0x7a>
ffffffffc0201bae:	000aa783          	lw	a5,0(s5)
ffffffffc0201bb2:	c79d                	beqz	a5,ffffffffc0201be0 <alloc_pages+0x7a>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201bb4:	000b3503          	ld	a0,0(s6)
ffffffffc0201bb8:	2d3000ef          	jal	ffffffffc020268a <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201bbc:	100027f3          	csrr	a5,sstatus
ffffffffc0201bc0:	8b89                	and	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0201bc2:	8526                	mv	a0,s1
ffffffffc0201bc4:	dbf9                	beqz	a5,ffffffffc0201b9a <alloc_pages+0x34>
        intr_disable();
ffffffffc0201bc6:	a37fe0ef          	jal	ffffffffc02005fc <intr_disable>
ffffffffc0201bca:	00093783          	ld	a5,0(s2)
ffffffffc0201bce:	8526                	mv	a0,s1
ffffffffc0201bd0:	6f9c                	ld	a5,24(a5)
ffffffffc0201bd2:	9782                	jalr	a5
ffffffffc0201bd4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201bd6:	a21fe0ef          	jal	ffffffffc02005f6 <intr_enable>
        swap_out(check_mm_struct, n, 0);
ffffffffc0201bda:	4601                	li	a2,0
ffffffffc0201bdc:	85ce                	mv	a1,s3
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0201bde:	d471                	beqz	s0,ffffffffc0201baa <alloc_pages+0x44>
}
ffffffffc0201be0:	70e2                	ld	ra,56(sp)
ffffffffc0201be2:	8522                	mv	a0,s0
ffffffffc0201be4:	7442                	ld	s0,48(sp)
ffffffffc0201be6:	74a2                	ld	s1,40(sp)
ffffffffc0201be8:	7902                	ld	s2,32(sp)
ffffffffc0201bea:	69e2                	ld	s3,24(sp)
ffffffffc0201bec:	6a42                	ld	s4,16(sp)
ffffffffc0201bee:	6aa2                	ld	s5,8(sp)
ffffffffc0201bf0:	6b02                	ld	s6,0(sp)
ffffffffc0201bf2:	6121                	add	sp,sp,64
ffffffffc0201bf4:	8082                	ret

ffffffffc0201bf6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201bf6:	100027f3          	csrr	a5,sstatus
ffffffffc0201bfa:	8b89                	and	a5,a5,2
ffffffffc0201bfc:	e799                	bnez	a5,ffffffffc0201c0a <free_pages+0x14>
        pmm_manager->free_pages(base, n);
ffffffffc0201bfe:	00053797          	auipc	a5,0x53
ffffffffc0201c02:	e7a7b783          	ld	a5,-390(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc0201c06:	739c                	ld	a5,32(a5)
ffffffffc0201c08:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0201c0a:	1101                	add	sp,sp,-32
ffffffffc0201c0c:	ec06                	sd	ra,24(sp)
ffffffffc0201c0e:	e822                	sd	s0,16(sp)
ffffffffc0201c10:	e426                	sd	s1,8(sp)
ffffffffc0201c12:	842a                	mv	s0,a0
ffffffffc0201c14:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201c16:	9e7fe0ef          	jal	ffffffffc02005fc <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201c1a:	00053797          	auipc	a5,0x53
ffffffffc0201c1e:	e5e7b783          	ld	a5,-418(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc0201c22:	739c                	ld	a5,32(a5)
ffffffffc0201c24:	85a6                	mv	a1,s1
ffffffffc0201c26:	8522                	mv	a0,s0
ffffffffc0201c28:	9782                	jalr	a5
}
ffffffffc0201c2a:	6442                	ld	s0,16(sp)
ffffffffc0201c2c:	60e2                	ld	ra,24(sp)
ffffffffc0201c2e:	64a2                	ld	s1,8(sp)
ffffffffc0201c30:	6105                	add	sp,sp,32
        intr_enable();
ffffffffc0201c32:	9c5fe06f          	j	ffffffffc02005f6 <intr_enable>

ffffffffc0201c36 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c36:	100027f3          	csrr	a5,sstatus
ffffffffc0201c3a:	8b89                	and	a5,a5,2
ffffffffc0201c3c:	e799                	bnez	a5,ffffffffc0201c4a <nr_free_pages+0x14>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201c3e:	00053797          	auipc	a5,0x53
ffffffffc0201c42:	e3a7b783          	ld	a5,-454(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc0201c46:	779c                	ld	a5,40(a5)
ffffffffc0201c48:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201c4a:	1141                	add	sp,sp,-16
ffffffffc0201c4c:	e406                	sd	ra,8(sp)
ffffffffc0201c4e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201c50:	9adfe0ef          	jal	ffffffffc02005fc <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201c54:	00053797          	auipc	a5,0x53
ffffffffc0201c58:	e247b783          	ld	a5,-476(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc0201c5c:	779c                	ld	a5,40(a5)
ffffffffc0201c5e:	9782                	jalr	a5
ffffffffc0201c60:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201c62:	995fe0ef          	jal	ffffffffc02005f6 <intr_enable>
}
ffffffffc0201c66:	60a2                	ld	ra,8(sp)
ffffffffc0201c68:	8522                	mv	a0,s0
ffffffffc0201c6a:	6402                	ld	s0,0(sp)
ffffffffc0201c6c:	0141                	add	sp,sp,16
ffffffffc0201c6e:	8082                	ret

ffffffffc0201c70 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201c70:	00004797          	auipc	a5,0x4
ffffffffc0201c74:	ef078793          	add	a5,a5,-272 # ffffffffc0205b60 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201c78:	638c                	ld	a1,0(a5)
}

// pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup
// paging mechanism
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void pmm_init(void) {
ffffffffc0201c7a:	1101                	add	sp,sp,-32
ffffffffc0201c7c:	ec06                	sd	ra,24(sp)
ffffffffc0201c7e:	e822                	sd	s0,16(sp)
ffffffffc0201c80:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201c82:	00004517          	auipc	a0,0x4
ffffffffc0201c86:	ff650513          	add	a0,a0,-10 # ffffffffc0205c78 <default_pmm_manager+0x118>
    pmm_manager = &default_pmm_manager;
ffffffffc0201c8a:	00053497          	auipc	s1,0x53
ffffffffc0201c8e:	dee48493          	add	s1,s1,-530 # ffffffffc0254a78 <pmm_manager>
ffffffffc0201c92:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201c94:	ceefe0ef          	jal	ffffffffc0200182 <cprintf>
    pmm_manager->init();
ffffffffc0201c98:	609c                	ld	a5,0(s1)
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201c9a:	00053417          	auipc	s0,0x53
ffffffffc0201c9e:	df640413          	add	s0,s0,-522 # ffffffffc0254a90 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201ca2:	679c                	ld	a5,8(a5)
ffffffffc0201ca4:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201ca6:	57f5                	li	a5,-3
ffffffffc0201ca8:	07fa                	sll	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201caa:	00004517          	auipc	a0,0x4
ffffffffc0201cae:	fe650513          	add	a0,a0,-26 # ffffffffc0205c90 <default_pmm_manager+0x130>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201cb2:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc0201cb4:	ccefe0ef          	jal	ffffffffc0200182 <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201cb8:	44300693          	li	a3,1091
ffffffffc0201cbc:	06d6                	sll	a3,a3,0x15
ffffffffc0201cbe:	40100613          	li	a2,1025
ffffffffc0201cc2:	16fd                	add	a3,a3,-1
ffffffffc0201cc4:	0656                	sll	a2,a2,0x15
ffffffffc0201cc6:	088005b7          	lui	a1,0x8800
ffffffffc0201cca:	00004517          	auipc	a0,0x4
ffffffffc0201cce:	fde50513          	add	a0,a0,-34 # ffffffffc0205ca8 <default_pmm_manager+0x148>
ffffffffc0201cd2:	cb0fe0ef          	jal	ffffffffc0200182 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201cd6:	777d                	lui	a4,0xfffff
ffffffffc0201cd8:	00054797          	auipc	a5,0x54
ffffffffc0201cdc:	e2778793          	add	a5,a5,-473 # ffffffffc0255aff <end+0xfff>
ffffffffc0201ce0:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201ce2:	00088737          	lui	a4,0x88
ffffffffc0201ce6:	00053597          	auipc	a1,0x53
ffffffffc0201cea:	db258593          	add	a1,a1,-590 # ffffffffc0254a98 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201cee:	00053617          	auipc	a2,0x53
ffffffffc0201cf2:	db260613          	add	a2,a2,-590 # ffffffffc0254aa0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201cf6:	60070713          	add	a4,a4,1536 # 88600 <_binary_obj___user_ex3_out_size+0x7d370>
ffffffffc0201cfa:	e198                	sd	a4,0(a1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201cfc:	e21c                	sd	a5,0(a2)
ffffffffc0201cfe:	4705                	li	a4,1
ffffffffc0201d00:	07a1                	add	a5,a5,8
ffffffffc0201d02:	40e7b02f          	amoor.d	zero,a4,(a5)
ffffffffc0201d06:	4805                	li	a6,1
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201d08:	fff80537          	lui	a0,0xfff80
        SetPageReserved(pages + i);
ffffffffc0201d0c:	621c                	ld	a5,0(a2)
ffffffffc0201d0e:	00671693          	sll	a3,a4,0x6
ffffffffc0201d12:	97b6                	add	a5,a5,a3
ffffffffc0201d14:	07a1                	add	a5,a5,8
ffffffffc0201d16:	4107b02f          	amoor.d	zero,a6,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201d1a:	619c                	ld	a5,0(a1)
ffffffffc0201d1c:	0705                	add	a4,a4,1
ffffffffc0201d1e:	00a786b3          	add	a3,a5,a0
ffffffffc0201d22:	fed765e3          	bltu	a4,a3,ffffffffc0201d0c <pmm_init+0x9c>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201d26:	6218                	ld	a4,0(a2)
ffffffffc0201d28:	069a                	sll	a3,a3,0x6
ffffffffc0201d2a:	c0200637          	lui	a2,0xc0200
ffffffffc0201d2e:	96ba                	add	a3,a3,a4
ffffffffc0201d30:	06c6e763          	bltu	a3,a2,ffffffffc0201d9e <pmm_init+0x12e>
ffffffffc0201d34:	6010                	ld	a2,0(s0)
    if (freemem < mem_end) {
ffffffffc0201d36:	44300593          	li	a1,1091
ffffffffc0201d3a:	05d6                	sll	a1,a1,0x15
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201d3c:	8e91                	sub	a3,a3,a2
    if (freemem < mem_end) {
ffffffffc0201d3e:	02b6e963          	bltu	a3,a1,ffffffffc0201d70 <pmm_init+0x100>
    // pmm
    //check_alloc_page();

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    extern char boot_page_table_sv39[];
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201d42:	00008697          	auipc	a3,0x8
ffffffffc0201d46:	2be68693          	add	a3,a3,702 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0201d4a:	00053797          	auipc	a5,0x53
ffffffffc0201d4e:	d2d7bf23          	sd	a3,-706(a5) # ffffffffc0254a88 <boot_pgdir>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201d52:	c02007b7          	lui	a5,0xc0200
ffffffffc0201d56:	06f6e063          	bltu	a3,a5,ffffffffc0201db6 <pmm_init+0x146>
ffffffffc0201d5a:	601c                	ld	a5,0(s0)
    // check the correctness of the basic virtual memory map.
    //check_boot_pgdir();


    kmalloc_init();
}
ffffffffc0201d5c:	6442                	ld	s0,16(sp)
ffffffffc0201d5e:	60e2                	ld	ra,24(sp)
ffffffffc0201d60:	64a2                	ld	s1,8(sp)
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201d62:	8e9d                	sub	a3,a3,a5
ffffffffc0201d64:	00053797          	auipc	a5,0x53
ffffffffc0201d68:	d0d7be23          	sd	a3,-740(a5) # ffffffffc0254a80 <boot_cr3>
}
ffffffffc0201d6c:	6105                	add	sp,sp,32
    kmalloc_init();
ffffffffc0201d6e:	b181                	j	ffffffffc02019ae <kmalloc_init>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201d70:	6605                	lui	a2,0x1
ffffffffc0201d72:	167d                	add	a2,a2,-1 # fff <_binary_obj___user_ex1_out_size-0x8bc9>
ffffffffc0201d74:	96b2                	add	a3,a3,a2
ffffffffc0201d76:	767d                	lui	a2,0xfffff
ffffffffc0201d78:	8ef1                	and	a3,a3,a2
    if (PPN(pa) >= npage) {
ffffffffc0201d7a:	00c6d613          	srl	a2,a3,0xc
ffffffffc0201d7e:	00f67e63          	bgeu	a2,a5,ffffffffc0201d9a <pmm_init+0x12a>
    pmm_manager->init_memmap(base, n);
ffffffffc0201d82:	609c                	ld	a5,0(s1)
    return &pages[PPN(pa) - nbase];
ffffffffc0201d84:	fff80537          	lui	a0,0xfff80
ffffffffc0201d88:	962a                	add	a2,a2,a0
ffffffffc0201d8a:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201d8c:	8d95                	sub	a1,a1,a3
ffffffffc0201d8e:	00661513          	sll	a0,a2,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0201d92:	81b1                	srl	a1,a1,0xc
ffffffffc0201d94:	953a                	add	a0,a0,a4
ffffffffc0201d96:	9782                	jalr	a5
}
ffffffffc0201d98:	b76d                	j	ffffffffc0201d42 <pmm_init+0xd2>
ffffffffc0201d9a:	db1ff0ef          	jal	ffffffffc0201b4a <pa2page.part.0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201d9e:	00004617          	auipc	a2,0x4
ffffffffc0201da2:	e6a60613          	add	a2,a2,-406 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0201da6:	07f00593          	li	a1,127
ffffffffc0201daa:	00004517          	auipc	a0,0x4
ffffffffc0201dae:	f2650513          	add	a0,a0,-218 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0201db2:	eb8fe0ef          	jal	ffffffffc020046a <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201db6:	00004617          	auipc	a2,0x4
ffffffffc0201dba:	e5260613          	add	a2,a2,-430 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0201dbe:	0c100593          	li	a1,193
ffffffffc0201dc2:	00004517          	auipc	a0,0x4
ffffffffc0201dc6:	f0e50513          	add	a0,a0,-242 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0201dca:	ea0fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0201dce <get_pte>:
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201dce:	01e5d793          	srl	a5,a1,0x1e
ffffffffc0201dd2:	1ff7f793          	and	a5,a5,511
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201dd6:	7139                	add	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201dd8:	078e                	sll	a5,a5,0x3
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201dda:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201ddc:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201de0:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201de2:	f04a                	sd	s2,32(sp)
ffffffffc0201de4:	ec4e                	sd	s3,24(sp)
ffffffffc0201de6:	e852                	sd	s4,16(sp)
ffffffffc0201de8:	fc06                	sd	ra,56(sp)
ffffffffc0201dea:	f822                	sd	s0,48(sp)
ffffffffc0201dec:	e456                	sd	s5,8(sp)
ffffffffc0201dee:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201df0:	0016f793          	and	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0201df4:	892e                	mv	s2,a1
ffffffffc0201df6:	89b2                	mv	s3,a2
ffffffffc0201df8:	00053a17          	auipc	s4,0x53
ffffffffc0201dfc:	ca0a0a13          	add	s4,s4,-864 # ffffffffc0254a98 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0201e00:	e7b5                	bnez	a5,ffffffffc0201e6c <get_pte+0x9e>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201e02:	12060b63          	beqz	a2,ffffffffc0201f38 <get_pte+0x16a>
ffffffffc0201e06:	4505                	li	a0,1
ffffffffc0201e08:	d5fff0ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0201e0c:	842a                	mv	s0,a0
ffffffffc0201e0e:	12050563          	beqz	a0,ffffffffc0201f38 <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201e12:	00053b17          	auipc	s6,0x53
ffffffffc0201e16:	c8eb0b13          	add	s6,s6,-882 # ffffffffc0254aa0 <pages>
ffffffffc0201e1a:	000b3503          	ld	a0,0(s6)
ffffffffc0201e1e:	00080ab7          	lui	s5,0x80
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e22:	00053a17          	auipc	s4,0x53
ffffffffc0201e26:	c76a0a13          	add	s4,s4,-906 # ffffffffc0254a98 <npage>
ffffffffc0201e2a:	40a40533          	sub	a0,s0,a0
ffffffffc0201e2e:	8519                	sra	a0,a0,0x6
ffffffffc0201e30:	9556                	add	a0,a0,s5
ffffffffc0201e32:	000a3703          	ld	a4,0(s4)
ffffffffc0201e36:	00c51793          	sll	a5,a0,0xc
    page->ref = val;
ffffffffc0201e3a:	4685                	li	a3,1
ffffffffc0201e3c:	c014                	sw	a3,0(s0)
ffffffffc0201e3e:	83b1                	srl	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e40:	0532                	sll	a0,a0,0xc
ffffffffc0201e42:	14e7f163          	bgeu	a5,a4,ffffffffc0201f84 <get_pte+0x1b6>
ffffffffc0201e46:	00053797          	auipc	a5,0x53
ffffffffc0201e4a:	c4a7b783          	ld	a5,-950(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc0201e4e:	953e                	add	a0,a0,a5
ffffffffc0201e50:	6605                	lui	a2,0x1
ffffffffc0201e52:	4581                	li	a1,0
ffffffffc0201e54:	7b9020ef          	jal	ffffffffc0204e0c <memset>
    return page - pages + nbase;
ffffffffc0201e58:	000b3783          	ld	a5,0(s6)
ffffffffc0201e5c:	40f406b3          	sub	a3,s0,a5
ffffffffc0201e60:	8699                	sra	a3,a3,0x6
ffffffffc0201e62:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vm");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e64:	06aa                	sll	a3,a3,0xa
ffffffffc0201e66:	0116e693          	or	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201e6a:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201e6c:	77fd                	lui	a5,0xfffff
ffffffffc0201e6e:	068a                	sll	a3,a3,0x2
ffffffffc0201e70:	000a3703          	ld	a4,0(s4)
ffffffffc0201e74:	8efd                	and	a3,a3,a5
ffffffffc0201e76:	00c6d793          	srl	a5,a3,0xc
ffffffffc0201e7a:	0ce7f163          	bgeu	a5,a4,ffffffffc0201f3c <get_pte+0x16e>
ffffffffc0201e7e:	00053a97          	auipc	s5,0x53
ffffffffc0201e82:	c12a8a93          	add	s5,s5,-1006 # ffffffffc0254a90 <va_pa_offset>
ffffffffc0201e86:	000ab603          	ld	a2,0(s5)
ffffffffc0201e8a:	01595793          	srl	a5,s2,0x15
ffffffffc0201e8e:	1ff7f793          	and	a5,a5,511
ffffffffc0201e92:	96b2                	add	a3,a3,a2
ffffffffc0201e94:	078e                	sll	a5,a5,0x3
ffffffffc0201e96:	00f68433          	add	s0,a3,a5
    if (!(*pdep0 & PTE_V)) {
ffffffffc0201e9a:	6014                	ld	a3,0(s0)
ffffffffc0201e9c:	0016f793          	and	a5,a3,1
ffffffffc0201ea0:	e3ad                	bnez	a5,ffffffffc0201f02 <get_pte+0x134>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201ea2:	08098b63          	beqz	s3,ffffffffc0201f38 <get_pte+0x16a>
ffffffffc0201ea6:	4505                	li	a0,1
ffffffffc0201ea8:	cbfff0ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0201eac:	84aa                	mv	s1,a0
ffffffffc0201eae:	c549                	beqz	a0,ffffffffc0201f38 <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201eb0:	00053b17          	auipc	s6,0x53
ffffffffc0201eb4:	bf0b0b13          	add	s6,s6,-1040 # ffffffffc0254aa0 <pages>
ffffffffc0201eb8:	000b3683          	ld	a3,0(s6)
ffffffffc0201ebc:	000809b7          	lui	s3,0x80
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201ec0:	000a3703          	ld	a4,0(s4)
ffffffffc0201ec4:	40d506b3          	sub	a3,a0,a3
ffffffffc0201ec8:	8699                	sra	a3,a3,0x6
ffffffffc0201eca:	96ce                	add	a3,a3,s3
ffffffffc0201ecc:	00c69793          	sll	a5,a3,0xc
    page->ref = val;
ffffffffc0201ed0:	4605                	li	a2,1
ffffffffc0201ed2:	c110                	sw	a2,0(a0)
ffffffffc0201ed4:	83b1                	srl	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ed6:	06b2                	sll	a3,a3,0xc
ffffffffc0201ed8:	08e7fa63          	bgeu	a5,a4,ffffffffc0201f6c <get_pte+0x19e>
ffffffffc0201edc:	000ab503          	ld	a0,0(s5)
ffffffffc0201ee0:	6605                	lui	a2,0x1
ffffffffc0201ee2:	4581                	li	a1,0
ffffffffc0201ee4:	9536                	add	a0,a0,a3
ffffffffc0201ee6:	727020ef          	jal	ffffffffc0204e0c <memset>
    return page - pages + nbase;
ffffffffc0201eea:	000b3783          	ld	a5,0(s6)
ffffffffc0201eee:	40f486b3          	sub	a3,s1,a5
ffffffffc0201ef2:	8699                	sra	a3,a3,0x6
ffffffffc0201ef4:	96ce                	add	a3,a3,s3
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201ef6:	06aa                	sll	a3,a3,0xa
ffffffffc0201ef8:	0116e693          	or	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201efc:	e014                	sd	a3,0(s0)
        }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201efe:	000a3703          	ld	a4,0(s4)
ffffffffc0201f02:	77fd                	lui	a5,0xfffff
ffffffffc0201f04:	068a                	sll	a3,a3,0x2
ffffffffc0201f06:	8efd                	and	a3,a3,a5
ffffffffc0201f08:	00c6d793          	srl	a5,a3,0xc
ffffffffc0201f0c:	04e7f463          	bgeu	a5,a4,ffffffffc0201f54 <get_pte+0x186>
ffffffffc0201f10:	000ab783          	ld	a5,0(s5)
ffffffffc0201f14:	00c95913          	srl	s2,s2,0xc
ffffffffc0201f18:	1ff97913          	and	s2,s2,511
ffffffffc0201f1c:	96be                	add	a3,a3,a5
ffffffffc0201f1e:	090e                	sll	s2,s2,0x3
ffffffffc0201f20:	01268533          	add	a0,a3,s2
}
ffffffffc0201f24:	70e2                	ld	ra,56(sp)
ffffffffc0201f26:	7442                	ld	s0,48(sp)
ffffffffc0201f28:	74a2                	ld	s1,40(sp)
ffffffffc0201f2a:	7902                	ld	s2,32(sp)
ffffffffc0201f2c:	69e2                	ld	s3,24(sp)
ffffffffc0201f2e:	6a42                	ld	s4,16(sp)
ffffffffc0201f30:	6aa2                	ld	s5,8(sp)
ffffffffc0201f32:	6b02                	ld	s6,0(sp)
ffffffffc0201f34:	6121                	add	sp,sp,64
ffffffffc0201f36:	8082                	ret
            return NULL;
ffffffffc0201f38:	4501                	li	a0,0
ffffffffc0201f3a:	b7ed                	j	ffffffffc0201f24 <get_pte+0x156>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f3c:	00004617          	auipc	a2,0x4
ffffffffc0201f40:	c5c60613          	add	a2,a2,-932 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0201f44:	0fe00593          	li	a1,254
ffffffffc0201f48:	00004517          	auipc	a0,0x4
ffffffffc0201f4c:	d8850513          	add	a0,a0,-632 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0201f50:	d1afe0ef          	jal	ffffffffc020046a <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f54:	00004617          	auipc	a2,0x4
ffffffffc0201f58:	c4460613          	add	a2,a2,-956 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0201f5c:	10900593          	li	a1,265
ffffffffc0201f60:	00004517          	auipc	a0,0x4
ffffffffc0201f64:	d7050513          	add	a0,a0,-656 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0201f68:	d02fe0ef          	jal	ffffffffc020046a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f6c:	00004617          	auipc	a2,0x4
ffffffffc0201f70:	c2c60613          	add	a2,a2,-980 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0201f74:	10600593          	li	a1,262
ffffffffc0201f78:	00004517          	auipc	a0,0x4
ffffffffc0201f7c:	d5850513          	add	a0,a0,-680 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0201f80:	ceafe0ef          	jal	ffffffffc020046a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f84:	86aa                	mv	a3,a0
ffffffffc0201f86:	00004617          	auipc	a2,0x4
ffffffffc0201f8a:	c1260613          	add	a2,a2,-1006 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0201f8e:	0fa00593          	li	a1,250
ffffffffc0201f92:	00004517          	auipc	a0,0x4
ffffffffc0201f96:	d3e50513          	add	a0,a0,-706 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0201f9a:	cd0fe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0201f9e <unmap_range>:
        *ptep = 0;                  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0201f9e:	715d                	add	sp,sp,-80
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0201fa0:	00c5e7b3          	or	a5,a1,a2
void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc0201fa4:	e486                	sd	ra,72(sp)
ffffffffc0201fa6:	e0a2                	sd	s0,64(sp)
ffffffffc0201fa8:	fc26                	sd	s1,56(sp)
ffffffffc0201faa:	f84a                	sd	s2,48(sp)
ffffffffc0201fac:	f44e                	sd	s3,40(sp)
ffffffffc0201fae:	f052                	sd	s4,32(sp)
ffffffffc0201fb0:	ec56                	sd	s5,24(sp)
ffffffffc0201fb2:	e85a                	sd	s6,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0201fb4:	17d2                	sll	a5,a5,0x34
ffffffffc0201fb6:	ebe9                	bnez	a5,ffffffffc0202088 <unmap_range+0xea>
    assert(USER_ACCESS(start, end));
ffffffffc0201fb8:	002007b7          	lui	a5,0x200
ffffffffc0201fbc:	842e                	mv	s0,a1
ffffffffc0201fbe:	0ef5e563          	bltu	a1,a5,ffffffffc02020a8 <unmap_range+0x10a>
ffffffffc0201fc2:	8932                	mv	s2,a2
ffffffffc0201fc4:	0ec5f263          	bgeu	a1,a2,ffffffffc02020a8 <unmap_range+0x10a>
ffffffffc0201fc8:	4785                	li	a5,1
ffffffffc0201fca:	07fe                	sll	a5,a5,0x1f
ffffffffc0201fcc:	0cc7ee63          	bltu	a5,a2,ffffffffc02020a8 <unmap_range+0x10a>
ffffffffc0201fd0:	89aa                	mv	s3,a0
            continue;
        }
        if (*ptep != 0) {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0201fd2:	6a05                	lui	s4,0x1
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0201fd4:	00200b37          	lui	s6,0x200
ffffffffc0201fd8:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0201fdc:	4601                	li	a2,0
ffffffffc0201fde:	85a2                	mv	a1,s0
ffffffffc0201fe0:	854e                	mv	a0,s3
ffffffffc0201fe2:	dedff0ef          	jal	ffffffffc0201dce <get_pte>
ffffffffc0201fe6:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc0201fe8:	cd39                	beqz	a0,ffffffffc0202046 <unmap_range+0xa8>
        if (*ptep != 0) {
ffffffffc0201fea:	611c                	ld	a5,0(a0)
ffffffffc0201fec:	ef91                	bnez	a5,ffffffffc0202008 <unmap_range+0x6a>
        start += PGSIZE;
ffffffffc0201fee:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0201ff0:	ff2466e3          	bltu	s0,s2,ffffffffc0201fdc <unmap_range+0x3e>
}
ffffffffc0201ff4:	60a6                	ld	ra,72(sp)
ffffffffc0201ff6:	6406                	ld	s0,64(sp)
ffffffffc0201ff8:	74e2                	ld	s1,56(sp)
ffffffffc0201ffa:	7942                	ld	s2,48(sp)
ffffffffc0201ffc:	79a2                	ld	s3,40(sp)
ffffffffc0201ffe:	7a02                	ld	s4,32(sp)
ffffffffc0202000:	6ae2                	ld	s5,24(sp)
ffffffffc0202002:	6b42                	ld	s6,16(sp)
ffffffffc0202004:	6161                	add	sp,sp,80
ffffffffc0202006:	8082                	ret
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0202008:	0017f713          	and	a4,a5,1
ffffffffc020200c:	d36d                	beqz	a4,ffffffffc0201fee <unmap_range+0x50>
    return pa2page(PTE_ADDR(pte));
ffffffffc020200e:	078a                	sll	a5,a5,0x2
ffffffffc0202010:	83b1                	srl	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202012:	00053717          	auipc	a4,0x53
ffffffffc0202016:	a8673703          	ld	a4,-1402(a4) # ffffffffc0254a98 <npage>
ffffffffc020201a:	0ae7f763          	bgeu	a5,a4,ffffffffc02020c8 <unmap_range+0x12a>
    return &pages[PPN(pa) - nbase];
ffffffffc020201e:	fff80737          	lui	a4,0xfff80
ffffffffc0202022:	97ba                	add	a5,a5,a4
ffffffffc0202024:	079a                	sll	a5,a5,0x6
ffffffffc0202026:	00053517          	auipc	a0,0x53
ffffffffc020202a:	a7a53503          	ld	a0,-1414(a0) # ffffffffc0254aa0 <pages>
ffffffffc020202e:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202030:	411c                	lw	a5,0(a0)
ffffffffc0202032:	fff7871b          	addw	a4,a5,-1 # 1fffff <_binary_obj___user_ex3_out_size+0x1f4d6f>
ffffffffc0202036:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202038:	cf11                	beqz	a4,ffffffffc0202054 <unmap_range+0xb6>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc020203a:	0004b023          	sd	zero,0(s1)
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020203e:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202042:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202044:	b775                	j	ffffffffc0201ff0 <unmap_range+0x52>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202046:	945a                	add	s0,s0,s6
ffffffffc0202048:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020204c:	d445                	beqz	s0,ffffffffc0201ff4 <unmap_range+0x56>
ffffffffc020204e:	f92467e3          	bltu	s0,s2,ffffffffc0201fdc <unmap_range+0x3e>
ffffffffc0202052:	b74d                	j	ffffffffc0201ff4 <unmap_range+0x56>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202054:	100027f3          	csrr	a5,sstatus
ffffffffc0202058:	8b89                	and	a5,a5,2
ffffffffc020205a:	eb89                	bnez	a5,ffffffffc020206c <unmap_range+0xce>
        pmm_manager->free_pages(base, n);
ffffffffc020205c:	00053797          	auipc	a5,0x53
ffffffffc0202060:	a1c7b783          	ld	a5,-1508(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc0202064:	739c                	ld	a5,32(a5)
ffffffffc0202066:	4585                	li	a1,1
ffffffffc0202068:	9782                	jalr	a5
    if (flag) {
ffffffffc020206a:	bfc1                	j	ffffffffc020203a <unmap_range+0x9c>
        intr_disable();
ffffffffc020206c:	e42a                	sd	a0,8(sp)
ffffffffc020206e:	d8efe0ef          	jal	ffffffffc02005fc <intr_disable>
ffffffffc0202072:	00053797          	auipc	a5,0x53
ffffffffc0202076:	a067b783          	ld	a5,-1530(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc020207a:	739c                	ld	a5,32(a5)
ffffffffc020207c:	6522                	ld	a0,8(sp)
ffffffffc020207e:	4585                	li	a1,1
ffffffffc0202080:	9782                	jalr	a5
        intr_enable();
ffffffffc0202082:	d74fe0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc0202086:	bf55                	j	ffffffffc020203a <unmap_range+0x9c>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202088:	00004697          	auipc	a3,0x4
ffffffffc020208c:	c5868693          	add	a3,a3,-936 # ffffffffc0205ce0 <default_pmm_manager+0x180>
ffffffffc0202090:	00003617          	auipc	a2,0x3
ffffffffc0202094:	43860613          	add	a2,a2,1080 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202098:	14000593          	li	a1,320
ffffffffc020209c:	00004517          	auipc	a0,0x4
ffffffffc02020a0:	c3450513          	add	a0,a0,-972 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc02020a4:	bc6fe0ef          	jal	ffffffffc020046a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02020a8:	00004697          	auipc	a3,0x4
ffffffffc02020ac:	c6868693          	add	a3,a3,-920 # ffffffffc0205d10 <default_pmm_manager+0x1b0>
ffffffffc02020b0:	00003617          	auipc	a2,0x3
ffffffffc02020b4:	41860613          	add	a2,a2,1048 # ffffffffc02054c8 <commands+0x430>
ffffffffc02020b8:	14100593          	li	a1,321
ffffffffc02020bc:	00004517          	auipc	a0,0x4
ffffffffc02020c0:	c1450513          	add	a0,a0,-1004 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc02020c4:	ba6fe0ef          	jal	ffffffffc020046a <__panic>
ffffffffc02020c8:	a83ff0ef          	jal	ffffffffc0201b4a <pa2page.part.0>

ffffffffc02020cc <exit_range>:
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc02020cc:	711d                	add	sp,sp,-96
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020ce:	00c5e7b3          	or	a5,a1,a2
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc02020d2:	ec86                	sd	ra,88(sp)
ffffffffc02020d4:	e8a2                	sd	s0,80(sp)
ffffffffc02020d6:	e4a6                	sd	s1,72(sp)
ffffffffc02020d8:	e0ca                	sd	s2,64(sp)
ffffffffc02020da:	fc4e                	sd	s3,56(sp)
ffffffffc02020dc:	f852                	sd	s4,48(sp)
ffffffffc02020de:	f456                	sd	s5,40(sp)
ffffffffc02020e0:	f05a                	sd	s6,32(sp)
ffffffffc02020e2:	ec5e                	sd	s7,24(sp)
ffffffffc02020e4:	e862                	sd	s8,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020e6:	17d2                	sll	a5,a5,0x34
ffffffffc02020e8:	e3f1                	bnez	a5,ffffffffc02021ac <exit_range+0xe0>
    assert(USER_ACCESS(start, end));
ffffffffc02020ea:	002007b7          	lui	a5,0x200
ffffffffc02020ee:	0ef5eb63          	bltu	a1,a5,ffffffffc02021e4 <exit_range+0x118>
ffffffffc02020f2:	8ab2                	mv	s5,a2
ffffffffc02020f4:	0ec5f863          	bgeu	a1,a2,ffffffffc02021e4 <exit_range+0x118>
ffffffffc02020f8:	4785                	li	a5,1
    start = ROUNDDOWN(start, PTSIZE);
ffffffffc02020fa:	ffe00737          	lui	a4,0xffe00
    assert(USER_ACCESS(start, end));
ffffffffc02020fe:	07fe                	sll	a5,a5,0x1f
    start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202100:	00e5f4b3          	and	s1,a1,a4
    assert(USER_ACCESS(start, end));
ffffffffc0202104:	0ec7e063          	bltu	a5,a2,ffffffffc02021e4 <exit_range+0x118>
ffffffffc0202108:	8b2a                	mv	s6,a0
    if (PPN(pa) >= npage) {
ffffffffc020210a:	00053b97          	auipc	s7,0x53
ffffffffc020210e:	98eb8b93          	add	s7,s7,-1650 # ffffffffc0254a98 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202112:	00053c17          	auipc	s8,0x53
ffffffffc0202116:	98ec0c13          	add	s8,s8,-1650 # ffffffffc0254aa0 <pages>
ffffffffc020211a:	fff809b7          	lui	s3,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020211e:	00053917          	auipc	s2,0x53
ffffffffc0202122:	95a90913          	add	s2,s2,-1702 # ffffffffc0254a78 <pmm_manager>
        start += PTSIZE;
ffffffffc0202126:	00200a37          	lui	s4,0x200
ffffffffc020212a:	a029                	j	ffffffffc0202134 <exit_range+0x68>
ffffffffc020212c:	94d2                	add	s1,s1,s4
    } while (start != 0 && start < end);
ffffffffc020212e:	c4a9                	beqz	s1,ffffffffc0202178 <exit_range+0xac>
ffffffffc0202130:	0554f463          	bgeu	s1,s5,ffffffffc0202178 <exit_range+0xac>
        int pde_idx = PDX1(start);
ffffffffc0202134:	01e4d413          	srl	s0,s1,0x1e
        if (pgdir[pde_idx] & PTE_V) {
ffffffffc0202138:	1ff47413          	and	s0,s0,511
ffffffffc020213c:	040e                	sll	s0,s0,0x3
ffffffffc020213e:	945a                	add	s0,s0,s6
ffffffffc0202140:	601c                	ld	a5,0(s0)
ffffffffc0202142:	0017f713          	and	a4,a5,1
ffffffffc0202146:	d37d                	beqz	a4,ffffffffc020212c <exit_range+0x60>
    if (PPN(pa) >= npage) {
ffffffffc0202148:	000bb703          	ld	a4,0(s7)
    return pa2page(PDE_ADDR(pde));
ffffffffc020214c:	078a                	sll	a5,a5,0x2
ffffffffc020214e:	83b1                	srl	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202150:	06e7fe63          	bgeu	a5,a4,ffffffffc02021cc <exit_range+0x100>
    return &pages[PPN(pa) - nbase];
ffffffffc0202154:	000c3503          	ld	a0,0(s8)
ffffffffc0202158:	97ce                	add	a5,a5,s3
ffffffffc020215a:	079a                	sll	a5,a5,0x6
ffffffffc020215c:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020215e:	100027f3          	csrr	a5,sstatus
ffffffffc0202162:	8b89                	and	a5,a5,2
ffffffffc0202164:	e795                	bnez	a5,ffffffffc0202190 <exit_range+0xc4>
        pmm_manager->free_pages(base, n);
ffffffffc0202166:	00093783          	ld	a5,0(s2)
ffffffffc020216a:	4585                	li	a1,1
ffffffffc020216c:	739c                	ld	a5,32(a5)
ffffffffc020216e:	9782                	jalr	a5
            pgdir[pde_idx] = 0;
ffffffffc0202170:	00043023          	sd	zero,0(s0)
        start += PTSIZE;
ffffffffc0202174:	94d2                	add	s1,s1,s4
    } while (start != 0 && start < end);
ffffffffc0202176:	fccd                	bnez	s1,ffffffffc0202130 <exit_range+0x64>
}
ffffffffc0202178:	60e6                	ld	ra,88(sp)
ffffffffc020217a:	6446                	ld	s0,80(sp)
ffffffffc020217c:	64a6                	ld	s1,72(sp)
ffffffffc020217e:	6906                	ld	s2,64(sp)
ffffffffc0202180:	79e2                	ld	s3,56(sp)
ffffffffc0202182:	7a42                	ld	s4,48(sp)
ffffffffc0202184:	7aa2                	ld	s5,40(sp)
ffffffffc0202186:	7b02                	ld	s6,32(sp)
ffffffffc0202188:	6be2                	ld	s7,24(sp)
ffffffffc020218a:	6c42                	ld	s8,16(sp)
ffffffffc020218c:	6125                	add	sp,sp,96
ffffffffc020218e:	8082                	ret
ffffffffc0202190:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202192:	c6afe0ef          	jal	ffffffffc02005fc <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202196:	00093783          	ld	a5,0(s2)
ffffffffc020219a:	6522                	ld	a0,8(sp)
ffffffffc020219c:	4585                	li	a1,1
ffffffffc020219e:	739c                	ld	a5,32(a5)
ffffffffc02021a0:	9782                	jalr	a5
        intr_enable();
ffffffffc02021a2:	c54fe0ef          	jal	ffffffffc02005f6 <intr_enable>
            pgdir[pde_idx] = 0;
ffffffffc02021a6:	00043023          	sd	zero,0(s0)
ffffffffc02021aa:	b7e9                	j	ffffffffc0202174 <exit_range+0xa8>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021ac:	00004697          	auipc	a3,0x4
ffffffffc02021b0:	b3468693          	add	a3,a3,-1228 # ffffffffc0205ce0 <default_pmm_manager+0x180>
ffffffffc02021b4:	00003617          	auipc	a2,0x3
ffffffffc02021b8:	31460613          	add	a2,a2,788 # ffffffffc02054c8 <commands+0x430>
ffffffffc02021bc:	15100593          	li	a1,337
ffffffffc02021c0:	00004517          	auipc	a0,0x4
ffffffffc02021c4:	b1050513          	add	a0,a0,-1264 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc02021c8:	aa2fe0ef          	jal	ffffffffc020046a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02021cc:	00004617          	auipc	a2,0x4
ffffffffc02021d0:	a6460613          	add	a2,a2,-1436 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc02021d4:	06200593          	li	a1,98
ffffffffc02021d8:	00004517          	auipc	a0,0x4
ffffffffc02021dc:	9e850513          	add	a0,a0,-1560 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc02021e0:	a8afe0ef          	jal	ffffffffc020046a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02021e4:	00004697          	auipc	a3,0x4
ffffffffc02021e8:	b2c68693          	add	a3,a3,-1236 # ffffffffc0205d10 <default_pmm_manager+0x1b0>
ffffffffc02021ec:	00003617          	auipc	a2,0x3
ffffffffc02021f0:	2dc60613          	add	a2,a2,732 # ffffffffc02054c8 <commands+0x430>
ffffffffc02021f4:	15200593          	li	a1,338
ffffffffc02021f8:	00004517          	auipc	a0,0x4
ffffffffc02021fc:	ad850513          	add	a0,a0,-1320 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0202200:	a6afe0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202204 <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202204:	7139                	add	sp,sp,-64
ffffffffc0202206:	e852                	sd	s4,16(sp)
ffffffffc0202208:	8a32                	mv	s4,a2
ffffffffc020220a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020220c:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc020220e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202210:	85d2                	mv	a1,s4
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0202212:	f426                	sd	s1,40(sp)
ffffffffc0202214:	fc06                	sd	ra,56(sp)
ffffffffc0202216:	f04a                	sd	s2,32(sp)
ffffffffc0202218:	ec4e                	sd	s3,24(sp)
ffffffffc020221a:	e456                	sd	s5,8(sp)
ffffffffc020221c:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020221e:	bb1ff0ef          	jal	ffffffffc0201dce <get_pte>
    if (ptep == NULL) {
ffffffffc0202222:	c969                	beqz	a0,ffffffffc02022f4 <page_insert+0xf0>
    page->ref += 1;
ffffffffc0202224:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc0202226:	611c                	ld	a5,0(a0)
ffffffffc0202228:	89aa                	mv	s3,a0
ffffffffc020222a:	0016871b          	addw	a4,a3,1
ffffffffc020222e:	c018                	sw	a4,0(s0)
ffffffffc0202230:	0017f713          	and	a4,a5,1
ffffffffc0202234:	ef05                	bnez	a4,ffffffffc020226c <page_insert+0x68>
    return &pages[PPN(pa) - nbase];
ffffffffc0202236:	00053717          	auipc	a4,0x53
ffffffffc020223a:	86a73703          	ld	a4,-1942(a4) # ffffffffc0254aa0 <pages>
    return page - pages + nbase;
ffffffffc020223e:	8c19                	sub	s0,s0,a4
ffffffffc0202240:	000807b7          	lui	a5,0x80
ffffffffc0202244:	8419                	sra	s0,s0,0x6
ffffffffc0202246:	943e                	add	s0,s0,a5
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202248:	042a                	sll	s0,s0,0xa
ffffffffc020224a:	8cc1                	or	s1,s1,s0
ffffffffc020224c:	0014e493          	or	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202250:	0099b023          	sd	s1,0(s3) # fffffffffff80000 <end+0x3fd2b500>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202254:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202258:	4501                	li	a0,0
}
ffffffffc020225a:	70e2                	ld	ra,56(sp)
ffffffffc020225c:	7442                	ld	s0,48(sp)
ffffffffc020225e:	74a2                	ld	s1,40(sp)
ffffffffc0202260:	7902                	ld	s2,32(sp)
ffffffffc0202262:	69e2                	ld	s3,24(sp)
ffffffffc0202264:	6a42                	ld	s4,16(sp)
ffffffffc0202266:	6aa2                	ld	s5,8(sp)
ffffffffc0202268:	6121                	add	sp,sp,64
ffffffffc020226a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020226c:	078a                	sll	a5,a5,0x2
ffffffffc020226e:	83b1                	srl	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202270:	00053717          	auipc	a4,0x53
ffffffffc0202274:	82873703          	ld	a4,-2008(a4) # ffffffffc0254a98 <npage>
ffffffffc0202278:	08e7f063          	bgeu	a5,a4,ffffffffc02022f8 <page_insert+0xf4>
    return &pages[PPN(pa) - nbase];
ffffffffc020227c:	00053a97          	auipc	s5,0x53
ffffffffc0202280:	824a8a93          	add	s5,s5,-2012 # ffffffffc0254aa0 <pages>
ffffffffc0202284:	000ab703          	ld	a4,0(s5)
ffffffffc0202288:	fff80637          	lui	a2,0xfff80
ffffffffc020228c:	00c78933          	add	s2,a5,a2
ffffffffc0202290:	091a                	sll	s2,s2,0x6
ffffffffc0202292:	993a                	add	s2,s2,a4
        if (p == page) {
ffffffffc0202294:	01240c63          	beq	s0,s2,ffffffffc02022ac <page_insert+0xa8>
    page->ref -= 1;
ffffffffc0202298:	00092783          	lw	a5,0(s2)
ffffffffc020229c:	fff7869b          	addw	a3,a5,-1 # 7ffff <_binary_obj___user_ex3_out_size+0x74d6f>
ffffffffc02022a0:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc02022a4:	c691                	beqz	a3,ffffffffc02022b0 <page_insert+0xac>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022a6:	120a0073          	sfence.vma	s4
}
ffffffffc02022aa:	bf51                	j	ffffffffc020223e <page_insert+0x3a>
ffffffffc02022ac:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02022ae:	bf41                	j	ffffffffc020223e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02022b0:	100027f3          	csrr	a5,sstatus
ffffffffc02022b4:	8b89                	and	a5,a5,2
ffffffffc02022b6:	ef91                	bnez	a5,ffffffffc02022d2 <page_insert+0xce>
        pmm_manager->free_pages(base, n);
ffffffffc02022b8:	00052797          	auipc	a5,0x52
ffffffffc02022bc:	7c07b783          	ld	a5,1984(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc02022c0:	739c                	ld	a5,32(a5)
ffffffffc02022c2:	4585                	li	a1,1
ffffffffc02022c4:	854a                	mv	a0,s2
ffffffffc02022c6:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02022c8:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022cc:	120a0073          	sfence.vma	s4
ffffffffc02022d0:	b7bd                	j	ffffffffc020223e <page_insert+0x3a>
        intr_disable();
ffffffffc02022d2:	b2afe0ef          	jal	ffffffffc02005fc <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02022d6:	00052797          	auipc	a5,0x52
ffffffffc02022da:	7a27b783          	ld	a5,1954(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc02022de:	739c                	ld	a5,32(a5)
ffffffffc02022e0:	4585                	li	a1,1
ffffffffc02022e2:	854a                	mv	a0,s2
ffffffffc02022e4:	9782                	jalr	a5
        intr_enable();
ffffffffc02022e6:	b10fe0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc02022ea:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02022ee:	120a0073          	sfence.vma	s4
ffffffffc02022f2:	b7b1                	j	ffffffffc020223e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc02022f4:	5571                	li	a0,-4
ffffffffc02022f6:	b795                	j	ffffffffc020225a <page_insert+0x56>
ffffffffc02022f8:	853ff0ef          	jal	ffffffffc0201b4a <pa2page.part.0>

ffffffffc02022fc <copy_range>:
               bool share) {
ffffffffc02022fc:	7159                	add	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022fe:	00d667b3          	or	a5,a2,a3
               bool share) {
ffffffffc0202302:	f486                	sd	ra,104(sp)
ffffffffc0202304:	f0a2                	sd	s0,96(sp)
ffffffffc0202306:	eca6                	sd	s1,88(sp)
ffffffffc0202308:	e8ca                	sd	s2,80(sp)
ffffffffc020230a:	e4ce                	sd	s3,72(sp)
ffffffffc020230c:	e0d2                	sd	s4,64(sp)
ffffffffc020230e:	fc56                	sd	s5,56(sp)
ffffffffc0202310:	f85a                	sd	s6,48(sp)
ffffffffc0202312:	f45e                	sd	s7,40(sp)
ffffffffc0202314:	f062                	sd	s8,32(sp)
ffffffffc0202316:	ec66                	sd	s9,24(sp)
ffffffffc0202318:	e86a                	sd	s10,16(sp)
ffffffffc020231a:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020231c:	17d2                	sll	a5,a5,0x34
ffffffffc020231e:	1e079763          	bnez	a5,ffffffffc020250c <copy_range+0x210>
    assert(USER_ACCESS(start, end));
ffffffffc0202322:	002007b7          	lui	a5,0x200
ffffffffc0202326:	8432                	mv	s0,a2
ffffffffc0202328:	16f66a63          	bltu	a2,a5,ffffffffc020249c <copy_range+0x1a0>
ffffffffc020232c:	8936                	mv	s2,a3
ffffffffc020232e:	16d67763          	bgeu	a2,a3,ffffffffc020249c <copy_range+0x1a0>
ffffffffc0202332:	4785                	li	a5,1
ffffffffc0202334:	07fe                	sll	a5,a5,0x1f
ffffffffc0202336:	16d7e363          	bltu	a5,a3,ffffffffc020249c <copy_range+0x1a0>
    return KADDR(page2pa(page));
ffffffffc020233a:	5b7d                	li	s6,-1
ffffffffc020233c:	8aaa                	mv	s5,a0
ffffffffc020233e:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc0202340:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202342:	00052c97          	auipc	s9,0x52
ffffffffc0202346:	756c8c93          	add	s9,s9,1878 # ffffffffc0254a98 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020234a:	00052c17          	auipc	s8,0x52
ffffffffc020234e:	756c0c13          	add	s8,s8,1878 # ffffffffc0254aa0 <pages>
    return page - pages + nbase;
ffffffffc0202352:	00080bb7          	lui	s7,0x80
    return KADDR(page2pa(page));
ffffffffc0202356:	00cb5b13          	srl	s6,s6,0xc
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc020235a:	4601                	li	a2,0
ffffffffc020235c:	85a2                	mv	a1,s0
ffffffffc020235e:	854e                	mv	a0,s3
ffffffffc0202360:	a6fff0ef          	jal	ffffffffc0201dce <get_pte>
ffffffffc0202364:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc0202366:	c175                	beqz	a0,ffffffffc020244a <copy_range+0x14e>
        if (*ptep & PTE_V) {
ffffffffc0202368:	611c                	ld	a5,0(a0)
ffffffffc020236a:	8b85                	and	a5,a5,1
ffffffffc020236c:	e785                	bnez	a5,ffffffffc0202394 <copy_range+0x98>
        start += PGSIZE;
ffffffffc020236e:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202370:	ff2465e3          	bltu	s0,s2,ffffffffc020235a <copy_range+0x5e>
    return 0;
ffffffffc0202374:	4501                	li	a0,0
}
ffffffffc0202376:	70a6                	ld	ra,104(sp)
ffffffffc0202378:	7406                	ld	s0,96(sp)
ffffffffc020237a:	64e6                	ld	s1,88(sp)
ffffffffc020237c:	6946                	ld	s2,80(sp)
ffffffffc020237e:	69a6                	ld	s3,72(sp)
ffffffffc0202380:	6a06                	ld	s4,64(sp)
ffffffffc0202382:	7ae2                	ld	s5,56(sp)
ffffffffc0202384:	7b42                	ld	s6,48(sp)
ffffffffc0202386:	7ba2                	ld	s7,40(sp)
ffffffffc0202388:	7c02                	ld	s8,32(sp)
ffffffffc020238a:	6ce2                	ld	s9,24(sp)
ffffffffc020238c:	6d42                	ld	s10,16(sp)
ffffffffc020238e:	6da2                	ld	s11,8(sp)
ffffffffc0202390:	6165                	add	sp,sp,112
ffffffffc0202392:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL) {
ffffffffc0202394:	4605                	li	a2,1
ffffffffc0202396:	85a2                	mv	a1,s0
ffffffffc0202398:	8556                	mv	a0,s5
ffffffffc020239a:	a35ff0ef          	jal	ffffffffc0201dce <get_pte>
ffffffffc020239e:	c161                	beqz	a0,ffffffffc020245e <copy_range+0x162>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02023a0:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V)) {
ffffffffc02023a2:	0017f713          	and	a4,a5,1
ffffffffc02023a6:	01f7f493          	and	s1,a5,31
ffffffffc02023aa:	14070563          	beqz	a4,ffffffffc02024f4 <copy_range+0x1f8>
    if (PPN(pa) >= npage) {
ffffffffc02023ae:	000cb683          	ld	a3,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02023b2:	078a                	sll	a5,a5,0x2
ffffffffc02023b4:	00c7d713          	srl	a4,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02023b8:	12d77263          	bgeu	a4,a3,ffffffffc02024dc <copy_range+0x1e0>
    return &pages[PPN(pa) - nbase];
ffffffffc02023bc:	000c3783          	ld	a5,0(s8)
ffffffffc02023c0:	fff806b7          	lui	a3,0xfff80
ffffffffc02023c4:	9736                	add	a4,a4,a3
ffffffffc02023c6:	071a                	sll	a4,a4,0x6
            struct Page *npage = alloc_page();
ffffffffc02023c8:	4505                	li	a0,1
ffffffffc02023ca:	00e78db3          	add	s11,a5,a4
ffffffffc02023ce:	f98ff0ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc02023d2:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc02023d4:	0a0d8463          	beqz	s11,ffffffffc020247c <copy_range+0x180>
            assert(npage != NULL);
ffffffffc02023d8:	c175                	beqz	a0,ffffffffc02024bc <copy_range+0x1c0>
    return page - pages + nbase;
ffffffffc02023da:	000c3703          	ld	a4,0(s8)
    return KADDR(page2pa(page));
ffffffffc02023de:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc02023e2:	40ed86b3          	sub	a3,s11,a4
ffffffffc02023e6:	8699                	sra	a3,a3,0x6
ffffffffc02023e8:	96de                	add	a3,a3,s7
    return KADDR(page2pa(page));
ffffffffc02023ea:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023ee:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02023f0:	06c7fa63          	bgeu	a5,a2,ffffffffc0202464 <copy_range+0x168>
    return page - pages + nbase;
ffffffffc02023f4:	40e507b3          	sub	a5,a0,a4
    return KADDR(page2pa(page));
ffffffffc02023f8:	00052717          	auipc	a4,0x52
ffffffffc02023fc:	69870713          	add	a4,a4,1688 # ffffffffc0254a90 <va_pa_offset>
ffffffffc0202400:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc0202402:	8799                	sra	a5,a5,0x6
ffffffffc0202404:	97de                	add	a5,a5,s7
    return KADDR(page2pa(page));
ffffffffc0202406:	0167f733          	and	a4,a5,s6
ffffffffc020240a:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020240e:	07b2                	sll	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0202410:	04c77963          	bgeu	a4,a2,ffffffffc0202462 <copy_range+0x166>
            memcpy(kva_dst, kva_src, PGSIZE);
ffffffffc0202414:	6605                	lui	a2,0x1
ffffffffc0202416:	953e                	add	a0,a0,a5
ffffffffc0202418:	207020ef          	jal	ffffffffc0204e1e <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc020241c:	86a6                	mv	a3,s1
ffffffffc020241e:	8622                	mv	a2,s0
ffffffffc0202420:	85ea                	mv	a1,s10
ffffffffc0202422:	8556                	mv	a0,s5
ffffffffc0202424:	de1ff0ef          	jal	ffffffffc0202204 <page_insert>
            assert(ret == 0);
ffffffffc0202428:	d139                	beqz	a0,ffffffffc020236e <copy_range+0x72>
ffffffffc020242a:	00004697          	auipc	a3,0x4
ffffffffc020242e:	91e68693          	add	a3,a3,-1762 # ffffffffc0205d48 <default_pmm_manager+0x1e8>
ffffffffc0202432:	00003617          	auipc	a2,0x3
ffffffffc0202436:	09660613          	add	a2,a2,150 # ffffffffc02054c8 <commands+0x430>
ffffffffc020243a:	19900593          	li	a1,409
ffffffffc020243e:	00004517          	auipc	a0,0x4
ffffffffc0202442:	89250513          	add	a0,a0,-1902 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0202446:	824fe0ef          	jal	ffffffffc020046a <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc020244a:	002007b7          	lui	a5,0x200
ffffffffc020244e:	97a2                	add	a5,a5,s0
ffffffffc0202450:	ffe00437          	lui	s0,0xffe00
ffffffffc0202454:	8c7d                	and	s0,s0,a5
    } while (start != 0 && start < end);
ffffffffc0202456:	dc19                	beqz	s0,ffffffffc0202374 <copy_range+0x78>
ffffffffc0202458:	f12461e3          	bltu	s0,s2,ffffffffc020235a <copy_range+0x5e>
ffffffffc020245c:	bf21                	j	ffffffffc0202374 <copy_range+0x78>
                return -E_NO_MEM;
ffffffffc020245e:	5571                	li	a0,-4
ffffffffc0202460:	bf19                	j	ffffffffc0202376 <copy_range+0x7a>
ffffffffc0202462:	86be                	mv	a3,a5
ffffffffc0202464:	00003617          	auipc	a2,0x3
ffffffffc0202468:	73460613          	add	a2,a2,1844 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc020246c:	06900593          	li	a1,105
ffffffffc0202470:	00003517          	auipc	a0,0x3
ffffffffc0202474:	75050513          	add	a0,a0,1872 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0202478:	ff3fd0ef          	jal	ffffffffc020046a <__panic>
            assert(page != NULL);
ffffffffc020247c:	00004697          	auipc	a3,0x4
ffffffffc0202480:	8ac68693          	add	a3,a3,-1876 # ffffffffc0205d28 <default_pmm_manager+0x1c8>
ffffffffc0202484:	00003617          	auipc	a2,0x3
ffffffffc0202488:	04460613          	add	a2,a2,68 # ffffffffc02054c8 <commands+0x430>
ffffffffc020248c:	17e00593          	li	a1,382
ffffffffc0202490:	00004517          	auipc	a0,0x4
ffffffffc0202494:	84050513          	add	a0,a0,-1984 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0202498:	fd3fd0ef          	jal	ffffffffc020046a <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020249c:	00004697          	auipc	a3,0x4
ffffffffc02024a0:	87468693          	add	a3,a3,-1932 # ffffffffc0205d10 <default_pmm_manager+0x1b0>
ffffffffc02024a4:	00003617          	auipc	a2,0x3
ffffffffc02024a8:	02460613          	add	a2,a2,36 # ffffffffc02054c8 <commands+0x430>
ffffffffc02024ac:	16a00593          	li	a1,362
ffffffffc02024b0:	00004517          	auipc	a0,0x4
ffffffffc02024b4:	82050513          	add	a0,a0,-2016 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc02024b8:	fb3fd0ef          	jal	ffffffffc020046a <__panic>
            assert(npage != NULL);
ffffffffc02024bc:	00004697          	auipc	a3,0x4
ffffffffc02024c0:	87c68693          	add	a3,a3,-1924 # ffffffffc0205d38 <default_pmm_manager+0x1d8>
ffffffffc02024c4:	00003617          	auipc	a2,0x3
ffffffffc02024c8:	00460613          	add	a2,a2,4 # ffffffffc02054c8 <commands+0x430>
ffffffffc02024cc:	17f00593          	li	a1,383
ffffffffc02024d0:	00004517          	auipc	a0,0x4
ffffffffc02024d4:	80050513          	add	a0,a0,-2048 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc02024d8:	f93fd0ef          	jal	ffffffffc020046a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02024dc:	00003617          	auipc	a2,0x3
ffffffffc02024e0:	75460613          	add	a2,a2,1876 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc02024e4:	06200593          	li	a1,98
ffffffffc02024e8:	00003517          	auipc	a0,0x3
ffffffffc02024ec:	6d850513          	add	a0,a0,1752 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc02024f0:	f7bfd0ef          	jal	ffffffffc020046a <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02024f4:	00003617          	auipc	a2,0x3
ffffffffc02024f8:	75c60613          	add	a2,a2,1884 # ffffffffc0205c50 <default_pmm_manager+0xf0>
ffffffffc02024fc:	07400593          	li	a1,116
ffffffffc0202500:	00003517          	auipc	a0,0x3
ffffffffc0202504:	6c050513          	add	a0,a0,1728 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0202508:	f63fd0ef          	jal	ffffffffc020046a <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020250c:	00003697          	auipc	a3,0x3
ffffffffc0202510:	7d468693          	add	a3,a3,2004 # ffffffffc0205ce0 <default_pmm_manager+0x180>
ffffffffc0202514:	00003617          	auipc	a2,0x3
ffffffffc0202518:	fb460613          	add	a2,a2,-76 # ffffffffc02054c8 <commands+0x430>
ffffffffc020251c:	16900593          	li	a1,361
ffffffffc0202520:	00003517          	auipc	a0,0x3
ffffffffc0202524:	7b050513          	add	a0,a0,1968 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc0202528:	f43fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc020252c <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020252c:	12058073          	sfence.vma	a1
}
ffffffffc0202530:	8082                	ret

ffffffffc0202532 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202532:	7179                	add	sp,sp,-48
ffffffffc0202534:	e84a                	sd	s2,16(sp)
ffffffffc0202536:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0202538:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc020253a:	ec26                	sd	s1,24(sp)
ffffffffc020253c:	e44e                	sd	s3,8(sp)
ffffffffc020253e:	f406                	sd	ra,40(sp)
ffffffffc0202540:	f022                	sd	s0,32(sp)
ffffffffc0202542:	84ae                	mv	s1,a1
ffffffffc0202544:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0202546:	e20ff0ef          	jal	ffffffffc0201b66 <alloc_pages>
    if (page != NULL) {
ffffffffc020254a:	c12d                	beqz	a0,ffffffffc02025ac <pgdir_alloc_page+0x7a>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc020254c:	842a                	mv	s0,a0
ffffffffc020254e:	85aa                	mv	a1,a0
ffffffffc0202550:	86ce                	mv	a3,s3
ffffffffc0202552:	8626                	mv	a2,s1
ffffffffc0202554:	854a                	mv	a0,s2
ffffffffc0202556:	cafff0ef          	jal	ffffffffc0202204 <page_insert>
ffffffffc020255a:	ed0d                	bnez	a0,ffffffffc0202594 <pgdir_alloc_page+0x62>
            free_page(page);
            return NULL;
        }
        if (swap_init_ok) {
ffffffffc020255c:	00052797          	auipc	a5,0x52
ffffffffc0202560:	54c7a783          	lw	a5,1356(a5) # ffffffffc0254aa8 <swap_init_ok>
ffffffffc0202564:	c385                	beqz	a5,ffffffffc0202584 <pgdir_alloc_page+0x52>
            if (check_mm_struct != NULL) {
ffffffffc0202566:	00052517          	auipc	a0,0x52
ffffffffc020256a:	56253503          	ld	a0,1378(a0) # ffffffffc0254ac8 <check_mm_struct>
ffffffffc020256e:	c919                	beqz	a0,ffffffffc0202584 <pgdir_alloc_page+0x52>
                swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0202570:	4681                	li	a3,0
ffffffffc0202572:	8622                	mv	a2,s0
ffffffffc0202574:	85a6                	mv	a1,s1
ffffffffc0202576:	108000ef          	jal	ffffffffc020267e <swap_map_swappable>
                page->pra_vaddr = la;
                assert(page_ref(page) == 1);
ffffffffc020257a:	4018                	lw	a4,0(s0)
                page->pra_vaddr = la;
ffffffffc020257c:	fc04                	sd	s1,56(s0)
                assert(page_ref(page) == 1);
ffffffffc020257e:	4785                	li	a5,1
ffffffffc0202580:	04f71663          	bne	a4,a5,ffffffffc02025cc <pgdir_alloc_page+0x9a>
            }
        }
    }

    return page;
}
ffffffffc0202584:	70a2                	ld	ra,40(sp)
ffffffffc0202586:	8522                	mv	a0,s0
ffffffffc0202588:	7402                	ld	s0,32(sp)
ffffffffc020258a:	64e2                	ld	s1,24(sp)
ffffffffc020258c:	6942                	ld	s2,16(sp)
ffffffffc020258e:	69a2                	ld	s3,8(sp)
ffffffffc0202590:	6145                	add	sp,sp,48
ffffffffc0202592:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202594:	100027f3          	csrr	a5,sstatus
ffffffffc0202598:	8b89                	and	a5,a5,2
ffffffffc020259a:	eb99                	bnez	a5,ffffffffc02025b0 <pgdir_alloc_page+0x7e>
        pmm_manager->free_pages(base, n);
ffffffffc020259c:	00052797          	auipc	a5,0x52
ffffffffc02025a0:	4dc7b783          	ld	a5,1244(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc02025a4:	739c                	ld	a5,32(a5)
ffffffffc02025a6:	4585                	li	a1,1
ffffffffc02025a8:	8522                	mv	a0,s0
ffffffffc02025aa:	9782                	jalr	a5
            return NULL;
ffffffffc02025ac:	4401                	li	s0,0
ffffffffc02025ae:	bfd9                	j	ffffffffc0202584 <pgdir_alloc_page+0x52>
        intr_disable();
ffffffffc02025b0:	84cfe0ef          	jal	ffffffffc02005fc <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025b4:	00052797          	auipc	a5,0x52
ffffffffc02025b8:	4c47b783          	ld	a5,1220(a5) # ffffffffc0254a78 <pmm_manager>
ffffffffc02025bc:	739c                	ld	a5,32(a5)
ffffffffc02025be:	8522                	mv	a0,s0
ffffffffc02025c0:	4585                	li	a1,1
ffffffffc02025c2:	9782                	jalr	a5
            return NULL;
ffffffffc02025c4:	4401                	li	s0,0
        intr_enable();
ffffffffc02025c6:	830fe0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc02025ca:	bf6d                	j	ffffffffc0202584 <pgdir_alloc_page+0x52>
                assert(page_ref(page) == 1);
ffffffffc02025cc:	00003697          	auipc	a3,0x3
ffffffffc02025d0:	78c68693          	add	a3,a3,1932 # ffffffffc0205d58 <default_pmm_manager+0x1f8>
ffffffffc02025d4:	00003617          	auipc	a2,0x3
ffffffffc02025d8:	ef460613          	add	a2,a2,-268 # ffffffffc02054c8 <commands+0x430>
ffffffffc02025dc:	1d800593          	li	a1,472
ffffffffc02025e0:	00003517          	auipc	a0,0x3
ffffffffc02025e4:	6f050513          	add	a0,a0,1776 # ffffffffc0205cd0 <default_pmm_manager+0x170>
ffffffffc02025e8:	e83fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02025ec <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc02025ec:	1101                	add	sp,sp,-32
ffffffffc02025ee:	ec06                	sd	ra,24(sp)
ffffffffc02025f0:	e822                	sd	s0,16(sp)
ffffffffc02025f2:	e426                	sd	s1,8(sp)
     swapfs_init();
ffffffffc02025f4:	32b000ef          	jal	ffffffffc020311e <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc02025f8:	00052697          	auipc	a3,0x52
ffffffffc02025fc:	4b86b683          	ld	a3,1208(a3) # ffffffffc0254ab0 <max_swap_offset>
ffffffffc0202600:	010007b7          	lui	a5,0x1000
ffffffffc0202604:	ff968713          	add	a4,a3,-7
ffffffffc0202608:	17e1                	add	a5,a5,-8 # fffff8 <_binary_obj___user_ex3_out_size+0xff4d68>
ffffffffc020260a:	04e7e863          	bltu	a5,a4,ffffffffc020265a <swap_init+0x6e>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }
     

     sm = &swap_manager_fifo;
ffffffffc020260e:	00047797          	auipc	a5,0x47
ffffffffc0202612:	f6a78793          	add	a5,a5,-150 # ffffffffc0249578 <swap_manager_fifo>
     int r = sm->init();
ffffffffc0202616:	6798                	ld	a4,8(a5)
     sm = &swap_manager_fifo;
ffffffffc0202618:	00052497          	auipc	s1,0x52
ffffffffc020261c:	4a048493          	add	s1,s1,1184 # ffffffffc0254ab8 <sm>
ffffffffc0202620:	e09c                	sd	a5,0(s1)
     int r = sm->init();
ffffffffc0202622:	9702                	jalr	a4
ffffffffc0202624:	842a                	mv	s0,a0
     
     if (r == 0)
ffffffffc0202626:	c519                	beqz	a0,ffffffffc0202634 <swap_init+0x48>
          cprintf("SWAP: manager = %s\n", sm->name);
          //check_swap();
     }

     return r;
}
ffffffffc0202628:	60e2                	ld	ra,24(sp)
ffffffffc020262a:	8522                	mv	a0,s0
ffffffffc020262c:	6442                	ld	s0,16(sp)
ffffffffc020262e:	64a2                	ld	s1,8(sp)
ffffffffc0202630:	6105                	add	sp,sp,32
ffffffffc0202632:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202634:	609c                	ld	a5,0(s1)
ffffffffc0202636:	00003517          	auipc	a0,0x3
ffffffffc020263a:	76a50513          	add	a0,a0,1898 # ffffffffc0205da0 <default_pmm_manager+0x240>
ffffffffc020263e:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0202640:	4785                	li	a5,1
ffffffffc0202642:	00052717          	auipc	a4,0x52
ffffffffc0202646:	46f72323          	sw	a5,1126(a4) # ffffffffc0254aa8 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020264a:	b39fd0ef          	jal	ffffffffc0200182 <cprintf>
}
ffffffffc020264e:	60e2                	ld	ra,24(sp)
ffffffffc0202650:	8522                	mv	a0,s0
ffffffffc0202652:	6442                	ld	s0,16(sp)
ffffffffc0202654:	64a2                	ld	s1,8(sp)
ffffffffc0202656:	6105                	add	sp,sp,32
ffffffffc0202658:	8082                	ret
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc020265a:	00003617          	auipc	a2,0x3
ffffffffc020265e:	71660613          	add	a2,a2,1814 # ffffffffc0205d70 <default_pmm_manager+0x210>
ffffffffc0202662:	02800593          	li	a1,40
ffffffffc0202666:	00003517          	auipc	a0,0x3
ffffffffc020266a:	72a50513          	add	a0,a0,1834 # ffffffffc0205d90 <default_pmm_manager+0x230>
ffffffffc020266e:	dfdfd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202672 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
     return sm->init_mm(mm);
ffffffffc0202672:	00052797          	auipc	a5,0x52
ffffffffc0202676:	4467b783          	ld	a5,1094(a5) # ffffffffc0254ab8 <sm>
ffffffffc020267a:	6b9c                	ld	a5,16(a5)
ffffffffc020267c:	8782                	jr	a5

ffffffffc020267e <swap_map_swappable>:
}

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc020267e:	00052797          	auipc	a5,0x52
ffffffffc0202682:	43a7b783          	ld	a5,1082(a5) # ffffffffc0254ab8 <sm>
ffffffffc0202686:	739c                	ld	a5,32(a5)
ffffffffc0202688:	8782                	jr	a5

ffffffffc020268a <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
ffffffffc020268a:	711d                	add	sp,sp,-96
ffffffffc020268c:	ec86                	sd	ra,88(sp)
ffffffffc020268e:	e8a2                	sd	s0,80(sp)
ffffffffc0202690:	e4a6                	sd	s1,72(sp)
ffffffffc0202692:	e0ca                	sd	s2,64(sp)
ffffffffc0202694:	fc4e                	sd	s3,56(sp)
ffffffffc0202696:	f852                	sd	s4,48(sp)
ffffffffc0202698:	f456                	sd	s5,40(sp)
ffffffffc020269a:	f05a                	sd	s6,32(sp)
ffffffffc020269c:	ec5e                	sd	s7,24(sp)
ffffffffc020269e:	e862                	sd	s8,16(sp)
     int i;
     for (i = 0; i != n; ++ i)
ffffffffc02026a0:	cde9                	beqz	a1,ffffffffc020277a <swap_out+0xf0>
ffffffffc02026a2:	8a2e                	mv	s4,a1
ffffffffc02026a4:	892a                	mv	s2,a0
ffffffffc02026a6:	8ab2                	mv	s5,a2
ffffffffc02026a8:	4401                	li	s0,0
ffffffffc02026aa:	00052997          	auipc	s3,0x52
ffffffffc02026ae:	40e98993          	add	s3,s3,1038 # ffffffffc0254ab8 <sm>
                    cprintf("SWAP: failed to save\n");
                    sm->map_swappable(mm, v, page, 0);
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02026b2:	00003b17          	auipc	s6,0x3
ffffffffc02026b6:	766b0b13          	add	s6,s6,1894 # ffffffffc0205e18 <default_pmm_manager+0x2b8>
                    cprintf("SWAP: failed to save\n");
ffffffffc02026ba:	00003b97          	auipc	s7,0x3
ffffffffc02026be:	746b8b93          	add	s7,s7,1862 # ffffffffc0205e00 <default_pmm_manager+0x2a0>
ffffffffc02026c2:	a825                	j	ffffffffc02026fa <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02026c4:	67a2                	ld	a5,8(sp)
ffffffffc02026c6:	8626                	mv	a2,s1
ffffffffc02026c8:	85a2                	mv	a1,s0
ffffffffc02026ca:	7f94                	ld	a3,56(a5)
ffffffffc02026cc:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc02026ce:	2405                	addw	s0,s0,1 # ffffffffffe00001 <end+0x3fbab501>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02026d0:	82b1                	srl	a3,a3,0xc
ffffffffc02026d2:	0685                	add	a3,a3,1
ffffffffc02026d4:	aaffd0ef          	jal	ffffffffc0200182 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc02026d8:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc02026da:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc02026dc:	7d1c                	ld	a5,56(a0)
ffffffffc02026de:	83b1                	srl	a5,a5,0xc
ffffffffc02026e0:	0785                	add	a5,a5,1
ffffffffc02026e2:	07a2                	sll	a5,a5,0x8
ffffffffc02026e4:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc02026e8:	d0eff0ef          	jal	ffffffffc0201bf6 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
ffffffffc02026ec:	01893503          	ld	a0,24(s2)
ffffffffc02026f0:	85a6                	mv	a1,s1
ffffffffc02026f2:	e3bff0ef          	jal	ffffffffc020252c <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc02026f6:	048a0d63          	beq	s4,s0,ffffffffc0202750 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc02026fa:	0009b783          	ld	a5,0(s3)
ffffffffc02026fe:	8656                	mv	a2,s5
ffffffffc0202700:	002c                	add	a1,sp,8
ffffffffc0202702:	7b9c                	ld	a5,48(a5)
ffffffffc0202704:	854a                	mv	a0,s2
ffffffffc0202706:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0202708:	e12d                	bnez	a0,ffffffffc020276a <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc020270a:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020270c:	01893503          	ld	a0,24(s2)
ffffffffc0202710:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0202712:	7f84                	ld	s1,56(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202714:	85a6                	mv	a1,s1
ffffffffc0202716:	eb8ff0ef          	jal	ffffffffc0201dce <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc020271a:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020271c:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc020271e:	8b85                	and	a5,a5,1
ffffffffc0202720:	cfb9                	beqz	a5,ffffffffc020277e <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0202722:	65a2                	ld	a1,8(sp)
ffffffffc0202724:	7d9c                	ld	a5,56(a1)
ffffffffc0202726:	83b1                	srl	a5,a5,0xc
ffffffffc0202728:	0785                	add	a5,a5,1
ffffffffc020272a:	00879513          	sll	a0,a5,0x8
ffffffffc020272e:	2b7000ef          	jal	ffffffffc02031e4 <swapfs_write>
ffffffffc0202732:	d949                	beqz	a0,ffffffffc02026c4 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202734:	855e                	mv	a0,s7
ffffffffc0202736:	a4dfd0ef          	jal	ffffffffc0200182 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc020273a:	0009b783          	ld	a5,0(s3)
ffffffffc020273e:	6622                	ld	a2,8(sp)
ffffffffc0202740:	4681                	li	a3,0
ffffffffc0202742:	739c                	ld	a5,32(a5)
ffffffffc0202744:	85a6                	mv	a1,s1
ffffffffc0202746:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0202748:	2405                	addw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc020274a:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc020274c:	fa8a17e3          	bne	s4,s0,ffffffffc02026fa <swap_out+0x70>
     }
     return i;
}
ffffffffc0202750:	60e6                	ld	ra,88(sp)
ffffffffc0202752:	8522                	mv	a0,s0
ffffffffc0202754:	6446                	ld	s0,80(sp)
ffffffffc0202756:	64a6                	ld	s1,72(sp)
ffffffffc0202758:	6906                	ld	s2,64(sp)
ffffffffc020275a:	79e2                	ld	s3,56(sp)
ffffffffc020275c:	7a42                	ld	s4,48(sp)
ffffffffc020275e:	7aa2                	ld	s5,40(sp)
ffffffffc0202760:	7b02                	ld	s6,32(sp)
ffffffffc0202762:	6be2                	ld	s7,24(sp)
ffffffffc0202764:	6c42                	ld	s8,16(sp)
ffffffffc0202766:	6125                	add	sp,sp,96
ffffffffc0202768:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc020276a:	85a2                	mv	a1,s0
ffffffffc020276c:	00003517          	auipc	a0,0x3
ffffffffc0202770:	64c50513          	add	a0,a0,1612 # ffffffffc0205db8 <default_pmm_manager+0x258>
ffffffffc0202774:	a0ffd0ef          	jal	ffffffffc0200182 <cprintf>
                  break;
ffffffffc0202778:	bfe1                	j	ffffffffc0202750 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc020277a:	4401                	li	s0,0
ffffffffc020277c:	bfd1                	j	ffffffffc0202750 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc020277e:	00003697          	auipc	a3,0x3
ffffffffc0202782:	66a68693          	add	a3,a3,1642 # ffffffffc0205de8 <default_pmm_manager+0x288>
ffffffffc0202786:	00003617          	auipc	a2,0x3
ffffffffc020278a:	d4260613          	add	a2,a2,-702 # ffffffffc02054c8 <commands+0x430>
ffffffffc020278e:	06800593          	li	a1,104
ffffffffc0202792:	00003517          	auipc	a0,0x3
ffffffffc0202796:	5fe50513          	add	a0,a0,1534 # ffffffffc0205d90 <default_pmm_manager+0x230>
ffffffffc020279a:	cd1fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc020279e <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
ffffffffc020279e:	7179                	add	sp,sp,-48
ffffffffc02027a0:	e84a                	sd	s2,16(sp)
ffffffffc02027a2:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc02027a4:	4505                	li	a0,1
{
ffffffffc02027a6:	ec26                	sd	s1,24(sp)
ffffffffc02027a8:	e44e                	sd	s3,8(sp)
ffffffffc02027aa:	f406                	sd	ra,40(sp)
ffffffffc02027ac:	f022                	sd	s0,32(sp)
ffffffffc02027ae:	84ae                	mv	s1,a1
ffffffffc02027b0:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc02027b2:	bb4ff0ef          	jal	ffffffffc0201b66 <alloc_pages>
     assert(result!=NULL);
ffffffffc02027b6:	c129                	beqz	a0,ffffffffc02027f8 <swap_in+0x5a>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc02027b8:	842a                	mv	s0,a0
ffffffffc02027ba:	01893503          	ld	a0,24(s2)
ffffffffc02027be:	4601                	li	a2,0
ffffffffc02027c0:	85a6                	mv	a1,s1
ffffffffc02027c2:	e0cff0ef          	jal	ffffffffc0201dce <get_pte>
ffffffffc02027c6:	892a                	mv	s2,a0
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc02027c8:	6108                	ld	a0,0(a0)
ffffffffc02027ca:	85a2                	mv	a1,s0
ffffffffc02027cc:	18b000ef          	jal	ffffffffc0203156 <swapfs_read>
     {
        assert(r!=0);
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc02027d0:	00093583          	ld	a1,0(s2)
ffffffffc02027d4:	8626                	mv	a2,s1
ffffffffc02027d6:	00003517          	auipc	a0,0x3
ffffffffc02027da:	69250513          	add	a0,a0,1682 # ffffffffc0205e68 <default_pmm_manager+0x308>
ffffffffc02027de:	81a1                	srl	a1,a1,0x8
ffffffffc02027e0:	9a3fd0ef          	jal	ffffffffc0200182 <cprintf>
     *ptr_result=result;
     return 0;
}
ffffffffc02027e4:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc02027e6:	0089b023          	sd	s0,0(s3)
}
ffffffffc02027ea:	7402                	ld	s0,32(sp)
ffffffffc02027ec:	64e2                	ld	s1,24(sp)
ffffffffc02027ee:	6942                	ld	s2,16(sp)
ffffffffc02027f0:	69a2                	ld	s3,8(sp)
ffffffffc02027f2:	4501                	li	a0,0
ffffffffc02027f4:	6145                	add	sp,sp,48
ffffffffc02027f6:	8082                	ret
     assert(result!=NULL);
ffffffffc02027f8:	00003697          	auipc	a3,0x3
ffffffffc02027fc:	66068693          	add	a3,a3,1632 # ffffffffc0205e58 <default_pmm_manager+0x2f8>
ffffffffc0202800:	00003617          	auipc	a2,0x3
ffffffffc0202804:	cc860613          	add	a2,a2,-824 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202808:	07e00593          	li	a1,126
ffffffffc020280c:	00003517          	auipc	a0,0x3
ffffffffc0202810:	58450513          	add	a0,a0,1412 # ffffffffc0205d90 <default_pmm_manager+0x230>
ffffffffc0202814:	c57fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202818 <_fifo_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc0202818:	0004e797          	auipc	a5,0x4e
ffffffffc020281c:	1f878793          	add	a5,a5,504 # ffffffffc0250a10 <pra_list_head>
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc0202820:	f51c                	sd	a5,40(a0)
ffffffffc0202822:	e79c                	sd	a5,8(a5)
ffffffffc0202824:	e39c                	sd	a5,0(a5)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc0202826:	4501                	li	a0,0
ffffffffc0202828:	8082                	ret

ffffffffc020282a <_fifo_init>:

static int
_fifo_init(void)
{
    return 0;
}
ffffffffc020282a:	4501                	li	a0,0
ffffffffc020282c:	8082                	ret

ffffffffc020282e <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc020282e:	4501                	li	a0,0
ffffffffc0202830:	8082                	ret

ffffffffc0202832 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc0202832:	4501                	li	a0,0
ffffffffc0202834:	8082                	ret

ffffffffc0202836 <_fifo_check_swap>:
_fifo_check_swap(void) {
ffffffffc0202836:	711d                	add	sp,sp,-96
ffffffffc0202838:	fc4e                	sd	s3,56(sp)
ffffffffc020283a:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc020283c:	00003517          	auipc	a0,0x3
ffffffffc0202840:	66c50513          	add	a0,a0,1644 # ffffffffc0205ea8 <default_pmm_manager+0x348>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0202844:	698d                	lui	s3,0x3
ffffffffc0202846:	4a31                	li	s4,12
_fifo_check_swap(void) {
ffffffffc0202848:	e4a6                	sd	s1,72(sp)
ffffffffc020284a:	ec86                	sd	ra,88(sp)
ffffffffc020284c:	e8a2                	sd	s0,80(sp)
ffffffffc020284e:	e0ca                	sd	s2,64(sp)
ffffffffc0202850:	f456                	sd	s5,40(sp)
ffffffffc0202852:	f05a                	sd	s6,32(sp)
ffffffffc0202854:	ec5e                	sd	s7,24(sp)
ffffffffc0202856:	e862                	sd	s8,16(sp)
ffffffffc0202858:	e466                	sd	s9,8(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc020285a:	929fd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc020285e:	01498023          	sb	s4,0(s3) # 3000 <_binary_obj___user_ex1_out_size-0x6bc8>
    assert(pgfault_num==4);
ffffffffc0202862:	00052497          	auipc	s1,0x52
ffffffffc0202866:	25e4a483          	lw	s1,606(s1) # ffffffffc0254ac0 <pgfault_num>
ffffffffc020286a:	4791                	li	a5,4
ffffffffc020286c:	14f49963          	bne	s1,a5,ffffffffc02029be <_fifo_check_swap+0x188>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202870:	00003517          	auipc	a0,0x3
ffffffffc0202874:	68850513          	add	a0,a0,1672 # ffffffffc0205ef8 <default_pmm_manager+0x398>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202878:	6a85                	lui	s5,0x1
ffffffffc020287a:	4b29                	li	s6,10
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc020287c:	907fd0ef          	jal	ffffffffc0200182 <cprintf>
ffffffffc0202880:	00052417          	auipc	s0,0x52
ffffffffc0202884:	24040413          	add	s0,s0,576 # ffffffffc0254ac0 <pgfault_num>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202888:	016a8023          	sb	s6,0(s5) # 1000 <_binary_obj___user_ex1_out_size-0x8bc8>
    assert(pgfault_num==4);
ffffffffc020288c:	401c                	lw	a5,0(s0)
ffffffffc020288e:	0007891b          	sext.w	s2,a5
ffffffffc0202892:	2a979663          	bne	a5,s1,ffffffffc0202b3e <_fifo_check_swap+0x308>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0202896:	00003517          	auipc	a0,0x3
ffffffffc020289a:	68a50513          	add	a0,a0,1674 # ffffffffc0205f20 <default_pmm_manager+0x3c0>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc020289e:	6b91                	lui	s7,0x4
ffffffffc02028a0:	4c35                	li	s8,13
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc02028a2:	8e1fd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02028a6:	018b8023          	sb	s8,0(s7) # 4000 <_binary_obj___user_ex1_out_size-0x5bc8>
    assert(pgfault_num==4);
ffffffffc02028aa:	401c                	lw	a5,0(s0)
ffffffffc02028ac:	00078c9b          	sext.w	s9,a5
ffffffffc02028b0:	27279763          	bne	a5,s2,ffffffffc0202b1e <_fifo_check_swap+0x2e8>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc02028b4:	00003517          	auipc	a0,0x3
ffffffffc02028b8:	69450513          	add	a0,a0,1684 # ffffffffc0205f48 <default_pmm_manager+0x3e8>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02028bc:	6489                	lui	s1,0x2
ffffffffc02028be:	492d                	li	s2,11
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc02028c0:	8c3fd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02028c4:	01248023          	sb	s2,0(s1) # 2000 <_binary_obj___user_ex1_out_size-0x7bc8>
    assert(pgfault_num==4);
ffffffffc02028c8:	401c                	lw	a5,0(s0)
ffffffffc02028ca:	23979a63          	bne	a5,s9,ffffffffc0202afe <_fifo_check_swap+0x2c8>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc02028ce:	00003517          	auipc	a0,0x3
ffffffffc02028d2:	6a250513          	add	a0,a0,1698 # ffffffffc0205f70 <default_pmm_manager+0x410>
ffffffffc02028d6:	8adfd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02028da:	6795                	lui	a5,0x5
ffffffffc02028dc:	4739                	li	a4,14
ffffffffc02028de:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_ex1_out_size-0x4bc8>
    assert(pgfault_num==5);
ffffffffc02028e2:	401c                	lw	a5,0(s0)
ffffffffc02028e4:	4715                	li	a4,5
ffffffffc02028e6:	00078c9b          	sext.w	s9,a5
ffffffffc02028ea:	1ee79a63          	bne	a5,a4,ffffffffc0202ade <_fifo_check_swap+0x2a8>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc02028ee:	00003517          	auipc	a0,0x3
ffffffffc02028f2:	65a50513          	add	a0,a0,1626 # ffffffffc0205f48 <default_pmm_manager+0x3e8>
ffffffffc02028f6:	88dfd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02028fa:	01248023          	sb	s2,0(s1)
    assert(pgfault_num==5);
ffffffffc02028fe:	401c                	lw	a5,0(s0)
ffffffffc0202900:	1b979f63          	bne	a5,s9,ffffffffc0202abe <_fifo_check_swap+0x288>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202904:	00003517          	auipc	a0,0x3
ffffffffc0202908:	5f450513          	add	a0,a0,1524 # ffffffffc0205ef8 <default_pmm_manager+0x398>
ffffffffc020290c:	877fd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202910:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc0202914:	4018                	lw	a4,0(s0)
ffffffffc0202916:	4799                	li	a5,6
ffffffffc0202918:	18f71363          	bne	a4,a5,ffffffffc0202a9e <_fifo_check_swap+0x268>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020291c:	00003517          	auipc	a0,0x3
ffffffffc0202920:	62c50513          	add	a0,a0,1580 # ffffffffc0205f48 <default_pmm_manager+0x3e8>
ffffffffc0202924:	85ffd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202928:	01248023          	sb	s2,0(s1)
    assert(pgfault_num==7);
ffffffffc020292c:	4018                	lw	a4,0(s0)
ffffffffc020292e:	479d                	li	a5,7
ffffffffc0202930:	14f71763          	bne	a4,a5,ffffffffc0202a7e <_fifo_check_swap+0x248>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0202934:	00003517          	auipc	a0,0x3
ffffffffc0202938:	57450513          	add	a0,a0,1396 # ffffffffc0205ea8 <default_pmm_manager+0x348>
ffffffffc020293c:	847fd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0202940:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc0202944:	4018                	lw	a4,0(s0)
ffffffffc0202946:	47a1                	li	a5,8
ffffffffc0202948:	10f71b63          	bne	a4,a5,ffffffffc0202a5e <_fifo_check_swap+0x228>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc020294c:	00003517          	auipc	a0,0x3
ffffffffc0202950:	5d450513          	add	a0,a0,1492 # ffffffffc0205f20 <default_pmm_manager+0x3c0>
ffffffffc0202954:	82ffd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202958:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc020295c:	4018                	lw	a4,0(s0)
ffffffffc020295e:	47a5                	li	a5,9
ffffffffc0202960:	0cf71f63          	bne	a4,a5,ffffffffc0202a3e <_fifo_check_swap+0x208>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc0202964:	00003517          	auipc	a0,0x3
ffffffffc0202968:	60c50513          	add	a0,a0,1548 # ffffffffc0205f70 <default_pmm_manager+0x410>
ffffffffc020296c:	817fd0ef          	jal	ffffffffc0200182 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0202970:	6795                	lui	a5,0x5
ffffffffc0202972:	4739                	li	a4,14
ffffffffc0202974:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_ex1_out_size-0x4bc8>
    assert(pgfault_num==10);
ffffffffc0202978:	401c                	lw	a5,0(s0)
ffffffffc020297a:	4729                	li	a4,10
ffffffffc020297c:	0007849b          	sext.w	s1,a5
ffffffffc0202980:	08e79f63          	bne	a5,a4,ffffffffc0202a1e <_fifo_check_swap+0x1e8>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202984:	00003517          	auipc	a0,0x3
ffffffffc0202988:	57450513          	add	a0,a0,1396 # ffffffffc0205ef8 <default_pmm_manager+0x398>
ffffffffc020298c:	ff6fd0ef          	jal	ffffffffc0200182 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202990:	6785                	lui	a5,0x1
ffffffffc0202992:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_obj___user_ex1_out_size-0x8bc8>
ffffffffc0202996:	06979463          	bne	a5,s1,ffffffffc02029fe <_fifo_check_swap+0x1c8>
    assert(pgfault_num==11);
ffffffffc020299a:	4018                	lw	a4,0(s0)
ffffffffc020299c:	47ad                	li	a5,11
ffffffffc020299e:	04f71063          	bne	a4,a5,ffffffffc02029de <_fifo_check_swap+0x1a8>
}
ffffffffc02029a2:	60e6                	ld	ra,88(sp)
ffffffffc02029a4:	6446                	ld	s0,80(sp)
ffffffffc02029a6:	64a6                	ld	s1,72(sp)
ffffffffc02029a8:	6906                	ld	s2,64(sp)
ffffffffc02029aa:	79e2                	ld	s3,56(sp)
ffffffffc02029ac:	7a42                	ld	s4,48(sp)
ffffffffc02029ae:	7aa2                	ld	s5,40(sp)
ffffffffc02029b0:	7b02                	ld	s6,32(sp)
ffffffffc02029b2:	6be2                	ld	s7,24(sp)
ffffffffc02029b4:	6c42                	ld	s8,16(sp)
ffffffffc02029b6:	6ca2                	ld	s9,8(sp)
ffffffffc02029b8:	4501                	li	a0,0
ffffffffc02029ba:	6125                	add	sp,sp,96
ffffffffc02029bc:	8082                	ret
    assert(pgfault_num==4);
ffffffffc02029be:	00003697          	auipc	a3,0x3
ffffffffc02029c2:	51268693          	add	a3,a3,1298 # ffffffffc0205ed0 <default_pmm_manager+0x370>
ffffffffc02029c6:	00003617          	auipc	a2,0x3
ffffffffc02029ca:	b0260613          	add	a2,a2,-1278 # ffffffffc02054c8 <commands+0x430>
ffffffffc02029ce:	05100593          	li	a1,81
ffffffffc02029d2:	00003517          	auipc	a0,0x3
ffffffffc02029d6:	50e50513          	add	a0,a0,1294 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc02029da:	a91fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==11);
ffffffffc02029de:	00003697          	auipc	a3,0x3
ffffffffc02029e2:	64268693          	add	a3,a3,1602 # ffffffffc0206020 <default_pmm_manager+0x4c0>
ffffffffc02029e6:	00003617          	auipc	a2,0x3
ffffffffc02029ea:	ae260613          	add	a2,a2,-1310 # ffffffffc02054c8 <commands+0x430>
ffffffffc02029ee:	07300593          	li	a1,115
ffffffffc02029f2:	00003517          	auipc	a0,0x3
ffffffffc02029f6:	4ee50513          	add	a0,a0,1262 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc02029fa:	a71fd0ef          	jal	ffffffffc020046a <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc02029fe:	00003697          	auipc	a3,0x3
ffffffffc0202a02:	5fa68693          	add	a3,a3,1530 # ffffffffc0205ff8 <default_pmm_manager+0x498>
ffffffffc0202a06:	00003617          	auipc	a2,0x3
ffffffffc0202a0a:	ac260613          	add	a2,a2,-1342 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202a0e:	07100593          	li	a1,113
ffffffffc0202a12:	00003517          	auipc	a0,0x3
ffffffffc0202a16:	4ce50513          	add	a0,a0,1230 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202a1a:	a51fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==10);
ffffffffc0202a1e:	00003697          	auipc	a3,0x3
ffffffffc0202a22:	5ca68693          	add	a3,a3,1482 # ffffffffc0205fe8 <default_pmm_manager+0x488>
ffffffffc0202a26:	00003617          	auipc	a2,0x3
ffffffffc0202a2a:	aa260613          	add	a2,a2,-1374 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202a2e:	06f00593          	li	a1,111
ffffffffc0202a32:	00003517          	auipc	a0,0x3
ffffffffc0202a36:	4ae50513          	add	a0,a0,1198 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202a3a:	a31fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==9);
ffffffffc0202a3e:	00003697          	auipc	a3,0x3
ffffffffc0202a42:	59a68693          	add	a3,a3,1434 # ffffffffc0205fd8 <default_pmm_manager+0x478>
ffffffffc0202a46:	00003617          	auipc	a2,0x3
ffffffffc0202a4a:	a8260613          	add	a2,a2,-1406 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202a4e:	06c00593          	li	a1,108
ffffffffc0202a52:	00003517          	auipc	a0,0x3
ffffffffc0202a56:	48e50513          	add	a0,a0,1166 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202a5a:	a11fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==8);
ffffffffc0202a5e:	00003697          	auipc	a3,0x3
ffffffffc0202a62:	56a68693          	add	a3,a3,1386 # ffffffffc0205fc8 <default_pmm_manager+0x468>
ffffffffc0202a66:	00003617          	auipc	a2,0x3
ffffffffc0202a6a:	a6260613          	add	a2,a2,-1438 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202a6e:	06900593          	li	a1,105
ffffffffc0202a72:	00003517          	auipc	a0,0x3
ffffffffc0202a76:	46e50513          	add	a0,a0,1134 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202a7a:	9f1fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==7);
ffffffffc0202a7e:	00003697          	auipc	a3,0x3
ffffffffc0202a82:	53a68693          	add	a3,a3,1338 # ffffffffc0205fb8 <default_pmm_manager+0x458>
ffffffffc0202a86:	00003617          	auipc	a2,0x3
ffffffffc0202a8a:	a4260613          	add	a2,a2,-1470 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202a8e:	06600593          	li	a1,102
ffffffffc0202a92:	00003517          	auipc	a0,0x3
ffffffffc0202a96:	44e50513          	add	a0,a0,1102 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202a9a:	9d1fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==6);
ffffffffc0202a9e:	00003697          	auipc	a3,0x3
ffffffffc0202aa2:	50a68693          	add	a3,a3,1290 # ffffffffc0205fa8 <default_pmm_manager+0x448>
ffffffffc0202aa6:	00003617          	auipc	a2,0x3
ffffffffc0202aaa:	a2260613          	add	a2,a2,-1502 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202aae:	06300593          	li	a1,99
ffffffffc0202ab2:	00003517          	auipc	a0,0x3
ffffffffc0202ab6:	42e50513          	add	a0,a0,1070 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202aba:	9b1fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==5);
ffffffffc0202abe:	00003697          	auipc	a3,0x3
ffffffffc0202ac2:	4da68693          	add	a3,a3,1242 # ffffffffc0205f98 <default_pmm_manager+0x438>
ffffffffc0202ac6:	00003617          	auipc	a2,0x3
ffffffffc0202aca:	a0260613          	add	a2,a2,-1534 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202ace:	06000593          	li	a1,96
ffffffffc0202ad2:	00003517          	auipc	a0,0x3
ffffffffc0202ad6:	40e50513          	add	a0,a0,1038 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202ada:	991fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==5);
ffffffffc0202ade:	00003697          	auipc	a3,0x3
ffffffffc0202ae2:	4ba68693          	add	a3,a3,1210 # ffffffffc0205f98 <default_pmm_manager+0x438>
ffffffffc0202ae6:	00003617          	auipc	a2,0x3
ffffffffc0202aea:	9e260613          	add	a2,a2,-1566 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202aee:	05d00593          	li	a1,93
ffffffffc0202af2:	00003517          	auipc	a0,0x3
ffffffffc0202af6:	3ee50513          	add	a0,a0,1006 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202afa:	971fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==4);
ffffffffc0202afe:	00003697          	auipc	a3,0x3
ffffffffc0202b02:	3d268693          	add	a3,a3,978 # ffffffffc0205ed0 <default_pmm_manager+0x370>
ffffffffc0202b06:	00003617          	auipc	a2,0x3
ffffffffc0202b0a:	9c260613          	add	a2,a2,-1598 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202b0e:	05a00593          	li	a1,90
ffffffffc0202b12:	00003517          	auipc	a0,0x3
ffffffffc0202b16:	3ce50513          	add	a0,a0,974 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202b1a:	951fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==4);
ffffffffc0202b1e:	00003697          	auipc	a3,0x3
ffffffffc0202b22:	3b268693          	add	a3,a3,946 # ffffffffc0205ed0 <default_pmm_manager+0x370>
ffffffffc0202b26:	00003617          	auipc	a2,0x3
ffffffffc0202b2a:	9a260613          	add	a2,a2,-1630 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202b2e:	05700593          	li	a1,87
ffffffffc0202b32:	00003517          	auipc	a0,0x3
ffffffffc0202b36:	3ae50513          	add	a0,a0,942 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202b3a:	931fd0ef          	jal	ffffffffc020046a <__panic>
    assert(pgfault_num==4);
ffffffffc0202b3e:	00003697          	auipc	a3,0x3
ffffffffc0202b42:	39268693          	add	a3,a3,914 # ffffffffc0205ed0 <default_pmm_manager+0x370>
ffffffffc0202b46:	00003617          	auipc	a2,0x3
ffffffffc0202b4a:	98260613          	add	a2,a2,-1662 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202b4e:	05400593          	li	a1,84
ffffffffc0202b52:	00003517          	auipc	a0,0x3
ffffffffc0202b56:	38e50513          	add	a0,a0,910 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202b5a:	911fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202b5e <_fifo_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0202b5e:	751c                	ld	a5,40(a0)
{
ffffffffc0202b60:	1141                	add	sp,sp,-16
ffffffffc0202b62:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc0202b64:	cf91                	beqz	a5,ffffffffc0202b80 <_fifo_swap_out_victim+0x22>
     assert(in_tick==0);
ffffffffc0202b66:	ee0d                	bnez	a2,ffffffffc0202ba0 <_fifo_swap_out_victim+0x42>
    return listelm->next;
ffffffffc0202b68:	679c                	ld	a5,8(a5)
}
ffffffffc0202b6a:	60a2                	ld	ra,8(sp)
ffffffffc0202b6c:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0202b6e:	6394                	ld	a3,0(a5)
ffffffffc0202b70:	6798                	ld	a4,8(a5)
    *ptr_page = le2page(entry, pra_page_link);
ffffffffc0202b72:	fd878793          	add	a5,a5,-40
    prev->next = next;
ffffffffc0202b76:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0202b78:	e314                	sd	a3,0(a4)
ffffffffc0202b7a:	e19c                	sd	a5,0(a1)
}
ffffffffc0202b7c:	0141                	add	sp,sp,16
ffffffffc0202b7e:	8082                	ret
         assert(head != NULL);
ffffffffc0202b80:	00003697          	auipc	a3,0x3
ffffffffc0202b84:	4b068693          	add	a3,a3,1200 # ffffffffc0206030 <default_pmm_manager+0x4d0>
ffffffffc0202b88:	00003617          	auipc	a2,0x3
ffffffffc0202b8c:	94060613          	add	a2,a2,-1728 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202b90:	04100593          	li	a1,65
ffffffffc0202b94:	00003517          	auipc	a0,0x3
ffffffffc0202b98:	34c50513          	add	a0,a0,844 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202b9c:	8cffd0ef          	jal	ffffffffc020046a <__panic>
     assert(in_tick==0);
ffffffffc0202ba0:	00003697          	auipc	a3,0x3
ffffffffc0202ba4:	4a068693          	add	a3,a3,1184 # ffffffffc0206040 <default_pmm_manager+0x4e0>
ffffffffc0202ba8:	00003617          	auipc	a2,0x3
ffffffffc0202bac:	92060613          	add	a2,a2,-1760 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202bb0:	04200593          	li	a1,66
ffffffffc0202bb4:	00003517          	auipc	a0,0x3
ffffffffc0202bb8:	32c50513          	add	a0,a0,812 # ffffffffc0205ee0 <default_pmm_manager+0x380>
ffffffffc0202bbc:	8affd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202bc0 <_fifo_map_swappable>:
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0202bc0:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc0202bc2:	cb91                	beqz	a5,ffffffffc0202bd6 <_fifo_map_swappable+0x16>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202bc4:	6394                	ld	a3,0(a5)
ffffffffc0202bc6:	02860713          	add	a4,a2,40
    prev->next = next->prev = elm;
ffffffffc0202bca:	e398                	sd	a4,0(a5)
ffffffffc0202bcc:	e698                	sd	a4,8(a3)
}
ffffffffc0202bce:	4501                	li	a0,0
    elm->next = next;
ffffffffc0202bd0:	fa1c                	sd	a5,48(a2)
    elm->prev = prev;
ffffffffc0202bd2:	f614                	sd	a3,40(a2)
ffffffffc0202bd4:	8082                	ret
{
ffffffffc0202bd6:	1141                	add	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc0202bd8:	00003697          	auipc	a3,0x3
ffffffffc0202bdc:	47868693          	add	a3,a3,1144 # ffffffffc0206050 <default_pmm_manager+0x4f0>
ffffffffc0202be0:	00003617          	auipc	a2,0x3
ffffffffc0202be4:	8e860613          	add	a2,a2,-1816 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202be8:	03200593          	li	a1,50
ffffffffc0202bec:	00003517          	auipc	a0,0x3
ffffffffc0202bf0:	2f450513          	add	a0,a0,756 # ffffffffc0205ee0 <default_pmm_manager+0x380>
{
ffffffffc0202bf4:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc0202bf6:	875fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202bfa <check_vma_overlap.part.0>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202bfa:	1141                	add	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202bfc:	00003697          	auipc	a3,0x3
ffffffffc0202c00:	48c68693          	add	a3,a3,1164 # ffffffffc0206088 <default_pmm_manager+0x528>
ffffffffc0202c04:	00003617          	auipc	a2,0x3
ffffffffc0202c08:	8c460613          	add	a2,a2,-1852 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202c0c:	06d00593          	li	a1,109
ffffffffc0202c10:	00003517          	auipc	a0,0x3
ffffffffc0202c14:	49850513          	add	a0,a0,1176 # ffffffffc02060a8 <default_pmm_manager+0x548>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202c18:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202c1a:	851fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202c1e <mm_create>:
mm_create(void) {
ffffffffc0202c1e:	1141                	add	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202c20:	04000513          	li	a0,64
mm_create(void) {
ffffffffc0202c24:	e022                	sd	s0,0(sp)
ffffffffc0202c26:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202c28:	d8dfe0ef          	jal	ffffffffc02019b4 <kmalloc>
ffffffffc0202c2c:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0202c2e:	c505                	beqz	a0,ffffffffc0202c56 <mm_create+0x38>
    elm->prev = elm->next = elm;
ffffffffc0202c30:	e408                	sd	a0,8(s0)
ffffffffc0202c32:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0202c34:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202c38:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202c3c:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0202c40:	00052797          	auipc	a5,0x52
ffffffffc0202c44:	e687a783          	lw	a5,-408(a5) # ffffffffc0254aa8 <swap_init_ok>
ffffffffc0202c48:	ef81                	bnez	a5,ffffffffc0202c60 <mm_create+0x42>
        else mm->sm_priv = NULL;
ffffffffc0202c4a:	02053423          	sd	zero,40(a0)
    return mm->mm_count;
}

static inline void
set_mm_count(struct mm_struct *mm, int val) {
    mm->mm_count = val;
ffffffffc0202c4e:	02042823          	sw	zero,48(s0)

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
    *lock = 0;
ffffffffc0202c52:	02043c23          	sd	zero,56(s0)
}
ffffffffc0202c56:	60a2                	ld	ra,8(sp)
ffffffffc0202c58:	8522                	mv	a0,s0
ffffffffc0202c5a:	6402                	ld	s0,0(sp)
ffffffffc0202c5c:	0141                	add	sp,sp,16
ffffffffc0202c5e:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0202c60:	a13ff0ef          	jal	ffffffffc0202672 <swap_init_mm>
ffffffffc0202c64:	b7ed                	j	ffffffffc0202c4e <mm_create+0x30>

ffffffffc0202c66 <find_vma>:
find_vma(struct mm_struct *mm, uintptr_t addr) {
ffffffffc0202c66:	86aa                	mv	a3,a0
    if (mm != NULL) {
ffffffffc0202c68:	c505                	beqz	a0,ffffffffc0202c90 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0202c6a:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202c6c:	c501                	beqz	a0,ffffffffc0202c74 <find_vma+0xe>
ffffffffc0202c6e:	651c                	ld	a5,8(a0)
ffffffffc0202c70:	02f5f663          	bgeu	a1,a5,ffffffffc0202c9c <find_vma+0x36>
    return listelm->next;
ffffffffc0202c74:	669c                	ld	a5,8(a3)
                while ((le = list_next(le)) != list) {
ffffffffc0202c76:	00f68d63          	beq	a3,a5,ffffffffc0202c90 <find_vma+0x2a>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0202c7a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202c7e:	00e5e663          	bltu	a1,a4,ffffffffc0202c8a <find_vma+0x24>
ffffffffc0202c82:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202c86:	00e5e763          	bltu	a1,a4,ffffffffc0202c94 <find_vma+0x2e>
ffffffffc0202c8a:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0202c8c:	fef697e3          	bne	a3,a5,ffffffffc0202c7a <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0202c90:	4501                	li	a0,0
}
ffffffffc0202c92:	8082                	ret
                    vma = le2vma(le, list_link);
ffffffffc0202c94:	fe078513          	add	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202c98:	ea88                	sd	a0,16(a3)
ffffffffc0202c9a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202c9c:	691c                	ld	a5,16(a0)
ffffffffc0202c9e:	fcf5fbe3          	bgeu	a1,a5,ffffffffc0202c74 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0202ca2:	ea88                	sd	a0,16(a3)
ffffffffc0202ca4:	8082                	ret

ffffffffc0202ca6 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202ca6:	6590                	ld	a2,8(a1)
ffffffffc0202ca8:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0202cac:	1141                	add	sp,sp,-16
ffffffffc0202cae:	e406                	sd	ra,8(sp)
ffffffffc0202cb0:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202cb2:	01066763          	bltu	a2,a6,ffffffffc0202cc0 <insert_vma_struct+0x1a>
ffffffffc0202cb6:	a085                	j	ffffffffc0202d16 <insert_vma_struct+0x70>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202cb8:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202cbc:	04e66863          	bltu	a2,a4,ffffffffc0202d0c <insert_vma_struct+0x66>
ffffffffc0202cc0:	86be                	mv	a3,a5
ffffffffc0202cc2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0202cc4:	fef51ae3          	bne	a0,a5,ffffffffc0202cb8 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0202cc8:	02a68463          	beq	a3,a0,ffffffffc0202cf0 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202ccc:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202cd0:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202cd4:	08e8f163          	bgeu	a7,a4,ffffffffc0202d56 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202cd8:	04e66f63          	bltu	a2,a4,ffffffffc0202d36 <insert_vma_struct+0x90>
    }
    if (le_next != list) {
ffffffffc0202cdc:	00f50a63          	beq	a0,a5,ffffffffc0202cf0 <insert_vma_struct+0x4a>
ffffffffc0202ce0:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202ce4:	05076963          	bltu	a4,a6,ffffffffc0202d36 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0202ce8:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202cec:	02c77363          	bgeu	a4,a2,ffffffffc0202d12 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0202cf0:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202cf2:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202cf4:	02058613          	add	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202cf8:	e390                	sd	a2,0(a5)
ffffffffc0202cfa:	e690                	sd	a2,8(a3)
}
ffffffffc0202cfc:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202cfe:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202d00:	f194                	sd	a3,32(a1)
    mm->map_count ++;
ffffffffc0202d02:	0017079b          	addw	a5,a4,1
ffffffffc0202d06:	d11c                	sw	a5,32(a0)
}
ffffffffc0202d08:	0141                	add	sp,sp,16
ffffffffc0202d0a:	8082                	ret
    if (le_prev != list) {
ffffffffc0202d0c:	fca690e3          	bne	a3,a0,ffffffffc0202ccc <insert_vma_struct+0x26>
ffffffffc0202d10:	bfd1                	j	ffffffffc0202ce4 <insert_vma_struct+0x3e>
ffffffffc0202d12:	ee9ff0ef          	jal	ffffffffc0202bfa <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202d16:	00003697          	auipc	a3,0x3
ffffffffc0202d1a:	3a268693          	add	a3,a3,930 # ffffffffc02060b8 <default_pmm_manager+0x558>
ffffffffc0202d1e:	00002617          	auipc	a2,0x2
ffffffffc0202d22:	7aa60613          	add	a2,a2,1962 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202d26:	07400593          	li	a1,116
ffffffffc0202d2a:	00003517          	auipc	a0,0x3
ffffffffc0202d2e:	37e50513          	add	a0,a0,894 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202d32:	f38fd0ef          	jal	ffffffffc020046a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202d36:	00003697          	auipc	a3,0x3
ffffffffc0202d3a:	3c268693          	add	a3,a3,962 # ffffffffc02060f8 <default_pmm_manager+0x598>
ffffffffc0202d3e:	00002617          	auipc	a2,0x2
ffffffffc0202d42:	78a60613          	add	a2,a2,1930 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202d46:	06c00593          	li	a1,108
ffffffffc0202d4a:	00003517          	auipc	a0,0x3
ffffffffc0202d4e:	35e50513          	add	a0,a0,862 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202d52:	f18fd0ef          	jal	ffffffffc020046a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202d56:	00003697          	auipc	a3,0x3
ffffffffc0202d5a:	38268693          	add	a3,a3,898 # ffffffffc02060d8 <default_pmm_manager+0x578>
ffffffffc0202d5e:	00002617          	auipc	a2,0x2
ffffffffc0202d62:	76a60613          	add	a2,a2,1898 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202d66:	06b00593          	li	a1,107
ffffffffc0202d6a:	00003517          	auipc	a0,0x3
ffffffffc0202d6e:	33e50513          	add	a0,a0,830 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202d72:	ef8fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202d76 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);
ffffffffc0202d76:	591c                	lw	a5,48(a0)
mm_destroy(struct mm_struct *mm) {
ffffffffc0202d78:	1141                	add	sp,sp,-16
ffffffffc0202d7a:	e406                	sd	ra,8(sp)
ffffffffc0202d7c:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0202d7e:	e78d                	bnez	a5,ffffffffc0202da8 <mm_destroy+0x32>
ffffffffc0202d80:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0202d82:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0202d84:	00a40c63          	beq	s0,a0,ffffffffc0202d9c <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202d88:	6118                	ld	a4,0(a0)
ffffffffc0202d8a:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0202d8c:	1501                	add	a0,a0,-32
    prev->next = next;
ffffffffc0202d8e:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202d90:	e398                	sd	a4,0(a5)
ffffffffc0202d92:	cc3fe0ef          	jal	ffffffffc0201a54 <kfree>
    return listelm->next;
ffffffffc0202d96:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0202d98:	fea418e3          	bne	s0,a0,ffffffffc0202d88 <mm_destroy+0x12>
    }
    kfree(mm); //kfree mm
ffffffffc0202d9c:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0202d9e:	6402                	ld	s0,0(sp)
ffffffffc0202da0:	60a2                	ld	ra,8(sp)
ffffffffc0202da2:	0141                	add	sp,sp,16
    kfree(mm); //kfree mm
ffffffffc0202da4:	cb1fe06f          	j	ffffffffc0201a54 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0202da8:	00003697          	auipc	a3,0x3
ffffffffc0202dac:	37068693          	add	a3,a3,880 # ffffffffc0206118 <default_pmm_manager+0x5b8>
ffffffffc0202db0:	00002617          	auipc	a2,0x2
ffffffffc0202db4:	71860613          	add	a2,a2,1816 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202db8:	09400593          	li	a1,148
ffffffffc0202dbc:	00003517          	auipc	a0,0x3
ffffffffc0202dc0:	2ec50513          	add	a0,a0,748 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202dc4:	ea6fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202dc8 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202dc8:	6785                	lui	a5,0x1
ffffffffc0202dca:	17fd                	add	a5,a5,-1 # fff <_binary_obj___user_ex1_out_size-0x8bc9>
       struct vma_struct **vma_store) {
ffffffffc0202dcc:	7139                	add	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202dce:	787d                	lui	a6,0xfffff
ffffffffc0202dd0:	963e                	add	a2,a2,a5
       struct vma_struct **vma_store) {
ffffffffc0202dd2:	f822                	sd	s0,48(sp)
ffffffffc0202dd4:	f426                	sd	s1,40(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202dd6:	962e                	add	a2,a2,a1
       struct vma_struct **vma_store) {
ffffffffc0202dd8:	fc06                	sd	ra,56(sp)
ffffffffc0202dda:	f04a                	sd	s2,32(sp)
ffffffffc0202ddc:	ec4e                	sd	s3,24(sp)
ffffffffc0202dde:	e852                	sd	s4,16(sp)
ffffffffc0202de0:	e456                	sd	s5,8(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202de2:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end)) {
ffffffffc0202de6:	002007b7          	lui	a5,0x200
ffffffffc0202dea:	01067433          	and	s0,a2,a6
ffffffffc0202dee:	06f4e363          	bltu	s1,a5,ffffffffc0202e54 <mm_map+0x8c>
ffffffffc0202df2:	0684f163          	bgeu	s1,s0,ffffffffc0202e54 <mm_map+0x8c>
ffffffffc0202df6:	4785                	li	a5,1
ffffffffc0202df8:	07fe                	sll	a5,a5,0x1f
ffffffffc0202dfa:	0487ed63          	bltu	a5,s0,ffffffffc0202e54 <mm_map+0x8c>
ffffffffc0202dfe:	89aa                	mv	s3,a0
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0202e00:	cd21                	beqz	a0,ffffffffc0202e58 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
ffffffffc0202e02:	85a6                	mv	a1,s1
ffffffffc0202e04:	8ab6                	mv	s5,a3
ffffffffc0202e06:	8a3a                	mv	s4,a4
ffffffffc0202e08:	e5fff0ef          	jal	ffffffffc0202c66 <find_vma>
ffffffffc0202e0c:	c501                	beqz	a0,ffffffffc0202e14 <mm_map+0x4c>
ffffffffc0202e0e:	651c                	ld	a5,8(a0)
ffffffffc0202e10:	0487e263          	bltu	a5,s0,ffffffffc0202e54 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202e14:	03000513          	li	a0,48
ffffffffc0202e18:	b9dfe0ef          	jal	ffffffffc02019b4 <kmalloc>
ffffffffc0202e1c:	892a                	mv	s2,a0
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0202e1e:	5571                	li	a0,-4
    if (vma != NULL) {
ffffffffc0202e20:	02090163          	beqz	s2,ffffffffc0202e42 <mm_map+0x7a>
        vma->vm_start = vm_start;
ffffffffc0202e24:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0202e28:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0202e2c:	01592c23          	sw	s5,24(s2)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0202e30:	85ca                	mv	a1,s2
ffffffffc0202e32:	854e                	mv	a0,s3
ffffffffc0202e34:	e73ff0ef          	jal	ffffffffc0202ca6 <insert_vma_struct>
    if (vma_store != NULL) {
ffffffffc0202e38:	000a0463          	beqz	s4,ffffffffc0202e40 <mm_map+0x78>
        *vma_store = vma;
ffffffffc0202e3c:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_ex1_out_size-0x8bc8>
    }
    ret = 0;
ffffffffc0202e40:	4501                	li	a0,0

out:
    return ret;
}
ffffffffc0202e42:	70e2                	ld	ra,56(sp)
ffffffffc0202e44:	7442                	ld	s0,48(sp)
ffffffffc0202e46:	74a2                	ld	s1,40(sp)
ffffffffc0202e48:	7902                	ld	s2,32(sp)
ffffffffc0202e4a:	69e2                	ld	s3,24(sp)
ffffffffc0202e4c:	6a42                	ld	s4,16(sp)
ffffffffc0202e4e:	6aa2                	ld	s5,8(sp)
ffffffffc0202e50:	6121                	add	sp,sp,64
ffffffffc0202e52:	8082                	ret
        return -E_INVAL;
ffffffffc0202e54:	5575                	li	a0,-3
ffffffffc0202e56:	b7f5                	j	ffffffffc0202e42 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0202e58:	00003697          	auipc	a3,0x3
ffffffffc0202e5c:	2d868693          	add	a3,a3,728 # ffffffffc0206130 <default_pmm_manager+0x5d0>
ffffffffc0202e60:	00002617          	auipc	a2,0x2
ffffffffc0202e64:	66860613          	add	a2,a2,1640 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202e68:	0a700593          	li	a1,167
ffffffffc0202e6c:	00003517          	auipc	a0,0x3
ffffffffc0202e70:	23c50513          	add	a0,a0,572 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202e74:	df6fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202e78 <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
ffffffffc0202e78:	7139                	add	sp,sp,-64
ffffffffc0202e7a:	fc06                	sd	ra,56(sp)
ffffffffc0202e7c:	f822                	sd	s0,48(sp)
ffffffffc0202e7e:	f426                	sd	s1,40(sp)
ffffffffc0202e80:	f04a                	sd	s2,32(sp)
ffffffffc0202e82:	ec4e                	sd	s3,24(sp)
ffffffffc0202e84:	e852                	sd	s4,16(sp)
ffffffffc0202e86:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0202e88:	c525                	beqz	a0,ffffffffc0202ef0 <dup_mmap+0x78>
ffffffffc0202e8a:	892a                	mv	s2,a0
ffffffffc0202e8c:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0202e8e:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0202e90:	c1a5                	beqz	a1,ffffffffc0202ef0 <dup_mmap+0x78>
    return listelm->prev;
ffffffffc0202e92:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list) {
ffffffffc0202e94:	04848c63          	beq	s1,s0,ffffffffc0202eec <dup_mmap+0x74>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202e98:	03000513          	li	a0,48
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0202e9c:	fe843a83          	ld	s5,-24(s0)
ffffffffc0202ea0:	ff043a03          	ld	s4,-16(s0)
ffffffffc0202ea4:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202ea8:	b0dfe0ef          	jal	ffffffffc02019b4 <kmalloc>
ffffffffc0202eac:	85aa                	mv	a1,a0
    if (vma != NULL) {
ffffffffc0202eae:	c50d                	beqz	a0,ffffffffc0202ed8 <dup_mmap+0x60>
        if (nvma == NULL) {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0202eb0:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0202eb2:	0155b423          	sd	s5,8(a1)
ffffffffc0202eb6:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0202eba:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0202ebe:	de9ff0ef          	jal	ffffffffc0202ca6 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
ffffffffc0202ec2:	ff043683          	ld	a3,-16(s0)
ffffffffc0202ec6:	fe843603          	ld	a2,-24(s0)
ffffffffc0202eca:	6c8c                	ld	a1,24(s1)
ffffffffc0202ecc:	01893503          	ld	a0,24(s2)
ffffffffc0202ed0:	4701                	li	a4,0
ffffffffc0202ed2:	c2aff0ef          	jal	ffffffffc02022fc <copy_range>
ffffffffc0202ed6:	dd55                	beqz	a0,ffffffffc0202e92 <dup_mmap+0x1a>
            return -E_NO_MEM;
ffffffffc0202ed8:	5571                	li	a0,-4
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0202eda:	70e2                	ld	ra,56(sp)
ffffffffc0202edc:	7442                	ld	s0,48(sp)
ffffffffc0202ede:	74a2                	ld	s1,40(sp)
ffffffffc0202ee0:	7902                	ld	s2,32(sp)
ffffffffc0202ee2:	69e2                	ld	s3,24(sp)
ffffffffc0202ee4:	6a42                	ld	s4,16(sp)
ffffffffc0202ee6:	6aa2                	ld	s5,8(sp)
ffffffffc0202ee8:	6121                	add	sp,sp,64
ffffffffc0202eea:	8082                	ret
    return 0;
ffffffffc0202eec:	4501                	li	a0,0
ffffffffc0202eee:	b7f5                	j	ffffffffc0202eda <dup_mmap+0x62>
    assert(to != NULL && from != NULL);
ffffffffc0202ef0:	00003697          	auipc	a3,0x3
ffffffffc0202ef4:	25068693          	add	a3,a3,592 # ffffffffc0206140 <default_pmm_manager+0x5e0>
ffffffffc0202ef8:	00002617          	auipc	a2,0x2
ffffffffc0202efc:	5d060613          	add	a2,a2,1488 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202f00:	0c000593          	li	a1,192
ffffffffc0202f04:	00003517          	auipc	a0,0x3
ffffffffc0202f08:	1a450513          	add	a0,a0,420 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202f0c:	d5efd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202f10 <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
ffffffffc0202f10:	1101                	add	sp,sp,-32
ffffffffc0202f12:	ec06                	sd	ra,24(sp)
ffffffffc0202f14:	e822                	sd	s0,16(sp)
ffffffffc0202f16:	e426                	sd	s1,8(sp)
ffffffffc0202f18:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202f1a:	c531                	beqz	a0,ffffffffc0202f66 <exit_mmap+0x56>
ffffffffc0202f1c:	591c                	lw	a5,48(a0)
ffffffffc0202f1e:	84aa                	mv	s1,a0
ffffffffc0202f20:	e3b9                	bnez	a5,ffffffffc0202f66 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0202f22:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0202f24:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
ffffffffc0202f28:	02850663          	beq	a0,s0,ffffffffc0202f54 <exit_mmap+0x44>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202f2c:	ff043603          	ld	a2,-16(s0)
ffffffffc0202f30:	fe843583          	ld	a1,-24(s0)
ffffffffc0202f34:	854a                	mv	a0,s2
ffffffffc0202f36:	868ff0ef          	jal	ffffffffc0201f9e <unmap_range>
ffffffffc0202f3a:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0202f3c:	fe8498e3          	bne	s1,s0,ffffffffc0202f2c <exit_mmap+0x1c>
ffffffffc0202f40:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list) {
ffffffffc0202f42:	00848c63          	beq	s1,s0,ffffffffc0202f5a <exit_mmap+0x4a>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202f46:	ff043603          	ld	a2,-16(s0)
ffffffffc0202f4a:	fe843583          	ld	a1,-24(s0)
ffffffffc0202f4e:	854a                	mv	a0,s2
ffffffffc0202f50:	97cff0ef          	jal	ffffffffc02020cc <exit_range>
ffffffffc0202f54:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0202f56:	fe8498e3          	bne	s1,s0,ffffffffc0202f46 <exit_mmap+0x36>
    }
}
ffffffffc0202f5a:	60e2                	ld	ra,24(sp)
ffffffffc0202f5c:	6442                	ld	s0,16(sp)
ffffffffc0202f5e:	64a2                	ld	s1,8(sp)
ffffffffc0202f60:	6902                	ld	s2,0(sp)
ffffffffc0202f62:	6105                	add	sp,sp,32
ffffffffc0202f64:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202f66:	00003697          	auipc	a3,0x3
ffffffffc0202f6a:	1fa68693          	add	a3,a3,506 # ffffffffc0206160 <default_pmm_manager+0x600>
ffffffffc0202f6e:	00002617          	auipc	a2,0x2
ffffffffc0202f72:	55a60613          	add	a2,a2,1370 # ffffffffc02054c8 <commands+0x430>
ffffffffc0202f76:	0d600593          	li	a1,214
ffffffffc0202f7a:	00003517          	auipc	a0,0x3
ffffffffc0202f7e:	12e50513          	add	a0,a0,302 # ffffffffc02060a8 <default_pmm_manager+0x548>
ffffffffc0202f82:	ce8fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0202f86 <vmm_init>:
// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
    //check_vmm();
}
ffffffffc0202f86:	8082                	ret

ffffffffc0202f88 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0202f88:	7139                	add	sp,sp,-64
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0202f8a:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc0202f8c:	f822                	sd	s0,48(sp)
ffffffffc0202f8e:	f426                	sd	s1,40(sp)
ffffffffc0202f90:	fc06                	sd	ra,56(sp)
ffffffffc0202f92:	f04a                	sd	s2,32(sp)
ffffffffc0202f94:	ec4e                	sd	s3,24(sp)
ffffffffc0202f96:	8432                	mv	s0,a2
ffffffffc0202f98:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0202f9a:	ccdff0ef          	jal	ffffffffc0202c66 <find_vma>

    pgfault_num++;
ffffffffc0202f9e:	00052797          	auipc	a5,0x52
ffffffffc0202fa2:	b227a783          	lw	a5,-1246(a5) # ffffffffc0254ac0 <pgfault_num>
ffffffffc0202fa6:	2785                	addw	a5,a5,1
ffffffffc0202fa8:	00052717          	auipc	a4,0x52
ffffffffc0202fac:	b0f72c23          	sw	a5,-1256(a4) # ffffffffc0254ac0 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc0202fb0:	c545                	beqz	a0,ffffffffc0203058 <do_pgfault+0xd0>
ffffffffc0202fb2:	651c                	ld	a5,8(a0)
ffffffffc0202fb4:	0af46263          	bltu	s0,a5,ffffffffc0203058 <do_pgfault+0xd0>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0202fb8:	4d1c                	lw	a5,24(a0)
        perm |= READ_WRITE;
ffffffffc0202fba:	49dd                	li	s3,23
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0202fbc:	8b89                	and	a5,a5,2
ffffffffc0202fbe:	cfb9                	beqz	a5,ffffffffc020301c <do_pgfault+0x94>
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0202fc0:	77fd                	lui	a5,0xfffff
    *   mm->pgdir : the PDT of these vma
    *
    */
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0202fc2:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0202fc4:	8c7d                	and	s0,s0,a5
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0202fc6:	4605                	li	a2,1
ffffffffc0202fc8:	85a2                	mv	a1,s0
ffffffffc0202fca:	e05fe0ef          	jal	ffffffffc0201dce <get_pte>
ffffffffc0202fce:	c555                	beqz	a0,ffffffffc020307a <do_pgfault+0xf2>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc0202fd0:	610c                	ld	a1,0(a0)
ffffffffc0202fd2:	c5ad                	beqz	a1,ffffffffc020303c <do_pgfault+0xb4>
            goto failed;
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
ffffffffc0202fd4:	00052797          	auipc	a5,0x52
ffffffffc0202fd8:	ad47a783          	lw	a5,-1324(a5) # ffffffffc0254aa8 <swap_init_ok>
ffffffffc0202fdc:	c7d9                	beqz	a5,ffffffffc020306a <do_pgfault+0xe2>
            struct Page *page=NULL;
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc0202fde:	0030                	add	a2,sp,8
ffffffffc0202fe0:	85a2                	mv	a1,s0
ffffffffc0202fe2:	8526                	mv	a0,s1
            struct Page *page=NULL;
ffffffffc0202fe4:	e402                	sd	zero,8(sp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc0202fe6:	fb8ff0ef          	jal	ffffffffc020279e <swap_in>
ffffffffc0202fea:	892a                	mv	s2,a0
ffffffffc0202fec:	e915                	bnez	a0,ffffffffc0203020 <do_pgfault+0x98>
                cprintf("swap_in in do_pgfault failed\n");
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
ffffffffc0202fee:	65a2                	ld	a1,8(sp)
ffffffffc0202ff0:	6c88                	ld	a0,24(s1)
ffffffffc0202ff2:	86ce                	mv	a3,s3
ffffffffc0202ff4:	8622                	mv	a2,s0
ffffffffc0202ff6:	a0eff0ef          	jal	ffffffffc0202204 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
ffffffffc0202ffa:	6622                	ld	a2,8(sp)
ffffffffc0202ffc:	4685                	li	a3,1
ffffffffc0202ffe:	85a2                	mv	a1,s0
ffffffffc0203000:	8526                	mv	a0,s1
ffffffffc0203002:	e7cff0ef          	jal	ffffffffc020267e <swap_map_swappable>
            page->pra_vaddr = addr;
ffffffffc0203006:	67a2                	ld	a5,8(sp)
ffffffffc0203008:	ff80                	sd	s0,56(a5)
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
   ret = 0;
ffffffffc020300a:	4901                	li	s2,0
failed:
    return ret;
}
ffffffffc020300c:	70e2                	ld	ra,56(sp)
ffffffffc020300e:	7442                	ld	s0,48(sp)
ffffffffc0203010:	74a2                	ld	s1,40(sp)
ffffffffc0203012:	69e2                	ld	s3,24(sp)
ffffffffc0203014:	854a                	mv	a0,s2
ffffffffc0203016:	7902                	ld	s2,32(sp)
ffffffffc0203018:	6121                	add	sp,sp,64
ffffffffc020301a:	8082                	ret
    uint32_t perm = PTE_U;
ffffffffc020301c:	49c1                	li	s3,16
ffffffffc020301e:	b74d                	j	ffffffffc0202fc0 <do_pgfault+0x38>
                cprintf("swap_in in do_pgfault failed\n");
ffffffffc0203020:	00003517          	auipc	a0,0x3
ffffffffc0203024:	1d850513          	add	a0,a0,472 # ffffffffc02061f8 <default_pmm_manager+0x698>
ffffffffc0203028:	95afd0ef          	jal	ffffffffc0200182 <cprintf>
}
ffffffffc020302c:	70e2                	ld	ra,56(sp)
ffffffffc020302e:	7442                	ld	s0,48(sp)
ffffffffc0203030:	74a2                	ld	s1,40(sp)
ffffffffc0203032:	69e2                	ld	s3,24(sp)
ffffffffc0203034:	854a                	mv	a0,s2
ffffffffc0203036:	7902                	ld	s2,32(sp)
ffffffffc0203038:	6121                	add	sp,sp,64
ffffffffc020303a:	8082                	ret
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc020303c:	6c88                	ld	a0,24(s1)
ffffffffc020303e:	864e                	mv	a2,s3
ffffffffc0203040:	85a2                	mv	a1,s0
ffffffffc0203042:	cf0ff0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc0203046:	f171                	bnez	a0,ffffffffc020300a <do_pgfault+0x82>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0203048:	00003517          	auipc	a0,0x3
ffffffffc020304c:	18850513          	add	a0,a0,392 # ffffffffc02061d0 <default_pmm_manager+0x670>
ffffffffc0203050:	932fd0ef          	jal	ffffffffc0200182 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203054:	5971                	li	s2,-4
ffffffffc0203056:	bf5d                	j	ffffffffc020300c <do_pgfault+0x84>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0203058:	85a2                	mv	a1,s0
ffffffffc020305a:	00003517          	auipc	a0,0x3
ffffffffc020305e:	12650513          	add	a0,a0,294 # ffffffffc0206180 <default_pmm_manager+0x620>
ffffffffc0203062:	920fd0ef          	jal	ffffffffc0200182 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203066:	5975                	li	s2,-3
        goto failed;
ffffffffc0203068:	b755                	j	ffffffffc020300c <do_pgfault+0x84>
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
ffffffffc020306a:	00003517          	auipc	a0,0x3
ffffffffc020306e:	1ae50513          	add	a0,a0,430 # ffffffffc0206218 <default_pmm_manager+0x6b8>
ffffffffc0203072:	910fd0ef          	jal	ffffffffc0200182 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203076:	5971                	li	s2,-4
ffffffffc0203078:	bf51                	j	ffffffffc020300c <do_pgfault+0x84>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc020307a:	00003517          	auipc	a0,0x3
ffffffffc020307e:	13650513          	add	a0,a0,310 # ffffffffc02061b0 <default_pmm_manager+0x650>
ffffffffc0203082:	900fd0ef          	jal	ffffffffc0200182 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203086:	5971                	li	s2,-4
ffffffffc0203088:	b751                	j	ffffffffc020300c <do_pgfault+0x84>

ffffffffc020308a <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
ffffffffc020308a:	7179                	add	sp,sp,-48
ffffffffc020308c:	f022                	sd	s0,32(sp)
ffffffffc020308e:	f406                	sd	ra,40(sp)
ffffffffc0203090:	ec26                	sd	s1,24(sp)
ffffffffc0203092:	e84a                	sd	s2,16(sp)
ffffffffc0203094:	e44e                	sd	s3,8(sp)
ffffffffc0203096:	e052                	sd	s4,0(sp)
ffffffffc0203098:	842e                	mv	s0,a1
    if (mm != NULL) {
ffffffffc020309a:	c135                	beqz	a0,ffffffffc02030fe <user_mem_check+0x74>
        if (!USER_ACCESS(addr, addr + len)) {
ffffffffc020309c:	002007b7          	lui	a5,0x200
ffffffffc02030a0:	04f5e663          	bltu	a1,a5,ffffffffc02030ec <user_mem_check+0x62>
ffffffffc02030a4:	00c584b3          	add	s1,a1,a2
ffffffffc02030a8:	0495f263          	bgeu	a1,s1,ffffffffc02030ec <user_mem_check+0x62>
ffffffffc02030ac:	4785                	li	a5,1
ffffffffc02030ae:	07fe                	sll	a5,a5,0x1f
ffffffffc02030b0:	0297ee63          	bltu	a5,s1,ffffffffc02030ec <user_mem_check+0x62>
ffffffffc02030b4:	892a                	mv	s2,a0
ffffffffc02030b6:	89b6                	mv	s3,a3
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK)) {
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc02030b8:	6a05                	lui	s4,0x1
ffffffffc02030ba:	a821                	j	ffffffffc02030d2 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc02030bc:	0027f693          	and	a3,a5,2
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc02030c0:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc02030c2:	8ba1                	and	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc02030c4:	c685                	beqz	a3,ffffffffc02030ec <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc02030c6:	c399                	beqz	a5,ffffffffc02030cc <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc02030c8:	02e46263          	bltu	s0,a4,ffffffffc02030ec <user_mem_check+0x62>
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc02030cc:	6900                	ld	s0,16(a0)
        while (start < end) {
ffffffffc02030ce:	04947663          	bgeu	s0,s1,ffffffffc020311a <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
ffffffffc02030d2:	85a2                	mv	a1,s0
ffffffffc02030d4:	854a                	mv	a0,s2
ffffffffc02030d6:	b91ff0ef          	jal	ffffffffc0202c66 <find_vma>
ffffffffc02030da:	c909                	beqz	a0,ffffffffc02030ec <user_mem_check+0x62>
ffffffffc02030dc:	6518                	ld	a4,8(a0)
ffffffffc02030de:	00e46763          	bltu	s0,a4,ffffffffc02030ec <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc02030e2:	4d1c                	lw	a5,24(a0)
ffffffffc02030e4:	fc099ce3          	bnez	s3,ffffffffc02030bc <user_mem_check+0x32>
ffffffffc02030e8:	8b85                	and	a5,a5,1
ffffffffc02030ea:	f3ed                	bnez	a5,ffffffffc02030cc <user_mem_check+0x42>
            return 0;
ffffffffc02030ec:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc02030ee:	70a2                	ld	ra,40(sp)
ffffffffc02030f0:	7402                	ld	s0,32(sp)
ffffffffc02030f2:	64e2                	ld	s1,24(sp)
ffffffffc02030f4:	6942                	ld	s2,16(sp)
ffffffffc02030f6:	69a2                	ld	s3,8(sp)
ffffffffc02030f8:	6a02                	ld	s4,0(sp)
ffffffffc02030fa:	6145                	add	sp,sp,48
ffffffffc02030fc:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc02030fe:	c02007b7          	lui	a5,0xc0200
ffffffffc0203102:	4501                	li	a0,0
ffffffffc0203104:	fef5e5e3          	bltu	a1,a5,ffffffffc02030ee <user_mem_check+0x64>
ffffffffc0203108:	962e                	add	a2,a2,a1
ffffffffc020310a:	fec5f2e3          	bgeu	a1,a2,ffffffffc02030ee <user_mem_check+0x64>
ffffffffc020310e:	c8000537          	lui	a0,0xc8000
ffffffffc0203112:	0505                	add	a0,a0,1 # ffffffffc8000001 <end+0x7dab501>
ffffffffc0203114:	00a63533          	sltu	a0,a2,a0
ffffffffc0203118:	bfd9                	j	ffffffffc02030ee <user_mem_check+0x64>
        return 1;
ffffffffc020311a:	4505                	li	a0,1
ffffffffc020311c:	bfc9                	j	ffffffffc02030ee <user_mem_check+0x64>

ffffffffc020311e <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc020311e:	1141                	add	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203120:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203122:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203124:	c7efd0ef          	jal	ffffffffc02005a2 <ide_device_valid>
ffffffffc0203128:	cd01                	beqz	a0,ffffffffc0203140 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc020312a:	4505                	li	a0,1
ffffffffc020312c:	c7cfd0ef          	jal	ffffffffc02005a8 <ide_device_size>
}
ffffffffc0203130:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203132:	810d                	srl	a0,a0,0x3
ffffffffc0203134:	00052797          	auipc	a5,0x52
ffffffffc0203138:	96a7be23          	sd	a0,-1668(a5) # ffffffffc0254ab0 <max_swap_offset>
}
ffffffffc020313c:	0141                	add	sp,sp,16
ffffffffc020313e:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203140:	00003617          	auipc	a2,0x3
ffffffffc0203144:	10060613          	add	a2,a2,256 # ffffffffc0206240 <default_pmm_manager+0x6e0>
ffffffffc0203148:	45b5                	li	a1,13
ffffffffc020314a:	00003517          	auipc	a0,0x3
ffffffffc020314e:	11650513          	add	a0,a0,278 # ffffffffc0206260 <default_pmm_manager+0x700>
ffffffffc0203152:	b18fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0203156 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203156:	1141                	add	sp,sp,-16
ffffffffc0203158:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020315a:	00855793          	srl	a5,a0,0x8
ffffffffc020315e:	cbb1                	beqz	a5,ffffffffc02031b2 <swapfs_read+0x5c>
ffffffffc0203160:	00052717          	auipc	a4,0x52
ffffffffc0203164:	95073703          	ld	a4,-1712(a4) # ffffffffc0254ab0 <max_swap_offset>
ffffffffc0203168:	04e7f563          	bgeu	a5,a4,ffffffffc02031b2 <swapfs_read+0x5c>
    return page - pages + nbase;
ffffffffc020316c:	00052717          	auipc	a4,0x52
ffffffffc0203170:	93473703          	ld	a4,-1740(a4) # ffffffffc0254aa0 <pages>
ffffffffc0203174:	8d99                	sub	a1,a1,a4
ffffffffc0203176:	4065d613          	sra	a2,a1,0x6
ffffffffc020317a:	00004717          	auipc	a4,0x4
ffffffffc020317e:	21e73703          	ld	a4,542(a4) # ffffffffc0207398 <nbase>
ffffffffc0203182:	963a                	add	a2,a2,a4
    return KADDR(page2pa(page));
ffffffffc0203184:	00c61713          	sll	a4,a2,0xc
ffffffffc0203188:	8331                	srl	a4,a4,0xc
ffffffffc020318a:	00052697          	auipc	a3,0x52
ffffffffc020318e:	90e6b683          	ld	a3,-1778(a3) # ffffffffc0254a98 <npage>
ffffffffc0203192:	0037959b          	sllw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203196:	0632                	sll	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0203198:	02d77963          	bgeu	a4,a3,ffffffffc02031ca <swapfs_read+0x74>
}
ffffffffc020319c:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020319e:	00052797          	auipc	a5,0x52
ffffffffc02031a2:	8f27b783          	ld	a5,-1806(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc02031a6:	46a1                	li	a3,8
ffffffffc02031a8:	963e                	add	a2,a2,a5
ffffffffc02031aa:	4505                	li	a0,1
}
ffffffffc02031ac:	0141                	add	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02031ae:	c00fd06f          	j	ffffffffc02005ae <ide_read_secs>
ffffffffc02031b2:	86aa                	mv	a3,a0
ffffffffc02031b4:	00003617          	auipc	a2,0x3
ffffffffc02031b8:	0c460613          	add	a2,a2,196 # ffffffffc0206278 <default_pmm_manager+0x718>
ffffffffc02031bc:	45d1                	li	a1,20
ffffffffc02031be:	00003517          	auipc	a0,0x3
ffffffffc02031c2:	0a250513          	add	a0,a0,162 # ffffffffc0206260 <default_pmm_manager+0x700>
ffffffffc02031c6:	aa4fd0ef          	jal	ffffffffc020046a <__panic>
ffffffffc02031ca:	86b2                	mv	a3,a2
ffffffffc02031cc:	06900593          	li	a1,105
ffffffffc02031d0:	00003617          	auipc	a2,0x3
ffffffffc02031d4:	9c860613          	add	a2,a2,-1592 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc02031d8:	00003517          	auipc	a0,0x3
ffffffffc02031dc:	9e850513          	add	a0,a0,-1560 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc02031e0:	a8afd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02031e4 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc02031e4:	1141                	add	sp,sp,-16
ffffffffc02031e6:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02031e8:	00855793          	srl	a5,a0,0x8
ffffffffc02031ec:	cbb1                	beqz	a5,ffffffffc0203240 <swapfs_write+0x5c>
ffffffffc02031ee:	00052717          	auipc	a4,0x52
ffffffffc02031f2:	8c273703          	ld	a4,-1854(a4) # ffffffffc0254ab0 <max_swap_offset>
ffffffffc02031f6:	04e7f563          	bgeu	a5,a4,ffffffffc0203240 <swapfs_write+0x5c>
    return page - pages + nbase;
ffffffffc02031fa:	00052717          	auipc	a4,0x52
ffffffffc02031fe:	8a673703          	ld	a4,-1882(a4) # ffffffffc0254aa0 <pages>
ffffffffc0203202:	8d99                	sub	a1,a1,a4
ffffffffc0203204:	4065d613          	sra	a2,a1,0x6
ffffffffc0203208:	00004717          	auipc	a4,0x4
ffffffffc020320c:	19073703          	ld	a4,400(a4) # ffffffffc0207398 <nbase>
ffffffffc0203210:	963a                	add	a2,a2,a4
    return KADDR(page2pa(page));
ffffffffc0203212:	00c61713          	sll	a4,a2,0xc
ffffffffc0203216:	8331                	srl	a4,a4,0xc
ffffffffc0203218:	00052697          	auipc	a3,0x52
ffffffffc020321c:	8806b683          	ld	a3,-1920(a3) # ffffffffc0254a98 <npage>
ffffffffc0203220:	0037959b          	sllw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203224:	0632                	sll	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0203226:	02d77963          	bgeu	a4,a3,ffffffffc0203258 <swapfs_write+0x74>
}
ffffffffc020322a:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020322c:	00052797          	auipc	a5,0x52
ffffffffc0203230:	8647b783          	ld	a5,-1948(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc0203234:	46a1                	li	a3,8
ffffffffc0203236:	963e                	add	a2,a2,a5
ffffffffc0203238:	4505                	li	a0,1
}
ffffffffc020323a:	0141                	add	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020323c:	b96fd06f          	j	ffffffffc02005d2 <ide_write_secs>
ffffffffc0203240:	86aa                	mv	a3,a0
ffffffffc0203242:	00003617          	auipc	a2,0x3
ffffffffc0203246:	03660613          	add	a2,a2,54 # ffffffffc0206278 <default_pmm_manager+0x718>
ffffffffc020324a:	45e5                	li	a1,25
ffffffffc020324c:	00003517          	auipc	a0,0x3
ffffffffc0203250:	01450513          	add	a0,a0,20 # ffffffffc0206260 <default_pmm_manager+0x700>
ffffffffc0203254:	a16fd0ef          	jal	ffffffffc020046a <__panic>
ffffffffc0203258:	86b2                	mv	a3,a2
ffffffffc020325a:	06900593          	li	a1,105
ffffffffc020325e:	00003617          	auipc	a2,0x3
ffffffffc0203262:	93a60613          	add	a2,a2,-1734 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0203266:	00003517          	auipc	a0,0x3
ffffffffc020326a:	95a50513          	add	a0,a0,-1702 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc020326e:	9fcfd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0203272 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203272:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203274:	9402                	jalr	s0

	jal do_exit
ffffffffc0203276:	642000ef          	jal	ffffffffc02038b8 <do_exit>

ffffffffc020327a <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc020327a:	1141                	add	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020327c:	13000513          	li	a0,304
alloc_proc(void) {
ffffffffc0203280:	e022                	sd	s0,0(sp)
ffffffffc0203282:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203284:	f30fe0ef          	jal	ffffffffc02019b4 <kmalloc>
ffffffffc0203288:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc020328a:	c13d                	beqz	a0,ffffffffc02032f0 <alloc_proc+0x76>
        proc->state = PROC_UNINIT;
ffffffffc020328c:	57fd                	li	a5,-1
ffffffffc020328e:	1782                	sll	a5,a5,0x20
ffffffffc0203290:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203292:	07000613          	li	a2,112
ffffffffc0203296:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203298:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc020329c:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02032a0:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc02032a4:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02032a8:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02032ac:	03050513          	add	a0,a0,48
ffffffffc02032b0:	35d010ef          	jal	ffffffffc0204e0c <memset>
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
ffffffffc02032b4:	00051797          	auipc	a5,0x51
ffffffffc02032b8:	7cc7b783          	ld	a5,1996(a5) # ffffffffc0254a80 <boot_cr3>
ffffffffc02032bc:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc02032be:	0a043023          	sd	zero,160(s0)
        proc->flags = 0;
ffffffffc02032c2:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN);
ffffffffc02032c6:	463d                	li	a2,15
ffffffffc02032c8:	4581                	li	a1,0
ffffffffc02032ca:	0b440513          	add	a0,s0,180
ffffffffc02032ce:	33f010ef          	jal	ffffffffc0204e0c <memset>
        proc->wait_state = 0;
        proc->cptr = proc->optr = proc->yptr = NULL;
        proc->time_slice = 0;
ffffffffc02032d2:	4785                	li	a5,1
ffffffffc02032d4:	1782                	sll	a5,a5,0x20
ffffffffc02032d6:	12f43023          	sd	a5,288(s0)
        proc->labschedule_priority = 1;
        proc->labschedule_good = 6;
ffffffffc02032da:	4799                	li	a5,6
        proc->wait_state = 0;
ffffffffc02032dc:	0e042623          	sw	zero,236(s0)
        proc->cptr = proc->optr = proc->yptr = NULL;
ffffffffc02032e0:	0e043c23          	sd	zero,248(s0)
ffffffffc02032e4:	10043023          	sd	zero,256(s0)
ffffffffc02032e8:	0e043823          	sd	zero,240(s0)
        proc->labschedule_good = 6;
ffffffffc02032ec:	12f42423          	sw	a5,296(s0)
    }
    return proc;
}
ffffffffc02032f0:	60a2                	ld	ra,8(sp)
ffffffffc02032f2:	8522                	mv	a0,s0
ffffffffc02032f4:	6402                	ld	s0,0(sp)
ffffffffc02032f6:	0141                	add	sp,sp,16
ffffffffc02032f8:	8082                	ret

ffffffffc02032fa <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc02032fa:	00051797          	auipc	a5,0x51
ffffffffc02032fe:	7de7b783          	ld	a5,2014(a5) # ffffffffc0254ad8 <current>
ffffffffc0203302:	73c8                	ld	a0,160(a5)
ffffffffc0203304:	9e7fd06f          	j	ffffffffc0200cea <forkrets>

ffffffffc0203308 <user_main>:
static int
user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(ex3);
ffffffffc0203308:	00051797          	auipc	a5,0x51
ffffffffc020330c:	7d07b783          	ld	a5,2000(a5) # ffffffffc0254ad8 <current>
ffffffffc0203310:	43cc                	lw	a1,4(a5)
user_main(void *arg) {
ffffffffc0203312:	7139                	add	sp,sp,-64
    KERNEL_EXECVE(ex3);
ffffffffc0203314:	00003617          	auipc	a2,0x3
ffffffffc0203318:	f8460613          	add	a2,a2,-124 # ffffffffc0206298 <default_pmm_manager+0x738>
ffffffffc020331c:	00003517          	auipc	a0,0x3
ffffffffc0203320:	f8450513          	add	a0,a0,-124 # ffffffffc02062a0 <default_pmm_manager+0x740>
user_main(void *arg) {
ffffffffc0203324:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(ex3);
ffffffffc0203326:	e5dfc0ef          	jal	ffffffffc0200182 <cprintf>
ffffffffc020332a:	3fe08797          	auipc	a5,0x3fe08
ffffffffc020332e:	f6678793          	add	a5,a5,-154 # b290 <_binary_obj___user_ex3_out_size>
ffffffffc0203332:	e43e                	sd	a5,8(sp)
ffffffffc0203334:	00003517          	auipc	a0,0x3
ffffffffc0203338:	f6450513          	add	a0,a0,-156 # ffffffffc0206298 <default_pmm_manager+0x738>
ffffffffc020333c:	0001b797          	auipc	a5,0x1b
ffffffffc0203340:	4fc78793          	add	a5,a5,1276 # ffffffffc021e838 <_binary_obj___user_ex3_out_start>
ffffffffc0203344:	f03e                	sd	a5,32(sp)
ffffffffc0203346:	f42a                	sd	a0,40(sp)
    int64_t ret=0, len = strlen(name);
ffffffffc0203348:	e802                	sd	zero,16(sp)
ffffffffc020334a:	23f010ef          	jal	ffffffffc0204d88 <strlen>
ffffffffc020334e:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203350:	4511                	li	a0,4
ffffffffc0203352:	55a2                	lw	a1,40(sp)
ffffffffc0203354:	4662                	lw	a2,24(sp)
ffffffffc0203356:	5682                	lw	a3,32(sp)
ffffffffc0203358:	4722                	lw	a4,8(sp)
ffffffffc020335a:	48a9                	li	a7,10
ffffffffc020335c:	9002                	ebreak
ffffffffc020335e:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203360:	65c2                	ld	a1,16(sp)
ffffffffc0203362:	00003517          	auipc	a0,0x3
ffffffffc0203366:	f6650513          	add	a0,a0,-154 # ffffffffc02062c8 <default_pmm_manager+0x768>
ffffffffc020336a:	e19fc0ef          	jal	ffffffffc0200182 <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc020336e:	00003617          	auipc	a2,0x3
ffffffffc0203372:	f6a60613          	add	a2,a2,-150 # ffffffffc02062d8 <default_pmm_manager+0x778>
ffffffffc0203376:	30700593          	li	a1,775
ffffffffc020337a:	00003517          	auipc	a0,0x3
ffffffffc020337e:	f7e50513          	add	a0,a0,-130 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203382:	8e8fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0203386 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203386:	6d14                	ld	a3,24(a0)
put_pgdir(struct mm_struct *mm) {
ffffffffc0203388:	1141                	add	sp,sp,-16
ffffffffc020338a:	e406                	sd	ra,8(sp)
ffffffffc020338c:	c02007b7          	lui	a5,0xc0200
ffffffffc0203390:	02f6ee63          	bltu	a3,a5,ffffffffc02033cc <put_pgdir+0x46>
ffffffffc0203394:	00051797          	auipc	a5,0x51
ffffffffc0203398:	6fc7b783          	ld	a5,1788(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc020339c:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc020339e:	82b1                	srl	a3,a3,0xc
ffffffffc02033a0:	00051797          	auipc	a5,0x51
ffffffffc02033a4:	6f87b783          	ld	a5,1784(a5) # ffffffffc0254a98 <npage>
ffffffffc02033a8:	02f6fe63          	bgeu	a3,a5,ffffffffc02033e4 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc02033ac:	00004797          	auipc	a5,0x4
ffffffffc02033b0:	fec7b783          	ld	a5,-20(a5) # ffffffffc0207398 <nbase>
}
ffffffffc02033b4:	60a2                	ld	ra,8(sp)
ffffffffc02033b6:	8e9d                	sub	a3,a3,a5
    free_page(kva2page(mm->pgdir));
ffffffffc02033b8:	00051517          	auipc	a0,0x51
ffffffffc02033bc:	6e853503          	ld	a0,1768(a0) # ffffffffc0254aa0 <pages>
ffffffffc02033c0:	069a                	sll	a3,a3,0x6
ffffffffc02033c2:	4585                	li	a1,1
ffffffffc02033c4:	9536                	add	a0,a0,a3
}
ffffffffc02033c6:	0141                	add	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc02033c8:	82ffe06f          	j	ffffffffc0201bf6 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc02033cc:	00003617          	auipc	a2,0x3
ffffffffc02033d0:	83c60613          	add	a2,a2,-1988 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc02033d4:	06e00593          	li	a1,110
ffffffffc02033d8:	00002517          	auipc	a0,0x2
ffffffffc02033dc:	7e850513          	add	a0,a0,2024 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc02033e0:	88afd0ef          	jal	ffffffffc020046a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02033e4:	00003617          	auipc	a2,0x3
ffffffffc02033e8:	84c60613          	add	a2,a2,-1972 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc02033ec:	06200593          	li	a1,98
ffffffffc02033f0:	00002517          	auipc	a0,0x2
ffffffffc02033f4:	7d050513          	add	a0,a0,2000 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc02033f8:	872fd0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02033fc <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc02033fc:	7179                	add	sp,sp,-48
ffffffffc02033fe:	ec4a                	sd	s2,24(sp)
    if (proc != current) {
ffffffffc0203400:	00051917          	auipc	s2,0x51
ffffffffc0203404:	6d890913          	add	s2,s2,1752 # ffffffffc0254ad8 <current>
proc_run(struct proc_struct *proc) {
ffffffffc0203408:	f026                	sd	s1,32(sp)
    if (proc != current) {
ffffffffc020340a:	00093483          	ld	s1,0(s2)
proc_run(struct proc_struct *proc) {
ffffffffc020340e:	f406                	sd	ra,40(sp)
ffffffffc0203410:	e84e                	sd	s3,16(sp)
    if (proc != current) {
ffffffffc0203412:	02a48863          	beq	s1,a0,ffffffffc0203442 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203416:	100027f3          	csrr	a5,sstatus
ffffffffc020341a:	8b89                	and	a5,a5,2
    return 0;
ffffffffc020341c:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020341e:	ef9d                	bnez	a5,ffffffffc020345c <proc_run+0x60>

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned long cr3) {
    write_csr(satp, 0x8000000000000000 | (cr3 >> RISCV_PGSHIFT));
ffffffffc0203420:	755c                	ld	a5,168(a0)
ffffffffc0203422:	577d                	li	a4,-1
ffffffffc0203424:	177e                	sll	a4,a4,0x3f
ffffffffc0203426:	83b1                	srl	a5,a5,0xc
            current = proc;
ffffffffc0203428:	00a93023          	sd	a0,0(s2)
ffffffffc020342c:	8fd9                	or	a5,a5,a4
ffffffffc020342e:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(next->context));
ffffffffc0203432:	03050593          	add	a1,a0,48
ffffffffc0203436:	03048513          	add	a0,s1,48
ffffffffc020343a:	060010ef          	jal	ffffffffc020449a <switch_to>
    if (flag) {
ffffffffc020343e:	00099863          	bnez	s3,ffffffffc020344e <proc_run+0x52>
}
ffffffffc0203442:	70a2                	ld	ra,40(sp)
ffffffffc0203444:	7482                	ld	s1,32(sp)
ffffffffc0203446:	6962                	ld	s2,24(sp)
ffffffffc0203448:	69c2                	ld	s3,16(sp)
ffffffffc020344a:	6145                	add	sp,sp,48
ffffffffc020344c:	8082                	ret
ffffffffc020344e:	70a2                	ld	ra,40(sp)
ffffffffc0203450:	7482                	ld	s1,32(sp)
ffffffffc0203452:	6962                	ld	s2,24(sp)
ffffffffc0203454:	69c2                	ld	s3,16(sp)
ffffffffc0203456:	6145                	add	sp,sp,48
        intr_enable();
ffffffffc0203458:	99efd06f          	j	ffffffffc02005f6 <intr_enable>
ffffffffc020345c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020345e:	99efd0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc0203462:	6522                	ld	a0,8(sp)
ffffffffc0203464:	4985                	li	s3,1
ffffffffc0203466:	bf6d                	j	ffffffffc0203420 <proc_run+0x24>

ffffffffc0203468 <do_fork>:
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0203468:	7119                	add	sp,sp,-128
ffffffffc020346a:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc020346c:	00051917          	auipc	s2,0x51
ffffffffc0203470:	66490913          	add	s2,s2,1636 # ffffffffc0254ad0 <nr_process>
ffffffffc0203474:	00092703          	lw	a4,0(s2)
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0203478:	fc86                	sd	ra,120(sp)
ffffffffc020347a:	f8a2                	sd	s0,112(sp)
ffffffffc020347c:	f4a6                	sd	s1,104(sp)
ffffffffc020347e:	ecce                	sd	s3,88(sp)
ffffffffc0203480:	e8d2                	sd	s4,80(sp)
ffffffffc0203482:	e4d6                	sd	s5,72(sp)
ffffffffc0203484:	e0da                	sd	s6,64(sp)
ffffffffc0203486:	fc5e                	sd	s7,56(sp)
ffffffffc0203488:	f862                	sd	s8,48(sp)
ffffffffc020348a:	f466                	sd	s9,40(sp)
ffffffffc020348c:	f06a                	sd	s10,32(sp)
ffffffffc020348e:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0203490:	6785                	lui	a5,0x1
ffffffffc0203492:	32f75d63          	bge	a4,a5,ffffffffc02037cc <do_fork+0x364>
ffffffffc0203496:	8a2a                	mv	s4,a0
ffffffffc0203498:	89ae                	mv	s3,a1
ffffffffc020349a:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc020349c:	ddfff0ef          	jal	ffffffffc020327a <alloc_proc>
ffffffffc02034a0:	84aa                	mv	s1,a0
ffffffffc02034a2:	30050a63          	beqz	a0,ffffffffc02037b6 <do_fork+0x34e>
    proc->parent = current;
ffffffffc02034a6:	00051c17          	auipc	s8,0x51
ffffffffc02034aa:	632c0c13          	add	s8,s8,1586 # ffffffffc0254ad8 <current>
ffffffffc02034ae:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state == 0);
ffffffffc02034b2:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_ex1_out_size-0x8adc>
    proc->parent = current;
ffffffffc02034b6:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);
ffffffffc02034b8:	30071c63          	bnez	a4,ffffffffc02037d0 <do_fork+0x368>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc02034bc:	4509                	li	a0,2
ffffffffc02034be:	ea8fe0ef          	jal	ffffffffc0201b66 <alloc_pages>
    if (page != NULL) {
ffffffffc02034c2:	2e050763          	beqz	a0,ffffffffc02037b0 <do_fork+0x348>
    return page - pages + nbase;
ffffffffc02034c6:	00051a97          	auipc	s5,0x51
ffffffffc02034ca:	5daa8a93          	add	s5,s5,1498 # ffffffffc0254aa0 <pages>
ffffffffc02034ce:	000ab703          	ld	a4,0(s5)
ffffffffc02034d2:	00004b17          	auipc	s6,0x4
ffffffffc02034d6:	ec6b0b13          	add	s6,s6,-314 # ffffffffc0207398 <nbase>
ffffffffc02034da:	000b3783          	ld	a5,0(s6)
ffffffffc02034de:	40e506b3          	sub	a3,a0,a4
    return KADDR(page2pa(page));
ffffffffc02034e2:	00051b97          	auipc	s7,0x51
ffffffffc02034e6:	5b6b8b93          	add	s7,s7,1462 # ffffffffc0254a98 <npage>
    return page - pages + nbase;
ffffffffc02034ea:	8699                	sra	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02034ec:	5dfd                	li	s11,-1
ffffffffc02034ee:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc02034f2:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02034f4:	00cddd93          	srl	s11,s11,0xc
ffffffffc02034f8:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc02034fc:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02034fe:	32e67163          	bgeu	a2,a4,ffffffffc0203820 <do_fork+0x3b8>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0203502:	000c3603          	ld	a2,0(s8)
ffffffffc0203506:	00051c17          	auipc	s8,0x51
ffffffffc020350a:	58ac0c13          	add	s8,s8,1418 # ffffffffc0254a90 <va_pa_offset>
ffffffffc020350e:	000c3703          	ld	a4,0(s8)
ffffffffc0203512:	02863d03          	ld	s10,40(a2)
ffffffffc0203516:	e43e                	sd	a5,8(sp)
ffffffffc0203518:	9736                	add	a4,a4,a3
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020351a:	e898                	sd	a4,16(s1)
    if (oldmm == NULL) {
ffffffffc020351c:	020d0863          	beqz	s10,ffffffffc020354c <do_fork+0xe4>
    if (clone_flags & CLONE_VM) {
ffffffffc0203520:	100a7a13          	and	s4,s4,256
ffffffffc0203524:	1c0a0663          	beqz	s4,ffffffffc02036f0 <do_fork+0x288>
}

static inline int
mm_count_inc(struct mm_struct *mm) {
    mm->mm_count += 1;
ffffffffc0203528:	030d2783          	lw	a5,48(s10)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc020352c:	018d3683          	ld	a3,24(s10)
ffffffffc0203530:	c0200737          	lui	a4,0xc0200
ffffffffc0203534:	2785                	addw	a5,a5,1
ffffffffc0203536:	02fd2823          	sw	a5,48(s10)
    proc->mm = mm;
ffffffffc020353a:	03a4b423          	sd	s10,40(s1)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc020353e:	2ce6e563          	bltu	a3,a4,ffffffffc0203808 <do_fork+0x3a0>
ffffffffc0203542:	000c3783          	ld	a5,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203546:	6898                	ld	a4,16(s1)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc0203548:	8e9d                	sub	a3,a3,a5
ffffffffc020354a:	f4d4                	sd	a3,168(s1)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc020354c:	6689                	lui	a3,0x2
ffffffffc020354e:	ee068693          	add	a3,a3,-288 # 1ee0 <_binary_obj___user_ex1_out_size-0x7ce8>
ffffffffc0203552:	96ba                	add	a3,a3,a4
    *(proc->tf) = *tf;
ffffffffc0203554:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0203556:	f0d4                	sd	a3,160(s1)
    *(proc->tf) = *tf;
ffffffffc0203558:	87b6                	mv	a5,a3
ffffffffc020355a:	12040313          	add	t1,s0,288
ffffffffc020355e:	00063883          	ld	a7,0(a2)
ffffffffc0203562:	00863803          	ld	a6,8(a2)
ffffffffc0203566:	6a08                	ld	a0,16(a2)
ffffffffc0203568:	6e0c                	ld	a1,24(a2)
ffffffffc020356a:	0117b023          	sd	a7,0(a5)
ffffffffc020356e:	0107b423          	sd	a6,8(a5)
ffffffffc0203572:	eb88                	sd	a0,16(a5)
ffffffffc0203574:	ef8c                	sd	a1,24(a5)
ffffffffc0203576:	02060613          	add	a2,a2,32
ffffffffc020357a:	02078793          	add	a5,a5,32
ffffffffc020357e:	fe6610e3          	bne	a2,t1,ffffffffc020355e <do_fork+0xf6>
    proc->tf->gpr.a0 = 0;
ffffffffc0203582:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf - 4 : esp;
ffffffffc0203586:	12098f63          	beqz	s3,ffffffffc02036c4 <do_fork+0x25c>
ffffffffc020358a:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020358e:	00000797          	auipc	a5,0x0
ffffffffc0203592:	d6c78793          	add	a5,a5,-660 # ffffffffc02032fa <forkret>
ffffffffc0203596:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0203598:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020359a:	100027f3          	csrr	a5,sstatus
ffffffffc020359e:	8b89                	and	a5,a5,2
    return 0;
ffffffffc02035a0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02035a2:	14079363          	bnez	a5,ffffffffc02036e8 <do_fork+0x280>
    if (++ last_pid >= MAX_PID) {
ffffffffc02035a6:	00046817          	auipc	a6,0x46
ffffffffc02035aa:	04e80813          	add	a6,a6,78 # ffffffffc02495f4 <last_pid.1>
ffffffffc02035ae:	00082783          	lw	a5,0(a6)
ffffffffc02035b2:	6709                	lui	a4,0x2
ffffffffc02035b4:	0017851b          	addw	a0,a5,1
ffffffffc02035b8:	00a82023          	sw	a0,0(a6)
ffffffffc02035bc:	08e55e63          	bge	a0,a4,ffffffffc0203658 <do_fork+0x1f0>
    if (last_pid >= next_safe) {
ffffffffc02035c0:	00046317          	auipc	t1,0x46
ffffffffc02035c4:	03030313          	add	t1,t1,48 # ffffffffc02495f0 <next_safe.0>
ffffffffc02035c8:	00032783          	lw	a5,0(t1)
ffffffffc02035cc:	00051417          	auipc	s0,0x51
ffffffffc02035d0:	45440413          	add	s0,s0,1108 # ffffffffc0254a20 <proc_list>
ffffffffc02035d4:	08f55a63          	bge	a0,a5,ffffffffc0203668 <do_fork+0x200>
        proc->pid = get_pid();
ffffffffc02035d8:	c0c8                	sw	a0,4(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02035da:	45a9                	li	a1,10
ffffffffc02035dc:	2501                	sext.w	a0,a0
ffffffffc02035de:	3aa010ef          	jal	ffffffffc0204988 <hash32>
ffffffffc02035e2:	02051793          	sll	a5,a0,0x20
ffffffffc02035e6:	01c7d513          	srl	a0,a5,0x1c
ffffffffc02035ea:	0004d797          	auipc	a5,0x4d
ffffffffc02035ee:	43678793          	add	a5,a5,1078 # ffffffffc0250a20 <hash_list>
ffffffffc02035f2:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02035f4:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc02035f6:	7094                	ld	a3,32(s1)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02035f8:	0d848793          	add	a5,s1,216
    prev->next = next->prev = elm;
ffffffffc02035fc:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc02035fe:	6410                	ld	a2,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203600:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc0203602:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0203604:	0c848793          	add	a5,s1,200
    elm->next = next;
ffffffffc0203608:	f0ec                	sd	a1,224(s1)
    elm->prev = prev;
ffffffffc020360a:	ece8                	sd	a0,216(s1)
    prev->next = next->prev = elm;
ffffffffc020360c:	e21c                	sd	a5,0(a2)
ffffffffc020360e:	e41c                	sd	a5,8(s0)
    elm->next = next;
ffffffffc0203610:	e8f0                	sd	a2,208(s1)
    elm->prev = prev;
ffffffffc0203612:	e4e0                	sd	s0,200(s1)
    proc->yptr = NULL;
ffffffffc0203614:	0e04bc23          	sd	zero,248(s1)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc0203618:	10e4b023          	sd	a4,256(s1)
ffffffffc020361c:	c311                	beqz	a4,ffffffffc0203620 <do_fork+0x1b8>
        proc->optr->yptr = proc;
ffffffffc020361e:	ff64                	sd	s1,248(a4)
    nr_process ++;
ffffffffc0203620:	00092783          	lw	a5,0(s2)
    proc->parent->cptr = proc;
ffffffffc0203624:	fae4                	sd	s1,240(a3)
    nr_process ++;
ffffffffc0203626:	2785                	addw	a5,a5,1
ffffffffc0203628:	00f92023          	sw	a5,0(s2)
    if (flag) {
ffffffffc020362c:	18099763          	bnez	s3,ffffffffc02037ba <do_fork+0x352>
    wakeup_proc(proc);
ffffffffc0203630:	8526                	mv	a0,s1
    ret = proc->pid;
ffffffffc0203632:	40c0                	lw	s0,4(s1)
    wakeup_proc(proc);
ffffffffc0203634:	036010ef          	jal	ffffffffc020466a <wakeup_proc>
}
ffffffffc0203638:	70e6                	ld	ra,120(sp)
ffffffffc020363a:	8522                	mv	a0,s0
ffffffffc020363c:	7446                	ld	s0,112(sp)
ffffffffc020363e:	74a6                	ld	s1,104(sp)
ffffffffc0203640:	7906                	ld	s2,96(sp)
ffffffffc0203642:	69e6                	ld	s3,88(sp)
ffffffffc0203644:	6a46                	ld	s4,80(sp)
ffffffffc0203646:	6aa6                	ld	s5,72(sp)
ffffffffc0203648:	6b06                	ld	s6,64(sp)
ffffffffc020364a:	7be2                	ld	s7,56(sp)
ffffffffc020364c:	7c42                	ld	s8,48(sp)
ffffffffc020364e:	7ca2                	ld	s9,40(sp)
ffffffffc0203650:	7d02                	ld	s10,32(sp)
ffffffffc0203652:	6de2                	ld	s11,24(sp)
ffffffffc0203654:	6109                	add	sp,sp,128
ffffffffc0203656:	8082                	ret
        last_pid = 1;
ffffffffc0203658:	4785                	li	a5,1
ffffffffc020365a:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc020365e:	4505                	li	a0,1
ffffffffc0203660:	00046317          	auipc	t1,0x46
ffffffffc0203664:	f9030313          	add	t1,t1,-112 # ffffffffc02495f0 <next_safe.0>
    return listelm->next;
ffffffffc0203668:	00051417          	auipc	s0,0x51
ffffffffc020366c:	3b840413          	add	s0,s0,952 # ffffffffc0254a20 <proc_list>
ffffffffc0203670:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc0203674:	6789                	lui	a5,0x2
ffffffffc0203676:	00f32023          	sw	a5,0(t1)
ffffffffc020367a:	86aa                	mv	a3,a0
ffffffffc020367c:	4581                	li	a1,0
        while ((le = list_next(le)) != list) {
ffffffffc020367e:	028e0e63          	beq	t3,s0,ffffffffc02036ba <do_fork+0x252>
ffffffffc0203682:	88ae                	mv	a7,a1
ffffffffc0203684:	87f2                	mv	a5,t3
ffffffffc0203686:	6609                	lui	a2,0x2
ffffffffc0203688:	a811                	j	ffffffffc020369c <do_fork+0x234>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc020368a:	00e6d663          	bge	a3,a4,ffffffffc0203696 <do_fork+0x22e>
ffffffffc020368e:	00c75463          	bge	a4,a2,ffffffffc0203696 <do_fork+0x22e>
                next_safe = proc->pid;
ffffffffc0203692:	863a                	mv	a2,a4
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc0203694:	4885                	li	a7,1
ffffffffc0203696:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0203698:	00878d63          	beq	a5,s0,ffffffffc02036b2 <do_fork+0x24a>
            if (proc->pid == last_pid) {
ffffffffc020369c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_ex1_out_size-0x7c8c>
ffffffffc02036a0:	fed715e3          	bne	a4,a3,ffffffffc020368a <do_fork+0x222>
                if (++ last_pid >= next_safe) {
ffffffffc02036a4:	2685                	addw	a3,a3,1
ffffffffc02036a6:	10c6dd63          	bge	a3,a2,ffffffffc02037c0 <do_fork+0x358>
ffffffffc02036aa:	679c                	ld	a5,8(a5)
ffffffffc02036ac:	4585                	li	a1,1
        while ((le = list_next(le)) != list) {
ffffffffc02036ae:	fe8797e3          	bne	a5,s0,ffffffffc020369c <do_fork+0x234>
ffffffffc02036b2:	00088463          	beqz	a7,ffffffffc02036ba <do_fork+0x252>
ffffffffc02036b6:	00c32023          	sw	a2,0(t1)
ffffffffc02036ba:	dd99                	beqz	a1,ffffffffc02035d8 <do_fork+0x170>
ffffffffc02036bc:	00d82023          	sw	a3,0(a6)
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc02036c0:	8536                	mv	a0,a3
ffffffffc02036c2:	bf19                	j	ffffffffc02035d8 <do_fork+0x170>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf - 4 : esp;
ffffffffc02036c4:	6989                	lui	s3,0x2
ffffffffc02036c6:	edc98993          	add	s3,s3,-292 # 1edc <_binary_obj___user_ex1_out_size-0x7cec>
ffffffffc02036ca:	99ba                	add	s3,s3,a4
ffffffffc02036cc:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02036d0:	00000797          	auipc	a5,0x0
ffffffffc02036d4:	c2a78793          	add	a5,a5,-982 # ffffffffc02032fa <forkret>
ffffffffc02036d8:	f89c                	sd	a5,48(s1)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02036da:	fc94                	sd	a3,56(s1)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02036dc:	100027f3          	csrr	a5,sstatus
ffffffffc02036e0:	8b89                	and	a5,a5,2
    return 0;
ffffffffc02036e2:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02036e4:	ec0781e3          	beqz	a5,ffffffffc02035a6 <do_fork+0x13e>
        intr_disable();
ffffffffc02036e8:	f15fc0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc02036ec:	4985                	li	s3,1
ffffffffc02036ee:	bd65                	j	ffffffffc02035a6 <do_fork+0x13e>
    if ((mm = mm_create()) == NULL) {
ffffffffc02036f0:	d2eff0ef          	jal	ffffffffc0202c1e <mm_create>
ffffffffc02036f4:	8caa                	mv	s9,a0
ffffffffc02036f6:	c549                	beqz	a0,ffffffffc0203780 <do_fork+0x318>
    if ((page = alloc_page()) == NULL) {
ffffffffc02036f8:	4505                	li	a0,1
ffffffffc02036fa:	c6cfe0ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc02036fe:	cd35                	beqz	a0,ffffffffc020377a <do_fork+0x312>
    return page - pages + nbase;
ffffffffc0203700:	000ab683          	ld	a3,0(s5)
ffffffffc0203704:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc0203706:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020370a:	40d506b3          	sub	a3,a0,a3
ffffffffc020370e:	8699                	sra	a3,a3,0x6
ffffffffc0203710:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203712:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc0203716:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203718:	10edf463          	bgeu	s11,a4,ffffffffc0203820 <do_fork+0x3b8>
ffffffffc020371c:	000c3783          	ld	a5,0(s8)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0203720:	6605                	lui	a2,0x1
ffffffffc0203722:	00051597          	auipc	a1,0x51
ffffffffc0203726:	3665b583          	ld	a1,870(a1) # ffffffffc0254a88 <boot_pgdir>
ffffffffc020372a:	00f68a33          	add	s4,a3,a5
ffffffffc020372e:	8552                	mv	a0,s4
ffffffffc0203730:	6ee010ef          	jal	ffffffffc0204e1e <memcpy>
}

static inline void
lock_mm(struct mm_struct *mm) {
    if (mm != NULL) {
        lock(&(mm->mm_lock));
ffffffffc0203734:	038d0d93          	add	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc0203738:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020373c:	4785                	li	a5,1
ffffffffc020373e:	40fdb7af          	amoor.d	a5,a5,(s11)
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
ffffffffc0203742:	8b85                	and	a5,a5,1
ffffffffc0203744:	4a05                	li	s4,1
ffffffffc0203746:	c799                	beqz	a5,ffffffffc0203754 <do_fork+0x2ec>
        schedule();
ffffffffc0203748:	026010ef          	jal	ffffffffc020476e <schedule>
ffffffffc020374c:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock)) {
ffffffffc0203750:	8b85                	and	a5,a5,1
ffffffffc0203752:	fbfd                	bnez	a5,ffffffffc0203748 <do_fork+0x2e0>
        ret = dup_mmap(mm, oldmm);
ffffffffc0203754:	85ea                	mv	a1,s10
ffffffffc0203756:	8566                	mv	a0,s9
ffffffffc0203758:	f20ff0ef          	jal	ffffffffc0202e78 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020375c:	57f9                	li	a5,-2
ffffffffc020375e:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc0203762:	8b85                	and	a5,a5,1
    }
}

static inline void
unlock(lock_t *lock) {
    if (!test_and_clear_bit(0, lock)) {
ffffffffc0203764:	0e078663          	beqz	a5,ffffffffc0203850 <do_fork+0x3e8>
good_mm:
ffffffffc0203768:	8d66                	mv	s10,s9
    if (ret != 0) {
ffffffffc020376a:	da050fe3          	beqz	a0,ffffffffc0203528 <do_fork+0xc0>
    exit_mmap(mm);
ffffffffc020376e:	8566                	mv	a0,s9
ffffffffc0203770:	fa0ff0ef          	jal	ffffffffc0202f10 <exit_mmap>
    put_pgdir(mm);
ffffffffc0203774:	8566                	mv	a0,s9
ffffffffc0203776:	c11ff0ef          	jal	ffffffffc0203386 <put_pgdir>
    mm_destroy(mm);
ffffffffc020377a:	8566                	mv	a0,s9
ffffffffc020377c:	dfaff0ef          	jal	ffffffffc0202d76 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0203780:	6894                	ld	a3,16(s1)
    return pa2page(PADDR(kva));
ffffffffc0203782:	c02007b7          	lui	a5,0xc0200
ffffffffc0203786:	0af6e963          	bltu	a3,a5,ffffffffc0203838 <do_fork+0x3d0>
ffffffffc020378a:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage) {
ffffffffc020378e:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0203792:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0203796:	83b1                	srl	a5,a5,0xc
ffffffffc0203798:	04e7fc63          	bgeu	a5,a4,ffffffffc02037f0 <do_fork+0x388>
    return &pages[PPN(pa) - nbase];
ffffffffc020379c:	000b3703          	ld	a4,0(s6)
ffffffffc02037a0:	000ab503          	ld	a0,0(s5)
ffffffffc02037a4:	4589                	li	a1,2
ffffffffc02037a6:	8f99                	sub	a5,a5,a4
ffffffffc02037a8:	079a                	sll	a5,a5,0x6
ffffffffc02037aa:	953e                	add	a0,a0,a5
ffffffffc02037ac:	c4afe0ef          	jal	ffffffffc0201bf6 <free_pages>
    kfree(proc);
ffffffffc02037b0:	8526                	mv	a0,s1
ffffffffc02037b2:	aa2fe0ef          	jal	ffffffffc0201a54 <kfree>
    ret = -E_NO_MEM;
ffffffffc02037b6:	5471                	li	s0,-4
    return ret;
ffffffffc02037b8:	b541                	j	ffffffffc0203638 <do_fork+0x1d0>
        intr_enable();
ffffffffc02037ba:	e3dfc0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc02037be:	bd8d                	j	ffffffffc0203630 <do_fork+0x1c8>
                    if (last_pid >= MAX_PID) {
ffffffffc02037c0:	6789                	lui	a5,0x2
ffffffffc02037c2:	00f6c363          	blt	a3,a5,ffffffffc02037c8 <do_fork+0x360>
                        last_pid = 1;
ffffffffc02037c6:	4685                	li	a3,1
                    goto repeat;
ffffffffc02037c8:	4585                	li	a1,1
ffffffffc02037ca:	bd55                	j	ffffffffc020367e <do_fork+0x216>
    int ret = -E_NO_FREE_PROC;
ffffffffc02037cc:	546d                	li	s0,-5
ffffffffc02037ce:	b5ad                	j	ffffffffc0203638 <do_fork+0x1d0>
    assert(current->wait_state == 0);
ffffffffc02037d0:	00003697          	auipc	a3,0x3
ffffffffc02037d4:	b4068693          	add	a3,a3,-1216 # ffffffffc0206310 <default_pmm_manager+0x7b0>
ffffffffc02037d8:	00002617          	auipc	a2,0x2
ffffffffc02037dc:	cf060613          	add	a2,a2,-784 # ffffffffc02054c8 <commands+0x430>
ffffffffc02037e0:	17300593          	li	a1,371
ffffffffc02037e4:	00003517          	auipc	a0,0x3
ffffffffc02037e8:	b1450513          	add	a0,a0,-1260 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02037ec:	c7ffc0ef          	jal	ffffffffc020046a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02037f0:	00002617          	auipc	a2,0x2
ffffffffc02037f4:	44060613          	add	a2,a2,1088 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc02037f8:	06200593          	li	a1,98
ffffffffc02037fc:	00002517          	auipc	a0,0x2
ffffffffc0203800:	3c450513          	add	a0,a0,964 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0203804:	c67fc0ef          	jal	ffffffffc020046a <__panic>
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc0203808:	00002617          	auipc	a2,0x2
ffffffffc020380c:	40060613          	add	a2,a2,1024 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0203810:	14600593          	li	a1,326
ffffffffc0203814:	00003517          	auipc	a0,0x3
ffffffffc0203818:	ae450513          	add	a0,a0,-1308 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc020381c:	c4ffc0ef          	jal	ffffffffc020046a <__panic>
    return KADDR(page2pa(page));
ffffffffc0203820:	00002617          	auipc	a2,0x2
ffffffffc0203824:	37860613          	add	a2,a2,888 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0203828:	06900593          	li	a1,105
ffffffffc020382c:	00002517          	auipc	a0,0x2
ffffffffc0203830:	39450513          	add	a0,a0,916 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0203834:	c37fc0ef          	jal	ffffffffc020046a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0203838:	00002617          	auipc	a2,0x2
ffffffffc020383c:	3d060613          	add	a2,a2,976 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0203840:	06e00593          	li	a1,110
ffffffffc0203844:	00002517          	auipc	a0,0x2
ffffffffc0203848:	37c50513          	add	a0,a0,892 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc020384c:	c1ffc0ef          	jal	ffffffffc020046a <__panic>
        panic("Unlock failed.\n");
ffffffffc0203850:	00003617          	auipc	a2,0x3
ffffffffc0203854:	ae060613          	add	a2,a2,-1312 # ffffffffc0206330 <default_pmm_manager+0x7d0>
ffffffffc0203858:	03200593          	li	a1,50
ffffffffc020385c:	00003517          	auipc	a0,0x3
ffffffffc0203860:	ae450513          	add	a0,a0,-1308 # ffffffffc0206340 <default_pmm_manager+0x7e0>
ffffffffc0203864:	c07fc0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0203868 <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc0203868:	7129                	add	sp,sp,-320
ffffffffc020386a:	fa22                	sd	s0,304(sp)
ffffffffc020386c:	f626                	sd	s1,296(sp)
ffffffffc020386e:	f24a                	sd	s2,288(sp)
ffffffffc0203870:	84ae                	mv	s1,a1
ffffffffc0203872:	892a                	mv	s2,a0
ffffffffc0203874:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203876:	4581                	li	a1,0
ffffffffc0203878:	12000613          	li	a2,288
ffffffffc020387c:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc020387e:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203880:	58c010ef          	jal	ffffffffc0204e0c <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc0203884:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc0203886:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203888:	100027f3          	csrr	a5,sstatus
ffffffffc020388c:	edd7f793          	and	a5,a5,-291
ffffffffc0203890:	1207e793          	or	a5,a5,288
ffffffffc0203894:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203896:	860a                	mv	a2,sp
ffffffffc0203898:	10046513          	or	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020389c:	00000797          	auipc	a5,0x0
ffffffffc02038a0:	9d678793          	add	a5,a5,-1578 # ffffffffc0203272 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02038a4:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02038a6:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02038a8:	bc1ff0ef          	jal	ffffffffc0203468 <do_fork>
}
ffffffffc02038ac:	70f2                	ld	ra,312(sp)
ffffffffc02038ae:	7452                	ld	s0,304(sp)
ffffffffc02038b0:	74b2                	ld	s1,296(sp)
ffffffffc02038b2:	7912                	ld	s2,288(sp)
ffffffffc02038b4:	6131                	add	sp,sp,320
ffffffffc02038b6:	8082                	ret

ffffffffc02038b8 <do_exit>:
do_exit(int error_code) {
ffffffffc02038b8:	7179                	add	sp,sp,-48
ffffffffc02038ba:	f022                	sd	s0,32(sp)
    if (current == idleproc) {
ffffffffc02038bc:	00051417          	auipc	s0,0x51
ffffffffc02038c0:	21c40413          	add	s0,s0,540 # ffffffffc0254ad8 <current>
ffffffffc02038c4:	601c                	ld	a5,0(s0)
do_exit(int error_code) {
ffffffffc02038c6:	f406                	sd	ra,40(sp)
ffffffffc02038c8:	ec26                	sd	s1,24(sp)
ffffffffc02038ca:	e84a                	sd	s2,16(sp)
ffffffffc02038cc:	e44e                	sd	s3,8(sp)
ffffffffc02038ce:	e052                	sd	s4,0(sp)
    if (current == idleproc) {
ffffffffc02038d0:	00051717          	auipc	a4,0x51
ffffffffc02038d4:	21873703          	ld	a4,536(a4) # ffffffffc0254ae8 <idleproc>
ffffffffc02038d8:	0ce78c63          	beq	a5,a4,ffffffffc02039b0 <do_exit+0xf8>
    if (current == initproc) {
ffffffffc02038dc:	00051497          	auipc	s1,0x51
ffffffffc02038e0:	20448493          	add	s1,s1,516 # ffffffffc0254ae0 <initproc>
ffffffffc02038e4:	6098                	ld	a4,0(s1)
ffffffffc02038e6:	0ee78b63          	beq	a5,a4,ffffffffc02039dc <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc02038ea:	0287b983          	ld	s3,40(a5)
ffffffffc02038ee:	892a                	mv	s2,a0
    if (mm != NULL) {
ffffffffc02038f0:	02098663          	beqz	s3,ffffffffc020391c <do_exit+0x64>
ffffffffc02038f4:	00051797          	auipc	a5,0x51
ffffffffc02038f8:	18c7b783          	ld	a5,396(a5) # ffffffffc0254a80 <boot_cr3>
ffffffffc02038fc:	577d                	li	a4,-1
ffffffffc02038fe:	177e                	sll	a4,a4,0x3f
ffffffffc0203900:	83b1                	srl	a5,a5,0xc
ffffffffc0203902:	8fd9                	or	a5,a5,a4
ffffffffc0203904:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0203908:	0309a783          	lw	a5,48(s3)
ffffffffc020390c:	fff7871b          	addw	a4,a5,-1
ffffffffc0203910:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0) {
ffffffffc0203914:	cb55                	beqz	a4,ffffffffc02039c8 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0203916:	601c                	ld	a5,0(s0)
ffffffffc0203918:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020391c:	601c                	ld	a5,0(s0)
ffffffffc020391e:	470d                	li	a4,3
ffffffffc0203920:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0203922:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203926:	100027f3          	csrr	a5,sstatus
ffffffffc020392a:	8b89                	and	a5,a5,2
    return 0;
ffffffffc020392c:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020392e:	e3f9                	bnez	a5,ffffffffc02039f4 <do_exit+0x13c>
        proc = current->parent;
ffffffffc0203930:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD) {
ffffffffc0203932:	800007b7          	lui	a5,0x80000
ffffffffc0203936:	0785                	add	a5,a5,1 # ffffffff80000001 <_binary_obj___user_ex3_out_size+0xffffffff7fff4d71>
        proc = current->parent;
ffffffffc0203938:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD) {
ffffffffc020393a:	0ec52703          	lw	a4,236(a0)
ffffffffc020393e:	0af70f63          	beq	a4,a5,ffffffffc02039fc <do_exit+0x144>
        while (current->cptr != NULL) {
ffffffffc0203942:	6018                	ld	a4,0(s0)
ffffffffc0203944:	7b7c                	ld	a5,240(a4)
ffffffffc0203946:	c3a1                	beqz	a5,ffffffffc0203986 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc0203948:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE) {
ffffffffc020394c:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD) {
ffffffffc020394e:	0985                	add	s3,s3,1 # ffffffff80000001 <_binary_obj___user_ex3_out_size+0xffffffff7fff4d71>
ffffffffc0203950:	a021                	j	ffffffffc0203958 <do_exit+0xa0>
        while (current->cptr != NULL) {
ffffffffc0203952:	6018                	ld	a4,0(s0)
ffffffffc0203954:	7b7c                	ld	a5,240(a4)
ffffffffc0203956:	cb85                	beqz	a5,ffffffffc0203986 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0203958:	1007b683          	ld	a3,256(a5)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc020395c:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020395e:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc0203960:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc0203962:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc0203966:	10e7b023          	sd	a4,256(a5)
ffffffffc020396a:	c311                	beqz	a4,ffffffffc020396e <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc020396c:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc020396e:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0203970:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0203972:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203974:	fd271fe3          	bne	a4,s2,ffffffffc0203952 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc0203978:	0ec52783          	lw	a5,236(a0)
ffffffffc020397c:	fd379be3          	bne	a5,s3,ffffffffc0203952 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc0203980:	4eb000ef          	jal	ffffffffc020466a <wakeup_proc>
ffffffffc0203984:	b7f9                	j	ffffffffc0203952 <do_exit+0x9a>
    if (flag) {
ffffffffc0203986:	020a1263          	bnez	s4,ffffffffc02039aa <do_exit+0xf2>
    schedule();
ffffffffc020398a:	5e5000ef          	jal	ffffffffc020476e <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc020398e:	601c                	ld	a5,0(s0)
ffffffffc0203990:	00003617          	auipc	a2,0x3
ffffffffc0203994:	9e860613          	add	a2,a2,-1560 # ffffffffc0206378 <default_pmm_manager+0x818>
ffffffffc0203998:	1c700593          	li	a1,455
ffffffffc020399c:	43d4                	lw	a3,4(a5)
ffffffffc020399e:	00003517          	auipc	a0,0x3
ffffffffc02039a2:	95a50513          	add	a0,a0,-1702 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02039a6:	ac5fc0ef          	jal	ffffffffc020046a <__panic>
        intr_enable();
ffffffffc02039aa:	c4dfc0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc02039ae:	bff1                	j	ffffffffc020398a <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02039b0:	00003617          	auipc	a2,0x3
ffffffffc02039b4:	9a860613          	add	a2,a2,-1624 # ffffffffc0206358 <default_pmm_manager+0x7f8>
ffffffffc02039b8:	19b00593          	li	a1,411
ffffffffc02039bc:	00003517          	auipc	a0,0x3
ffffffffc02039c0:	93c50513          	add	a0,a0,-1732 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02039c4:	aa7fc0ef          	jal	ffffffffc020046a <__panic>
            exit_mmap(mm);
ffffffffc02039c8:	854e                	mv	a0,s3
ffffffffc02039ca:	d46ff0ef          	jal	ffffffffc0202f10 <exit_mmap>
            put_pgdir(mm);
ffffffffc02039ce:	854e                	mv	a0,s3
ffffffffc02039d0:	9b7ff0ef          	jal	ffffffffc0203386 <put_pgdir>
            mm_destroy(mm);
ffffffffc02039d4:	854e                	mv	a0,s3
ffffffffc02039d6:	ba0ff0ef          	jal	ffffffffc0202d76 <mm_destroy>
ffffffffc02039da:	bf35                	j	ffffffffc0203916 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc02039dc:	00003617          	auipc	a2,0x3
ffffffffc02039e0:	98c60613          	add	a2,a2,-1652 # ffffffffc0206368 <default_pmm_manager+0x808>
ffffffffc02039e4:	19e00593          	li	a1,414
ffffffffc02039e8:	00003517          	auipc	a0,0x3
ffffffffc02039ec:	91050513          	add	a0,a0,-1776 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02039f0:	a7bfc0ef          	jal	ffffffffc020046a <__panic>
        intr_disable();
ffffffffc02039f4:	c09fc0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc02039f8:	4a05                	li	s4,1
ffffffffc02039fa:	bf1d                	j	ffffffffc0203930 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc02039fc:	46f000ef          	jal	ffffffffc020466a <wakeup_proc>
ffffffffc0203a00:	b789                	j	ffffffffc0203942 <do_exit+0x8a>

ffffffffc0203a02 <do_wait.part.0>:
do_wait(int pid, int *code_store) {
ffffffffc0203a02:	715d                	add	sp,sp,-80
ffffffffc0203a04:	f84a                	sd	s2,48(sp)
ffffffffc0203a06:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0203a08:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203a0c:	6989                	lui	s3,0x2
do_wait(int pid, int *code_store) {
ffffffffc0203a0e:	fc26                	sd	s1,56(sp)
ffffffffc0203a10:	f052                	sd	s4,32(sp)
ffffffffc0203a12:	ec56                	sd	s5,24(sp)
ffffffffc0203a14:	e85a                	sd	s6,16(sp)
ffffffffc0203a16:	e45e                	sd	s7,8(sp)
ffffffffc0203a18:	e486                	sd	ra,72(sp)
ffffffffc0203a1a:	e0a2                	sd	s0,64(sp)
ffffffffc0203a1c:	84aa                	mv	s1,a0
ffffffffc0203a1e:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0203a20:	00051b97          	auipc	s7,0x51
ffffffffc0203a24:	0b8b8b93          	add	s7,s7,184 # ffffffffc0254ad8 <current>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203a28:	00050b1b          	sext.w	s6,a0
ffffffffc0203a2c:	fff50a9b          	addw	s5,a0,-1
ffffffffc0203a30:	19f9                	add	s3,s3,-2 # 1ffe <_binary_obj___user_ex1_out_size-0x7bca>
        current->wait_state = WT_CHILD;
ffffffffc0203a32:	0905                	add	s2,s2,1 # ffffffff80000001 <_binary_obj___user_ex3_out_size+0xffffffff7fff4d71>
    if (pid != 0) {
ffffffffc0203a34:	ccbd                	beqz	s1,ffffffffc0203ab2 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID) {
ffffffffc0203a36:	0359e863          	bltu	s3,s5,ffffffffc0203a66 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203a3a:	45a9                	li	a1,10
ffffffffc0203a3c:	855a                	mv	a0,s6
ffffffffc0203a3e:	74b000ef          	jal	ffffffffc0204988 <hash32>
ffffffffc0203a42:	02051793          	sll	a5,a0,0x20
ffffffffc0203a46:	01c7d513          	srl	a0,a5,0x1c
ffffffffc0203a4a:	0004d797          	auipc	a5,0x4d
ffffffffc0203a4e:	fd678793          	add	a5,a5,-42 # ffffffffc0250a20 <hash_list>
ffffffffc0203a52:	953e                	add	a0,a0,a5
ffffffffc0203a54:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list) {
ffffffffc0203a56:	a029                	j	ffffffffc0203a60 <do_wait.part.0+0x5e>
            if (proc->pid == pid) {
ffffffffc0203a58:	f2c42783          	lw	a5,-212(s0)
ffffffffc0203a5c:	02978163          	beq	a5,s1,ffffffffc0203a7e <do_wait.part.0+0x7c>
ffffffffc0203a60:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list) {
ffffffffc0203a62:	fe851be3          	bne	a0,s0,ffffffffc0203a58 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc0203a66:	5579                	li	a0,-2
}
ffffffffc0203a68:	60a6                	ld	ra,72(sp)
ffffffffc0203a6a:	6406                	ld	s0,64(sp)
ffffffffc0203a6c:	74e2                	ld	s1,56(sp)
ffffffffc0203a6e:	7942                	ld	s2,48(sp)
ffffffffc0203a70:	79a2                	ld	s3,40(sp)
ffffffffc0203a72:	7a02                	ld	s4,32(sp)
ffffffffc0203a74:	6ae2                	ld	s5,24(sp)
ffffffffc0203a76:	6b42                	ld	s6,16(sp)
ffffffffc0203a78:	6ba2                	ld	s7,8(sp)
ffffffffc0203a7a:	6161                	add	sp,sp,80
ffffffffc0203a7c:	8082                	ret
        if (proc != NULL && proc->parent == current) {
ffffffffc0203a7e:	000bb683          	ld	a3,0(s7)
ffffffffc0203a82:	f4843783          	ld	a5,-184(s0)
ffffffffc0203a86:	fed790e3          	bne	a5,a3,ffffffffc0203a66 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203a8a:	f2842703          	lw	a4,-216(s0)
ffffffffc0203a8e:	478d                	li	a5,3
ffffffffc0203a90:	0ef70b63          	beq	a4,a5,ffffffffc0203b86 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc0203a94:	4785                	li	a5,1
ffffffffc0203a96:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc0203a98:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc0203a9c:	4d3000ef          	jal	ffffffffc020476e <schedule>
        if (current->flags & PF_EXITING) {
ffffffffc0203aa0:	000bb783          	ld	a5,0(s7)
ffffffffc0203aa4:	0b07a783          	lw	a5,176(a5)
ffffffffc0203aa8:	8b85                	and	a5,a5,1
ffffffffc0203aaa:	d7c9                	beqz	a5,ffffffffc0203a34 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0203aac:	555d                	li	a0,-9
ffffffffc0203aae:	e0bff0ef          	jal	ffffffffc02038b8 <do_exit>
        proc = current->cptr;
ffffffffc0203ab2:	000bb683          	ld	a3,0(s7)
ffffffffc0203ab6:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr) {
ffffffffc0203ab8:	d45d                	beqz	s0,ffffffffc0203a66 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203aba:	470d                	li	a4,3
ffffffffc0203abc:	a021                	j	ffffffffc0203ac4 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr) {
ffffffffc0203abe:	10043403          	ld	s0,256(s0)
ffffffffc0203ac2:	d869                	beqz	s0,ffffffffc0203a94 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0203ac4:	401c                	lw	a5,0(s0)
ffffffffc0203ac6:	fee79ce3          	bne	a5,a4,ffffffffc0203abe <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc) {
ffffffffc0203aca:	00051797          	auipc	a5,0x51
ffffffffc0203ace:	01e7b783          	ld	a5,30(a5) # ffffffffc0254ae8 <idleproc>
ffffffffc0203ad2:	0c878963          	beq	a5,s0,ffffffffc0203ba4 <do_wait.part.0+0x1a2>
ffffffffc0203ad6:	00051797          	auipc	a5,0x51
ffffffffc0203ada:	00a7b783          	ld	a5,10(a5) # ffffffffc0254ae0 <initproc>
ffffffffc0203ade:	0cf40363          	beq	s0,a5,ffffffffc0203ba4 <do_wait.part.0+0x1a2>
    if (code_store != NULL) {
ffffffffc0203ae2:	000a0663          	beqz	s4,ffffffffc0203aee <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0203ae6:	0e842783          	lw	a5,232(s0)
ffffffffc0203aea:	00fa2023          	sw	a5,0(s4) # 1000 <_binary_obj___user_ex1_out_size-0x8bc8>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203aee:	100027f3          	csrr	a5,sstatus
ffffffffc0203af2:	8b89                	and	a5,a5,2
    return 0;
ffffffffc0203af4:	4601                	li	a2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203af6:	e7c1                	bnez	a5,ffffffffc0203b7e <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203af8:	6c74                	ld	a3,216(s0)
ffffffffc0203afa:	7078                	ld	a4,224(s0)
    if (proc->optr != NULL) {
ffffffffc0203afc:	10043783          	ld	a5,256(s0)
    prev->next = next;
ffffffffc0203b00:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0203b02:	e314                	sd	a3,0(a4)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203b04:	6474                	ld	a3,200(s0)
ffffffffc0203b06:	6878                	ld	a4,208(s0)
    prev->next = next;
ffffffffc0203b08:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0203b0a:	e314                	sd	a3,0(a4)
ffffffffc0203b0c:	c399                	beqz	a5,ffffffffc0203b12 <do_wait.part.0+0x110>
        proc->optr->yptr = proc->yptr;
ffffffffc0203b0e:	7c78                	ld	a4,248(s0)
ffffffffc0203b10:	fff8                	sd	a4,248(a5)
    if (proc->yptr != NULL) {
ffffffffc0203b12:	7c78                	ld	a4,248(s0)
ffffffffc0203b14:	c335                	beqz	a4,ffffffffc0203b78 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0203b16:	10f73023          	sd	a5,256(a4)
    nr_process --;
ffffffffc0203b1a:	00051717          	auipc	a4,0x51
ffffffffc0203b1e:	fb670713          	add	a4,a4,-74 # ffffffffc0254ad0 <nr_process>
ffffffffc0203b22:	431c                	lw	a5,0(a4)
ffffffffc0203b24:	37fd                	addw	a5,a5,-1
ffffffffc0203b26:	c31c                	sw	a5,0(a4)
    if (flag) {
ffffffffc0203b28:	e629                	bnez	a2,ffffffffc0203b72 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0203b2a:	6814                	ld	a3,16(s0)
ffffffffc0203b2c:	c02007b7          	lui	a5,0xc0200
ffffffffc0203b30:	04f6ee63          	bltu	a3,a5,ffffffffc0203b8c <do_wait.part.0+0x18a>
ffffffffc0203b34:	00051797          	auipc	a5,0x51
ffffffffc0203b38:	f5c7b783          	ld	a5,-164(a5) # ffffffffc0254a90 <va_pa_offset>
ffffffffc0203b3c:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0203b3e:	82b1                	srl	a3,a3,0xc
ffffffffc0203b40:	00051797          	auipc	a5,0x51
ffffffffc0203b44:	f587b783          	ld	a5,-168(a5) # ffffffffc0254a98 <npage>
ffffffffc0203b48:	06f6fa63          	bgeu	a3,a5,ffffffffc0203bbc <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0203b4c:	00004797          	auipc	a5,0x4
ffffffffc0203b50:	84c7b783          	ld	a5,-1972(a5) # ffffffffc0207398 <nbase>
ffffffffc0203b54:	8e9d                	sub	a3,a3,a5
ffffffffc0203b56:	069a                	sll	a3,a3,0x6
ffffffffc0203b58:	00051517          	auipc	a0,0x51
ffffffffc0203b5c:	f4853503          	ld	a0,-184(a0) # ffffffffc0254aa0 <pages>
ffffffffc0203b60:	9536                	add	a0,a0,a3
ffffffffc0203b62:	4589                	li	a1,2
ffffffffc0203b64:	892fe0ef          	jal	ffffffffc0201bf6 <free_pages>
    kfree(proc);
ffffffffc0203b68:	8522                	mv	a0,s0
ffffffffc0203b6a:	eebfd0ef          	jal	ffffffffc0201a54 <kfree>
    return 0;
ffffffffc0203b6e:	4501                	li	a0,0
ffffffffc0203b70:	bde5                	j	ffffffffc0203a68 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc0203b72:	a85fc0ef          	jal	ffffffffc02005f6 <intr_enable>
ffffffffc0203b76:	bf55                	j	ffffffffc0203b2a <do_wait.part.0+0x128>
       proc->parent->cptr = proc->optr;
ffffffffc0203b78:	7018                	ld	a4,32(s0)
ffffffffc0203b7a:	fb7c                	sd	a5,240(a4)
ffffffffc0203b7c:	bf79                	j	ffffffffc0203b1a <do_wait.part.0+0x118>
        intr_disable();
ffffffffc0203b7e:	a7ffc0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc0203b82:	4605                	li	a2,1
ffffffffc0203b84:	bf95                	j	ffffffffc0203af8 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0203b86:	f2840413          	add	s0,s0,-216
ffffffffc0203b8a:	b781                	j	ffffffffc0203aca <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc0203b8c:	00002617          	auipc	a2,0x2
ffffffffc0203b90:	07c60613          	add	a2,a2,124 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0203b94:	06e00593          	li	a1,110
ffffffffc0203b98:	00002517          	auipc	a0,0x2
ffffffffc0203b9c:	02850513          	add	a0,a0,40 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0203ba0:	8cbfc0ef          	jal	ffffffffc020046a <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc0203ba4:	00002617          	auipc	a2,0x2
ffffffffc0203ba8:	7f460613          	add	a2,a2,2036 # ffffffffc0206398 <default_pmm_manager+0x838>
ffffffffc0203bac:	2b600593          	li	a1,694
ffffffffc0203bb0:	00002517          	auipc	a0,0x2
ffffffffc0203bb4:	74850513          	add	a0,a0,1864 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203bb8:	8b3fc0ef          	jal	ffffffffc020046a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203bbc:	00002617          	auipc	a2,0x2
ffffffffc0203bc0:	07460613          	add	a2,a2,116 # ffffffffc0205c30 <default_pmm_manager+0xd0>
ffffffffc0203bc4:	06200593          	li	a1,98
ffffffffc0203bc8:	00002517          	auipc	a0,0x2
ffffffffc0203bcc:	ff850513          	add	a0,a0,-8 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc0203bd0:	89bfc0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0203bd4 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
ffffffffc0203bd4:	1141                	add	sp,sp,-16
ffffffffc0203bd6:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0203bd8:	85efe0ef          	jal	ffffffffc0201c36 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0203bdc:	dd5fd0ef          	jal	ffffffffc02019b0 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0203be0:	4601                	li	a2,0
ffffffffc0203be2:	4581                	li	a1,0
ffffffffc0203be4:	fffff517          	auipc	a0,0xfffff
ffffffffc0203be8:	72450513          	add	a0,a0,1828 # ffffffffc0203308 <user_main>
ffffffffc0203bec:	c7dff0ef          	jal	ffffffffc0203868 <kernel_thread>
    if (pid <= 0) {
ffffffffc0203bf0:	00a04563          	bgtz	a0,ffffffffc0203bfa <init_main+0x26>
ffffffffc0203bf4:	a071                	j	ffffffffc0203c80 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
ffffffffc0203bf6:	379000ef          	jal	ffffffffc020476e <schedule>
    if (code_store != NULL) {
ffffffffc0203bfa:	4581                	li	a1,0
ffffffffc0203bfc:	4501                	li	a0,0
ffffffffc0203bfe:	e05ff0ef          	jal	ffffffffc0203a02 <do_wait.part.0>
    while (do_wait(0, NULL) == 0) {
ffffffffc0203c02:	d975                	beqz	a0,ffffffffc0203bf6 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0203c04:	00002517          	auipc	a0,0x2
ffffffffc0203c08:	7d450513          	add	a0,a0,2004 # ffffffffc02063d8 <default_pmm_manager+0x878>
ffffffffc0203c0c:	d76fc0ef          	jal	ffffffffc0200182 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0203c10:	00051797          	auipc	a5,0x51
ffffffffc0203c14:	ed07b783          	ld	a5,-304(a5) # ffffffffc0254ae0 <initproc>
ffffffffc0203c18:	7bf8                	ld	a4,240(a5)
ffffffffc0203c1a:	e339                	bnez	a4,ffffffffc0203c60 <init_main+0x8c>
ffffffffc0203c1c:	7ff8                	ld	a4,248(a5)
ffffffffc0203c1e:	e329                	bnez	a4,ffffffffc0203c60 <init_main+0x8c>
ffffffffc0203c20:	1007b703          	ld	a4,256(a5)
ffffffffc0203c24:	ef15                	bnez	a4,ffffffffc0203c60 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0203c26:	00051697          	auipc	a3,0x51
ffffffffc0203c2a:	eaa6a683          	lw	a3,-342(a3) # ffffffffc0254ad0 <nr_process>
ffffffffc0203c2e:	4709                	li	a4,2
ffffffffc0203c30:	0ae69463          	bne	a3,a4,ffffffffc0203cd8 <init_main+0x104>
    return listelm->next;
ffffffffc0203c34:	00051697          	auipc	a3,0x51
ffffffffc0203c38:	dec68693          	add	a3,a3,-532 # ffffffffc0254a20 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0203c3c:	6698                	ld	a4,8(a3)
ffffffffc0203c3e:	0c878793          	add	a5,a5,200
ffffffffc0203c42:	06f71b63          	bne	a4,a5,ffffffffc0203cb8 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0203c46:	629c                	ld	a5,0(a3)
ffffffffc0203c48:	04f71863          	bne	a4,a5,ffffffffc0203c98 <init_main+0xc4>

    //cprintf("init check memory pass.\n");
    cprintf("The end of init_main\n");
ffffffffc0203c4c:	00003517          	auipc	a0,0x3
ffffffffc0203c50:	87450513          	add	a0,a0,-1932 # ffffffffc02064c0 <default_pmm_manager+0x960>
ffffffffc0203c54:	d2efc0ef          	jal	ffffffffc0200182 <cprintf>
    return 0;
}
ffffffffc0203c58:	60a2                	ld	ra,8(sp)
ffffffffc0203c5a:	4501                	li	a0,0
ffffffffc0203c5c:	0141                	add	sp,sp,16
ffffffffc0203c5e:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0203c60:	00002697          	auipc	a3,0x2
ffffffffc0203c64:	7a068693          	add	a3,a3,1952 # ffffffffc0206400 <default_pmm_manager+0x8a0>
ffffffffc0203c68:	00002617          	auipc	a2,0x2
ffffffffc0203c6c:	86060613          	add	a2,a2,-1952 # ffffffffc02054c8 <commands+0x430>
ffffffffc0203c70:	31a00593          	li	a1,794
ffffffffc0203c74:	00002517          	auipc	a0,0x2
ffffffffc0203c78:	68450513          	add	a0,a0,1668 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203c7c:	feefc0ef          	jal	ffffffffc020046a <__panic>
        panic("create user_main failed.\n");
ffffffffc0203c80:	00002617          	auipc	a2,0x2
ffffffffc0203c84:	73860613          	add	a2,a2,1848 # ffffffffc02063b8 <default_pmm_manager+0x858>
ffffffffc0203c88:	31200593          	li	a1,786
ffffffffc0203c8c:	00002517          	auipc	a0,0x2
ffffffffc0203c90:	66c50513          	add	a0,a0,1644 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203c94:	fd6fc0ef          	jal	ffffffffc020046a <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0203c98:	00002697          	auipc	a3,0x2
ffffffffc0203c9c:	7f868693          	add	a3,a3,2040 # ffffffffc0206490 <default_pmm_manager+0x930>
ffffffffc0203ca0:	00002617          	auipc	a2,0x2
ffffffffc0203ca4:	82860613          	add	a2,a2,-2008 # ffffffffc02054c8 <commands+0x430>
ffffffffc0203ca8:	31d00593          	li	a1,797
ffffffffc0203cac:	00002517          	auipc	a0,0x2
ffffffffc0203cb0:	64c50513          	add	a0,a0,1612 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203cb4:	fb6fc0ef          	jal	ffffffffc020046a <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0203cb8:	00002697          	auipc	a3,0x2
ffffffffc0203cbc:	7a868693          	add	a3,a3,1960 # ffffffffc0206460 <default_pmm_manager+0x900>
ffffffffc0203cc0:	00002617          	auipc	a2,0x2
ffffffffc0203cc4:	80860613          	add	a2,a2,-2040 # ffffffffc02054c8 <commands+0x430>
ffffffffc0203cc8:	31c00593          	li	a1,796
ffffffffc0203ccc:	00002517          	auipc	a0,0x2
ffffffffc0203cd0:	62c50513          	add	a0,a0,1580 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203cd4:	f96fc0ef          	jal	ffffffffc020046a <__panic>
    assert(nr_process == 2);
ffffffffc0203cd8:	00002697          	auipc	a3,0x2
ffffffffc0203cdc:	77868693          	add	a3,a3,1912 # ffffffffc0206450 <default_pmm_manager+0x8f0>
ffffffffc0203ce0:	00001617          	auipc	a2,0x1
ffffffffc0203ce4:	7e860613          	add	a2,a2,2024 # ffffffffc02054c8 <commands+0x430>
ffffffffc0203ce8:	31b00593          	li	a1,795
ffffffffc0203cec:	00002517          	auipc	a0,0x2
ffffffffc0203cf0:	60c50513          	add	a0,a0,1548 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203cf4:	f76fc0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0203cf8 <do_execve>:
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203cf8:	7171                	add	sp,sp,-176
ffffffffc0203cfa:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0203cfc:	00051d97          	auipc	s11,0x51
ffffffffc0203d00:	ddcd8d93          	add	s11,s11,-548 # ffffffffc0254ad8 <current>
ffffffffc0203d04:	000db783          	ld	a5,0(s11)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203d08:	e54e                	sd	s3,136(sp)
ffffffffc0203d0a:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0203d0c:	0287b983          	ld	s3,40(a5)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203d10:	e94a                	sd	s2,144(sp)
ffffffffc0203d12:	fcd6                	sd	s5,120(sp)
ffffffffc0203d14:	892a                	mv	s2,a0
ffffffffc0203d16:	84ae                	mv	s1,a1
ffffffffc0203d18:	8ab2                	mv	s5,a2
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc0203d1a:	4681                	li	a3,0
ffffffffc0203d1c:	862e                	mv	a2,a1
ffffffffc0203d1e:	85aa                	mv	a1,a0
ffffffffc0203d20:	854e                	mv	a0,s3
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0203d22:	f506                	sd	ra,168(sp)
ffffffffc0203d24:	f122                	sd	s0,160(sp)
ffffffffc0203d26:	e152                	sd	s4,128(sp)
ffffffffc0203d28:	f8da                	sd	s6,112(sp)
ffffffffc0203d2a:	f4de                	sd	s7,104(sp)
ffffffffc0203d2c:	f0e2                	sd	s8,96(sp)
ffffffffc0203d2e:	ece6                	sd	s9,88(sp)
ffffffffc0203d30:	e8ea                	sd	s10,80(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc0203d32:	b58ff0ef          	jal	ffffffffc020308a <user_mem_check>
ffffffffc0203d36:	42050163          	beqz	a0,ffffffffc0204158 <do_execve+0x460>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0203d3a:	4641                	li	a2,16
ffffffffc0203d3c:	4581                	li	a1,0
ffffffffc0203d3e:	1808                	add	a0,sp,48
ffffffffc0203d40:	0cc010ef          	jal	ffffffffc0204e0c <memset>
    if (len > PROC_NAME_LEN) {
ffffffffc0203d44:	47bd                	li	a5,15
ffffffffc0203d46:	8626                	mv	a2,s1
ffffffffc0203d48:	0e97e163          	bltu	a5,s1,ffffffffc0203e2a <do_execve+0x132>
    memcpy(local_name, name, len);
ffffffffc0203d4c:	85ca                	mv	a1,s2
ffffffffc0203d4e:	1808                	add	a0,sp,48
ffffffffc0203d50:	0ce010ef          	jal	ffffffffc0204e1e <memcpy>
    if (mm != NULL) {
ffffffffc0203d54:	0e098263          	beqz	s3,ffffffffc0203e38 <do_execve+0x140>
        cputs("mm != NULL");
ffffffffc0203d58:	00002517          	auipc	a0,0x2
ffffffffc0203d5c:	3d850513          	add	a0,a0,984 # ffffffffc0206130 <default_pmm_manager+0x5d0>
ffffffffc0203d60:	c5afc0ef          	jal	ffffffffc02001ba <cputs>
ffffffffc0203d64:	00051797          	auipc	a5,0x51
ffffffffc0203d68:	d1c7b783          	ld	a5,-740(a5) # ffffffffc0254a80 <boot_cr3>
ffffffffc0203d6c:	577d                	li	a4,-1
ffffffffc0203d6e:	177e                	sll	a4,a4,0x3f
ffffffffc0203d70:	83b1                	srl	a5,a5,0xc
ffffffffc0203d72:	8fd9                	or	a5,a5,a4
ffffffffc0203d74:	18079073          	csrw	satp,a5
ffffffffc0203d78:	0309a783          	lw	a5,48(s3)
ffffffffc0203d7c:	fff7871b          	addw	a4,a5,-1
ffffffffc0203d80:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0) {
ffffffffc0203d84:	2a070a63          	beqz	a4,ffffffffc0204038 <do_execve+0x340>
        current->mm = NULL;
ffffffffc0203d88:	000db783          	ld	a5,0(s11)
ffffffffc0203d8c:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL) {
ffffffffc0203d90:	e8ffe0ef          	jal	ffffffffc0202c1e <mm_create>
ffffffffc0203d94:	84aa                	mv	s1,a0
ffffffffc0203d96:	1c050a63          	beqz	a0,ffffffffc0203f6a <do_execve+0x272>
    if ((page = alloc_page()) == NULL) {
ffffffffc0203d9a:	4505                	li	a0,1
ffffffffc0203d9c:	dcbfd0ef          	jal	ffffffffc0201b66 <alloc_pages>
ffffffffc0203da0:	3c050063          	beqz	a0,ffffffffc0204160 <do_execve+0x468>
    return page - pages + nbase;
ffffffffc0203da4:	00051d17          	auipc	s10,0x51
ffffffffc0203da8:	cfcd0d13          	add	s10,s10,-772 # ffffffffc0254aa0 <pages>
ffffffffc0203dac:	000d3783          	ld	a5,0(s10)
    return KADDR(page2pa(page));
ffffffffc0203db0:	00051c97          	auipc	s9,0x51
ffffffffc0203db4:	ce8c8c93          	add	s9,s9,-792 # ffffffffc0254a98 <npage>
    return page - pages + nbase;
ffffffffc0203db8:	00003717          	auipc	a4,0x3
ffffffffc0203dbc:	5e073703          	ld	a4,1504(a4) # ffffffffc0207398 <nbase>
ffffffffc0203dc0:	40f506b3          	sub	a3,a0,a5
ffffffffc0203dc4:	8699                	sra	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0203dc6:	5bfd                	li	s7,-1
ffffffffc0203dc8:	000cb783          	ld	a5,0(s9)
    return page - pages + nbase;
ffffffffc0203dcc:	96ba                	add	a3,a3,a4
ffffffffc0203dce:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0203dd0:	00cbd713          	srl	a4,s7,0xc
ffffffffc0203dd4:	f03a                	sd	a4,32(sp)
ffffffffc0203dd6:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203dd8:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203dda:	38f77763          	bgeu	a4,a5,ffffffffc0204168 <do_execve+0x470>
ffffffffc0203dde:	00051b17          	auipc	s6,0x51
ffffffffc0203de2:	cb2b0b13          	add	s6,s6,-846 # ffffffffc0254a90 <va_pa_offset>
ffffffffc0203de6:	000b3783          	ld	a5,0(s6)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0203dea:	6605                	lui	a2,0x1
ffffffffc0203dec:	00051597          	auipc	a1,0x51
ffffffffc0203df0:	c9c5b583          	ld	a1,-868(a1) # ffffffffc0254a88 <boot_pgdir>
ffffffffc0203df4:	00f68933          	add	s2,a3,a5
ffffffffc0203df8:	854a                	mv	a0,s2
ffffffffc0203dfa:	024010ef          	jal	ffffffffc0204e1e <memcpy>
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0203dfe:	000aa703          	lw	a4,0(s5)
ffffffffc0203e02:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0203e06:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0203e0a:	57f78793          	add	a5,a5,1407 # 464c457f <_binary_obj___user_ex3_out_size+0x464b92ef>
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0203e0e:	020aba03          	ld	s4,32(s5)
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0203e12:	04f70363          	beq	a4,a5,ffffffffc0203e58 <do_execve+0x160>
        ret = -E_INVAL_ELF;
ffffffffc0203e16:	5961                	li	s2,-8
    put_pgdir(mm);
ffffffffc0203e18:	8526                	mv	a0,s1
ffffffffc0203e1a:	d6cff0ef          	jal	ffffffffc0203386 <put_pgdir>
    mm_destroy(mm);
ffffffffc0203e1e:	8526                	mv	a0,s1
ffffffffc0203e20:	f57fe0ef          	jal	ffffffffc0202d76 <mm_destroy>
    do_exit(ret);
ffffffffc0203e24:	854a                	mv	a0,s2
ffffffffc0203e26:	a93ff0ef          	jal	ffffffffc02038b8 <do_exit>
    if (len > PROC_NAME_LEN) {
ffffffffc0203e2a:	463d                	li	a2,15
    memcpy(local_name, name, len);
ffffffffc0203e2c:	85ca                	mv	a1,s2
ffffffffc0203e2e:	1808                	add	a0,sp,48
ffffffffc0203e30:	7ef000ef          	jal	ffffffffc0204e1e <memcpy>
    if (mm != NULL) {
ffffffffc0203e34:	f20992e3          	bnez	s3,ffffffffc0203d58 <do_execve+0x60>
    if (current->mm != NULL) {
ffffffffc0203e38:	000db783          	ld	a5,0(s11)
ffffffffc0203e3c:	779c                	ld	a5,40(a5)
ffffffffc0203e3e:	dba9                	beqz	a5,ffffffffc0203d90 <do_execve+0x98>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0203e40:	00002617          	auipc	a2,0x2
ffffffffc0203e44:	69860613          	add	a2,a2,1688 # ffffffffc02064d8 <default_pmm_manager+0x978>
ffffffffc0203e48:	1d100593          	li	a1,465
ffffffffc0203e4c:	00002517          	auipc	a0,0x2
ffffffffc0203e50:	4ac50513          	add	a0,a0,1196 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0203e54:	e16fc0ef          	jal	ffffffffc020046a <__panic>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0203e58:	038ad703          	lhu	a4,56(s5)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0203e5c:	9a56                	add	s4,s4,s5
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0203e5e:	00371793          	sll	a5,a4,0x3
ffffffffc0203e62:	8f99                	sub	a5,a5,a4
ffffffffc0203e64:	078e                	sll	a5,a5,0x3
ffffffffc0203e66:	97d2                	add	a5,a5,s4
ffffffffc0203e68:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph ++) {
ffffffffc0203e6a:	00fa7c63          	bgeu	s4,a5,ffffffffc0203e82 <do_execve+0x18a>
        if (ph->p_type != ELF_PT_LOAD) {
ffffffffc0203e6e:	000a2783          	lw	a5,0(s4)
ffffffffc0203e72:	4705                	li	a4,1
ffffffffc0203e74:	0ee78d63          	beq	a5,a4,ffffffffc0203f6e <do_execve+0x276>
    for (; ph < ph_end; ph ++) {
ffffffffc0203e78:	77a2                	ld	a5,40(sp)
ffffffffc0203e7a:	038a0a13          	add	s4,s4,56
ffffffffc0203e7e:	fefa68e3          	bltu	s4,a5,ffffffffc0203e6e <do_execve+0x176>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
ffffffffc0203e82:	4701                	li	a4,0
ffffffffc0203e84:	46ad                	li	a3,11
ffffffffc0203e86:	00100637          	lui	a2,0x100
ffffffffc0203e8a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0203e8e:	8526                	mv	a0,s1
ffffffffc0203e90:	f39fe0ef          	jal	ffffffffc0202dc8 <mm_map>
ffffffffc0203e94:	892a                	mv	s2,a0
ffffffffc0203e96:	18051d63          	bnez	a0,ffffffffc0204030 <do_execve+0x338>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc0203e9a:	6c88                	ld	a0,24(s1)
ffffffffc0203e9c:	467d                	li	a2,31
ffffffffc0203e9e:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0203ea2:	e90fe0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc0203ea6:	34050963          	beqz	a0,ffffffffc02041f8 <do_execve+0x500>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc0203eaa:	6c88                	ld	a0,24(s1)
ffffffffc0203eac:	467d                	li	a2,31
ffffffffc0203eae:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0203eb2:	e80fe0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc0203eb6:	32050163          	beqz	a0,ffffffffc02041d8 <do_execve+0x4e0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc0203eba:	6c88                	ld	a0,24(s1)
ffffffffc0203ebc:	467d                	li	a2,31
ffffffffc0203ebe:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0203ec2:	e70fe0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc0203ec6:	2e050963          	beqz	a0,ffffffffc02041b8 <do_execve+0x4c0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0203eca:	6c88                	ld	a0,24(s1)
ffffffffc0203ecc:	467d                	li	a2,31
ffffffffc0203ece:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0203ed2:	e60fe0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc0203ed6:	2c050163          	beqz	a0,ffffffffc0204198 <do_execve+0x4a0>
    mm->mm_count += 1;
ffffffffc0203eda:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0203edc:	000db603          	ld	a2,0(s11)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0203ee0:	6c94                	ld	a3,24(s1)
ffffffffc0203ee2:	2785                	addw	a5,a5,1
ffffffffc0203ee4:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0203ee6:	f604                	sd	s1,40(a2)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0203ee8:	c02007b7          	lui	a5,0xc0200
ffffffffc0203eec:	28f6ea63          	bltu	a3,a5,ffffffffc0204180 <do_execve+0x488>
ffffffffc0203ef0:	000b3783          	ld	a5,0(s6)
ffffffffc0203ef4:	577d                	li	a4,-1
ffffffffc0203ef6:	177e                	sll	a4,a4,0x3f
ffffffffc0203ef8:	8e9d                	sub	a3,a3,a5
ffffffffc0203efa:	00c6d793          	srl	a5,a3,0xc
ffffffffc0203efe:	f654                	sd	a3,168(a2)
ffffffffc0203f00:	8fd9                	or	a5,a5,a4
ffffffffc0203f02:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0203f06:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0203f08:	4581                	li	a1,0
ffffffffc0203f0a:	12000613          	li	a2,288
ffffffffc0203f0e:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0203f10:	10043983          	ld	s3,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0203f14:	6f9000ef          	jal	ffffffffc0204e0c <memset>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f18:	000db483          	ld	s1,0(s11)
    tf->epc = elf->e_entry;
ffffffffc0203f1c:	018ab703          	ld	a4,24(s5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0203f20:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f22:	0b448493          	add	s1,s1,180
    tf->gpr.sp = USTACKTOP;
ffffffffc0203f26:	07fe                	sll	a5,a5,0x1f
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0203f28:	edf9f993          	and	s3,s3,-289
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f2c:	4641                	li	a2,16
ffffffffc0203f2e:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0203f30:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0203f32:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0203f36:	11343023          	sd	s3,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203f3a:	8526                	mv	a0,s1
ffffffffc0203f3c:	6d1000ef          	jal	ffffffffc0204e0c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0203f40:	463d                	li	a2,15
ffffffffc0203f42:	180c                	add	a1,sp,48
ffffffffc0203f44:	8526                	mv	a0,s1
ffffffffc0203f46:	6d9000ef          	jal	ffffffffc0204e1e <memcpy>
}
ffffffffc0203f4a:	70aa                	ld	ra,168(sp)
ffffffffc0203f4c:	740a                	ld	s0,160(sp)
ffffffffc0203f4e:	64ea                	ld	s1,152(sp)
ffffffffc0203f50:	69aa                	ld	s3,136(sp)
ffffffffc0203f52:	6a0a                	ld	s4,128(sp)
ffffffffc0203f54:	7ae6                	ld	s5,120(sp)
ffffffffc0203f56:	7b46                	ld	s6,112(sp)
ffffffffc0203f58:	7ba6                	ld	s7,104(sp)
ffffffffc0203f5a:	7c06                	ld	s8,96(sp)
ffffffffc0203f5c:	6ce6                	ld	s9,88(sp)
ffffffffc0203f5e:	6d46                	ld	s10,80(sp)
ffffffffc0203f60:	6da6                	ld	s11,72(sp)
ffffffffc0203f62:	854a                	mv	a0,s2
ffffffffc0203f64:	694a                	ld	s2,144(sp)
ffffffffc0203f66:	614d                	add	sp,sp,176
ffffffffc0203f68:	8082                	ret
    int ret = -E_NO_MEM;
ffffffffc0203f6a:	5971                	li	s2,-4
ffffffffc0203f6c:	bd65                	j	ffffffffc0203e24 <do_execve+0x12c>
        if (ph->p_filesz > ph->p_memsz) {
ffffffffc0203f6e:	028a3603          	ld	a2,40(s4)
ffffffffc0203f72:	020a3783          	ld	a5,32(s4)
ffffffffc0203f76:	1ef66763          	bltu	a2,a5,ffffffffc0204164 <do_execve+0x46c>
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc0203f7a:	004a2783          	lw	a5,4(s4)
ffffffffc0203f7e:	0017f713          	and	a4,a5,1
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0203f82:	0027f593          	and	a1,a5,2
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc0203f86:	0027169b          	sllw	a3,a4,0x2
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0203f8a:	8b91                	and	a5,a5,4
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc0203f8c:	070a                	sll	a4,a4,0x2
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0203f8e:	cddd                	beqz	a1,ffffffffc020404c <do_execve+0x354>
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0203f90:	1a079b63          	bnez	a5,ffffffffc0204146 <do_execve+0x44e>
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0203f94:	0026e693          	or	a3,a3,2
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc0203f98:	47dd                	li	a5,23
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0203f9a:	2681                	sext.w	a3,a3
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc0203f9c:	ec3e                	sd	a5,24(sp)
        if (vm_flags & VM_EXEC) perm |= PTE_X;
ffffffffc0203f9e:	c709                	beqz	a4,ffffffffc0203fa8 <do_execve+0x2b0>
ffffffffc0203fa0:	67e2                	ld	a5,24(sp)
ffffffffc0203fa2:	0087e793          	or	a5,a5,8
ffffffffc0203fa6:	ec3e                	sd	a5,24(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
ffffffffc0203fa8:	010a3583          	ld	a1,16(s4)
ffffffffc0203fac:	4701                	li	a4,0
ffffffffc0203fae:	8526                	mv	a0,s1
ffffffffc0203fb0:	e19fe0ef          	jal	ffffffffc0202dc8 <mm_map>
ffffffffc0203fb4:	892a                	mv	s2,a0
ffffffffc0203fb6:	ed2d                	bnez	a0,ffffffffc0204030 <do_execve+0x338>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0203fb8:	010a3c03          	ld	s8,16(s4)
        end = ph->p_va + ph->p_filesz;
ffffffffc0203fbc:	020a3903          	ld	s2,32(s4)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0203fc0:	008a3983          	ld	s3,8(s4)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0203fc4:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0203fc6:	9962                	add	s2,s2,s8
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0203fc8:	00fc7bb3          	and	s7,s8,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0203fcc:	99d6                	add	s3,s3,s5
        while (start < end) {
ffffffffc0203fce:	052c6963          	bltu	s8,s2,ffffffffc0204020 <do_execve+0x328>
ffffffffc0203fd2:	a269                	j	ffffffffc020415c <do_execve+0x464>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0203fd4:	6785                	lui	a5,0x1
ffffffffc0203fd6:	417c0533          	sub	a0,s8,s7
ffffffffc0203fda:	9bbe                	add	s7,s7,a5
            if (end < la) {
ffffffffc0203fdc:	41890633          	sub	a2,s2,s8
ffffffffc0203fe0:	01796463          	bltu	s2,s7,ffffffffc0203fe8 <do_execve+0x2f0>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0203fe4:	418b8633          	sub	a2,s7,s8
    return page - pages + nbase;
ffffffffc0203fe8:	000d3683          	ld	a3,0(s10)
ffffffffc0203fec:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0203fee:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0203ff2:	40d406b3          	sub	a3,s0,a3
ffffffffc0203ff6:	8699                	sra	a3,a3,0x6
ffffffffc0203ff8:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203ffa:	7782                	ld	a5,32(sp)
ffffffffc0203ffc:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204000:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204002:	16b87363          	bgeu	a6,a1,ffffffffc0204168 <do_execve+0x470>
ffffffffc0204006:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc020400a:	85ce                	mv	a1,s3
            start += size, from += size;
ffffffffc020400c:	9c32                	add	s8,s8,a2
ffffffffc020400e:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204010:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204012:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204014:	60b000ef          	jal	ffffffffc0204e1e <memcpy>
            start += size, from += size;
ffffffffc0204018:	6622                	ld	a2,8(sp)
ffffffffc020401a:	99b2                	add	s3,s3,a2
        while (start < end) {
ffffffffc020401c:	032c7d63          	bgeu	s8,s2,ffffffffc0204056 <do_execve+0x35e>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0204020:	6c88                	ld	a0,24(s1)
ffffffffc0204022:	6662                	ld	a2,24(sp)
ffffffffc0204024:	85de                	mv	a1,s7
ffffffffc0204026:	d0cfe0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc020402a:	842a                	mv	s0,a0
ffffffffc020402c:	f545                	bnez	a0,ffffffffc0203fd4 <do_execve+0x2dc>
        ret = -E_NO_MEM;
ffffffffc020402e:	5971                	li	s2,-4
    exit_mmap(mm);
ffffffffc0204030:	8526                	mv	a0,s1
ffffffffc0204032:	edffe0ef          	jal	ffffffffc0202f10 <exit_mmap>
ffffffffc0204036:	b3cd                	j	ffffffffc0203e18 <do_execve+0x120>
            exit_mmap(mm);
ffffffffc0204038:	854e                	mv	a0,s3
ffffffffc020403a:	ed7fe0ef          	jal	ffffffffc0202f10 <exit_mmap>
            put_pgdir(mm);
ffffffffc020403e:	854e                	mv	a0,s3
ffffffffc0204040:	b46ff0ef          	jal	ffffffffc0203386 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204044:	854e                	mv	a0,s3
ffffffffc0204046:	d31fe0ef          	jal	ffffffffc0202d76 <mm_destroy>
ffffffffc020404a:	bb3d                	j	ffffffffc0203d88 <do_execve+0x90>
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc020404c:	e7fd                	bnez	a5,ffffffffc020413a <do_execve+0x442>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc020404e:	47c5                	li	a5,17
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0204050:	86ba                	mv	a3,a4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204052:	ec3e                	sd	a5,24(sp)
ffffffffc0204054:	b7a9                	j	ffffffffc0203f9e <do_execve+0x2a6>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204056:	010a3903          	ld	s2,16(s4)
ffffffffc020405a:	028a3683          	ld	a3,40(s4)
ffffffffc020405e:	9936                	add	s2,s2,a3
        if (start < la) {
ffffffffc0204060:	077c7b63          	bgeu	s8,s7,ffffffffc02040d6 <do_execve+0x3de>
            if (start == end) {
ffffffffc0204064:	e1890ae3          	beq	s2,s8,ffffffffc0203e78 <do_execve+0x180>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204068:	6505                	lui	a0,0x1
ffffffffc020406a:	9562                	add	a0,a0,s8
ffffffffc020406c:	41750533          	sub	a0,a0,s7
                size -= la - end;
ffffffffc0204070:	418909b3          	sub	s3,s2,s8
            if (end < la) {
ffffffffc0204074:	0d797f63          	bgeu	s2,s7,ffffffffc0204152 <do_execve+0x45a>
    return page - pages + nbase;
ffffffffc0204078:	000d3683          	ld	a3,0(s10)
ffffffffc020407c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc020407e:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204082:	40d406b3          	sub	a3,s0,a3
ffffffffc0204086:	8699                	sra	a3,a3,0x6
ffffffffc0204088:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020408a:	00c69613          	sll	a2,a3,0xc
ffffffffc020408e:	8231                	srl	a2,a2,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0204090:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204092:	0cb67b63          	bgeu	a2,a1,ffffffffc0204168 <do_execve+0x470>
ffffffffc0204096:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc020409a:	864e                	mv	a2,s3
ffffffffc020409c:	4581                	li	a1,0
ffffffffc020409e:	96c2                	add	a3,a3,a6
ffffffffc02040a0:	9536                	add	a0,a0,a3
ffffffffc02040a2:	56b000ef          	jal	ffffffffc0204e0c <memset>
            start += size;
ffffffffc02040a6:	99e2                	add	s3,s3,s8
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc02040a8:	03797463          	bgeu	s2,s7,ffffffffc02040d0 <do_execve+0x3d8>
ffffffffc02040ac:	dd3906e3          	beq	s2,s3,ffffffffc0203e78 <do_execve+0x180>
ffffffffc02040b0:	00002697          	auipc	a3,0x2
ffffffffc02040b4:	45068693          	add	a3,a3,1104 # ffffffffc0206500 <default_pmm_manager+0x9a0>
ffffffffc02040b8:	00001617          	auipc	a2,0x1
ffffffffc02040bc:	41060613          	add	a2,a2,1040 # ffffffffc02054c8 <commands+0x430>
ffffffffc02040c0:	22600593          	li	a1,550
ffffffffc02040c4:	00002517          	auipc	a0,0x2
ffffffffc02040c8:	23450513          	add	a0,a0,564 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02040cc:	b9efc0ef          	jal	ffffffffc020046a <__panic>
ffffffffc02040d0:	ff7990e3          	bne	s3,s7,ffffffffc02040b0 <do_execve+0x3b8>
ffffffffc02040d4:	8c5e                	mv	s8,s7
        while (start < end) {
ffffffffc02040d6:	db2c71e3          	bgeu	s8,s2,ffffffffc0203e78 <do_execve+0x180>
ffffffffc02040da:	56fd                	li	a3,-1
ffffffffc02040dc:	00c6d793          	srl	a5,a3,0xc
ffffffffc02040e0:	6985                	lui	s3,0x1
ffffffffc02040e2:	e43e                	sd	a5,8(sp)
ffffffffc02040e4:	a099                	j	ffffffffc020412a <do_execve+0x432>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc02040e6:	417c0533          	sub	a0,s8,s7
ffffffffc02040ea:	9bce                	add	s7,s7,s3
            if (end < la) {
ffffffffc02040ec:	41890633          	sub	a2,s2,s8
ffffffffc02040f0:	01796463          	bltu	s2,s7,ffffffffc02040f8 <do_execve+0x400>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc02040f4:	418b8633          	sub	a2,s7,s8
    return page - pages + nbase;
ffffffffc02040f8:	000d3683          	ld	a3,0(s10)
ffffffffc02040fc:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc02040fe:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0204102:	40d406b3          	sub	a3,s0,a3
ffffffffc0204106:	8699                	sra	a3,a3,0x6
ffffffffc0204108:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc020410a:	67a2                	ld	a5,8(sp)
ffffffffc020410c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204110:	06b2                	sll	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204112:	04b87b63          	bgeu	a6,a1,ffffffffc0204168 <do_execve+0x470>
ffffffffc0204116:	000b3803          	ld	a6,0(s6)
            start += size;
ffffffffc020411a:	9c32                	add	s8,s8,a2
            memset(page2kva(page) + off, 0, size);
ffffffffc020411c:	4581                	li	a1,0
ffffffffc020411e:	96c2                	add	a3,a3,a6
ffffffffc0204120:	9536                	add	a0,a0,a3
ffffffffc0204122:	4eb000ef          	jal	ffffffffc0204e0c <memset>
        while (start < end) {
ffffffffc0204126:	d52c79e3          	bgeu	s8,s2,ffffffffc0203e78 <do_execve+0x180>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc020412a:	6c88                	ld	a0,24(s1)
ffffffffc020412c:	6662                	ld	a2,24(sp)
ffffffffc020412e:	85de                	mv	a1,s7
ffffffffc0204130:	c02fe0ef          	jal	ffffffffc0202532 <pgdir_alloc_page>
ffffffffc0204134:	842a                	mv	s0,a0
ffffffffc0204136:	f945                	bnez	a0,ffffffffc02040e6 <do_execve+0x3ee>
ffffffffc0204138:	bddd                	j	ffffffffc020402e <do_execve+0x336>
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc020413a:	0016e693          	or	a3,a3,1
        if (vm_flags & VM_READ) perm |= PTE_R;
ffffffffc020413e:	47cd                	li	a5,19
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0204140:	2681                	sext.w	a3,a3
        if (vm_flags & VM_READ) perm |= PTE_R;
ffffffffc0204142:	ec3e                	sd	a5,24(sp)
ffffffffc0204144:	bda9                	j	ffffffffc0203f9e <do_execve+0x2a6>
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0204146:	0036e693          	or	a3,a3,3
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc020414a:	47dd                	li	a5,23
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc020414c:	2681                	sext.w	a3,a3
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc020414e:	ec3e                	sd	a5,24(sp)
ffffffffc0204150:	b5b9                	j	ffffffffc0203f9e <do_execve+0x2a6>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204152:	418b89b3          	sub	s3,s7,s8
ffffffffc0204156:	b70d                	j	ffffffffc0204078 <do_execve+0x380>
        return -E_INVAL;
ffffffffc0204158:	5975                	li	s2,-3
ffffffffc020415a:	bbc5                	j	ffffffffc0203f4a <do_execve+0x252>
        while (start < end) {
ffffffffc020415c:	8962                	mv	s2,s8
ffffffffc020415e:	bdf5                	j	ffffffffc020405a <do_execve+0x362>
    int ret = -E_NO_MEM;
ffffffffc0204160:	5971                	li	s2,-4
ffffffffc0204162:	b975                	j	ffffffffc0203e1e <do_execve+0x126>
            ret = -E_INVAL_ELF;
ffffffffc0204164:	5961                	li	s2,-8
ffffffffc0204166:	b5e9                	j	ffffffffc0204030 <do_execve+0x338>
ffffffffc0204168:	00002617          	auipc	a2,0x2
ffffffffc020416c:	a3060613          	add	a2,a2,-1488 # ffffffffc0205b98 <default_pmm_manager+0x38>
ffffffffc0204170:	06900593          	li	a1,105
ffffffffc0204174:	00002517          	auipc	a0,0x2
ffffffffc0204178:	a4c50513          	add	a0,a0,-1460 # ffffffffc0205bc0 <default_pmm_manager+0x60>
ffffffffc020417c:	aeefc0ef          	jal	ffffffffc020046a <__panic>
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0204180:	00002617          	auipc	a2,0x2
ffffffffc0204184:	a8860613          	add	a2,a2,-1400 # ffffffffc0205c08 <default_pmm_manager+0xa8>
ffffffffc0204188:	24100593          	li	a1,577
ffffffffc020418c:	00002517          	auipc	a0,0x2
ffffffffc0204190:	16c50513          	add	a0,a0,364 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0204194:	ad6fc0ef          	jal	ffffffffc020046a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0204198:	00002697          	auipc	a3,0x2
ffffffffc020419c:	48068693          	add	a3,a3,1152 # ffffffffc0206618 <default_pmm_manager+0xab8>
ffffffffc02041a0:	00001617          	auipc	a2,0x1
ffffffffc02041a4:	32860613          	add	a2,a2,808 # ffffffffc02054c8 <commands+0x430>
ffffffffc02041a8:	23c00593          	li	a1,572
ffffffffc02041ac:	00002517          	auipc	a0,0x2
ffffffffc02041b0:	14c50513          	add	a0,a0,332 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02041b4:	ab6fc0ef          	jal	ffffffffc020046a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc02041b8:	00002697          	auipc	a3,0x2
ffffffffc02041bc:	41868693          	add	a3,a3,1048 # ffffffffc02065d0 <default_pmm_manager+0xa70>
ffffffffc02041c0:	00001617          	auipc	a2,0x1
ffffffffc02041c4:	30860613          	add	a2,a2,776 # ffffffffc02054c8 <commands+0x430>
ffffffffc02041c8:	23b00593          	li	a1,571
ffffffffc02041cc:	00002517          	auipc	a0,0x2
ffffffffc02041d0:	12c50513          	add	a0,a0,300 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02041d4:	a96fc0ef          	jal	ffffffffc020046a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc02041d8:	00002697          	auipc	a3,0x2
ffffffffc02041dc:	3b068693          	add	a3,a3,944 # ffffffffc0206588 <default_pmm_manager+0xa28>
ffffffffc02041e0:	00001617          	auipc	a2,0x1
ffffffffc02041e4:	2e860613          	add	a2,a2,744 # ffffffffc02054c8 <commands+0x430>
ffffffffc02041e8:	23a00593          	li	a1,570
ffffffffc02041ec:	00002517          	auipc	a0,0x2
ffffffffc02041f0:	10c50513          	add	a0,a0,268 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc02041f4:	a76fc0ef          	jal	ffffffffc020046a <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc02041f8:	00002697          	auipc	a3,0x2
ffffffffc02041fc:	34868693          	add	a3,a3,840 # ffffffffc0206540 <default_pmm_manager+0x9e0>
ffffffffc0204200:	00001617          	auipc	a2,0x1
ffffffffc0204204:	2c860613          	add	a2,a2,712 # ffffffffc02054c8 <commands+0x430>
ffffffffc0204208:	23900593          	li	a1,569
ffffffffc020420c:	00002517          	auipc	a0,0x2
ffffffffc0204210:	0ec50513          	add	a0,a0,236 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0204214:	a56fc0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0204218 <do_yield>:
    current->need_resched = 1;
ffffffffc0204218:	00051797          	auipc	a5,0x51
ffffffffc020421c:	8c07b783          	ld	a5,-1856(a5) # ffffffffc0254ad8 <current>
ffffffffc0204220:	4705                	li	a4,1
ffffffffc0204222:	ef98                	sd	a4,24(a5)
}
ffffffffc0204224:	4501                	li	a0,0
ffffffffc0204226:	8082                	ret

ffffffffc0204228 <do_wait>:
do_wait(int pid, int *code_store) {
ffffffffc0204228:	1101                	add	sp,sp,-32
ffffffffc020422a:	e822                	sd	s0,16(sp)
ffffffffc020422c:	e426                	sd	s1,8(sp)
    struct mm_struct *mm = current->mm;
ffffffffc020422e:	00051797          	auipc	a5,0x51
ffffffffc0204232:	8aa7b783          	ld	a5,-1878(a5) # ffffffffc0254ad8 <current>
do_wait(int pid, int *code_store) {
ffffffffc0204236:	ec06                	sd	ra,24(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204238:	779c                	ld	a5,40(a5)
do_wait(int pid, int *code_store) {
ffffffffc020423a:	842e                	mv	s0,a1
ffffffffc020423c:	84aa                	mv	s1,a0
    if (code_store != NULL) {
ffffffffc020423e:	c599                	beqz	a1,ffffffffc020424c <do_wait+0x24>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
ffffffffc0204240:	4685                	li	a3,1
ffffffffc0204242:	4611                	li	a2,4
ffffffffc0204244:	853e                	mv	a0,a5
ffffffffc0204246:	e45fe0ef          	jal	ffffffffc020308a <user_mem_check>
ffffffffc020424a:	c909                	beqz	a0,ffffffffc020425c <do_wait+0x34>
ffffffffc020424c:	85a2                	mv	a1,s0
}
ffffffffc020424e:	6442                	ld	s0,16(sp)
ffffffffc0204250:	60e2                	ld	ra,24(sp)
ffffffffc0204252:	8526                	mv	a0,s1
ffffffffc0204254:	64a2                	ld	s1,8(sp)
ffffffffc0204256:	6105                	add	sp,sp,32
ffffffffc0204258:	faaff06f          	j	ffffffffc0203a02 <do_wait.part.0>
ffffffffc020425c:	60e2                	ld	ra,24(sp)
ffffffffc020425e:	6442                	ld	s0,16(sp)
ffffffffc0204260:	64a2                	ld	s1,8(sp)
ffffffffc0204262:	5575                	li	a0,-3
ffffffffc0204264:	6105                	add	sp,sp,32
ffffffffc0204266:	8082                	ret

ffffffffc0204268 <do_kill>:
    if (0 < pid && pid < MAX_PID) {
ffffffffc0204268:	6789                	lui	a5,0x2
ffffffffc020426a:	fff5071b          	addw	a4,a0,-1
ffffffffc020426e:	17f9                	add	a5,a5,-2 # 1ffe <_binary_obj___user_ex1_out_size-0x7bca>
ffffffffc0204270:	06e7e963          	bltu	a5,a4,ffffffffc02042e2 <do_kill+0x7a>
do_kill(int pid) {
ffffffffc0204274:	1141                	add	sp,sp,-16
ffffffffc0204276:	e022                	sd	s0,0(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204278:	45a9                	li	a1,10
ffffffffc020427a:	842a                	mv	s0,a0
ffffffffc020427c:	2501                	sext.w	a0,a0
do_kill(int pid) {
ffffffffc020427e:	e406                	sd	ra,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204280:	708000ef          	jal	ffffffffc0204988 <hash32>
ffffffffc0204284:	02051793          	sll	a5,a0,0x20
ffffffffc0204288:	01c7d513          	srl	a0,a5,0x1c
ffffffffc020428c:	0004c797          	auipc	a5,0x4c
ffffffffc0204290:	79478793          	add	a5,a5,1940 # ffffffffc0250a20 <hash_list>
ffffffffc0204294:	953e                	add	a0,a0,a5
ffffffffc0204296:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list) {
ffffffffc0204298:	a029                	j	ffffffffc02042a2 <do_kill+0x3a>
            if (proc->pid == pid) {
ffffffffc020429a:	f2c7a703          	lw	a4,-212(a5)
ffffffffc020429e:	00870a63          	beq	a4,s0,ffffffffc02042b2 <do_kill+0x4a>
ffffffffc02042a2:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02042a4:	fef51be3          	bne	a0,a5,ffffffffc020429a <do_kill+0x32>
    return -E_INVAL;
ffffffffc02042a8:	5575                	li	a0,-3
}
ffffffffc02042aa:	60a2                	ld	ra,8(sp)
ffffffffc02042ac:	6402                	ld	s0,0(sp)
ffffffffc02042ae:	0141                	add	sp,sp,16
ffffffffc02042b0:	8082                	ret
        if (!(proc->flags & PF_EXITING)) {
ffffffffc02042b2:	fd87a703          	lw	a4,-40(a5)
        return -E_KILLED;
ffffffffc02042b6:	555d                	li	a0,-9
        if (!(proc->flags & PF_EXITING)) {
ffffffffc02042b8:	00177693          	and	a3,a4,1
ffffffffc02042bc:	f6fd                	bnez	a3,ffffffffc02042aa <do_kill+0x42>
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc02042be:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc02042c0:	00176713          	or	a4,a4,1
ffffffffc02042c4:	fce7ac23          	sw	a4,-40(a5)
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc02042c8:	0006c763          	bltz	a3,ffffffffc02042d6 <do_kill+0x6e>
            return 0;
ffffffffc02042cc:	4501                	li	a0,0
}
ffffffffc02042ce:	60a2                	ld	ra,8(sp)
ffffffffc02042d0:	6402                	ld	s0,0(sp)
ffffffffc02042d2:	0141                	add	sp,sp,16
ffffffffc02042d4:	8082                	ret
                wakeup_proc(proc);
ffffffffc02042d6:	f2878513          	add	a0,a5,-216
ffffffffc02042da:	390000ef          	jal	ffffffffc020466a <wakeup_proc>
            return 0;
ffffffffc02042de:	4501                	li	a0,0
ffffffffc02042e0:	b7fd                	j	ffffffffc02042ce <do_kill+0x66>
    return -E_INVAL;
ffffffffc02042e2:	5575                	li	a0,-3
}
ffffffffc02042e4:	8082                	ret

ffffffffc02042e6 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc02042e6:	1101                	add	sp,sp,-32
ffffffffc02042e8:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc02042ea:	00050797          	auipc	a5,0x50
ffffffffc02042ee:	73678793          	add	a5,a5,1846 # ffffffffc0254a20 <proc_list>
ffffffffc02042f2:	ec06                	sd	ra,24(sp)
ffffffffc02042f4:	e822                	sd	s0,16(sp)
ffffffffc02042f6:	e04a                	sd	s2,0(sp)
ffffffffc02042f8:	0004c497          	auipc	s1,0x4c
ffffffffc02042fc:	72848493          	add	s1,s1,1832 # ffffffffc0250a20 <hash_list>
ffffffffc0204300:	e79c                	sd	a5,8(a5)
ffffffffc0204302:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc0204304:	00050717          	auipc	a4,0x50
ffffffffc0204308:	71c70713          	add	a4,a4,1820 # ffffffffc0254a20 <proc_list>
ffffffffc020430c:	87a6                	mv	a5,s1
ffffffffc020430e:	e79c                	sd	a5,8(a5)
ffffffffc0204310:	e39c                	sd	a5,0(a5)
ffffffffc0204312:	07c1                	add	a5,a5,16
ffffffffc0204314:	fef71de3          	bne	a4,a5,ffffffffc020430e <proc_init+0x28>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0204318:	f63fe0ef          	jal	ffffffffc020327a <alloc_proc>
ffffffffc020431c:	00050917          	auipc	s2,0x50
ffffffffc0204320:	7cc90913          	add	s2,s2,1996 # ffffffffc0254ae8 <idleproc>
ffffffffc0204324:	00a93023          	sd	a0,0(s2)
ffffffffc0204328:	10050063          	beqz	a0,ffffffffc0204428 <proc_init+0x142>
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020432c:	4789                	li	a5,2
ffffffffc020432e:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204330:	00004797          	auipc	a5,0x4
ffffffffc0204334:	cd078793          	add	a5,a5,-816 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204338:	0b450413          	add	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020433c:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc020433e:	4785                	li	a5,1
ffffffffc0204340:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204342:	4641                	li	a2,16
ffffffffc0204344:	4581                	li	a1,0
ffffffffc0204346:	8522                	mv	a0,s0
ffffffffc0204348:	2c5000ef          	jal	ffffffffc0204e0c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020434c:	463d                	li	a2,15
ffffffffc020434e:	00002597          	auipc	a1,0x2
ffffffffc0204352:	32a58593          	add	a1,a1,810 # ffffffffc0206678 <default_pmm_manager+0xb18>
ffffffffc0204356:	8522                	mv	a0,s0
ffffffffc0204358:	2c7000ef          	jal	ffffffffc0204e1e <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process ++;
ffffffffc020435c:	00050717          	auipc	a4,0x50
ffffffffc0204360:	77470713          	add	a4,a4,1908 # ffffffffc0254ad0 <nr_process>
ffffffffc0204364:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204366:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020436a:	4601                	li	a2,0
    nr_process ++;
ffffffffc020436c:	2785                	addw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020436e:	4581                	li	a1,0
ffffffffc0204370:	00000517          	auipc	a0,0x0
ffffffffc0204374:	86450513          	add	a0,a0,-1948 # ffffffffc0203bd4 <init_main>
    nr_process ++;
ffffffffc0204378:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc020437a:	00050797          	auipc	a5,0x50
ffffffffc020437e:	74d7bf23          	sd	a3,1886(a5) # ffffffffc0254ad8 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204382:	ce6ff0ef          	jal	ffffffffc0203868 <kernel_thread>
ffffffffc0204386:	842a                	mv	s0,a0
    if (pid <= 0) {
ffffffffc0204388:	08a05463          	blez	a0,ffffffffc0204410 <proc_init+0x12a>
    if (0 < pid && pid < MAX_PID) {
ffffffffc020438c:	6789                	lui	a5,0x2
ffffffffc020438e:	fff5071b          	addw	a4,a0,-1
ffffffffc0204392:	17f9                	add	a5,a5,-2 # 1ffe <_binary_obj___user_ex1_out_size-0x7bca>
ffffffffc0204394:	2501                	sext.w	a0,a0
ffffffffc0204396:	02e7e463          	bltu	a5,a4,ffffffffc02043be <proc_init+0xd8>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020439a:	45a9                	li	a1,10
ffffffffc020439c:	5ec000ef          	jal	ffffffffc0204988 <hash32>
ffffffffc02043a0:	02051713          	sll	a4,a0,0x20
ffffffffc02043a4:	01c75793          	srl	a5,a4,0x1c
ffffffffc02043a8:	00f486b3          	add	a3,s1,a5
ffffffffc02043ac:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc02043ae:	a029                	j	ffffffffc02043b8 <proc_init+0xd2>
            if (proc->pid == pid) {
ffffffffc02043b0:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02043b4:	04870b63          	beq	a4,s0,ffffffffc020440a <proc_init+0x124>
    return listelm->next;
ffffffffc02043b8:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc02043ba:	fef69be3          	bne	a3,a5,ffffffffc02043b0 <proc_init+0xca>
    return NULL;
ffffffffc02043be:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02043c0:	0b478493          	add	s1,a5,180
ffffffffc02043c4:	4641                	li	a2,16
ffffffffc02043c6:	4581                	li	a1,0
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02043c8:	00050417          	auipc	s0,0x50
ffffffffc02043cc:	71840413          	add	s0,s0,1816 # ffffffffc0254ae0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02043d0:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc02043d2:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02043d4:	239000ef          	jal	ffffffffc0204e0c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02043d8:	463d                	li	a2,15
ffffffffc02043da:	00002597          	auipc	a1,0x2
ffffffffc02043de:	2c658593          	add	a1,a1,710 # ffffffffc02066a0 <default_pmm_manager+0xb40>
ffffffffc02043e2:	8526                	mv	a0,s1
ffffffffc02043e4:	23b000ef          	jal	ffffffffc0204e1e <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02043e8:	00093783          	ld	a5,0(s2)
ffffffffc02043ec:	cbb5                	beqz	a5,ffffffffc0204460 <proc_init+0x17a>
ffffffffc02043ee:	43dc                	lw	a5,4(a5)
ffffffffc02043f0:	eba5                	bnez	a5,ffffffffc0204460 <proc_init+0x17a>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02043f2:	601c                	ld	a5,0(s0)
ffffffffc02043f4:	c7b1                	beqz	a5,ffffffffc0204440 <proc_init+0x15a>
ffffffffc02043f6:	43d8                	lw	a4,4(a5)
ffffffffc02043f8:	4785                	li	a5,1
ffffffffc02043fa:	04f71363          	bne	a4,a5,ffffffffc0204440 <proc_init+0x15a>
}
ffffffffc02043fe:	60e2                	ld	ra,24(sp)
ffffffffc0204400:	6442                	ld	s0,16(sp)
ffffffffc0204402:	64a2                	ld	s1,8(sp)
ffffffffc0204404:	6902                	ld	s2,0(sp)
ffffffffc0204406:	6105                	add	sp,sp,32
ffffffffc0204408:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc020440a:	f2878793          	add	a5,a5,-216
ffffffffc020440e:	bf4d                	j	ffffffffc02043c0 <proc_init+0xda>
        panic("create init_main failed.\n");
ffffffffc0204410:	00002617          	auipc	a2,0x2
ffffffffc0204414:	27060613          	add	a2,a2,624 # ffffffffc0206680 <default_pmm_manager+0xb20>
ffffffffc0204418:	33e00593          	li	a1,830
ffffffffc020441c:	00002517          	auipc	a0,0x2
ffffffffc0204420:	edc50513          	add	a0,a0,-292 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc0204424:	846fc0ef          	jal	ffffffffc020046a <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204428:	00002617          	auipc	a2,0x2
ffffffffc020442c:	23860613          	add	a2,a2,568 # ffffffffc0206660 <default_pmm_manager+0xb00>
ffffffffc0204430:	33000593          	li	a1,816
ffffffffc0204434:	00002517          	auipc	a0,0x2
ffffffffc0204438:	ec450513          	add	a0,a0,-316 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc020443c:	82efc0ef          	jal	ffffffffc020046a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204440:	00002697          	auipc	a3,0x2
ffffffffc0204444:	29068693          	add	a3,a3,656 # ffffffffc02066d0 <default_pmm_manager+0xb70>
ffffffffc0204448:	00001617          	auipc	a2,0x1
ffffffffc020444c:	08060613          	add	a2,a2,128 # ffffffffc02054c8 <commands+0x430>
ffffffffc0204450:	34500593          	li	a1,837
ffffffffc0204454:	00002517          	auipc	a0,0x2
ffffffffc0204458:	ea450513          	add	a0,a0,-348 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc020445c:	80efc0ef          	jal	ffffffffc020046a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204460:	00002697          	auipc	a3,0x2
ffffffffc0204464:	24868693          	add	a3,a3,584 # ffffffffc02066a8 <default_pmm_manager+0xb48>
ffffffffc0204468:	00001617          	auipc	a2,0x1
ffffffffc020446c:	06060613          	add	a2,a2,96 # ffffffffc02054c8 <commands+0x430>
ffffffffc0204470:	34400593          	li	a1,836
ffffffffc0204474:	00002517          	auipc	a0,0x2
ffffffffc0204478:	e8450513          	add	a0,a0,-380 # ffffffffc02062f8 <default_pmm_manager+0x798>
ffffffffc020447c:	feffb0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0204480 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc0204480:	1141                	add	sp,sp,-16
ffffffffc0204482:	e022                	sd	s0,0(sp)
ffffffffc0204484:	e406                	sd	ra,8(sp)
ffffffffc0204486:	00050417          	auipc	s0,0x50
ffffffffc020448a:	65240413          	add	s0,s0,1618 # ffffffffc0254ad8 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc020448e:	6018                	ld	a4,0(s0)
ffffffffc0204490:	6f1c                	ld	a5,24(a4)
ffffffffc0204492:	dffd                	beqz	a5,ffffffffc0204490 <cpu_idle+0x10>
            schedule();
ffffffffc0204494:	2da000ef          	jal	ffffffffc020476e <schedule>
ffffffffc0204498:	bfdd                	j	ffffffffc020448e <cpu_idle+0xe>

ffffffffc020449a <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc020449a:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc020449e:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02044a2:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02044a4:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02044a6:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02044aa:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02044ae:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02044b2:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02044b6:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02044ba:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02044be:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02044c2:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02044c6:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02044ca:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02044ce:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc02044d2:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02044d6:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02044d8:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02044da:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02044de:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02044e2:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02044e6:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02044ea:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02044ee:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02044f2:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02044f6:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02044fa:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02044fe:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204502:	8082                	ret

ffffffffc0204504 <RR_init>:
    elm->prev = elm->next = elm;
ffffffffc0204504:	e508                	sd	a0,8(a0)
ffffffffc0204506:	e108                	sd	a0,0(a0)
#include <default_sched.h>

static void
RR_init(struct run_queue *rq) {
    list_init(&(rq->run_list));
    rq->proc_num = 0;
ffffffffc0204508:	00052823          	sw	zero,16(a0)
}
ffffffffc020450c:	8082                	ret

ffffffffc020450e <RR_enqueue>:
    __list_add(elm, listelm->prev, listelm);
ffffffffc020450e:	611c                	ld	a5,0(a0)

static void
RR_enqueue(struct run_queue *rq, struct proc_struct *proc) {


    list_add_before(&(rq->run_list), &(proc->run_link));
ffffffffc0204510:	11058713          	add	a4,a1,272
    prev->next = next->prev = elm;
ffffffffc0204514:	e118                	sd	a4,0(a0)
    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
ffffffffc0204516:	1205a683          	lw	a3,288(a1)
ffffffffc020451a:	e798                	sd	a4,8(a5)
    elm->prev = prev;
ffffffffc020451c:	10f5b823          	sd	a5,272(a1)
    elm->next = next;
ffffffffc0204520:	10a5bc23          	sd	a0,280(a1)
ffffffffc0204524:	495c                	lw	a5,20(a0)
ffffffffc0204526:	c299                	beqz	a3,ffffffffc020452c <RR_enqueue+0x1e>
ffffffffc0204528:	00d7d463          	bge	a5,a3,ffffffffc0204530 <RR_enqueue+0x22>
        proc->time_slice = rq->max_time_slice;
ffffffffc020452c:	12f5a023          	sw	a5,288(a1)
    }
    proc->rq = rq;
    rq->proc_num ++;
ffffffffc0204530:	491c                	lw	a5,16(a0)
    proc->rq = rq;
ffffffffc0204532:	10a5b423          	sd	a0,264(a1)
    rq->proc_num ++;
ffffffffc0204536:	2785                	addw	a5,a5,1
ffffffffc0204538:	c91c                	sw	a5,16(a0)
}
ffffffffc020453a:	8082                	ret

ffffffffc020453c <RR_proc_tick>:
    return le2proc(max, run_link);
}

static void
RR_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
    if (proc->time_slice > 0) {
ffffffffc020453c:	1205a783          	lw	a5,288(a1)
ffffffffc0204540:	00f05563          	blez	a5,ffffffffc020454a <RR_proc_tick+0xe>
        proc->time_slice --;
ffffffffc0204544:	37fd                	addw	a5,a5,-1
ffffffffc0204546:	12f5a023          	sw	a5,288(a1)
    }
    if (proc->time_slice == 0) {
ffffffffc020454a:	e399                	bnez	a5,ffffffffc0204550 <RR_proc_tick+0x14>
        proc->need_resched = 1;
ffffffffc020454c:	4785                	li	a5,1
ffffffffc020454e:	ed9c                	sd	a5,24(a1)
    }
}
ffffffffc0204550:	8082                	ret

ffffffffc0204552 <RR_pick_next>:
RR_pick_next(struct run_queue *rq) {
ffffffffc0204552:	872a                	mv	a4,a0
    list_entry_t *le = start->next;
ffffffffc0204554:	6508                	ld	a0,8(a0)
    while (le && le != start) {
ffffffffc0204556:	c129                	beqz	a0,ffffffffc0204598 <RR_pick_next+0x46>
ffffffffc0204558:	04a70163          	beq	a4,a0,ffffffffc020459a <RR_pick_next+0x48>
ffffffffc020455c:	4d10                	lw	a2,24(a0)
RR_pick_next(struct run_queue *rq) {
ffffffffc020455e:	1141                	add	sp,sp,-16
ffffffffc0204560:	e022                	sd	s0,0(sp)
ffffffffc0204562:	e406                	sd	ra,8(sp)
    list_entry_t *le = start->next;
ffffffffc0204564:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0204566:	6508                	ld	a0,8(a0)
    while (le && le != start) {
ffffffffc0204568:	c911                	beqz	a0,ffffffffc020457c <RR_pick_next+0x2a>
ffffffffc020456a:	00a70963          	beq	a4,a0,ffffffffc020457c <RR_pick_next+0x2a>
        else if(le2proc(le, run_link)->labschedule_good > le2proc(max, run_link)->labschedule_good){
ffffffffc020456e:	4d1c                	lw	a5,24(a0)
ffffffffc0204570:	fef67be3          	bgeu	a2,a5,ffffffffc0204566 <RR_pick_next+0x14>
        le = list_next(le);
ffffffffc0204574:	842a                	mv	s0,a0
ffffffffc0204576:	6508                	ld	a0,8(a0)
ffffffffc0204578:	863e                	mv	a2,a5
    while (le && le != start) {
ffffffffc020457a:	f965                	bnez	a0,ffffffffc020456a <RR_pick_next+0x18>
        cprintf("found proc %d with good:%d\n", le2proc(max, run_link)->pid,le2proc(max, run_link)->labschedule_good);
ffffffffc020457c:	ef442583          	lw	a1,-268(s0)
ffffffffc0204580:	00002517          	auipc	a0,0x2
ffffffffc0204584:	17850513          	add	a0,a0,376 # ffffffffc02066f8 <default_pmm_manager+0xb98>
ffffffffc0204588:	bfbfb0ef          	jal	ffffffffc0200182 <cprintf>
}
ffffffffc020458c:	60a2                	ld	ra,8(sp)
    return le2proc(max, run_link);
ffffffffc020458e:	ef040513          	add	a0,s0,-272
}
ffffffffc0204592:	6402                	ld	s0,0(sp)
ffffffffc0204594:	0141                	add	sp,sp,16
ffffffffc0204596:	8082                	ret
ffffffffc0204598:	8082                	ret
        return NULL;
ffffffffc020459a:	4501                	li	a0,0
ffffffffc020459c:	8082                	ret

ffffffffc020459e <RR_dequeue>:
    return list->next == list;
ffffffffc020459e:	1185b703          	ld	a4,280(a1)
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
ffffffffc02045a2:	11058793          	add	a5,a1,272
ffffffffc02045a6:	02e78363          	beq	a5,a4,ffffffffc02045cc <RR_dequeue+0x2e>
ffffffffc02045aa:	1085b683          	ld	a3,264(a1)
ffffffffc02045ae:	00a69f63          	bne	a3,a0,ffffffffc02045cc <RR_dequeue+0x2e>
    __list_del(listelm->prev, listelm->next);
ffffffffc02045b2:	1105b503          	ld	a0,272(a1)
    rq->proc_num --;
ffffffffc02045b6:	4a90                	lw	a2,16(a3)
    prev->next = next;
ffffffffc02045b8:	e518                	sd	a4,8(a0)
    next->prev = prev;
ffffffffc02045ba:	e308                	sd	a0,0(a4)
    elm->prev = elm->next = elm;
ffffffffc02045bc:	10f5bc23          	sd	a5,280(a1)
ffffffffc02045c0:	10f5b823          	sd	a5,272(a1)
ffffffffc02045c4:	fff6079b          	addw	a5,a2,-1
ffffffffc02045c8:	ca9c                	sw	a5,16(a3)
ffffffffc02045ca:	8082                	ret
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
ffffffffc02045cc:	1141                	add	sp,sp,-16
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
ffffffffc02045ce:	00002697          	auipc	a3,0x2
ffffffffc02045d2:	14a68693          	add	a3,a3,330 # ffffffffc0206718 <default_pmm_manager+0xbb8>
ffffffffc02045d6:	00001617          	auipc	a2,0x1
ffffffffc02045da:	ef260613          	add	a2,a2,-270 # ffffffffc02054c8 <commands+0x430>
ffffffffc02045de:	45ed                	li	a1,27
ffffffffc02045e0:	00002517          	auipc	a0,0x2
ffffffffc02045e4:	17050513          	add	a0,a0,368 # ffffffffc0206750 <default_pmm_manager+0xbf0>
RR_dequeue(struct run_queue *rq, struct proc_struct *proc) {
ffffffffc02045e8:	e406                	sd	ra,8(sp)
    assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
ffffffffc02045ea:	e81fb0ef          	jal	ffffffffc020046a <__panic>

ffffffffc02045ee <sched_class_proc_tick>:
    return sched_class->pick_next(rq);
}

void
sched_class_proc_tick(struct proc_struct *proc) {
    if (proc != idleproc) {
ffffffffc02045ee:	00050797          	auipc	a5,0x50
ffffffffc02045f2:	4fa7b783          	ld	a5,1274(a5) # ffffffffc0254ae8 <idleproc>
sched_class_proc_tick(struct proc_struct *proc) {
ffffffffc02045f6:	85aa                	mv	a1,a0
    if (proc != idleproc) {
ffffffffc02045f8:	00a78c63          	beq	a5,a0,ffffffffc0204610 <sched_class_proc_tick+0x22>
        sched_class->proc_tick(rq, proc);
ffffffffc02045fc:	00050797          	auipc	a5,0x50
ffffffffc0204600:	4fc7b783          	ld	a5,1276(a5) # ffffffffc0254af8 <sched_class>
ffffffffc0204604:	779c                	ld	a5,40(a5)
ffffffffc0204606:	00050517          	auipc	a0,0x50
ffffffffc020460a:	4ea53503          	ld	a0,1258(a0) # ffffffffc0254af0 <rq>
ffffffffc020460e:	8782                	jr	a5
    }
    else {
        proc->need_resched = 1;
ffffffffc0204610:	4705                	li	a4,1
ffffffffc0204612:	ef98                	sd	a4,24(a5)
    }
}
ffffffffc0204614:	8082                	ret

ffffffffc0204616 <sched_init>:

static struct run_queue __rq;

void
sched_init(void) {
ffffffffc0204616:	1141                	add	sp,sp,-16
    list_init(&timer_list);

    sched_class = &default_sched_class;
ffffffffc0204618:	00045697          	auipc	a3,0x45
ffffffffc020461c:	fa068693          	add	a3,a3,-96 # ffffffffc02495b8 <default_sched_class>
sched_init(void) {
ffffffffc0204620:	e022                	sd	s0,0(sp)
ffffffffc0204622:	e406                	sd	ra,8(sp)
ffffffffc0204624:	00050797          	auipc	a5,0x50
ffffffffc0204628:	42c78793          	add	a5,a5,1068 # ffffffffc0254a50 <timer_list>
    //sched_class = &stride_sched_class;

    rq = &__rq;
    rq->max_time_slice = MAX_TIME_SLICE;
    sched_class->init(rq);
ffffffffc020462c:	6690                	ld	a2,8(a3)
    rq = &__rq;
ffffffffc020462e:	00050717          	auipc	a4,0x50
ffffffffc0204632:	40270713          	add	a4,a4,1026 # ffffffffc0254a30 <__rq>
ffffffffc0204636:	e79c                	sd	a5,8(a5)
ffffffffc0204638:	e39c                	sd	a5,0(a5)
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc020463a:	4795                	li	a5,5
    sched_class = &default_sched_class;
ffffffffc020463c:	00050417          	auipc	s0,0x50
ffffffffc0204640:	4bc40413          	add	s0,s0,1212 # ffffffffc0254af8 <sched_class>
    rq->max_time_slice = MAX_TIME_SLICE;
ffffffffc0204644:	cb5c                	sw	a5,20(a4)
    sched_class->init(rq);
ffffffffc0204646:	853a                	mv	a0,a4
    sched_class = &default_sched_class;
ffffffffc0204648:	e014                	sd	a3,0(s0)
    rq = &__rq;
ffffffffc020464a:	00050797          	auipc	a5,0x50
ffffffffc020464e:	4ae7b323          	sd	a4,1190(a5) # ffffffffc0254af0 <rq>
    sched_class->init(rq);
ffffffffc0204652:	9602                	jalr	a2

    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0204654:	601c                	ld	a5,0(s0)
}
ffffffffc0204656:	6402                	ld	s0,0(sp)
ffffffffc0204658:	60a2                	ld	ra,8(sp)
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc020465a:	638c                	ld	a1,0(a5)
ffffffffc020465c:	00002517          	auipc	a0,0x2
ffffffffc0204660:	12450513          	add	a0,a0,292 # ffffffffc0206780 <default_pmm_manager+0xc20>
}
ffffffffc0204664:	0141                	add	sp,sp,16
    cprintf("sched class: %s\n", sched_class->name);
ffffffffc0204666:	b1dfb06f          	j	ffffffffc0200182 <cprintf>

ffffffffc020466a <wakeup_proc>:

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020466a:	4118                	lw	a4,0(a0)
wakeup_proc(struct proc_struct *proc) {
ffffffffc020466c:	1141                	add	sp,sp,-16
ffffffffc020466e:	e406                	sd	ra,8(sp)
ffffffffc0204670:	e022                	sd	s0,0(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204672:	478d                	li	a5,3
ffffffffc0204674:	0cf70163          	beq	a4,a5,ffffffffc0204736 <wakeup_proc+0xcc>
ffffffffc0204678:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020467a:	100027f3          	csrr	a5,sstatus
ffffffffc020467e:	8b89                	and	a5,a5,2
ffffffffc0204680:	e7a9                	bnez	a5,ffffffffc02046ca <wakeup_proc+0x60>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
ffffffffc0204682:	4789                	li	a5,2
ffffffffc0204684:	06f70d63          	beq	a4,a5,ffffffffc02046fe <wakeup_proc+0x94>
            proc->state = PROC_RUNNABLE;
ffffffffc0204688:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc020468a:	0e052623          	sw	zero,236(a0)
            if (proc != current) {
ffffffffc020468e:	00050797          	auipc	a5,0x50
ffffffffc0204692:	44a7b783          	ld	a5,1098(a5) # ffffffffc0254ad8 <current>
ffffffffc0204696:	02f50663          	beq	a0,a5,ffffffffc02046c2 <wakeup_proc+0x58>
    if (proc != idleproc) {
ffffffffc020469a:	00050797          	auipc	a5,0x50
ffffffffc020469e:	44e7b783          	ld	a5,1102(a5) # ffffffffc0254ae8 <idleproc>
ffffffffc02046a2:	02f50063          	beq	a0,a5,ffffffffc02046c2 <wakeup_proc+0x58>
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02046a6:	6402                	ld	s0,0(sp)
        sched_class->enqueue(rq, proc);
ffffffffc02046a8:	00050797          	auipc	a5,0x50
ffffffffc02046ac:	4507b783          	ld	a5,1104(a5) # ffffffffc0254af8 <sched_class>
}
ffffffffc02046b0:	60a2                	ld	ra,8(sp)
        sched_class->enqueue(rq, proc);
ffffffffc02046b2:	6b9c                	ld	a5,16(a5)
ffffffffc02046b4:	85aa                	mv	a1,a0
ffffffffc02046b6:	00050517          	auipc	a0,0x50
ffffffffc02046ba:	43a53503          	ld	a0,1082(a0) # ffffffffc0254af0 <rq>
}
ffffffffc02046be:	0141                	add	sp,sp,16
        sched_class->enqueue(rq, proc);
ffffffffc02046c0:	8782                	jr	a5
}
ffffffffc02046c2:	60a2                	ld	ra,8(sp)
ffffffffc02046c4:	6402                	ld	s0,0(sp)
ffffffffc02046c6:	0141                	add	sp,sp,16
ffffffffc02046c8:	8082                	ret
        intr_disable();
ffffffffc02046ca:	f33fb0ef          	jal	ffffffffc02005fc <intr_disable>
        if (proc->state != PROC_RUNNABLE) {
ffffffffc02046ce:	4018                	lw	a4,0(s0)
ffffffffc02046d0:	4789                	li	a5,2
ffffffffc02046d2:	04f70563          	beq	a4,a5,ffffffffc020471c <wakeup_proc+0xb2>
            proc->state = PROC_RUNNABLE;
ffffffffc02046d6:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc02046d8:	0e042623          	sw	zero,236(s0)
            if (proc != current) {
ffffffffc02046dc:	00050797          	auipc	a5,0x50
ffffffffc02046e0:	3fc7b783          	ld	a5,1020(a5) # ffffffffc0254ad8 <current>
ffffffffc02046e4:	00f40863          	beq	s0,a5,ffffffffc02046f4 <wakeup_proc+0x8a>
    if (proc != idleproc) {
ffffffffc02046e8:	00050797          	auipc	a5,0x50
ffffffffc02046ec:	4007b783          	ld	a5,1024(a5) # ffffffffc0254ae8 <idleproc>
ffffffffc02046f0:	06f41363          	bne	s0,a5,ffffffffc0204756 <wakeup_proc+0xec>
}
ffffffffc02046f4:	6402                	ld	s0,0(sp)
ffffffffc02046f6:	60a2                	ld	ra,8(sp)
ffffffffc02046f8:	0141                	add	sp,sp,16
        intr_enable();
ffffffffc02046fa:	efdfb06f          	j	ffffffffc02005f6 <intr_enable>
ffffffffc02046fe:	6402                	ld	s0,0(sp)
ffffffffc0204700:	60a2                	ld	ra,8(sp)
            warn("wakeup runnable process.\n");
ffffffffc0204702:	00002617          	auipc	a2,0x2
ffffffffc0204706:	0ce60613          	add	a2,a2,206 # ffffffffc02067d0 <default_pmm_manager+0xc70>
ffffffffc020470a:	04900593          	li	a1,73
ffffffffc020470e:	00002517          	auipc	a0,0x2
ffffffffc0204712:	0aa50513          	add	a0,a0,170 # ffffffffc02067b8 <default_pmm_manager+0xc58>
}
ffffffffc0204716:	0141                	add	sp,sp,16
            warn("wakeup runnable process.\n");
ffffffffc0204718:	dbbfb06f          	j	ffffffffc02004d2 <__warn>
ffffffffc020471c:	00002617          	auipc	a2,0x2
ffffffffc0204720:	0b460613          	add	a2,a2,180 # ffffffffc02067d0 <default_pmm_manager+0xc70>
ffffffffc0204724:	04900593          	li	a1,73
ffffffffc0204728:	00002517          	auipc	a0,0x2
ffffffffc020472c:	09050513          	add	a0,a0,144 # ffffffffc02067b8 <default_pmm_manager+0xc58>
ffffffffc0204730:	da3fb0ef          	jal	ffffffffc02004d2 <__warn>
    if (flag) {
ffffffffc0204734:	b7c1                	j	ffffffffc02046f4 <wakeup_proc+0x8a>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204736:	00002697          	auipc	a3,0x2
ffffffffc020473a:	06268693          	add	a3,a3,98 # ffffffffc0206798 <default_pmm_manager+0xc38>
ffffffffc020473e:	00001617          	auipc	a2,0x1
ffffffffc0204742:	d8a60613          	add	a2,a2,-630 # ffffffffc02054c8 <commands+0x430>
ffffffffc0204746:	03d00593          	li	a1,61
ffffffffc020474a:	00002517          	auipc	a0,0x2
ffffffffc020474e:	06e50513          	add	a0,a0,110 # ffffffffc02067b8 <default_pmm_manager+0xc58>
ffffffffc0204752:	d19fb0ef          	jal	ffffffffc020046a <__panic>
        sched_class->enqueue(rq, proc);
ffffffffc0204756:	00050797          	auipc	a5,0x50
ffffffffc020475a:	3a27b783          	ld	a5,930(a5) # ffffffffc0254af8 <sched_class>
ffffffffc020475e:	6b9c                	ld	a5,16(a5)
ffffffffc0204760:	85a2                	mv	a1,s0
ffffffffc0204762:	00050517          	auipc	a0,0x50
ffffffffc0204766:	38e53503          	ld	a0,910(a0) # ffffffffc0254af0 <rq>
ffffffffc020476a:	9782                	jalr	a5
ffffffffc020476c:	b761                	j	ffffffffc02046f4 <wakeup_proc+0x8a>

ffffffffc020476e <schedule>:

void
schedule(void) {
ffffffffc020476e:	7179                	add	sp,sp,-48
ffffffffc0204770:	f406                	sd	ra,40(sp)
ffffffffc0204772:	f022                	sd	s0,32(sp)
ffffffffc0204774:	ec26                	sd	s1,24(sp)
ffffffffc0204776:	e84a                	sd	s2,16(sp)
ffffffffc0204778:	e44e                	sd	s3,8(sp)
ffffffffc020477a:	e052                	sd	s4,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020477c:	100027f3          	csrr	a5,sstatus
ffffffffc0204780:	8b89                	and	a5,a5,2
ffffffffc0204782:	4a01                	li	s4,0
ffffffffc0204784:	ebc5                	bnez	a5,ffffffffc0204834 <schedule+0xc6>
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0204786:	00050497          	auipc	s1,0x50
ffffffffc020478a:	35248493          	add	s1,s1,850 # ffffffffc0254ad8 <current>
ffffffffc020478e:	608c                	ld	a1,0(s1)
        if (current->state == PROC_RUNNABLE) {
ffffffffc0204790:	4789                	li	a5,2
ffffffffc0204792:	00050917          	auipc	s2,0x50
ffffffffc0204796:	35e90913          	add	s2,s2,862 # ffffffffc0254af0 <rq>
ffffffffc020479a:	4198                	lw	a4,0(a1)
        current->need_resched = 0;
ffffffffc020479c:	0005bc23          	sd	zero,24(a1)
        if (current->state == PROC_RUNNABLE) {
ffffffffc02047a0:	00050997          	auipc	s3,0x50
ffffffffc02047a4:	35898993          	add	s3,s3,856 # ffffffffc0254af8 <sched_class>
ffffffffc02047a8:	06f70963          	beq	a4,a5,ffffffffc020481a <schedule+0xac>
    return sched_class->pick_next(rq);
ffffffffc02047ac:	0009b783          	ld	a5,0(s3)
ffffffffc02047b0:	00093503          	ld	a0,0(s2)
ffffffffc02047b4:	739c                	ld	a5,32(a5)
ffffffffc02047b6:	9782                	jalr	a5
ffffffffc02047b8:	842a                	mv	s0,a0
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL) {
ffffffffc02047ba:	c939                	beqz	a0,ffffffffc0204810 <schedule+0xa2>
    sched_class->dequeue(rq, proc);
ffffffffc02047bc:	0009b783          	ld	a5,0(s3)
ffffffffc02047c0:	00093503          	ld	a0,0(s2)
ffffffffc02047c4:	85a2                	mv	a1,s0
ffffffffc02047c6:	6f9c                	ld	a5,24(a5)
ffffffffc02047c8:	9782                	jalr	a5
            sched_class_dequeue(next);
        }
        if (next == NULL) {
            next = idleproc;
        }
        next->runs ++;
ffffffffc02047ca:	441c                	lw	a5,8(s0)
        if (next != current) {
ffffffffc02047cc:	6098                	ld	a4,0(s1)
        next->runs ++;
ffffffffc02047ce:	2785                	addw	a5,a5,1
ffffffffc02047d0:	c41c                	sw	a5,8(s0)
        if (next != current) {
ffffffffc02047d2:	00870c63          	beq	a4,s0,ffffffffc02047ea <schedule+0x7c>
            cprintf("The next proc is pid:%d\n",next->pid);
ffffffffc02047d6:	404c                	lw	a1,4(s0)
ffffffffc02047d8:	00002517          	auipc	a0,0x2
ffffffffc02047dc:	01850513          	add	a0,a0,24 # ffffffffc02067f0 <default_pmm_manager+0xc90>
ffffffffc02047e0:	9a3fb0ef          	jal	ffffffffc0200182 <cprintf>
            proc_run(next);
ffffffffc02047e4:	8522                	mv	a0,s0
ffffffffc02047e6:	c17fe0ef          	jal	ffffffffc02033fc <proc_run>
    if (flag) {
ffffffffc02047ea:	000a1a63          	bnez	s4,ffffffffc02047fe <schedule+0x90>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02047ee:	70a2                	ld	ra,40(sp)
ffffffffc02047f0:	7402                	ld	s0,32(sp)
ffffffffc02047f2:	64e2                	ld	s1,24(sp)
ffffffffc02047f4:	6942                	ld	s2,16(sp)
ffffffffc02047f6:	69a2                	ld	s3,8(sp)
ffffffffc02047f8:	6a02                	ld	s4,0(sp)
ffffffffc02047fa:	6145                	add	sp,sp,48
ffffffffc02047fc:	8082                	ret
ffffffffc02047fe:	7402                	ld	s0,32(sp)
ffffffffc0204800:	70a2                	ld	ra,40(sp)
ffffffffc0204802:	64e2                	ld	s1,24(sp)
ffffffffc0204804:	6942                	ld	s2,16(sp)
ffffffffc0204806:	69a2                	ld	s3,8(sp)
ffffffffc0204808:	6a02                	ld	s4,0(sp)
ffffffffc020480a:	6145                	add	sp,sp,48
        intr_enable();
ffffffffc020480c:	debfb06f          	j	ffffffffc02005f6 <intr_enable>
            next = idleproc;
ffffffffc0204810:	00050417          	auipc	s0,0x50
ffffffffc0204814:	2d843403          	ld	s0,728(s0) # ffffffffc0254ae8 <idleproc>
ffffffffc0204818:	bf4d                	j	ffffffffc02047ca <schedule+0x5c>
    if (proc != idleproc) {
ffffffffc020481a:	00050797          	auipc	a5,0x50
ffffffffc020481e:	2ce7b783          	ld	a5,718(a5) # ffffffffc0254ae8 <idleproc>
ffffffffc0204822:	f8f585e3          	beq	a1,a5,ffffffffc02047ac <schedule+0x3e>
        sched_class->enqueue(rq, proc);
ffffffffc0204826:	0009b783          	ld	a5,0(s3)
ffffffffc020482a:	00093503          	ld	a0,0(s2)
ffffffffc020482e:	6b9c                	ld	a5,16(a5)
ffffffffc0204830:	9782                	jalr	a5
ffffffffc0204832:	bfad                	j	ffffffffc02047ac <schedule+0x3e>
        intr_disable();
ffffffffc0204834:	dc9fb0ef          	jal	ffffffffc02005fc <intr_disable>
        return 1;
ffffffffc0204838:	4a05                	li	s4,1
ffffffffc020483a:	b7b1                	j	ffffffffc0204786 <schedule+0x18>

ffffffffc020483c <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020483c:	00050797          	auipc	a5,0x50
ffffffffc0204840:	29c7b783          	ld	a5,668(a5) # ffffffffc0254ad8 <current>
}
ffffffffc0204844:	43c8                	lw	a0,4(a5)
ffffffffc0204846:	8082                	ret

ffffffffc0204848 <sys_gettime>:
    cputchar(c);
    return 0;
}

static int sys_gettime(uint64_t arg[]){
    return (int)ticks*10;
ffffffffc0204848:	00050797          	auipc	a5,0x50
ffffffffc020484c:	2207b783          	ld	a5,544(a5) # ffffffffc0254a68 <ticks>
ffffffffc0204850:	0027951b          	sllw	a0,a5,0x2
ffffffffc0204854:	9d3d                	addw	a0,a0,a5
}
ffffffffc0204856:	0015151b          	sllw	a0,a0,0x1
ffffffffc020485a:	8082                	ret

ffffffffc020485c <sys_putc>:
    cputchar(c);
ffffffffc020485c:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020485e:	1141                	add	sp,sp,-16
ffffffffc0204860:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0204862:	957fb0ef          	jal	ffffffffc02001b8 <cputchar>
}
ffffffffc0204866:	60a2                	ld	ra,8(sp)
ffffffffc0204868:	4501                	li	a0,0
ffffffffc020486a:	0141                	add	sp,sp,16
ffffffffc020486c:	8082                	ret

ffffffffc020486e <sys_kill>:
    return do_kill(pid);
ffffffffc020486e:	4108                	lw	a0,0(a0)
ffffffffc0204870:	9f9ff06f          	j	ffffffffc0204268 <do_kill>

ffffffffc0204874 <sys_yield>:
    return do_yield();
ffffffffc0204874:	9a5ff06f          	j	ffffffffc0204218 <do_yield>

ffffffffc0204878 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0204878:	6d14                	ld	a3,24(a0)
ffffffffc020487a:	6910                	ld	a2,16(a0)
ffffffffc020487c:	650c                	ld	a1,8(a0)
ffffffffc020487e:	6108                	ld	a0,0(a0)
ffffffffc0204880:	c78ff06f          	j	ffffffffc0203cf8 <do_execve>

ffffffffc0204884 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0204884:	650c                	ld	a1,8(a0)
ffffffffc0204886:	4108                	lw	a0,0(a0)
ffffffffc0204888:	9a1ff06f          	j	ffffffffc0204228 <do_wait>

ffffffffc020488c <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020488c:	00050797          	auipc	a5,0x50
ffffffffc0204890:	24c7b783          	ld	a5,588(a5) # ffffffffc0254ad8 <current>
ffffffffc0204894:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0204896:	4501                	li	a0,0
ffffffffc0204898:	6a0c                	ld	a1,16(a2)
ffffffffc020489a:	bcffe06f          	j	ffffffffc0203468 <do_fork>

ffffffffc020489e <sys_exit>:
    return do_exit(error_code);
ffffffffc020489e:	4108                	lw	a0,0(a0)
ffffffffc02048a0:	818ff06f          	j	ffffffffc02038b8 <do_exit>

ffffffffc02048a4 <sys_set_good>:

static int sys_set_good(uint64_t arg[]){
ffffffffc02048a4:	1141                	add	sp,sp,-16
ffffffffc02048a6:	e022                	sd	s0,0(sp)
    uint32_t good = (uint32_t)arg[0];
    assert(current!=NULL);
ffffffffc02048a8:	00050417          	auipc	s0,0x50
ffffffffc02048ac:	23040413          	add	s0,s0,560 # ffffffffc0254ad8 <current>
ffffffffc02048b0:	601c                	ld	a5,0(s0)
static int sys_set_good(uint64_t arg[]){
ffffffffc02048b2:	e406                	sd	ra,8(sp)
    uint32_t good = (uint32_t)arg[0];
ffffffffc02048b4:	410c                	lw	a1,0(a0)
    assert(current!=NULL);
ffffffffc02048b6:	cb85                	beqz	a5,ffffffffc02048e6 <sys_set_good+0x42>
    current->labschedule_good = good;
    cprintf("set good %d for pid %d at ticks %d \n",good,current->pid,ticks);
ffffffffc02048b8:	43d0                	lw	a2,4(a5)
    current->labschedule_good = good;
ffffffffc02048ba:	12b7a423          	sw	a1,296(a5)
    cprintf("set good %d for pid %d at ticks %d \n",good,current->pid,ticks);
ffffffffc02048be:	00050697          	auipc	a3,0x50
ffffffffc02048c2:	1aa6b683          	ld	a3,426(a3) # ffffffffc0254a68 <ticks>
ffffffffc02048c6:	00002517          	auipc	a0,0x2
ffffffffc02048ca:	f7250513          	add	a0,a0,-142 # ffffffffc0206838 <default_pmm_manager+0xcd8>
ffffffffc02048ce:	8b5fb0ef          	jal	ffffffffc0200182 <cprintf>
    current->need_resched = 1;
ffffffffc02048d2:	601c                	ld	a5,0(s0)
ffffffffc02048d4:	4705                	li	a4,1
ffffffffc02048d6:	ef98                	sd	a4,24(a5)
    schedule();
ffffffffc02048d8:	e97ff0ef          	jal	ffffffffc020476e <schedule>
    return 0;
}
ffffffffc02048dc:	60a2                	ld	ra,8(sp)
ffffffffc02048de:	6402                	ld	s0,0(sp)
ffffffffc02048e0:	4501                	li	a0,0
ffffffffc02048e2:	0141                	add	sp,sp,16
ffffffffc02048e4:	8082                	ret
    assert(current!=NULL);
ffffffffc02048e6:	00002697          	auipc	a3,0x2
ffffffffc02048ea:	f2a68693          	add	a3,a3,-214 # ffffffffc0206810 <default_pmm_manager+0xcb0>
ffffffffc02048ee:	00001617          	auipc	a2,0x1
ffffffffc02048f2:	bda60613          	add	a2,a2,-1062 # ffffffffc02054c8 <commands+0x430>
ffffffffc02048f6:	04400593          	li	a1,68
ffffffffc02048fa:	00002517          	auipc	a0,0x2
ffffffffc02048fe:	f2650513          	add	a0,a0,-218 # ffffffffc0206820 <default_pmm_manager+0xcc0>
ffffffffc0204902:	b69fb0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0204906 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc0204906:	715d                	add	sp,sp,-80
ffffffffc0204908:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020490a:	00050497          	auipc	s1,0x50
ffffffffc020490e:	1ce48493          	add	s1,s1,462 # ffffffffc0254ad8 <current>
ffffffffc0204912:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0204914:	e0a2                	sd	s0,64(sp)
ffffffffc0204916:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc0204918:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020491a:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc020491c:	0fe00793          	li	a5,254
    int num = tf->gpr.a0;
ffffffffc0204920:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0204924:	0327ee63          	bltu	a5,s2,ffffffffc0204960 <syscall+0x5a>
        if (syscalls[num] != NULL) {
ffffffffc0204928:	00391713          	sll	a4,s2,0x3
ffffffffc020492c:	00002797          	auipc	a5,0x2
ffffffffc0204930:	f6478793          	add	a5,a5,-156 # ffffffffc0206890 <syscalls>
ffffffffc0204934:	97ba                	add	a5,a5,a4
ffffffffc0204936:	639c                	ld	a5,0(a5)
ffffffffc0204938:	c785                	beqz	a5,ffffffffc0204960 <syscall+0x5a>
            arg[0] = tf->gpr.a1;
ffffffffc020493a:	7028                	ld	a0,96(s0)
ffffffffc020493c:	742c                	ld	a1,104(s0)
ffffffffc020493e:	7834                	ld	a3,112(s0)
ffffffffc0204940:	7c38                	ld	a4,120(s0)
ffffffffc0204942:	6c30                	ld	a2,88(s0)
ffffffffc0204944:	e82a                	sd	a0,16(sp)
ffffffffc0204946:	ec2e                	sd	a1,24(sp)
ffffffffc0204948:	e432                	sd	a2,8(sp)
ffffffffc020494a:	f036                	sd	a3,32(sp)
ffffffffc020494c:	f43a                	sd	a4,40(sp)
            arg[1] = tf->gpr.a2;
            arg[2] = tf->gpr.a3;
            arg[3] = tf->gpr.a4;
            arg[4] = tf->gpr.a5;
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc020494e:	0028                	add	a0,sp,8
ffffffffc0204950:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0204952:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0204954:	e828                	sd	a0,80(s0)
}
ffffffffc0204956:	6406                	ld	s0,64(sp)
ffffffffc0204958:	74e2                	ld	s1,56(sp)
ffffffffc020495a:	7942                	ld	s2,48(sp)
ffffffffc020495c:	6161                	add	sp,sp,80
ffffffffc020495e:	8082                	ret
    print_trapframe(tf);
ffffffffc0204960:	8522                	mv	a0,s0
ffffffffc0204962:	e87fb0ef          	jal	ffffffffc02007e8 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0204966:	609c                	ld	a5,0(s1)
ffffffffc0204968:	86ca                	mv	a3,s2
ffffffffc020496a:	00002617          	auipc	a2,0x2
ffffffffc020496e:	ef660613          	add	a2,a2,-266 # ffffffffc0206860 <default_pmm_manager+0xd00>
ffffffffc0204972:	43d8                	lw	a4,4(a5)
ffffffffc0204974:	06c00593          	li	a1,108
ffffffffc0204978:	0b478793          	add	a5,a5,180
ffffffffc020497c:	00002517          	auipc	a0,0x2
ffffffffc0204980:	ea450513          	add	a0,a0,-348 # ffffffffc0206820 <default_pmm_manager+0xcc0>
ffffffffc0204984:	ae7fb0ef          	jal	ffffffffc020046a <__panic>

ffffffffc0204988 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0204988:	9e3707b7          	lui	a5,0x9e370
ffffffffc020498c:	2785                	addw	a5,a5,1 # ffffffff9e370001 <_binary_obj___user_ex3_out_size+0xffffffff9e364d71>
ffffffffc020498e:	02a787bb          	mulw	a5,a5,a0
    return (hash >> (32 - bits));
ffffffffc0204992:	02000513          	li	a0,32
ffffffffc0204996:	9d0d                	subw	a0,a0,a1
}
ffffffffc0204998:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020499c:	8082                	ret

ffffffffc020499e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020499e:	02069813          	sll	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02049a2:	7179                	add	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02049a4:	02085813          	srl	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02049a8:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02049aa:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02049ae:	f022                	sd	s0,32(sp)
ffffffffc02049b0:	ec26                	sd	s1,24(sp)
ffffffffc02049b2:	e84a                	sd	s2,16(sp)
ffffffffc02049b4:	f406                	sd	ra,40(sp)
ffffffffc02049b6:	e44e                	sd	s3,8(sp)
ffffffffc02049b8:	84aa                	mv	s1,a0
ffffffffc02049ba:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02049bc:	fff7041b          	addw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02049c0:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02049c2:	03067f63          	bgeu	a2,a6,ffffffffc0204a00 <printnum+0x62>
ffffffffc02049c6:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02049c8:	4785                	li	a5,1
ffffffffc02049ca:	00e7d763          	bge	a5,a4,ffffffffc02049d8 <printnum+0x3a>
ffffffffc02049ce:	347d                	addw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02049d0:	85ca                	mv	a1,s2
ffffffffc02049d2:	854e                	mv	a0,s3
ffffffffc02049d4:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02049d6:	fc65                	bnez	s0,ffffffffc02049ce <printnum+0x30>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02049d8:	1a02                	sll	s4,s4,0x20
ffffffffc02049da:	020a5a13          	srl	s4,s4,0x20
ffffffffc02049de:	00002797          	auipc	a5,0x2
ffffffffc02049e2:	6aa78793          	add	a5,a5,1706 # ffffffffc0207088 <syscalls+0x7f8>
ffffffffc02049e6:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02049e8:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02049ea:	0007c503          	lbu	a0,0(a5)
}
ffffffffc02049ee:	70a2                	ld	ra,40(sp)
ffffffffc02049f0:	69a2                	ld	s3,8(sp)
ffffffffc02049f2:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02049f4:	85ca                	mv	a1,s2
ffffffffc02049f6:	87a6                	mv	a5,s1
}
ffffffffc02049f8:	6942                	ld	s2,16(sp)
ffffffffc02049fa:	64e2                	ld	s1,24(sp)
ffffffffc02049fc:	6145                	add	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02049fe:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0204a00:	03065633          	divu	a2,a2,a6
ffffffffc0204a04:	8722                	mv	a4,s0
ffffffffc0204a06:	f99ff0ef          	jal	ffffffffc020499e <printnum>
ffffffffc0204a0a:	b7f9                	j	ffffffffc02049d8 <printnum+0x3a>

ffffffffc0204a0c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0204a0c:	7119                	add	sp,sp,-128
ffffffffc0204a0e:	f4a6                	sd	s1,104(sp)
ffffffffc0204a10:	f0ca                	sd	s2,96(sp)
ffffffffc0204a12:	ecce                	sd	s3,88(sp)
ffffffffc0204a14:	e8d2                	sd	s4,80(sp)
ffffffffc0204a16:	e4d6                	sd	s5,72(sp)
ffffffffc0204a18:	e0da                	sd	s6,64(sp)
ffffffffc0204a1a:	f862                	sd	s8,48(sp)
ffffffffc0204a1c:	fc86                	sd	ra,120(sp)
ffffffffc0204a1e:	f8a2                	sd	s0,112(sp)
ffffffffc0204a20:	fc5e                	sd	s7,56(sp)
ffffffffc0204a22:	f466                	sd	s9,40(sp)
ffffffffc0204a24:	f06a                	sd	s10,32(sp)
ffffffffc0204a26:	ec6e                	sd	s11,24(sp)
ffffffffc0204a28:	892a                	mv	s2,a0
ffffffffc0204a2a:	84ae                	mv	s1,a1
ffffffffc0204a2c:	8c32                	mv	s8,a2
ffffffffc0204a2e:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204a30:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204a34:	05500b13          	li	s6,85
ffffffffc0204a38:	00002a97          	auipc	s5,0x2
ffffffffc0204a3c:	67ca8a93          	add	s5,s5,1660 # ffffffffc02070b4 <syscalls+0x824>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204a40:	000c4503          	lbu	a0,0(s8)
ffffffffc0204a44:	001c0413          	add	s0,s8,1
ffffffffc0204a48:	01350a63          	beq	a0,s3,ffffffffc0204a5c <vprintfmt+0x50>
            if (ch == '\0') {
ffffffffc0204a4c:	cd0d                	beqz	a0,ffffffffc0204a86 <vprintfmt+0x7a>
            putch(ch, putdat);
ffffffffc0204a4e:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204a50:	0405                	add	s0,s0,1
            putch(ch, putdat);
ffffffffc0204a52:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204a54:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204a58:	ff351ae3          	bne	a0,s3,ffffffffc0204a4c <vprintfmt+0x40>
        char padc = ' ';
ffffffffc0204a5c:	02000d93          	li	s11,32
        lflag = altflag = 0;
ffffffffc0204a60:	4b81                	li	s7,0
ffffffffc0204a62:	4601                	li	a2,0
        width = precision = -1;
ffffffffc0204a64:	5d7d                	li	s10,-1
ffffffffc0204a66:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204a68:	00044683          	lbu	a3,0(s0)
ffffffffc0204a6c:	00140c13          	add	s8,s0,1
ffffffffc0204a70:	fdd6859b          	addw	a1,a3,-35
ffffffffc0204a74:	0ff5f593          	zext.b	a1,a1
ffffffffc0204a78:	02bb6663          	bltu	s6,a1,ffffffffc0204aa4 <vprintfmt+0x98>
ffffffffc0204a7c:	058a                	sll	a1,a1,0x2
ffffffffc0204a7e:	95d6                	add	a1,a1,s5
ffffffffc0204a80:	4198                	lw	a4,0(a1)
ffffffffc0204a82:	9756                	add	a4,a4,s5
ffffffffc0204a84:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0204a86:	70e6                	ld	ra,120(sp)
ffffffffc0204a88:	7446                	ld	s0,112(sp)
ffffffffc0204a8a:	74a6                	ld	s1,104(sp)
ffffffffc0204a8c:	7906                	ld	s2,96(sp)
ffffffffc0204a8e:	69e6                	ld	s3,88(sp)
ffffffffc0204a90:	6a46                	ld	s4,80(sp)
ffffffffc0204a92:	6aa6                	ld	s5,72(sp)
ffffffffc0204a94:	6b06                	ld	s6,64(sp)
ffffffffc0204a96:	7be2                	ld	s7,56(sp)
ffffffffc0204a98:	7c42                	ld	s8,48(sp)
ffffffffc0204a9a:	7ca2                	ld	s9,40(sp)
ffffffffc0204a9c:	7d02                	ld	s10,32(sp)
ffffffffc0204a9e:	6de2                	ld	s11,24(sp)
ffffffffc0204aa0:	6109                	add	sp,sp,128
ffffffffc0204aa2:	8082                	ret
            putch('%', putdat);
ffffffffc0204aa4:	85a6                	mv	a1,s1
ffffffffc0204aa6:	02500513          	li	a0,37
ffffffffc0204aaa:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0204aac:	fff44703          	lbu	a4,-1(s0)
ffffffffc0204ab0:	02500793          	li	a5,37
ffffffffc0204ab4:	8c22                	mv	s8,s0
ffffffffc0204ab6:	f8f705e3          	beq	a4,a5,ffffffffc0204a40 <vprintfmt+0x34>
ffffffffc0204aba:	02500713          	li	a4,37
ffffffffc0204abe:	ffec4783          	lbu	a5,-2(s8)
ffffffffc0204ac2:	1c7d                	add	s8,s8,-1
ffffffffc0204ac4:	fee79de3          	bne	a5,a4,ffffffffc0204abe <vprintfmt+0xb2>
ffffffffc0204ac8:	bfa5                	j	ffffffffc0204a40 <vprintfmt+0x34>
                ch = *fmt;
ffffffffc0204aca:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
ffffffffc0204ace:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
ffffffffc0204ad0:	fd068d1b          	addw	s10,a3,-48
                if (ch < '0' || ch > '9') {
ffffffffc0204ad4:	fd07859b          	addw	a1,a5,-48
                ch = *fmt;
ffffffffc0204ad8:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204adc:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
ffffffffc0204ade:	02b76563          	bltu	a4,a1,ffffffffc0204b08 <vprintfmt+0xfc>
ffffffffc0204ae2:	4525                	li	a0,9
                ch = *fmt;
ffffffffc0204ae4:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204ae8:	002d171b          	sllw	a4,s10,0x2
ffffffffc0204aec:	01a7073b          	addw	a4,a4,s10
ffffffffc0204af0:	0017171b          	sllw	a4,a4,0x1
ffffffffc0204af4:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
ffffffffc0204af6:	fd07859b          	addw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0204afa:	0405                	add	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0204afc:	fd070d1b          	addw	s10,a4,-48
                ch = *fmt;
ffffffffc0204b00:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
ffffffffc0204b04:	feb570e3          	bgeu	a0,a1,ffffffffc0204ae4 <vprintfmt+0xd8>
            if (width < 0)
ffffffffc0204b08:	f60cd0e3          	bgez	s9,ffffffffc0204a68 <vprintfmt+0x5c>
                width = precision, precision = -1;
ffffffffc0204b0c:	8cea                	mv	s9,s10
ffffffffc0204b0e:	5d7d                	li	s10,-1
ffffffffc0204b10:	bfa1                	j	ffffffffc0204a68 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b12:	8db6                	mv	s11,a3
ffffffffc0204b14:	8462                	mv	s0,s8
ffffffffc0204b16:	bf89                	j	ffffffffc0204a68 <vprintfmt+0x5c>
ffffffffc0204b18:	8462                	mv	s0,s8
            altflag = 1;
ffffffffc0204b1a:	4b85                	li	s7,1
            goto reswitch;
ffffffffc0204b1c:	b7b1                	j	ffffffffc0204a68 <vprintfmt+0x5c>
    if (lflag >= 2) {
ffffffffc0204b1e:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0204b20:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
ffffffffc0204b24:	00c7c463          	blt	a5,a2,ffffffffc0204b2c <vprintfmt+0x120>
    else if (lflag) {
ffffffffc0204b28:	1a060263          	beqz	a2,ffffffffc0204ccc <vprintfmt+0x2c0>
        return va_arg(*ap, unsigned long);
ffffffffc0204b2c:	000a3603          	ld	a2,0(s4)
ffffffffc0204b30:	46c1                	li	a3,16
ffffffffc0204b32:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204b34:	000d879b          	sext.w	a5,s11
ffffffffc0204b38:	8766                	mv	a4,s9
ffffffffc0204b3a:	85a6                	mv	a1,s1
ffffffffc0204b3c:	854a                	mv	a0,s2
ffffffffc0204b3e:	e61ff0ef          	jal	ffffffffc020499e <printnum>
            break;
ffffffffc0204b42:	bdfd                	j	ffffffffc0204a40 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
ffffffffc0204b44:	000a2503          	lw	a0,0(s4)
ffffffffc0204b48:	85a6                	mv	a1,s1
ffffffffc0204b4a:	0a21                	add	s4,s4,8
ffffffffc0204b4c:	9902                	jalr	s2
            break;
ffffffffc0204b4e:	bdcd                	j	ffffffffc0204a40 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0204b50:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0204b52:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
ffffffffc0204b56:	00c7c463          	blt	a5,a2,ffffffffc0204b5e <vprintfmt+0x152>
    else if (lflag) {
ffffffffc0204b5a:	16060463          	beqz	a2,ffffffffc0204cc2 <vprintfmt+0x2b6>
        return va_arg(*ap, unsigned long);
ffffffffc0204b5e:	000a3603          	ld	a2,0(s4)
ffffffffc0204b62:	46a9                	li	a3,10
ffffffffc0204b64:	8a3a                	mv	s4,a4
ffffffffc0204b66:	b7f9                	j	ffffffffc0204b34 <vprintfmt+0x128>
            putch('0', putdat);
ffffffffc0204b68:	03000513          	li	a0,48
ffffffffc0204b6c:	85a6                	mv	a1,s1
ffffffffc0204b6e:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0204b70:	85a6                	mv	a1,s1
ffffffffc0204b72:	07800513          	li	a0,120
ffffffffc0204b76:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204b78:	0a21                	add	s4,s4,8
            goto number;
ffffffffc0204b7a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204b7c:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0204b80:	bf55                	j	ffffffffc0204b34 <vprintfmt+0x128>
            putch(ch, putdat);
ffffffffc0204b82:	85a6                	mv	a1,s1
ffffffffc0204b84:	02500513          	li	a0,37
ffffffffc0204b88:	9902                	jalr	s2
            break;
ffffffffc0204b8a:	bd5d                	j	ffffffffc0204a40 <vprintfmt+0x34>
            precision = va_arg(ap, int);
ffffffffc0204b8c:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b90:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
ffffffffc0204b92:	0a21                	add	s4,s4,8
            goto process_precision;
ffffffffc0204b94:	bf95                	j	ffffffffc0204b08 <vprintfmt+0xfc>
    if (lflag >= 2) {
ffffffffc0204b96:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0204b98:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
ffffffffc0204b9c:	00c7c463          	blt	a5,a2,ffffffffc0204ba4 <vprintfmt+0x198>
    else if (lflag) {
ffffffffc0204ba0:	10060c63          	beqz	a2,ffffffffc0204cb8 <vprintfmt+0x2ac>
        return va_arg(*ap, unsigned long);
ffffffffc0204ba4:	000a3603          	ld	a2,0(s4)
ffffffffc0204ba8:	46a1                	li	a3,8
ffffffffc0204baa:	8a3a                	mv	s4,a4
ffffffffc0204bac:	b761                	j	ffffffffc0204b34 <vprintfmt+0x128>
            if (width < 0)
ffffffffc0204bae:	fffcc793          	not	a5,s9
ffffffffc0204bb2:	97fd                	sra	a5,a5,0x3f
ffffffffc0204bb4:	00fcf7b3          	and	a5,s9,a5
ffffffffc0204bb8:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204bbc:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0204bbe:	b56d                	j	ffffffffc0204a68 <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204bc0:	000a3403          	ld	s0,0(s4)
ffffffffc0204bc4:	008a0793          	add	a5,s4,8
ffffffffc0204bc8:	e43e                	sd	a5,8(sp)
ffffffffc0204bca:	12040163          	beqz	s0,ffffffffc0204cec <vprintfmt+0x2e0>
            if (width > 0 && padc != '-') {
ffffffffc0204bce:	0d905963          	blez	s9,ffffffffc0204ca0 <vprintfmt+0x294>
ffffffffc0204bd2:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204bd6:	00140a13          	add	s4,s0,1
            if (width > 0 && padc != '-') {
ffffffffc0204bda:	12fd9863          	bne	s11,a5,ffffffffc0204d0a <vprintfmt+0x2fe>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204bde:	00044783          	lbu	a5,0(s0)
ffffffffc0204be2:	0007851b          	sext.w	a0,a5
ffffffffc0204be6:	cb9d                	beqz	a5,ffffffffc0204c1c <vprintfmt+0x210>
ffffffffc0204be8:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204bea:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204bee:	000d4563          	bltz	s10,ffffffffc0204bf8 <vprintfmt+0x1ec>
ffffffffc0204bf2:	3d7d                	addw	s10,s10,-1
ffffffffc0204bf4:	028d0263          	beq	s10,s0,ffffffffc0204c18 <vprintfmt+0x20c>
                    putch('?', putdat);
ffffffffc0204bf8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204bfa:	0c0b8e63          	beqz	s7,ffffffffc0204cd6 <vprintfmt+0x2ca>
ffffffffc0204bfe:	3781                	addw	a5,a5,-32
ffffffffc0204c00:	0cfdfb63          	bgeu	s11,a5,ffffffffc0204cd6 <vprintfmt+0x2ca>
                    putch('?', putdat);
ffffffffc0204c04:	03f00513          	li	a0,63
ffffffffc0204c08:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204c0a:	000a4783          	lbu	a5,0(s4)
ffffffffc0204c0e:	3cfd                	addw	s9,s9,-1
ffffffffc0204c10:	0a05                	add	s4,s4,1
ffffffffc0204c12:	0007851b          	sext.w	a0,a5
ffffffffc0204c16:	ffe1                	bnez	a5,ffffffffc0204bee <vprintfmt+0x1e2>
            for (; width > 0; width --) {
ffffffffc0204c18:	01905963          	blez	s9,ffffffffc0204c2a <vprintfmt+0x21e>
ffffffffc0204c1c:	3cfd                	addw	s9,s9,-1
                putch(' ', putdat);
ffffffffc0204c1e:	85a6                	mv	a1,s1
ffffffffc0204c20:	02000513          	li	a0,32
ffffffffc0204c24:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0204c26:	fe0c9be3          	bnez	s9,ffffffffc0204c1c <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204c2a:	6a22                	ld	s4,8(sp)
ffffffffc0204c2c:	bd11                	j	ffffffffc0204a40 <vprintfmt+0x34>
    if (lflag >= 2) {
ffffffffc0204c2e:	4785                	li	a5,1
            precision = va_arg(ap, int);
ffffffffc0204c30:	008a0b93          	add	s7,s4,8
    if (lflag >= 2) {
ffffffffc0204c34:	00c7c363          	blt	a5,a2,ffffffffc0204c3a <vprintfmt+0x22e>
    else if (lflag) {
ffffffffc0204c38:	ce2d                	beqz	a2,ffffffffc0204cb2 <vprintfmt+0x2a6>
        return va_arg(*ap, long);
ffffffffc0204c3a:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0204c3e:	08044e63          	bltz	s0,ffffffffc0204cda <vprintfmt+0x2ce>
            num = getint(&ap, lflag);
ffffffffc0204c42:	8622                	mv	a2,s0
ffffffffc0204c44:	8a5e                	mv	s4,s7
ffffffffc0204c46:	46a9                	li	a3,10
ffffffffc0204c48:	b5f5                	j	ffffffffc0204b34 <vprintfmt+0x128>
            if (err < 0) {
ffffffffc0204c4a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204c4e:	4661                	li	a2,24
            if (err < 0) {
ffffffffc0204c50:	41f7d71b          	sraw	a4,a5,0x1f
ffffffffc0204c54:	8fb9                	xor	a5,a5,a4
ffffffffc0204c56:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204c5a:	02d64663          	blt	a2,a3,ffffffffc0204c86 <vprintfmt+0x27a>
ffffffffc0204c5e:	00369713          	sll	a4,a3,0x3
ffffffffc0204c62:	00002797          	auipc	a5,0x2
ffffffffc0204c66:	66e78793          	add	a5,a5,1646 # ffffffffc02072d0 <error_string>
ffffffffc0204c6a:	97ba                	add	a5,a5,a4
ffffffffc0204c6c:	639c                	ld	a5,0(a5)
ffffffffc0204c6e:	cf81                	beqz	a5,ffffffffc0204c86 <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204c70:	86be                	mv	a3,a5
ffffffffc0204c72:	00000617          	auipc	a2,0x0
ffffffffc0204c76:	1e660613          	add	a2,a2,486 # ffffffffc0204e58 <etext+0x22>
ffffffffc0204c7a:	85a6                	mv	a1,s1
ffffffffc0204c7c:	854a                	mv	a0,s2
ffffffffc0204c7e:	0ea000ef          	jal	ffffffffc0204d68 <printfmt>
            err = va_arg(ap, int);
ffffffffc0204c82:	0a21                	add	s4,s4,8
ffffffffc0204c84:	bb75                	j	ffffffffc0204a40 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204c86:	00002617          	auipc	a2,0x2
ffffffffc0204c8a:	42260613          	add	a2,a2,1058 # ffffffffc02070a8 <syscalls+0x818>
ffffffffc0204c8e:	85a6                	mv	a1,s1
ffffffffc0204c90:	854a                	mv	a0,s2
ffffffffc0204c92:	0d6000ef          	jal	ffffffffc0204d68 <printfmt>
            err = va_arg(ap, int);
ffffffffc0204c96:	0a21                	add	s4,s4,8
ffffffffc0204c98:	b365                	j	ffffffffc0204a40 <vprintfmt+0x34>
            lflag ++;
ffffffffc0204c9a:	2605                	addw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204c9c:	8462                	mv	s0,s8
            goto reswitch;
ffffffffc0204c9e:	b3e9                	j	ffffffffc0204a68 <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204ca0:	00044783          	lbu	a5,0(s0)
ffffffffc0204ca4:	00140a13          	add	s4,s0,1
ffffffffc0204ca8:	0007851b          	sext.w	a0,a5
ffffffffc0204cac:	ff95                	bnez	a5,ffffffffc0204be8 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204cae:	6a22                	ld	s4,8(sp)
ffffffffc0204cb0:	bb41                	j	ffffffffc0204a40 <vprintfmt+0x34>
        return va_arg(*ap, int);
ffffffffc0204cb2:	000a2403          	lw	s0,0(s4)
ffffffffc0204cb6:	b761                	j	ffffffffc0204c3e <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
ffffffffc0204cb8:	000a6603          	lwu	a2,0(s4)
ffffffffc0204cbc:	46a1                	li	a3,8
ffffffffc0204cbe:	8a3a                	mv	s4,a4
ffffffffc0204cc0:	bd95                	j	ffffffffc0204b34 <vprintfmt+0x128>
ffffffffc0204cc2:	000a6603          	lwu	a2,0(s4)
ffffffffc0204cc6:	46a9                	li	a3,10
ffffffffc0204cc8:	8a3a                	mv	s4,a4
ffffffffc0204cca:	b5ad                	j	ffffffffc0204b34 <vprintfmt+0x128>
ffffffffc0204ccc:	000a6603          	lwu	a2,0(s4)
ffffffffc0204cd0:	46c1                	li	a3,16
ffffffffc0204cd2:	8a3a                	mv	s4,a4
ffffffffc0204cd4:	b585                	j	ffffffffc0204b34 <vprintfmt+0x128>
                    putch(ch, putdat);
ffffffffc0204cd6:	9902                	jalr	s2
ffffffffc0204cd8:	bf0d                	j	ffffffffc0204c0a <vprintfmt+0x1fe>
                putch('-', putdat);
ffffffffc0204cda:	85a6                	mv	a1,s1
ffffffffc0204cdc:	02d00513          	li	a0,45
ffffffffc0204ce0:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0204ce2:	8a5e                	mv	s4,s7
ffffffffc0204ce4:	40800633          	neg	a2,s0
ffffffffc0204ce8:	46a9                	li	a3,10
ffffffffc0204cea:	b5a9                	j	ffffffffc0204b34 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
ffffffffc0204cec:	01905663          	blez	s9,ffffffffc0204cf8 <vprintfmt+0x2ec>
ffffffffc0204cf0:	02d00793          	li	a5,45
ffffffffc0204cf4:	04fd9263          	bne	s11,a5,ffffffffc0204d38 <vprintfmt+0x32c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204cf8:	00002a17          	auipc	s4,0x2
ffffffffc0204cfc:	3a9a0a13          	add	s4,s4,937 # ffffffffc02070a1 <syscalls+0x811>
ffffffffc0204d00:	02800513          	li	a0,40
ffffffffc0204d04:	02800793          	li	a5,40
ffffffffc0204d08:	b5c5                	j	ffffffffc0204be8 <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204d0a:	85ea                	mv	a1,s10
ffffffffc0204d0c:	8522                	mv	a0,s0
ffffffffc0204d0e:	094000ef          	jal	ffffffffc0204da2 <strnlen>
ffffffffc0204d12:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0204d16:	01905963          	blez	s9,ffffffffc0204d28 <vprintfmt+0x31c>
                    putch(padc, putdat);
ffffffffc0204d1a:	2d81                	sext.w	s11,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204d1c:	3cfd                	addw	s9,s9,-1
                    putch(padc, putdat);
ffffffffc0204d1e:	85a6                	mv	a1,s1
ffffffffc0204d20:	856e                	mv	a0,s11
ffffffffc0204d22:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204d24:	fe0c9ce3          	bnez	s9,ffffffffc0204d1c <vprintfmt+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204d28:	00044783          	lbu	a5,0(s0)
ffffffffc0204d2c:	0007851b          	sext.w	a0,a5
ffffffffc0204d30:	ea079ce3          	bnez	a5,ffffffffc0204be8 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204d34:	6a22                	ld	s4,8(sp)
ffffffffc0204d36:	b329                	j	ffffffffc0204a40 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204d38:	85ea                	mv	a1,s10
ffffffffc0204d3a:	00002517          	auipc	a0,0x2
ffffffffc0204d3e:	36650513          	add	a0,a0,870 # ffffffffc02070a0 <syscalls+0x810>
ffffffffc0204d42:	060000ef          	jal	ffffffffc0204da2 <strnlen>
ffffffffc0204d46:	40ac8cbb          	subw	s9,s9,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204d4a:	00002a17          	auipc	s4,0x2
ffffffffc0204d4e:	357a0a13          	add	s4,s4,855 # ffffffffc02070a1 <syscalls+0x811>
                p = "(null)";
ffffffffc0204d52:	00002417          	auipc	s0,0x2
ffffffffc0204d56:	34e40413          	add	s0,s0,846 # ffffffffc02070a0 <syscalls+0x810>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204d5a:	02800513          	li	a0,40
ffffffffc0204d5e:	02800793          	li	a5,40
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204d62:	fb904ce3          	bgtz	s9,ffffffffc0204d1a <vprintfmt+0x30e>
ffffffffc0204d66:	b549                	j	ffffffffc0204be8 <vprintfmt+0x1dc>

ffffffffc0204d68 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204d68:	715d                	add	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204d6a:	02810313          	add	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204d6e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204d70:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204d72:	ec06                	sd	ra,24(sp)
ffffffffc0204d74:	f83a                	sd	a4,48(sp)
ffffffffc0204d76:	fc3e                	sd	a5,56(sp)
ffffffffc0204d78:	e0c2                	sd	a6,64(sp)
ffffffffc0204d7a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204d7c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204d7e:	c8fff0ef          	jal	ffffffffc0204a0c <vprintfmt>
}
ffffffffc0204d82:	60e2                	ld	ra,24(sp)
ffffffffc0204d84:	6161                	add	sp,sp,80
ffffffffc0204d86:	8082                	ret

ffffffffc0204d88 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0204d88:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0204d8c:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0204d8e:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0204d90:	cb81                	beqz	a5,ffffffffc0204da0 <strlen+0x18>
        cnt ++;
ffffffffc0204d92:	0505                	add	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0204d94:	00a707b3          	add	a5,a4,a0
ffffffffc0204d98:	0007c783          	lbu	a5,0(a5)
ffffffffc0204d9c:	fbfd                	bnez	a5,ffffffffc0204d92 <strlen+0xa>
ffffffffc0204d9e:	8082                	ret
    }
    return cnt;
}
ffffffffc0204da0:	8082                	ret

ffffffffc0204da2 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0204da2:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204da4:	e589                	bnez	a1,ffffffffc0204dae <strnlen+0xc>
ffffffffc0204da6:	a811                	j	ffffffffc0204dba <strnlen+0x18>
        cnt ++;
ffffffffc0204da8:	0785                	add	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204daa:	00f58863          	beq	a1,a5,ffffffffc0204dba <strnlen+0x18>
ffffffffc0204dae:	00f50733          	add	a4,a0,a5
ffffffffc0204db2:	00074703          	lbu	a4,0(a4)
ffffffffc0204db6:	fb6d                	bnez	a4,ffffffffc0204da8 <strnlen+0x6>
ffffffffc0204db8:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0204dba:	852e                	mv	a0,a1
ffffffffc0204dbc:	8082                	ret

ffffffffc0204dbe <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204dbe:	00054783          	lbu	a5,0(a0)
ffffffffc0204dc2:	e791                	bnez	a5,ffffffffc0204dce <strcmp+0x10>
ffffffffc0204dc4:	a02d                	j	ffffffffc0204dee <strcmp+0x30>
ffffffffc0204dc6:	00054783          	lbu	a5,0(a0)
ffffffffc0204dca:	cf89                	beqz	a5,ffffffffc0204de4 <strcmp+0x26>
        s1 ++, s2 ++;
ffffffffc0204dcc:	85b6                	mv	a1,a3
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204dce:	0005c703          	lbu	a4,0(a1)
        s1 ++, s2 ++;
ffffffffc0204dd2:	0505                	add	a0,a0,1
ffffffffc0204dd4:	00158693          	add	a3,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204dd8:	fef707e3          	beq	a4,a5,ffffffffc0204dc6 <strcmp+0x8>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204ddc:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204de0:	9d19                	subw	a0,a0,a4
ffffffffc0204de2:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204de4:	0015c703          	lbu	a4,1(a1)
ffffffffc0204de8:	4501                	li	a0,0
}
ffffffffc0204dea:	9d19                	subw	a0,a0,a4
ffffffffc0204dec:	8082                	ret
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204dee:	0005c703          	lbu	a4,0(a1)
ffffffffc0204df2:	4501                	li	a0,0
ffffffffc0204df4:	b7f5                	j	ffffffffc0204de0 <strcmp+0x22>

ffffffffc0204df6 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0204df6:	00054783          	lbu	a5,0(a0)
ffffffffc0204dfa:	c799                	beqz	a5,ffffffffc0204e08 <strchr+0x12>
        if (*s == c) {
ffffffffc0204dfc:	00f58763          	beq	a1,a5,ffffffffc0204e0a <strchr+0x14>
    while (*s != '\0') {
ffffffffc0204e00:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0204e04:	0505                	add	a0,a0,1
    while (*s != '\0') {
ffffffffc0204e06:	fbfd                	bnez	a5,ffffffffc0204dfc <strchr+0x6>
    }
    return NULL;
ffffffffc0204e08:	4501                	li	a0,0
}
ffffffffc0204e0a:	8082                	ret

ffffffffc0204e0c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0204e0c:	ca01                	beqz	a2,ffffffffc0204e1c <memset+0x10>
ffffffffc0204e0e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0204e10:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0204e12:	0785                	add	a5,a5,1
ffffffffc0204e14:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0204e18:	fec79de3          	bne	a5,a2,ffffffffc0204e12 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0204e1c:	8082                	ret

ffffffffc0204e1e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204e1e:	ca19                	beqz	a2,ffffffffc0204e34 <memcpy+0x16>
ffffffffc0204e20:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0204e22:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0204e24:	0005c703          	lbu	a4,0(a1)
ffffffffc0204e28:	0585                	add	a1,a1,1
ffffffffc0204e2a:	0785                	add	a5,a5,1
ffffffffc0204e2c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0204e30:	fec59ae3          	bne	a1,a2,ffffffffc0204e24 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0204e34:	8082                	ret
