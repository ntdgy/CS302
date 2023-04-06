
obj/__user_rr.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	136000ef          	jal	800156 <umain>
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
  80003a:	67a50513          	add	a0,a0,1658 # 8006b0 <main+0x136>
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
  80005a:	67a50513          	add	a0,a0,1658 # 8006d0 <main+0x156>
  80005e:	044000ef          	jal	8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0d2000ef          	jal	800136 <exit>

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
  800096:	13a000ef          	jal	8001d0 <vprintfmt>
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
  8000cc:	104000ef          	jal	8001d0 <vprintfmt>
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

0000000000800132 <sys_gettime>:
}

int
sys_gettime(void) {
    return syscall(SYS_gettime);
  800132:	4545                	li	a0,17
  800134:	b755                	j	8000d8 <syscall>

0000000000800136 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  800136:	1141                	add	sp,sp,-16
  800138:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  80013a:	fd7ff0ef          	jal	800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  80013e:	00000517          	auipc	a0,0x0
  800142:	59a50513          	add	a0,a0,1434 # 8006d8 <main+0x15e>
  800146:	f5dff0ef          	jal	8000a2 <cprintf>
    while (1);
  80014a:	a001                	j	80014a <exit+0x14>

000000000080014c <fork>:
}

int
fork(void) {
    return sys_fork();
  80014c:	b7e9                	j	800116 <sys_fork>

000000000080014e <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  80014e:	b7f1                	j	80011a <sys_wait>

0000000000800150 <kill>:
    sys_yield();
}

int
kill(int pid) {
    return sys_kill(pid);
  800150:	bfc9                	j	800122 <sys_kill>

0000000000800152 <getpid>:
}

int
getpid(void) {
    return sys_getpid();
  800152:	bfd9                	j	800128 <sys_getpid>

0000000000800154 <gettime_msec>:
}

unsigned int
gettime_msec(void) {
    return (unsigned int)sys_gettime();
  800154:	bff9                	j	800132 <sys_gettime>

0000000000800156 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800156:	1141                	add	sp,sp,-16
  800158:	e406                	sd	ra,8(sp)
    int ret = main();
  80015a:	420000ef          	jal	80057a <main>
    exit(ret);
  80015e:	fd9ff0ef          	jal	800136 <exit>

0000000000800162 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800162:	02069813          	sll	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800166:	7179                	add	sp,sp,-48
    unsigned mod = do_div(result, base);
  800168:	02085813          	srl	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80016c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  80016e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800172:	f022                	sd	s0,32(sp)
  800174:	ec26                	sd	s1,24(sp)
  800176:	e84a                	sd	s2,16(sp)
  800178:	f406                	sd	ra,40(sp)
  80017a:	e44e                	sd	s3,8(sp)
  80017c:	84aa                	mv	s1,a0
  80017e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800180:	fff7041b          	addw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800184:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800186:	03067f63          	bgeu	a2,a6,8001c4 <printnum+0x62>
  80018a:	89be                	mv	s3,a5
        while (-- width > 0)
  80018c:	4785                	li	a5,1
  80018e:	00e7d763          	bge	a5,a4,80019c <printnum+0x3a>
  800192:	347d                	addw	s0,s0,-1
            putch(padc, putdat);
  800194:	85ca                	mv	a1,s2
  800196:	854e                	mv	a0,s3
  800198:	9482                	jalr	s1
        while (-- width > 0)
  80019a:	fc65                	bnez	s0,800192 <printnum+0x30>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80019c:	1a02                	sll	s4,s4,0x20
  80019e:	020a5a13          	srl	s4,s4,0x20
  8001a2:	00000797          	auipc	a5,0x0
  8001a6:	54e78793          	add	a5,a5,1358 # 8006f0 <main+0x176>
  8001aa:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001ac:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001ae:	0007c503          	lbu	a0,0(a5)
}
  8001b2:	70a2                	ld	ra,40(sp)
  8001b4:	69a2                	ld	s3,8(sp)
  8001b6:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001b8:	85ca                	mv	a1,s2
  8001ba:	87a6                	mv	a5,s1
}
  8001bc:	6942                	ld	s2,16(sp)
  8001be:	64e2                	ld	s1,24(sp)
  8001c0:	6145                	add	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001c2:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001c4:	03065633          	divu	a2,a2,a6
  8001c8:	8722                	mv	a4,s0
  8001ca:	f99ff0ef          	jal	800162 <printnum>
  8001ce:	b7f9                	j	80019c <printnum+0x3a>

00000000008001d0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001d0:	7119                	add	sp,sp,-128
  8001d2:	f4a6                	sd	s1,104(sp)
  8001d4:	f0ca                	sd	s2,96(sp)
  8001d6:	ecce                	sd	s3,88(sp)
  8001d8:	e8d2                	sd	s4,80(sp)
  8001da:	e4d6                	sd	s5,72(sp)
  8001dc:	e0da                	sd	s6,64(sp)
  8001de:	f862                	sd	s8,48(sp)
  8001e0:	fc86                	sd	ra,120(sp)
  8001e2:	f8a2                	sd	s0,112(sp)
  8001e4:	fc5e                	sd	s7,56(sp)
  8001e6:	f466                	sd	s9,40(sp)
  8001e8:	f06a                	sd	s10,32(sp)
  8001ea:	ec6e                	sd	s11,24(sp)
  8001ec:	892a                	mv	s2,a0
  8001ee:	84ae                	mv	s1,a1
  8001f0:	8c32                	mv	s8,a2
  8001f2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001f4:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8001f8:	05500b13          	li	s6,85
  8001fc:	00000a97          	auipc	s5,0x0
  800200:	528a8a93          	add	s5,s5,1320 # 800724 <main+0x1aa>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800204:	000c4503          	lbu	a0,0(s8)
  800208:	001c0413          	add	s0,s8,1
  80020c:	01350a63          	beq	a0,s3,800220 <vprintfmt+0x50>
            if (ch == '\0') {
  800210:	cd0d                	beqz	a0,80024a <vprintfmt+0x7a>
            putch(ch, putdat);
  800212:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800214:	0405                	add	s0,s0,1
            putch(ch, putdat);
  800216:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800218:	fff44503          	lbu	a0,-1(s0)
  80021c:	ff351ae3          	bne	a0,s3,800210 <vprintfmt+0x40>
        char padc = ' ';
  800220:	02000d93          	li	s11,32
        lflag = altflag = 0;
  800224:	4b81                	li	s7,0
  800226:	4601                	li	a2,0
        width = precision = -1;
  800228:	5d7d                	li	s10,-1
  80022a:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
  80022c:	00044683          	lbu	a3,0(s0)
  800230:	00140c13          	add	s8,s0,1
  800234:	fdd6859b          	addw	a1,a3,-35
  800238:	0ff5f593          	zext.b	a1,a1
  80023c:	02bb6663          	bltu	s6,a1,800268 <vprintfmt+0x98>
  800240:	058a                	sll	a1,a1,0x2
  800242:	95d6                	add	a1,a1,s5
  800244:	4198                	lw	a4,0(a1)
  800246:	9756                	add	a4,a4,s5
  800248:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80024a:	70e6                	ld	ra,120(sp)
  80024c:	7446                	ld	s0,112(sp)
  80024e:	74a6                	ld	s1,104(sp)
  800250:	7906                	ld	s2,96(sp)
  800252:	69e6                	ld	s3,88(sp)
  800254:	6a46                	ld	s4,80(sp)
  800256:	6aa6                	ld	s5,72(sp)
  800258:	6b06                	ld	s6,64(sp)
  80025a:	7be2                	ld	s7,56(sp)
  80025c:	7c42                	ld	s8,48(sp)
  80025e:	7ca2                	ld	s9,40(sp)
  800260:	7d02                	ld	s10,32(sp)
  800262:	6de2                	ld	s11,24(sp)
  800264:	6109                	add	sp,sp,128
  800266:	8082                	ret
            putch('%', putdat);
  800268:	85a6                	mv	a1,s1
  80026a:	02500513          	li	a0,37
  80026e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800270:	fff44703          	lbu	a4,-1(s0)
  800274:	02500793          	li	a5,37
  800278:	8c22                	mv	s8,s0
  80027a:	f8f705e3          	beq	a4,a5,800204 <vprintfmt+0x34>
  80027e:	02500713          	li	a4,37
  800282:	ffec4783          	lbu	a5,-2(s8)
  800286:	1c7d                	add	s8,s8,-1
  800288:	fee79de3          	bne	a5,a4,800282 <vprintfmt+0xb2>
  80028c:	bfa5                	j	800204 <vprintfmt+0x34>
                ch = *fmt;
  80028e:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
  800292:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
  800294:	fd068d1b          	addw	s10,a3,-48
                if (ch < '0' || ch > '9') {
  800298:	fd07859b          	addw	a1,a5,-48
                ch = *fmt;
  80029c:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
  8002a0:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
  8002a2:	02b76563          	bltu	a4,a1,8002cc <vprintfmt+0xfc>
  8002a6:	4525                	li	a0,9
                ch = *fmt;
  8002a8:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
  8002ac:	002d171b          	sllw	a4,s10,0x2
  8002b0:	01a7073b          	addw	a4,a4,s10
  8002b4:	0017171b          	sllw	a4,a4,0x1
  8002b8:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
  8002ba:	fd07859b          	addw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
  8002be:	0405                	add	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002c0:	fd070d1b          	addw	s10,a4,-48
                ch = *fmt;
  8002c4:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
  8002c8:	feb570e3          	bgeu	a0,a1,8002a8 <vprintfmt+0xd8>
            if (width < 0)
  8002cc:	f60cd0e3          	bgez	s9,80022c <vprintfmt+0x5c>
                width = precision, precision = -1;
  8002d0:	8cea                	mv	s9,s10
  8002d2:	5d7d                	li	s10,-1
  8002d4:	bfa1                	j	80022c <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
  8002d6:	8db6                	mv	s11,a3
  8002d8:	8462                	mv	s0,s8
  8002da:	bf89                	j	80022c <vprintfmt+0x5c>
  8002dc:	8462                	mv	s0,s8
            altflag = 1;
  8002de:	4b85                	li	s7,1
            goto reswitch;
  8002e0:	b7b1                	j	80022c <vprintfmt+0x5c>
    if (lflag >= 2) {
  8002e2:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8002e4:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  8002e8:	00c7c463          	blt	a5,a2,8002f0 <vprintfmt+0x120>
    else if (lflag) {
  8002ec:	1a060263          	beqz	a2,800490 <vprintfmt+0x2c0>
        return va_arg(*ap, unsigned long);
  8002f0:	000a3603          	ld	a2,0(s4)
  8002f4:	46c1                	li	a3,16
  8002f6:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
  8002f8:	000d879b          	sext.w	a5,s11
  8002fc:	8766                	mv	a4,s9
  8002fe:	85a6                	mv	a1,s1
  800300:	854a                	mv	a0,s2
  800302:	e61ff0ef          	jal	800162 <printnum>
            break;
  800306:	bdfd                	j	800204 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
  800308:	000a2503          	lw	a0,0(s4)
  80030c:	85a6                	mv	a1,s1
  80030e:	0a21                	add	s4,s4,8
  800310:	9902                	jalr	s2
            break;
  800312:	bdcd                	j	800204 <vprintfmt+0x34>
    if (lflag >= 2) {
  800314:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800316:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  80031a:	00c7c463          	blt	a5,a2,800322 <vprintfmt+0x152>
    else if (lflag) {
  80031e:	16060463          	beqz	a2,800486 <vprintfmt+0x2b6>
        return va_arg(*ap, unsigned long);
  800322:	000a3603          	ld	a2,0(s4)
  800326:	46a9                	li	a3,10
  800328:	8a3a                	mv	s4,a4
  80032a:	b7f9                	j	8002f8 <vprintfmt+0x128>
            putch('0', putdat);
  80032c:	03000513          	li	a0,48
  800330:	85a6                	mv	a1,s1
  800332:	9902                	jalr	s2
            putch('x', putdat);
  800334:	85a6                	mv	a1,s1
  800336:	07800513          	li	a0,120
  80033a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80033c:	0a21                	add	s4,s4,8
            goto number;
  80033e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800340:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800344:	bf55                	j	8002f8 <vprintfmt+0x128>
            putch(ch, putdat);
  800346:	85a6                	mv	a1,s1
  800348:	02500513          	li	a0,37
  80034c:	9902                	jalr	s2
            break;
  80034e:	bd5d                	j	800204 <vprintfmt+0x34>
            precision = va_arg(ap, int);
  800350:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800354:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
  800356:	0a21                	add	s4,s4,8
            goto process_precision;
  800358:	bf95                	j	8002cc <vprintfmt+0xfc>
    if (lflag >= 2) {
  80035a:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80035c:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  800360:	00c7c463          	blt	a5,a2,800368 <vprintfmt+0x198>
    else if (lflag) {
  800364:	10060c63          	beqz	a2,80047c <vprintfmt+0x2ac>
        return va_arg(*ap, unsigned long);
  800368:	000a3603          	ld	a2,0(s4)
  80036c:	46a1                	li	a3,8
  80036e:	8a3a                	mv	s4,a4
  800370:	b761                	j	8002f8 <vprintfmt+0x128>
            if (width < 0)
  800372:	fffcc793          	not	a5,s9
  800376:	97fd                	sra	a5,a5,0x3f
  800378:	00fcf7b3          	and	a5,s9,a5
  80037c:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800380:	8462                	mv	s0,s8
            goto reswitch;
  800382:	b56d                	j	80022c <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
  800384:	000a3403          	ld	s0,0(s4)
  800388:	008a0793          	add	a5,s4,8
  80038c:	e43e                	sd	a5,8(sp)
  80038e:	12040163          	beqz	s0,8004b0 <vprintfmt+0x2e0>
            if (width > 0 && padc != '-') {
  800392:	0d905963          	blez	s9,800464 <vprintfmt+0x294>
  800396:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80039a:	00140a13          	add	s4,s0,1
            if (width > 0 && padc != '-') {
  80039e:	12fd9863          	bne	s11,a5,8004ce <vprintfmt+0x2fe>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003a2:	00044783          	lbu	a5,0(s0)
  8003a6:	0007851b          	sext.w	a0,a5
  8003aa:	cb9d                	beqz	a5,8003e0 <vprintfmt+0x210>
  8003ac:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003ae:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003b2:	000d4563          	bltz	s10,8003bc <vprintfmt+0x1ec>
  8003b6:	3d7d                	addw	s10,s10,-1
  8003b8:	028d0263          	beq	s10,s0,8003dc <vprintfmt+0x20c>
                    putch('?', putdat);
  8003bc:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003be:	0c0b8e63          	beqz	s7,80049a <vprintfmt+0x2ca>
  8003c2:	3781                	addw	a5,a5,-32
  8003c4:	0cfdfb63          	bgeu	s11,a5,80049a <vprintfmt+0x2ca>
                    putch('?', putdat);
  8003c8:	03f00513          	li	a0,63
  8003cc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003ce:	000a4783          	lbu	a5,0(s4)
  8003d2:	3cfd                	addw	s9,s9,-1
  8003d4:	0a05                	add	s4,s4,1
  8003d6:	0007851b          	sext.w	a0,a5
  8003da:	ffe1                	bnez	a5,8003b2 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
  8003dc:	01905963          	blez	s9,8003ee <vprintfmt+0x21e>
  8003e0:	3cfd                	addw	s9,s9,-1
                putch(' ', putdat);
  8003e2:	85a6                	mv	a1,s1
  8003e4:	02000513          	li	a0,32
  8003e8:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003ea:	fe0c9be3          	bnez	s9,8003e0 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003ee:	6a22                	ld	s4,8(sp)
  8003f0:	bd11                	j	800204 <vprintfmt+0x34>
    if (lflag >= 2) {
  8003f2:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003f4:	008a0b93          	add	s7,s4,8
    if (lflag >= 2) {
  8003f8:	00c7c363          	blt	a5,a2,8003fe <vprintfmt+0x22e>
    else if (lflag) {
  8003fc:	ce2d                	beqz	a2,800476 <vprintfmt+0x2a6>
        return va_arg(*ap, long);
  8003fe:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800402:	08044e63          	bltz	s0,80049e <vprintfmt+0x2ce>
            num = getint(&ap, lflag);
  800406:	8622                	mv	a2,s0
  800408:	8a5e                	mv	s4,s7
  80040a:	46a9                	li	a3,10
  80040c:	b5f5                	j	8002f8 <vprintfmt+0x128>
            if (err < 0) {
  80040e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800412:	4661                	li	a2,24
            if (err < 0) {
  800414:	41f7d71b          	sraw	a4,a5,0x1f
  800418:	8fb9                	xor	a5,a5,a4
  80041a:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80041e:	02d64663          	blt	a2,a3,80044a <vprintfmt+0x27a>
  800422:	00369713          	sll	a4,a3,0x3
  800426:	00000797          	auipc	a5,0x0
  80042a:	51a78793          	add	a5,a5,1306 # 800940 <error_string>
  80042e:	97ba                	add	a5,a5,a4
  800430:	639c                	ld	a5,0(a5)
  800432:	cf81                	beqz	a5,80044a <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
  800434:	86be                	mv	a3,a5
  800436:	00000617          	auipc	a2,0x0
  80043a:	2ea60613          	add	a2,a2,746 # 800720 <main+0x1a6>
  80043e:	85a6                	mv	a1,s1
  800440:	854a                	mv	a0,s2
  800442:	0ea000ef          	jal	80052c <printfmt>
            err = va_arg(ap, int);
  800446:	0a21                	add	s4,s4,8
  800448:	bb75                	j	800204 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
  80044a:	00000617          	auipc	a2,0x0
  80044e:	2c660613          	add	a2,a2,710 # 800710 <main+0x196>
  800452:	85a6                	mv	a1,s1
  800454:	854a                	mv	a0,s2
  800456:	0d6000ef          	jal	80052c <printfmt>
            err = va_arg(ap, int);
  80045a:	0a21                	add	s4,s4,8
  80045c:	b365                	j	800204 <vprintfmt+0x34>
            lflag ++;
  80045e:	2605                	addw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
  800460:	8462                	mv	s0,s8
            goto reswitch;
  800462:	b3e9                	j	80022c <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800464:	00044783          	lbu	a5,0(s0)
  800468:	00140a13          	add	s4,s0,1
  80046c:	0007851b          	sext.w	a0,a5
  800470:	ff95                	bnez	a5,8003ac <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  800472:	6a22                	ld	s4,8(sp)
  800474:	bb41                	j	800204 <vprintfmt+0x34>
        return va_arg(*ap, int);
  800476:	000a2403          	lw	s0,0(s4)
  80047a:	b761                	j	800402 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
  80047c:	000a6603          	lwu	a2,0(s4)
  800480:	46a1                	li	a3,8
  800482:	8a3a                	mv	s4,a4
  800484:	bd95                	j	8002f8 <vprintfmt+0x128>
  800486:	000a6603          	lwu	a2,0(s4)
  80048a:	46a9                	li	a3,10
  80048c:	8a3a                	mv	s4,a4
  80048e:	b5ad                	j	8002f8 <vprintfmt+0x128>
  800490:	000a6603          	lwu	a2,0(s4)
  800494:	46c1                	li	a3,16
  800496:	8a3a                	mv	s4,a4
  800498:	b585                	j	8002f8 <vprintfmt+0x128>
                    putch(ch, putdat);
  80049a:	9902                	jalr	s2
  80049c:	bf0d                	j	8003ce <vprintfmt+0x1fe>
                putch('-', putdat);
  80049e:	85a6                	mv	a1,s1
  8004a0:	02d00513          	li	a0,45
  8004a4:	9902                	jalr	s2
                num = -(long long)num;
  8004a6:	8a5e                	mv	s4,s7
  8004a8:	40800633          	neg	a2,s0
  8004ac:	46a9                	li	a3,10
  8004ae:	b5a9                	j	8002f8 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
  8004b0:	01905663          	blez	s9,8004bc <vprintfmt+0x2ec>
  8004b4:	02d00793          	li	a5,45
  8004b8:	04fd9263          	bne	s11,a5,8004fc <vprintfmt+0x32c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004bc:	00000a17          	auipc	s4,0x0
  8004c0:	24da0a13          	add	s4,s4,589 # 800709 <main+0x18f>
  8004c4:	02800513          	li	a0,40
  8004c8:	02800793          	li	a5,40
  8004cc:	b5c5                	j	8003ac <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004ce:	85ea                	mv	a1,s10
  8004d0:	8522                	mv	a0,s0
  8004d2:	07a000ef          	jal	80054c <strnlen>
  8004d6:	40ac8cbb          	subw	s9,s9,a0
  8004da:	01905963          	blez	s9,8004ec <vprintfmt+0x31c>
                    putch(padc, putdat);
  8004de:	2d81                	sext.w	s11,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004e0:	3cfd                	addw	s9,s9,-1
                    putch(padc, putdat);
  8004e2:	85a6                	mv	a1,s1
  8004e4:	856e                	mv	a0,s11
  8004e6:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004e8:	fe0c9ce3          	bnez	s9,8004e0 <vprintfmt+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004ec:	00044783          	lbu	a5,0(s0)
  8004f0:	0007851b          	sext.w	a0,a5
  8004f4:	ea079ce3          	bnez	a5,8003ac <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  8004f8:	6a22                	ld	s4,8(sp)
  8004fa:	b329                	j	800204 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004fc:	85ea                	mv	a1,s10
  8004fe:	00000517          	auipc	a0,0x0
  800502:	20a50513          	add	a0,a0,522 # 800708 <main+0x18e>
  800506:	046000ef          	jal	80054c <strnlen>
  80050a:	40ac8cbb          	subw	s9,s9,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80050e:	00000a17          	auipc	s4,0x0
  800512:	1fba0a13          	add	s4,s4,507 # 800709 <main+0x18f>
                p = "(null)";
  800516:	00000417          	auipc	s0,0x0
  80051a:	1f240413          	add	s0,s0,498 # 800708 <main+0x18e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80051e:	02800513          	li	a0,40
  800522:	02800793          	li	a5,40
                for (width -= strnlen(p, precision); width > 0; width --) {
  800526:	fb904ce3          	bgtz	s9,8004de <vprintfmt+0x30e>
  80052a:	b549                	j	8003ac <vprintfmt+0x1dc>

000000000080052c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80052c:	715d                	add	sp,sp,-80
    va_start(ap, fmt);
  80052e:	02810313          	add	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800532:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800534:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800536:	ec06                	sd	ra,24(sp)
  800538:	f83a                	sd	a4,48(sp)
  80053a:	fc3e                	sd	a5,56(sp)
  80053c:	e0c2                	sd	a6,64(sp)
  80053e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800540:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800542:	c8fff0ef          	jal	8001d0 <vprintfmt>
}
  800546:	60e2                	ld	ra,24(sp)
  800548:	6161                	add	sp,sp,80
  80054a:	8082                	ret

000000000080054c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  80054c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  80054e:	e589                	bnez	a1,800558 <strnlen+0xc>
  800550:	a811                	j	800564 <strnlen+0x18>
        cnt ++;
  800552:	0785                	add	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800554:	00f58863          	beq	a1,a5,800564 <strnlen+0x18>
  800558:	00f50733          	add	a4,a0,a5
  80055c:	00074703          	lbu	a4,0(a4)
  800560:	fb6d                	bnez	a4,800552 <strnlen+0x6>
  800562:	85be                	mv	a1,a5
    }
    return cnt;
}
  800564:	852e                	mv	a0,a1
  800566:	8082                	ret

0000000000800568 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
  800568:	ca01                	beqz	a2,800578 <memset+0x10>
  80056a:	962a                	add	a2,a2,a0
    char *p = s;
  80056c:	87aa                	mv	a5,a0
        *p ++ = c;
  80056e:	0785                	add	a5,a5,1
  800570:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
  800574:	fec79de3          	bne	a5,a2,80056e <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800578:	8082                	ret

000000000080057a <main>:
          j = !j;
     }
}

int
main(void) {
  80057a:	715d                	add	sp,sp,-80
     int i,time;
     memset(pids, 0, sizeof(pids));
  80057c:	00001517          	auipc	a0,0x1
  800580:	a8450513          	add	a0,a0,-1404 # 801000 <pids>
main(void) {
  800584:	fc26                	sd	s1,56(sp)
  800586:	ec56                	sd	s5,24(sp)
  800588:	84aa                	mv	s1,a0
     memset(pids, 0, sizeof(pids));
  80058a:	4651                	li	a2,20
  80058c:	4581                	li	a1,0
  80058e:	00001a97          	auipc	s5,0x1
  800592:	aa2a8a93          	add	s5,s5,-1374 # 801030 <acc>
main(void) {
  800596:	e0a2                	sd	s0,64(sp)
  800598:	f84a                	sd	s2,48(sp)
  80059a:	f44e                	sd	s3,40(sp)
  80059c:	f052                	sd	s4,32(sp)
  80059e:	e486                	sd	ra,72(sp)
  8005a0:	89d6                	mv	s3,s5
     memset(pids, 0, sizeof(pids));
  8005a2:	fc7ff0ef          	jal	800568 <memset>
  8005a6:	8926                	mv	s2,s1

     for (i = 0; i < TOTAL; i ++) {
  8005a8:	4401                	li	s0,0
  8005aa:	4a15                	li	s4,5
          acc[i]=0;
  8005ac:	0009a023          	sw	zero,0(s3)
          if ((pids[i] = fork()) == 0) {
  8005b0:	b9dff0ef          	jal	80014c <fork>
  8005b4:	00a92023          	sw	a0,0(s2)
  8005b8:	c125                	beqz	a0,800618 <main+0x9e>
                            exit(acc[i]);
                        }
                    }
               }
          }
          if (pids[i] < 0) {
  8005ba:	0c054363          	bltz	a0,800680 <main+0x106>
     for (i = 0; i < TOTAL; i ++) {
  8005be:	2405                	addw	s0,s0,1
  8005c0:	0991                	add	s3,s3,4
  8005c2:	0911                	add	s2,s2,4
  8005c4:	ff4414e3          	bne	s0,s4,8005ac <main+0x32>
               goto failed;
          }
     }

     cprintf("main: fork ok,now need to wait pids.\n");
  8005c8:	00000517          	auipc	a0,0x0
  8005cc:	46050513          	add	a0,a0,1120 # 800a28 <error_string+0xe8>
  8005d0:	ad3ff0ef          	jal	8000a2 <cprintf>

     for (i = 0; i < TOTAL; i ++) {
  8005d4:	00001417          	auipc	s0,0x1
  8005d8:	a4440413          	add	s0,s0,-1468 # 801018 <status>
  8005dc:	00001917          	auipc	s2,0x1
  8005e0:	a5090913          	add	s2,s2,-1456 # 80102c <status+0x14>
         status[i]=0;
         waitpid(pids[i],&status[i]);
  8005e4:	4088                	lw	a0,0(s1)
         status[i]=0;
  8005e6:	00042023          	sw	zero,0(s0)
         waitpid(pids[i],&status[i]);
  8005ea:	85a2                	mv	a1,s0
     for (i = 0; i < TOTAL; i ++) {
  8005ec:	0411                	add	s0,s0,4
         waitpid(pids[i],&status[i]);
  8005ee:	b61ff0ef          	jal	80014e <waitpid>
     for (i = 0; i < TOTAL; i ++) {
  8005f2:	0491                	add	s1,s1,4
  8005f4:	ff2418e3          	bne	s0,s2,8005e4 <main+0x6a>
       
     }
     cprintf("main: wait pids over\n");
  8005f8:	00000517          	auipc	a0,0x0
  8005fc:	45850513          	add	a0,a0,1112 # 800a50 <error_string+0x110>
  800600:	aa3ff0ef          	jal	8000a2 <cprintf>
          if (pids[i] > 0) {
               kill(pids[i]);
          }
     }
     panic("FAIL: T.T\n");
}
  800604:	60a6                	ld	ra,72(sp)
  800606:	6406                	ld	s0,64(sp)
  800608:	74e2                	ld	s1,56(sp)
  80060a:	7942                	ld	s2,48(sp)
  80060c:	79a2                	ld	s3,40(sp)
  80060e:	7a02                	ld	s4,32(sp)
  800610:	6ae2                	ld	s5,24(sp)
  800612:	4501                	li	a0,0
  800614:	6161                	add	sp,sp,80
  800616:	8082                	ret
               acc[i] = 0;
  800618:	040a                	sll	s0,s0,0x2
  80061a:	9aa2                	add	s5,s5,s0
                        if((time=gettime_msec())>MAX_TIME) {
  80061c:	6909                	lui	s2,0x2
                    if(acc[i]%4000==0) {
  80061e:	6405                	lui	s0,0x1
               acc[i] = 0;
  800620:	000aa023          	sw	zero,0(s5)
                    if(acc[i]%4000==0) {
  800624:	fa04041b          	addw	s0,s0,-96 # fa0 <_start-0x7ff080>
                        if((time=gettime_msec())>MAX_TIME) {
  800628:	71090913          	add	s2,s2,1808 # 2710 <_start-0x7fd910>
  80062c:	000aa683          	lw	a3,0(s5)
  800630:	2685                	addw	a3,a3,1
     for (i = 0; i != 200; ++ i)
  800632:	0c800713          	li	a4,200
          j = !j;
  800636:	47b2                	lw	a5,12(sp)
     for (i = 0; i != 200; ++ i)
  800638:	377d                	addw	a4,a4,-1
          j = !j;
  80063a:	0017b793          	seqz	a5,a5
  80063e:	c63e                	sw	a5,12(sp)
     for (i = 0; i != 200; ++ i)
  800640:	fb7d                	bnez	a4,800636 <main+0xbc>
                    if(acc[i]%4000==0) {
  800642:	0286f7bb          	remuw	a5,a3,s0
  800646:	0016871b          	addw	a4,a3,1
  80064a:	c399                	beqz	a5,800650 <main+0xd6>
  80064c:	86ba                	mv	a3,a4
  80064e:	b7d5                	j	800632 <main+0xb8>
  800650:	00daa023          	sw	a3,0(s5)
                        if((time=gettime_msec())>MAX_TIME) {
  800654:	b01ff0ef          	jal	800154 <gettime_msec>
  800658:	0005049b          	sext.w	s1,a0
  80065c:	fc9958e3          	bge	s2,s1,80062c <main+0xb2>
                            cprintf("child pid %d, acc %d, time %d\n",getpid(),acc[i],time);
  800660:	af3ff0ef          	jal	800152 <getpid>
  800664:	000aa603          	lw	a2,0(s5)
  800668:	85aa                	mv	a1,a0
  80066a:	86a6                	mv	a3,s1
  80066c:	00000517          	auipc	a0,0x0
  800670:	39c50513          	add	a0,a0,924 # 800a08 <error_string+0xc8>
  800674:	a2fff0ef          	jal	8000a2 <cprintf>
                            exit(acc[i]);
  800678:	000aa503          	lw	a0,0(s5)
  80067c:	abbff0ef          	jal	800136 <exit>
  800680:	00001417          	auipc	s0,0x1
  800684:	99440413          	add	s0,s0,-1644 # 801014 <pids+0x14>
          if (pids[i] > 0) {
  800688:	4088                	lw	a0,0(s1)
  80068a:	00a05463          	blez	a0,800692 <main+0x118>
               kill(pids[i]);
  80068e:	ac3ff0ef          	jal	800150 <kill>
     for (i = 0; i < TOTAL; i ++) {
  800692:	0491                	add	s1,s1,4
  800694:	fe849ae3          	bne	s1,s0,800688 <main+0x10e>
     panic("FAIL: T.T\n");
  800698:	00000617          	auipc	a2,0x0
  80069c:	3d060613          	add	a2,a2,976 # 800a68 <error_string+0x128>
  8006a0:	04100593          	li	a1,65
  8006a4:	00000517          	auipc	a0,0x0
  8006a8:	3d450513          	add	a0,a0,980 # 800a78 <error_string+0x138>
  8006ac:	97bff0ef          	jal	800026 <__panic>
