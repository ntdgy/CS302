
obj/__user_ex3.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	13a000ef          	jal	80015a <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800026:	715d                	add	sp,sp,-80
  800028:	832e                	mv	t1,a1
  80002a:	e822                	sd	s0,16(sp)
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("user panic at %s:%d:\n    ", file, line);
  80002c:	85aa                	mv	a1,a0
__panic(const char *file, int line, const char *fmt, ...) {
  80002e:	8432                	mv	s0,a2
  800030:	fc3e                	sd	a5,56(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  800032:	861a                	mv	a2,t1
    va_start(ap, fmt);
  800034:	103c                	add	a5,sp,40
    cprintf("user panic at %s:%d:\n    ", file, line);
  800036:	00000517          	auipc	a0,0x0
  80003a:	6a250513          	add	a0,a0,1698 # 8006d8 <main+0x15a>
__panic(const char *file, int line, const char *fmt, ...) {
  80003e:	ec06                	sd	ra,24(sp)
  800040:	f436                	sd	a3,40(sp)
  800042:	f83a                	sd	a4,48(sp)
  800044:	e0c2                	sd	a6,64(sp)
  800046:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800048:	e43e                	sd	a5,8(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80004a:	058000ef          	jal	8000a2 <cprintf>
    vcprintf(fmt, ap);
  80004e:	65a2                	ld	a1,8(sp)
  800050:	8522                	mv	a0,s0
  800052:	030000ef          	jal	800082 <vcprintf>
    cprintf("\n");
  800056:	00000517          	auipc	a0,0x0
  80005a:	6a250513          	add	a0,a0,1698 # 8006f8 <main+0x17a>
  80005e:	044000ef          	jal	8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0d6000ef          	jal	80013a <exit>

0000000000800068 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800068:	1141                	add	sp,sp,-16
  80006a:	e022                	sd	s0,0(sp)
  80006c:	e406                	sd	ra,8(sp)
  80006e:	842e                	mv	s0,a1
    sys_putc(c);
  800070:	0bc000ef          	jal	80012c <sys_putc>
    (*cnt) ++;
  800074:	401c                	lw	a5,0(s0)
}
  800076:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800078:	2785                	addw	a5,a5,1
  80007a:	c01c                	sw	a5,0(s0)
}
  80007c:	6402                	ld	s0,0(sp)
  80007e:	0141                	add	sp,sp,16
  800080:	8082                	ret

0000000000800082 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  800082:	1101                	add	sp,sp,-32
  800084:	862a                	mv	a2,a0
  800086:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800088:	00000517          	auipc	a0,0x0
  80008c:	fe050513          	add	a0,a0,-32 # 800068 <cputch>
  800090:	006c                	add	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
  800092:	ec06                	sd	ra,24(sp)
    int cnt = 0;
  800094:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800096:	13e000ef          	jal	8001d4 <vprintfmt>
    return cnt;
}
  80009a:	60e2                	ld	ra,24(sp)
  80009c:	4532                	lw	a0,12(sp)
  80009e:	6105                	add	sp,sp,32
  8000a0:	8082                	ret

00000000008000a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  8000a2:	711d                	add	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  8000a4:	02810313          	add	t1,sp,40
cprintf(const char *fmt, ...) {
  8000a8:	8e2a                	mv	t3,a0
  8000aa:	f42e                	sd	a1,40(sp)
  8000ac:	f832                	sd	a2,48(sp)
  8000ae:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000b0:	00000517          	auipc	a0,0x0
  8000b4:	fb850513          	add	a0,a0,-72 # 800068 <cputch>
  8000b8:	004c                	add	a1,sp,4
  8000ba:	869a                	mv	a3,t1
  8000bc:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  8000be:	ec06                	sd	ra,24(sp)
  8000c0:	e0ba                	sd	a4,64(sp)
  8000c2:	e4be                	sd	a5,72(sp)
  8000c4:	e8c2                	sd	a6,80(sp)
  8000c6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  8000c8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  8000ca:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000cc:	108000ef          	jal	8001d4 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  8000d0:	60e2                	ld	ra,24(sp)
  8000d2:	4512                	lw	a0,4(sp)
  8000d4:	6125                	add	sp,sp,96
  8000d6:	8082                	ret

00000000008000d8 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  8000d8:	7175                	add	sp,sp,-144
  8000da:	e42a                	sd	a0,8(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  8000dc:	0108                	add	a0,sp,128
syscall(int64_t num, ...) {
  8000de:	ecae                	sd	a1,88(sp)
  8000e0:	f0b2                	sd	a2,96(sp)
  8000e2:	f4b6                	sd	a3,104(sp)
  8000e4:	f8ba                	sd	a4,112(sp)
  8000e6:	fcbe                	sd	a5,120(sp)
  8000e8:	e142                	sd	a6,128(sp)
  8000ea:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  8000ec:	f02a                	sd	a0,32(sp)
  8000ee:	f42e                	sd	a1,40(sp)
  8000f0:	f832                	sd	a2,48(sp)
  8000f2:	fc36                	sd	a3,56(sp)
  8000f4:	e0ba                	sd	a4,64(sp)
  8000f6:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);
    asm volatile (
  8000f8:	4522                	lw	a0,8(sp)
  8000fa:	55a2                	lw	a1,40(sp)
  8000fc:	5642                	lw	a2,48(sp)
  8000fe:	56e2                	lw	a3,56(sp)
  800100:	4706                	lw	a4,64(sp)
  800102:	47a6                	lw	a5,72(sp)
  800104:	00000073          	ecall
  800108:	ce2a                	sw	a0,28(sp)
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
    return ret;
}
  80010a:	4572                	lw	a0,28(sp)
  80010c:	6149                	add	sp,sp,144
  80010e:	8082                	ret

0000000000800110 <sys_exit>:

int
sys_exit(int64_t error_code) {
  800110:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  800112:	4505                	li	a0,1
  800114:	b7d1                	j	8000d8 <syscall>

0000000000800116 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  800116:	4509                	li	a0,2
  800118:	b7c1                	j	8000d8 <syscall>

000000000080011a <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  80011a:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  80011c:	85aa                	mv	a1,a0
  80011e:	450d                	li	a0,3
  800120:	bf65                	j	8000d8 <syscall>

0000000000800122 <sys_kill>:
sys_yield(void) {
    return syscall(SYS_yield);
}

int
sys_kill(int64_t pid) {
  800122:	85aa                	mv	a1,a0
    return syscall(SYS_kill, pid);
  800124:	4531                	li	a0,12
  800126:	bf4d                	j	8000d8 <syscall>

0000000000800128 <sys_getpid>:
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  800128:	4549                	li	a0,18
  80012a:	b77d                	j	8000d8 <syscall>

000000000080012c <sys_putc>:
}

int
sys_putc(int64_t c) {
  80012c:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  80012e:	4579                	li	a0,30
  800130:	b765                	j	8000d8 <syscall>

0000000000800132 <sys_set_good>:
int
sys_gettime(void) {
    return syscall(SYS_gettime);
}

int sys_set_good(uint32_t good){
  800132:	85aa                	mv	a1,a0
    return syscall(SYS_set_good,good);
  800134:	0fe00513          	li	a0,254
  800138:	b745                	j	8000d8 <syscall>

000000000080013a <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  80013a:	1141                	add	sp,sp,-16
  80013c:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  80013e:	fd3ff0ef          	jal	800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800142:	00000517          	auipc	a0,0x0
  800146:	5be50513          	add	a0,a0,1470 # 800700 <main+0x182>
  80014a:	f59ff0ef          	jal	8000a2 <cprintf>
    while (1);
  80014e:	a001                	j	80014e <exit+0x14>

0000000000800150 <fork>:
}

int
fork(void) {
    return sys_fork();
  800150:	b7d9                	j	800116 <sys_fork>

0000000000800152 <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  800152:	b7e1                	j	80011a <sys_wait>

0000000000800154 <kill>:
    sys_yield();
}

int
kill(int pid) {
    return sys_kill(pid);
  800154:	b7f9                	j	800122 <sys_kill>

0000000000800156 <getpid>:
}

int
getpid(void) {
    return sys_getpid();
  800156:	bfc9                	j	800128 <sys_getpid>

0000000000800158 <set_good>:
gettime_msec(void) {
    return (unsigned int)sys_gettime();
}

void set_good(uint32_t good){
    sys_set_good(good);
  800158:	bfe9                	j	800132 <sys_set_good>

000000000080015a <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  80015a:	1141                	add	sp,sp,-16
  80015c:	e406                	sd	ra,8(sp)
    int ret = main();
  80015e:	420000ef          	jal	80057e <main>
    exit(ret);
  800162:	fd9ff0ef          	jal	80013a <exit>

0000000000800166 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800166:	02069813          	sll	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80016a:	7179                	add	sp,sp,-48
    unsigned mod = do_div(result, base);
  80016c:	02085813          	srl	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800170:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  800172:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800176:	f022                	sd	s0,32(sp)
  800178:	ec26                	sd	s1,24(sp)
  80017a:	e84a                	sd	s2,16(sp)
  80017c:	f406                	sd	ra,40(sp)
  80017e:	e44e                	sd	s3,8(sp)
  800180:	84aa                	mv	s1,a0
  800182:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800184:	fff7041b          	addw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800188:	2a01                	sext.w	s4,s4
    if (num >= base) {
  80018a:	03067f63          	bgeu	a2,a6,8001c8 <printnum+0x62>
  80018e:	89be                	mv	s3,a5
        while (-- width > 0)
  800190:	4785                	li	a5,1
  800192:	00e7d763          	bge	a5,a4,8001a0 <printnum+0x3a>
  800196:	347d                	addw	s0,s0,-1
            putch(padc, putdat);
  800198:	85ca                	mv	a1,s2
  80019a:	854e                	mv	a0,s3
  80019c:	9482                	jalr	s1
        while (-- width > 0)
  80019e:	fc65                	bnez	s0,800196 <printnum+0x30>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8001a0:	1a02                	sll	s4,s4,0x20
  8001a2:	020a5a13          	srl	s4,s4,0x20
  8001a6:	00000797          	auipc	a5,0x0
  8001aa:	57278793          	add	a5,a5,1394 # 800718 <main+0x19a>
  8001ae:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001b0:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001b2:	0007c503          	lbu	a0,0(a5)
}
  8001b6:	70a2                	ld	ra,40(sp)
  8001b8:	69a2                	ld	s3,8(sp)
  8001ba:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001bc:	85ca                	mv	a1,s2
  8001be:	87a6                	mv	a5,s1
}
  8001c0:	6942                	ld	s2,16(sp)
  8001c2:	64e2                	ld	s1,24(sp)
  8001c4:	6145                	add	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001c6:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001c8:	03065633          	divu	a2,a2,a6
  8001cc:	8722                	mv	a4,s0
  8001ce:	f99ff0ef          	jal	800166 <printnum>
  8001d2:	b7f9                	j	8001a0 <printnum+0x3a>

00000000008001d4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001d4:	7119                	add	sp,sp,-128
  8001d6:	f4a6                	sd	s1,104(sp)
  8001d8:	f0ca                	sd	s2,96(sp)
  8001da:	ecce                	sd	s3,88(sp)
  8001dc:	e8d2                	sd	s4,80(sp)
  8001de:	e4d6                	sd	s5,72(sp)
  8001e0:	e0da                	sd	s6,64(sp)
  8001e2:	f862                	sd	s8,48(sp)
  8001e4:	fc86                	sd	ra,120(sp)
  8001e6:	f8a2                	sd	s0,112(sp)
  8001e8:	fc5e                	sd	s7,56(sp)
  8001ea:	f466                	sd	s9,40(sp)
  8001ec:	f06a                	sd	s10,32(sp)
  8001ee:	ec6e                	sd	s11,24(sp)
  8001f0:	892a                	mv	s2,a0
  8001f2:	84ae                	mv	s1,a1
  8001f4:	8c32                	mv	s8,a2
  8001f6:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001f8:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8001fc:	05500b13          	li	s6,85
  800200:	00000a97          	auipc	s5,0x0
  800204:	54ca8a93          	add	s5,s5,1356 # 80074c <main+0x1ce>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800208:	000c4503          	lbu	a0,0(s8)
  80020c:	001c0413          	add	s0,s8,1
  800210:	01350a63          	beq	a0,s3,800224 <vprintfmt+0x50>
            if (ch == '\0') {
  800214:	cd0d                	beqz	a0,80024e <vprintfmt+0x7a>
            putch(ch, putdat);
  800216:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800218:	0405                	add	s0,s0,1
            putch(ch, putdat);
  80021a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80021c:	fff44503          	lbu	a0,-1(s0)
  800220:	ff351ae3          	bne	a0,s3,800214 <vprintfmt+0x40>
        char padc = ' ';
  800224:	02000d93          	li	s11,32
        lflag = altflag = 0;
  800228:	4b81                	li	s7,0
  80022a:	4601                	li	a2,0
        width = precision = -1;
  80022c:	5d7d                	li	s10,-1
  80022e:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
  800230:	00044683          	lbu	a3,0(s0)
  800234:	00140c13          	add	s8,s0,1
  800238:	fdd6859b          	addw	a1,a3,-35
  80023c:	0ff5f593          	zext.b	a1,a1
  800240:	02bb6663          	bltu	s6,a1,80026c <vprintfmt+0x98>
  800244:	058a                	sll	a1,a1,0x2
  800246:	95d6                	add	a1,a1,s5
  800248:	4198                	lw	a4,0(a1)
  80024a:	9756                	add	a4,a4,s5
  80024c:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80024e:	70e6                	ld	ra,120(sp)
  800250:	7446                	ld	s0,112(sp)
  800252:	74a6                	ld	s1,104(sp)
  800254:	7906                	ld	s2,96(sp)
  800256:	69e6                	ld	s3,88(sp)
  800258:	6a46                	ld	s4,80(sp)
  80025a:	6aa6                	ld	s5,72(sp)
  80025c:	6b06                	ld	s6,64(sp)
  80025e:	7be2                	ld	s7,56(sp)
  800260:	7c42                	ld	s8,48(sp)
  800262:	7ca2                	ld	s9,40(sp)
  800264:	7d02                	ld	s10,32(sp)
  800266:	6de2                	ld	s11,24(sp)
  800268:	6109                	add	sp,sp,128
  80026a:	8082                	ret
            putch('%', putdat);
  80026c:	85a6                	mv	a1,s1
  80026e:	02500513          	li	a0,37
  800272:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800274:	fff44703          	lbu	a4,-1(s0)
  800278:	02500793          	li	a5,37
  80027c:	8c22                	mv	s8,s0
  80027e:	f8f705e3          	beq	a4,a5,800208 <vprintfmt+0x34>
  800282:	02500713          	li	a4,37
  800286:	ffec4783          	lbu	a5,-2(s8)
  80028a:	1c7d                	add	s8,s8,-1
  80028c:	fee79de3          	bne	a5,a4,800286 <vprintfmt+0xb2>
  800290:	bfa5                	j	800208 <vprintfmt+0x34>
                ch = *fmt;
  800292:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
  800296:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
  800298:	fd068d1b          	addw	s10,a3,-48
                if (ch < '0' || ch > '9') {
  80029c:	fd07859b          	addw	a1,a5,-48
                ch = *fmt;
  8002a0:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
  8002a4:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
  8002a6:	02b76563          	bltu	a4,a1,8002d0 <vprintfmt+0xfc>
  8002aa:	4525                	li	a0,9
                ch = *fmt;
  8002ac:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
  8002b0:	002d171b          	sllw	a4,s10,0x2
  8002b4:	01a7073b          	addw	a4,a4,s10
  8002b8:	0017171b          	sllw	a4,a4,0x1
  8002bc:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
  8002be:	fd07859b          	addw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
  8002c2:	0405                	add	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002c4:	fd070d1b          	addw	s10,a4,-48
                ch = *fmt;
  8002c8:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
  8002cc:	feb570e3          	bgeu	a0,a1,8002ac <vprintfmt+0xd8>
            if (width < 0)
  8002d0:	f60cd0e3          	bgez	s9,800230 <vprintfmt+0x5c>
                width = precision, precision = -1;
  8002d4:	8cea                	mv	s9,s10
  8002d6:	5d7d                	li	s10,-1
  8002d8:	bfa1                	j	800230 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
  8002da:	8db6                	mv	s11,a3
  8002dc:	8462                	mv	s0,s8
  8002de:	bf89                	j	800230 <vprintfmt+0x5c>
  8002e0:	8462                	mv	s0,s8
            altflag = 1;
  8002e2:	4b85                	li	s7,1
            goto reswitch;
  8002e4:	b7b1                	j	800230 <vprintfmt+0x5c>
    if (lflag >= 2) {
  8002e6:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8002e8:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  8002ec:	00c7c463          	blt	a5,a2,8002f4 <vprintfmt+0x120>
    else if (lflag) {
  8002f0:	1a060263          	beqz	a2,800494 <vprintfmt+0x2c0>
        return va_arg(*ap, unsigned long);
  8002f4:	000a3603          	ld	a2,0(s4)
  8002f8:	46c1                	li	a3,16
  8002fa:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
  8002fc:	000d879b          	sext.w	a5,s11
  800300:	8766                	mv	a4,s9
  800302:	85a6                	mv	a1,s1
  800304:	854a                	mv	a0,s2
  800306:	e61ff0ef          	jal	800166 <printnum>
            break;
  80030a:	bdfd                	j	800208 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
  80030c:	000a2503          	lw	a0,0(s4)
  800310:	85a6                	mv	a1,s1
  800312:	0a21                	add	s4,s4,8
  800314:	9902                	jalr	s2
            break;
  800316:	bdcd                	j	800208 <vprintfmt+0x34>
    if (lflag >= 2) {
  800318:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80031a:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  80031e:	00c7c463          	blt	a5,a2,800326 <vprintfmt+0x152>
    else if (lflag) {
  800322:	16060463          	beqz	a2,80048a <vprintfmt+0x2b6>
        return va_arg(*ap, unsigned long);
  800326:	000a3603          	ld	a2,0(s4)
  80032a:	46a9                	li	a3,10
  80032c:	8a3a                	mv	s4,a4
  80032e:	b7f9                	j	8002fc <vprintfmt+0x128>
            putch('0', putdat);
  800330:	03000513          	li	a0,48
  800334:	85a6                	mv	a1,s1
  800336:	9902                	jalr	s2
            putch('x', putdat);
  800338:	85a6                	mv	a1,s1
  80033a:	07800513          	li	a0,120
  80033e:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800340:	0a21                	add	s4,s4,8
            goto number;
  800342:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800344:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800348:	bf55                	j	8002fc <vprintfmt+0x128>
            putch(ch, putdat);
  80034a:	85a6                	mv	a1,s1
  80034c:	02500513          	li	a0,37
  800350:	9902                	jalr	s2
            break;
  800352:	bd5d                	j	800208 <vprintfmt+0x34>
            precision = va_arg(ap, int);
  800354:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800358:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
  80035a:	0a21                	add	s4,s4,8
            goto process_precision;
  80035c:	bf95                	j	8002d0 <vprintfmt+0xfc>
    if (lflag >= 2) {
  80035e:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800360:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  800364:	00c7c463          	blt	a5,a2,80036c <vprintfmt+0x198>
    else if (lflag) {
  800368:	10060c63          	beqz	a2,800480 <vprintfmt+0x2ac>
        return va_arg(*ap, unsigned long);
  80036c:	000a3603          	ld	a2,0(s4)
  800370:	46a1                	li	a3,8
  800372:	8a3a                	mv	s4,a4
  800374:	b761                	j	8002fc <vprintfmt+0x128>
            if (width < 0)
  800376:	fffcc793          	not	a5,s9
  80037a:	97fd                	sra	a5,a5,0x3f
  80037c:	00fcf7b3          	and	a5,s9,a5
  800380:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800384:	8462                	mv	s0,s8
            goto reswitch;
  800386:	b56d                	j	800230 <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
  800388:	000a3403          	ld	s0,0(s4)
  80038c:	008a0793          	add	a5,s4,8
  800390:	e43e                	sd	a5,8(sp)
  800392:	12040163          	beqz	s0,8004b4 <vprintfmt+0x2e0>
            if (width > 0 && padc != '-') {
  800396:	0d905963          	blez	s9,800468 <vprintfmt+0x294>
  80039a:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80039e:	00140a13          	add	s4,s0,1
            if (width > 0 && padc != '-') {
  8003a2:	12fd9863          	bne	s11,a5,8004d2 <vprintfmt+0x2fe>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003a6:	00044783          	lbu	a5,0(s0)
  8003aa:	0007851b          	sext.w	a0,a5
  8003ae:	cb9d                	beqz	a5,8003e4 <vprintfmt+0x210>
  8003b0:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003b2:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003b6:	000d4563          	bltz	s10,8003c0 <vprintfmt+0x1ec>
  8003ba:	3d7d                	addw	s10,s10,-1
  8003bc:	028d0263          	beq	s10,s0,8003e0 <vprintfmt+0x20c>
                    putch('?', putdat);
  8003c0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003c2:	0c0b8e63          	beqz	s7,80049e <vprintfmt+0x2ca>
  8003c6:	3781                	addw	a5,a5,-32
  8003c8:	0cfdfb63          	bgeu	s11,a5,80049e <vprintfmt+0x2ca>
                    putch('?', putdat);
  8003cc:	03f00513          	li	a0,63
  8003d0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003d2:	000a4783          	lbu	a5,0(s4)
  8003d6:	3cfd                	addw	s9,s9,-1
  8003d8:	0a05                	add	s4,s4,1
  8003da:	0007851b          	sext.w	a0,a5
  8003de:	ffe1                	bnez	a5,8003b6 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
  8003e0:	01905963          	blez	s9,8003f2 <vprintfmt+0x21e>
  8003e4:	3cfd                	addw	s9,s9,-1
                putch(' ', putdat);
  8003e6:	85a6                	mv	a1,s1
  8003e8:	02000513          	li	a0,32
  8003ec:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003ee:	fe0c9be3          	bnez	s9,8003e4 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003f2:	6a22                	ld	s4,8(sp)
  8003f4:	bd11                	j	800208 <vprintfmt+0x34>
    if (lflag >= 2) {
  8003f6:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003f8:	008a0b93          	add	s7,s4,8
    if (lflag >= 2) {
  8003fc:	00c7c363          	blt	a5,a2,800402 <vprintfmt+0x22e>
    else if (lflag) {
  800400:	ce2d                	beqz	a2,80047a <vprintfmt+0x2a6>
        return va_arg(*ap, long);
  800402:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800406:	08044e63          	bltz	s0,8004a2 <vprintfmt+0x2ce>
            num = getint(&ap, lflag);
  80040a:	8622                	mv	a2,s0
  80040c:	8a5e                	mv	s4,s7
  80040e:	46a9                	li	a3,10
  800410:	b5f5                	j	8002fc <vprintfmt+0x128>
            if (err < 0) {
  800412:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800416:	4661                	li	a2,24
            if (err < 0) {
  800418:	41f7d71b          	sraw	a4,a5,0x1f
  80041c:	8fb9                	xor	a5,a5,a4
  80041e:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800422:	02d64663          	blt	a2,a3,80044e <vprintfmt+0x27a>
  800426:	00369713          	sll	a4,a3,0x3
  80042a:	00000797          	auipc	a5,0x0
  80042e:	53e78793          	add	a5,a5,1342 # 800968 <error_string>
  800432:	97ba                	add	a5,a5,a4
  800434:	639c                	ld	a5,0(a5)
  800436:	cf81                	beqz	a5,80044e <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
  800438:	86be                	mv	a3,a5
  80043a:	00000617          	auipc	a2,0x0
  80043e:	30e60613          	add	a2,a2,782 # 800748 <main+0x1ca>
  800442:	85a6                	mv	a1,s1
  800444:	854a                	mv	a0,s2
  800446:	0ea000ef          	jal	800530 <printfmt>
            err = va_arg(ap, int);
  80044a:	0a21                	add	s4,s4,8
  80044c:	bb75                	j	800208 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
  80044e:	00000617          	auipc	a2,0x0
  800452:	2ea60613          	add	a2,a2,746 # 800738 <main+0x1ba>
  800456:	85a6                	mv	a1,s1
  800458:	854a                	mv	a0,s2
  80045a:	0d6000ef          	jal	800530 <printfmt>
            err = va_arg(ap, int);
  80045e:	0a21                	add	s4,s4,8
  800460:	b365                	j	800208 <vprintfmt+0x34>
            lflag ++;
  800462:	2605                	addw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
  800464:	8462                	mv	s0,s8
            goto reswitch;
  800466:	b3e9                	j	800230 <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800468:	00044783          	lbu	a5,0(s0)
  80046c:	00140a13          	add	s4,s0,1
  800470:	0007851b          	sext.w	a0,a5
  800474:	ff95                	bnez	a5,8003b0 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  800476:	6a22                	ld	s4,8(sp)
  800478:	bb41                	j	800208 <vprintfmt+0x34>
        return va_arg(*ap, int);
  80047a:	000a2403          	lw	s0,0(s4)
  80047e:	b761                	j	800406 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
  800480:	000a6603          	lwu	a2,0(s4)
  800484:	46a1                	li	a3,8
  800486:	8a3a                	mv	s4,a4
  800488:	bd95                	j	8002fc <vprintfmt+0x128>
  80048a:	000a6603          	lwu	a2,0(s4)
  80048e:	46a9                	li	a3,10
  800490:	8a3a                	mv	s4,a4
  800492:	b5ad                	j	8002fc <vprintfmt+0x128>
  800494:	000a6603          	lwu	a2,0(s4)
  800498:	46c1                	li	a3,16
  80049a:	8a3a                	mv	s4,a4
  80049c:	b585                	j	8002fc <vprintfmt+0x128>
                    putch(ch, putdat);
  80049e:	9902                	jalr	s2
  8004a0:	bf0d                	j	8003d2 <vprintfmt+0x1fe>
                putch('-', putdat);
  8004a2:	85a6                	mv	a1,s1
  8004a4:	02d00513          	li	a0,45
  8004a8:	9902                	jalr	s2
                num = -(long long)num;
  8004aa:	8a5e                	mv	s4,s7
  8004ac:	40800633          	neg	a2,s0
  8004b0:	46a9                	li	a3,10
  8004b2:	b5a9                	j	8002fc <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
  8004b4:	01905663          	blez	s9,8004c0 <vprintfmt+0x2ec>
  8004b8:	02d00793          	li	a5,45
  8004bc:	04fd9263          	bne	s11,a5,800500 <vprintfmt+0x32c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004c0:	00000a17          	auipc	s4,0x0
  8004c4:	271a0a13          	add	s4,s4,625 # 800731 <main+0x1b3>
  8004c8:	02800513          	li	a0,40
  8004cc:	02800793          	li	a5,40
  8004d0:	b5c5                	j	8003b0 <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004d2:	85ea                	mv	a1,s10
  8004d4:	8522                	mv	a0,s0
  8004d6:	07a000ef          	jal	800550 <strnlen>
  8004da:	40ac8cbb          	subw	s9,s9,a0
  8004de:	01905963          	blez	s9,8004f0 <vprintfmt+0x31c>
                    putch(padc, putdat);
  8004e2:	2d81                	sext.w	s11,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004e4:	3cfd                	addw	s9,s9,-1
                    putch(padc, putdat);
  8004e6:	85a6                	mv	a1,s1
  8004e8:	856e                	mv	a0,s11
  8004ea:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004ec:	fe0c9ce3          	bnez	s9,8004e4 <vprintfmt+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004f0:	00044783          	lbu	a5,0(s0)
  8004f4:	0007851b          	sext.w	a0,a5
  8004f8:	ea079ce3          	bnez	a5,8003b0 <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  8004fc:	6a22                	ld	s4,8(sp)
  8004fe:	b329                	j	800208 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800500:	85ea                	mv	a1,s10
  800502:	00000517          	auipc	a0,0x0
  800506:	22e50513          	add	a0,a0,558 # 800730 <main+0x1b2>
  80050a:	046000ef          	jal	800550 <strnlen>
  80050e:	40ac8cbb          	subw	s9,s9,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800512:	00000a17          	auipc	s4,0x0
  800516:	21fa0a13          	add	s4,s4,543 # 800731 <main+0x1b3>
                p = "(null)";
  80051a:	00000417          	auipc	s0,0x0
  80051e:	21640413          	add	s0,s0,534 # 800730 <main+0x1b2>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800522:	02800513          	li	a0,40
  800526:	02800793          	li	a5,40
                for (width -= strnlen(p, precision); width > 0; width --) {
  80052a:	fb904ce3          	bgtz	s9,8004e2 <vprintfmt+0x30e>
  80052e:	b549                	j	8003b0 <vprintfmt+0x1dc>

0000000000800530 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800530:	715d                	add	sp,sp,-80
    va_start(ap, fmt);
  800532:	02810313          	add	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800536:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800538:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80053a:	ec06                	sd	ra,24(sp)
  80053c:	f83a                	sd	a4,48(sp)
  80053e:	fc3e                	sd	a5,56(sp)
  800540:	e0c2                	sd	a6,64(sp)
  800542:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800544:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800546:	c8fff0ef          	jal	8001d4 <vprintfmt>
}
  80054a:	60e2                	ld	ra,24(sp)
  80054c:	6161                	add	sp,sp,80
  80054e:	8082                	ret

0000000000800550 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800550:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800552:	e589                	bnez	a1,80055c <strnlen+0xc>
  800554:	a811                	j	800568 <strnlen+0x18>
        cnt ++;
  800556:	0785                	add	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800558:	00f58863          	beq	a1,a5,800568 <strnlen+0x18>
  80055c:	00f50733          	add	a4,a0,a5
  800560:	00074703          	lbu	a4,0(a4)
  800564:	fb6d                	bnez	a4,800556 <strnlen+0x6>
  800566:	85be                	mv	a1,a5
    }
    return cnt;
}
  800568:	852e                	mv	a0,a1
  80056a:	8082                	ret

000000000080056c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
  80056c:	ca01                	beqz	a2,80057c <memset+0x10>
  80056e:	962a                	add	a2,a2,a0
    char *p = s;
  800570:	87aa                	mv	a5,a0
        *p ++ = c;
  800572:	0785                	add	a5,a5,1
  800574:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
  800578:	fec79de3          	bne	a5,a2,800572 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  80057c:	8082                	ret

000000000080057e <main>:
          j = !j;
     }
}

int
main(void) {
  80057e:	711d                	add	sp,sp,-96
     //open this
     
     int i,time;
     memset(pids, 0, sizeof(pids));
  800580:	4651                	li	a2,20
  800582:	4581                	li	a1,0
  800584:	00001517          	auipc	a0,0x1
  800588:	a7c50513          	add	a0,a0,-1412 # 801000 <pids>
main(void) {
  80058c:	e8a2                	sd	s0,80(sp)
  80058e:	e4a6                	sd	s1,72(sp)
  800590:	e0ca                	sd	s2,64(sp)
  800592:	fc4e                	sd	s3,56(sp)
  800594:	f852                	sd	s4,48(sp)
  800596:	f456                	sd	s5,40(sp)
  800598:	ec86                	sd	ra,88(sp)
     memset(pids, 0, sizeof(pids));
  80059a:	fd3ff0ef          	jal	80056c <memset>
     int goods[TOTAL]= {3,1,4,5,2};
  80059e:	4795                	li	a5,5
  8005a0:	4705                	li	a4,1
  8005a2:	1782                	sll	a5,a5,0x20
  8005a4:	0791                	add	a5,a5,4
  8005a6:	1702                	sll	a4,a4,0x20
  8005a8:	00001a17          	auipc	s4,0x1
  8005ac:	a88a0a13          	add	s4,s4,-1400 # 801030 <acc>
  8005b0:	00001497          	auipc	s1,0x1
  8005b4:	a5048493          	add	s1,s1,-1456 # 801000 <pids>
  8005b8:	070d                	add	a4,a4,3
  8005ba:	e83e                	sd	a5,16(sp)
  8005bc:	4789                	li	a5,2
  8005be:	e43a                	sd	a4,8(sp)
  8005c0:	cc3e                	sw	a5,24(sp)
     for (i = 0; i < TOTAL; i ++) {
  8005c2:	89d2                	mv	s3,s4
     int goods[TOTAL]= {3,1,4,5,2};
  8005c4:	8926                	mv	s2,s1
     for (i = 0; i < TOTAL; i ++) {
  8005c6:	4401                	li	s0,0
  8005c8:	4a95                	li	s5,5
          acc[i]=0;
  8005ca:	0009a023          	sw	zero,0(s3)
          if ((pids[i] = fork()) == 0) {
  8005ce:	b83ff0ef          	jal	800150 <fork>
  8005d2:	00a92023          	sw	a0,0(s2)
  8005d6:	c125                	beqz	a0,800636 <main+0xb8>
                         exit(acc[i]);
                    }

               }
          }
          if (pids[i] < 0) {
  8005d8:	0c054763          	bltz	a0,8006a6 <main+0x128>
     for (i = 0; i < TOTAL; i ++) {
  8005dc:	2405                	addw	s0,s0,1
  8005de:	0991                	add	s3,s3,4
  8005e0:	0911                	add	s2,s2,4
  8005e2:	ff5414e3          	bne	s0,s5,8005ca <main+0x4c>
               goto failed;
          }
     }
     cprintf("main: fork ok,now need to wait pids.\n");
  8005e6:	00000517          	auipc	a0,0x0
  8005ea:	46250513          	add	a0,a0,1122 # 800a48 <error_string+0xe0>
  8005ee:	ab5ff0ef          	jal	8000a2 <cprintf>

     for (i = 0; i < TOTAL; i ++) {
  8005f2:	00001417          	auipc	s0,0x1
  8005f6:	a2640413          	add	s0,s0,-1498 # 801018 <status>
  8005fa:	00001917          	auipc	s2,0x1
  8005fe:	a3290913          	add	s2,s2,-1486 # 80102c <status+0x14>
         status[i]=0;
         waitpid(pids[i],&status[i]);
  800602:	4088                	lw	a0,0(s1)
         status[i]=0;
  800604:	00042023          	sw	zero,0(s0)
         waitpid(pids[i],&status[i]);
  800608:	85a2                	mv	a1,s0
     for (i = 0; i < TOTAL; i ++) {
  80060a:	0411                	add	s0,s0,4
         waitpid(pids[i],&status[i]);
  80060c:	b47ff0ef          	jal	800152 <waitpid>
     for (i = 0; i < TOTAL; i ++) {
  800610:	0491                	add	s1,s1,4
  800612:	ff2418e3          	bne	s0,s2,800602 <main+0x84>
     }
     cprintf("main: wait pids over\n");
  800616:	00000517          	auipc	a0,0x0
  80061a:	45a50513          	add	a0,a0,1114 # 800a70 <error_string+0x108>
  80061e:	a85ff0ef          	jal	8000a2 <cprintf>
               kill(pids[i]);
          }
     }
     panic("FAIL: T.T\n");
     
}
  800622:	60e6                	ld	ra,88(sp)
  800624:	6446                	ld	s0,80(sp)
  800626:	64a6                	ld	s1,72(sp)
  800628:	6906                	ld	s2,64(sp)
  80062a:	79e2                	ld	s3,56(sp)
  80062c:	7a42                	ld	s4,48(sp)
  80062e:	7aa2                	ld	s5,40(sp)
  800630:	4501                	li	a0,0
  800632:	6125                	add	sp,sp,96
  800634:	8082                	ret
               acc[i] = 0;
  800636:	040a                	sll	s0,s0,0x2
  800638:	9a22                	add	s4,s4,s0
                    if(acc[i]==200000){
  80063a:	00031937          	lui	s2,0x31
                         set_good(goods[i]);
  80063e:	02040793          	add	a5,s0,32
                    if(acc[i]>4000000) {
  800642:	003d14b7          	lui	s1,0x3d1
               acc[i] = 0;
  800646:	000a2023          	sw	zero,0(s4)
                    if(acc[i]==200000){
  80064a:	d4090913          	add	s2,s2,-704 # 30d40 <_start-0x7cf2e0>
                         set_good(goods[i]);
  80064e:	00278433          	add	s0,a5,sp
                    if(acc[i]>4000000) {
  800652:	90048493          	add	s1,s1,-1792 # 3d0900 <_start-0x42f720>
     for (i = 0; i < TOTAL; i ++) {
  800656:	0c800713          	li	a4,200
          j = !j;
  80065a:	4792                	lw	a5,4(sp)
     for (i = 0; i != 200; ++ i)
  80065c:	377d                	addw	a4,a4,-1
          j = !j;
  80065e:	0017b793          	seqz	a5,a5
  800662:	c23e                	sw	a5,4(sp)
     for (i = 0; i != 200; ++ i)
  800664:	fb7d                	bnez	a4,80065a <main+0xdc>
                    ++ acc[i];
  800666:	000a2783          	lw	a5,0(s4)
  80066a:	0017871b          	addw	a4,a5,1
  80066e:	00ea2023          	sw	a4,0(s4)
                    if(acc[i]==200000){
  800672:	03270563          	beq	a4,s2,80069c <main+0x11e>
                    if(acc[i]>4000000) {
  800676:	000a2783          	lw	a5,0(s4)
  80067a:	fcf4fee3          	bgeu	s1,a5,800656 <main+0xd8>
                         cprintf("child pid %d, acc %d\n",getpid(),acc[i]);
  80067e:	ad9ff0ef          	jal	800156 <getpid>
  800682:	000a2603          	lw	a2,0(s4)
  800686:	85aa                	mv	a1,a0
  800688:	00000517          	auipc	a0,0x0
  80068c:	3a850513          	add	a0,a0,936 # 800a30 <error_string+0xc8>
  800690:	a13ff0ef          	jal	8000a2 <cprintf>
                         exit(acc[i]);
  800694:	000a2503          	lw	a0,0(s4)
  800698:	aa3ff0ef          	jal	80013a <exit>
                         set_good(goods[i]);
  80069c:	fe842503          	lw	a0,-24(s0)
  8006a0:	ab9ff0ef          	jal	800158 <set_good>
  8006a4:	bfc9                	j	800676 <main+0xf8>
  8006a6:	00001417          	auipc	s0,0x1
  8006aa:	96e40413          	add	s0,s0,-1682 # 801014 <pids+0x14>
          if (pids[i] > 0) {
  8006ae:	4088                	lw	a0,0(s1)
  8006b0:	00a05463          	blez	a0,8006b8 <main+0x13a>
               kill(pids[i]);
  8006b4:	aa1ff0ef          	jal	800154 <kill>
     for (i = 0; i < TOTAL; i ++) {
  8006b8:	0491                	add	s1,s1,4
  8006ba:	fe941ae3          	bne	s0,s1,8006ae <main+0x130>
     panic("FAIL: T.T\n");
  8006be:	00000617          	auipc	a2,0x0
  8006c2:	3ca60613          	add	a2,a2,970 # 800a88 <error_string+0x120>
  8006c6:	04600593          	li	a1,70
  8006ca:	00000517          	auipc	a0,0x0
  8006ce:	3ce50513          	add	a0,a0,974 # 800a98 <error_string+0x130>
  8006d2:	955ff0ef          	jal	800026 <__panic>
