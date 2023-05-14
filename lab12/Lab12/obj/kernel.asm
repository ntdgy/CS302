
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	c020b2b7          	lui	t0,0xc020b
ffffffffc0200004:	ffd0031b          	addw	t1,zero,-3
ffffffffc0200008:	037a                	sll	t1,t1,0x1e
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
ffffffffc020000e:	00c2d293          	srl	t0,t0,0xc
ffffffffc0200012:	fff0031b          	addw	t1,zero,-1
ffffffffc0200016:	137e                	sll	t1,t1,0x3f
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
ffffffffc020001c:	18029073          	csrw	satp,t0
ffffffffc0200020:	12000073          	sfence.vma
ffffffffc0200024:	c020b137          	lui	sp,0xc020b
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
ffffffffc020002c:	03228293          	add	t0,t0,50 # ffffffffc0200032 <kern_init>
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
ffffffffc0200032:	0000c517          	auipc	a0,0xc
ffffffffc0200036:	05e50513          	add	a0,a0,94 # ffffffffc020c090 <buf>
ffffffffc020003a:	00017617          	auipc	a2,0x17
ffffffffc020003e:	64660613          	add	a2,a2,1606 # ffffffffc0217680 <end>
ffffffffc0200042:	1141                	add	sp,sp,-16 # ffffffffc020aff0 <bootstack+0x1ff0>
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	0d5050ef          	jal	ffffffffc020591e <memset>
ffffffffc020004e:	518000ef          	jal	ffffffffc0200566 <cons_init>
ffffffffc0200052:	00006597          	auipc	a1,0x6
ffffffffc0200056:	8f658593          	add	a1,a1,-1802 # ffffffffc0205948 <etext>
ffffffffc020005a:	00006517          	auipc	a0,0x6
ffffffffc020005e:	90650513          	add	a0,a0,-1786 # ffffffffc0205960 <etext+0x18>
ffffffffc0200062:	128000ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200066:	435010ef          	jal	ffffffffc0201c9a <pmm_init>
ffffffffc020006a:	5d0000ef          	jal	ffffffffc020063a <pic_init>
ffffffffc020006e:	5ce000ef          	jal	ffffffffc020063c <idt_init>
ffffffffc0200072:	745020ef          	jal	ffffffffc0202fb6 <vmm_init>
ffffffffc0200076:	691040ef          	jal	ffffffffc0204f06 <sched_init>
ffffffffc020007a:	6c0040ef          	jal	ffffffffc020473a <proc_init>
ffffffffc020007e:	55a000ef          	jal	ffffffffc02005d8 <ide_init>
ffffffffc0200082:	594020ef          	jal	ffffffffc0202616 <swap_init>
ffffffffc0200086:	498000ef          	jal	ffffffffc020051e <clock_init>
ffffffffc020008a:	5a4000ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc020008e:	047040ef          	jal	ffffffffc02048d4 <cpu_idle>

ffffffffc0200092 <readline>:
ffffffffc0200092:	715d                	add	sp,sp,-80
ffffffffc0200094:	e486                	sd	ra,72(sp)
ffffffffc0200096:	e0a2                	sd	s0,64(sp)
ffffffffc0200098:	fc26                	sd	s1,56(sp)
ffffffffc020009a:	f84a                	sd	s2,48(sp)
ffffffffc020009c:	f44e                	sd	s3,40(sp)
ffffffffc020009e:	f052                	sd	s4,32(sp)
ffffffffc02000a0:	ec56                	sd	s5,24(sp)
ffffffffc02000a2:	e85a                	sd	s6,16(sp)
ffffffffc02000a4:	e45e                	sd	s7,8(sp)
ffffffffc02000a6:	c901                	beqz	a0,ffffffffc02000b6 <readline+0x24>
ffffffffc02000a8:	85aa                	mv	a1,a0
ffffffffc02000aa:	00006517          	auipc	a0,0x6
ffffffffc02000ae:	8be50513          	add	a0,a0,-1858 # ffffffffc0205968 <etext+0x20>
ffffffffc02000b2:	0d8000ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02000b6:	4481                	li	s1,0
ffffffffc02000b8:	497d                	li	s2,31
ffffffffc02000ba:	4a21                	li	s4,8
ffffffffc02000bc:	4aa9                	li	s5,10
ffffffffc02000be:	4b35                	li	s6,13
ffffffffc02000c0:	0000cb97          	auipc	s7,0xc
ffffffffc02000c4:	fd0b8b93          	add	s7,s7,-48 # ffffffffc020c090 <buf>
ffffffffc02000c8:	3fe00993          	li	s3,1022
ffffffffc02000cc:	136000ef          	jal	ffffffffc0200202 <getchar>
ffffffffc02000d0:	842a                	mv	s0,a0
ffffffffc02000d2:	02054363          	bltz	a0,ffffffffc02000f8 <readline+0x66>
ffffffffc02000d6:	02a95363          	bge	s2,a0,ffffffffc02000fc <readline+0x6a>
ffffffffc02000da:	fe99c9e3          	blt	s3,s1,ffffffffc02000cc <readline+0x3a>
ffffffffc02000de:	8522                	mv	a0,s0
ffffffffc02000e0:	0e0000ef          	jal	ffffffffc02001c0 <cputchar>
ffffffffc02000e4:	009b87b3          	add	a5,s7,s1
ffffffffc02000e8:	00878023          	sb	s0,0(a5)
ffffffffc02000ec:	116000ef          	jal	ffffffffc0200202 <getchar>
ffffffffc02000f0:	2485                	addw	s1,s1,1
ffffffffc02000f2:	842a                	mv	s0,a0
ffffffffc02000f4:	fe0551e3          	bgez	a0,ffffffffc02000d6 <readline+0x44>
ffffffffc02000f8:	4501                	li	a0,0
ffffffffc02000fa:	a081                	j	ffffffffc020013a <readline+0xa8>
ffffffffc02000fc:	03451163          	bne	a0,s4,ffffffffc020011e <readline+0x8c>
ffffffffc0200100:	c489                	beqz	s1,ffffffffc020010a <readline+0x78>
ffffffffc0200102:	0be000ef          	jal	ffffffffc02001c0 <cputchar>
ffffffffc0200106:	34fd                	addw	s1,s1,-1
ffffffffc0200108:	b7d1                	j	ffffffffc02000cc <readline+0x3a>
ffffffffc020010a:	0f8000ef          	jal	ffffffffc0200202 <getchar>
ffffffffc020010e:	842a                	mv	s0,a0
ffffffffc0200110:	47a1                	li	a5,8
ffffffffc0200112:	fe0543e3          	bltz	a0,ffffffffc02000f8 <readline+0x66>
ffffffffc0200116:	fca944e3          	blt	s2,a0,ffffffffc02000de <readline+0x4c>
ffffffffc020011a:	fef508e3          	beq	a0,a5,ffffffffc020010a <readline+0x78>
ffffffffc020011e:	01540463          	beq	s0,s5,ffffffffc0200126 <readline+0x94>
ffffffffc0200122:	fb6415e3          	bne	s0,s6,ffffffffc02000cc <readline+0x3a>
ffffffffc0200126:	8522                	mv	a0,s0
ffffffffc0200128:	098000ef          	jal	ffffffffc02001c0 <cputchar>
ffffffffc020012c:	0000c517          	auipc	a0,0xc
ffffffffc0200130:	f6450513          	add	a0,a0,-156 # ffffffffc020c090 <buf>
ffffffffc0200134:	94aa                	add	s1,s1,a0
ffffffffc0200136:	00048023          	sb	zero,0(s1)
ffffffffc020013a:	60a6                	ld	ra,72(sp)
ffffffffc020013c:	6406                	ld	s0,64(sp)
ffffffffc020013e:	74e2                	ld	s1,56(sp)
ffffffffc0200140:	7942                	ld	s2,48(sp)
ffffffffc0200142:	79a2                	ld	s3,40(sp)
ffffffffc0200144:	7a02                	ld	s4,32(sp)
ffffffffc0200146:	6ae2                	ld	s5,24(sp)
ffffffffc0200148:	6b42                	ld	s6,16(sp)
ffffffffc020014a:	6ba2                	ld	s7,8(sp)
ffffffffc020014c:	6161                	add	sp,sp,80
ffffffffc020014e:	8082                	ret

ffffffffc0200150 <cputch>:
ffffffffc0200150:	1141                	add	sp,sp,-16
ffffffffc0200152:	e022                	sd	s0,0(sp)
ffffffffc0200154:	e406                	sd	ra,8(sp)
ffffffffc0200156:	842e                	mv	s0,a1
ffffffffc0200158:	410000ef          	jal	ffffffffc0200568 <cons_putc>
ffffffffc020015c:	401c                	lw	a5,0(s0)
ffffffffc020015e:	60a2                	ld	ra,8(sp)
ffffffffc0200160:	2785                	addw	a5,a5,1
ffffffffc0200162:	c01c                	sw	a5,0(s0)
ffffffffc0200164:	6402                	ld	s0,0(sp)
ffffffffc0200166:	0141                	add	sp,sp,16
ffffffffc0200168:	8082                	ret

ffffffffc020016a <vcprintf>:
ffffffffc020016a:	1101                	add	sp,sp,-32
ffffffffc020016c:	862a                	mv	a2,a0
ffffffffc020016e:	86ae                	mv	a3,a1
ffffffffc0200170:	00000517          	auipc	a0,0x0
ffffffffc0200174:	fe050513          	add	a0,a0,-32 # ffffffffc0200150 <cputch>
ffffffffc0200178:	006c                	add	a1,sp,12
ffffffffc020017a:	ec06                	sd	ra,24(sp)
ffffffffc020017c:	c602                	sw	zero,12(sp)
ffffffffc020017e:	3ba050ef          	jal	ffffffffc0205538 <vprintfmt>
ffffffffc0200182:	60e2                	ld	ra,24(sp)
ffffffffc0200184:	4532                	lw	a0,12(sp)
ffffffffc0200186:	6105                	add	sp,sp,32
ffffffffc0200188:	8082                	ret

ffffffffc020018a <cprintf>:
ffffffffc020018a:	711d                	add	sp,sp,-96
ffffffffc020018c:	02810313          	add	t1,sp,40
ffffffffc0200190:	8e2a                	mv	t3,a0
ffffffffc0200192:	f42e                	sd	a1,40(sp)
ffffffffc0200194:	f832                	sd	a2,48(sp)
ffffffffc0200196:	fc36                	sd	a3,56(sp)
ffffffffc0200198:	00000517          	auipc	a0,0x0
ffffffffc020019c:	fb850513          	add	a0,a0,-72 # ffffffffc0200150 <cputch>
ffffffffc02001a0:	004c                	add	a1,sp,4
ffffffffc02001a2:	869a                	mv	a3,t1
ffffffffc02001a4:	8672                	mv	a2,t3
ffffffffc02001a6:	ec06                	sd	ra,24(sp)
ffffffffc02001a8:	e0ba                	sd	a4,64(sp)
ffffffffc02001aa:	e4be                	sd	a5,72(sp)
ffffffffc02001ac:	e8c2                	sd	a6,80(sp)
ffffffffc02001ae:	ecc6                	sd	a7,88(sp)
ffffffffc02001b0:	e41a                	sd	t1,8(sp)
ffffffffc02001b2:	c202                	sw	zero,4(sp)
ffffffffc02001b4:	384050ef          	jal	ffffffffc0205538 <vprintfmt>
ffffffffc02001b8:	60e2                	ld	ra,24(sp)
ffffffffc02001ba:	4512                	lw	a0,4(sp)
ffffffffc02001bc:	6125                	add	sp,sp,96
ffffffffc02001be:	8082                	ret

ffffffffc02001c0 <cputchar>:
ffffffffc02001c0:	a665                	j	ffffffffc0200568 <cons_putc>

ffffffffc02001c2 <cputs>:
ffffffffc02001c2:	1101                	add	sp,sp,-32
ffffffffc02001c4:	ec06                	sd	ra,24(sp)
ffffffffc02001c6:	e822                	sd	s0,16(sp)
ffffffffc02001c8:	e426                	sd	s1,8(sp)
ffffffffc02001ca:	87aa                	mv	a5,a0
ffffffffc02001cc:	00054503          	lbu	a0,0(a0)
ffffffffc02001d0:	c51d                	beqz	a0,ffffffffc02001fe <cputs+0x3c>
ffffffffc02001d2:	00178493          	add	s1,a5,1
ffffffffc02001d6:	8426                	mv	s0,s1
ffffffffc02001d8:	390000ef          	jal	ffffffffc0200568 <cons_putc>
ffffffffc02001dc:	00044503          	lbu	a0,0(s0)
ffffffffc02001e0:	87a2                	mv	a5,s0
ffffffffc02001e2:	0405                	add	s0,s0,1
ffffffffc02001e4:	f975                	bnez	a0,ffffffffc02001d8 <cputs+0x16>
ffffffffc02001e6:	9f85                	subw	a5,a5,s1
ffffffffc02001e8:	0027841b          	addw	s0,a5,2
ffffffffc02001ec:	4529                	li	a0,10
ffffffffc02001ee:	37a000ef          	jal	ffffffffc0200568 <cons_putc>
ffffffffc02001f2:	60e2                	ld	ra,24(sp)
ffffffffc02001f4:	8522                	mv	a0,s0
ffffffffc02001f6:	6442                	ld	s0,16(sp)
ffffffffc02001f8:	64a2                	ld	s1,8(sp)
ffffffffc02001fa:	6105                	add	sp,sp,32
ffffffffc02001fc:	8082                	ret
ffffffffc02001fe:	4405                	li	s0,1
ffffffffc0200200:	b7f5                	j	ffffffffc02001ec <cputs+0x2a>

ffffffffc0200202 <getchar>:
ffffffffc0200202:	1141                	add	sp,sp,-16
ffffffffc0200204:	e406                	sd	ra,8(sp)
ffffffffc0200206:	396000ef          	jal	ffffffffc020059c <cons_getc>
ffffffffc020020a:	dd75                	beqz	a0,ffffffffc0200206 <getchar+0x4>
ffffffffc020020c:	60a2                	ld	ra,8(sp)
ffffffffc020020e:	0141                	add	sp,sp,16
ffffffffc0200210:	8082                	ret

ffffffffc0200212 <print_kerninfo>:
ffffffffc0200212:	1141                	add	sp,sp,-16
ffffffffc0200214:	00005517          	auipc	a0,0x5
ffffffffc0200218:	75c50513          	add	a0,a0,1884 # ffffffffc0205970 <etext+0x28>
ffffffffc020021c:	e406                	sd	ra,8(sp)
ffffffffc020021e:	f6dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200222:	00000597          	auipc	a1,0x0
ffffffffc0200226:	e1058593          	add	a1,a1,-496 # ffffffffc0200032 <kern_init>
ffffffffc020022a:	00005517          	auipc	a0,0x5
ffffffffc020022e:	76650513          	add	a0,a0,1894 # ffffffffc0205990 <etext+0x48>
ffffffffc0200232:	f59ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200236:	00005597          	auipc	a1,0x5
ffffffffc020023a:	71258593          	add	a1,a1,1810 # ffffffffc0205948 <etext>
ffffffffc020023e:	00005517          	auipc	a0,0x5
ffffffffc0200242:	77250513          	add	a0,a0,1906 # ffffffffc02059b0 <etext+0x68>
ffffffffc0200246:	f45ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020024a:	0000c597          	auipc	a1,0xc
ffffffffc020024e:	e4658593          	add	a1,a1,-442 # ffffffffc020c090 <buf>
ffffffffc0200252:	00005517          	auipc	a0,0x5
ffffffffc0200256:	77e50513          	add	a0,a0,1918 # ffffffffc02059d0 <etext+0x88>
ffffffffc020025a:	f31ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020025e:	00017597          	auipc	a1,0x17
ffffffffc0200262:	42258593          	add	a1,a1,1058 # ffffffffc0217680 <end>
ffffffffc0200266:	00005517          	auipc	a0,0x5
ffffffffc020026a:	78a50513          	add	a0,a0,1930 # ffffffffc02059f0 <etext+0xa8>
ffffffffc020026e:	f1dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200272:	00018797          	auipc	a5,0x18
ffffffffc0200276:	80d78793          	add	a5,a5,-2035 # ffffffffc0217a7f <end+0x3ff>
ffffffffc020027a:	00000717          	auipc	a4,0x0
ffffffffc020027e:	db870713          	add	a4,a4,-584 # ffffffffc0200032 <kern_init>
ffffffffc0200282:	8f99                	sub	a5,a5,a4
ffffffffc0200284:	43f7d593          	sra	a1,a5,0x3f
ffffffffc0200288:	60a2                	ld	ra,8(sp)
ffffffffc020028a:	3ff5f593          	and	a1,a1,1023
ffffffffc020028e:	95be                	add	a1,a1,a5
ffffffffc0200290:	85a9                	sra	a1,a1,0xa
ffffffffc0200292:	00005517          	auipc	a0,0x5
ffffffffc0200296:	77e50513          	add	a0,a0,1918 # ffffffffc0205a10 <etext+0xc8>
ffffffffc020029a:	0141                	add	sp,sp,16
ffffffffc020029c:	b5fd                	j	ffffffffc020018a <cprintf>

ffffffffc020029e <print_stackframe>:
ffffffffc020029e:	1141                	add	sp,sp,-16
ffffffffc02002a0:	00005617          	auipc	a2,0x5
ffffffffc02002a4:	7a060613          	add	a2,a2,1952 # ffffffffc0205a40 <etext+0xf8>
ffffffffc02002a8:	05b00593          	li	a1,91
ffffffffc02002ac:	00005517          	auipc	a0,0x5
ffffffffc02002b0:	7ac50513          	add	a0,a0,1964 # ffffffffc0205a58 <etext+0x110>
ffffffffc02002b4:	e406                	sd	ra,8(sp)
ffffffffc02002b6:	1bc000ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02002ba <mon_help>:
ffffffffc02002ba:	1141                	add	sp,sp,-16
ffffffffc02002bc:	00005617          	auipc	a2,0x5
ffffffffc02002c0:	7b460613          	add	a2,a2,1972 # ffffffffc0205a70 <etext+0x128>
ffffffffc02002c4:	00005597          	auipc	a1,0x5
ffffffffc02002c8:	7cc58593          	add	a1,a1,1996 # ffffffffc0205a90 <etext+0x148>
ffffffffc02002cc:	00005517          	auipc	a0,0x5
ffffffffc02002d0:	7cc50513          	add	a0,a0,1996 # ffffffffc0205a98 <etext+0x150>
ffffffffc02002d4:	e406                	sd	ra,8(sp)
ffffffffc02002d6:	eb5ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02002da:	00005617          	auipc	a2,0x5
ffffffffc02002de:	7ce60613          	add	a2,a2,1998 # ffffffffc0205aa8 <etext+0x160>
ffffffffc02002e2:	00005597          	auipc	a1,0x5
ffffffffc02002e6:	7ee58593          	add	a1,a1,2030 # ffffffffc0205ad0 <etext+0x188>
ffffffffc02002ea:	00005517          	auipc	a0,0x5
ffffffffc02002ee:	7ae50513          	add	a0,a0,1966 # ffffffffc0205a98 <etext+0x150>
ffffffffc02002f2:	e99ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02002f6:	00005617          	auipc	a2,0x5
ffffffffc02002fa:	7ea60613          	add	a2,a2,2026 # ffffffffc0205ae0 <etext+0x198>
ffffffffc02002fe:	00006597          	auipc	a1,0x6
ffffffffc0200302:	80258593          	add	a1,a1,-2046 # ffffffffc0205b00 <etext+0x1b8>
ffffffffc0200306:	00005517          	auipc	a0,0x5
ffffffffc020030a:	79250513          	add	a0,a0,1938 # ffffffffc0205a98 <etext+0x150>
ffffffffc020030e:	e7dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200312:	60a2                	ld	ra,8(sp)
ffffffffc0200314:	4501                	li	a0,0
ffffffffc0200316:	0141                	add	sp,sp,16
ffffffffc0200318:	8082                	ret

ffffffffc020031a <mon_kerninfo>:
ffffffffc020031a:	1141                	add	sp,sp,-16
ffffffffc020031c:	e406                	sd	ra,8(sp)
ffffffffc020031e:	ef5ff0ef          	jal	ffffffffc0200212 <print_kerninfo>
ffffffffc0200322:	60a2                	ld	ra,8(sp)
ffffffffc0200324:	4501                	li	a0,0
ffffffffc0200326:	0141                	add	sp,sp,16
ffffffffc0200328:	8082                	ret

ffffffffc020032a <mon_backtrace>:
ffffffffc020032a:	1141                	add	sp,sp,-16
ffffffffc020032c:	e406                	sd	ra,8(sp)
ffffffffc020032e:	f71ff0ef          	jal	ffffffffc020029e <print_stackframe>
ffffffffc0200332:	60a2                	ld	ra,8(sp)
ffffffffc0200334:	4501                	li	a0,0
ffffffffc0200336:	0141                	add	sp,sp,16
ffffffffc0200338:	8082                	ret

ffffffffc020033a <kmonitor>:
ffffffffc020033a:	7115                	add	sp,sp,-224
ffffffffc020033c:	f15a                	sd	s6,160(sp)
ffffffffc020033e:	8b2a                	mv	s6,a0
ffffffffc0200340:	00005517          	auipc	a0,0x5
ffffffffc0200344:	7d050513          	add	a0,a0,2000 # ffffffffc0205b10 <etext+0x1c8>
ffffffffc0200348:	ed86                	sd	ra,216(sp)
ffffffffc020034a:	e9a2                	sd	s0,208(sp)
ffffffffc020034c:	e5a6                	sd	s1,200(sp)
ffffffffc020034e:	e1ca                	sd	s2,192(sp)
ffffffffc0200350:	fd4e                	sd	s3,184(sp)
ffffffffc0200352:	f952                	sd	s4,176(sp)
ffffffffc0200354:	f556                	sd	s5,168(sp)
ffffffffc0200356:	ed5e                	sd	s7,152(sp)
ffffffffc0200358:	e962                	sd	s8,144(sp)
ffffffffc020035a:	e566                	sd	s9,136(sp)
ffffffffc020035c:	e16a                	sd	s10,128(sp)
ffffffffc020035e:	e2dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200362:	00005517          	auipc	a0,0x5
ffffffffc0200366:	7d650513          	add	a0,a0,2006 # ffffffffc0205b38 <etext+0x1f0>
ffffffffc020036a:	e21ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020036e:	000b0563          	beqz	s6,ffffffffc0200378 <kmonitor+0x3e>
ffffffffc0200372:	855a                	mv	a0,s6
ffffffffc0200374:	4b0000ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200378:	00006c17          	auipc	s8,0x6
ffffffffc020037c:	830c0c13          	add	s8,s8,-2000 # ffffffffc0205ba8 <commands>
ffffffffc0200380:	00005917          	auipc	s2,0x5
ffffffffc0200384:	7e090913          	add	s2,s2,2016 # ffffffffc0205b60 <etext+0x218>
ffffffffc0200388:	00005497          	auipc	s1,0x5
ffffffffc020038c:	7e048493          	add	s1,s1,2016 # ffffffffc0205b68 <etext+0x220>
ffffffffc0200390:	49bd                	li	s3,15
ffffffffc0200392:	00005a97          	auipc	s5,0x5
ffffffffc0200396:	7dea8a93          	add	s5,s5,2014 # ffffffffc0205b70 <etext+0x228>
ffffffffc020039a:	4a0d                	li	s4,3
ffffffffc020039c:	00005b97          	auipc	s7,0x5
ffffffffc02003a0:	7f4b8b93          	add	s7,s7,2036 # ffffffffc0205b90 <etext+0x248>
ffffffffc02003a4:	854a                	mv	a0,s2
ffffffffc02003a6:	cedff0ef          	jal	ffffffffc0200092 <readline>
ffffffffc02003aa:	842a                	mv	s0,a0
ffffffffc02003ac:	dd65                	beqz	a0,ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc02003ae:	00054583          	lbu	a1,0(a0)
ffffffffc02003b2:	4c81                	li	s9,0
ffffffffc02003b4:	e59d                	bnez	a1,ffffffffc02003e2 <kmonitor+0xa8>
ffffffffc02003b6:	fe0c87e3          	beqz	s9,ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc02003ba:	00005d17          	auipc	s10,0x5
ffffffffc02003be:	7eed0d13          	add	s10,s10,2030 # ffffffffc0205ba8 <commands>
ffffffffc02003c2:	4401                	li	s0,0
ffffffffc02003c4:	000d3503          	ld	a0,0(s10)
ffffffffc02003c8:	6582                	ld	a1,0(sp)
ffffffffc02003ca:	0d61                	add	s10,s10,24
ffffffffc02003cc:	504050ef          	jal	ffffffffc02058d0 <strcmp>
ffffffffc02003d0:	c535                	beqz	a0,ffffffffc020043c <kmonitor+0x102>
ffffffffc02003d2:	2405                	addw	s0,s0,1
ffffffffc02003d4:	ff4418e3          	bne	s0,s4,ffffffffc02003c4 <kmonitor+0x8a>
ffffffffc02003d8:	6582                	ld	a1,0(sp)
ffffffffc02003da:	855e                	mv	a0,s7
ffffffffc02003dc:	dafff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02003e0:	b7d1                	j	ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc02003e2:	8526                	mv	a0,s1
ffffffffc02003e4:	524050ef          	jal	ffffffffc0205908 <strchr>
ffffffffc02003e8:	c901                	beqz	a0,ffffffffc02003f8 <kmonitor+0xbe>
ffffffffc02003ea:	00144583          	lbu	a1,1(s0)
ffffffffc02003ee:	00040023          	sb	zero,0(s0)
ffffffffc02003f2:	0405                	add	s0,s0,1
ffffffffc02003f4:	d1e9                	beqz	a1,ffffffffc02003b6 <kmonitor+0x7c>
ffffffffc02003f6:	b7f5                	j	ffffffffc02003e2 <kmonitor+0xa8>
ffffffffc02003f8:	00044783          	lbu	a5,0(s0)
ffffffffc02003fc:	dfcd                	beqz	a5,ffffffffc02003b6 <kmonitor+0x7c>
ffffffffc02003fe:	033c8a63          	beq	s9,s3,ffffffffc0200432 <kmonitor+0xf8>
ffffffffc0200402:	003c9793          	sll	a5,s9,0x3
ffffffffc0200406:	08078793          	add	a5,a5,128
ffffffffc020040a:	978a                	add	a5,a5,sp
ffffffffc020040c:	f887b023          	sd	s0,-128(a5)
ffffffffc0200410:	00044583          	lbu	a1,0(s0)
ffffffffc0200414:	2c85                	addw	s9,s9,1
ffffffffc0200416:	e591                	bnez	a1,ffffffffc0200422 <kmonitor+0xe8>
ffffffffc0200418:	b74d                	j	ffffffffc02003ba <kmonitor+0x80>
ffffffffc020041a:	00144583          	lbu	a1,1(s0)
ffffffffc020041e:	0405                	add	s0,s0,1
ffffffffc0200420:	d9d9                	beqz	a1,ffffffffc02003b6 <kmonitor+0x7c>
ffffffffc0200422:	8526                	mv	a0,s1
ffffffffc0200424:	4e4050ef          	jal	ffffffffc0205908 <strchr>
ffffffffc0200428:	d96d                	beqz	a0,ffffffffc020041a <kmonitor+0xe0>
ffffffffc020042a:	00044583          	lbu	a1,0(s0)
ffffffffc020042e:	d5c1                	beqz	a1,ffffffffc02003b6 <kmonitor+0x7c>
ffffffffc0200430:	bf4d                	j	ffffffffc02003e2 <kmonitor+0xa8>
ffffffffc0200432:	45c1                	li	a1,16
ffffffffc0200434:	8556                	mv	a0,s5
ffffffffc0200436:	d55ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020043a:	b7e1                	j	ffffffffc0200402 <kmonitor+0xc8>
ffffffffc020043c:	00141793          	sll	a5,s0,0x1
ffffffffc0200440:	97a2                	add	a5,a5,s0
ffffffffc0200442:	078e                	sll	a5,a5,0x3
ffffffffc0200444:	97e2                	add	a5,a5,s8
ffffffffc0200446:	6b9c                	ld	a5,16(a5)
ffffffffc0200448:	865a                	mv	a2,s6
ffffffffc020044a:	002c                	add	a1,sp,8
ffffffffc020044c:	fffc851b          	addw	a0,s9,-1
ffffffffc0200450:	9782                	jalr	a5
ffffffffc0200452:	f40559e3          	bgez	a0,ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc0200456:	60ee                	ld	ra,216(sp)
ffffffffc0200458:	644e                	ld	s0,208(sp)
ffffffffc020045a:	64ae                	ld	s1,200(sp)
ffffffffc020045c:	690e                	ld	s2,192(sp)
ffffffffc020045e:	79ea                	ld	s3,184(sp)
ffffffffc0200460:	7a4a                	ld	s4,176(sp)
ffffffffc0200462:	7aaa                	ld	s5,168(sp)
ffffffffc0200464:	7b0a                	ld	s6,160(sp)
ffffffffc0200466:	6bea                	ld	s7,152(sp)
ffffffffc0200468:	6c4a                	ld	s8,144(sp)
ffffffffc020046a:	6caa                	ld	s9,136(sp)
ffffffffc020046c:	6d0a                	ld	s10,128(sp)
ffffffffc020046e:	612d                	add	sp,sp,224
ffffffffc0200470:	8082                	ret

ffffffffc0200472 <__panic>:
ffffffffc0200472:	00017317          	auipc	t1,0x17
ffffffffc0200476:	16e30313          	add	t1,t1,366 # ffffffffc02175e0 <is_panic>
ffffffffc020047a:	00033e03          	ld	t3,0(t1)
ffffffffc020047e:	715d                	add	sp,sp,-80
ffffffffc0200480:	ec06                	sd	ra,24(sp)
ffffffffc0200482:	e822                	sd	s0,16(sp)
ffffffffc0200484:	f436                	sd	a3,40(sp)
ffffffffc0200486:	f83a                	sd	a4,48(sp)
ffffffffc0200488:	fc3e                	sd	a5,56(sp)
ffffffffc020048a:	e0c2                	sd	a6,64(sp)
ffffffffc020048c:	e4c6                	sd	a7,72(sp)
ffffffffc020048e:	020e1a63          	bnez	t3,ffffffffc02004c2 <__panic+0x50>
ffffffffc0200492:	4785                	li	a5,1
ffffffffc0200494:	00f33023          	sd	a5,0(t1)
ffffffffc0200498:	8432                	mv	s0,a2
ffffffffc020049a:	103c                	add	a5,sp,40
ffffffffc020049c:	862e                	mv	a2,a1
ffffffffc020049e:	85aa                	mv	a1,a0
ffffffffc02004a0:	00005517          	auipc	a0,0x5
ffffffffc02004a4:	75050513          	add	a0,a0,1872 # ffffffffc0205bf0 <commands+0x48>
ffffffffc02004a8:	e43e                	sd	a5,8(sp)
ffffffffc02004aa:	ce1ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02004ae:	65a2                	ld	a1,8(sp)
ffffffffc02004b0:	8522                	mv	a0,s0
ffffffffc02004b2:	cb9ff0ef          	jal	ffffffffc020016a <vcprintf>
ffffffffc02004b6:	00007517          	auipc	a0,0x7
ffffffffc02004ba:	98a50513          	add	a0,a0,-1654 # ffffffffc0206e40 <default_pmm_manager+0x7b0>
ffffffffc02004be:	ccdff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02004c2:	4501                	li	a0,0
ffffffffc02004c4:	4581                	li	a1,0
ffffffffc02004c6:	4601                	li	a2,0
ffffffffc02004c8:	48a1                	li	a7,8
ffffffffc02004ca:	00000073          	ecall
ffffffffc02004ce:	166000ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02004d2:	4501                	li	a0,0
ffffffffc02004d4:	e67ff0ef          	jal	ffffffffc020033a <kmonitor>
ffffffffc02004d8:	bfed                	j	ffffffffc02004d2 <__panic+0x60>

ffffffffc02004da <__warn>:
ffffffffc02004da:	715d                	add	sp,sp,-80
ffffffffc02004dc:	832e                	mv	t1,a1
ffffffffc02004de:	e822                	sd	s0,16(sp)
ffffffffc02004e0:	85aa                	mv	a1,a0
ffffffffc02004e2:	8432                	mv	s0,a2
ffffffffc02004e4:	fc3e                	sd	a5,56(sp)
ffffffffc02004e6:	861a                	mv	a2,t1
ffffffffc02004e8:	103c                	add	a5,sp,40
ffffffffc02004ea:	00005517          	auipc	a0,0x5
ffffffffc02004ee:	72650513          	add	a0,a0,1830 # ffffffffc0205c10 <commands+0x68>
ffffffffc02004f2:	ec06                	sd	ra,24(sp)
ffffffffc02004f4:	f436                	sd	a3,40(sp)
ffffffffc02004f6:	f83a                	sd	a4,48(sp)
ffffffffc02004f8:	e0c2                	sd	a6,64(sp)
ffffffffc02004fa:	e4c6                	sd	a7,72(sp)
ffffffffc02004fc:	e43e                	sd	a5,8(sp)
ffffffffc02004fe:	c8dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200502:	65a2                	ld	a1,8(sp)
ffffffffc0200504:	8522                	mv	a0,s0
ffffffffc0200506:	c65ff0ef          	jal	ffffffffc020016a <vcprintf>
ffffffffc020050a:	00007517          	auipc	a0,0x7
ffffffffc020050e:	93650513          	add	a0,a0,-1738 # ffffffffc0206e40 <default_pmm_manager+0x7b0>
ffffffffc0200512:	c79ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200516:	60e2                	ld	ra,24(sp)
ffffffffc0200518:	6442                	ld	s0,16(sp)
ffffffffc020051a:	6161                	add	sp,sp,80
ffffffffc020051c:	8082                	ret

ffffffffc020051e <clock_init>:
ffffffffc020051e:	02000793          	li	a5,32
ffffffffc0200522:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200526:	c0102573          	rdtime	a0
ffffffffc020052a:	67e1                	lui	a5,0x18
ffffffffc020052c:	6a078793          	add	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200530:	953e                	add	a0,a0,a5
ffffffffc0200532:	4581                	li	a1,0
ffffffffc0200534:	4601                	li	a2,0
ffffffffc0200536:	4881                	li	a7,0
ffffffffc0200538:	00000073          	ecall
ffffffffc020053c:	00005517          	auipc	a0,0x5
ffffffffc0200540:	6f450513          	add	a0,a0,1780 # ffffffffc0205c30 <commands+0x88>
ffffffffc0200544:	00017797          	auipc	a5,0x17
ffffffffc0200548:	0a07b223          	sd	zero,164(a5) # ffffffffc02175e8 <ticks>
ffffffffc020054c:	b93d                	j	ffffffffc020018a <cprintf>

ffffffffc020054e <clock_set_next_event>:
ffffffffc020054e:	c0102573          	rdtime	a0
ffffffffc0200552:	67e1                	lui	a5,0x18
ffffffffc0200554:	6a078793          	add	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200558:	953e                	add	a0,a0,a5
ffffffffc020055a:	4581                	li	a1,0
ffffffffc020055c:	4601                	li	a2,0
ffffffffc020055e:	4881                	li	a7,0
ffffffffc0200560:	00000073          	ecall
ffffffffc0200564:	8082                	ret

ffffffffc0200566 <cons_init>:
ffffffffc0200566:	8082                	ret

ffffffffc0200568 <cons_putc>:
ffffffffc0200568:	100027f3          	csrr	a5,sstatus
ffffffffc020056c:	8b89                	and	a5,a5,2
ffffffffc020056e:	0ff57513          	zext.b	a0,a0
ffffffffc0200572:	e799                	bnez	a5,ffffffffc0200580 <cons_putc+0x18>
ffffffffc0200574:	4581                	li	a1,0
ffffffffc0200576:	4601                	li	a2,0
ffffffffc0200578:	4885                	li	a7,1
ffffffffc020057a:	00000073          	ecall
ffffffffc020057e:	8082                	ret
ffffffffc0200580:	1101                	add	sp,sp,-32
ffffffffc0200582:	ec06                	sd	ra,24(sp)
ffffffffc0200584:	e42a                	sd	a0,8(sp)
ffffffffc0200586:	0ae000ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020058a:	6522                	ld	a0,8(sp)
ffffffffc020058c:	4581                	li	a1,0
ffffffffc020058e:	4601                	li	a2,0
ffffffffc0200590:	4885                	li	a7,1
ffffffffc0200592:	00000073          	ecall
ffffffffc0200596:	60e2                	ld	ra,24(sp)
ffffffffc0200598:	6105                	add	sp,sp,32
ffffffffc020059a:	a851                	j	ffffffffc020062e <intr_enable>

ffffffffc020059c <cons_getc>:
ffffffffc020059c:	100027f3          	csrr	a5,sstatus
ffffffffc02005a0:	8b89                	and	a5,a5,2
ffffffffc02005a2:	eb89                	bnez	a5,ffffffffc02005b4 <cons_getc+0x18>
ffffffffc02005a4:	4501                	li	a0,0
ffffffffc02005a6:	4581                	li	a1,0
ffffffffc02005a8:	4601                	li	a2,0
ffffffffc02005aa:	4889                	li	a7,2
ffffffffc02005ac:	00000073          	ecall
ffffffffc02005b0:	2501                	sext.w	a0,a0
ffffffffc02005b2:	8082                	ret
ffffffffc02005b4:	1101                	add	sp,sp,-32
ffffffffc02005b6:	ec06                	sd	ra,24(sp)
ffffffffc02005b8:	07c000ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02005bc:	4501                	li	a0,0
ffffffffc02005be:	4581                	li	a1,0
ffffffffc02005c0:	4601                	li	a2,0
ffffffffc02005c2:	4889                	li	a7,2
ffffffffc02005c4:	00000073          	ecall
ffffffffc02005c8:	2501                	sext.w	a0,a0
ffffffffc02005ca:	e42a                	sd	a0,8(sp)
ffffffffc02005cc:	062000ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02005d0:	60e2                	ld	ra,24(sp)
ffffffffc02005d2:	6522                	ld	a0,8(sp)
ffffffffc02005d4:	6105                	add	sp,sp,32
ffffffffc02005d6:	8082                	ret

ffffffffc02005d8 <ide_init>:
ffffffffc02005d8:	8082                	ret

ffffffffc02005da <ide_device_valid>:
ffffffffc02005da:	00253513          	sltiu	a0,a0,2
ffffffffc02005de:	8082                	ret

ffffffffc02005e0 <ide_device_size>:
ffffffffc02005e0:	03800513          	li	a0,56
ffffffffc02005e4:	8082                	ret

ffffffffc02005e6 <ide_read_secs>:
ffffffffc02005e6:	0000c797          	auipc	a5,0xc
ffffffffc02005ea:	eaa78793          	add	a5,a5,-342 # ffffffffc020c490 <ide>
ffffffffc02005ee:	0095959b          	sllw	a1,a1,0x9
ffffffffc02005f2:	1141                	add	sp,sp,-16
ffffffffc02005f4:	8532                	mv	a0,a2
ffffffffc02005f6:	95be                	add	a1,a1,a5
ffffffffc02005f8:	00969613          	sll	a2,a3,0x9
ffffffffc02005fc:	e406                	sd	ra,8(sp)
ffffffffc02005fe:	332050ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc0200602:	60a2                	ld	ra,8(sp)
ffffffffc0200604:	4501                	li	a0,0
ffffffffc0200606:	0141                	add	sp,sp,16
ffffffffc0200608:	8082                	ret

ffffffffc020060a <ide_write_secs>:
ffffffffc020060a:	0095979b          	sllw	a5,a1,0x9
ffffffffc020060e:	0000c517          	auipc	a0,0xc
ffffffffc0200612:	e8250513          	add	a0,a0,-382 # ffffffffc020c490 <ide>
ffffffffc0200616:	1141                	add	sp,sp,-16
ffffffffc0200618:	85b2                	mv	a1,a2
ffffffffc020061a:	953e                	add	a0,a0,a5
ffffffffc020061c:	00969613          	sll	a2,a3,0x9
ffffffffc0200620:	e406                	sd	ra,8(sp)
ffffffffc0200622:	30e050ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc0200626:	60a2                	ld	ra,8(sp)
ffffffffc0200628:	4501                	li	a0,0
ffffffffc020062a:	0141                	add	sp,sp,16
ffffffffc020062c:	8082                	ret

ffffffffc020062e <intr_enable>:
ffffffffc020062e:	100167f3          	csrrs	a5,sstatus,2
ffffffffc0200632:	8082                	ret

ffffffffc0200634 <intr_disable>:
ffffffffc0200634:	100177f3          	csrrc	a5,sstatus,2
ffffffffc0200638:	8082                	ret

ffffffffc020063a <pic_init>:
ffffffffc020063a:	8082                	ret

ffffffffc020063c <idt_init>:
ffffffffc020063c:	14005073          	csrw	sscratch,0
ffffffffc0200640:	00000797          	auipc	a5,0x0
ffffffffc0200644:	60c78793          	add	a5,a5,1548 # ffffffffc0200c4c <__alltraps>
ffffffffc0200648:	10579073          	csrw	stvec,a5
ffffffffc020064c:	000407b7          	lui	a5,0x40
ffffffffc0200650:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200654:	8082                	ret

ffffffffc0200656 <print_regs>:
ffffffffc0200656:	610c                	ld	a1,0(a0)
ffffffffc0200658:	1141                	add	sp,sp,-16
ffffffffc020065a:	e022                	sd	s0,0(sp)
ffffffffc020065c:	842a                	mv	s0,a0
ffffffffc020065e:	00005517          	auipc	a0,0x5
ffffffffc0200662:	5f250513          	add	a0,a0,1522 # ffffffffc0205c50 <commands+0xa8>
ffffffffc0200666:	e406                	sd	ra,8(sp)
ffffffffc0200668:	b23ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020066c:	640c                	ld	a1,8(s0)
ffffffffc020066e:	00005517          	auipc	a0,0x5
ffffffffc0200672:	5fa50513          	add	a0,a0,1530 # ffffffffc0205c68 <commands+0xc0>
ffffffffc0200676:	b15ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020067a:	680c                	ld	a1,16(s0)
ffffffffc020067c:	00005517          	auipc	a0,0x5
ffffffffc0200680:	60450513          	add	a0,a0,1540 # ffffffffc0205c80 <commands+0xd8>
ffffffffc0200684:	b07ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200688:	6c0c                	ld	a1,24(s0)
ffffffffc020068a:	00005517          	auipc	a0,0x5
ffffffffc020068e:	60e50513          	add	a0,a0,1550 # ffffffffc0205c98 <commands+0xf0>
ffffffffc0200692:	af9ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200696:	700c                	ld	a1,32(s0)
ffffffffc0200698:	00005517          	auipc	a0,0x5
ffffffffc020069c:	61850513          	add	a0,a0,1560 # ffffffffc0205cb0 <commands+0x108>
ffffffffc02006a0:	aebff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006a4:	740c                	ld	a1,40(s0)
ffffffffc02006a6:	00005517          	auipc	a0,0x5
ffffffffc02006aa:	62250513          	add	a0,a0,1570 # ffffffffc0205cc8 <commands+0x120>
ffffffffc02006ae:	addff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006b2:	780c                	ld	a1,48(s0)
ffffffffc02006b4:	00005517          	auipc	a0,0x5
ffffffffc02006b8:	62c50513          	add	a0,a0,1580 # ffffffffc0205ce0 <commands+0x138>
ffffffffc02006bc:	acfff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006c0:	7c0c                	ld	a1,56(s0)
ffffffffc02006c2:	00005517          	auipc	a0,0x5
ffffffffc02006c6:	63650513          	add	a0,a0,1590 # ffffffffc0205cf8 <commands+0x150>
ffffffffc02006ca:	ac1ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006ce:	602c                	ld	a1,64(s0)
ffffffffc02006d0:	00005517          	auipc	a0,0x5
ffffffffc02006d4:	64050513          	add	a0,a0,1600 # ffffffffc0205d10 <commands+0x168>
ffffffffc02006d8:	ab3ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006dc:	642c                	ld	a1,72(s0)
ffffffffc02006de:	00005517          	auipc	a0,0x5
ffffffffc02006e2:	64a50513          	add	a0,a0,1610 # ffffffffc0205d28 <commands+0x180>
ffffffffc02006e6:	aa5ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006ea:	682c                	ld	a1,80(s0)
ffffffffc02006ec:	00005517          	auipc	a0,0x5
ffffffffc02006f0:	65450513          	add	a0,a0,1620 # ffffffffc0205d40 <commands+0x198>
ffffffffc02006f4:	a97ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006f8:	6c2c                	ld	a1,88(s0)
ffffffffc02006fa:	00005517          	auipc	a0,0x5
ffffffffc02006fe:	65e50513          	add	a0,a0,1630 # ffffffffc0205d58 <commands+0x1b0>
ffffffffc0200702:	a89ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200706:	702c                	ld	a1,96(s0)
ffffffffc0200708:	00005517          	auipc	a0,0x5
ffffffffc020070c:	66850513          	add	a0,a0,1640 # ffffffffc0205d70 <commands+0x1c8>
ffffffffc0200710:	a7bff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200714:	742c                	ld	a1,104(s0)
ffffffffc0200716:	00005517          	auipc	a0,0x5
ffffffffc020071a:	67250513          	add	a0,a0,1650 # ffffffffc0205d88 <commands+0x1e0>
ffffffffc020071e:	a6dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200722:	782c                	ld	a1,112(s0)
ffffffffc0200724:	00005517          	auipc	a0,0x5
ffffffffc0200728:	67c50513          	add	a0,a0,1660 # ffffffffc0205da0 <commands+0x1f8>
ffffffffc020072c:	a5fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200730:	7c2c                	ld	a1,120(s0)
ffffffffc0200732:	00005517          	auipc	a0,0x5
ffffffffc0200736:	68650513          	add	a0,a0,1670 # ffffffffc0205db8 <commands+0x210>
ffffffffc020073a:	a51ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020073e:	604c                	ld	a1,128(s0)
ffffffffc0200740:	00005517          	auipc	a0,0x5
ffffffffc0200744:	69050513          	add	a0,a0,1680 # ffffffffc0205dd0 <commands+0x228>
ffffffffc0200748:	a43ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020074c:	644c                	ld	a1,136(s0)
ffffffffc020074e:	00005517          	auipc	a0,0x5
ffffffffc0200752:	69a50513          	add	a0,a0,1690 # ffffffffc0205de8 <commands+0x240>
ffffffffc0200756:	a35ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020075a:	684c                	ld	a1,144(s0)
ffffffffc020075c:	00005517          	auipc	a0,0x5
ffffffffc0200760:	6a450513          	add	a0,a0,1700 # ffffffffc0205e00 <commands+0x258>
ffffffffc0200764:	a27ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200768:	6c4c                	ld	a1,152(s0)
ffffffffc020076a:	00005517          	auipc	a0,0x5
ffffffffc020076e:	6ae50513          	add	a0,a0,1710 # ffffffffc0205e18 <commands+0x270>
ffffffffc0200772:	a19ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200776:	704c                	ld	a1,160(s0)
ffffffffc0200778:	00005517          	auipc	a0,0x5
ffffffffc020077c:	6b850513          	add	a0,a0,1720 # ffffffffc0205e30 <commands+0x288>
ffffffffc0200780:	a0bff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200784:	744c                	ld	a1,168(s0)
ffffffffc0200786:	00005517          	auipc	a0,0x5
ffffffffc020078a:	6c250513          	add	a0,a0,1730 # ffffffffc0205e48 <commands+0x2a0>
ffffffffc020078e:	9fdff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200792:	784c                	ld	a1,176(s0)
ffffffffc0200794:	00005517          	auipc	a0,0x5
ffffffffc0200798:	6cc50513          	add	a0,a0,1740 # ffffffffc0205e60 <commands+0x2b8>
ffffffffc020079c:	9efff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007a0:	7c4c                	ld	a1,184(s0)
ffffffffc02007a2:	00005517          	auipc	a0,0x5
ffffffffc02007a6:	6d650513          	add	a0,a0,1750 # ffffffffc0205e78 <commands+0x2d0>
ffffffffc02007aa:	9e1ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007ae:	606c                	ld	a1,192(s0)
ffffffffc02007b0:	00005517          	auipc	a0,0x5
ffffffffc02007b4:	6e050513          	add	a0,a0,1760 # ffffffffc0205e90 <commands+0x2e8>
ffffffffc02007b8:	9d3ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007bc:	646c                	ld	a1,200(s0)
ffffffffc02007be:	00005517          	auipc	a0,0x5
ffffffffc02007c2:	6ea50513          	add	a0,a0,1770 # ffffffffc0205ea8 <commands+0x300>
ffffffffc02007c6:	9c5ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007ca:	686c                	ld	a1,208(s0)
ffffffffc02007cc:	00005517          	auipc	a0,0x5
ffffffffc02007d0:	6f450513          	add	a0,a0,1780 # ffffffffc0205ec0 <commands+0x318>
ffffffffc02007d4:	9b7ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007d8:	6c6c                	ld	a1,216(s0)
ffffffffc02007da:	00005517          	auipc	a0,0x5
ffffffffc02007de:	6fe50513          	add	a0,a0,1790 # ffffffffc0205ed8 <commands+0x330>
ffffffffc02007e2:	9a9ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007e6:	706c                	ld	a1,224(s0)
ffffffffc02007e8:	00005517          	auipc	a0,0x5
ffffffffc02007ec:	70850513          	add	a0,a0,1800 # ffffffffc0205ef0 <commands+0x348>
ffffffffc02007f0:	99bff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007f4:	746c                	ld	a1,232(s0)
ffffffffc02007f6:	00005517          	auipc	a0,0x5
ffffffffc02007fa:	71250513          	add	a0,a0,1810 # ffffffffc0205f08 <commands+0x360>
ffffffffc02007fe:	98dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200802:	786c                	ld	a1,240(s0)
ffffffffc0200804:	00005517          	auipc	a0,0x5
ffffffffc0200808:	71c50513          	add	a0,a0,1820 # ffffffffc0205f20 <commands+0x378>
ffffffffc020080c:	97fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200810:	7c6c                	ld	a1,248(s0)
ffffffffc0200812:	6402                	ld	s0,0(sp)
ffffffffc0200814:	60a2                	ld	ra,8(sp)
ffffffffc0200816:	00005517          	auipc	a0,0x5
ffffffffc020081a:	72250513          	add	a0,a0,1826 # ffffffffc0205f38 <commands+0x390>
ffffffffc020081e:	0141                	add	sp,sp,16
ffffffffc0200820:	96bff06f          	j	ffffffffc020018a <cprintf>

ffffffffc0200824 <print_trapframe>:
ffffffffc0200824:	1141                	add	sp,sp,-16
ffffffffc0200826:	e022                	sd	s0,0(sp)
ffffffffc0200828:	85aa                	mv	a1,a0
ffffffffc020082a:	842a                	mv	s0,a0
ffffffffc020082c:	00005517          	auipc	a0,0x5
ffffffffc0200830:	72450513          	add	a0,a0,1828 # ffffffffc0205f50 <commands+0x3a8>
ffffffffc0200834:	e406                	sd	ra,8(sp)
ffffffffc0200836:	955ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020083a:	8522                	mv	a0,s0
ffffffffc020083c:	e1bff0ef          	jal	ffffffffc0200656 <print_regs>
ffffffffc0200840:	10043583          	ld	a1,256(s0)
ffffffffc0200844:	00005517          	auipc	a0,0x5
ffffffffc0200848:	72450513          	add	a0,a0,1828 # ffffffffc0205f68 <commands+0x3c0>
ffffffffc020084c:	93fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200850:	10843583          	ld	a1,264(s0)
ffffffffc0200854:	00005517          	auipc	a0,0x5
ffffffffc0200858:	72c50513          	add	a0,a0,1836 # ffffffffc0205f80 <commands+0x3d8>
ffffffffc020085c:	92fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200860:	11043583          	ld	a1,272(s0)
ffffffffc0200864:	00005517          	auipc	a0,0x5
ffffffffc0200868:	73450513          	add	a0,a0,1844 # ffffffffc0205f98 <commands+0x3f0>
ffffffffc020086c:	91fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200870:	11843583          	ld	a1,280(s0)
ffffffffc0200874:	6402                	ld	s0,0(sp)
ffffffffc0200876:	60a2                	ld	ra,8(sp)
ffffffffc0200878:	00005517          	auipc	a0,0x5
ffffffffc020087c:	73050513          	add	a0,a0,1840 # ffffffffc0205fa8 <commands+0x400>
ffffffffc0200880:	0141                	add	sp,sp,16
ffffffffc0200882:	909ff06f          	j	ffffffffc020018a <cprintf>

ffffffffc0200886 <pgfault_handler>:
ffffffffc0200886:	1101                	add	sp,sp,-32
ffffffffc0200888:	e426                	sd	s1,8(sp)
ffffffffc020088a:	00017497          	auipc	s1,0x17
ffffffffc020088e:	dbe48493          	add	s1,s1,-578 # ffffffffc0217648 <check_mm_struct>
ffffffffc0200892:	609c                	ld	a5,0(s1)
ffffffffc0200894:	e822                	sd	s0,16(sp)
ffffffffc0200896:	ec06                	sd	ra,24(sp)
ffffffffc0200898:	842a                	mv	s0,a0
ffffffffc020089a:	cfb9                	beqz	a5,ffffffffc02008f8 <pgfault_handler+0x72>
ffffffffc020089c:	10053783          	ld	a5,256(a0)
ffffffffc02008a0:	11053583          	ld	a1,272(a0)
ffffffffc02008a4:	05500613          	li	a2,85
ffffffffc02008a8:	1007f793          	and	a5,a5,256
ffffffffc02008ac:	c399                	beqz	a5,ffffffffc02008b2 <pgfault_handler+0x2c>
ffffffffc02008ae:	04b00613          	li	a2,75
ffffffffc02008b2:	11843703          	ld	a4,280(s0)
ffffffffc02008b6:	47bd                	li	a5,15
ffffffffc02008b8:	05200693          	li	a3,82
ffffffffc02008bc:	04f70e63          	beq	a4,a5,ffffffffc0200918 <pgfault_handler+0x92>
ffffffffc02008c0:	00005517          	auipc	a0,0x5
ffffffffc02008c4:	70050513          	add	a0,a0,1792 # ffffffffc0205fc0 <commands+0x418>
ffffffffc02008c8:	8c3ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02008cc:	6088                	ld	a0,0(s1)
ffffffffc02008ce:	c50d                	beqz	a0,ffffffffc02008f8 <pgfault_handler+0x72>
ffffffffc02008d0:	00017717          	auipc	a4,0x17
ffffffffc02008d4:	d8873703          	ld	a4,-632(a4) # ffffffffc0217658 <current>
ffffffffc02008d8:	00017797          	auipc	a5,0x17
ffffffffc02008dc:	d907b783          	ld	a5,-624(a5) # ffffffffc0217668 <idleproc>
ffffffffc02008e0:	02f71f63          	bne	a4,a5,ffffffffc020091e <pgfault_handler+0x98>
ffffffffc02008e4:	11043603          	ld	a2,272(s0)
ffffffffc02008e8:	11843583          	ld	a1,280(s0)
ffffffffc02008ec:	6442                	ld	s0,16(sp)
ffffffffc02008ee:	60e2                	ld	ra,24(sp)
ffffffffc02008f0:	64a2                	ld	s1,8(sp)
ffffffffc02008f2:	6105                	add	sp,sp,32
ffffffffc02008f4:	6c40206f          	j	ffffffffc0202fb8 <do_pgfault>
ffffffffc02008f8:	00017797          	auipc	a5,0x17
ffffffffc02008fc:	d607b783          	ld	a5,-672(a5) # ffffffffc0217658 <current>
ffffffffc0200900:	cf9d                	beqz	a5,ffffffffc020093e <pgfault_handler+0xb8>
ffffffffc0200902:	11043603          	ld	a2,272(s0)
ffffffffc0200906:	11843583          	ld	a1,280(s0)
ffffffffc020090a:	6442                	ld	s0,16(sp)
ffffffffc020090c:	60e2                	ld	ra,24(sp)
ffffffffc020090e:	64a2                	ld	s1,8(sp)
ffffffffc0200910:	7788                	ld	a0,40(a5)
ffffffffc0200912:	6105                	add	sp,sp,32
ffffffffc0200914:	6a40206f          	j	ffffffffc0202fb8 <do_pgfault>
ffffffffc0200918:	05700693          	li	a3,87
ffffffffc020091c:	b755                	j	ffffffffc02008c0 <pgfault_handler+0x3a>
ffffffffc020091e:	00005697          	auipc	a3,0x5
ffffffffc0200922:	6c268693          	add	a3,a3,1730 # ffffffffc0205fe0 <commands+0x438>
ffffffffc0200926:	00005617          	auipc	a2,0x5
ffffffffc020092a:	6d260613          	add	a2,a2,1746 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020092e:	06c00593          	li	a1,108
ffffffffc0200932:	00005517          	auipc	a0,0x5
ffffffffc0200936:	6de50513          	add	a0,a0,1758 # ffffffffc0206010 <commands+0x468>
ffffffffc020093a:	b39ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020093e:	8522                	mv	a0,s0
ffffffffc0200940:	ee5ff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200944:	10043783          	ld	a5,256(s0)
ffffffffc0200948:	11043583          	ld	a1,272(s0)
ffffffffc020094c:	05500613          	li	a2,85
ffffffffc0200950:	1007f793          	and	a5,a5,256
ffffffffc0200954:	c399                	beqz	a5,ffffffffc020095a <pgfault_handler+0xd4>
ffffffffc0200956:	04b00613          	li	a2,75
ffffffffc020095a:	11843703          	ld	a4,280(s0)
ffffffffc020095e:	47bd                	li	a5,15
ffffffffc0200960:	05200693          	li	a3,82
ffffffffc0200964:	00f71463          	bne	a4,a5,ffffffffc020096c <pgfault_handler+0xe6>
ffffffffc0200968:	05700693          	li	a3,87
ffffffffc020096c:	00005517          	auipc	a0,0x5
ffffffffc0200970:	65450513          	add	a0,a0,1620 # ffffffffc0205fc0 <commands+0x418>
ffffffffc0200974:	817ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200978:	00005617          	auipc	a2,0x5
ffffffffc020097c:	6b060613          	add	a2,a2,1712 # ffffffffc0206028 <commands+0x480>
ffffffffc0200980:	07300593          	li	a1,115
ffffffffc0200984:	00005517          	auipc	a0,0x5
ffffffffc0200988:	68c50513          	add	a0,a0,1676 # ffffffffc0206010 <commands+0x468>
ffffffffc020098c:	ae7ff0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0200990 <interrupt_handler>:
ffffffffc0200990:	11853783          	ld	a5,280(a0)
ffffffffc0200994:	472d                	li	a4,11
ffffffffc0200996:	0786                	sll	a5,a5,0x1
ffffffffc0200998:	8385                	srl	a5,a5,0x1
ffffffffc020099a:	06f76863          	bltu	a4,a5,ffffffffc0200a0a <interrupt_handler+0x7a>
ffffffffc020099e:	00005717          	auipc	a4,0x5
ffffffffc02009a2:	74270713          	add	a4,a4,1858 # ffffffffc02060e0 <commands+0x538>
ffffffffc02009a6:	078a                	sll	a5,a5,0x2
ffffffffc02009a8:	97ba                	add	a5,a5,a4
ffffffffc02009aa:	439c                	lw	a5,0(a5)
ffffffffc02009ac:	97ba                	add	a5,a5,a4
ffffffffc02009ae:	8782                	jr	a5
ffffffffc02009b0:	00005517          	auipc	a0,0x5
ffffffffc02009b4:	6f050513          	add	a0,a0,1776 # ffffffffc02060a0 <commands+0x4f8>
ffffffffc02009b8:	fd2ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009bc:	00005517          	auipc	a0,0x5
ffffffffc02009c0:	6c450513          	add	a0,a0,1732 # ffffffffc0206080 <commands+0x4d8>
ffffffffc02009c4:	fc6ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009c8:	00005517          	auipc	a0,0x5
ffffffffc02009cc:	67850513          	add	a0,a0,1656 # ffffffffc0206040 <commands+0x498>
ffffffffc02009d0:	fbaff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009d4:	00005517          	auipc	a0,0x5
ffffffffc02009d8:	68c50513          	add	a0,a0,1676 # ffffffffc0206060 <commands+0x4b8>
ffffffffc02009dc:	faeff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009e0:	1141                	add	sp,sp,-16
ffffffffc02009e2:	e406                	sd	ra,8(sp)
ffffffffc02009e4:	b6bff0ef          	jal	ffffffffc020054e <clock_set_next_event>
ffffffffc02009e8:	00017717          	auipc	a4,0x17
ffffffffc02009ec:	c0070713          	add	a4,a4,-1024 # ffffffffc02175e8 <ticks>
ffffffffc02009f0:	631c                	ld	a5,0(a4)
ffffffffc02009f2:	60a2                	ld	ra,8(sp)
ffffffffc02009f4:	0785                	add	a5,a5,1
ffffffffc02009f6:	e31c                	sd	a5,0(a4)
ffffffffc02009f8:	0141                	add	sp,sp,16
ffffffffc02009fa:	0750406f          	j	ffffffffc020526e <run_timer_list>
ffffffffc02009fe:	00005517          	auipc	a0,0x5
ffffffffc0200a02:	6c250513          	add	a0,a0,1730 # ffffffffc02060c0 <commands+0x518>
ffffffffc0200a06:	f84ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc0200a0a:	bd29                	j	ffffffffc0200824 <print_trapframe>

ffffffffc0200a0c <exception_handler>:
ffffffffc0200a0c:	11853783          	ld	a5,280(a0)
ffffffffc0200a10:	1101                	add	sp,sp,-32
ffffffffc0200a12:	e822                	sd	s0,16(sp)
ffffffffc0200a14:	ec06                	sd	ra,24(sp)
ffffffffc0200a16:	e426                	sd	s1,8(sp)
ffffffffc0200a18:	473d                	li	a4,15
ffffffffc0200a1a:	842a                	mv	s0,a0
ffffffffc0200a1c:	16f76163          	bltu	a4,a5,ffffffffc0200b7e <exception_handler+0x172>
ffffffffc0200a20:	00006717          	auipc	a4,0x6
ffffffffc0200a24:	88870713          	add	a4,a4,-1912 # ffffffffc02062a8 <commands+0x700>
ffffffffc0200a28:	078a                	sll	a5,a5,0x2
ffffffffc0200a2a:	97ba                	add	a5,a5,a4
ffffffffc0200a2c:	439c                	lw	a5,0(a5)
ffffffffc0200a2e:	97ba                	add	a5,a5,a4
ffffffffc0200a30:	8782                	jr	a5
ffffffffc0200a32:	00005517          	auipc	a0,0x5
ffffffffc0200a36:	7ce50513          	add	a0,a0,1998 # ffffffffc0206200 <commands+0x658>
ffffffffc0200a3a:	f50ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200a3e:	10843783          	ld	a5,264(s0)
ffffffffc0200a42:	60e2                	ld	ra,24(sp)
ffffffffc0200a44:	64a2                	ld	s1,8(sp)
ffffffffc0200a46:	0791                	add	a5,a5,4
ffffffffc0200a48:	10f43423          	sd	a5,264(s0)
ffffffffc0200a4c:	6442                	ld	s0,16(sp)
ffffffffc0200a4e:	6105                	add	sp,sp,32
ffffffffc0200a50:	1e30406f          	j	ffffffffc0205432 <syscall>
ffffffffc0200a54:	00005517          	auipc	a0,0x5
ffffffffc0200a58:	7cc50513          	add	a0,a0,1996 # ffffffffc0206220 <commands+0x678>
ffffffffc0200a5c:	6442                	ld	s0,16(sp)
ffffffffc0200a5e:	60e2                	ld	ra,24(sp)
ffffffffc0200a60:	64a2                	ld	s1,8(sp)
ffffffffc0200a62:	6105                	add	sp,sp,32
ffffffffc0200a64:	f26ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc0200a68:	00005517          	auipc	a0,0x5
ffffffffc0200a6c:	7d850513          	add	a0,a0,2008 # ffffffffc0206240 <commands+0x698>
ffffffffc0200a70:	b7f5                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200a72:	00005517          	auipc	a0,0x5
ffffffffc0200a76:	7ee50513          	add	a0,a0,2030 # ffffffffc0206260 <commands+0x6b8>
ffffffffc0200a7a:	b7cd                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200a7c:	00005517          	auipc	a0,0x5
ffffffffc0200a80:	7fc50513          	add	a0,a0,2044 # ffffffffc0206278 <commands+0x6d0>
ffffffffc0200a84:	f06ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200a88:	8522                	mv	a0,s0
ffffffffc0200a8a:	dfdff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200a8e:	84aa                	mv	s1,a0
ffffffffc0200a90:	10051963          	bnez	a0,ffffffffc0200ba2 <exception_handler+0x196>
ffffffffc0200a94:	60e2                	ld	ra,24(sp)
ffffffffc0200a96:	6442                	ld	s0,16(sp)
ffffffffc0200a98:	64a2                	ld	s1,8(sp)
ffffffffc0200a9a:	6105                	add	sp,sp,32
ffffffffc0200a9c:	8082                	ret
ffffffffc0200a9e:	00005517          	auipc	a0,0x5
ffffffffc0200aa2:	7f250513          	add	a0,a0,2034 # ffffffffc0206290 <commands+0x6e8>
ffffffffc0200aa6:	ee4ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200aaa:	8522                	mv	a0,s0
ffffffffc0200aac:	ddbff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200ab0:	84aa                	mv	s1,a0
ffffffffc0200ab2:	d16d                	beqz	a0,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200ab4:	8522                	mv	a0,s0
ffffffffc0200ab6:	d6fff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200aba:	86a6                	mv	a3,s1
ffffffffc0200abc:	00005617          	auipc	a2,0x5
ffffffffc0200ac0:	6f460613          	add	a2,a2,1780 # ffffffffc02061b0 <commands+0x608>
ffffffffc0200ac4:	0f600593          	li	a1,246
ffffffffc0200ac8:	00005517          	auipc	a0,0x5
ffffffffc0200acc:	54850513          	add	a0,a0,1352 # ffffffffc0206010 <commands+0x468>
ffffffffc0200ad0:	9a3ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200ad4:	00005517          	auipc	a0,0x5
ffffffffc0200ad8:	63c50513          	add	a0,a0,1596 # ffffffffc0206110 <commands+0x568>
ffffffffc0200adc:	b741                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200ade:	00005517          	auipc	a0,0x5
ffffffffc0200ae2:	65250513          	add	a0,a0,1618 # ffffffffc0206130 <commands+0x588>
ffffffffc0200ae6:	bf9d                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200ae8:	00005517          	auipc	a0,0x5
ffffffffc0200aec:	66850513          	add	a0,a0,1640 # ffffffffc0206150 <commands+0x5a8>
ffffffffc0200af0:	b7b5                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200af2:	00005517          	auipc	a0,0x5
ffffffffc0200af6:	67650513          	add	a0,a0,1654 # ffffffffc0206168 <commands+0x5c0>
ffffffffc0200afa:	e90ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200afe:	6458                	ld	a4,136(s0)
ffffffffc0200b00:	47a9                	li	a5,10
ffffffffc0200b02:	f8f719e3          	bne	a4,a5,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200b06:	bf25                	j	ffffffffc0200a3e <exception_handler+0x32>
ffffffffc0200b08:	00005517          	auipc	a0,0x5
ffffffffc0200b0c:	67050513          	add	a0,a0,1648 # ffffffffc0206178 <commands+0x5d0>
ffffffffc0200b10:	b7b1                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200b12:	00005517          	auipc	a0,0x5
ffffffffc0200b16:	68650513          	add	a0,a0,1670 # ffffffffc0206198 <commands+0x5f0>
ffffffffc0200b1a:	e70ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200b1e:	8522                	mv	a0,s0
ffffffffc0200b20:	d67ff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200b24:	84aa                	mv	s1,a0
ffffffffc0200b26:	d53d                	beqz	a0,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200b28:	8522                	mv	a0,s0
ffffffffc0200b2a:	cfbff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200b2e:	86a6                	mv	a3,s1
ffffffffc0200b30:	00005617          	auipc	a2,0x5
ffffffffc0200b34:	68060613          	add	a2,a2,1664 # ffffffffc02061b0 <commands+0x608>
ffffffffc0200b38:	0cb00593          	li	a1,203
ffffffffc0200b3c:	00005517          	auipc	a0,0x5
ffffffffc0200b40:	4d450513          	add	a0,a0,1236 # ffffffffc0206010 <commands+0x468>
ffffffffc0200b44:	92fff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200b48:	00005517          	auipc	a0,0x5
ffffffffc0200b4c:	6a050513          	add	a0,a0,1696 # ffffffffc02061e8 <commands+0x640>
ffffffffc0200b50:	e3aff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200b54:	8522                	mv	a0,s0
ffffffffc0200b56:	d31ff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200b5a:	84aa                	mv	s1,a0
ffffffffc0200b5c:	dd05                	beqz	a0,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200b5e:	8522                	mv	a0,s0
ffffffffc0200b60:	cc5ff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200b64:	86a6                	mv	a3,s1
ffffffffc0200b66:	00005617          	auipc	a2,0x5
ffffffffc0200b6a:	64a60613          	add	a2,a2,1610 # ffffffffc02061b0 <commands+0x608>
ffffffffc0200b6e:	0d500593          	li	a1,213
ffffffffc0200b72:	00005517          	auipc	a0,0x5
ffffffffc0200b76:	49e50513          	add	a0,a0,1182 # ffffffffc0206010 <commands+0x468>
ffffffffc0200b7a:	8f9ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200b7e:	8522                	mv	a0,s0
ffffffffc0200b80:	6442                	ld	s0,16(sp)
ffffffffc0200b82:	60e2                	ld	ra,24(sp)
ffffffffc0200b84:	64a2                	ld	s1,8(sp)
ffffffffc0200b86:	6105                	add	sp,sp,32
ffffffffc0200b88:	b971                	j	ffffffffc0200824 <print_trapframe>
ffffffffc0200b8a:	00005617          	auipc	a2,0x5
ffffffffc0200b8e:	64660613          	add	a2,a2,1606 # ffffffffc02061d0 <commands+0x628>
ffffffffc0200b92:	0cf00593          	li	a1,207
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	47a50513          	add	a0,a0,1146 # ffffffffc0206010 <commands+0x468>
ffffffffc0200b9e:	8d5ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200ba2:	8522                	mv	a0,s0
ffffffffc0200ba4:	c81ff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200ba8:	86a6                	mv	a3,s1
ffffffffc0200baa:	00005617          	auipc	a2,0x5
ffffffffc0200bae:	60660613          	add	a2,a2,1542 # ffffffffc02061b0 <commands+0x608>
ffffffffc0200bb2:	0ef00593          	li	a1,239
ffffffffc0200bb6:	00005517          	auipc	a0,0x5
ffffffffc0200bba:	45a50513          	add	a0,a0,1114 # ffffffffc0206010 <commands+0x468>
ffffffffc0200bbe:	8b5ff0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0200bc2 <trap>:
ffffffffc0200bc2:	1101                	add	sp,sp,-32
ffffffffc0200bc4:	e822                	sd	s0,16(sp)
ffffffffc0200bc6:	00017417          	auipc	s0,0x17
ffffffffc0200bca:	a9240413          	add	s0,s0,-1390 # ffffffffc0217658 <current>
ffffffffc0200bce:	6018                	ld	a4,0(s0)
ffffffffc0200bd0:	ec06                	sd	ra,24(sp)
ffffffffc0200bd2:	e426                	sd	s1,8(sp)
ffffffffc0200bd4:	e04a                	sd	s2,0(sp)
ffffffffc0200bd6:	11853683          	ld	a3,280(a0)
ffffffffc0200bda:	cf1d                	beqz	a4,ffffffffc0200c18 <trap+0x56>
ffffffffc0200bdc:	10053483          	ld	s1,256(a0)
ffffffffc0200be0:	0a073903          	ld	s2,160(a4)
ffffffffc0200be4:	f348                	sd	a0,160(a4)
ffffffffc0200be6:	1004f493          	and	s1,s1,256
ffffffffc0200bea:	0206c463          	bltz	a3,ffffffffc0200c12 <trap+0x50>
ffffffffc0200bee:	e1fff0ef          	jal	ffffffffc0200a0c <exception_handler>
ffffffffc0200bf2:	601c                	ld	a5,0(s0)
ffffffffc0200bf4:	0b27b023          	sd	s2,160(a5)
ffffffffc0200bf8:	e499                	bnez	s1,ffffffffc0200c06 <trap+0x44>
ffffffffc0200bfa:	0b07a703          	lw	a4,176(a5)
ffffffffc0200bfe:	8b05                	and	a4,a4,1
ffffffffc0200c00:	e329                	bnez	a4,ffffffffc0200c42 <trap+0x80>
ffffffffc0200c02:	6f9c                	ld	a5,24(a5)
ffffffffc0200c04:	eb85                	bnez	a5,ffffffffc0200c34 <trap+0x72>
ffffffffc0200c06:	60e2                	ld	ra,24(sp)
ffffffffc0200c08:	6442                	ld	s0,16(sp)
ffffffffc0200c0a:	64a2                	ld	s1,8(sp)
ffffffffc0200c0c:	6902                	ld	s2,0(sp)
ffffffffc0200c0e:	6105                	add	sp,sp,32
ffffffffc0200c10:	8082                	ret
ffffffffc0200c12:	d7fff0ef          	jal	ffffffffc0200990 <interrupt_handler>
ffffffffc0200c16:	bff1                	j	ffffffffc0200bf2 <trap+0x30>
ffffffffc0200c18:	0006c863          	bltz	a3,ffffffffc0200c28 <trap+0x66>
ffffffffc0200c1c:	6442                	ld	s0,16(sp)
ffffffffc0200c1e:	60e2                	ld	ra,24(sp)
ffffffffc0200c20:	64a2                	ld	s1,8(sp)
ffffffffc0200c22:	6902                	ld	s2,0(sp)
ffffffffc0200c24:	6105                	add	sp,sp,32
ffffffffc0200c26:	b3dd                	j	ffffffffc0200a0c <exception_handler>
ffffffffc0200c28:	6442                	ld	s0,16(sp)
ffffffffc0200c2a:	60e2                	ld	ra,24(sp)
ffffffffc0200c2c:	64a2                	ld	s1,8(sp)
ffffffffc0200c2e:	6902                	ld	s2,0(sp)
ffffffffc0200c30:	6105                	add	sp,sp,32
ffffffffc0200c32:	bbb9                	j	ffffffffc0200990 <interrupt_handler>
ffffffffc0200c34:	6442                	ld	s0,16(sp)
ffffffffc0200c36:	60e2                	ld	ra,24(sp)
ffffffffc0200c38:	64a2                	ld	s1,8(sp)
ffffffffc0200c3a:	6902                	ld	s2,0(sp)
ffffffffc0200c3c:	6105                	add	sp,sp,32
ffffffffc0200c3e:	4200406f          	j	ffffffffc020505e <schedule>
ffffffffc0200c42:	555d                	li	a0,-9
ffffffffc0200c44:	0ea030ef          	jal	ffffffffc0203d2e <do_exit>
ffffffffc0200c48:	601c                	ld	a5,0(s0)
ffffffffc0200c4a:	bf65                	j	ffffffffc0200c02 <trap+0x40>

ffffffffc0200c4c <__alltraps>:
ffffffffc0200c4c:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200c50:	00011463          	bnez	sp,ffffffffc0200c58 <__alltraps+0xc>
ffffffffc0200c54:	14002173          	csrr	sp,sscratch
ffffffffc0200c58:	712d                	add	sp,sp,-288
ffffffffc0200c5a:	e002                	sd	zero,0(sp)
ffffffffc0200c5c:	e406                	sd	ra,8(sp)
ffffffffc0200c5e:	ec0e                	sd	gp,24(sp)
ffffffffc0200c60:	f012                	sd	tp,32(sp)
ffffffffc0200c62:	f416                	sd	t0,40(sp)
ffffffffc0200c64:	f81a                	sd	t1,48(sp)
ffffffffc0200c66:	fc1e                	sd	t2,56(sp)
ffffffffc0200c68:	e0a2                	sd	s0,64(sp)
ffffffffc0200c6a:	e4a6                	sd	s1,72(sp)
ffffffffc0200c6c:	e8aa                	sd	a0,80(sp)
ffffffffc0200c6e:	ecae                	sd	a1,88(sp)
ffffffffc0200c70:	f0b2                	sd	a2,96(sp)
ffffffffc0200c72:	f4b6                	sd	a3,104(sp)
ffffffffc0200c74:	f8ba                	sd	a4,112(sp)
ffffffffc0200c76:	fcbe                	sd	a5,120(sp)
ffffffffc0200c78:	e142                	sd	a6,128(sp)
ffffffffc0200c7a:	e546                	sd	a7,136(sp)
ffffffffc0200c7c:	e94a                	sd	s2,144(sp)
ffffffffc0200c7e:	ed4e                	sd	s3,152(sp)
ffffffffc0200c80:	f152                	sd	s4,160(sp)
ffffffffc0200c82:	f556                	sd	s5,168(sp)
ffffffffc0200c84:	f95a                	sd	s6,176(sp)
ffffffffc0200c86:	fd5e                	sd	s7,184(sp)
ffffffffc0200c88:	e1e2                	sd	s8,192(sp)
ffffffffc0200c8a:	e5e6                	sd	s9,200(sp)
ffffffffc0200c8c:	e9ea                	sd	s10,208(sp)
ffffffffc0200c8e:	edee                	sd	s11,216(sp)
ffffffffc0200c90:	f1f2                	sd	t3,224(sp)
ffffffffc0200c92:	f5f6                	sd	t4,232(sp)
ffffffffc0200c94:	f9fa                	sd	t5,240(sp)
ffffffffc0200c96:	fdfe                	sd	t6,248(sp)
ffffffffc0200c98:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c9c:	100024f3          	csrr	s1,sstatus
ffffffffc0200ca0:	14102973          	csrr	s2,sepc
ffffffffc0200ca4:	143029f3          	csrr	s3,stval
ffffffffc0200ca8:	14202a73          	csrr	s4,scause
ffffffffc0200cac:	e822                	sd	s0,16(sp)
ffffffffc0200cae:	e226                	sd	s1,256(sp)
ffffffffc0200cb0:	e64a                	sd	s2,264(sp)
ffffffffc0200cb2:	ea4e                	sd	s3,272(sp)
ffffffffc0200cb4:	ee52                	sd	s4,280(sp)
ffffffffc0200cb6:	850a                	mv	a0,sp
ffffffffc0200cb8:	f0bff0ef          	jal	ffffffffc0200bc2 <trap>

ffffffffc0200cbc <__trapret>:
ffffffffc0200cbc:	6492                	ld	s1,256(sp)
ffffffffc0200cbe:	6932                	ld	s2,264(sp)
ffffffffc0200cc0:	1004f413          	and	s0,s1,256
ffffffffc0200cc4:	e401                	bnez	s0,ffffffffc0200ccc <__trapret+0x10>
ffffffffc0200cc6:	1200                	add	s0,sp,288
ffffffffc0200cc8:	14041073          	csrw	sscratch,s0
ffffffffc0200ccc:	10049073          	csrw	sstatus,s1
ffffffffc0200cd0:	14191073          	csrw	sepc,s2
ffffffffc0200cd4:	60a2                	ld	ra,8(sp)
ffffffffc0200cd6:	61e2                	ld	gp,24(sp)
ffffffffc0200cd8:	7202                	ld	tp,32(sp)
ffffffffc0200cda:	72a2                	ld	t0,40(sp)
ffffffffc0200cdc:	7342                	ld	t1,48(sp)
ffffffffc0200cde:	73e2                	ld	t2,56(sp)
ffffffffc0200ce0:	6406                	ld	s0,64(sp)
ffffffffc0200ce2:	64a6                	ld	s1,72(sp)
ffffffffc0200ce4:	6546                	ld	a0,80(sp)
ffffffffc0200ce6:	65e6                	ld	a1,88(sp)
ffffffffc0200ce8:	7606                	ld	a2,96(sp)
ffffffffc0200cea:	76a6                	ld	a3,104(sp)
ffffffffc0200cec:	7746                	ld	a4,112(sp)
ffffffffc0200cee:	77e6                	ld	a5,120(sp)
ffffffffc0200cf0:	680a                	ld	a6,128(sp)
ffffffffc0200cf2:	68aa                	ld	a7,136(sp)
ffffffffc0200cf4:	694a                	ld	s2,144(sp)
ffffffffc0200cf6:	69ea                	ld	s3,152(sp)
ffffffffc0200cf8:	7a0a                	ld	s4,160(sp)
ffffffffc0200cfa:	7aaa                	ld	s5,168(sp)
ffffffffc0200cfc:	7b4a                	ld	s6,176(sp)
ffffffffc0200cfe:	7bea                	ld	s7,184(sp)
ffffffffc0200d00:	6c0e                	ld	s8,192(sp)
ffffffffc0200d02:	6cae                	ld	s9,200(sp)
ffffffffc0200d04:	6d4e                	ld	s10,208(sp)
ffffffffc0200d06:	6dee                	ld	s11,216(sp)
ffffffffc0200d08:	7e0e                	ld	t3,224(sp)
ffffffffc0200d0a:	7eae                	ld	t4,232(sp)
ffffffffc0200d0c:	7f4e                	ld	t5,240(sp)
ffffffffc0200d0e:	7fee                	ld	t6,248(sp)
ffffffffc0200d10:	6142                	ld	sp,16(sp)
ffffffffc0200d12:	10200073          	sret

ffffffffc0200d16 <forkrets>:
ffffffffc0200d16:	812a                	mv	sp,a0
ffffffffc0200d18:	b755                	j	ffffffffc0200cbc <__trapret>

ffffffffc0200d1a <default_init>:
ffffffffc0200d1a:	00012797          	auipc	a5,0x12
ffffffffc0200d1e:	77678793          	add	a5,a5,1910 # ffffffffc0213490 <free_area>
ffffffffc0200d22:	e79c                	sd	a5,8(a5)
ffffffffc0200d24:	e39c                	sd	a5,0(a5)
ffffffffc0200d26:	0007a823          	sw	zero,16(a5)
ffffffffc0200d2a:	8082                	ret

ffffffffc0200d2c <default_nr_free_pages>:
ffffffffc0200d2c:	00012517          	auipc	a0,0x12
ffffffffc0200d30:	77456503          	lwu	a0,1908(a0) # ffffffffc02134a0 <free_area+0x10>
ffffffffc0200d34:	8082                	ret

ffffffffc0200d36 <default_check>:
ffffffffc0200d36:	715d                	add	sp,sp,-80
ffffffffc0200d38:	e0a2                	sd	s0,64(sp)
ffffffffc0200d3a:	00012417          	auipc	s0,0x12
ffffffffc0200d3e:	75640413          	add	s0,s0,1878 # ffffffffc0213490 <free_area>
ffffffffc0200d42:	641c                	ld	a5,8(s0)
ffffffffc0200d44:	e486                	sd	ra,72(sp)
ffffffffc0200d46:	fc26                	sd	s1,56(sp)
ffffffffc0200d48:	f84a                	sd	s2,48(sp)
ffffffffc0200d4a:	f44e                	sd	s3,40(sp)
ffffffffc0200d4c:	f052                	sd	s4,32(sp)
ffffffffc0200d4e:	ec56                	sd	s5,24(sp)
ffffffffc0200d50:	e85a                	sd	s6,16(sp)
ffffffffc0200d52:	e45e                	sd	s7,8(sp)
ffffffffc0200d54:	e062                	sd	s8,0(sp)
ffffffffc0200d56:	2a878d63          	beq	a5,s0,ffffffffc0201010 <default_check+0x2da>
ffffffffc0200d5a:	4481                	li	s1,0
ffffffffc0200d5c:	4901                	li	s2,0
ffffffffc0200d5e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200d62:	8b09                	and	a4,a4,2
ffffffffc0200d64:	2a070a63          	beqz	a4,ffffffffc0201018 <default_check+0x2e2>
ffffffffc0200d68:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d6c:	679c                	ld	a5,8(a5)
ffffffffc0200d6e:	2905                	addw	s2,s2,1
ffffffffc0200d70:	9cb9                	addw	s1,s1,a4
ffffffffc0200d72:	fe8796e3          	bne	a5,s0,ffffffffc0200d5e <default_check+0x28>
ffffffffc0200d76:	89a6                	mv	s3,s1
ffffffffc0200d78:	6e9000ef          	jal	ffffffffc0201c60 <nr_free_pages>
ffffffffc0200d7c:	6f351e63          	bne	a0,s3,ffffffffc0201478 <default_check+0x742>
ffffffffc0200d80:	4505                	li	a0,1
ffffffffc0200d82:	60f000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200d86:	8aaa                	mv	s5,a0
ffffffffc0200d88:	42050863          	beqz	a0,ffffffffc02011b8 <default_check+0x482>
ffffffffc0200d8c:	4505                	li	a0,1
ffffffffc0200d8e:	603000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200d92:	89aa                	mv	s3,a0
ffffffffc0200d94:	70050263          	beqz	a0,ffffffffc0201498 <default_check+0x762>
ffffffffc0200d98:	4505                	li	a0,1
ffffffffc0200d9a:	5f7000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200d9e:	8a2a                	mv	s4,a0
ffffffffc0200da0:	48050c63          	beqz	a0,ffffffffc0201238 <default_check+0x502>
ffffffffc0200da4:	293a8a63          	beq	s5,s3,ffffffffc0201038 <default_check+0x302>
ffffffffc0200da8:	28aa8863          	beq	s5,a0,ffffffffc0201038 <default_check+0x302>
ffffffffc0200dac:	28a98663          	beq	s3,a0,ffffffffc0201038 <default_check+0x302>
ffffffffc0200db0:	000aa783          	lw	a5,0(s5)
ffffffffc0200db4:	2a079263          	bnez	a5,ffffffffc0201058 <default_check+0x322>
ffffffffc0200db8:	0009a783          	lw	a5,0(s3)
ffffffffc0200dbc:	28079e63          	bnez	a5,ffffffffc0201058 <default_check+0x322>
ffffffffc0200dc0:	411c                	lw	a5,0(a0)
ffffffffc0200dc2:	28079b63          	bnez	a5,ffffffffc0201058 <default_check+0x322>
ffffffffc0200dc6:	00017797          	auipc	a5,0x17
ffffffffc0200dca:	85a7b783          	ld	a5,-1958(a5) # ffffffffc0217620 <pages>
ffffffffc0200dce:	40fa8733          	sub	a4,s5,a5
ffffffffc0200dd2:	00007617          	auipc	a2,0x7
ffffffffc0200dd6:	2a663603          	ld	a2,678(a2) # ffffffffc0208078 <nbase>
ffffffffc0200dda:	8719                	sra	a4,a4,0x6
ffffffffc0200ddc:	9732                	add	a4,a4,a2
ffffffffc0200dde:	00017697          	auipc	a3,0x17
ffffffffc0200de2:	83a6b683          	ld	a3,-1990(a3) # ffffffffc0217618 <npage>
ffffffffc0200de6:	06b2                	sll	a3,a3,0xc
ffffffffc0200de8:	0732                	sll	a4,a4,0xc
ffffffffc0200dea:	28d77763          	bgeu	a4,a3,ffffffffc0201078 <default_check+0x342>
ffffffffc0200dee:	40f98733          	sub	a4,s3,a5
ffffffffc0200df2:	8719                	sra	a4,a4,0x6
ffffffffc0200df4:	9732                	add	a4,a4,a2
ffffffffc0200df6:	0732                	sll	a4,a4,0xc
ffffffffc0200df8:	4cd77063          	bgeu	a4,a3,ffffffffc02012b8 <default_check+0x582>
ffffffffc0200dfc:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e00:	8799                	sra	a5,a5,0x6
ffffffffc0200e02:	97b2                	add	a5,a5,a2
ffffffffc0200e04:	07b2                	sll	a5,a5,0xc
ffffffffc0200e06:	30d7f963          	bgeu	a5,a3,ffffffffc0201118 <default_check+0x3e2>
ffffffffc0200e0a:	4505                	li	a0,1
ffffffffc0200e0c:	00043c03          	ld	s8,0(s0)
ffffffffc0200e10:	00843b83          	ld	s7,8(s0)
ffffffffc0200e14:	01042b03          	lw	s6,16(s0)
ffffffffc0200e18:	e400                	sd	s0,8(s0)
ffffffffc0200e1a:	e000                	sd	s0,0(s0)
ffffffffc0200e1c:	00012797          	auipc	a5,0x12
ffffffffc0200e20:	6807a223          	sw	zero,1668(a5) # ffffffffc02134a0 <free_area+0x10>
ffffffffc0200e24:	56d000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e28:	2c051863          	bnez	a0,ffffffffc02010f8 <default_check+0x3c2>
ffffffffc0200e2c:	4585                	li	a1,1
ffffffffc0200e2e:	8556                	mv	a0,s5
ffffffffc0200e30:	5f1000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200e34:	4585                	li	a1,1
ffffffffc0200e36:	854e                	mv	a0,s3
ffffffffc0200e38:	5e9000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200e3c:	4585                	li	a1,1
ffffffffc0200e3e:	8552                	mv	a0,s4
ffffffffc0200e40:	5e1000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200e44:	4818                	lw	a4,16(s0)
ffffffffc0200e46:	478d                	li	a5,3
ffffffffc0200e48:	28f71863          	bne	a4,a5,ffffffffc02010d8 <default_check+0x3a2>
ffffffffc0200e4c:	4505                	li	a0,1
ffffffffc0200e4e:	543000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e52:	89aa                	mv	s3,a0
ffffffffc0200e54:	26050263          	beqz	a0,ffffffffc02010b8 <default_check+0x382>
ffffffffc0200e58:	4505                	li	a0,1
ffffffffc0200e5a:	537000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e5e:	8aaa                	mv	s5,a0
ffffffffc0200e60:	3a050c63          	beqz	a0,ffffffffc0201218 <default_check+0x4e2>
ffffffffc0200e64:	4505                	li	a0,1
ffffffffc0200e66:	52b000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e6a:	8a2a                	mv	s4,a0
ffffffffc0200e6c:	38050663          	beqz	a0,ffffffffc02011f8 <default_check+0x4c2>
ffffffffc0200e70:	4505                	li	a0,1
ffffffffc0200e72:	51f000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e76:	36051163          	bnez	a0,ffffffffc02011d8 <default_check+0x4a2>
ffffffffc0200e7a:	4585                	li	a1,1
ffffffffc0200e7c:	854e                	mv	a0,s3
ffffffffc0200e7e:	5a3000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200e82:	641c                	ld	a5,8(s0)
ffffffffc0200e84:	20878a63          	beq	a5,s0,ffffffffc0201098 <default_check+0x362>
ffffffffc0200e88:	4505                	li	a0,1
ffffffffc0200e8a:	507000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e8e:	30a99563          	bne	s3,a0,ffffffffc0201198 <default_check+0x462>
ffffffffc0200e92:	4505                	li	a0,1
ffffffffc0200e94:	4fd000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200e98:	2e051063          	bnez	a0,ffffffffc0201178 <default_check+0x442>
ffffffffc0200e9c:	481c                	lw	a5,16(s0)
ffffffffc0200e9e:	2a079d63          	bnez	a5,ffffffffc0201158 <default_check+0x422>
ffffffffc0200ea2:	854e                	mv	a0,s3
ffffffffc0200ea4:	4585                	li	a1,1
ffffffffc0200ea6:	01843023          	sd	s8,0(s0)
ffffffffc0200eaa:	01743423          	sd	s7,8(s0)
ffffffffc0200eae:	01642823          	sw	s6,16(s0)
ffffffffc0200eb2:	56f000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200eb6:	4585                	li	a1,1
ffffffffc0200eb8:	8556                	mv	a0,s5
ffffffffc0200eba:	567000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200ebe:	4585                	li	a1,1
ffffffffc0200ec0:	8552                	mv	a0,s4
ffffffffc0200ec2:	55f000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200ec6:	4515                	li	a0,5
ffffffffc0200ec8:	4c9000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200ecc:	89aa                	mv	s3,a0
ffffffffc0200ece:	26050563          	beqz	a0,ffffffffc0201138 <default_check+0x402>
ffffffffc0200ed2:	651c                	ld	a5,8(a0)
ffffffffc0200ed4:	8385                	srl	a5,a5,0x1
ffffffffc0200ed6:	8b85                	and	a5,a5,1
ffffffffc0200ed8:	54079063          	bnez	a5,ffffffffc0201418 <default_check+0x6e2>
ffffffffc0200edc:	4505                	li	a0,1
ffffffffc0200ede:	00043b03          	ld	s6,0(s0)
ffffffffc0200ee2:	00843a83          	ld	s5,8(s0)
ffffffffc0200ee6:	e000                	sd	s0,0(s0)
ffffffffc0200ee8:	e400                	sd	s0,8(s0)
ffffffffc0200eea:	4a7000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200eee:	50051563          	bnez	a0,ffffffffc02013f8 <default_check+0x6c2>
ffffffffc0200ef2:	08098a13          	add	s4,s3,128
ffffffffc0200ef6:	8552                	mv	a0,s4
ffffffffc0200ef8:	458d                	li	a1,3
ffffffffc0200efa:	01042b83          	lw	s7,16(s0)
ffffffffc0200efe:	00012797          	auipc	a5,0x12
ffffffffc0200f02:	5a07a123          	sw	zero,1442(a5) # ffffffffc02134a0 <free_area+0x10>
ffffffffc0200f06:	51b000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200f0a:	4511                	li	a0,4
ffffffffc0200f0c:	485000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200f10:	4c051463          	bnez	a0,ffffffffc02013d8 <default_check+0x6a2>
ffffffffc0200f14:	0889b783          	ld	a5,136(s3)
ffffffffc0200f18:	8385                	srl	a5,a5,0x1
ffffffffc0200f1a:	8b85                	and	a5,a5,1
ffffffffc0200f1c:	48078e63          	beqz	a5,ffffffffc02013b8 <default_check+0x682>
ffffffffc0200f20:	0909a703          	lw	a4,144(s3)
ffffffffc0200f24:	478d                	li	a5,3
ffffffffc0200f26:	48f71963          	bne	a4,a5,ffffffffc02013b8 <default_check+0x682>
ffffffffc0200f2a:	450d                	li	a0,3
ffffffffc0200f2c:	465000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200f30:	8c2a                	mv	s8,a0
ffffffffc0200f32:	46050363          	beqz	a0,ffffffffc0201398 <default_check+0x662>
ffffffffc0200f36:	4505                	li	a0,1
ffffffffc0200f38:	459000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200f3c:	42051e63          	bnez	a0,ffffffffc0201378 <default_check+0x642>
ffffffffc0200f40:	418a1c63          	bne	s4,s8,ffffffffc0201358 <default_check+0x622>
ffffffffc0200f44:	4585                	li	a1,1
ffffffffc0200f46:	854e                	mv	a0,s3
ffffffffc0200f48:	4d9000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200f4c:	458d                	li	a1,3
ffffffffc0200f4e:	8552                	mv	a0,s4
ffffffffc0200f50:	4d1000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200f54:	0089b783          	ld	a5,8(s3)
ffffffffc0200f58:	04098c13          	add	s8,s3,64
ffffffffc0200f5c:	8385                	srl	a5,a5,0x1
ffffffffc0200f5e:	8b85                	and	a5,a5,1
ffffffffc0200f60:	3c078c63          	beqz	a5,ffffffffc0201338 <default_check+0x602>
ffffffffc0200f64:	0109a703          	lw	a4,16(s3)
ffffffffc0200f68:	4785                	li	a5,1
ffffffffc0200f6a:	3cf71763          	bne	a4,a5,ffffffffc0201338 <default_check+0x602>
ffffffffc0200f6e:	008a3783          	ld	a5,8(s4)
ffffffffc0200f72:	8385                	srl	a5,a5,0x1
ffffffffc0200f74:	8b85                	and	a5,a5,1
ffffffffc0200f76:	3a078163          	beqz	a5,ffffffffc0201318 <default_check+0x5e2>
ffffffffc0200f7a:	010a2703          	lw	a4,16(s4)
ffffffffc0200f7e:	478d                	li	a5,3
ffffffffc0200f80:	38f71c63          	bne	a4,a5,ffffffffc0201318 <default_check+0x5e2>
ffffffffc0200f84:	4505                	li	a0,1
ffffffffc0200f86:	40b000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200f8a:	36a99763          	bne	s3,a0,ffffffffc02012f8 <default_check+0x5c2>
ffffffffc0200f8e:	4585                	li	a1,1
ffffffffc0200f90:	491000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200f94:	4509                	li	a0,2
ffffffffc0200f96:	3fb000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200f9a:	32aa1f63          	bne	s4,a0,ffffffffc02012d8 <default_check+0x5a2>
ffffffffc0200f9e:	4589                	li	a1,2
ffffffffc0200fa0:	481000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200fa4:	4585                	li	a1,1
ffffffffc0200fa6:	8562                	mv	a0,s8
ffffffffc0200fa8:	479000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200fac:	4515                	li	a0,5
ffffffffc0200fae:	3e3000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200fb2:	89aa                	mv	s3,a0
ffffffffc0200fb4:	48050263          	beqz	a0,ffffffffc0201438 <default_check+0x702>
ffffffffc0200fb8:	4505                	li	a0,1
ffffffffc0200fba:	3d7000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0200fbe:	2c051d63          	bnez	a0,ffffffffc0201298 <default_check+0x562>
ffffffffc0200fc2:	481c                	lw	a5,16(s0)
ffffffffc0200fc4:	2a079a63          	bnez	a5,ffffffffc0201278 <default_check+0x542>
ffffffffc0200fc8:	4595                	li	a1,5
ffffffffc0200fca:	854e                	mv	a0,s3
ffffffffc0200fcc:	01742823          	sw	s7,16(s0)
ffffffffc0200fd0:	01643023          	sd	s6,0(s0)
ffffffffc0200fd4:	01543423          	sd	s5,8(s0)
ffffffffc0200fd8:	449000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0200fdc:	641c                	ld	a5,8(s0)
ffffffffc0200fde:	00878963          	beq	a5,s0,ffffffffc0200ff0 <default_check+0x2ba>
ffffffffc0200fe2:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200fe6:	679c                	ld	a5,8(a5)
ffffffffc0200fe8:	397d                	addw	s2,s2,-1
ffffffffc0200fea:	9c99                	subw	s1,s1,a4
ffffffffc0200fec:	fe879be3          	bne	a5,s0,ffffffffc0200fe2 <default_check+0x2ac>
ffffffffc0200ff0:	26091463          	bnez	s2,ffffffffc0201258 <default_check+0x522>
ffffffffc0200ff4:	46049263          	bnez	s1,ffffffffc0201458 <default_check+0x722>
ffffffffc0200ff8:	60a6                	ld	ra,72(sp)
ffffffffc0200ffa:	6406                	ld	s0,64(sp)
ffffffffc0200ffc:	74e2                	ld	s1,56(sp)
ffffffffc0200ffe:	7942                	ld	s2,48(sp)
ffffffffc0201000:	79a2                	ld	s3,40(sp)
ffffffffc0201002:	7a02                	ld	s4,32(sp)
ffffffffc0201004:	6ae2                	ld	s5,24(sp)
ffffffffc0201006:	6b42                	ld	s6,16(sp)
ffffffffc0201008:	6ba2                	ld	s7,8(sp)
ffffffffc020100a:	6c02                	ld	s8,0(sp)
ffffffffc020100c:	6161                	add	sp,sp,80
ffffffffc020100e:	8082                	ret
ffffffffc0201010:	4981                	li	s3,0
ffffffffc0201012:	4481                	li	s1,0
ffffffffc0201014:	4901                	li	s2,0
ffffffffc0201016:	b38d                	j	ffffffffc0200d78 <default_check+0x42>
ffffffffc0201018:	00005697          	auipc	a3,0x5
ffffffffc020101c:	2d068693          	add	a3,a3,720 # ffffffffc02062e8 <commands+0x740>
ffffffffc0201020:	00005617          	auipc	a2,0x5
ffffffffc0201024:	fd860613          	add	a2,a2,-40 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201028:	0f000593          	li	a1,240
ffffffffc020102c:	00005517          	auipc	a0,0x5
ffffffffc0201030:	2cc50513          	add	a0,a0,716 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201034:	c3eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201038:	00005697          	auipc	a3,0x5
ffffffffc020103c:	35868693          	add	a3,a3,856 # ffffffffc0206390 <commands+0x7e8>
ffffffffc0201040:	00005617          	auipc	a2,0x5
ffffffffc0201044:	fb860613          	add	a2,a2,-72 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201048:	0bd00593          	li	a1,189
ffffffffc020104c:	00005517          	auipc	a0,0x5
ffffffffc0201050:	2ac50513          	add	a0,a0,684 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201054:	c1eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201058:	00005697          	auipc	a3,0x5
ffffffffc020105c:	36068693          	add	a3,a3,864 # ffffffffc02063b8 <commands+0x810>
ffffffffc0201060:	00005617          	auipc	a2,0x5
ffffffffc0201064:	f9860613          	add	a2,a2,-104 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201068:	0be00593          	li	a1,190
ffffffffc020106c:	00005517          	auipc	a0,0x5
ffffffffc0201070:	28c50513          	add	a0,a0,652 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201074:	bfeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201078:	00005697          	auipc	a3,0x5
ffffffffc020107c:	38068693          	add	a3,a3,896 # ffffffffc02063f8 <commands+0x850>
ffffffffc0201080:	00005617          	auipc	a2,0x5
ffffffffc0201084:	f7860613          	add	a2,a2,-136 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201088:	0c000593          	li	a1,192
ffffffffc020108c:	00005517          	auipc	a0,0x5
ffffffffc0201090:	26c50513          	add	a0,a0,620 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201094:	bdeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201098:	00005697          	auipc	a3,0x5
ffffffffc020109c:	3e868693          	add	a3,a3,1000 # ffffffffc0206480 <commands+0x8d8>
ffffffffc02010a0:	00005617          	auipc	a2,0x5
ffffffffc02010a4:	f5860613          	add	a2,a2,-168 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02010a8:	0d900593          	li	a1,217
ffffffffc02010ac:	00005517          	auipc	a0,0x5
ffffffffc02010b0:	24c50513          	add	a0,a0,588 # ffffffffc02062f8 <commands+0x750>
ffffffffc02010b4:	bbeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02010b8:	00005697          	auipc	a3,0x5
ffffffffc02010bc:	27868693          	add	a3,a3,632 # ffffffffc0206330 <commands+0x788>
ffffffffc02010c0:	00005617          	auipc	a2,0x5
ffffffffc02010c4:	f3860613          	add	a2,a2,-200 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02010c8:	0d200593          	li	a1,210
ffffffffc02010cc:	00005517          	auipc	a0,0x5
ffffffffc02010d0:	22c50513          	add	a0,a0,556 # ffffffffc02062f8 <commands+0x750>
ffffffffc02010d4:	b9eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02010d8:	00005697          	auipc	a3,0x5
ffffffffc02010dc:	39868693          	add	a3,a3,920 # ffffffffc0206470 <commands+0x8c8>
ffffffffc02010e0:	00005617          	auipc	a2,0x5
ffffffffc02010e4:	f1860613          	add	a2,a2,-232 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02010e8:	0d000593          	li	a1,208
ffffffffc02010ec:	00005517          	auipc	a0,0x5
ffffffffc02010f0:	20c50513          	add	a0,a0,524 # ffffffffc02062f8 <commands+0x750>
ffffffffc02010f4:	b7eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02010f8:	00005697          	auipc	a3,0x5
ffffffffc02010fc:	36068693          	add	a3,a3,864 # ffffffffc0206458 <commands+0x8b0>
ffffffffc0201100:	00005617          	auipc	a2,0x5
ffffffffc0201104:	ef860613          	add	a2,a2,-264 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201108:	0cb00593          	li	a1,203
ffffffffc020110c:	00005517          	auipc	a0,0x5
ffffffffc0201110:	1ec50513          	add	a0,a0,492 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201114:	b5eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201118:	00005697          	auipc	a3,0x5
ffffffffc020111c:	32068693          	add	a3,a3,800 # ffffffffc0206438 <commands+0x890>
ffffffffc0201120:	00005617          	auipc	a2,0x5
ffffffffc0201124:	ed860613          	add	a2,a2,-296 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201128:	0c200593          	li	a1,194
ffffffffc020112c:	00005517          	auipc	a0,0x5
ffffffffc0201130:	1cc50513          	add	a0,a0,460 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201134:	b3eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201138:	00005697          	auipc	a3,0x5
ffffffffc020113c:	39068693          	add	a3,a3,912 # ffffffffc02064c8 <commands+0x920>
ffffffffc0201140:	00005617          	auipc	a2,0x5
ffffffffc0201144:	eb860613          	add	a2,a2,-328 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201148:	0f800593          	li	a1,248
ffffffffc020114c:	00005517          	auipc	a0,0x5
ffffffffc0201150:	1ac50513          	add	a0,a0,428 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201154:	b1eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201158:	00005697          	auipc	a3,0x5
ffffffffc020115c:	36068693          	add	a3,a3,864 # ffffffffc02064b8 <commands+0x910>
ffffffffc0201160:	00005617          	auipc	a2,0x5
ffffffffc0201164:	e9860613          	add	a2,a2,-360 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201168:	0df00593          	li	a1,223
ffffffffc020116c:	00005517          	auipc	a0,0x5
ffffffffc0201170:	18c50513          	add	a0,a0,396 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201174:	afeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201178:	00005697          	auipc	a3,0x5
ffffffffc020117c:	2e068693          	add	a3,a3,736 # ffffffffc0206458 <commands+0x8b0>
ffffffffc0201180:	00005617          	auipc	a2,0x5
ffffffffc0201184:	e7860613          	add	a2,a2,-392 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201188:	0dd00593          	li	a1,221
ffffffffc020118c:	00005517          	auipc	a0,0x5
ffffffffc0201190:	16c50513          	add	a0,a0,364 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201194:	adeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201198:	00005697          	auipc	a3,0x5
ffffffffc020119c:	30068693          	add	a3,a3,768 # ffffffffc0206498 <commands+0x8f0>
ffffffffc02011a0:	00005617          	auipc	a2,0x5
ffffffffc02011a4:	e5860613          	add	a2,a2,-424 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02011a8:	0dc00593          	li	a1,220
ffffffffc02011ac:	00005517          	auipc	a0,0x5
ffffffffc02011b0:	14c50513          	add	a0,a0,332 # ffffffffc02062f8 <commands+0x750>
ffffffffc02011b4:	abeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02011b8:	00005697          	auipc	a3,0x5
ffffffffc02011bc:	17868693          	add	a3,a3,376 # ffffffffc0206330 <commands+0x788>
ffffffffc02011c0:	00005617          	auipc	a2,0x5
ffffffffc02011c4:	e3860613          	add	a2,a2,-456 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02011c8:	0b900593          	li	a1,185
ffffffffc02011cc:	00005517          	auipc	a0,0x5
ffffffffc02011d0:	12c50513          	add	a0,a0,300 # ffffffffc02062f8 <commands+0x750>
ffffffffc02011d4:	a9eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02011d8:	00005697          	auipc	a3,0x5
ffffffffc02011dc:	28068693          	add	a3,a3,640 # ffffffffc0206458 <commands+0x8b0>
ffffffffc02011e0:	00005617          	auipc	a2,0x5
ffffffffc02011e4:	e1860613          	add	a2,a2,-488 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02011e8:	0d600593          	li	a1,214
ffffffffc02011ec:	00005517          	auipc	a0,0x5
ffffffffc02011f0:	10c50513          	add	a0,a0,268 # ffffffffc02062f8 <commands+0x750>
ffffffffc02011f4:	a7eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02011f8:	00005697          	auipc	a3,0x5
ffffffffc02011fc:	17868693          	add	a3,a3,376 # ffffffffc0206370 <commands+0x7c8>
ffffffffc0201200:	00005617          	auipc	a2,0x5
ffffffffc0201204:	df860613          	add	a2,a2,-520 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201208:	0d400593          	li	a1,212
ffffffffc020120c:	00005517          	auipc	a0,0x5
ffffffffc0201210:	0ec50513          	add	a0,a0,236 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201214:	a5eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201218:	00005697          	auipc	a3,0x5
ffffffffc020121c:	13868693          	add	a3,a3,312 # ffffffffc0206350 <commands+0x7a8>
ffffffffc0201220:	00005617          	auipc	a2,0x5
ffffffffc0201224:	dd860613          	add	a2,a2,-552 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201228:	0d300593          	li	a1,211
ffffffffc020122c:	00005517          	auipc	a0,0x5
ffffffffc0201230:	0cc50513          	add	a0,a0,204 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201234:	a3eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201238:	00005697          	auipc	a3,0x5
ffffffffc020123c:	13868693          	add	a3,a3,312 # ffffffffc0206370 <commands+0x7c8>
ffffffffc0201240:	00005617          	auipc	a2,0x5
ffffffffc0201244:	db860613          	add	a2,a2,-584 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201248:	0bb00593          	li	a1,187
ffffffffc020124c:	00005517          	auipc	a0,0x5
ffffffffc0201250:	0ac50513          	add	a0,a0,172 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201254:	a1eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201258:	00005697          	auipc	a3,0x5
ffffffffc020125c:	3c068693          	add	a3,a3,960 # ffffffffc0206618 <commands+0xa70>
ffffffffc0201260:	00005617          	auipc	a2,0x5
ffffffffc0201264:	d9860613          	add	a2,a2,-616 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201268:	12500593          	li	a1,293
ffffffffc020126c:	00005517          	auipc	a0,0x5
ffffffffc0201270:	08c50513          	add	a0,a0,140 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201274:	9feff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201278:	00005697          	auipc	a3,0x5
ffffffffc020127c:	24068693          	add	a3,a3,576 # ffffffffc02064b8 <commands+0x910>
ffffffffc0201280:	00005617          	auipc	a2,0x5
ffffffffc0201284:	d7860613          	add	a2,a2,-648 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201288:	11a00593          	li	a1,282
ffffffffc020128c:	00005517          	auipc	a0,0x5
ffffffffc0201290:	06c50513          	add	a0,a0,108 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201294:	9deff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201298:	00005697          	auipc	a3,0x5
ffffffffc020129c:	1c068693          	add	a3,a3,448 # ffffffffc0206458 <commands+0x8b0>
ffffffffc02012a0:	00005617          	auipc	a2,0x5
ffffffffc02012a4:	d5860613          	add	a2,a2,-680 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02012a8:	11800593          	li	a1,280
ffffffffc02012ac:	00005517          	auipc	a0,0x5
ffffffffc02012b0:	04c50513          	add	a0,a0,76 # ffffffffc02062f8 <commands+0x750>
ffffffffc02012b4:	9beff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02012b8:	00005697          	auipc	a3,0x5
ffffffffc02012bc:	16068693          	add	a3,a3,352 # ffffffffc0206418 <commands+0x870>
ffffffffc02012c0:	00005617          	auipc	a2,0x5
ffffffffc02012c4:	d3860613          	add	a2,a2,-712 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02012c8:	0c100593          	li	a1,193
ffffffffc02012cc:	00005517          	auipc	a0,0x5
ffffffffc02012d0:	02c50513          	add	a0,a0,44 # ffffffffc02062f8 <commands+0x750>
ffffffffc02012d4:	99eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02012d8:	00005697          	auipc	a3,0x5
ffffffffc02012dc:	30068693          	add	a3,a3,768 # ffffffffc02065d8 <commands+0xa30>
ffffffffc02012e0:	00005617          	auipc	a2,0x5
ffffffffc02012e4:	d1860613          	add	a2,a2,-744 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02012e8:	11200593          	li	a1,274
ffffffffc02012ec:	00005517          	auipc	a0,0x5
ffffffffc02012f0:	00c50513          	add	a0,a0,12 # ffffffffc02062f8 <commands+0x750>
ffffffffc02012f4:	97eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02012f8:	00005697          	auipc	a3,0x5
ffffffffc02012fc:	2c068693          	add	a3,a3,704 # ffffffffc02065b8 <commands+0xa10>
ffffffffc0201300:	00005617          	auipc	a2,0x5
ffffffffc0201304:	cf860613          	add	a2,a2,-776 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201308:	11000593          	li	a1,272
ffffffffc020130c:	00005517          	auipc	a0,0x5
ffffffffc0201310:	fec50513          	add	a0,a0,-20 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201314:	95eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201318:	00005697          	auipc	a3,0x5
ffffffffc020131c:	27868693          	add	a3,a3,632 # ffffffffc0206590 <commands+0x9e8>
ffffffffc0201320:	00005617          	auipc	a2,0x5
ffffffffc0201324:	cd860613          	add	a2,a2,-808 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201328:	10e00593          	li	a1,270
ffffffffc020132c:	00005517          	auipc	a0,0x5
ffffffffc0201330:	fcc50513          	add	a0,a0,-52 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201334:	93eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201338:	00005697          	auipc	a3,0x5
ffffffffc020133c:	23068693          	add	a3,a3,560 # ffffffffc0206568 <commands+0x9c0>
ffffffffc0201340:	00005617          	auipc	a2,0x5
ffffffffc0201344:	cb860613          	add	a2,a2,-840 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201348:	10d00593          	li	a1,269
ffffffffc020134c:	00005517          	auipc	a0,0x5
ffffffffc0201350:	fac50513          	add	a0,a0,-84 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201354:	91eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201358:	00005697          	auipc	a3,0x5
ffffffffc020135c:	20068693          	add	a3,a3,512 # ffffffffc0206558 <commands+0x9b0>
ffffffffc0201360:	00005617          	auipc	a2,0x5
ffffffffc0201364:	c9860613          	add	a2,a2,-872 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201368:	10800593          	li	a1,264
ffffffffc020136c:	00005517          	auipc	a0,0x5
ffffffffc0201370:	f8c50513          	add	a0,a0,-116 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201374:	8feff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201378:	00005697          	auipc	a3,0x5
ffffffffc020137c:	0e068693          	add	a3,a3,224 # ffffffffc0206458 <commands+0x8b0>
ffffffffc0201380:	00005617          	auipc	a2,0x5
ffffffffc0201384:	c7860613          	add	a2,a2,-904 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201388:	10700593          	li	a1,263
ffffffffc020138c:	00005517          	auipc	a0,0x5
ffffffffc0201390:	f6c50513          	add	a0,a0,-148 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201394:	8deff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201398:	00005697          	auipc	a3,0x5
ffffffffc020139c:	1a068693          	add	a3,a3,416 # ffffffffc0206538 <commands+0x990>
ffffffffc02013a0:	00005617          	auipc	a2,0x5
ffffffffc02013a4:	c5860613          	add	a2,a2,-936 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02013a8:	10600593          	li	a1,262
ffffffffc02013ac:	00005517          	auipc	a0,0x5
ffffffffc02013b0:	f4c50513          	add	a0,a0,-180 # ffffffffc02062f8 <commands+0x750>
ffffffffc02013b4:	8beff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02013b8:	00005697          	auipc	a3,0x5
ffffffffc02013bc:	15068693          	add	a3,a3,336 # ffffffffc0206508 <commands+0x960>
ffffffffc02013c0:	00005617          	auipc	a2,0x5
ffffffffc02013c4:	c3860613          	add	a2,a2,-968 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02013c8:	10500593          	li	a1,261
ffffffffc02013cc:	00005517          	auipc	a0,0x5
ffffffffc02013d0:	f2c50513          	add	a0,a0,-212 # ffffffffc02062f8 <commands+0x750>
ffffffffc02013d4:	89eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02013d8:	00005697          	auipc	a3,0x5
ffffffffc02013dc:	11868693          	add	a3,a3,280 # ffffffffc02064f0 <commands+0x948>
ffffffffc02013e0:	00005617          	auipc	a2,0x5
ffffffffc02013e4:	c1860613          	add	a2,a2,-1000 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02013e8:	10400593          	li	a1,260
ffffffffc02013ec:	00005517          	auipc	a0,0x5
ffffffffc02013f0:	f0c50513          	add	a0,a0,-244 # ffffffffc02062f8 <commands+0x750>
ffffffffc02013f4:	87eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02013f8:	00005697          	auipc	a3,0x5
ffffffffc02013fc:	06068693          	add	a3,a3,96 # ffffffffc0206458 <commands+0x8b0>
ffffffffc0201400:	00005617          	auipc	a2,0x5
ffffffffc0201404:	bf860613          	add	a2,a2,-1032 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201408:	0fe00593          	li	a1,254
ffffffffc020140c:	00005517          	auipc	a0,0x5
ffffffffc0201410:	eec50513          	add	a0,a0,-276 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201414:	85eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201418:	00005697          	auipc	a3,0x5
ffffffffc020141c:	0c068693          	add	a3,a3,192 # ffffffffc02064d8 <commands+0x930>
ffffffffc0201420:	00005617          	auipc	a2,0x5
ffffffffc0201424:	bd860613          	add	a2,a2,-1064 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201428:	0f900593          	li	a1,249
ffffffffc020142c:	00005517          	auipc	a0,0x5
ffffffffc0201430:	ecc50513          	add	a0,a0,-308 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201434:	83eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201438:	00005697          	auipc	a3,0x5
ffffffffc020143c:	1c068693          	add	a3,a3,448 # ffffffffc02065f8 <commands+0xa50>
ffffffffc0201440:	00005617          	auipc	a2,0x5
ffffffffc0201444:	bb860613          	add	a2,a2,-1096 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201448:	11700593          	li	a1,279
ffffffffc020144c:	00005517          	auipc	a0,0x5
ffffffffc0201450:	eac50513          	add	a0,a0,-340 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201454:	81eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201458:	00005697          	auipc	a3,0x5
ffffffffc020145c:	1d068693          	add	a3,a3,464 # ffffffffc0206628 <commands+0xa80>
ffffffffc0201460:	00005617          	auipc	a2,0x5
ffffffffc0201464:	b9860613          	add	a2,a2,-1128 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201468:	12600593          	li	a1,294
ffffffffc020146c:	00005517          	auipc	a0,0x5
ffffffffc0201470:	e8c50513          	add	a0,a0,-372 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201474:	ffffe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201478:	00005697          	auipc	a3,0x5
ffffffffc020147c:	e9868693          	add	a3,a3,-360 # ffffffffc0206310 <commands+0x768>
ffffffffc0201480:	00005617          	auipc	a2,0x5
ffffffffc0201484:	b7860613          	add	a2,a2,-1160 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201488:	0f300593          	li	a1,243
ffffffffc020148c:	00005517          	auipc	a0,0x5
ffffffffc0201490:	e6c50513          	add	a0,a0,-404 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201494:	fdffe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201498:	00005697          	auipc	a3,0x5
ffffffffc020149c:	eb868693          	add	a3,a3,-328 # ffffffffc0206350 <commands+0x7a8>
ffffffffc02014a0:	00005617          	auipc	a2,0x5
ffffffffc02014a4:	b5860613          	add	a2,a2,-1192 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02014a8:	0ba00593          	li	a1,186
ffffffffc02014ac:	00005517          	auipc	a0,0x5
ffffffffc02014b0:	e4c50513          	add	a0,a0,-436 # ffffffffc02062f8 <commands+0x750>
ffffffffc02014b4:	fbffe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02014b8 <default_free_pages>:
ffffffffc02014b8:	1141                	add	sp,sp,-16
ffffffffc02014ba:	e406                	sd	ra,8(sp)
ffffffffc02014bc:	14058463          	beqz	a1,ffffffffc0201604 <default_free_pages+0x14c>
ffffffffc02014c0:	00659713          	sll	a4,a1,0x6
ffffffffc02014c4:	00e506b3          	add	a3,a0,a4
ffffffffc02014c8:	87aa                	mv	a5,a0
ffffffffc02014ca:	c30d                	beqz	a4,ffffffffc02014ec <default_free_pages+0x34>
ffffffffc02014cc:	6798                	ld	a4,8(a5)
ffffffffc02014ce:	8b05                	and	a4,a4,1
ffffffffc02014d0:	10071a63          	bnez	a4,ffffffffc02015e4 <default_free_pages+0x12c>
ffffffffc02014d4:	6798                	ld	a4,8(a5)
ffffffffc02014d6:	8b09                	and	a4,a4,2
ffffffffc02014d8:	10071663          	bnez	a4,ffffffffc02015e4 <default_free_pages+0x12c>
ffffffffc02014dc:	0007b423          	sd	zero,8(a5)
ffffffffc02014e0:	0007a023          	sw	zero,0(a5)
ffffffffc02014e4:	04078793          	add	a5,a5,64
ffffffffc02014e8:	fed792e3          	bne	a5,a3,ffffffffc02014cc <default_free_pages+0x14>
ffffffffc02014ec:	2581                	sext.w	a1,a1
ffffffffc02014ee:	c90c                	sw	a1,16(a0)
ffffffffc02014f0:	00850893          	add	a7,a0,8
ffffffffc02014f4:	4789                	li	a5,2
ffffffffc02014f6:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc02014fa:	00012697          	auipc	a3,0x12
ffffffffc02014fe:	f9668693          	add	a3,a3,-106 # ffffffffc0213490 <free_area>
ffffffffc0201502:	4a98                	lw	a4,16(a3)
ffffffffc0201504:	669c                	ld	a5,8(a3)
ffffffffc0201506:	9f2d                	addw	a4,a4,a1
ffffffffc0201508:	ca98                	sw	a4,16(a3)
ffffffffc020150a:	0ad78163          	beq	a5,a3,ffffffffc02015ac <default_free_pages+0xf4>
ffffffffc020150e:	fe878713          	add	a4,a5,-24
ffffffffc0201512:	4581                	li	a1,0
ffffffffc0201514:	01850613          	add	a2,a0,24
ffffffffc0201518:	00e56a63          	bltu	a0,a4,ffffffffc020152c <default_free_pages+0x74>
ffffffffc020151c:	6798                	ld	a4,8(a5)
ffffffffc020151e:	04d70c63          	beq	a4,a3,ffffffffc0201576 <default_free_pages+0xbe>
ffffffffc0201522:	87ba                	mv	a5,a4
ffffffffc0201524:	fe878713          	add	a4,a5,-24
ffffffffc0201528:	fee57ae3          	bgeu	a0,a4,ffffffffc020151c <default_free_pages+0x64>
ffffffffc020152c:	c199                	beqz	a1,ffffffffc0201532 <default_free_pages+0x7a>
ffffffffc020152e:	0106b023          	sd	a6,0(a3)
ffffffffc0201532:	6398                	ld	a4,0(a5)
ffffffffc0201534:	e390                	sd	a2,0(a5)
ffffffffc0201536:	e710                	sd	a2,8(a4)
ffffffffc0201538:	f11c                	sd	a5,32(a0)
ffffffffc020153a:	ed18                	sd	a4,24(a0)
ffffffffc020153c:	00d70d63          	beq	a4,a3,ffffffffc0201556 <default_free_pages+0x9e>
ffffffffc0201540:	ff872583          	lw	a1,-8(a4)
ffffffffc0201544:	fe870613          	add	a2,a4,-24
ffffffffc0201548:	02059813          	sll	a6,a1,0x20
ffffffffc020154c:	01a85793          	srl	a5,a6,0x1a
ffffffffc0201550:	97b2                	add	a5,a5,a2
ffffffffc0201552:	02f50c63          	beq	a0,a5,ffffffffc020158a <default_free_pages+0xd2>
ffffffffc0201556:	711c                	ld	a5,32(a0)
ffffffffc0201558:	00d78c63          	beq	a5,a3,ffffffffc0201570 <default_free_pages+0xb8>
ffffffffc020155c:	4910                	lw	a2,16(a0)
ffffffffc020155e:	fe878693          	add	a3,a5,-24
ffffffffc0201562:	02061593          	sll	a1,a2,0x20
ffffffffc0201566:	01a5d713          	srl	a4,a1,0x1a
ffffffffc020156a:	972a                	add	a4,a4,a0
ffffffffc020156c:	04e68c63          	beq	a3,a4,ffffffffc02015c4 <default_free_pages+0x10c>
ffffffffc0201570:	60a2                	ld	ra,8(sp)
ffffffffc0201572:	0141                	add	sp,sp,16
ffffffffc0201574:	8082                	ret
ffffffffc0201576:	e790                	sd	a2,8(a5)
ffffffffc0201578:	f114                	sd	a3,32(a0)
ffffffffc020157a:	6798                	ld	a4,8(a5)
ffffffffc020157c:	ed1c                	sd	a5,24(a0)
ffffffffc020157e:	8832                	mv	a6,a2
ffffffffc0201580:	02d70f63          	beq	a4,a3,ffffffffc02015be <default_free_pages+0x106>
ffffffffc0201584:	4585                	li	a1,1
ffffffffc0201586:	87ba                	mv	a5,a4
ffffffffc0201588:	bf71                	j	ffffffffc0201524 <default_free_pages+0x6c>
ffffffffc020158a:	491c                	lw	a5,16(a0)
ffffffffc020158c:	9fad                	addw	a5,a5,a1
ffffffffc020158e:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201592:	57f5                	li	a5,-3
ffffffffc0201594:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201598:	01853803          	ld	a6,24(a0)
ffffffffc020159c:	710c                	ld	a1,32(a0)
ffffffffc020159e:	8532                	mv	a0,a2
ffffffffc02015a0:	00b83423          	sd	a1,8(a6)
ffffffffc02015a4:	671c                	ld	a5,8(a4)
ffffffffc02015a6:	0105b023          	sd	a6,0(a1)
ffffffffc02015aa:	b77d                	j	ffffffffc0201558 <default_free_pages+0xa0>
ffffffffc02015ac:	60a2                	ld	ra,8(sp)
ffffffffc02015ae:	01850713          	add	a4,a0,24
ffffffffc02015b2:	e398                	sd	a4,0(a5)
ffffffffc02015b4:	e798                	sd	a4,8(a5)
ffffffffc02015b6:	f11c                	sd	a5,32(a0)
ffffffffc02015b8:	ed1c                	sd	a5,24(a0)
ffffffffc02015ba:	0141                	add	sp,sp,16
ffffffffc02015bc:	8082                	ret
ffffffffc02015be:	e290                	sd	a2,0(a3)
ffffffffc02015c0:	873e                	mv	a4,a5
ffffffffc02015c2:	bfad                	j	ffffffffc020153c <default_free_pages+0x84>
ffffffffc02015c4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02015c8:	ff078693          	add	a3,a5,-16
ffffffffc02015cc:	9f31                	addw	a4,a4,a2
ffffffffc02015ce:	c918                	sw	a4,16(a0)
ffffffffc02015d0:	5775                	li	a4,-3
ffffffffc02015d2:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc02015d6:	6398                	ld	a4,0(a5)
ffffffffc02015d8:	679c                	ld	a5,8(a5)
ffffffffc02015da:	60a2                	ld	ra,8(sp)
ffffffffc02015dc:	e71c                	sd	a5,8(a4)
ffffffffc02015de:	e398                	sd	a4,0(a5)
ffffffffc02015e0:	0141                	add	sp,sp,16
ffffffffc02015e2:	8082                	ret
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	05c68693          	add	a3,a3,92 # ffffffffc0206640 <commands+0xa98>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	a0c60613          	add	a2,a2,-1524 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02015f4:	08300593          	li	a1,131
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	d0050513          	add	a0,a0,-768 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201600:	e73fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	03468693          	add	a3,a3,52 # ffffffffc0206638 <commands+0xa90>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	9ec60613          	add	a2,a2,-1556 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0201614:	08000593          	li	a1,128
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	ce050513          	add	a0,a0,-800 # ffffffffc02062f8 <commands+0x750>
ffffffffc0201620:	e53fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201624 <default_alloc_pages>:
ffffffffc0201624:	c949                	beqz	a0,ffffffffc02016b6 <default_alloc_pages+0x92>
ffffffffc0201626:	00012617          	auipc	a2,0x12
ffffffffc020162a:	e6a60613          	add	a2,a2,-406 # ffffffffc0213490 <free_area>
ffffffffc020162e:	4a0c                	lw	a1,16(a2)
ffffffffc0201630:	872a                	mv	a4,a0
ffffffffc0201632:	02059793          	sll	a5,a1,0x20
ffffffffc0201636:	9381                	srl	a5,a5,0x20
ffffffffc0201638:	00a7eb63          	bltu	a5,a0,ffffffffc020164e <default_alloc_pages+0x2a>
ffffffffc020163c:	87b2                	mv	a5,a2
ffffffffc020163e:	a029                	j	ffffffffc0201648 <default_alloc_pages+0x24>
ffffffffc0201640:	ff87e683          	lwu	a3,-8(a5)
ffffffffc0201644:	00e6f763          	bgeu	a3,a4,ffffffffc0201652 <default_alloc_pages+0x2e>
ffffffffc0201648:	679c                	ld	a5,8(a5)
ffffffffc020164a:	fec79be3          	bne	a5,a2,ffffffffc0201640 <default_alloc_pages+0x1c>
ffffffffc020164e:	4501                	li	a0,0
ffffffffc0201650:	8082                	ret
ffffffffc0201652:	0087b883          	ld	a7,8(a5)
ffffffffc0201656:	ff87a803          	lw	a6,-8(a5)
ffffffffc020165a:	6394                	ld	a3,0(a5)
ffffffffc020165c:	fe878513          	add	a0,a5,-24
ffffffffc0201660:	02081313          	sll	t1,a6,0x20
ffffffffc0201664:	0116b423          	sd	a7,8(a3)
ffffffffc0201668:	00d8b023          	sd	a3,0(a7)
ffffffffc020166c:	02035313          	srl	t1,t1,0x20
ffffffffc0201670:	0007089b          	sext.w	a7,a4
ffffffffc0201674:	02677963          	bgeu	a4,t1,ffffffffc02016a6 <default_alloc_pages+0x82>
ffffffffc0201678:	071a                	sll	a4,a4,0x6
ffffffffc020167a:	972a                	add	a4,a4,a0
ffffffffc020167c:	4118083b          	subw	a6,a6,a7
ffffffffc0201680:	01072823          	sw	a6,16(a4)
ffffffffc0201684:	4589                	li	a1,2
ffffffffc0201686:	00870813          	add	a6,a4,8
ffffffffc020168a:	40b8302f          	amoor.d	zero,a1,(a6)
ffffffffc020168e:	0086b803          	ld	a6,8(a3)
ffffffffc0201692:	01870313          	add	t1,a4,24
ffffffffc0201696:	4a0c                	lw	a1,16(a2)
ffffffffc0201698:	00683023          	sd	t1,0(a6)
ffffffffc020169c:	0066b423          	sd	t1,8(a3)
ffffffffc02016a0:	03073023          	sd	a6,32(a4)
ffffffffc02016a4:	ef14                	sd	a3,24(a4)
ffffffffc02016a6:	411585bb          	subw	a1,a1,a7
ffffffffc02016aa:	ca0c                	sw	a1,16(a2)
ffffffffc02016ac:	5775                	li	a4,-3
ffffffffc02016ae:	17c1                	add	a5,a5,-16
ffffffffc02016b0:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc02016b4:	8082                	ret
ffffffffc02016b6:	1141                	add	sp,sp,-16
ffffffffc02016b8:	00005697          	auipc	a3,0x5
ffffffffc02016bc:	f8068693          	add	a3,a3,-128 # ffffffffc0206638 <commands+0xa90>
ffffffffc02016c0:	00005617          	auipc	a2,0x5
ffffffffc02016c4:	93860613          	add	a2,a2,-1736 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02016c8:	06200593          	li	a1,98
ffffffffc02016cc:	00005517          	auipc	a0,0x5
ffffffffc02016d0:	c2c50513          	add	a0,a0,-980 # ffffffffc02062f8 <commands+0x750>
ffffffffc02016d4:	e406                	sd	ra,8(sp)
ffffffffc02016d6:	d9dfe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02016da <default_init_memmap>:
ffffffffc02016da:	1141                	add	sp,sp,-16
ffffffffc02016dc:	e406                	sd	ra,8(sp)
ffffffffc02016de:	c5f1                	beqz	a1,ffffffffc02017aa <default_init_memmap+0xd0>
ffffffffc02016e0:	00659713          	sll	a4,a1,0x6
ffffffffc02016e4:	00e506b3          	add	a3,a0,a4
ffffffffc02016e8:	87aa                	mv	a5,a0
ffffffffc02016ea:	cf11                	beqz	a4,ffffffffc0201706 <default_init_memmap+0x2c>
ffffffffc02016ec:	6798                	ld	a4,8(a5)
ffffffffc02016ee:	8b05                	and	a4,a4,1
ffffffffc02016f0:	cf49                	beqz	a4,ffffffffc020178a <default_init_memmap+0xb0>
ffffffffc02016f2:	0007a823          	sw	zero,16(a5)
ffffffffc02016f6:	0007b423          	sd	zero,8(a5)
ffffffffc02016fa:	0007a023          	sw	zero,0(a5)
ffffffffc02016fe:	04078793          	add	a5,a5,64
ffffffffc0201702:	fed795e3          	bne	a5,a3,ffffffffc02016ec <default_init_memmap+0x12>
ffffffffc0201706:	2581                	sext.w	a1,a1
ffffffffc0201708:	c90c                	sw	a1,16(a0)
ffffffffc020170a:	4789                	li	a5,2
ffffffffc020170c:	00850713          	add	a4,a0,8
ffffffffc0201710:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201714:	00012697          	auipc	a3,0x12
ffffffffc0201718:	d7c68693          	add	a3,a3,-644 # ffffffffc0213490 <free_area>
ffffffffc020171c:	4a98                	lw	a4,16(a3)
ffffffffc020171e:	669c                	ld	a5,8(a3)
ffffffffc0201720:	9f2d                	addw	a4,a4,a1
ffffffffc0201722:	ca98                	sw	a4,16(a3)
ffffffffc0201724:	04d78663          	beq	a5,a3,ffffffffc0201770 <default_init_memmap+0x96>
ffffffffc0201728:	fe878713          	add	a4,a5,-24
ffffffffc020172c:	4581                	li	a1,0
ffffffffc020172e:	01850613          	add	a2,a0,24
ffffffffc0201732:	00e56a63          	bltu	a0,a4,ffffffffc0201746 <default_init_memmap+0x6c>
ffffffffc0201736:	6798                	ld	a4,8(a5)
ffffffffc0201738:	02d70263          	beq	a4,a3,ffffffffc020175c <default_init_memmap+0x82>
ffffffffc020173c:	87ba                	mv	a5,a4
ffffffffc020173e:	fe878713          	add	a4,a5,-24
ffffffffc0201742:	fee57ae3          	bgeu	a0,a4,ffffffffc0201736 <default_init_memmap+0x5c>
ffffffffc0201746:	c199                	beqz	a1,ffffffffc020174c <default_init_memmap+0x72>
ffffffffc0201748:	0106b023          	sd	a6,0(a3)
ffffffffc020174c:	6398                	ld	a4,0(a5)
ffffffffc020174e:	60a2                	ld	ra,8(sp)
ffffffffc0201750:	e390                	sd	a2,0(a5)
ffffffffc0201752:	e710                	sd	a2,8(a4)
ffffffffc0201754:	f11c                	sd	a5,32(a0)
ffffffffc0201756:	ed18                	sd	a4,24(a0)
ffffffffc0201758:	0141                	add	sp,sp,16
ffffffffc020175a:	8082                	ret
ffffffffc020175c:	e790                	sd	a2,8(a5)
ffffffffc020175e:	f114                	sd	a3,32(a0)
ffffffffc0201760:	6798                	ld	a4,8(a5)
ffffffffc0201762:	ed1c                	sd	a5,24(a0)
ffffffffc0201764:	8832                	mv	a6,a2
ffffffffc0201766:	00d70e63          	beq	a4,a3,ffffffffc0201782 <default_init_memmap+0xa8>
ffffffffc020176a:	4585                	li	a1,1
ffffffffc020176c:	87ba                	mv	a5,a4
ffffffffc020176e:	bfc1                	j	ffffffffc020173e <default_init_memmap+0x64>
ffffffffc0201770:	60a2                	ld	ra,8(sp)
ffffffffc0201772:	01850713          	add	a4,a0,24
ffffffffc0201776:	e398                	sd	a4,0(a5)
ffffffffc0201778:	e798                	sd	a4,8(a5)
ffffffffc020177a:	f11c                	sd	a5,32(a0)
ffffffffc020177c:	ed1c                	sd	a5,24(a0)
ffffffffc020177e:	0141                	add	sp,sp,16
ffffffffc0201780:	8082                	ret
ffffffffc0201782:	60a2                	ld	ra,8(sp)
ffffffffc0201784:	e290                	sd	a2,0(a3)
ffffffffc0201786:	0141                	add	sp,sp,16
ffffffffc0201788:	8082                	ret
ffffffffc020178a:	00005697          	auipc	a3,0x5
ffffffffc020178e:	ede68693          	add	a3,a3,-290 # ffffffffc0206668 <commands+0xac0>
ffffffffc0201792:	00005617          	auipc	a2,0x5
ffffffffc0201796:	86660613          	add	a2,a2,-1946 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020179a:	04900593          	li	a1,73
ffffffffc020179e:	00005517          	auipc	a0,0x5
ffffffffc02017a2:	b5a50513          	add	a0,a0,-1190 # ffffffffc02062f8 <commands+0x750>
ffffffffc02017a6:	ccdfe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02017aa:	00005697          	auipc	a3,0x5
ffffffffc02017ae:	e8e68693          	add	a3,a3,-370 # ffffffffc0206638 <commands+0xa90>
ffffffffc02017b2:	00005617          	auipc	a2,0x5
ffffffffc02017b6:	84660613          	add	a2,a2,-1978 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02017ba:	04600593          	li	a1,70
ffffffffc02017be:	00005517          	auipc	a0,0x5
ffffffffc02017c2:	b3a50513          	add	a0,a0,-1222 # ffffffffc02062f8 <commands+0x750>
ffffffffc02017c6:	cadfe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02017ca <slob_free>:
ffffffffc02017ca:	c955                	beqz	a0,ffffffffc020187e <slob_free+0xb4>
ffffffffc02017cc:	1141                	add	sp,sp,-16
ffffffffc02017ce:	e022                	sd	s0,0(sp)
ffffffffc02017d0:	e406                	sd	ra,8(sp)
ffffffffc02017d2:	842a                	mv	s0,a0
ffffffffc02017d4:	e9c9                	bnez	a1,ffffffffc0201866 <slob_free+0x9c>
ffffffffc02017d6:	100027f3          	csrr	a5,sstatus
ffffffffc02017da:	8b89                	and	a5,a5,2
ffffffffc02017dc:	4501                	li	a0,0
ffffffffc02017de:	efc1                	bnez	a5,ffffffffc0201876 <slob_free+0xac>
ffffffffc02017e0:	0000b617          	auipc	a2,0xb
ffffffffc02017e4:	8a060613          	add	a2,a2,-1888 # ffffffffc020c080 <slobfree>
ffffffffc02017e8:	621c                	ld	a5,0(a2)
ffffffffc02017ea:	873e                	mv	a4,a5
ffffffffc02017ec:	679c                	ld	a5,8(a5)
ffffffffc02017ee:	02877a63          	bgeu	a4,s0,ffffffffc0201822 <slob_free+0x58>
ffffffffc02017f2:	00f46463          	bltu	s0,a5,ffffffffc02017fa <slob_free+0x30>
ffffffffc02017f6:	fef76ae3          	bltu	a4,a5,ffffffffc02017ea <slob_free+0x20>
ffffffffc02017fa:	400c                	lw	a1,0(s0)
ffffffffc02017fc:	00459693          	sll	a3,a1,0x4
ffffffffc0201800:	96a2                	add	a3,a3,s0
ffffffffc0201802:	02d78a63          	beq	a5,a3,ffffffffc0201836 <slob_free+0x6c>
ffffffffc0201806:	430c                	lw	a1,0(a4)
ffffffffc0201808:	e41c                	sd	a5,8(s0)
ffffffffc020180a:	00459693          	sll	a3,a1,0x4
ffffffffc020180e:	96ba                	add	a3,a3,a4
ffffffffc0201810:	02d40e63          	beq	s0,a3,ffffffffc020184c <slob_free+0x82>
ffffffffc0201814:	e700                	sd	s0,8(a4)
ffffffffc0201816:	e218                	sd	a4,0(a2)
ffffffffc0201818:	e131                	bnez	a0,ffffffffc020185c <slob_free+0x92>
ffffffffc020181a:	60a2                	ld	ra,8(sp)
ffffffffc020181c:	6402                	ld	s0,0(sp)
ffffffffc020181e:	0141                	add	sp,sp,16
ffffffffc0201820:	8082                	ret
ffffffffc0201822:	fcf764e3          	bltu	a4,a5,ffffffffc02017ea <slob_free+0x20>
ffffffffc0201826:	fcf472e3          	bgeu	s0,a5,ffffffffc02017ea <slob_free+0x20>
ffffffffc020182a:	400c                	lw	a1,0(s0)
ffffffffc020182c:	00459693          	sll	a3,a1,0x4
ffffffffc0201830:	96a2                	add	a3,a3,s0
ffffffffc0201832:	fcd79ae3          	bne	a5,a3,ffffffffc0201806 <slob_free+0x3c>
ffffffffc0201836:	4394                	lw	a3,0(a5)
ffffffffc0201838:	679c                	ld	a5,8(a5)
ffffffffc020183a:	9ead                	addw	a3,a3,a1
ffffffffc020183c:	c014                	sw	a3,0(s0)
ffffffffc020183e:	430c                	lw	a1,0(a4)
ffffffffc0201840:	e41c                	sd	a5,8(s0)
ffffffffc0201842:	00459693          	sll	a3,a1,0x4
ffffffffc0201846:	96ba                	add	a3,a3,a4
ffffffffc0201848:	fcd416e3          	bne	s0,a3,ffffffffc0201814 <slob_free+0x4a>
ffffffffc020184c:	4014                	lw	a3,0(s0)
ffffffffc020184e:	843e                	mv	s0,a5
ffffffffc0201850:	e700                	sd	s0,8(a4)
ffffffffc0201852:	00b687bb          	addw	a5,a3,a1
ffffffffc0201856:	c31c                	sw	a5,0(a4)
ffffffffc0201858:	e218                	sd	a4,0(a2)
ffffffffc020185a:	d161                	beqz	a0,ffffffffc020181a <slob_free+0x50>
ffffffffc020185c:	6402                	ld	s0,0(sp)
ffffffffc020185e:	60a2                	ld	ra,8(sp)
ffffffffc0201860:	0141                	add	sp,sp,16
ffffffffc0201862:	dcdfe06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0201866:	25bd                	addw	a1,a1,15
ffffffffc0201868:	8191                	srl	a1,a1,0x4
ffffffffc020186a:	c10c                	sw	a1,0(a0)
ffffffffc020186c:	100027f3          	csrr	a5,sstatus
ffffffffc0201870:	8b89                	and	a5,a5,2
ffffffffc0201872:	4501                	li	a0,0
ffffffffc0201874:	d7b5                	beqz	a5,ffffffffc02017e0 <slob_free+0x16>
ffffffffc0201876:	dbffe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020187a:	4505                	li	a0,1
ffffffffc020187c:	b795                	j	ffffffffc02017e0 <slob_free+0x16>
ffffffffc020187e:	8082                	ret

ffffffffc0201880 <__slob_get_free_pages.constprop.0>:
ffffffffc0201880:	4785                	li	a5,1
ffffffffc0201882:	1141                	add	sp,sp,-16
ffffffffc0201884:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201888:	e406                	sd	ra,8(sp)
ffffffffc020188a:	306000ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc020188e:	c91d                	beqz	a0,ffffffffc02018c4 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201890:	00016797          	auipc	a5,0x16
ffffffffc0201894:	d907b783          	ld	a5,-624(a5) # ffffffffc0217620 <pages>
ffffffffc0201898:	8d1d                	sub	a0,a0,a5
ffffffffc020189a:	8519                	sra	a0,a0,0x6
ffffffffc020189c:	00006797          	auipc	a5,0x6
ffffffffc02018a0:	7dc7b783          	ld	a5,2012(a5) # ffffffffc0208078 <nbase>
ffffffffc02018a4:	953e                	add	a0,a0,a5
ffffffffc02018a6:	00c51793          	sll	a5,a0,0xc
ffffffffc02018aa:	83b1                	srl	a5,a5,0xc
ffffffffc02018ac:	00016717          	auipc	a4,0x16
ffffffffc02018b0:	d6c73703          	ld	a4,-660(a4) # ffffffffc0217618 <npage>
ffffffffc02018b4:	0532                	sll	a0,a0,0xc
ffffffffc02018b6:	00e7fa63          	bgeu	a5,a4,ffffffffc02018ca <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02018ba:	00016797          	auipc	a5,0x16
ffffffffc02018be:	d567b783          	ld	a5,-682(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc02018c2:	953e                	add	a0,a0,a5
ffffffffc02018c4:	60a2                	ld	ra,8(sp)
ffffffffc02018c6:	0141                	add	sp,sp,16
ffffffffc02018c8:	8082                	ret
ffffffffc02018ca:	86aa                	mv	a3,a0
ffffffffc02018cc:	00005617          	auipc	a2,0x5
ffffffffc02018d0:	dfc60613          	add	a2,a2,-516 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc02018d4:	06900593          	li	a1,105
ffffffffc02018d8:	00005517          	auipc	a0,0x5
ffffffffc02018dc:	e1850513          	add	a0,a0,-488 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc02018e0:	b93fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02018e4 <slob_alloc.constprop.0>:
ffffffffc02018e4:	1101                	add	sp,sp,-32
ffffffffc02018e6:	ec06                	sd	ra,24(sp)
ffffffffc02018e8:	e822                	sd	s0,16(sp)
ffffffffc02018ea:	e426                	sd	s1,8(sp)
ffffffffc02018ec:	e04a                	sd	s2,0(sp)
ffffffffc02018ee:	01050713          	add	a4,a0,16
ffffffffc02018f2:	6785                	lui	a5,0x1
ffffffffc02018f4:	0cf77363          	bgeu	a4,a5,ffffffffc02019ba <slob_alloc.constprop.0+0xd6>
ffffffffc02018f8:	00f50493          	add	s1,a0,15
ffffffffc02018fc:	8091                	srl	s1,s1,0x4
ffffffffc02018fe:	2481                	sext.w	s1,s1
ffffffffc0201900:	10002673          	csrr	a2,sstatus
ffffffffc0201904:	8a09                	and	a2,a2,2
ffffffffc0201906:	e25d                	bnez	a2,ffffffffc02019ac <slob_alloc.constprop.0+0xc8>
ffffffffc0201908:	0000a917          	auipc	s2,0xa
ffffffffc020190c:	77890913          	add	s2,s2,1912 # ffffffffc020c080 <slobfree>
ffffffffc0201910:	00093683          	ld	a3,0(s2)
ffffffffc0201914:	669c                	ld	a5,8(a3)
ffffffffc0201916:	4398                	lw	a4,0(a5)
ffffffffc0201918:	08975e63          	bge	a4,s1,ffffffffc02019b4 <slob_alloc.constprop.0+0xd0>
ffffffffc020191c:	00f68b63          	beq	a3,a5,ffffffffc0201932 <slob_alloc.constprop.0+0x4e>
ffffffffc0201920:	6780                	ld	s0,8(a5)
ffffffffc0201922:	4018                	lw	a4,0(s0)
ffffffffc0201924:	02975a63          	bge	a4,s1,ffffffffc0201958 <slob_alloc.constprop.0+0x74>
ffffffffc0201928:	00093683          	ld	a3,0(s2)
ffffffffc020192c:	87a2                	mv	a5,s0
ffffffffc020192e:	fef699e3          	bne	a3,a5,ffffffffc0201920 <slob_alloc.constprop.0+0x3c>
ffffffffc0201932:	ee31                	bnez	a2,ffffffffc020198e <slob_alloc.constprop.0+0xaa>
ffffffffc0201934:	4501                	li	a0,0
ffffffffc0201936:	f4bff0ef          	jal	ffffffffc0201880 <__slob_get_free_pages.constprop.0>
ffffffffc020193a:	842a                	mv	s0,a0
ffffffffc020193c:	cd05                	beqz	a0,ffffffffc0201974 <slob_alloc.constprop.0+0x90>
ffffffffc020193e:	6585                	lui	a1,0x1
ffffffffc0201940:	e8bff0ef          	jal	ffffffffc02017ca <slob_free>
ffffffffc0201944:	10002673          	csrr	a2,sstatus
ffffffffc0201948:	8a09                	and	a2,a2,2
ffffffffc020194a:	ee05                	bnez	a2,ffffffffc0201982 <slob_alloc.constprop.0+0x9e>
ffffffffc020194c:	00093783          	ld	a5,0(s2)
ffffffffc0201950:	6780                	ld	s0,8(a5)
ffffffffc0201952:	4018                	lw	a4,0(s0)
ffffffffc0201954:	fc974ae3          	blt	a4,s1,ffffffffc0201928 <slob_alloc.constprop.0+0x44>
ffffffffc0201958:	04e48763          	beq	s1,a4,ffffffffc02019a6 <slob_alloc.constprop.0+0xc2>
ffffffffc020195c:	00449693          	sll	a3,s1,0x4
ffffffffc0201960:	96a2                	add	a3,a3,s0
ffffffffc0201962:	e794                	sd	a3,8(a5)
ffffffffc0201964:	640c                	ld	a1,8(s0)
ffffffffc0201966:	9f05                	subw	a4,a4,s1
ffffffffc0201968:	c298                	sw	a4,0(a3)
ffffffffc020196a:	e68c                	sd	a1,8(a3)
ffffffffc020196c:	c004                	sw	s1,0(s0)
ffffffffc020196e:	00f93023          	sd	a5,0(s2)
ffffffffc0201972:	e20d                	bnez	a2,ffffffffc0201994 <slob_alloc.constprop.0+0xb0>
ffffffffc0201974:	60e2                	ld	ra,24(sp)
ffffffffc0201976:	8522                	mv	a0,s0
ffffffffc0201978:	6442                	ld	s0,16(sp)
ffffffffc020197a:	64a2                	ld	s1,8(sp)
ffffffffc020197c:	6902                	ld	s2,0(sp)
ffffffffc020197e:	6105                	add	sp,sp,32
ffffffffc0201980:	8082                	ret
ffffffffc0201982:	cb3fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201986:	00093783          	ld	a5,0(s2)
ffffffffc020198a:	4605                	li	a2,1
ffffffffc020198c:	b7d1                	j	ffffffffc0201950 <slob_alloc.constprop.0+0x6c>
ffffffffc020198e:	ca1fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201992:	b74d                	j	ffffffffc0201934 <slob_alloc.constprop.0+0x50>
ffffffffc0201994:	c9bfe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201998:	60e2                	ld	ra,24(sp)
ffffffffc020199a:	8522                	mv	a0,s0
ffffffffc020199c:	6442                	ld	s0,16(sp)
ffffffffc020199e:	64a2                	ld	s1,8(sp)
ffffffffc02019a0:	6902                	ld	s2,0(sp)
ffffffffc02019a2:	6105                	add	sp,sp,32
ffffffffc02019a4:	8082                	ret
ffffffffc02019a6:	6418                	ld	a4,8(s0)
ffffffffc02019a8:	e798                	sd	a4,8(a5)
ffffffffc02019aa:	b7d1                	j	ffffffffc020196e <slob_alloc.constprop.0+0x8a>
ffffffffc02019ac:	c89fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02019b0:	4605                	li	a2,1
ffffffffc02019b2:	bf99                	j	ffffffffc0201908 <slob_alloc.constprop.0+0x24>
ffffffffc02019b4:	843e                	mv	s0,a5
ffffffffc02019b6:	87b6                	mv	a5,a3
ffffffffc02019b8:	b745                	j	ffffffffc0201958 <slob_alloc.constprop.0+0x74>
ffffffffc02019ba:	00005697          	auipc	a3,0x5
ffffffffc02019be:	d4668693          	add	a3,a3,-698 # ffffffffc0206700 <default_pmm_manager+0x70>
ffffffffc02019c2:	00004617          	auipc	a2,0x4
ffffffffc02019c6:	63660613          	add	a2,a2,1590 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02019ca:	06400593          	li	a1,100
ffffffffc02019ce:	00005517          	auipc	a0,0x5
ffffffffc02019d2:	d5250513          	add	a0,a0,-686 # ffffffffc0206720 <default_pmm_manager+0x90>
ffffffffc02019d6:	a9dfe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02019da <kallocated>:
ffffffffc02019da:	4501                	li	a0,0
ffffffffc02019dc:	8082                	ret

ffffffffc02019de <kmalloc>:
ffffffffc02019de:	1101                	add	sp,sp,-32
ffffffffc02019e0:	e04a                	sd	s2,0(sp)
ffffffffc02019e2:	6905                	lui	s2,0x1
ffffffffc02019e4:	e822                	sd	s0,16(sp)
ffffffffc02019e6:	ec06                	sd	ra,24(sp)
ffffffffc02019e8:	e426                	sd	s1,8(sp)
ffffffffc02019ea:	fef90793          	add	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
ffffffffc02019ee:	842a                	mv	s0,a0
ffffffffc02019f0:	04a7f763          	bgeu	a5,a0,ffffffffc0201a3e <kmalloc+0x60>
ffffffffc02019f4:	4561                	li	a0,24
ffffffffc02019f6:	eefff0ef          	jal	ffffffffc02018e4 <slob_alloc.constprop.0>
ffffffffc02019fa:	84aa                	mv	s1,a0
ffffffffc02019fc:	c539                	beqz	a0,ffffffffc0201a4a <kmalloc+0x6c>
ffffffffc02019fe:	0004079b          	sext.w	a5,s0
ffffffffc0201a02:	4501                	li	a0,0
ffffffffc0201a04:	00f95763          	bge	s2,a5,ffffffffc0201a12 <kmalloc+0x34>
ffffffffc0201a08:	6705                	lui	a4,0x1
ffffffffc0201a0a:	8785                	sra	a5,a5,0x1
ffffffffc0201a0c:	2505                	addw	a0,a0,1
ffffffffc0201a0e:	fef74ee3          	blt	a4,a5,ffffffffc0201a0a <kmalloc+0x2c>
ffffffffc0201a12:	c088                	sw	a0,0(s1)
ffffffffc0201a14:	e6dff0ef          	jal	ffffffffc0201880 <__slob_get_free_pages.constprop.0>
ffffffffc0201a18:	e488                	sd	a0,8(s1)
ffffffffc0201a1a:	cd21                	beqz	a0,ffffffffc0201a72 <kmalloc+0x94>
ffffffffc0201a1c:	100027f3          	csrr	a5,sstatus
ffffffffc0201a20:	8b89                	and	a5,a5,2
ffffffffc0201a22:	e795                	bnez	a5,ffffffffc0201a4e <kmalloc+0x70>
ffffffffc0201a24:	00016797          	auipc	a5,0x16
ffffffffc0201a28:	bcc78793          	add	a5,a5,-1076 # ffffffffc02175f0 <bigblocks>
ffffffffc0201a2c:	6398                	ld	a4,0(a5)
ffffffffc0201a2e:	e384                	sd	s1,0(a5)
ffffffffc0201a30:	e898                	sd	a4,16(s1)
ffffffffc0201a32:	60e2                	ld	ra,24(sp)
ffffffffc0201a34:	6442                	ld	s0,16(sp)
ffffffffc0201a36:	64a2                	ld	s1,8(sp)
ffffffffc0201a38:	6902                	ld	s2,0(sp)
ffffffffc0201a3a:	6105                	add	sp,sp,32
ffffffffc0201a3c:	8082                	ret
ffffffffc0201a3e:	0541                	add	a0,a0,16
ffffffffc0201a40:	ea5ff0ef          	jal	ffffffffc02018e4 <slob_alloc.constprop.0>
ffffffffc0201a44:	87aa                	mv	a5,a0
ffffffffc0201a46:	0541                	add	a0,a0,16
ffffffffc0201a48:	f7ed                	bnez	a5,ffffffffc0201a32 <kmalloc+0x54>
ffffffffc0201a4a:	4501                	li	a0,0
ffffffffc0201a4c:	b7dd                	j	ffffffffc0201a32 <kmalloc+0x54>
ffffffffc0201a4e:	be7fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201a52:	00016797          	auipc	a5,0x16
ffffffffc0201a56:	b9e78793          	add	a5,a5,-1122 # ffffffffc02175f0 <bigblocks>
ffffffffc0201a5a:	6398                	ld	a4,0(a5)
ffffffffc0201a5c:	e384                	sd	s1,0(a5)
ffffffffc0201a5e:	e898                	sd	a4,16(s1)
ffffffffc0201a60:	bcffe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201a64:	60e2                	ld	ra,24(sp)
ffffffffc0201a66:	6442                	ld	s0,16(sp)
ffffffffc0201a68:	6488                	ld	a0,8(s1)
ffffffffc0201a6a:	6902                	ld	s2,0(sp)
ffffffffc0201a6c:	64a2                	ld	s1,8(sp)
ffffffffc0201a6e:	6105                	add	sp,sp,32
ffffffffc0201a70:	8082                	ret
ffffffffc0201a72:	8526                	mv	a0,s1
ffffffffc0201a74:	45e1                	li	a1,24
ffffffffc0201a76:	d55ff0ef          	jal	ffffffffc02017ca <slob_free>
ffffffffc0201a7a:	4501                	li	a0,0
ffffffffc0201a7c:	bf5d                	j	ffffffffc0201a32 <kmalloc+0x54>

ffffffffc0201a7e <kfree>:
ffffffffc0201a7e:	c169                	beqz	a0,ffffffffc0201b40 <kfree+0xc2>
ffffffffc0201a80:	1101                	add	sp,sp,-32
ffffffffc0201a82:	e822                	sd	s0,16(sp)
ffffffffc0201a84:	ec06                	sd	ra,24(sp)
ffffffffc0201a86:	e426                	sd	s1,8(sp)
ffffffffc0201a88:	03451793          	sll	a5,a0,0x34
ffffffffc0201a8c:	842a                	mv	s0,a0
ffffffffc0201a8e:	e3d9                	bnez	a5,ffffffffc0201b14 <kfree+0x96>
ffffffffc0201a90:	100027f3          	csrr	a5,sstatus
ffffffffc0201a94:	8b89                	and	a5,a5,2
ffffffffc0201a96:	e7d9                	bnez	a5,ffffffffc0201b24 <kfree+0xa6>
ffffffffc0201a98:	00016797          	auipc	a5,0x16
ffffffffc0201a9c:	b587b783          	ld	a5,-1192(a5) # ffffffffc02175f0 <bigblocks>
ffffffffc0201aa0:	4601                	li	a2,0
ffffffffc0201aa2:	cbad                	beqz	a5,ffffffffc0201b14 <kfree+0x96>
ffffffffc0201aa4:	00016697          	auipc	a3,0x16
ffffffffc0201aa8:	b4c68693          	add	a3,a3,-1204 # ffffffffc02175f0 <bigblocks>
ffffffffc0201aac:	a021                	j	ffffffffc0201ab4 <kfree+0x36>
ffffffffc0201aae:	01048693          	add	a3,s1,16
ffffffffc0201ab2:	c3a5                	beqz	a5,ffffffffc0201b12 <kfree+0x94>
ffffffffc0201ab4:	6798                	ld	a4,8(a5)
ffffffffc0201ab6:	84be                	mv	s1,a5
ffffffffc0201ab8:	6b9c                	ld	a5,16(a5)
ffffffffc0201aba:	fe871ae3          	bne	a4,s0,ffffffffc0201aae <kfree+0x30>
ffffffffc0201abe:	e29c                	sd	a5,0(a3)
ffffffffc0201ac0:	ee2d                	bnez	a2,ffffffffc0201b3a <kfree+0xbc>
ffffffffc0201ac2:	c02007b7          	lui	a5,0xc0200
ffffffffc0201ac6:	4098                	lw	a4,0(s1)
ffffffffc0201ac8:	08f46963          	bltu	s0,a5,ffffffffc0201b5a <kfree+0xdc>
ffffffffc0201acc:	00016797          	auipc	a5,0x16
ffffffffc0201ad0:	b447b783          	ld	a5,-1212(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc0201ad4:	8c1d                	sub	s0,s0,a5
ffffffffc0201ad6:	8031                	srl	s0,s0,0xc
ffffffffc0201ad8:	00016797          	auipc	a5,0x16
ffffffffc0201adc:	b407b783          	ld	a5,-1216(a5) # ffffffffc0217618 <npage>
ffffffffc0201ae0:	06f47163          	bgeu	s0,a5,ffffffffc0201b42 <kfree+0xc4>
ffffffffc0201ae4:	00006797          	auipc	a5,0x6
ffffffffc0201ae8:	5947b783          	ld	a5,1428(a5) # ffffffffc0208078 <nbase>
ffffffffc0201aec:	8c1d                	sub	s0,s0,a5
ffffffffc0201aee:	041a                	sll	s0,s0,0x6
ffffffffc0201af0:	00016517          	auipc	a0,0x16
ffffffffc0201af4:	b3053503          	ld	a0,-1232(a0) # ffffffffc0217620 <pages>
ffffffffc0201af8:	4585                	li	a1,1
ffffffffc0201afa:	9522                	add	a0,a0,s0
ffffffffc0201afc:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201b00:	120000ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0201b04:	6442                	ld	s0,16(sp)
ffffffffc0201b06:	60e2                	ld	ra,24(sp)
ffffffffc0201b08:	8526                	mv	a0,s1
ffffffffc0201b0a:	64a2                	ld	s1,8(sp)
ffffffffc0201b0c:	45e1                	li	a1,24
ffffffffc0201b0e:	6105                	add	sp,sp,32
ffffffffc0201b10:	b96d                	j	ffffffffc02017ca <slob_free>
ffffffffc0201b12:	e20d                	bnez	a2,ffffffffc0201b34 <kfree+0xb6>
ffffffffc0201b14:	ff040513          	add	a0,s0,-16
ffffffffc0201b18:	6442                	ld	s0,16(sp)
ffffffffc0201b1a:	60e2                	ld	ra,24(sp)
ffffffffc0201b1c:	64a2                	ld	s1,8(sp)
ffffffffc0201b1e:	4581                	li	a1,0
ffffffffc0201b20:	6105                	add	sp,sp,32
ffffffffc0201b22:	b165                	j	ffffffffc02017ca <slob_free>
ffffffffc0201b24:	b11fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201b28:	00016797          	auipc	a5,0x16
ffffffffc0201b2c:	ac87b783          	ld	a5,-1336(a5) # ffffffffc02175f0 <bigblocks>
ffffffffc0201b30:	4605                	li	a2,1
ffffffffc0201b32:	fbad                	bnez	a5,ffffffffc0201aa4 <kfree+0x26>
ffffffffc0201b34:	afbfe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201b38:	bff1                	j	ffffffffc0201b14 <kfree+0x96>
ffffffffc0201b3a:	af5fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201b3e:	b751                	j	ffffffffc0201ac2 <kfree+0x44>
ffffffffc0201b40:	8082                	ret
ffffffffc0201b42:	00005617          	auipc	a2,0x5
ffffffffc0201b46:	c1e60613          	add	a2,a2,-994 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc0201b4a:	06200593          	li	a1,98
ffffffffc0201b4e:	00005517          	auipc	a0,0x5
ffffffffc0201b52:	ba250513          	add	a0,a0,-1118 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0201b56:	91dfe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201b5a:	86a2                	mv	a3,s0
ffffffffc0201b5c:	00005617          	auipc	a2,0x5
ffffffffc0201b60:	bdc60613          	add	a2,a2,-1060 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc0201b64:	06e00593          	li	a1,110
ffffffffc0201b68:	00005517          	auipc	a0,0x5
ffffffffc0201b6c:	b8850513          	add	a0,a0,-1144 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0201b70:	903fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201b74 <pa2page.part.0>:
ffffffffc0201b74:	1141                	add	sp,sp,-16
ffffffffc0201b76:	00005617          	auipc	a2,0x5
ffffffffc0201b7a:	bea60613          	add	a2,a2,-1046 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc0201b7e:	06200593          	li	a1,98
ffffffffc0201b82:	00005517          	auipc	a0,0x5
ffffffffc0201b86:	b6e50513          	add	a0,a0,-1170 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0201b8a:	e406                	sd	ra,8(sp)
ffffffffc0201b8c:	8e7fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201b90 <alloc_pages>:
ffffffffc0201b90:	7139                	add	sp,sp,-64
ffffffffc0201b92:	f426                	sd	s1,40(sp)
ffffffffc0201b94:	f04a                	sd	s2,32(sp)
ffffffffc0201b96:	ec4e                	sd	s3,24(sp)
ffffffffc0201b98:	e852                	sd	s4,16(sp)
ffffffffc0201b9a:	e456                	sd	s5,8(sp)
ffffffffc0201b9c:	e05a                	sd	s6,0(sp)
ffffffffc0201b9e:	fc06                	sd	ra,56(sp)
ffffffffc0201ba0:	f822                	sd	s0,48(sp)
ffffffffc0201ba2:	84aa                	mv	s1,a0
ffffffffc0201ba4:	00016917          	auipc	s2,0x16
ffffffffc0201ba8:	a5490913          	add	s2,s2,-1452 # ffffffffc02175f8 <pmm_manager>
ffffffffc0201bac:	4a05                	li	s4,1
ffffffffc0201bae:	00016a97          	auipc	s5,0x16
ffffffffc0201bb2:	a7aa8a93          	add	s5,s5,-1414 # ffffffffc0217628 <swap_init_ok>
ffffffffc0201bb6:	0005099b          	sext.w	s3,a0
ffffffffc0201bba:	00016b17          	auipc	s6,0x16
ffffffffc0201bbe:	a8eb0b13          	add	s6,s6,-1394 # ffffffffc0217648 <check_mm_struct>
ffffffffc0201bc2:	a015                	j	ffffffffc0201be6 <alloc_pages+0x56>
ffffffffc0201bc4:	00093783          	ld	a5,0(s2)
ffffffffc0201bc8:	6f9c                	ld	a5,24(a5)
ffffffffc0201bca:	9782                	jalr	a5
ffffffffc0201bcc:	842a                	mv	s0,a0
ffffffffc0201bce:	4601                	li	a2,0
ffffffffc0201bd0:	85ce                	mv	a1,s3
ffffffffc0201bd2:	ec05                	bnez	s0,ffffffffc0201c0a <alloc_pages+0x7a>
ffffffffc0201bd4:	029a6b63          	bltu	s4,s1,ffffffffc0201c0a <alloc_pages+0x7a>
ffffffffc0201bd8:	000aa783          	lw	a5,0(s5)
ffffffffc0201bdc:	c79d                	beqz	a5,ffffffffc0201c0a <alloc_pages+0x7a>
ffffffffc0201bde:	000b3503          	ld	a0,0(s6)
ffffffffc0201be2:	2d3000ef          	jal	ffffffffc02026b4 <swap_out>
ffffffffc0201be6:	100027f3          	csrr	a5,sstatus
ffffffffc0201bea:	8b89                	and	a5,a5,2
ffffffffc0201bec:	8526                	mv	a0,s1
ffffffffc0201bee:	dbf9                	beqz	a5,ffffffffc0201bc4 <alloc_pages+0x34>
ffffffffc0201bf0:	a45fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201bf4:	00093783          	ld	a5,0(s2)
ffffffffc0201bf8:	8526                	mv	a0,s1
ffffffffc0201bfa:	6f9c                	ld	a5,24(a5)
ffffffffc0201bfc:	9782                	jalr	a5
ffffffffc0201bfe:	842a                	mv	s0,a0
ffffffffc0201c00:	a2ffe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201c04:	4601                	li	a2,0
ffffffffc0201c06:	85ce                	mv	a1,s3
ffffffffc0201c08:	d471                	beqz	s0,ffffffffc0201bd4 <alloc_pages+0x44>
ffffffffc0201c0a:	70e2                	ld	ra,56(sp)
ffffffffc0201c0c:	8522                	mv	a0,s0
ffffffffc0201c0e:	7442                	ld	s0,48(sp)
ffffffffc0201c10:	74a2                	ld	s1,40(sp)
ffffffffc0201c12:	7902                	ld	s2,32(sp)
ffffffffc0201c14:	69e2                	ld	s3,24(sp)
ffffffffc0201c16:	6a42                	ld	s4,16(sp)
ffffffffc0201c18:	6aa2                	ld	s5,8(sp)
ffffffffc0201c1a:	6b02                	ld	s6,0(sp)
ffffffffc0201c1c:	6121                	add	sp,sp,64
ffffffffc0201c1e:	8082                	ret

ffffffffc0201c20 <free_pages>:
ffffffffc0201c20:	100027f3          	csrr	a5,sstatus
ffffffffc0201c24:	8b89                	and	a5,a5,2
ffffffffc0201c26:	e799                	bnez	a5,ffffffffc0201c34 <free_pages+0x14>
ffffffffc0201c28:	00016797          	auipc	a5,0x16
ffffffffc0201c2c:	9d07b783          	ld	a5,-1584(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc0201c30:	739c                	ld	a5,32(a5)
ffffffffc0201c32:	8782                	jr	a5
ffffffffc0201c34:	1101                	add	sp,sp,-32
ffffffffc0201c36:	ec06                	sd	ra,24(sp)
ffffffffc0201c38:	e822                	sd	s0,16(sp)
ffffffffc0201c3a:	e426                	sd	s1,8(sp)
ffffffffc0201c3c:	842a                	mv	s0,a0
ffffffffc0201c3e:	84ae                	mv	s1,a1
ffffffffc0201c40:	9f5fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201c44:	00016797          	auipc	a5,0x16
ffffffffc0201c48:	9b47b783          	ld	a5,-1612(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc0201c4c:	739c                	ld	a5,32(a5)
ffffffffc0201c4e:	85a6                	mv	a1,s1
ffffffffc0201c50:	8522                	mv	a0,s0
ffffffffc0201c52:	9782                	jalr	a5
ffffffffc0201c54:	6442                	ld	s0,16(sp)
ffffffffc0201c56:	60e2                	ld	ra,24(sp)
ffffffffc0201c58:	64a2                	ld	s1,8(sp)
ffffffffc0201c5a:	6105                	add	sp,sp,32
ffffffffc0201c5c:	9d3fe06f          	j	ffffffffc020062e <intr_enable>

ffffffffc0201c60 <nr_free_pages>:
ffffffffc0201c60:	100027f3          	csrr	a5,sstatus
ffffffffc0201c64:	8b89                	and	a5,a5,2
ffffffffc0201c66:	e799                	bnez	a5,ffffffffc0201c74 <nr_free_pages+0x14>
ffffffffc0201c68:	00016797          	auipc	a5,0x16
ffffffffc0201c6c:	9907b783          	ld	a5,-1648(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc0201c70:	779c                	ld	a5,40(a5)
ffffffffc0201c72:	8782                	jr	a5
ffffffffc0201c74:	1141                	add	sp,sp,-16
ffffffffc0201c76:	e406                	sd	ra,8(sp)
ffffffffc0201c78:	e022                	sd	s0,0(sp)
ffffffffc0201c7a:	9bbfe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201c7e:	00016797          	auipc	a5,0x16
ffffffffc0201c82:	97a7b783          	ld	a5,-1670(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc0201c86:	779c                	ld	a5,40(a5)
ffffffffc0201c88:	9782                	jalr	a5
ffffffffc0201c8a:	842a                	mv	s0,a0
ffffffffc0201c8c:	9a3fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201c90:	60a2                	ld	ra,8(sp)
ffffffffc0201c92:	8522                	mv	a0,s0
ffffffffc0201c94:	6402                	ld	s0,0(sp)
ffffffffc0201c96:	0141                	add	sp,sp,16
ffffffffc0201c98:	8082                	ret

ffffffffc0201c9a <pmm_init>:
ffffffffc0201c9a:	00005797          	auipc	a5,0x5
ffffffffc0201c9e:	9f678793          	add	a5,a5,-1546 # ffffffffc0206690 <default_pmm_manager>
ffffffffc0201ca2:	638c                	ld	a1,0(a5)
ffffffffc0201ca4:	1101                	add	sp,sp,-32
ffffffffc0201ca6:	ec06                	sd	ra,24(sp)
ffffffffc0201ca8:	e822                	sd	s0,16(sp)
ffffffffc0201caa:	e426                	sd	s1,8(sp)
ffffffffc0201cac:	00005517          	auipc	a0,0x5
ffffffffc0201cb0:	afc50513          	add	a0,a0,-1284 # ffffffffc02067a8 <default_pmm_manager+0x118>
ffffffffc0201cb4:	00016497          	auipc	s1,0x16
ffffffffc0201cb8:	94448493          	add	s1,s1,-1724 # ffffffffc02175f8 <pmm_manager>
ffffffffc0201cbc:	e09c                	sd	a5,0(s1)
ffffffffc0201cbe:	cccfe0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0201cc2:	609c                	ld	a5,0(s1)
ffffffffc0201cc4:	00016417          	auipc	s0,0x16
ffffffffc0201cc8:	94c40413          	add	s0,s0,-1716 # ffffffffc0217610 <va_pa_offset>
ffffffffc0201ccc:	679c                	ld	a5,8(a5)
ffffffffc0201cce:	9782                	jalr	a5
ffffffffc0201cd0:	57f5                	li	a5,-3
ffffffffc0201cd2:	07fa                	sll	a5,a5,0x1e
ffffffffc0201cd4:	00005517          	auipc	a0,0x5
ffffffffc0201cd8:	aec50513          	add	a0,a0,-1300 # ffffffffc02067c0 <default_pmm_manager+0x130>
ffffffffc0201cdc:	e01c                	sd	a5,0(s0)
ffffffffc0201cde:	cacfe0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0201ce2:	44300693          	li	a3,1091
ffffffffc0201ce6:	06d6                	sll	a3,a3,0x15
ffffffffc0201ce8:	40100613          	li	a2,1025
ffffffffc0201cec:	16fd                	add	a3,a3,-1
ffffffffc0201cee:	0656                	sll	a2,a2,0x15
ffffffffc0201cf0:	088005b7          	lui	a1,0x8800
ffffffffc0201cf4:	00005517          	auipc	a0,0x5
ffffffffc0201cf8:	ae450513          	add	a0,a0,-1308 # ffffffffc02067d8 <default_pmm_manager+0x148>
ffffffffc0201cfc:	c8efe0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0201d00:	777d                	lui	a4,0xfffff
ffffffffc0201d02:	00017797          	auipc	a5,0x17
ffffffffc0201d06:	97d78793          	add	a5,a5,-1667 # ffffffffc021867f <end+0xfff>
ffffffffc0201d0a:	8ff9                	and	a5,a5,a4
ffffffffc0201d0c:	00088737          	lui	a4,0x88
ffffffffc0201d10:	00016597          	auipc	a1,0x16
ffffffffc0201d14:	90858593          	add	a1,a1,-1784 # ffffffffc0217618 <npage>
ffffffffc0201d18:	00016617          	auipc	a2,0x16
ffffffffc0201d1c:	90860613          	add	a2,a2,-1784 # ffffffffc0217620 <pages>
ffffffffc0201d20:	60070713          	add	a4,a4,1536 # 88600 <kern_entry-0xffffffffc0177a00>
ffffffffc0201d24:	e198                	sd	a4,0(a1)
ffffffffc0201d26:	e21c                	sd	a5,0(a2)
ffffffffc0201d28:	4705                	li	a4,1
ffffffffc0201d2a:	07a1                	add	a5,a5,8
ffffffffc0201d2c:	40e7b02f          	amoor.d	zero,a4,(a5)
ffffffffc0201d30:	4805                	li	a6,1
ffffffffc0201d32:	fff80537          	lui	a0,0xfff80
ffffffffc0201d36:	621c                	ld	a5,0(a2)
ffffffffc0201d38:	00671693          	sll	a3,a4,0x6
ffffffffc0201d3c:	97b6                	add	a5,a5,a3
ffffffffc0201d3e:	07a1                	add	a5,a5,8
ffffffffc0201d40:	4107b02f          	amoor.d	zero,a6,(a5)
ffffffffc0201d44:	619c                	ld	a5,0(a1)
ffffffffc0201d46:	0705                	add	a4,a4,1
ffffffffc0201d48:	00a786b3          	add	a3,a5,a0
ffffffffc0201d4c:	fed765e3          	bltu	a4,a3,ffffffffc0201d36 <pmm_init+0x9c>
ffffffffc0201d50:	6218                	ld	a4,0(a2)
ffffffffc0201d52:	069a                	sll	a3,a3,0x6
ffffffffc0201d54:	c0200637          	lui	a2,0xc0200
ffffffffc0201d58:	96ba                	add	a3,a3,a4
ffffffffc0201d5a:	06c6e763          	bltu	a3,a2,ffffffffc0201dc8 <pmm_init+0x12e>
ffffffffc0201d5e:	6010                	ld	a2,0(s0)
ffffffffc0201d60:	44300593          	li	a1,1091
ffffffffc0201d64:	05d6                	sll	a1,a1,0x15
ffffffffc0201d66:	8e91                	sub	a3,a3,a2
ffffffffc0201d68:	02b6e963          	bltu	a3,a1,ffffffffc0201d9a <pmm_init+0x100>
ffffffffc0201d6c:	00009697          	auipc	a3,0x9
ffffffffc0201d70:	29468693          	add	a3,a3,660 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc0201d74:	00016797          	auipc	a5,0x16
ffffffffc0201d78:	88d7ba23          	sd	a3,-1900(a5) # ffffffffc0217608 <boot_pgdir>
ffffffffc0201d7c:	c02007b7          	lui	a5,0xc0200
ffffffffc0201d80:	06f6e063          	bltu	a3,a5,ffffffffc0201de0 <pmm_init+0x146>
ffffffffc0201d84:	601c                	ld	a5,0(s0)
ffffffffc0201d86:	60e2                	ld	ra,24(sp)
ffffffffc0201d88:	6442                	ld	s0,16(sp)
ffffffffc0201d8a:	8e9d                	sub	a3,a3,a5
ffffffffc0201d8c:	00016797          	auipc	a5,0x16
ffffffffc0201d90:	86d7ba23          	sd	a3,-1932(a5) # ffffffffc0217600 <boot_cr3>
ffffffffc0201d94:	64a2                	ld	s1,8(sp)
ffffffffc0201d96:	6105                	add	sp,sp,32
ffffffffc0201d98:	8082                	ret
ffffffffc0201d9a:	6605                	lui	a2,0x1
ffffffffc0201d9c:	167d                	add	a2,a2,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0201d9e:	96b2                	add	a3,a3,a2
ffffffffc0201da0:	767d                	lui	a2,0xfffff
ffffffffc0201da2:	8ef1                	and	a3,a3,a2
ffffffffc0201da4:	00c6d613          	srl	a2,a3,0xc
ffffffffc0201da8:	00f67e63          	bgeu	a2,a5,ffffffffc0201dc4 <pmm_init+0x12a>
ffffffffc0201dac:	609c                	ld	a5,0(s1)
ffffffffc0201dae:	fff80537          	lui	a0,0xfff80
ffffffffc0201db2:	962a                	add	a2,a2,a0
ffffffffc0201db4:	6b9c                	ld	a5,16(a5)
ffffffffc0201db6:	8d95                	sub	a1,a1,a3
ffffffffc0201db8:	00661513          	sll	a0,a2,0x6
ffffffffc0201dbc:	81b1                	srl	a1,a1,0xc
ffffffffc0201dbe:	953a                	add	a0,a0,a4
ffffffffc0201dc0:	9782                	jalr	a5
ffffffffc0201dc2:	b76d                	j	ffffffffc0201d6c <pmm_init+0xd2>
ffffffffc0201dc4:	db1ff0ef          	jal	ffffffffc0201b74 <pa2page.part.0>
ffffffffc0201dc8:	00005617          	auipc	a2,0x5
ffffffffc0201dcc:	97060613          	add	a2,a2,-1680 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc0201dd0:	07f00593          	li	a1,127
ffffffffc0201dd4:	00005517          	auipc	a0,0x5
ffffffffc0201dd8:	a2c50513          	add	a0,a0,-1492 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0201ddc:	e96fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201de0:	00005617          	auipc	a2,0x5
ffffffffc0201de4:	95860613          	add	a2,a2,-1704 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc0201de8:	0c100593          	li	a1,193
ffffffffc0201dec:	00005517          	auipc	a0,0x5
ffffffffc0201df0:	a1450513          	add	a0,a0,-1516 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0201df4:	e7efe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201df8 <get_pte>:
ffffffffc0201df8:	01e5d793          	srl	a5,a1,0x1e
ffffffffc0201dfc:	1ff7f793          	and	a5,a5,511
ffffffffc0201e00:	7139                	add	sp,sp,-64
ffffffffc0201e02:	078e                	sll	a5,a5,0x3
ffffffffc0201e04:	f426                	sd	s1,40(sp)
ffffffffc0201e06:	00f504b3          	add	s1,a0,a5
ffffffffc0201e0a:	6094                	ld	a3,0(s1)
ffffffffc0201e0c:	f04a                	sd	s2,32(sp)
ffffffffc0201e0e:	ec4e                	sd	s3,24(sp)
ffffffffc0201e10:	e852                	sd	s4,16(sp)
ffffffffc0201e12:	fc06                	sd	ra,56(sp)
ffffffffc0201e14:	f822                	sd	s0,48(sp)
ffffffffc0201e16:	e456                	sd	s5,8(sp)
ffffffffc0201e18:	e05a                	sd	s6,0(sp)
ffffffffc0201e1a:	0016f793          	and	a5,a3,1
ffffffffc0201e1e:	892e                	mv	s2,a1
ffffffffc0201e20:	89b2                	mv	s3,a2
ffffffffc0201e22:	00015a17          	auipc	s4,0x15
ffffffffc0201e26:	7f6a0a13          	add	s4,s4,2038 # ffffffffc0217618 <npage>
ffffffffc0201e2a:	e7b5                	bnez	a5,ffffffffc0201e96 <get_pte+0x9e>
ffffffffc0201e2c:	12060b63          	beqz	a2,ffffffffc0201f62 <get_pte+0x16a>
ffffffffc0201e30:	4505                	li	a0,1
ffffffffc0201e32:	d5fff0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0201e36:	842a                	mv	s0,a0
ffffffffc0201e38:	12050563          	beqz	a0,ffffffffc0201f62 <get_pte+0x16a>
ffffffffc0201e3c:	00015b17          	auipc	s6,0x15
ffffffffc0201e40:	7e4b0b13          	add	s6,s6,2020 # ffffffffc0217620 <pages>
ffffffffc0201e44:	000b3503          	ld	a0,0(s6)
ffffffffc0201e48:	00080ab7          	lui	s5,0x80
ffffffffc0201e4c:	00015a17          	auipc	s4,0x15
ffffffffc0201e50:	7cca0a13          	add	s4,s4,1996 # ffffffffc0217618 <npage>
ffffffffc0201e54:	40a40533          	sub	a0,s0,a0
ffffffffc0201e58:	8519                	sra	a0,a0,0x6
ffffffffc0201e5a:	9556                	add	a0,a0,s5
ffffffffc0201e5c:	000a3703          	ld	a4,0(s4)
ffffffffc0201e60:	00c51793          	sll	a5,a0,0xc
ffffffffc0201e64:	4685                	li	a3,1
ffffffffc0201e66:	c014                	sw	a3,0(s0)
ffffffffc0201e68:	83b1                	srl	a5,a5,0xc
ffffffffc0201e6a:	0532                	sll	a0,a0,0xc
ffffffffc0201e6c:	14e7f163          	bgeu	a5,a4,ffffffffc0201fae <get_pte+0x1b6>
ffffffffc0201e70:	00015797          	auipc	a5,0x15
ffffffffc0201e74:	7a07b783          	ld	a5,1952(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc0201e78:	953e                	add	a0,a0,a5
ffffffffc0201e7a:	6605                	lui	a2,0x1
ffffffffc0201e7c:	4581                	li	a1,0
ffffffffc0201e7e:	2a1030ef          	jal	ffffffffc020591e <memset>
ffffffffc0201e82:	000b3783          	ld	a5,0(s6)
ffffffffc0201e86:	40f406b3          	sub	a3,s0,a5
ffffffffc0201e8a:	8699                	sra	a3,a3,0x6
ffffffffc0201e8c:	96d6                	add	a3,a3,s5
ffffffffc0201e8e:	06aa                	sll	a3,a3,0xa
ffffffffc0201e90:	0116e693          	or	a3,a3,17
ffffffffc0201e94:	e094                	sd	a3,0(s1)
ffffffffc0201e96:	77fd                	lui	a5,0xfffff
ffffffffc0201e98:	068a                	sll	a3,a3,0x2
ffffffffc0201e9a:	000a3703          	ld	a4,0(s4)
ffffffffc0201e9e:	8efd                	and	a3,a3,a5
ffffffffc0201ea0:	00c6d793          	srl	a5,a3,0xc
ffffffffc0201ea4:	0ce7f163          	bgeu	a5,a4,ffffffffc0201f66 <get_pte+0x16e>
ffffffffc0201ea8:	00015a97          	auipc	s5,0x15
ffffffffc0201eac:	768a8a93          	add	s5,s5,1896 # ffffffffc0217610 <va_pa_offset>
ffffffffc0201eb0:	000ab603          	ld	a2,0(s5)
ffffffffc0201eb4:	01595793          	srl	a5,s2,0x15
ffffffffc0201eb8:	1ff7f793          	and	a5,a5,511
ffffffffc0201ebc:	96b2                	add	a3,a3,a2
ffffffffc0201ebe:	078e                	sll	a5,a5,0x3
ffffffffc0201ec0:	00f68433          	add	s0,a3,a5
ffffffffc0201ec4:	6014                	ld	a3,0(s0)
ffffffffc0201ec6:	0016f793          	and	a5,a3,1
ffffffffc0201eca:	e3ad                	bnez	a5,ffffffffc0201f2c <get_pte+0x134>
ffffffffc0201ecc:	08098b63          	beqz	s3,ffffffffc0201f62 <get_pte+0x16a>
ffffffffc0201ed0:	4505                	li	a0,1
ffffffffc0201ed2:	cbfff0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0201ed6:	84aa                	mv	s1,a0
ffffffffc0201ed8:	c549                	beqz	a0,ffffffffc0201f62 <get_pte+0x16a>
ffffffffc0201eda:	00015b17          	auipc	s6,0x15
ffffffffc0201ede:	746b0b13          	add	s6,s6,1862 # ffffffffc0217620 <pages>
ffffffffc0201ee2:	000b3683          	ld	a3,0(s6)
ffffffffc0201ee6:	000809b7          	lui	s3,0x80
ffffffffc0201eea:	000a3703          	ld	a4,0(s4)
ffffffffc0201eee:	40d506b3          	sub	a3,a0,a3
ffffffffc0201ef2:	8699                	sra	a3,a3,0x6
ffffffffc0201ef4:	96ce                	add	a3,a3,s3
ffffffffc0201ef6:	00c69793          	sll	a5,a3,0xc
ffffffffc0201efa:	4605                	li	a2,1
ffffffffc0201efc:	c110                	sw	a2,0(a0)
ffffffffc0201efe:	83b1                	srl	a5,a5,0xc
ffffffffc0201f00:	06b2                	sll	a3,a3,0xc
ffffffffc0201f02:	08e7fa63          	bgeu	a5,a4,ffffffffc0201f96 <get_pte+0x19e>
ffffffffc0201f06:	000ab503          	ld	a0,0(s5)
ffffffffc0201f0a:	6605                	lui	a2,0x1
ffffffffc0201f0c:	4581                	li	a1,0
ffffffffc0201f0e:	9536                	add	a0,a0,a3
ffffffffc0201f10:	20f030ef          	jal	ffffffffc020591e <memset>
ffffffffc0201f14:	000b3783          	ld	a5,0(s6)
ffffffffc0201f18:	40f486b3          	sub	a3,s1,a5
ffffffffc0201f1c:	8699                	sra	a3,a3,0x6
ffffffffc0201f1e:	96ce                	add	a3,a3,s3
ffffffffc0201f20:	06aa                	sll	a3,a3,0xa
ffffffffc0201f22:	0116e693          	or	a3,a3,17
ffffffffc0201f26:	e014                	sd	a3,0(s0)
ffffffffc0201f28:	000a3703          	ld	a4,0(s4)
ffffffffc0201f2c:	77fd                	lui	a5,0xfffff
ffffffffc0201f2e:	068a                	sll	a3,a3,0x2
ffffffffc0201f30:	8efd                	and	a3,a3,a5
ffffffffc0201f32:	00c6d793          	srl	a5,a3,0xc
ffffffffc0201f36:	04e7f463          	bgeu	a5,a4,ffffffffc0201f7e <get_pte+0x186>
ffffffffc0201f3a:	000ab783          	ld	a5,0(s5)
ffffffffc0201f3e:	00c95913          	srl	s2,s2,0xc
ffffffffc0201f42:	1ff97913          	and	s2,s2,511
ffffffffc0201f46:	96be                	add	a3,a3,a5
ffffffffc0201f48:	090e                	sll	s2,s2,0x3
ffffffffc0201f4a:	01268533          	add	a0,a3,s2
ffffffffc0201f4e:	70e2                	ld	ra,56(sp)
ffffffffc0201f50:	7442                	ld	s0,48(sp)
ffffffffc0201f52:	74a2                	ld	s1,40(sp)
ffffffffc0201f54:	7902                	ld	s2,32(sp)
ffffffffc0201f56:	69e2                	ld	s3,24(sp)
ffffffffc0201f58:	6a42                	ld	s4,16(sp)
ffffffffc0201f5a:	6aa2                	ld	s5,8(sp)
ffffffffc0201f5c:	6b02                	ld	s6,0(sp)
ffffffffc0201f5e:	6121                	add	sp,sp,64
ffffffffc0201f60:	8082                	ret
ffffffffc0201f62:	4501                	li	a0,0
ffffffffc0201f64:	b7ed                	j	ffffffffc0201f4e <get_pte+0x156>
ffffffffc0201f66:	00004617          	auipc	a2,0x4
ffffffffc0201f6a:	76260613          	add	a2,a2,1890 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0201f6e:	0fe00593          	li	a1,254
ffffffffc0201f72:	00005517          	auipc	a0,0x5
ffffffffc0201f76:	88e50513          	add	a0,a0,-1906 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0201f7a:	cf8fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201f7e:	00004617          	auipc	a2,0x4
ffffffffc0201f82:	74a60613          	add	a2,a2,1866 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0201f86:	10900593          	li	a1,265
ffffffffc0201f8a:	00005517          	auipc	a0,0x5
ffffffffc0201f8e:	87650513          	add	a0,a0,-1930 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0201f92:	ce0fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201f96:	00004617          	auipc	a2,0x4
ffffffffc0201f9a:	73260613          	add	a2,a2,1842 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0201f9e:	10600593          	li	a1,262
ffffffffc0201fa2:	00005517          	auipc	a0,0x5
ffffffffc0201fa6:	85e50513          	add	a0,a0,-1954 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0201faa:	cc8fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201fae:	86aa                	mv	a3,a0
ffffffffc0201fb0:	00004617          	auipc	a2,0x4
ffffffffc0201fb4:	71860613          	add	a2,a2,1816 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0201fb8:	0fa00593          	li	a1,250
ffffffffc0201fbc:	00005517          	auipc	a0,0x5
ffffffffc0201fc0:	84450513          	add	a0,a0,-1980 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0201fc4:	caefe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201fc8 <unmap_range>:
ffffffffc0201fc8:	715d                	add	sp,sp,-80
ffffffffc0201fca:	00c5e7b3          	or	a5,a1,a2
ffffffffc0201fce:	e486                	sd	ra,72(sp)
ffffffffc0201fd0:	e0a2                	sd	s0,64(sp)
ffffffffc0201fd2:	fc26                	sd	s1,56(sp)
ffffffffc0201fd4:	f84a                	sd	s2,48(sp)
ffffffffc0201fd6:	f44e                	sd	s3,40(sp)
ffffffffc0201fd8:	f052                	sd	s4,32(sp)
ffffffffc0201fda:	ec56                	sd	s5,24(sp)
ffffffffc0201fdc:	e85a                	sd	s6,16(sp)
ffffffffc0201fde:	17d2                	sll	a5,a5,0x34
ffffffffc0201fe0:	ebe9                	bnez	a5,ffffffffc02020b2 <unmap_range+0xea>
ffffffffc0201fe2:	002007b7          	lui	a5,0x200
ffffffffc0201fe6:	842e                	mv	s0,a1
ffffffffc0201fe8:	0ef5e563          	bltu	a1,a5,ffffffffc02020d2 <unmap_range+0x10a>
ffffffffc0201fec:	8932                	mv	s2,a2
ffffffffc0201fee:	0ec5f263          	bgeu	a1,a2,ffffffffc02020d2 <unmap_range+0x10a>
ffffffffc0201ff2:	4785                	li	a5,1
ffffffffc0201ff4:	07fe                	sll	a5,a5,0x1f
ffffffffc0201ff6:	0cc7ee63          	bltu	a5,a2,ffffffffc02020d2 <unmap_range+0x10a>
ffffffffc0201ffa:	89aa                	mv	s3,a0
ffffffffc0201ffc:	6a05                	lui	s4,0x1
ffffffffc0201ffe:	00200b37          	lui	s6,0x200
ffffffffc0202002:	ffe00ab7          	lui	s5,0xffe00
ffffffffc0202006:	4601                	li	a2,0
ffffffffc0202008:	85a2                	mv	a1,s0
ffffffffc020200a:	854e                	mv	a0,s3
ffffffffc020200c:	dedff0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc0202010:	84aa                	mv	s1,a0
ffffffffc0202012:	cd39                	beqz	a0,ffffffffc0202070 <unmap_range+0xa8>
ffffffffc0202014:	611c                	ld	a5,0(a0)
ffffffffc0202016:	ef91                	bnez	a5,ffffffffc0202032 <unmap_range+0x6a>
ffffffffc0202018:	9452                	add	s0,s0,s4
ffffffffc020201a:	ff2466e3          	bltu	s0,s2,ffffffffc0202006 <unmap_range+0x3e>
ffffffffc020201e:	60a6                	ld	ra,72(sp)
ffffffffc0202020:	6406                	ld	s0,64(sp)
ffffffffc0202022:	74e2                	ld	s1,56(sp)
ffffffffc0202024:	7942                	ld	s2,48(sp)
ffffffffc0202026:	79a2                	ld	s3,40(sp)
ffffffffc0202028:	7a02                	ld	s4,32(sp)
ffffffffc020202a:	6ae2                	ld	s5,24(sp)
ffffffffc020202c:	6b42                	ld	s6,16(sp)
ffffffffc020202e:	6161                	add	sp,sp,80
ffffffffc0202030:	8082                	ret
ffffffffc0202032:	0017f713          	and	a4,a5,1
ffffffffc0202036:	d36d                	beqz	a4,ffffffffc0202018 <unmap_range+0x50>
ffffffffc0202038:	078a                	sll	a5,a5,0x2
ffffffffc020203a:	83b1                	srl	a5,a5,0xc
ffffffffc020203c:	00015717          	auipc	a4,0x15
ffffffffc0202040:	5dc73703          	ld	a4,1500(a4) # ffffffffc0217618 <npage>
ffffffffc0202044:	0ae7f763          	bgeu	a5,a4,ffffffffc02020f2 <unmap_range+0x12a>
ffffffffc0202048:	fff80737          	lui	a4,0xfff80
ffffffffc020204c:	97ba                	add	a5,a5,a4
ffffffffc020204e:	079a                	sll	a5,a5,0x6
ffffffffc0202050:	00015517          	auipc	a0,0x15
ffffffffc0202054:	5d053503          	ld	a0,1488(a0) # ffffffffc0217620 <pages>
ffffffffc0202058:	953e                	add	a0,a0,a5
ffffffffc020205a:	411c                	lw	a5,0(a0)
ffffffffc020205c:	fff7871b          	addw	a4,a5,-1 # 1fffff <kern_entry-0xffffffffc0000001>
ffffffffc0202060:	c118                	sw	a4,0(a0)
ffffffffc0202062:	cf11                	beqz	a4,ffffffffc020207e <unmap_range+0xb6>
ffffffffc0202064:	0004b023          	sd	zero,0(s1)
ffffffffc0202068:	12040073          	sfence.vma	s0
ffffffffc020206c:	9452                	add	s0,s0,s4
ffffffffc020206e:	b775                	j	ffffffffc020201a <unmap_range+0x52>
ffffffffc0202070:	945a                	add	s0,s0,s6
ffffffffc0202072:	01547433          	and	s0,s0,s5
ffffffffc0202076:	d445                	beqz	s0,ffffffffc020201e <unmap_range+0x56>
ffffffffc0202078:	f92467e3          	bltu	s0,s2,ffffffffc0202006 <unmap_range+0x3e>
ffffffffc020207c:	b74d                	j	ffffffffc020201e <unmap_range+0x56>
ffffffffc020207e:	100027f3          	csrr	a5,sstatus
ffffffffc0202082:	8b89                	and	a5,a5,2
ffffffffc0202084:	eb89                	bnez	a5,ffffffffc0202096 <unmap_range+0xce>
ffffffffc0202086:	00015797          	auipc	a5,0x15
ffffffffc020208a:	5727b783          	ld	a5,1394(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc020208e:	739c                	ld	a5,32(a5)
ffffffffc0202090:	4585                	li	a1,1
ffffffffc0202092:	9782                	jalr	a5
ffffffffc0202094:	bfc1                	j	ffffffffc0202064 <unmap_range+0x9c>
ffffffffc0202096:	e42a                	sd	a0,8(sp)
ffffffffc0202098:	d9cfe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020209c:	00015797          	auipc	a5,0x15
ffffffffc02020a0:	55c7b783          	ld	a5,1372(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc02020a4:	739c                	ld	a5,32(a5)
ffffffffc02020a6:	6522                	ld	a0,8(sp)
ffffffffc02020a8:	4585                	li	a1,1
ffffffffc02020aa:	9782                	jalr	a5
ffffffffc02020ac:	d82fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02020b0:	bf55                	j	ffffffffc0202064 <unmap_range+0x9c>
ffffffffc02020b2:	00004697          	auipc	a3,0x4
ffffffffc02020b6:	75e68693          	add	a3,a3,1886 # ffffffffc0206810 <default_pmm_manager+0x180>
ffffffffc02020ba:	00004617          	auipc	a2,0x4
ffffffffc02020be:	f3e60613          	add	a2,a2,-194 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02020c2:	14000593          	li	a1,320
ffffffffc02020c6:	00004517          	auipc	a0,0x4
ffffffffc02020ca:	73a50513          	add	a0,a0,1850 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc02020ce:	ba4fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02020d2:	00004697          	auipc	a3,0x4
ffffffffc02020d6:	76e68693          	add	a3,a3,1902 # ffffffffc0206840 <default_pmm_manager+0x1b0>
ffffffffc02020da:	00004617          	auipc	a2,0x4
ffffffffc02020de:	f1e60613          	add	a2,a2,-226 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02020e2:	14100593          	li	a1,321
ffffffffc02020e6:	00004517          	auipc	a0,0x4
ffffffffc02020ea:	71a50513          	add	a0,a0,1818 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc02020ee:	b84fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02020f2:	a83ff0ef          	jal	ffffffffc0201b74 <pa2page.part.0>

ffffffffc02020f6 <exit_range>:
ffffffffc02020f6:	711d                	add	sp,sp,-96
ffffffffc02020f8:	00c5e7b3          	or	a5,a1,a2
ffffffffc02020fc:	ec86                	sd	ra,88(sp)
ffffffffc02020fe:	e8a2                	sd	s0,80(sp)
ffffffffc0202100:	e4a6                	sd	s1,72(sp)
ffffffffc0202102:	e0ca                	sd	s2,64(sp)
ffffffffc0202104:	fc4e                	sd	s3,56(sp)
ffffffffc0202106:	f852                	sd	s4,48(sp)
ffffffffc0202108:	f456                	sd	s5,40(sp)
ffffffffc020210a:	f05a                	sd	s6,32(sp)
ffffffffc020210c:	ec5e                	sd	s7,24(sp)
ffffffffc020210e:	e862                	sd	s8,16(sp)
ffffffffc0202110:	17d2                	sll	a5,a5,0x34
ffffffffc0202112:	e3f1                	bnez	a5,ffffffffc02021d6 <exit_range+0xe0>
ffffffffc0202114:	002007b7          	lui	a5,0x200
ffffffffc0202118:	0ef5eb63          	bltu	a1,a5,ffffffffc020220e <exit_range+0x118>
ffffffffc020211c:	8ab2                	mv	s5,a2
ffffffffc020211e:	0ec5f863          	bgeu	a1,a2,ffffffffc020220e <exit_range+0x118>
ffffffffc0202122:	4785                	li	a5,1
ffffffffc0202124:	ffe00737          	lui	a4,0xffe00
ffffffffc0202128:	07fe                	sll	a5,a5,0x1f
ffffffffc020212a:	00e5f4b3          	and	s1,a1,a4
ffffffffc020212e:	0ec7e063          	bltu	a5,a2,ffffffffc020220e <exit_range+0x118>
ffffffffc0202132:	8b2a                	mv	s6,a0
ffffffffc0202134:	00015b97          	auipc	s7,0x15
ffffffffc0202138:	4e4b8b93          	add	s7,s7,1252 # ffffffffc0217618 <npage>
ffffffffc020213c:	00015c17          	auipc	s8,0x15
ffffffffc0202140:	4e4c0c13          	add	s8,s8,1252 # ffffffffc0217620 <pages>
ffffffffc0202144:	fff809b7          	lui	s3,0xfff80
ffffffffc0202148:	00015917          	auipc	s2,0x15
ffffffffc020214c:	4b090913          	add	s2,s2,1200 # ffffffffc02175f8 <pmm_manager>
ffffffffc0202150:	00200a37          	lui	s4,0x200
ffffffffc0202154:	a029                	j	ffffffffc020215e <exit_range+0x68>
ffffffffc0202156:	94d2                	add	s1,s1,s4
ffffffffc0202158:	c4a9                	beqz	s1,ffffffffc02021a2 <exit_range+0xac>
ffffffffc020215a:	0554f463          	bgeu	s1,s5,ffffffffc02021a2 <exit_range+0xac>
ffffffffc020215e:	01e4d413          	srl	s0,s1,0x1e
ffffffffc0202162:	1ff47413          	and	s0,s0,511
ffffffffc0202166:	040e                	sll	s0,s0,0x3
ffffffffc0202168:	945a                	add	s0,s0,s6
ffffffffc020216a:	601c                	ld	a5,0(s0)
ffffffffc020216c:	0017f713          	and	a4,a5,1
ffffffffc0202170:	d37d                	beqz	a4,ffffffffc0202156 <exit_range+0x60>
ffffffffc0202172:	000bb703          	ld	a4,0(s7)
ffffffffc0202176:	078a                	sll	a5,a5,0x2
ffffffffc0202178:	83b1                	srl	a5,a5,0xc
ffffffffc020217a:	06e7fe63          	bgeu	a5,a4,ffffffffc02021f6 <exit_range+0x100>
ffffffffc020217e:	000c3503          	ld	a0,0(s8)
ffffffffc0202182:	97ce                	add	a5,a5,s3
ffffffffc0202184:	079a                	sll	a5,a5,0x6
ffffffffc0202186:	953e                	add	a0,a0,a5
ffffffffc0202188:	100027f3          	csrr	a5,sstatus
ffffffffc020218c:	8b89                	and	a5,a5,2
ffffffffc020218e:	e795                	bnez	a5,ffffffffc02021ba <exit_range+0xc4>
ffffffffc0202190:	00093783          	ld	a5,0(s2)
ffffffffc0202194:	4585                	li	a1,1
ffffffffc0202196:	739c                	ld	a5,32(a5)
ffffffffc0202198:	9782                	jalr	a5
ffffffffc020219a:	00043023          	sd	zero,0(s0)
ffffffffc020219e:	94d2                	add	s1,s1,s4
ffffffffc02021a0:	fccd                	bnez	s1,ffffffffc020215a <exit_range+0x64>
ffffffffc02021a2:	60e6                	ld	ra,88(sp)
ffffffffc02021a4:	6446                	ld	s0,80(sp)
ffffffffc02021a6:	64a6                	ld	s1,72(sp)
ffffffffc02021a8:	6906                	ld	s2,64(sp)
ffffffffc02021aa:	79e2                	ld	s3,56(sp)
ffffffffc02021ac:	7a42                	ld	s4,48(sp)
ffffffffc02021ae:	7aa2                	ld	s5,40(sp)
ffffffffc02021b0:	7b02                	ld	s6,32(sp)
ffffffffc02021b2:	6be2                	ld	s7,24(sp)
ffffffffc02021b4:	6c42                	ld	s8,16(sp)
ffffffffc02021b6:	6125                	add	sp,sp,96
ffffffffc02021b8:	8082                	ret
ffffffffc02021ba:	e42a                	sd	a0,8(sp)
ffffffffc02021bc:	c78fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02021c0:	00093783          	ld	a5,0(s2)
ffffffffc02021c4:	6522                	ld	a0,8(sp)
ffffffffc02021c6:	4585                	li	a1,1
ffffffffc02021c8:	739c                	ld	a5,32(a5)
ffffffffc02021ca:	9782                	jalr	a5
ffffffffc02021cc:	c62fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02021d0:	00043023          	sd	zero,0(s0)
ffffffffc02021d4:	b7e9                	j	ffffffffc020219e <exit_range+0xa8>
ffffffffc02021d6:	00004697          	auipc	a3,0x4
ffffffffc02021da:	63a68693          	add	a3,a3,1594 # ffffffffc0206810 <default_pmm_manager+0x180>
ffffffffc02021de:	00004617          	auipc	a2,0x4
ffffffffc02021e2:	e1a60613          	add	a2,a2,-486 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02021e6:	15100593          	li	a1,337
ffffffffc02021ea:	00004517          	auipc	a0,0x4
ffffffffc02021ee:	61650513          	add	a0,a0,1558 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc02021f2:	a80fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02021f6:	00004617          	auipc	a2,0x4
ffffffffc02021fa:	56a60613          	add	a2,a2,1386 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc02021fe:	06200593          	li	a1,98
ffffffffc0202202:	00004517          	auipc	a0,0x4
ffffffffc0202206:	4ee50513          	add	a0,a0,1262 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc020220a:	a68fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020220e:	00004697          	auipc	a3,0x4
ffffffffc0202212:	63268693          	add	a3,a3,1586 # ffffffffc0206840 <default_pmm_manager+0x1b0>
ffffffffc0202216:	00004617          	auipc	a2,0x4
ffffffffc020221a:	de260613          	add	a2,a2,-542 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020221e:	15200593          	li	a1,338
ffffffffc0202222:	00004517          	auipc	a0,0x4
ffffffffc0202226:	5de50513          	add	a0,a0,1502 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc020222a:	a48fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020222e <page_insert>:
ffffffffc020222e:	7139                	add	sp,sp,-64
ffffffffc0202230:	e852                	sd	s4,16(sp)
ffffffffc0202232:	8a32                	mv	s4,a2
ffffffffc0202234:	f822                	sd	s0,48(sp)
ffffffffc0202236:	4605                	li	a2,1
ffffffffc0202238:	842e                	mv	s0,a1
ffffffffc020223a:	85d2                	mv	a1,s4
ffffffffc020223c:	f426                	sd	s1,40(sp)
ffffffffc020223e:	fc06                	sd	ra,56(sp)
ffffffffc0202240:	f04a                	sd	s2,32(sp)
ffffffffc0202242:	ec4e                	sd	s3,24(sp)
ffffffffc0202244:	e456                	sd	s5,8(sp)
ffffffffc0202246:	84b6                	mv	s1,a3
ffffffffc0202248:	bb1ff0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc020224c:	c969                	beqz	a0,ffffffffc020231e <page_insert+0xf0>
ffffffffc020224e:	4014                	lw	a3,0(s0)
ffffffffc0202250:	611c                	ld	a5,0(a0)
ffffffffc0202252:	89aa                	mv	s3,a0
ffffffffc0202254:	0016871b          	addw	a4,a3,1
ffffffffc0202258:	c018                	sw	a4,0(s0)
ffffffffc020225a:	0017f713          	and	a4,a5,1
ffffffffc020225e:	ef05                	bnez	a4,ffffffffc0202296 <page_insert+0x68>
ffffffffc0202260:	00015717          	auipc	a4,0x15
ffffffffc0202264:	3c073703          	ld	a4,960(a4) # ffffffffc0217620 <pages>
ffffffffc0202268:	8c19                	sub	s0,s0,a4
ffffffffc020226a:	000807b7          	lui	a5,0x80
ffffffffc020226e:	8419                	sra	s0,s0,0x6
ffffffffc0202270:	943e                	add	s0,s0,a5
ffffffffc0202272:	042a                	sll	s0,s0,0xa
ffffffffc0202274:	8cc1                	or	s1,s1,s0
ffffffffc0202276:	0014e493          	or	s1,s1,1
ffffffffc020227a:	0099b023          	sd	s1,0(s3) # fffffffffff80000 <end+0x3fd68980>
ffffffffc020227e:	120a0073          	sfence.vma	s4
ffffffffc0202282:	4501                	li	a0,0
ffffffffc0202284:	70e2                	ld	ra,56(sp)
ffffffffc0202286:	7442                	ld	s0,48(sp)
ffffffffc0202288:	74a2                	ld	s1,40(sp)
ffffffffc020228a:	7902                	ld	s2,32(sp)
ffffffffc020228c:	69e2                	ld	s3,24(sp)
ffffffffc020228e:	6a42                	ld	s4,16(sp)
ffffffffc0202290:	6aa2                	ld	s5,8(sp)
ffffffffc0202292:	6121                	add	sp,sp,64
ffffffffc0202294:	8082                	ret
ffffffffc0202296:	078a                	sll	a5,a5,0x2
ffffffffc0202298:	83b1                	srl	a5,a5,0xc
ffffffffc020229a:	00015717          	auipc	a4,0x15
ffffffffc020229e:	37e73703          	ld	a4,894(a4) # ffffffffc0217618 <npage>
ffffffffc02022a2:	08e7f063          	bgeu	a5,a4,ffffffffc0202322 <page_insert+0xf4>
ffffffffc02022a6:	00015a97          	auipc	s5,0x15
ffffffffc02022aa:	37aa8a93          	add	s5,s5,890 # ffffffffc0217620 <pages>
ffffffffc02022ae:	000ab703          	ld	a4,0(s5)
ffffffffc02022b2:	fff80637          	lui	a2,0xfff80
ffffffffc02022b6:	00c78933          	add	s2,a5,a2
ffffffffc02022ba:	091a                	sll	s2,s2,0x6
ffffffffc02022bc:	993a                	add	s2,s2,a4
ffffffffc02022be:	01240c63          	beq	s0,s2,ffffffffc02022d6 <page_insert+0xa8>
ffffffffc02022c2:	00092783          	lw	a5,0(s2)
ffffffffc02022c6:	fff7869b          	addw	a3,a5,-1 # 7ffff <kern_entry-0xffffffffc0180001>
ffffffffc02022ca:	00d92023          	sw	a3,0(s2)
ffffffffc02022ce:	c691                	beqz	a3,ffffffffc02022da <page_insert+0xac>
ffffffffc02022d0:	120a0073          	sfence.vma	s4
ffffffffc02022d4:	bf51                	j	ffffffffc0202268 <page_insert+0x3a>
ffffffffc02022d6:	c014                	sw	a3,0(s0)
ffffffffc02022d8:	bf41                	j	ffffffffc0202268 <page_insert+0x3a>
ffffffffc02022da:	100027f3          	csrr	a5,sstatus
ffffffffc02022de:	8b89                	and	a5,a5,2
ffffffffc02022e0:	ef91                	bnez	a5,ffffffffc02022fc <page_insert+0xce>
ffffffffc02022e2:	00015797          	auipc	a5,0x15
ffffffffc02022e6:	3167b783          	ld	a5,790(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc02022ea:	739c                	ld	a5,32(a5)
ffffffffc02022ec:	4585                	li	a1,1
ffffffffc02022ee:	854a                	mv	a0,s2
ffffffffc02022f0:	9782                	jalr	a5
ffffffffc02022f2:	000ab703          	ld	a4,0(s5)
ffffffffc02022f6:	120a0073          	sfence.vma	s4
ffffffffc02022fa:	b7bd                	j	ffffffffc0202268 <page_insert+0x3a>
ffffffffc02022fc:	b38fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0202300:	00015797          	auipc	a5,0x15
ffffffffc0202304:	2f87b783          	ld	a5,760(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc0202308:	739c                	ld	a5,32(a5)
ffffffffc020230a:	4585                	li	a1,1
ffffffffc020230c:	854a                	mv	a0,s2
ffffffffc020230e:	9782                	jalr	a5
ffffffffc0202310:	b1efe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0202314:	000ab703          	ld	a4,0(s5)
ffffffffc0202318:	120a0073          	sfence.vma	s4
ffffffffc020231c:	b7b1                	j	ffffffffc0202268 <page_insert+0x3a>
ffffffffc020231e:	5571                	li	a0,-4
ffffffffc0202320:	b795                	j	ffffffffc0202284 <page_insert+0x56>
ffffffffc0202322:	853ff0ef          	jal	ffffffffc0201b74 <pa2page.part.0>

ffffffffc0202326 <copy_range>:
ffffffffc0202326:	7159                	add	sp,sp,-112
ffffffffc0202328:	00d667b3          	or	a5,a2,a3
ffffffffc020232c:	f486                	sd	ra,104(sp)
ffffffffc020232e:	f0a2                	sd	s0,96(sp)
ffffffffc0202330:	eca6                	sd	s1,88(sp)
ffffffffc0202332:	e8ca                	sd	s2,80(sp)
ffffffffc0202334:	e4ce                	sd	s3,72(sp)
ffffffffc0202336:	e0d2                	sd	s4,64(sp)
ffffffffc0202338:	fc56                	sd	s5,56(sp)
ffffffffc020233a:	f85a                	sd	s6,48(sp)
ffffffffc020233c:	f45e                	sd	s7,40(sp)
ffffffffc020233e:	f062                	sd	s8,32(sp)
ffffffffc0202340:	ec66                	sd	s9,24(sp)
ffffffffc0202342:	e86a                	sd	s10,16(sp)
ffffffffc0202344:	e46e                	sd	s11,8(sp)
ffffffffc0202346:	17d2                	sll	a5,a5,0x34
ffffffffc0202348:	1e079763          	bnez	a5,ffffffffc0202536 <copy_range+0x210>
ffffffffc020234c:	002007b7          	lui	a5,0x200
ffffffffc0202350:	8432                	mv	s0,a2
ffffffffc0202352:	16f66a63          	bltu	a2,a5,ffffffffc02024c6 <copy_range+0x1a0>
ffffffffc0202356:	8936                	mv	s2,a3
ffffffffc0202358:	16d67763          	bgeu	a2,a3,ffffffffc02024c6 <copy_range+0x1a0>
ffffffffc020235c:	4785                	li	a5,1
ffffffffc020235e:	07fe                	sll	a5,a5,0x1f
ffffffffc0202360:	16d7e363          	bltu	a5,a3,ffffffffc02024c6 <copy_range+0x1a0>
ffffffffc0202364:	5b7d                	li	s6,-1
ffffffffc0202366:	8aaa                	mv	s5,a0
ffffffffc0202368:	89ae                	mv	s3,a1
ffffffffc020236a:	6a05                	lui	s4,0x1
ffffffffc020236c:	00015c97          	auipc	s9,0x15
ffffffffc0202370:	2acc8c93          	add	s9,s9,684 # ffffffffc0217618 <npage>
ffffffffc0202374:	00015c17          	auipc	s8,0x15
ffffffffc0202378:	2acc0c13          	add	s8,s8,684 # ffffffffc0217620 <pages>
ffffffffc020237c:	00080bb7          	lui	s7,0x80
ffffffffc0202380:	00cb5b13          	srl	s6,s6,0xc
ffffffffc0202384:	4601                	li	a2,0
ffffffffc0202386:	85a2                	mv	a1,s0
ffffffffc0202388:	854e                	mv	a0,s3
ffffffffc020238a:	a6fff0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc020238e:	84aa                	mv	s1,a0
ffffffffc0202390:	c175                	beqz	a0,ffffffffc0202474 <copy_range+0x14e>
ffffffffc0202392:	611c                	ld	a5,0(a0)
ffffffffc0202394:	8b85                	and	a5,a5,1
ffffffffc0202396:	e785                	bnez	a5,ffffffffc02023be <copy_range+0x98>
ffffffffc0202398:	9452                	add	s0,s0,s4
ffffffffc020239a:	ff2465e3          	bltu	s0,s2,ffffffffc0202384 <copy_range+0x5e>
ffffffffc020239e:	4501                	li	a0,0
ffffffffc02023a0:	70a6                	ld	ra,104(sp)
ffffffffc02023a2:	7406                	ld	s0,96(sp)
ffffffffc02023a4:	64e6                	ld	s1,88(sp)
ffffffffc02023a6:	6946                	ld	s2,80(sp)
ffffffffc02023a8:	69a6                	ld	s3,72(sp)
ffffffffc02023aa:	6a06                	ld	s4,64(sp)
ffffffffc02023ac:	7ae2                	ld	s5,56(sp)
ffffffffc02023ae:	7b42                	ld	s6,48(sp)
ffffffffc02023b0:	7ba2                	ld	s7,40(sp)
ffffffffc02023b2:	7c02                	ld	s8,32(sp)
ffffffffc02023b4:	6ce2                	ld	s9,24(sp)
ffffffffc02023b6:	6d42                	ld	s10,16(sp)
ffffffffc02023b8:	6da2                	ld	s11,8(sp)
ffffffffc02023ba:	6165                	add	sp,sp,112
ffffffffc02023bc:	8082                	ret
ffffffffc02023be:	4605                	li	a2,1
ffffffffc02023c0:	85a2                	mv	a1,s0
ffffffffc02023c2:	8556                	mv	a0,s5
ffffffffc02023c4:	a35ff0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc02023c8:	c161                	beqz	a0,ffffffffc0202488 <copy_range+0x162>
ffffffffc02023ca:	609c                	ld	a5,0(s1)
ffffffffc02023cc:	0017f713          	and	a4,a5,1
ffffffffc02023d0:	01f7f493          	and	s1,a5,31
ffffffffc02023d4:	14070563          	beqz	a4,ffffffffc020251e <copy_range+0x1f8>
ffffffffc02023d8:	000cb683          	ld	a3,0(s9)
ffffffffc02023dc:	078a                	sll	a5,a5,0x2
ffffffffc02023de:	00c7d713          	srl	a4,a5,0xc
ffffffffc02023e2:	12d77263          	bgeu	a4,a3,ffffffffc0202506 <copy_range+0x1e0>
ffffffffc02023e6:	000c3783          	ld	a5,0(s8)
ffffffffc02023ea:	fff806b7          	lui	a3,0xfff80
ffffffffc02023ee:	9736                	add	a4,a4,a3
ffffffffc02023f0:	071a                	sll	a4,a4,0x6
ffffffffc02023f2:	4505                	li	a0,1
ffffffffc02023f4:	00e78db3          	add	s11,a5,a4
ffffffffc02023f8:	f98ff0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc02023fc:	8d2a                	mv	s10,a0
ffffffffc02023fe:	0a0d8463          	beqz	s11,ffffffffc02024a6 <copy_range+0x180>
ffffffffc0202402:	c175                	beqz	a0,ffffffffc02024e6 <copy_range+0x1c0>
ffffffffc0202404:	000c3703          	ld	a4,0(s8)
ffffffffc0202408:	000cb603          	ld	a2,0(s9)
ffffffffc020240c:	40ed86b3          	sub	a3,s11,a4
ffffffffc0202410:	8699                	sra	a3,a3,0x6
ffffffffc0202412:	96de                	add	a3,a3,s7
ffffffffc0202414:	0166f7b3          	and	a5,a3,s6
ffffffffc0202418:	06b2                	sll	a3,a3,0xc
ffffffffc020241a:	06c7fa63          	bgeu	a5,a2,ffffffffc020248e <copy_range+0x168>
ffffffffc020241e:	40e507b3          	sub	a5,a0,a4
ffffffffc0202422:	00015717          	auipc	a4,0x15
ffffffffc0202426:	1ee70713          	add	a4,a4,494 # ffffffffc0217610 <va_pa_offset>
ffffffffc020242a:	6308                	ld	a0,0(a4)
ffffffffc020242c:	8799                	sra	a5,a5,0x6
ffffffffc020242e:	97de                	add	a5,a5,s7
ffffffffc0202430:	0167f733          	and	a4,a5,s6
ffffffffc0202434:	00a685b3          	add	a1,a3,a0
ffffffffc0202438:	07b2                	sll	a5,a5,0xc
ffffffffc020243a:	04c77963          	bgeu	a4,a2,ffffffffc020248c <copy_range+0x166>
ffffffffc020243e:	6605                	lui	a2,0x1
ffffffffc0202440:	953e                	add	a0,a0,a5
ffffffffc0202442:	4ee030ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc0202446:	86a6                	mv	a3,s1
ffffffffc0202448:	8622                	mv	a2,s0
ffffffffc020244a:	85ea                	mv	a1,s10
ffffffffc020244c:	8556                	mv	a0,s5
ffffffffc020244e:	de1ff0ef          	jal	ffffffffc020222e <page_insert>
ffffffffc0202452:	d139                	beqz	a0,ffffffffc0202398 <copy_range+0x72>
ffffffffc0202454:	00004697          	auipc	a3,0x4
ffffffffc0202458:	42468693          	add	a3,a3,1060 # ffffffffc0206878 <default_pmm_manager+0x1e8>
ffffffffc020245c:	00004617          	auipc	a2,0x4
ffffffffc0202460:	b9c60613          	add	a2,a2,-1124 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202464:	19900593          	li	a1,409
ffffffffc0202468:	00004517          	auipc	a0,0x4
ffffffffc020246c:	39850513          	add	a0,a0,920 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0202470:	802fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202474:	002007b7          	lui	a5,0x200
ffffffffc0202478:	97a2                	add	a5,a5,s0
ffffffffc020247a:	ffe00437          	lui	s0,0xffe00
ffffffffc020247e:	8c7d                	and	s0,s0,a5
ffffffffc0202480:	dc19                	beqz	s0,ffffffffc020239e <copy_range+0x78>
ffffffffc0202482:	f12461e3          	bltu	s0,s2,ffffffffc0202384 <copy_range+0x5e>
ffffffffc0202486:	bf21                	j	ffffffffc020239e <copy_range+0x78>
ffffffffc0202488:	5571                	li	a0,-4
ffffffffc020248a:	bf19                	j	ffffffffc02023a0 <copy_range+0x7a>
ffffffffc020248c:	86be                	mv	a3,a5
ffffffffc020248e:	00004617          	auipc	a2,0x4
ffffffffc0202492:	23a60613          	add	a2,a2,570 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0202496:	06900593          	li	a1,105
ffffffffc020249a:	00004517          	auipc	a0,0x4
ffffffffc020249e:	25650513          	add	a0,a0,598 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc02024a2:	fd1fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02024a6:	00004697          	auipc	a3,0x4
ffffffffc02024aa:	3b268693          	add	a3,a3,946 # ffffffffc0206858 <default_pmm_manager+0x1c8>
ffffffffc02024ae:	00004617          	auipc	a2,0x4
ffffffffc02024b2:	b4a60613          	add	a2,a2,-1206 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02024b6:	17e00593          	li	a1,382
ffffffffc02024ba:	00004517          	auipc	a0,0x4
ffffffffc02024be:	34650513          	add	a0,a0,838 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc02024c2:	fb1fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02024c6:	00004697          	auipc	a3,0x4
ffffffffc02024ca:	37a68693          	add	a3,a3,890 # ffffffffc0206840 <default_pmm_manager+0x1b0>
ffffffffc02024ce:	00004617          	auipc	a2,0x4
ffffffffc02024d2:	b2a60613          	add	a2,a2,-1238 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02024d6:	16a00593          	li	a1,362
ffffffffc02024da:	00004517          	auipc	a0,0x4
ffffffffc02024de:	32650513          	add	a0,a0,806 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc02024e2:	f91fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02024e6:	00004697          	auipc	a3,0x4
ffffffffc02024ea:	38268693          	add	a3,a3,898 # ffffffffc0206868 <default_pmm_manager+0x1d8>
ffffffffc02024ee:	00004617          	auipc	a2,0x4
ffffffffc02024f2:	b0a60613          	add	a2,a2,-1270 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02024f6:	17f00593          	li	a1,383
ffffffffc02024fa:	00004517          	auipc	a0,0x4
ffffffffc02024fe:	30650513          	add	a0,a0,774 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0202502:	f71fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202506:	00004617          	auipc	a2,0x4
ffffffffc020250a:	25a60613          	add	a2,a2,602 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc020250e:	06200593          	li	a1,98
ffffffffc0202512:	00004517          	auipc	a0,0x4
ffffffffc0202516:	1de50513          	add	a0,a0,478 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc020251a:	f59fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020251e:	00004617          	auipc	a2,0x4
ffffffffc0202522:	26260613          	add	a2,a2,610 # ffffffffc0206780 <default_pmm_manager+0xf0>
ffffffffc0202526:	07400593          	li	a1,116
ffffffffc020252a:	00004517          	auipc	a0,0x4
ffffffffc020252e:	1c650513          	add	a0,a0,454 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0202532:	f41fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202536:	00004697          	auipc	a3,0x4
ffffffffc020253a:	2da68693          	add	a3,a3,730 # ffffffffc0206810 <default_pmm_manager+0x180>
ffffffffc020253e:	00004617          	auipc	a2,0x4
ffffffffc0202542:	aba60613          	add	a2,a2,-1350 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202546:	16900593          	li	a1,361
ffffffffc020254a:	00004517          	auipc	a0,0x4
ffffffffc020254e:	2b650513          	add	a0,a0,694 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0202552:	f21fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202556 <tlb_invalidate>:
ffffffffc0202556:	12058073          	sfence.vma	a1
ffffffffc020255a:	8082                	ret

ffffffffc020255c <pgdir_alloc_page>:
ffffffffc020255c:	7179                	add	sp,sp,-48
ffffffffc020255e:	e84a                	sd	s2,16(sp)
ffffffffc0202560:	892a                	mv	s2,a0
ffffffffc0202562:	4505                	li	a0,1
ffffffffc0202564:	ec26                	sd	s1,24(sp)
ffffffffc0202566:	e44e                	sd	s3,8(sp)
ffffffffc0202568:	f406                	sd	ra,40(sp)
ffffffffc020256a:	f022                	sd	s0,32(sp)
ffffffffc020256c:	84ae                	mv	s1,a1
ffffffffc020256e:	89b2                	mv	s3,a2
ffffffffc0202570:	e20ff0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0202574:	c12d                	beqz	a0,ffffffffc02025d6 <pgdir_alloc_page+0x7a>
ffffffffc0202576:	842a                	mv	s0,a0
ffffffffc0202578:	85aa                	mv	a1,a0
ffffffffc020257a:	86ce                	mv	a3,s3
ffffffffc020257c:	8626                	mv	a2,s1
ffffffffc020257e:	854a                	mv	a0,s2
ffffffffc0202580:	cafff0ef          	jal	ffffffffc020222e <page_insert>
ffffffffc0202584:	ed0d                	bnez	a0,ffffffffc02025be <pgdir_alloc_page+0x62>
ffffffffc0202586:	00015797          	auipc	a5,0x15
ffffffffc020258a:	0a27a783          	lw	a5,162(a5) # ffffffffc0217628 <swap_init_ok>
ffffffffc020258e:	c385                	beqz	a5,ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc0202590:	00015517          	auipc	a0,0x15
ffffffffc0202594:	0b853503          	ld	a0,184(a0) # ffffffffc0217648 <check_mm_struct>
ffffffffc0202598:	c919                	beqz	a0,ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc020259a:	4681                	li	a3,0
ffffffffc020259c:	8622                	mv	a2,s0
ffffffffc020259e:	85a6                	mv	a1,s1
ffffffffc02025a0:	108000ef          	jal	ffffffffc02026a8 <swap_map_swappable>
ffffffffc02025a4:	4018                	lw	a4,0(s0)
ffffffffc02025a6:	fc04                	sd	s1,56(s0)
ffffffffc02025a8:	4785                	li	a5,1
ffffffffc02025aa:	04f71663          	bne	a4,a5,ffffffffc02025f6 <pgdir_alloc_page+0x9a>
ffffffffc02025ae:	70a2                	ld	ra,40(sp)
ffffffffc02025b0:	8522                	mv	a0,s0
ffffffffc02025b2:	7402                	ld	s0,32(sp)
ffffffffc02025b4:	64e2                	ld	s1,24(sp)
ffffffffc02025b6:	6942                	ld	s2,16(sp)
ffffffffc02025b8:	69a2                	ld	s3,8(sp)
ffffffffc02025ba:	6145                	add	sp,sp,48
ffffffffc02025bc:	8082                	ret
ffffffffc02025be:	100027f3          	csrr	a5,sstatus
ffffffffc02025c2:	8b89                	and	a5,a5,2
ffffffffc02025c4:	eb99                	bnez	a5,ffffffffc02025da <pgdir_alloc_page+0x7e>
ffffffffc02025c6:	00015797          	auipc	a5,0x15
ffffffffc02025ca:	0327b783          	ld	a5,50(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc02025ce:	739c                	ld	a5,32(a5)
ffffffffc02025d0:	4585                	li	a1,1
ffffffffc02025d2:	8522                	mv	a0,s0
ffffffffc02025d4:	9782                	jalr	a5
ffffffffc02025d6:	4401                	li	s0,0
ffffffffc02025d8:	bfd9                	j	ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc02025da:	85afe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02025de:	00015797          	auipc	a5,0x15
ffffffffc02025e2:	01a7b783          	ld	a5,26(a5) # ffffffffc02175f8 <pmm_manager>
ffffffffc02025e6:	739c                	ld	a5,32(a5)
ffffffffc02025e8:	8522                	mv	a0,s0
ffffffffc02025ea:	4585                	li	a1,1
ffffffffc02025ec:	9782                	jalr	a5
ffffffffc02025ee:	4401                	li	s0,0
ffffffffc02025f0:	83efe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02025f4:	bf6d                	j	ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc02025f6:	00004697          	auipc	a3,0x4
ffffffffc02025fa:	29268693          	add	a3,a3,658 # ffffffffc0206888 <default_pmm_manager+0x1f8>
ffffffffc02025fe:	00004617          	auipc	a2,0x4
ffffffffc0202602:	9fa60613          	add	a2,a2,-1542 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202606:	1d800593          	li	a1,472
ffffffffc020260a:	00004517          	auipc	a0,0x4
ffffffffc020260e:	1f650513          	add	a0,a0,502 # ffffffffc0206800 <default_pmm_manager+0x170>
ffffffffc0202612:	e61fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202616 <swap_init>:
ffffffffc0202616:	1101                	add	sp,sp,-32
ffffffffc0202618:	ec06                	sd	ra,24(sp)
ffffffffc020261a:	e822                	sd	s0,16(sp)
ffffffffc020261c:	e426                	sd	s1,8(sp)
ffffffffc020261e:	7a3000ef          	jal	ffffffffc02035c0 <swapfs_init>
ffffffffc0202622:	00015697          	auipc	a3,0x15
ffffffffc0202626:	00e6b683          	ld	a3,14(a3) # ffffffffc0217630 <max_swap_offset>
ffffffffc020262a:	010007b7          	lui	a5,0x1000
ffffffffc020262e:	ff968713          	add	a4,a3,-7
ffffffffc0202632:	17e1                	add	a5,a5,-8 # fffff8 <kern_entry-0xffffffffbf200008>
ffffffffc0202634:	04e7e863          	bltu	a5,a4,ffffffffc0202684 <swap_init+0x6e>
ffffffffc0202638:	0000a797          	auipc	a5,0xa
ffffffffc020263c:	9d878793          	add	a5,a5,-1576 # ffffffffc020c010 <swap_manager_fifo>
ffffffffc0202640:	6798                	ld	a4,8(a5)
ffffffffc0202642:	00015497          	auipc	s1,0x15
ffffffffc0202646:	ff648493          	add	s1,s1,-10 # ffffffffc0217638 <sm>
ffffffffc020264a:	e09c                	sd	a5,0(s1)
ffffffffc020264c:	9702                	jalr	a4
ffffffffc020264e:	842a                	mv	s0,a0
ffffffffc0202650:	c519                	beqz	a0,ffffffffc020265e <swap_init+0x48>
ffffffffc0202652:	60e2                	ld	ra,24(sp)
ffffffffc0202654:	8522                	mv	a0,s0
ffffffffc0202656:	6442                	ld	s0,16(sp)
ffffffffc0202658:	64a2                	ld	s1,8(sp)
ffffffffc020265a:	6105                	add	sp,sp,32
ffffffffc020265c:	8082                	ret
ffffffffc020265e:	609c                	ld	a5,0(s1)
ffffffffc0202660:	00004517          	auipc	a0,0x4
ffffffffc0202664:	27050513          	add	a0,a0,624 # ffffffffc02068d0 <default_pmm_manager+0x240>
ffffffffc0202668:	638c                	ld	a1,0(a5)
ffffffffc020266a:	4785                	li	a5,1
ffffffffc020266c:	00015717          	auipc	a4,0x15
ffffffffc0202670:	faf72e23          	sw	a5,-68(a4) # ffffffffc0217628 <swap_init_ok>
ffffffffc0202674:	b17fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202678:	60e2                	ld	ra,24(sp)
ffffffffc020267a:	8522                	mv	a0,s0
ffffffffc020267c:	6442                	ld	s0,16(sp)
ffffffffc020267e:	64a2                	ld	s1,8(sp)
ffffffffc0202680:	6105                	add	sp,sp,32
ffffffffc0202682:	8082                	ret
ffffffffc0202684:	00004617          	auipc	a2,0x4
ffffffffc0202688:	21c60613          	add	a2,a2,540 # ffffffffc02068a0 <default_pmm_manager+0x210>
ffffffffc020268c:	02800593          	li	a1,40
ffffffffc0202690:	00004517          	auipc	a0,0x4
ffffffffc0202694:	23050513          	add	a0,a0,560 # ffffffffc02068c0 <default_pmm_manager+0x230>
ffffffffc0202698:	ddbfd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020269c <swap_init_mm>:
ffffffffc020269c:	00015797          	auipc	a5,0x15
ffffffffc02026a0:	f9c7b783          	ld	a5,-100(a5) # ffffffffc0217638 <sm>
ffffffffc02026a4:	6b9c                	ld	a5,16(a5)
ffffffffc02026a6:	8782                	jr	a5

ffffffffc02026a8 <swap_map_swappable>:
ffffffffc02026a8:	00015797          	auipc	a5,0x15
ffffffffc02026ac:	f907b783          	ld	a5,-112(a5) # ffffffffc0217638 <sm>
ffffffffc02026b0:	739c                	ld	a5,32(a5)
ffffffffc02026b2:	8782                	jr	a5

ffffffffc02026b4 <swap_out>:
ffffffffc02026b4:	711d                	add	sp,sp,-96
ffffffffc02026b6:	ec86                	sd	ra,88(sp)
ffffffffc02026b8:	e8a2                	sd	s0,80(sp)
ffffffffc02026ba:	e4a6                	sd	s1,72(sp)
ffffffffc02026bc:	e0ca                	sd	s2,64(sp)
ffffffffc02026be:	fc4e                	sd	s3,56(sp)
ffffffffc02026c0:	f852                	sd	s4,48(sp)
ffffffffc02026c2:	f456                	sd	s5,40(sp)
ffffffffc02026c4:	f05a                	sd	s6,32(sp)
ffffffffc02026c6:	ec5e                	sd	s7,24(sp)
ffffffffc02026c8:	e862                	sd	s8,16(sp)
ffffffffc02026ca:	cde9                	beqz	a1,ffffffffc02027a4 <swap_out+0xf0>
ffffffffc02026cc:	8a2e                	mv	s4,a1
ffffffffc02026ce:	892a                	mv	s2,a0
ffffffffc02026d0:	8ab2                	mv	s5,a2
ffffffffc02026d2:	4401                	li	s0,0
ffffffffc02026d4:	00015997          	auipc	s3,0x15
ffffffffc02026d8:	f6498993          	add	s3,s3,-156 # ffffffffc0217638 <sm>
ffffffffc02026dc:	00004b17          	auipc	s6,0x4
ffffffffc02026e0:	26cb0b13          	add	s6,s6,620 # ffffffffc0206948 <default_pmm_manager+0x2b8>
ffffffffc02026e4:	00004b97          	auipc	s7,0x4
ffffffffc02026e8:	24cb8b93          	add	s7,s7,588 # ffffffffc0206930 <default_pmm_manager+0x2a0>
ffffffffc02026ec:	a825                	j	ffffffffc0202724 <swap_out+0x70>
ffffffffc02026ee:	67a2                	ld	a5,8(sp)
ffffffffc02026f0:	8626                	mv	a2,s1
ffffffffc02026f2:	85a2                	mv	a1,s0
ffffffffc02026f4:	7f94                	ld	a3,56(a5)
ffffffffc02026f6:	855a                	mv	a0,s6
ffffffffc02026f8:	2405                	addw	s0,s0,1 # ffffffffffe00001 <end+0x3fbe8981>
ffffffffc02026fa:	82b1                	srl	a3,a3,0xc
ffffffffc02026fc:	0685                	add	a3,a3,1
ffffffffc02026fe:	a8dfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202702:	6522                	ld	a0,8(sp)
ffffffffc0202704:	4585                	li	a1,1
ffffffffc0202706:	7d1c                	ld	a5,56(a0)
ffffffffc0202708:	83b1                	srl	a5,a5,0xc
ffffffffc020270a:	0785                	add	a5,a5,1
ffffffffc020270c:	07a2                	sll	a5,a5,0x8
ffffffffc020270e:	00fc3023          	sd	a5,0(s8)
ffffffffc0202712:	d0eff0ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0202716:	01893503          	ld	a0,24(s2)
ffffffffc020271a:	85a6                	mv	a1,s1
ffffffffc020271c:	e3bff0ef          	jal	ffffffffc0202556 <tlb_invalidate>
ffffffffc0202720:	048a0d63          	beq	s4,s0,ffffffffc020277a <swap_out+0xc6>
ffffffffc0202724:	0009b783          	ld	a5,0(s3)
ffffffffc0202728:	8656                	mv	a2,s5
ffffffffc020272a:	002c                	add	a1,sp,8
ffffffffc020272c:	7b9c                	ld	a5,48(a5)
ffffffffc020272e:	854a                	mv	a0,s2
ffffffffc0202730:	9782                	jalr	a5
ffffffffc0202732:	e12d                	bnez	a0,ffffffffc0202794 <swap_out+0xe0>
ffffffffc0202734:	67a2                	ld	a5,8(sp)
ffffffffc0202736:	01893503          	ld	a0,24(s2)
ffffffffc020273a:	4601                	li	a2,0
ffffffffc020273c:	7f84                	ld	s1,56(a5)
ffffffffc020273e:	85a6                	mv	a1,s1
ffffffffc0202740:	eb8ff0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc0202744:	611c                	ld	a5,0(a0)
ffffffffc0202746:	8c2a                	mv	s8,a0
ffffffffc0202748:	8b85                	and	a5,a5,1
ffffffffc020274a:	cfb9                	beqz	a5,ffffffffc02027a8 <swap_out+0xf4>
ffffffffc020274c:	65a2                	ld	a1,8(sp)
ffffffffc020274e:	7d9c                	ld	a5,56(a1)
ffffffffc0202750:	83b1                	srl	a5,a5,0xc
ffffffffc0202752:	0785                	add	a5,a5,1
ffffffffc0202754:	00879513          	sll	a0,a5,0x8
ffffffffc0202758:	72f000ef          	jal	ffffffffc0203686 <swapfs_write>
ffffffffc020275c:	d949                	beqz	a0,ffffffffc02026ee <swap_out+0x3a>
ffffffffc020275e:	855e                	mv	a0,s7
ffffffffc0202760:	a2bfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202764:	0009b783          	ld	a5,0(s3)
ffffffffc0202768:	6622                	ld	a2,8(sp)
ffffffffc020276a:	4681                	li	a3,0
ffffffffc020276c:	739c                	ld	a5,32(a5)
ffffffffc020276e:	85a6                	mv	a1,s1
ffffffffc0202770:	854a                	mv	a0,s2
ffffffffc0202772:	2405                	addw	s0,s0,1
ffffffffc0202774:	9782                	jalr	a5
ffffffffc0202776:	fa8a17e3          	bne	s4,s0,ffffffffc0202724 <swap_out+0x70>
ffffffffc020277a:	60e6                	ld	ra,88(sp)
ffffffffc020277c:	8522                	mv	a0,s0
ffffffffc020277e:	6446                	ld	s0,80(sp)
ffffffffc0202780:	64a6                	ld	s1,72(sp)
ffffffffc0202782:	6906                	ld	s2,64(sp)
ffffffffc0202784:	79e2                	ld	s3,56(sp)
ffffffffc0202786:	7a42                	ld	s4,48(sp)
ffffffffc0202788:	7aa2                	ld	s5,40(sp)
ffffffffc020278a:	7b02                	ld	s6,32(sp)
ffffffffc020278c:	6be2                	ld	s7,24(sp)
ffffffffc020278e:	6c42                	ld	s8,16(sp)
ffffffffc0202790:	6125                	add	sp,sp,96
ffffffffc0202792:	8082                	ret
ffffffffc0202794:	85a2                	mv	a1,s0
ffffffffc0202796:	00004517          	auipc	a0,0x4
ffffffffc020279a:	15250513          	add	a0,a0,338 # ffffffffc02068e8 <default_pmm_manager+0x258>
ffffffffc020279e:	9edfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02027a2:	bfe1                	j	ffffffffc020277a <swap_out+0xc6>
ffffffffc02027a4:	4401                	li	s0,0
ffffffffc02027a6:	bfd1                	j	ffffffffc020277a <swap_out+0xc6>
ffffffffc02027a8:	00004697          	auipc	a3,0x4
ffffffffc02027ac:	17068693          	add	a3,a3,368 # ffffffffc0206918 <default_pmm_manager+0x288>
ffffffffc02027b0:	00004617          	auipc	a2,0x4
ffffffffc02027b4:	84860613          	add	a2,a2,-1976 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02027b8:	06800593          	li	a1,104
ffffffffc02027bc:	00004517          	auipc	a0,0x4
ffffffffc02027c0:	10450513          	add	a0,a0,260 # ffffffffc02068c0 <default_pmm_manager+0x230>
ffffffffc02027c4:	caffd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02027c8 <swap_in>:
ffffffffc02027c8:	7179                	add	sp,sp,-48
ffffffffc02027ca:	e84a                	sd	s2,16(sp)
ffffffffc02027cc:	892a                	mv	s2,a0
ffffffffc02027ce:	4505                	li	a0,1
ffffffffc02027d0:	ec26                	sd	s1,24(sp)
ffffffffc02027d2:	e44e                	sd	s3,8(sp)
ffffffffc02027d4:	f406                	sd	ra,40(sp)
ffffffffc02027d6:	f022                	sd	s0,32(sp)
ffffffffc02027d8:	84ae                	mv	s1,a1
ffffffffc02027da:	89b2                	mv	s3,a2
ffffffffc02027dc:	bb4ff0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc02027e0:	c129                	beqz	a0,ffffffffc0202822 <swap_in+0x5a>
ffffffffc02027e2:	842a                	mv	s0,a0
ffffffffc02027e4:	01893503          	ld	a0,24(s2)
ffffffffc02027e8:	4601                	li	a2,0
ffffffffc02027ea:	85a6                	mv	a1,s1
ffffffffc02027ec:	e0cff0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc02027f0:	892a                	mv	s2,a0
ffffffffc02027f2:	6108                	ld	a0,0(a0)
ffffffffc02027f4:	85a2                	mv	a1,s0
ffffffffc02027f6:	603000ef          	jal	ffffffffc02035f8 <swapfs_read>
ffffffffc02027fa:	00093583          	ld	a1,0(s2)
ffffffffc02027fe:	8626                	mv	a2,s1
ffffffffc0202800:	00004517          	auipc	a0,0x4
ffffffffc0202804:	19850513          	add	a0,a0,408 # ffffffffc0206998 <default_pmm_manager+0x308>
ffffffffc0202808:	81a1                	srl	a1,a1,0x8
ffffffffc020280a:	981fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020280e:	70a2                	ld	ra,40(sp)
ffffffffc0202810:	0089b023          	sd	s0,0(s3)
ffffffffc0202814:	7402                	ld	s0,32(sp)
ffffffffc0202816:	64e2                	ld	s1,24(sp)
ffffffffc0202818:	6942                	ld	s2,16(sp)
ffffffffc020281a:	69a2                	ld	s3,8(sp)
ffffffffc020281c:	4501                	li	a0,0
ffffffffc020281e:	6145                	add	sp,sp,48
ffffffffc0202820:	8082                	ret
ffffffffc0202822:	00004697          	auipc	a3,0x4
ffffffffc0202826:	16668693          	add	a3,a3,358 # ffffffffc0206988 <default_pmm_manager+0x2f8>
ffffffffc020282a:	00003617          	auipc	a2,0x3
ffffffffc020282e:	7ce60613          	add	a2,a2,1998 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202832:	07e00593          	li	a1,126
ffffffffc0202836:	00004517          	auipc	a0,0x4
ffffffffc020283a:	08a50513          	add	a0,a0,138 # ffffffffc02068c0 <default_pmm_manager+0x230>
ffffffffc020283e:	c35fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202842 <_fifo_init_mm>:
ffffffffc0202842:	00011797          	auipc	a5,0x11
ffffffffc0202846:	c6678793          	add	a5,a5,-922 # ffffffffc02134a8 <pra_list_head>
ffffffffc020284a:	f51c                	sd	a5,40(a0)
ffffffffc020284c:	e79c                	sd	a5,8(a5)
ffffffffc020284e:	e39c                	sd	a5,0(a5)
ffffffffc0202850:	4501                	li	a0,0
ffffffffc0202852:	8082                	ret

ffffffffc0202854 <_fifo_init>:
ffffffffc0202854:	4501                	li	a0,0
ffffffffc0202856:	8082                	ret

ffffffffc0202858 <_fifo_set_unswappable>:
ffffffffc0202858:	4501                	li	a0,0
ffffffffc020285a:	8082                	ret

ffffffffc020285c <_fifo_tick_event>:
ffffffffc020285c:	4501                	li	a0,0
ffffffffc020285e:	8082                	ret

ffffffffc0202860 <_fifo_check_swap>:
ffffffffc0202860:	711d                	add	sp,sp,-96
ffffffffc0202862:	fc4e                	sd	s3,56(sp)
ffffffffc0202864:	f852                	sd	s4,48(sp)
ffffffffc0202866:	00004517          	auipc	a0,0x4
ffffffffc020286a:	17250513          	add	a0,a0,370 # ffffffffc02069d8 <default_pmm_manager+0x348>
ffffffffc020286e:	698d                	lui	s3,0x3
ffffffffc0202870:	4a31                	li	s4,12
ffffffffc0202872:	e4a6                	sd	s1,72(sp)
ffffffffc0202874:	ec86                	sd	ra,88(sp)
ffffffffc0202876:	e8a2                	sd	s0,80(sp)
ffffffffc0202878:	e0ca                	sd	s2,64(sp)
ffffffffc020287a:	f456                	sd	s5,40(sp)
ffffffffc020287c:	f05a                	sd	s6,32(sp)
ffffffffc020287e:	ec5e                	sd	s7,24(sp)
ffffffffc0202880:	e862                	sd	s8,16(sp)
ffffffffc0202882:	e466                	sd	s9,8(sp)
ffffffffc0202884:	907fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202888:	01498023          	sb	s4,0(s3) # 3000 <kern_entry-0xffffffffc01fd000>
ffffffffc020288c:	00015497          	auipc	s1,0x15
ffffffffc0202890:	db44a483          	lw	s1,-588(s1) # ffffffffc0217640 <pgfault_num>
ffffffffc0202894:	4791                	li	a5,4
ffffffffc0202896:	14f49963          	bne	s1,a5,ffffffffc02029e8 <_fifo_check_swap+0x188>
ffffffffc020289a:	00004517          	auipc	a0,0x4
ffffffffc020289e:	18e50513          	add	a0,a0,398 # ffffffffc0206a28 <default_pmm_manager+0x398>
ffffffffc02028a2:	6a85                	lui	s5,0x1
ffffffffc02028a4:	4b29                	li	s6,10
ffffffffc02028a6:	8e5fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02028aa:	00015417          	auipc	s0,0x15
ffffffffc02028ae:	d9640413          	add	s0,s0,-618 # ffffffffc0217640 <pgfault_num>
ffffffffc02028b2:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02028b6:	401c                	lw	a5,0(s0)
ffffffffc02028b8:	0007891b          	sext.w	s2,a5
ffffffffc02028bc:	2a979663          	bne	a5,s1,ffffffffc0202b68 <_fifo_check_swap+0x308>
ffffffffc02028c0:	00004517          	auipc	a0,0x4
ffffffffc02028c4:	19050513          	add	a0,a0,400 # ffffffffc0206a50 <default_pmm_manager+0x3c0>
ffffffffc02028c8:	6b91                	lui	s7,0x4
ffffffffc02028ca:	4c35                	li	s8,13
ffffffffc02028cc:	8bffd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02028d0:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
ffffffffc02028d4:	401c                	lw	a5,0(s0)
ffffffffc02028d6:	00078c9b          	sext.w	s9,a5
ffffffffc02028da:	27279763          	bne	a5,s2,ffffffffc0202b48 <_fifo_check_swap+0x2e8>
ffffffffc02028de:	00004517          	auipc	a0,0x4
ffffffffc02028e2:	19a50513          	add	a0,a0,410 # ffffffffc0206a78 <default_pmm_manager+0x3e8>
ffffffffc02028e6:	6489                	lui	s1,0x2
ffffffffc02028e8:	492d                	li	s2,11
ffffffffc02028ea:	8a1fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02028ee:	01248023          	sb	s2,0(s1) # 2000 <kern_entry-0xffffffffc01fe000>
ffffffffc02028f2:	401c                	lw	a5,0(s0)
ffffffffc02028f4:	23979a63          	bne	a5,s9,ffffffffc0202b28 <_fifo_check_swap+0x2c8>
ffffffffc02028f8:	00004517          	auipc	a0,0x4
ffffffffc02028fc:	1a850513          	add	a0,a0,424 # ffffffffc0206aa0 <default_pmm_manager+0x410>
ffffffffc0202900:	88bfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202904:	6795                	lui	a5,0x5
ffffffffc0202906:	4739                	li	a4,14
ffffffffc0202908:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc020290c:	401c                	lw	a5,0(s0)
ffffffffc020290e:	4715                	li	a4,5
ffffffffc0202910:	00078c9b          	sext.w	s9,a5
ffffffffc0202914:	1ee79a63          	bne	a5,a4,ffffffffc0202b08 <_fifo_check_swap+0x2a8>
ffffffffc0202918:	00004517          	auipc	a0,0x4
ffffffffc020291c:	16050513          	add	a0,a0,352 # ffffffffc0206a78 <default_pmm_manager+0x3e8>
ffffffffc0202920:	86bfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202924:	01248023          	sb	s2,0(s1)
ffffffffc0202928:	401c                	lw	a5,0(s0)
ffffffffc020292a:	1b979f63          	bne	a5,s9,ffffffffc0202ae8 <_fifo_check_swap+0x288>
ffffffffc020292e:	00004517          	auipc	a0,0x4
ffffffffc0202932:	0fa50513          	add	a0,a0,250 # ffffffffc0206a28 <default_pmm_manager+0x398>
ffffffffc0202936:	855fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020293a:	016a8023          	sb	s6,0(s5)
ffffffffc020293e:	4018                	lw	a4,0(s0)
ffffffffc0202940:	4799                	li	a5,6
ffffffffc0202942:	18f71363          	bne	a4,a5,ffffffffc0202ac8 <_fifo_check_swap+0x268>
ffffffffc0202946:	00004517          	auipc	a0,0x4
ffffffffc020294a:	13250513          	add	a0,a0,306 # ffffffffc0206a78 <default_pmm_manager+0x3e8>
ffffffffc020294e:	83dfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202952:	01248023          	sb	s2,0(s1)
ffffffffc0202956:	4018                	lw	a4,0(s0)
ffffffffc0202958:	479d                	li	a5,7
ffffffffc020295a:	14f71763          	bne	a4,a5,ffffffffc0202aa8 <_fifo_check_swap+0x248>
ffffffffc020295e:	00004517          	auipc	a0,0x4
ffffffffc0202962:	07a50513          	add	a0,a0,122 # ffffffffc02069d8 <default_pmm_manager+0x348>
ffffffffc0202966:	825fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020296a:	01498023          	sb	s4,0(s3)
ffffffffc020296e:	4018                	lw	a4,0(s0)
ffffffffc0202970:	47a1                	li	a5,8
ffffffffc0202972:	10f71b63          	bne	a4,a5,ffffffffc0202a88 <_fifo_check_swap+0x228>
ffffffffc0202976:	00004517          	auipc	a0,0x4
ffffffffc020297a:	0da50513          	add	a0,a0,218 # ffffffffc0206a50 <default_pmm_manager+0x3c0>
ffffffffc020297e:	80dfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202982:	018b8023          	sb	s8,0(s7)
ffffffffc0202986:	4018                	lw	a4,0(s0)
ffffffffc0202988:	47a5                	li	a5,9
ffffffffc020298a:	0cf71f63          	bne	a4,a5,ffffffffc0202a68 <_fifo_check_swap+0x208>
ffffffffc020298e:	00004517          	auipc	a0,0x4
ffffffffc0202992:	11250513          	add	a0,a0,274 # ffffffffc0206aa0 <default_pmm_manager+0x410>
ffffffffc0202996:	ff4fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020299a:	6795                	lui	a5,0x5
ffffffffc020299c:	4739                	li	a4,14
ffffffffc020299e:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc02029a2:	401c                	lw	a5,0(s0)
ffffffffc02029a4:	4729                	li	a4,10
ffffffffc02029a6:	0007849b          	sext.w	s1,a5
ffffffffc02029aa:	08e79f63          	bne	a5,a4,ffffffffc0202a48 <_fifo_check_swap+0x1e8>
ffffffffc02029ae:	00004517          	auipc	a0,0x4
ffffffffc02029b2:	07a50513          	add	a0,a0,122 # ffffffffc0206a28 <default_pmm_manager+0x398>
ffffffffc02029b6:	fd4fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02029ba:	6785                	lui	a5,0x1
ffffffffc02029bc:	0007c783          	lbu	a5,0(a5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02029c0:	06979463          	bne	a5,s1,ffffffffc0202a28 <_fifo_check_swap+0x1c8>
ffffffffc02029c4:	4018                	lw	a4,0(s0)
ffffffffc02029c6:	47ad                	li	a5,11
ffffffffc02029c8:	04f71063          	bne	a4,a5,ffffffffc0202a08 <_fifo_check_swap+0x1a8>
ffffffffc02029cc:	60e6                	ld	ra,88(sp)
ffffffffc02029ce:	6446                	ld	s0,80(sp)
ffffffffc02029d0:	64a6                	ld	s1,72(sp)
ffffffffc02029d2:	6906                	ld	s2,64(sp)
ffffffffc02029d4:	79e2                	ld	s3,56(sp)
ffffffffc02029d6:	7a42                	ld	s4,48(sp)
ffffffffc02029d8:	7aa2                	ld	s5,40(sp)
ffffffffc02029da:	7b02                	ld	s6,32(sp)
ffffffffc02029dc:	6be2                	ld	s7,24(sp)
ffffffffc02029de:	6c42                	ld	s8,16(sp)
ffffffffc02029e0:	6ca2                	ld	s9,8(sp)
ffffffffc02029e2:	4501                	li	a0,0
ffffffffc02029e4:	6125                	add	sp,sp,96
ffffffffc02029e6:	8082                	ret
ffffffffc02029e8:	00004697          	auipc	a3,0x4
ffffffffc02029ec:	01868693          	add	a3,a3,24 # ffffffffc0206a00 <default_pmm_manager+0x370>
ffffffffc02029f0:	00003617          	auipc	a2,0x3
ffffffffc02029f4:	60860613          	add	a2,a2,1544 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02029f8:	05100593          	li	a1,81
ffffffffc02029fc:	00004517          	auipc	a0,0x4
ffffffffc0202a00:	01450513          	add	a0,a0,20 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202a04:	a6ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a08:	00004697          	auipc	a3,0x4
ffffffffc0202a0c:	14868693          	add	a3,a3,328 # ffffffffc0206b50 <default_pmm_manager+0x4c0>
ffffffffc0202a10:	00003617          	auipc	a2,0x3
ffffffffc0202a14:	5e860613          	add	a2,a2,1512 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202a18:	07300593          	li	a1,115
ffffffffc0202a1c:	00004517          	auipc	a0,0x4
ffffffffc0202a20:	ff450513          	add	a0,a0,-12 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202a24:	a4ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a28:	00004697          	auipc	a3,0x4
ffffffffc0202a2c:	10068693          	add	a3,a3,256 # ffffffffc0206b28 <default_pmm_manager+0x498>
ffffffffc0202a30:	00003617          	auipc	a2,0x3
ffffffffc0202a34:	5c860613          	add	a2,a2,1480 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202a38:	07100593          	li	a1,113
ffffffffc0202a3c:	00004517          	auipc	a0,0x4
ffffffffc0202a40:	fd450513          	add	a0,a0,-44 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202a44:	a2ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a48:	00004697          	auipc	a3,0x4
ffffffffc0202a4c:	0d068693          	add	a3,a3,208 # ffffffffc0206b18 <default_pmm_manager+0x488>
ffffffffc0202a50:	00003617          	auipc	a2,0x3
ffffffffc0202a54:	5a860613          	add	a2,a2,1448 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202a58:	06f00593          	li	a1,111
ffffffffc0202a5c:	00004517          	auipc	a0,0x4
ffffffffc0202a60:	fb450513          	add	a0,a0,-76 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202a64:	a0ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a68:	00004697          	auipc	a3,0x4
ffffffffc0202a6c:	0a068693          	add	a3,a3,160 # ffffffffc0206b08 <default_pmm_manager+0x478>
ffffffffc0202a70:	00003617          	auipc	a2,0x3
ffffffffc0202a74:	58860613          	add	a2,a2,1416 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202a78:	06c00593          	li	a1,108
ffffffffc0202a7c:	00004517          	auipc	a0,0x4
ffffffffc0202a80:	f9450513          	add	a0,a0,-108 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202a84:	9effd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a88:	00004697          	auipc	a3,0x4
ffffffffc0202a8c:	07068693          	add	a3,a3,112 # ffffffffc0206af8 <default_pmm_manager+0x468>
ffffffffc0202a90:	00003617          	auipc	a2,0x3
ffffffffc0202a94:	56860613          	add	a2,a2,1384 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202a98:	06900593          	li	a1,105
ffffffffc0202a9c:	00004517          	auipc	a0,0x4
ffffffffc0202aa0:	f7450513          	add	a0,a0,-140 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202aa4:	9cffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202aa8:	00004697          	auipc	a3,0x4
ffffffffc0202aac:	04068693          	add	a3,a3,64 # ffffffffc0206ae8 <default_pmm_manager+0x458>
ffffffffc0202ab0:	00003617          	auipc	a2,0x3
ffffffffc0202ab4:	54860613          	add	a2,a2,1352 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202ab8:	06600593          	li	a1,102
ffffffffc0202abc:	00004517          	auipc	a0,0x4
ffffffffc0202ac0:	f5450513          	add	a0,a0,-172 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202ac4:	9affd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202ac8:	00004697          	auipc	a3,0x4
ffffffffc0202acc:	01068693          	add	a3,a3,16 # ffffffffc0206ad8 <default_pmm_manager+0x448>
ffffffffc0202ad0:	00003617          	auipc	a2,0x3
ffffffffc0202ad4:	52860613          	add	a2,a2,1320 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202ad8:	06300593          	li	a1,99
ffffffffc0202adc:	00004517          	auipc	a0,0x4
ffffffffc0202ae0:	f3450513          	add	a0,a0,-204 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202ae4:	98ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202ae8:	00004697          	auipc	a3,0x4
ffffffffc0202aec:	fe068693          	add	a3,a3,-32 # ffffffffc0206ac8 <default_pmm_manager+0x438>
ffffffffc0202af0:	00003617          	auipc	a2,0x3
ffffffffc0202af4:	50860613          	add	a2,a2,1288 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202af8:	06000593          	li	a1,96
ffffffffc0202afc:	00004517          	auipc	a0,0x4
ffffffffc0202b00:	f1450513          	add	a0,a0,-236 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202b04:	96ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b08:	00004697          	auipc	a3,0x4
ffffffffc0202b0c:	fc068693          	add	a3,a3,-64 # ffffffffc0206ac8 <default_pmm_manager+0x438>
ffffffffc0202b10:	00003617          	auipc	a2,0x3
ffffffffc0202b14:	4e860613          	add	a2,a2,1256 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202b18:	05d00593          	li	a1,93
ffffffffc0202b1c:	00004517          	auipc	a0,0x4
ffffffffc0202b20:	ef450513          	add	a0,a0,-268 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202b24:	94ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b28:	00004697          	auipc	a3,0x4
ffffffffc0202b2c:	ed868693          	add	a3,a3,-296 # ffffffffc0206a00 <default_pmm_manager+0x370>
ffffffffc0202b30:	00003617          	auipc	a2,0x3
ffffffffc0202b34:	4c860613          	add	a2,a2,1224 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202b38:	05a00593          	li	a1,90
ffffffffc0202b3c:	00004517          	auipc	a0,0x4
ffffffffc0202b40:	ed450513          	add	a0,a0,-300 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202b44:	92ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b48:	00004697          	auipc	a3,0x4
ffffffffc0202b4c:	eb868693          	add	a3,a3,-328 # ffffffffc0206a00 <default_pmm_manager+0x370>
ffffffffc0202b50:	00003617          	auipc	a2,0x3
ffffffffc0202b54:	4a860613          	add	a2,a2,1192 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202b58:	05700593          	li	a1,87
ffffffffc0202b5c:	00004517          	auipc	a0,0x4
ffffffffc0202b60:	eb450513          	add	a0,a0,-332 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202b64:	90ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b68:	00004697          	auipc	a3,0x4
ffffffffc0202b6c:	e9868693          	add	a3,a3,-360 # ffffffffc0206a00 <default_pmm_manager+0x370>
ffffffffc0202b70:	00003617          	auipc	a2,0x3
ffffffffc0202b74:	48860613          	add	a2,a2,1160 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202b78:	05400593          	li	a1,84
ffffffffc0202b7c:	00004517          	auipc	a0,0x4
ffffffffc0202b80:	e9450513          	add	a0,a0,-364 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202b84:	8effd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202b88 <_fifo_swap_out_victim>:
ffffffffc0202b88:	751c                	ld	a5,40(a0)
ffffffffc0202b8a:	1141                	add	sp,sp,-16
ffffffffc0202b8c:	e406                	sd	ra,8(sp)
ffffffffc0202b8e:	cf91                	beqz	a5,ffffffffc0202baa <_fifo_swap_out_victim+0x22>
ffffffffc0202b90:	ee0d                	bnez	a2,ffffffffc0202bca <_fifo_swap_out_victim+0x42>
ffffffffc0202b92:	679c                	ld	a5,8(a5)
ffffffffc0202b94:	60a2                	ld	ra,8(sp)
ffffffffc0202b96:	4501                	li	a0,0
ffffffffc0202b98:	6394                	ld	a3,0(a5)
ffffffffc0202b9a:	6798                	ld	a4,8(a5)
ffffffffc0202b9c:	fd878793          	add	a5,a5,-40
ffffffffc0202ba0:	e698                	sd	a4,8(a3)
ffffffffc0202ba2:	e314                	sd	a3,0(a4)
ffffffffc0202ba4:	e19c                	sd	a5,0(a1)
ffffffffc0202ba6:	0141                	add	sp,sp,16
ffffffffc0202ba8:	8082                	ret
ffffffffc0202baa:	00004697          	auipc	a3,0x4
ffffffffc0202bae:	fb668693          	add	a3,a3,-74 # ffffffffc0206b60 <default_pmm_manager+0x4d0>
ffffffffc0202bb2:	00003617          	auipc	a2,0x3
ffffffffc0202bb6:	44660613          	add	a2,a2,1094 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202bba:	04100593          	li	a1,65
ffffffffc0202bbe:	00004517          	auipc	a0,0x4
ffffffffc0202bc2:	e5250513          	add	a0,a0,-430 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202bc6:	8adfd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202bca:	00004697          	auipc	a3,0x4
ffffffffc0202bce:	fa668693          	add	a3,a3,-90 # ffffffffc0206b70 <default_pmm_manager+0x4e0>
ffffffffc0202bd2:	00003617          	auipc	a2,0x3
ffffffffc0202bd6:	42660613          	add	a2,a2,1062 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202bda:	04200593          	li	a1,66
ffffffffc0202bde:	00004517          	auipc	a0,0x4
ffffffffc0202be2:	e3250513          	add	a0,a0,-462 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202be6:	88dfd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202bea <_fifo_map_swappable>:
ffffffffc0202bea:	751c                	ld	a5,40(a0)
ffffffffc0202bec:	cb91                	beqz	a5,ffffffffc0202c00 <_fifo_map_swappable+0x16>
ffffffffc0202bee:	6394                	ld	a3,0(a5)
ffffffffc0202bf0:	02860713          	add	a4,a2,40
ffffffffc0202bf4:	e398                	sd	a4,0(a5)
ffffffffc0202bf6:	e698                	sd	a4,8(a3)
ffffffffc0202bf8:	4501                	li	a0,0
ffffffffc0202bfa:	fa1c                	sd	a5,48(a2)
ffffffffc0202bfc:	f614                	sd	a3,40(a2)
ffffffffc0202bfe:	8082                	ret
ffffffffc0202c00:	1141                	add	sp,sp,-16
ffffffffc0202c02:	00004697          	auipc	a3,0x4
ffffffffc0202c06:	f7e68693          	add	a3,a3,-130 # ffffffffc0206b80 <default_pmm_manager+0x4f0>
ffffffffc0202c0a:	00003617          	auipc	a2,0x3
ffffffffc0202c0e:	3ee60613          	add	a2,a2,1006 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202c12:	03200593          	li	a1,50
ffffffffc0202c16:	00004517          	auipc	a0,0x4
ffffffffc0202c1a:	dfa50513          	add	a0,a0,-518 # ffffffffc0206a10 <default_pmm_manager+0x380>
ffffffffc0202c1e:	e406                	sd	ra,8(sp)
ffffffffc0202c20:	853fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202c24 <check_vma_overlap.part.0>:
ffffffffc0202c24:	1141                	add	sp,sp,-16
ffffffffc0202c26:	00004697          	auipc	a3,0x4
ffffffffc0202c2a:	f9268693          	add	a3,a3,-110 # ffffffffc0206bb8 <default_pmm_manager+0x528>
ffffffffc0202c2e:	00003617          	auipc	a2,0x3
ffffffffc0202c32:	3ca60613          	add	a2,a2,970 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202c36:	06d00593          	li	a1,109
ffffffffc0202c3a:	00004517          	auipc	a0,0x4
ffffffffc0202c3e:	f9e50513          	add	a0,a0,-98 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202c42:	e406                	sd	ra,8(sp)
ffffffffc0202c44:	82ffd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202c48 <mm_create>:
ffffffffc0202c48:	1141                	add	sp,sp,-16
ffffffffc0202c4a:	05800513          	li	a0,88
ffffffffc0202c4e:	e022                	sd	s0,0(sp)
ffffffffc0202c50:	e406                	sd	ra,8(sp)
ffffffffc0202c52:	d8dfe0ef          	jal	ffffffffc02019de <kmalloc>
ffffffffc0202c56:	842a                	mv	s0,a0
ffffffffc0202c58:	c51d                	beqz	a0,ffffffffc0202c86 <mm_create+0x3e>
ffffffffc0202c5a:	e408                	sd	a0,8(s0)
ffffffffc0202c5c:	e008                	sd	a0,0(s0)
ffffffffc0202c5e:	00053823          	sd	zero,16(a0)
ffffffffc0202c62:	00053c23          	sd	zero,24(a0)
ffffffffc0202c66:	02052023          	sw	zero,32(a0)
ffffffffc0202c6a:	00015797          	auipc	a5,0x15
ffffffffc0202c6e:	9be7a783          	lw	a5,-1602(a5) # ffffffffc0217628 <swap_init_ok>
ffffffffc0202c72:	ef99                	bnez	a5,ffffffffc0202c90 <mm_create+0x48>
ffffffffc0202c74:	02053423          	sd	zero,40(a0)
ffffffffc0202c78:	02042823          	sw	zero,48(s0)
ffffffffc0202c7c:	4585                	li	a1,1
ffffffffc0202c7e:	03840513          	add	a0,s0,56
ffffffffc0202c82:	003000ef          	jal	ffffffffc0203484 <sem_init>
ffffffffc0202c86:	60a2                	ld	ra,8(sp)
ffffffffc0202c88:	8522                	mv	a0,s0
ffffffffc0202c8a:	6402                	ld	s0,0(sp)
ffffffffc0202c8c:	0141                	add	sp,sp,16
ffffffffc0202c8e:	8082                	ret
ffffffffc0202c90:	a0dff0ef          	jal	ffffffffc020269c <swap_init_mm>
ffffffffc0202c94:	b7d5                	j	ffffffffc0202c78 <mm_create+0x30>

ffffffffc0202c96 <find_vma>:
ffffffffc0202c96:	86aa                	mv	a3,a0
ffffffffc0202c98:	c505                	beqz	a0,ffffffffc0202cc0 <find_vma+0x2a>
ffffffffc0202c9a:	6908                	ld	a0,16(a0)
ffffffffc0202c9c:	c501                	beqz	a0,ffffffffc0202ca4 <find_vma+0xe>
ffffffffc0202c9e:	651c                	ld	a5,8(a0)
ffffffffc0202ca0:	02f5f663          	bgeu	a1,a5,ffffffffc0202ccc <find_vma+0x36>
ffffffffc0202ca4:	669c                	ld	a5,8(a3)
ffffffffc0202ca6:	00f68d63          	beq	a3,a5,ffffffffc0202cc0 <find_vma+0x2a>
ffffffffc0202caa:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202cae:	00e5e663          	bltu	a1,a4,ffffffffc0202cba <find_vma+0x24>
ffffffffc0202cb2:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202cb6:	00e5e763          	bltu	a1,a4,ffffffffc0202cc4 <find_vma+0x2e>
ffffffffc0202cba:	679c                	ld	a5,8(a5)
ffffffffc0202cbc:	fef697e3          	bne	a3,a5,ffffffffc0202caa <find_vma+0x14>
ffffffffc0202cc0:	4501                	li	a0,0
ffffffffc0202cc2:	8082                	ret
ffffffffc0202cc4:	fe078513          	add	a0,a5,-32
ffffffffc0202cc8:	ea88                	sd	a0,16(a3)
ffffffffc0202cca:	8082                	ret
ffffffffc0202ccc:	691c                	ld	a5,16(a0)
ffffffffc0202cce:	fcf5fbe3          	bgeu	a1,a5,ffffffffc0202ca4 <find_vma+0xe>
ffffffffc0202cd2:	ea88                	sd	a0,16(a3)
ffffffffc0202cd4:	8082                	ret

ffffffffc0202cd6 <insert_vma_struct>:
ffffffffc0202cd6:	6590                	ld	a2,8(a1)
ffffffffc0202cd8:	0105b803          	ld	a6,16(a1)
ffffffffc0202cdc:	1141                	add	sp,sp,-16
ffffffffc0202cde:	e406                	sd	ra,8(sp)
ffffffffc0202ce0:	87aa                	mv	a5,a0
ffffffffc0202ce2:	01066763          	bltu	a2,a6,ffffffffc0202cf0 <insert_vma_struct+0x1a>
ffffffffc0202ce6:	a085                	j	ffffffffc0202d46 <insert_vma_struct+0x70>
ffffffffc0202ce8:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202cec:	04e66863          	bltu	a2,a4,ffffffffc0202d3c <insert_vma_struct+0x66>
ffffffffc0202cf0:	86be                	mv	a3,a5
ffffffffc0202cf2:	679c                	ld	a5,8(a5)
ffffffffc0202cf4:	fef51ae3          	bne	a0,a5,ffffffffc0202ce8 <insert_vma_struct+0x12>
ffffffffc0202cf8:	02a68463          	beq	a3,a0,ffffffffc0202d20 <insert_vma_struct+0x4a>
ffffffffc0202cfc:	ff06b703          	ld	a4,-16(a3)
ffffffffc0202d00:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202d04:	08e8f163          	bgeu	a7,a4,ffffffffc0202d86 <insert_vma_struct+0xb0>
ffffffffc0202d08:	04e66f63          	bltu	a2,a4,ffffffffc0202d66 <insert_vma_struct+0x90>
ffffffffc0202d0c:	00f50a63          	beq	a0,a5,ffffffffc0202d20 <insert_vma_struct+0x4a>
ffffffffc0202d10:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202d14:	05076963          	bltu	a4,a6,ffffffffc0202d66 <insert_vma_struct+0x90>
ffffffffc0202d18:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202d1c:	02c77363          	bgeu	a4,a2,ffffffffc0202d42 <insert_vma_struct+0x6c>
ffffffffc0202d20:	5118                	lw	a4,32(a0)
ffffffffc0202d22:	e188                	sd	a0,0(a1)
ffffffffc0202d24:	02058613          	add	a2,a1,32
ffffffffc0202d28:	e390                	sd	a2,0(a5)
ffffffffc0202d2a:	e690                	sd	a2,8(a3)
ffffffffc0202d2c:	60a2                	ld	ra,8(sp)
ffffffffc0202d2e:	f59c                	sd	a5,40(a1)
ffffffffc0202d30:	f194                	sd	a3,32(a1)
ffffffffc0202d32:	0017079b          	addw	a5,a4,1
ffffffffc0202d36:	d11c                	sw	a5,32(a0)
ffffffffc0202d38:	0141                	add	sp,sp,16
ffffffffc0202d3a:	8082                	ret
ffffffffc0202d3c:	fca690e3          	bne	a3,a0,ffffffffc0202cfc <insert_vma_struct+0x26>
ffffffffc0202d40:	bfd1                	j	ffffffffc0202d14 <insert_vma_struct+0x3e>
ffffffffc0202d42:	ee3ff0ef          	jal	ffffffffc0202c24 <check_vma_overlap.part.0>
ffffffffc0202d46:	00004697          	auipc	a3,0x4
ffffffffc0202d4a:	ea268693          	add	a3,a3,-350 # ffffffffc0206be8 <default_pmm_manager+0x558>
ffffffffc0202d4e:	00003617          	auipc	a2,0x3
ffffffffc0202d52:	2aa60613          	add	a2,a2,682 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202d56:	07400593          	li	a1,116
ffffffffc0202d5a:	00004517          	auipc	a0,0x4
ffffffffc0202d5e:	e7e50513          	add	a0,a0,-386 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202d62:	f10fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202d66:	00004697          	auipc	a3,0x4
ffffffffc0202d6a:	ec268693          	add	a3,a3,-318 # ffffffffc0206c28 <default_pmm_manager+0x598>
ffffffffc0202d6e:	00003617          	auipc	a2,0x3
ffffffffc0202d72:	28a60613          	add	a2,a2,650 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202d76:	06c00593          	li	a1,108
ffffffffc0202d7a:	00004517          	auipc	a0,0x4
ffffffffc0202d7e:	e5e50513          	add	a0,a0,-418 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202d82:	ef0fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202d86:	00004697          	auipc	a3,0x4
ffffffffc0202d8a:	e8268693          	add	a3,a3,-382 # ffffffffc0206c08 <default_pmm_manager+0x578>
ffffffffc0202d8e:	00003617          	auipc	a2,0x3
ffffffffc0202d92:	26a60613          	add	a2,a2,618 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202d96:	06b00593          	li	a1,107
ffffffffc0202d9a:	00004517          	auipc	a0,0x4
ffffffffc0202d9e:	e3e50513          	add	a0,a0,-450 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202da2:	ed0fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202da6 <mm_destroy>:
ffffffffc0202da6:	591c                	lw	a5,48(a0)
ffffffffc0202da8:	1141                	add	sp,sp,-16
ffffffffc0202daa:	e406                	sd	ra,8(sp)
ffffffffc0202dac:	e022                	sd	s0,0(sp)
ffffffffc0202dae:	e78d                	bnez	a5,ffffffffc0202dd8 <mm_destroy+0x32>
ffffffffc0202db0:	842a                	mv	s0,a0
ffffffffc0202db2:	6508                	ld	a0,8(a0)
ffffffffc0202db4:	00a40c63          	beq	s0,a0,ffffffffc0202dcc <mm_destroy+0x26>
ffffffffc0202db8:	6118                	ld	a4,0(a0)
ffffffffc0202dba:	651c                	ld	a5,8(a0)
ffffffffc0202dbc:	1501                	add	a0,a0,-32
ffffffffc0202dbe:	e71c                	sd	a5,8(a4)
ffffffffc0202dc0:	e398                	sd	a4,0(a5)
ffffffffc0202dc2:	cbdfe0ef          	jal	ffffffffc0201a7e <kfree>
ffffffffc0202dc6:	6408                	ld	a0,8(s0)
ffffffffc0202dc8:	fea418e3          	bne	s0,a0,ffffffffc0202db8 <mm_destroy+0x12>
ffffffffc0202dcc:	8522                	mv	a0,s0
ffffffffc0202dce:	6402                	ld	s0,0(sp)
ffffffffc0202dd0:	60a2                	ld	ra,8(sp)
ffffffffc0202dd2:	0141                	add	sp,sp,16
ffffffffc0202dd4:	cabfe06f          	j	ffffffffc0201a7e <kfree>
ffffffffc0202dd8:	00004697          	auipc	a3,0x4
ffffffffc0202ddc:	e7068693          	add	a3,a3,-400 # ffffffffc0206c48 <default_pmm_manager+0x5b8>
ffffffffc0202de0:	00003617          	auipc	a2,0x3
ffffffffc0202de4:	21860613          	add	a2,a2,536 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202de8:	09400593          	li	a1,148
ffffffffc0202dec:	00004517          	auipc	a0,0x4
ffffffffc0202df0:	dec50513          	add	a0,a0,-532 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202df4:	e7efd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202df8 <mm_map>:
ffffffffc0202df8:	6785                	lui	a5,0x1
ffffffffc0202dfa:	17fd                	add	a5,a5,-1 # fff <kern_entry-0xffffffffc01ff001>
ffffffffc0202dfc:	7139                	add	sp,sp,-64
ffffffffc0202dfe:	787d                	lui	a6,0xfffff
ffffffffc0202e00:	963e                	add	a2,a2,a5
ffffffffc0202e02:	f822                	sd	s0,48(sp)
ffffffffc0202e04:	f426                	sd	s1,40(sp)
ffffffffc0202e06:	962e                	add	a2,a2,a1
ffffffffc0202e08:	fc06                	sd	ra,56(sp)
ffffffffc0202e0a:	f04a                	sd	s2,32(sp)
ffffffffc0202e0c:	ec4e                	sd	s3,24(sp)
ffffffffc0202e0e:	e852                	sd	s4,16(sp)
ffffffffc0202e10:	e456                	sd	s5,8(sp)
ffffffffc0202e12:	0105f4b3          	and	s1,a1,a6
ffffffffc0202e16:	002007b7          	lui	a5,0x200
ffffffffc0202e1a:	01067433          	and	s0,a2,a6
ffffffffc0202e1e:	06f4e363          	bltu	s1,a5,ffffffffc0202e84 <mm_map+0x8c>
ffffffffc0202e22:	0684f163          	bgeu	s1,s0,ffffffffc0202e84 <mm_map+0x8c>
ffffffffc0202e26:	4785                	li	a5,1
ffffffffc0202e28:	07fe                	sll	a5,a5,0x1f
ffffffffc0202e2a:	0487ed63          	bltu	a5,s0,ffffffffc0202e84 <mm_map+0x8c>
ffffffffc0202e2e:	89aa                	mv	s3,a0
ffffffffc0202e30:	cd21                	beqz	a0,ffffffffc0202e88 <mm_map+0x90>
ffffffffc0202e32:	85a6                	mv	a1,s1
ffffffffc0202e34:	8ab6                	mv	s5,a3
ffffffffc0202e36:	8a3a                	mv	s4,a4
ffffffffc0202e38:	e5fff0ef          	jal	ffffffffc0202c96 <find_vma>
ffffffffc0202e3c:	c501                	beqz	a0,ffffffffc0202e44 <mm_map+0x4c>
ffffffffc0202e3e:	651c                	ld	a5,8(a0)
ffffffffc0202e40:	0487e263          	bltu	a5,s0,ffffffffc0202e84 <mm_map+0x8c>
ffffffffc0202e44:	03000513          	li	a0,48
ffffffffc0202e48:	b97fe0ef          	jal	ffffffffc02019de <kmalloc>
ffffffffc0202e4c:	892a                	mv	s2,a0
ffffffffc0202e4e:	5571                	li	a0,-4
ffffffffc0202e50:	02090163          	beqz	s2,ffffffffc0202e72 <mm_map+0x7a>
ffffffffc0202e54:	00993423          	sd	s1,8(s2)
ffffffffc0202e58:	00893823          	sd	s0,16(s2)
ffffffffc0202e5c:	01592c23          	sw	s5,24(s2)
ffffffffc0202e60:	85ca                	mv	a1,s2
ffffffffc0202e62:	854e                	mv	a0,s3
ffffffffc0202e64:	e73ff0ef          	jal	ffffffffc0202cd6 <insert_vma_struct>
ffffffffc0202e68:	000a0463          	beqz	s4,ffffffffc0202e70 <mm_map+0x78>
ffffffffc0202e6c:	012a3023          	sd	s2,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202e70:	4501                	li	a0,0
ffffffffc0202e72:	70e2                	ld	ra,56(sp)
ffffffffc0202e74:	7442                	ld	s0,48(sp)
ffffffffc0202e76:	74a2                	ld	s1,40(sp)
ffffffffc0202e78:	7902                	ld	s2,32(sp)
ffffffffc0202e7a:	69e2                	ld	s3,24(sp)
ffffffffc0202e7c:	6a42                	ld	s4,16(sp)
ffffffffc0202e7e:	6aa2                	ld	s5,8(sp)
ffffffffc0202e80:	6121                	add	sp,sp,64
ffffffffc0202e82:	8082                	ret
ffffffffc0202e84:	5575                	li	a0,-3
ffffffffc0202e86:	b7f5                	j	ffffffffc0202e72 <mm_map+0x7a>
ffffffffc0202e88:	00004697          	auipc	a3,0x4
ffffffffc0202e8c:	dd868693          	add	a3,a3,-552 # ffffffffc0206c60 <default_pmm_manager+0x5d0>
ffffffffc0202e90:	00003617          	auipc	a2,0x3
ffffffffc0202e94:	16860613          	add	a2,a2,360 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202e98:	0a700593          	li	a1,167
ffffffffc0202e9c:	00004517          	auipc	a0,0x4
ffffffffc0202ea0:	d3c50513          	add	a0,a0,-708 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202ea4:	dcefd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202ea8 <dup_mmap>:
ffffffffc0202ea8:	7139                	add	sp,sp,-64
ffffffffc0202eaa:	fc06                	sd	ra,56(sp)
ffffffffc0202eac:	f822                	sd	s0,48(sp)
ffffffffc0202eae:	f426                	sd	s1,40(sp)
ffffffffc0202eb0:	f04a                	sd	s2,32(sp)
ffffffffc0202eb2:	ec4e                	sd	s3,24(sp)
ffffffffc0202eb4:	e852                	sd	s4,16(sp)
ffffffffc0202eb6:	e456                	sd	s5,8(sp)
ffffffffc0202eb8:	c525                	beqz	a0,ffffffffc0202f20 <dup_mmap+0x78>
ffffffffc0202eba:	892a                	mv	s2,a0
ffffffffc0202ebc:	84ae                	mv	s1,a1
ffffffffc0202ebe:	842e                	mv	s0,a1
ffffffffc0202ec0:	c1a5                	beqz	a1,ffffffffc0202f20 <dup_mmap+0x78>
ffffffffc0202ec2:	6000                	ld	s0,0(s0)
ffffffffc0202ec4:	04848c63          	beq	s1,s0,ffffffffc0202f1c <dup_mmap+0x74>
ffffffffc0202ec8:	03000513          	li	a0,48
ffffffffc0202ecc:	fe843a83          	ld	s5,-24(s0)
ffffffffc0202ed0:	ff043a03          	ld	s4,-16(s0)
ffffffffc0202ed4:	ff842983          	lw	s3,-8(s0)
ffffffffc0202ed8:	b07fe0ef          	jal	ffffffffc02019de <kmalloc>
ffffffffc0202edc:	85aa                	mv	a1,a0
ffffffffc0202ede:	c50d                	beqz	a0,ffffffffc0202f08 <dup_mmap+0x60>
ffffffffc0202ee0:	854a                	mv	a0,s2
ffffffffc0202ee2:	0155b423          	sd	s5,8(a1)
ffffffffc0202ee6:	0145b823          	sd	s4,16(a1)
ffffffffc0202eea:	0135ac23          	sw	s3,24(a1)
ffffffffc0202eee:	de9ff0ef          	jal	ffffffffc0202cd6 <insert_vma_struct>
ffffffffc0202ef2:	ff043683          	ld	a3,-16(s0)
ffffffffc0202ef6:	fe843603          	ld	a2,-24(s0)
ffffffffc0202efa:	6c8c                	ld	a1,24(s1)
ffffffffc0202efc:	01893503          	ld	a0,24(s2)
ffffffffc0202f00:	4701                	li	a4,0
ffffffffc0202f02:	c24ff0ef          	jal	ffffffffc0202326 <copy_range>
ffffffffc0202f06:	dd55                	beqz	a0,ffffffffc0202ec2 <dup_mmap+0x1a>
ffffffffc0202f08:	5571                	li	a0,-4
ffffffffc0202f0a:	70e2                	ld	ra,56(sp)
ffffffffc0202f0c:	7442                	ld	s0,48(sp)
ffffffffc0202f0e:	74a2                	ld	s1,40(sp)
ffffffffc0202f10:	7902                	ld	s2,32(sp)
ffffffffc0202f12:	69e2                	ld	s3,24(sp)
ffffffffc0202f14:	6a42                	ld	s4,16(sp)
ffffffffc0202f16:	6aa2                	ld	s5,8(sp)
ffffffffc0202f18:	6121                	add	sp,sp,64
ffffffffc0202f1a:	8082                	ret
ffffffffc0202f1c:	4501                	li	a0,0
ffffffffc0202f1e:	b7f5                	j	ffffffffc0202f0a <dup_mmap+0x62>
ffffffffc0202f20:	00004697          	auipc	a3,0x4
ffffffffc0202f24:	d5068693          	add	a3,a3,-688 # ffffffffc0206c70 <default_pmm_manager+0x5e0>
ffffffffc0202f28:	00003617          	auipc	a2,0x3
ffffffffc0202f2c:	0d060613          	add	a2,a2,208 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202f30:	0c000593          	li	a1,192
ffffffffc0202f34:	00004517          	auipc	a0,0x4
ffffffffc0202f38:	ca450513          	add	a0,a0,-860 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202f3c:	d36fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202f40 <exit_mmap>:
ffffffffc0202f40:	1101                	add	sp,sp,-32
ffffffffc0202f42:	ec06                	sd	ra,24(sp)
ffffffffc0202f44:	e822                	sd	s0,16(sp)
ffffffffc0202f46:	e426                	sd	s1,8(sp)
ffffffffc0202f48:	e04a                	sd	s2,0(sp)
ffffffffc0202f4a:	c531                	beqz	a0,ffffffffc0202f96 <exit_mmap+0x56>
ffffffffc0202f4c:	591c                	lw	a5,48(a0)
ffffffffc0202f4e:	84aa                	mv	s1,a0
ffffffffc0202f50:	e3b9                	bnez	a5,ffffffffc0202f96 <exit_mmap+0x56>
ffffffffc0202f52:	6500                	ld	s0,8(a0)
ffffffffc0202f54:	01853903          	ld	s2,24(a0)
ffffffffc0202f58:	02850663          	beq	a0,s0,ffffffffc0202f84 <exit_mmap+0x44>
ffffffffc0202f5c:	ff043603          	ld	a2,-16(s0)
ffffffffc0202f60:	fe843583          	ld	a1,-24(s0)
ffffffffc0202f64:	854a                	mv	a0,s2
ffffffffc0202f66:	862ff0ef          	jal	ffffffffc0201fc8 <unmap_range>
ffffffffc0202f6a:	6400                	ld	s0,8(s0)
ffffffffc0202f6c:	fe8498e3          	bne	s1,s0,ffffffffc0202f5c <exit_mmap+0x1c>
ffffffffc0202f70:	6400                	ld	s0,8(s0)
ffffffffc0202f72:	00848c63          	beq	s1,s0,ffffffffc0202f8a <exit_mmap+0x4a>
ffffffffc0202f76:	ff043603          	ld	a2,-16(s0)
ffffffffc0202f7a:	fe843583          	ld	a1,-24(s0)
ffffffffc0202f7e:	854a                	mv	a0,s2
ffffffffc0202f80:	976ff0ef          	jal	ffffffffc02020f6 <exit_range>
ffffffffc0202f84:	6400                	ld	s0,8(s0)
ffffffffc0202f86:	fe8498e3          	bne	s1,s0,ffffffffc0202f76 <exit_mmap+0x36>
ffffffffc0202f8a:	60e2                	ld	ra,24(sp)
ffffffffc0202f8c:	6442                	ld	s0,16(sp)
ffffffffc0202f8e:	64a2                	ld	s1,8(sp)
ffffffffc0202f90:	6902                	ld	s2,0(sp)
ffffffffc0202f92:	6105                	add	sp,sp,32
ffffffffc0202f94:	8082                	ret
ffffffffc0202f96:	00004697          	auipc	a3,0x4
ffffffffc0202f9a:	cfa68693          	add	a3,a3,-774 # ffffffffc0206c90 <default_pmm_manager+0x600>
ffffffffc0202f9e:	00003617          	auipc	a2,0x3
ffffffffc0202fa2:	05a60613          	add	a2,a2,90 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0202fa6:	0d600593          	li	a1,214
ffffffffc0202faa:	00004517          	auipc	a0,0x4
ffffffffc0202fae:	c2e50513          	add	a0,a0,-978 # ffffffffc0206bd8 <default_pmm_manager+0x548>
ffffffffc0202fb2:	cc0fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202fb6 <vmm_init>:
ffffffffc0202fb6:	8082                	ret

ffffffffc0202fb8 <do_pgfault>:
ffffffffc0202fb8:	7139                	add	sp,sp,-64
ffffffffc0202fba:	85b2                	mv	a1,a2
ffffffffc0202fbc:	f822                	sd	s0,48(sp)
ffffffffc0202fbe:	f426                	sd	s1,40(sp)
ffffffffc0202fc0:	fc06                	sd	ra,56(sp)
ffffffffc0202fc2:	f04a                	sd	s2,32(sp)
ffffffffc0202fc4:	ec4e                	sd	s3,24(sp)
ffffffffc0202fc6:	8432                	mv	s0,a2
ffffffffc0202fc8:	84aa                	mv	s1,a0
ffffffffc0202fca:	ccdff0ef          	jal	ffffffffc0202c96 <find_vma>
ffffffffc0202fce:	00014797          	auipc	a5,0x14
ffffffffc0202fd2:	6727a783          	lw	a5,1650(a5) # ffffffffc0217640 <pgfault_num>
ffffffffc0202fd6:	2785                	addw	a5,a5,1
ffffffffc0202fd8:	00014717          	auipc	a4,0x14
ffffffffc0202fdc:	66f72423          	sw	a5,1640(a4) # ffffffffc0217640 <pgfault_num>
ffffffffc0202fe0:	c545                	beqz	a0,ffffffffc0203088 <do_pgfault+0xd0>
ffffffffc0202fe2:	651c                	ld	a5,8(a0)
ffffffffc0202fe4:	0af46263          	bltu	s0,a5,ffffffffc0203088 <do_pgfault+0xd0>
ffffffffc0202fe8:	4d1c                	lw	a5,24(a0)
ffffffffc0202fea:	49dd                	li	s3,23
ffffffffc0202fec:	8b89                	and	a5,a5,2
ffffffffc0202fee:	cfb9                	beqz	a5,ffffffffc020304c <do_pgfault+0x94>
ffffffffc0202ff0:	77fd                	lui	a5,0xfffff
ffffffffc0202ff2:	6c88                	ld	a0,24(s1)
ffffffffc0202ff4:	8c7d                	and	s0,s0,a5
ffffffffc0202ff6:	4605                	li	a2,1
ffffffffc0202ff8:	85a2                	mv	a1,s0
ffffffffc0202ffa:	dfffe0ef          	jal	ffffffffc0201df8 <get_pte>
ffffffffc0202ffe:	c555                	beqz	a0,ffffffffc02030aa <do_pgfault+0xf2>
ffffffffc0203000:	610c                	ld	a1,0(a0)
ffffffffc0203002:	c5ad                	beqz	a1,ffffffffc020306c <do_pgfault+0xb4>
ffffffffc0203004:	00014797          	auipc	a5,0x14
ffffffffc0203008:	6247a783          	lw	a5,1572(a5) # ffffffffc0217628 <swap_init_ok>
ffffffffc020300c:	c7d9                	beqz	a5,ffffffffc020309a <do_pgfault+0xe2>
ffffffffc020300e:	0030                	add	a2,sp,8
ffffffffc0203010:	85a2                	mv	a1,s0
ffffffffc0203012:	8526                	mv	a0,s1
ffffffffc0203014:	e402                	sd	zero,8(sp)
ffffffffc0203016:	fb2ff0ef          	jal	ffffffffc02027c8 <swap_in>
ffffffffc020301a:	892a                	mv	s2,a0
ffffffffc020301c:	e915                	bnez	a0,ffffffffc0203050 <do_pgfault+0x98>
ffffffffc020301e:	65a2                	ld	a1,8(sp)
ffffffffc0203020:	6c88                	ld	a0,24(s1)
ffffffffc0203022:	86ce                	mv	a3,s3
ffffffffc0203024:	8622                	mv	a2,s0
ffffffffc0203026:	a08ff0ef          	jal	ffffffffc020222e <page_insert>
ffffffffc020302a:	6622                	ld	a2,8(sp)
ffffffffc020302c:	4685                	li	a3,1
ffffffffc020302e:	85a2                	mv	a1,s0
ffffffffc0203030:	8526                	mv	a0,s1
ffffffffc0203032:	e76ff0ef          	jal	ffffffffc02026a8 <swap_map_swappable>
ffffffffc0203036:	67a2                	ld	a5,8(sp)
ffffffffc0203038:	ff80                	sd	s0,56(a5)
ffffffffc020303a:	4901                	li	s2,0
ffffffffc020303c:	70e2                	ld	ra,56(sp)
ffffffffc020303e:	7442                	ld	s0,48(sp)
ffffffffc0203040:	74a2                	ld	s1,40(sp)
ffffffffc0203042:	69e2                	ld	s3,24(sp)
ffffffffc0203044:	854a                	mv	a0,s2
ffffffffc0203046:	7902                	ld	s2,32(sp)
ffffffffc0203048:	6121                	add	sp,sp,64
ffffffffc020304a:	8082                	ret
ffffffffc020304c:	49c1                	li	s3,16
ffffffffc020304e:	b74d                	j	ffffffffc0202ff0 <do_pgfault+0x38>
ffffffffc0203050:	00004517          	auipc	a0,0x4
ffffffffc0203054:	cd850513          	add	a0,a0,-808 # ffffffffc0206d28 <default_pmm_manager+0x698>
ffffffffc0203058:	932fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020305c:	70e2                	ld	ra,56(sp)
ffffffffc020305e:	7442                	ld	s0,48(sp)
ffffffffc0203060:	74a2                	ld	s1,40(sp)
ffffffffc0203062:	69e2                	ld	s3,24(sp)
ffffffffc0203064:	854a                	mv	a0,s2
ffffffffc0203066:	7902                	ld	s2,32(sp)
ffffffffc0203068:	6121                	add	sp,sp,64
ffffffffc020306a:	8082                	ret
ffffffffc020306c:	6c88                	ld	a0,24(s1)
ffffffffc020306e:	864e                	mv	a2,s3
ffffffffc0203070:	85a2                	mv	a1,s0
ffffffffc0203072:	ceaff0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0203076:	f171                	bnez	a0,ffffffffc020303a <do_pgfault+0x82>
ffffffffc0203078:	00004517          	auipc	a0,0x4
ffffffffc020307c:	c8850513          	add	a0,a0,-888 # ffffffffc0206d00 <default_pmm_manager+0x670>
ffffffffc0203080:	90afd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203084:	5971                	li	s2,-4
ffffffffc0203086:	bf5d                	j	ffffffffc020303c <do_pgfault+0x84>
ffffffffc0203088:	85a2                	mv	a1,s0
ffffffffc020308a:	00004517          	auipc	a0,0x4
ffffffffc020308e:	c2650513          	add	a0,a0,-986 # ffffffffc0206cb0 <default_pmm_manager+0x620>
ffffffffc0203092:	8f8fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203096:	5975                	li	s2,-3
ffffffffc0203098:	b755                	j	ffffffffc020303c <do_pgfault+0x84>
ffffffffc020309a:	00004517          	auipc	a0,0x4
ffffffffc020309e:	cae50513          	add	a0,a0,-850 # ffffffffc0206d48 <default_pmm_manager+0x6b8>
ffffffffc02030a2:	8e8fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02030a6:	5971                	li	s2,-4
ffffffffc02030a8:	bf51                	j	ffffffffc020303c <do_pgfault+0x84>
ffffffffc02030aa:	00004517          	auipc	a0,0x4
ffffffffc02030ae:	c3650513          	add	a0,a0,-970 # ffffffffc0206ce0 <default_pmm_manager+0x650>
ffffffffc02030b2:	8d8fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02030b6:	5971                	li	s2,-4
ffffffffc02030b8:	b751                	j	ffffffffc020303c <do_pgfault+0x84>

ffffffffc02030ba <user_mem_check>:
ffffffffc02030ba:	7179                	add	sp,sp,-48
ffffffffc02030bc:	f022                	sd	s0,32(sp)
ffffffffc02030be:	f406                	sd	ra,40(sp)
ffffffffc02030c0:	ec26                	sd	s1,24(sp)
ffffffffc02030c2:	e84a                	sd	s2,16(sp)
ffffffffc02030c4:	e44e                	sd	s3,8(sp)
ffffffffc02030c6:	e052                	sd	s4,0(sp)
ffffffffc02030c8:	842e                	mv	s0,a1
ffffffffc02030ca:	c135                	beqz	a0,ffffffffc020312e <user_mem_check+0x74>
ffffffffc02030cc:	002007b7          	lui	a5,0x200
ffffffffc02030d0:	04f5e663          	bltu	a1,a5,ffffffffc020311c <user_mem_check+0x62>
ffffffffc02030d4:	00c584b3          	add	s1,a1,a2
ffffffffc02030d8:	0495f263          	bgeu	a1,s1,ffffffffc020311c <user_mem_check+0x62>
ffffffffc02030dc:	4785                	li	a5,1
ffffffffc02030de:	07fe                	sll	a5,a5,0x1f
ffffffffc02030e0:	0297ee63          	bltu	a5,s1,ffffffffc020311c <user_mem_check+0x62>
ffffffffc02030e4:	892a                	mv	s2,a0
ffffffffc02030e6:	89b6                	mv	s3,a3
ffffffffc02030e8:	6a05                	lui	s4,0x1
ffffffffc02030ea:	a821                	j	ffffffffc0203102 <user_mem_check+0x48>
ffffffffc02030ec:	0027f693          	and	a3,a5,2
ffffffffc02030f0:	9752                	add	a4,a4,s4
ffffffffc02030f2:	8ba1                	and	a5,a5,8
ffffffffc02030f4:	c685                	beqz	a3,ffffffffc020311c <user_mem_check+0x62>
ffffffffc02030f6:	c399                	beqz	a5,ffffffffc02030fc <user_mem_check+0x42>
ffffffffc02030f8:	02e46263          	bltu	s0,a4,ffffffffc020311c <user_mem_check+0x62>
ffffffffc02030fc:	6900                	ld	s0,16(a0)
ffffffffc02030fe:	04947663          	bgeu	s0,s1,ffffffffc020314a <user_mem_check+0x90>
ffffffffc0203102:	85a2                	mv	a1,s0
ffffffffc0203104:	854a                	mv	a0,s2
ffffffffc0203106:	b91ff0ef          	jal	ffffffffc0202c96 <find_vma>
ffffffffc020310a:	c909                	beqz	a0,ffffffffc020311c <user_mem_check+0x62>
ffffffffc020310c:	6518                	ld	a4,8(a0)
ffffffffc020310e:	00e46763          	bltu	s0,a4,ffffffffc020311c <user_mem_check+0x62>
ffffffffc0203112:	4d1c                	lw	a5,24(a0)
ffffffffc0203114:	fc099ce3          	bnez	s3,ffffffffc02030ec <user_mem_check+0x32>
ffffffffc0203118:	8b85                	and	a5,a5,1
ffffffffc020311a:	f3ed                	bnez	a5,ffffffffc02030fc <user_mem_check+0x42>
ffffffffc020311c:	4501                	li	a0,0
ffffffffc020311e:	70a2                	ld	ra,40(sp)
ffffffffc0203120:	7402                	ld	s0,32(sp)
ffffffffc0203122:	64e2                	ld	s1,24(sp)
ffffffffc0203124:	6942                	ld	s2,16(sp)
ffffffffc0203126:	69a2                	ld	s3,8(sp)
ffffffffc0203128:	6a02                	ld	s4,0(sp)
ffffffffc020312a:	6145                	add	sp,sp,48
ffffffffc020312c:	8082                	ret
ffffffffc020312e:	c02007b7          	lui	a5,0xc0200
ffffffffc0203132:	4501                	li	a0,0
ffffffffc0203134:	fef5e5e3          	bltu	a1,a5,ffffffffc020311e <user_mem_check+0x64>
ffffffffc0203138:	962e                	add	a2,a2,a1
ffffffffc020313a:	fec5f2e3          	bgeu	a1,a2,ffffffffc020311e <user_mem_check+0x64>
ffffffffc020313e:	c8000537          	lui	a0,0xc8000
ffffffffc0203142:	0505                	add	a0,a0,1 # ffffffffc8000001 <end+0x7de8981>
ffffffffc0203144:	00a63533          	sltu	a0,a2,a0
ffffffffc0203148:	bfd9                	j	ffffffffc020311e <user_mem_check+0x64>
ffffffffc020314a:	4505                	li	a0,1
ffffffffc020314c:	bfc9                	j	ffffffffc020311e <user_mem_check+0x64>

ffffffffc020314e <phi_test_sema>:
ffffffffc020314e:	00251713          	sll	a4,a0,0x2
ffffffffc0203152:	00010797          	auipc	a5,0x10
ffffffffc0203156:	43678793          	add	a5,a5,1078 # ffffffffc0213588 <state_sema>
ffffffffc020315a:	97ba                	add	a5,a5,a4
ffffffffc020315c:	4394                	lw	a3,0(a5)
ffffffffc020315e:	4705                	li	a4,1
ffffffffc0203160:	00e68363          	beq	a3,a4,ffffffffc0203166 <phi_test_sema+0x18>
ffffffffc0203164:	8082                	ret
ffffffffc0203166:	0015071b          	addw	a4,a0,1
ffffffffc020316a:	4615                	li	a2,5
ffffffffc020316c:	02c7673b          	remw	a4,a4,a2
ffffffffc0203170:	00010697          	auipc	a3,0x10
ffffffffc0203174:	40068693          	add	a3,a3,1024 # ffffffffc0213570 <request>
ffffffffc0203178:	070a                	sll	a4,a4,0x2
ffffffffc020317a:	9736                	add	a4,a4,a3
ffffffffc020317c:	4318                	lw	a4,0(a4)
ffffffffc020317e:	cb09                	beqz	a4,ffffffffc0203190 <phi_test_sema+0x42>
ffffffffc0203180:	2511                	addw	a0,a0,4
ffffffffc0203182:	02c5653b          	remw	a0,a0,a2
ffffffffc0203186:	00251713          	sll	a4,a0,0x2
ffffffffc020318a:	96ba                	add	a3,a3,a4
ffffffffc020318c:	4298                	lw	a4,0(a3)
ffffffffc020318e:	fb79                	bnez	a4,ffffffffc0203164 <phi_test_sema+0x16>
ffffffffc0203190:	00151713          	sll	a4,a0,0x1
ffffffffc0203194:	972a                	add	a4,a4,a0
ffffffffc0203196:	070e                	sll	a4,a4,0x3
ffffffffc0203198:	00010517          	auipc	a0,0x10
ffffffffc020319c:	34850513          	add	a0,a0,840 # ffffffffc02134e0 <s>
ffffffffc02031a0:	953a                	add	a0,a0,a4
ffffffffc02031a2:	4709                	li	a4,2
ffffffffc02031a4:	c398                	sw	a4,0(a5)
ffffffffc02031a6:	a4d5                	j	ffffffffc020348a <up>

ffffffffc02031a8 <philosopher_using_semaphore>:
ffffffffc02031a8:	711d                	add	sp,sp,-96
ffffffffc02031aa:	e8a2                	sd	s0,80(sp)
ffffffffc02031ac:	0005041b          	sext.w	s0,a0
ffffffffc02031b0:	85a2                	mv	a1,s0
ffffffffc02031b2:	00004517          	auipc	a0,0x4
ffffffffc02031b6:	bbe50513          	add	a0,a0,-1090 # ffffffffc0206d70 <default_pmm_manager+0x6e0>
ffffffffc02031ba:	e4a6                	sd	s1,72(sp)
ffffffffc02031bc:	e0ca                	sd	s2,64(sp)
ffffffffc02031be:	fc4e                	sd	s3,56(sp)
ffffffffc02031c0:	f852                	sd	s4,48(sp)
ffffffffc02031c2:	f456                	sd	s5,40(sp)
ffffffffc02031c4:	f05a                	sd	s6,32(sp)
ffffffffc02031c6:	ec5e                	sd	s7,24(sp)
ffffffffc02031c8:	e862                	sd	s8,16(sp)
ffffffffc02031ca:	e466                	sd	s9,8(sp)
ffffffffc02031cc:	e06a                	sd	s10,0(sp)
ffffffffc02031ce:	ec86                	sd	ra,88(sp)
ffffffffc02031d0:	fbbfc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02031d4:	4795                	li	a5,5
ffffffffc02031d6:	00440b1b          	addw	s6,s0,4
ffffffffc02031da:	00140a9b          	addw	s5,s0,1
ffffffffc02031de:	02fb6b3b          	remw	s6,s6,a5
ffffffffc02031e2:	00141a13          	sll	s4,s0,0x1
ffffffffc02031e6:	9a22                	add	s4,s4,s0
ffffffffc02031e8:	0a0e                	sll	s4,s4,0x3
ffffffffc02031ea:	00241713          	sll	a4,s0,0x2
ffffffffc02031ee:	00010697          	auipc	a3,0x10
ffffffffc02031f2:	2f268693          	add	a3,a3,754 # ffffffffc02134e0 <s>
ffffffffc02031f6:	00010997          	auipc	s3,0x10
ffffffffc02031fa:	39298993          	add	s3,s3,914 # ffffffffc0213588 <state_sema>
ffffffffc02031fe:	9a36                	add	s4,s4,a3
ffffffffc0203200:	4485                	li	s1,1
ffffffffc0203202:	00004d17          	auipc	s10,0x4
ffffffffc0203206:	b8ed0d13          	add	s10,s10,-1138 # ffffffffc0206d90 <default_pmm_manager+0x700>
ffffffffc020320a:	00010917          	auipc	s2,0x10
ffffffffc020320e:	34e90913          	add	s2,s2,846 # ffffffffc0213558 <mutex>
ffffffffc0203212:	99ba                	add	s3,s3,a4
ffffffffc0203214:	4c85                	li	s9,1
ffffffffc0203216:	00004c17          	auipc	s8,0x4
ffffffffc020321a:	baac0c13          	add	s8,s8,-1110 # ffffffffc0206dc0 <default_pmm_manager+0x730>
ffffffffc020321e:	4b95                	li	s7,5
ffffffffc0203220:	02faeabb          	remw	s5,s5,a5
ffffffffc0203224:	85a6                	mv	a1,s1
ffffffffc0203226:	8622                	mv	a2,s0
ffffffffc0203228:	856a                	mv	a0,s10
ffffffffc020322a:	f61fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020322e:	4529                	li	a0,10
ffffffffc0203230:	6f8010ef          	jal	ffffffffc0204928 <do_sleep>
ffffffffc0203234:	854a                	mv	a0,s2
ffffffffc0203236:	256000ef          	jal	ffffffffc020348c <down>
ffffffffc020323a:	8522                	mv	a0,s0
ffffffffc020323c:	0199a023          	sw	s9,0(s3)
ffffffffc0203240:	f0fff0ef          	jal	ffffffffc020314e <phi_test_sema>
ffffffffc0203244:	854a                	mv	a0,s2
ffffffffc0203246:	244000ef          	jal	ffffffffc020348a <up>
ffffffffc020324a:	8552                	mv	a0,s4
ffffffffc020324c:	240000ef          	jal	ffffffffc020348c <down>
ffffffffc0203250:	85a6                	mv	a1,s1
ffffffffc0203252:	8622                	mv	a2,s0
ffffffffc0203254:	8562                	mv	a0,s8
ffffffffc0203256:	f35fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020325a:	4529                	li	a0,10
ffffffffc020325c:	6cc010ef          	jal	ffffffffc0204928 <do_sleep>
ffffffffc0203260:	854a                	mv	a0,s2
ffffffffc0203262:	22a000ef          	jal	ffffffffc020348c <down>
ffffffffc0203266:	855a                	mv	a0,s6
ffffffffc0203268:	0009a023          	sw	zero,0(s3)
ffffffffc020326c:	ee3ff0ef          	jal	ffffffffc020314e <phi_test_sema>
ffffffffc0203270:	8556                	mv	a0,s5
ffffffffc0203272:	eddff0ef          	jal	ffffffffc020314e <phi_test_sema>
ffffffffc0203276:	2485                	addw	s1,s1,1
ffffffffc0203278:	854a                	mv	a0,s2
ffffffffc020327a:	210000ef          	jal	ffffffffc020348a <up>
ffffffffc020327e:	fb7493e3          	bne	s1,s7,ffffffffc0203224 <philosopher_using_semaphore+0x7c>
ffffffffc0203282:	85a2                	mv	a1,s0
ffffffffc0203284:	00004517          	auipc	a0,0x4
ffffffffc0203288:	b6c50513          	add	a0,a0,-1172 # ffffffffc0206df0 <default_pmm_manager+0x760>
ffffffffc020328c:	efffc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203290:	60e6                	ld	ra,88(sp)
ffffffffc0203292:	6446                	ld	s0,80(sp)
ffffffffc0203294:	64a6                	ld	s1,72(sp)
ffffffffc0203296:	6906                	ld	s2,64(sp)
ffffffffc0203298:	79e2                	ld	s3,56(sp)
ffffffffc020329a:	7a42                	ld	s4,48(sp)
ffffffffc020329c:	7aa2                	ld	s5,40(sp)
ffffffffc020329e:	7b02                	ld	s6,32(sp)
ffffffffc02032a0:	6be2                	ld	s7,24(sp)
ffffffffc02032a2:	6c42                	ld	s8,16(sp)
ffffffffc02032a4:	6ca2                	ld	s9,8(sp)
ffffffffc02032a6:	6d02                	ld	s10,0(sp)
ffffffffc02032a8:	4501                	li	a0,0
ffffffffc02032aa:	6125                	add	sp,sp,96
ffffffffc02032ac:	8082                	ret

ffffffffc02032ae <check_sync>:
ffffffffc02032ae:	7139                	add	sp,sp,-64
ffffffffc02032b0:	4585                	li	a1,1
ffffffffc02032b2:	00010517          	auipc	a0,0x10
ffffffffc02032b6:	2a650513          	add	a0,a0,678 # ffffffffc0213558 <mutex>
ffffffffc02032ba:	f822                	sd	s0,48(sp)
ffffffffc02032bc:	f426                	sd	s1,40(sp)
ffffffffc02032be:	f04a                	sd	s2,32(sp)
ffffffffc02032c0:	ec4e                	sd	s3,24(sp)
ffffffffc02032c2:	e852                	sd	s4,16(sp)
ffffffffc02032c4:	e456                	sd	s5,8(sp)
ffffffffc02032c6:	fc06                	sd	ra,56(sp)
ffffffffc02032c8:	00010917          	auipc	s2,0x10
ffffffffc02032cc:	21890913          	add	s2,s2,536 # ffffffffc02134e0 <s>
ffffffffc02032d0:	1b4000ef          	jal	ffffffffc0203484 <sem_init>
ffffffffc02032d4:	00010497          	auipc	s1,0x10
ffffffffc02032d8:	1e448493          	add	s1,s1,484 # ffffffffc02134b8 <philosopher_proc_sema>
ffffffffc02032dc:	4401                	li	s0,0
ffffffffc02032de:	00000a97          	auipc	s5,0x0
ffffffffc02032e2:	ecaa8a93          	add	s5,s5,-310 # ffffffffc02031a8 <philosopher_using_semaphore>
ffffffffc02032e6:	00004a17          	auipc	s4,0x4
ffffffffc02032ea:	b7aa0a13          	add	s4,s4,-1158 # ffffffffc0206e60 <default_pmm_manager+0x7d0>
ffffffffc02032ee:	4995                	li	s3,5
ffffffffc02032f0:	4585                	li	a1,1
ffffffffc02032f2:	854a                	mv	a0,s2
ffffffffc02032f4:	190000ef          	jal	ffffffffc0203484 <sem_init>
ffffffffc02032f8:	4601                	li	a2,0
ffffffffc02032fa:	85a2                	mv	a1,s0
ffffffffc02032fc:	8556                	mv	a0,s5
ffffffffc02032fe:	1e1000ef          	jal	ffffffffc0203cde <kernel_thread>
ffffffffc0203302:	02a05663          	blez	a0,ffffffffc020332e <check_sync+0x80>
ffffffffc0203306:	5a2000ef          	jal	ffffffffc02038a8 <find_proc>
ffffffffc020330a:	e088                	sd	a0,0(s1)
ffffffffc020330c:	85d2                	mv	a1,s4
ffffffffc020330e:	0405                	add	s0,s0,1
ffffffffc0203310:	0961                	add	s2,s2,24
ffffffffc0203312:	500000ef          	jal	ffffffffc0203812 <set_proc_name>
ffffffffc0203316:	04a1                	add	s1,s1,8
ffffffffc0203318:	fd341ce3          	bne	s0,s3,ffffffffc02032f0 <check_sync+0x42>
ffffffffc020331c:	70e2                	ld	ra,56(sp)
ffffffffc020331e:	7442                	ld	s0,48(sp)
ffffffffc0203320:	74a2                	ld	s1,40(sp)
ffffffffc0203322:	7902                	ld	s2,32(sp)
ffffffffc0203324:	69e2                	ld	s3,24(sp)
ffffffffc0203326:	6a42                	ld	s4,16(sp)
ffffffffc0203328:	6aa2                	ld	s5,8(sp)
ffffffffc020332a:	6121                	add	sp,sp,64
ffffffffc020332c:	8082                	ret
ffffffffc020332e:	00004617          	auipc	a2,0x4
ffffffffc0203332:	ae260613          	add	a2,a2,-1310 # ffffffffc0206e10 <default_pmm_manager+0x780>
ffffffffc0203336:	06700593          	li	a1,103
ffffffffc020333a:	00004517          	auipc	a0,0x4
ffffffffc020333e:	b0e50513          	add	a0,a0,-1266 # ffffffffc0206e48 <default_pmm_manager+0x7b8>
ffffffffc0203342:	930fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203346 <__down.constprop.0>:
ffffffffc0203346:	715d                	add	sp,sp,-80
ffffffffc0203348:	e0a2                	sd	s0,64(sp)
ffffffffc020334a:	e486                	sd	ra,72(sp)
ffffffffc020334c:	fc26                	sd	s1,56(sp)
ffffffffc020334e:	842a                	mv	s0,a0
ffffffffc0203350:	100027f3          	csrr	a5,sstatus
ffffffffc0203354:	8b89                	and	a5,a5,2
ffffffffc0203356:	eba9                	bnez	a5,ffffffffc02033a8 <__down.constprop.0+0x62>
ffffffffc0203358:	411c                	lw	a5,0(a0)
ffffffffc020335a:	00f05a63          	blez	a5,ffffffffc020336e <__down.constprop.0+0x28>
ffffffffc020335e:	37fd                	addw	a5,a5,-1
ffffffffc0203360:	c11c                	sw	a5,0(a0)
ffffffffc0203362:	4501                	li	a0,0
ffffffffc0203364:	60a6                	ld	ra,72(sp)
ffffffffc0203366:	6406                	ld	s0,64(sp)
ffffffffc0203368:	74e2                	ld	s1,56(sp)
ffffffffc020336a:	6161                	add	sp,sp,80
ffffffffc020336c:	8082                	ret
ffffffffc020336e:	00850413          	add	s0,a0,8
ffffffffc0203372:	0024                	add	s1,sp,8
ffffffffc0203374:	10000613          	li	a2,256
ffffffffc0203378:	85a6                	mv	a1,s1
ffffffffc020337a:	8522                	mv	a0,s0
ffffffffc020337c:	1f2000ef          	jal	ffffffffc020356e <wait_current_set>
ffffffffc0203380:	4df010ef          	jal	ffffffffc020505e <schedule>
ffffffffc0203384:	100027f3          	csrr	a5,sstatus
ffffffffc0203388:	8b89                	and	a5,a5,2
ffffffffc020338a:	ebb1                	bnez	a5,ffffffffc02033de <__down.constprop.0+0x98>
ffffffffc020338c:	8526                	mv	a0,s1
ffffffffc020338e:	184000ef          	jal	ffffffffc0203512 <wait_in_queue>
ffffffffc0203392:	e129                	bnez	a0,ffffffffc02033d4 <__down.constprop.0+0x8e>
ffffffffc0203394:	4542                	lw	a0,16(sp)
ffffffffc0203396:	10000793          	li	a5,256
ffffffffc020339a:	fcf504e3          	beq	a0,a5,ffffffffc0203362 <__down.constprop.0+0x1c>
ffffffffc020339e:	60a6                	ld	ra,72(sp)
ffffffffc02033a0:	6406                	ld	s0,64(sp)
ffffffffc02033a2:	74e2                	ld	s1,56(sp)
ffffffffc02033a4:	6161                	add	sp,sp,80
ffffffffc02033a6:	8082                	ret
ffffffffc02033a8:	a8cfd0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02033ac:	401c                	lw	a5,0(s0)
ffffffffc02033ae:	00f05863          	blez	a5,ffffffffc02033be <__down.constprop.0+0x78>
ffffffffc02033b2:	37fd                	addw	a5,a5,-1
ffffffffc02033b4:	c01c                	sw	a5,0(s0)
ffffffffc02033b6:	a78fd0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02033ba:	4501                	li	a0,0
ffffffffc02033bc:	b765                	j	ffffffffc0203364 <__down.constprop.0+0x1e>
ffffffffc02033be:	0421                	add	s0,s0,8
ffffffffc02033c0:	0024                	add	s1,sp,8
ffffffffc02033c2:	10000613          	li	a2,256
ffffffffc02033c6:	85a6                	mv	a1,s1
ffffffffc02033c8:	8522                	mv	a0,s0
ffffffffc02033ca:	1a4000ef          	jal	ffffffffc020356e <wait_current_set>
ffffffffc02033ce:	a60fd0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02033d2:	b77d                	j	ffffffffc0203380 <__down.constprop.0+0x3a>
ffffffffc02033d4:	85a6                	mv	a1,s1
ffffffffc02033d6:	8522                	mv	a0,s0
ffffffffc02033d8:	0ec000ef          	jal	ffffffffc02034c4 <wait_queue_del>
ffffffffc02033dc:	bf65                	j	ffffffffc0203394 <__down.constprop.0+0x4e>
ffffffffc02033de:	a56fd0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02033e2:	8526                	mv	a0,s1
ffffffffc02033e4:	12e000ef          	jal	ffffffffc0203512 <wait_in_queue>
ffffffffc02033e8:	e501                	bnez	a0,ffffffffc02033f0 <__down.constprop.0+0xaa>
ffffffffc02033ea:	a44fd0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02033ee:	b75d                	j	ffffffffc0203394 <__down.constprop.0+0x4e>
ffffffffc02033f0:	85a6                	mv	a1,s1
ffffffffc02033f2:	8522                	mv	a0,s0
ffffffffc02033f4:	0d0000ef          	jal	ffffffffc02034c4 <wait_queue_del>
ffffffffc02033f8:	bfcd                	j	ffffffffc02033ea <__down.constprop.0+0xa4>

ffffffffc02033fa <__up.constprop.0>:
ffffffffc02033fa:	1101                	add	sp,sp,-32
ffffffffc02033fc:	e822                	sd	s0,16(sp)
ffffffffc02033fe:	ec06                	sd	ra,24(sp)
ffffffffc0203400:	e426                	sd	s1,8(sp)
ffffffffc0203402:	e04a                	sd	s2,0(sp)
ffffffffc0203404:	842a                	mv	s0,a0
ffffffffc0203406:	100027f3          	csrr	a5,sstatus
ffffffffc020340a:	8b89                	and	a5,a5,2
ffffffffc020340c:	4901                	li	s2,0
ffffffffc020340e:	eba1                	bnez	a5,ffffffffc020345e <__up.constprop.0+0x64>
ffffffffc0203410:	00840493          	add	s1,s0,8
ffffffffc0203414:	8526                	mv	a0,s1
ffffffffc0203416:	0ec000ef          	jal	ffffffffc0203502 <wait_queue_first>
ffffffffc020341a:	85aa                	mv	a1,a0
ffffffffc020341c:	cd0d                	beqz	a0,ffffffffc0203456 <__up.constprop.0+0x5c>
ffffffffc020341e:	6118                	ld	a4,0(a0)
ffffffffc0203420:	10000793          	li	a5,256
ffffffffc0203424:	0ec72703          	lw	a4,236(a4)
ffffffffc0203428:	02f71f63          	bne	a4,a5,ffffffffc0203466 <__up.constprop.0+0x6c>
ffffffffc020342c:	4685                	li	a3,1
ffffffffc020342e:	10000613          	li	a2,256
ffffffffc0203432:	8526                	mv	a0,s1
ffffffffc0203434:	0ec000ef          	jal	ffffffffc0203520 <wakeup_wait>
ffffffffc0203438:	00091863          	bnez	s2,ffffffffc0203448 <__up.constprop.0+0x4e>
ffffffffc020343c:	60e2                	ld	ra,24(sp)
ffffffffc020343e:	6442                	ld	s0,16(sp)
ffffffffc0203440:	64a2                	ld	s1,8(sp)
ffffffffc0203442:	6902                	ld	s2,0(sp)
ffffffffc0203444:	6105                	add	sp,sp,32
ffffffffc0203446:	8082                	ret
ffffffffc0203448:	6442                	ld	s0,16(sp)
ffffffffc020344a:	60e2                	ld	ra,24(sp)
ffffffffc020344c:	64a2                	ld	s1,8(sp)
ffffffffc020344e:	6902                	ld	s2,0(sp)
ffffffffc0203450:	6105                	add	sp,sp,32
ffffffffc0203452:	9dcfd06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0203456:	401c                	lw	a5,0(s0)
ffffffffc0203458:	2785                	addw	a5,a5,1
ffffffffc020345a:	c01c                	sw	a5,0(s0)
ffffffffc020345c:	bff1                	j	ffffffffc0203438 <__up.constprop.0+0x3e>
ffffffffc020345e:	9d6fd0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203462:	4905                	li	s2,1
ffffffffc0203464:	b775                	j	ffffffffc0203410 <__up.constprop.0+0x16>
ffffffffc0203466:	00004697          	auipc	a3,0x4
ffffffffc020346a:	a1268693          	add	a3,a3,-1518 # ffffffffc0206e78 <default_pmm_manager+0x7e8>
ffffffffc020346e:	00003617          	auipc	a2,0x3
ffffffffc0203472:	b8a60613          	add	a2,a2,-1142 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0203476:	45e5                	li	a1,25
ffffffffc0203478:	00004517          	auipc	a0,0x4
ffffffffc020347c:	a2850513          	add	a0,a0,-1496 # ffffffffc0206ea0 <default_pmm_manager+0x810>
ffffffffc0203480:	ff3fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203484 <sem_init>:
ffffffffc0203484:	c10c                	sw	a1,0(a0)
ffffffffc0203486:	0521                	add	a0,a0,8
ffffffffc0203488:	a81d                	j	ffffffffc02034be <wait_queue_init>

ffffffffc020348a <up>:
ffffffffc020348a:	bf85                	j	ffffffffc02033fa <__up.constprop.0>

ffffffffc020348c <down>:
ffffffffc020348c:	1141                	add	sp,sp,-16
ffffffffc020348e:	e406                	sd	ra,8(sp)
ffffffffc0203490:	eb7ff0ef          	jal	ffffffffc0203346 <__down.constprop.0>
ffffffffc0203494:	2501                	sext.w	a0,a0
ffffffffc0203496:	e501                	bnez	a0,ffffffffc020349e <down+0x12>
ffffffffc0203498:	60a2                	ld	ra,8(sp)
ffffffffc020349a:	0141                	add	sp,sp,16
ffffffffc020349c:	8082                	ret
ffffffffc020349e:	00004697          	auipc	a3,0x4
ffffffffc02034a2:	a1268693          	add	a3,a3,-1518 # ffffffffc0206eb0 <default_pmm_manager+0x820>
ffffffffc02034a6:	00003617          	auipc	a2,0x3
ffffffffc02034aa:	b5260613          	add	a2,a2,-1198 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02034ae:	04000593          	li	a1,64
ffffffffc02034b2:	00004517          	auipc	a0,0x4
ffffffffc02034b6:	9ee50513          	add	a0,a0,-1554 # ffffffffc0206ea0 <default_pmm_manager+0x810>
ffffffffc02034ba:	fb9fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02034be <wait_queue_init>:
ffffffffc02034be:	e508                	sd	a0,8(a0)
ffffffffc02034c0:	e108                	sd	a0,0(a0)
ffffffffc02034c2:	8082                	ret

ffffffffc02034c4 <wait_queue_del>:
ffffffffc02034c4:	7198                	ld	a4,32(a1)
ffffffffc02034c6:	01858793          	add	a5,a1,24
ffffffffc02034ca:	00e78b63          	beq	a5,a4,ffffffffc02034e0 <wait_queue_del+0x1c>
ffffffffc02034ce:	6994                	ld	a3,16(a1)
ffffffffc02034d0:	00a69863          	bne	a3,a0,ffffffffc02034e0 <wait_queue_del+0x1c>
ffffffffc02034d4:	6d94                	ld	a3,24(a1)
ffffffffc02034d6:	e698                	sd	a4,8(a3)
ffffffffc02034d8:	e314                	sd	a3,0(a4)
ffffffffc02034da:	f19c                	sd	a5,32(a1)
ffffffffc02034dc:	ed9c                	sd	a5,24(a1)
ffffffffc02034de:	8082                	ret
ffffffffc02034e0:	1141                	add	sp,sp,-16
ffffffffc02034e2:	00004697          	auipc	a3,0x4
ffffffffc02034e6:	a2e68693          	add	a3,a3,-1490 # ffffffffc0206f10 <default_pmm_manager+0x880>
ffffffffc02034ea:	00003617          	auipc	a2,0x3
ffffffffc02034ee:	b0e60613          	add	a2,a2,-1266 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02034f2:	45f1                	li	a1,28
ffffffffc02034f4:	00004517          	auipc	a0,0x4
ffffffffc02034f8:	a0450513          	add	a0,a0,-1532 # ffffffffc0206ef8 <default_pmm_manager+0x868>
ffffffffc02034fc:	e406                	sd	ra,8(sp)
ffffffffc02034fe:	f75fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203502 <wait_queue_first>:
ffffffffc0203502:	651c                	ld	a5,8(a0)
ffffffffc0203504:	00f50563          	beq	a0,a5,ffffffffc020350e <wait_queue_first+0xc>
ffffffffc0203508:	fe878513          	add	a0,a5,-24
ffffffffc020350c:	8082                	ret
ffffffffc020350e:	4501                	li	a0,0
ffffffffc0203510:	8082                	ret

ffffffffc0203512 <wait_in_queue>:
ffffffffc0203512:	711c                	ld	a5,32(a0)
ffffffffc0203514:	0561                	add	a0,a0,24
ffffffffc0203516:	40a78533          	sub	a0,a5,a0
ffffffffc020351a:	00a03533          	snez	a0,a0
ffffffffc020351e:	8082                	ret

ffffffffc0203520 <wakeup_wait>:
ffffffffc0203520:	e689                	bnez	a3,ffffffffc020352a <wakeup_wait+0xa>
ffffffffc0203522:	6188                	ld	a0,0(a1)
ffffffffc0203524:	c590                	sw	a2,8(a1)
ffffffffc0203526:	2350106f          	j	ffffffffc0204f5a <wakeup_proc>
ffffffffc020352a:	7198                	ld	a4,32(a1)
ffffffffc020352c:	01858793          	add	a5,a1,24
ffffffffc0203530:	00e78e63          	beq	a5,a4,ffffffffc020354c <wakeup_wait+0x2c>
ffffffffc0203534:	6994                	ld	a3,16(a1)
ffffffffc0203536:	00d51b63          	bne	a0,a3,ffffffffc020354c <wakeup_wait+0x2c>
ffffffffc020353a:	6d94                	ld	a3,24(a1)
ffffffffc020353c:	6188                	ld	a0,0(a1)
ffffffffc020353e:	e698                	sd	a4,8(a3)
ffffffffc0203540:	e314                	sd	a3,0(a4)
ffffffffc0203542:	f19c                	sd	a5,32(a1)
ffffffffc0203544:	ed9c                	sd	a5,24(a1)
ffffffffc0203546:	c590                	sw	a2,8(a1)
ffffffffc0203548:	2130106f          	j	ffffffffc0204f5a <wakeup_proc>
ffffffffc020354c:	1141                	add	sp,sp,-16
ffffffffc020354e:	00004697          	auipc	a3,0x4
ffffffffc0203552:	9c268693          	add	a3,a3,-1598 # ffffffffc0206f10 <default_pmm_manager+0x880>
ffffffffc0203556:	00003617          	auipc	a2,0x3
ffffffffc020355a:	aa260613          	add	a2,a2,-1374 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020355e:	45f1                	li	a1,28
ffffffffc0203560:	00004517          	auipc	a0,0x4
ffffffffc0203564:	99850513          	add	a0,a0,-1640 # ffffffffc0206ef8 <default_pmm_manager+0x868>
ffffffffc0203568:	e406                	sd	ra,8(sp)
ffffffffc020356a:	f09fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020356e <wait_current_set>:
ffffffffc020356e:	00014797          	auipc	a5,0x14
ffffffffc0203572:	0ea7b783          	ld	a5,234(a5) # ffffffffc0217658 <current>
ffffffffc0203576:	c39d                	beqz	a5,ffffffffc020359c <wait_current_set+0x2e>
ffffffffc0203578:	01858713          	add	a4,a1,24
ffffffffc020357c:	800006b7          	lui	a3,0x80000
ffffffffc0203580:	ed98                	sd	a4,24(a1)
ffffffffc0203582:	e19c                	sd	a5,0(a1)
ffffffffc0203584:	c594                	sw	a3,8(a1)
ffffffffc0203586:	4685                	li	a3,1
ffffffffc0203588:	c394                	sw	a3,0(a5)
ffffffffc020358a:	0ec7a623          	sw	a2,236(a5)
ffffffffc020358e:	611c                	ld	a5,0(a0)
ffffffffc0203590:	e988                	sd	a0,16(a1)
ffffffffc0203592:	e118                	sd	a4,0(a0)
ffffffffc0203594:	e798                	sd	a4,8(a5)
ffffffffc0203596:	f188                	sd	a0,32(a1)
ffffffffc0203598:	ed9c                	sd	a5,24(a1)
ffffffffc020359a:	8082                	ret
ffffffffc020359c:	1141                	add	sp,sp,-16
ffffffffc020359e:	00004697          	auipc	a3,0x4
ffffffffc02035a2:	9b268693          	add	a3,a3,-1614 # ffffffffc0206f50 <default_pmm_manager+0x8c0>
ffffffffc02035a6:	00003617          	auipc	a2,0x3
ffffffffc02035aa:	a5260613          	add	a2,a2,-1454 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02035ae:	07400593          	li	a1,116
ffffffffc02035b2:	00004517          	auipc	a0,0x4
ffffffffc02035b6:	94650513          	add	a0,a0,-1722 # ffffffffc0206ef8 <default_pmm_manager+0x868>
ffffffffc02035ba:	e406                	sd	ra,8(sp)
ffffffffc02035bc:	eb7fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02035c0 <swapfs_init>:
ffffffffc02035c0:	1141                	add	sp,sp,-16
ffffffffc02035c2:	4505                	li	a0,1
ffffffffc02035c4:	e406                	sd	ra,8(sp)
ffffffffc02035c6:	814fd0ef          	jal	ffffffffc02005da <ide_device_valid>
ffffffffc02035ca:	cd01                	beqz	a0,ffffffffc02035e2 <swapfs_init+0x22>
ffffffffc02035cc:	4505                	li	a0,1
ffffffffc02035ce:	812fd0ef          	jal	ffffffffc02005e0 <ide_device_size>
ffffffffc02035d2:	60a2                	ld	ra,8(sp)
ffffffffc02035d4:	810d                	srl	a0,a0,0x3
ffffffffc02035d6:	00014797          	auipc	a5,0x14
ffffffffc02035da:	04a7bd23          	sd	a0,90(a5) # ffffffffc0217630 <max_swap_offset>
ffffffffc02035de:	0141                	add	sp,sp,16
ffffffffc02035e0:	8082                	ret
ffffffffc02035e2:	00004617          	auipc	a2,0x4
ffffffffc02035e6:	97e60613          	add	a2,a2,-1666 # ffffffffc0206f60 <default_pmm_manager+0x8d0>
ffffffffc02035ea:	45b5                	li	a1,13
ffffffffc02035ec:	00004517          	auipc	a0,0x4
ffffffffc02035f0:	99450513          	add	a0,a0,-1644 # ffffffffc0206f80 <default_pmm_manager+0x8f0>
ffffffffc02035f4:	e7ffc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02035f8 <swapfs_read>:
ffffffffc02035f8:	1141                	add	sp,sp,-16
ffffffffc02035fa:	e406                	sd	ra,8(sp)
ffffffffc02035fc:	00855793          	srl	a5,a0,0x8
ffffffffc0203600:	cbb1                	beqz	a5,ffffffffc0203654 <swapfs_read+0x5c>
ffffffffc0203602:	00014717          	auipc	a4,0x14
ffffffffc0203606:	02e73703          	ld	a4,46(a4) # ffffffffc0217630 <max_swap_offset>
ffffffffc020360a:	04e7f563          	bgeu	a5,a4,ffffffffc0203654 <swapfs_read+0x5c>
ffffffffc020360e:	00014717          	auipc	a4,0x14
ffffffffc0203612:	01273703          	ld	a4,18(a4) # ffffffffc0217620 <pages>
ffffffffc0203616:	8d99                	sub	a1,a1,a4
ffffffffc0203618:	4065d613          	sra	a2,a1,0x6
ffffffffc020361c:	00005717          	auipc	a4,0x5
ffffffffc0203620:	a5c73703          	ld	a4,-1444(a4) # ffffffffc0208078 <nbase>
ffffffffc0203624:	963a                	add	a2,a2,a4
ffffffffc0203626:	00c61713          	sll	a4,a2,0xc
ffffffffc020362a:	8331                	srl	a4,a4,0xc
ffffffffc020362c:	00014697          	auipc	a3,0x14
ffffffffc0203630:	fec6b683          	ld	a3,-20(a3) # ffffffffc0217618 <npage>
ffffffffc0203634:	0037959b          	sllw	a1,a5,0x3
ffffffffc0203638:	0632                	sll	a2,a2,0xc
ffffffffc020363a:	02d77963          	bgeu	a4,a3,ffffffffc020366c <swapfs_read+0x74>
ffffffffc020363e:	60a2                	ld	ra,8(sp)
ffffffffc0203640:	00014797          	auipc	a5,0x14
ffffffffc0203644:	fd07b783          	ld	a5,-48(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc0203648:	46a1                	li	a3,8
ffffffffc020364a:	963e                	add	a2,a2,a5
ffffffffc020364c:	4505                	li	a0,1
ffffffffc020364e:	0141                	add	sp,sp,16
ffffffffc0203650:	f97fc06f          	j	ffffffffc02005e6 <ide_read_secs>
ffffffffc0203654:	86aa                	mv	a3,a0
ffffffffc0203656:	00004617          	auipc	a2,0x4
ffffffffc020365a:	94260613          	add	a2,a2,-1726 # ffffffffc0206f98 <default_pmm_manager+0x908>
ffffffffc020365e:	45d1                	li	a1,20
ffffffffc0203660:	00004517          	auipc	a0,0x4
ffffffffc0203664:	92050513          	add	a0,a0,-1760 # ffffffffc0206f80 <default_pmm_manager+0x8f0>
ffffffffc0203668:	e0bfc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020366c:	86b2                	mv	a3,a2
ffffffffc020366e:	06900593          	li	a1,105
ffffffffc0203672:	00003617          	auipc	a2,0x3
ffffffffc0203676:	05660613          	add	a2,a2,86 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc020367a:	00003517          	auipc	a0,0x3
ffffffffc020367e:	07650513          	add	a0,a0,118 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0203682:	df1fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203686 <swapfs_write>:
ffffffffc0203686:	1141                	add	sp,sp,-16
ffffffffc0203688:	e406                	sd	ra,8(sp)
ffffffffc020368a:	00855793          	srl	a5,a0,0x8
ffffffffc020368e:	cbb1                	beqz	a5,ffffffffc02036e2 <swapfs_write+0x5c>
ffffffffc0203690:	00014717          	auipc	a4,0x14
ffffffffc0203694:	fa073703          	ld	a4,-96(a4) # ffffffffc0217630 <max_swap_offset>
ffffffffc0203698:	04e7f563          	bgeu	a5,a4,ffffffffc02036e2 <swapfs_write+0x5c>
ffffffffc020369c:	00014717          	auipc	a4,0x14
ffffffffc02036a0:	f8473703          	ld	a4,-124(a4) # ffffffffc0217620 <pages>
ffffffffc02036a4:	8d99                	sub	a1,a1,a4
ffffffffc02036a6:	4065d613          	sra	a2,a1,0x6
ffffffffc02036aa:	00005717          	auipc	a4,0x5
ffffffffc02036ae:	9ce73703          	ld	a4,-1586(a4) # ffffffffc0208078 <nbase>
ffffffffc02036b2:	963a                	add	a2,a2,a4
ffffffffc02036b4:	00c61713          	sll	a4,a2,0xc
ffffffffc02036b8:	8331                	srl	a4,a4,0xc
ffffffffc02036ba:	00014697          	auipc	a3,0x14
ffffffffc02036be:	f5e6b683          	ld	a3,-162(a3) # ffffffffc0217618 <npage>
ffffffffc02036c2:	0037959b          	sllw	a1,a5,0x3
ffffffffc02036c6:	0632                	sll	a2,a2,0xc
ffffffffc02036c8:	02d77963          	bgeu	a4,a3,ffffffffc02036fa <swapfs_write+0x74>
ffffffffc02036cc:	60a2                	ld	ra,8(sp)
ffffffffc02036ce:	00014797          	auipc	a5,0x14
ffffffffc02036d2:	f427b783          	ld	a5,-190(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc02036d6:	46a1                	li	a3,8
ffffffffc02036d8:	963e                	add	a2,a2,a5
ffffffffc02036da:	4505                	li	a0,1
ffffffffc02036dc:	0141                	add	sp,sp,16
ffffffffc02036de:	f2dfc06f          	j	ffffffffc020060a <ide_write_secs>
ffffffffc02036e2:	86aa                	mv	a3,a0
ffffffffc02036e4:	00004617          	auipc	a2,0x4
ffffffffc02036e8:	8b460613          	add	a2,a2,-1868 # ffffffffc0206f98 <default_pmm_manager+0x908>
ffffffffc02036ec:	45e5                	li	a1,25
ffffffffc02036ee:	00004517          	auipc	a0,0x4
ffffffffc02036f2:	89250513          	add	a0,a0,-1902 # ffffffffc0206f80 <default_pmm_manager+0x8f0>
ffffffffc02036f6:	d7dfc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02036fa:	86b2                	mv	a3,a2
ffffffffc02036fc:	06900593          	li	a1,105
ffffffffc0203700:	00003617          	auipc	a2,0x3
ffffffffc0203704:	fc860613          	add	a2,a2,-56 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0203708:	00003517          	auipc	a0,0x3
ffffffffc020370c:	fe850513          	add	a0,a0,-24 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0203710:	d63fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203714 <kernel_thread_entry>:
ffffffffc0203714:	8526                	mv	a0,s1
ffffffffc0203716:	9402                	jalr	s0
ffffffffc0203718:	616000ef          	jal	ffffffffc0203d2e <do_exit>

ffffffffc020371c <alloc_proc>:
ffffffffc020371c:	1141                	add	sp,sp,-16
ffffffffc020371e:	14800513          	li	a0,328
ffffffffc0203722:	e022                	sd	s0,0(sp)
ffffffffc0203724:	e406                	sd	ra,8(sp)
ffffffffc0203726:	ab8fe0ef          	jal	ffffffffc02019de <kmalloc>
ffffffffc020372a:	842a                	mv	s0,a0
ffffffffc020372c:	cd21                	beqz	a0,ffffffffc0203784 <alloc_proc+0x68>
ffffffffc020372e:	57fd                	li	a5,-1
ffffffffc0203730:	1782                	sll	a5,a5,0x20
ffffffffc0203732:	e11c                	sd	a5,0(a0)
ffffffffc0203734:	07000613          	li	a2,112
ffffffffc0203738:	4581                	li	a1,0
ffffffffc020373a:	00052423          	sw	zero,8(a0)
ffffffffc020373e:	00053823          	sd	zero,16(a0)
ffffffffc0203742:	00053c23          	sd	zero,24(a0)
ffffffffc0203746:	02053023          	sd	zero,32(a0)
ffffffffc020374a:	02053423          	sd	zero,40(a0)
ffffffffc020374e:	03050513          	add	a0,a0,48
ffffffffc0203752:	1cc020ef          	jal	ffffffffc020591e <memset>
ffffffffc0203756:	00014797          	auipc	a5,0x14
ffffffffc020375a:	eaa7b783          	ld	a5,-342(a5) # ffffffffc0217600 <boot_cr3>
ffffffffc020375e:	0a043023          	sd	zero,160(s0)
ffffffffc0203762:	f45c                	sd	a5,168(s0)
ffffffffc0203764:	0a042823          	sw	zero,176(s0)
ffffffffc0203768:	463d                	li	a2,15
ffffffffc020376a:	4581                	li	a1,0
ffffffffc020376c:	0b440513          	add	a0,s0,180
ffffffffc0203770:	1ae020ef          	jal	ffffffffc020591e <memset>
ffffffffc0203774:	0e042623          	sw	zero,236(s0)
ffffffffc0203778:	0e043c23          	sd	zero,248(s0)
ffffffffc020377c:	10043023          	sd	zero,256(s0)
ffffffffc0203780:	0e043823          	sd	zero,240(s0)
ffffffffc0203784:	60a2                	ld	ra,8(sp)
ffffffffc0203786:	8522                	mv	a0,s0
ffffffffc0203788:	6402                	ld	s0,0(sp)
ffffffffc020378a:	0141                	add	sp,sp,16
ffffffffc020378c:	8082                	ret

ffffffffc020378e <forkret>:
ffffffffc020378e:	00014797          	auipc	a5,0x14
ffffffffc0203792:	eca7b783          	ld	a5,-310(a5) # ffffffffc0217658 <current>
ffffffffc0203796:	73c8                	ld	a0,160(a5)
ffffffffc0203798:	d7efd06f          	j	ffffffffc0200d16 <forkrets>

ffffffffc020379c <put_pgdir.isra.0>:
ffffffffc020379c:	1141                	add	sp,sp,-16
ffffffffc020379e:	e406                	sd	ra,8(sp)
ffffffffc02037a0:	c02007b7          	lui	a5,0xc0200
ffffffffc02037a4:	02f56e63          	bltu	a0,a5,ffffffffc02037e0 <put_pgdir.isra.0+0x44>
ffffffffc02037a8:	00014797          	auipc	a5,0x14
ffffffffc02037ac:	e687b783          	ld	a5,-408(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc02037b0:	8d1d                	sub	a0,a0,a5
ffffffffc02037b2:	8131                	srl	a0,a0,0xc
ffffffffc02037b4:	00014797          	auipc	a5,0x14
ffffffffc02037b8:	e647b783          	ld	a5,-412(a5) # ffffffffc0217618 <npage>
ffffffffc02037bc:	02f57f63          	bgeu	a0,a5,ffffffffc02037fa <put_pgdir.isra.0+0x5e>
ffffffffc02037c0:	00005797          	auipc	a5,0x5
ffffffffc02037c4:	8b87b783          	ld	a5,-1864(a5) # ffffffffc0208078 <nbase>
ffffffffc02037c8:	60a2                	ld	ra,8(sp)
ffffffffc02037ca:	8d1d                	sub	a0,a0,a5
ffffffffc02037cc:	051a                	sll	a0,a0,0x6
ffffffffc02037ce:	00014797          	auipc	a5,0x14
ffffffffc02037d2:	e527b783          	ld	a5,-430(a5) # ffffffffc0217620 <pages>
ffffffffc02037d6:	4585                	li	a1,1
ffffffffc02037d8:	953e                	add	a0,a0,a5
ffffffffc02037da:	0141                	add	sp,sp,16
ffffffffc02037dc:	c44fe06f          	j	ffffffffc0201c20 <free_pages>
ffffffffc02037e0:	86aa                	mv	a3,a0
ffffffffc02037e2:	00003617          	auipc	a2,0x3
ffffffffc02037e6:	f5660613          	add	a2,a2,-170 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc02037ea:	06e00593          	li	a1,110
ffffffffc02037ee:	00003517          	auipc	a0,0x3
ffffffffc02037f2:	f0250513          	add	a0,a0,-254 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc02037f6:	c7dfc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02037fa:	00003617          	auipc	a2,0x3
ffffffffc02037fe:	f6660613          	add	a2,a2,-154 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc0203802:	06200593          	li	a1,98
ffffffffc0203806:	00003517          	auipc	a0,0x3
ffffffffc020380a:	eea50513          	add	a0,a0,-278 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc020380e:	c65fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203812 <set_proc_name>:
ffffffffc0203812:	1101                	add	sp,sp,-32
ffffffffc0203814:	e822                	sd	s0,16(sp)
ffffffffc0203816:	0b450413          	add	s0,a0,180
ffffffffc020381a:	e426                	sd	s1,8(sp)
ffffffffc020381c:	4641                	li	a2,16
ffffffffc020381e:	84ae                	mv	s1,a1
ffffffffc0203820:	8522                	mv	a0,s0
ffffffffc0203822:	4581                	li	a1,0
ffffffffc0203824:	ec06                	sd	ra,24(sp)
ffffffffc0203826:	0f8020ef          	jal	ffffffffc020591e <memset>
ffffffffc020382a:	8522                	mv	a0,s0
ffffffffc020382c:	6442                	ld	s0,16(sp)
ffffffffc020382e:	60e2                	ld	ra,24(sp)
ffffffffc0203830:	85a6                	mv	a1,s1
ffffffffc0203832:	64a2                	ld	s1,8(sp)
ffffffffc0203834:	463d                	li	a2,15
ffffffffc0203836:	6105                	add	sp,sp,32
ffffffffc0203838:	0f80206f          	j	ffffffffc0205930 <memcpy>

ffffffffc020383c <proc_run>:
ffffffffc020383c:	7179                	add	sp,sp,-48
ffffffffc020383e:	ec4a                	sd	s2,24(sp)
ffffffffc0203840:	00014917          	auipc	s2,0x14
ffffffffc0203844:	e1890913          	add	s2,s2,-488 # ffffffffc0217658 <current>
ffffffffc0203848:	f026                	sd	s1,32(sp)
ffffffffc020384a:	00093483          	ld	s1,0(s2)
ffffffffc020384e:	f406                	sd	ra,40(sp)
ffffffffc0203850:	e84e                	sd	s3,16(sp)
ffffffffc0203852:	02a48863          	beq	s1,a0,ffffffffc0203882 <proc_run+0x46>
ffffffffc0203856:	100027f3          	csrr	a5,sstatus
ffffffffc020385a:	8b89                	and	a5,a5,2
ffffffffc020385c:	4981                	li	s3,0
ffffffffc020385e:	ef9d                	bnez	a5,ffffffffc020389c <proc_run+0x60>
ffffffffc0203860:	755c                	ld	a5,168(a0)
ffffffffc0203862:	577d                	li	a4,-1
ffffffffc0203864:	177e                	sll	a4,a4,0x3f
ffffffffc0203866:	83b1                	srl	a5,a5,0xc
ffffffffc0203868:	00a93023          	sd	a0,0(s2)
ffffffffc020386c:	8fd9                	or	a5,a5,a4
ffffffffc020386e:	18079073          	csrw	satp,a5
ffffffffc0203872:	03050593          	add	a1,a0,48
ffffffffc0203876:	03048513          	add	a0,s1,48
ffffffffc020387a:	132010ef          	jal	ffffffffc02049ac <switch_to>
ffffffffc020387e:	00099863          	bnez	s3,ffffffffc020388e <proc_run+0x52>
ffffffffc0203882:	70a2                	ld	ra,40(sp)
ffffffffc0203884:	7482                	ld	s1,32(sp)
ffffffffc0203886:	6962                	ld	s2,24(sp)
ffffffffc0203888:	69c2                	ld	s3,16(sp)
ffffffffc020388a:	6145                	add	sp,sp,48
ffffffffc020388c:	8082                	ret
ffffffffc020388e:	70a2                	ld	ra,40(sp)
ffffffffc0203890:	7482                	ld	s1,32(sp)
ffffffffc0203892:	6962                	ld	s2,24(sp)
ffffffffc0203894:	69c2                	ld	s3,16(sp)
ffffffffc0203896:	6145                	add	sp,sp,48
ffffffffc0203898:	d97fc06f          	j	ffffffffc020062e <intr_enable>
ffffffffc020389c:	e42a                	sd	a0,8(sp)
ffffffffc020389e:	d97fc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02038a2:	6522                	ld	a0,8(sp)
ffffffffc02038a4:	4985                	li	s3,1
ffffffffc02038a6:	bf6d                	j	ffffffffc0203860 <proc_run+0x24>

ffffffffc02038a8 <find_proc>:
ffffffffc02038a8:	6789                	lui	a5,0x2
ffffffffc02038aa:	fff5071b          	addw	a4,a0,-1
ffffffffc02038ae:	17f9                	add	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02038b0:	04e7e163          	bltu	a5,a4,ffffffffc02038f2 <find_proc+0x4a>
ffffffffc02038b4:	1141                	add	sp,sp,-16
ffffffffc02038b6:	e022                	sd	s0,0(sp)
ffffffffc02038b8:	45a9                	li	a1,10
ffffffffc02038ba:	842a                	mv	s0,a0
ffffffffc02038bc:	2501                	sext.w	a0,a0
ffffffffc02038be:	e406                	sd	ra,8(sp)
ffffffffc02038c0:	3f5010ef          	jal	ffffffffc02054b4 <hash32>
ffffffffc02038c4:	02051793          	sll	a5,a0,0x20
ffffffffc02038c8:	01c7d513          	srl	a0,a5,0x1c
ffffffffc02038cc:	00010797          	auipc	a5,0x10
ffffffffc02038d0:	cd478793          	add	a5,a5,-812 # ffffffffc02135a0 <hash_list>
ffffffffc02038d4:	953e                	add	a0,a0,a5
ffffffffc02038d6:	87aa                	mv	a5,a0
ffffffffc02038d8:	a029                	j	ffffffffc02038e2 <find_proc+0x3a>
ffffffffc02038da:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02038de:	00870c63          	beq	a4,s0,ffffffffc02038f6 <find_proc+0x4e>
ffffffffc02038e2:	679c                	ld	a5,8(a5)
ffffffffc02038e4:	fef51be3          	bne	a0,a5,ffffffffc02038da <find_proc+0x32>
ffffffffc02038e8:	60a2                	ld	ra,8(sp)
ffffffffc02038ea:	6402                	ld	s0,0(sp)
ffffffffc02038ec:	4501                	li	a0,0
ffffffffc02038ee:	0141                	add	sp,sp,16
ffffffffc02038f0:	8082                	ret
ffffffffc02038f2:	4501                	li	a0,0
ffffffffc02038f4:	8082                	ret
ffffffffc02038f6:	60a2                	ld	ra,8(sp)
ffffffffc02038f8:	6402                	ld	s0,0(sp)
ffffffffc02038fa:	f2878513          	add	a0,a5,-216
ffffffffc02038fe:	0141                	add	sp,sp,16
ffffffffc0203900:	8082                	ret

ffffffffc0203902 <do_fork>:
ffffffffc0203902:	7119                	add	sp,sp,-128
ffffffffc0203904:	f0ca                	sd	s2,96(sp)
ffffffffc0203906:	00014917          	auipc	s2,0x14
ffffffffc020390a:	d4a90913          	add	s2,s2,-694 # ffffffffc0217650 <nr_process>
ffffffffc020390e:	00092703          	lw	a4,0(s2)
ffffffffc0203912:	fc86                	sd	ra,120(sp)
ffffffffc0203914:	f8a2                	sd	s0,112(sp)
ffffffffc0203916:	f4a6                	sd	s1,104(sp)
ffffffffc0203918:	ecce                	sd	s3,88(sp)
ffffffffc020391a:	e8d2                	sd	s4,80(sp)
ffffffffc020391c:	e4d6                	sd	s5,72(sp)
ffffffffc020391e:	e0da                	sd	s6,64(sp)
ffffffffc0203920:	fc5e                	sd	s7,56(sp)
ffffffffc0203922:	f862                	sd	s8,48(sp)
ffffffffc0203924:	f466                	sd	s9,40(sp)
ffffffffc0203926:	f06a                	sd	s10,32(sp)
ffffffffc0203928:	ec6e                	sd	s11,24(sp)
ffffffffc020392a:	6785                	lui	a5,0x1
ffffffffc020392c:	32f75763          	bge	a4,a5,ffffffffc0203c5a <do_fork+0x358>
ffffffffc0203930:	8a2a                	mv	s4,a0
ffffffffc0203932:	89ae                	mv	s3,a1
ffffffffc0203934:	8432                	mv	s0,a2
ffffffffc0203936:	de7ff0ef          	jal	ffffffffc020371c <alloc_proc>
ffffffffc020393a:	84aa                	mv	s1,a0
ffffffffc020393c:	30050463          	beqz	a0,ffffffffc0203c44 <do_fork+0x342>
ffffffffc0203940:	00014c17          	auipc	s8,0x14
ffffffffc0203944:	d18c0c13          	add	s8,s8,-744 # ffffffffc0217658 <current>
ffffffffc0203948:	000c3783          	ld	a5,0(s8)
ffffffffc020394c:	0ec7a703          	lw	a4,236(a5) # 10ec <kern_entry-0xffffffffc01fef14>
ffffffffc0203950:	f11c                	sd	a5,32(a0)
ffffffffc0203952:	32071263          	bnez	a4,ffffffffc0203c76 <do_fork+0x374>
ffffffffc0203956:	4509                	li	a0,2
ffffffffc0203958:	a38fe0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc020395c:	2e050163          	beqz	a0,ffffffffc0203c3e <do_fork+0x33c>
ffffffffc0203960:	00014c97          	auipc	s9,0x14
ffffffffc0203964:	cc0c8c93          	add	s9,s9,-832 # ffffffffc0217620 <pages>
ffffffffc0203968:	000cb783          	ld	a5,0(s9)
ffffffffc020396c:	00014d17          	auipc	s10,0x14
ffffffffc0203970:	cacd0d13          	add	s10,s10,-852 # ffffffffc0217618 <npage>
ffffffffc0203974:	00004a97          	auipc	s5,0x4
ffffffffc0203978:	704aba83          	ld	s5,1796(s5) # ffffffffc0208078 <nbase>
ffffffffc020397c:	40f506b3          	sub	a3,a0,a5
ffffffffc0203980:	8699                	sra	a3,a3,0x6
ffffffffc0203982:	5dfd                	li	s11,-1
ffffffffc0203984:	000d3783          	ld	a5,0(s10)
ffffffffc0203988:	96d6                	add	a3,a3,s5
ffffffffc020398a:	00cddd93          	srl	s11,s11,0xc
ffffffffc020398e:	01b6f733          	and	a4,a3,s11
ffffffffc0203992:	06b2                	sll	a3,a3,0xc
ffffffffc0203994:	32f77963          	bgeu	a4,a5,ffffffffc0203cc6 <do_fork+0x3c4>
ffffffffc0203998:	000c3603          	ld	a2,0(s8)
ffffffffc020399c:	00014b17          	auipc	s6,0x14
ffffffffc02039a0:	c74b0b13          	add	s6,s6,-908 # ffffffffc0217610 <va_pa_offset>
ffffffffc02039a4:	000b3703          	ld	a4,0(s6)
ffffffffc02039a8:	02863b83          	ld	s7,40(a2)
ffffffffc02039ac:	9736                	add	a4,a4,a3
ffffffffc02039ae:	e898                	sd	a4,16(s1)
ffffffffc02039b0:	020b8863          	beqz	s7,ffffffffc02039e0 <do_fork+0xde>
ffffffffc02039b4:	100a7a13          	and	s4,s4,256
ffffffffc02039b8:	1c0a0563          	beqz	s4,ffffffffc0203b82 <do_fork+0x280>
ffffffffc02039bc:	030ba703          	lw	a4,48(s7)
ffffffffc02039c0:	018bb683          	ld	a3,24(s7)
ffffffffc02039c4:	c0200637          	lui	a2,0xc0200
ffffffffc02039c8:	2705                	addw	a4,a4,1
ffffffffc02039ca:	02eba823          	sw	a4,48(s7)
ffffffffc02039ce:	0374b423          	sd	s7,40(s1)
ffffffffc02039d2:	2cc6e263          	bltu	a3,a2,ffffffffc0203c96 <do_fork+0x394>
ffffffffc02039d6:	000b3783          	ld	a5,0(s6)
ffffffffc02039da:	6898                	ld	a4,16(s1)
ffffffffc02039dc:	8e9d                	sub	a3,a3,a5
ffffffffc02039de:	f4d4                	sd	a3,168(s1)
ffffffffc02039e0:	6689                	lui	a3,0x2
ffffffffc02039e2:	ee068693          	add	a3,a3,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02039e6:	96ba                	add	a3,a3,a4
ffffffffc02039e8:	8622                	mv	a2,s0
ffffffffc02039ea:	f0d4                	sd	a3,160(s1)
ffffffffc02039ec:	87b6                	mv	a5,a3
ffffffffc02039ee:	12040313          	add	t1,s0,288
ffffffffc02039f2:	00063883          	ld	a7,0(a2) # ffffffffc0200000 <kern_entry>
ffffffffc02039f6:	00863803          	ld	a6,8(a2)
ffffffffc02039fa:	6a08                	ld	a0,16(a2)
ffffffffc02039fc:	6e0c                	ld	a1,24(a2)
ffffffffc02039fe:	0117b023          	sd	a7,0(a5)
ffffffffc0203a02:	0107b423          	sd	a6,8(a5)
ffffffffc0203a06:	eb88                	sd	a0,16(a5)
ffffffffc0203a08:	ef8c                	sd	a1,24(a5)
ffffffffc0203a0a:	02060613          	add	a2,a2,32
ffffffffc0203a0e:	02078793          	add	a5,a5,32
ffffffffc0203a12:	fe6610e3          	bne	a2,t1,ffffffffc02039f2 <do_fork+0xf0>
ffffffffc0203a16:	0406b823          	sd	zero,80(a3)
ffffffffc0203a1a:	12098e63          	beqz	s3,ffffffffc0203b56 <do_fork+0x254>
ffffffffc0203a1e:	0136b823          	sd	s3,16(a3)
ffffffffc0203a22:	00000797          	auipc	a5,0x0
ffffffffc0203a26:	d6c78793          	add	a5,a5,-660 # ffffffffc020378e <forkret>
ffffffffc0203a2a:	f89c                	sd	a5,48(s1)
ffffffffc0203a2c:	fc94                	sd	a3,56(s1)
ffffffffc0203a2e:	100027f3          	csrr	a5,sstatus
ffffffffc0203a32:	8b89                	and	a5,a5,2
ffffffffc0203a34:	4981                	li	s3,0
ffffffffc0203a36:	14079263          	bnez	a5,ffffffffc0203b7a <do_fork+0x278>
ffffffffc0203a3a:	00008817          	auipc	a6,0x8
ffffffffc0203a3e:	65280813          	add	a6,a6,1618 # ffffffffc020c08c <last_pid.1>
ffffffffc0203a42:	00082783          	lw	a5,0(a6)
ffffffffc0203a46:	6709                	lui	a4,0x2
ffffffffc0203a48:	0017851b          	addw	a0,a5,1
ffffffffc0203a4c:	00a82023          	sw	a0,0(a6)
ffffffffc0203a50:	08e55d63          	bge	a0,a4,ffffffffc0203aea <do_fork+0x1e8>
ffffffffc0203a54:	00008317          	auipc	t1,0x8
ffffffffc0203a58:	63430313          	add	t1,t1,1588 # ffffffffc020c088 <next_safe.0>
ffffffffc0203a5c:	00032783          	lw	a5,0(t1)
ffffffffc0203a60:	00014417          	auipc	s0,0x14
ffffffffc0203a64:	b4040413          	add	s0,s0,-1216 # ffffffffc02175a0 <proc_list>
ffffffffc0203a68:	08f55963          	bge	a0,a5,ffffffffc0203afa <do_fork+0x1f8>
ffffffffc0203a6c:	c0c8                	sw	a0,4(s1)
ffffffffc0203a6e:	45a9                	li	a1,10
ffffffffc0203a70:	2501                	sext.w	a0,a0
ffffffffc0203a72:	243010ef          	jal	ffffffffc02054b4 <hash32>
ffffffffc0203a76:	02051793          	sll	a5,a0,0x20
ffffffffc0203a7a:	01c7d513          	srl	a0,a5,0x1c
ffffffffc0203a7e:	00010797          	auipc	a5,0x10
ffffffffc0203a82:	b2278793          	add	a5,a5,-1246 # ffffffffc02135a0 <hash_list>
ffffffffc0203a86:	953e                	add	a0,a0,a5
ffffffffc0203a88:	650c                	ld	a1,8(a0)
ffffffffc0203a8a:	7094                	ld	a3,32(s1)
ffffffffc0203a8c:	0d848793          	add	a5,s1,216
ffffffffc0203a90:	e19c                	sd	a5,0(a1)
ffffffffc0203a92:	6410                	ld	a2,8(s0)
ffffffffc0203a94:	e51c                	sd	a5,8(a0)
ffffffffc0203a96:	7af8                	ld	a4,240(a3)
ffffffffc0203a98:	0c848793          	add	a5,s1,200
ffffffffc0203a9c:	f0ec                	sd	a1,224(s1)
ffffffffc0203a9e:	ece8                	sd	a0,216(s1)
ffffffffc0203aa0:	e21c                	sd	a5,0(a2)
ffffffffc0203aa2:	e41c                	sd	a5,8(s0)
ffffffffc0203aa4:	e8f0                	sd	a2,208(s1)
ffffffffc0203aa6:	e4e0                	sd	s0,200(s1)
ffffffffc0203aa8:	0e04bc23          	sd	zero,248(s1)
ffffffffc0203aac:	10e4b023          	sd	a4,256(s1)
ffffffffc0203ab0:	c311                	beqz	a4,ffffffffc0203ab4 <do_fork+0x1b2>
ffffffffc0203ab2:	ff64                	sd	s1,248(a4)
ffffffffc0203ab4:	00092783          	lw	a5,0(s2)
ffffffffc0203ab8:	fae4                	sd	s1,240(a3)
ffffffffc0203aba:	2785                	addw	a5,a5,1
ffffffffc0203abc:	00f92023          	sw	a5,0(s2)
ffffffffc0203ac0:	18099463          	bnez	s3,ffffffffc0203c48 <do_fork+0x346>
ffffffffc0203ac4:	8526                	mv	a0,s1
ffffffffc0203ac6:	494010ef          	jal	ffffffffc0204f5a <wakeup_proc>
ffffffffc0203aca:	40c8                	lw	a0,4(s1)
ffffffffc0203acc:	70e6                	ld	ra,120(sp)
ffffffffc0203ace:	7446                	ld	s0,112(sp)
ffffffffc0203ad0:	74a6                	ld	s1,104(sp)
ffffffffc0203ad2:	7906                	ld	s2,96(sp)
ffffffffc0203ad4:	69e6                	ld	s3,88(sp)
ffffffffc0203ad6:	6a46                	ld	s4,80(sp)
ffffffffc0203ad8:	6aa6                	ld	s5,72(sp)
ffffffffc0203ada:	6b06                	ld	s6,64(sp)
ffffffffc0203adc:	7be2                	ld	s7,56(sp)
ffffffffc0203ade:	7c42                	ld	s8,48(sp)
ffffffffc0203ae0:	7ca2                	ld	s9,40(sp)
ffffffffc0203ae2:	7d02                	ld	s10,32(sp)
ffffffffc0203ae4:	6de2                	ld	s11,24(sp)
ffffffffc0203ae6:	6109                	add	sp,sp,128
ffffffffc0203ae8:	8082                	ret
ffffffffc0203aea:	4785                	li	a5,1
ffffffffc0203aec:	00f82023          	sw	a5,0(a6)
ffffffffc0203af0:	4505                	li	a0,1
ffffffffc0203af2:	00008317          	auipc	t1,0x8
ffffffffc0203af6:	59630313          	add	t1,t1,1430 # ffffffffc020c088 <next_safe.0>
ffffffffc0203afa:	00014417          	auipc	s0,0x14
ffffffffc0203afe:	aa640413          	add	s0,s0,-1370 # ffffffffc02175a0 <proc_list>
ffffffffc0203b02:	00843e03          	ld	t3,8(s0)
ffffffffc0203b06:	6789                	lui	a5,0x2
ffffffffc0203b08:	00f32023          	sw	a5,0(t1)
ffffffffc0203b0c:	86aa                	mv	a3,a0
ffffffffc0203b0e:	4581                	li	a1,0
ffffffffc0203b10:	028e0e63          	beq	t3,s0,ffffffffc0203b4c <do_fork+0x24a>
ffffffffc0203b14:	88ae                	mv	a7,a1
ffffffffc0203b16:	87f2                	mv	a5,t3
ffffffffc0203b18:	6609                	lui	a2,0x2
ffffffffc0203b1a:	a811                	j	ffffffffc0203b2e <do_fork+0x22c>
ffffffffc0203b1c:	00e6d663          	bge	a3,a4,ffffffffc0203b28 <do_fork+0x226>
ffffffffc0203b20:	00c75463          	bge	a4,a2,ffffffffc0203b28 <do_fork+0x226>
ffffffffc0203b24:	863a                	mv	a2,a4
ffffffffc0203b26:	4885                	li	a7,1
ffffffffc0203b28:	679c                	ld	a5,8(a5)
ffffffffc0203b2a:	00878d63          	beq	a5,s0,ffffffffc0203b44 <do_fork+0x242>
ffffffffc0203b2e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc0203b32:	fed715e3          	bne	a4,a3,ffffffffc0203b1c <do_fork+0x21a>
ffffffffc0203b36:	2685                	addw	a3,a3,1
ffffffffc0203b38:	10c6db63          	bge	a3,a2,ffffffffc0203c4e <do_fork+0x34c>
ffffffffc0203b3c:	679c                	ld	a5,8(a5)
ffffffffc0203b3e:	4585                	li	a1,1
ffffffffc0203b40:	fe8797e3          	bne	a5,s0,ffffffffc0203b2e <do_fork+0x22c>
ffffffffc0203b44:	00088463          	beqz	a7,ffffffffc0203b4c <do_fork+0x24a>
ffffffffc0203b48:	00c32023          	sw	a2,0(t1)
ffffffffc0203b4c:	d185                	beqz	a1,ffffffffc0203a6c <do_fork+0x16a>
ffffffffc0203b4e:	00d82023          	sw	a3,0(a6)
ffffffffc0203b52:	8536                	mv	a0,a3
ffffffffc0203b54:	bf21                	j	ffffffffc0203a6c <do_fork+0x16a>
ffffffffc0203b56:	6989                	lui	s3,0x2
ffffffffc0203b58:	edc98993          	add	s3,s3,-292 # 1edc <kern_entry-0xffffffffc01fe124>
ffffffffc0203b5c:	99ba                	add	s3,s3,a4
ffffffffc0203b5e:	0136b823          	sd	s3,16(a3)
ffffffffc0203b62:	00000797          	auipc	a5,0x0
ffffffffc0203b66:	c2c78793          	add	a5,a5,-980 # ffffffffc020378e <forkret>
ffffffffc0203b6a:	f89c                	sd	a5,48(s1)
ffffffffc0203b6c:	fc94                	sd	a3,56(s1)
ffffffffc0203b6e:	100027f3          	csrr	a5,sstatus
ffffffffc0203b72:	8b89                	and	a5,a5,2
ffffffffc0203b74:	4981                	li	s3,0
ffffffffc0203b76:	ec0782e3          	beqz	a5,ffffffffc0203a3a <do_fork+0x138>
ffffffffc0203b7a:	abbfc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203b7e:	4985                	li	s3,1
ffffffffc0203b80:	bd6d                	j	ffffffffc0203a3a <do_fork+0x138>
ffffffffc0203b82:	8c6ff0ef          	jal	ffffffffc0202c48 <mm_create>
ffffffffc0203b86:	e42a                	sd	a0,8(sp)
ffffffffc0203b88:	c541                	beqz	a0,ffffffffc0203c10 <do_fork+0x30e>
ffffffffc0203b8a:	4505                	li	a0,1
ffffffffc0203b8c:	804fe0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0203b90:	cd2d                	beqz	a0,ffffffffc0203c0a <do_fork+0x308>
ffffffffc0203b92:	000cb683          	ld	a3,0(s9)
ffffffffc0203b96:	000d3703          	ld	a4,0(s10)
ffffffffc0203b9a:	40d506b3          	sub	a3,a0,a3
ffffffffc0203b9e:	8699                	sra	a3,a3,0x6
ffffffffc0203ba0:	96d6                	add	a3,a3,s5
ffffffffc0203ba2:	01b6fdb3          	and	s11,a3,s11
ffffffffc0203ba6:	06b2                	sll	a3,a3,0xc
ffffffffc0203ba8:	10edff63          	bgeu	s11,a4,ffffffffc0203cc6 <do_fork+0x3c4>
ffffffffc0203bac:	000b3703          	ld	a4,0(s6)
ffffffffc0203bb0:	6605                	lui	a2,0x1
ffffffffc0203bb2:	00014597          	auipc	a1,0x14
ffffffffc0203bb6:	a565b583          	ld	a1,-1450(a1) # ffffffffc0217608 <boot_pgdir>
ffffffffc0203bba:	00e68a33          	add	s4,a3,a4
ffffffffc0203bbe:	8552                	mv	a0,s4
ffffffffc0203bc0:	571010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc0203bc4:	67a2                	ld	a5,8(sp)
ffffffffc0203bc6:	038b8d93          	add	s11,s7,56
ffffffffc0203bca:	856e                	mv	a0,s11
ffffffffc0203bcc:	0147bc23          	sd	s4,24(a5)
ffffffffc0203bd0:	8bdff0ef          	jal	ffffffffc020348c <down>
ffffffffc0203bd4:	000c3703          	ld	a4,0(s8)
ffffffffc0203bd8:	c701                	beqz	a4,ffffffffc0203be0 <do_fork+0x2de>
ffffffffc0203bda:	4358                	lw	a4,4(a4)
ffffffffc0203bdc:	04eba823          	sw	a4,80(s7)
ffffffffc0203be0:	6c22                	ld	s8,8(sp)
ffffffffc0203be2:	85de                	mv	a1,s7
ffffffffc0203be4:	8562                	mv	a0,s8
ffffffffc0203be6:	ac2ff0ef          	jal	ffffffffc0202ea8 <dup_mmap>
ffffffffc0203bea:	8a2a                	mv	s4,a0
ffffffffc0203bec:	856e                	mv	a0,s11
ffffffffc0203bee:	89dff0ef          	jal	ffffffffc020348a <up>
ffffffffc0203bf2:	040ba823          	sw	zero,80(s7)
ffffffffc0203bf6:	8be2                	mv	s7,s8
ffffffffc0203bf8:	dc0a02e3          	beqz	s4,ffffffffc02039bc <do_fork+0xba>
ffffffffc0203bfc:	6422                	ld	s0,8(sp)
ffffffffc0203bfe:	8522                	mv	a0,s0
ffffffffc0203c00:	b40ff0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0203c04:	6c08                	ld	a0,24(s0)
ffffffffc0203c06:	b97ff0ef          	jal	ffffffffc020379c <put_pgdir.isra.0>
ffffffffc0203c0a:	6522                	ld	a0,8(sp)
ffffffffc0203c0c:	99aff0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc0203c10:	6894                	ld	a3,16(s1)
ffffffffc0203c12:	c0200737          	lui	a4,0xc0200
ffffffffc0203c16:	08e6ec63          	bltu	a3,a4,ffffffffc0203cae <do_fork+0x3ac>
ffffffffc0203c1a:	000b3783          	ld	a5,0(s6)
ffffffffc0203c1e:	000d3703          	ld	a4,0(s10)
ffffffffc0203c22:	40f687b3          	sub	a5,a3,a5
ffffffffc0203c26:	83b1                	srl	a5,a5,0xc
ffffffffc0203c28:	02e7fb63          	bgeu	a5,a4,ffffffffc0203c5e <do_fork+0x35c>
ffffffffc0203c2c:	000cb503          	ld	a0,0(s9)
ffffffffc0203c30:	415787b3          	sub	a5,a5,s5
ffffffffc0203c34:	079a                	sll	a5,a5,0x6
ffffffffc0203c36:	4589                	li	a1,2
ffffffffc0203c38:	953e                	add	a0,a0,a5
ffffffffc0203c3a:	fe7fd0ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0203c3e:	8526                	mv	a0,s1
ffffffffc0203c40:	e3ffd0ef          	jal	ffffffffc0201a7e <kfree>
ffffffffc0203c44:	5571                	li	a0,-4
ffffffffc0203c46:	b559                	j	ffffffffc0203acc <do_fork+0x1ca>
ffffffffc0203c48:	9e7fc0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0203c4c:	bda5                	j	ffffffffc0203ac4 <do_fork+0x1c2>
ffffffffc0203c4e:	6789                	lui	a5,0x2
ffffffffc0203c50:	00f6c363          	blt	a3,a5,ffffffffc0203c56 <do_fork+0x354>
ffffffffc0203c54:	4685                	li	a3,1
ffffffffc0203c56:	4585                	li	a1,1
ffffffffc0203c58:	bd65                	j	ffffffffc0203b10 <do_fork+0x20e>
ffffffffc0203c5a:	556d                	li	a0,-5
ffffffffc0203c5c:	bd85                	j	ffffffffc0203acc <do_fork+0x1ca>
ffffffffc0203c5e:	00003617          	auipc	a2,0x3
ffffffffc0203c62:	b0260613          	add	a2,a2,-1278 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc0203c66:	06200593          	li	a1,98
ffffffffc0203c6a:	00003517          	auipc	a0,0x3
ffffffffc0203c6e:	a8650513          	add	a0,a0,-1402 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0203c72:	801fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203c76:	00003697          	auipc	a3,0x3
ffffffffc0203c7a:	34268693          	add	a3,a3,834 # ffffffffc0206fb8 <default_pmm_manager+0x928>
ffffffffc0203c7e:	00002617          	auipc	a2,0x2
ffffffffc0203c82:	37a60613          	add	a2,a2,890 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0203c86:	1a600593          	li	a1,422
ffffffffc0203c8a:	00003517          	auipc	a0,0x3
ffffffffc0203c8e:	34e50513          	add	a0,a0,846 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0203c92:	fe0fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203c96:	00003617          	auipc	a2,0x3
ffffffffc0203c9a:	aa260613          	add	a2,a2,-1374 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc0203c9e:	15900593          	li	a1,345
ffffffffc0203ca2:	00003517          	auipc	a0,0x3
ffffffffc0203ca6:	33650513          	add	a0,a0,822 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0203caa:	fc8fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203cae:	00003617          	auipc	a2,0x3
ffffffffc0203cb2:	a8a60613          	add	a2,a2,-1398 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc0203cb6:	06e00593          	li	a1,110
ffffffffc0203cba:	00003517          	auipc	a0,0x3
ffffffffc0203cbe:	a3650513          	add	a0,a0,-1482 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0203cc2:	fb0fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203cc6:	00003617          	auipc	a2,0x3
ffffffffc0203cca:	a0260613          	add	a2,a2,-1534 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc0203cce:	06900593          	li	a1,105
ffffffffc0203cd2:	00003517          	auipc	a0,0x3
ffffffffc0203cd6:	a1e50513          	add	a0,a0,-1506 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0203cda:	f98fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203cde <kernel_thread>:
ffffffffc0203cde:	7129                	add	sp,sp,-320
ffffffffc0203ce0:	fa22                	sd	s0,304(sp)
ffffffffc0203ce2:	f626                	sd	s1,296(sp)
ffffffffc0203ce4:	f24a                	sd	s2,288(sp)
ffffffffc0203ce6:	84ae                	mv	s1,a1
ffffffffc0203ce8:	892a                	mv	s2,a0
ffffffffc0203cea:	8432                	mv	s0,a2
ffffffffc0203cec:	4581                	li	a1,0
ffffffffc0203cee:	12000613          	li	a2,288
ffffffffc0203cf2:	850a                	mv	a0,sp
ffffffffc0203cf4:	fe06                	sd	ra,312(sp)
ffffffffc0203cf6:	429010ef          	jal	ffffffffc020591e <memset>
ffffffffc0203cfa:	e0ca                	sd	s2,64(sp)
ffffffffc0203cfc:	e4a6                	sd	s1,72(sp)
ffffffffc0203cfe:	100027f3          	csrr	a5,sstatus
ffffffffc0203d02:	edd7f793          	and	a5,a5,-291
ffffffffc0203d06:	1207e793          	or	a5,a5,288
ffffffffc0203d0a:	e23e                	sd	a5,256(sp)
ffffffffc0203d0c:	860a                	mv	a2,sp
ffffffffc0203d0e:	10046513          	or	a0,s0,256
ffffffffc0203d12:	00000797          	auipc	a5,0x0
ffffffffc0203d16:	a0278793          	add	a5,a5,-1534 # ffffffffc0203714 <kernel_thread_entry>
ffffffffc0203d1a:	4581                	li	a1,0
ffffffffc0203d1c:	e63e                	sd	a5,264(sp)
ffffffffc0203d1e:	be5ff0ef          	jal	ffffffffc0203902 <do_fork>
ffffffffc0203d22:	70f2                	ld	ra,312(sp)
ffffffffc0203d24:	7452                	ld	s0,304(sp)
ffffffffc0203d26:	74b2                	ld	s1,296(sp)
ffffffffc0203d28:	7912                	ld	s2,288(sp)
ffffffffc0203d2a:	6131                	add	sp,sp,320
ffffffffc0203d2c:	8082                	ret

ffffffffc0203d2e <do_exit>:
ffffffffc0203d2e:	7179                	add	sp,sp,-48
ffffffffc0203d30:	f022                	sd	s0,32(sp)
ffffffffc0203d32:	00014417          	auipc	s0,0x14
ffffffffc0203d36:	92640413          	add	s0,s0,-1754 # ffffffffc0217658 <current>
ffffffffc0203d3a:	601c                	ld	a5,0(s0)
ffffffffc0203d3c:	f406                	sd	ra,40(sp)
ffffffffc0203d3e:	ec26                	sd	s1,24(sp)
ffffffffc0203d40:	e84a                	sd	s2,16(sp)
ffffffffc0203d42:	e44e                	sd	s3,8(sp)
ffffffffc0203d44:	e052                	sd	s4,0(sp)
ffffffffc0203d46:	00014717          	auipc	a4,0x14
ffffffffc0203d4a:	92273703          	ld	a4,-1758(a4) # ffffffffc0217668 <idleproc>
ffffffffc0203d4e:	0ce78c63          	beq	a5,a4,ffffffffc0203e26 <do_exit+0xf8>
ffffffffc0203d52:	00014497          	auipc	s1,0x14
ffffffffc0203d56:	90e48493          	add	s1,s1,-1778 # ffffffffc0217660 <initproc>
ffffffffc0203d5a:	6098                	ld	a4,0(s1)
ffffffffc0203d5c:	0ee78c63          	beq	a5,a4,ffffffffc0203e54 <do_exit+0x126>
ffffffffc0203d60:	0287b983          	ld	s3,40(a5)
ffffffffc0203d64:	892a                	mv	s2,a0
ffffffffc0203d66:	02098663          	beqz	s3,ffffffffc0203d92 <do_exit+0x64>
ffffffffc0203d6a:	00014797          	auipc	a5,0x14
ffffffffc0203d6e:	8967b783          	ld	a5,-1898(a5) # ffffffffc0217600 <boot_cr3>
ffffffffc0203d72:	577d                	li	a4,-1
ffffffffc0203d74:	177e                	sll	a4,a4,0x3f
ffffffffc0203d76:	83b1                	srl	a5,a5,0xc
ffffffffc0203d78:	8fd9                	or	a5,a5,a4
ffffffffc0203d7a:	18079073          	csrw	satp,a5
ffffffffc0203d7e:	0309a783          	lw	a5,48(s3)
ffffffffc0203d82:	fff7871b          	addw	a4,a5,-1
ffffffffc0203d86:	02e9a823          	sw	a4,48(s3)
ffffffffc0203d8a:	cb55                	beqz	a4,ffffffffc0203e3e <do_exit+0x110>
ffffffffc0203d8c:	601c                	ld	a5,0(s0)
ffffffffc0203d8e:	0207b423          	sd	zero,40(a5)
ffffffffc0203d92:	601c                	ld	a5,0(s0)
ffffffffc0203d94:	470d                	li	a4,3
ffffffffc0203d96:	c398                	sw	a4,0(a5)
ffffffffc0203d98:	0f27a423          	sw	s2,232(a5)
ffffffffc0203d9c:	100027f3          	csrr	a5,sstatus
ffffffffc0203da0:	8b89                	and	a5,a5,2
ffffffffc0203da2:	4a01                	li	s4,0
ffffffffc0203da4:	e7e1                	bnez	a5,ffffffffc0203e6c <do_exit+0x13e>
ffffffffc0203da6:	6018                	ld	a4,0(s0)
ffffffffc0203da8:	800007b7          	lui	a5,0x80000
ffffffffc0203dac:	0785                	add	a5,a5,1 # ffffffff80000001 <kern_entry-0x401fffff>
ffffffffc0203dae:	7308                	ld	a0,32(a4)
ffffffffc0203db0:	0ec52703          	lw	a4,236(a0)
ffffffffc0203db4:	0cf70063          	beq	a4,a5,ffffffffc0203e74 <do_exit+0x146>
ffffffffc0203db8:	6018                	ld	a4,0(s0)
ffffffffc0203dba:	7b7c                	ld	a5,240(a4)
ffffffffc0203dbc:	c3a1                	beqz	a5,ffffffffc0203dfc <do_exit+0xce>
ffffffffc0203dbe:	800009b7          	lui	s3,0x80000
ffffffffc0203dc2:	490d                	li	s2,3
ffffffffc0203dc4:	0985                	add	s3,s3,1 # ffffffff80000001 <kern_entry-0x401fffff>
ffffffffc0203dc6:	a021                	j	ffffffffc0203dce <do_exit+0xa0>
ffffffffc0203dc8:	6018                	ld	a4,0(s0)
ffffffffc0203dca:	7b7c                	ld	a5,240(a4)
ffffffffc0203dcc:	cb85                	beqz	a5,ffffffffc0203dfc <do_exit+0xce>
ffffffffc0203dce:	1007b683          	ld	a3,256(a5)
ffffffffc0203dd2:	6088                	ld	a0,0(s1)
ffffffffc0203dd4:	fb74                	sd	a3,240(a4)
ffffffffc0203dd6:	7978                	ld	a4,240(a0)
ffffffffc0203dd8:	0e07bc23          	sd	zero,248(a5)
ffffffffc0203ddc:	10e7b023          	sd	a4,256(a5)
ffffffffc0203de0:	c311                	beqz	a4,ffffffffc0203de4 <do_exit+0xb6>
ffffffffc0203de2:	ff7c                	sd	a5,248(a4)
ffffffffc0203de4:	4398                	lw	a4,0(a5)
ffffffffc0203de6:	f388                	sd	a0,32(a5)
ffffffffc0203de8:	f97c                	sd	a5,240(a0)
ffffffffc0203dea:	fd271fe3          	bne	a4,s2,ffffffffc0203dc8 <do_exit+0x9a>
ffffffffc0203dee:	0ec52783          	lw	a5,236(a0)
ffffffffc0203df2:	fd379be3          	bne	a5,s3,ffffffffc0203dc8 <do_exit+0x9a>
ffffffffc0203df6:	164010ef          	jal	ffffffffc0204f5a <wakeup_proc>
ffffffffc0203dfa:	b7f9                	j	ffffffffc0203dc8 <do_exit+0x9a>
ffffffffc0203dfc:	020a1263          	bnez	s4,ffffffffc0203e20 <do_exit+0xf2>
ffffffffc0203e00:	25e010ef          	jal	ffffffffc020505e <schedule>
ffffffffc0203e04:	601c                	ld	a5,0(s0)
ffffffffc0203e06:	00003617          	auipc	a2,0x3
ffffffffc0203e0a:	20a60613          	add	a2,a2,522 # ffffffffc0207010 <default_pmm_manager+0x980>
ffffffffc0203e0e:	1f900593          	li	a1,505
ffffffffc0203e12:	43d4                	lw	a3,4(a5)
ffffffffc0203e14:	00003517          	auipc	a0,0x3
ffffffffc0203e18:	1c450513          	add	a0,a0,452 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0203e1c:	e56fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203e20:	80ffc0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0203e24:	bff1                	j	ffffffffc0203e00 <do_exit+0xd2>
ffffffffc0203e26:	00003617          	auipc	a2,0x3
ffffffffc0203e2a:	1ca60613          	add	a2,a2,458 # ffffffffc0206ff0 <default_pmm_manager+0x960>
ffffffffc0203e2e:	1cd00593          	li	a1,461
ffffffffc0203e32:	00003517          	auipc	a0,0x3
ffffffffc0203e36:	1a650513          	add	a0,a0,422 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0203e3a:	e38fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203e3e:	854e                	mv	a0,s3
ffffffffc0203e40:	900ff0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0203e44:	0189b503          	ld	a0,24(s3)
ffffffffc0203e48:	955ff0ef          	jal	ffffffffc020379c <put_pgdir.isra.0>
ffffffffc0203e4c:	854e                	mv	a0,s3
ffffffffc0203e4e:	f59fe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc0203e52:	bf2d                	j	ffffffffc0203d8c <do_exit+0x5e>
ffffffffc0203e54:	00003617          	auipc	a2,0x3
ffffffffc0203e58:	1ac60613          	add	a2,a2,428 # ffffffffc0207000 <default_pmm_manager+0x970>
ffffffffc0203e5c:	1d000593          	li	a1,464
ffffffffc0203e60:	00003517          	auipc	a0,0x3
ffffffffc0203e64:	17850513          	add	a0,a0,376 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0203e68:	e0afc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203e6c:	fc8fc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203e70:	4a05                	li	s4,1
ffffffffc0203e72:	bf15                	j	ffffffffc0203da6 <do_exit+0x78>
ffffffffc0203e74:	0e6010ef          	jal	ffffffffc0204f5a <wakeup_proc>
ffffffffc0203e78:	b781                	j	ffffffffc0203db8 <do_exit+0x8a>

ffffffffc0203e7a <do_wait.part.0>:
ffffffffc0203e7a:	715d                	add	sp,sp,-80
ffffffffc0203e7c:	f84a                	sd	s2,48(sp)
ffffffffc0203e7e:	f44e                	sd	s3,40(sp)
ffffffffc0203e80:	80000937          	lui	s2,0x80000
ffffffffc0203e84:	6989                	lui	s3,0x2
ffffffffc0203e86:	fc26                	sd	s1,56(sp)
ffffffffc0203e88:	f052                	sd	s4,32(sp)
ffffffffc0203e8a:	ec56                	sd	s5,24(sp)
ffffffffc0203e8c:	e85a                	sd	s6,16(sp)
ffffffffc0203e8e:	e45e                	sd	s7,8(sp)
ffffffffc0203e90:	e486                	sd	ra,72(sp)
ffffffffc0203e92:	e0a2                	sd	s0,64(sp)
ffffffffc0203e94:	84aa                	mv	s1,a0
ffffffffc0203e96:	8a2e                	mv	s4,a1
ffffffffc0203e98:	00013b97          	auipc	s7,0x13
ffffffffc0203e9c:	7c0b8b93          	add	s7,s7,1984 # ffffffffc0217658 <current>
ffffffffc0203ea0:	00050b1b          	sext.w	s6,a0
ffffffffc0203ea4:	fff50a9b          	addw	s5,a0,-1
ffffffffc0203ea8:	19f9                	add	s3,s3,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc0203eaa:	0905                	add	s2,s2,1 # ffffffff80000001 <kern_entry-0x401fffff>
ffffffffc0203eac:	ccbd                	beqz	s1,ffffffffc0203f2a <do_wait.part.0+0xb0>
ffffffffc0203eae:	0359e863          	bltu	s3,s5,ffffffffc0203ede <do_wait.part.0+0x64>
ffffffffc0203eb2:	45a9                	li	a1,10
ffffffffc0203eb4:	855a                	mv	a0,s6
ffffffffc0203eb6:	5fe010ef          	jal	ffffffffc02054b4 <hash32>
ffffffffc0203eba:	02051793          	sll	a5,a0,0x20
ffffffffc0203ebe:	01c7d513          	srl	a0,a5,0x1c
ffffffffc0203ec2:	0000f797          	auipc	a5,0xf
ffffffffc0203ec6:	6de78793          	add	a5,a5,1758 # ffffffffc02135a0 <hash_list>
ffffffffc0203eca:	953e                	add	a0,a0,a5
ffffffffc0203ecc:	842a                	mv	s0,a0
ffffffffc0203ece:	a029                	j	ffffffffc0203ed8 <do_wait.part.0+0x5e>
ffffffffc0203ed0:	f2c42783          	lw	a5,-212(s0)
ffffffffc0203ed4:	02978163          	beq	a5,s1,ffffffffc0203ef6 <do_wait.part.0+0x7c>
ffffffffc0203ed8:	6400                	ld	s0,8(s0)
ffffffffc0203eda:	fe851be3          	bne	a0,s0,ffffffffc0203ed0 <do_wait.part.0+0x56>
ffffffffc0203ede:	5579                	li	a0,-2
ffffffffc0203ee0:	60a6                	ld	ra,72(sp)
ffffffffc0203ee2:	6406                	ld	s0,64(sp)
ffffffffc0203ee4:	74e2                	ld	s1,56(sp)
ffffffffc0203ee6:	7942                	ld	s2,48(sp)
ffffffffc0203ee8:	79a2                	ld	s3,40(sp)
ffffffffc0203eea:	7a02                	ld	s4,32(sp)
ffffffffc0203eec:	6ae2                	ld	s5,24(sp)
ffffffffc0203eee:	6b42                	ld	s6,16(sp)
ffffffffc0203ef0:	6ba2                	ld	s7,8(sp)
ffffffffc0203ef2:	6161                	add	sp,sp,80
ffffffffc0203ef4:	8082                	ret
ffffffffc0203ef6:	000bb683          	ld	a3,0(s7)
ffffffffc0203efa:	f4843783          	ld	a5,-184(s0)
ffffffffc0203efe:	fed790e3          	bne	a5,a3,ffffffffc0203ede <do_wait.part.0+0x64>
ffffffffc0203f02:	f2842703          	lw	a4,-216(s0)
ffffffffc0203f06:	478d                	li	a5,3
ffffffffc0203f08:	0ef70b63          	beq	a4,a5,ffffffffc0203ffe <do_wait.part.0+0x184>
ffffffffc0203f0c:	4785                	li	a5,1
ffffffffc0203f0e:	c29c                	sw	a5,0(a3)
ffffffffc0203f10:	0f26a623          	sw	s2,236(a3)
ffffffffc0203f14:	14a010ef          	jal	ffffffffc020505e <schedule>
ffffffffc0203f18:	000bb783          	ld	a5,0(s7)
ffffffffc0203f1c:	0b07a783          	lw	a5,176(a5)
ffffffffc0203f20:	8b85                	and	a5,a5,1
ffffffffc0203f22:	d7c9                	beqz	a5,ffffffffc0203eac <do_wait.part.0+0x32>
ffffffffc0203f24:	555d                	li	a0,-9
ffffffffc0203f26:	e09ff0ef          	jal	ffffffffc0203d2e <do_exit>
ffffffffc0203f2a:	000bb683          	ld	a3,0(s7)
ffffffffc0203f2e:	7ae0                	ld	s0,240(a3)
ffffffffc0203f30:	d45d                	beqz	s0,ffffffffc0203ede <do_wait.part.0+0x64>
ffffffffc0203f32:	470d                	li	a4,3
ffffffffc0203f34:	a021                	j	ffffffffc0203f3c <do_wait.part.0+0xc2>
ffffffffc0203f36:	10043403          	ld	s0,256(s0)
ffffffffc0203f3a:	d869                	beqz	s0,ffffffffc0203f0c <do_wait.part.0+0x92>
ffffffffc0203f3c:	401c                	lw	a5,0(s0)
ffffffffc0203f3e:	fee79ce3          	bne	a5,a4,ffffffffc0203f36 <do_wait.part.0+0xbc>
ffffffffc0203f42:	00013797          	auipc	a5,0x13
ffffffffc0203f46:	7267b783          	ld	a5,1830(a5) # ffffffffc0217668 <idleproc>
ffffffffc0203f4a:	0c878963          	beq	a5,s0,ffffffffc020401c <do_wait.part.0+0x1a2>
ffffffffc0203f4e:	00013797          	auipc	a5,0x13
ffffffffc0203f52:	7127b783          	ld	a5,1810(a5) # ffffffffc0217660 <initproc>
ffffffffc0203f56:	0cf40363          	beq	s0,a5,ffffffffc020401c <do_wait.part.0+0x1a2>
ffffffffc0203f5a:	000a0663          	beqz	s4,ffffffffc0203f66 <do_wait.part.0+0xec>
ffffffffc0203f5e:	0e842783          	lw	a5,232(s0)
ffffffffc0203f62:	00fa2023          	sw	a5,0(s4)
ffffffffc0203f66:	100027f3          	csrr	a5,sstatus
ffffffffc0203f6a:	8b89                	and	a5,a5,2
ffffffffc0203f6c:	4601                	li	a2,0
ffffffffc0203f6e:	e7c1                	bnez	a5,ffffffffc0203ff6 <do_wait.part.0+0x17c>
ffffffffc0203f70:	6c74                	ld	a3,216(s0)
ffffffffc0203f72:	7078                	ld	a4,224(s0)
ffffffffc0203f74:	10043783          	ld	a5,256(s0)
ffffffffc0203f78:	e698                	sd	a4,8(a3)
ffffffffc0203f7a:	e314                	sd	a3,0(a4)
ffffffffc0203f7c:	6474                	ld	a3,200(s0)
ffffffffc0203f7e:	6878                	ld	a4,208(s0)
ffffffffc0203f80:	e698                	sd	a4,8(a3)
ffffffffc0203f82:	e314                	sd	a3,0(a4)
ffffffffc0203f84:	c399                	beqz	a5,ffffffffc0203f8a <do_wait.part.0+0x110>
ffffffffc0203f86:	7c78                	ld	a4,248(s0)
ffffffffc0203f88:	fff8                	sd	a4,248(a5)
ffffffffc0203f8a:	7c78                	ld	a4,248(s0)
ffffffffc0203f8c:	c335                	beqz	a4,ffffffffc0203ff0 <do_wait.part.0+0x176>
ffffffffc0203f8e:	10f73023          	sd	a5,256(a4)
ffffffffc0203f92:	00013717          	auipc	a4,0x13
ffffffffc0203f96:	6be70713          	add	a4,a4,1726 # ffffffffc0217650 <nr_process>
ffffffffc0203f9a:	431c                	lw	a5,0(a4)
ffffffffc0203f9c:	37fd                	addw	a5,a5,-1
ffffffffc0203f9e:	c31c                	sw	a5,0(a4)
ffffffffc0203fa0:	e629                	bnez	a2,ffffffffc0203fea <do_wait.part.0+0x170>
ffffffffc0203fa2:	6814                	ld	a3,16(s0)
ffffffffc0203fa4:	c02007b7          	lui	a5,0xc0200
ffffffffc0203fa8:	04f6ee63          	bltu	a3,a5,ffffffffc0204004 <do_wait.part.0+0x18a>
ffffffffc0203fac:	00013797          	auipc	a5,0x13
ffffffffc0203fb0:	6647b783          	ld	a5,1636(a5) # ffffffffc0217610 <va_pa_offset>
ffffffffc0203fb4:	8e9d                	sub	a3,a3,a5
ffffffffc0203fb6:	82b1                	srl	a3,a3,0xc
ffffffffc0203fb8:	00013797          	auipc	a5,0x13
ffffffffc0203fbc:	6607b783          	ld	a5,1632(a5) # ffffffffc0217618 <npage>
ffffffffc0203fc0:	06f6fa63          	bgeu	a3,a5,ffffffffc0204034 <do_wait.part.0+0x1ba>
ffffffffc0203fc4:	00004797          	auipc	a5,0x4
ffffffffc0203fc8:	0b47b783          	ld	a5,180(a5) # ffffffffc0208078 <nbase>
ffffffffc0203fcc:	8e9d                	sub	a3,a3,a5
ffffffffc0203fce:	069a                	sll	a3,a3,0x6
ffffffffc0203fd0:	00013517          	auipc	a0,0x13
ffffffffc0203fd4:	65053503          	ld	a0,1616(a0) # ffffffffc0217620 <pages>
ffffffffc0203fd8:	9536                	add	a0,a0,a3
ffffffffc0203fda:	4589                	li	a1,2
ffffffffc0203fdc:	c45fd0ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0203fe0:	8522                	mv	a0,s0
ffffffffc0203fe2:	a9dfd0ef          	jal	ffffffffc0201a7e <kfree>
ffffffffc0203fe6:	4501                	li	a0,0
ffffffffc0203fe8:	bde5                	j	ffffffffc0203ee0 <do_wait.part.0+0x66>
ffffffffc0203fea:	e44fc0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0203fee:	bf55                	j	ffffffffc0203fa2 <do_wait.part.0+0x128>
ffffffffc0203ff0:	7018                	ld	a4,32(s0)
ffffffffc0203ff2:	fb7c                	sd	a5,240(a4)
ffffffffc0203ff4:	bf79                	j	ffffffffc0203f92 <do_wait.part.0+0x118>
ffffffffc0203ff6:	e3efc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203ffa:	4605                	li	a2,1
ffffffffc0203ffc:	bf95                	j	ffffffffc0203f70 <do_wait.part.0+0xf6>
ffffffffc0203ffe:	f2840413          	add	s0,s0,-216
ffffffffc0204002:	b781                	j	ffffffffc0203f42 <do_wait.part.0+0xc8>
ffffffffc0204004:	00002617          	auipc	a2,0x2
ffffffffc0204008:	73460613          	add	a2,a2,1844 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc020400c:	06e00593          	li	a1,110
ffffffffc0204010:	00002517          	auipc	a0,0x2
ffffffffc0204014:	6e050513          	add	a0,a0,1760 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0204018:	c5afc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020401c:	00003617          	auipc	a2,0x3
ffffffffc0204020:	01460613          	add	a2,a2,20 # ffffffffc0207030 <default_pmm_manager+0x9a0>
ffffffffc0204024:	2f600593          	li	a1,758
ffffffffc0204028:	00003517          	auipc	a0,0x3
ffffffffc020402c:	fb050513          	add	a0,a0,-80 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204030:	c42fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204034:	00002617          	auipc	a2,0x2
ffffffffc0204038:	72c60613          	add	a2,a2,1836 # ffffffffc0206760 <default_pmm_manager+0xd0>
ffffffffc020403c:	06200593          	li	a1,98
ffffffffc0204040:	00002517          	auipc	a0,0x2
ffffffffc0204044:	6b050513          	add	a0,a0,1712 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc0204048:	c2afc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020404c <init_main>:
ffffffffc020404c:	1141                	add	sp,sp,-16
ffffffffc020404e:	e406                	sd	ra,8(sp)
ffffffffc0204050:	c11fd0ef          	jal	ffffffffc0201c60 <nr_free_pages>
ffffffffc0204054:	987fd0ef          	jal	ffffffffc02019da <kallocated>
ffffffffc0204058:	a56ff0ef          	jal	ffffffffc02032ae <check_sync>
ffffffffc020405c:	a019                	j	ffffffffc0204062 <init_main+0x16>
ffffffffc020405e:	000010ef          	jal	ffffffffc020505e <schedule>
ffffffffc0204062:	4581                	li	a1,0
ffffffffc0204064:	4501                	li	a0,0
ffffffffc0204066:	e15ff0ef          	jal	ffffffffc0203e7a <do_wait.part.0>
ffffffffc020406a:	d975                	beqz	a0,ffffffffc020405e <init_main+0x12>
ffffffffc020406c:	00003517          	auipc	a0,0x3
ffffffffc0204070:	fe450513          	add	a0,a0,-28 # ffffffffc0207050 <default_pmm_manager+0x9c0>
ffffffffc0204074:	916fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0204078:	00013797          	auipc	a5,0x13
ffffffffc020407c:	5e87b783          	ld	a5,1512(a5) # ffffffffc0217660 <initproc>
ffffffffc0204080:	7bf8                	ld	a4,240(a5)
ffffffffc0204082:	e339                	bnez	a4,ffffffffc02040c8 <init_main+0x7c>
ffffffffc0204084:	7ff8                	ld	a4,248(a5)
ffffffffc0204086:	e329                	bnez	a4,ffffffffc02040c8 <init_main+0x7c>
ffffffffc0204088:	1007b703          	ld	a4,256(a5)
ffffffffc020408c:	ef15                	bnez	a4,ffffffffc02040c8 <init_main+0x7c>
ffffffffc020408e:	00013697          	auipc	a3,0x13
ffffffffc0204092:	5c26a683          	lw	a3,1474(a3) # ffffffffc0217650 <nr_process>
ffffffffc0204096:	4709                	li	a4,2
ffffffffc0204098:	08e69863          	bne	a3,a4,ffffffffc0204128 <init_main+0xdc>
ffffffffc020409c:	00013717          	auipc	a4,0x13
ffffffffc02040a0:	50470713          	add	a4,a4,1284 # ffffffffc02175a0 <proc_list>
ffffffffc02040a4:	6714                	ld	a3,8(a4)
ffffffffc02040a6:	0c878793          	add	a5,a5,200
ffffffffc02040aa:	04d79f63          	bne	a5,a3,ffffffffc0204108 <init_main+0xbc>
ffffffffc02040ae:	6318                	ld	a4,0(a4)
ffffffffc02040b0:	02e79c63          	bne	a5,a4,ffffffffc02040e8 <init_main+0x9c>
ffffffffc02040b4:	00003517          	auipc	a0,0x3
ffffffffc02040b8:	08450513          	add	a0,a0,132 # ffffffffc0207138 <default_pmm_manager+0xaa8>
ffffffffc02040bc:	8cefc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02040c0:	60a2                	ld	ra,8(sp)
ffffffffc02040c2:	4501                	li	a0,0
ffffffffc02040c4:	0141                	add	sp,sp,16
ffffffffc02040c6:	8082                	ret
ffffffffc02040c8:	00003697          	auipc	a3,0x3
ffffffffc02040cc:	fb068693          	add	a3,a3,-80 # ffffffffc0207078 <default_pmm_manager+0x9e8>
ffffffffc02040d0:	00002617          	auipc	a2,0x2
ffffffffc02040d4:	f2860613          	add	a2,a2,-216 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02040d8:	35f00593          	li	a1,863
ffffffffc02040dc:	00003517          	auipc	a0,0x3
ffffffffc02040e0:	efc50513          	add	a0,a0,-260 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc02040e4:	b8efc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02040e8:	00003697          	auipc	a3,0x3
ffffffffc02040ec:	02068693          	add	a3,a3,32 # ffffffffc0207108 <default_pmm_manager+0xa78>
ffffffffc02040f0:	00002617          	auipc	a2,0x2
ffffffffc02040f4:	f0860613          	add	a2,a2,-248 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02040f8:	36200593          	li	a1,866
ffffffffc02040fc:	00003517          	auipc	a0,0x3
ffffffffc0204100:	edc50513          	add	a0,a0,-292 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204104:	b6efc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204108:	00003697          	auipc	a3,0x3
ffffffffc020410c:	fd068693          	add	a3,a3,-48 # ffffffffc02070d8 <default_pmm_manager+0xa48>
ffffffffc0204110:	00002617          	auipc	a2,0x2
ffffffffc0204114:	ee860613          	add	a2,a2,-280 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0204118:	36100593          	li	a1,865
ffffffffc020411c:	00003517          	auipc	a0,0x3
ffffffffc0204120:	ebc50513          	add	a0,a0,-324 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204124:	b4efc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204128:	00003697          	auipc	a3,0x3
ffffffffc020412c:	fa068693          	add	a3,a3,-96 # ffffffffc02070c8 <default_pmm_manager+0xa38>
ffffffffc0204130:	00002617          	auipc	a2,0x2
ffffffffc0204134:	ec860613          	add	a2,a2,-312 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0204138:	36000593          	li	a1,864
ffffffffc020413c:	00003517          	auipc	a0,0x3
ffffffffc0204140:	e9c50513          	add	a0,a0,-356 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204144:	b2efc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0204148 <do_execve>:
ffffffffc0204148:	7171                	add	sp,sp,-176
ffffffffc020414a:	e4ee                	sd	s11,72(sp)
ffffffffc020414c:	00013d97          	auipc	s11,0x13
ffffffffc0204150:	50cd8d93          	add	s11,s11,1292 # ffffffffc0217658 <current>
ffffffffc0204154:	000db783          	ld	a5,0(s11)
ffffffffc0204158:	e54e                	sd	s3,136(sp)
ffffffffc020415a:	ed26                	sd	s1,152(sp)
ffffffffc020415c:	0287b983          	ld	s3,40(a5)
ffffffffc0204160:	e94a                	sd	s2,144(sp)
ffffffffc0204162:	fcd6                	sd	s5,120(sp)
ffffffffc0204164:	892a                	mv	s2,a0
ffffffffc0204166:	84ae                	mv	s1,a1
ffffffffc0204168:	8ab2                	mv	s5,a2
ffffffffc020416a:	4681                	li	a3,0
ffffffffc020416c:	862e                	mv	a2,a1
ffffffffc020416e:	85aa                	mv	a1,a0
ffffffffc0204170:	854e                	mv	a0,s3
ffffffffc0204172:	f506                	sd	ra,168(sp)
ffffffffc0204174:	f122                	sd	s0,160(sp)
ffffffffc0204176:	e152                	sd	s4,128(sp)
ffffffffc0204178:	f8da                	sd	s6,112(sp)
ffffffffc020417a:	f4de                	sd	s7,104(sp)
ffffffffc020417c:	f0e2                	sd	s8,96(sp)
ffffffffc020417e:	ece6                	sd	s9,88(sp)
ffffffffc0204180:	e8ea                	sd	s10,80(sp)
ffffffffc0204182:	f39fe0ef          	jal	ffffffffc02030ba <user_mem_check>
ffffffffc0204186:	42050363          	beqz	a0,ffffffffc02045ac <do_execve+0x464>
ffffffffc020418a:	4641                	li	a2,16
ffffffffc020418c:	4581                	li	a1,0
ffffffffc020418e:	1808                	add	a0,sp,48
ffffffffc0204190:	78e010ef          	jal	ffffffffc020591e <memset>
ffffffffc0204194:	47bd                	li	a5,15
ffffffffc0204196:	8626                	mv	a2,s1
ffffffffc0204198:	0e97e163          	bltu	a5,s1,ffffffffc020427a <do_execve+0x132>
ffffffffc020419c:	85ca                	mv	a1,s2
ffffffffc020419e:	1808                	add	a0,sp,48
ffffffffc02041a0:	790010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc02041a4:	0e098263          	beqz	s3,ffffffffc0204288 <do_execve+0x140>
ffffffffc02041a8:	00003517          	auipc	a0,0x3
ffffffffc02041ac:	ab850513          	add	a0,a0,-1352 # ffffffffc0206c60 <default_pmm_manager+0x5d0>
ffffffffc02041b0:	812fc0ef          	jal	ffffffffc02001c2 <cputs>
ffffffffc02041b4:	00013797          	auipc	a5,0x13
ffffffffc02041b8:	44c7b783          	ld	a5,1100(a5) # ffffffffc0217600 <boot_cr3>
ffffffffc02041bc:	577d                	li	a4,-1
ffffffffc02041be:	177e                	sll	a4,a4,0x3f
ffffffffc02041c0:	83b1                	srl	a5,a5,0xc
ffffffffc02041c2:	8fd9                	or	a5,a5,a4
ffffffffc02041c4:	18079073          	csrw	satp,a5
ffffffffc02041c8:	0309a783          	lw	a5,48(s3)
ffffffffc02041cc:	fff7871b          	addw	a4,a5,-1
ffffffffc02041d0:	02e9a823          	sw	a4,48(s3)
ffffffffc02041d4:	2a070c63          	beqz	a4,ffffffffc020448c <do_execve+0x344>
ffffffffc02041d8:	000db783          	ld	a5,0(s11)
ffffffffc02041dc:	0207b423          	sd	zero,40(a5)
ffffffffc02041e0:	a69fe0ef          	jal	ffffffffc0202c48 <mm_create>
ffffffffc02041e4:	84aa                	mv	s1,a0
ffffffffc02041e6:	1c050a63          	beqz	a0,ffffffffc02043ba <do_execve+0x272>
ffffffffc02041ea:	4505                	li	a0,1
ffffffffc02041ec:	9a5fd0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc02041f0:	3c050263          	beqz	a0,ffffffffc02045b4 <do_execve+0x46c>
ffffffffc02041f4:	00013d17          	auipc	s10,0x13
ffffffffc02041f8:	42cd0d13          	add	s10,s10,1068 # ffffffffc0217620 <pages>
ffffffffc02041fc:	000d3783          	ld	a5,0(s10)
ffffffffc0204200:	00013c97          	auipc	s9,0x13
ffffffffc0204204:	418c8c93          	add	s9,s9,1048 # ffffffffc0217618 <npage>
ffffffffc0204208:	00004717          	auipc	a4,0x4
ffffffffc020420c:	e7073703          	ld	a4,-400(a4) # ffffffffc0208078 <nbase>
ffffffffc0204210:	40f506b3          	sub	a3,a0,a5
ffffffffc0204214:	8699                	sra	a3,a3,0x6
ffffffffc0204216:	5bfd                	li	s7,-1
ffffffffc0204218:	000cb783          	ld	a5,0(s9)
ffffffffc020421c:	96ba                	add	a3,a3,a4
ffffffffc020421e:	e83a                	sd	a4,16(sp)
ffffffffc0204220:	00cbd713          	srl	a4,s7,0xc
ffffffffc0204224:	f03a                	sd	a4,32(sp)
ffffffffc0204226:	8f75                	and	a4,a4,a3
ffffffffc0204228:	06b2                	sll	a3,a3,0xc
ffffffffc020422a:	38f77963          	bgeu	a4,a5,ffffffffc02045bc <do_execve+0x474>
ffffffffc020422e:	00013b17          	auipc	s6,0x13
ffffffffc0204232:	3e2b0b13          	add	s6,s6,994 # ffffffffc0217610 <va_pa_offset>
ffffffffc0204236:	000b3783          	ld	a5,0(s6)
ffffffffc020423a:	6605                	lui	a2,0x1
ffffffffc020423c:	00013597          	auipc	a1,0x13
ffffffffc0204240:	3cc5b583          	ld	a1,972(a1) # ffffffffc0217608 <boot_pgdir>
ffffffffc0204244:	00f689b3          	add	s3,a3,a5
ffffffffc0204248:	854e                	mv	a0,s3
ffffffffc020424a:	6e6010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc020424e:	000aa703          	lw	a4,0(s5)
ffffffffc0204252:	464c47b7          	lui	a5,0x464c4
ffffffffc0204256:	0134bc23          	sd	s3,24(s1)
ffffffffc020425a:	57f78793          	add	a5,a5,1407 # 464c457f <kern_entry-0xffffffff79d3ba81>
ffffffffc020425e:	020aba03          	ld	s4,32(s5)
ffffffffc0204262:	04f70363          	beq	a4,a5,ffffffffc02042a8 <do_execve+0x160>
ffffffffc0204266:	5961                	li	s2,-8
ffffffffc0204268:	854e                	mv	a0,s3
ffffffffc020426a:	d32ff0ef          	jal	ffffffffc020379c <put_pgdir.isra.0>
ffffffffc020426e:	8526                	mv	a0,s1
ffffffffc0204270:	b37fe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc0204274:	854a                	mv	a0,s2
ffffffffc0204276:	ab9ff0ef          	jal	ffffffffc0203d2e <do_exit>
ffffffffc020427a:	463d                	li	a2,15
ffffffffc020427c:	85ca                	mv	a1,s2
ffffffffc020427e:	1808                	add	a0,sp,48
ffffffffc0204280:	6b0010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc0204284:	f20992e3          	bnez	s3,ffffffffc02041a8 <do_execve+0x60>
ffffffffc0204288:	000db783          	ld	a5,0(s11)
ffffffffc020428c:	779c                	ld	a5,40(a5)
ffffffffc020428e:	dba9                	beqz	a5,ffffffffc02041e0 <do_execve+0x98>
ffffffffc0204290:	00003617          	auipc	a2,0x3
ffffffffc0204294:	ec860613          	add	a2,a2,-312 # ffffffffc0207158 <default_pmm_manager+0xac8>
ffffffffc0204298:	20300593          	li	a1,515
ffffffffc020429c:	00003517          	auipc	a0,0x3
ffffffffc02042a0:	d3c50513          	add	a0,a0,-708 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc02042a4:	9cefc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02042a8:	038ad703          	lhu	a4,56(s5)
ffffffffc02042ac:	9a56                	add	s4,s4,s5
ffffffffc02042ae:	00371793          	sll	a5,a4,0x3
ffffffffc02042b2:	8f99                	sub	a5,a5,a4
ffffffffc02042b4:	078e                	sll	a5,a5,0x3
ffffffffc02042b6:	97d2                	add	a5,a5,s4
ffffffffc02042b8:	f43e                	sd	a5,40(sp)
ffffffffc02042ba:	00fa7c63          	bgeu	s4,a5,ffffffffc02042d2 <do_execve+0x18a>
ffffffffc02042be:	000a2783          	lw	a5,0(s4)
ffffffffc02042c2:	4705                	li	a4,1
ffffffffc02042c4:	0ee78d63          	beq	a5,a4,ffffffffc02043be <do_execve+0x276>
ffffffffc02042c8:	77a2                	ld	a5,40(sp)
ffffffffc02042ca:	038a0a13          	add	s4,s4,56
ffffffffc02042ce:	fefa68e3          	bltu	s4,a5,ffffffffc02042be <do_execve+0x176>
ffffffffc02042d2:	4701                	li	a4,0
ffffffffc02042d4:	46ad                	li	a3,11
ffffffffc02042d6:	00100637          	lui	a2,0x100
ffffffffc02042da:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02042de:	8526                	mv	a0,s1
ffffffffc02042e0:	b19fe0ef          	jal	ffffffffc0202df8 <mm_map>
ffffffffc02042e4:	892a                	mv	s2,a0
ffffffffc02042e6:	18051d63          	bnez	a0,ffffffffc0204480 <do_execve+0x338>
ffffffffc02042ea:	6c88                	ld	a0,24(s1)
ffffffffc02042ec:	467d                	li	a2,31
ffffffffc02042ee:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02042f2:	a6afe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc02042f6:	34050b63          	beqz	a0,ffffffffc020464c <do_execve+0x504>
ffffffffc02042fa:	6c88                	ld	a0,24(s1)
ffffffffc02042fc:	467d                	li	a2,31
ffffffffc02042fe:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204302:	a5afe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204306:	32050363          	beqz	a0,ffffffffc020462c <do_execve+0x4e4>
ffffffffc020430a:	6c88                	ld	a0,24(s1)
ffffffffc020430c:	467d                	li	a2,31
ffffffffc020430e:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204312:	a4afe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204316:	2e050b63          	beqz	a0,ffffffffc020460c <do_execve+0x4c4>
ffffffffc020431a:	6c88                	ld	a0,24(s1)
ffffffffc020431c:	467d                	li	a2,31
ffffffffc020431e:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204322:	a3afe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204326:	2c050363          	beqz	a0,ffffffffc02045ec <do_execve+0x4a4>
ffffffffc020432a:	589c                	lw	a5,48(s1)
ffffffffc020432c:	000db603          	ld	a2,0(s11)
ffffffffc0204330:	6c94                	ld	a3,24(s1)
ffffffffc0204332:	2785                	addw	a5,a5,1
ffffffffc0204334:	d89c                	sw	a5,48(s1)
ffffffffc0204336:	f604                	sd	s1,40(a2)
ffffffffc0204338:	c02007b7          	lui	a5,0xc0200
ffffffffc020433c:	28f6ec63          	bltu	a3,a5,ffffffffc02045d4 <do_execve+0x48c>
ffffffffc0204340:	000b3783          	ld	a5,0(s6)
ffffffffc0204344:	577d                	li	a4,-1
ffffffffc0204346:	177e                	sll	a4,a4,0x3f
ffffffffc0204348:	8e9d                	sub	a3,a3,a5
ffffffffc020434a:	00c6d793          	srl	a5,a3,0xc
ffffffffc020434e:	f654                	sd	a3,168(a2)
ffffffffc0204350:	8fd9                	or	a5,a5,a4
ffffffffc0204352:	18079073          	csrw	satp,a5
ffffffffc0204356:	7240                	ld	s0,160(a2)
ffffffffc0204358:	4581                	li	a1,0
ffffffffc020435a:	12000613          	li	a2,288
ffffffffc020435e:	8522                	mv	a0,s0
ffffffffc0204360:	10043983          	ld	s3,256(s0)
ffffffffc0204364:	5ba010ef          	jal	ffffffffc020591e <memset>
ffffffffc0204368:	000db483          	ld	s1,0(s11)
ffffffffc020436c:	018ab703          	ld	a4,24(s5)
ffffffffc0204370:	4785                	li	a5,1
ffffffffc0204372:	0b448493          	add	s1,s1,180
ffffffffc0204376:	07fe                	sll	a5,a5,0x1f
ffffffffc0204378:	edf9f993          	and	s3,s3,-289
ffffffffc020437c:	4641                	li	a2,16
ffffffffc020437e:	4581                	li	a1,0
ffffffffc0204380:	e81c                	sd	a5,16(s0)
ffffffffc0204382:	10e43423          	sd	a4,264(s0)
ffffffffc0204386:	11343023          	sd	s3,256(s0)
ffffffffc020438a:	8526                	mv	a0,s1
ffffffffc020438c:	592010ef          	jal	ffffffffc020591e <memset>
ffffffffc0204390:	463d                	li	a2,15
ffffffffc0204392:	180c                	add	a1,sp,48
ffffffffc0204394:	8526                	mv	a0,s1
ffffffffc0204396:	59a010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc020439a:	70aa                	ld	ra,168(sp)
ffffffffc020439c:	740a                	ld	s0,160(sp)
ffffffffc020439e:	64ea                	ld	s1,152(sp)
ffffffffc02043a0:	69aa                	ld	s3,136(sp)
ffffffffc02043a2:	6a0a                	ld	s4,128(sp)
ffffffffc02043a4:	7ae6                	ld	s5,120(sp)
ffffffffc02043a6:	7b46                	ld	s6,112(sp)
ffffffffc02043a8:	7ba6                	ld	s7,104(sp)
ffffffffc02043aa:	7c06                	ld	s8,96(sp)
ffffffffc02043ac:	6ce6                	ld	s9,88(sp)
ffffffffc02043ae:	6d46                	ld	s10,80(sp)
ffffffffc02043b0:	6da6                	ld	s11,72(sp)
ffffffffc02043b2:	854a                	mv	a0,s2
ffffffffc02043b4:	694a                	ld	s2,144(sp)
ffffffffc02043b6:	614d                	add	sp,sp,176
ffffffffc02043b8:	8082                	ret
ffffffffc02043ba:	5971                	li	s2,-4
ffffffffc02043bc:	bd65                	j	ffffffffc0204274 <do_execve+0x12c>
ffffffffc02043be:	028a3603          	ld	a2,40(s4)
ffffffffc02043c2:	020a3783          	ld	a5,32(s4)
ffffffffc02043c6:	1ef66963          	bltu	a2,a5,ffffffffc02045b8 <do_execve+0x470>
ffffffffc02043ca:	004a2783          	lw	a5,4(s4)
ffffffffc02043ce:	0017f713          	and	a4,a5,1
ffffffffc02043d2:	0027f593          	and	a1,a5,2
ffffffffc02043d6:	0027169b          	sllw	a3,a4,0x2
ffffffffc02043da:	8b91                	and	a5,a5,4
ffffffffc02043dc:	070a                	sll	a4,a4,0x2
ffffffffc02043de:	c1f1                	beqz	a1,ffffffffc02044a2 <do_execve+0x35a>
ffffffffc02043e0:	1a079d63          	bnez	a5,ffffffffc020459a <do_execve+0x452>
ffffffffc02043e4:	0026e693          	or	a3,a3,2
ffffffffc02043e8:	47dd                	li	a5,23
ffffffffc02043ea:	2681                	sext.w	a3,a3
ffffffffc02043ec:	ec3e                	sd	a5,24(sp)
ffffffffc02043ee:	c709                	beqz	a4,ffffffffc02043f8 <do_execve+0x2b0>
ffffffffc02043f0:	67e2                	ld	a5,24(sp)
ffffffffc02043f2:	0087e793          	or	a5,a5,8
ffffffffc02043f6:	ec3e                	sd	a5,24(sp)
ffffffffc02043f8:	010a3583          	ld	a1,16(s4)
ffffffffc02043fc:	4701                	li	a4,0
ffffffffc02043fe:	8526                	mv	a0,s1
ffffffffc0204400:	9f9fe0ef          	jal	ffffffffc0202df8 <mm_map>
ffffffffc0204404:	892a                	mv	s2,a0
ffffffffc0204406:	ed2d                	bnez	a0,ffffffffc0204480 <do_execve+0x338>
ffffffffc0204408:	010a3b83          	ld	s7,16(s4)
ffffffffc020440c:	020a3903          	ld	s2,32(s4)
ffffffffc0204410:	008a3983          	ld	s3,8(s4)
ffffffffc0204414:	77fd                	lui	a5,0xfffff
ffffffffc0204416:	995e                	add	s2,s2,s7
ffffffffc0204418:	00fbfc33          	and	s8,s7,a5
ffffffffc020441c:	99d6                	add	s3,s3,s5
ffffffffc020441e:	052be963          	bltu	s7,s2,ffffffffc0204470 <do_execve+0x328>
ffffffffc0204422:	a279                	j	ffffffffc02045b0 <do_execve+0x468>
ffffffffc0204424:	6785                	lui	a5,0x1
ffffffffc0204426:	418b8533          	sub	a0,s7,s8
ffffffffc020442a:	9c3e                	add	s8,s8,a5
ffffffffc020442c:	41790633          	sub	a2,s2,s7
ffffffffc0204430:	01896463          	bltu	s2,s8,ffffffffc0204438 <do_execve+0x2f0>
ffffffffc0204434:	417c0633          	sub	a2,s8,s7
ffffffffc0204438:	000d3683          	ld	a3,0(s10)
ffffffffc020443c:	67c2                	ld	a5,16(sp)
ffffffffc020443e:	000cb583          	ld	a1,0(s9)
ffffffffc0204442:	40d406b3          	sub	a3,s0,a3
ffffffffc0204446:	8699                	sra	a3,a3,0x6
ffffffffc0204448:	96be                	add	a3,a3,a5
ffffffffc020444a:	7782                	ld	a5,32(sp)
ffffffffc020444c:	00f6f833          	and	a6,a3,a5
ffffffffc0204450:	06b2                	sll	a3,a3,0xc
ffffffffc0204452:	16b87563          	bgeu	a6,a1,ffffffffc02045bc <do_execve+0x474>
ffffffffc0204456:	000b3803          	ld	a6,0(s6)
ffffffffc020445a:	85ce                	mv	a1,s3
ffffffffc020445c:	9bb2                	add	s7,s7,a2
ffffffffc020445e:	96c2                	add	a3,a3,a6
ffffffffc0204460:	9536                	add	a0,a0,a3
ffffffffc0204462:	e432                	sd	a2,8(sp)
ffffffffc0204464:	4cc010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc0204468:	6622                	ld	a2,8(sp)
ffffffffc020446a:	99b2                	add	s3,s3,a2
ffffffffc020446c:	052bf063          	bgeu	s7,s2,ffffffffc02044ac <do_execve+0x364>
ffffffffc0204470:	6c88                	ld	a0,24(s1)
ffffffffc0204472:	6662                	ld	a2,24(sp)
ffffffffc0204474:	85e2                	mv	a1,s8
ffffffffc0204476:	8e6fe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc020447a:	842a                	mv	s0,a0
ffffffffc020447c:	f545                	bnez	a0,ffffffffc0204424 <do_execve+0x2dc>
ffffffffc020447e:	5971                	li	s2,-4
ffffffffc0204480:	8526                	mv	a0,s1
ffffffffc0204482:	abffe0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0204486:	0184b983          	ld	s3,24(s1)
ffffffffc020448a:	bbf9                	j	ffffffffc0204268 <do_execve+0x120>
ffffffffc020448c:	854e                	mv	a0,s3
ffffffffc020448e:	ab3fe0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0204492:	0189b503          	ld	a0,24(s3)
ffffffffc0204496:	b06ff0ef          	jal	ffffffffc020379c <put_pgdir.isra.0>
ffffffffc020449a:	854e                	mv	a0,s3
ffffffffc020449c:	90bfe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc02044a0:	bb25                	j	ffffffffc02041d8 <do_execve+0x90>
ffffffffc02044a2:	e7f5                	bnez	a5,ffffffffc020458e <do_execve+0x446>
ffffffffc02044a4:	47c5                	li	a5,17
ffffffffc02044a6:	86ba                	mv	a3,a4
ffffffffc02044a8:	ec3e                	sd	a5,24(sp)
ffffffffc02044aa:	b791                	j	ffffffffc02043ee <do_execve+0x2a6>
ffffffffc02044ac:	010a3903          	ld	s2,16(s4)
ffffffffc02044b0:	028a3683          	ld	a3,40(s4)
ffffffffc02044b4:	9936                	add	s2,s2,a3
ffffffffc02044b6:	078bfa63          	bgeu	s7,s8,ffffffffc020452a <do_execve+0x3e2>
ffffffffc02044ba:	e17907e3          	beq	s2,s7,ffffffffc02042c8 <do_execve+0x180>
ffffffffc02044be:	6505                	lui	a0,0x1
ffffffffc02044c0:	955e                	add	a0,a0,s7
ffffffffc02044c2:	41850533          	sub	a0,a0,s8
ffffffffc02044c6:	417909b3          	sub	s3,s2,s7
ffffffffc02044ca:	0d897e63          	bgeu	s2,s8,ffffffffc02045a6 <do_execve+0x45e>
ffffffffc02044ce:	000d3683          	ld	a3,0(s10)
ffffffffc02044d2:	67c2                	ld	a5,16(sp)
ffffffffc02044d4:	000cb603          	ld	a2,0(s9)
ffffffffc02044d8:	40d406b3          	sub	a3,s0,a3
ffffffffc02044dc:	8699                	sra	a3,a3,0x6
ffffffffc02044de:	96be                	add	a3,a3,a5
ffffffffc02044e0:	00c69593          	sll	a1,a3,0xc
ffffffffc02044e4:	81b1                	srl	a1,a1,0xc
ffffffffc02044e6:	06b2                	sll	a3,a3,0xc
ffffffffc02044e8:	0cc5fa63          	bgeu	a1,a2,ffffffffc02045bc <do_execve+0x474>
ffffffffc02044ec:	000b3803          	ld	a6,0(s6)
ffffffffc02044f0:	864e                	mv	a2,s3
ffffffffc02044f2:	4581                	li	a1,0
ffffffffc02044f4:	96c2                	add	a3,a3,a6
ffffffffc02044f6:	9536                	add	a0,a0,a3
ffffffffc02044f8:	426010ef          	jal	ffffffffc020591e <memset>
ffffffffc02044fc:	9bce                	add	s7,s7,s3
ffffffffc02044fe:	03897463          	bgeu	s2,s8,ffffffffc0204526 <do_execve+0x3de>
ffffffffc0204502:	dd7903e3          	beq	s2,s7,ffffffffc02042c8 <do_execve+0x180>
ffffffffc0204506:	00003697          	auipc	a3,0x3
ffffffffc020450a:	c7a68693          	add	a3,a3,-902 # ffffffffc0207180 <default_pmm_manager+0xaf0>
ffffffffc020450e:	00002617          	auipc	a2,0x2
ffffffffc0204512:	aea60613          	add	a2,a2,-1302 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0204516:	25800593          	li	a1,600
ffffffffc020451a:	00003517          	auipc	a0,0x3
ffffffffc020451e:	abe50513          	add	a0,a0,-1346 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204522:	f51fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204526:	ff7c10e3          	bne	s8,s7,ffffffffc0204506 <do_execve+0x3be>
ffffffffc020452a:	d92bffe3          	bgeu	s7,s2,ffffffffc02042c8 <do_execve+0x180>
ffffffffc020452e:	56fd                	li	a3,-1
ffffffffc0204530:	00c6d793          	srl	a5,a3,0xc
ffffffffc0204534:	6985                	lui	s3,0x1
ffffffffc0204536:	e43e                	sd	a5,8(sp)
ffffffffc0204538:	a099                	j	ffffffffc020457e <do_execve+0x436>
ffffffffc020453a:	418b8533          	sub	a0,s7,s8
ffffffffc020453e:	9c4e                	add	s8,s8,s3
ffffffffc0204540:	41790633          	sub	a2,s2,s7
ffffffffc0204544:	01896463          	bltu	s2,s8,ffffffffc020454c <do_execve+0x404>
ffffffffc0204548:	417c0633          	sub	a2,s8,s7
ffffffffc020454c:	000d3683          	ld	a3,0(s10)
ffffffffc0204550:	67c2                	ld	a5,16(sp)
ffffffffc0204552:	000cb583          	ld	a1,0(s9)
ffffffffc0204556:	40d406b3          	sub	a3,s0,a3
ffffffffc020455a:	8699                	sra	a3,a3,0x6
ffffffffc020455c:	96be                	add	a3,a3,a5
ffffffffc020455e:	67a2                	ld	a5,8(sp)
ffffffffc0204560:	00f6f833          	and	a6,a3,a5
ffffffffc0204564:	06b2                	sll	a3,a3,0xc
ffffffffc0204566:	04b87b63          	bgeu	a6,a1,ffffffffc02045bc <do_execve+0x474>
ffffffffc020456a:	000b3803          	ld	a6,0(s6)
ffffffffc020456e:	9bb2                	add	s7,s7,a2
ffffffffc0204570:	4581                	li	a1,0
ffffffffc0204572:	96c2                	add	a3,a3,a6
ffffffffc0204574:	9536                	add	a0,a0,a3
ffffffffc0204576:	3a8010ef          	jal	ffffffffc020591e <memset>
ffffffffc020457a:	d52bf7e3          	bgeu	s7,s2,ffffffffc02042c8 <do_execve+0x180>
ffffffffc020457e:	6c88                	ld	a0,24(s1)
ffffffffc0204580:	6662                	ld	a2,24(sp)
ffffffffc0204582:	85e2                	mv	a1,s8
ffffffffc0204584:	fd9fd0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204588:	842a                	mv	s0,a0
ffffffffc020458a:	f945                	bnez	a0,ffffffffc020453a <do_execve+0x3f2>
ffffffffc020458c:	bdcd                	j	ffffffffc020447e <do_execve+0x336>
ffffffffc020458e:	0016e693          	or	a3,a3,1
ffffffffc0204592:	47cd                	li	a5,19
ffffffffc0204594:	2681                	sext.w	a3,a3
ffffffffc0204596:	ec3e                	sd	a5,24(sp)
ffffffffc0204598:	bd99                	j	ffffffffc02043ee <do_execve+0x2a6>
ffffffffc020459a:	0036e693          	or	a3,a3,3
ffffffffc020459e:	47dd                	li	a5,23
ffffffffc02045a0:	2681                	sext.w	a3,a3
ffffffffc02045a2:	ec3e                	sd	a5,24(sp)
ffffffffc02045a4:	b5a9                	j	ffffffffc02043ee <do_execve+0x2a6>
ffffffffc02045a6:	417c09b3          	sub	s3,s8,s7
ffffffffc02045aa:	b715                	j	ffffffffc02044ce <do_execve+0x386>
ffffffffc02045ac:	5975                	li	s2,-3
ffffffffc02045ae:	b3f5                	j	ffffffffc020439a <do_execve+0x252>
ffffffffc02045b0:	895e                	mv	s2,s7
ffffffffc02045b2:	bdfd                	j	ffffffffc02044b0 <do_execve+0x368>
ffffffffc02045b4:	5971                	li	s2,-4
ffffffffc02045b6:	b965                	j	ffffffffc020426e <do_execve+0x126>
ffffffffc02045b8:	5961                	li	s2,-8
ffffffffc02045ba:	b5d9                	j	ffffffffc0204480 <do_execve+0x338>
ffffffffc02045bc:	00002617          	auipc	a2,0x2
ffffffffc02045c0:	10c60613          	add	a2,a2,268 # ffffffffc02066c8 <default_pmm_manager+0x38>
ffffffffc02045c4:	06900593          	li	a1,105
ffffffffc02045c8:	00002517          	auipc	a0,0x2
ffffffffc02045cc:	12850513          	add	a0,a0,296 # ffffffffc02066f0 <default_pmm_manager+0x60>
ffffffffc02045d0:	ea3fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02045d4:	00002617          	auipc	a2,0x2
ffffffffc02045d8:	16460613          	add	a2,a2,356 # ffffffffc0206738 <default_pmm_manager+0xa8>
ffffffffc02045dc:	27300593          	li	a1,627
ffffffffc02045e0:	00003517          	auipc	a0,0x3
ffffffffc02045e4:	9f850513          	add	a0,a0,-1544 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc02045e8:	e8bfb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02045ec:	00003697          	auipc	a3,0x3
ffffffffc02045f0:	cac68693          	add	a3,a3,-852 # ffffffffc0207298 <default_pmm_manager+0xc08>
ffffffffc02045f4:	00002617          	auipc	a2,0x2
ffffffffc02045f8:	a0460613          	add	a2,a2,-1532 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02045fc:	26e00593          	li	a1,622
ffffffffc0204600:	00003517          	auipc	a0,0x3
ffffffffc0204604:	9d850513          	add	a0,a0,-1576 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204608:	e6bfb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020460c:	00003697          	auipc	a3,0x3
ffffffffc0204610:	c4468693          	add	a3,a3,-956 # ffffffffc0207250 <default_pmm_manager+0xbc0>
ffffffffc0204614:	00002617          	auipc	a2,0x2
ffffffffc0204618:	9e460613          	add	a2,a2,-1564 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020461c:	26d00593          	li	a1,621
ffffffffc0204620:	00003517          	auipc	a0,0x3
ffffffffc0204624:	9b850513          	add	a0,a0,-1608 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204628:	e4bfb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020462c:	00003697          	auipc	a3,0x3
ffffffffc0204630:	bdc68693          	add	a3,a3,-1060 # ffffffffc0207208 <default_pmm_manager+0xb78>
ffffffffc0204634:	00002617          	auipc	a2,0x2
ffffffffc0204638:	9c460613          	add	a2,a2,-1596 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020463c:	26c00593          	li	a1,620
ffffffffc0204640:	00003517          	auipc	a0,0x3
ffffffffc0204644:	99850513          	add	a0,a0,-1640 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204648:	e2bfb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020464c:	00003697          	auipc	a3,0x3
ffffffffc0204650:	b7468693          	add	a3,a3,-1164 # ffffffffc02071c0 <default_pmm_manager+0xb30>
ffffffffc0204654:	00002617          	auipc	a2,0x2
ffffffffc0204658:	9a460613          	add	a2,a2,-1628 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020465c:	26b00593          	li	a1,619
ffffffffc0204660:	00003517          	auipc	a0,0x3
ffffffffc0204664:	97850513          	add	a0,a0,-1672 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204668:	e0bfb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020466c <do_yield>:
ffffffffc020466c:	00013797          	auipc	a5,0x13
ffffffffc0204670:	fec7b783          	ld	a5,-20(a5) # ffffffffc0217658 <current>
ffffffffc0204674:	4705                	li	a4,1
ffffffffc0204676:	ef98                	sd	a4,24(a5)
ffffffffc0204678:	4501                	li	a0,0
ffffffffc020467a:	8082                	ret

ffffffffc020467c <do_wait>:
ffffffffc020467c:	1101                	add	sp,sp,-32
ffffffffc020467e:	e822                	sd	s0,16(sp)
ffffffffc0204680:	e426                	sd	s1,8(sp)
ffffffffc0204682:	00013797          	auipc	a5,0x13
ffffffffc0204686:	fd67b783          	ld	a5,-42(a5) # ffffffffc0217658 <current>
ffffffffc020468a:	ec06                	sd	ra,24(sp)
ffffffffc020468c:	779c                	ld	a5,40(a5)
ffffffffc020468e:	842e                	mv	s0,a1
ffffffffc0204690:	84aa                	mv	s1,a0
ffffffffc0204692:	c599                	beqz	a1,ffffffffc02046a0 <do_wait+0x24>
ffffffffc0204694:	4685                	li	a3,1
ffffffffc0204696:	4611                	li	a2,4
ffffffffc0204698:	853e                	mv	a0,a5
ffffffffc020469a:	a21fe0ef          	jal	ffffffffc02030ba <user_mem_check>
ffffffffc020469e:	c909                	beqz	a0,ffffffffc02046b0 <do_wait+0x34>
ffffffffc02046a0:	85a2                	mv	a1,s0
ffffffffc02046a2:	6442                	ld	s0,16(sp)
ffffffffc02046a4:	60e2                	ld	ra,24(sp)
ffffffffc02046a6:	8526                	mv	a0,s1
ffffffffc02046a8:	64a2                	ld	s1,8(sp)
ffffffffc02046aa:	6105                	add	sp,sp,32
ffffffffc02046ac:	fceff06f          	j	ffffffffc0203e7a <do_wait.part.0>
ffffffffc02046b0:	60e2                	ld	ra,24(sp)
ffffffffc02046b2:	6442                	ld	s0,16(sp)
ffffffffc02046b4:	64a2                	ld	s1,8(sp)
ffffffffc02046b6:	5575                	li	a0,-3
ffffffffc02046b8:	6105                	add	sp,sp,32
ffffffffc02046ba:	8082                	ret

ffffffffc02046bc <do_kill>:
ffffffffc02046bc:	6789                	lui	a5,0x2
ffffffffc02046be:	fff5071b          	addw	a4,a0,-1
ffffffffc02046c2:	17f9                	add	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02046c4:	06e7e963          	bltu	a5,a4,ffffffffc0204736 <do_kill+0x7a>
ffffffffc02046c8:	1141                	add	sp,sp,-16
ffffffffc02046ca:	e022                	sd	s0,0(sp)
ffffffffc02046cc:	45a9                	li	a1,10
ffffffffc02046ce:	842a                	mv	s0,a0
ffffffffc02046d0:	2501                	sext.w	a0,a0
ffffffffc02046d2:	e406                	sd	ra,8(sp)
ffffffffc02046d4:	5e1000ef          	jal	ffffffffc02054b4 <hash32>
ffffffffc02046d8:	02051793          	sll	a5,a0,0x20
ffffffffc02046dc:	01c7d513          	srl	a0,a5,0x1c
ffffffffc02046e0:	0000f797          	auipc	a5,0xf
ffffffffc02046e4:	ec078793          	add	a5,a5,-320 # ffffffffc02135a0 <hash_list>
ffffffffc02046e8:	953e                	add	a0,a0,a5
ffffffffc02046ea:	87aa                	mv	a5,a0
ffffffffc02046ec:	a029                	j	ffffffffc02046f6 <do_kill+0x3a>
ffffffffc02046ee:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02046f2:	00870a63          	beq	a4,s0,ffffffffc0204706 <do_kill+0x4a>
ffffffffc02046f6:	679c                	ld	a5,8(a5)
ffffffffc02046f8:	fef51be3          	bne	a0,a5,ffffffffc02046ee <do_kill+0x32>
ffffffffc02046fc:	5575                	li	a0,-3
ffffffffc02046fe:	60a2                	ld	ra,8(sp)
ffffffffc0204700:	6402                	ld	s0,0(sp)
ffffffffc0204702:	0141                	add	sp,sp,16
ffffffffc0204704:	8082                	ret
ffffffffc0204706:	fd87a703          	lw	a4,-40(a5)
ffffffffc020470a:	555d                	li	a0,-9
ffffffffc020470c:	00177693          	and	a3,a4,1
ffffffffc0204710:	f6fd                	bnez	a3,ffffffffc02046fe <do_kill+0x42>
ffffffffc0204712:	4bd4                	lw	a3,20(a5)
ffffffffc0204714:	00176713          	or	a4,a4,1
ffffffffc0204718:	fce7ac23          	sw	a4,-40(a5)
ffffffffc020471c:	0006c763          	bltz	a3,ffffffffc020472a <do_kill+0x6e>
ffffffffc0204720:	4501                	li	a0,0
ffffffffc0204722:	60a2                	ld	ra,8(sp)
ffffffffc0204724:	6402                	ld	s0,0(sp)
ffffffffc0204726:	0141                	add	sp,sp,16
ffffffffc0204728:	8082                	ret
ffffffffc020472a:	f2878513          	add	a0,a5,-216
ffffffffc020472e:	02d000ef          	jal	ffffffffc0204f5a <wakeup_proc>
ffffffffc0204732:	4501                	li	a0,0
ffffffffc0204734:	b7fd                	j	ffffffffc0204722 <do_kill+0x66>
ffffffffc0204736:	5575                	li	a0,-3
ffffffffc0204738:	8082                	ret

ffffffffc020473a <proc_init>:
ffffffffc020473a:	1101                	add	sp,sp,-32
ffffffffc020473c:	e426                	sd	s1,8(sp)
ffffffffc020473e:	00013797          	auipc	a5,0x13
ffffffffc0204742:	e6278793          	add	a5,a5,-414 # ffffffffc02175a0 <proc_list>
ffffffffc0204746:	ec06                	sd	ra,24(sp)
ffffffffc0204748:	e822                	sd	s0,16(sp)
ffffffffc020474a:	e04a                	sd	s2,0(sp)
ffffffffc020474c:	0000f497          	auipc	s1,0xf
ffffffffc0204750:	e5448493          	add	s1,s1,-428 # ffffffffc02135a0 <hash_list>
ffffffffc0204754:	e79c                	sd	a5,8(a5)
ffffffffc0204756:	e39c                	sd	a5,0(a5)
ffffffffc0204758:	00013717          	auipc	a4,0x13
ffffffffc020475c:	e4870713          	add	a4,a4,-440 # ffffffffc02175a0 <proc_list>
ffffffffc0204760:	87a6                	mv	a5,s1
ffffffffc0204762:	e79c                	sd	a5,8(a5)
ffffffffc0204764:	e39c                	sd	a5,0(a5)
ffffffffc0204766:	07c1                	add	a5,a5,16
ffffffffc0204768:	fef71de3          	bne	a4,a5,ffffffffc0204762 <proc_init+0x28>
ffffffffc020476c:	fb1fe0ef          	jal	ffffffffc020371c <alloc_proc>
ffffffffc0204770:	00013917          	auipc	s2,0x13
ffffffffc0204774:	ef890913          	add	s2,s2,-264 # ffffffffc0217668 <idleproc>
ffffffffc0204778:	00a93023          	sd	a0,0(s2)
ffffffffc020477c:	10050063          	beqz	a0,ffffffffc020487c <proc_init+0x142>
ffffffffc0204780:	4789                	li	a5,2
ffffffffc0204782:	e11c                	sd	a5,0(a0)
ffffffffc0204784:	00005797          	auipc	a5,0x5
ffffffffc0204788:	87c78793          	add	a5,a5,-1924 # ffffffffc0209000 <bootstack>
ffffffffc020478c:	0b450413          	add	s0,a0,180
ffffffffc0204790:	e91c                	sd	a5,16(a0)
ffffffffc0204792:	4785                	li	a5,1
ffffffffc0204794:	ed1c                	sd	a5,24(a0)
ffffffffc0204796:	4641                	li	a2,16
ffffffffc0204798:	4581                	li	a1,0
ffffffffc020479a:	8522                	mv	a0,s0
ffffffffc020479c:	182010ef          	jal	ffffffffc020591e <memset>
ffffffffc02047a0:	463d                	li	a2,15
ffffffffc02047a2:	00003597          	auipc	a1,0x3
ffffffffc02047a6:	b5658593          	add	a1,a1,-1194 # ffffffffc02072f8 <default_pmm_manager+0xc68>
ffffffffc02047aa:	8522                	mv	a0,s0
ffffffffc02047ac:	184010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc02047b0:	00013717          	auipc	a4,0x13
ffffffffc02047b4:	ea070713          	add	a4,a4,-352 # ffffffffc0217650 <nr_process>
ffffffffc02047b8:	431c                	lw	a5,0(a4)
ffffffffc02047ba:	00093683          	ld	a3,0(s2)
ffffffffc02047be:	4601                	li	a2,0
ffffffffc02047c0:	2785                	addw	a5,a5,1
ffffffffc02047c2:	4581                	li	a1,0
ffffffffc02047c4:	00000517          	auipc	a0,0x0
ffffffffc02047c8:	88850513          	add	a0,a0,-1912 # ffffffffc020404c <init_main>
ffffffffc02047cc:	c31c                	sw	a5,0(a4)
ffffffffc02047ce:	00013797          	auipc	a5,0x13
ffffffffc02047d2:	e8d7b523          	sd	a3,-374(a5) # ffffffffc0217658 <current>
ffffffffc02047d6:	d08ff0ef          	jal	ffffffffc0203cde <kernel_thread>
ffffffffc02047da:	842a                	mv	s0,a0
ffffffffc02047dc:	08a05463          	blez	a0,ffffffffc0204864 <proc_init+0x12a>
ffffffffc02047e0:	6789                	lui	a5,0x2
ffffffffc02047e2:	fff5071b          	addw	a4,a0,-1
ffffffffc02047e6:	17f9                	add	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02047e8:	2501                	sext.w	a0,a0
ffffffffc02047ea:	02e7e463          	bltu	a5,a4,ffffffffc0204812 <proc_init+0xd8>
ffffffffc02047ee:	45a9                	li	a1,10
ffffffffc02047f0:	4c5000ef          	jal	ffffffffc02054b4 <hash32>
ffffffffc02047f4:	02051713          	sll	a4,a0,0x20
ffffffffc02047f8:	01c75793          	srl	a5,a4,0x1c
ffffffffc02047fc:	00f486b3          	add	a3,s1,a5
ffffffffc0204800:	87b6                	mv	a5,a3
ffffffffc0204802:	a029                	j	ffffffffc020480c <proc_init+0xd2>
ffffffffc0204804:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204808:	04870b63          	beq	a4,s0,ffffffffc020485e <proc_init+0x124>
ffffffffc020480c:	679c                	ld	a5,8(a5)
ffffffffc020480e:	fef69be3          	bne	a3,a5,ffffffffc0204804 <proc_init+0xca>
ffffffffc0204812:	4781                	li	a5,0
ffffffffc0204814:	0b478493          	add	s1,a5,180
ffffffffc0204818:	4641                	li	a2,16
ffffffffc020481a:	4581                	li	a1,0
ffffffffc020481c:	00013417          	auipc	s0,0x13
ffffffffc0204820:	e4440413          	add	s0,s0,-444 # ffffffffc0217660 <initproc>
ffffffffc0204824:	8526                	mv	a0,s1
ffffffffc0204826:	e01c                	sd	a5,0(s0)
ffffffffc0204828:	0f6010ef          	jal	ffffffffc020591e <memset>
ffffffffc020482c:	463d                	li	a2,15
ffffffffc020482e:	00003597          	auipc	a1,0x3
ffffffffc0204832:	af258593          	add	a1,a1,-1294 # ffffffffc0207320 <default_pmm_manager+0xc90>
ffffffffc0204836:	8526                	mv	a0,s1
ffffffffc0204838:	0f8010ef          	jal	ffffffffc0205930 <memcpy>
ffffffffc020483c:	00093783          	ld	a5,0(s2)
ffffffffc0204840:	cbb5                	beqz	a5,ffffffffc02048b4 <proc_init+0x17a>
ffffffffc0204842:	43dc                	lw	a5,4(a5)
ffffffffc0204844:	eba5                	bnez	a5,ffffffffc02048b4 <proc_init+0x17a>
ffffffffc0204846:	601c                	ld	a5,0(s0)
ffffffffc0204848:	c7b1                	beqz	a5,ffffffffc0204894 <proc_init+0x15a>
ffffffffc020484a:	43d8                	lw	a4,4(a5)
ffffffffc020484c:	4785                	li	a5,1
ffffffffc020484e:	04f71363          	bne	a4,a5,ffffffffc0204894 <proc_init+0x15a>
ffffffffc0204852:	60e2                	ld	ra,24(sp)
ffffffffc0204854:	6442                	ld	s0,16(sp)
ffffffffc0204856:	64a2                	ld	s1,8(sp)
ffffffffc0204858:	6902                	ld	s2,0(sp)
ffffffffc020485a:	6105                	add	sp,sp,32
ffffffffc020485c:	8082                	ret
ffffffffc020485e:	f2878793          	add	a5,a5,-216
ffffffffc0204862:	bf4d                	j	ffffffffc0204814 <proc_init+0xda>
ffffffffc0204864:	00003617          	auipc	a2,0x3
ffffffffc0204868:	a9c60613          	add	a2,a2,-1380 # ffffffffc0207300 <default_pmm_manager+0xc70>
ffffffffc020486c:	38200593          	li	a1,898
ffffffffc0204870:	00002517          	auipc	a0,0x2
ffffffffc0204874:	76850513          	add	a0,a0,1896 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204878:	bfbfb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020487c:	00003617          	auipc	a2,0x3
ffffffffc0204880:	a6460613          	add	a2,a2,-1436 # ffffffffc02072e0 <default_pmm_manager+0xc50>
ffffffffc0204884:	37400593          	li	a1,884
ffffffffc0204888:	00002517          	auipc	a0,0x2
ffffffffc020488c:	75050513          	add	a0,a0,1872 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc0204890:	be3fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204894:	00003697          	auipc	a3,0x3
ffffffffc0204898:	abc68693          	add	a3,a3,-1348 # ffffffffc0207350 <default_pmm_manager+0xcc0>
ffffffffc020489c:	00001617          	auipc	a2,0x1
ffffffffc02048a0:	75c60613          	add	a2,a2,1884 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02048a4:	38900593          	li	a1,905
ffffffffc02048a8:	00002517          	auipc	a0,0x2
ffffffffc02048ac:	73050513          	add	a0,a0,1840 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc02048b0:	bc3fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02048b4:	00003697          	auipc	a3,0x3
ffffffffc02048b8:	a7468693          	add	a3,a3,-1420 # ffffffffc0207328 <default_pmm_manager+0xc98>
ffffffffc02048bc:	00001617          	auipc	a2,0x1
ffffffffc02048c0:	73c60613          	add	a2,a2,1852 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02048c4:	38800593          	li	a1,904
ffffffffc02048c8:	00002517          	auipc	a0,0x2
ffffffffc02048cc:	71050513          	add	a0,a0,1808 # ffffffffc0206fd8 <default_pmm_manager+0x948>
ffffffffc02048d0:	ba3fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02048d4 <cpu_idle>:
ffffffffc02048d4:	1141                	add	sp,sp,-16
ffffffffc02048d6:	e022                	sd	s0,0(sp)
ffffffffc02048d8:	e406                	sd	ra,8(sp)
ffffffffc02048da:	00013417          	auipc	s0,0x13
ffffffffc02048de:	d7e40413          	add	s0,s0,-642 # ffffffffc0217658 <current>
ffffffffc02048e2:	6018                	ld	a4,0(s0)
ffffffffc02048e4:	6f1c                	ld	a5,24(a4)
ffffffffc02048e6:	dffd                	beqz	a5,ffffffffc02048e4 <cpu_idle+0x10>
ffffffffc02048e8:	776000ef          	jal	ffffffffc020505e <schedule>
ffffffffc02048ec:	bfdd                	j	ffffffffc02048e2 <cpu_idle+0xe>

ffffffffc02048ee <lab6_set_priority>:
ffffffffc02048ee:	1141                	add	sp,sp,-16
ffffffffc02048f0:	e022                	sd	s0,0(sp)
ffffffffc02048f2:	85aa                	mv	a1,a0
ffffffffc02048f4:	842a                	mv	s0,a0
ffffffffc02048f6:	00003517          	auipc	a0,0x3
ffffffffc02048fa:	a8250513          	add	a0,a0,-1406 # ffffffffc0207378 <default_pmm_manager+0xce8>
ffffffffc02048fe:	e406                	sd	ra,8(sp)
ffffffffc0204900:	88bfb0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0204904:	00013797          	auipc	a5,0x13
ffffffffc0204908:	d547b783          	ld	a5,-684(a5) # ffffffffc0217658 <current>
ffffffffc020490c:	e801                	bnez	s0,ffffffffc020491c <lab6_set_priority+0x2e>
ffffffffc020490e:	60a2                	ld	ra,8(sp)
ffffffffc0204910:	6402                	ld	s0,0(sp)
ffffffffc0204912:	4705                	li	a4,1
ffffffffc0204914:	14e7a223          	sw	a4,324(a5)
ffffffffc0204918:	0141                	add	sp,sp,16
ffffffffc020491a:	8082                	ret
ffffffffc020491c:	60a2                	ld	ra,8(sp)
ffffffffc020491e:	1487a223          	sw	s0,324(a5)
ffffffffc0204922:	6402                	ld	s0,0(sp)
ffffffffc0204924:	0141                	add	sp,sp,16
ffffffffc0204926:	8082                	ret

ffffffffc0204928 <do_sleep>:
ffffffffc0204928:	c539                	beqz	a0,ffffffffc0204976 <do_sleep+0x4e>
ffffffffc020492a:	7179                	add	sp,sp,-48
ffffffffc020492c:	f022                	sd	s0,32(sp)
ffffffffc020492e:	f406                	sd	ra,40(sp)
ffffffffc0204930:	842a                	mv	s0,a0
ffffffffc0204932:	100027f3          	csrr	a5,sstatus
ffffffffc0204936:	8b89                	and	a5,a5,2
ffffffffc0204938:	e3a9                	bnez	a5,ffffffffc020497a <do_sleep+0x52>
ffffffffc020493a:	00013797          	auipc	a5,0x13
ffffffffc020493e:	d1e7b783          	ld	a5,-738(a5) # ffffffffc0217658 <current>
ffffffffc0204942:	0818                	add	a4,sp,16
ffffffffc0204944:	c02a                	sw	a0,0(sp)
ffffffffc0204946:	ec3a                	sd	a4,24(sp)
ffffffffc0204948:	e83a                	sd	a4,16(sp)
ffffffffc020494a:	e43e                	sd	a5,8(sp)
ffffffffc020494c:	4705                	li	a4,1
ffffffffc020494e:	c398                	sw	a4,0(a5)
ffffffffc0204950:	80000737          	lui	a4,0x80000
ffffffffc0204954:	840a                	mv	s0,sp
ffffffffc0204956:	0709                	add	a4,a4,2 # ffffffff80000002 <kern_entry-0x401ffffe>
ffffffffc0204958:	0ee7a623          	sw	a4,236(a5)
ffffffffc020495c:	8522                	mv	a0,s0
ffffffffc020495e:	7c0000ef          	jal	ffffffffc020511e <add_timer>
ffffffffc0204962:	6fc000ef          	jal	ffffffffc020505e <schedule>
ffffffffc0204966:	8522                	mv	a0,s0
ffffffffc0204968:	07d000ef          	jal	ffffffffc02051e4 <del_timer>
ffffffffc020496c:	70a2                	ld	ra,40(sp)
ffffffffc020496e:	7402                	ld	s0,32(sp)
ffffffffc0204970:	4501                	li	a0,0
ffffffffc0204972:	6145                	add	sp,sp,48
ffffffffc0204974:	8082                	ret
ffffffffc0204976:	4501                	li	a0,0
ffffffffc0204978:	8082                	ret
ffffffffc020497a:	cbbfb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020497e:	00013797          	auipc	a5,0x13
ffffffffc0204982:	cda7b783          	ld	a5,-806(a5) # ffffffffc0217658 <current>
ffffffffc0204986:	0818                	add	a4,sp,16
ffffffffc0204988:	c022                	sw	s0,0(sp)
ffffffffc020498a:	e43e                	sd	a5,8(sp)
ffffffffc020498c:	ec3a                	sd	a4,24(sp)
ffffffffc020498e:	e83a                	sd	a4,16(sp)
ffffffffc0204990:	4705                	li	a4,1
ffffffffc0204992:	c398                	sw	a4,0(a5)
ffffffffc0204994:	80000737          	lui	a4,0x80000
ffffffffc0204998:	0709                	add	a4,a4,2 # ffffffff80000002 <kern_entry-0x401ffffe>
ffffffffc020499a:	840a                	mv	s0,sp
ffffffffc020499c:	8522                	mv	a0,s0
ffffffffc020499e:	0ee7a623          	sw	a4,236(a5)
ffffffffc02049a2:	77c000ef          	jal	ffffffffc020511e <add_timer>
ffffffffc02049a6:	c89fb0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02049aa:	bf65                	j	ffffffffc0204962 <do_sleep+0x3a>

ffffffffc02049ac <switch_to>:
ffffffffc02049ac:	00153023          	sd	ra,0(a0)
ffffffffc02049b0:	00253423          	sd	sp,8(a0)
ffffffffc02049b4:	e900                	sd	s0,16(a0)
ffffffffc02049b6:	ed04                	sd	s1,24(a0)
ffffffffc02049b8:	03253023          	sd	s2,32(a0)
ffffffffc02049bc:	03353423          	sd	s3,40(a0)
ffffffffc02049c0:	03453823          	sd	s4,48(a0)
ffffffffc02049c4:	03553c23          	sd	s5,56(a0)
ffffffffc02049c8:	05653023          	sd	s6,64(a0)
ffffffffc02049cc:	05753423          	sd	s7,72(a0)
ffffffffc02049d0:	05853823          	sd	s8,80(a0)
ffffffffc02049d4:	05953c23          	sd	s9,88(a0)
ffffffffc02049d8:	07a53023          	sd	s10,96(a0)
ffffffffc02049dc:	07b53423          	sd	s11,104(a0)
ffffffffc02049e0:	0005b083          	ld	ra,0(a1)
ffffffffc02049e4:	0085b103          	ld	sp,8(a1)
ffffffffc02049e8:	6980                	ld	s0,16(a1)
ffffffffc02049ea:	6d84                	ld	s1,24(a1)
ffffffffc02049ec:	0205b903          	ld	s2,32(a1)
ffffffffc02049f0:	0285b983          	ld	s3,40(a1)
ffffffffc02049f4:	0305ba03          	ld	s4,48(a1)
ffffffffc02049f8:	0385ba83          	ld	s5,56(a1)
ffffffffc02049fc:	0405bb03          	ld	s6,64(a1)
ffffffffc0204a00:	0485bb83          	ld	s7,72(a1)
ffffffffc0204a04:	0505bc03          	ld	s8,80(a1)
ffffffffc0204a08:	0585bc83          	ld	s9,88(a1)
ffffffffc0204a0c:	0605bd03          	ld	s10,96(a1)
ffffffffc0204a10:	0685bd83          	ld	s11,104(a1)
ffffffffc0204a14:	8082                	ret

ffffffffc0204a16 <stride_init>:
ffffffffc0204a16:	e508                	sd	a0,8(a0)
ffffffffc0204a18:	e108                	sd	a0,0(a0)
ffffffffc0204a1a:	00053c23          	sd	zero,24(a0)
ffffffffc0204a1e:	00052823          	sw	zero,16(a0)
ffffffffc0204a22:	8082                	ret

ffffffffc0204a24 <stride_pick_next>:
ffffffffc0204a24:	6d1c                	ld	a5,24(a0)
ffffffffc0204a26:	cf89                	beqz	a5,ffffffffc0204a40 <stride_pick_next+0x1c>
ffffffffc0204a28:	4fd0                	lw	a2,28(a5)
ffffffffc0204a2a:	4f98                	lw	a4,24(a5)
ffffffffc0204a2c:	ed878513          	add	a0,a5,-296
ffffffffc0204a30:	400006b7          	lui	a3,0x40000
ffffffffc0204a34:	c219                	beqz	a2,ffffffffc0204a3a <stride_pick_next+0x16>
ffffffffc0204a36:	02c6d6bb          	divuw	a3,a3,a2
ffffffffc0204a3a:	9f35                	addw	a4,a4,a3
ffffffffc0204a3c:	cf98                	sw	a4,24(a5)
ffffffffc0204a3e:	8082                	ret
ffffffffc0204a40:	4501                	li	a0,0
ffffffffc0204a42:	8082                	ret

ffffffffc0204a44 <stride_proc_tick>:
ffffffffc0204a44:	1205a783          	lw	a5,288(a1)
ffffffffc0204a48:	00f05563          	blez	a5,ffffffffc0204a52 <stride_proc_tick+0xe>
ffffffffc0204a4c:	37fd                	addw	a5,a5,-1
ffffffffc0204a4e:	12f5a023          	sw	a5,288(a1)
ffffffffc0204a52:	e399                	bnez	a5,ffffffffc0204a58 <stride_proc_tick+0x14>
ffffffffc0204a54:	4785                	li	a5,1
ffffffffc0204a56:	ed9c                	sd	a5,24(a1)
ffffffffc0204a58:	8082                	ret

ffffffffc0204a5a <skew_heap_merge.constprop.0>:
ffffffffc0204a5a:	7139                	add	sp,sp,-64
ffffffffc0204a5c:	f822                	sd	s0,48(sp)
ffffffffc0204a5e:	fc06                	sd	ra,56(sp)
ffffffffc0204a60:	f426                	sd	s1,40(sp)
ffffffffc0204a62:	f04a                	sd	s2,32(sp)
ffffffffc0204a64:	ec4e                	sd	s3,24(sp)
ffffffffc0204a66:	e852                	sd	s4,16(sp)
ffffffffc0204a68:	e456                	sd	s5,8(sp)
ffffffffc0204a6a:	e05a                	sd	s6,0(sp)
ffffffffc0204a6c:	842e                	mv	s0,a1
ffffffffc0204a6e:	c52d                	beqz	a0,ffffffffc0204ad8 <skew_heap_merge.constprop.0+0x7e>
ffffffffc0204a70:	892a                	mv	s2,a0
ffffffffc0204a72:	cde1                	beqz	a1,ffffffffc0204b4a <skew_heap_merge.constprop.0+0xf0>
ffffffffc0204a74:	4d1c                	lw	a5,24(a0)
ffffffffc0204a76:	4d98                	lw	a4,24(a1)
ffffffffc0204a78:	40e786bb          	subw	a3,a5,a4
ffffffffc0204a7c:	0606c963          	bltz	a3,ffffffffc0204aee <skew_heap_merge.constprop.0+0x94>
ffffffffc0204a80:	6984                	ld	s1,16(a1)
ffffffffc0204a82:	0085ba03          	ld	s4,8(a1)
ffffffffc0204a86:	10048063          	beqz	s1,ffffffffc0204b86 <skew_heap_merge.constprop.0+0x12c>
ffffffffc0204a8a:	4c98                	lw	a4,24(s1)
ffffffffc0204a8c:	40e786bb          	subw	a3,a5,a4
ffffffffc0204a90:	0a06cf63          	bltz	a3,ffffffffc0204b4e <skew_heap_merge.constprop.0+0xf4>
ffffffffc0204a94:	0104b983          	ld	s3,16(s1)
ffffffffc0204a98:	0084ba83          	ld	s5,8(s1)
ffffffffc0204a9c:	10098e63          	beqz	s3,ffffffffc0204bb8 <skew_heap_merge.constprop.0+0x15e>
ffffffffc0204aa0:	0189a703          	lw	a4,24(s3) # 1018 <kern_entry-0xffffffffc01fefe8>
ffffffffc0204aa4:	9f99                	subw	a5,a5,a4
ffffffffc0204aa6:	0e07cc63          	bltz	a5,ffffffffc0204b9e <skew_heap_merge.constprop.0+0x144>
ffffffffc0204aaa:	0109b583          	ld	a1,16(s3)
ffffffffc0204aae:	0089b903          	ld	s2,8(s3)
ffffffffc0204ab2:	fa9ff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204ab6:	00a9b423          	sd	a0,8(s3)
ffffffffc0204aba:	0129b823          	sd	s2,16(s3)
ffffffffc0204abe:	c119                	beqz	a0,ffffffffc0204ac4 <skew_heap_merge.constprop.0+0x6a>
ffffffffc0204ac0:	01353023          	sd	s3,0(a0)
ffffffffc0204ac4:	0134b423          	sd	s3,8(s1)
ffffffffc0204ac8:	0154b823          	sd	s5,16(s1)
ffffffffc0204acc:	0099b023          	sd	s1,0(s3)
ffffffffc0204ad0:	e404                	sd	s1,8(s0)
ffffffffc0204ad2:	01443823          	sd	s4,16(s0)
ffffffffc0204ad6:	e080                	sd	s0,0(s1)
ffffffffc0204ad8:	8522                	mv	a0,s0
ffffffffc0204ada:	70e2                	ld	ra,56(sp)
ffffffffc0204adc:	7442                	ld	s0,48(sp)
ffffffffc0204ade:	74a2                	ld	s1,40(sp)
ffffffffc0204ae0:	7902                	ld	s2,32(sp)
ffffffffc0204ae2:	69e2                	ld	s3,24(sp)
ffffffffc0204ae4:	6a42                	ld	s4,16(sp)
ffffffffc0204ae6:	6aa2                	ld	s5,8(sp)
ffffffffc0204ae8:	6b02                	ld	s6,0(sp)
ffffffffc0204aea:	6121                	add	sp,sp,64
ffffffffc0204aec:	8082                	ret
ffffffffc0204aee:	6904                	ld	s1,16(a0)
ffffffffc0204af0:	00853a03          	ld	s4,8(a0)
ffffffffc0204af4:	c4a9                	beqz	s1,ffffffffc0204b3e <skew_heap_merge.constprop.0+0xe4>
ffffffffc0204af6:	4c9c                	lw	a5,24(s1)
ffffffffc0204af8:	40e7873b          	subw	a4,a5,a4
ffffffffc0204afc:	08074763          	bltz	a4,ffffffffc0204b8a <skew_heap_merge.constprop.0+0x130>
ffffffffc0204b00:	0105b983          	ld	s3,16(a1)
ffffffffc0204b04:	0085ba83          	ld	s5,8(a1)
ffffffffc0204b08:	0c098563          	beqz	s3,ffffffffc0204bd2 <skew_heap_merge.constprop.0+0x178>
ffffffffc0204b0c:	0189a703          	lw	a4,24(s3)
ffffffffc0204b10:	9f99                	subw	a5,a5,a4
ffffffffc0204b12:	0a07c563          	bltz	a5,ffffffffc0204bbc <skew_heap_merge.constprop.0+0x162>
ffffffffc0204b16:	0109b583          	ld	a1,16(s3)
ffffffffc0204b1a:	0089bb03          	ld	s6,8(s3)
ffffffffc0204b1e:	8526                	mv	a0,s1
ffffffffc0204b20:	f3bff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204b24:	00a9b423          	sd	a0,8(s3)
ffffffffc0204b28:	0169b823          	sd	s6,16(s3)
ffffffffc0204b2c:	c119                	beqz	a0,ffffffffc0204b32 <skew_heap_merge.constprop.0+0xd8>
ffffffffc0204b2e:	01353023          	sd	s3,0(a0)
ffffffffc0204b32:	01343423          	sd	s3,8(s0)
ffffffffc0204b36:	01543823          	sd	s5,16(s0)
ffffffffc0204b3a:	0089b023          	sd	s0,0(s3)
ffffffffc0204b3e:	00893423          	sd	s0,8(s2)
ffffffffc0204b42:	01493823          	sd	s4,16(s2)
ffffffffc0204b46:	01243023          	sd	s2,0(s0)
ffffffffc0204b4a:	854a                	mv	a0,s2
ffffffffc0204b4c:	b779                	j	ffffffffc0204ada <skew_heap_merge.constprop.0+0x80>
ffffffffc0204b4e:	01053983          	ld	s3,16(a0)
ffffffffc0204b52:	00853a83          	ld	s5,8(a0)
ffffffffc0204b56:	02098263          	beqz	s3,ffffffffc0204b7a <skew_heap_merge.constprop.0+0x120>
ffffffffc0204b5a:	0189a783          	lw	a5,24(s3)
ffffffffc0204b5e:	9f99                	subw	a5,a5,a4
ffffffffc0204b60:	0607cb63          	bltz	a5,ffffffffc0204bd6 <skew_heap_merge.constprop.0+0x17c>
ffffffffc0204b64:	688c                	ld	a1,16(s1)
ffffffffc0204b66:	0084bb03          	ld	s6,8(s1)
ffffffffc0204b6a:	854e                	mv	a0,s3
ffffffffc0204b6c:	eefff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204b70:	e488                	sd	a0,8(s1)
ffffffffc0204b72:	0164b823          	sd	s6,16(s1)
ffffffffc0204b76:	c111                	beqz	a0,ffffffffc0204b7a <skew_heap_merge.constprop.0+0x120>
ffffffffc0204b78:	e104                	sd	s1,0(a0)
ffffffffc0204b7a:	00993423          	sd	s1,8(s2)
ffffffffc0204b7e:	01593823          	sd	s5,16(s2)
ffffffffc0204b82:	0124b023          	sd	s2,0(s1)
ffffffffc0204b86:	84ca                	mv	s1,s2
ffffffffc0204b88:	b7a1                	j	ffffffffc0204ad0 <skew_heap_merge.constprop.0+0x76>
ffffffffc0204b8a:	6888                	ld	a0,16(s1)
ffffffffc0204b8c:	6480                	ld	s0,8(s1)
ffffffffc0204b8e:	ecdff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204b92:	e488                	sd	a0,8(s1)
ffffffffc0204b94:	e880                	sd	s0,16(s1)
ffffffffc0204b96:	c111                	beqz	a0,ffffffffc0204b9a <skew_heap_merge.constprop.0+0x140>
ffffffffc0204b98:	e104                	sd	s1,0(a0)
ffffffffc0204b9a:	8426                	mv	s0,s1
ffffffffc0204b9c:	b74d                	j	ffffffffc0204b3e <skew_heap_merge.constprop.0+0xe4>
ffffffffc0204b9e:	6908                	ld	a0,16(a0)
ffffffffc0204ba0:	00893b03          	ld	s6,8(s2)
ffffffffc0204ba4:	85ce                	mv	a1,s3
ffffffffc0204ba6:	eb5ff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204baa:	00a93423          	sd	a0,8(s2)
ffffffffc0204bae:	01693823          	sd	s6,16(s2)
ffffffffc0204bb2:	c119                	beqz	a0,ffffffffc0204bb8 <skew_heap_merge.constprop.0+0x15e>
ffffffffc0204bb4:	01253023          	sd	s2,0(a0)
ffffffffc0204bb8:	89ca                	mv	s3,s2
ffffffffc0204bba:	b729                	j	ffffffffc0204ac4 <skew_heap_merge.constprop.0+0x6a>
ffffffffc0204bbc:	6888                	ld	a0,16(s1)
ffffffffc0204bbe:	0084bb03          	ld	s6,8(s1)
ffffffffc0204bc2:	85ce                	mv	a1,s3
ffffffffc0204bc4:	e97ff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204bc8:	e488                	sd	a0,8(s1)
ffffffffc0204bca:	0164b823          	sd	s6,16(s1)
ffffffffc0204bce:	c111                	beqz	a0,ffffffffc0204bd2 <skew_heap_merge.constprop.0+0x178>
ffffffffc0204bd0:	e104                	sd	s1,0(a0)
ffffffffc0204bd2:	89a6                	mv	s3,s1
ffffffffc0204bd4:	bfb9                	j	ffffffffc0204b32 <skew_heap_merge.constprop.0+0xd8>
ffffffffc0204bd6:	0109b503          	ld	a0,16(s3)
ffffffffc0204bda:	0089bb03          	ld	s6,8(s3)
ffffffffc0204bde:	85a6                	mv	a1,s1
ffffffffc0204be0:	e7bff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204be4:	00a9b423          	sd	a0,8(s3)
ffffffffc0204be8:	0169b823          	sd	s6,16(s3)
ffffffffc0204bec:	c119                	beqz	a0,ffffffffc0204bf2 <skew_heap_merge.constprop.0+0x198>
ffffffffc0204bee:	01353023          	sd	s3,0(a0)
ffffffffc0204bf2:	84ce                	mv	s1,s3
ffffffffc0204bf4:	b759                	j	ffffffffc0204b7a <skew_heap_merge.constprop.0+0x120>

ffffffffc0204bf6 <stride_enqueue>:
ffffffffc0204bf6:	7139                	add	sp,sp,-64
ffffffffc0204bf8:	f04a                	sd	s2,32(sp)
ffffffffc0204bfa:	01853903          	ld	s2,24(a0)
ffffffffc0204bfe:	f822                	sd	s0,48(sp)
ffffffffc0204c00:	f426                	sd	s1,40(sp)
ffffffffc0204c02:	fc06                	sd	ra,56(sp)
ffffffffc0204c04:	ec4e                	sd	s3,24(sp)
ffffffffc0204c06:	e852                	sd	s4,16(sp)
ffffffffc0204c08:	e456                	sd	s5,8(sp)
ffffffffc0204c0a:	1205b423          	sd	zero,296(a1)
ffffffffc0204c0e:	1205bc23          	sd	zero,312(a1)
ffffffffc0204c12:	1205b823          	sd	zero,304(a1)
ffffffffc0204c16:	842e                	mv	s0,a1
ffffffffc0204c18:	84aa                	mv	s1,a0
ffffffffc0204c1a:	12858593          	add	a1,a1,296
ffffffffc0204c1e:	00090d63          	beqz	s2,ffffffffc0204c38 <stride_enqueue+0x42>
ffffffffc0204c22:	14042703          	lw	a4,320(s0)
ffffffffc0204c26:	01892783          	lw	a5,24(s2)
ffffffffc0204c2a:	9f99                	subw	a5,a5,a4
ffffffffc0204c2c:	0207cd63          	bltz	a5,ffffffffc0204c66 <stride_enqueue+0x70>
ffffffffc0204c30:	13243823          	sd	s2,304(s0)
ffffffffc0204c34:	00b93023          	sd	a1,0(s2)
ffffffffc0204c38:	12042783          	lw	a5,288(s0)
ffffffffc0204c3c:	ec8c                	sd	a1,24(s1)
ffffffffc0204c3e:	48d8                	lw	a4,20(s1)
ffffffffc0204c40:	c399                	beqz	a5,ffffffffc0204c46 <stride_enqueue+0x50>
ffffffffc0204c42:	00f75463          	bge	a4,a5,ffffffffc0204c4a <stride_enqueue+0x54>
ffffffffc0204c46:	12e42023          	sw	a4,288(s0)
ffffffffc0204c4a:	489c                	lw	a5,16(s1)
ffffffffc0204c4c:	70e2                	ld	ra,56(sp)
ffffffffc0204c4e:	10943423          	sd	s1,264(s0)
ffffffffc0204c52:	7442                	ld	s0,48(sp)
ffffffffc0204c54:	2785                	addw	a5,a5,1
ffffffffc0204c56:	c89c                	sw	a5,16(s1)
ffffffffc0204c58:	7902                	ld	s2,32(sp)
ffffffffc0204c5a:	74a2                	ld	s1,40(sp)
ffffffffc0204c5c:	69e2                	ld	s3,24(sp)
ffffffffc0204c5e:	6a42                	ld	s4,16(sp)
ffffffffc0204c60:	6aa2                	ld	s5,8(sp)
ffffffffc0204c62:	6121                	add	sp,sp,64
ffffffffc0204c64:	8082                	ret
ffffffffc0204c66:	01093983          	ld	s3,16(s2)
ffffffffc0204c6a:	00893a03          	ld	s4,8(s2)
ffffffffc0204c6e:	00098b63          	beqz	s3,ffffffffc0204c84 <stride_enqueue+0x8e>
ffffffffc0204c72:	0189a783          	lw	a5,24(s3)
ffffffffc0204c76:	9f99                	subw	a5,a5,a4
ffffffffc0204c78:	0007ce63          	bltz	a5,ffffffffc0204c94 <stride_enqueue+0x9e>
ffffffffc0204c7c:	13343823          	sd	s3,304(s0)
ffffffffc0204c80:	00b9b023          	sd	a1,0(s3)
ffffffffc0204c84:	00b93423          	sd	a1,8(s2)
ffffffffc0204c88:	01493823          	sd	s4,16(s2)
ffffffffc0204c8c:	0125b023          	sd	s2,0(a1)
ffffffffc0204c90:	85ca                	mv	a1,s2
ffffffffc0204c92:	b75d                	j	ffffffffc0204c38 <stride_enqueue+0x42>
ffffffffc0204c94:	0109b503          	ld	a0,16(s3)
ffffffffc0204c98:	0089ba83          	ld	s5,8(s3)
ffffffffc0204c9c:	dbfff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204ca0:	00a9b423          	sd	a0,8(s3)
ffffffffc0204ca4:	0159b823          	sd	s5,16(s3)
ffffffffc0204ca8:	c119                	beqz	a0,ffffffffc0204cae <stride_enqueue+0xb8>
ffffffffc0204caa:	01353023          	sd	s3,0(a0)
ffffffffc0204cae:	85ce                	mv	a1,s3
ffffffffc0204cb0:	bfd1                	j	ffffffffc0204c84 <stride_enqueue+0x8e>

ffffffffc0204cb2 <stride_dequeue>:
ffffffffc0204cb2:	1085b783          	ld	a5,264(a1)
ffffffffc0204cb6:	7159                	add	sp,sp,-112
ffffffffc0204cb8:	f486                	sd	ra,104(sp)
ffffffffc0204cba:	f0a2                	sd	s0,96(sp)
ffffffffc0204cbc:	eca6                	sd	s1,88(sp)
ffffffffc0204cbe:	e8ca                	sd	s2,80(sp)
ffffffffc0204cc0:	e4ce                	sd	s3,72(sp)
ffffffffc0204cc2:	e0d2                	sd	s4,64(sp)
ffffffffc0204cc4:	fc56                	sd	s5,56(sp)
ffffffffc0204cc6:	f85a                	sd	s6,48(sp)
ffffffffc0204cc8:	f45e                	sd	s7,40(sp)
ffffffffc0204cca:	f062                	sd	s8,32(sp)
ffffffffc0204ccc:	ec66                	sd	s9,24(sp)
ffffffffc0204cce:	e86a                	sd	s10,16(sp)
ffffffffc0204cd0:	e46e                	sd	s11,8(sp)
ffffffffc0204cd2:	20a79a63          	bne	a5,a0,ffffffffc0204ee6 <stride_dequeue+0x234>
ffffffffc0204cd6:	01052903          	lw	s2,16(a0)
ffffffffc0204cda:	8b2a                	mv	s6,a0
ffffffffc0204cdc:	20090563          	beqz	s2,ffffffffc0204ee6 <stride_dequeue+0x234>
ffffffffc0204ce0:	1305b983          	ld	s3,304(a1)
ffffffffc0204ce4:	01853c03          	ld	s8,24(a0)
ffffffffc0204ce8:	1285ba03          	ld	s4,296(a1)
ffffffffc0204cec:	1385b483          	ld	s1,312(a1)
ffffffffc0204cf0:	842e                	mv	s0,a1
ffffffffc0204cf2:	12098563          	beqz	s3,ffffffffc0204e1c <stride_dequeue+0x16a>
ffffffffc0204cf6:	10048c63          	beqz	s1,ffffffffc0204e0e <stride_dequeue+0x15c>
ffffffffc0204cfa:	0189a783          	lw	a5,24(s3)
ffffffffc0204cfe:	4c98                	lw	a4,24(s1)
ffffffffc0204d00:	40e786bb          	subw	a3,a5,a4
ffffffffc0204d04:	0a06c463          	bltz	a3,ffffffffc0204dac <stride_dequeue+0xfa>
ffffffffc0204d08:	0104ba83          	ld	s5,16(s1)
ffffffffc0204d0c:	0084bc83          	ld	s9,8(s1)
ffffffffc0204d10:	140a8963          	beqz	s5,ffffffffc0204e62 <stride_dequeue+0x1b0>
ffffffffc0204d14:	018aa703          	lw	a4,24(s5)
ffffffffc0204d18:	40e786bb          	subw	a3,a5,a4
ffffffffc0204d1c:	1006c463          	bltz	a3,ffffffffc0204e24 <stride_dequeue+0x172>
ffffffffc0204d20:	010abb83          	ld	s7,16(s5)
ffffffffc0204d24:	008abd03          	ld	s10,8(s5)
ffffffffc0204d28:	160b8d63          	beqz	s7,ffffffffc0204ea2 <stride_dequeue+0x1f0>
ffffffffc0204d2c:	018ba703          	lw	a4,24(s7)
ffffffffc0204d30:	9f99                	subw	a5,a5,a4
ffffffffc0204d32:	1407ca63          	bltz	a5,ffffffffc0204e86 <stride_dequeue+0x1d4>
ffffffffc0204d36:	010bb583          	ld	a1,16(s7)
ffffffffc0204d3a:	008bbd83          	ld	s11,8(s7)
ffffffffc0204d3e:	854e                	mv	a0,s3
ffffffffc0204d40:	d1bff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204d44:	00abb423          	sd	a0,8(s7)
ffffffffc0204d48:	01bbb823          	sd	s11,16(s7)
ffffffffc0204d4c:	c119                	beqz	a0,ffffffffc0204d52 <stride_dequeue+0xa0>
ffffffffc0204d4e:	01753023          	sd	s7,0(a0)
ffffffffc0204d52:	017ab423          	sd	s7,8(s5)
ffffffffc0204d56:	01aab823          	sd	s10,16(s5)
ffffffffc0204d5a:	015bb023          	sd	s5,0(s7)
ffffffffc0204d5e:	0154b423          	sd	s5,8(s1)
ffffffffc0204d62:	0194b823          	sd	s9,16(s1)
ffffffffc0204d66:	009ab023          	sd	s1,0(s5)
ffffffffc0204d6a:	0144b023          	sd	s4,0(s1)
ffffffffc0204d6e:	000a0b63          	beqz	s4,ffffffffc0204d84 <stride_dequeue+0xd2>
ffffffffc0204d72:	008a3783          	ld	a5,8(s4)
ffffffffc0204d76:	12840413          	add	s0,s0,296
ffffffffc0204d7a:	08878e63          	beq	a5,s0,ffffffffc0204e16 <stride_dequeue+0x164>
ffffffffc0204d7e:	009a3823          	sd	s1,16(s4)
ffffffffc0204d82:	84e2                	mv	s1,s8
ffffffffc0204d84:	70a6                	ld	ra,104(sp)
ffffffffc0204d86:	7406                	ld	s0,96(sp)
ffffffffc0204d88:	397d                	addw	s2,s2,-1
ffffffffc0204d8a:	009b3c23          	sd	s1,24(s6)
ffffffffc0204d8e:	012b2823          	sw	s2,16(s6)
ffffffffc0204d92:	64e6                	ld	s1,88(sp)
ffffffffc0204d94:	6946                	ld	s2,80(sp)
ffffffffc0204d96:	69a6                	ld	s3,72(sp)
ffffffffc0204d98:	6a06                	ld	s4,64(sp)
ffffffffc0204d9a:	7ae2                	ld	s5,56(sp)
ffffffffc0204d9c:	7b42                	ld	s6,48(sp)
ffffffffc0204d9e:	7ba2                	ld	s7,40(sp)
ffffffffc0204da0:	7c02                	ld	s8,32(sp)
ffffffffc0204da2:	6ce2                	ld	s9,24(sp)
ffffffffc0204da4:	6d42                	ld	s10,16(sp)
ffffffffc0204da6:	6da2                	ld	s11,8(sp)
ffffffffc0204da8:	6165                	add	sp,sp,112
ffffffffc0204daa:	8082                	ret
ffffffffc0204dac:	0109ba83          	ld	s5,16(s3)
ffffffffc0204db0:	0089bc83          	ld	s9,8(s3)
ffffffffc0204db4:	040a8763          	beqz	s5,ffffffffc0204e02 <stride_dequeue+0x150>
ffffffffc0204db8:	018aa783          	lw	a5,24(s5)
ffffffffc0204dbc:	40e7873b          	subw	a4,a5,a4
ffffffffc0204dc0:	0a074363          	bltz	a4,ffffffffc0204e66 <stride_dequeue+0x1b4>
ffffffffc0204dc4:	0104bb83          	ld	s7,16(s1)
ffffffffc0204dc8:	0084bd03          	ld	s10,8(s1)
ffffffffc0204dcc:	100b8b63          	beqz	s7,ffffffffc0204ee2 <stride_dequeue+0x230>
ffffffffc0204dd0:	018ba703          	lw	a4,24(s7)
ffffffffc0204dd4:	9f99                	subw	a5,a5,a4
ffffffffc0204dd6:	0e07c863          	bltz	a5,ffffffffc0204ec6 <stride_dequeue+0x214>
ffffffffc0204dda:	010bb583          	ld	a1,16(s7)
ffffffffc0204dde:	008bbd83          	ld	s11,8(s7)
ffffffffc0204de2:	8556                	mv	a0,s5
ffffffffc0204de4:	c77ff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204de8:	00abb423          	sd	a0,8(s7)
ffffffffc0204dec:	01bbb823          	sd	s11,16(s7)
ffffffffc0204df0:	c119                	beqz	a0,ffffffffc0204df6 <stride_dequeue+0x144>
ffffffffc0204df2:	01753023          	sd	s7,0(a0)
ffffffffc0204df6:	0174b423          	sd	s7,8(s1)
ffffffffc0204dfa:	01a4b823          	sd	s10,16(s1)
ffffffffc0204dfe:	009bb023          	sd	s1,0(s7)
ffffffffc0204e02:	0099b423          	sd	s1,8(s3)
ffffffffc0204e06:	0199b823          	sd	s9,16(s3)
ffffffffc0204e0a:	0134b023          	sd	s3,0(s1)
ffffffffc0204e0e:	84ce                	mv	s1,s3
ffffffffc0204e10:	0144b023          	sd	s4,0(s1)
ffffffffc0204e14:	bfa9                	j	ffffffffc0204d6e <stride_dequeue+0xbc>
ffffffffc0204e16:	009a3423          	sd	s1,8(s4)
ffffffffc0204e1a:	b7a5                	j	ffffffffc0204d82 <stride_dequeue+0xd0>
ffffffffc0204e1c:	d8a9                	beqz	s1,ffffffffc0204d6e <stride_dequeue+0xbc>
ffffffffc0204e1e:	0144b023          	sd	s4,0(s1)
ffffffffc0204e22:	b7b1                	j	ffffffffc0204d6e <stride_dequeue+0xbc>
ffffffffc0204e24:	0109bb83          	ld	s7,16(s3)
ffffffffc0204e28:	0089bd03          	ld	s10,8(s3)
ffffffffc0204e2c:	020b8563          	beqz	s7,ffffffffc0204e56 <stride_dequeue+0x1a4>
ffffffffc0204e30:	018ba783          	lw	a5,24(s7)
ffffffffc0204e34:	9f99                	subw	a5,a5,a4
ffffffffc0204e36:	0607c863          	bltz	a5,ffffffffc0204ea6 <stride_dequeue+0x1f4>
ffffffffc0204e3a:	010ab583          	ld	a1,16(s5)
ffffffffc0204e3e:	008abd83          	ld	s11,8(s5)
ffffffffc0204e42:	855e                	mv	a0,s7
ffffffffc0204e44:	c17ff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204e48:	00aab423          	sd	a0,8(s5)
ffffffffc0204e4c:	01bab823          	sd	s11,16(s5)
ffffffffc0204e50:	c119                	beqz	a0,ffffffffc0204e56 <stride_dequeue+0x1a4>
ffffffffc0204e52:	01553023          	sd	s5,0(a0)
ffffffffc0204e56:	0159b423          	sd	s5,8(s3)
ffffffffc0204e5a:	01a9b823          	sd	s10,16(s3)
ffffffffc0204e5e:	013ab023          	sd	s3,0(s5)
ffffffffc0204e62:	8ace                	mv	s5,s3
ffffffffc0204e64:	bded                	j	ffffffffc0204d5e <stride_dequeue+0xac>
ffffffffc0204e66:	010ab503          	ld	a0,16(s5)
ffffffffc0204e6a:	008abb83          	ld	s7,8(s5)
ffffffffc0204e6e:	85a6                	mv	a1,s1
ffffffffc0204e70:	bebff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204e74:	00aab423          	sd	a0,8(s5)
ffffffffc0204e78:	017ab823          	sd	s7,16(s5)
ffffffffc0204e7c:	c119                	beqz	a0,ffffffffc0204e82 <stride_dequeue+0x1d0>
ffffffffc0204e7e:	01553023          	sd	s5,0(a0)
ffffffffc0204e82:	84d6                	mv	s1,s5
ffffffffc0204e84:	bfbd                	j	ffffffffc0204e02 <stride_dequeue+0x150>
ffffffffc0204e86:	0109b503          	ld	a0,16(s3)
ffffffffc0204e8a:	0089bd83          	ld	s11,8(s3)
ffffffffc0204e8e:	85de                	mv	a1,s7
ffffffffc0204e90:	bcbff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204e94:	00a9b423          	sd	a0,8(s3)
ffffffffc0204e98:	01b9b823          	sd	s11,16(s3)
ffffffffc0204e9c:	c119                	beqz	a0,ffffffffc0204ea2 <stride_dequeue+0x1f0>
ffffffffc0204e9e:	01353023          	sd	s3,0(a0)
ffffffffc0204ea2:	8bce                	mv	s7,s3
ffffffffc0204ea4:	b57d                	j	ffffffffc0204d52 <stride_dequeue+0xa0>
ffffffffc0204ea6:	010bb503          	ld	a0,16(s7)
ffffffffc0204eaa:	008bbd83          	ld	s11,8(s7)
ffffffffc0204eae:	85d6                	mv	a1,s5
ffffffffc0204eb0:	babff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204eb4:	00abb423          	sd	a0,8(s7)
ffffffffc0204eb8:	01bbb823          	sd	s11,16(s7)
ffffffffc0204ebc:	c119                	beqz	a0,ffffffffc0204ec2 <stride_dequeue+0x210>
ffffffffc0204ebe:	01753023          	sd	s7,0(a0)
ffffffffc0204ec2:	8ade                	mv	s5,s7
ffffffffc0204ec4:	bf49                	j	ffffffffc0204e56 <stride_dequeue+0x1a4>
ffffffffc0204ec6:	010ab503          	ld	a0,16(s5)
ffffffffc0204eca:	008abd83          	ld	s11,8(s5)
ffffffffc0204ece:	85de                	mv	a1,s7
ffffffffc0204ed0:	b8bff0ef          	jal	ffffffffc0204a5a <skew_heap_merge.constprop.0>
ffffffffc0204ed4:	00aab423          	sd	a0,8(s5)
ffffffffc0204ed8:	01bab823          	sd	s11,16(s5)
ffffffffc0204edc:	c119                	beqz	a0,ffffffffc0204ee2 <stride_dequeue+0x230>
ffffffffc0204ede:	01553023          	sd	s5,0(a0)
ffffffffc0204ee2:	8bd6                	mv	s7,s5
ffffffffc0204ee4:	bf09                	j	ffffffffc0204df6 <stride_dequeue+0x144>
ffffffffc0204ee6:	00002697          	auipc	a3,0x2
ffffffffc0204eea:	4aa68693          	add	a3,a3,1194 # ffffffffc0207390 <default_pmm_manager+0xd00>
ffffffffc0204eee:	00001617          	auipc	a2,0x1
ffffffffc0204ef2:	10a60613          	add	a2,a2,266 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0204ef6:	06300593          	li	a1,99
ffffffffc0204efa:	00002517          	auipc	a0,0x2
ffffffffc0204efe:	4be50513          	add	a0,a0,1214 # ffffffffc02073b8 <default_pmm_manager+0xd28>
ffffffffc0204f02:	d70fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0204f06 <sched_init>:
ffffffffc0204f06:	1141                	add	sp,sp,-16
ffffffffc0204f08:	00007697          	auipc	a3,0x7
ffffffffc0204f0c:	14868693          	add	a3,a3,328 # ffffffffc020c050 <default_sched_class>
ffffffffc0204f10:	e022                	sd	s0,0(sp)
ffffffffc0204f12:	e406                	sd	ra,8(sp)
ffffffffc0204f14:	00012797          	auipc	a5,0x12
ffffffffc0204f18:	6bc78793          	add	a5,a5,1724 # ffffffffc02175d0 <timer_list>
ffffffffc0204f1c:	6690                	ld	a2,8(a3)
ffffffffc0204f1e:	00012717          	auipc	a4,0x12
ffffffffc0204f22:	69270713          	add	a4,a4,1682 # ffffffffc02175b0 <__rq>
ffffffffc0204f26:	e79c                	sd	a5,8(a5)
ffffffffc0204f28:	e39c                	sd	a5,0(a5)
ffffffffc0204f2a:	4795                	li	a5,5
ffffffffc0204f2c:	00012417          	auipc	s0,0x12
ffffffffc0204f30:	74c40413          	add	s0,s0,1868 # ffffffffc0217678 <sched_class>
ffffffffc0204f34:	cb5c                	sw	a5,20(a4)
ffffffffc0204f36:	853a                	mv	a0,a4
ffffffffc0204f38:	e014                	sd	a3,0(s0)
ffffffffc0204f3a:	00012797          	auipc	a5,0x12
ffffffffc0204f3e:	72e7bb23          	sd	a4,1846(a5) # ffffffffc0217670 <rq>
ffffffffc0204f42:	9602                	jalr	a2
ffffffffc0204f44:	601c                	ld	a5,0(s0)
ffffffffc0204f46:	6402                	ld	s0,0(sp)
ffffffffc0204f48:	60a2                	ld	ra,8(sp)
ffffffffc0204f4a:	638c                	ld	a1,0(a5)
ffffffffc0204f4c:	00002517          	auipc	a0,0x2
ffffffffc0204f50:	4ac50513          	add	a0,a0,1196 # ffffffffc02073f8 <default_pmm_manager+0xd68>
ffffffffc0204f54:	0141                	add	sp,sp,16
ffffffffc0204f56:	a34fb06f          	j	ffffffffc020018a <cprintf>

ffffffffc0204f5a <wakeup_proc>:
ffffffffc0204f5a:	4118                	lw	a4,0(a0)
ffffffffc0204f5c:	1141                	add	sp,sp,-16
ffffffffc0204f5e:	e406                	sd	ra,8(sp)
ffffffffc0204f60:	e022                	sd	s0,0(sp)
ffffffffc0204f62:	478d                	li	a5,3
ffffffffc0204f64:	0cf70163          	beq	a4,a5,ffffffffc0205026 <wakeup_proc+0xcc>
ffffffffc0204f68:	842a                	mv	s0,a0
ffffffffc0204f6a:	100027f3          	csrr	a5,sstatus
ffffffffc0204f6e:	8b89                	and	a5,a5,2
ffffffffc0204f70:	e7a9                	bnez	a5,ffffffffc0204fba <wakeup_proc+0x60>
ffffffffc0204f72:	4789                	li	a5,2
ffffffffc0204f74:	06f70d63          	beq	a4,a5,ffffffffc0204fee <wakeup_proc+0x94>
ffffffffc0204f78:	c11c                	sw	a5,0(a0)
ffffffffc0204f7a:	0e052623          	sw	zero,236(a0)
ffffffffc0204f7e:	00012797          	auipc	a5,0x12
ffffffffc0204f82:	6da7b783          	ld	a5,1754(a5) # ffffffffc0217658 <current>
ffffffffc0204f86:	02f50663          	beq	a0,a5,ffffffffc0204fb2 <wakeup_proc+0x58>
ffffffffc0204f8a:	00012797          	auipc	a5,0x12
ffffffffc0204f8e:	6de7b783          	ld	a5,1758(a5) # ffffffffc0217668 <idleproc>
ffffffffc0204f92:	02f50063          	beq	a0,a5,ffffffffc0204fb2 <wakeup_proc+0x58>
ffffffffc0204f96:	6402                	ld	s0,0(sp)
ffffffffc0204f98:	00012797          	auipc	a5,0x12
ffffffffc0204f9c:	6e07b783          	ld	a5,1760(a5) # ffffffffc0217678 <sched_class>
ffffffffc0204fa0:	60a2                	ld	ra,8(sp)
ffffffffc0204fa2:	6b9c                	ld	a5,16(a5)
ffffffffc0204fa4:	85aa                	mv	a1,a0
ffffffffc0204fa6:	00012517          	auipc	a0,0x12
ffffffffc0204faa:	6ca53503          	ld	a0,1738(a0) # ffffffffc0217670 <rq>
ffffffffc0204fae:	0141                	add	sp,sp,16
ffffffffc0204fb0:	8782                	jr	a5
ffffffffc0204fb2:	60a2                	ld	ra,8(sp)
ffffffffc0204fb4:	6402                	ld	s0,0(sp)
ffffffffc0204fb6:	0141                	add	sp,sp,16
ffffffffc0204fb8:	8082                	ret
ffffffffc0204fba:	e7afb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0204fbe:	4018                	lw	a4,0(s0)
ffffffffc0204fc0:	4789                	li	a5,2
ffffffffc0204fc2:	04f70563          	beq	a4,a5,ffffffffc020500c <wakeup_proc+0xb2>
ffffffffc0204fc6:	c01c                	sw	a5,0(s0)
ffffffffc0204fc8:	0e042623          	sw	zero,236(s0)
ffffffffc0204fcc:	00012797          	auipc	a5,0x12
ffffffffc0204fd0:	68c7b783          	ld	a5,1676(a5) # ffffffffc0217658 <current>
ffffffffc0204fd4:	00f40863          	beq	s0,a5,ffffffffc0204fe4 <wakeup_proc+0x8a>
ffffffffc0204fd8:	00012797          	auipc	a5,0x12
ffffffffc0204fdc:	6907b783          	ld	a5,1680(a5) # ffffffffc0217668 <idleproc>
ffffffffc0204fe0:	06f41363          	bne	s0,a5,ffffffffc0205046 <wakeup_proc+0xec>
ffffffffc0204fe4:	6402                	ld	s0,0(sp)
ffffffffc0204fe6:	60a2                	ld	ra,8(sp)
ffffffffc0204fe8:	0141                	add	sp,sp,16
ffffffffc0204fea:	e44fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0204fee:	6402                	ld	s0,0(sp)
ffffffffc0204ff0:	60a2                	ld	ra,8(sp)
ffffffffc0204ff2:	00002617          	auipc	a2,0x2
ffffffffc0204ff6:	45660613          	add	a2,a2,1110 # ffffffffc0207448 <default_pmm_manager+0xdb8>
ffffffffc0204ffa:	04800593          	li	a1,72
ffffffffc0204ffe:	00002517          	auipc	a0,0x2
ffffffffc0205002:	43250513          	add	a0,a0,1074 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc0205006:	0141                	add	sp,sp,16
ffffffffc0205008:	cd2fb06f          	j	ffffffffc02004da <__warn>
ffffffffc020500c:	00002617          	auipc	a2,0x2
ffffffffc0205010:	43c60613          	add	a2,a2,1084 # ffffffffc0207448 <default_pmm_manager+0xdb8>
ffffffffc0205014:	04800593          	li	a1,72
ffffffffc0205018:	00002517          	auipc	a0,0x2
ffffffffc020501c:	41850513          	add	a0,a0,1048 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc0205020:	cbafb0ef          	jal	ffffffffc02004da <__warn>
ffffffffc0205024:	b7c1                	j	ffffffffc0204fe4 <wakeup_proc+0x8a>
ffffffffc0205026:	00002697          	auipc	a3,0x2
ffffffffc020502a:	3ea68693          	add	a3,a3,1002 # ffffffffc0207410 <default_pmm_manager+0xd80>
ffffffffc020502e:	00001617          	auipc	a2,0x1
ffffffffc0205032:	fca60613          	add	a2,a2,-54 # ffffffffc0205ff8 <commands+0x450>
ffffffffc0205036:	03c00593          	li	a1,60
ffffffffc020503a:	00002517          	auipc	a0,0x2
ffffffffc020503e:	3f650513          	add	a0,a0,1014 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc0205042:	c30fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0205046:	00012797          	auipc	a5,0x12
ffffffffc020504a:	6327b783          	ld	a5,1586(a5) # ffffffffc0217678 <sched_class>
ffffffffc020504e:	6b9c                	ld	a5,16(a5)
ffffffffc0205050:	85a2                	mv	a1,s0
ffffffffc0205052:	00012517          	auipc	a0,0x12
ffffffffc0205056:	61e53503          	ld	a0,1566(a0) # ffffffffc0217670 <rq>
ffffffffc020505a:	9782                	jalr	a5
ffffffffc020505c:	b761                	j	ffffffffc0204fe4 <wakeup_proc+0x8a>

ffffffffc020505e <schedule>:
ffffffffc020505e:	7179                	add	sp,sp,-48
ffffffffc0205060:	f406                	sd	ra,40(sp)
ffffffffc0205062:	f022                	sd	s0,32(sp)
ffffffffc0205064:	ec26                	sd	s1,24(sp)
ffffffffc0205066:	e84a                	sd	s2,16(sp)
ffffffffc0205068:	e44e                	sd	s3,8(sp)
ffffffffc020506a:	e052                	sd	s4,0(sp)
ffffffffc020506c:	100027f3          	csrr	a5,sstatus
ffffffffc0205070:	8b89                	and	a5,a5,2
ffffffffc0205072:	4a01                	li	s4,0
ffffffffc0205074:	e3cd                	bnez	a5,ffffffffc0205116 <schedule+0xb8>
ffffffffc0205076:	00012497          	auipc	s1,0x12
ffffffffc020507a:	5e248493          	add	s1,s1,1506 # ffffffffc0217658 <current>
ffffffffc020507e:	608c                	ld	a1,0(s1)
ffffffffc0205080:	4789                	li	a5,2
ffffffffc0205082:	00012917          	auipc	s2,0x12
ffffffffc0205086:	5ee90913          	add	s2,s2,1518 # ffffffffc0217670 <rq>
ffffffffc020508a:	4198                	lw	a4,0(a1)
ffffffffc020508c:	0005bc23          	sd	zero,24(a1)
ffffffffc0205090:	00012997          	auipc	s3,0x12
ffffffffc0205094:	5e898993          	add	s3,s3,1512 # ffffffffc0217678 <sched_class>
ffffffffc0205098:	06f70263          	beq	a4,a5,ffffffffc02050fc <schedule+0x9e>
ffffffffc020509c:	0009b783          	ld	a5,0(s3)
ffffffffc02050a0:	00093503          	ld	a0,0(s2)
ffffffffc02050a4:	739c                	ld	a5,32(a5)
ffffffffc02050a6:	9782                	jalr	a5
ffffffffc02050a8:	842a                	mv	s0,a0
ffffffffc02050aa:	c521                	beqz	a0,ffffffffc02050f2 <schedule+0x94>
ffffffffc02050ac:	0009b783          	ld	a5,0(s3)
ffffffffc02050b0:	00093503          	ld	a0,0(s2)
ffffffffc02050b4:	85a2                	mv	a1,s0
ffffffffc02050b6:	6f9c                	ld	a5,24(a5)
ffffffffc02050b8:	9782                	jalr	a5
ffffffffc02050ba:	441c                	lw	a5,8(s0)
ffffffffc02050bc:	6098                	ld	a4,0(s1)
ffffffffc02050be:	2785                	addw	a5,a5,1
ffffffffc02050c0:	c41c                	sw	a5,8(s0)
ffffffffc02050c2:	00870563          	beq	a4,s0,ffffffffc02050cc <schedule+0x6e>
ffffffffc02050c6:	8522                	mv	a0,s0
ffffffffc02050c8:	f74fe0ef          	jal	ffffffffc020383c <proc_run>
ffffffffc02050cc:	000a1a63          	bnez	s4,ffffffffc02050e0 <schedule+0x82>
ffffffffc02050d0:	70a2                	ld	ra,40(sp)
ffffffffc02050d2:	7402                	ld	s0,32(sp)
ffffffffc02050d4:	64e2                	ld	s1,24(sp)
ffffffffc02050d6:	6942                	ld	s2,16(sp)
ffffffffc02050d8:	69a2                	ld	s3,8(sp)
ffffffffc02050da:	6a02                	ld	s4,0(sp)
ffffffffc02050dc:	6145                	add	sp,sp,48
ffffffffc02050de:	8082                	ret
ffffffffc02050e0:	7402                	ld	s0,32(sp)
ffffffffc02050e2:	70a2                	ld	ra,40(sp)
ffffffffc02050e4:	64e2                	ld	s1,24(sp)
ffffffffc02050e6:	6942                	ld	s2,16(sp)
ffffffffc02050e8:	69a2                	ld	s3,8(sp)
ffffffffc02050ea:	6a02                	ld	s4,0(sp)
ffffffffc02050ec:	6145                	add	sp,sp,48
ffffffffc02050ee:	d40fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc02050f2:	00012417          	auipc	s0,0x12
ffffffffc02050f6:	57643403          	ld	s0,1398(s0) # ffffffffc0217668 <idleproc>
ffffffffc02050fa:	b7c1                	j	ffffffffc02050ba <schedule+0x5c>
ffffffffc02050fc:	00012797          	auipc	a5,0x12
ffffffffc0205100:	56c7b783          	ld	a5,1388(a5) # ffffffffc0217668 <idleproc>
ffffffffc0205104:	f8f58ce3          	beq	a1,a5,ffffffffc020509c <schedule+0x3e>
ffffffffc0205108:	0009b783          	ld	a5,0(s3)
ffffffffc020510c:	00093503          	ld	a0,0(s2)
ffffffffc0205110:	6b9c                	ld	a5,16(a5)
ffffffffc0205112:	9782                	jalr	a5
ffffffffc0205114:	b761                	j	ffffffffc020509c <schedule+0x3e>
ffffffffc0205116:	d1efb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020511a:	4a05                	li	s4,1
ffffffffc020511c:	bfa9                	j	ffffffffc0205076 <schedule+0x18>

ffffffffc020511e <add_timer>:
ffffffffc020511e:	1141                	add	sp,sp,-16
ffffffffc0205120:	e022                	sd	s0,0(sp)
ffffffffc0205122:	e406                	sd	ra,8(sp)
ffffffffc0205124:	842a                	mv	s0,a0
ffffffffc0205126:	100027f3          	csrr	a5,sstatus
ffffffffc020512a:	8b89                	and	a5,a5,2
ffffffffc020512c:	4501                	li	a0,0
ffffffffc020512e:	e7bd                	bnez	a5,ffffffffc020519c <add_timer+0x7e>
ffffffffc0205130:	401c                	lw	a5,0(s0)
ffffffffc0205132:	cbad                	beqz	a5,ffffffffc02051a4 <add_timer+0x86>
ffffffffc0205134:	6418                	ld	a4,8(s0)
ffffffffc0205136:	c73d                	beqz	a4,ffffffffc02051a4 <add_timer+0x86>
ffffffffc0205138:	6c18                	ld	a4,24(s0)
ffffffffc020513a:	01040593          	add	a1,s0,16
ffffffffc020513e:	08e59363          	bne	a1,a4,ffffffffc02051c4 <add_timer+0xa6>
ffffffffc0205142:	00012617          	auipc	a2,0x12
ffffffffc0205146:	48e60613          	add	a2,a2,1166 # ffffffffc02175d0 <timer_list>
ffffffffc020514a:	6618                	ld	a4,8(a2)
ffffffffc020514c:	00c71863          	bne	a4,a2,ffffffffc020515c <add_timer+0x3e>
ffffffffc0205150:	a805                	j	ffffffffc0205180 <add_timer+0x62>
ffffffffc0205152:	6718                	ld	a4,8(a4)
ffffffffc0205154:	9f95                	subw	a5,a5,a3
ffffffffc0205156:	c01c                	sw	a5,0(s0)
ffffffffc0205158:	02c70463          	beq	a4,a2,ffffffffc0205180 <add_timer+0x62>
ffffffffc020515c:	ff072683          	lw	a3,-16(a4)
ffffffffc0205160:	fed7f9e3          	bgeu	a5,a3,ffffffffc0205152 <add_timer+0x34>
ffffffffc0205164:	9e9d                	subw	a3,a3,a5
ffffffffc0205166:	631c                	ld	a5,0(a4)
ffffffffc0205168:	fed72823          	sw	a3,-16(a4)
ffffffffc020516c:	e30c                	sd	a1,0(a4)
ffffffffc020516e:	e78c                	sd	a1,8(a5)
ffffffffc0205170:	ec18                	sd	a4,24(s0)
ffffffffc0205172:	e81c                	sd	a5,16(s0)
ffffffffc0205174:	c105                	beqz	a0,ffffffffc0205194 <add_timer+0x76>
ffffffffc0205176:	6402                	ld	s0,0(sp)
ffffffffc0205178:	60a2                	ld	ra,8(sp)
ffffffffc020517a:	0141                	add	sp,sp,16
ffffffffc020517c:	cb2fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0205180:	00012717          	auipc	a4,0x12
ffffffffc0205184:	45070713          	add	a4,a4,1104 # ffffffffc02175d0 <timer_list>
ffffffffc0205188:	631c                	ld	a5,0(a4)
ffffffffc020518a:	e30c                	sd	a1,0(a4)
ffffffffc020518c:	e78c                	sd	a1,8(a5)
ffffffffc020518e:	ec18                	sd	a4,24(s0)
ffffffffc0205190:	e81c                	sd	a5,16(s0)
ffffffffc0205192:	f175                	bnez	a0,ffffffffc0205176 <add_timer+0x58>
ffffffffc0205194:	60a2                	ld	ra,8(sp)
ffffffffc0205196:	6402                	ld	s0,0(sp)
ffffffffc0205198:	0141                	add	sp,sp,16
ffffffffc020519a:	8082                	ret
ffffffffc020519c:	c98fb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02051a0:	4505                	li	a0,1
ffffffffc02051a2:	b779                	j	ffffffffc0205130 <add_timer+0x12>
ffffffffc02051a4:	00002697          	auipc	a3,0x2
ffffffffc02051a8:	2c468693          	add	a3,a3,708 # ffffffffc0207468 <default_pmm_manager+0xdd8>
ffffffffc02051ac:	00001617          	auipc	a2,0x1
ffffffffc02051b0:	e4c60613          	add	a2,a2,-436 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02051b4:	06c00593          	li	a1,108
ffffffffc02051b8:	00002517          	auipc	a0,0x2
ffffffffc02051bc:	27850513          	add	a0,a0,632 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc02051c0:	ab2fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02051c4:	00002697          	auipc	a3,0x2
ffffffffc02051c8:	2d468693          	add	a3,a3,724 # ffffffffc0207498 <default_pmm_manager+0xe08>
ffffffffc02051cc:	00001617          	auipc	a2,0x1
ffffffffc02051d0:	e2c60613          	add	a2,a2,-468 # ffffffffc0205ff8 <commands+0x450>
ffffffffc02051d4:	06d00593          	li	a1,109
ffffffffc02051d8:	00002517          	auipc	a0,0x2
ffffffffc02051dc:	25850513          	add	a0,a0,600 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc02051e0:	a92fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02051e4 <del_timer>:
ffffffffc02051e4:	1101                	add	sp,sp,-32
ffffffffc02051e6:	e822                	sd	s0,16(sp)
ffffffffc02051e8:	ec06                	sd	ra,24(sp)
ffffffffc02051ea:	e426                	sd	s1,8(sp)
ffffffffc02051ec:	842a                	mv	s0,a0
ffffffffc02051ee:	100027f3          	csrr	a5,sstatus
ffffffffc02051f2:	8b89                	and	a5,a5,2
ffffffffc02051f4:	01050493          	add	s1,a0,16
ffffffffc02051f8:	e7b9                	bnez	a5,ffffffffc0205246 <del_timer+0x62>
ffffffffc02051fa:	6d1c                	ld	a5,24(a0)
ffffffffc02051fc:	04f48063          	beq	s1,a5,ffffffffc020523c <del_timer+0x58>
ffffffffc0205200:	4114                	lw	a3,0(a0)
ffffffffc0205202:	6918                	ld	a4,16(a0)
ffffffffc0205204:	ca85                	beqz	a3,ffffffffc0205234 <del_timer+0x50>
ffffffffc0205206:	00012617          	auipc	a2,0x12
ffffffffc020520a:	3ca60613          	add	a2,a2,970 # ffffffffc02175d0 <timer_list>
ffffffffc020520e:	4581                	li	a1,0
ffffffffc0205210:	02c78263          	beq	a5,a2,ffffffffc0205234 <del_timer+0x50>
ffffffffc0205214:	ff07a603          	lw	a2,-16(a5)
ffffffffc0205218:	9eb1                	addw	a3,a3,a2
ffffffffc020521a:	fed7a823          	sw	a3,-16(a5)
ffffffffc020521e:	e71c                	sd	a5,8(a4)
ffffffffc0205220:	e398                	sd	a4,0(a5)
ffffffffc0205222:	ec04                	sd	s1,24(s0)
ffffffffc0205224:	e804                	sd	s1,16(s0)
ffffffffc0205226:	c999                	beqz	a1,ffffffffc020523c <del_timer+0x58>
ffffffffc0205228:	6442                	ld	s0,16(sp)
ffffffffc020522a:	60e2                	ld	ra,24(sp)
ffffffffc020522c:	64a2                	ld	s1,8(sp)
ffffffffc020522e:	6105                	add	sp,sp,32
ffffffffc0205230:	bfefb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0205234:	e71c                	sd	a5,8(a4)
ffffffffc0205236:	e398                	sd	a4,0(a5)
ffffffffc0205238:	ec04                	sd	s1,24(s0)
ffffffffc020523a:	e804                	sd	s1,16(s0)
ffffffffc020523c:	60e2                	ld	ra,24(sp)
ffffffffc020523e:	6442                	ld	s0,16(sp)
ffffffffc0205240:	64a2                	ld	s1,8(sp)
ffffffffc0205242:	6105                	add	sp,sp,32
ffffffffc0205244:	8082                	ret
ffffffffc0205246:	beefb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020524a:	6c1c                	ld	a5,24(s0)
ffffffffc020524c:	fcf48ee3          	beq	s1,a5,ffffffffc0205228 <del_timer+0x44>
ffffffffc0205250:	4014                	lw	a3,0(s0)
ffffffffc0205252:	6818                	ld	a4,16(s0)
ffffffffc0205254:	ca81                	beqz	a3,ffffffffc0205264 <del_timer+0x80>
ffffffffc0205256:	00012617          	auipc	a2,0x12
ffffffffc020525a:	37a60613          	add	a2,a2,890 # ffffffffc02175d0 <timer_list>
ffffffffc020525e:	4585                	li	a1,1
ffffffffc0205260:	fac79ae3          	bne	a5,a2,ffffffffc0205214 <del_timer+0x30>
ffffffffc0205264:	e71c                	sd	a5,8(a4)
ffffffffc0205266:	e398                	sd	a4,0(a5)
ffffffffc0205268:	ec04                	sd	s1,24(s0)
ffffffffc020526a:	e804                	sd	s1,16(s0)
ffffffffc020526c:	bf75                	j	ffffffffc0205228 <del_timer+0x44>

ffffffffc020526e <run_timer_list>:
ffffffffc020526e:	7139                	add	sp,sp,-64
ffffffffc0205270:	fc06                	sd	ra,56(sp)
ffffffffc0205272:	f822                	sd	s0,48(sp)
ffffffffc0205274:	f426                	sd	s1,40(sp)
ffffffffc0205276:	f04a                	sd	s2,32(sp)
ffffffffc0205278:	ec4e                	sd	s3,24(sp)
ffffffffc020527a:	e852                	sd	s4,16(sp)
ffffffffc020527c:	e456                	sd	s5,8(sp)
ffffffffc020527e:	e05a                	sd	s6,0(sp)
ffffffffc0205280:	100027f3          	csrr	a5,sstatus
ffffffffc0205284:	8b89                	and	a5,a5,2
ffffffffc0205286:	4b01                	li	s6,0
ffffffffc0205288:	eff9                	bnez	a5,ffffffffc0205366 <run_timer_list+0xf8>
ffffffffc020528a:	00012997          	auipc	s3,0x12
ffffffffc020528e:	34698993          	add	s3,s3,838 # ffffffffc02175d0 <timer_list>
ffffffffc0205292:	0089b403          	ld	s0,8(s3)
ffffffffc0205296:	07340a63          	beq	s0,s3,ffffffffc020530a <run_timer_list+0x9c>
ffffffffc020529a:	ff042783          	lw	a5,-16(s0)
ffffffffc020529e:	ff040913          	add	s2,s0,-16
ffffffffc02052a2:	0e078663          	beqz	a5,ffffffffc020538e <run_timer_list+0x120>
ffffffffc02052a6:	fff7871b          	addw	a4,a5,-1
ffffffffc02052aa:	fee42823          	sw	a4,-16(s0)
ffffffffc02052ae:	ef31                	bnez	a4,ffffffffc020530a <run_timer_list+0x9c>
ffffffffc02052b0:	00002a97          	auipc	s5,0x2
ffffffffc02052b4:	250a8a93          	add	s5,s5,592 # ffffffffc0207500 <default_pmm_manager+0xe70>
ffffffffc02052b8:	00002a17          	auipc	s4,0x2
ffffffffc02052bc:	178a0a13          	add	s4,s4,376 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc02052c0:	a005                	j	ffffffffc02052e0 <run_timer_list+0x72>
ffffffffc02052c2:	0a07d663          	bgez	a5,ffffffffc020536e <run_timer_list+0x100>
ffffffffc02052c6:	8526                	mv	a0,s1
ffffffffc02052c8:	c93ff0ef          	jal	ffffffffc0204f5a <wakeup_proc>
ffffffffc02052cc:	854a                	mv	a0,s2
ffffffffc02052ce:	f17ff0ef          	jal	ffffffffc02051e4 <del_timer>
ffffffffc02052d2:	03340c63          	beq	s0,s3,ffffffffc020530a <run_timer_list+0x9c>
ffffffffc02052d6:	ff042783          	lw	a5,-16(s0)
ffffffffc02052da:	ff040913          	add	s2,s0,-16
ffffffffc02052de:	e795                	bnez	a5,ffffffffc020530a <run_timer_list+0x9c>
ffffffffc02052e0:	00893483          	ld	s1,8(s2)
ffffffffc02052e4:	6400                	ld	s0,8(s0)
ffffffffc02052e6:	0ec4a783          	lw	a5,236(s1)
ffffffffc02052ea:	ffe1                	bnez	a5,ffffffffc02052c2 <run_timer_list+0x54>
ffffffffc02052ec:	40d4                	lw	a3,4(s1)
ffffffffc02052ee:	8656                	mv	a2,s5
ffffffffc02052f0:	0a300593          	li	a1,163
ffffffffc02052f4:	8552                	mv	a0,s4
ffffffffc02052f6:	9e4fb0ef          	jal	ffffffffc02004da <__warn>
ffffffffc02052fa:	8526                	mv	a0,s1
ffffffffc02052fc:	c5fff0ef          	jal	ffffffffc0204f5a <wakeup_proc>
ffffffffc0205300:	854a                	mv	a0,s2
ffffffffc0205302:	ee3ff0ef          	jal	ffffffffc02051e4 <del_timer>
ffffffffc0205306:	fd3418e3          	bne	s0,s3,ffffffffc02052d6 <run_timer_list+0x68>
ffffffffc020530a:	00012597          	auipc	a1,0x12
ffffffffc020530e:	34e5b583          	ld	a1,846(a1) # ffffffffc0217658 <current>
ffffffffc0205312:	00012797          	auipc	a5,0x12
ffffffffc0205316:	3567b783          	ld	a5,854(a5) # ffffffffc0217668 <idleproc>
ffffffffc020531a:	04f58363          	beq	a1,a5,ffffffffc0205360 <run_timer_list+0xf2>
ffffffffc020531e:	00012797          	auipc	a5,0x12
ffffffffc0205322:	35a7b783          	ld	a5,858(a5) # ffffffffc0217678 <sched_class>
ffffffffc0205326:	779c                	ld	a5,40(a5)
ffffffffc0205328:	00012517          	auipc	a0,0x12
ffffffffc020532c:	34853503          	ld	a0,840(a0) # ffffffffc0217670 <rq>
ffffffffc0205330:	9782                	jalr	a5
ffffffffc0205332:	000b1c63          	bnez	s6,ffffffffc020534a <run_timer_list+0xdc>
ffffffffc0205336:	70e2                	ld	ra,56(sp)
ffffffffc0205338:	7442                	ld	s0,48(sp)
ffffffffc020533a:	74a2                	ld	s1,40(sp)
ffffffffc020533c:	7902                	ld	s2,32(sp)
ffffffffc020533e:	69e2                	ld	s3,24(sp)
ffffffffc0205340:	6a42                	ld	s4,16(sp)
ffffffffc0205342:	6aa2                	ld	s5,8(sp)
ffffffffc0205344:	6b02                	ld	s6,0(sp)
ffffffffc0205346:	6121                	add	sp,sp,64
ffffffffc0205348:	8082                	ret
ffffffffc020534a:	7442                	ld	s0,48(sp)
ffffffffc020534c:	70e2                	ld	ra,56(sp)
ffffffffc020534e:	74a2                	ld	s1,40(sp)
ffffffffc0205350:	7902                	ld	s2,32(sp)
ffffffffc0205352:	69e2                	ld	s3,24(sp)
ffffffffc0205354:	6a42                	ld	s4,16(sp)
ffffffffc0205356:	6aa2                	ld	s5,8(sp)
ffffffffc0205358:	6b02                	ld	s6,0(sp)
ffffffffc020535a:	6121                	add	sp,sp,64
ffffffffc020535c:	ad2fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0205360:	4785                	li	a5,1
ffffffffc0205362:	ed9c                	sd	a5,24(a1)
ffffffffc0205364:	b7f9                	j	ffffffffc0205332 <run_timer_list+0xc4>
ffffffffc0205366:	acefb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020536a:	4b05                	li	s6,1
ffffffffc020536c:	bf39                	j	ffffffffc020528a <run_timer_list+0x1c>
ffffffffc020536e:	00002697          	auipc	a3,0x2
ffffffffc0205372:	16a68693          	add	a3,a3,362 # ffffffffc02074d8 <default_pmm_manager+0xe48>
ffffffffc0205376:	00001617          	auipc	a2,0x1
ffffffffc020537a:	c8260613          	add	a2,a2,-894 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020537e:	0a000593          	li	a1,160
ffffffffc0205382:	00002517          	auipc	a0,0x2
ffffffffc0205386:	0ae50513          	add	a0,a0,174 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc020538a:	8e8fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020538e:	00002697          	auipc	a3,0x2
ffffffffc0205392:	13268693          	add	a3,a3,306 # ffffffffc02074c0 <default_pmm_manager+0xe30>
ffffffffc0205396:	00001617          	auipc	a2,0x1
ffffffffc020539a:	c6260613          	add	a2,a2,-926 # ffffffffc0205ff8 <commands+0x450>
ffffffffc020539e:	09a00593          	li	a1,154
ffffffffc02053a2:	00002517          	auipc	a0,0x2
ffffffffc02053a6:	08e50513          	add	a0,a0,142 # ffffffffc0207430 <default_pmm_manager+0xda0>
ffffffffc02053aa:	8c8fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02053ae <sys_getpid>:
ffffffffc02053ae:	00012797          	auipc	a5,0x12
ffffffffc02053b2:	2aa7b783          	ld	a5,682(a5) # ffffffffc0217658 <current>
ffffffffc02053b6:	43c8                	lw	a0,4(a5)
ffffffffc02053b8:	8082                	ret

ffffffffc02053ba <sys_pgdir>:
ffffffffc02053ba:	4501                	li	a0,0
ffffffffc02053bc:	8082                	ret

ffffffffc02053be <sys_gettime>:
ffffffffc02053be:	00012797          	auipc	a5,0x12
ffffffffc02053c2:	22a7b783          	ld	a5,554(a5) # ffffffffc02175e8 <ticks>
ffffffffc02053c6:	0027951b          	sllw	a0,a5,0x2
ffffffffc02053ca:	9d3d                	addw	a0,a0,a5
ffffffffc02053cc:	0015151b          	sllw	a0,a0,0x1
ffffffffc02053d0:	8082                	ret

ffffffffc02053d2 <sys_lab6_set_priority>:
ffffffffc02053d2:	4108                	lw	a0,0(a0)
ffffffffc02053d4:	1141                	add	sp,sp,-16
ffffffffc02053d6:	e406                	sd	ra,8(sp)
ffffffffc02053d8:	d16ff0ef          	jal	ffffffffc02048ee <lab6_set_priority>
ffffffffc02053dc:	60a2                	ld	ra,8(sp)
ffffffffc02053de:	4501                	li	a0,0
ffffffffc02053e0:	0141                	add	sp,sp,16
ffffffffc02053e2:	8082                	ret

ffffffffc02053e4 <sys_putc>:
ffffffffc02053e4:	4108                	lw	a0,0(a0)
ffffffffc02053e6:	1141                	add	sp,sp,-16
ffffffffc02053e8:	e406                	sd	ra,8(sp)
ffffffffc02053ea:	dd7fa0ef          	jal	ffffffffc02001c0 <cputchar>
ffffffffc02053ee:	60a2                	ld	ra,8(sp)
ffffffffc02053f0:	4501                	li	a0,0
ffffffffc02053f2:	0141                	add	sp,sp,16
ffffffffc02053f4:	8082                	ret

ffffffffc02053f6 <sys_kill>:
ffffffffc02053f6:	4108                	lw	a0,0(a0)
ffffffffc02053f8:	ac4ff06f          	j	ffffffffc02046bc <do_kill>

ffffffffc02053fc <sys_sleep>:
ffffffffc02053fc:	4108                	lw	a0,0(a0)
ffffffffc02053fe:	d2aff06f          	j	ffffffffc0204928 <do_sleep>

ffffffffc0205402 <sys_yield>:
ffffffffc0205402:	a6aff06f          	j	ffffffffc020466c <do_yield>

ffffffffc0205406 <sys_exec>:
ffffffffc0205406:	6d14                	ld	a3,24(a0)
ffffffffc0205408:	6910                	ld	a2,16(a0)
ffffffffc020540a:	650c                	ld	a1,8(a0)
ffffffffc020540c:	6108                	ld	a0,0(a0)
ffffffffc020540e:	d3bfe06f          	j	ffffffffc0204148 <do_execve>

ffffffffc0205412 <sys_wait>:
ffffffffc0205412:	650c                	ld	a1,8(a0)
ffffffffc0205414:	4108                	lw	a0,0(a0)
ffffffffc0205416:	a66ff06f          	j	ffffffffc020467c <do_wait>

ffffffffc020541a <sys_fork>:
ffffffffc020541a:	00012797          	auipc	a5,0x12
ffffffffc020541e:	23e7b783          	ld	a5,574(a5) # ffffffffc0217658 <current>
ffffffffc0205422:	73d0                	ld	a2,160(a5)
ffffffffc0205424:	4501                	li	a0,0
ffffffffc0205426:	6a0c                	ld	a1,16(a2)
ffffffffc0205428:	cdafe06f          	j	ffffffffc0203902 <do_fork>

ffffffffc020542c <sys_exit>:
ffffffffc020542c:	4108                	lw	a0,0(a0)
ffffffffc020542e:	901fe06f          	j	ffffffffc0203d2e <do_exit>

ffffffffc0205432 <syscall>:
ffffffffc0205432:	715d                	add	sp,sp,-80
ffffffffc0205434:	fc26                	sd	s1,56(sp)
ffffffffc0205436:	00012497          	auipc	s1,0x12
ffffffffc020543a:	22248493          	add	s1,s1,546 # ffffffffc0217658 <current>
ffffffffc020543e:	6098                	ld	a4,0(s1)
ffffffffc0205440:	e0a2                	sd	s0,64(sp)
ffffffffc0205442:	f84a                	sd	s2,48(sp)
ffffffffc0205444:	7340                	ld	s0,160(a4)
ffffffffc0205446:	e486                	sd	ra,72(sp)
ffffffffc0205448:	0ff00793          	li	a5,255
ffffffffc020544c:	05042903          	lw	s2,80(s0)
ffffffffc0205450:	0327ee63          	bltu	a5,s2,ffffffffc020548c <syscall+0x5a>
ffffffffc0205454:	00391713          	sll	a4,s2,0x3
ffffffffc0205458:	00002797          	auipc	a5,0x2
ffffffffc020545c:	11078793          	add	a5,a5,272 # ffffffffc0207568 <syscalls>
ffffffffc0205460:	97ba                	add	a5,a5,a4
ffffffffc0205462:	639c                	ld	a5,0(a5)
ffffffffc0205464:	c785                	beqz	a5,ffffffffc020548c <syscall+0x5a>
ffffffffc0205466:	7028                	ld	a0,96(s0)
ffffffffc0205468:	742c                	ld	a1,104(s0)
ffffffffc020546a:	7834                	ld	a3,112(s0)
ffffffffc020546c:	7c38                	ld	a4,120(s0)
ffffffffc020546e:	6c30                	ld	a2,88(s0)
ffffffffc0205470:	e82a                	sd	a0,16(sp)
ffffffffc0205472:	ec2e                	sd	a1,24(sp)
ffffffffc0205474:	e432                	sd	a2,8(sp)
ffffffffc0205476:	f036                	sd	a3,32(sp)
ffffffffc0205478:	f43a                	sd	a4,40(sp)
ffffffffc020547a:	0028                	add	a0,sp,8
ffffffffc020547c:	9782                	jalr	a5
ffffffffc020547e:	60a6                	ld	ra,72(sp)
ffffffffc0205480:	e828                	sd	a0,80(s0)
ffffffffc0205482:	6406                	ld	s0,64(sp)
ffffffffc0205484:	74e2                	ld	s1,56(sp)
ffffffffc0205486:	7942                	ld	s2,48(sp)
ffffffffc0205488:	6161                	add	sp,sp,80
ffffffffc020548a:	8082                	ret
ffffffffc020548c:	8522                	mv	a0,s0
ffffffffc020548e:	b96fb0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0205492:	609c                	ld	a5,0(s1)
ffffffffc0205494:	86ca                	mv	a3,s2
ffffffffc0205496:	00002617          	auipc	a2,0x2
ffffffffc020549a:	08a60613          	add	a2,a2,138 # ffffffffc0207520 <default_pmm_manager+0xe90>
ffffffffc020549e:	43d8                	lw	a4,4(a5)
ffffffffc02054a0:	07300593          	li	a1,115
ffffffffc02054a4:	0b478793          	add	a5,a5,180
ffffffffc02054a8:	00002517          	auipc	a0,0x2
ffffffffc02054ac:	0a850513          	add	a0,a0,168 # ffffffffc0207550 <default_pmm_manager+0xec0>
ffffffffc02054b0:	fc3fa0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02054b4 <hash32>:
ffffffffc02054b4:	9e3707b7          	lui	a5,0x9e370
ffffffffc02054b8:	2785                	addw	a5,a5,1 # ffffffff9e370001 <kern_entry-0x21e8ffff>
ffffffffc02054ba:	02a787bb          	mulw	a5,a5,a0
ffffffffc02054be:	02000513          	li	a0,32
ffffffffc02054c2:	9d0d                	subw	a0,a0,a1
ffffffffc02054c4:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02054c8:	8082                	ret

ffffffffc02054ca <printnum>:
ffffffffc02054ca:	02069813          	sll	a6,a3,0x20
ffffffffc02054ce:	7179                	add	sp,sp,-48
ffffffffc02054d0:	02085813          	srl	a6,a6,0x20
ffffffffc02054d4:	e052                	sd	s4,0(sp)
ffffffffc02054d6:	03067a33          	remu	s4,a2,a6
ffffffffc02054da:	f022                	sd	s0,32(sp)
ffffffffc02054dc:	ec26                	sd	s1,24(sp)
ffffffffc02054de:	e84a                	sd	s2,16(sp)
ffffffffc02054e0:	f406                	sd	ra,40(sp)
ffffffffc02054e2:	e44e                	sd	s3,8(sp)
ffffffffc02054e4:	84aa                	mv	s1,a0
ffffffffc02054e6:	892e                	mv	s2,a1
ffffffffc02054e8:	fff7041b          	addw	s0,a4,-1
ffffffffc02054ec:	2a01                	sext.w	s4,s4
ffffffffc02054ee:	03067f63          	bgeu	a2,a6,ffffffffc020552c <printnum+0x62>
ffffffffc02054f2:	89be                	mv	s3,a5
ffffffffc02054f4:	4785                	li	a5,1
ffffffffc02054f6:	00e7d763          	bge	a5,a4,ffffffffc0205504 <printnum+0x3a>
ffffffffc02054fa:	347d                	addw	s0,s0,-1
ffffffffc02054fc:	85ca                	mv	a1,s2
ffffffffc02054fe:	854e                	mv	a0,s3
ffffffffc0205500:	9482                	jalr	s1
ffffffffc0205502:	fc65                	bnez	s0,ffffffffc02054fa <printnum+0x30>
ffffffffc0205504:	1a02                	sll	s4,s4,0x20
ffffffffc0205506:	020a5a13          	srl	s4,s4,0x20
ffffffffc020550a:	00003797          	auipc	a5,0x3
ffffffffc020550e:	85e78793          	add	a5,a5,-1954 # ffffffffc0207d68 <syscalls+0x800>
ffffffffc0205512:	97d2                	add	a5,a5,s4
ffffffffc0205514:	7402                	ld	s0,32(sp)
ffffffffc0205516:	0007c503          	lbu	a0,0(a5)
ffffffffc020551a:	70a2                	ld	ra,40(sp)
ffffffffc020551c:	69a2                	ld	s3,8(sp)
ffffffffc020551e:	6a02                	ld	s4,0(sp)
ffffffffc0205520:	85ca                	mv	a1,s2
ffffffffc0205522:	87a6                	mv	a5,s1
ffffffffc0205524:	6942                	ld	s2,16(sp)
ffffffffc0205526:	64e2                	ld	s1,24(sp)
ffffffffc0205528:	6145                	add	sp,sp,48
ffffffffc020552a:	8782                	jr	a5
ffffffffc020552c:	03065633          	divu	a2,a2,a6
ffffffffc0205530:	8722                	mv	a4,s0
ffffffffc0205532:	f99ff0ef          	jal	ffffffffc02054ca <printnum>
ffffffffc0205536:	b7f9                	j	ffffffffc0205504 <printnum+0x3a>

ffffffffc0205538 <vprintfmt>:
ffffffffc0205538:	7119                	add	sp,sp,-128
ffffffffc020553a:	f4a6                	sd	s1,104(sp)
ffffffffc020553c:	f0ca                	sd	s2,96(sp)
ffffffffc020553e:	ecce                	sd	s3,88(sp)
ffffffffc0205540:	e8d2                	sd	s4,80(sp)
ffffffffc0205542:	e4d6                	sd	s5,72(sp)
ffffffffc0205544:	e0da                	sd	s6,64(sp)
ffffffffc0205546:	f862                	sd	s8,48(sp)
ffffffffc0205548:	fc86                	sd	ra,120(sp)
ffffffffc020554a:	f8a2                	sd	s0,112(sp)
ffffffffc020554c:	fc5e                	sd	s7,56(sp)
ffffffffc020554e:	f466                	sd	s9,40(sp)
ffffffffc0205550:	f06a                	sd	s10,32(sp)
ffffffffc0205552:	ec6e                	sd	s11,24(sp)
ffffffffc0205554:	892a                	mv	s2,a0
ffffffffc0205556:	84ae                	mv	s1,a1
ffffffffc0205558:	8c32                	mv	s8,a2
ffffffffc020555a:	8a36                	mv	s4,a3
ffffffffc020555c:	02500993          	li	s3,37
ffffffffc0205560:	05500b13          	li	s6,85
ffffffffc0205564:	00003a97          	auipc	s5,0x3
ffffffffc0205568:	830a8a93          	add	s5,s5,-2000 # ffffffffc0207d94 <syscalls+0x82c>
ffffffffc020556c:	000c4503          	lbu	a0,0(s8)
ffffffffc0205570:	001c0413          	add	s0,s8,1
ffffffffc0205574:	01350a63          	beq	a0,s3,ffffffffc0205588 <vprintfmt+0x50>
ffffffffc0205578:	cd0d                	beqz	a0,ffffffffc02055b2 <vprintfmt+0x7a>
ffffffffc020557a:	85a6                	mv	a1,s1
ffffffffc020557c:	0405                	add	s0,s0,1
ffffffffc020557e:	9902                	jalr	s2
ffffffffc0205580:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205584:	ff351ae3          	bne	a0,s3,ffffffffc0205578 <vprintfmt+0x40>
ffffffffc0205588:	02000d93          	li	s11,32
ffffffffc020558c:	4b81                	li	s7,0
ffffffffc020558e:	4601                	li	a2,0
ffffffffc0205590:	5d7d                	li	s10,-1
ffffffffc0205592:	5cfd                	li	s9,-1
ffffffffc0205594:	00044683          	lbu	a3,0(s0)
ffffffffc0205598:	00140c13          	add	s8,s0,1
ffffffffc020559c:	fdd6859b          	addw	a1,a3,-35
ffffffffc02055a0:	0ff5f593          	zext.b	a1,a1
ffffffffc02055a4:	02bb6663          	bltu	s6,a1,ffffffffc02055d0 <vprintfmt+0x98>
ffffffffc02055a8:	058a                	sll	a1,a1,0x2
ffffffffc02055aa:	95d6                	add	a1,a1,s5
ffffffffc02055ac:	4198                	lw	a4,0(a1)
ffffffffc02055ae:	9756                	add	a4,a4,s5
ffffffffc02055b0:	8702                	jr	a4
ffffffffc02055b2:	70e6                	ld	ra,120(sp)
ffffffffc02055b4:	7446                	ld	s0,112(sp)
ffffffffc02055b6:	74a6                	ld	s1,104(sp)
ffffffffc02055b8:	7906                	ld	s2,96(sp)
ffffffffc02055ba:	69e6                	ld	s3,88(sp)
ffffffffc02055bc:	6a46                	ld	s4,80(sp)
ffffffffc02055be:	6aa6                	ld	s5,72(sp)
ffffffffc02055c0:	6b06                	ld	s6,64(sp)
ffffffffc02055c2:	7be2                	ld	s7,56(sp)
ffffffffc02055c4:	7c42                	ld	s8,48(sp)
ffffffffc02055c6:	7ca2                	ld	s9,40(sp)
ffffffffc02055c8:	7d02                	ld	s10,32(sp)
ffffffffc02055ca:	6de2                	ld	s11,24(sp)
ffffffffc02055cc:	6109                	add	sp,sp,128
ffffffffc02055ce:	8082                	ret
ffffffffc02055d0:	85a6                	mv	a1,s1
ffffffffc02055d2:	02500513          	li	a0,37
ffffffffc02055d6:	9902                	jalr	s2
ffffffffc02055d8:	fff44703          	lbu	a4,-1(s0)
ffffffffc02055dc:	02500793          	li	a5,37
ffffffffc02055e0:	8c22                	mv	s8,s0
ffffffffc02055e2:	f8f705e3          	beq	a4,a5,ffffffffc020556c <vprintfmt+0x34>
ffffffffc02055e6:	02500713          	li	a4,37
ffffffffc02055ea:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02055ee:	1c7d                	add	s8,s8,-1
ffffffffc02055f0:	fee79de3          	bne	a5,a4,ffffffffc02055ea <vprintfmt+0xb2>
ffffffffc02055f4:	bfa5                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc02055f6:	00144783          	lbu	a5,1(s0)
ffffffffc02055fa:	4725                	li	a4,9
ffffffffc02055fc:	fd068d1b          	addw	s10,a3,-48
ffffffffc0205600:	fd07859b          	addw	a1,a5,-48
ffffffffc0205604:	0007869b          	sext.w	a3,a5
ffffffffc0205608:	8462                	mv	s0,s8
ffffffffc020560a:	02b76563          	bltu	a4,a1,ffffffffc0205634 <vprintfmt+0xfc>
ffffffffc020560e:	4525                	li	a0,9
ffffffffc0205610:	00144783          	lbu	a5,1(s0)
ffffffffc0205614:	002d171b          	sllw	a4,s10,0x2
ffffffffc0205618:	01a7073b          	addw	a4,a4,s10
ffffffffc020561c:	0017171b          	sllw	a4,a4,0x1
ffffffffc0205620:	9f35                	addw	a4,a4,a3
ffffffffc0205622:	fd07859b          	addw	a1,a5,-48
ffffffffc0205626:	0405                	add	s0,s0,1
ffffffffc0205628:	fd070d1b          	addw	s10,a4,-48
ffffffffc020562c:	0007869b          	sext.w	a3,a5
ffffffffc0205630:	feb570e3          	bgeu	a0,a1,ffffffffc0205610 <vprintfmt+0xd8>
ffffffffc0205634:	f60cd0e3          	bgez	s9,ffffffffc0205594 <vprintfmt+0x5c>
ffffffffc0205638:	8cea                	mv	s9,s10
ffffffffc020563a:	5d7d                	li	s10,-1
ffffffffc020563c:	bfa1                	j	ffffffffc0205594 <vprintfmt+0x5c>
ffffffffc020563e:	8db6                	mv	s11,a3
ffffffffc0205640:	8462                	mv	s0,s8
ffffffffc0205642:	bf89                	j	ffffffffc0205594 <vprintfmt+0x5c>
ffffffffc0205644:	8462                	mv	s0,s8
ffffffffc0205646:	4b85                	li	s7,1
ffffffffc0205648:	b7b1                	j	ffffffffc0205594 <vprintfmt+0x5c>
ffffffffc020564a:	4785                	li	a5,1
ffffffffc020564c:	008a0713          	add	a4,s4,8
ffffffffc0205650:	00c7c463          	blt	a5,a2,ffffffffc0205658 <vprintfmt+0x120>
ffffffffc0205654:	1a060263          	beqz	a2,ffffffffc02057f8 <vprintfmt+0x2c0>
ffffffffc0205658:	000a3603          	ld	a2,0(s4)
ffffffffc020565c:	46c1                	li	a3,16
ffffffffc020565e:	8a3a                	mv	s4,a4
ffffffffc0205660:	000d879b          	sext.w	a5,s11
ffffffffc0205664:	8766                	mv	a4,s9
ffffffffc0205666:	85a6                	mv	a1,s1
ffffffffc0205668:	854a                	mv	a0,s2
ffffffffc020566a:	e61ff0ef          	jal	ffffffffc02054ca <printnum>
ffffffffc020566e:	bdfd                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc0205670:	000a2503          	lw	a0,0(s4)
ffffffffc0205674:	85a6                	mv	a1,s1
ffffffffc0205676:	0a21                	add	s4,s4,8
ffffffffc0205678:	9902                	jalr	s2
ffffffffc020567a:	bdcd                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc020567c:	4785                	li	a5,1
ffffffffc020567e:	008a0713          	add	a4,s4,8
ffffffffc0205682:	00c7c463          	blt	a5,a2,ffffffffc020568a <vprintfmt+0x152>
ffffffffc0205686:	16060463          	beqz	a2,ffffffffc02057ee <vprintfmt+0x2b6>
ffffffffc020568a:	000a3603          	ld	a2,0(s4)
ffffffffc020568e:	46a9                	li	a3,10
ffffffffc0205690:	8a3a                	mv	s4,a4
ffffffffc0205692:	b7f9                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc0205694:	03000513          	li	a0,48
ffffffffc0205698:	85a6                	mv	a1,s1
ffffffffc020569a:	9902                	jalr	s2
ffffffffc020569c:	85a6                	mv	a1,s1
ffffffffc020569e:	07800513          	li	a0,120
ffffffffc02056a2:	9902                	jalr	s2
ffffffffc02056a4:	0a21                	add	s4,s4,8
ffffffffc02056a6:	46c1                	li	a3,16
ffffffffc02056a8:	ff8a3603          	ld	a2,-8(s4)
ffffffffc02056ac:	bf55                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc02056ae:	85a6                	mv	a1,s1
ffffffffc02056b0:	02500513          	li	a0,37
ffffffffc02056b4:	9902                	jalr	s2
ffffffffc02056b6:	bd5d                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc02056b8:	000a2d03          	lw	s10,0(s4)
ffffffffc02056bc:	8462                	mv	s0,s8
ffffffffc02056be:	0a21                	add	s4,s4,8
ffffffffc02056c0:	bf95                	j	ffffffffc0205634 <vprintfmt+0xfc>
ffffffffc02056c2:	4785                	li	a5,1
ffffffffc02056c4:	008a0713          	add	a4,s4,8
ffffffffc02056c8:	00c7c463          	blt	a5,a2,ffffffffc02056d0 <vprintfmt+0x198>
ffffffffc02056cc:	10060c63          	beqz	a2,ffffffffc02057e4 <vprintfmt+0x2ac>
ffffffffc02056d0:	000a3603          	ld	a2,0(s4)
ffffffffc02056d4:	46a1                	li	a3,8
ffffffffc02056d6:	8a3a                	mv	s4,a4
ffffffffc02056d8:	b761                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc02056da:	fffcc793          	not	a5,s9
ffffffffc02056de:	97fd                	sra	a5,a5,0x3f
ffffffffc02056e0:	00fcf7b3          	and	a5,s9,a5
ffffffffc02056e4:	00078c9b          	sext.w	s9,a5
ffffffffc02056e8:	8462                	mv	s0,s8
ffffffffc02056ea:	b56d                	j	ffffffffc0205594 <vprintfmt+0x5c>
ffffffffc02056ec:	000a3403          	ld	s0,0(s4)
ffffffffc02056f0:	008a0793          	add	a5,s4,8
ffffffffc02056f4:	e43e                	sd	a5,8(sp)
ffffffffc02056f6:	12040163          	beqz	s0,ffffffffc0205818 <vprintfmt+0x2e0>
ffffffffc02056fa:	0d905963          	blez	s9,ffffffffc02057cc <vprintfmt+0x294>
ffffffffc02056fe:	02d00793          	li	a5,45
ffffffffc0205702:	00140a13          	add	s4,s0,1
ffffffffc0205706:	12fd9863          	bne	s11,a5,ffffffffc0205836 <vprintfmt+0x2fe>
ffffffffc020570a:	00044783          	lbu	a5,0(s0)
ffffffffc020570e:	0007851b          	sext.w	a0,a5
ffffffffc0205712:	cb9d                	beqz	a5,ffffffffc0205748 <vprintfmt+0x210>
ffffffffc0205714:	547d                	li	s0,-1
ffffffffc0205716:	05e00d93          	li	s11,94
ffffffffc020571a:	000d4563          	bltz	s10,ffffffffc0205724 <vprintfmt+0x1ec>
ffffffffc020571e:	3d7d                	addw	s10,s10,-1
ffffffffc0205720:	028d0263          	beq	s10,s0,ffffffffc0205744 <vprintfmt+0x20c>
ffffffffc0205724:	85a6                	mv	a1,s1
ffffffffc0205726:	0c0b8e63          	beqz	s7,ffffffffc0205802 <vprintfmt+0x2ca>
ffffffffc020572a:	3781                	addw	a5,a5,-32
ffffffffc020572c:	0cfdfb63          	bgeu	s11,a5,ffffffffc0205802 <vprintfmt+0x2ca>
ffffffffc0205730:	03f00513          	li	a0,63
ffffffffc0205734:	9902                	jalr	s2
ffffffffc0205736:	000a4783          	lbu	a5,0(s4)
ffffffffc020573a:	3cfd                	addw	s9,s9,-1
ffffffffc020573c:	0a05                	add	s4,s4,1
ffffffffc020573e:	0007851b          	sext.w	a0,a5
ffffffffc0205742:	ffe1                	bnez	a5,ffffffffc020571a <vprintfmt+0x1e2>
ffffffffc0205744:	01905963          	blez	s9,ffffffffc0205756 <vprintfmt+0x21e>
ffffffffc0205748:	3cfd                	addw	s9,s9,-1
ffffffffc020574a:	85a6                	mv	a1,s1
ffffffffc020574c:	02000513          	li	a0,32
ffffffffc0205750:	9902                	jalr	s2
ffffffffc0205752:	fe0c9be3          	bnez	s9,ffffffffc0205748 <vprintfmt+0x210>
ffffffffc0205756:	6a22                	ld	s4,8(sp)
ffffffffc0205758:	bd11                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc020575a:	4785                	li	a5,1
ffffffffc020575c:	008a0b93          	add	s7,s4,8
ffffffffc0205760:	00c7c363          	blt	a5,a2,ffffffffc0205766 <vprintfmt+0x22e>
ffffffffc0205764:	ce2d                	beqz	a2,ffffffffc02057de <vprintfmt+0x2a6>
ffffffffc0205766:	000a3403          	ld	s0,0(s4)
ffffffffc020576a:	08044e63          	bltz	s0,ffffffffc0205806 <vprintfmt+0x2ce>
ffffffffc020576e:	8622                	mv	a2,s0
ffffffffc0205770:	8a5e                	mv	s4,s7
ffffffffc0205772:	46a9                	li	a3,10
ffffffffc0205774:	b5f5                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc0205776:	000a2783          	lw	a5,0(s4)
ffffffffc020577a:	4661                	li	a2,24
ffffffffc020577c:	41f7d71b          	sraw	a4,a5,0x1f
ffffffffc0205780:	8fb9                	xor	a5,a5,a4
ffffffffc0205782:	40e786bb          	subw	a3,a5,a4
ffffffffc0205786:	02d64663          	blt	a2,a3,ffffffffc02057b2 <vprintfmt+0x27a>
ffffffffc020578a:	00369713          	sll	a4,a3,0x3
ffffffffc020578e:	00003797          	auipc	a5,0x3
ffffffffc0205792:	82278793          	add	a5,a5,-2014 # ffffffffc0207fb0 <error_string>
ffffffffc0205796:	97ba                	add	a5,a5,a4
ffffffffc0205798:	639c                	ld	a5,0(a5)
ffffffffc020579a:	cf81                	beqz	a5,ffffffffc02057b2 <vprintfmt+0x27a>
ffffffffc020579c:	86be                	mv	a3,a5
ffffffffc020579e:	00000617          	auipc	a2,0x0
ffffffffc02057a2:	1ca60613          	add	a2,a2,458 # ffffffffc0205968 <etext+0x20>
ffffffffc02057a6:	85a6                	mv	a1,s1
ffffffffc02057a8:	854a                	mv	a0,s2
ffffffffc02057aa:	0ea000ef          	jal	ffffffffc0205894 <printfmt>
ffffffffc02057ae:	0a21                	add	s4,s4,8
ffffffffc02057b0:	bb75                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc02057b2:	00002617          	auipc	a2,0x2
ffffffffc02057b6:	5d660613          	add	a2,a2,1494 # ffffffffc0207d88 <syscalls+0x820>
ffffffffc02057ba:	85a6                	mv	a1,s1
ffffffffc02057bc:	854a                	mv	a0,s2
ffffffffc02057be:	0d6000ef          	jal	ffffffffc0205894 <printfmt>
ffffffffc02057c2:	0a21                	add	s4,s4,8
ffffffffc02057c4:	b365                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc02057c6:	2605                	addw	a2,a2,1
ffffffffc02057c8:	8462                	mv	s0,s8
ffffffffc02057ca:	b3e9                	j	ffffffffc0205594 <vprintfmt+0x5c>
ffffffffc02057cc:	00044783          	lbu	a5,0(s0)
ffffffffc02057d0:	00140a13          	add	s4,s0,1
ffffffffc02057d4:	0007851b          	sext.w	a0,a5
ffffffffc02057d8:	ff95                	bnez	a5,ffffffffc0205714 <vprintfmt+0x1dc>
ffffffffc02057da:	6a22                	ld	s4,8(sp)
ffffffffc02057dc:	bb41                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc02057de:	000a2403          	lw	s0,0(s4)
ffffffffc02057e2:	b761                	j	ffffffffc020576a <vprintfmt+0x232>
ffffffffc02057e4:	000a6603          	lwu	a2,0(s4)
ffffffffc02057e8:	46a1                	li	a3,8
ffffffffc02057ea:	8a3a                	mv	s4,a4
ffffffffc02057ec:	bd95                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc02057ee:	000a6603          	lwu	a2,0(s4)
ffffffffc02057f2:	46a9                	li	a3,10
ffffffffc02057f4:	8a3a                	mv	s4,a4
ffffffffc02057f6:	b5ad                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc02057f8:	000a6603          	lwu	a2,0(s4)
ffffffffc02057fc:	46c1                	li	a3,16
ffffffffc02057fe:	8a3a                	mv	s4,a4
ffffffffc0205800:	b585                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc0205802:	9902                	jalr	s2
ffffffffc0205804:	bf0d                	j	ffffffffc0205736 <vprintfmt+0x1fe>
ffffffffc0205806:	85a6                	mv	a1,s1
ffffffffc0205808:	02d00513          	li	a0,45
ffffffffc020580c:	9902                	jalr	s2
ffffffffc020580e:	8a5e                	mv	s4,s7
ffffffffc0205810:	40800633          	neg	a2,s0
ffffffffc0205814:	46a9                	li	a3,10
ffffffffc0205816:	b5a9                	j	ffffffffc0205660 <vprintfmt+0x128>
ffffffffc0205818:	01905663          	blez	s9,ffffffffc0205824 <vprintfmt+0x2ec>
ffffffffc020581c:	02d00793          	li	a5,45
ffffffffc0205820:	04fd9263          	bne	s11,a5,ffffffffc0205864 <vprintfmt+0x32c>
ffffffffc0205824:	00002a17          	auipc	s4,0x2
ffffffffc0205828:	55da0a13          	add	s4,s4,1373 # ffffffffc0207d81 <syscalls+0x819>
ffffffffc020582c:	02800513          	li	a0,40
ffffffffc0205830:	02800793          	li	a5,40
ffffffffc0205834:	b5c5                	j	ffffffffc0205714 <vprintfmt+0x1dc>
ffffffffc0205836:	85ea                	mv	a1,s10
ffffffffc0205838:	8522                	mv	a0,s0
ffffffffc020583a:	07a000ef          	jal	ffffffffc02058b4 <strnlen>
ffffffffc020583e:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0205842:	01905963          	blez	s9,ffffffffc0205854 <vprintfmt+0x31c>
ffffffffc0205846:	2d81                	sext.w	s11,s11
ffffffffc0205848:	3cfd                	addw	s9,s9,-1
ffffffffc020584a:	85a6                	mv	a1,s1
ffffffffc020584c:	856e                	mv	a0,s11
ffffffffc020584e:	9902                	jalr	s2
ffffffffc0205850:	fe0c9ce3          	bnez	s9,ffffffffc0205848 <vprintfmt+0x310>
ffffffffc0205854:	00044783          	lbu	a5,0(s0)
ffffffffc0205858:	0007851b          	sext.w	a0,a5
ffffffffc020585c:	ea079ce3          	bnez	a5,ffffffffc0205714 <vprintfmt+0x1dc>
ffffffffc0205860:	6a22                	ld	s4,8(sp)
ffffffffc0205862:	b329                	j	ffffffffc020556c <vprintfmt+0x34>
ffffffffc0205864:	85ea                	mv	a1,s10
ffffffffc0205866:	00002517          	auipc	a0,0x2
ffffffffc020586a:	51a50513          	add	a0,a0,1306 # ffffffffc0207d80 <syscalls+0x818>
ffffffffc020586e:	046000ef          	jal	ffffffffc02058b4 <strnlen>
ffffffffc0205872:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0205876:	00002a17          	auipc	s4,0x2
ffffffffc020587a:	50ba0a13          	add	s4,s4,1291 # ffffffffc0207d81 <syscalls+0x819>
ffffffffc020587e:	00002417          	auipc	s0,0x2
ffffffffc0205882:	50240413          	add	s0,s0,1282 # ffffffffc0207d80 <syscalls+0x818>
ffffffffc0205886:	02800513          	li	a0,40
ffffffffc020588a:	02800793          	li	a5,40
ffffffffc020588e:	fb904ce3          	bgtz	s9,ffffffffc0205846 <vprintfmt+0x30e>
ffffffffc0205892:	b549                	j	ffffffffc0205714 <vprintfmt+0x1dc>

ffffffffc0205894 <printfmt>:
ffffffffc0205894:	715d                	add	sp,sp,-80
ffffffffc0205896:	02810313          	add	t1,sp,40
ffffffffc020589a:	f436                	sd	a3,40(sp)
ffffffffc020589c:	869a                	mv	a3,t1
ffffffffc020589e:	ec06                	sd	ra,24(sp)
ffffffffc02058a0:	f83a                	sd	a4,48(sp)
ffffffffc02058a2:	fc3e                	sd	a5,56(sp)
ffffffffc02058a4:	e0c2                	sd	a6,64(sp)
ffffffffc02058a6:	e4c6                	sd	a7,72(sp)
ffffffffc02058a8:	e41a                	sd	t1,8(sp)
ffffffffc02058aa:	c8fff0ef          	jal	ffffffffc0205538 <vprintfmt>
ffffffffc02058ae:	60e2                	ld	ra,24(sp)
ffffffffc02058b0:	6161                	add	sp,sp,80
ffffffffc02058b2:	8082                	ret

ffffffffc02058b4 <strnlen>:
ffffffffc02058b4:	4781                	li	a5,0
ffffffffc02058b6:	e589                	bnez	a1,ffffffffc02058c0 <strnlen+0xc>
ffffffffc02058b8:	a811                	j	ffffffffc02058cc <strnlen+0x18>
ffffffffc02058ba:	0785                	add	a5,a5,1
ffffffffc02058bc:	00f58863          	beq	a1,a5,ffffffffc02058cc <strnlen+0x18>
ffffffffc02058c0:	00f50733          	add	a4,a0,a5
ffffffffc02058c4:	00074703          	lbu	a4,0(a4)
ffffffffc02058c8:	fb6d                	bnez	a4,ffffffffc02058ba <strnlen+0x6>
ffffffffc02058ca:	85be                	mv	a1,a5
ffffffffc02058cc:	852e                	mv	a0,a1
ffffffffc02058ce:	8082                	ret

ffffffffc02058d0 <strcmp>:
ffffffffc02058d0:	00054783          	lbu	a5,0(a0)
ffffffffc02058d4:	e791                	bnez	a5,ffffffffc02058e0 <strcmp+0x10>
ffffffffc02058d6:	a02d                	j	ffffffffc0205900 <strcmp+0x30>
ffffffffc02058d8:	00054783          	lbu	a5,0(a0)
ffffffffc02058dc:	cf89                	beqz	a5,ffffffffc02058f6 <strcmp+0x26>
ffffffffc02058de:	85b6                	mv	a1,a3
ffffffffc02058e0:	0005c703          	lbu	a4,0(a1)
ffffffffc02058e4:	0505                	add	a0,a0,1
ffffffffc02058e6:	00158693          	add	a3,a1,1
ffffffffc02058ea:	fef707e3          	beq	a4,a5,ffffffffc02058d8 <strcmp+0x8>
ffffffffc02058ee:	0007851b          	sext.w	a0,a5
ffffffffc02058f2:	9d19                	subw	a0,a0,a4
ffffffffc02058f4:	8082                	ret
ffffffffc02058f6:	0015c703          	lbu	a4,1(a1)
ffffffffc02058fa:	4501                	li	a0,0
ffffffffc02058fc:	9d19                	subw	a0,a0,a4
ffffffffc02058fe:	8082                	ret
ffffffffc0205900:	0005c703          	lbu	a4,0(a1)
ffffffffc0205904:	4501                	li	a0,0
ffffffffc0205906:	b7f5                	j	ffffffffc02058f2 <strcmp+0x22>

ffffffffc0205908 <strchr>:
ffffffffc0205908:	00054783          	lbu	a5,0(a0)
ffffffffc020590c:	c799                	beqz	a5,ffffffffc020591a <strchr+0x12>
ffffffffc020590e:	00f58763          	beq	a1,a5,ffffffffc020591c <strchr+0x14>
ffffffffc0205912:	00154783          	lbu	a5,1(a0)
ffffffffc0205916:	0505                	add	a0,a0,1
ffffffffc0205918:	fbfd                	bnez	a5,ffffffffc020590e <strchr+0x6>
ffffffffc020591a:	4501                	li	a0,0
ffffffffc020591c:	8082                	ret

ffffffffc020591e <memset>:
ffffffffc020591e:	ca01                	beqz	a2,ffffffffc020592e <memset+0x10>
ffffffffc0205920:	962a                	add	a2,a2,a0
ffffffffc0205922:	87aa                	mv	a5,a0
ffffffffc0205924:	0785                	add	a5,a5,1
ffffffffc0205926:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020592a:	fec79de3          	bne	a5,a2,ffffffffc0205924 <memset+0x6>
ffffffffc020592e:	8082                	ret

ffffffffc0205930 <memcpy>:
ffffffffc0205930:	ca19                	beqz	a2,ffffffffc0205946 <memcpy+0x16>
ffffffffc0205932:	962e                	add	a2,a2,a1
ffffffffc0205934:	87aa                	mv	a5,a0
ffffffffc0205936:	0005c703          	lbu	a4,0(a1)
ffffffffc020593a:	0585                	add	a1,a1,1
ffffffffc020593c:	0785                	add	a5,a5,1
ffffffffc020593e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205942:	fec59ae3          	bne	a1,a2,ffffffffc0205936 <memcpy+0x6>
ffffffffc0205946:	8082                	ret
