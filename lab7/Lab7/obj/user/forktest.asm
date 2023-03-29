
obj/__user_forktest.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
    # move down the esp register
    # since it may cause page fault in backtrace
    // subl $0x20, %esp

    # call user-program function
    call umain
  800020:	126000ef          	jal	ra,800146 <umain>
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
  80003a:	5da50513          	addi	a0,a0,1498 # 800610 <main+0xb4>
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
  80005a:	5da50513          	addi	a0,a0,1498 # 800630 <main+0xd4>
  80005e:	044000ef          	jal	ra,8000a2 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800062:	5559                	li	a0,-10
  800064:	0c4000ef          	jal	ra,800128 <exit>

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
  800070:	0b2000ef          	jal	ra,800122 <sys_putc>
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
  800096:	128000ef          	jal	ra,8001be <vprintfmt>
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
  8000cc:	0f2000ef          	jal	ra,8001be <vprintfmt>
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
  800128:	1141                	addi	sp,sp,-16
  80012a:	e406                	sd	ra,8(sp)
    //cprintf("eee\n");
    sys_exit(error_code);
  80012c:	fe5ff0ef          	jal	ra,800110 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800130:	00000517          	auipc	a0,0x0
  800134:	50850513          	addi	a0,a0,1288 # 800638 <main+0xdc>
  800138:	f6bff0ef          	jal	ra,8000a2 <cprintf>
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
  800146:	1141                	addi	sp,sp,-16
  800148:	e406                	sd	ra,8(sp)
    int ret = main();
  80014a:	412000ef          	jal	ra,80055c <main>
    exit(ret);
  80014e:	fdbff0ef          	jal	ra,800128 <exit>

0000000000800152 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  800152:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800156:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  800158:	02085813          	srli	a6,a6,0x20
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
  800170:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800174:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800176:	03067e63          	bgeu	a2,a6,8001b2 <printnum+0x60>
  80017a:	89be                	mv	s3,a5
        while (-- width > 0)
  80017c:	00805763          	blez	s0,80018a <printnum+0x38>
  800180:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800182:	85ca                	mv	a1,s2
  800184:	854e                	mv	a0,s3
  800186:	9482                	jalr	s1
        while (-- width > 0)
  800188:	fc65                	bnez	s0,800180 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80018a:	1a02                	slli	s4,s4,0x20
  80018c:	00000797          	auipc	a5,0x0
  800190:	4c478793          	addi	a5,a5,1220 # 800650 <main+0xf4>
  800194:	020a5a13          	srli	s4,s4,0x20
  800198:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  80019a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  80019c:	000a4503          	lbu	a0,0(s4)
}
  8001a0:	70a2                	ld	ra,40(sp)
  8001a2:	69a2                	ld	s3,8(sp)
  8001a4:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  8001a6:	85ca                	mv	a1,s2
  8001a8:	87a6                	mv	a5,s1
}
  8001aa:	6942                	ld	s2,16(sp)
  8001ac:	64e2                	ld	s1,24(sp)
  8001ae:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  8001b0:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  8001b2:	03065633          	divu	a2,a2,a6
  8001b6:	8722                	mv	a4,s0
  8001b8:	f9bff0ef          	jal	ra,800152 <printnum>
  8001bc:	b7f9                	j	80018a <printnum+0x38>

00000000008001be <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8001be:	7119                	addi	sp,sp,-128
  8001c0:	f4a6                	sd	s1,104(sp)
  8001c2:	f0ca                	sd	s2,96(sp)
  8001c4:	ecce                	sd	s3,88(sp)
  8001c6:	e8d2                	sd	s4,80(sp)
  8001c8:	e4d6                	sd	s5,72(sp)
  8001ca:	e0da                	sd	s6,64(sp)
  8001cc:	fc5e                	sd	s7,56(sp)
  8001ce:	f06a                	sd	s10,32(sp)
  8001d0:	fc86                	sd	ra,120(sp)
  8001d2:	f8a2                	sd	s0,112(sp)
  8001d4:	f862                	sd	s8,48(sp)
  8001d6:	f466                	sd	s9,40(sp)
  8001d8:	ec6e                	sd	s11,24(sp)
  8001da:	892a                	mv	s2,a0
  8001dc:	84ae                	mv	s1,a1
  8001de:	8d32                	mv	s10,a2
  8001e0:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001e2:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  8001e6:	5b7d                	li	s6,-1
  8001e8:	00000a97          	auipc	s5,0x0
  8001ec:	49ca8a93          	addi	s5,s5,1180 # 800684 <main+0x128>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8001f0:	00000b97          	auipc	s7,0x0
  8001f4:	6b0b8b93          	addi	s7,s7,1712 # 8008a0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001f8:	000d4503          	lbu	a0,0(s10)
  8001fc:	001d0413          	addi	s0,s10,1
  800200:	01350a63          	beq	a0,s3,800214 <vprintfmt+0x56>
            if (ch == '\0') {
  800204:	c121                	beqz	a0,800244 <vprintfmt+0x86>
            putch(ch, putdat);
  800206:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800208:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  80020a:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80020c:	fff44503          	lbu	a0,-1(s0)
  800210:	ff351ae3          	bne	a0,s3,800204 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  800214:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  800218:	02000793          	li	a5,32
        lflag = altflag = 0;
  80021c:	4c81                	li	s9,0
  80021e:	4881                	li	a7,0
        width = precision = -1;
  800220:	5c7d                	li	s8,-1
  800222:	5dfd                	li	s11,-1
  800224:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  800228:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  80022a:	fdd6059b          	addiw	a1,a2,-35
  80022e:	0ff5f593          	andi	a1,a1,255
  800232:	00140d13          	addi	s10,s0,1
  800236:	04b56263          	bltu	a0,a1,80027a <vprintfmt+0xbc>
  80023a:	058a                	slli	a1,a1,0x2
  80023c:	95d6                	add	a1,a1,s5
  80023e:	4194                	lw	a3,0(a1)
  800240:	96d6                	add	a3,a3,s5
  800242:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800244:	70e6                	ld	ra,120(sp)
  800246:	7446                	ld	s0,112(sp)
  800248:	74a6                	ld	s1,104(sp)
  80024a:	7906                	ld	s2,96(sp)
  80024c:	69e6                	ld	s3,88(sp)
  80024e:	6a46                	ld	s4,80(sp)
  800250:	6aa6                	ld	s5,72(sp)
  800252:	6b06                	ld	s6,64(sp)
  800254:	7be2                	ld	s7,56(sp)
  800256:	7c42                	ld	s8,48(sp)
  800258:	7ca2                	ld	s9,40(sp)
  80025a:	7d02                	ld	s10,32(sp)
  80025c:	6de2                	ld	s11,24(sp)
  80025e:	6109                	addi	sp,sp,128
  800260:	8082                	ret
            padc = '0';
  800262:	87b2                	mv	a5,a2
            goto reswitch;
  800264:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800268:	846a                	mv	s0,s10
  80026a:	00140d13          	addi	s10,s0,1
  80026e:	fdd6059b          	addiw	a1,a2,-35
  800272:	0ff5f593          	andi	a1,a1,255
  800276:	fcb572e3          	bgeu	a0,a1,80023a <vprintfmt+0x7c>
            putch('%', putdat);
  80027a:	85a6                	mv	a1,s1
  80027c:	02500513          	li	a0,37
  800280:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  800282:	fff44783          	lbu	a5,-1(s0)
  800286:	8d22                	mv	s10,s0
  800288:	f73788e3          	beq	a5,s3,8001f8 <vprintfmt+0x3a>
  80028c:	ffed4783          	lbu	a5,-2(s10)
  800290:	1d7d                	addi	s10,s10,-1
  800292:	ff379de3          	bne	a5,s3,80028c <vprintfmt+0xce>
  800296:	b78d                	j	8001f8 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800298:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  80029c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  8002a0:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  8002a2:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  8002a6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002aa:	02d86463          	bltu	a6,a3,8002d2 <vprintfmt+0x114>
                ch = *fmt;
  8002ae:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  8002b2:	002c169b          	slliw	a3,s8,0x2
  8002b6:	0186873b          	addw	a4,a3,s8
  8002ba:	0017171b          	slliw	a4,a4,0x1
  8002be:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  8002c0:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  8002c4:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  8002c6:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  8002ca:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  8002ce:	fed870e3          	bgeu	a6,a3,8002ae <vprintfmt+0xf0>
            if (width < 0)
  8002d2:	f40ddce3          	bgez	s11,80022a <vprintfmt+0x6c>
                width = precision, precision = -1;
  8002d6:	8de2                	mv	s11,s8
  8002d8:	5c7d                	li	s8,-1
  8002da:	bf81                	j	80022a <vprintfmt+0x6c>
            if (width < 0)
  8002dc:	fffdc693          	not	a3,s11
  8002e0:	96fd                	srai	a3,a3,0x3f
  8002e2:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  8002e6:	00144603          	lbu	a2,1(s0)
  8002ea:	2d81                	sext.w	s11,s11
  8002ec:	846a                	mv	s0,s10
            goto reswitch;
  8002ee:	bf35                	j	80022a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  8002f0:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002f4:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  8002f8:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  8002fa:	846a                	mv	s0,s10
            goto process_precision;
  8002fc:	bfd9                	j	8002d2 <vprintfmt+0x114>
    if (lflag >= 2) {
  8002fe:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800300:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800304:	01174463          	blt	a4,a7,80030c <vprintfmt+0x14e>
    else if (lflag) {
  800308:	1a088e63          	beqz	a7,8004c4 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  80030c:	000a3603          	ld	a2,0(s4)
  800310:	46c1                	li	a3,16
  800312:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  800314:	2781                	sext.w	a5,a5
  800316:	876e                	mv	a4,s11
  800318:	85a6                	mv	a1,s1
  80031a:	854a                	mv	a0,s2
  80031c:	e37ff0ef          	jal	ra,800152 <printnum>
            break;
  800320:	bde1                	j	8001f8 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  800322:	000a2503          	lw	a0,0(s4)
  800326:	85a6                	mv	a1,s1
  800328:	0a21                	addi	s4,s4,8
  80032a:	9902                	jalr	s2
            break;
  80032c:	b5f1                	j	8001f8 <vprintfmt+0x3a>
    if (lflag >= 2) {
  80032e:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800330:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800334:	01174463          	blt	a4,a7,80033c <vprintfmt+0x17e>
    else if (lflag) {
  800338:	18088163          	beqz	a7,8004ba <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  80033c:	000a3603          	ld	a2,0(s4)
  800340:	46a9                	li	a3,10
  800342:	8a2e                	mv	s4,a1
  800344:	bfc1                	j	800314 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  800346:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  80034a:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  80034c:	846a                	mv	s0,s10
            goto reswitch;
  80034e:	bdf1                	j	80022a <vprintfmt+0x6c>
            putch(ch, putdat);
  800350:	85a6                	mv	a1,s1
  800352:	02500513          	li	a0,37
  800356:	9902                	jalr	s2
            break;
  800358:	b545                	j	8001f8 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  80035a:	00144603          	lbu	a2,1(s0)
            lflag ++;
  80035e:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  800360:	846a                	mv	s0,s10
            goto reswitch;
  800362:	b5e1                	j	80022a <vprintfmt+0x6c>
    if (lflag >= 2) {
  800364:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800366:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  80036a:	01174463          	blt	a4,a7,800372 <vprintfmt+0x1b4>
    else if (lflag) {
  80036e:	14088163          	beqz	a7,8004b0 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  800372:	000a3603          	ld	a2,0(s4)
  800376:	46a1                	li	a3,8
  800378:	8a2e                	mv	s4,a1
  80037a:	bf69                	j	800314 <vprintfmt+0x156>
            putch('0', putdat);
  80037c:	03000513          	li	a0,48
  800380:	85a6                	mv	a1,s1
  800382:	e03e                	sd	a5,0(sp)
  800384:	9902                	jalr	s2
            putch('x', putdat);
  800386:	85a6                	mv	a1,s1
  800388:	07800513          	li	a0,120
  80038c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80038e:	0a21                	addi	s4,s4,8
            goto number;
  800390:	6782                	ld	a5,0(sp)
  800392:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800394:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800398:	bfb5                	j	800314 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  80039a:	000a3403          	ld	s0,0(s4)
  80039e:	008a0713          	addi	a4,s4,8
  8003a2:	e03a                	sd	a4,0(sp)
  8003a4:	14040263          	beqz	s0,8004e8 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  8003a8:	0fb05763          	blez	s11,800496 <vprintfmt+0x2d8>
  8003ac:	02d00693          	li	a3,45
  8003b0:	0cd79163          	bne	a5,a3,800472 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003b4:	00044783          	lbu	a5,0(s0)
  8003b8:	0007851b          	sext.w	a0,a5
  8003bc:	cf85                	beqz	a5,8003f4 <vprintfmt+0x236>
  8003be:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003c2:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003c6:	000c4563          	bltz	s8,8003d0 <vprintfmt+0x212>
  8003ca:	3c7d                	addiw	s8,s8,-1
  8003cc:	036c0263          	beq	s8,s6,8003f0 <vprintfmt+0x232>
                    putch('?', putdat);
  8003d0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  8003d2:	0e0c8e63          	beqz	s9,8004ce <vprintfmt+0x310>
  8003d6:	3781                	addiw	a5,a5,-32
  8003d8:	0ef47b63          	bgeu	s0,a5,8004ce <vprintfmt+0x310>
                    putch('?', putdat);
  8003dc:	03f00513          	li	a0,63
  8003e0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8003e2:	000a4783          	lbu	a5,0(s4)
  8003e6:	3dfd                	addiw	s11,s11,-1
  8003e8:	0a05                	addi	s4,s4,1
  8003ea:	0007851b          	sext.w	a0,a5
  8003ee:	ffe1                	bnez	a5,8003c6 <vprintfmt+0x208>
            for (; width > 0; width --) {
  8003f0:	01b05963          	blez	s11,800402 <vprintfmt+0x244>
  8003f4:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  8003f6:	85a6                	mv	a1,s1
  8003f8:	02000513          	li	a0,32
  8003fc:	9902                	jalr	s2
            for (; width > 0; width --) {
  8003fe:	fe0d9be3          	bnez	s11,8003f4 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  800402:	6a02                	ld	s4,0(sp)
  800404:	bbd5                	j	8001f8 <vprintfmt+0x3a>
    if (lflag >= 2) {
  800406:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800408:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  80040c:	01174463          	blt	a4,a7,800414 <vprintfmt+0x256>
    else if (lflag) {
  800410:	08088d63          	beqz	a7,8004aa <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  800414:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  800418:	0a044d63          	bltz	s0,8004d2 <vprintfmt+0x314>
            num = getint(&ap, lflag);
  80041c:	8622                	mv	a2,s0
  80041e:	8a66                	mv	s4,s9
  800420:	46a9                	li	a3,10
  800422:	bdcd                	j	800314 <vprintfmt+0x156>
            err = va_arg(ap, int);
  800424:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800428:	4761                	li	a4,24
            err = va_arg(ap, int);
  80042a:	0a21                	addi	s4,s4,8
            if (err < 0) {
  80042c:	41f7d69b          	sraiw	a3,a5,0x1f
  800430:	8fb5                	xor	a5,a5,a3
  800432:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800436:	02d74163          	blt	a4,a3,800458 <vprintfmt+0x29a>
  80043a:	00369793          	slli	a5,a3,0x3
  80043e:	97de                	add	a5,a5,s7
  800440:	639c                	ld	a5,0(a5)
  800442:	cb99                	beqz	a5,800458 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  800444:	86be                	mv	a3,a5
  800446:	00000617          	auipc	a2,0x0
  80044a:	23a60613          	addi	a2,a2,570 # 800680 <main+0x124>
  80044e:	85a6                	mv	a1,s1
  800450:	854a                	mv	a0,s2
  800452:	0ce000ef          	jal	ra,800520 <printfmt>
  800456:	b34d                	j	8001f8 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  800458:	00000617          	auipc	a2,0x0
  80045c:	21860613          	addi	a2,a2,536 # 800670 <main+0x114>
  800460:	85a6                	mv	a1,s1
  800462:	854a                	mv	a0,s2
  800464:	0bc000ef          	jal	ra,800520 <printfmt>
  800468:	bb41                	j	8001f8 <vprintfmt+0x3a>
                p = "(null)";
  80046a:	00000417          	auipc	s0,0x0
  80046e:	1fe40413          	addi	s0,s0,510 # 800668 <main+0x10c>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800472:	85e2                	mv	a1,s8
  800474:	8522                	mv	a0,s0
  800476:	e43e                	sd	a5,8(sp)
  800478:	0c8000ef          	jal	ra,800540 <strnlen>
  80047c:	40ad8dbb          	subw	s11,s11,a0
  800480:	01b05b63          	blez	s11,800496 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  800484:	67a2                	ld	a5,8(sp)
  800486:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  80048a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  80048c:	85a6                	mv	a1,s1
  80048e:	8552                	mv	a0,s4
  800490:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  800492:	fe0d9ce3          	bnez	s11,80048a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800496:	00044783          	lbu	a5,0(s0)
  80049a:	00140a13          	addi	s4,s0,1
  80049e:	0007851b          	sext.w	a0,a5
  8004a2:	d3a5                	beqz	a5,800402 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  8004a4:	05e00413          	li	s0,94
  8004a8:	bf39                	j	8003c6 <vprintfmt+0x208>
        return va_arg(*ap, int);
  8004aa:	000a2403          	lw	s0,0(s4)
  8004ae:	b7ad                	j	800418 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  8004b0:	000a6603          	lwu	a2,0(s4)
  8004b4:	46a1                	li	a3,8
  8004b6:	8a2e                	mv	s4,a1
  8004b8:	bdb1                	j	800314 <vprintfmt+0x156>
  8004ba:	000a6603          	lwu	a2,0(s4)
  8004be:	46a9                	li	a3,10
  8004c0:	8a2e                	mv	s4,a1
  8004c2:	bd89                	j	800314 <vprintfmt+0x156>
  8004c4:	000a6603          	lwu	a2,0(s4)
  8004c8:	46c1                	li	a3,16
  8004ca:	8a2e                	mv	s4,a1
  8004cc:	b5a1                	j	800314 <vprintfmt+0x156>
                    putch(ch, putdat);
  8004ce:	9902                	jalr	s2
  8004d0:	bf09                	j	8003e2 <vprintfmt+0x224>
                putch('-', putdat);
  8004d2:	85a6                	mv	a1,s1
  8004d4:	02d00513          	li	a0,45
  8004d8:	e03e                	sd	a5,0(sp)
  8004da:	9902                	jalr	s2
                num = -(long long)num;
  8004dc:	6782                	ld	a5,0(sp)
  8004de:	8a66                	mv	s4,s9
  8004e0:	40800633          	neg	a2,s0
  8004e4:	46a9                	li	a3,10
  8004e6:	b53d                	j	800314 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  8004e8:	03b05163          	blez	s11,80050a <vprintfmt+0x34c>
  8004ec:	02d00693          	li	a3,45
  8004f0:	f6d79de3          	bne	a5,a3,80046a <vprintfmt+0x2ac>
                p = "(null)";
  8004f4:	00000417          	auipc	s0,0x0
  8004f8:	17440413          	addi	s0,s0,372 # 800668 <main+0x10c>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8004fc:	02800793          	li	a5,40
  800500:	02800513          	li	a0,40
  800504:	00140a13          	addi	s4,s0,1
  800508:	bd6d                	j	8003c2 <vprintfmt+0x204>
  80050a:	00000a17          	auipc	s4,0x0
  80050e:	15fa0a13          	addi	s4,s4,351 # 800669 <main+0x10d>
  800512:	02800513          	li	a0,40
  800516:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  80051a:	05e00413          	li	s0,94
  80051e:	b565                	j	8003c6 <vprintfmt+0x208>

0000000000800520 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800520:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  800522:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800526:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800528:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80052a:	ec06                	sd	ra,24(sp)
  80052c:	f83a                	sd	a4,48(sp)
  80052e:	fc3e                	sd	a5,56(sp)
  800530:	e0c2                	sd	a6,64(sp)
  800532:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  800534:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  800536:	c89ff0ef          	jal	ra,8001be <vprintfmt>
}
  80053a:	60e2                	ld	ra,24(sp)
  80053c:	6161                	addi	sp,sp,80
  80053e:	8082                	ret

0000000000800540 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  800540:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  800542:	e589                	bnez	a1,80054c <strnlen+0xc>
  800544:	a811                	j	800558 <strnlen+0x18>
        cnt ++;
  800546:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  800548:	00f58863          	beq	a1,a5,800558 <strnlen+0x18>
  80054c:	00f50733          	add	a4,a0,a5
  800550:	00074703          	lbu	a4,0(a4)
  800554:	fb6d                	bnez	a4,800546 <strnlen+0x6>
  800556:	85be                	mv	a1,a5
    }
    return cnt;
}
  800558:	852e                	mv	a0,a1
  80055a:	8082                	ret

000000000080055c <main>:
#include <stdio.h>

const int max_child = 32;

int
main(void) {
  80055c:	1101                	addi	sp,sp,-32
  80055e:	e822                	sd	s0,16(sp)
  800560:	e426                	sd	s1,8(sp)
  800562:	ec06                	sd	ra,24(sp)
    int n, pid;
    for (n = 0; n < max_child; n ++) {
  800564:	4401                	li	s0,0
  800566:	02000493          	li	s1,32
        if ((pid = fork()) == 0) {
  80056a:	bd5ff0ef          	jal	ra,80013e <fork>
  80056e:	c131                	beqz	a0,8005b2 <main+0x56>
            cprintf("I am child %d\n", n);
            exit(0);
        }
        assert(pid > 0);
  800570:	06a05663          	blez	a0,8005dc <main+0x80>
    for (n = 0; n < max_child; n ++) {
  800574:	2405                	addiw	s0,s0,1
  800576:	fe941ae3          	bne	s0,s1,80056a <main+0xe>
    }

    if (n > max_child) {
        panic("fork claimed to work %d times!\n", n);
    }
    cprintf("fork finished\n");
  80057a:	00000517          	auipc	a0,0x0
  80057e:	42e50513          	addi	a0,a0,1070 # 8009a8 <error_string+0x108>
  800582:	b21ff0ef          	jal	ra,8000a2 <cprintf>
  800586:	02000413          	li	s0,32
    for (; n > 0; n --) {
        if (wait() != 0) {
  80058a:	bb7ff0ef          	jal	ra,800140 <wait>
  80058e:	ed05                	bnez	a0,8005c6 <main+0x6a>
    for (; n > 0; n --) {
  800590:	347d                	addiw	s0,s0,-1
  800592:	fc65                	bnez	s0,80058a <main+0x2e>
            panic("wait stopped early\n");
        }
    }

    if (wait() == 0) {
  800594:	badff0ef          	jal	ra,800140 <wait>
  800598:	c12d                	beqz	a0,8005fa <main+0x9e>
        panic("wait got too many\n");
    }

    cprintf("forktest pass.\n");
  80059a:	00000517          	auipc	a0,0x0
  80059e:	44e50513          	addi	a0,a0,1102 # 8009e8 <error_string+0x148>
  8005a2:	b01ff0ef          	jal	ra,8000a2 <cprintf>
    return 0;
}
  8005a6:	60e2                	ld	ra,24(sp)
  8005a8:	6442                	ld	s0,16(sp)
  8005aa:	64a2                	ld	s1,8(sp)
  8005ac:	4501                	li	a0,0
  8005ae:	6105                	addi	sp,sp,32
  8005b0:	8082                	ret
            cprintf("I am child %d\n", n);
  8005b2:	85a2                	mv	a1,s0
  8005b4:	00000517          	auipc	a0,0x0
  8005b8:	3b450513          	addi	a0,a0,948 # 800968 <error_string+0xc8>
  8005bc:	ae7ff0ef          	jal	ra,8000a2 <cprintf>
            exit(0);
  8005c0:	4501                	li	a0,0
  8005c2:	b67ff0ef          	jal	ra,800128 <exit>
            panic("wait stopped early\n");
  8005c6:	00000617          	auipc	a2,0x0
  8005ca:	3f260613          	addi	a2,a2,1010 # 8009b8 <error_string+0x118>
  8005ce:	45dd                	li	a1,23
  8005d0:	00000517          	auipc	a0,0x0
  8005d4:	3c850513          	addi	a0,a0,968 # 800998 <error_string+0xf8>
  8005d8:	a4fff0ef          	jal	ra,800026 <__panic>
        assert(pid > 0);
  8005dc:	00000697          	auipc	a3,0x0
  8005e0:	39c68693          	addi	a3,a3,924 # 800978 <error_string+0xd8>
  8005e4:	00000617          	auipc	a2,0x0
  8005e8:	39c60613          	addi	a2,a2,924 # 800980 <error_string+0xe0>
  8005ec:	45b9                	li	a1,14
  8005ee:	00000517          	auipc	a0,0x0
  8005f2:	3aa50513          	addi	a0,a0,938 # 800998 <error_string+0xf8>
  8005f6:	a31ff0ef          	jal	ra,800026 <__panic>
        panic("wait got too many\n");
  8005fa:	00000617          	auipc	a2,0x0
  8005fe:	3d660613          	addi	a2,a2,982 # 8009d0 <error_string+0x130>
  800602:	45f1                	li	a1,28
  800604:	00000517          	auipc	a0,0x0
  800608:	39450513          	addi	a0,a0,916 # 800998 <error_string+0xf8>
  80060c:	a1bff0ef          	jal	ra,800026 <__panic>
