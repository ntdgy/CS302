
obj/__user_forktest.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	126000ef          	jal	800146 <umain>
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
  80003a:	5da50513          	add	a0,a0,1498 # 800610 <main+0xb8>
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
  80005a:	5da50513          	add	a0,a0,1498 # 800630 <main+0xd8>
  80005e:	044000ef          	jal	8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0c4000ef          	jal	800128 <exit>

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
  800070:	0b2000ef          	jal	800122 <sys_putc>
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
  800096:	12a000ef          	jal	8001c0 <vprintfmt>
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
  8000cc:	0f4000ef          	jal	8001c0 <vprintfmt>
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

0000000000800122 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  800122:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  800124:	4579                	li	a0,30
  800126:	bf4d                	j	8000d8 <syscall>

0000000000800128 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  800128:	1141                	add	sp,sp,-16
  80012a:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  80012c:	fe5ff0ef          	jal	800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800130:	00000517          	auipc	a0,0x0
  800134:	50850513          	add	a0,a0,1288 # 800638 <main+0xe0>
  800138:	f6bff0ef          	jal	8000a2 <cprintf>
    while (1);
  80013c:	a001                	j	80013c <exit+0x14>

000000000080013e <fork>:
}

int
fork(void) {
    return sys_fork();
  80013e:	bfe1                	j	800116 <sys_fork>

0000000000800140 <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  800140:	4581                	li	a1,0
  800142:	4501                	li	a0,0
  800144:	bfd9                	j	80011a <sys_wait>

0000000000800146 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800146:	1141                	add	sp,sp,-16
  800148:	e406                	sd	ra,8(sp)
    int ret = main();
  80014a:	40e000ef          	jal	800558 <main>
    exit(ret);
  80014e:	fdbff0ef          	jal	800128 <exit>

0000000000800152 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800152:	02069813          	sll	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800156:	7179                	add	sp,sp,-48
    unsigned mod = do_div(result, base);
  800158:	02085813          	srl	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  80015c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  80015e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  800162:	f022                	sd	s0,32(sp)
  800164:	ec26                	sd	s1,24(sp)
  800166:	e84a                	sd	s2,16(sp)
  800168:	f406                	sd	ra,40(sp)
  80016a:	e44e                	sd	s3,8(sp)
  80016c:	84aa                	mv	s1,a0
  80016e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800170:	fff7041b          	addw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800174:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800176:	03067f63          	bgeu	a2,a6,8001b4 <printnum+0x62>
  80017a:	89be                	mv	s3,a5
        while (-- width > 0)
  80017c:	4785                	li	a5,1
  80017e:	00e7d763          	bge	a5,a4,80018c <printnum+0x3a>
  800182:	347d                	addw	s0,s0,-1
            putch(padc, putdat);
  800184:	85ca                	mv	a1,s2
  800186:	854e                	mv	a0,s3
  800188:	9482                	jalr	s1
        while (-- width > 0)
  80018a:	fc65                	bnez	s0,800182 <printnum+0x30>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80018c:	1a02                	sll	s4,s4,0x20
  80018e:	020a5a13          	srl	s4,s4,0x20
  800192:	00000797          	auipc	a5,0x0
  800196:	4be78793          	add	a5,a5,1214 # 800650 <main+0xf8>
  80019a:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80019c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  80019e:	0007c503          	lbu	a0,0(a5)
}
  8001a2:	70a2                	ld	ra,40(sp)
  8001a4:	69a2                	ld	s3,8(sp)
  8001a6:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001a8:	85ca                	mv	a1,s2
  8001aa:	87a6                	mv	a5,s1
}
  8001ac:	6942                	ld	s2,16(sp)
  8001ae:	64e2                	ld	s1,24(sp)
  8001b0:	6145                	add	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001b2:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001b4:	03065633          	divu	a2,a2,a6
  8001b8:	8722                	mv	a4,s0
  8001ba:	f99ff0ef          	jal	800152 <printnum>
  8001be:	b7f9                	j	80018c <printnum+0x3a>

00000000008001c0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001c0:	7119                	add	sp,sp,-128
  8001c2:	f4a6                	sd	s1,104(sp)
  8001c4:	f0ca                	sd	s2,96(sp)
  8001c6:	ecce                	sd	s3,88(sp)
  8001c8:	e8d2                	sd	s4,80(sp)
  8001ca:	e4d6                	sd	s5,72(sp)
  8001cc:	e0da                	sd	s6,64(sp)
  8001ce:	f862                	sd	s8,48(sp)
  8001d0:	fc86                	sd	ra,120(sp)
  8001d2:	f8a2                	sd	s0,112(sp)
  8001d4:	fc5e                	sd	s7,56(sp)
  8001d6:	f466                	sd	s9,40(sp)
  8001d8:	f06a                	sd	s10,32(sp)
  8001da:	ec6e                	sd	s11,24(sp)
  8001dc:	892a                	mv	s2,a0
  8001de:	84ae                	mv	s1,a1
  8001e0:	8c32                	mv	s8,a2
  8001e2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001e4:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  8001e8:	05500b13          	li	s6,85
  8001ec:	00000a97          	auipc	s5,0x0
  8001f0:	498a8a93          	add	s5,s5,1176 # 800684 <main+0x12c>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001f4:	000c4503          	lbu	a0,0(s8)
  8001f8:	001c0413          	add	s0,s8,1
  8001fc:	01350a63          	beq	a0,s3,800210 <vprintfmt+0x50>
            if (ch == '\0') {
  800200:	cd0d                	beqz	a0,80023a <vprintfmt+0x7a>
            putch(ch, putdat);
  800202:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800204:	0405                	add	s0,s0,1
            putch(ch, putdat);
  800206:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800208:	fff44503          	lbu	a0,-1(s0)
  80020c:	ff351ae3          	bne	a0,s3,800200 <vprintfmt+0x40>
        char padc = ' ';
  800210:	02000d93          	li	s11,32
        lflag = altflag = 0;
  800214:	4b81                	li	s7,0
  800216:	4601                	li	a2,0
        width = precision = -1;
  800218:	5d7d                	li	s10,-1
  80021a:	5cfd                	li	s9,-1
        switch (ch = *(unsigned char *)fmt ++) {
  80021c:	00044683          	lbu	a3,0(s0)
  800220:	00140c13          	add	s8,s0,1
  800224:	fdd6859b          	addw	a1,a3,-35
  800228:	0ff5f593          	zext.b	a1,a1
  80022c:	02bb6663          	bltu	s6,a1,800258 <vprintfmt+0x98>
  800230:	058a                	sll	a1,a1,0x2
  800232:	95d6                	add	a1,a1,s5
  800234:	4198                	lw	a4,0(a1)
  800236:	9756                	add	a4,a4,s5
  800238:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80023a:	70e6                	ld	ra,120(sp)
  80023c:	7446                	ld	s0,112(sp)
  80023e:	74a6                	ld	s1,104(sp)
  800240:	7906                	ld	s2,96(sp)
  800242:	69e6                	ld	s3,88(sp)
  800244:	6a46                	ld	s4,80(sp)
  800246:	6aa6                	ld	s5,72(sp)
  800248:	6b06                	ld	s6,64(sp)
  80024a:	7be2                	ld	s7,56(sp)
  80024c:	7c42                	ld	s8,48(sp)
  80024e:	7ca2                	ld	s9,40(sp)
  800250:	7d02                	ld	s10,32(sp)
  800252:	6de2                	ld	s11,24(sp)
  800254:	6109                	add	sp,sp,128
  800256:	8082                	ret
            putch('%', putdat);
  800258:	85a6                	mv	a1,s1
  80025a:	02500513          	li	a0,37
  80025e:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800260:	fff44703          	lbu	a4,-1(s0)
  800264:	02500793          	li	a5,37
  800268:	8c22                	mv	s8,s0
  80026a:	f8f705e3          	beq	a4,a5,8001f4 <vprintfmt+0x34>
  80026e:	02500713          	li	a4,37
  800272:	ffec4783          	lbu	a5,-2(s8)
  800276:	1c7d                	add	s8,s8,-1
  800278:	fee79de3          	bne	a5,a4,800272 <vprintfmt+0xb2>
  80027c:	bfa5                	j	8001f4 <vprintfmt+0x34>
                ch = *fmt;
  80027e:	00144783          	lbu	a5,1(s0)
                if (ch < '0' || ch > '9') {
  800282:	4725                	li	a4,9
                precision = precision * 10 + ch - '0';
  800284:	fd068d1b          	addw	s10,a3,-48
                if (ch < '0' || ch > '9') {
  800288:	fd07859b          	addw	a1,a5,-48
                ch = *fmt;
  80028c:	0007869b          	sext.w	a3,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800290:	8462                	mv	s0,s8
                if (ch < '0' || ch > '9') {
  800292:	02b76563          	bltu	a4,a1,8002bc <vprintfmt+0xfc>
  800296:	4525                	li	a0,9
                ch = *fmt;
  800298:	00144783          	lbu	a5,1(s0)
                precision = precision * 10 + ch - '0';
  80029c:	002d171b          	sllw	a4,s10,0x2
  8002a0:	01a7073b          	addw	a4,a4,s10
  8002a4:	0017171b          	sllw	a4,a4,0x1
  8002a8:	9f35                	addw	a4,a4,a3
                if (ch < '0' || ch > '9') {
  8002aa:	fd07859b          	addw	a1,a5,-48
            for (precision = 0; ; ++ fmt) {
  8002ae:	0405                	add	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002b0:	fd070d1b          	addw	s10,a4,-48
                ch = *fmt;
  8002b4:	0007869b          	sext.w	a3,a5
                if (ch < '0' || ch > '9') {
  8002b8:	feb570e3          	bgeu	a0,a1,800298 <vprintfmt+0xd8>
            if (width < 0)
  8002bc:	f60cd0e3          	bgez	s9,80021c <vprintfmt+0x5c>
                width = precision, precision = -1;
  8002c0:	8cea                	mv	s9,s10
  8002c2:	5d7d                	li	s10,-1
  8002c4:	bfa1                	j	80021c <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
  8002c6:	8db6                	mv	s11,a3
  8002c8:	8462                	mv	s0,s8
  8002ca:	bf89                	j	80021c <vprintfmt+0x5c>
  8002cc:	8462                	mv	s0,s8
            altflag = 1;
  8002ce:	4b85                	li	s7,1
            goto reswitch;
  8002d0:	b7b1                	j	80021c <vprintfmt+0x5c>
    if (lflag >= 2) {
  8002d2:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8002d4:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  8002d8:	00c7c463          	blt	a5,a2,8002e0 <vprintfmt+0x120>
    else if (lflag) {
  8002dc:	1a060263          	beqz	a2,800480 <vprintfmt+0x2c0>
        return va_arg(*ap, unsigned long);
  8002e0:	000a3603          	ld	a2,0(s4)
  8002e4:	46c1                	li	a3,16
  8002e6:	8a3a                	mv	s4,a4
            printnum(putch, putdat, num, base, width, padc);
  8002e8:	000d879b          	sext.w	a5,s11
  8002ec:	8766                	mv	a4,s9
  8002ee:	85a6                	mv	a1,s1
  8002f0:	854a                	mv	a0,s2
  8002f2:	e61ff0ef          	jal	800152 <printnum>
            break;
  8002f6:	bdfd                	j	8001f4 <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
  8002f8:	000a2503          	lw	a0,0(s4)
  8002fc:	85a6                	mv	a1,s1
  8002fe:	0a21                	add	s4,s4,8
  800300:	9902                	jalr	s2
            break;
  800302:	bdcd                	j	8001f4 <vprintfmt+0x34>
    if (lflag >= 2) {
  800304:	4785                	li	a5,1
            precision = va_arg(ap, int);
  800306:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  80030a:	00c7c463          	blt	a5,a2,800312 <vprintfmt+0x152>
    else if (lflag) {
  80030e:	16060463          	beqz	a2,800476 <vprintfmt+0x2b6>
        return va_arg(*ap, unsigned long);
  800312:	000a3603          	ld	a2,0(s4)
  800316:	46a9                	li	a3,10
  800318:	8a3a                	mv	s4,a4
  80031a:	b7f9                	j	8002e8 <vprintfmt+0x128>
            putch('0', putdat);
  80031c:	03000513          	li	a0,48
  800320:	85a6                	mv	a1,s1
  800322:	9902                	jalr	s2
            putch('x', putdat);
  800324:	85a6                	mv	a1,s1
  800326:	07800513          	li	a0,120
  80032a:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80032c:	0a21                	add	s4,s4,8
            goto number;
  80032e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800330:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800334:	bf55                	j	8002e8 <vprintfmt+0x128>
            putch(ch, putdat);
  800336:	85a6                	mv	a1,s1
  800338:	02500513          	li	a0,37
  80033c:	9902                	jalr	s2
            break;
  80033e:	bd5d                	j	8001f4 <vprintfmt+0x34>
            precision = va_arg(ap, int);
  800340:	000a2d03          	lw	s10,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800344:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
  800346:	0a21                	add	s4,s4,8
            goto process_precision;
  800348:	bf95                	j	8002bc <vprintfmt+0xfc>
    if (lflag >= 2) {
  80034a:	4785                	li	a5,1
            precision = va_arg(ap, int);
  80034c:	008a0713          	add	a4,s4,8
    if (lflag >= 2) {
  800350:	00c7c463          	blt	a5,a2,800358 <vprintfmt+0x198>
    else if (lflag) {
  800354:	10060c63          	beqz	a2,80046c <vprintfmt+0x2ac>
        return va_arg(*ap, unsigned long);
  800358:	000a3603          	ld	a2,0(s4)
  80035c:	46a1                	li	a3,8
  80035e:	8a3a                	mv	s4,a4
  800360:	b761                	j	8002e8 <vprintfmt+0x128>
            if (width < 0)
  800362:	fffcc793          	not	a5,s9
  800366:	97fd                	sra	a5,a5,0x3f
  800368:	00fcf7b3          	and	a5,s9,a5
  80036c:	00078c9b          	sext.w	s9,a5
        switch (ch = *(unsigned char *)fmt ++) {
  800370:	8462                	mv	s0,s8
            goto reswitch;
  800372:	b56d                	j	80021c <vprintfmt+0x5c>
            if ((p = va_arg(ap, char *)) == NULL) {
  800374:	000a3403          	ld	s0,0(s4)
  800378:	008a0793          	add	a5,s4,8
  80037c:	e43e                	sd	a5,8(sp)
  80037e:	12040163          	beqz	s0,8004a0 <vprintfmt+0x2e0>
            if (width > 0 && padc != '-') {
  800382:	0d905963          	blez	s9,800454 <vprintfmt+0x294>
  800386:	02d00793          	li	a5,45
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80038a:	00140a13          	add	s4,s0,1
            if (width > 0 && padc != '-') {
  80038e:	12fd9863          	bne	s11,a5,8004be <vprintfmt+0x2fe>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800392:	00044783          	lbu	a5,0(s0)
  800396:	0007851b          	sext.w	a0,a5
  80039a:	cb9d                	beqz	a5,8003d0 <vprintfmt+0x210>
  80039c:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  80039e:	05e00d93          	li	s11,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003a2:	000d4563          	bltz	s10,8003ac <vprintfmt+0x1ec>
  8003a6:	3d7d                	addw	s10,s10,-1
  8003a8:	028d0263          	beq	s10,s0,8003cc <vprintfmt+0x20c>
                    putch('?', putdat);
  8003ac:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003ae:	0c0b8e63          	beqz	s7,80048a <vprintfmt+0x2ca>
  8003b2:	3781                	addw	a5,a5,-32
  8003b4:	0cfdfb63          	bgeu	s11,a5,80048a <vprintfmt+0x2ca>
                    putch('?', putdat);
  8003b8:	03f00513          	li	a0,63
  8003bc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003be:	000a4783          	lbu	a5,0(s4)
  8003c2:	3cfd                	addw	s9,s9,-1
  8003c4:	0a05                	add	s4,s4,1
  8003c6:	0007851b          	sext.w	a0,a5
  8003ca:	ffe1                	bnez	a5,8003a2 <vprintfmt+0x1e2>
            for (; width > 0; width --) {
  8003cc:	01905963          	blez	s9,8003de <vprintfmt+0x21e>
  8003d0:	3cfd                	addw	s9,s9,-1
                putch(' ', putdat);
  8003d2:	85a6                	mv	a1,s1
  8003d4:	02000513          	li	a0,32
  8003d8:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003da:	fe0c9be3          	bnez	s9,8003d0 <vprintfmt+0x210>
            if ((p = va_arg(ap, char *)) == NULL) {
  8003de:	6a22                	ld	s4,8(sp)
  8003e0:	bd11                	j	8001f4 <vprintfmt+0x34>
    if (lflag >= 2) {
  8003e2:	4785                	li	a5,1
            precision = va_arg(ap, int);
  8003e4:	008a0b93          	add	s7,s4,8
    if (lflag >= 2) {
  8003e8:	00c7c363          	blt	a5,a2,8003ee <vprintfmt+0x22e>
    else if (lflag) {
  8003ec:	ce2d                	beqz	a2,800466 <vprintfmt+0x2a6>
        return va_arg(*ap, long);
  8003ee:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003f2:	08044e63          	bltz	s0,80048e <vprintfmt+0x2ce>
            num = getint(&ap, lflag);
  8003f6:	8622                	mv	a2,s0
  8003f8:	8a5e                	mv	s4,s7
  8003fa:	46a9                	li	a3,10
  8003fc:	b5f5                	j	8002e8 <vprintfmt+0x128>
            if (err < 0) {
  8003fe:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800402:	4661                	li	a2,24
            if (err < 0) {
  800404:	41f7d71b          	sraw	a4,a5,0x1f
  800408:	8fb9                	xor	a5,a5,a4
  80040a:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80040e:	02d64663          	blt	a2,a3,80043a <vprintfmt+0x27a>
  800412:	00369713          	sll	a4,a3,0x3
  800416:	00000797          	auipc	a5,0x0
  80041a:	48a78793          	add	a5,a5,1162 # 8008a0 <error_string>
  80041e:	97ba                	add	a5,a5,a4
  800420:	639c                	ld	a5,0(a5)
  800422:	cf81                	beqz	a5,80043a <vprintfmt+0x27a>
                printfmt(putch, putdat, "%s", p);
  800424:	86be                	mv	a3,a5
  800426:	00000617          	auipc	a2,0x0
  80042a:	25a60613          	add	a2,a2,602 # 800680 <main+0x128>
  80042e:	85a6                	mv	a1,s1
  800430:	854a                	mv	a0,s2
  800432:	0ea000ef          	jal	80051c <printfmt>
            err = va_arg(ap, int);
  800436:	0a21                	add	s4,s4,8
  800438:	bb75                	j	8001f4 <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
  80043a:	00000617          	auipc	a2,0x0
  80043e:	23660613          	add	a2,a2,566 # 800670 <main+0x118>
  800442:	85a6                	mv	a1,s1
  800444:	854a                	mv	a0,s2
  800446:	0d6000ef          	jal	80051c <printfmt>
            err = va_arg(ap, int);
  80044a:	0a21                	add	s4,s4,8
  80044c:	b365                	j	8001f4 <vprintfmt+0x34>
            lflag ++;
  80044e:	2605                	addw	a2,a2,1
        switch (ch = *(unsigned char *)fmt ++) {
  800450:	8462                	mv	s0,s8
            goto reswitch;
  800452:	b3e9                	j	80021c <vprintfmt+0x5c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800454:	00044783          	lbu	a5,0(s0)
  800458:	00140a13          	add	s4,s0,1
  80045c:	0007851b          	sext.w	a0,a5
  800460:	ff95                	bnez	a5,80039c <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  800462:	6a22                	ld	s4,8(sp)
  800464:	bb41                	j	8001f4 <vprintfmt+0x34>
        return va_arg(*ap, int);
  800466:	000a2403          	lw	s0,0(s4)
  80046a:	b761                	j	8003f2 <vprintfmt+0x232>
        return va_arg(*ap, unsigned int);
  80046c:	000a6603          	lwu	a2,0(s4)
  800470:	46a1                	li	a3,8
  800472:	8a3a                	mv	s4,a4
  800474:	bd95                	j	8002e8 <vprintfmt+0x128>
  800476:	000a6603          	lwu	a2,0(s4)
  80047a:	46a9                	li	a3,10
  80047c:	8a3a                	mv	s4,a4
  80047e:	b5ad                	j	8002e8 <vprintfmt+0x128>
  800480:	000a6603          	lwu	a2,0(s4)
  800484:	46c1                	li	a3,16
  800486:	8a3a                	mv	s4,a4
  800488:	b585                	j	8002e8 <vprintfmt+0x128>
                    putch(ch, putdat);
  80048a:	9902                	jalr	s2
  80048c:	bf0d                	j	8003be <vprintfmt+0x1fe>
                putch('-', putdat);
  80048e:	85a6                	mv	a1,s1
  800490:	02d00513          	li	a0,45
  800494:	9902                	jalr	s2
                num = -(long long)num;
  800496:	8a5e                	mv	s4,s7
  800498:	40800633          	neg	a2,s0
  80049c:	46a9                	li	a3,10
  80049e:	b5a9                	j	8002e8 <vprintfmt+0x128>
            if (width > 0 && padc != '-') {
  8004a0:	01905663          	blez	s9,8004ac <vprintfmt+0x2ec>
  8004a4:	02d00793          	li	a5,45
  8004a8:	04fd9263          	bne	s11,a5,8004ec <vprintfmt+0x32c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004ac:	00000a17          	auipc	s4,0x0
  8004b0:	1bda0a13          	add	s4,s4,445 # 800669 <main+0x111>
  8004b4:	02800513          	li	a0,40
  8004b8:	02800793          	li	a5,40
  8004bc:	b5c5                	j	80039c <vprintfmt+0x1dc>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004be:	85ea                	mv	a1,s10
  8004c0:	8522                	mv	a0,s0
  8004c2:	07a000ef          	jal	80053c <strnlen>
  8004c6:	40ac8cbb          	subw	s9,s9,a0
  8004ca:	01905963          	blez	s9,8004dc <vprintfmt+0x31c>
                    putch(padc, putdat);
  8004ce:	2d81                	sext.w	s11,s11
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004d0:	3cfd                	addw	s9,s9,-1
                    putch(padc, putdat);
  8004d2:	85a6                	mv	a1,s1
  8004d4:	856e                	mv	a0,s11
  8004d6:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004d8:	fe0c9ce3          	bnez	s9,8004d0 <vprintfmt+0x310>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004dc:	00044783          	lbu	a5,0(s0)
  8004e0:	0007851b          	sext.w	a0,a5
  8004e4:	ea079ce3          	bnez	a5,80039c <vprintfmt+0x1dc>
            if ((p = va_arg(ap, char *)) == NULL) {
  8004e8:	6a22                	ld	s4,8(sp)
  8004ea:	b329                	j	8001f4 <vprintfmt+0x34>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8004ec:	85ea                	mv	a1,s10
  8004ee:	00000517          	auipc	a0,0x0
  8004f2:	17a50513          	add	a0,a0,378 # 800668 <main+0x110>
  8004f6:	046000ef          	jal	80053c <strnlen>
  8004fa:	40ac8cbb          	subw	s9,s9,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004fe:	00000a17          	auipc	s4,0x0
  800502:	16ba0a13          	add	s4,s4,363 # 800669 <main+0x111>
                p = "(null)";
  800506:	00000417          	auipc	s0,0x0
  80050a:	16240413          	add	s0,s0,354 # 800668 <main+0x110>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80050e:	02800513          	li	a0,40
  800512:	02800793          	li	a5,40
                for (width -= strnlen(p, precision); width > 0; width --) {
  800516:	fb904ce3          	bgtz	s9,8004ce <vprintfmt+0x30e>
  80051a:	b549                	j	80039c <vprintfmt+0x1dc>

000000000080051c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80051c:	715d                	add	sp,sp,-80
    va_start(ap, fmt);
  80051e:	02810313          	add	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800522:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800524:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800526:	ec06                	sd	ra,24(sp)
  800528:	f83a                	sd	a4,48(sp)
  80052a:	fc3e                	sd	a5,56(sp)
  80052c:	e0c2                	sd	a6,64(sp)
  80052e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800530:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800532:	c8fff0ef          	jal	8001c0 <vprintfmt>
}
  800536:	60e2                	ld	ra,24(sp)
  800538:	6161                	add	sp,sp,80
  80053a:	8082                	ret

000000000080053c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  80053c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  80053e:	e589                	bnez	a1,800548 <strnlen+0xc>
  800540:	a811                	j	800554 <strnlen+0x18>
        cnt ++;
  800542:	0785                	add	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800544:	00f58863          	beq	a1,a5,800554 <strnlen+0x18>
  800548:	00f50733          	add	a4,a0,a5
  80054c:	00074703          	lbu	a4,0(a4)
  800550:	fb6d                	bnez	a4,800542 <strnlen+0x6>
  800552:	85be                	mv	a1,a5
    }
    return cnt;
}
  800554:	852e                	mv	a0,a1
  800556:	8082                	ret

0000000000800558 <main>:
#include <stdio.h>

const int max_child = 32;

int
main(void) {
  800558:	1101                	add	sp,sp,-32
  80055a:	e822                	sd	s0,16(sp)
  80055c:	e426                	sd	s1,8(sp)
  80055e:	ec06                	sd	ra,24(sp)
    int n, pid;
    for (n = 0; n < max_child; n ++) {
  800560:	4401                	li	s0,0
  800562:	02000493          	li	s1,32
        if ((pid = fork()) == 0) {
  800566:	bd9ff0ef          	jal	80013e <fork>
  80056a:	c131                	beqz	a0,8005ae <main+0x56>
            cprintf("I am child %d\n", n);
            exit(0);
        }
        assert(pid > 0);
  80056c:	06a05663          	blez	a0,8005d8 <main+0x80>
    for (n = 0; n < max_child; n ++) {
  800570:	2405                	addw	s0,s0,1
  800572:	fe941ae3          	bne	s0,s1,800566 <main+0xe>
    }

    if (n > max_child) {
        panic("fork claimed to work %d times!\n", n);
    }
    cprintf("fork finished\n");
  800576:	00000517          	auipc	a0,0x0
  80057a:	43250513          	add	a0,a0,1074 # 8009a8 <error_string+0x108>
  80057e:	b25ff0ef          	jal	8000a2 <cprintf>
  800582:	02000413          	li	s0,32
    for (; n > 0; n --) {
        if (wait() != 0) {
  800586:	bbbff0ef          	jal	800140 <wait>
  80058a:	ed05                	bnez	a0,8005c2 <main+0x6a>
    for (; n > 0; n --) {
  80058c:	347d                	addw	s0,s0,-1
  80058e:	fc65                	bnez	s0,800586 <main+0x2e>
            panic("wait stopped early\n");
        }
    }

    if (wait() == 0) {
  800590:	bb1ff0ef          	jal	800140 <wait>
  800594:	c12d                	beqz	a0,8005f6 <main+0x9e>
        panic("wait got too many\n");
    }

    cprintf("forktest pass.\n");
  800596:	00000517          	auipc	a0,0x0
  80059a:	45250513          	add	a0,a0,1106 # 8009e8 <error_string+0x148>
  80059e:	b05ff0ef          	jal	8000a2 <cprintf>
    return 0;
}
  8005a2:	60e2                	ld	ra,24(sp)
  8005a4:	6442                	ld	s0,16(sp)
  8005a6:	64a2                	ld	s1,8(sp)
  8005a8:	4501                	li	a0,0
  8005aa:	6105                	add	sp,sp,32
  8005ac:	8082                	ret
            cprintf("I am child %d\n", n);
  8005ae:	85a2                	mv	a1,s0
  8005b0:	00000517          	auipc	a0,0x0
  8005b4:	3b850513          	add	a0,a0,952 # 800968 <error_string+0xc8>
  8005b8:	aebff0ef          	jal	8000a2 <cprintf>
            exit(0);
  8005bc:	4501                	li	a0,0
  8005be:	b6bff0ef          	jal	800128 <exit>
            panic("wait stopped early\n");
  8005c2:	00000617          	auipc	a2,0x0
  8005c6:	3f660613          	add	a2,a2,1014 # 8009b8 <error_string+0x118>
  8005ca:	45dd                	li	a1,23
  8005cc:	00000517          	auipc	a0,0x0
  8005d0:	3cc50513          	add	a0,a0,972 # 800998 <error_string+0xf8>
  8005d4:	a53ff0ef          	jal	800026 <__panic>
        assert(pid > 0);
  8005d8:	00000697          	auipc	a3,0x0
  8005dc:	3a068693          	add	a3,a3,928 # 800978 <error_string+0xd8>
  8005e0:	00000617          	auipc	a2,0x0
  8005e4:	3a060613          	add	a2,a2,928 # 800980 <error_string+0xe0>
  8005e8:	45b9                	li	a1,14
  8005ea:	00000517          	auipc	a0,0x0
  8005ee:	3ae50513          	add	a0,a0,942 # 800998 <error_string+0xf8>
  8005f2:	a35ff0ef          	jal	800026 <__panic>
        panic("wait got too many\n");
  8005f6:	00000617          	auipc	a2,0x0
  8005fa:	3da60613          	add	a2,a2,986 # 8009d0 <error_string+0x130>
  8005fe:	45f1                	li	a1,28
  800600:	00000517          	auipc	a0,0x0
  800604:	39850513          	add	a0,a0,920 # 800998 <error_string+0xf8>
  800608:	a1fff0ef          	jal	800026 <__panic>
