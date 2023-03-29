
obj/__user_rr.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	136000ef          	jal	ra,800156 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800026:	715d                	addi	sp,sp,-80
  800028:	8e2e                	mv	t3,a1
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
  800032:	8672                	mv	a2,t3
    va_start(ap, fmt);
  800034:	103c                	addi	a5,sp,40
    cprintf("user panic at %s:%d:\n    ", file, line);
  800036:	00000517          	auipc	a0,0x0
  80003a:	67a50513          	addi	a0,a0,1658 # 8006b0 <main+0x132>
__panic(const char *file, int line, const char *fmt, ...) {
  80003e:	ec06                	sd	ra,24(sp)
  800040:	f436                	sd	a3,40(sp)
  800042:	f83a                	sd	a4,48(sp)
  800044:	e0c2                	sd	a6,64(sp)
  800046:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800048:	e43e                	sd	a5,8(sp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80004a:	058000ef          	jal	ra,8000a2 <cprintf>
    vcprintf(fmt, ap);
  80004e:	65a2                	ld	a1,8(sp)
  800050:	8522                	mv	a0,s0
  800052:	030000ef          	jal	ra,800082 <vcprintf>
    cprintf("\n");
  800056:	00000517          	auipc	a0,0x0
  80005a:	67a50513          	addi	a0,a0,1658 # 8006d0 <main+0x152>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0d2000ef          	jal	ra,800136 <exit>

0000000000800068 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800068:	1141                	addi	sp,sp,-16
  80006a:	e022                	sd	s0,0(sp)
  80006c:	e406                	sd	ra,8(sp)
  80006e:	842e                	mv	s0,a1
    sys_putc(c);
  800070:	0bc000ef          	jal	ra,80012c <sys_putc>
    (*cnt) ++;
  800074:	401c                	lw	a5,0(s0)
}
  800076:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800078:	2785                	addiw	a5,a5,1
  80007a:	c01c                	sw	a5,0(s0)
}
  80007c:	6402                	ld	s0,0(sp)
  80007e:	0141                	addi	sp,sp,16
  800080:	8082                	ret

0000000000800082 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  800082:	1101                	addi	sp,sp,-32
  800084:	862a                	mv	a2,a0
  800086:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800088:	00000517          	auipc	a0,0x0
  80008c:	fe050513          	addi	a0,a0,-32 # 800068 <cputch>
  800090:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
  800092:	ec06                	sd	ra,24(sp)
    int cnt = 0;
  800094:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800096:	138000ef          	jal	ra,8001ce <vprintfmt>
    return cnt;
}
  80009a:	60e2                	ld	ra,24(sp)
  80009c:	4532                	lw	a0,12(sp)
  80009e:	6105                	addi	sp,sp,32
  8000a0:	8082                	ret

00000000008000a2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  8000a2:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  8000a4:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  8000a8:	8e2a                	mv	t3,a0
  8000aa:	f42e                	sd	a1,40(sp)
  8000ac:	f832                	sd	a2,48(sp)
  8000ae:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000b0:	00000517          	auipc	a0,0x0
  8000b4:	fb850513          	addi	a0,a0,-72 # 800068 <cputch>
  8000b8:	004c                	addi	a1,sp,4
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
  8000cc:	102000ef          	jal	ra,8001ce <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  8000d0:	60e2                	ld	ra,24(sp)
  8000d2:	4512                	lw	a0,4(sp)
  8000d4:	6125                	addi	sp,sp,96
  8000d6:	8082                	ret

00000000008000d8 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  8000d8:	7175                	addi	sp,sp,-144
  8000da:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  8000dc:	e0ba                	sd	a4,64(sp)
  8000de:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  8000e0:	e42a                	sd	a0,8(sp)
  8000e2:	ecae                	sd	a1,88(sp)
  8000e4:	f0b2                	sd	a2,96(sp)
  8000e6:	f4b6                	sd	a3,104(sp)
  8000e8:	fcbe                	sd	a5,120(sp)
  8000ea:	e142                	sd	a6,128(sp)
  8000ec:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  8000ee:	f42e                	sd	a1,40(sp)
  8000f0:	f832                	sd	a2,48(sp)
  8000f2:	fc36                	sd	a3,56(sp)
  8000f4:	f03a                	sd	a4,32(sp)
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
  80010c:	6149                	addi	sp,sp,144
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
  800136:	1141                	addi	sp,sp,-16
  800138:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  80013a:	fd7ff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  80013e:	00000517          	auipc	a0,0x0
  800142:	59a50513          	addi	a0,a0,1434 # 8006d8 <main+0x15a>
  800146:	f5dff0ef          	jal	ra,8000a2 <cprintf>
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
  800156:	1141                	addi	sp,sp,-16
  800158:	e406                	sd	ra,8(sp)
    int ret = main();
  80015a:	424000ef          	jal	ra,80057e <main>
    exit(ret);
  80015e:	fd9ff0ef          	jal	ra,800136 <exit>

0000000000800162 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800162:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800166:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  800168:	02085813          	srli	a6,a6,0x20
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
  800180:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800184:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800186:	03067e63          	bgeu	a2,a6,8001c2 <printnum+0x60>
  80018a:	89be                	mv	s3,a5
        while (-- width > 0)
  80018c:	00805763          	blez	s0,80019a <printnum+0x38>
  800190:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800192:	85ca                	mv	a1,s2
  800194:	854e                	mv	a0,s3
  800196:	9482                	jalr	s1
        while (-- width > 0)
  800198:	fc65                	bnez	s0,800190 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80019a:	1a02                	slli	s4,s4,0x20
  80019c:	00000797          	auipc	a5,0x0
  8001a0:	55478793          	addi	a5,a5,1364 # 8006f0 <main+0x172>
  8001a4:	020a5a13          	srli	s4,s4,0x20
  8001a8:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  8001aa:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001ac:	000a4503          	lbu	a0,0(s4)
}
  8001b0:	70a2                	ld	ra,40(sp)
  8001b2:	69a2                	ld	s3,8(sp)
  8001b4:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001b6:	85ca                	mv	a1,s2
  8001b8:	87a6                	mv	a5,s1
}
  8001ba:	6942                	ld	s2,16(sp)
  8001bc:	64e2                	ld	s1,24(sp)
  8001be:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001c0:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001c2:	03065633          	divu	a2,a2,a6
  8001c6:	8722                	mv	a4,s0
  8001c8:	f9bff0ef          	jal	ra,800162 <printnum>
  8001cc:	b7f9                	j	80019a <printnum+0x38>

00000000008001ce <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001ce:	7119                	addi	sp,sp,-128
  8001d0:	f4a6                	sd	s1,104(sp)
  8001d2:	f0ca                	sd	s2,96(sp)
  8001d4:	ecce                	sd	s3,88(sp)
  8001d6:	e8d2                	sd	s4,80(sp)
  8001d8:	e4d6                	sd	s5,72(sp)
  8001da:	e0da                	sd	s6,64(sp)
  8001dc:	fc5e                	sd	s7,56(sp)
  8001de:	f06a                	sd	s10,32(sp)
  8001e0:	fc86                	sd	ra,120(sp)
  8001e2:	f8a2                	sd	s0,112(sp)
  8001e4:	f862                	sd	s8,48(sp)
  8001e6:	f466                	sd	s9,40(sp)
  8001e8:	ec6e                	sd	s11,24(sp)
  8001ea:	892a                	mv	s2,a0
  8001ec:	84ae                	mv	s1,a1
  8001ee:	8d32                	mv	s10,a2
  8001f0:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001f2:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  8001f6:	5b7d                	li	s6,-1
  8001f8:	00000a97          	auipc	s5,0x0
  8001fc:	52ca8a93          	addi	s5,s5,1324 # 800724 <main+0x1a6>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800200:	00000b97          	auipc	s7,0x0
  800204:	740b8b93          	addi	s7,s7,1856 # 800940 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800208:	000d4503          	lbu	a0,0(s10)
  80020c:	001d0413          	addi	s0,s10,1
  800210:	01350a63          	beq	a0,s3,800224 <vprintfmt+0x56>
            if (ch == '\0') {
  800214:	c121                	beqz	a0,800254 <vprintfmt+0x86>
            putch(ch, putdat);
  800216:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800218:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80021a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80021c:	fff44503          	lbu	a0,-1(s0)
  800220:	ff351ae3          	bne	a0,s3,800214 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  800224:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  800228:	02000793          	li	a5,32
        lflag = altflag = 0;
  80022c:	4c81                	li	s9,0
  80022e:	4881                	li	a7,0
        width = precision = -1;
  800230:	5c7d                	li	s8,-1
  800232:	5dfd                	li	s11,-1
  800234:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  800238:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  80023a:	fdd6059b          	addiw	a1,a2,-35
  80023e:	0ff5f593          	andi	a1,a1,255
  800242:	00140d13          	addi	s10,s0,1
  800246:	04b56263          	bltu	a0,a1,80028a <vprintfmt+0xbc>
  80024a:	058a                	slli	a1,a1,0x2
  80024c:	95d6                	add	a1,a1,s5
  80024e:	4194                	lw	a3,0(a1)
  800250:	96d6                	add	a3,a3,s5
  800252:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800254:	70e6                	ld	ra,120(sp)
  800256:	7446                	ld	s0,112(sp)
  800258:	74a6                	ld	s1,104(sp)
  80025a:	7906                	ld	s2,96(sp)
  80025c:	69e6                	ld	s3,88(sp)
  80025e:	6a46                	ld	s4,80(sp)
  800260:	6aa6                	ld	s5,72(sp)
  800262:	6b06                	ld	s6,64(sp)
  800264:	7be2                	ld	s7,56(sp)
  800266:	7c42                	ld	s8,48(sp)
  800268:	7ca2                	ld	s9,40(sp)
  80026a:	7d02                	ld	s10,32(sp)
  80026c:	6de2                	ld	s11,24(sp)
  80026e:	6109                	addi	sp,sp,128
  800270:	8082                	ret
            padc = '0';
  800272:	87b2                	mv	a5,a2
            goto reswitch;
  800274:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800278:	846a                	mv	s0,s10
  80027a:	00140d13          	addi	s10,s0,1
  80027e:	fdd6059b          	addiw	a1,a2,-35
  800282:	0ff5f593          	andi	a1,a1,255
  800286:	fcb572e3          	bgeu	a0,a1,80024a <vprintfmt+0x7c>
            putch('%', putdat);
  80028a:	85a6                	mv	a1,s1
  80028c:	02500513          	li	a0,37
  800290:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800292:	fff44783          	lbu	a5,-1(s0)
  800296:	8d22                	mv	s10,s0
  800298:	f73788e3          	beq	a5,s3,800208 <vprintfmt+0x3a>
  80029c:	ffed4783          	lbu	a5,-2(s10)
  8002a0:	1d7d                	addi	s10,s10,-1
  8002a2:	ff379de3          	bne	a5,s3,80029c <vprintfmt+0xce>
  8002a6:	b78d                	j	800208 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  8002a8:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  8002ac:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002b0:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  8002b2:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  8002b6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002ba:	02d86463          	bltu	a6,a3,8002e2 <vprintfmt+0x114>
                ch = *fmt;
  8002be:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  8002c2:	002c169b          	slliw	a3,s8,0x2
  8002c6:	0186873b          	addw	a4,a3,s8
  8002ca:	0017171b          	slliw	a4,a4,0x1
  8002ce:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  8002d0:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  8002d4:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002d6:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002da:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002de:	fed870e3          	bgeu	a6,a3,8002be <vprintfmt+0xf0>
            if (width < 0)
  8002e2:	f40ddce3          	bgez	s11,80023a <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002e6:	8de2                	mv	s11,s8
  8002e8:	5c7d                	li	s8,-1
  8002ea:	bf81                	j	80023a <vprintfmt+0x6c>
            if (width < 0)
  8002ec:	fffdc693          	not	a3,s11
  8002f0:	96fd                	srai	a3,a3,0x3f
  8002f2:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  8002f6:	00144603          	lbu	a2,1(s0)
  8002fa:	2d81                	sext.w	s11,s11
  8002fc:	846a                	mv	s0,s10
            goto reswitch;
  8002fe:	bf35                	j	80023a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  800300:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800304:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  800308:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  80030a:	846a                	mv	s0,s10
            goto process_precision;
  80030c:	bfd9                	j	8002e2 <vprintfmt+0x114>
    if (lflag >= 2) {
  80030e:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800310:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800314:	01174463          	blt	a4,a7,80031c <vprintfmt+0x14e>
    else if (lflag) {
  800318:	1a088e63          	beqz	a7,8004d4 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  80031c:	000a3603          	ld	a2,0(s4)
  800320:	46c1                	li	a3,16
  800322:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  800324:	2781                	sext.w	a5,a5
  800326:	876e                	mv	a4,s11
  800328:	85a6                	mv	a1,s1
  80032a:	854a                	mv	a0,s2
  80032c:	e37ff0ef          	jal	ra,800162 <printnum>
            break;
  800330:	bde1                	j	800208 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  800332:	000a2503          	lw	a0,0(s4)
  800336:	85a6                	mv	a1,s1
  800338:	0a21                	addi	s4,s4,8
  80033a:	9902                	jalr	s2
            break;
  80033c:	b5f1                	j	800208 <vprintfmt+0x3a>
    if (lflag >= 2) {
  80033e:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800340:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800344:	01174463          	blt	a4,a7,80034c <vprintfmt+0x17e>
    else if (lflag) {
  800348:	18088163          	beqz	a7,8004ca <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  80034c:	000a3603          	ld	a2,0(s4)
  800350:	46a9                	li	a3,10
  800352:	8a2e                	mv	s4,a1
  800354:	bfc1                	j	800324 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  800356:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  80035a:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  80035c:	846a                	mv	s0,s10
            goto reswitch;
  80035e:	bdf1                	j	80023a <vprintfmt+0x6c>
            putch(ch, putdat);
  800360:	85a6                	mv	a1,s1
  800362:	02500513          	li	a0,37
  800366:	9902                	jalr	s2
            break;
  800368:	b545                	j	800208 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  80036a:	00144603          	lbu	a2,1(s0)
            lflag ++;
  80036e:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  800370:	846a                	mv	s0,s10
            goto reswitch;
  800372:	b5e1                	j	80023a <vprintfmt+0x6c>
    if (lflag >= 2) {
  800374:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800376:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  80037a:	01174463          	blt	a4,a7,800382 <vprintfmt+0x1b4>
    else if (lflag) {
  80037e:	14088163          	beqz	a7,8004c0 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800382:	000a3603          	ld	a2,0(s4)
  800386:	46a1                	li	a3,8
  800388:	8a2e                	mv	s4,a1
  80038a:	bf69                	j	800324 <vprintfmt+0x156>
            putch('0', putdat);
  80038c:	03000513          	li	a0,48
  800390:	85a6                	mv	a1,s1
  800392:	e03e                	sd	a5,0(sp)
  800394:	9902                	jalr	s2
            putch('x', putdat);
  800396:	85a6                	mv	a1,s1
  800398:	07800513          	li	a0,120
  80039c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80039e:	0a21                	addi	s4,s4,8
            goto number;
  8003a0:	6782                	ld	a5,0(sp)
  8003a2:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8003a4:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  8003a8:	bfb5                	j	800324 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003aa:	000a3403          	ld	s0,0(s4)
  8003ae:	008a0713          	addi	a4,s4,8
  8003b2:	e03a                	sd	a4,0(sp)
  8003b4:	14040263          	beqz	s0,8004f8 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  8003b8:	0fb05763          	blez	s11,8004a6 <vprintfmt+0x2d8>
  8003bc:	02d00693          	li	a3,45
  8003c0:	0cd79163          	bne	a5,a3,800482 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003c4:	00044783          	lbu	a5,0(s0)
  8003c8:	0007851b          	sext.w	a0,a5
  8003cc:	cf85                	beqz	a5,800404 <vprintfmt+0x236>
  8003ce:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003d2:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003d6:	000c4563          	bltz	s8,8003e0 <vprintfmt+0x212>
  8003da:	3c7d                	addiw	s8,s8,-1
  8003dc:	036c0263          	beq	s8,s6,800400 <vprintfmt+0x232>
                    putch('?', putdat);
  8003e0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003e2:	0e0c8e63          	beqz	s9,8004de <vprintfmt+0x310>
  8003e6:	3781                	addiw	a5,a5,-32
  8003e8:	0ef47b63          	bgeu	s0,a5,8004de <vprintfmt+0x310>
                    putch('?', putdat);
  8003ec:	03f00513          	li	a0,63
  8003f0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003f2:	000a4783          	lbu	a5,0(s4)
  8003f6:	3dfd                	addiw	s11,s11,-1
  8003f8:	0a05                	addi	s4,s4,1
  8003fa:	0007851b          	sext.w	a0,a5
  8003fe:	ffe1                	bnez	a5,8003d6 <vprintfmt+0x208>
            for (; width > 0; width --) {
  800400:	01b05963          	blez	s11,800412 <vprintfmt+0x244>
  800404:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  800406:	85a6                	mv	a1,s1
  800408:	02000513          	li	a0,32
  80040c:	9902                	jalr	s2
            for (; width > 0; width --) {
  80040e:	fe0d9be3          	bnez	s11,800404 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  800412:	6a02                	ld	s4,0(sp)
  800414:	bbd5                	j	800208 <vprintfmt+0x3a>
    if (lflag >= 2) {
  800416:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800418:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  80041c:	01174463          	blt	a4,a7,800424 <vprintfmt+0x256>
    else if (lflag) {
  800420:	08088d63          	beqz	a7,8004ba <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  800424:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800428:	0a044d63          	bltz	s0,8004e2 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  80042c:	8622                	mv	a2,s0
  80042e:	8a66                	mv	s4,s9
  800430:	46a9                	li	a3,10
  800432:	bdcd                	j	800324 <vprintfmt+0x156>
            err = va_arg(ap, int);
  800434:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800438:	4761                	li	a4,24
            err = va_arg(ap, int);
  80043a:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80043c:	41f7d69b          	sraiw	a3,a5,0x1f
  800440:	8fb5                	xor	a5,a5,a3
  800442:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800446:	02d74163          	blt	a4,a3,800468 <vprintfmt+0x29a>
  80044a:	00369793          	slli	a5,a3,0x3
  80044e:	97de                	add	a5,a5,s7
  800450:	639c                	ld	a5,0(a5)
  800452:	cb99                	beqz	a5,800468 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  800454:	86be                	mv	a3,a5
  800456:	00000617          	auipc	a2,0x0
  80045a:	2ca60613          	addi	a2,a2,714 # 800720 <main+0x1a2>
  80045e:	85a6                	mv	a1,s1
  800460:	854a                	mv	a0,s2
  800462:	0ce000ef          	jal	ra,800530 <printfmt>
  800466:	b34d                	j	800208 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800468:	00000617          	auipc	a2,0x0
  80046c:	2a860613          	addi	a2,a2,680 # 800710 <main+0x192>
  800470:	85a6                	mv	a1,s1
  800472:	854a                	mv	a0,s2
  800474:	0bc000ef          	jal	ra,800530 <printfmt>
  800478:	bb41                	j	800208 <vprintfmt+0x3a>
                p = "(null)";
  80047a:	00000417          	auipc	s0,0x0
  80047e:	28e40413          	addi	s0,s0,654 # 800708 <main+0x18a>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800482:	85e2                	mv	a1,s8
  800484:	8522                	mv	a0,s0
  800486:	e43e                	sd	a5,8(sp)
  800488:	0c8000ef          	jal	ra,800550 <strnlen>
  80048c:	40ad8dbb          	subw	s11,s11,a0
  800490:	01b05b63          	blez	s11,8004a6 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  800494:	67a2                	ld	a5,8(sp)
  800496:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  80049a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  80049c:	85a6                	mv	a1,s1
  80049e:	8552                	mv	a0,s4
  8004a0:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004a2:	fe0d9ce3          	bnez	s11,80049a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004a6:	00044783          	lbu	a5,0(s0)
  8004aa:	00140a13          	addi	s4,s0,1
  8004ae:	0007851b          	sext.w	a0,a5
  8004b2:	d3a5                	beqz	a5,800412 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004b4:	05e00413          	li	s0,94
  8004b8:	bf39                	j	8003d6 <vprintfmt+0x208>
        return va_arg(*ap, int);
  8004ba:	000a2403          	lw	s0,0(s4)
  8004be:	b7ad                	j	800428 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  8004c0:	000a6603          	lwu	a2,0(s4)
  8004c4:	46a1                	li	a3,8
  8004c6:	8a2e                	mv	s4,a1
  8004c8:	bdb1                	j	800324 <vprintfmt+0x156>
  8004ca:	000a6603          	lwu	a2,0(s4)
  8004ce:	46a9                	li	a3,10
  8004d0:	8a2e                	mv	s4,a1
  8004d2:	bd89                	j	800324 <vprintfmt+0x156>
  8004d4:	000a6603          	lwu	a2,0(s4)
  8004d8:	46c1                	li	a3,16
  8004da:	8a2e                	mv	s4,a1
  8004dc:	b5a1                	j	800324 <vprintfmt+0x156>
                    putch(ch, putdat);
  8004de:	9902                	jalr	s2
  8004e0:	bf09                	j	8003f2 <vprintfmt+0x224>
                putch('-', putdat);
  8004e2:	85a6                	mv	a1,s1
  8004e4:	02d00513          	li	a0,45
  8004e8:	e03e                	sd	a5,0(sp)
  8004ea:	9902                	jalr	s2
                num = -(long long)num;
  8004ec:	6782                	ld	a5,0(sp)
  8004ee:	8a66                	mv	s4,s9
  8004f0:	40800633          	neg	a2,s0
  8004f4:	46a9                	li	a3,10
  8004f6:	b53d                	j	800324 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  8004f8:	03b05163          	blez	s11,80051a <vprintfmt+0x34c>
  8004fc:	02d00693          	li	a3,45
  800500:	f6d79de3          	bne	a5,a3,80047a <vprintfmt+0x2ac>
                p = "(null)";
  800504:	00000417          	auipc	s0,0x0
  800508:	20440413          	addi	s0,s0,516 # 800708 <main+0x18a>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80050c:	02800793          	li	a5,40
  800510:	02800513          	li	a0,40
  800514:	00140a13          	addi	s4,s0,1
  800518:	bd6d                	j	8003d2 <vprintfmt+0x204>
  80051a:	00000a17          	auipc	s4,0x0
  80051e:	1efa0a13          	addi	s4,s4,495 # 800709 <main+0x18b>
  800522:	02800513          	li	a0,40
  800526:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  80052a:	05e00413          	li	s0,94
  80052e:	b565                	j	8003d6 <vprintfmt+0x208>

0000000000800530 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800530:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  800532:	02810313          	addi	t1,sp,40
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
  800546:	c89ff0ef          	jal	ra,8001ce <vprintfmt>
}
  80054a:	60e2                	ld	ra,24(sp)
  80054c:	6161                	addi	sp,sp,80
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
  800556:	0785                	addi	a5,a5,1
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
  800572:	0785                	addi	a5,a5,1
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
  80057e:	715d                	addi	sp,sp,-80
     int i,time;
     memset(pids, 0, sizeof(pids));
  800580:	00001517          	auipc	a0,0x1
  800584:	a9850513          	addi	a0,a0,-1384 # 801018 <pids>
main(void) {
  800588:	fc26                	sd	s1,56(sp)
  80058a:	ec56                	sd	s5,24(sp)
  80058c:	84aa                	mv	s1,a0
     memset(pids, 0, sizeof(pids));
  80058e:	4651                	li	a2,20
  800590:	4581                	li	a1,0
  800592:	00001a97          	auipc	s5,0x1
  800596:	a6ea8a93          	addi	s5,s5,-1426 # 801000 <acc>
main(void) {
  80059a:	e0a2                	sd	s0,64(sp)
  80059c:	f84a                	sd	s2,48(sp)
  80059e:	f44e                	sd	s3,40(sp)
  8005a0:	f052                	sd	s4,32(sp)
  8005a2:	e486                	sd	ra,72(sp)
  8005a4:	89d6                	mv	s3,s5
     memset(pids, 0, sizeof(pids));
  8005a6:	fc7ff0ef          	jal	ra,80056c <memset>
  8005aa:	8926                	mv	s2,s1

     for (i = 0; i < TOTAL; i ++) {
  8005ac:	4401                	li	s0,0
  8005ae:	4a15                	li	s4,5
          acc[i]=0;
  8005b0:	0009a023          	sw	zero,0(s3)
          if ((pids[i] = fork()) == 0) {
  8005b4:	b99ff0ef          	jal	ra,80014c <fork>
  8005b8:	00a92023          	sw	a0,0(s2)
  8005bc:	c125                	beqz	a0,80061c <main+0x9e>
                            exit(acc[i]);
                        }
                    }
               }
          }
          if (pids[i] < 0) {
  8005be:	0c054063          	bltz	a0,80067e <main+0x100>
     for (i = 0; i < TOTAL; i ++) {
  8005c2:	2405                	addiw	s0,s0,1
  8005c4:	0991                	addi	s3,s3,4
  8005c6:	0911                	addi	s2,s2,4
  8005c8:	ff4414e3          	bne	s0,s4,8005b0 <main+0x32>
               goto failed;
          }
     }

     cprintf("main: fork ok,now need to wait pids.\n");
  8005cc:	00000517          	auipc	a0,0x0
  8005d0:	45c50513          	addi	a0,a0,1116 # 800a28 <error_string+0xe8>
  8005d4:	acfff0ef          	jal	ra,8000a2 <cprintf>

     for (i = 0; i < TOTAL; i ++) {
  8005d8:	00001417          	auipc	s0,0x1
  8005dc:	a5840413          	addi	s0,s0,-1448 # 801030 <status>
  8005e0:	00001917          	auipc	s2,0x1
  8005e4:	a6490913          	addi	s2,s2,-1436 # 801044 <status+0x14>
         status[i]=0;
         waitpid(pids[i],&status[i]);
  8005e8:	4088                	lw	a0,0(s1)
         status[i]=0;
  8005ea:	00042023          	sw	zero,0(s0)
         waitpid(pids[i],&status[i]);
  8005ee:	85a2                	mv	a1,s0
     for (i = 0; i < TOTAL; i ++) {
  8005f0:	0411                	addi	s0,s0,4
         waitpid(pids[i],&status[i]);
  8005f2:	b5dff0ef          	jal	ra,80014e <waitpid>
     for (i = 0; i < TOTAL; i ++) {
  8005f6:	0491                	addi	s1,s1,4
  8005f8:	ff2418e3          	bne	s0,s2,8005e8 <main+0x6a>
         //cprintf("main: pid %d, acc %d, time %d\n",pids[i],status[i],gettime_msec()); 
     }
     cprintf("main: wait pids over\n");
  8005fc:	00000517          	auipc	a0,0x0
  800600:	45450513          	addi	a0,a0,1108 # 800a50 <error_string+0x110>
  800604:	a9fff0ef          	jal	ra,8000a2 <cprintf>
          if (pids[i] > 0) {
               kill(pids[i]);
          }
     }
     panic("FAIL: T.T\n");
}
  800608:	60a6                	ld	ra,72(sp)
  80060a:	6406                	ld	s0,64(sp)
  80060c:	74e2                	ld	s1,56(sp)
  80060e:	7942                	ld	s2,48(sp)
  800610:	79a2                	ld	s3,40(sp)
  800612:	7a02                	ld	s4,32(sp)
  800614:	6ae2                	ld	s5,24(sp)
  800616:	4501                	li	a0,0
  800618:	6161                	addi	sp,sp,80
  80061a:	8082                	ret
               acc[i] = 0;
  80061c:	040a                	slli	s0,s0,0x2
  80061e:	9456                	add	s0,s0,s5
                    if(acc[i]%4000==0) {
  800620:	6485                	lui	s1,0x1
                        if((time=gettime_msec())>MAX_TIME) {
  800622:	6989                	lui	s3,0x2
               acc[i] = 0;
  800624:	00042023          	sw	zero,0(s0)
                    if(acc[i]%4000==0) {
  800628:	fa04849b          	addiw	s1,s1,-96
                        if((time=gettime_msec())>MAX_TIME) {
  80062c:	71098993          	addi	s3,s3,1808 # 2710 <_start-0x7fd910>
  800630:	4014                	lw	a3,0(s0)
  800632:	2685                	addiw	a3,a3,1
     for (i = 0; i != 200; ++ i)
  800634:	0c800713          	li	a4,200
          j = !j;
  800638:	47b2                	lw	a5,12(sp)
     for (i = 0; i != 200; ++ i)
  80063a:	377d                	addiw	a4,a4,-1
          j = !j;
  80063c:	2781                	sext.w	a5,a5
  80063e:	0017b793          	seqz	a5,a5
  800642:	c63e                	sw	a5,12(sp)
     for (i = 0; i != 200; ++ i)
  800644:	fb75                	bnez	a4,800638 <main+0xba>
                    if(acc[i]%4000==0) {
  800646:	0296f7bb          	remuw	a5,a3,s1
  80064a:	0016871b          	addiw	a4,a3,1
  80064e:	c399                	beqz	a5,800654 <main+0xd6>
  800650:	86ba                	mv	a3,a4
  800652:	b7cd                	j	800634 <main+0xb6>
  800654:	c014                	sw	a3,0(s0)
                        if((time=gettime_msec())>MAX_TIME) {
  800656:	affff0ef          	jal	ra,800154 <gettime_msec>
  80065a:	0005091b          	sext.w	s2,a0
  80065e:	fd29d9e3          	bge	s3,s2,800630 <main+0xb2>
                            cprintf("child pid %d, acc %d, time %d\n",getpid(),acc[i],time);
  800662:	af1ff0ef          	jal	ra,800152 <getpid>
  800666:	4010                	lw	a2,0(s0)
  800668:	85aa                	mv	a1,a0
  80066a:	86ca                	mv	a3,s2
  80066c:	00000517          	auipc	a0,0x0
  800670:	39c50513          	addi	a0,a0,924 # 800a08 <error_string+0xc8>
  800674:	a2fff0ef          	jal	ra,8000a2 <cprintf>
                            exit(acc[i]);
  800678:	4008                	lw	a0,0(s0)
  80067a:	abdff0ef          	jal	ra,800136 <exit>
  80067e:	00001417          	auipc	s0,0x1
  800682:	9ae40413          	addi	s0,s0,-1618 # 80102c <pids+0x14>
          if (pids[i] > 0) {
  800686:	4088                	lw	a0,0(s1)
  800688:	00a05463          	blez	a0,800690 <main+0x112>
               kill(pids[i]);
  80068c:	ac5ff0ef          	jal	ra,800150 <kill>
     for (i = 0; i < TOTAL; i ++) {
  800690:	0491                	addi	s1,s1,4
  800692:	fe849ae3          	bne	s1,s0,800686 <main+0x108>
     panic("FAIL: T.T\n");
  800696:	00000617          	auipc	a2,0x0
  80069a:	3d260613          	addi	a2,a2,978 # 800a68 <error_string+0x128>
  80069e:	04100593          	li	a1,65
  8006a2:	00000517          	auipc	a0,0x0
  8006a6:	3d650513          	addi	a0,a0,982 # 800a78 <error_string+0x138>
  8006aa:	97dff0ef          	jal	ra,800026 <__panic>
