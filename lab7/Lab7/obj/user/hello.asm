
obj/__user_hello.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	0b6000ef          	jal	ra,8000d6 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	addi	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	08a000ef          	jal	ra,8000b8 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addiw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	addi	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	addi	a1,sp,4
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
  80006a:	0e4000ef          	jal	ra,80014e <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	addi	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	addi	sp,sp,-144
  800078:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	e0ba                	sd	a4,64(sp)
  80007c:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  80007e:	e42a                	sd	a0,8(sp)
  800080:	ecae                	sd	a1,88(sp)
  800082:	f0b2                	sd	a2,96(sp)
  800084:	f4b6                	sd	a3,104(sp)
  800086:	fcbe                	sd	a5,120(sp)
  800088:	e142                	sd	a6,128(sp)
  80008a:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	f03a                	sd	a4,32(sp)
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
  8000aa:	6149                	addi	sp,sp,144
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
  8000be:	1141                	addi	sp,sp,-16
  8000c0:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  8000c2:	fedff0ef          	jal	ra,8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000c6:	00000517          	auipc	a0,0x0
  8000ca:	46250513          	addi	a0,a0,1122 # 800528 <main+0x3c>
  8000ce:	f73ff0ef          	jal	ra,800040 <cprintf>
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
  8000d6:	1141                	addi	sp,sp,-16
  8000d8:	e406                	sd	ra,8(sp)
    int ret = main();
  8000da:	412000ef          	jal	ra,8004ec <main>
    exit(ret);
  8000de:	fe1ff0ef          	jal	ra,8000be <exit>

00000000008000e2 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000e2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000e6:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  8000e8:	02085813          	srli	a6,a6,0x20
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
  800100:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800104:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800106:	03067e63          	bgeu	a2,a6,800142 <printnum+0x60>
  80010a:	89be                	mv	s3,a5
        while (-- width > 0)
  80010c:	00805763          	blez	s0,80011a <printnum+0x38>
  800110:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800112:	85ca                	mv	a1,s2
  800114:	854e                	mv	a0,s3
  800116:	9482                	jalr	s1
        while (-- width > 0)
  800118:	fc65                	bnez	s0,800110 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80011a:	1a02                	slli	s4,s4,0x20
  80011c:	00000797          	auipc	a5,0x0
  800120:	42478793          	addi	a5,a5,1060 # 800540 <main+0x54>
  800124:	020a5a13          	srli	s4,s4,0x20
  800128:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80012a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  80012c:	000a4503          	lbu	a0,0(s4)
}
  800130:	70a2                	ld	ra,40(sp)
  800132:	69a2                	ld	s3,8(sp)
  800134:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800136:	85ca                	mv	a1,s2
  800138:	87a6                	mv	a5,s1
}
  80013a:	6942                	ld	s2,16(sp)
  80013c:	64e2                	ld	s1,24(sp)
  80013e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  800140:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  800142:	03065633          	divu	a2,a2,a6
  800146:	8722                	mv	a4,s0
  800148:	f9bff0ef          	jal	ra,8000e2 <printnum>
  80014c:	b7f9                	j	80011a <printnum+0x38>

000000000080014e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80014e:	7119                	addi	sp,sp,-128
  800150:	f4a6                	sd	s1,104(sp)
  800152:	f0ca                	sd	s2,96(sp)
  800154:	ecce                	sd	s3,88(sp)
  800156:	e8d2                	sd	s4,80(sp)
  800158:	e4d6                	sd	s5,72(sp)
  80015a:	e0da                	sd	s6,64(sp)
  80015c:	fc5e                	sd	s7,56(sp)
  80015e:	f06a                	sd	s10,32(sp)
  800160:	fc86                	sd	ra,120(sp)
  800162:	f8a2                	sd	s0,112(sp)
  800164:	f862                	sd	s8,48(sp)
  800166:	f466                	sd	s9,40(sp)
  800168:	ec6e                	sd	s11,24(sp)
  80016a:	892a                	mv	s2,a0
  80016c:	84ae                	mv	s1,a1
  80016e:	8d32                	mv	s10,a2
  800170:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800172:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800176:	5b7d                	li	s6,-1
  800178:	00000a97          	auipc	s5,0x0
  80017c:	3fca8a93          	addi	s5,s5,1020 # 800574 <main+0x88>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800180:	00000b97          	auipc	s7,0x0
  800184:	610b8b93          	addi	s7,s7,1552 # 800790 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800188:	000d4503          	lbu	a0,0(s10)
  80018c:	001d0413          	addi	s0,s10,1
  800190:	01350a63          	beq	a0,s3,8001a4 <vprintfmt+0x56>
            if (ch == '\0') {
  800194:	c121                	beqz	a0,8001d4 <vprintfmt+0x86>
            putch(ch, putdat);
  800196:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800198:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80019a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80019c:	fff44503          	lbu	a0,-1(s0)
  8001a0:	ff351ae3          	bne	a0,s3,800194 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8001a4:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8001a8:	02000793          	li	a5,32
        lflag = altflag = 0;
  8001ac:	4c81                	li	s9,0
  8001ae:	4881                	li	a7,0
        width = precision = -1;
  8001b0:	5c7d                	li	s8,-1
  8001b2:	5dfd                	li	s11,-1
  8001b4:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  8001b8:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  8001ba:	fdd6059b          	addiw	a1,a2,-35
  8001be:	0ff5f593          	andi	a1,a1,255
  8001c2:	00140d13          	addi	s10,s0,1
  8001c6:	04b56263          	bltu	a0,a1,80020a <vprintfmt+0xbc>
  8001ca:	058a                	slli	a1,a1,0x2
  8001cc:	95d6                	add	a1,a1,s5
  8001ce:	4194                	lw	a3,0(a1)
  8001d0:	96d6                	add	a3,a3,s5
  8001d2:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001d4:	70e6                	ld	ra,120(sp)
  8001d6:	7446                	ld	s0,112(sp)
  8001d8:	74a6                	ld	s1,104(sp)
  8001da:	7906                	ld	s2,96(sp)
  8001dc:	69e6                	ld	s3,88(sp)
  8001de:	6a46                	ld	s4,80(sp)
  8001e0:	6aa6                	ld	s5,72(sp)
  8001e2:	6b06                	ld	s6,64(sp)
  8001e4:	7be2                	ld	s7,56(sp)
  8001e6:	7c42                	ld	s8,48(sp)
  8001e8:	7ca2                	ld	s9,40(sp)
  8001ea:	7d02                	ld	s10,32(sp)
  8001ec:	6de2                	ld	s11,24(sp)
  8001ee:	6109                	addi	sp,sp,128
  8001f0:	8082                	ret
            padc = '0';
  8001f2:	87b2                	mv	a5,a2
            goto reswitch;
  8001f4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8001f8:	846a                	mv	s0,s10
  8001fa:	00140d13          	addi	s10,s0,1
  8001fe:	fdd6059b          	addiw	a1,a2,-35
  800202:	0ff5f593          	andi	a1,a1,255
  800206:	fcb572e3          	bgeu	a0,a1,8001ca <vprintfmt+0x7c>
            putch('%', putdat);
  80020a:	85a6                	mv	a1,s1
  80020c:	02500513          	li	a0,37
  800210:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800212:	fff44783          	lbu	a5,-1(s0)
  800216:	8d22                	mv	s10,s0
  800218:	f73788e3          	beq	a5,s3,800188 <vprintfmt+0x3a>
  80021c:	ffed4783          	lbu	a5,-2(s10)
  800220:	1d7d                	addi	s10,s10,-1
  800222:	ff379de3          	bne	a5,s3,80021c <vprintfmt+0xce>
  800226:	b78d                	j	800188 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800228:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  80022c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800230:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  800232:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  800236:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  80023a:	02d86463          	bltu	a6,a3,800262 <vprintfmt+0x114>
                ch = *fmt;
  80023e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  800242:	002c169b          	slliw	a3,s8,0x2
  800246:	0186873b          	addw	a4,a3,s8
  80024a:	0017171b          	slliw	a4,a4,0x1
  80024e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  800250:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  800254:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800256:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  80025a:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  80025e:	fed870e3          	bgeu	a6,a3,80023e <vprintfmt+0xf0>
            if (width < 0)
  800262:	f40ddce3          	bgez	s11,8001ba <vprintfmt+0x6c>
                width = precision, precision = -1;
  800266:	8de2                	mv	s11,s8
  800268:	5c7d                	li	s8,-1
  80026a:	bf81                	j	8001ba <vprintfmt+0x6c>
            if (width < 0)
  80026c:	fffdc693          	not	a3,s11
  800270:	96fd                	srai	a3,a3,0x3f
  800272:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  800276:	00144603          	lbu	a2,1(s0)
  80027a:	2d81                	sext.w	s11,s11
  80027c:	846a                	mv	s0,s10
            goto reswitch;
  80027e:	bf35                	j	8001ba <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800280:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800284:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  800288:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  80028a:	846a                	mv	s0,s10
            goto process_precision;
  80028c:	bfd9                	j	800262 <vprintfmt+0x114>
    if (lflag >= 2) {
  80028e:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800290:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800294:	01174463          	blt	a4,a7,80029c <vprintfmt+0x14e>
    else if (lflag) {
  800298:	1a088e63          	beqz	a7,800454 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  80029c:	000a3603          	ld	a2,0(s4)
  8002a0:	46c1                	li	a3,16
  8002a2:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  8002a4:	2781                	sext.w	a5,a5
  8002a6:	876e                	mv	a4,s11
  8002a8:	85a6                	mv	a1,s1
  8002aa:	854a                	mv	a0,s2
  8002ac:	e37ff0ef          	jal	ra,8000e2 <printnum>
            break;
  8002b0:	bde1                	j	800188 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8002b2:	000a2503          	lw	a0,0(s4)
  8002b6:	85a6                	mv	a1,s1
  8002b8:	0a21                	addi	s4,s4,8
  8002ba:	9902                	jalr	s2
            break;
  8002bc:	b5f1                	j	800188 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8002be:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002c0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002c4:	01174463          	blt	a4,a7,8002cc <vprintfmt+0x17e>
    else if (lflag) {
  8002c8:	18088163          	beqz	a7,80044a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  8002cc:	000a3603          	ld	a2,0(s4)
  8002d0:	46a9                	li	a3,10
  8002d2:	8a2e                	mv	s4,a1
  8002d4:	bfc1                	j	8002a4 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  8002d6:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  8002da:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002dc:	846a                	mv	s0,s10
            goto reswitch;
  8002de:	bdf1                	j	8001ba <vprintfmt+0x6c>
            putch(ch, putdat);
  8002e0:	85a6                	mv	a1,s1
  8002e2:	02500513          	li	a0,37
  8002e6:	9902                	jalr	s2
            break;
  8002e8:	b545                	j	800188 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  8002ea:	00144603          	lbu	a2,1(s0)
            lflag ++;
  8002ee:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002f0:	846a                	mv	s0,s10
            goto reswitch;
  8002f2:	b5e1                	j	8001ba <vprintfmt+0x6c>
    if (lflag >= 2) {
  8002f4:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002f6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002fa:	01174463          	blt	a4,a7,800302 <vprintfmt+0x1b4>
    else if (lflag) {
  8002fe:	14088163          	beqz	a7,800440 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800302:	000a3603          	ld	a2,0(s4)
  800306:	46a1                	li	a3,8
  800308:	8a2e                	mv	s4,a1
  80030a:	bf69                	j	8002a4 <vprintfmt+0x156>
            putch('0', putdat);
  80030c:	03000513          	li	a0,48
  800310:	85a6                	mv	a1,s1
  800312:	e03e                	sd	a5,0(sp)
  800314:	9902                	jalr	s2
            putch('x', putdat);
  800316:	85a6                	mv	a1,s1
  800318:	07800513          	li	a0,120
  80031c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80031e:	0a21                	addi	s4,s4,8
            goto number;
  800320:	6782                	ld	a5,0(sp)
  800322:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800324:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800328:	bfb5                	j	8002a4 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  80032a:	000a3403          	ld	s0,0(s4)
  80032e:	008a0713          	addi	a4,s4,8
  800332:	e03a                	sd	a4,0(sp)
  800334:	14040263          	beqz	s0,800478 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  800338:	0fb05763          	blez	s11,800426 <vprintfmt+0x2d8>
  80033c:	02d00693          	li	a3,45
  800340:	0cd79163          	bne	a5,a3,800402 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800344:	00044783          	lbu	a5,0(s0)
  800348:	0007851b          	sext.w	a0,a5
  80034c:	cf85                	beqz	a5,800384 <vprintfmt+0x236>
  80034e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  800352:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800356:	000c4563          	bltz	s8,800360 <vprintfmt+0x212>
  80035a:	3c7d                	addiw	s8,s8,-1
  80035c:	036c0263          	beq	s8,s6,800380 <vprintfmt+0x232>
                    putch('?', putdat);
  800360:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  800362:	0e0c8e63          	beqz	s9,80045e <vprintfmt+0x310>
  800366:	3781                	addiw	a5,a5,-32
  800368:	0ef47b63          	bgeu	s0,a5,80045e <vprintfmt+0x310>
                    putch('?', putdat);
  80036c:	03f00513          	li	a0,63
  800370:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800372:	000a4783          	lbu	a5,0(s4)
  800376:	3dfd                	addiw	s11,s11,-1
  800378:	0a05                	addi	s4,s4,1
  80037a:	0007851b          	sext.w	a0,a5
  80037e:	ffe1                	bnez	a5,800356 <vprintfmt+0x208>
            for (; width > 0; width --) {
  800380:	01b05963          	blez	s11,800392 <vprintfmt+0x244>
  800384:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  800386:	85a6                	mv	a1,s1
  800388:	02000513          	li	a0,32
  80038c:	9902                	jalr	s2
            for (; width > 0; width --) {
  80038e:	fe0d9be3          	bnez	s11,800384 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  800392:	6a02                	ld	s4,0(sp)
  800394:	bbd5                	j	800188 <vprintfmt+0x3a>
    if (lflag >= 2) {
  800396:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800398:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  80039c:	01174463          	blt	a4,a7,8003a4 <vprintfmt+0x256>
    else if (lflag) {
  8003a0:	08088d63          	beqz	a7,80043a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  8003a4:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003a8:	0a044d63          	bltz	s0,800462 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  8003ac:	8622                	mv	a2,s0
  8003ae:	8a66                	mv	s4,s9
  8003b0:	46a9                	li	a3,10
  8003b2:	bdcd                	j	8002a4 <vprintfmt+0x156>
            err = va_arg(ap, int);
  8003b4:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003b8:	4761                	li	a4,24
            err = va_arg(ap, int);
  8003ba:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8003bc:	41f7d69b          	sraiw	a3,a5,0x1f
  8003c0:	8fb5                	xor	a5,a5,a3
  8003c2:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003c6:	02d74163          	blt	a4,a3,8003e8 <vprintfmt+0x29a>
  8003ca:	00369793          	slli	a5,a3,0x3
  8003ce:	97de                	add	a5,a5,s7
  8003d0:	639c                	ld	a5,0(a5)
  8003d2:	cb99                	beqz	a5,8003e8 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  8003d4:	86be                	mv	a3,a5
  8003d6:	00000617          	auipc	a2,0x0
  8003da:	19a60613          	addi	a2,a2,410 # 800570 <main+0x84>
  8003de:	85a6                	mv	a1,s1
  8003e0:	854a                	mv	a0,s2
  8003e2:	0ce000ef          	jal	ra,8004b0 <printfmt>
  8003e6:	b34d                	j	800188 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8003e8:	00000617          	auipc	a2,0x0
  8003ec:	17860613          	addi	a2,a2,376 # 800560 <main+0x74>
  8003f0:	85a6                	mv	a1,s1
  8003f2:	854a                	mv	a0,s2
  8003f4:	0bc000ef          	jal	ra,8004b0 <printfmt>
  8003f8:	bb41                	j	800188 <vprintfmt+0x3a>
                p = "(null)";
  8003fa:	00000417          	auipc	s0,0x0
  8003fe:	15e40413          	addi	s0,s0,350 # 800558 <main+0x6c>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800402:	85e2                	mv	a1,s8
  800404:	8522                	mv	a0,s0
  800406:	e43e                	sd	a5,8(sp)
  800408:	0c8000ef          	jal	ra,8004d0 <strnlen>
  80040c:	40ad8dbb          	subw	s11,s11,a0
  800410:	01b05b63          	blez	s11,800426 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  800414:	67a2                	ld	a5,8(sp)
  800416:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  80041a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  80041c:	85a6                	mv	a1,s1
  80041e:	8552                	mv	a0,s4
  800420:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800422:	fe0d9ce3          	bnez	s11,80041a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800426:	00044783          	lbu	a5,0(s0)
  80042a:	00140a13          	addi	s4,s0,1
  80042e:	0007851b          	sext.w	a0,a5
  800432:	d3a5                	beqz	a5,800392 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  800434:	05e00413          	li	s0,94
  800438:	bf39                	j	800356 <vprintfmt+0x208>
        return va_arg(*ap, int);
  80043a:	000a2403          	lw	s0,0(s4)
  80043e:	b7ad                	j	8003a8 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  800440:	000a6603          	lwu	a2,0(s4)
  800444:	46a1                	li	a3,8
  800446:	8a2e                	mv	s4,a1
  800448:	bdb1                	j	8002a4 <vprintfmt+0x156>
  80044a:	000a6603          	lwu	a2,0(s4)
  80044e:	46a9                	li	a3,10
  800450:	8a2e                	mv	s4,a1
  800452:	bd89                	j	8002a4 <vprintfmt+0x156>
  800454:	000a6603          	lwu	a2,0(s4)
  800458:	46c1                	li	a3,16
  80045a:	8a2e                	mv	s4,a1
  80045c:	b5a1                	j	8002a4 <vprintfmt+0x156>
                    putch(ch, putdat);
  80045e:	9902                	jalr	s2
  800460:	bf09                	j	800372 <vprintfmt+0x224>
                putch('-', putdat);
  800462:	85a6                	mv	a1,s1
  800464:	02d00513          	li	a0,45
  800468:	e03e                	sd	a5,0(sp)
  80046a:	9902                	jalr	s2
                num = -(long long)num;
  80046c:	6782                	ld	a5,0(sp)
  80046e:	8a66                	mv	s4,s9
  800470:	40800633          	neg	a2,s0
  800474:	46a9                	li	a3,10
  800476:	b53d                	j	8002a4 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  800478:	03b05163          	blez	s11,80049a <vprintfmt+0x34c>
  80047c:	02d00693          	li	a3,45
  800480:	f6d79de3          	bne	a5,a3,8003fa <vprintfmt+0x2ac>
                p = "(null)";
  800484:	00000417          	auipc	s0,0x0
  800488:	0d440413          	addi	s0,s0,212 # 800558 <main+0x6c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80048c:	02800793          	li	a5,40
  800490:	02800513          	li	a0,40
  800494:	00140a13          	addi	s4,s0,1
  800498:	bd6d                	j	800352 <vprintfmt+0x204>
  80049a:	00000a17          	auipc	s4,0x0
  80049e:	0bfa0a13          	addi	s4,s4,191 # 800559 <main+0x6d>
  8004a2:	02800513          	li	a0,40
  8004a6:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  8004aa:	05e00413          	li	s0,94
  8004ae:	b565                	j	800356 <vprintfmt+0x208>

00000000008004b0 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004b0:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004b2:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004b6:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004b8:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004ba:	ec06                	sd	ra,24(sp)
  8004bc:	f83a                	sd	a4,48(sp)
  8004be:	fc3e                	sd	a5,56(sp)
  8004c0:	e0c2                	sd	a6,64(sp)
  8004c2:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004c4:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004c6:	c89ff0ef          	jal	ra,80014e <vprintfmt>
}
  8004ca:	60e2                	ld	ra,24(sp)
  8004cc:	6161                	addi	sp,sp,80
  8004ce:	8082                	ret

00000000008004d0 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004d0:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004d2:	e589                	bnez	a1,8004dc <strnlen+0xc>
  8004d4:	a811                	j	8004e8 <strnlen+0x18>
        cnt ++;
  8004d6:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004d8:	00f58863          	beq	a1,a5,8004e8 <strnlen+0x18>
  8004dc:	00f50733          	add	a4,a0,a5
  8004e0:	00074703          	lbu	a4,0(a4)
  8004e4:	fb6d                	bnez	a4,8004d6 <strnlen+0x6>
  8004e6:	85be                	mv	a1,a5
    }
    return cnt;
}
  8004e8:	852e                	mv	a0,a1
  8004ea:	8082                	ret

00000000008004ec <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  8004ec:	1141                	addi	sp,sp,-16
    cprintf("Hello world!!.\n");
  8004ee:	00000517          	auipc	a0,0x0
  8004f2:	36a50513          	addi	a0,a0,874 # 800858 <error_string+0xc8>
main(void) {
  8004f6:	e406                	sd	ra,8(sp)
    cprintf("Hello world!!.\n");
  8004f8:	b49ff0ef          	jal	ra,800040 <cprintf>
    cprintf("I am process %d.\n", getpid());
  8004fc:	bd9ff0ef          	jal	ra,8000d4 <getpid>
  800500:	85aa                	mv	a1,a0
  800502:	00000517          	auipc	a0,0x0
  800506:	36650513          	addi	a0,a0,870 # 800868 <error_string+0xd8>
  80050a:	b37ff0ef          	jal	ra,800040 <cprintf>
    cprintf("hello pass.\n");
  80050e:	00000517          	auipc	a0,0x0
  800512:	37250513          	addi	a0,a0,882 # 800880 <error_string+0xf0>
  800516:	b2bff0ef          	jal	ra,800040 <cprintf>
    return 0;
}
  80051a:	60a2                	ld	ra,8(sp)
  80051c:	4501                	li	a0,0
  80051e:	0141                	addi	sp,sp,16
  800520:	8082                	ret
