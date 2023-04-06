
obj/__user_hello.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0b6000ef          	jal	8000d6 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	add	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	08a000ef          	jal	8000b8 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	add	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	add	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	add	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	add	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	add	a1,sp,4
  800058:	869a                	mv	a3,t1
  80005a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80005c:	ec06                	sd	ra,24(sp)
  80005e:	e0ba                	sd	a4,64(sp)
  800060:	e4be                	sd	a5,72(sp)
  800062:	e8c2                	sd	a6,80(sp)
  800064:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800066:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800068:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80006a:	0e6000ef          	jal	800150 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	add	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	add	sp,sp,-144
  800078:	e42a                	sd	a0,8(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	0108                	add	a0,sp,128
syscall(int64_t num, ...) {
  80007c:	ecae                	sd	a1,88(sp)
  80007e:	f0b2                	sd	a2,96(sp)
  800080:	f4b6                	sd	a3,104(sp)
  800082:	f8ba                	sd	a4,112(sp)
  800084:	fcbe                	sd	a5,120(sp)
  800086:	e142                	sd	a6,128(sp)
  800088:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008a:	f02a                	sd	a0,32(sp)
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	e0ba                	sd	a4,64(sp)
  800094:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);
    asm volatile (
  800096:	4522                	lw	a0,8(sp)
  800098:	55a2                	lw	a1,40(sp)
  80009a:	5642                	lw	a2,48(sp)
  80009c:	56e2                	lw	a3,56(sp)
  80009e:	4706                	lw	a4,64(sp)
  8000a0:	47a6                	lw	a5,72(sp)
  8000a2:	00000073          	ecall
  8000a6:	ce2a                	sw	a0,28(sp)
          "m" (a[3]),
          "m" (a[4])
        : "memory"
      );
    return ret;
}
  8000a8:	4572                	lw	a0,28(sp)
  8000aa:	6149                	add	sp,sp,144
  8000ac:	8082                	ret

00000000008000ae <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000ae:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b0:	4505                	li	a0,1
  8000b2:	b7d1                	j	800076 <syscall>

00000000008000b4 <sys_getpid>:
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
  8000b4:	4549                	li	a0,18
  8000b6:	b7c1                	j	800076 <syscall>

00000000008000b8 <sys_putc>:
}

int
sys_putc(int64_t c) {
  8000b8:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000ba:	4579                	li	a0,30
  8000bc:	bf6d                	j	800076 <syscall>

00000000008000be <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000be:	1141                	add	sp,sp,-16
  8000c0:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  8000c2:	fedff0ef          	jal	8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000c6:	00000517          	auipc	a0,0x0
  8000ca:	45a50513          	add	a0,a0,1114 # 800520 <main+0x38>
  8000ce:	f73ff0ef          	jal	800040 <cprintf>
    while (1);
  8000d2:	a001                	j	8000d2 <exit+0x14>

00000000008000d4 <getpid>:
    return sys_kill(pid);
}

int
getpid(void) {
    return sys_getpid();
  8000d4:	b7c5                	j	8000b4 <sys_getpid>

00000000008000d6 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000d6:	1141                	add	sp,sp,-16
  8000d8:	e406                	sd	ra,8(sp)
    int ret = main();
  8000da:	40e000ef          	jal	8004e8 <main>
    exit(ret);
  8000de:	fe1ff0ef          	jal	8000be <exit>

00000000008000e2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000e2:	02069813          	sll	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000e6:	7179                	add	sp,sp,-48
    unsigned mod = do_div(result, base);
  8000e8:	02085813          	srl	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000ec:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  8000ee:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  8000f2:	f022                	sd	s0,32(sp)
  8000f4:	ec26                	sd	s1,24(sp)
  8000f6:	e84a                	sd	s2,16(sp)
  8000f8:	f406                	sd	ra,40(sp)
  8000fa:	e44e                	sd	s3,8(sp)
  8000fc:	84aa                	mv	s1,a0
  8000fe:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800100:	fff7041b          	addw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800104:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800106:	03067f63          	bgeu	a2,a6,800144 <printnum+0x62>
  80010a:	89be                	mv	s3,a5
        while (-- width > 0)
  80010c:	4785                	li	a5,1
  80010e:	00e7d763          	bge	a5,a4,80011c <printnum+0x3a>
  800112:	347d                	addw	s0,s0,-1
            putch(padc, putdat);
  800114:	85ca                	mv	a1,s2
  800116:	854e                	mv	a0,s3
  800118:	9482                	jalr	s1
        while (-- width > 0)
  80011a:	fc65                	bnez	s0,800112 <printnum+0x30>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80011c:	1a02                	sll	s4,s4,0x20
  80011e:	020a5a13          	srl	s4,s4,0x20
  800122:	00000797          	auipc	a5,0x0
  800126:	41678793          	add	a5,a5,1046 # 800538 <main+0x50>
  80012a:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80012c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  80012e:	0007c503          	lbu	a0,0(a5)
}
  800132:	70a2                	ld	ra,40(sp)
  800134:	69a2                	ld	s3,8(sp)
  800136:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800138:	85ca                	mv	a1,s2
  80013a:	87a6                	mv	a5,s1
}
  80013c:	6942                	ld	s2,16(sp)
  80013e:	64e2                	ld	s1,24(sp)
  800140:	6145                	add	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  800142:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  800144:	03065633          	divu	a2,a2,a6
  800148:	8722                	mv	a4,s0
  80014a:	f99ff0ef          	jal	8000e2 <printnum>
  80014e:	b7f9                	j	80011c <printnum+0x3a>

0000000000800150 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800150:	7119                	add	sp,sp,-128
  800152:	f4a6                	sd	s1,104(sp)
  800154:	f0ca                	sd	s2,96(sp)
  800156:	ecce                	sd	s3,88(sp)
  800158:	e8d2                	sd	s4,80(sp)
  80015a:	e4d6                	sd	s5,72(sp)
  80015c:	e0da                	sd	s6,64(sp)
  80015e:	f862                	sd	s8,48(sp)
  800160:	fc86                	sd	ra,120(sp)
  800162:	f8a2                	sd	s0,112(sp)
  800164:	fc5e                	sd	s7,56(sp)
  800166:	f466                	sd	s9,40(sp)
  800168:	f06a                	sd	s10,32(sp)
  80016a:	ec6e                	sd	s11,24(sp)
  80016c:	892a                	mv	s2,a0
  80016e:	84ae                	mv	s1,a1
  800170:	8c32                	mv	s8,a2
  800172:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800174:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800178:	05500b13          	li	s6,85
  80017c:	00000a97          	auipc	s5,0x0
  800180:	3f0a8a93          	add	s5,s5,1008 # 80056c <main+0x84>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800184:	000c4503          	lbu	a0,0(s8)
  800188:	001c0413          	add	s0,s8,1
  80018c:	01350a63          	beq	a0,s3,8001a0 <vprintfmt+0x50>
            if (ch == '\0') {
  800190:	cd0d                	beqz	a0,8001ca <vprintfmt+0x7a>
            putch(ch, putdat);
  800192:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800194:	0405                	add	s0,s0,1
            putch(ch, putdat);
  800196:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800198:	fff44503          	lbu	a0,-1(s0)
  80019c:	ff351ae3          	bne	a0,s3,800190 <vprintfmt+0x40>
        char padc = ' ';
  8001a0:	02000d93          	li	s11,32
        lflag = altflag = 0;
  8001a4:	4b81                	li	s7,0
  8001a6:	4601                	li	a2,0
        width = precision = -1;
  8001a8:	5d7d                	li	s10,-1
  8001aa:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
  8001ac:	00044683          	lbu	a3,0(s0)
  8001b0:	00140c13          	add	s8,s0,1
  8001b4:	fdd6859b          	addw	a1,a3,-35
  8001b8:	0ff5f593          	zext.b	a1,a1
  8001bc:	02bb6663          	bltu	s6,a1,8001e8 <vprintfmt+0x98>
  8001c0:	058a                	sll	a1,a1,0x2
  8001c2:	95d6                	add	a1,a1,s5
  8001c4:	4198                	lw	a4,0(a1)
  8001c6:	9756                	add	a4,a4,s5
  8001c8:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001ca:	70e6                	ld	ra,120(sp)
  8001cc:	7446                	ld	s0,112(sp)
  8001ce:	74a6                	ld	s1,104(sp)
  8001d0:	7906                	ld	s2,96(sp)
  8001d2:	69e6                	ld	s3,88(sp)
  8001d4:	6a46                	ld	s4,80(sp)
  8001d6:	6aa6                	ld	s5,72(sp)
  8001d8:	6b06                	ld	s6,64(sp)
  8001da:	7be2                	ld	s7,56(sp)
  8001dc:	7c42                	ld	s8,48(sp)
  8001de:	7ca2                	ld	s9,40(sp)
  8001e0:	7d02                	ld	s10,32(sp)
  8001e2:	6de2                	ld	s11,24(sp)
  8001e4:	6109                	add	sp,sp,128
  8001e6:	8082                	ret
            putch('%', putdat);
  8001e8:	85a6                	mv	a1,s1
  8001ea:	02500513          	li	a0,37
  8001ee:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  8001f0:	fff44703          	lbu	a4,-1(s0)
  8001f4:	02500793          	li	a5,37
  8001f8:	8c22                	mv	s8,s0
  8001fa:	f8f705e3          	beq	a4,a5,800184 <vprintfmt+0x34>
  8001fe:	02500713          	li	a4,37
  800202:	ffec4783          	lbu	a5,-2(s8)
  800206:	1c7d                	add	s8,s8,-1
  800208:	fee79de3          	bne	a5,a4,800202 <vprintfmt+0xb2>
  80020c:	bfa5                	j	800184 <vprintfmt+0x34>
                ch = *fmt;
  80020e:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
  800212:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
  800214:	fd068d1b          	addw	s10,a3,-48
                if (ch < '0' || ch > '9') {
  800218:	fd07859b          	addw	a1,a5,-48
                ch = *fmt;
  80021c:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800220:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
  800222:	02b76563          	bltu	a4,a1,80024c <vprintfmt+0xfc>
  800226:	4525                	li	a0,9
                ch = *fmt;
  800228:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
  80022c:	002d171b          	sllw	a4,s10,0x2
  800230:	01a7073b          	addw	a4,a4,s10
  800234:	0017171b          	sllw	a4,a4,0x1
  800238:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
  80023a:	fd07859b          	addw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
  80023e:	0405                	add	s0,s0,1
                precision = precision * 10 + ch - '0';
  800240:	fd070d1b          	addw	s10,a4,-48
                ch = *fmt;
  800244:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
  800248:	feb570e3          	bgeu	a0,a1,800228 <vprintfmt+0xd8>
            if (width < 0)
  80024c:	f60cd0e3          	bgez	s9,8001ac <vprintfmt+0x5c>
                width = precision, precision = -1;
  800250:	8cea                	mv	s9,s10
  800252:	5d7d                	li	s10,-1
  800254:	bfa1                	j	8001ac <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
  800256:	8db6                	mv	s11,a3
  800258:	8462                	mv	s0,s8
  80025a:	bf89                	j	8001ac <vprintfmt+0x5c>
  80025c:	8462                	mv	s0,s8
            altflag = 1;
  80025e:	4b85                	li	s7,1
            goto reswitch;
  800260:	b7b1                	j	8001ac <vprintfmt+0x5c>
    if (lflag >= 2) {
  800262:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800264:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  800268:	00c7c463          	blt	a5,a2,800270 <vprintfmt+0x120>
    else if (lflag) {
  80026c:	1a060263          	beqz	a2,800410 <vprintfmt+0x2c0>
        return va_arg(*ap, unsigned long);
  800270:	000a3603          	ld	a2,0(s4)
  800274:	46c1                	li	a3,16
  800276:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
  800278:	000d879b          	sext.w	a5,s11
  80027c:	8766                	mv	a4,s9
  80027e:	85a6                	mv	a1,s1
  800280:	854a                	mv	a0,s2
  800282:	e61ff0ef          	jal	8000e2 <printnum>
            break;
  800286:	bdfd                	j	800184 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
  800288:	000a2503          	lw	a0,0(s4)
  80028c:	85a6                	mv	a1,s1
  80028e:	0a21                	add	s4,s4,8
  800290:	9902                	jalr	s2
            break;
  800292:	bdcd                	j	800184 <vprintfmt+0x34>
    if (lflag >= 2) {
  800294:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800296:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  80029a:	00c7c463          	blt	a5,a2,8002a2 <vprintfmt+0x152>
    else if (lflag) {
  80029e:	16060463          	beqz	a2,800406 <vprintfmt+0x2b6>
        return va_arg(*ap, unsigned long);
  8002a2:	000a3603          	ld	a2,0(s4)
  8002a6:	46a9                	li	a3,10
  8002a8:	8a3a                	mv	s4,a4
  8002aa:	b7f9                	j	800278 <vprintfmt+0x128>
            putch('0', putdat);
  8002ac:	03000513          	li	a0,48
  8002b0:	85a6                	mv	a1,s1
  8002b2:	9902                	jalr	s2
            putch('x', putdat);
  8002b4:	85a6                	mv	a1,s1
  8002b6:	07800513          	li	a0,120
  8002ba:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8002bc:	0a21                	add	s4,s4,8
            goto number;
  8002be:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8002c0:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  8002c4:	bf55                	j	800278 <vprintfmt+0x128>
            putch(ch, putdat);
  8002c6:	85a6                	mv	a1,s1
  8002c8:	02500513          	li	a0,37
  8002cc:	9902                	jalr	s2
            break;
  8002ce:	bd5d                	j	800184 <vprintfmt+0x34>
            precision = va_arg(ap, int);
  8002d0:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002d4:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
  8002d6:	0a21                	add	s4,s4,8
            goto process_precision;
  8002d8:	bf95                	j	80024c <vprintfmt+0xfc>
    if (lflag >= 2) {
  8002da:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8002dc:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  8002e0:	00c7c463          	blt	a5,a2,8002e8 <vprintfmt+0x198>
    else if (lflag) {
  8002e4:	10060c63          	beqz	a2,8003fc <vprintfmt+0x2ac>
        return va_arg(*ap, unsigned long);
  8002e8:	000a3603          	ld	a2,0(s4)
  8002ec:	46a1                	li	a3,8
  8002ee:	8a3a                	mv	s4,a4
  8002f0:	b761                	j	800278 <vprintfmt+0x128>
            if (width < 0)
  8002f2:	fffcc793          	not	a5,s9
  8002f6:	97fd                	sra	a5,a5,0x3f
  8002f8:	00fcf7b3          	and	a5,s9,a5
  8002fc:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800300:	8462                	mv	s0,s8
            goto reswitch;
  800302:	b56d                	j	8001ac <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
  800304:	000a3403          	ld	s0,0(s4)
  800308:	008a0793          	add	a5,s4,8
  80030c:	e43e                	sd	a5,8(sp)
  80030e:	12040163          	beqz	s0,800430 <vprintfmt+0x2e0>
            if (width > 0 && padc != '-') {
  800312:	0d905963          	blez	s9,8003e4 <vprintfmt+0x294>
  800316:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80031a:	00140a13          	add	s4,s0,1
            if (width > 0 && padc != '-') {
  80031e:	12fd9863          	bne	s11,a5,80044e <vprintfmt+0x2fe>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800322:	00044783          	lbu	a5,0(s0)
  800326:	0007851b          	sext.w	a0,a5
  80032a:	cb9d                	beqz	a5,800360 <vprintfmt+0x210>
  80032c:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  80032e:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800332:	000d4563          	bltz	s10,80033c <vprintfmt+0x1ec>
  800336:	3d7d                	addw	s10,s10,-1
  800338:	028d0263          	beq	s10,s0,80035c <vprintfmt+0x20c>
                    putch('?', putdat);
  80033c:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80033e:	0c0b8e63          	beqz	s7,80041a <vprintfmt+0x2ca>
  800342:	3781                	addw	a5,a5,-32
  800344:	0cfdfb63          	bgeu	s11,a5,80041a <vprintfmt+0x2ca>
                    putch('?', putdat);
  800348:	03f00513          	li	a0,63
  80034c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80034e:	000a4783          	lbu	a5,0(s4)
  800352:	3cfd                	addw	s9,s9,-1
  800354:	0a05                	add	s4,s4,1
  800356:	0007851b          	sext.w	a0,a5
  80035a:	ffe1                	bnez	a5,800332 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
  80035c:	01905963          	blez	s9,80036e <vprintfmt+0x21e>
  800360:	3cfd                	addw	s9,s9,-1
                putch(' ', putdat);
  800362:	85a6                	mv	a1,s1
  800364:	02000513          	li	a0,32
  800368:	9902                	jalr	s2
            for (; width > 0; width --) {
  80036a:	fe0c9be3          	bnez	s9,800360 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
  80036e:	6a22                	ld	s4,8(sp)
  800370:	bd11                	j	800184 <vprintfmt+0x34>
    if (lflag >= 2) {
  800372:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800374:	008a0b93          	add	s7,s4,8
    if (lflag >= 2) {
  800378:	00c7c363          	blt	a5,a2,80037e <vprintfmt+0x22e>
    else if (lflag) {
  80037c:	ce2d                	beqz	a2,8003f6 <vprintfmt+0x2a6>
        return va_arg(*ap, long);
  80037e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800382:	08044e63          	bltz	s0,80041e <vprintfmt+0x2ce>
            num = getint(&ap, lflag);
  800386:	8622                	mv	a2,s0
  800388:	8a5e                	mv	s4,s7
  80038a:	46a9                	li	a3,10
  80038c:	b5f5                	j	800278 <vprintfmt+0x128>
            if (err < 0) {
  80038e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800392:	4661                	li	a2,24
            if (err < 0) {
  800394:	41f7d71b          	sraw	a4,a5,0x1f
  800398:	8fb9                	xor	a5,a5,a4
  80039a:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80039e:	02d64663          	blt	a2,a3,8003ca <vprintfmt+0x27a>
  8003a2:	00369713          	sll	a4,a3,0x3
  8003a6:	00000797          	auipc	a5,0x0
  8003aa:	3e278793          	add	a5,a5,994 # 800788 <error_string>
  8003ae:	97ba                	add	a5,a5,a4
  8003b0:	639c                	ld	a5,0(a5)
  8003b2:	cf81                	beqz	a5,8003ca <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
  8003b4:	86be                	mv	a3,a5
  8003b6:	00000617          	auipc	a2,0x0
  8003ba:	1b260613          	add	a2,a2,434 # 800568 <main+0x80>
  8003be:	85a6                	mv	a1,s1
  8003c0:	854a                	mv	a0,s2
  8003c2:	0ea000ef          	jal	8004ac <printfmt>
            err = va_arg(ap, int);
  8003c6:	0a21                	add	s4,s4,8
  8003c8:	bb75                	j	800184 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
  8003ca:	00000617          	auipc	a2,0x0
  8003ce:	18e60613          	add	a2,a2,398 # 800558 <main+0x70>
  8003d2:	85a6                	mv	a1,s1
  8003d4:	854a                	mv	a0,s2
  8003d6:	0d6000ef          	jal	8004ac <printfmt>
            err = va_arg(ap, int);
  8003da:	0a21                	add	s4,s4,8
  8003dc:	b365                	j	800184 <vprintfmt+0x34>
            lflag ++;
  8003de:	2605                	addw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003e0:	8462                	mv	s0,s8
            goto reswitch;
  8003e2:	b3e9                	j	8001ac <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003e4:	00044783          	lbu	a5,0(s0)
  8003e8:	00140a13          	add	s4,s0,1
  8003ec:	0007851b          	sext.w	a0,a5
  8003f0:	ff95                	bnez	a5,80032c <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003f2:	6a22                	ld	s4,8(sp)
  8003f4:	bb41                	j	800184 <vprintfmt+0x34>
        return va_arg(*ap, int);
  8003f6:	000a2403          	lw	s0,0(s4)
  8003fa:	b761                	j	800382 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
  8003fc:	000a6603          	lwu	a2,0(s4)
  800400:	46a1                	li	a3,8
  800402:	8a3a                	mv	s4,a4
  800404:	bd95                	j	800278 <vprintfmt+0x128>
  800406:	000a6603          	lwu	a2,0(s4)
  80040a:	46a9                	li	a3,10
  80040c:	8a3a                	mv	s4,a4
  80040e:	b5ad                	j	800278 <vprintfmt+0x128>
  800410:	000a6603          	lwu	a2,0(s4)
  800414:	46c1                	li	a3,16
  800416:	8a3a                	mv	s4,a4
  800418:	b585                	j	800278 <vprintfmt+0x128>
                    putch(ch, putdat);
  80041a:	9902                	jalr	s2
  80041c:	bf0d                	j	80034e <vprintfmt+0x1fe>
                putch('-', putdat);
  80041e:	85a6                	mv	a1,s1
  800420:	02d00513          	li	a0,45
  800424:	9902                	jalr	s2
                num = -(long long)num;
  800426:	8a5e                	mv	s4,s7
  800428:	40800633          	neg	a2,s0
  80042c:	46a9                	li	a3,10
  80042e:	b5a9                	j	800278 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
  800430:	01905663          	blez	s9,80043c <vprintfmt+0x2ec>
  800434:	02d00793          	li	a5,45
  800438:	04fd9263          	bne	s11,a5,80047c <vprintfmt+0x32c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80043c:	00000a17          	auipc	s4,0x0
  800440:	115a0a13          	add	s4,s4,277 # 800551 <main+0x69>
  800444:	02800513          	li	a0,40
  800448:	02800793          	li	a5,40
  80044c:	b5c5                	j	80032c <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80044e:	85ea                	mv	a1,s10
  800450:	8522                	mv	a0,s0
  800452:	07a000ef          	jal	8004cc <strnlen>
  800456:	40ac8cbb          	subw	s9,s9,a0
  80045a:	01905963          	blez	s9,80046c <vprintfmt+0x31c>
                    putch(padc, putdat);
  80045e:	2d81                	sext.w	s11,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
  800460:	3cfd                	addw	s9,s9,-1
                    putch(padc, putdat);
  800462:	85a6                	mv	a1,s1
  800464:	856e                	mv	a0,s11
  800466:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800468:	fe0c9ce3          	bnez	s9,800460 <vprintfmt+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80046c:	00044783          	lbu	a5,0(s0)
  800470:	0007851b          	sext.w	a0,a5
  800474:	ea079ce3          	bnez	a5,80032c <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  800478:	6a22                	ld	s4,8(sp)
  80047a:	b329                	j	800184 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80047c:	85ea                	mv	a1,s10
  80047e:	00000517          	auipc	a0,0x0
  800482:	0d250513          	add	a0,a0,210 # 800550 <main+0x68>
  800486:	046000ef          	jal	8004cc <strnlen>
  80048a:	40ac8cbb          	subw	s9,s9,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80048e:	00000a17          	auipc	s4,0x0
  800492:	0c3a0a13          	add	s4,s4,195 # 800551 <main+0x69>
                p = "(null)";
  800496:	00000417          	auipc	s0,0x0
  80049a:	0ba40413          	add	s0,s0,186 # 800550 <main+0x68>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80049e:	02800513          	li	a0,40
  8004a2:	02800793          	li	a5,40
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004a6:	fb904ce3          	bgtz	s9,80045e <vprintfmt+0x30e>
  8004aa:	b549                	j	80032c <vprintfmt+0x1dc>

00000000008004ac <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004ac:	715d                	add	sp,sp,-80
    va_start(ap, fmt);
  8004ae:	02810313          	add	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004b2:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004b4:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004b6:	ec06                	sd	ra,24(sp)
  8004b8:	f83a                	sd	a4,48(sp)
  8004ba:	fc3e                	sd	a5,56(sp)
  8004bc:	e0c2                	sd	a6,64(sp)
  8004be:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004c0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004c2:	c8fff0ef          	jal	800150 <vprintfmt>
}
  8004c6:	60e2                	ld	ra,24(sp)
  8004c8:	6161                	add	sp,sp,80
  8004ca:	8082                	ret

00000000008004cc <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004cc:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004ce:	e589                	bnez	a1,8004d8 <strnlen+0xc>
  8004d0:	a811                	j	8004e4 <strnlen+0x18>
        cnt ++;
  8004d2:	0785                	add	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004d4:	00f58863          	beq	a1,a5,8004e4 <strnlen+0x18>
  8004d8:	00f50733          	add	a4,a0,a5
  8004dc:	00074703          	lbu	a4,0(a4)
  8004e0:	fb6d                	bnez	a4,8004d2 <strnlen+0x6>
  8004e2:	85be                	mv	a1,a5
    }
    return cnt;
}
  8004e4:	852e                	mv	a0,a1
  8004e6:	8082                	ret

00000000008004e8 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  8004e8:	1141                	add	sp,sp,-16
    cprintf("Hello world!!.\n");
  8004ea:	00000517          	auipc	a0,0x0
  8004ee:	36650513          	add	a0,a0,870 # 800850 <error_string+0xc8>
main(void) {
  8004f2:	e406                	sd	ra,8(sp)
    cprintf("Hello world!!.\n");
  8004f4:	b4dff0ef          	jal	800040 <cprintf>
    cprintf("I am process %d.\n", getpid());
  8004f8:	bddff0ef          	jal	8000d4 <getpid>
  8004fc:	85aa                	mv	a1,a0
  8004fe:	00000517          	auipc	a0,0x0
  800502:	36250513          	add	a0,a0,866 # 800860 <error_string+0xd8>
  800506:	b3bff0ef          	jal	800040 <cprintf>
    cprintf("hello pass.\n");
  80050a:	00000517          	auipc	a0,0x0
  80050e:	36e50513          	add	a0,a0,878 # 800878 <error_string+0xf0>
  800512:	b2fff0ef          	jal	800040 <cprintf>
    return 0;
}
  800516:	60a2                	ld	ra,8(sp)
  800518:	4501                	li	a0,0
  80051a:	0141                	add	sp,sp,16
  80051c:	8082                	ret
