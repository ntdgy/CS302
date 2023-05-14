
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
ffffffffc0200036:	06250513          	add	a0,a0,98 # ffffffffc020c094 <edata>
ffffffffc020003a:	00017617          	auipc	a2,0x17
ffffffffc020003e:	5c660613          	add	a2,a2,1478 # ffffffffc0217600 <end>
ffffffffc0200042:	1141                	add	sp,sp,-16 # ffffffffc020aff0 <bootstack+0x1ff0>
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
ffffffffc0200048:	e406                	sd	ra,8(sp)
ffffffffc020004a:	2e1050ef          	jal	ffffffffc0205b2a <memset>
ffffffffc020004e:	518000ef          	jal	ffffffffc0200566 <cons_init>
ffffffffc0200052:	00006597          	auipc	a1,0x6
ffffffffc0200056:	b0658593          	add	a1,a1,-1274 # ffffffffc0205b58 <etext+0x4>
ffffffffc020005a:	00006517          	auipc	a0,0x6
ffffffffc020005e:	b1650513          	add	a0,a0,-1258 # ffffffffc0205b70 <etext+0x1c>
ffffffffc0200062:	128000ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200066:	435010ef          	jal	ffffffffc0201c9a <pmm_init>
ffffffffc020006a:	5d0000ef          	jal	ffffffffc020063a <pic_init>
ffffffffc020006e:	5ce000ef          	jal	ffffffffc020063c <idt_init>
ffffffffc0200072:	745020ef          	jal	ffffffffc0202fb6 <vmm_init>
ffffffffc0200076:	09c050ef          	jal	ffffffffc0205112 <sched_init>
ffffffffc020007a:	0cd040ef          	jal	ffffffffc0204946 <proc_init>
ffffffffc020007e:	55a000ef          	jal	ffffffffc02005d8 <ide_init>
ffffffffc0200082:	594020ef          	jal	ffffffffc0202616 <swap_init>
ffffffffc0200086:	498000ef          	jal	ffffffffc020051e <clock_init>
ffffffffc020008a:	5a4000ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc020008e:	253040ef          	jal	ffffffffc0204ae0 <cpu_idle>

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
ffffffffc02000ae:	ace50513          	add	a0,a0,-1330 # ffffffffc0205b78 <etext+0x24>
ffffffffc02000b2:	0d8000ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02000b6:	4481                	li	s1,0
ffffffffc02000b8:	497d                	li	s2,31
ffffffffc02000ba:	4a21                	li	s4,8
ffffffffc02000bc:	4aa9                	li	s5,10
ffffffffc02000be:	4b35                	li	s6,13
ffffffffc02000c0:	0000cb97          	auipc	s7,0xc
ffffffffc02000c4:	fd8b8b93          	add	s7,s7,-40 # ffffffffc020c098 <buf>
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
ffffffffc0200130:	f6c50513          	add	a0,a0,-148 # ffffffffc020c098 <buf>
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
ffffffffc020017e:	5c6050ef          	jal	ffffffffc0205744 <vprintfmt>
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
ffffffffc02001b4:	590050ef          	jal	ffffffffc0205744 <vprintfmt>
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
ffffffffc0200214:	00006517          	auipc	a0,0x6
ffffffffc0200218:	96c50513          	add	a0,a0,-1684 # ffffffffc0205b80 <etext+0x2c>
ffffffffc020021c:	e406                	sd	ra,8(sp)
ffffffffc020021e:	f6dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200222:	00000597          	auipc	a1,0x0
ffffffffc0200226:	e1058593          	add	a1,a1,-496 # ffffffffc0200032 <kern_init>
ffffffffc020022a:	00006517          	auipc	a0,0x6
ffffffffc020022e:	97650513          	add	a0,a0,-1674 # ffffffffc0205ba0 <etext+0x4c>
ffffffffc0200232:	f59ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200236:	00006597          	auipc	a1,0x6
ffffffffc020023a:	91e58593          	add	a1,a1,-1762 # ffffffffc0205b54 <etext>
ffffffffc020023e:	00006517          	auipc	a0,0x6
ffffffffc0200242:	98250513          	add	a0,a0,-1662 # ffffffffc0205bc0 <etext+0x6c>
ffffffffc0200246:	f45ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020024a:	0000c597          	auipc	a1,0xc
ffffffffc020024e:	e4a58593          	add	a1,a1,-438 # ffffffffc020c094 <edata>
ffffffffc0200252:	00006517          	auipc	a0,0x6
ffffffffc0200256:	98e50513          	add	a0,a0,-1650 # ffffffffc0205be0 <etext+0x8c>
ffffffffc020025a:	f31ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020025e:	00017597          	auipc	a1,0x17
ffffffffc0200262:	3a258593          	add	a1,a1,930 # ffffffffc0217600 <end>
ffffffffc0200266:	00006517          	auipc	a0,0x6
ffffffffc020026a:	99a50513          	add	a0,a0,-1638 # ffffffffc0205c00 <etext+0xac>
ffffffffc020026e:	f1dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200272:	00017797          	auipc	a5,0x17
ffffffffc0200276:	78d78793          	add	a5,a5,1933 # ffffffffc02179ff <end+0x3ff>
ffffffffc020027a:	00000717          	auipc	a4,0x0
ffffffffc020027e:	db870713          	add	a4,a4,-584 # ffffffffc0200032 <kern_init>
ffffffffc0200282:	8f99                	sub	a5,a5,a4
ffffffffc0200284:	43f7d593          	sra	a1,a5,0x3f
ffffffffc0200288:	60a2                	ld	ra,8(sp)
ffffffffc020028a:	3ff5f593          	and	a1,a1,1023
ffffffffc020028e:	95be                	add	a1,a1,a5
ffffffffc0200290:	85a9                	sra	a1,a1,0xa
ffffffffc0200292:	00006517          	auipc	a0,0x6
ffffffffc0200296:	98e50513          	add	a0,a0,-1650 # ffffffffc0205c20 <etext+0xcc>
ffffffffc020029a:	0141                	add	sp,sp,16
ffffffffc020029c:	b5fd                	j	ffffffffc020018a <cprintf>

ffffffffc020029e <print_stackframe>:
ffffffffc020029e:	1141                	add	sp,sp,-16
ffffffffc02002a0:	00006617          	auipc	a2,0x6
ffffffffc02002a4:	9b060613          	add	a2,a2,-1616 # ffffffffc0205c50 <etext+0xfc>
ffffffffc02002a8:	05b00593          	li	a1,91
ffffffffc02002ac:	00006517          	auipc	a0,0x6
ffffffffc02002b0:	9bc50513          	add	a0,a0,-1604 # ffffffffc0205c68 <etext+0x114>
ffffffffc02002b4:	e406                	sd	ra,8(sp)
ffffffffc02002b6:	1bc000ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02002ba <mon_help>:
ffffffffc02002ba:	1141                	add	sp,sp,-16
ffffffffc02002bc:	00006617          	auipc	a2,0x6
ffffffffc02002c0:	9c460613          	add	a2,a2,-1596 # ffffffffc0205c80 <etext+0x12c>
ffffffffc02002c4:	00006597          	auipc	a1,0x6
ffffffffc02002c8:	9dc58593          	add	a1,a1,-1572 # ffffffffc0205ca0 <etext+0x14c>
ffffffffc02002cc:	00006517          	auipc	a0,0x6
ffffffffc02002d0:	9dc50513          	add	a0,a0,-1572 # ffffffffc0205ca8 <etext+0x154>
ffffffffc02002d4:	e406                	sd	ra,8(sp)
ffffffffc02002d6:	eb5ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02002da:	00006617          	auipc	a2,0x6
ffffffffc02002de:	9de60613          	add	a2,a2,-1570 # ffffffffc0205cb8 <etext+0x164>
ffffffffc02002e2:	00006597          	auipc	a1,0x6
ffffffffc02002e6:	9fe58593          	add	a1,a1,-1538 # ffffffffc0205ce0 <etext+0x18c>
ffffffffc02002ea:	00006517          	auipc	a0,0x6
ffffffffc02002ee:	9be50513          	add	a0,a0,-1602 # ffffffffc0205ca8 <etext+0x154>
ffffffffc02002f2:	e99ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02002f6:	00006617          	auipc	a2,0x6
ffffffffc02002fa:	9fa60613          	add	a2,a2,-1542 # ffffffffc0205cf0 <etext+0x19c>
ffffffffc02002fe:	00006597          	auipc	a1,0x6
ffffffffc0200302:	a1258593          	add	a1,a1,-1518 # ffffffffc0205d10 <etext+0x1bc>
ffffffffc0200306:	00006517          	auipc	a0,0x6
ffffffffc020030a:	9a250513          	add	a0,a0,-1630 # ffffffffc0205ca8 <etext+0x154>
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
ffffffffc0200340:	00006517          	auipc	a0,0x6
ffffffffc0200344:	9e050513          	add	a0,a0,-1568 # ffffffffc0205d20 <etext+0x1cc>
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
ffffffffc0200362:	00006517          	auipc	a0,0x6
ffffffffc0200366:	9e650513          	add	a0,a0,-1562 # ffffffffc0205d48 <etext+0x1f4>
ffffffffc020036a:	e21ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020036e:	000b0563          	beqz	s6,ffffffffc0200378 <kmonitor+0x3e>
ffffffffc0200372:	855a                	mv	a0,s6
ffffffffc0200374:	4b0000ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200378:	00006c17          	auipc	s8,0x6
ffffffffc020037c:	a40c0c13          	add	s8,s8,-1472 # ffffffffc0205db8 <commands>
ffffffffc0200380:	00006917          	auipc	s2,0x6
ffffffffc0200384:	9f090913          	add	s2,s2,-1552 # ffffffffc0205d70 <etext+0x21c>
ffffffffc0200388:	00006497          	auipc	s1,0x6
ffffffffc020038c:	9f048493          	add	s1,s1,-1552 # ffffffffc0205d78 <etext+0x224>
ffffffffc0200390:	49bd                	li	s3,15
ffffffffc0200392:	00006a97          	auipc	s5,0x6
ffffffffc0200396:	9eea8a93          	add	s5,s5,-1554 # ffffffffc0205d80 <etext+0x22c>
ffffffffc020039a:	4a0d                	li	s4,3
ffffffffc020039c:	00006b97          	auipc	s7,0x6
ffffffffc02003a0:	a04b8b93          	add	s7,s7,-1532 # ffffffffc0205da0 <etext+0x24c>
ffffffffc02003a4:	854a                	mv	a0,s2
ffffffffc02003a6:	cedff0ef          	jal	ffffffffc0200092 <readline>
ffffffffc02003aa:	842a                	mv	s0,a0
ffffffffc02003ac:	dd65                	beqz	a0,ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc02003ae:	00054583          	lbu	a1,0(a0)
ffffffffc02003b2:	4c81                	li	s9,0
ffffffffc02003b4:	e59d                	bnez	a1,ffffffffc02003e2 <kmonitor+0xa8>
ffffffffc02003b6:	fe0c87e3          	beqz	s9,ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc02003ba:	00006d17          	auipc	s10,0x6
ffffffffc02003be:	9fed0d13          	add	s10,s10,-1538 # ffffffffc0205db8 <commands>
ffffffffc02003c2:	4401                	li	s0,0
ffffffffc02003c4:	000d3503          	ld	a0,0(s10)
ffffffffc02003c8:	6582                	ld	a1,0(sp)
ffffffffc02003ca:	0d61                	add	s10,s10,24
ffffffffc02003cc:	710050ef          	jal	ffffffffc0205adc <strcmp>
ffffffffc02003d0:	c535                	beqz	a0,ffffffffc020043c <kmonitor+0x102>
ffffffffc02003d2:	2405                	addw	s0,s0,1
ffffffffc02003d4:	ff4418e3          	bne	s0,s4,ffffffffc02003c4 <kmonitor+0x8a>
ffffffffc02003d8:	6582                	ld	a1,0(sp)
ffffffffc02003da:	855e                	mv	a0,s7
ffffffffc02003dc:	dafff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02003e0:	b7d1                	j	ffffffffc02003a4 <kmonitor+0x6a>
ffffffffc02003e2:	8526                	mv	a0,s1
ffffffffc02003e4:	730050ef          	jal	ffffffffc0205b14 <strchr>
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
ffffffffc0200424:	6f0050ef          	jal	ffffffffc0205b14 <strchr>
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
ffffffffc0200476:	0ce30313          	add	t1,t1,206 # ffffffffc0217540 <is_panic>
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
ffffffffc02004a0:	00006517          	auipc	a0,0x6
ffffffffc02004a4:	96050513          	add	a0,a0,-1696 # ffffffffc0205e00 <commands+0x48>
ffffffffc02004a8:	e43e                	sd	a5,8(sp)
ffffffffc02004aa:	ce1ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02004ae:	65a2                	ld	a1,8(sp)
ffffffffc02004b0:	8522                	mv	a0,s0
ffffffffc02004b2:	cb9ff0ef          	jal	ffffffffc020016a <vcprintf>
ffffffffc02004b6:	00007517          	auipc	a0,0x7
ffffffffc02004ba:	ed250513          	add	a0,a0,-302 # ffffffffc0207388 <default_pmm_manager+0xae8>
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
ffffffffc02004ea:	00006517          	auipc	a0,0x6
ffffffffc02004ee:	93650513          	add	a0,a0,-1738 # ffffffffc0205e20 <commands+0x68>
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
ffffffffc020050e:	e7e50513          	add	a0,a0,-386 # ffffffffc0207388 <default_pmm_manager+0xae8>
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
ffffffffc020053c:	00006517          	auipc	a0,0x6
ffffffffc0200540:	90450513          	add	a0,a0,-1788 # ffffffffc0205e40 <commands+0x88>
ffffffffc0200544:	00017797          	auipc	a5,0x17
ffffffffc0200548:	0007b223          	sd	zero,4(a5) # ffffffffc0217548 <ticks>
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
ffffffffc02005ea:	eb278793          	add	a5,a5,-334 # ffffffffc020c498 <ide>
ffffffffc02005ee:	0095959b          	sllw	a1,a1,0x9
ffffffffc02005f2:	1141                	add	sp,sp,-16
ffffffffc02005f4:	8532                	mv	a0,a2
ffffffffc02005f6:	95be                	add	a1,a1,a5
ffffffffc02005f8:	00969613          	sll	a2,a3,0x9
ffffffffc02005fc:	e406                	sd	ra,8(sp)
ffffffffc02005fe:	53e050ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc0200602:	60a2                	ld	ra,8(sp)
ffffffffc0200604:	4501                	li	a0,0
ffffffffc0200606:	0141                	add	sp,sp,16
ffffffffc0200608:	8082                	ret

ffffffffc020060a <ide_write_secs>:
ffffffffc020060a:	0095979b          	sllw	a5,a1,0x9
ffffffffc020060e:	0000c517          	auipc	a0,0xc
ffffffffc0200612:	e8a50513          	add	a0,a0,-374 # ffffffffc020c498 <ide>
ffffffffc0200616:	1141                	add	sp,sp,-16
ffffffffc0200618:	85b2                	mv	a1,a2
ffffffffc020061a:	953e                	add	a0,a0,a5
ffffffffc020061c:	00969613          	sll	a2,a3,0x9
ffffffffc0200620:	e406                	sd	ra,8(sp)
ffffffffc0200622:	51a050ef          	jal	ffffffffc0205b3c <memcpy>
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
ffffffffc020065e:	00006517          	auipc	a0,0x6
ffffffffc0200662:	80250513          	add	a0,a0,-2046 # ffffffffc0205e60 <commands+0xa8>
ffffffffc0200666:	e406                	sd	ra,8(sp)
ffffffffc0200668:	b23ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020066c:	640c                	ld	a1,8(s0)
ffffffffc020066e:	00006517          	auipc	a0,0x6
ffffffffc0200672:	80a50513          	add	a0,a0,-2038 # ffffffffc0205e78 <commands+0xc0>
ffffffffc0200676:	b15ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020067a:	680c                	ld	a1,16(s0)
ffffffffc020067c:	00006517          	auipc	a0,0x6
ffffffffc0200680:	81450513          	add	a0,a0,-2028 # ffffffffc0205e90 <commands+0xd8>
ffffffffc0200684:	b07ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200688:	6c0c                	ld	a1,24(s0)
ffffffffc020068a:	00006517          	auipc	a0,0x6
ffffffffc020068e:	81e50513          	add	a0,a0,-2018 # ffffffffc0205ea8 <commands+0xf0>
ffffffffc0200692:	af9ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200696:	700c                	ld	a1,32(s0)
ffffffffc0200698:	00006517          	auipc	a0,0x6
ffffffffc020069c:	82850513          	add	a0,a0,-2008 # ffffffffc0205ec0 <commands+0x108>
ffffffffc02006a0:	aebff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006a4:	740c                	ld	a1,40(s0)
ffffffffc02006a6:	00006517          	auipc	a0,0x6
ffffffffc02006aa:	83250513          	add	a0,a0,-1998 # ffffffffc0205ed8 <commands+0x120>
ffffffffc02006ae:	addff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006b2:	780c                	ld	a1,48(s0)
ffffffffc02006b4:	00006517          	auipc	a0,0x6
ffffffffc02006b8:	83c50513          	add	a0,a0,-1988 # ffffffffc0205ef0 <commands+0x138>
ffffffffc02006bc:	acfff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006c0:	7c0c                	ld	a1,56(s0)
ffffffffc02006c2:	00006517          	auipc	a0,0x6
ffffffffc02006c6:	84650513          	add	a0,a0,-1978 # ffffffffc0205f08 <commands+0x150>
ffffffffc02006ca:	ac1ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006ce:	602c                	ld	a1,64(s0)
ffffffffc02006d0:	00006517          	auipc	a0,0x6
ffffffffc02006d4:	85050513          	add	a0,a0,-1968 # ffffffffc0205f20 <commands+0x168>
ffffffffc02006d8:	ab3ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006dc:	642c                	ld	a1,72(s0)
ffffffffc02006de:	00006517          	auipc	a0,0x6
ffffffffc02006e2:	85a50513          	add	a0,a0,-1958 # ffffffffc0205f38 <commands+0x180>
ffffffffc02006e6:	aa5ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006ea:	682c                	ld	a1,80(s0)
ffffffffc02006ec:	00006517          	auipc	a0,0x6
ffffffffc02006f0:	86450513          	add	a0,a0,-1948 # ffffffffc0205f50 <commands+0x198>
ffffffffc02006f4:	a97ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02006f8:	6c2c                	ld	a1,88(s0)
ffffffffc02006fa:	00006517          	auipc	a0,0x6
ffffffffc02006fe:	86e50513          	add	a0,a0,-1938 # ffffffffc0205f68 <commands+0x1b0>
ffffffffc0200702:	a89ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200706:	702c                	ld	a1,96(s0)
ffffffffc0200708:	00006517          	auipc	a0,0x6
ffffffffc020070c:	87850513          	add	a0,a0,-1928 # ffffffffc0205f80 <commands+0x1c8>
ffffffffc0200710:	a7bff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200714:	742c                	ld	a1,104(s0)
ffffffffc0200716:	00006517          	auipc	a0,0x6
ffffffffc020071a:	88250513          	add	a0,a0,-1918 # ffffffffc0205f98 <commands+0x1e0>
ffffffffc020071e:	a6dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200722:	782c                	ld	a1,112(s0)
ffffffffc0200724:	00006517          	auipc	a0,0x6
ffffffffc0200728:	88c50513          	add	a0,a0,-1908 # ffffffffc0205fb0 <commands+0x1f8>
ffffffffc020072c:	a5fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200730:	7c2c                	ld	a1,120(s0)
ffffffffc0200732:	00006517          	auipc	a0,0x6
ffffffffc0200736:	89650513          	add	a0,a0,-1898 # ffffffffc0205fc8 <commands+0x210>
ffffffffc020073a:	a51ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020073e:	604c                	ld	a1,128(s0)
ffffffffc0200740:	00006517          	auipc	a0,0x6
ffffffffc0200744:	8a050513          	add	a0,a0,-1888 # ffffffffc0205fe0 <commands+0x228>
ffffffffc0200748:	a43ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020074c:	644c                	ld	a1,136(s0)
ffffffffc020074e:	00006517          	auipc	a0,0x6
ffffffffc0200752:	8aa50513          	add	a0,a0,-1878 # ffffffffc0205ff8 <commands+0x240>
ffffffffc0200756:	a35ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020075a:	684c                	ld	a1,144(s0)
ffffffffc020075c:	00006517          	auipc	a0,0x6
ffffffffc0200760:	8b450513          	add	a0,a0,-1868 # ffffffffc0206010 <commands+0x258>
ffffffffc0200764:	a27ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200768:	6c4c                	ld	a1,152(s0)
ffffffffc020076a:	00006517          	auipc	a0,0x6
ffffffffc020076e:	8be50513          	add	a0,a0,-1858 # ffffffffc0206028 <commands+0x270>
ffffffffc0200772:	a19ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200776:	704c                	ld	a1,160(s0)
ffffffffc0200778:	00006517          	auipc	a0,0x6
ffffffffc020077c:	8c850513          	add	a0,a0,-1848 # ffffffffc0206040 <commands+0x288>
ffffffffc0200780:	a0bff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200784:	744c                	ld	a1,168(s0)
ffffffffc0200786:	00006517          	auipc	a0,0x6
ffffffffc020078a:	8d250513          	add	a0,a0,-1838 # ffffffffc0206058 <commands+0x2a0>
ffffffffc020078e:	9fdff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200792:	784c                	ld	a1,176(s0)
ffffffffc0200794:	00006517          	auipc	a0,0x6
ffffffffc0200798:	8dc50513          	add	a0,a0,-1828 # ffffffffc0206070 <commands+0x2b8>
ffffffffc020079c:	9efff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007a0:	7c4c                	ld	a1,184(s0)
ffffffffc02007a2:	00006517          	auipc	a0,0x6
ffffffffc02007a6:	8e650513          	add	a0,a0,-1818 # ffffffffc0206088 <commands+0x2d0>
ffffffffc02007aa:	9e1ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007ae:	606c                	ld	a1,192(s0)
ffffffffc02007b0:	00006517          	auipc	a0,0x6
ffffffffc02007b4:	8f050513          	add	a0,a0,-1808 # ffffffffc02060a0 <commands+0x2e8>
ffffffffc02007b8:	9d3ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007bc:	646c                	ld	a1,200(s0)
ffffffffc02007be:	00006517          	auipc	a0,0x6
ffffffffc02007c2:	8fa50513          	add	a0,a0,-1798 # ffffffffc02060b8 <commands+0x300>
ffffffffc02007c6:	9c5ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007ca:	686c                	ld	a1,208(s0)
ffffffffc02007cc:	00006517          	auipc	a0,0x6
ffffffffc02007d0:	90450513          	add	a0,a0,-1788 # ffffffffc02060d0 <commands+0x318>
ffffffffc02007d4:	9b7ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007d8:	6c6c                	ld	a1,216(s0)
ffffffffc02007da:	00006517          	auipc	a0,0x6
ffffffffc02007de:	90e50513          	add	a0,a0,-1778 # ffffffffc02060e8 <commands+0x330>
ffffffffc02007e2:	9a9ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007e6:	706c                	ld	a1,224(s0)
ffffffffc02007e8:	00006517          	auipc	a0,0x6
ffffffffc02007ec:	91850513          	add	a0,a0,-1768 # ffffffffc0206100 <commands+0x348>
ffffffffc02007f0:	99bff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02007f4:	746c                	ld	a1,232(s0)
ffffffffc02007f6:	00006517          	auipc	a0,0x6
ffffffffc02007fa:	92250513          	add	a0,a0,-1758 # ffffffffc0206118 <commands+0x360>
ffffffffc02007fe:	98dff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200802:	786c                	ld	a1,240(s0)
ffffffffc0200804:	00006517          	auipc	a0,0x6
ffffffffc0200808:	92c50513          	add	a0,a0,-1748 # ffffffffc0206130 <commands+0x378>
ffffffffc020080c:	97fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200810:	7c6c                	ld	a1,248(s0)
ffffffffc0200812:	6402                	ld	s0,0(sp)
ffffffffc0200814:	60a2                	ld	ra,8(sp)
ffffffffc0200816:	00006517          	auipc	a0,0x6
ffffffffc020081a:	93250513          	add	a0,a0,-1742 # ffffffffc0206148 <commands+0x390>
ffffffffc020081e:	0141                	add	sp,sp,16
ffffffffc0200820:	96bff06f          	j	ffffffffc020018a <cprintf>

ffffffffc0200824 <print_trapframe>:
ffffffffc0200824:	1141                	add	sp,sp,-16
ffffffffc0200826:	e022                	sd	s0,0(sp)
ffffffffc0200828:	85aa                	mv	a1,a0
ffffffffc020082a:	842a                	mv	s0,a0
ffffffffc020082c:	00006517          	auipc	a0,0x6
ffffffffc0200830:	93450513          	add	a0,a0,-1740 # ffffffffc0206160 <commands+0x3a8>
ffffffffc0200834:	e406                	sd	ra,8(sp)
ffffffffc0200836:	955ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020083a:	8522                	mv	a0,s0
ffffffffc020083c:	e1bff0ef          	jal	ffffffffc0200656 <print_regs>
ffffffffc0200840:	10043583          	ld	a1,256(s0)
ffffffffc0200844:	00006517          	auipc	a0,0x6
ffffffffc0200848:	93450513          	add	a0,a0,-1740 # ffffffffc0206178 <commands+0x3c0>
ffffffffc020084c:	93fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200850:	10843583          	ld	a1,264(s0)
ffffffffc0200854:	00006517          	auipc	a0,0x6
ffffffffc0200858:	93c50513          	add	a0,a0,-1732 # ffffffffc0206190 <commands+0x3d8>
ffffffffc020085c:	92fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200860:	11043583          	ld	a1,272(s0)
ffffffffc0200864:	00006517          	auipc	a0,0x6
ffffffffc0200868:	94450513          	add	a0,a0,-1724 # ffffffffc02061a8 <commands+0x3f0>
ffffffffc020086c:	91fff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200870:	11843583          	ld	a1,280(s0)
ffffffffc0200874:	6402                	ld	s0,0(sp)
ffffffffc0200876:	60a2                	ld	ra,8(sp)
ffffffffc0200878:	00006517          	auipc	a0,0x6
ffffffffc020087c:	94050513          	add	a0,a0,-1728 # ffffffffc02061b8 <commands+0x400>
ffffffffc0200880:	0141                	add	sp,sp,16
ffffffffc0200882:	909ff06f          	j	ffffffffc020018a <cprintf>

ffffffffc0200886 <pgfault_handler>:
ffffffffc0200886:	1101                	add	sp,sp,-32
ffffffffc0200888:	e426                	sd	s1,8(sp)
ffffffffc020088a:	00017497          	auipc	s1,0x17
ffffffffc020088e:	d1e48493          	add	s1,s1,-738 # ffffffffc02175a8 <check_mm_struct>
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
ffffffffc02008c0:	00006517          	auipc	a0,0x6
ffffffffc02008c4:	91050513          	add	a0,a0,-1776 # ffffffffc02061d0 <commands+0x418>
ffffffffc02008c8:	8c3ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02008cc:	6088                	ld	a0,0(s1)
ffffffffc02008ce:	c50d                	beqz	a0,ffffffffc02008f8 <pgfault_handler+0x72>
ffffffffc02008d0:	00017717          	auipc	a4,0x17
ffffffffc02008d4:	d0873703          	ld	a4,-760(a4) # ffffffffc02175d8 <current>
ffffffffc02008d8:	00017797          	auipc	a5,0x17
ffffffffc02008dc:	d107b783          	ld	a5,-752(a5) # ffffffffc02175e8 <idleproc>
ffffffffc02008e0:	02f71f63          	bne	a4,a5,ffffffffc020091e <pgfault_handler+0x98>
ffffffffc02008e4:	11043603          	ld	a2,272(s0)
ffffffffc02008e8:	11843583          	ld	a1,280(s0)
ffffffffc02008ec:	6442                	ld	s0,16(sp)
ffffffffc02008ee:	60e2                	ld	ra,24(sp)
ffffffffc02008f0:	64a2                	ld	s1,8(sp)
ffffffffc02008f2:	6105                	add	sp,sp,32
ffffffffc02008f4:	6c40206f          	j	ffffffffc0202fb8 <do_pgfault>
ffffffffc02008f8:	00017797          	auipc	a5,0x17
ffffffffc02008fc:	ce07b783          	ld	a5,-800(a5) # ffffffffc02175d8 <current>
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
ffffffffc020091e:	00006697          	auipc	a3,0x6
ffffffffc0200922:	8d268693          	add	a3,a3,-1838 # ffffffffc02061f0 <commands+0x438>
ffffffffc0200926:	00006617          	auipc	a2,0x6
ffffffffc020092a:	8e260613          	add	a2,a2,-1822 # ffffffffc0206208 <commands+0x450>
ffffffffc020092e:	06c00593          	li	a1,108
ffffffffc0200932:	00006517          	auipc	a0,0x6
ffffffffc0200936:	8ee50513          	add	a0,a0,-1810 # ffffffffc0206220 <commands+0x468>
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
ffffffffc020096c:	00006517          	auipc	a0,0x6
ffffffffc0200970:	86450513          	add	a0,a0,-1948 # ffffffffc02061d0 <commands+0x418>
ffffffffc0200974:	817ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200978:	00006617          	auipc	a2,0x6
ffffffffc020097c:	8c060613          	add	a2,a2,-1856 # ffffffffc0206238 <commands+0x480>
ffffffffc0200980:	07300593          	li	a1,115
ffffffffc0200984:	00006517          	auipc	a0,0x6
ffffffffc0200988:	89c50513          	add	a0,a0,-1892 # ffffffffc0206220 <commands+0x468>
ffffffffc020098c:	ae7ff0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0200990 <interrupt_handler>:
ffffffffc0200990:	11853783          	ld	a5,280(a0)
ffffffffc0200994:	472d                	li	a4,11
ffffffffc0200996:	0786                	sll	a5,a5,0x1
ffffffffc0200998:	8385                	srl	a5,a5,0x1
ffffffffc020099a:	06f76863          	bltu	a4,a5,ffffffffc0200a0a <interrupt_handler+0x7a>
ffffffffc020099e:	00006717          	auipc	a4,0x6
ffffffffc02009a2:	95270713          	add	a4,a4,-1710 # ffffffffc02062f0 <commands+0x538>
ffffffffc02009a6:	078a                	sll	a5,a5,0x2
ffffffffc02009a8:	97ba                	add	a5,a5,a4
ffffffffc02009aa:	439c                	lw	a5,0(a5)
ffffffffc02009ac:	97ba                	add	a5,a5,a4
ffffffffc02009ae:	8782                	jr	a5
ffffffffc02009b0:	00006517          	auipc	a0,0x6
ffffffffc02009b4:	90050513          	add	a0,a0,-1792 # ffffffffc02062b0 <commands+0x4f8>
ffffffffc02009b8:	fd2ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009bc:	00006517          	auipc	a0,0x6
ffffffffc02009c0:	8d450513          	add	a0,a0,-1836 # ffffffffc0206290 <commands+0x4d8>
ffffffffc02009c4:	fc6ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009c8:	00006517          	auipc	a0,0x6
ffffffffc02009cc:	88850513          	add	a0,a0,-1912 # ffffffffc0206250 <commands+0x498>
ffffffffc02009d0:	fbaff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009d4:	00006517          	auipc	a0,0x6
ffffffffc02009d8:	89c50513          	add	a0,a0,-1892 # ffffffffc0206270 <commands+0x4b8>
ffffffffc02009dc:	faeff06f          	j	ffffffffc020018a <cprintf>
ffffffffc02009e0:	1141                	add	sp,sp,-16
ffffffffc02009e2:	e406                	sd	ra,8(sp)
ffffffffc02009e4:	b6bff0ef          	jal	ffffffffc020054e <clock_set_next_event>
ffffffffc02009e8:	00017717          	auipc	a4,0x17
ffffffffc02009ec:	b6070713          	add	a4,a4,-1184 # ffffffffc0217548 <ticks>
ffffffffc02009f0:	631c                	ld	a5,0(a4)
ffffffffc02009f2:	60a2                	ld	ra,8(sp)
ffffffffc02009f4:	0785                	add	a5,a5,1
ffffffffc02009f6:	e31c                	sd	a5,0(a4)
ffffffffc02009f8:	0141                	add	sp,sp,16
ffffffffc02009fa:	2810406f          	j	ffffffffc020547a <run_timer_list>
ffffffffc02009fe:	00006517          	auipc	a0,0x6
ffffffffc0200a02:	8d250513          	add	a0,a0,-1838 # ffffffffc02062d0 <commands+0x518>
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
ffffffffc0200a24:	a9870713          	add	a4,a4,-1384 # ffffffffc02064b8 <commands+0x700>
ffffffffc0200a28:	078a                	sll	a5,a5,0x2
ffffffffc0200a2a:	97ba                	add	a5,a5,a4
ffffffffc0200a2c:	439c                	lw	a5,0(a5)
ffffffffc0200a2e:	97ba                	add	a5,a5,a4
ffffffffc0200a30:	8782                	jr	a5
ffffffffc0200a32:	00006517          	auipc	a0,0x6
ffffffffc0200a36:	9de50513          	add	a0,a0,-1570 # ffffffffc0206410 <commands+0x658>
ffffffffc0200a3a:	f50ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200a3e:	10843783          	ld	a5,264(s0)
ffffffffc0200a42:	60e2                	ld	ra,24(sp)
ffffffffc0200a44:	64a2                	ld	s1,8(sp)
ffffffffc0200a46:	0791                	add	a5,a5,4
ffffffffc0200a48:	10f43423          	sd	a5,264(s0)
ffffffffc0200a4c:	6442                	ld	s0,16(sp)
ffffffffc0200a4e:	6105                	add	sp,sp,32
ffffffffc0200a50:	3ef0406f          	j	ffffffffc020563e <syscall>
ffffffffc0200a54:	00006517          	auipc	a0,0x6
ffffffffc0200a58:	9dc50513          	add	a0,a0,-1572 # ffffffffc0206430 <commands+0x678>
ffffffffc0200a5c:	6442                	ld	s0,16(sp)
ffffffffc0200a5e:	60e2                	ld	ra,24(sp)
ffffffffc0200a60:	64a2                	ld	s1,8(sp)
ffffffffc0200a62:	6105                	add	sp,sp,32
ffffffffc0200a64:	f26ff06f          	j	ffffffffc020018a <cprintf>
ffffffffc0200a68:	00006517          	auipc	a0,0x6
ffffffffc0200a6c:	9e850513          	add	a0,a0,-1560 # ffffffffc0206450 <commands+0x698>
ffffffffc0200a70:	b7f5                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200a72:	00006517          	auipc	a0,0x6
ffffffffc0200a76:	9fe50513          	add	a0,a0,-1538 # ffffffffc0206470 <commands+0x6b8>
ffffffffc0200a7a:	b7cd                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200a7c:	00006517          	auipc	a0,0x6
ffffffffc0200a80:	a0c50513          	add	a0,a0,-1524 # ffffffffc0206488 <commands+0x6d0>
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
ffffffffc0200a9e:	00006517          	auipc	a0,0x6
ffffffffc0200aa2:	a0250513          	add	a0,a0,-1534 # ffffffffc02064a0 <commands+0x6e8>
ffffffffc0200aa6:	ee4ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200aaa:	8522                	mv	a0,s0
ffffffffc0200aac:	ddbff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200ab0:	84aa                	mv	s1,a0
ffffffffc0200ab2:	d16d                	beqz	a0,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200ab4:	8522                	mv	a0,s0
ffffffffc0200ab6:	d6fff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200aba:	86a6                	mv	a3,s1
ffffffffc0200abc:	00006617          	auipc	a2,0x6
ffffffffc0200ac0:	90460613          	add	a2,a2,-1788 # ffffffffc02063c0 <commands+0x608>
ffffffffc0200ac4:	0f600593          	li	a1,246
ffffffffc0200ac8:	00005517          	auipc	a0,0x5
ffffffffc0200acc:	75850513          	add	a0,a0,1880 # ffffffffc0206220 <commands+0x468>
ffffffffc0200ad0:	9a3ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200ad4:	00006517          	auipc	a0,0x6
ffffffffc0200ad8:	84c50513          	add	a0,a0,-1972 # ffffffffc0206320 <commands+0x568>
ffffffffc0200adc:	b741                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200ade:	00006517          	auipc	a0,0x6
ffffffffc0200ae2:	86250513          	add	a0,a0,-1950 # ffffffffc0206340 <commands+0x588>
ffffffffc0200ae6:	bf9d                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200ae8:	00006517          	auipc	a0,0x6
ffffffffc0200aec:	87850513          	add	a0,a0,-1928 # ffffffffc0206360 <commands+0x5a8>
ffffffffc0200af0:	b7b5                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200af2:	00006517          	auipc	a0,0x6
ffffffffc0200af6:	88650513          	add	a0,a0,-1914 # ffffffffc0206378 <commands+0x5c0>
ffffffffc0200afa:	e90ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200afe:	6458                	ld	a4,136(s0)
ffffffffc0200b00:	47a9                	li	a5,10
ffffffffc0200b02:	f8f719e3          	bne	a4,a5,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200b06:	bf25                	j	ffffffffc0200a3e <exception_handler+0x32>
ffffffffc0200b08:	00006517          	auipc	a0,0x6
ffffffffc0200b0c:	88050513          	add	a0,a0,-1920 # ffffffffc0206388 <commands+0x5d0>
ffffffffc0200b10:	b7b1                	j	ffffffffc0200a5c <exception_handler+0x50>
ffffffffc0200b12:	00006517          	auipc	a0,0x6
ffffffffc0200b16:	89650513          	add	a0,a0,-1898 # ffffffffc02063a8 <commands+0x5f0>
ffffffffc0200b1a:	e70ff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200b1e:	8522                	mv	a0,s0
ffffffffc0200b20:	d67ff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200b24:	84aa                	mv	s1,a0
ffffffffc0200b26:	d53d                	beqz	a0,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200b28:	8522                	mv	a0,s0
ffffffffc0200b2a:	cfbff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200b2e:	86a6                	mv	a3,s1
ffffffffc0200b30:	00006617          	auipc	a2,0x6
ffffffffc0200b34:	89060613          	add	a2,a2,-1904 # ffffffffc02063c0 <commands+0x608>
ffffffffc0200b38:	0cb00593          	li	a1,203
ffffffffc0200b3c:	00005517          	auipc	a0,0x5
ffffffffc0200b40:	6e450513          	add	a0,a0,1764 # ffffffffc0206220 <commands+0x468>
ffffffffc0200b44:	92fff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200b48:	00006517          	auipc	a0,0x6
ffffffffc0200b4c:	8b050513          	add	a0,a0,-1872 # ffffffffc02063f8 <commands+0x640>
ffffffffc0200b50:	e3aff0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0200b54:	8522                	mv	a0,s0
ffffffffc0200b56:	d31ff0ef          	jal	ffffffffc0200886 <pgfault_handler>
ffffffffc0200b5a:	84aa                	mv	s1,a0
ffffffffc0200b5c:	dd05                	beqz	a0,ffffffffc0200a94 <exception_handler+0x88>
ffffffffc0200b5e:	8522                	mv	a0,s0
ffffffffc0200b60:	cc5ff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200b64:	86a6                	mv	a3,s1
ffffffffc0200b66:	00006617          	auipc	a2,0x6
ffffffffc0200b6a:	85a60613          	add	a2,a2,-1958 # ffffffffc02063c0 <commands+0x608>
ffffffffc0200b6e:	0d500593          	li	a1,213
ffffffffc0200b72:	00005517          	auipc	a0,0x5
ffffffffc0200b76:	6ae50513          	add	a0,a0,1710 # ffffffffc0206220 <commands+0x468>
ffffffffc0200b7a:	8f9ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200b7e:	8522                	mv	a0,s0
ffffffffc0200b80:	6442                	ld	s0,16(sp)
ffffffffc0200b82:	60e2                	ld	ra,24(sp)
ffffffffc0200b84:	64a2                	ld	s1,8(sp)
ffffffffc0200b86:	6105                	add	sp,sp,32
ffffffffc0200b88:	b971                	j	ffffffffc0200824 <print_trapframe>
ffffffffc0200b8a:	00006617          	auipc	a2,0x6
ffffffffc0200b8e:	85660613          	add	a2,a2,-1962 # ffffffffc02063e0 <commands+0x628>
ffffffffc0200b92:	0cf00593          	li	a1,207
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	68a50513          	add	a0,a0,1674 # ffffffffc0206220 <commands+0x468>
ffffffffc0200b9e:	8d5ff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0200ba2:	8522                	mv	a0,s0
ffffffffc0200ba4:	c81ff0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc0200ba8:	86a6                	mv	a3,s1
ffffffffc0200baa:	00006617          	auipc	a2,0x6
ffffffffc0200bae:	81660613          	add	a2,a2,-2026 # ffffffffc02063c0 <commands+0x608>
ffffffffc0200bb2:	0ef00593          	li	a1,239
ffffffffc0200bb6:	00005517          	auipc	a0,0x5
ffffffffc0200bba:	66a50513          	add	a0,a0,1642 # ffffffffc0206220 <commands+0x468>
ffffffffc0200bbe:	8b5ff0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0200bc2 <trap>:
ffffffffc0200bc2:	1101                	add	sp,sp,-32
ffffffffc0200bc4:	e822                	sd	s0,16(sp)
ffffffffc0200bc6:	00017417          	auipc	s0,0x17
ffffffffc0200bca:	a1240413          	add	s0,s0,-1518 # ffffffffc02175d8 <current>
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
ffffffffc0200c3e:	62c0406f          	j	ffffffffc020526a <schedule>
ffffffffc0200c42:	555d                	li	a0,-9
ffffffffc0200c44:	2ea030ef          	jal	ffffffffc0203f2e <do_exit>
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
ffffffffc0200d1e:	77e78793          	add	a5,a5,1918 # ffffffffc0213498 <free_area>
ffffffffc0200d22:	e79c                	sd	a5,8(a5)
ffffffffc0200d24:	e39c                	sd	a5,0(a5)
ffffffffc0200d26:	0007a823          	sw	zero,16(a5)
ffffffffc0200d2a:	8082                	ret

ffffffffc0200d2c <default_nr_free_pages>:
ffffffffc0200d2c:	00012517          	auipc	a0,0x12
ffffffffc0200d30:	77c56503          	lwu	a0,1916(a0) # ffffffffc02134a8 <free_area+0x10>
ffffffffc0200d34:	8082                	ret

ffffffffc0200d36 <default_check>:
ffffffffc0200d36:	715d                	add	sp,sp,-80
ffffffffc0200d38:	e0a2                	sd	s0,64(sp)
ffffffffc0200d3a:	00012417          	auipc	s0,0x12
ffffffffc0200d3e:	75e40413          	add	s0,s0,1886 # ffffffffc0213498 <free_area>
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
ffffffffc0200dc6:	00016797          	auipc	a5,0x16
ffffffffc0200dca:	7ba7b783          	ld	a5,1978(a5) # ffffffffc0217580 <pages>
ffffffffc0200dce:	40fa8733          	sub	a4,s5,a5
ffffffffc0200dd2:	00007617          	auipc	a2,0x7
ffffffffc0200dd6:	5e663603          	ld	a2,1510(a2) # ffffffffc02083b8 <nbase>
ffffffffc0200dda:	8719                	sra	a4,a4,0x6
ffffffffc0200ddc:	9732                	add	a4,a4,a2
ffffffffc0200dde:	00016697          	auipc	a3,0x16
ffffffffc0200de2:	79a6b683          	ld	a3,1946(a3) # ffffffffc0217578 <npage>
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
ffffffffc0200e20:	6807a623          	sw	zero,1676(a5) # ffffffffc02134a8 <free_area+0x10>
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
ffffffffc0200f02:	5a07a523          	sw	zero,1450(a5) # ffffffffc02134a8 <free_area+0x10>
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
ffffffffc020101c:	4e068693          	add	a3,a3,1248 # ffffffffc02064f8 <commands+0x740>
ffffffffc0201020:	00005617          	auipc	a2,0x5
ffffffffc0201024:	1e860613          	add	a2,a2,488 # ffffffffc0206208 <commands+0x450>
ffffffffc0201028:	0f000593          	li	a1,240
ffffffffc020102c:	00005517          	auipc	a0,0x5
ffffffffc0201030:	4dc50513          	add	a0,a0,1244 # ffffffffc0206508 <commands+0x750>
ffffffffc0201034:	c3eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201038:	00005697          	auipc	a3,0x5
ffffffffc020103c:	56868693          	add	a3,a3,1384 # ffffffffc02065a0 <commands+0x7e8>
ffffffffc0201040:	00005617          	auipc	a2,0x5
ffffffffc0201044:	1c860613          	add	a2,a2,456 # ffffffffc0206208 <commands+0x450>
ffffffffc0201048:	0bd00593          	li	a1,189
ffffffffc020104c:	00005517          	auipc	a0,0x5
ffffffffc0201050:	4bc50513          	add	a0,a0,1212 # ffffffffc0206508 <commands+0x750>
ffffffffc0201054:	c1eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201058:	00005697          	auipc	a3,0x5
ffffffffc020105c:	57068693          	add	a3,a3,1392 # ffffffffc02065c8 <commands+0x810>
ffffffffc0201060:	00005617          	auipc	a2,0x5
ffffffffc0201064:	1a860613          	add	a2,a2,424 # ffffffffc0206208 <commands+0x450>
ffffffffc0201068:	0be00593          	li	a1,190
ffffffffc020106c:	00005517          	auipc	a0,0x5
ffffffffc0201070:	49c50513          	add	a0,a0,1180 # ffffffffc0206508 <commands+0x750>
ffffffffc0201074:	bfeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201078:	00005697          	auipc	a3,0x5
ffffffffc020107c:	59068693          	add	a3,a3,1424 # ffffffffc0206608 <commands+0x850>
ffffffffc0201080:	00005617          	auipc	a2,0x5
ffffffffc0201084:	18860613          	add	a2,a2,392 # ffffffffc0206208 <commands+0x450>
ffffffffc0201088:	0c000593          	li	a1,192
ffffffffc020108c:	00005517          	auipc	a0,0x5
ffffffffc0201090:	47c50513          	add	a0,a0,1148 # ffffffffc0206508 <commands+0x750>
ffffffffc0201094:	bdeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201098:	00005697          	auipc	a3,0x5
ffffffffc020109c:	5f868693          	add	a3,a3,1528 # ffffffffc0206690 <commands+0x8d8>
ffffffffc02010a0:	00005617          	auipc	a2,0x5
ffffffffc02010a4:	16860613          	add	a2,a2,360 # ffffffffc0206208 <commands+0x450>
ffffffffc02010a8:	0d900593          	li	a1,217
ffffffffc02010ac:	00005517          	auipc	a0,0x5
ffffffffc02010b0:	45c50513          	add	a0,a0,1116 # ffffffffc0206508 <commands+0x750>
ffffffffc02010b4:	bbeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02010b8:	00005697          	auipc	a3,0x5
ffffffffc02010bc:	48868693          	add	a3,a3,1160 # ffffffffc0206540 <commands+0x788>
ffffffffc02010c0:	00005617          	auipc	a2,0x5
ffffffffc02010c4:	14860613          	add	a2,a2,328 # ffffffffc0206208 <commands+0x450>
ffffffffc02010c8:	0d200593          	li	a1,210
ffffffffc02010cc:	00005517          	auipc	a0,0x5
ffffffffc02010d0:	43c50513          	add	a0,a0,1084 # ffffffffc0206508 <commands+0x750>
ffffffffc02010d4:	b9eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02010d8:	00005697          	auipc	a3,0x5
ffffffffc02010dc:	5a868693          	add	a3,a3,1448 # ffffffffc0206680 <commands+0x8c8>
ffffffffc02010e0:	00005617          	auipc	a2,0x5
ffffffffc02010e4:	12860613          	add	a2,a2,296 # ffffffffc0206208 <commands+0x450>
ffffffffc02010e8:	0d000593          	li	a1,208
ffffffffc02010ec:	00005517          	auipc	a0,0x5
ffffffffc02010f0:	41c50513          	add	a0,a0,1052 # ffffffffc0206508 <commands+0x750>
ffffffffc02010f4:	b7eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02010f8:	00005697          	auipc	a3,0x5
ffffffffc02010fc:	57068693          	add	a3,a3,1392 # ffffffffc0206668 <commands+0x8b0>
ffffffffc0201100:	00005617          	auipc	a2,0x5
ffffffffc0201104:	10860613          	add	a2,a2,264 # ffffffffc0206208 <commands+0x450>
ffffffffc0201108:	0cb00593          	li	a1,203
ffffffffc020110c:	00005517          	auipc	a0,0x5
ffffffffc0201110:	3fc50513          	add	a0,a0,1020 # ffffffffc0206508 <commands+0x750>
ffffffffc0201114:	b5eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201118:	00005697          	auipc	a3,0x5
ffffffffc020111c:	53068693          	add	a3,a3,1328 # ffffffffc0206648 <commands+0x890>
ffffffffc0201120:	00005617          	auipc	a2,0x5
ffffffffc0201124:	0e860613          	add	a2,a2,232 # ffffffffc0206208 <commands+0x450>
ffffffffc0201128:	0c200593          	li	a1,194
ffffffffc020112c:	00005517          	auipc	a0,0x5
ffffffffc0201130:	3dc50513          	add	a0,a0,988 # ffffffffc0206508 <commands+0x750>
ffffffffc0201134:	b3eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201138:	00005697          	auipc	a3,0x5
ffffffffc020113c:	5a068693          	add	a3,a3,1440 # ffffffffc02066d8 <commands+0x920>
ffffffffc0201140:	00005617          	auipc	a2,0x5
ffffffffc0201144:	0c860613          	add	a2,a2,200 # ffffffffc0206208 <commands+0x450>
ffffffffc0201148:	0f800593          	li	a1,248
ffffffffc020114c:	00005517          	auipc	a0,0x5
ffffffffc0201150:	3bc50513          	add	a0,a0,956 # ffffffffc0206508 <commands+0x750>
ffffffffc0201154:	b1eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201158:	00005697          	auipc	a3,0x5
ffffffffc020115c:	57068693          	add	a3,a3,1392 # ffffffffc02066c8 <commands+0x910>
ffffffffc0201160:	00005617          	auipc	a2,0x5
ffffffffc0201164:	0a860613          	add	a2,a2,168 # ffffffffc0206208 <commands+0x450>
ffffffffc0201168:	0df00593          	li	a1,223
ffffffffc020116c:	00005517          	auipc	a0,0x5
ffffffffc0201170:	39c50513          	add	a0,a0,924 # ffffffffc0206508 <commands+0x750>
ffffffffc0201174:	afeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201178:	00005697          	auipc	a3,0x5
ffffffffc020117c:	4f068693          	add	a3,a3,1264 # ffffffffc0206668 <commands+0x8b0>
ffffffffc0201180:	00005617          	auipc	a2,0x5
ffffffffc0201184:	08860613          	add	a2,a2,136 # ffffffffc0206208 <commands+0x450>
ffffffffc0201188:	0dd00593          	li	a1,221
ffffffffc020118c:	00005517          	auipc	a0,0x5
ffffffffc0201190:	37c50513          	add	a0,a0,892 # ffffffffc0206508 <commands+0x750>
ffffffffc0201194:	adeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201198:	00005697          	auipc	a3,0x5
ffffffffc020119c:	51068693          	add	a3,a3,1296 # ffffffffc02066a8 <commands+0x8f0>
ffffffffc02011a0:	00005617          	auipc	a2,0x5
ffffffffc02011a4:	06860613          	add	a2,a2,104 # ffffffffc0206208 <commands+0x450>
ffffffffc02011a8:	0dc00593          	li	a1,220
ffffffffc02011ac:	00005517          	auipc	a0,0x5
ffffffffc02011b0:	35c50513          	add	a0,a0,860 # ffffffffc0206508 <commands+0x750>
ffffffffc02011b4:	abeff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02011b8:	00005697          	auipc	a3,0x5
ffffffffc02011bc:	38868693          	add	a3,a3,904 # ffffffffc0206540 <commands+0x788>
ffffffffc02011c0:	00005617          	auipc	a2,0x5
ffffffffc02011c4:	04860613          	add	a2,a2,72 # ffffffffc0206208 <commands+0x450>
ffffffffc02011c8:	0b900593          	li	a1,185
ffffffffc02011cc:	00005517          	auipc	a0,0x5
ffffffffc02011d0:	33c50513          	add	a0,a0,828 # ffffffffc0206508 <commands+0x750>
ffffffffc02011d4:	a9eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02011d8:	00005697          	auipc	a3,0x5
ffffffffc02011dc:	49068693          	add	a3,a3,1168 # ffffffffc0206668 <commands+0x8b0>
ffffffffc02011e0:	00005617          	auipc	a2,0x5
ffffffffc02011e4:	02860613          	add	a2,a2,40 # ffffffffc0206208 <commands+0x450>
ffffffffc02011e8:	0d600593          	li	a1,214
ffffffffc02011ec:	00005517          	auipc	a0,0x5
ffffffffc02011f0:	31c50513          	add	a0,a0,796 # ffffffffc0206508 <commands+0x750>
ffffffffc02011f4:	a7eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02011f8:	00005697          	auipc	a3,0x5
ffffffffc02011fc:	38868693          	add	a3,a3,904 # ffffffffc0206580 <commands+0x7c8>
ffffffffc0201200:	00005617          	auipc	a2,0x5
ffffffffc0201204:	00860613          	add	a2,a2,8 # ffffffffc0206208 <commands+0x450>
ffffffffc0201208:	0d400593          	li	a1,212
ffffffffc020120c:	00005517          	auipc	a0,0x5
ffffffffc0201210:	2fc50513          	add	a0,a0,764 # ffffffffc0206508 <commands+0x750>
ffffffffc0201214:	a5eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201218:	00005697          	auipc	a3,0x5
ffffffffc020121c:	34868693          	add	a3,a3,840 # ffffffffc0206560 <commands+0x7a8>
ffffffffc0201220:	00005617          	auipc	a2,0x5
ffffffffc0201224:	fe860613          	add	a2,a2,-24 # ffffffffc0206208 <commands+0x450>
ffffffffc0201228:	0d300593          	li	a1,211
ffffffffc020122c:	00005517          	auipc	a0,0x5
ffffffffc0201230:	2dc50513          	add	a0,a0,732 # ffffffffc0206508 <commands+0x750>
ffffffffc0201234:	a3eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201238:	00005697          	auipc	a3,0x5
ffffffffc020123c:	34868693          	add	a3,a3,840 # ffffffffc0206580 <commands+0x7c8>
ffffffffc0201240:	00005617          	auipc	a2,0x5
ffffffffc0201244:	fc860613          	add	a2,a2,-56 # ffffffffc0206208 <commands+0x450>
ffffffffc0201248:	0bb00593          	li	a1,187
ffffffffc020124c:	00005517          	auipc	a0,0x5
ffffffffc0201250:	2bc50513          	add	a0,a0,700 # ffffffffc0206508 <commands+0x750>
ffffffffc0201254:	a1eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201258:	00005697          	auipc	a3,0x5
ffffffffc020125c:	5d068693          	add	a3,a3,1488 # ffffffffc0206828 <commands+0xa70>
ffffffffc0201260:	00005617          	auipc	a2,0x5
ffffffffc0201264:	fa860613          	add	a2,a2,-88 # ffffffffc0206208 <commands+0x450>
ffffffffc0201268:	12500593          	li	a1,293
ffffffffc020126c:	00005517          	auipc	a0,0x5
ffffffffc0201270:	29c50513          	add	a0,a0,668 # ffffffffc0206508 <commands+0x750>
ffffffffc0201274:	9feff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201278:	00005697          	auipc	a3,0x5
ffffffffc020127c:	45068693          	add	a3,a3,1104 # ffffffffc02066c8 <commands+0x910>
ffffffffc0201280:	00005617          	auipc	a2,0x5
ffffffffc0201284:	f8860613          	add	a2,a2,-120 # ffffffffc0206208 <commands+0x450>
ffffffffc0201288:	11a00593          	li	a1,282
ffffffffc020128c:	00005517          	auipc	a0,0x5
ffffffffc0201290:	27c50513          	add	a0,a0,636 # ffffffffc0206508 <commands+0x750>
ffffffffc0201294:	9deff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201298:	00005697          	auipc	a3,0x5
ffffffffc020129c:	3d068693          	add	a3,a3,976 # ffffffffc0206668 <commands+0x8b0>
ffffffffc02012a0:	00005617          	auipc	a2,0x5
ffffffffc02012a4:	f6860613          	add	a2,a2,-152 # ffffffffc0206208 <commands+0x450>
ffffffffc02012a8:	11800593          	li	a1,280
ffffffffc02012ac:	00005517          	auipc	a0,0x5
ffffffffc02012b0:	25c50513          	add	a0,a0,604 # ffffffffc0206508 <commands+0x750>
ffffffffc02012b4:	9beff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02012b8:	00005697          	auipc	a3,0x5
ffffffffc02012bc:	37068693          	add	a3,a3,880 # ffffffffc0206628 <commands+0x870>
ffffffffc02012c0:	00005617          	auipc	a2,0x5
ffffffffc02012c4:	f4860613          	add	a2,a2,-184 # ffffffffc0206208 <commands+0x450>
ffffffffc02012c8:	0c100593          	li	a1,193
ffffffffc02012cc:	00005517          	auipc	a0,0x5
ffffffffc02012d0:	23c50513          	add	a0,a0,572 # ffffffffc0206508 <commands+0x750>
ffffffffc02012d4:	99eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02012d8:	00005697          	auipc	a3,0x5
ffffffffc02012dc:	51068693          	add	a3,a3,1296 # ffffffffc02067e8 <commands+0xa30>
ffffffffc02012e0:	00005617          	auipc	a2,0x5
ffffffffc02012e4:	f2860613          	add	a2,a2,-216 # ffffffffc0206208 <commands+0x450>
ffffffffc02012e8:	11200593          	li	a1,274
ffffffffc02012ec:	00005517          	auipc	a0,0x5
ffffffffc02012f0:	21c50513          	add	a0,a0,540 # ffffffffc0206508 <commands+0x750>
ffffffffc02012f4:	97eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02012f8:	00005697          	auipc	a3,0x5
ffffffffc02012fc:	4d068693          	add	a3,a3,1232 # ffffffffc02067c8 <commands+0xa10>
ffffffffc0201300:	00005617          	auipc	a2,0x5
ffffffffc0201304:	f0860613          	add	a2,a2,-248 # ffffffffc0206208 <commands+0x450>
ffffffffc0201308:	11000593          	li	a1,272
ffffffffc020130c:	00005517          	auipc	a0,0x5
ffffffffc0201310:	1fc50513          	add	a0,a0,508 # ffffffffc0206508 <commands+0x750>
ffffffffc0201314:	95eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201318:	00005697          	auipc	a3,0x5
ffffffffc020131c:	48868693          	add	a3,a3,1160 # ffffffffc02067a0 <commands+0x9e8>
ffffffffc0201320:	00005617          	auipc	a2,0x5
ffffffffc0201324:	ee860613          	add	a2,a2,-280 # ffffffffc0206208 <commands+0x450>
ffffffffc0201328:	10e00593          	li	a1,270
ffffffffc020132c:	00005517          	auipc	a0,0x5
ffffffffc0201330:	1dc50513          	add	a0,a0,476 # ffffffffc0206508 <commands+0x750>
ffffffffc0201334:	93eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201338:	00005697          	auipc	a3,0x5
ffffffffc020133c:	44068693          	add	a3,a3,1088 # ffffffffc0206778 <commands+0x9c0>
ffffffffc0201340:	00005617          	auipc	a2,0x5
ffffffffc0201344:	ec860613          	add	a2,a2,-312 # ffffffffc0206208 <commands+0x450>
ffffffffc0201348:	10d00593          	li	a1,269
ffffffffc020134c:	00005517          	auipc	a0,0x5
ffffffffc0201350:	1bc50513          	add	a0,a0,444 # ffffffffc0206508 <commands+0x750>
ffffffffc0201354:	91eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201358:	00005697          	auipc	a3,0x5
ffffffffc020135c:	41068693          	add	a3,a3,1040 # ffffffffc0206768 <commands+0x9b0>
ffffffffc0201360:	00005617          	auipc	a2,0x5
ffffffffc0201364:	ea860613          	add	a2,a2,-344 # ffffffffc0206208 <commands+0x450>
ffffffffc0201368:	10800593          	li	a1,264
ffffffffc020136c:	00005517          	auipc	a0,0x5
ffffffffc0201370:	19c50513          	add	a0,a0,412 # ffffffffc0206508 <commands+0x750>
ffffffffc0201374:	8feff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201378:	00005697          	auipc	a3,0x5
ffffffffc020137c:	2f068693          	add	a3,a3,752 # ffffffffc0206668 <commands+0x8b0>
ffffffffc0201380:	00005617          	auipc	a2,0x5
ffffffffc0201384:	e8860613          	add	a2,a2,-376 # ffffffffc0206208 <commands+0x450>
ffffffffc0201388:	10700593          	li	a1,263
ffffffffc020138c:	00005517          	auipc	a0,0x5
ffffffffc0201390:	17c50513          	add	a0,a0,380 # ffffffffc0206508 <commands+0x750>
ffffffffc0201394:	8deff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201398:	00005697          	auipc	a3,0x5
ffffffffc020139c:	3b068693          	add	a3,a3,944 # ffffffffc0206748 <commands+0x990>
ffffffffc02013a0:	00005617          	auipc	a2,0x5
ffffffffc02013a4:	e6860613          	add	a2,a2,-408 # ffffffffc0206208 <commands+0x450>
ffffffffc02013a8:	10600593          	li	a1,262
ffffffffc02013ac:	00005517          	auipc	a0,0x5
ffffffffc02013b0:	15c50513          	add	a0,a0,348 # ffffffffc0206508 <commands+0x750>
ffffffffc02013b4:	8beff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02013b8:	00005697          	auipc	a3,0x5
ffffffffc02013bc:	36068693          	add	a3,a3,864 # ffffffffc0206718 <commands+0x960>
ffffffffc02013c0:	00005617          	auipc	a2,0x5
ffffffffc02013c4:	e4860613          	add	a2,a2,-440 # ffffffffc0206208 <commands+0x450>
ffffffffc02013c8:	10500593          	li	a1,261
ffffffffc02013cc:	00005517          	auipc	a0,0x5
ffffffffc02013d0:	13c50513          	add	a0,a0,316 # ffffffffc0206508 <commands+0x750>
ffffffffc02013d4:	89eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02013d8:	00005697          	auipc	a3,0x5
ffffffffc02013dc:	32868693          	add	a3,a3,808 # ffffffffc0206700 <commands+0x948>
ffffffffc02013e0:	00005617          	auipc	a2,0x5
ffffffffc02013e4:	e2860613          	add	a2,a2,-472 # ffffffffc0206208 <commands+0x450>
ffffffffc02013e8:	10400593          	li	a1,260
ffffffffc02013ec:	00005517          	auipc	a0,0x5
ffffffffc02013f0:	11c50513          	add	a0,a0,284 # ffffffffc0206508 <commands+0x750>
ffffffffc02013f4:	87eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02013f8:	00005697          	auipc	a3,0x5
ffffffffc02013fc:	27068693          	add	a3,a3,624 # ffffffffc0206668 <commands+0x8b0>
ffffffffc0201400:	00005617          	auipc	a2,0x5
ffffffffc0201404:	e0860613          	add	a2,a2,-504 # ffffffffc0206208 <commands+0x450>
ffffffffc0201408:	0fe00593          	li	a1,254
ffffffffc020140c:	00005517          	auipc	a0,0x5
ffffffffc0201410:	0fc50513          	add	a0,a0,252 # ffffffffc0206508 <commands+0x750>
ffffffffc0201414:	85eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201418:	00005697          	auipc	a3,0x5
ffffffffc020141c:	2d068693          	add	a3,a3,720 # ffffffffc02066e8 <commands+0x930>
ffffffffc0201420:	00005617          	auipc	a2,0x5
ffffffffc0201424:	de860613          	add	a2,a2,-536 # ffffffffc0206208 <commands+0x450>
ffffffffc0201428:	0f900593          	li	a1,249
ffffffffc020142c:	00005517          	auipc	a0,0x5
ffffffffc0201430:	0dc50513          	add	a0,a0,220 # ffffffffc0206508 <commands+0x750>
ffffffffc0201434:	83eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201438:	00005697          	auipc	a3,0x5
ffffffffc020143c:	3d068693          	add	a3,a3,976 # ffffffffc0206808 <commands+0xa50>
ffffffffc0201440:	00005617          	auipc	a2,0x5
ffffffffc0201444:	dc860613          	add	a2,a2,-568 # ffffffffc0206208 <commands+0x450>
ffffffffc0201448:	11700593          	li	a1,279
ffffffffc020144c:	00005517          	auipc	a0,0x5
ffffffffc0201450:	0bc50513          	add	a0,a0,188 # ffffffffc0206508 <commands+0x750>
ffffffffc0201454:	81eff0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201458:	00005697          	auipc	a3,0x5
ffffffffc020145c:	3e068693          	add	a3,a3,992 # ffffffffc0206838 <commands+0xa80>
ffffffffc0201460:	00005617          	auipc	a2,0x5
ffffffffc0201464:	da860613          	add	a2,a2,-600 # ffffffffc0206208 <commands+0x450>
ffffffffc0201468:	12600593          	li	a1,294
ffffffffc020146c:	00005517          	auipc	a0,0x5
ffffffffc0201470:	09c50513          	add	a0,a0,156 # ffffffffc0206508 <commands+0x750>
ffffffffc0201474:	ffffe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201478:	00005697          	auipc	a3,0x5
ffffffffc020147c:	0a868693          	add	a3,a3,168 # ffffffffc0206520 <commands+0x768>
ffffffffc0201480:	00005617          	auipc	a2,0x5
ffffffffc0201484:	d8860613          	add	a2,a2,-632 # ffffffffc0206208 <commands+0x450>
ffffffffc0201488:	0f300593          	li	a1,243
ffffffffc020148c:	00005517          	auipc	a0,0x5
ffffffffc0201490:	07c50513          	add	a0,a0,124 # ffffffffc0206508 <commands+0x750>
ffffffffc0201494:	fdffe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201498:	00005697          	auipc	a3,0x5
ffffffffc020149c:	0c868693          	add	a3,a3,200 # ffffffffc0206560 <commands+0x7a8>
ffffffffc02014a0:	00005617          	auipc	a2,0x5
ffffffffc02014a4:	d6860613          	add	a2,a2,-664 # ffffffffc0206208 <commands+0x450>
ffffffffc02014a8:	0ba00593          	li	a1,186
ffffffffc02014ac:	00005517          	auipc	a0,0x5
ffffffffc02014b0:	05c50513          	add	a0,a0,92 # ffffffffc0206508 <commands+0x750>
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
ffffffffc02014fe:	f9e68693          	add	a3,a3,-98 # ffffffffc0213498 <free_area>
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
ffffffffc02015e8:	26c68693          	add	a3,a3,620 # ffffffffc0206850 <commands+0xa98>
ffffffffc02015ec:	00005617          	auipc	a2,0x5
ffffffffc02015f0:	c1c60613          	add	a2,a2,-996 # ffffffffc0206208 <commands+0x450>
ffffffffc02015f4:	08300593          	li	a1,131
ffffffffc02015f8:	00005517          	auipc	a0,0x5
ffffffffc02015fc:	f1050513          	add	a0,a0,-240 # ffffffffc0206508 <commands+0x750>
ffffffffc0201600:	e73fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201604:	00005697          	auipc	a3,0x5
ffffffffc0201608:	24468693          	add	a3,a3,580 # ffffffffc0206848 <commands+0xa90>
ffffffffc020160c:	00005617          	auipc	a2,0x5
ffffffffc0201610:	bfc60613          	add	a2,a2,-1028 # ffffffffc0206208 <commands+0x450>
ffffffffc0201614:	08000593          	li	a1,128
ffffffffc0201618:	00005517          	auipc	a0,0x5
ffffffffc020161c:	ef050513          	add	a0,a0,-272 # ffffffffc0206508 <commands+0x750>
ffffffffc0201620:	e53fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201624 <default_alloc_pages>:
ffffffffc0201624:	c949                	beqz	a0,ffffffffc02016b6 <default_alloc_pages+0x92>
ffffffffc0201626:	00012617          	auipc	a2,0x12
ffffffffc020162a:	e7260613          	add	a2,a2,-398 # ffffffffc0213498 <free_area>
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
ffffffffc02016bc:	19068693          	add	a3,a3,400 # ffffffffc0206848 <commands+0xa90>
ffffffffc02016c0:	00005617          	auipc	a2,0x5
ffffffffc02016c4:	b4860613          	add	a2,a2,-1208 # ffffffffc0206208 <commands+0x450>
ffffffffc02016c8:	06200593          	li	a1,98
ffffffffc02016cc:	00005517          	auipc	a0,0x5
ffffffffc02016d0:	e3c50513          	add	a0,a0,-452 # ffffffffc0206508 <commands+0x750>
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
ffffffffc0201718:	d8468693          	add	a3,a3,-636 # ffffffffc0213498 <free_area>
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
ffffffffc020178e:	0ee68693          	add	a3,a3,238 # ffffffffc0206878 <commands+0xac0>
ffffffffc0201792:	00005617          	auipc	a2,0x5
ffffffffc0201796:	a7660613          	add	a2,a2,-1418 # ffffffffc0206208 <commands+0x450>
ffffffffc020179a:	04900593          	li	a1,73
ffffffffc020179e:	00005517          	auipc	a0,0x5
ffffffffc02017a2:	d6a50513          	add	a0,a0,-662 # ffffffffc0206508 <commands+0x750>
ffffffffc02017a6:	ccdfe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02017aa:	00005697          	auipc	a3,0x5
ffffffffc02017ae:	09e68693          	add	a3,a3,158 # ffffffffc0206848 <commands+0xa90>
ffffffffc02017b2:	00005617          	auipc	a2,0x5
ffffffffc02017b6:	a5660613          	add	a2,a2,-1450 # ffffffffc0206208 <commands+0x450>
ffffffffc02017ba:	04600593          	li	a1,70
ffffffffc02017be:	00005517          	auipc	a0,0x5
ffffffffc02017c2:	d4a50513          	add	a0,a0,-694 # ffffffffc0206508 <commands+0x750>
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
ffffffffc0201894:	cf07b783          	ld	a5,-784(a5) # ffffffffc0217580 <pages>
ffffffffc0201898:	8d1d                	sub	a0,a0,a5
ffffffffc020189a:	8519                	sra	a0,a0,0x6
ffffffffc020189c:	00007797          	auipc	a5,0x7
ffffffffc02018a0:	b1c7b783          	ld	a5,-1252(a5) # ffffffffc02083b8 <nbase>
ffffffffc02018a4:	953e                	add	a0,a0,a5
ffffffffc02018a6:	00c51793          	sll	a5,a0,0xc
ffffffffc02018aa:	83b1                	srl	a5,a5,0xc
ffffffffc02018ac:	00016717          	auipc	a4,0x16
ffffffffc02018b0:	ccc73703          	ld	a4,-820(a4) # ffffffffc0217578 <npage>
ffffffffc02018b4:	0532                	sll	a0,a0,0xc
ffffffffc02018b6:	00e7fa63          	bgeu	a5,a4,ffffffffc02018ca <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc02018ba:	00016797          	auipc	a5,0x16
ffffffffc02018be:	cb67b783          	ld	a5,-842(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc02018c2:	953e                	add	a0,a0,a5
ffffffffc02018c4:	60a2                	ld	ra,8(sp)
ffffffffc02018c6:	0141                	add	sp,sp,16
ffffffffc02018c8:	8082                	ret
ffffffffc02018ca:	86aa                	mv	a3,a0
ffffffffc02018cc:	00005617          	auipc	a2,0x5
ffffffffc02018d0:	00c60613          	add	a2,a2,12 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc02018d4:	06900593          	li	a1,105
ffffffffc02018d8:	00005517          	auipc	a0,0x5
ffffffffc02018dc:	02850513          	add	a0,a0,40 # ffffffffc0206900 <default_pmm_manager+0x60>
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
ffffffffc02019be:	f5668693          	add	a3,a3,-170 # ffffffffc0206910 <default_pmm_manager+0x70>
ffffffffc02019c2:	00005617          	auipc	a2,0x5
ffffffffc02019c6:	84660613          	add	a2,a2,-1978 # ffffffffc0206208 <commands+0x450>
ffffffffc02019ca:	06400593          	li	a1,100
ffffffffc02019ce:	00005517          	auipc	a0,0x5
ffffffffc02019d2:	f6250513          	add	a0,a0,-158 # ffffffffc0206930 <default_pmm_manager+0x90>
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
ffffffffc0201a28:	b2c78793          	add	a5,a5,-1236 # ffffffffc0217550 <bigblocks>
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
ffffffffc0201a56:	afe78793          	add	a5,a5,-1282 # ffffffffc0217550 <bigblocks>
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
ffffffffc0201a9c:	ab87b783          	ld	a5,-1352(a5) # ffffffffc0217550 <bigblocks>
ffffffffc0201aa0:	4601                	li	a2,0
ffffffffc0201aa2:	cbad                	beqz	a5,ffffffffc0201b14 <kfree+0x96>
ffffffffc0201aa4:	00016697          	auipc	a3,0x16
ffffffffc0201aa8:	aac68693          	add	a3,a3,-1364 # ffffffffc0217550 <bigblocks>
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
ffffffffc0201ad0:	aa47b783          	ld	a5,-1372(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc0201ad4:	8c1d                	sub	s0,s0,a5
ffffffffc0201ad6:	8031                	srl	s0,s0,0xc
ffffffffc0201ad8:	00016797          	auipc	a5,0x16
ffffffffc0201adc:	aa07b783          	ld	a5,-1376(a5) # ffffffffc0217578 <npage>
ffffffffc0201ae0:	06f47163          	bgeu	s0,a5,ffffffffc0201b42 <kfree+0xc4>
ffffffffc0201ae4:	00007797          	auipc	a5,0x7
ffffffffc0201ae8:	8d47b783          	ld	a5,-1836(a5) # ffffffffc02083b8 <nbase>
ffffffffc0201aec:	8c1d                	sub	s0,s0,a5
ffffffffc0201aee:	041a                	sll	s0,s0,0x6
ffffffffc0201af0:	00016517          	auipc	a0,0x16
ffffffffc0201af4:	a9053503          	ld	a0,-1392(a0) # ffffffffc0217580 <pages>
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
ffffffffc0201b2c:	a287b783          	ld	a5,-1496(a5) # ffffffffc0217550 <bigblocks>
ffffffffc0201b30:	4605                	li	a2,1
ffffffffc0201b32:	fbad                	bnez	a5,ffffffffc0201aa4 <kfree+0x26>
ffffffffc0201b34:	afbfe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201b38:	bff1                	j	ffffffffc0201b14 <kfree+0x96>
ffffffffc0201b3a:	af5fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0201b3e:	b751                	j	ffffffffc0201ac2 <kfree+0x44>
ffffffffc0201b40:	8082                	ret
ffffffffc0201b42:	00005617          	auipc	a2,0x5
ffffffffc0201b46:	e2e60613          	add	a2,a2,-466 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc0201b4a:	06200593          	li	a1,98
ffffffffc0201b4e:	00005517          	auipc	a0,0x5
ffffffffc0201b52:	db250513          	add	a0,a0,-590 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0201b56:	91dfe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201b5a:	86a2                	mv	a3,s0
ffffffffc0201b5c:	00005617          	auipc	a2,0x5
ffffffffc0201b60:	dec60613          	add	a2,a2,-532 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc0201b64:	06e00593          	li	a1,110
ffffffffc0201b68:	00005517          	auipc	a0,0x5
ffffffffc0201b6c:	d9850513          	add	a0,a0,-616 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0201b70:	903fe0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0201b74 <pa2page.part.0>:
ffffffffc0201b74:	1141                	add	sp,sp,-16
ffffffffc0201b76:	00005617          	auipc	a2,0x5
ffffffffc0201b7a:	dfa60613          	add	a2,a2,-518 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc0201b7e:	06200593          	li	a1,98
ffffffffc0201b82:	00005517          	auipc	a0,0x5
ffffffffc0201b86:	d7e50513          	add	a0,a0,-642 # ffffffffc0206900 <default_pmm_manager+0x60>
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
ffffffffc0201ba8:	9b490913          	add	s2,s2,-1612 # ffffffffc0217558 <pmm_manager>
ffffffffc0201bac:	4a05                	li	s4,1
ffffffffc0201bae:	00016a97          	auipc	s5,0x16
ffffffffc0201bb2:	9daa8a93          	add	s5,s5,-1574 # ffffffffc0217588 <swap_init_ok>
ffffffffc0201bb6:	0005099b          	sext.w	s3,a0
ffffffffc0201bba:	00016b17          	auipc	s6,0x16
ffffffffc0201bbe:	9eeb0b13          	add	s6,s6,-1554 # ffffffffc02175a8 <check_mm_struct>
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
ffffffffc0201c2c:	9307b783          	ld	a5,-1744(a5) # ffffffffc0217558 <pmm_manager>
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
ffffffffc0201c48:	9147b783          	ld	a5,-1772(a5) # ffffffffc0217558 <pmm_manager>
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
ffffffffc0201c6c:	8f07b783          	ld	a5,-1808(a5) # ffffffffc0217558 <pmm_manager>
ffffffffc0201c70:	779c                	ld	a5,40(a5)
ffffffffc0201c72:	8782                	jr	a5
ffffffffc0201c74:	1141                	add	sp,sp,-16
ffffffffc0201c76:	e406                	sd	ra,8(sp)
ffffffffc0201c78:	e022                	sd	s0,0(sp)
ffffffffc0201c7a:	9bbfe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0201c7e:	00016797          	auipc	a5,0x16
ffffffffc0201c82:	8da7b783          	ld	a5,-1830(a5) # ffffffffc0217558 <pmm_manager>
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
ffffffffc0201c9e:	c0678793          	add	a5,a5,-1018 # ffffffffc02068a0 <default_pmm_manager>
ffffffffc0201ca2:	638c                	ld	a1,0(a5)
ffffffffc0201ca4:	1101                	add	sp,sp,-32
ffffffffc0201ca6:	ec06                	sd	ra,24(sp)
ffffffffc0201ca8:	e822                	sd	s0,16(sp)
ffffffffc0201caa:	e426                	sd	s1,8(sp)
ffffffffc0201cac:	00005517          	auipc	a0,0x5
ffffffffc0201cb0:	d0c50513          	add	a0,a0,-756 # ffffffffc02069b8 <default_pmm_manager+0x118>
ffffffffc0201cb4:	00016497          	auipc	s1,0x16
ffffffffc0201cb8:	8a448493          	add	s1,s1,-1884 # ffffffffc0217558 <pmm_manager>
ffffffffc0201cbc:	e09c                	sd	a5,0(s1)
ffffffffc0201cbe:	cccfe0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0201cc2:	609c                	ld	a5,0(s1)
ffffffffc0201cc4:	00016417          	auipc	s0,0x16
ffffffffc0201cc8:	8ac40413          	add	s0,s0,-1876 # ffffffffc0217570 <va_pa_offset>
ffffffffc0201ccc:	679c                	ld	a5,8(a5)
ffffffffc0201cce:	9782                	jalr	a5
ffffffffc0201cd0:	57f5                	li	a5,-3
ffffffffc0201cd2:	07fa                	sll	a5,a5,0x1e
ffffffffc0201cd4:	00005517          	auipc	a0,0x5
ffffffffc0201cd8:	cfc50513          	add	a0,a0,-772 # ffffffffc02069d0 <default_pmm_manager+0x130>
ffffffffc0201cdc:	e01c                	sd	a5,0(s0)
ffffffffc0201cde:	cacfe0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0201ce2:	44300693          	li	a3,1091
ffffffffc0201ce6:	06d6                	sll	a3,a3,0x15
ffffffffc0201ce8:	40100613          	li	a2,1025
ffffffffc0201cec:	16fd                	add	a3,a3,-1
ffffffffc0201cee:	0656                	sll	a2,a2,0x15
ffffffffc0201cf0:	088005b7          	lui	a1,0x8800
ffffffffc0201cf4:	00005517          	auipc	a0,0x5
ffffffffc0201cf8:	cf450513          	add	a0,a0,-780 # ffffffffc02069e8 <default_pmm_manager+0x148>
ffffffffc0201cfc:	c8efe0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0201d00:	777d                	lui	a4,0xfffff
ffffffffc0201d02:	00017797          	auipc	a5,0x17
ffffffffc0201d06:	8fd78793          	add	a5,a5,-1795 # ffffffffc02185ff <end+0xfff>
ffffffffc0201d0a:	8ff9                	and	a5,a5,a4
ffffffffc0201d0c:	00088737          	lui	a4,0x88
ffffffffc0201d10:	00016597          	auipc	a1,0x16
ffffffffc0201d14:	86858593          	add	a1,a1,-1944 # ffffffffc0217578 <npage>
ffffffffc0201d18:	00016617          	auipc	a2,0x16
ffffffffc0201d1c:	86860613          	add	a2,a2,-1944 # ffffffffc0217580 <pages>
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
ffffffffc0201d74:	00015797          	auipc	a5,0x15
ffffffffc0201d78:	7ed7ba23          	sd	a3,2036(a5) # ffffffffc0217568 <boot_pgdir>
ffffffffc0201d7c:	c02007b7          	lui	a5,0xc0200
ffffffffc0201d80:	06f6e063          	bltu	a3,a5,ffffffffc0201de0 <pmm_init+0x146>
ffffffffc0201d84:	601c                	ld	a5,0(s0)
ffffffffc0201d86:	60e2                	ld	ra,24(sp)
ffffffffc0201d88:	6442                	ld	s0,16(sp)
ffffffffc0201d8a:	8e9d                	sub	a3,a3,a5
ffffffffc0201d8c:	00015797          	auipc	a5,0x15
ffffffffc0201d90:	7cd7ba23          	sd	a3,2004(a5) # ffffffffc0217560 <boot_cr3>
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
ffffffffc0201dcc:	b8060613          	add	a2,a2,-1152 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc0201dd0:	07f00593          	li	a1,127
ffffffffc0201dd4:	00005517          	auipc	a0,0x5
ffffffffc0201dd8:	c3c50513          	add	a0,a0,-964 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc0201ddc:	e96fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201de0:	00005617          	auipc	a2,0x5
ffffffffc0201de4:	b6860613          	add	a2,a2,-1176 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc0201de8:	0c100593          	li	a1,193
ffffffffc0201dec:	00005517          	auipc	a0,0x5
ffffffffc0201df0:	c2450513          	add	a0,a0,-988 # ffffffffc0206a10 <default_pmm_manager+0x170>
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
ffffffffc0201e26:	756a0a13          	add	s4,s4,1878 # ffffffffc0217578 <npage>
ffffffffc0201e2a:	e7b5                	bnez	a5,ffffffffc0201e96 <get_pte+0x9e>
ffffffffc0201e2c:	12060b63          	beqz	a2,ffffffffc0201f62 <get_pte+0x16a>
ffffffffc0201e30:	4505                	li	a0,1
ffffffffc0201e32:	d5fff0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0201e36:	842a                	mv	s0,a0
ffffffffc0201e38:	12050563          	beqz	a0,ffffffffc0201f62 <get_pte+0x16a>
ffffffffc0201e3c:	00015b17          	auipc	s6,0x15
ffffffffc0201e40:	744b0b13          	add	s6,s6,1860 # ffffffffc0217580 <pages>
ffffffffc0201e44:	000b3503          	ld	a0,0(s6)
ffffffffc0201e48:	00080ab7          	lui	s5,0x80
ffffffffc0201e4c:	00015a17          	auipc	s4,0x15
ffffffffc0201e50:	72ca0a13          	add	s4,s4,1836 # ffffffffc0217578 <npage>
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
ffffffffc0201e74:	7007b783          	ld	a5,1792(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc0201e78:	953e                	add	a0,a0,a5
ffffffffc0201e7a:	6605                	lui	a2,0x1
ffffffffc0201e7c:	4581                	li	a1,0
ffffffffc0201e7e:	4ad030ef          	jal	ffffffffc0205b2a <memset>
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
ffffffffc0201eac:	6c8a8a93          	add	s5,s5,1736 # ffffffffc0217570 <va_pa_offset>
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
ffffffffc0201ede:	6a6b0b13          	add	s6,s6,1702 # ffffffffc0217580 <pages>
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
ffffffffc0201f10:	41b030ef          	jal	ffffffffc0205b2a <memset>
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
ffffffffc0201f66:	00005617          	auipc	a2,0x5
ffffffffc0201f6a:	97260613          	add	a2,a2,-1678 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0201f6e:	0fe00593          	li	a1,254
ffffffffc0201f72:	00005517          	auipc	a0,0x5
ffffffffc0201f76:	a9e50513          	add	a0,a0,-1378 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc0201f7a:	cf8fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201f7e:	00005617          	auipc	a2,0x5
ffffffffc0201f82:	95a60613          	add	a2,a2,-1702 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0201f86:	10900593          	li	a1,265
ffffffffc0201f8a:	00005517          	auipc	a0,0x5
ffffffffc0201f8e:	a8650513          	add	a0,a0,-1402 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc0201f92:	ce0fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201f96:	00005617          	auipc	a2,0x5
ffffffffc0201f9a:	94260613          	add	a2,a2,-1726 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0201f9e:	10600593          	li	a1,262
ffffffffc0201fa2:	00005517          	auipc	a0,0x5
ffffffffc0201fa6:	a6e50513          	add	a0,a0,-1426 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc0201faa:	cc8fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0201fae:	86aa                	mv	a3,a0
ffffffffc0201fb0:	00005617          	auipc	a2,0x5
ffffffffc0201fb4:	92860613          	add	a2,a2,-1752 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0201fb8:	0fa00593          	li	a1,250
ffffffffc0201fbc:	00005517          	auipc	a0,0x5
ffffffffc0201fc0:	a5450513          	add	a0,a0,-1452 # ffffffffc0206a10 <default_pmm_manager+0x170>
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
ffffffffc0202040:	53c73703          	ld	a4,1340(a4) # ffffffffc0217578 <npage>
ffffffffc0202044:	0ae7f763          	bgeu	a5,a4,ffffffffc02020f2 <unmap_range+0x12a>
ffffffffc0202048:	fff80737          	lui	a4,0xfff80
ffffffffc020204c:	97ba                	add	a5,a5,a4
ffffffffc020204e:	079a                	sll	a5,a5,0x6
ffffffffc0202050:	00015517          	auipc	a0,0x15
ffffffffc0202054:	53053503          	ld	a0,1328(a0) # ffffffffc0217580 <pages>
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
ffffffffc020208a:	4d27b783          	ld	a5,1234(a5) # ffffffffc0217558 <pmm_manager>
ffffffffc020208e:	739c                	ld	a5,32(a5)
ffffffffc0202090:	4585                	li	a1,1
ffffffffc0202092:	9782                	jalr	a5
ffffffffc0202094:	bfc1                	j	ffffffffc0202064 <unmap_range+0x9c>
ffffffffc0202096:	e42a                	sd	a0,8(sp)
ffffffffc0202098:	d9cfe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc020209c:	00015797          	auipc	a5,0x15
ffffffffc02020a0:	4bc7b783          	ld	a5,1212(a5) # ffffffffc0217558 <pmm_manager>
ffffffffc02020a4:	739c                	ld	a5,32(a5)
ffffffffc02020a6:	6522                	ld	a0,8(sp)
ffffffffc02020a8:	4585                	li	a1,1
ffffffffc02020aa:	9782                	jalr	a5
ffffffffc02020ac:	d82fe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02020b0:	bf55                	j	ffffffffc0202064 <unmap_range+0x9c>
ffffffffc02020b2:	00005697          	auipc	a3,0x5
ffffffffc02020b6:	96e68693          	add	a3,a3,-1682 # ffffffffc0206a20 <default_pmm_manager+0x180>
ffffffffc02020ba:	00004617          	auipc	a2,0x4
ffffffffc02020be:	14e60613          	add	a2,a2,334 # ffffffffc0206208 <commands+0x450>
ffffffffc02020c2:	14000593          	li	a1,320
ffffffffc02020c6:	00005517          	auipc	a0,0x5
ffffffffc02020ca:	94a50513          	add	a0,a0,-1718 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc02020ce:	ba4fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02020d2:	00005697          	auipc	a3,0x5
ffffffffc02020d6:	97e68693          	add	a3,a3,-1666 # ffffffffc0206a50 <default_pmm_manager+0x1b0>
ffffffffc02020da:	00004617          	auipc	a2,0x4
ffffffffc02020de:	12e60613          	add	a2,a2,302 # ffffffffc0206208 <commands+0x450>
ffffffffc02020e2:	14100593          	li	a1,321
ffffffffc02020e6:	00005517          	auipc	a0,0x5
ffffffffc02020ea:	92a50513          	add	a0,a0,-1750 # ffffffffc0206a10 <default_pmm_manager+0x170>
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
ffffffffc0202138:	444b8b93          	add	s7,s7,1092 # ffffffffc0217578 <npage>
ffffffffc020213c:	00015c17          	auipc	s8,0x15
ffffffffc0202140:	444c0c13          	add	s8,s8,1092 # ffffffffc0217580 <pages>
ffffffffc0202144:	fff809b7          	lui	s3,0xfff80
ffffffffc0202148:	00015917          	auipc	s2,0x15
ffffffffc020214c:	41090913          	add	s2,s2,1040 # ffffffffc0217558 <pmm_manager>
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
ffffffffc02021d6:	00005697          	auipc	a3,0x5
ffffffffc02021da:	84a68693          	add	a3,a3,-1974 # ffffffffc0206a20 <default_pmm_manager+0x180>
ffffffffc02021de:	00004617          	auipc	a2,0x4
ffffffffc02021e2:	02a60613          	add	a2,a2,42 # ffffffffc0206208 <commands+0x450>
ffffffffc02021e6:	15100593          	li	a1,337
ffffffffc02021ea:	00005517          	auipc	a0,0x5
ffffffffc02021ee:	82650513          	add	a0,a0,-2010 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc02021f2:	a80fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02021f6:	00004617          	auipc	a2,0x4
ffffffffc02021fa:	77a60613          	add	a2,a2,1914 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc02021fe:	06200593          	li	a1,98
ffffffffc0202202:	00004517          	auipc	a0,0x4
ffffffffc0202206:	6fe50513          	add	a0,a0,1790 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc020220a:	a68fe0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020220e:	00005697          	auipc	a3,0x5
ffffffffc0202212:	84268693          	add	a3,a3,-1982 # ffffffffc0206a50 <default_pmm_manager+0x1b0>
ffffffffc0202216:	00004617          	auipc	a2,0x4
ffffffffc020221a:	ff260613          	add	a2,a2,-14 # ffffffffc0206208 <commands+0x450>
ffffffffc020221e:	15200593          	li	a1,338
ffffffffc0202222:	00004517          	auipc	a0,0x4
ffffffffc0202226:	7ee50513          	add	a0,a0,2030 # ffffffffc0206a10 <default_pmm_manager+0x170>
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
ffffffffc0202264:	32073703          	ld	a4,800(a4) # ffffffffc0217580 <pages>
ffffffffc0202268:	8c19                	sub	s0,s0,a4
ffffffffc020226a:	000807b7          	lui	a5,0x80
ffffffffc020226e:	8419                	sra	s0,s0,0x6
ffffffffc0202270:	943e                	add	s0,s0,a5
ffffffffc0202272:	042a                	sll	s0,s0,0xa
ffffffffc0202274:	8cc1                	or	s1,s1,s0
ffffffffc0202276:	0014e493          	or	s1,s1,1
ffffffffc020227a:	0099b023          	sd	s1,0(s3) # fffffffffff80000 <end+0x3fd68a00>
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
ffffffffc020229e:	2de73703          	ld	a4,734(a4) # ffffffffc0217578 <npage>
ffffffffc02022a2:	08e7f063          	bgeu	a5,a4,ffffffffc0202322 <page_insert+0xf4>
ffffffffc02022a6:	00015a97          	auipc	s5,0x15
ffffffffc02022aa:	2daa8a93          	add	s5,s5,730 # ffffffffc0217580 <pages>
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
ffffffffc02022e6:	2767b783          	ld	a5,630(a5) # ffffffffc0217558 <pmm_manager>
ffffffffc02022ea:	739c                	ld	a5,32(a5)
ffffffffc02022ec:	4585                	li	a1,1
ffffffffc02022ee:	854a                	mv	a0,s2
ffffffffc02022f0:	9782                	jalr	a5
ffffffffc02022f2:	000ab703          	ld	a4,0(s5)
ffffffffc02022f6:	120a0073          	sfence.vma	s4
ffffffffc02022fa:	b7bd                	j	ffffffffc0202268 <page_insert+0x3a>
ffffffffc02022fc:	b38fe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0202300:	00015797          	auipc	a5,0x15
ffffffffc0202304:	2587b783          	ld	a5,600(a5) # ffffffffc0217558 <pmm_manager>
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
ffffffffc0202370:	20cc8c93          	add	s9,s9,524 # ffffffffc0217578 <npage>
ffffffffc0202374:	00015c17          	auipc	s8,0x15
ffffffffc0202378:	20cc0c13          	add	s8,s8,524 # ffffffffc0217580 <pages>
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
ffffffffc0202426:	14e70713          	add	a4,a4,334 # ffffffffc0217570 <va_pa_offset>
ffffffffc020242a:	6308                	ld	a0,0(a4)
ffffffffc020242c:	8799                	sra	a5,a5,0x6
ffffffffc020242e:	97de                	add	a5,a5,s7
ffffffffc0202430:	0167f733          	and	a4,a5,s6
ffffffffc0202434:	00a685b3          	add	a1,a3,a0
ffffffffc0202438:	07b2                	sll	a5,a5,0xc
ffffffffc020243a:	04c77963          	bgeu	a4,a2,ffffffffc020248c <copy_range+0x166>
ffffffffc020243e:	6605                	lui	a2,0x1
ffffffffc0202440:	953e                	add	a0,a0,a5
ffffffffc0202442:	6fa030ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc0202446:	86a6                	mv	a3,s1
ffffffffc0202448:	8622                	mv	a2,s0
ffffffffc020244a:	85ea                	mv	a1,s10
ffffffffc020244c:	8556                	mv	a0,s5
ffffffffc020244e:	de1ff0ef          	jal	ffffffffc020222e <page_insert>
ffffffffc0202452:	d139                	beqz	a0,ffffffffc0202398 <copy_range+0x72>
ffffffffc0202454:	00004697          	auipc	a3,0x4
ffffffffc0202458:	63468693          	add	a3,a3,1588 # ffffffffc0206a88 <default_pmm_manager+0x1e8>
ffffffffc020245c:	00004617          	auipc	a2,0x4
ffffffffc0202460:	dac60613          	add	a2,a2,-596 # ffffffffc0206208 <commands+0x450>
ffffffffc0202464:	19900593          	li	a1,409
ffffffffc0202468:	00004517          	auipc	a0,0x4
ffffffffc020246c:	5a850513          	add	a0,a0,1448 # ffffffffc0206a10 <default_pmm_manager+0x170>
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
ffffffffc0202492:	44a60613          	add	a2,a2,1098 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0202496:	06900593          	li	a1,105
ffffffffc020249a:	00004517          	auipc	a0,0x4
ffffffffc020249e:	46650513          	add	a0,a0,1126 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc02024a2:	fd1fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02024a6:	00004697          	auipc	a3,0x4
ffffffffc02024aa:	5c268693          	add	a3,a3,1474 # ffffffffc0206a68 <default_pmm_manager+0x1c8>
ffffffffc02024ae:	00004617          	auipc	a2,0x4
ffffffffc02024b2:	d5a60613          	add	a2,a2,-678 # ffffffffc0206208 <commands+0x450>
ffffffffc02024b6:	17e00593          	li	a1,382
ffffffffc02024ba:	00004517          	auipc	a0,0x4
ffffffffc02024be:	55650513          	add	a0,a0,1366 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc02024c2:	fb1fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02024c6:	00004697          	auipc	a3,0x4
ffffffffc02024ca:	58a68693          	add	a3,a3,1418 # ffffffffc0206a50 <default_pmm_manager+0x1b0>
ffffffffc02024ce:	00004617          	auipc	a2,0x4
ffffffffc02024d2:	d3a60613          	add	a2,a2,-710 # ffffffffc0206208 <commands+0x450>
ffffffffc02024d6:	16a00593          	li	a1,362
ffffffffc02024da:	00004517          	auipc	a0,0x4
ffffffffc02024de:	53650513          	add	a0,a0,1334 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc02024e2:	f91fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02024e6:	00004697          	auipc	a3,0x4
ffffffffc02024ea:	59268693          	add	a3,a3,1426 # ffffffffc0206a78 <default_pmm_manager+0x1d8>
ffffffffc02024ee:	00004617          	auipc	a2,0x4
ffffffffc02024f2:	d1a60613          	add	a2,a2,-742 # ffffffffc0206208 <commands+0x450>
ffffffffc02024f6:	17f00593          	li	a1,383
ffffffffc02024fa:	00004517          	auipc	a0,0x4
ffffffffc02024fe:	51650513          	add	a0,a0,1302 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc0202502:	f71fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202506:	00004617          	auipc	a2,0x4
ffffffffc020250a:	46a60613          	add	a2,a2,1130 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc020250e:	06200593          	li	a1,98
ffffffffc0202512:	00004517          	auipc	a0,0x4
ffffffffc0202516:	3ee50513          	add	a0,a0,1006 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc020251a:	f59fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020251e:	00004617          	auipc	a2,0x4
ffffffffc0202522:	47260613          	add	a2,a2,1138 # ffffffffc0206990 <default_pmm_manager+0xf0>
ffffffffc0202526:	07400593          	li	a1,116
ffffffffc020252a:	00004517          	auipc	a0,0x4
ffffffffc020252e:	3d650513          	add	a0,a0,982 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0202532:	f41fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202536:	00004697          	auipc	a3,0x4
ffffffffc020253a:	4ea68693          	add	a3,a3,1258 # ffffffffc0206a20 <default_pmm_manager+0x180>
ffffffffc020253e:	00004617          	auipc	a2,0x4
ffffffffc0202542:	cca60613          	add	a2,a2,-822 # ffffffffc0206208 <commands+0x450>
ffffffffc0202546:	16900593          	li	a1,361
ffffffffc020254a:	00004517          	auipc	a0,0x4
ffffffffc020254e:	4c650513          	add	a0,a0,1222 # ffffffffc0206a10 <default_pmm_manager+0x170>
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
ffffffffc020258a:	0027a783          	lw	a5,2(a5) # ffffffffc0217588 <swap_init_ok>
ffffffffc020258e:	c385                	beqz	a5,ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc0202590:	00015517          	auipc	a0,0x15
ffffffffc0202594:	01853503          	ld	a0,24(a0) # ffffffffc02175a8 <check_mm_struct>
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
ffffffffc02025ca:	f927b783          	ld	a5,-110(a5) # ffffffffc0217558 <pmm_manager>
ffffffffc02025ce:	739c                	ld	a5,32(a5)
ffffffffc02025d0:	4585                	li	a1,1
ffffffffc02025d2:	8522                	mv	a0,s0
ffffffffc02025d4:	9782                	jalr	a5
ffffffffc02025d6:	4401                	li	s0,0
ffffffffc02025d8:	bfd9                	j	ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc02025da:	85afe0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02025de:	00015797          	auipc	a5,0x15
ffffffffc02025e2:	f7a7b783          	ld	a5,-134(a5) # ffffffffc0217558 <pmm_manager>
ffffffffc02025e6:	739c                	ld	a5,32(a5)
ffffffffc02025e8:	8522                	mv	a0,s0
ffffffffc02025ea:	4585                	li	a1,1
ffffffffc02025ec:	9782                	jalr	a5
ffffffffc02025ee:	4401                	li	s0,0
ffffffffc02025f0:	83efe0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02025f4:	bf6d                	j	ffffffffc02025ae <pgdir_alloc_page+0x52>
ffffffffc02025f6:	00004697          	auipc	a3,0x4
ffffffffc02025fa:	4a268693          	add	a3,a3,1186 # ffffffffc0206a98 <default_pmm_manager+0x1f8>
ffffffffc02025fe:	00004617          	auipc	a2,0x4
ffffffffc0202602:	c0a60613          	add	a2,a2,-1014 # ffffffffc0206208 <commands+0x450>
ffffffffc0202606:	1d800593          	li	a1,472
ffffffffc020260a:	00004517          	auipc	a0,0x4
ffffffffc020260e:	40650513          	add	a0,a0,1030 # ffffffffc0206a10 <default_pmm_manager+0x170>
ffffffffc0202612:	e61fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202616 <swap_init>:
ffffffffc0202616:	1101                	add	sp,sp,-32
ffffffffc0202618:	ec06                	sd	ra,24(sp)
ffffffffc020261a:	e822                	sd	s0,16(sp)
ffffffffc020261c:	e426                	sd	s1,8(sp)
ffffffffc020261e:	1a2010ef          	jal	ffffffffc02037c0 <swapfs_init>
ffffffffc0202622:	00015697          	auipc	a3,0x15
ffffffffc0202626:	f6e6b683          	ld	a3,-146(a3) # ffffffffc0217590 <max_swap_offset>
ffffffffc020262a:	010007b7          	lui	a5,0x1000
ffffffffc020262e:	ff968713          	add	a4,a3,-7
ffffffffc0202632:	17e1                	add	a5,a5,-8 # fffff8 <kern_entry-0xffffffffbf200008>
ffffffffc0202634:	04e7e863          	bltu	a5,a4,ffffffffc0202684 <swap_init+0x6e>
ffffffffc0202638:	0000a797          	auipc	a5,0xa
ffffffffc020263c:	9d878793          	add	a5,a5,-1576 # ffffffffc020c010 <swap_manager_fifo>
ffffffffc0202640:	6798                	ld	a4,8(a5)
ffffffffc0202642:	00015497          	auipc	s1,0x15
ffffffffc0202646:	f5648493          	add	s1,s1,-170 # ffffffffc0217598 <sm>
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
ffffffffc0202664:	48050513          	add	a0,a0,1152 # ffffffffc0206ae0 <default_pmm_manager+0x240>
ffffffffc0202668:	638c                	ld	a1,0(a5)
ffffffffc020266a:	4785                	li	a5,1
ffffffffc020266c:	00015717          	auipc	a4,0x15
ffffffffc0202670:	f0f72e23          	sw	a5,-228(a4) # ffffffffc0217588 <swap_init_ok>
ffffffffc0202674:	b17fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202678:	60e2                	ld	ra,24(sp)
ffffffffc020267a:	8522                	mv	a0,s0
ffffffffc020267c:	6442                	ld	s0,16(sp)
ffffffffc020267e:	64a2                	ld	s1,8(sp)
ffffffffc0202680:	6105                	add	sp,sp,32
ffffffffc0202682:	8082                	ret
ffffffffc0202684:	00004617          	auipc	a2,0x4
ffffffffc0202688:	42c60613          	add	a2,a2,1068 # ffffffffc0206ab0 <default_pmm_manager+0x210>
ffffffffc020268c:	02800593          	li	a1,40
ffffffffc0202690:	00004517          	auipc	a0,0x4
ffffffffc0202694:	44050513          	add	a0,a0,1088 # ffffffffc0206ad0 <default_pmm_manager+0x230>
ffffffffc0202698:	ddbfd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020269c <swap_init_mm>:
ffffffffc020269c:	00015797          	auipc	a5,0x15
ffffffffc02026a0:	efc7b783          	ld	a5,-260(a5) # ffffffffc0217598 <sm>
ffffffffc02026a4:	6b9c                	ld	a5,16(a5)
ffffffffc02026a6:	8782                	jr	a5

ffffffffc02026a8 <swap_map_swappable>:
ffffffffc02026a8:	00015797          	auipc	a5,0x15
ffffffffc02026ac:	ef07b783          	ld	a5,-272(a5) # ffffffffc0217598 <sm>
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
ffffffffc02026d8:	ec498993          	add	s3,s3,-316 # ffffffffc0217598 <sm>
ffffffffc02026dc:	00004b17          	auipc	s6,0x4
ffffffffc02026e0:	47cb0b13          	add	s6,s6,1148 # ffffffffc0206b58 <default_pmm_manager+0x2b8>
ffffffffc02026e4:	00004b97          	auipc	s7,0x4
ffffffffc02026e8:	45cb8b93          	add	s7,s7,1116 # ffffffffc0206b40 <default_pmm_manager+0x2a0>
ffffffffc02026ec:	a825                	j	ffffffffc0202724 <swap_out+0x70>
ffffffffc02026ee:	67a2                	ld	a5,8(sp)
ffffffffc02026f0:	8626                	mv	a2,s1
ffffffffc02026f2:	85a2                	mv	a1,s0
ffffffffc02026f4:	7f94                	ld	a3,56(a5)
ffffffffc02026f6:	855a                	mv	a0,s6
ffffffffc02026f8:	2405                	addw	s0,s0,1 # ffffffffffe00001 <end+0x3fbe8a01>
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
ffffffffc0202758:	12e010ef          	jal	ffffffffc0203886 <swapfs_write>
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
ffffffffc020279a:	36250513          	add	a0,a0,866 # ffffffffc0206af8 <default_pmm_manager+0x258>
ffffffffc020279e:	9edfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02027a2:	bfe1                	j	ffffffffc020277a <swap_out+0xc6>
ffffffffc02027a4:	4401                	li	s0,0
ffffffffc02027a6:	bfd1                	j	ffffffffc020277a <swap_out+0xc6>
ffffffffc02027a8:	00004697          	auipc	a3,0x4
ffffffffc02027ac:	38068693          	add	a3,a3,896 # ffffffffc0206b28 <default_pmm_manager+0x288>
ffffffffc02027b0:	00004617          	auipc	a2,0x4
ffffffffc02027b4:	a5860613          	add	a2,a2,-1448 # ffffffffc0206208 <commands+0x450>
ffffffffc02027b8:	06800593          	li	a1,104
ffffffffc02027bc:	00004517          	auipc	a0,0x4
ffffffffc02027c0:	31450513          	add	a0,a0,788 # ffffffffc0206ad0 <default_pmm_manager+0x230>
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
ffffffffc02027f6:	002010ef          	jal	ffffffffc02037f8 <swapfs_read>
ffffffffc02027fa:	00093583          	ld	a1,0(s2)
ffffffffc02027fe:	8626                	mv	a2,s1
ffffffffc0202800:	00004517          	auipc	a0,0x4
ffffffffc0202804:	3a850513          	add	a0,a0,936 # ffffffffc0206ba8 <default_pmm_manager+0x308>
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
ffffffffc0202826:	37668693          	add	a3,a3,886 # ffffffffc0206b98 <default_pmm_manager+0x2f8>
ffffffffc020282a:	00004617          	auipc	a2,0x4
ffffffffc020282e:	9de60613          	add	a2,a2,-1570 # ffffffffc0206208 <commands+0x450>
ffffffffc0202832:	07e00593          	li	a1,126
ffffffffc0202836:	00004517          	auipc	a0,0x4
ffffffffc020283a:	29a50513          	add	a0,a0,666 # ffffffffc0206ad0 <default_pmm_manager+0x230>
ffffffffc020283e:	c35fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202842 <_fifo_init_mm>:
ffffffffc0202842:	00011797          	auipc	a5,0x11
ffffffffc0202846:	c6e78793          	add	a5,a5,-914 # ffffffffc02134b0 <pra_list_head>
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
ffffffffc020286a:	38250513          	add	a0,a0,898 # ffffffffc0206be8 <default_pmm_manager+0x348>
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
ffffffffc0202890:	d144a483          	lw	s1,-748(s1) # ffffffffc02175a0 <pgfault_num>
ffffffffc0202894:	4791                	li	a5,4
ffffffffc0202896:	14f49963          	bne	s1,a5,ffffffffc02029e8 <_fifo_check_swap+0x188>
ffffffffc020289a:	00004517          	auipc	a0,0x4
ffffffffc020289e:	39e50513          	add	a0,a0,926 # ffffffffc0206c38 <default_pmm_manager+0x398>
ffffffffc02028a2:	6a85                	lui	s5,0x1
ffffffffc02028a4:	4b29                	li	s6,10
ffffffffc02028a6:	8e5fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02028aa:	00015417          	auipc	s0,0x15
ffffffffc02028ae:	cf640413          	add	s0,s0,-778 # ffffffffc02175a0 <pgfault_num>
ffffffffc02028b2:	016a8023          	sb	s6,0(s5) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02028b6:	401c                	lw	a5,0(s0)
ffffffffc02028b8:	0007891b          	sext.w	s2,a5
ffffffffc02028bc:	2a979663          	bne	a5,s1,ffffffffc0202b68 <_fifo_check_swap+0x308>
ffffffffc02028c0:	00004517          	auipc	a0,0x4
ffffffffc02028c4:	3a050513          	add	a0,a0,928 # ffffffffc0206c60 <default_pmm_manager+0x3c0>
ffffffffc02028c8:	6b91                	lui	s7,0x4
ffffffffc02028ca:	4c35                	li	s8,13
ffffffffc02028cc:	8bffd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02028d0:	018b8023          	sb	s8,0(s7) # 4000 <kern_entry-0xffffffffc01fc000>
ffffffffc02028d4:	401c                	lw	a5,0(s0)
ffffffffc02028d6:	00078c9b          	sext.w	s9,a5
ffffffffc02028da:	27279763          	bne	a5,s2,ffffffffc0202b48 <_fifo_check_swap+0x2e8>
ffffffffc02028de:	00004517          	auipc	a0,0x4
ffffffffc02028e2:	3aa50513          	add	a0,a0,938 # ffffffffc0206c88 <default_pmm_manager+0x3e8>
ffffffffc02028e6:	6489                	lui	s1,0x2
ffffffffc02028e8:	492d                	li	s2,11
ffffffffc02028ea:	8a1fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02028ee:	01248023          	sb	s2,0(s1) # 2000 <kern_entry-0xffffffffc01fe000>
ffffffffc02028f2:	401c                	lw	a5,0(s0)
ffffffffc02028f4:	23979a63          	bne	a5,s9,ffffffffc0202b28 <_fifo_check_swap+0x2c8>
ffffffffc02028f8:	00004517          	auipc	a0,0x4
ffffffffc02028fc:	3b850513          	add	a0,a0,952 # ffffffffc0206cb0 <default_pmm_manager+0x410>
ffffffffc0202900:	88bfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202904:	6795                	lui	a5,0x5
ffffffffc0202906:	4739                	li	a4,14
ffffffffc0202908:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc020290c:	401c                	lw	a5,0(s0)
ffffffffc020290e:	4715                	li	a4,5
ffffffffc0202910:	00078c9b          	sext.w	s9,a5
ffffffffc0202914:	1ee79a63          	bne	a5,a4,ffffffffc0202b08 <_fifo_check_swap+0x2a8>
ffffffffc0202918:	00004517          	auipc	a0,0x4
ffffffffc020291c:	37050513          	add	a0,a0,880 # ffffffffc0206c88 <default_pmm_manager+0x3e8>
ffffffffc0202920:	86bfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202924:	01248023          	sb	s2,0(s1)
ffffffffc0202928:	401c                	lw	a5,0(s0)
ffffffffc020292a:	1b979f63          	bne	a5,s9,ffffffffc0202ae8 <_fifo_check_swap+0x288>
ffffffffc020292e:	00004517          	auipc	a0,0x4
ffffffffc0202932:	30a50513          	add	a0,a0,778 # ffffffffc0206c38 <default_pmm_manager+0x398>
ffffffffc0202936:	855fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020293a:	016a8023          	sb	s6,0(s5)
ffffffffc020293e:	4018                	lw	a4,0(s0)
ffffffffc0202940:	4799                	li	a5,6
ffffffffc0202942:	18f71363          	bne	a4,a5,ffffffffc0202ac8 <_fifo_check_swap+0x268>
ffffffffc0202946:	00004517          	auipc	a0,0x4
ffffffffc020294a:	34250513          	add	a0,a0,834 # ffffffffc0206c88 <default_pmm_manager+0x3e8>
ffffffffc020294e:	83dfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202952:	01248023          	sb	s2,0(s1)
ffffffffc0202956:	4018                	lw	a4,0(s0)
ffffffffc0202958:	479d                	li	a5,7
ffffffffc020295a:	14f71763          	bne	a4,a5,ffffffffc0202aa8 <_fifo_check_swap+0x248>
ffffffffc020295e:	00004517          	auipc	a0,0x4
ffffffffc0202962:	28a50513          	add	a0,a0,650 # ffffffffc0206be8 <default_pmm_manager+0x348>
ffffffffc0202966:	825fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020296a:	01498023          	sb	s4,0(s3)
ffffffffc020296e:	4018                	lw	a4,0(s0)
ffffffffc0202970:	47a1                	li	a5,8
ffffffffc0202972:	10f71b63          	bne	a4,a5,ffffffffc0202a88 <_fifo_check_swap+0x228>
ffffffffc0202976:	00004517          	auipc	a0,0x4
ffffffffc020297a:	2ea50513          	add	a0,a0,746 # ffffffffc0206c60 <default_pmm_manager+0x3c0>
ffffffffc020297e:	80dfd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0202982:	018b8023          	sb	s8,0(s7)
ffffffffc0202986:	4018                	lw	a4,0(s0)
ffffffffc0202988:	47a5                	li	a5,9
ffffffffc020298a:	0cf71f63          	bne	a4,a5,ffffffffc0202a68 <_fifo_check_swap+0x208>
ffffffffc020298e:	00004517          	auipc	a0,0x4
ffffffffc0202992:	32250513          	add	a0,a0,802 # ffffffffc0206cb0 <default_pmm_manager+0x410>
ffffffffc0202996:	ff4fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020299a:	6795                	lui	a5,0x5
ffffffffc020299c:	4739                	li	a4,14
ffffffffc020299e:	00e78023          	sb	a4,0(a5) # 5000 <kern_entry-0xffffffffc01fb000>
ffffffffc02029a2:	401c                	lw	a5,0(s0)
ffffffffc02029a4:	4729                	li	a4,10
ffffffffc02029a6:	0007849b          	sext.w	s1,a5
ffffffffc02029aa:	08e79f63          	bne	a5,a4,ffffffffc0202a48 <_fifo_check_swap+0x1e8>
ffffffffc02029ae:	00004517          	auipc	a0,0x4
ffffffffc02029b2:	28a50513          	add	a0,a0,650 # ffffffffc0206c38 <default_pmm_manager+0x398>
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
ffffffffc02029ec:	22868693          	add	a3,a3,552 # ffffffffc0206c10 <default_pmm_manager+0x370>
ffffffffc02029f0:	00004617          	auipc	a2,0x4
ffffffffc02029f4:	81860613          	add	a2,a2,-2024 # ffffffffc0206208 <commands+0x450>
ffffffffc02029f8:	05100593          	li	a1,81
ffffffffc02029fc:	00004517          	auipc	a0,0x4
ffffffffc0202a00:	22450513          	add	a0,a0,548 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202a04:	a6ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a08:	00004697          	auipc	a3,0x4
ffffffffc0202a0c:	35868693          	add	a3,a3,856 # ffffffffc0206d60 <default_pmm_manager+0x4c0>
ffffffffc0202a10:	00003617          	auipc	a2,0x3
ffffffffc0202a14:	7f860613          	add	a2,a2,2040 # ffffffffc0206208 <commands+0x450>
ffffffffc0202a18:	07300593          	li	a1,115
ffffffffc0202a1c:	00004517          	auipc	a0,0x4
ffffffffc0202a20:	20450513          	add	a0,a0,516 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202a24:	a4ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a28:	00004697          	auipc	a3,0x4
ffffffffc0202a2c:	31068693          	add	a3,a3,784 # ffffffffc0206d38 <default_pmm_manager+0x498>
ffffffffc0202a30:	00003617          	auipc	a2,0x3
ffffffffc0202a34:	7d860613          	add	a2,a2,2008 # ffffffffc0206208 <commands+0x450>
ffffffffc0202a38:	07100593          	li	a1,113
ffffffffc0202a3c:	00004517          	auipc	a0,0x4
ffffffffc0202a40:	1e450513          	add	a0,a0,484 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202a44:	a2ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a48:	00004697          	auipc	a3,0x4
ffffffffc0202a4c:	2e068693          	add	a3,a3,736 # ffffffffc0206d28 <default_pmm_manager+0x488>
ffffffffc0202a50:	00003617          	auipc	a2,0x3
ffffffffc0202a54:	7b860613          	add	a2,a2,1976 # ffffffffc0206208 <commands+0x450>
ffffffffc0202a58:	06f00593          	li	a1,111
ffffffffc0202a5c:	00004517          	auipc	a0,0x4
ffffffffc0202a60:	1c450513          	add	a0,a0,452 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202a64:	a0ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a68:	00004697          	auipc	a3,0x4
ffffffffc0202a6c:	2b068693          	add	a3,a3,688 # ffffffffc0206d18 <default_pmm_manager+0x478>
ffffffffc0202a70:	00003617          	auipc	a2,0x3
ffffffffc0202a74:	79860613          	add	a2,a2,1944 # ffffffffc0206208 <commands+0x450>
ffffffffc0202a78:	06c00593          	li	a1,108
ffffffffc0202a7c:	00004517          	auipc	a0,0x4
ffffffffc0202a80:	1a450513          	add	a0,a0,420 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202a84:	9effd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202a88:	00004697          	auipc	a3,0x4
ffffffffc0202a8c:	28068693          	add	a3,a3,640 # ffffffffc0206d08 <default_pmm_manager+0x468>
ffffffffc0202a90:	00003617          	auipc	a2,0x3
ffffffffc0202a94:	77860613          	add	a2,a2,1912 # ffffffffc0206208 <commands+0x450>
ffffffffc0202a98:	06900593          	li	a1,105
ffffffffc0202a9c:	00004517          	auipc	a0,0x4
ffffffffc0202aa0:	18450513          	add	a0,a0,388 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202aa4:	9cffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202aa8:	00004697          	auipc	a3,0x4
ffffffffc0202aac:	25068693          	add	a3,a3,592 # ffffffffc0206cf8 <default_pmm_manager+0x458>
ffffffffc0202ab0:	00003617          	auipc	a2,0x3
ffffffffc0202ab4:	75860613          	add	a2,a2,1880 # ffffffffc0206208 <commands+0x450>
ffffffffc0202ab8:	06600593          	li	a1,102
ffffffffc0202abc:	00004517          	auipc	a0,0x4
ffffffffc0202ac0:	16450513          	add	a0,a0,356 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202ac4:	9affd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202ac8:	00004697          	auipc	a3,0x4
ffffffffc0202acc:	22068693          	add	a3,a3,544 # ffffffffc0206ce8 <default_pmm_manager+0x448>
ffffffffc0202ad0:	00003617          	auipc	a2,0x3
ffffffffc0202ad4:	73860613          	add	a2,a2,1848 # ffffffffc0206208 <commands+0x450>
ffffffffc0202ad8:	06300593          	li	a1,99
ffffffffc0202adc:	00004517          	auipc	a0,0x4
ffffffffc0202ae0:	14450513          	add	a0,a0,324 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202ae4:	98ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202ae8:	00004697          	auipc	a3,0x4
ffffffffc0202aec:	1f068693          	add	a3,a3,496 # ffffffffc0206cd8 <default_pmm_manager+0x438>
ffffffffc0202af0:	00003617          	auipc	a2,0x3
ffffffffc0202af4:	71860613          	add	a2,a2,1816 # ffffffffc0206208 <commands+0x450>
ffffffffc0202af8:	06000593          	li	a1,96
ffffffffc0202afc:	00004517          	auipc	a0,0x4
ffffffffc0202b00:	12450513          	add	a0,a0,292 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202b04:	96ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b08:	00004697          	auipc	a3,0x4
ffffffffc0202b0c:	1d068693          	add	a3,a3,464 # ffffffffc0206cd8 <default_pmm_manager+0x438>
ffffffffc0202b10:	00003617          	auipc	a2,0x3
ffffffffc0202b14:	6f860613          	add	a2,a2,1784 # ffffffffc0206208 <commands+0x450>
ffffffffc0202b18:	05d00593          	li	a1,93
ffffffffc0202b1c:	00004517          	auipc	a0,0x4
ffffffffc0202b20:	10450513          	add	a0,a0,260 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202b24:	94ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b28:	00004697          	auipc	a3,0x4
ffffffffc0202b2c:	0e868693          	add	a3,a3,232 # ffffffffc0206c10 <default_pmm_manager+0x370>
ffffffffc0202b30:	00003617          	auipc	a2,0x3
ffffffffc0202b34:	6d860613          	add	a2,a2,1752 # ffffffffc0206208 <commands+0x450>
ffffffffc0202b38:	05a00593          	li	a1,90
ffffffffc0202b3c:	00004517          	auipc	a0,0x4
ffffffffc0202b40:	0e450513          	add	a0,a0,228 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202b44:	92ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b48:	00004697          	auipc	a3,0x4
ffffffffc0202b4c:	0c868693          	add	a3,a3,200 # ffffffffc0206c10 <default_pmm_manager+0x370>
ffffffffc0202b50:	00003617          	auipc	a2,0x3
ffffffffc0202b54:	6b860613          	add	a2,a2,1720 # ffffffffc0206208 <commands+0x450>
ffffffffc0202b58:	05700593          	li	a1,87
ffffffffc0202b5c:	00004517          	auipc	a0,0x4
ffffffffc0202b60:	0c450513          	add	a0,a0,196 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202b64:	90ffd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202b68:	00004697          	auipc	a3,0x4
ffffffffc0202b6c:	0a868693          	add	a3,a3,168 # ffffffffc0206c10 <default_pmm_manager+0x370>
ffffffffc0202b70:	00003617          	auipc	a2,0x3
ffffffffc0202b74:	69860613          	add	a2,a2,1688 # ffffffffc0206208 <commands+0x450>
ffffffffc0202b78:	05400593          	li	a1,84
ffffffffc0202b7c:	00004517          	auipc	a0,0x4
ffffffffc0202b80:	0a450513          	add	a0,a0,164 # ffffffffc0206c20 <default_pmm_manager+0x380>
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
ffffffffc0202bae:	1c668693          	add	a3,a3,454 # ffffffffc0206d70 <default_pmm_manager+0x4d0>
ffffffffc0202bb2:	00003617          	auipc	a2,0x3
ffffffffc0202bb6:	65660613          	add	a2,a2,1622 # ffffffffc0206208 <commands+0x450>
ffffffffc0202bba:	04100593          	li	a1,65
ffffffffc0202bbe:	00004517          	auipc	a0,0x4
ffffffffc0202bc2:	06250513          	add	a0,a0,98 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202bc6:	8adfd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202bca:	00004697          	auipc	a3,0x4
ffffffffc0202bce:	1b668693          	add	a3,a3,438 # ffffffffc0206d80 <default_pmm_manager+0x4e0>
ffffffffc0202bd2:	00003617          	auipc	a2,0x3
ffffffffc0202bd6:	63660613          	add	a2,a2,1590 # ffffffffc0206208 <commands+0x450>
ffffffffc0202bda:	04200593          	li	a1,66
ffffffffc0202bde:	00004517          	auipc	a0,0x4
ffffffffc0202be2:	04250513          	add	a0,a0,66 # ffffffffc0206c20 <default_pmm_manager+0x380>
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
ffffffffc0202c06:	18e68693          	add	a3,a3,398 # ffffffffc0206d90 <default_pmm_manager+0x4f0>
ffffffffc0202c0a:	00003617          	auipc	a2,0x3
ffffffffc0202c0e:	5fe60613          	add	a2,a2,1534 # ffffffffc0206208 <commands+0x450>
ffffffffc0202c12:	03200593          	li	a1,50
ffffffffc0202c16:	00004517          	auipc	a0,0x4
ffffffffc0202c1a:	00a50513          	add	a0,a0,10 # ffffffffc0206c20 <default_pmm_manager+0x380>
ffffffffc0202c1e:	e406                	sd	ra,8(sp)
ffffffffc0202c20:	853fd0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0202c24 <check_vma_overlap.part.0>:
ffffffffc0202c24:	1141                	add	sp,sp,-16
ffffffffc0202c26:	00004697          	auipc	a3,0x4
ffffffffc0202c2a:	1a268693          	add	a3,a3,418 # ffffffffc0206dc8 <default_pmm_manager+0x528>
ffffffffc0202c2e:	00003617          	auipc	a2,0x3
ffffffffc0202c32:	5da60613          	add	a2,a2,1498 # ffffffffc0206208 <commands+0x450>
ffffffffc0202c36:	06d00593          	li	a1,109
ffffffffc0202c3a:	00004517          	auipc	a0,0x4
ffffffffc0202c3e:	1ae50513          	add	a0,a0,430 # ffffffffc0206de8 <default_pmm_manager+0x548>
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
ffffffffc0202c6e:	91e7a783          	lw	a5,-1762(a5) # ffffffffc0217588 <swap_init_ok>
ffffffffc0202c72:	ef99                	bnez	a5,ffffffffc0202c90 <mm_create+0x48>
ffffffffc0202c74:	02053423          	sd	zero,40(a0)
ffffffffc0202c78:	02042823          	sw	zero,48(s0)
ffffffffc0202c7c:	4585                	li	a1,1
ffffffffc0202c7e:	03840513          	add	a0,s0,56
ffffffffc0202c82:	203000ef          	jal	ffffffffc0203684 <sem_init>
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
ffffffffc0202d4a:	0b268693          	add	a3,a3,178 # ffffffffc0206df8 <default_pmm_manager+0x558>
ffffffffc0202d4e:	00003617          	auipc	a2,0x3
ffffffffc0202d52:	4ba60613          	add	a2,a2,1210 # ffffffffc0206208 <commands+0x450>
ffffffffc0202d56:	07400593          	li	a1,116
ffffffffc0202d5a:	00004517          	auipc	a0,0x4
ffffffffc0202d5e:	08e50513          	add	a0,a0,142 # ffffffffc0206de8 <default_pmm_manager+0x548>
ffffffffc0202d62:	f10fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202d66:	00004697          	auipc	a3,0x4
ffffffffc0202d6a:	0d268693          	add	a3,a3,210 # ffffffffc0206e38 <default_pmm_manager+0x598>
ffffffffc0202d6e:	00003617          	auipc	a2,0x3
ffffffffc0202d72:	49a60613          	add	a2,a2,1178 # ffffffffc0206208 <commands+0x450>
ffffffffc0202d76:	06c00593          	li	a1,108
ffffffffc0202d7a:	00004517          	auipc	a0,0x4
ffffffffc0202d7e:	06e50513          	add	a0,a0,110 # ffffffffc0206de8 <default_pmm_manager+0x548>
ffffffffc0202d82:	ef0fd0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0202d86:	00004697          	auipc	a3,0x4
ffffffffc0202d8a:	09268693          	add	a3,a3,146 # ffffffffc0206e18 <default_pmm_manager+0x578>
ffffffffc0202d8e:	00003617          	auipc	a2,0x3
ffffffffc0202d92:	47a60613          	add	a2,a2,1146 # ffffffffc0206208 <commands+0x450>
ffffffffc0202d96:	06b00593          	li	a1,107
ffffffffc0202d9a:	00004517          	auipc	a0,0x4
ffffffffc0202d9e:	04e50513          	add	a0,a0,78 # ffffffffc0206de8 <default_pmm_manager+0x548>
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
ffffffffc0202ddc:	08068693          	add	a3,a3,128 # ffffffffc0206e58 <default_pmm_manager+0x5b8>
ffffffffc0202de0:	00003617          	auipc	a2,0x3
ffffffffc0202de4:	42860613          	add	a2,a2,1064 # ffffffffc0206208 <commands+0x450>
ffffffffc0202de8:	09400593          	li	a1,148
ffffffffc0202dec:	00004517          	auipc	a0,0x4
ffffffffc0202df0:	ffc50513          	add	a0,a0,-4 # ffffffffc0206de8 <default_pmm_manager+0x548>
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
ffffffffc0202e8c:	fe868693          	add	a3,a3,-24 # ffffffffc0206e70 <default_pmm_manager+0x5d0>
ffffffffc0202e90:	00003617          	auipc	a2,0x3
ffffffffc0202e94:	37860613          	add	a2,a2,888 # ffffffffc0206208 <commands+0x450>
ffffffffc0202e98:	0a700593          	li	a1,167
ffffffffc0202e9c:	00004517          	auipc	a0,0x4
ffffffffc0202ea0:	f4c50513          	add	a0,a0,-180 # ffffffffc0206de8 <default_pmm_manager+0x548>
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
ffffffffc0202f24:	f6068693          	add	a3,a3,-160 # ffffffffc0206e80 <default_pmm_manager+0x5e0>
ffffffffc0202f28:	00003617          	auipc	a2,0x3
ffffffffc0202f2c:	2e060613          	add	a2,a2,736 # ffffffffc0206208 <commands+0x450>
ffffffffc0202f30:	0c000593          	li	a1,192
ffffffffc0202f34:	00004517          	auipc	a0,0x4
ffffffffc0202f38:	eb450513          	add	a0,a0,-332 # ffffffffc0206de8 <default_pmm_manager+0x548>
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
ffffffffc0202f9a:	f0a68693          	add	a3,a3,-246 # ffffffffc0206ea0 <default_pmm_manager+0x600>
ffffffffc0202f9e:	00003617          	auipc	a2,0x3
ffffffffc0202fa2:	26a60613          	add	a2,a2,618 # ffffffffc0206208 <commands+0x450>
ffffffffc0202fa6:	0d600593          	li	a1,214
ffffffffc0202faa:	00004517          	auipc	a0,0x4
ffffffffc0202fae:	e3e50513          	add	a0,a0,-450 # ffffffffc0206de8 <default_pmm_manager+0x548>
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
ffffffffc0202fd2:	5d27a783          	lw	a5,1490(a5) # ffffffffc02175a0 <pgfault_num>
ffffffffc0202fd6:	2785                	addw	a5,a5,1
ffffffffc0202fd8:	00014717          	auipc	a4,0x14
ffffffffc0202fdc:	5cf72423          	sw	a5,1480(a4) # ffffffffc02175a0 <pgfault_num>
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
ffffffffc0203008:	5847a783          	lw	a5,1412(a5) # ffffffffc0217588 <swap_init_ok>
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
ffffffffc0203054:	ee850513          	add	a0,a0,-280 # ffffffffc0206f38 <default_pmm_manager+0x698>
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
ffffffffc020307c:	e9850513          	add	a0,a0,-360 # ffffffffc0206f10 <default_pmm_manager+0x670>
ffffffffc0203080:	90afd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203084:	5971                	li	s2,-4
ffffffffc0203086:	bf5d                	j	ffffffffc020303c <do_pgfault+0x84>
ffffffffc0203088:	85a2                	mv	a1,s0
ffffffffc020308a:	00004517          	auipc	a0,0x4
ffffffffc020308e:	e3650513          	add	a0,a0,-458 # ffffffffc0206ec0 <default_pmm_manager+0x620>
ffffffffc0203092:	8f8fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203096:	5975                	li	s2,-3
ffffffffc0203098:	b755                	j	ffffffffc020303c <do_pgfault+0x84>
ffffffffc020309a:	00004517          	auipc	a0,0x4
ffffffffc020309e:	ebe50513          	add	a0,a0,-322 # ffffffffc0206f58 <default_pmm_manager+0x6b8>
ffffffffc02030a2:	8e8fd0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02030a6:	5971                	li	s2,-4
ffffffffc02030a8:	bf51                	j	ffffffffc020303c <do_pgfault+0x84>
ffffffffc02030aa:	00004517          	auipc	a0,0x4
ffffffffc02030ae:	e4650513          	add	a0,a0,-442 # ffffffffc0206ef0 <default_pmm_manager+0x650>
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
ffffffffc0203142:	0505                	add	a0,a0,1 # ffffffffc8000001 <end+0x7de8a01>
ffffffffc0203144:	00a63533          	sltu	a0,a2,a0
ffffffffc0203148:	bfd9                	j	ffffffffc020311e <user_mem_check+0x64>
ffffffffc020314a:	4505                	li	a0,1
ffffffffc020314c:	bfc9                	j	ffffffffc020311e <user_mem_check+0x64>

ffffffffc020314e <mom>:
ffffffffc020314e:	715d                	add	sp,sp,-80
ffffffffc0203150:	e0a2                	sd	s0,64(sp)
ffffffffc0203152:	fc26                	sd	s1,56(sp)
ffffffffc0203154:	f84a                	sd	s2,48(sp)
ffffffffc0203156:	f44e                	sd	s3,40(sp)
ffffffffc0203158:	f052                	sd	s4,32(sp)
ffffffffc020315a:	ec56                	sd	s5,24(sp)
ffffffffc020315c:	e85a                	sd	s6,16(sp)
ffffffffc020315e:	e45e                	sd	s7,8(sp)
ffffffffc0203160:	e062                	sd	s8,0(sp)
ffffffffc0203162:	e486                	sd	ra,72(sp)
ffffffffc0203164:	00009417          	auipc	s0,0x9
ffffffffc0203168:	f2440413          	add	s0,s0,-220 # ffffffffc020c088 <milk>
ffffffffc020316c:	00010497          	auipc	s1,0x10
ffffffffc0203170:	37c48493          	add	s1,s1,892 # ffffffffc02134e8 <mutex1>
ffffffffc0203174:	00004b17          	auipc	s6,0x4
ffffffffc0203178:	e0cb0b13          	add	s6,s6,-500 # ffffffffc0206f80 <default_pmm_manager+0x6e0>
ffffffffc020317c:	00004997          	auipc	s3,0x4
ffffffffc0203180:	e1c98993          	add	s3,s3,-484 # ffffffffc0206f98 <default_pmm_manager+0x6f8>
ffffffffc0203184:	00010917          	auipc	s2,0x10
ffffffffc0203188:	33c90913          	add	s2,s2,828 # ffffffffc02134c0 <p1>
ffffffffc020318c:	00004a97          	auipc	s5,0x4
ffffffffc0203190:	e1ca8a93          	add	s5,s5,-484 # ffffffffc0206fa8 <default_pmm_manager+0x708>
ffffffffc0203194:	00004a17          	auipc	s4,0x4
ffffffffc0203198:	e34a0a13          	add	s4,s4,-460 # ffffffffc0206fc8 <default_pmm_manager+0x728>
ffffffffc020319c:	00004c17          	auipc	s8,0x4
ffffffffc02031a0:	e84c0c13          	add	s8,s8,-380 # ffffffffc0207020 <default_pmm_manager+0x780>
ffffffffc02031a4:	00004b97          	auipc	s7,0x4
ffffffffc02031a8:	e3cb8b93          	add	s7,s7,-452 # ffffffffc0206fe0 <default_pmm_manager+0x740>
ffffffffc02031ac:	8526                	mv	a0,s1
ffffffffc02031ae:	4de000ef          	jal	ffffffffc020368c <down>
ffffffffc02031b2:	855a                	mv	a0,s6
ffffffffc02031b4:	fd7fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02031b8:	401c                	lw	a5,0(s0)
ffffffffc02031ba:	00f05c63          	blez	a5,ffffffffc02031d2 <mom+0x84>
ffffffffc02031be:	854e                	mv	a0,s3
ffffffffc02031c0:	fcbfc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02031c4:	85a6                	mv	a1,s1
ffffffffc02031c6:	854a                	mv	a0,s2
ffffffffc02031c8:	33c000ef          	jal	ffffffffc0203504 <cond_wait>
ffffffffc02031cc:	401c                	lw	a5,0(s0)
ffffffffc02031ce:	fef048e3          	bgtz	a5,ffffffffc02031be <mom+0x70>
ffffffffc02031d2:	8556                	mv	a0,s5
ffffffffc02031d4:	fb7fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02031d8:	8552                	mv	a0,s4
ffffffffc02031da:	fb1fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02031de:	401c                	lw	a5,0(s0)
ffffffffc02031e0:	00f05d63          	blez	a5,ffffffffc02031fa <mom+0xac>
ffffffffc02031e4:	855e                	mv	a0,s7
ffffffffc02031e6:	fa5fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02031ea:	8526                	mv	a0,s1
ffffffffc02031ec:	49e000ef          	jal	ffffffffc020368a <up>
ffffffffc02031f0:	06400513          	li	a0,100
ffffffffc02031f4:	141010ef          	jal	ffffffffc0204b34 <do_sleep>
ffffffffc02031f8:	bf55                	j	ffffffffc02031ac <mom+0x5e>
ffffffffc02031fa:	0647879b          	addw	a5,a5,100 # ffffffffc0200064 <kern_init+0x32>
ffffffffc02031fe:	8562                	mv	a0,s8
ffffffffc0203200:	c01c                	sw	a5,0(s0)
ffffffffc0203202:	f89fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203206:	b7d5                	j	ffffffffc02031ea <mom+0x9c>

ffffffffc0203208 <sister>:
ffffffffc0203208:	715d                	add	sp,sp,-80
ffffffffc020320a:	e0a2                	sd	s0,64(sp)
ffffffffc020320c:	fc26                	sd	s1,56(sp)
ffffffffc020320e:	f84a                	sd	s2,48(sp)
ffffffffc0203210:	f44e                	sd	s3,40(sp)
ffffffffc0203212:	f052                	sd	s4,32(sp)
ffffffffc0203214:	ec56                	sd	s5,24(sp)
ffffffffc0203216:	e85a                	sd	s6,16(sp)
ffffffffc0203218:	e45e                	sd	s7,8(sp)
ffffffffc020321a:	e062                	sd	s8,0(sp)
ffffffffc020321c:	e486                	sd	ra,72(sp)
ffffffffc020321e:	00009417          	auipc	s0,0x9
ffffffffc0203222:	e6a40413          	add	s0,s0,-406 # ffffffffc020c088 <milk>
ffffffffc0203226:	00010497          	auipc	s1,0x10
ffffffffc020322a:	2c248493          	add	s1,s1,706 # ffffffffc02134e8 <mutex1>
ffffffffc020322e:	00004b17          	auipc	s6,0x4
ffffffffc0203232:	e1ab0b13          	add	s6,s6,-486 # ffffffffc0207048 <default_pmm_manager+0x7a8>
ffffffffc0203236:	00004997          	auipc	s3,0x4
ffffffffc020323a:	e2a98993          	add	s3,s3,-470 # ffffffffc0207060 <default_pmm_manager+0x7c0>
ffffffffc020323e:	00010917          	auipc	s2,0x10
ffffffffc0203242:	28290913          	add	s2,s2,642 # ffffffffc02134c0 <p1>
ffffffffc0203246:	00004a97          	auipc	s5,0x4
ffffffffc020324a:	e2aa8a93          	add	s5,s5,-470 # ffffffffc0207070 <default_pmm_manager+0x7d0>
ffffffffc020324e:	00004a17          	auipc	s4,0x4
ffffffffc0203252:	e42a0a13          	add	s4,s4,-446 # ffffffffc0207090 <default_pmm_manager+0x7f0>
ffffffffc0203256:	00004c17          	auipc	s8,0x4
ffffffffc020325a:	e52c0c13          	add	s8,s8,-430 # ffffffffc02070a8 <default_pmm_manager+0x808>
ffffffffc020325e:	00004b97          	auipc	s7,0x4
ffffffffc0203262:	d82b8b93          	add	s7,s7,-638 # ffffffffc0206fe0 <default_pmm_manager+0x740>
ffffffffc0203266:	8526                	mv	a0,s1
ffffffffc0203268:	424000ef          	jal	ffffffffc020368c <down>
ffffffffc020326c:	855a                	mv	a0,s6
ffffffffc020326e:	f1dfc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203272:	401c                	lw	a5,0(s0)
ffffffffc0203274:	00f05c63          	blez	a5,ffffffffc020328c <sister+0x84>
ffffffffc0203278:	854e                	mv	a0,s3
ffffffffc020327a:	f11fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020327e:	85a6                	mv	a1,s1
ffffffffc0203280:	854a                	mv	a0,s2
ffffffffc0203282:	282000ef          	jal	ffffffffc0203504 <cond_wait>
ffffffffc0203286:	401c                	lw	a5,0(s0)
ffffffffc0203288:	fef048e3          	bgtz	a5,ffffffffc0203278 <sister+0x70>
ffffffffc020328c:	8556                	mv	a0,s5
ffffffffc020328e:	efdfc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203292:	8552                	mv	a0,s4
ffffffffc0203294:	ef7fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203298:	401c                	lw	a5,0(s0)
ffffffffc020329a:	00f05d63          	blez	a5,ffffffffc02032b4 <sister+0xac>
ffffffffc020329e:	855e                	mv	a0,s7
ffffffffc02032a0:	eebfc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02032a4:	8526                	mv	a0,s1
ffffffffc02032a6:	3e4000ef          	jal	ffffffffc020368a <up>
ffffffffc02032aa:	06400513          	li	a0,100
ffffffffc02032ae:	087010ef          	jal	ffffffffc0204b34 <do_sleep>
ffffffffc02032b2:	bf55                	j	ffffffffc0203266 <sister+0x5e>
ffffffffc02032b4:	0647879b          	addw	a5,a5,100
ffffffffc02032b8:	8562                	mv	a0,s8
ffffffffc02032ba:	c01c                	sw	a5,0(s0)
ffffffffc02032bc:	ecffc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02032c0:	b7d5                	j	ffffffffc02032a4 <sister+0x9c>

ffffffffc02032c2 <dad>:
ffffffffc02032c2:	7139                	add	sp,sp,-64
ffffffffc02032c4:	f822                	sd	s0,48(sp)
ffffffffc02032c6:	f426                	sd	s1,40(sp)
ffffffffc02032c8:	f04a                	sd	s2,32(sp)
ffffffffc02032ca:	ec4e                	sd	s3,24(sp)
ffffffffc02032cc:	e852                	sd	s4,16(sp)
ffffffffc02032ce:	e456                	sd	s5,8(sp)
ffffffffc02032d0:	fc06                	sd	ra,56(sp)
ffffffffc02032d2:	00009497          	auipc	s1,0x9
ffffffffc02032d6:	db648493          	add	s1,s1,-586 # ffffffffc020c088 <milk>
ffffffffc02032da:	00010417          	auipc	s0,0x10
ffffffffc02032de:	20e40413          	add	s0,s0,526 # ffffffffc02134e8 <mutex1>
ffffffffc02032e2:	00004997          	auipc	s3,0x4
ffffffffc02032e6:	dee98993          	add	s3,s3,-530 # ffffffffc02070d0 <default_pmm_manager+0x830>
ffffffffc02032ea:	00004a97          	auipc	s5,0x4
ffffffffc02032ee:	e26a8a93          	add	s5,s5,-474 # ffffffffc0207110 <default_pmm_manager+0x870>
ffffffffc02032f2:	00010917          	auipc	s2,0x10
ffffffffc02032f6:	1ce90913          	add	s2,s2,462 # ffffffffc02134c0 <p1>
ffffffffc02032fa:	00004a17          	auipc	s4,0x4
ffffffffc02032fe:	deea0a13          	add	s4,s4,-530 # ffffffffc02070e8 <default_pmm_manager+0x848>
ffffffffc0203302:	a829                	j	ffffffffc020331c <dad+0x5a>
ffffffffc0203304:	1cc000ef          	jal	ffffffffc02034d0 <cond_signal>
ffffffffc0203308:	8552                	mv	a0,s4
ffffffffc020330a:	e81fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc020330e:	8522                	mv	a0,s0
ffffffffc0203310:	37a000ef          	jal	ffffffffc020368a <up>
ffffffffc0203314:	06400513          	li	a0,100
ffffffffc0203318:	01d010ef          	jal	ffffffffc0204b34 <do_sleep>
ffffffffc020331c:	8522                	mv	a0,s0
ffffffffc020331e:	36e000ef          	jal	ffffffffc020368c <down>
ffffffffc0203322:	854e                	mv	a0,s3
ffffffffc0203324:	e67fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203328:	409c                	lw	a5,0(s1)
ffffffffc020332a:	854a                	mv	a0,s2
ffffffffc020332c:	dfe1                	beqz	a5,ffffffffc0203304 <dad+0x42>
ffffffffc020332e:	37b1                	addw	a5,a5,-20
ffffffffc0203330:	8556                	mv	a0,s5
ffffffffc0203332:	c09c                	sw	a5,0(s1)
ffffffffc0203334:	e57fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203338:	bfd9                	j	ffffffffc020330e <dad+0x4c>

ffffffffc020333a <you>:
ffffffffc020333a:	7139                	add	sp,sp,-64
ffffffffc020333c:	f822                	sd	s0,48(sp)
ffffffffc020333e:	f426                	sd	s1,40(sp)
ffffffffc0203340:	f04a                	sd	s2,32(sp)
ffffffffc0203342:	ec4e                	sd	s3,24(sp)
ffffffffc0203344:	e852                	sd	s4,16(sp)
ffffffffc0203346:	e456                	sd	s5,8(sp)
ffffffffc0203348:	fc06                	sd	ra,56(sp)
ffffffffc020334a:	00009497          	auipc	s1,0x9
ffffffffc020334e:	d3e48493          	add	s1,s1,-706 # ffffffffc020c088 <milk>
ffffffffc0203352:	00010417          	auipc	s0,0x10
ffffffffc0203356:	19640413          	add	s0,s0,406 # ffffffffc02134e8 <mutex1>
ffffffffc020335a:	00004997          	auipc	s3,0x4
ffffffffc020335e:	dce98993          	add	s3,s3,-562 # ffffffffc0207128 <default_pmm_manager+0x888>
ffffffffc0203362:	00004a97          	auipc	s5,0x4
ffffffffc0203366:	e06a8a93          	add	s5,s5,-506 # ffffffffc0207168 <default_pmm_manager+0x8c8>
ffffffffc020336a:	00010917          	auipc	s2,0x10
ffffffffc020336e:	15690913          	add	s2,s2,342 # ffffffffc02134c0 <p1>
ffffffffc0203372:	00004a17          	auipc	s4,0x4
ffffffffc0203376:	dcea0a13          	add	s4,s4,-562 # ffffffffc0207140 <default_pmm_manager+0x8a0>
ffffffffc020337a:	a829                	j	ffffffffc0203394 <you+0x5a>
ffffffffc020337c:	154000ef          	jal	ffffffffc02034d0 <cond_signal>
ffffffffc0203380:	8552                	mv	a0,s4
ffffffffc0203382:	e09fc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0203386:	8522                	mv	a0,s0
ffffffffc0203388:	302000ef          	jal	ffffffffc020368a <up>
ffffffffc020338c:	06400513          	li	a0,100
ffffffffc0203390:	7a4010ef          	jal	ffffffffc0204b34 <do_sleep>
ffffffffc0203394:	8522                	mv	a0,s0
ffffffffc0203396:	2f6000ef          	jal	ffffffffc020368c <down>
ffffffffc020339a:	854e                	mv	a0,s3
ffffffffc020339c:	deffc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02033a0:	409c                	lw	a5,0(s1)
ffffffffc02033a2:	854a                	mv	a0,s2
ffffffffc02033a4:	dfe1                	beqz	a5,ffffffffc020337c <you+0x42>
ffffffffc02033a6:	37b1                	addw	a5,a5,-20
ffffffffc02033a8:	8556                	mv	a0,s5
ffffffffc02033aa:	c09c                	sw	a5,0(s1)
ffffffffc02033ac:	ddffc0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02033b0:	bfd9                	j	ffffffffc0203386 <you+0x4c>

ffffffffc02033b2 <check_milk>:
ffffffffc02033b2:	7179                	add	sp,sp,-48
ffffffffc02033b4:	4585                	li	a1,1
ffffffffc02033b6:	00010517          	auipc	a0,0x10
ffffffffc02033ba:	13250513          	add	a0,a0,306 # ffffffffc02134e8 <mutex1>
ffffffffc02033be:	f406                	sd	ra,40(sp)
ffffffffc02033c0:	f022                	sd	s0,32(sp)
ffffffffc02033c2:	ec26                	sd	s1,24(sp)
ffffffffc02033c4:	e84a                	sd	s2,16(sp)
ffffffffc02033c6:	e44e                	sd	s3,8(sp)
ffffffffc02033c8:	2bc000ef          	jal	ffffffffc0203684 <sem_init>
ffffffffc02033cc:	00010517          	auipc	a0,0x10
ffffffffc02033d0:	0f450513          	add	a0,a0,244 # ffffffffc02134c0 <p1>
ffffffffc02033d4:	0be000ef          	jal	ffffffffc0203492 <cond_init>
ffffffffc02033d8:	4601                	li	a2,0
ffffffffc02033da:	4581                	li	a1,0
ffffffffc02033dc:	00000517          	auipc	a0,0x0
ffffffffc02033e0:	ee650513          	add	a0,a0,-282 # ffffffffc02032c2 <dad>
ffffffffc02033e4:	2fb000ef          	jal	ffffffffc0203ede <kernel_thread>
ffffffffc02033e8:	89aa                	mv	s3,a0
ffffffffc02033ea:	4601                	li	a2,0
ffffffffc02033ec:	4581                	li	a1,0
ffffffffc02033ee:	00000517          	auipc	a0,0x0
ffffffffc02033f2:	d6050513          	add	a0,a0,-672 # ffffffffc020314e <mom>
ffffffffc02033f6:	2e9000ef          	jal	ffffffffc0203ede <kernel_thread>
ffffffffc02033fa:	892a                	mv	s2,a0
ffffffffc02033fc:	4601                	li	a2,0
ffffffffc02033fe:	4581                	li	a1,0
ffffffffc0203400:	00000517          	auipc	a0,0x0
ffffffffc0203404:	e0850513          	add	a0,a0,-504 # ffffffffc0203208 <sister>
ffffffffc0203408:	2d7000ef          	jal	ffffffffc0203ede <kernel_thread>
ffffffffc020340c:	4601                	li	a2,0
ffffffffc020340e:	84aa                	mv	s1,a0
ffffffffc0203410:	4581                	li	a1,0
ffffffffc0203412:	00000517          	auipc	a0,0x0
ffffffffc0203416:	f2850513          	add	a0,a0,-216 # ffffffffc020333a <you>
ffffffffc020341a:	2c5000ef          	jal	ffffffffc0203ede <kernel_thread>
ffffffffc020341e:	842a                	mv	s0,a0
ffffffffc0203420:	854e                	mv	a0,s3
ffffffffc0203422:	686000ef          	jal	ffffffffc0203aa8 <find_proc>
ffffffffc0203426:	00004597          	auipc	a1,0x4
ffffffffc020342a:	d5a58593          	add	a1,a1,-678 # ffffffffc0207180 <default_pmm_manager+0x8e0>
ffffffffc020342e:	00014717          	auipc	a4,0x14
ffffffffc0203432:	18a73d23          	sd	a0,410(a4) # ffffffffc02175c8 <pdad>
ffffffffc0203436:	5dc000ef          	jal	ffffffffc0203a12 <set_proc_name>
ffffffffc020343a:	854a                	mv	a0,s2
ffffffffc020343c:	66c000ef          	jal	ffffffffc0203aa8 <find_proc>
ffffffffc0203440:	00004597          	auipc	a1,0x4
ffffffffc0203444:	d4858593          	add	a1,a1,-696 # ffffffffc0207188 <default_pmm_manager+0x8e8>
ffffffffc0203448:	00014717          	auipc	a4,0x14
ffffffffc020344c:	16a73c23          	sd	a0,376(a4) # ffffffffc02175c0 <pmom>
ffffffffc0203450:	5c2000ef          	jal	ffffffffc0203a12 <set_proc_name>
ffffffffc0203454:	8526                	mv	a0,s1
ffffffffc0203456:	652000ef          	jal	ffffffffc0203aa8 <find_proc>
ffffffffc020345a:	00004597          	auipc	a1,0x4
ffffffffc020345e:	d3658593          	add	a1,a1,-714 # ffffffffc0207190 <default_pmm_manager+0x8f0>
ffffffffc0203462:	00014717          	auipc	a4,0x14
ffffffffc0203466:	14a73b23          	sd	a0,342(a4) # ffffffffc02175b8 <psister>
ffffffffc020346a:	5a8000ef          	jal	ffffffffc0203a12 <set_proc_name>
ffffffffc020346e:	8522                	mv	a0,s0
ffffffffc0203470:	638000ef          	jal	ffffffffc0203aa8 <find_proc>
ffffffffc0203474:	7402                	ld	s0,32(sp)
ffffffffc0203476:	70a2                	ld	ra,40(sp)
ffffffffc0203478:	64e2                	ld	s1,24(sp)
ffffffffc020347a:	6942                	ld	s2,16(sp)
ffffffffc020347c:	69a2                	ld	s3,8(sp)
ffffffffc020347e:	00014717          	auipc	a4,0x14
ffffffffc0203482:	12a73923          	sd	a0,306(a4) # ffffffffc02175b0 <pyou>
ffffffffc0203486:	00004597          	auipc	a1,0x4
ffffffffc020348a:	d1258593          	add	a1,a1,-750 # ffffffffc0207198 <default_pmm_manager+0x8f8>
ffffffffc020348e:	6145                	add	sp,sp,48
ffffffffc0203490:	a349                	j	ffffffffc0203a12 <set_proc_name>

ffffffffc0203492 <cond_init>:
ffffffffc0203492:	1101                	add	sp,sp,-32
ffffffffc0203494:	e822                	sd	s0,16(sp)
ffffffffc0203496:	842a                	mv	s0,a0
ffffffffc0203498:	04000513          	li	a0,64
ffffffffc020349c:	ec06                	sd	ra,24(sp)
ffffffffc020349e:	e426                	sd	s1,8(sp)
ffffffffc02034a0:	d3efe0ef          	jal	ffffffffc02019de <kmalloc>
ffffffffc02034a4:	fd00                	sd	s0,56(a0)
ffffffffc02034a6:	4585                	li	a1,1
ffffffffc02034a8:	02052823          	sw	zero,48(a0)
ffffffffc02034ac:	84aa                	mv	s1,a0
ffffffffc02034ae:	1d6000ef          	jal	ffffffffc0203684 <sem_init>
ffffffffc02034b2:	01848513          	add	a0,s1,24
ffffffffc02034b6:	4581                	li	a1,0
ffffffffc02034b8:	1cc000ef          	jal	ffffffffc0203684 <sem_init>
ffffffffc02034bc:	8522                	mv	a0,s0
ffffffffc02034be:	f004                	sd	s1,32(s0)
ffffffffc02034c0:	00042c23          	sw	zero,24(s0)
ffffffffc02034c4:	6442                	ld	s0,16(sp)
ffffffffc02034c6:	60e2                	ld	ra,24(sp)
ffffffffc02034c8:	64a2                	ld	s1,8(sp)
ffffffffc02034ca:	4581                	li	a1,0
ffffffffc02034cc:	6105                	add	sp,sp,32
ffffffffc02034ce:	aa5d                	j	ffffffffc0203684 <sem_init>

ffffffffc02034d0 <cond_signal>:
ffffffffc02034d0:	4d1c                	lw	a5,24(a0)
ffffffffc02034d2:	00f04363          	bgtz	a5,ffffffffc02034d8 <cond_signal+0x8>
ffffffffc02034d6:	8082                	ret
ffffffffc02034d8:	7118                	ld	a4,32(a0)
ffffffffc02034da:	1141                	add	sp,sp,-16
ffffffffc02034dc:	e406                	sd	ra,8(sp)
ffffffffc02034de:	5b1c                	lw	a5,48(a4)
ffffffffc02034e0:	e022                	sd	s0,0(sp)
ffffffffc02034e2:	842a                	mv	s0,a0
ffffffffc02034e4:	2785                	addw	a5,a5,1
ffffffffc02034e6:	db1c                	sw	a5,48(a4)
ffffffffc02034e8:	1a2000ef          	jal	ffffffffc020368a <up>
ffffffffc02034ec:	7008                	ld	a0,32(s0)
ffffffffc02034ee:	0561                	add	a0,a0,24
ffffffffc02034f0:	19c000ef          	jal	ffffffffc020368c <down>
ffffffffc02034f4:	7018                	ld	a4,32(s0)
ffffffffc02034f6:	60a2                	ld	ra,8(sp)
ffffffffc02034f8:	6402                	ld	s0,0(sp)
ffffffffc02034fa:	5b1c                	lw	a5,48(a4)
ffffffffc02034fc:	37fd                	addw	a5,a5,-1
ffffffffc02034fe:	db1c                	sw	a5,48(a4)
ffffffffc0203500:	0141                	add	sp,sp,16
ffffffffc0203502:	8082                	ret

ffffffffc0203504 <cond_wait>:
ffffffffc0203504:	1101                	add	sp,sp,-32
ffffffffc0203506:	e822                	sd	s0,16(sp)
ffffffffc0203508:	842a                	mv	s0,a0
ffffffffc020350a:	7108                	ld	a0,32(a0)
ffffffffc020350c:	4c1c                	lw	a5,24(s0)
ffffffffc020350e:	e426                	sd	s1,8(sp)
ffffffffc0203510:	5918                	lw	a4,48(a0)
ffffffffc0203512:	ec06                	sd	ra,24(sp)
ffffffffc0203514:	2785                	addw	a5,a5,1
ffffffffc0203516:	cc1c                	sw	a5,24(s0)
ffffffffc0203518:	84ae                	mv	s1,a1
ffffffffc020351a:	02e05363          	blez	a4,ffffffffc0203540 <cond_wait+0x3c>
ffffffffc020351e:	0561                	add	a0,a0,24
ffffffffc0203520:	16a000ef          	jal	ffffffffc020368a <up>
ffffffffc0203524:	8526                	mv	a0,s1
ffffffffc0203526:	164000ef          	jal	ffffffffc020368a <up>
ffffffffc020352a:	8522                	mv	a0,s0
ffffffffc020352c:	160000ef          	jal	ffffffffc020368c <down>
ffffffffc0203530:	4c1c                	lw	a5,24(s0)
ffffffffc0203532:	60e2                	ld	ra,24(sp)
ffffffffc0203534:	64a2                	ld	s1,8(sp)
ffffffffc0203536:	37fd                	addw	a5,a5,-1
ffffffffc0203538:	cc1c                	sw	a5,24(s0)
ffffffffc020353a:	6442                	ld	s0,16(sp)
ffffffffc020353c:	6105                	add	sp,sp,32
ffffffffc020353e:	8082                	ret
ffffffffc0203540:	14a000ef          	jal	ffffffffc020368a <up>
ffffffffc0203544:	b7c5                	j	ffffffffc0203524 <cond_wait+0x20>

ffffffffc0203546 <__down.constprop.0>:
ffffffffc0203546:	715d                	add	sp,sp,-80
ffffffffc0203548:	e0a2                	sd	s0,64(sp)
ffffffffc020354a:	e486                	sd	ra,72(sp)
ffffffffc020354c:	fc26                	sd	s1,56(sp)
ffffffffc020354e:	842a                	mv	s0,a0
ffffffffc0203550:	100027f3          	csrr	a5,sstatus
ffffffffc0203554:	8b89                	and	a5,a5,2
ffffffffc0203556:	eba9                	bnez	a5,ffffffffc02035a8 <__down.constprop.0+0x62>
ffffffffc0203558:	411c                	lw	a5,0(a0)
ffffffffc020355a:	00f05a63          	blez	a5,ffffffffc020356e <__down.constprop.0+0x28>
ffffffffc020355e:	37fd                	addw	a5,a5,-1
ffffffffc0203560:	c11c                	sw	a5,0(a0)
ffffffffc0203562:	4501                	li	a0,0
ffffffffc0203564:	60a6                	ld	ra,72(sp)
ffffffffc0203566:	6406                	ld	s0,64(sp)
ffffffffc0203568:	74e2                	ld	s1,56(sp)
ffffffffc020356a:	6161                	add	sp,sp,80
ffffffffc020356c:	8082                	ret
ffffffffc020356e:	00850413          	add	s0,a0,8
ffffffffc0203572:	0024                	add	s1,sp,8
ffffffffc0203574:	10000613          	li	a2,256
ffffffffc0203578:	85a6                	mv	a1,s1
ffffffffc020357a:	8522                	mv	a0,s0
ffffffffc020357c:	1f2000ef          	jal	ffffffffc020376e <wait_current_set>
ffffffffc0203580:	4eb010ef          	jal	ffffffffc020526a <schedule>
ffffffffc0203584:	100027f3          	csrr	a5,sstatus
ffffffffc0203588:	8b89                	and	a5,a5,2
ffffffffc020358a:	ebb1                	bnez	a5,ffffffffc02035de <__down.constprop.0+0x98>
ffffffffc020358c:	8526                	mv	a0,s1
ffffffffc020358e:	184000ef          	jal	ffffffffc0203712 <wait_in_queue>
ffffffffc0203592:	e129                	bnez	a0,ffffffffc02035d4 <__down.constprop.0+0x8e>
ffffffffc0203594:	4542                	lw	a0,16(sp)
ffffffffc0203596:	10000793          	li	a5,256
ffffffffc020359a:	fcf504e3          	beq	a0,a5,ffffffffc0203562 <__down.constprop.0+0x1c>
ffffffffc020359e:	60a6                	ld	ra,72(sp)
ffffffffc02035a0:	6406                	ld	s0,64(sp)
ffffffffc02035a2:	74e2                	ld	s1,56(sp)
ffffffffc02035a4:	6161                	add	sp,sp,80
ffffffffc02035a6:	8082                	ret
ffffffffc02035a8:	88cfd0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02035ac:	401c                	lw	a5,0(s0)
ffffffffc02035ae:	00f05863          	blez	a5,ffffffffc02035be <__down.constprop.0+0x78>
ffffffffc02035b2:	37fd                	addw	a5,a5,-1
ffffffffc02035b4:	c01c                	sw	a5,0(s0)
ffffffffc02035b6:	878fd0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02035ba:	4501                	li	a0,0
ffffffffc02035bc:	b765                	j	ffffffffc0203564 <__down.constprop.0+0x1e>
ffffffffc02035be:	0421                	add	s0,s0,8
ffffffffc02035c0:	0024                	add	s1,sp,8
ffffffffc02035c2:	10000613          	li	a2,256
ffffffffc02035c6:	85a6                	mv	a1,s1
ffffffffc02035c8:	8522                	mv	a0,s0
ffffffffc02035ca:	1a4000ef          	jal	ffffffffc020376e <wait_current_set>
ffffffffc02035ce:	860fd0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02035d2:	b77d                	j	ffffffffc0203580 <__down.constprop.0+0x3a>
ffffffffc02035d4:	85a6                	mv	a1,s1
ffffffffc02035d6:	8522                	mv	a0,s0
ffffffffc02035d8:	0ec000ef          	jal	ffffffffc02036c4 <wait_queue_del>
ffffffffc02035dc:	bf65                	j	ffffffffc0203594 <__down.constprop.0+0x4e>
ffffffffc02035de:	856fd0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02035e2:	8526                	mv	a0,s1
ffffffffc02035e4:	12e000ef          	jal	ffffffffc0203712 <wait_in_queue>
ffffffffc02035e8:	e501                	bnez	a0,ffffffffc02035f0 <__down.constprop.0+0xaa>
ffffffffc02035ea:	844fd0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02035ee:	b75d                	j	ffffffffc0203594 <__down.constprop.0+0x4e>
ffffffffc02035f0:	85a6                	mv	a1,s1
ffffffffc02035f2:	8522                	mv	a0,s0
ffffffffc02035f4:	0d0000ef          	jal	ffffffffc02036c4 <wait_queue_del>
ffffffffc02035f8:	bfcd                	j	ffffffffc02035ea <__down.constprop.0+0xa4>

ffffffffc02035fa <__up.constprop.0>:
ffffffffc02035fa:	1101                	add	sp,sp,-32
ffffffffc02035fc:	e822                	sd	s0,16(sp)
ffffffffc02035fe:	ec06                	sd	ra,24(sp)
ffffffffc0203600:	e426                	sd	s1,8(sp)
ffffffffc0203602:	e04a                	sd	s2,0(sp)
ffffffffc0203604:	842a                	mv	s0,a0
ffffffffc0203606:	100027f3          	csrr	a5,sstatus
ffffffffc020360a:	8b89                	and	a5,a5,2
ffffffffc020360c:	4901                	li	s2,0
ffffffffc020360e:	eba1                	bnez	a5,ffffffffc020365e <__up.constprop.0+0x64>
ffffffffc0203610:	00840493          	add	s1,s0,8
ffffffffc0203614:	8526                	mv	a0,s1
ffffffffc0203616:	0ec000ef          	jal	ffffffffc0203702 <wait_queue_first>
ffffffffc020361a:	85aa                	mv	a1,a0
ffffffffc020361c:	cd0d                	beqz	a0,ffffffffc0203656 <__up.constprop.0+0x5c>
ffffffffc020361e:	6118                	ld	a4,0(a0)
ffffffffc0203620:	10000793          	li	a5,256
ffffffffc0203624:	0ec72703          	lw	a4,236(a4)
ffffffffc0203628:	02f71f63          	bne	a4,a5,ffffffffc0203666 <__up.constprop.0+0x6c>
ffffffffc020362c:	4685                	li	a3,1
ffffffffc020362e:	10000613          	li	a2,256
ffffffffc0203632:	8526                	mv	a0,s1
ffffffffc0203634:	0ec000ef          	jal	ffffffffc0203720 <wakeup_wait>
ffffffffc0203638:	00091863          	bnez	s2,ffffffffc0203648 <__up.constprop.0+0x4e>
ffffffffc020363c:	60e2                	ld	ra,24(sp)
ffffffffc020363e:	6442                	ld	s0,16(sp)
ffffffffc0203640:	64a2                	ld	s1,8(sp)
ffffffffc0203642:	6902                	ld	s2,0(sp)
ffffffffc0203644:	6105                	add	sp,sp,32
ffffffffc0203646:	8082                	ret
ffffffffc0203648:	6442                	ld	s0,16(sp)
ffffffffc020364a:	60e2                	ld	ra,24(sp)
ffffffffc020364c:	64a2                	ld	s1,8(sp)
ffffffffc020364e:	6902                	ld	s2,0(sp)
ffffffffc0203650:	6105                	add	sp,sp,32
ffffffffc0203652:	fddfc06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0203656:	401c                	lw	a5,0(s0)
ffffffffc0203658:	2785                	addw	a5,a5,1
ffffffffc020365a:	c01c                	sw	a5,0(s0)
ffffffffc020365c:	bff1                	j	ffffffffc0203638 <__up.constprop.0+0x3e>
ffffffffc020365e:	fd7fc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203662:	4905                	li	s2,1
ffffffffc0203664:	b775                	j	ffffffffc0203610 <__up.constprop.0+0x16>
ffffffffc0203666:	00004697          	auipc	a3,0x4
ffffffffc020366a:	b3a68693          	add	a3,a3,-1222 # ffffffffc02071a0 <default_pmm_manager+0x900>
ffffffffc020366e:	00003617          	auipc	a2,0x3
ffffffffc0203672:	b9a60613          	add	a2,a2,-1126 # ffffffffc0206208 <commands+0x450>
ffffffffc0203676:	45e5                	li	a1,25
ffffffffc0203678:	00004517          	auipc	a0,0x4
ffffffffc020367c:	b5050513          	add	a0,a0,-1200 # ffffffffc02071c8 <default_pmm_manager+0x928>
ffffffffc0203680:	df3fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203684 <sem_init>:
ffffffffc0203684:	c10c                	sw	a1,0(a0)
ffffffffc0203686:	0521                	add	a0,a0,8
ffffffffc0203688:	a81d                	j	ffffffffc02036be <wait_queue_init>

ffffffffc020368a <up>:
ffffffffc020368a:	bf85                	j	ffffffffc02035fa <__up.constprop.0>

ffffffffc020368c <down>:
ffffffffc020368c:	1141                	add	sp,sp,-16
ffffffffc020368e:	e406                	sd	ra,8(sp)
ffffffffc0203690:	eb7ff0ef          	jal	ffffffffc0203546 <__down.constprop.0>
ffffffffc0203694:	2501                	sext.w	a0,a0
ffffffffc0203696:	e501                	bnez	a0,ffffffffc020369e <down+0x12>
ffffffffc0203698:	60a2                	ld	ra,8(sp)
ffffffffc020369a:	0141                	add	sp,sp,16
ffffffffc020369c:	8082                	ret
ffffffffc020369e:	00004697          	auipc	a3,0x4
ffffffffc02036a2:	b3a68693          	add	a3,a3,-1222 # ffffffffc02071d8 <default_pmm_manager+0x938>
ffffffffc02036a6:	00003617          	auipc	a2,0x3
ffffffffc02036aa:	b6260613          	add	a2,a2,-1182 # ffffffffc0206208 <commands+0x450>
ffffffffc02036ae:	04000593          	li	a1,64
ffffffffc02036b2:	00004517          	auipc	a0,0x4
ffffffffc02036b6:	b1650513          	add	a0,a0,-1258 # ffffffffc02071c8 <default_pmm_manager+0x928>
ffffffffc02036ba:	db9fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02036be <wait_queue_init>:
ffffffffc02036be:	e508                	sd	a0,8(a0)
ffffffffc02036c0:	e108                	sd	a0,0(a0)
ffffffffc02036c2:	8082                	ret

ffffffffc02036c4 <wait_queue_del>:
ffffffffc02036c4:	7198                	ld	a4,32(a1)
ffffffffc02036c6:	01858793          	add	a5,a1,24
ffffffffc02036ca:	00e78b63          	beq	a5,a4,ffffffffc02036e0 <wait_queue_del+0x1c>
ffffffffc02036ce:	6994                	ld	a3,16(a1)
ffffffffc02036d0:	00a69863          	bne	a3,a0,ffffffffc02036e0 <wait_queue_del+0x1c>
ffffffffc02036d4:	6d94                	ld	a3,24(a1)
ffffffffc02036d6:	e698                	sd	a4,8(a3)
ffffffffc02036d8:	e314                	sd	a3,0(a4)
ffffffffc02036da:	f19c                	sd	a5,32(a1)
ffffffffc02036dc:	ed9c                	sd	a5,24(a1)
ffffffffc02036de:	8082                	ret
ffffffffc02036e0:	1141                	add	sp,sp,-16
ffffffffc02036e2:	00004697          	auipc	a3,0x4
ffffffffc02036e6:	b5668693          	add	a3,a3,-1194 # ffffffffc0207238 <default_pmm_manager+0x998>
ffffffffc02036ea:	00003617          	auipc	a2,0x3
ffffffffc02036ee:	b1e60613          	add	a2,a2,-1250 # ffffffffc0206208 <commands+0x450>
ffffffffc02036f2:	45f1                	li	a1,28
ffffffffc02036f4:	00004517          	auipc	a0,0x4
ffffffffc02036f8:	b2c50513          	add	a0,a0,-1236 # ffffffffc0207220 <default_pmm_manager+0x980>
ffffffffc02036fc:	e406                	sd	ra,8(sp)
ffffffffc02036fe:	d75fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203702 <wait_queue_first>:
ffffffffc0203702:	651c                	ld	a5,8(a0)
ffffffffc0203704:	00f50563          	beq	a0,a5,ffffffffc020370e <wait_queue_first+0xc>
ffffffffc0203708:	fe878513          	add	a0,a5,-24
ffffffffc020370c:	8082                	ret
ffffffffc020370e:	4501                	li	a0,0
ffffffffc0203710:	8082                	ret

ffffffffc0203712 <wait_in_queue>:
ffffffffc0203712:	711c                	ld	a5,32(a0)
ffffffffc0203714:	0561                	add	a0,a0,24
ffffffffc0203716:	40a78533          	sub	a0,a5,a0
ffffffffc020371a:	00a03533          	snez	a0,a0
ffffffffc020371e:	8082                	ret

ffffffffc0203720 <wakeup_wait>:
ffffffffc0203720:	e689                	bnez	a3,ffffffffc020372a <wakeup_wait+0xa>
ffffffffc0203722:	6188                	ld	a0,0(a1)
ffffffffc0203724:	c590                	sw	a2,8(a1)
ffffffffc0203726:	2410106f          	j	ffffffffc0205166 <wakeup_proc>
ffffffffc020372a:	7198                	ld	a4,32(a1)
ffffffffc020372c:	01858793          	add	a5,a1,24
ffffffffc0203730:	00e78e63          	beq	a5,a4,ffffffffc020374c <wakeup_wait+0x2c>
ffffffffc0203734:	6994                	ld	a3,16(a1)
ffffffffc0203736:	00d51b63          	bne	a0,a3,ffffffffc020374c <wakeup_wait+0x2c>
ffffffffc020373a:	6d94                	ld	a3,24(a1)
ffffffffc020373c:	6188                	ld	a0,0(a1)
ffffffffc020373e:	e698                	sd	a4,8(a3)
ffffffffc0203740:	e314                	sd	a3,0(a4)
ffffffffc0203742:	f19c                	sd	a5,32(a1)
ffffffffc0203744:	ed9c                	sd	a5,24(a1)
ffffffffc0203746:	c590                	sw	a2,8(a1)
ffffffffc0203748:	21f0106f          	j	ffffffffc0205166 <wakeup_proc>
ffffffffc020374c:	1141                	add	sp,sp,-16
ffffffffc020374e:	00004697          	auipc	a3,0x4
ffffffffc0203752:	aea68693          	add	a3,a3,-1302 # ffffffffc0207238 <default_pmm_manager+0x998>
ffffffffc0203756:	00003617          	auipc	a2,0x3
ffffffffc020375a:	ab260613          	add	a2,a2,-1358 # ffffffffc0206208 <commands+0x450>
ffffffffc020375e:	45f1                	li	a1,28
ffffffffc0203760:	00004517          	auipc	a0,0x4
ffffffffc0203764:	ac050513          	add	a0,a0,-1344 # ffffffffc0207220 <default_pmm_manager+0x980>
ffffffffc0203768:	e406                	sd	ra,8(sp)
ffffffffc020376a:	d09fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020376e <wait_current_set>:
ffffffffc020376e:	00014797          	auipc	a5,0x14
ffffffffc0203772:	e6a7b783          	ld	a5,-406(a5) # ffffffffc02175d8 <current>
ffffffffc0203776:	c39d                	beqz	a5,ffffffffc020379c <wait_current_set+0x2e>
ffffffffc0203778:	01858713          	add	a4,a1,24
ffffffffc020377c:	800006b7          	lui	a3,0x80000
ffffffffc0203780:	ed98                	sd	a4,24(a1)
ffffffffc0203782:	e19c                	sd	a5,0(a1)
ffffffffc0203784:	c594                	sw	a3,8(a1)
ffffffffc0203786:	4685                	li	a3,1
ffffffffc0203788:	c394                	sw	a3,0(a5)
ffffffffc020378a:	0ec7a623          	sw	a2,236(a5)
ffffffffc020378e:	611c                	ld	a5,0(a0)
ffffffffc0203790:	e988                	sd	a0,16(a1)
ffffffffc0203792:	e118                	sd	a4,0(a0)
ffffffffc0203794:	e798                	sd	a4,8(a5)
ffffffffc0203796:	f188                	sd	a0,32(a1)
ffffffffc0203798:	ed9c                	sd	a5,24(a1)
ffffffffc020379a:	8082                	ret
ffffffffc020379c:	1141                	add	sp,sp,-16
ffffffffc020379e:	00004697          	auipc	a3,0x4
ffffffffc02037a2:	ada68693          	add	a3,a3,-1318 # ffffffffc0207278 <default_pmm_manager+0x9d8>
ffffffffc02037a6:	00003617          	auipc	a2,0x3
ffffffffc02037aa:	a6260613          	add	a2,a2,-1438 # ffffffffc0206208 <commands+0x450>
ffffffffc02037ae:	07400593          	li	a1,116
ffffffffc02037b2:	00004517          	auipc	a0,0x4
ffffffffc02037b6:	a6e50513          	add	a0,a0,-1426 # ffffffffc0207220 <default_pmm_manager+0x980>
ffffffffc02037ba:	e406                	sd	ra,8(sp)
ffffffffc02037bc:	cb7fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02037c0 <swapfs_init>:
ffffffffc02037c0:	1141                	add	sp,sp,-16
ffffffffc02037c2:	4505                	li	a0,1
ffffffffc02037c4:	e406                	sd	ra,8(sp)
ffffffffc02037c6:	e15fc0ef          	jal	ffffffffc02005da <ide_device_valid>
ffffffffc02037ca:	cd01                	beqz	a0,ffffffffc02037e2 <swapfs_init+0x22>
ffffffffc02037cc:	4505                	li	a0,1
ffffffffc02037ce:	e13fc0ef          	jal	ffffffffc02005e0 <ide_device_size>
ffffffffc02037d2:	60a2                	ld	ra,8(sp)
ffffffffc02037d4:	810d                	srl	a0,a0,0x3
ffffffffc02037d6:	00014797          	auipc	a5,0x14
ffffffffc02037da:	daa7bd23          	sd	a0,-582(a5) # ffffffffc0217590 <max_swap_offset>
ffffffffc02037de:	0141                	add	sp,sp,16
ffffffffc02037e0:	8082                	ret
ffffffffc02037e2:	00004617          	auipc	a2,0x4
ffffffffc02037e6:	aa660613          	add	a2,a2,-1370 # ffffffffc0207288 <default_pmm_manager+0x9e8>
ffffffffc02037ea:	45b5                	li	a1,13
ffffffffc02037ec:	00004517          	auipc	a0,0x4
ffffffffc02037f0:	abc50513          	add	a0,a0,-1348 # ffffffffc02072a8 <default_pmm_manager+0xa08>
ffffffffc02037f4:	c7ffc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02037f8 <swapfs_read>:
ffffffffc02037f8:	1141                	add	sp,sp,-16
ffffffffc02037fa:	e406                	sd	ra,8(sp)
ffffffffc02037fc:	00855793          	srl	a5,a0,0x8
ffffffffc0203800:	cbb1                	beqz	a5,ffffffffc0203854 <swapfs_read+0x5c>
ffffffffc0203802:	00014717          	auipc	a4,0x14
ffffffffc0203806:	d8e73703          	ld	a4,-626(a4) # ffffffffc0217590 <max_swap_offset>
ffffffffc020380a:	04e7f563          	bgeu	a5,a4,ffffffffc0203854 <swapfs_read+0x5c>
ffffffffc020380e:	00014717          	auipc	a4,0x14
ffffffffc0203812:	d7273703          	ld	a4,-654(a4) # ffffffffc0217580 <pages>
ffffffffc0203816:	8d99                	sub	a1,a1,a4
ffffffffc0203818:	4065d613          	sra	a2,a1,0x6
ffffffffc020381c:	00005717          	auipc	a4,0x5
ffffffffc0203820:	b9c73703          	ld	a4,-1124(a4) # ffffffffc02083b8 <nbase>
ffffffffc0203824:	963a                	add	a2,a2,a4
ffffffffc0203826:	00c61713          	sll	a4,a2,0xc
ffffffffc020382a:	8331                	srl	a4,a4,0xc
ffffffffc020382c:	00014697          	auipc	a3,0x14
ffffffffc0203830:	d4c6b683          	ld	a3,-692(a3) # ffffffffc0217578 <npage>
ffffffffc0203834:	0037959b          	sllw	a1,a5,0x3
ffffffffc0203838:	0632                	sll	a2,a2,0xc
ffffffffc020383a:	02d77963          	bgeu	a4,a3,ffffffffc020386c <swapfs_read+0x74>
ffffffffc020383e:	60a2                	ld	ra,8(sp)
ffffffffc0203840:	00014797          	auipc	a5,0x14
ffffffffc0203844:	d307b783          	ld	a5,-720(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc0203848:	46a1                	li	a3,8
ffffffffc020384a:	963e                	add	a2,a2,a5
ffffffffc020384c:	4505                	li	a0,1
ffffffffc020384e:	0141                	add	sp,sp,16
ffffffffc0203850:	d97fc06f          	j	ffffffffc02005e6 <ide_read_secs>
ffffffffc0203854:	86aa                	mv	a3,a0
ffffffffc0203856:	00004617          	auipc	a2,0x4
ffffffffc020385a:	a6a60613          	add	a2,a2,-1430 # ffffffffc02072c0 <default_pmm_manager+0xa20>
ffffffffc020385e:	45d1                	li	a1,20
ffffffffc0203860:	00004517          	auipc	a0,0x4
ffffffffc0203864:	a4850513          	add	a0,a0,-1464 # ffffffffc02072a8 <default_pmm_manager+0xa08>
ffffffffc0203868:	c0bfc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020386c:	86b2                	mv	a3,a2
ffffffffc020386e:	06900593          	li	a1,105
ffffffffc0203872:	00003617          	auipc	a2,0x3
ffffffffc0203876:	06660613          	add	a2,a2,102 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc020387a:	00003517          	auipc	a0,0x3
ffffffffc020387e:	08650513          	add	a0,a0,134 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0203882:	bf1fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203886 <swapfs_write>:
ffffffffc0203886:	1141                	add	sp,sp,-16
ffffffffc0203888:	e406                	sd	ra,8(sp)
ffffffffc020388a:	00855793          	srl	a5,a0,0x8
ffffffffc020388e:	cbb1                	beqz	a5,ffffffffc02038e2 <swapfs_write+0x5c>
ffffffffc0203890:	00014717          	auipc	a4,0x14
ffffffffc0203894:	d0073703          	ld	a4,-768(a4) # ffffffffc0217590 <max_swap_offset>
ffffffffc0203898:	04e7f563          	bgeu	a5,a4,ffffffffc02038e2 <swapfs_write+0x5c>
ffffffffc020389c:	00014717          	auipc	a4,0x14
ffffffffc02038a0:	ce473703          	ld	a4,-796(a4) # ffffffffc0217580 <pages>
ffffffffc02038a4:	8d99                	sub	a1,a1,a4
ffffffffc02038a6:	4065d613          	sra	a2,a1,0x6
ffffffffc02038aa:	00005717          	auipc	a4,0x5
ffffffffc02038ae:	b0e73703          	ld	a4,-1266(a4) # ffffffffc02083b8 <nbase>
ffffffffc02038b2:	963a                	add	a2,a2,a4
ffffffffc02038b4:	00c61713          	sll	a4,a2,0xc
ffffffffc02038b8:	8331                	srl	a4,a4,0xc
ffffffffc02038ba:	00014697          	auipc	a3,0x14
ffffffffc02038be:	cbe6b683          	ld	a3,-834(a3) # ffffffffc0217578 <npage>
ffffffffc02038c2:	0037959b          	sllw	a1,a5,0x3
ffffffffc02038c6:	0632                	sll	a2,a2,0xc
ffffffffc02038c8:	02d77963          	bgeu	a4,a3,ffffffffc02038fa <swapfs_write+0x74>
ffffffffc02038cc:	60a2                	ld	ra,8(sp)
ffffffffc02038ce:	00014797          	auipc	a5,0x14
ffffffffc02038d2:	ca27b783          	ld	a5,-862(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc02038d6:	46a1                	li	a3,8
ffffffffc02038d8:	963e                	add	a2,a2,a5
ffffffffc02038da:	4505                	li	a0,1
ffffffffc02038dc:	0141                	add	sp,sp,16
ffffffffc02038de:	d2dfc06f          	j	ffffffffc020060a <ide_write_secs>
ffffffffc02038e2:	86aa                	mv	a3,a0
ffffffffc02038e4:	00004617          	auipc	a2,0x4
ffffffffc02038e8:	9dc60613          	add	a2,a2,-1572 # ffffffffc02072c0 <default_pmm_manager+0xa20>
ffffffffc02038ec:	45e5                	li	a1,25
ffffffffc02038ee:	00004517          	auipc	a0,0x4
ffffffffc02038f2:	9ba50513          	add	a0,a0,-1606 # ffffffffc02072a8 <default_pmm_manager+0xa08>
ffffffffc02038f6:	b7dfc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02038fa:	86b2                	mv	a3,a2
ffffffffc02038fc:	06900593          	li	a1,105
ffffffffc0203900:	00003617          	auipc	a2,0x3
ffffffffc0203904:	fd860613          	add	a2,a2,-40 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0203908:	00003517          	auipc	a0,0x3
ffffffffc020390c:	ff850513          	add	a0,a0,-8 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0203910:	b63fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203914 <kernel_thread_entry>:
ffffffffc0203914:	8526                	mv	a0,s1
ffffffffc0203916:	9402                	jalr	s0
ffffffffc0203918:	616000ef          	jal	ffffffffc0203f2e <do_exit>

ffffffffc020391c <alloc_proc>:
ffffffffc020391c:	1141                	add	sp,sp,-16
ffffffffc020391e:	14800513          	li	a0,328
ffffffffc0203922:	e022                	sd	s0,0(sp)
ffffffffc0203924:	e406                	sd	ra,8(sp)
ffffffffc0203926:	8b8fe0ef          	jal	ffffffffc02019de <kmalloc>
ffffffffc020392a:	842a                	mv	s0,a0
ffffffffc020392c:	cd21                	beqz	a0,ffffffffc0203984 <alloc_proc+0x68>
ffffffffc020392e:	57fd                	li	a5,-1
ffffffffc0203930:	1782                	sll	a5,a5,0x20
ffffffffc0203932:	e11c                	sd	a5,0(a0)
ffffffffc0203934:	07000613          	li	a2,112
ffffffffc0203938:	4581                	li	a1,0
ffffffffc020393a:	00052423          	sw	zero,8(a0)
ffffffffc020393e:	00053823          	sd	zero,16(a0)
ffffffffc0203942:	00053c23          	sd	zero,24(a0)
ffffffffc0203946:	02053023          	sd	zero,32(a0)
ffffffffc020394a:	02053423          	sd	zero,40(a0)
ffffffffc020394e:	03050513          	add	a0,a0,48
ffffffffc0203952:	1d8020ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0203956:	00014797          	auipc	a5,0x14
ffffffffc020395a:	c0a7b783          	ld	a5,-1014(a5) # ffffffffc0217560 <boot_cr3>
ffffffffc020395e:	0a043023          	sd	zero,160(s0)
ffffffffc0203962:	f45c                	sd	a5,168(s0)
ffffffffc0203964:	0a042823          	sw	zero,176(s0)
ffffffffc0203968:	463d                	li	a2,15
ffffffffc020396a:	4581                	li	a1,0
ffffffffc020396c:	0b440513          	add	a0,s0,180
ffffffffc0203970:	1ba020ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0203974:	0e042623          	sw	zero,236(s0)
ffffffffc0203978:	0e043c23          	sd	zero,248(s0)
ffffffffc020397c:	10043023          	sd	zero,256(s0)
ffffffffc0203980:	0e043823          	sd	zero,240(s0)
ffffffffc0203984:	60a2                	ld	ra,8(sp)
ffffffffc0203986:	8522                	mv	a0,s0
ffffffffc0203988:	6402                	ld	s0,0(sp)
ffffffffc020398a:	0141                	add	sp,sp,16
ffffffffc020398c:	8082                	ret

ffffffffc020398e <forkret>:
ffffffffc020398e:	00014797          	auipc	a5,0x14
ffffffffc0203992:	c4a7b783          	ld	a5,-950(a5) # ffffffffc02175d8 <current>
ffffffffc0203996:	73c8                	ld	a0,160(a5)
ffffffffc0203998:	b7efd06f          	j	ffffffffc0200d16 <forkrets>

ffffffffc020399c <put_pgdir.isra.0>:
ffffffffc020399c:	1141                	add	sp,sp,-16
ffffffffc020399e:	e406                	sd	ra,8(sp)
ffffffffc02039a0:	c02007b7          	lui	a5,0xc0200
ffffffffc02039a4:	02f56e63          	bltu	a0,a5,ffffffffc02039e0 <put_pgdir.isra.0+0x44>
ffffffffc02039a8:	00014797          	auipc	a5,0x14
ffffffffc02039ac:	bc87b783          	ld	a5,-1080(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc02039b0:	8d1d                	sub	a0,a0,a5
ffffffffc02039b2:	8131                	srl	a0,a0,0xc
ffffffffc02039b4:	00014797          	auipc	a5,0x14
ffffffffc02039b8:	bc47b783          	ld	a5,-1084(a5) # ffffffffc0217578 <npage>
ffffffffc02039bc:	02f57f63          	bgeu	a0,a5,ffffffffc02039fa <put_pgdir.isra.0+0x5e>
ffffffffc02039c0:	00005797          	auipc	a5,0x5
ffffffffc02039c4:	9f87b783          	ld	a5,-1544(a5) # ffffffffc02083b8 <nbase>
ffffffffc02039c8:	60a2                	ld	ra,8(sp)
ffffffffc02039ca:	8d1d                	sub	a0,a0,a5
ffffffffc02039cc:	051a                	sll	a0,a0,0x6
ffffffffc02039ce:	00014797          	auipc	a5,0x14
ffffffffc02039d2:	bb27b783          	ld	a5,-1102(a5) # ffffffffc0217580 <pages>
ffffffffc02039d6:	4585                	li	a1,1
ffffffffc02039d8:	953e                	add	a0,a0,a5
ffffffffc02039da:	0141                	add	sp,sp,16
ffffffffc02039dc:	a44fe06f          	j	ffffffffc0201c20 <free_pages>
ffffffffc02039e0:	86aa                	mv	a3,a0
ffffffffc02039e2:	00003617          	auipc	a2,0x3
ffffffffc02039e6:	f6660613          	add	a2,a2,-154 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc02039ea:	06e00593          	li	a1,110
ffffffffc02039ee:	00003517          	auipc	a0,0x3
ffffffffc02039f2:	f1250513          	add	a0,a0,-238 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc02039f6:	a7dfc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02039fa:	00003617          	auipc	a2,0x3
ffffffffc02039fe:	f7660613          	add	a2,a2,-138 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc0203a02:	06200593          	li	a1,98
ffffffffc0203a06:	00003517          	auipc	a0,0x3
ffffffffc0203a0a:	efa50513          	add	a0,a0,-262 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0203a0e:	a65fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203a12 <set_proc_name>:
ffffffffc0203a12:	1101                	add	sp,sp,-32
ffffffffc0203a14:	e822                	sd	s0,16(sp)
ffffffffc0203a16:	0b450413          	add	s0,a0,180
ffffffffc0203a1a:	e426                	sd	s1,8(sp)
ffffffffc0203a1c:	4641                	li	a2,16
ffffffffc0203a1e:	84ae                	mv	s1,a1
ffffffffc0203a20:	8522                	mv	a0,s0
ffffffffc0203a22:	4581                	li	a1,0
ffffffffc0203a24:	ec06                	sd	ra,24(sp)
ffffffffc0203a26:	104020ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0203a2a:	8522                	mv	a0,s0
ffffffffc0203a2c:	6442                	ld	s0,16(sp)
ffffffffc0203a2e:	60e2                	ld	ra,24(sp)
ffffffffc0203a30:	85a6                	mv	a1,s1
ffffffffc0203a32:	64a2                	ld	s1,8(sp)
ffffffffc0203a34:	463d                	li	a2,15
ffffffffc0203a36:	6105                	add	sp,sp,32
ffffffffc0203a38:	1040206f          	j	ffffffffc0205b3c <memcpy>

ffffffffc0203a3c <proc_run>:
ffffffffc0203a3c:	7179                	add	sp,sp,-48
ffffffffc0203a3e:	ec4a                	sd	s2,24(sp)
ffffffffc0203a40:	00014917          	auipc	s2,0x14
ffffffffc0203a44:	b9890913          	add	s2,s2,-1128 # ffffffffc02175d8 <current>
ffffffffc0203a48:	f026                	sd	s1,32(sp)
ffffffffc0203a4a:	00093483          	ld	s1,0(s2)
ffffffffc0203a4e:	f406                	sd	ra,40(sp)
ffffffffc0203a50:	e84e                	sd	s3,16(sp)
ffffffffc0203a52:	02a48863          	beq	s1,a0,ffffffffc0203a82 <proc_run+0x46>
ffffffffc0203a56:	100027f3          	csrr	a5,sstatus
ffffffffc0203a5a:	8b89                	and	a5,a5,2
ffffffffc0203a5c:	4981                	li	s3,0
ffffffffc0203a5e:	ef9d                	bnez	a5,ffffffffc0203a9c <proc_run+0x60>
ffffffffc0203a60:	755c                	ld	a5,168(a0)
ffffffffc0203a62:	577d                	li	a4,-1
ffffffffc0203a64:	177e                	sll	a4,a4,0x3f
ffffffffc0203a66:	83b1                	srl	a5,a5,0xc
ffffffffc0203a68:	00a93023          	sd	a0,0(s2)
ffffffffc0203a6c:	8fd9                	or	a5,a5,a4
ffffffffc0203a6e:	18079073          	csrw	satp,a5
ffffffffc0203a72:	03050593          	add	a1,a0,48
ffffffffc0203a76:	03048513          	add	a0,s1,48
ffffffffc0203a7a:	13e010ef          	jal	ffffffffc0204bb8 <switch_to>
ffffffffc0203a7e:	00099863          	bnez	s3,ffffffffc0203a8e <proc_run+0x52>
ffffffffc0203a82:	70a2                	ld	ra,40(sp)
ffffffffc0203a84:	7482                	ld	s1,32(sp)
ffffffffc0203a86:	6962                	ld	s2,24(sp)
ffffffffc0203a88:	69c2                	ld	s3,16(sp)
ffffffffc0203a8a:	6145                	add	sp,sp,48
ffffffffc0203a8c:	8082                	ret
ffffffffc0203a8e:	70a2                	ld	ra,40(sp)
ffffffffc0203a90:	7482                	ld	s1,32(sp)
ffffffffc0203a92:	6962                	ld	s2,24(sp)
ffffffffc0203a94:	69c2                	ld	s3,16(sp)
ffffffffc0203a96:	6145                	add	sp,sp,48
ffffffffc0203a98:	b97fc06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0203a9c:	e42a                	sd	a0,8(sp)
ffffffffc0203a9e:	b97fc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203aa2:	6522                	ld	a0,8(sp)
ffffffffc0203aa4:	4985                	li	s3,1
ffffffffc0203aa6:	bf6d                	j	ffffffffc0203a60 <proc_run+0x24>

ffffffffc0203aa8 <find_proc>:
ffffffffc0203aa8:	6789                	lui	a5,0x2
ffffffffc0203aaa:	fff5071b          	addw	a4,a0,-1
ffffffffc0203aae:	17f9                	add	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc0203ab0:	04e7e163          	bltu	a5,a4,ffffffffc0203af2 <find_proc+0x4a>
ffffffffc0203ab4:	1141                	add	sp,sp,-16
ffffffffc0203ab6:	e022                	sd	s0,0(sp)
ffffffffc0203ab8:	45a9                	li	a1,10
ffffffffc0203aba:	842a                	mv	s0,a0
ffffffffc0203abc:	2501                	sext.w	a0,a0
ffffffffc0203abe:	e406                	sd	ra,8(sp)
ffffffffc0203ac0:	401010ef          	jal	ffffffffc02056c0 <hash32>
ffffffffc0203ac4:	02051793          	sll	a5,a0,0x20
ffffffffc0203ac8:	01c7d513          	srl	a0,a5,0x1c
ffffffffc0203acc:	00010797          	auipc	a5,0x10
ffffffffc0203ad0:	a3478793          	add	a5,a5,-1484 # ffffffffc0213500 <hash_list>
ffffffffc0203ad4:	953e                	add	a0,a0,a5
ffffffffc0203ad6:	87aa                	mv	a5,a0
ffffffffc0203ad8:	a029                	j	ffffffffc0203ae2 <find_proc+0x3a>
ffffffffc0203ada:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0203ade:	00870c63          	beq	a4,s0,ffffffffc0203af6 <find_proc+0x4e>
ffffffffc0203ae2:	679c                	ld	a5,8(a5)
ffffffffc0203ae4:	fef51be3          	bne	a0,a5,ffffffffc0203ada <find_proc+0x32>
ffffffffc0203ae8:	60a2                	ld	ra,8(sp)
ffffffffc0203aea:	6402                	ld	s0,0(sp)
ffffffffc0203aec:	4501                	li	a0,0
ffffffffc0203aee:	0141                	add	sp,sp,16
ffffffffc0203af0:	8082                	ret
ffffffffc0203af2:	4501                	li	a0,0
ffffffffc0203af4:	8082                	ret
ffffffffc0203af6:	60a2                	ld	ra,8(sp)
ffffffffc0203af8:	6402                	ld	s0,0(sp)
ffffffffc0203afa:	f2878513          	add	a0,a5,-216
ffffffffc0203afe:	0141                	add	sp,sp,16
ffffffffc0203b00:	8082                	ret

ffffffffc0203b02 <do_fork>:
ffffffffc0203b02:	7119                	add	sp,sp,-128
ffffffffc0203b04:	f0ca                	sd	s2,96(sp)
ffffffffc0203b06:	00014917          	auipc	s2,0x14
ffffffffc0203b0a:	aca90913          	add	s2,s2,-1334 # ffffffffc02175d0 <nr_process>
ffffffffc0203b0e:	00092703          	lw	a4,0(s2)
ffffffffc0203b12:	fc86                	sd	ra,120(sp)
ffffffffc0203b14:	f8a2                	sd	s0,112(sp)
ffffffffc0203b16:	f4a6                	sd	s1,104(sp)
ffffffffc0203b18:	ecce                	sd	s3,88(sp)
ffffffffc0203b1a:	e8d2                	sd	s4,80(sp)
ffffffffc0203b1c:	e4d6                	sd	s5,72(sp)
ffffffffc0203b1e:	e0da                	sd	s6,64(sp)
ffffffffc0203b20:	fc5e                	sd	s7,56(sp)
ffffffffc0203b22:	f862                	sd	s8,48(sp)
ffffffffc0203b24:	f466                	sd	s9,40(sp)
ffffffffc0203b26:	f06a                	sd	s10,32(sp)
ffffffffc0203b28:	ec6e                	sd	s11,24(sp)
ffffffffc0203b2a:	6785                	lui	a5,0x1
ffffffffc0203b2c:	32f75763          	bge	a4,a5,ffffffffc0203e5a <do_fork+0x358>
ffffffffc0203b30:	8a2a                	mv	s4,a0
ffffffffc0203b32:	89ae                	mv	s3,a1
ffffffffc0203b34:	8432                	mv	s0,a2
ffffffffc0203b36:	de7ff0ef          	jal	ffffffffc020391c <alloc_proc>
ffffffffc0203b3a:	84aa                	mv	s1,a0
ffffffffc0203b3c:	30050463          	beqz	a0,ffffffffc0203e44 <do_fork+0x342>
ffffffffc0203b40:	00014c17          	auipc	s8,0x14
ffffffffc0203b44:	a98c0c13          	add	s8,s8,-1384 # ffffffffc02175d8 <current>
ffffffffc0203b48:	000c3783          	ld	a5,0(s8)
ffffffffc0203b4c:	0ec7a703          	lw	a4,236(a5) # 10ec <kern_entry-0xffffffffc01fef14>
ffffffffc0203b50:	f11c                	sd	a5,32(a0)
ffffffffc0203b52:	32071263          	bnez	a4,ffffffffc0203e76 <do_fork+0x374>
ffffffffc0203b56:	4509                	li	a0,2
ffffffffc0203b58:	838fe0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0203b5c:	2e050163          	beqz	a0,ffffffffc0203e3e <do_fork+0x33c>
ffffffffc0203b60:	00014c97          	auipc	s9,0x14
ffffffffc0203b64:	a20c8c93          	add	s9,s9,-1504 # ffffffffc0217580 <pages>
ffffffffc0203b68:	000cb783          	ld	a5,0(s9)
ffffffffc0203b6c:	00014d17          	auipc	s10,0x14
ffffffffc0203b70:	a0cd0d13          	add	s10,s10,-1524 # ffffffffc0217578 <npage>
ffffffffc0203b74:	00005a97          	auipc	s5,0x5
ffffffffc0203b78:	844aba83          	ld	s5,-1980(s5) # ffffffffc02083b8 <nbase>
ffffffffc0203b7c:	40f506b3          	sub	a3,a0,a5
ffffffffc0203b80:	8699                	sra	a3,a3,0x6
ffffffffc0203b82:	5dfd                	li	s11,-1
ffffffffc0203b84:	000d3783          	ld	a5,0(s10)
ffffffffc0203b88:	96d6                	add	a3,a3,s5
ffffffffc0203b8a:	00cddd93          	srl	s11,s11,0xc
ffffffffc0203b8e:	01b6f733          	and	a4,a3,s11
ffffffffc0203b92:	06b2                	sll	a3,a3,0xc
ffffffffc0203b94:	32f77963          	bgeu	a4,a5,ffffffffc0203ec6 <do_fork+0x3c4>
ffffffffc0203b98:	000c3603          	ld	a2,0(s8)
ffffffffc0203b9c:	00014b17          	auipc	s6,0x14
ffffffffc0203ba0:	9d4b0b13          	add	s6,s6,-1580 # ffffffffc0217570 <va_pa_offset>
ffffffffc0203ba4:	000b3703          	ld	a4,0(s6)
ffffffffc0203ba8:	02863b83          	ld	s7,40(a2)
ffffffffc0203bac:	9736                	add	a4,a4,a3
ffffffffc0203bae:	e898                	sd	a4,16(s1)
ffffffffc0203bb0:	020b8863          	beqz	s7,ffffffffc0203be0 <do_fork+0xde>
ffffffffc0203bb4:	100a7a13          	and	s4,s4,256
ffffffffc0203bb8:	1c0a0563          	beqz	s4,ffffffffc0203d82 <do_fork+0x280>
ffffffffc0203bbc:	030ba703          	lw	a4,48(s7)
ffffffffc0203bc0:	018bb683          	ld	a3,24(s7)
ffffffffc0203bc4:	c0200637          	lui	a2,0xc0200
ffffffffc0203bc8:	2705                	addw	a4,a4,1
ffffffffc0203bca:	02eba823          	sw	a4,48(s7)
ffffffffc0203bce:	0374b423          	sd	s7,40(s1)
ffffffffc0203bd2:	2cc6e263          	bltu	a3,a2,ffffffffc0203e96 <do_fork+0x394>
ffffffffc0203bd6:	000b3783          	ld	a5,0(s6)
ffffffffc0203bda:	6898                	ld	a4,16(s1)
ffffffffc0203bdc:	8e9d                	sub	a3,a3,a5
ffffffffc0203bde:	f4d4                	sd	a3,168(s1)
ffffffffc0203be0:	6689                	lui	a3,0x2
ffffffffc0203be2:	ee068693          	add	a3,a3,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc0203be6:	96ba                	add	a3,a3,a4
ffffffffc0203be8:	8622                	mv	a2,s0
ffffffffc0203bea:	f0d4                	sd	a3,160(s1)
ffffffffc0203bec:	87b6                	mv	a5,a3
ffffffffc0203bee:	12040313          	add	t1,s0,288
ffffffffc0203bf2:	00063883          	ld	a7,0(a2) # ffffffffc0200000 <kern_entry>
ffffffffc0203bf6:	00863803          	ld	a6,8(a2)
ffffffffc0203bfa:	6a08                	ld	a0,16(a2)
ffffffffc0203bfc:	6e0c                	ld	a1,24(a2)
ffffffffc0203bfe:	0117b023          	sd	a7,0(a5)
ffffffffc0203c02:	0107b423          	sd	a6,8(a5)
ffffffffc0203c06:	eb88                	sd	a0,16(a5)
ffffffffc0203c08:	ef8c                	sd	a1,24(a5)
ffffffffc0203c0a:	02060613          	add	a2,a2,32
ffffffffc0203c0e:	02078793          	add	a5,a5,32
ffffffffc0203c12:	fe6610e3          	bne	a2,t1,ffffffffc0203bf2 <do_fork+0xf0>
ffffffffc0203c16:	0406b823          	sd	zero,80(a3)
ffffffffc0203c1a:	12098e63          	beqz	s3,ffffffffc0203d56 <do_fork+0x254>
ffffffffc0203c1e:	0136b823          	sd	s3,16(a3)
ffffffffc0203c22:	00000797          	auipc	a5,0x0
ffffffffc0203c26:	d6c78793          	add	a5,a5,-660 # ffffffffc020398e <forkret>
ffffffffc0203c2a:	f89c                	sd	a5,48(s1)
ffffffffc0203c2c:	fc94                	sd	a3,56(s1)
ffffffffc0203c2e:	100027f3          	csrr	a5,sstatus
ffffffffc0203c32:	8b89                	and	a5,a5,2
ffffffffc0203c34:	4981                	li	s3,0
ffffffffc0203c36:	14079263          	bnez	a5,ffffffffc0203d7a <do_fork+0x278>
ffffffffc0203c3a:	00008817          	auipc	a6,0x8
ffffffffc0203c3e:	45680813          	add	a6,a6,1110 # ffffffffc020c090 <last_pid.1>
ffffffffc0203c42:	00082783          	lw	a5,0(a6)
ffffffffc0203c46:	6709                	lui	a4,0x2
ffffffffc0203c48:	0017851b          	addw	a0,a5,1
ffffffffc0203c4c:	00a82023          	sw	a0,0(a6)
ffffffffc0203c50:	08e55d63          	bge	a0,a4,ffffffffc0203cea <do_fork+0x1e8>
ffffffffc0203c54:	00008317          	auipc	t1,0x8
ffffffffc0203c58:	43830313          	add	t1,t1,1080 # ffffffffc020c08c <next_safe.0>
ffffffffc0203c5c:	00032783          	lw	a5,0(t1)
ffffffffc0203c60:	00014417          	auipc	s0,0x14
ffffffffc0203c64:	8a040413          	add	s0,s0,-1888 # ffffffffc0217500 <proc_list>
ffffffffc0203c68:	08f55963          	bge	a0,a5,ffffffffc0203cfa <do_fork+0x1f8>
ffffffffc0203c6c:	c0c8                	sw	a0,4(s1)
ffffffffc0203c6e:	45a9                	li	a1,10
ffffffffc0203c70:	2501                	sext.w	a0,a0
ffffffffc0203c72:	24f010ef          	jal	ffffffffc02056c0 <hash32>
ffffffffc0203c76:	02051793          	sll	a5,a0,0x20
ffffffffc0203c7a:	01c7d513          	srl	a0,a5,0x1c
ffffffffc0203c7e:	00010797          	auipc	a5,0x10
ffffffffc0203c82:	88278793          	add	a5,a5,-1918 # ffffffffc0213500 <hash_list>
ffffffffc0203c86:	953e                	add	a0,a0,a5
ffffffffc0203c88:	650c                	ld	a1,8(a0)
ffffffffc0203c8a:	7094                	ld	a3,32(s1)
ffffffffc0203c8c:	0d848793          	add	a5,s1,216
ffffffffc0203c90:	e19c                	sd	a5,0(a1)
ffffffffc0203c92:	6410                	ld	a2,8(s0)
ffffffffc0203c94:	e51c                	sd	a5,8(a0)
ffffffffc0203c96:	7af8                	ld	a4,240(a3)
ffffffffc0203c98:	0c848793          	add	a5,s1,200
ffffffffc0203c9c:	f0ec                	sd	a1,224(s1)
ffffffffc0203c9e:	ece8                	sd	a0,216(s1)
ffffffffc0203ca0:	e21c                	sd	a5,0(a2)
ffffffffc0203ca2:	e41c                	sd	a5,8(s0)
ffffffffc0203ca4:	e8f0                	sd	a2,208(s1)
ffffffffc0203ca6:	e4e0                	sd	s0,200(s1)
ffffffffc0203ca8:	0e04bc23          	sd	zero,248(s1)
ffffffffc0203cac:	10e4b023          	sd	a4,256(s1)
ffffffffc0203cb0:	c311                	beqz	a4,ffffffffc0203cb4 <do_fork+0x1b2>
ffffffffc0203cb2:	ff64                	sd	s1,248(a4)
ffffffffc0203cb4:	00092783          	lw	a5,0(s2)
ffffffffc0203cb8:	fae4                	sd	s1,240(a3)
ffffffffc0203cba:	2785                	addw	a5,a5,1
ffffffffc0203cbc:	00f92023          	sw	a5,0(s2)
ffffffffc0203cc0:	18099463          	bnez	s3,ffffffffc0203e48 <do_fork+0x346>
ffffffffc0203cc4:	8526                	mv	a0,s1
ffffffffc0203cc6:	4a0010ef          	jal	ffffffffc0205166 <wakeup_proc>
ffffffffc0203cca:	40c8                	lw	a0,4(s1)
ffffffffc0203ccc:	70e6                	ld	ra,120(sp)
ffffffffc0203cce:	7446                	ld	s0,112(sp)
ffffffffc0203cd0:	74a6                	ld	s1,104(sp)
ffffffffc0203cd2:	7906                	ld	s2,96(sp)
ffffffffc0203cd4:	69e6                	ld	s3,88(sp)
ffffffffc0203cd6:	6a46                	ld	s4,80(sp)
ffffffffc0203cd8:	6aa6                	ld	s5,72(sp)
ffffffffc0203cda:	6b06                	ld	s6,64(sp)
ffffffffc0203cdc:	7be2                	ld	s7,56(sp)
ffffffffc0203cde:	7c42                	ld	s8,48(sp)
ffffffffc0203ce0:	7ca2                	ld	s9,40(sp)
ffffffffc0203ce2:	7d02                	ld	s10,32(sp)
ffffffffc0203ce4:	6de2                	ld	s11,24(sp)
ffffffffc0203ce6:	6109                	add	sp,sp,128
ffffffffc0203ce8:	8082                	ret
ffffffffc0203cea:	4785                	li	a5,1
ffffffffc0203cec:	00f82023          	sw	a5,0(a6)
ffffffffc0203cf0:	4505                	li	a0,1
ffffffffc0203cf2:	00008317          	auipc	t1,0x8
ffffffffc0203cf6:	39a30313          	add	t1,t1,922 # ffffffffc020c08c <next_safe.0>
ffffffffc0203cfa:	00014417          	auipc	s0,0x14
ffffffffc0203cfe:	80640413          	add	s0,s0,-2042 # ffffffffc0217500 <proc_list>
ffffffffc0203d02:	00843e03          	ld	t3,8(s0)
ffffffffc0203d06:	6789                	lui	a5,0x2
ffffffffc0203d08:	00f32023          	sw	a5,0(t1)
ffffffffc0203d0c:	86aa                	mv	a3,a0
ffffffffc0203d0e:	4581                	li	a1,0
ffffffffc0203d10:	028e0e63          	beq	t3,s0,ffffffffc0203d4c <do_fork+0x24a>
ffffffffc0203d14:	88ae                	mv	a7,a1
ffffffffc0203d16:	87f2                	mv	a5,t3
ffffffffc0203d18:	6609                	lui	a2,0x2
ffffffffc0203d1a:	a811                	j	ffffffffc0203d2e <do_fork+0x22c>
ffffffffc0203d1c:	00e6d663          	bge	a3,a4,ffffffffc0203d28 <do_fork+0x226>
ffffffffc0203d20:	00c75463          	bge	a4,a2,ffffffffc0203d28 <do_fork+0x226>
ffffffffc0203d24:	863a                	mv	a2,a4
ffffffffc0203d26:	4885                	li	a7,1
ffffffffc0203d28:	679c                	ld	a5,8(a5)
ffffffffc0203d2a:	00878d63          	beq	a5,s0,ffffffffc0203d44 <do_fork+0x242>
ffffffffc0203d2e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc0203d32:	fed715e3          	bne	a4,a3,ffffffffc0203d1c <do_fork+0x21a>
ffffffffc0203d36:	2685                	addw	a3,a3,1
ffffffffc0203d38:	10c6db63          	bge	a3,a2,ffffffffc0203e4e <do_fork+0x34c>
ffffffffc0203d3c:	679c                	ld	a5,8(a5)
ffffffffc0203d3e:	4585                	li	a1,1
ffffffffc0203d40:	fe8797e3          	bne	a5,s0,ffffffffc0203d2e <do_fork+0x22c>
ffffffffc0203d44:	00088463          	beqz	a7,ffffffffc0203d4c <do_fork+0x24a>
ffffffffc0203d48:	00c32023          	sw	a2,0(t1)
ffffffffc0203d4c:	d185                	beqz	a1,ffffffffc0203c6c <do_fork+0x16a>
ffffffffc0203d4e:	00d82023          	sw	a3,0(a6)
ffffffffc0203d52:	8536                	mv	a0,a3
ffffffffc0203d54:	bf21                	j	ffffffffc0203c6c <do_fork+0x16a>
ffffffffc0203d56:	6989                	lui	s3,0x2
ffffffffc0203d58:	edc98993          	add	s3,s3,-292 # 1edc <kern_entry-0xffffffffc01fe124>
ffffffffc0203d5c:	99ba                	add	s3,s3,a4
ffffffffc0203d5e:	0136b823          	sd	s3,16(a3)
ffffffffc0203d62:	00000797          	auipc	a5,0x0
ffffffffc0203d66:	c2c78793          	add	a5,a5,-980 # ffffffffc020398e <forkret>
ffffffffc0203d6a:	f89c                	sd	a5,48(s1)
ffffffffc0203d6c:	fc94                	sd	a3,56(s1)
ffffffffc0203d6e:	100027f3          	csrr	a5,sstatus
ffffffffc0203d72:	8b89                	and	a5,a5,2
ffffffffc0203d74:	4981                	li	s3,0
ffffffffc0203d76:	ec0782e3          	beqz	a5,ffffffffc0203c3a <do_fork+0x138>
ffffffffc0203d7a:	8bbfc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0203d7e:	4985                	li	s3,1
ffffffffc0203d80:	bd6d                	j	ffffffffc0203c3a <do_fork+0x138>
ffffffffc0203d82:	ec7fe0ef          	jal	ffffffffc0202c48 <mm_create>
ffffffffc0203d86:	e42a                	sd	a0,8(sp)
ffffffffc0203d88:	c541                	beqz	a0,ffffffffc0203e10 <do_fork+0x30e>
ffffffffc0203d8a:	4505                	li	a0,1
ffffffffc0203d8c:	e05fd0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc0203d90:	cd2d                	beqz	a0,ffffffffc0203e0a <do_fork+0x308>
ffffffffc0203d92:	000cb683          	ld	a3,0(s9)
ffffffffc0203d96:	000d3703          	ld	a4,0(s10)
ffffffffc0203d9a:	40d506b3          	sub	a3,a0,a3
ffffffffc0203d9e:	8699                	sra	a3,a3,0x6
ffffffffc0203da0:	96d6                	add	a3,a3,s5
ffffffffc0203da2:	01b6fdb3          	and	s11,a3,s11
ffffffffc0203da6:	06b2                	sll	a3,a3,0xc
ffffffffc0203da8:	10edff63          	bgeu	s11,a4,ffffffffc0203ec6 <do_fork+0x3c4>
ffffffffc0203dac:	000b3703          	ld	a4,0(s6)
ffffffffc0203db0:	6605                	lui	a2,0x1
ffffffffc0203db2:	00013597          	auipc	a1,0x13
ffffffffc0203db6:	7b65b583          	ld	a1,1974(a1) # ffffffffc0217568 <boot_pgdir>
ffffffffc0203dba:	00e68a33          	add	s4,a3,a4
ffffffffc0203dbe:	8552                	mv	a0,s4
ffffffffc0203dc0:	57d010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc0203dc4:	67a2                	ld	a5,8(sp)
ffffffffc0203dc6:	038b8d93          	add	s11,s7,56
ffffffffc0203dca:	856e                	mv	a0,s11
ffffffffc0203dcc:	0147bc23          	sd	s4,24(a5)
ffffffffc0203dd0:	8bdff0ef          	jal	ffffffffc020368c <down>
ffffffffc0203dd4:	000c3703          	ld	a4,0(s8)
ffffffffc0203dd8:	c701                	beqz	a4,ffffffffc0203de0 <do_fork+0x2de>
ffffffffc0203dda:	4358                	lw	a4,4(a4)
ffffffffc0203ddc:	04eba823          	sw	a4,80(s7)
ffffffffc0203de0:	6c22                	ld	s8,8(sp)
ffffffffc0203de2:	85de                	mv	a1,s7
ffffffffc0203de4:	8562                	mv	a0,s8
ffffffffc0203de6:	8c2ff0ef          	jal	ffffffffc0202ea8 <dup_mmap>
ffffffffc0203dea:	8a2a                	mv	s4,a0
ffffffffc0203dec:	856e                	mv	a0,s11
ffffffffc0203dee:	89dff0ef          	jal	ffffffffc020368a <up>
ffffffffc0203df2:	040ba823          	sw	zero,80(s7)
ffffffffc0203df6:	8be2                	mv	s7,s8
ffffffffc0203df8:	dc0a02e3          	beqz	s4,ffffffffc0203bbc <do_fork+0xba>
ffffffffc0203dfc:	6422                	ld	s0,8(sp)
ffffffffc0203dfe:	8522                	mv	a0,s0
ffffffffc0203e00:	940ff0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0203e04:	6c08                	ld	a0,24(s0)
ffffffffc0203e06:	b97ff0ef          	jal	ffffffffc020399c <put_pgdir.isra.0>
ffffffffc0203e0a:	6522                	ld	a0,8(sp)
ffffffffc0203e0c:	f9bfe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc0203e10:	6894                	ld	a3,16(s1)
ffffffffc0203e12:	c0200737          	lui	a4,0xc0200
ffffffffc0203e16:	08e6ec63          	bltu	a3,a4,ffffffffc0203eae <do_fork+0x3ac>
ffffffffc0203e1a:	000b3783          	ld	a5,0(s6)
ffffffffc0203e1e:	000d3703          	ld	a4,0(s10)
ffffffffc0203e22:	40f687b3          	sub	a5,a3,a5
ffffffffc0203e26:	83b1                	srl	a5,a5,0xc
ffffffffc0203e28:	02e7fb63          	bgeu	a5,a4,ffffffffc0203e5e <do_fork+0x35c>
ffffffffc0203e2c:	000cb503          	ld	a0,0(s9)
ffffffffc0203e30:	415787b3          	sub	a5,a5,s5
ffffffffc0203e34:	079a                	sll	a5,a5,0x6
ffffffffc0203e36:	4589                	li	a1,2
ffffffffc0203e38:	953e                	add	a0,a0,a5
ffffffffc0203e3a:	de7fd0ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc0203e3e:	8526                	mv	a0,s1
ffffffffc0203e40:	c3ffd0ef          	jal	ffffffffc0201a7e <kfree>
ffffffffc0203e44:	5571                	li	a0,-4
ffffffffc0203e46:	b559                	j	ffffffffc0203ccc <do_fork+0x1ca>
ffffffffc0203e48:	fe6fc0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0203e4c:	bda5                	j	ffffffffc0203cc4 <do_fork+0x1c2>
ffffffffc0203e4e:	6789                	lui	a5,0x2
ffffffffc0203e50:	00f6c363          	blt	a3,a5,ffffffffc0203e56 <do_fork+0x354>
ffffffffc0203e54:	4685                	li	a3,1
ffffffffc0203e56:	4585                	li	a1,1
ffffffffc0203e58:	bd65                	j	ffffffffc0203d10 <do_fork+0x20e>
ffffffffc0203e5a:	556d                	li	a0,-5
ffffffffc0203e5c:	bd85                	j	ffffffffc0203ccc <do_fork+0x1ca>
ffffffffc0203e5e:	00003617          	auipc	a2,0x3
ffffffffc0203e62:	b1260613          	add	a2,a2,-1262 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc0203e66:	06200593          	li	a1,98
ffffffffc0203e6a:	00003517          	auipc	a0,0x3
ffffffffc0203e6e:	a9650513          	add	a0,a0,-1386 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0203e72:	e00fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203e76:	00003697          	auipc	a3,0x3
ffffffffc0203e7a:	46a68693          	add	a3,a3,1130 # ffffffffc02072e0 <default_pmm_manager+0xa40>
ffffffffc0203e7e:	00002617          	auipc	a2,0x2
ffffffffc0203e82:	38a60613          	add	a2,a2,906 # ffffffffc0206208 <commands+0x450>
ffffffffc0203e86:	1a600593          	li	a1,422
ffffffffc0203e8a:	00003517          	auipc	a0,0x3
ffffffffc0203e8e:	47650513          	add	a0,a0,1142 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0203e92:	de0fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203e96:	00003617          	auipc	a2,0x3
ffffffffc0203e9a:	ab260613          	add	a2,a2,-1358 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc0203e9e:	15900593          	li	a1,345
ffffffffc0203ea2:	00003517          	auipc	a0,0x3
ffffffffc0203ea6:	45e50513          	add	a0,a0,1118 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0203eaa:	dc8fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203eae:	00003617          	auipc	a2,0x3
ffffffffc0203eb2:	a9a60613          	add	a2,a2,-1382 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc0203eb6:	06e00593          	li	a1,110
ffffffffc0203eba:	00003517          	auipc	a0,0x3
ffffffffc0203ebe:	a4650513          	add	a0,a0,-1466 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0203ec2:	db0fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0203ec6:	00003617          	auipc	a2,0x3
ffffffffc0203eca:	a1260613          	add	a2,a2,-1518 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc0203ece:	06900593          	li	a1,105
ffffffffc0203ed2:	00003517          	auipc	a0,0x3
ffffffffc0203ed6:	a2e50513          	add	a0,a0,-1490 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0203eda:	d98fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0203ede <kernel_thread>:
ffffffffc0203ede:	7129                	add	sp,sp,-320
ffffffffc0203ee0:	fa22                	sd	s0,304(sp)
ffffffffc0203ee2:	f626                	sd	s1,296(sp)
ffffffffc0203ee4:	f24a                	sd	s2,288(sp)
ffffffffc0203ee6:	84ae                	mv	s1,a1
ffffffffc0203ee8:	892a                	mv	s2,a0
ffffffffc0203eea:	8432                	mv	s0,a2
ffffffffc0203eec:	4581                	li	a1,0
ffffffffc0203eee:	12000613          	li	a2,288
ffffffffc0203ef2:	850a                	mv	a0,sp
ffffffffc0203ef4:	fe06                	sd	ra,312(sp)
ffffffffc0203ef6:	435010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0203efa:	e0ca                	sd	s2,64(sp)
ffffffffc0203efc:	e4a6                	sd	s1,72(sp)
ffffffffc0203efe:	100027f3          	csrr	a5,sstatus
ffffffffc0203f02:	edd7f793          	and	a5,a5,-291
ffffffffc0203f06:	1207e793          	or	a5,a5,288
ffffffffc0203f0a:	e23e                	sd	a5,256(sp)
ffffffffc0203f0c:	860a                	mv	a2,sp
ffffffffc0203f0e:	10046513          	or	a0,s0,256
ffffffffc0203f12:	00000797          	auipc	a5,0x0
ffffffffc0203f16:	a0278793          	add	a5,a5,-1534 # ffffffffc0203914 <kernel_thread_entry>
ffffffffc0203f1a:	4581                	li	a1,0
ffffffffc0203f1c:	e63e                	sd	a5,264(sp)
ffffffffc0203f1e:	be5ff0ef          	jal	ffffffffc0203b02 <do_fork>
ffffffffc0203f22:	70f2                	ld	ra,312(sp)
ffffffffc0203f24:	7452                	ld	s0,304(sp)
ffffffffc0203f26:	74b2                	ld	s1,296(sp)
ffffffffc0203f28:	7912                	ld	s2,288(sp)
ffffffffc0203f2a:	6131                	add	sp,sp,320
ffffffffc0203f2c:	8082                	ret

ffffffffc0203f2e <do_exit>:
ffffffffc0203f2e:	7179                	add	sp,sp,-48
ffffffffc0203f30:	f022                	sd	s0,32(sp)
ffffffffc0203f32:	00013417          	auipc	s0,0x13
ffffffffc0203f36:	6a640413          	add	s0,s0,1702 # ffffffffc02175d8 <current>
ffffffffc0203f3a:	601c                	ld	a5,0(s0)
ffffffffc0203f3c:	f406                	sd	ra,40(sp)
ffffffffc0203f3e:	ec26                	sd	s1,24(sp)
ffffffffc0203f40:	e84a                	sd	s2,16(sp)
ffffffffc0203f42:	e44e                	sd	s3,8(sp)
ffffffffc0203f44:	e052                	sd	s4,0(sp)
ffffffffc0203f46:	00013717          	auipc	a4,0x13
ffffffffc0203f4a:	6a273703          	ld	a4,1698(a4) # ffffffffc02175e8 <idleproc>
ffffffffc0203f4e:	0ce78c63          	beq	a5,a4,ffffffffc0204026 <do_exit+0xf8>
ffffffffc0203f52:	00013497          	auipc	s1,0x13
ffffffffc0203f56:	68e48493          	add	s1,s1,1678 # ffffffffc02175e0 <initproc>
ffffffffc0203f5a:	6098                	ld	a4,0(s1)
ffffffffc0203f5c:	0ee78c63          	beq	a5,a4,ffffffffc0204054 <do_exit+0x126>
ffffffffc0203f60:	0287b983          	ld	s3,40(a5)
ffffffffc0203f64:	892a                	mv	s2,a0
ffffffffc0203f66:	02098663          	beqz	s3,ffffffffc0203f92 <do_exit+0x64>
ffffffffc0203f6a:	00013797          	auipc	a5,0x13
ffffffffc0203f6e:	5f67b783          	ld	a5,1526(a5) # ffffffffc0217560 <boot_cr3>
ffffffffc0203f72:	577d                	li	a4,-1
ffffffffc0203f74:	177e                	sll	a4,a4,0x3f
ffffffffc0203f76:	83b1                	srl	a5,a5,0xc
ffffffffc0203f78:	8fd9                	or	a5,a5,a4
ffffffffc0203f7a:	18079073          	csrw	satp,a5
ffffffffc0203f7e:	0309a783          	lw	a5,48(s3)
ffffffffc0203f82:	fff7871b          	addw	a4,a5,-1
ffffffffc0203f86:	02e9a823          	sw	a4,48(s3)
ffffffffc0203f8a:	cb55                	beqz	a4,ffffffffc020403e <do_exit+0x110>
ffffffffc0203f8c:	601c                	ld	a5,0(s0)
ffffffffc0203f8e:	0207b423          	sd	zero,40(a5)
ffffffffc0203f92:	601c                	ld	a5,0(s0)
ffffffffc0203f94:	470d                	li	a4,3
ffffffffc0203f96:	c398                	sw	a4,0(a5)
ffffffffc0203f98:	0f27a423          	sw	s2,232(a5)
ffffffffc0203f9c:	100027f3          	csrr	a5,sstatus
ffffffffc0203fa0:	8b89                	and	a5,a5,2
ffffffffc0203fa2:	4a01                	li	s4,0
ffffffffc0203fa4:	e7e1                	bnez	a5,ffffffffc020406c <do_exit+0x13e>
ffffffffc0203fa6:	6018                	ld	a4,0(s0)
ffffffffc0203fa8:	800007b7          	lui	a5,0x80000
ffffffffc0203fac:	0785                	add	a5,a5,1 # ffffffff80000001 <kern_entry-0x401fffff>
ffffffffc0203fae:	7308                	ld	a0,32(a4)
ffffffffc0203fb0:	0ec52703          	lw	a4,236(a0)
ffffffffc0203fb4:	0cf70063          	beq	a4,a5,ffffffffc0204074 <do_exit+0x146>
ffffffffc0203fb8:	6018                	ld	a4,0(s0)
ffffffffc0203fba:	7b7c                	ld	a5,240(a4)
ffffffffc0203fbc:	c3a1                	beqz	a5,ffffffffc0203ffc <do_exit+0xce>
ffffffffc0203fbe:	800009b7          	lui	s3,0x80000
ffffffffc0203fc2:	490d                	li	s2,3
ffffffffc0203fc4:	0985                	add	s3,s3,1 # ffffffff80000001 <kern_entry-0x401fffff>
ffffffffc0203fc6:	a021                	j	ffffffffc0203fce <do_exit+0xa0>
ffffffffc0203fc8:	6018                	ld	a4,0(s0)
ffffffffc0203fca:	7b7c                	ld	a5,240(a4)
ffffffffc0203fcc:	cb85                	beqz	a5,ffffffffc0203ffc <do_exit+0xce>
ffffffffc0203fce:	1007b683          	ld	a3,256(a5)
ffffffffc0203fd2:	6088                	ld	a0,0(s1)
ffffffffc0203fd4:	fb74                	sd	a3,240(a4)
ffffffffc0203fd6:	7978                	ld	a4,240(a0)
ffffffffc0203fd8:	0e07bc23          	sd	zero,248(a5)
ffffffffc0203fdc:	10e7b023          	sd	a4,256(a5)
ffffffffc0203fe0:	c311                	beqz	a4,ffffffffc0203fe4 <do_exit+0xb6>
ffffffffc0203fe2:	ff7c                	sd	a5,248(a4)
ffffffffc0203fe4:	4398                	lw	a4,0(a5)
ffffffffc0203fe6:	f388                	sd	a0,32(a5)
ffffffffc0203fe8:	f97c                	sd	a5,240(a0)
ffffffffc0203fea:	fd271fe3          	bne	a4,s2,ffffffffc0203fc8 <do_exit+0x9a>
ffffffffc0203fee:	0ec52783          	lw	a5,236(a0)
ffffffffc0203ff2:	fd379be3          	bne	a5,s3,ffffffffc0203fc8 <do_exit+0x9a>
ffffffffc0203ff6:	170010ef          	jal	ffffffffc0205166 <wakeup_proc>
ffffffffc0203ffa:	b7f9                	j	ffffffffc0203fc8 <do_exit+0x9a>
ffffffffc0203ffc:	020a1263          	bnez	s4,ffffffffc0204020 <do_exit+0xf2>
ffffffffc0204000:	26a010ef          	jal	ffffffffc020526a <schedule>
ffffffffc0204004:	601c                	ld	a5,0(s0)
ffffffffc0204006:	00003617          	auipc	a2,0x3
ffffffffc020400a:	33260613          	add	a2,a2,818 # ffffffffc0207338 <default_pmm_manager+0xa98>
ffffffffc020400e:	1f900593          	li	a1,505
ffffffffc0204012:	43d4                	lw	a3,4(a5)
ffffffffc0204014:	00003517          	auipc	a0,0x3
ffffffffc0204018:	2ec50513          	add	a0,a0,748 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc020401c:	c56fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204020:	e0efc0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0204024:	bff1                	j	ffffffffc0204000 <do_exit+0xd2>
ffffffffc0204026:	00003617          	auipc	a2,0x3
ffffffffc020402a:	2f260613          	add	a2,a2,754 # ffffffffc0207318 <default_pmm_manager+0xa78>
ffffffffc020402e:	1cd00593          	li	a1,461
ffffffffc0204032:	00003517          	auipc	a0,0x3
ffffffffc0204036:	2ce50513          	add	a0,a0,718 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc020403a:	c38fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020403e:	854e                	mv	a0,s3
ffffffffc0204040:	f01fe0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0204044:	0189b503          	ld	a0,24(s3)
ffffffffc0204048:	955ff0ef          	jal	ffffffffc020399c <put_pgdir.isra.0>
ffffffffc020404c:	854e                	mv	a0,s3
ffffffffc020404e:	d59fe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc0204052:	bf2d                	j	ffffffffc0203f8c <do_exit+0x5e>
ffffffffc0204054:	00003617          	auipc	a2,0x3
ffffffffc0204058:	2d460613          	add	a2,a2,724 # ffffffffc0207328 <default_pmm_manager+0xa88>
ffffffffc020405c:	1d000593          	li	a1,464
ffffffffc0204060:	00003517          	auipc	a0,0x3
ffffffffc0204064:	2a050513          	add	a0,a0,672 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204068:	c0afc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020406c:	dc8fc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0204070:	4a05                	li	s4,1
ffffffffc0204072:	bf15                	j	ffffffffc0203fa6 <do_exit+0x78>
ffffffffc0204074:	0f2010ef          	jal	ffffffffc0205166 <wakeup_proc>
ffffffffc0204078:	b781                	j	ffffffffc0203fb8 <do_exit+0x8a>

ffffffffc020407a <do_wait.part.0>:
ffffffffc020407a:	715d                	add	sp,sp,-80
ffffffffc020407c:	f84a                	sd	s2,48(sp)
ffffffffc020407e:	f44e                	sd	s3,40(sp)
ffffffffc0204080:	80000937          	lui	s2,0x80000
ffffffffc0204084:	6989                	lui	s3,0x2
ffffffffc0204086:	fc26                	sd	s1,56(sp)
ffffffffc0204088:	f052                	sd	s4,32(sp)
ffffffffc020408a:	ec56                	sd	s5,24(sp)
ffffffffc020408c:	e85a                	sd	s6,16(sp)
ffffffffc020408e:	e45e                	sd	s7,8(sp)
ffffffffc0204090:	e486                	sd	ra,72(sp)
ffffffffc0204092:	e0a2                	sd	s0,64(sp)
ffffffffc0204094:	84aa                	mv	s1,a0
ffffffffc0204096:	8a2e                	mv	s4,a1
ffffffffc0204098:	00013b97          	auipc	s7,0x13
ffffffffc020409c:	540b8b93          	add	s7,s7,1344 # ffffffffc02175d8 <current>
ffffffffc02040a0:	00050b1b          	sext.w	s6,a0
ffffffffc02040a4:	fff50a9b          	addw	s5,a0,-1
ffffffffc02040a8:	19f9                	add	s3,s3,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02040aa:	0905                	add	s2,s2,1 # ffffffff80000001 <kern_entry-0x401fffff>
ffffffffc02040ac:	ccbd                	beqz	s1,ffffffffc020412a <do_wait.part.0+0xb0>
ffffffffc02040ae:	0359e863          	bltu	s3,s5,ffffffffc02040de <do_wait.part.0+0x64>
ffffffffc02040b2:	45a9                	li	a1,10
ffffffffc02040b4:	855a                	mv	a0,s6
ffffffffc02040b6:	60a010ef          	jal	ffffffffc02056c0 <hash32>
ffffffffc02040ba:	02051793          	sll	a5,a0,0x20
ffffffffc02040be:	01c7d513          	srl	a0,a5,0x1c
ffffffffc02040c2:	0000f797          	auipc	a5,0xf
ffffffffc02040c6:	43e78793          	add	a5,a5,1086 # ffffffffc0213500 <hash_list>
ffffffffc02040ca:	953e                	add	a0,a0,a5
ffffffffc02040cc:	842a                	mv	s0,a0
ffffffffc02040ce:	a029                	j	ffffffffc02040d8 <do_wait.part.0+0x5e>
ffffffffc02040d0:	f2c42783          	lw	a5,-212(s0)
ffffffffc02040d4:	02978163          	beq	a5,s1,ffffffffc02040f6 <do_wait.part.0+0x7c>
ffffffffc02040d8:	6400                	ld	s0,8(s0)
ffffffffc02040da:	fe851be3          	bne	a0,s0,ffffffffc02040d0 <do_wait.part.0+0x56>
ffffffffc02040de:	5579                	li	a0,-2
ffffffffc02040e0:	60a6                	ld	ra,72(sp)
ffffffffc02040e2:	6406                	ld	s0,64(sp)
ffffffffc02040e4:	74e2                	ld	s1,56(sp)
ffffffffc02040e6:	7942                	ld	s2,48(sp)
ffffffffc02040e8:	79a2                	ld	s3,40(sp)
ffffffffc02040ea:	7a02                	ld	s4,32(sp)
ffffffffc02040ec:	6ae2                	ld	s5,24(sp)
ffffffffc02040ee:	6b42                	ld	s6,16(sp)
ffffffffc02040f0:	6ba2                	ld	s7,8(sp)
ffffffffc02040f2:	6161                	add	sp,sp,80
ffffffffc02040f4:	8082                	ret
ffffffffc02040f6:	000bb683          	ld	a3,0(s7)
ffffffffc02040fa:	f4843783          	ld	a5,-184(s0)
ffffffffc02040fe:	fed790e3          	bne	a5,a3,ffffffffc02040de <do_wait.part.0+0x64>
ffffffffc0204102:	f2842703          	lw	a4,-216(s0)
ffffffffc0204106:	478d                	li	a5,3
ffffffffc0204108:	0ef70b63          	beq	a4,a5,ffffffffc02041fe <do_wait.part.0+0x184>
ffffffffc020410c:	4785                	li	a5,1
ffffffffc020410e:	c29c                	sw	a5,0(a3)
ffffffffc0204110:	0f26a623          	sw	s2,236(a3)
ffffffffc0204114:	156010ef          	jal	ffffffffc020526a <schedule>
ffffffffc0204118:	000bb783          	ld	a5,0(s7)
ffffffffc020411c:	0b07a783          	lw	a5,176(a5)
ffffffffc0204120:	8b85                	and	a5,a5,1
ffffffffc0204122:	d7c9                	beqz	a5,ffffffffc02040ac <do_wait.part.0+0x32>
ffffffffc0204124:	555d                	li	a0,-9
ffffffffc0204126:	e09ff0ef          	jal	ffffffffc0203f2e <do_exit>
ffffffffc020412a:	000bb683          	ld	a3,0(s7)
ffffffffc020412e:	7ae0                	ld	s0,240(a3)
ffffffffc0204130:	d45d                	beqz	s0,ffffffffc02040de <do_wait.part.0+0x64>
ffffffffc0204132:	470d                	li	a4,3
ffffffffc0204134:	a021                	j	ffffffffc020413c <do_wait.part.0+0xc2>
ffffffffc0204136:	10043403          	ld	s0,256(s0)
ffffffffc020413a:	d869                	beqz	s0,ffffffffc020410c <do_wait.part.0+0x92>
ffffffffc020413c:	401c                	lw	a5,0(s0)
ffffffffc020413e:	fee79ce3          	bne	a5,a4,ffffffffc0204136 <do_wait.part.0+0xbc>
ffffffffc0204142:	00013797          	auipc	a5,0x13
ffffffffc0204146:	4a67b783          	ld	a5,1190(a5) # ffffffffc02175e8 <idleproc>
ffffffffc020414a:	0c878963          	beq	a5,s0,ffffffffc020421c <do_wait.part.0+0x1a2>
ffffffffc020414e:	00013797          	auipc	a5,0x13
ffffffffc0204152:	4927b783          	ld	a5,1170(a5) # ffffffffc02175e0 <initproc>
ffffffffc0204156:	0cf40363          	beq	s0,a5,ffffffffc020421c <do_wait.part.0+0x1a2>
ffffffffc020415a:	000a0663          	beqz	s4,ffffffffc0204166 <do_wait.part.0+0xec>
ffffffffc020415e:	0e842783          	lw	a5,232(s0)
ffffffffc0204162:	00fa2023          	sw	a5,0(s4)
ffffffffc0204166:	100027f3          	csrr	a5,sstatus
ffffffffc020416a:	8b89                	and	a5,a5,2
ffffffffc020416c:	4601                	li	a2,0
ffffffffc020416e:	e7c1                	bnez	a5,ffffffffc02041f6 <do_wait.part.0+0x17c>
ffffffffc0204170:	6c74                	ld	a3,216(s0)
ffffffffc0204172:	7078                	ld	a4,224(s0)
ffffffffc0204174:	10043783          	ld	a5,256(s0)
ffffffffc0204178:	e698                	sd	a4,8(a3)
ffffffffc020417a:	e314                	sd	a3,0(a4)
ffffffffc020417c:	6474                	ld	a3,200(s0)
ffffffffc020417e:	6878                	ld	a4,208(s0)
ffffffffc0204180:	e698                	sd	a4,8(a3)
ffffffffc0204182:	e314                	sd	a3,0(a4)
ffffffffc0204184:	c399                	beqz	a5,ffffffffc020418a <do_wait.part.0+0x110>
ffffffffc0204186:	7c78                	ld	a4,248(s0)
ffffffffc0204188:	fff8                	sd	a4,248(a5)
ffffffffc020418a:	7c78                	ld	a4,248(s0)
ffffffffc020418c:	c335                	beqz	a4,ffffffffc02041f0 <do_wait.part.0+0x176>
ffffffffc020418e:	10f73023          	sd	a5,256(a4)
ffffffffc0204192:	00013717          	auipc	a4,0x13
ffffffffc0204196:	43e70713          	add	a4,a4,1086 # ffffffffc02175d0 <nr_process>
ffffffffc020419a:	431c                	lw	a5,0(a4)
ffffffffc020419c:	37fd                	addw	a5,a5,-1
ffffffffc020419e:	c31c                	sw	a5,0(a4)
ffffffffc02041a0:	e629                	bnez	a2,ffffffffc02041ea <do_wait.part.0+0x170>
ffffffffc02041a2:	6814                	ld	a3,16(s0)
ffffffffc02041a4:	c02007b7          	lui	a5,0xc0200
ffffffffc02041a8:	04f6ee63          	bltu	a3,a5,ffffffffc0204204 <do_wait.part.0+0x18a>
ffffffffc02041ac:	00013797          	auipc	a5,0x13
ffffffffc02041b0:	3c47b783          	ld	a5,964(a5) # ffffffffc0217570 <va_pa_offset>
ffffffffc02041b4:	8e9d                	sub	a3,a3,a5
ffffffffc02041b6:	82b1                	srl	a3,a3,0xc
ffffffffc02041b8:	00013797          	auipc	a5,0x13
ffffffffc02041bc:	3c07b783          	ld	a5,960(a5) # ffffffffc0217578 <npage>
ffffffffc02041c0:	06f6fa63          	bgeu	a3,a5,ffffffffc0204234 <do_wait.part.0+0x1ba>
ffffffffc02041c4:	00004797          	auipc	a5,0x4
ffffffffc02041c8:	1f47b783          	ld	a5,500(a5) # ffffffffc02083b8 <nbase>
ffffffffc02041cc:	8e9d                	sub	a3,a3,a5
ffffffffc02041ce:	069a                	sll	a3,a3,0x6
ffffffffc02041d0:	00013517          	auipc	a0,0x13
ffffffffc02041d4:	3b053503          	ld	a0,944(a0) # ffffffffc0217580 <pages>
ffffffffc02041d8:	9536                	add	a0,a0,a3
ffffffffc02041da:	4589                	li	a1,2
ffffffffc02041dc:	a45fd0ef          	jal	ffffffffc0201c20 <free_pages>
ffffffffc02041e0:	8522                	mv	a0,s0
ffffffffc02041e2:	89dfd0ef          	jal	ffffffffc0201a7e <kfree>
ffffffffc02041e6:	4501                	li	a0,0
ffffffffc02041e8:	bde5                	j	ffffffffc02040e0 <do_wait.part.0+0x66>
ffffffffc02041ea:	c44fc0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc02041ee:	bf55                	j	ffffffffc02041a2 <do_wait.part.0+0x128>
ffffffffc02041f0:	7018                	ld	a4,32(s0)
ffffffffc02041f2:	fb7c                	sd	a5,240(a4)
ffffffffc02041f4:	bf79                	j	ffffffffc0204192 <do_wait.part.0+0x118>
ffffffffc02041f6:	c3efc0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02041fa:	4605                	li	a2,1
ffffffffc02041fc:	bf95                	j	ffffffffc0204170 <do_wait.part.0+0xf6>
ffffffffc02041fe:	f2840413          	add	s0,s0,-216
ffffffffc0204202:	b781                	j	ffffffffc0204142 <do_wait.part.0+0xc8>
ffffffffc0204204:	00002617          	auipc	a2,0x2
ffffffffc0204208:	74460613          	add	a2,a2,1860 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc020420c:	06e00593          	li	a1,110
ffffffffc0204210:	00002517          	auipc	a0,0x2
ffffffffc0204214:	6f050513          	add	a0,a0,1776 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0204218:	a5afc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020421c:	00003617          	auipc	a2,0x3
ffffffffc0204220:	13c60613          	add	a2,a2,316 # ffffffffc0207358 <default_pmm_manager+0xab8>
ffffffffc0204224:	2f600593          	li	a1,758
ffffffffc0204228:	00003517          	auipc	a0,0x3
ffffffffc020422c:	0d850513          	add	a0,a0,216 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204230:	a42fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204234:	00002617          	auipc	a2,0x2
ffffffffc0204238:	73c60613          	add	a2,a2,1852 # ffffffffc0206970 <default_pmm_manager+0xd0>
ffffffffc020423c:	06200593          	li	a1,98
ffffffffc0204240:	00002517          	auipc	a0,0x2
ffffffffc0204244:	6c050513          	add	a0,a0,1728 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc0204248:	a2afc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc020424c <init_main>:
ffffffffc020424c:	1141                	add	sp,sp,-16
ffffffffc020424e:	e406                	sd	ra,8(sp)
ffffffffc0204250:	a11fd0ef          	jal	ffffffffc0201c60 <nr_free_pages>
ffffffffc0204254:	f86fd0ef          	jal	ffffffffc02019da <kallocated>
ffffffffc0204258:	00003517          	auipc	a0,0x3
ffffffffc020425c:	12050513          	add	a0,a0,288 # ffffffffc0207378 <default_pmm_manager+0xad8>
ffffffffc0204260:	f2bfb0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0204264:	94eff0ef          	jal	ffffffffc02033b2 <check_milk>
ffffffffc0204268:	a019                	j	ffffffffc020426e <init_main+0x22>
ffffffffc020426a:	000010ef          	jal	ffffffffc020526a <schedule>
ffffffffc020426e:	4581                	li	a1,0
ffffffffc0204270:	4501                	li	a0,0
ffffffffc0204272:	e09ff0ef          	jal	ffffffffc020407a <do_wait.part.0>
ffffffffc0204276:	d975                	beqz	a0,ffffffffc020426a <init_main+0x1e>
ffffffffc0204278:	00003517          	auipc	a0,0x3
ffffffffc020427c:	11850513          	add	a0,a0,280 # ffffffffc0207390 <default_pmm_manager+0xaf0>
ffffffffc0204280:	f0bfb0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0204284:	00013797          	auipc	a5,0x13
ffffffffc0204288:	35c7b783          	ld	a5,860(a5) # ffffffffc02175e0 <initproc>
ffffffffc020428c:	7bf8                	ld	a4,240(a5)
ffffffffc020428e:	e339                	bnez	a4,ffffffffc02042d4 <init_main+0x88>
ffffffffc0204290:	7ff8                	ld	a4,248(a5)
ffffffffc0204292:	e329                	bnez	a4,ffffffffc02042d4 <init_main+0x88>
ffffffffc0204294:	1007b703          	ld	a4,256(a5)
ffffffffc0204298:	ef15                	bnez	a4,ffffffffc02042d4 <init_main+0x88>
ffffffffc020429a:	00013697          	auipc	a3,0x13
ffffffffc020429e:	3366a683          	lw	a3,822(a3) # ffffffffc02175d0 <nr_process>
ffffffffc02042a2:	4709                	li	a4,2
ffffffffc02042a4:	08e69863          	bne	a3,a4,ffffffffc0204334 <init_main+0xe8>
ffffffffc02042a8:	00013717          	auipc	a4,0x13
ffffffffc02042ac:	25870713          	add	a4,a4,600 # ffffffffc0217500 <proc_list>
ffffffffc02042b0:	6714                	ld	a3,8(a4)
ffffffffc02042b2:	0c878793          	add	a5,a5,200
ffffffffc02042b6:	04d79f63          	bne	a5,a3,ffffffffc0204314 <init_main+0xc8>
ffffffffc02042ba:	6318                	ld	a4,0(a4)
ffffffffc02042bc:	02e79c63          	bne	a5,a4,ffffffffc02042f4 <init_main+0xa8>
ffffffffc02042c0:	00003517          	auipc	a0,0x3
ffffffffc02042c4:	1b850513          	add	a0,a0,440 # ffffffffc0207478 <default_pmm_manager+0xbd8>
ffffffffc02042c8:	ec3fb0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc02042cc:	60a2                	ld	ra,8(sp)
ffffffffc02042ce:	4501                	li	a0,0
ffffffffc02042d0:	0141                	add	sp,sp,16
ffffffffc02042d2:	8082                	ret
ffffffffc02042d4:	00003697          	auipc	a3,0x3
ffffffffc02042d8:	0e468693          	add	a3,a3,228 # ffffffffc02073b8 <default_pmm_manager+0xb18>
ffffffffc02042dc:	00002617          	auipc	a2,0x2
ffffffffc02042e0:	f2c60613          	add	a2,a2,-212 # ffffffffc0206208 <commands+0x450>
ffffffffc02042e4:	36200593          	li	a1,866
ffffffffc02042e8:	00003517          	auipc	a0,0x3
ffffffffc02042ec:	01850513          	add	a0,a0,24 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc02042f0:	982fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02042f4:	00003697          	auipc	a3,0x3
ffffffffc02042f8:	15468693          	add	a3,a3,340 # ffffffffc0207448 <default_pmm_manager+0xba8>
ffffffffc02042fc:	00002617          	auipc	a2,0x2
ffffffffc0204300:	f0c60613          	add	a2,a2,-244 # ffffffffc0206208 <commands+0x450>
ffffffffc0204304:	36500593          	li	a1,869
ffffffffc0204308:	00003517          	auipc	a0,0x3
ffffffffc020430c:	ff850513          	add	a0,a0,-8 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204310:	962fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204314:	00003697          	auipc	a3,0x3
ffffffffc0204318:	10468693          	add	a3,a3,260 # ffffffffc0207418 <default_pmm_manager+0xb78>
ffffffffc020431c:	00002617          	auipc	a2,0x2
ffffffffc0204320:	eec60613          	add	a2,a2,-276 # ffffffffc0206208 <commands+0x450>
ffffffffc0204324:	36400593          	li	a1,868
ffffffffc0204328:	00003517          	auipc	a0,0x3
ffffffffc020432c:	fd850513          	add	a0,a0,-40 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204330:	942fc0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204334:	00003697          	auipc	a3,0x3
ffffffffc0204338:	0d468693          	add	a3,a3,212 # ffffffffc0207408 <default_pmm_manager+0xb68>
ffffffffc020433c:	00002617          	auipc	a2,0x2
ffffffffc0204340:	ecc60613          	add	a2,a2,-308 # ffffffffc0206208 <commands+0x450>
ffffffffc0204344:	36300593          	li	a1,867
ffffffffc0204348:	00003517          	auipc	a0,0x3
ffffffffc020434c:	fb850513          	add	a0,a0,-72 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204350:	922fc0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0204354 <do_execve>:
ffffffffc0204354:	7171                	add	sp,sp,-176
ffffffffc0204356:	e4ee                	sd	s11,72(sp)
ffffffffc0204358:	00013d97          	auipc	s11,0x13
ffffffffc020435c:	280d8d93          	add	s11,s11,640 # ffffffffc02175d8 <current>
ffffffffc0204360:	000db783          	ld	a5,0(s11)
ffffffffc0204364:	e54e                	sd	s3,136(sp)
ffffffffc0204366:	ed26                	sd	s1,152(sp)
ffffffffc0204368:	0287b983          	ld	s3,40(a5)
ffffffffc020436c:	e94a                	sd	s2,144(sp)
ffffffffc020436e:	fcd6                	sd	s5,120(sp)
ffffffffc0204370:	892a                	mv	s2,a0
ffffffffc0204372:	84ae                	mv	s1,a1
ffffffffc0204374:	8ab2                	mv	s5,a2
ffffffffc0204376:	4681                	li	a3,0
ffffffffc0204378:	862e                	mv	a2,a1
ffffffffc020437a:	85aa                	mv	a1,a0
ffffffffc020437c:	854e                	mv	a0,s3
ffffffffc020437e:	f506                	sd	ra,168(sp)
ffffffffc0204380:	f122                	sd	s0,160(sp)
ffffffffc0204382:	e152                	sd	s4,128(sp)
ffffffffc0204384:	f8da                	sd	s6,112(sp)
ffffffffc0204386:	f4de                	sd	s7,104(sp)
ffffffffc0204388:	f0e2                	sd	s8,96(sp)
ffffffffc020438a:	ece6                	sd	s9,88(sp)
ffffffffc020438c:	e8ea                	sd	s10,80(sp)
ffffffffc020438e:	d2dfe0ef          	jal	ffffffffc02030ba <user_mem_check>
ffffffffc0204392:	42050363          	beqz	a0,ffffffffc02047b8 <do_execve+0x464>
ffffffffc0204396:	4641                	li	a2,16
ffffffffc0204398:	4581                	li	a1,0
ffffffffc020439a:	1808                	add	a0,sp,48
ffffffffc020439c:	78e010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc02043a0:	47bd                	li	a5,15
ffffffffc02043a2:	8626                	mv	a2,s1
ffffffffc02043a4:	0e97e163          	bltu	a5,s1,ffffffffc0204486 <do_execve+0x132>
ffffffffc02043a8:	85ca                	mv	a1,s2
ffffffffc02043aa:	1808                	add	a0,sp,48
ffffffffc02043ac:	790010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc02043b0:	0e098263          	beqz	s3,ffffffffc0204494 <do_execve+0x140>
ffffffffc02043b4:	00003517          	auipc	a0,0x3
ffffffffc02043b8:	abc50513          	add	a0,a0,-1348 # ffffffffc0206e70 <default_pmm_manager+0x5d0>
ffffffffc02043bc:	e07fb0ef          	jal	ffffffffc02001c2 <cputs>
ffffffffc02043c0:	00013797          	auipc	a5,0x13
ffffffffc02043c4:	1a07b783          	ld	a5,416(a5) # ffffffffc0217560 <boot_cr3>
ffffffffc02043c8:	577d                	li	a4,-1
ffffffffc02043ca:	177e                	sll	a4,a4,0x3f
ffffffffc02043cc:	83b1                	srl	a5,a5,0xc
ffffffffc02043ce:	8fd9                	or	a5,a5,a4
ffffffffc02043d0:	18079073          	csrw	satp,a5
ffffffffc02043d4:	0309a783          	lw	a5,48(s3)
ffffffffc02043d8:	fff7871b          	addw	a4,a5,-1
ffffffffc02043dc:	02e9a823          	sw	a4,48(s3)
ffffffffc02043e0:	2a070c63          	beqz	a4,ffffffffc0204698 <do_execve+0x344>
ffffffffc02043e4:	000db783          	ld	a5,0(s11)
ffffffffc02043e8:	0207b423          	sd	zero,40(a5)
ffffffffc02043ec:	85dfe0ef          	jal	ffffffffc0202c48 <mm_create>
ffffffffc02043f0:	84aa                	mv	s1,a0
ffffffffc02043f2:	1c050a63          	beqz	a0,ffffffffc02045c6 <do_execve+0x272>
ffffffffc02043f6:	4505                	li	a0,1
ffffffffc02043f8:	f98fd0ef          	jal	ffffffffc0201b90 <alloc_pages>
ffffffffc02043fc:	3c050263          	beqz	a0,ffffffffc02047c0 <do_execve+0x46c>
ffffffffc0204400:	00013d17          	auipc	s10,0x13
ffffffffc0204404:	180d0d13          	add	s10,s10,384 # ffffffffc0217580 <pages>
ffffffffc0204408:	000d3783          	ld	a5,0(s10)
ffffffffc020440c:	00013c97          	auipc	s9,0x13
ffffffffc0204410:	16cc8c93          	add	s9,s9,364 # ffffffffc0217578 <npage>
ffffffffc0204414:	00004717          	auipc	a4,0x4
ffffffffc0204418:	fa473703          	ld	a4,-92(a4) # ffffffffc02083b8 <nbase>
ffffffffc020441c:	40f506b3          	sub	a3,a0,a5
ffffffffc0204420:	8699                	sra	a3,a3,0x6
ffffffffc0204422:	5bfd                	li	s7,-1
ffffffffc0204424:	000cb783          	ld	a5,0(s9)
ffffffffc0204428:	96ba                	add	a3,a3,a4
ffffffffc020442a:	e83a                	sd	a4,16(sp)
ffffffffc020442c:	00cbd713          	srl	a4,s7,0xc
ffffffffc0204430:	f03a                	sd	a4,32(sp)
ffffffffc0204432:	8f75                	and	a4,a4,a3
ffffffffc0204434:	06b2                	sll	a3,a3,0xc
ffffffffc0204436:	38f77963          	bgeu	a4,a5,ffffffffc02047c8 <do_execve+0x474>
ffffffffc020443a:	00013b17          	auipc	s6,0x13
ffffffffc020443e:	136b0b13          	add	s6,s6,310 # ffffffffc0217570 <va_pa_offset>
ffffffffc0204442:	000b3783          	ld	a5,0(s6)
ffffffffc0204446:	6605                	lui	a2,0x1
ffffffffc0204448:	00013597          	auipc	a1,0x13
ffffffffc020444c:	1205b583          	ld	a1,288(a1) # ffffffffc0217568 <boot_pgdir>
ffffffffc0204450:	00f689b3          	add	s3,a3,a5
ffffffffc0204454:	854e                	mv	a0,s3
ffffffffc0204456:	6e6010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc020445a:	000aa703          	lw	a4,0(s5)
ffffffffc020445e:	464c47b7          	lui	a5,0x464c4
ffffffffc0204462:	0134bc23          	sd	s3,24(s1)
ffffffffc0204466:	57f78793          	add	a5,a5,1407 # 464c457f <kern_entry-0xffffffff79d3ba81>
ffffffffc020446a:	020aba03          	ld	s4,32(s5)
ffffffffc020446e:	04f70363          	beq	a4,a5,ffffffffc02044b4 <do_execve+0x160>
ffffffffc0204472:	5961                	li	s2,-8
ffffffffc0204474:	854e                	mv	a0,s3
ffffffffc0204476:	d26ff0ef          	jal	ffffffffc020399c <put_pgdir.isra.0>
ffffffffc020447a:	8526                	mv	a0,s1
ffffffffc020447c:	92bfe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc0204480:	854a                	mv	a0,s2
ffffffffc0204482:	aadff0ef          	jal	ffffffffc0203f2e <do_exit>
ffffffffc0204486:	463d                	li	a2,15
ffffffffc0204488:	85ca                	mv	a1,s2
ffffffffc020448a:	1808                	add	a0,sp,48
ffffffffc020448c:	6b0010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc0204490:	f20992e3          	bnez	s3,ffffffffc02043b4 <do_execve+0x60>
ffffffffc0204494:	000db783          	ld	a5,0(s11)
ffffffffc0204498:	779c                	ld	a5,40(a5)
ffffffffc020449a:	dba9                	beqz	a5,ffffffffc02043ec <do_execve+0x98>
ffffffffc020449c:	00003617          	auipc	a2,0x3
ffffffffc02044a0:	ffc60613          	add	a2,a2,-4 # ffffffffc0207498 <default_pmm_manager+0xbf8>
ffffffffc02044a4:	20300593          	li	a1,515
ffffffffc02044a8:	00003517          	auipc	a0,0x3
ffffffffc02044ac:	e5850513          	add	a0,a0,-424 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc02044b0:	fc3fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02044b4:	038ad703          	lhu	a4,56(s5)
ffffffffc02044b8:	9a56                	add	s4,s4,s5
ffffffffc02044ba:	00371793          	sll	a5,a4,0x3
ffffffffc02044be:	8f99                	sub	a5,a5,a4
ffffffffc02044c0:	078e                	sll	a5,a5,0x3
ffffffffc02044c2:	97d2                	add	a5,a5,s4
ffffffffc02044c4:	f43e                	sd	a5,40(sp)
ffffffffc02044c6:	00fa7c63          	bgeu	s4,a5,ffffffffc02044de <do_execve+0x18a>
ffffffffc02044ca:	000a2783          	lw	a5,0(s4)
ffffffffc02044ce:	4705                	li	a4,1
ffffffffc02044d0:	0ee78d63          	beq	a5,a4,ffffffffc02045ca <do_execve+0x276>
ffffffffc02044d4:	77a2                	ld	a5,40(sp)
ffffffffc02044d6:	038a0a13          	add	s4,s4,56
ffffffffc02044da:	fefa68e3          	bltu	s4,a5,ffffffffc02044ca <do_execve+0x176>
ffffffffc02044de:	4701                	li	a4,0
ffffffffc02044e0:	46ad                	li	a3,11
ffffffffc02044e2:	00100637          	lui	a2,0x100
ffffffffc02044e6:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02044ea:	8526                	mv	a0,s1
ffffffffc02044ec:	90dfe0ef          	jal	ffffffffc0202df8 <mm_map>
ffffffffc02044f0:	892a                	mv	s2,a0
ffffffffc02044f2:	18051d63          	bnez	a0,ffffffffc020468c <do_execve+0x338>
ffffffffc02044f6:	6c88                	ld	a0,24(s1)
ffffffffc02044f8:	467d                	li	a2,31
ffffffffc02044fa:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02044fe:	85efe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204502:	34050b63          	beqz	a0,ffffffffc0204858 <do_execve+0x504>
ffffffffc0204506:	6c88                	ld	a0,24(s1)
ffffffffc0204508:	467d                	li	a2,31
ffffffffc020450a:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc020450e:	84efe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204512:	32050363          	beqz	a0,ffffffffc0204838 <do_execve+0x4e4>
ffffffffc0204516:	6c88                	ld	a0,24(s1)
ffffffffc0204518:	467d                	li	a2,31
ffffffffc020451a:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc020451e:	83efe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204522:	2e050b63          	beqz	a0,ffffffffc0204818 <do_execve+0x4c4>
ffffffffc0204526:	6c88                	ld	a0,24(s1)
ffffffffc0204528:	467d                	li	a2,31
ffffffffc020452a:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc020452e:	82efe0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204532:	2c050363          	beqz	a0,ffffffffc02047f8 <do_execve+0x4a4>
ffffffffc0204536:	589c                	lw	a5,48(s1)
ffffffffc0204538:	000db603          	ld	a2,0(s11)
ffffffffc020453c:	6c94                	ld	a3,24(s1)
ffffffffc020453e:	2785                	addw	a5,a5,1
ffffffffc0204540:	d89c                	sw	a5,48(s1)
ffffffffc0204542:	f604                	sd	s1,40(a2)
ffffffffc0204544:	c02007b7          	lui	a5,0xc0200
ffffffffc0204548:	28f6ec63          	bltu	a3,a5,ffffffffc02047e0 <do_execve+0x48c>
ffffffffc020454c:	000b3783          	ld	a5,0(s6)
ffffffffc0204550:	577d                	li	a4,-1
ffffffffc0204552:	177e                	sll	a4,a4,0x3f
ffffffffc0204554:	8e9d                	sub	a3,a3,a5
ffffffffc0204556:	00c6d793          	srl	a5,a3,0xc
ffffffffc020455a:	f654                	sd	a3,168(a2)
ffffffffc020455c:	8fd9                	or	a5,a5,a4
ffffffffc020455e:	18079073          	csrw	satp,a5
ffffffffc0204562:	7240                	ld	s0,160(a2)
ffffffffc0204564:	4581                	li	a1,0
ffffffffc0204566:	12000613          	li	a2,288
ffffffffc020456a:	8522                	mv	a0,s0
ffffffffc020456c:	10043983          	ld	s3,256(s0)
ffffffffc0204570:	5ba010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0204574:	000db483          	ld	s1,0(s11)
ffffffffc0204578:	018ab703          	ld	a4,24(s5)
ffffffffc020457c:	4785                	li	a5,1
ffffffffc020457e:	0b448493          	add	s1,s1,180
ffffffffc0204582:	07fe                	sll	a5,a5,0x1f
ffffffffc0204584:	edf9f993          	and	s3,s3,-289
ffffffffc0204588:	4641                	li	a2,16
ffffffffc020458a:	4581                	li	a1,0
ffffffffc020458c:	e81c                	sd	a5,16(s0)
ffffffffc020458e:	10e43423          	sd	a4,264(s0)
ffffffffc0204592:	11343023          	sd	s3,256(s0)
ffffffffc0204596:	8526                	mv	a0,s1
ffffffffc0204598:	592010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc020459c:	463d                	li	a2,15
ffffffffc020459e:	180c                	add	a1,sp,48
ffffffffc02045a0:	8526                	mv	a0,s1
ffffffffc02045a2:	59a010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc02045a6:	70aa                	ld	ra,168(sp)
ffffffffc02045a8:	740a                	ld	s0,160(sp)
ffffffffc02045aa:	64ea                	ld	s1,152(sp)
ffffffffc02045ac:	69aa                	ld	s3,136(sp)
ffffffffc02045ae:	6a0a                	ld	s4,128(sp)
ffffffffc02045b0:	7ae6                	ld	s5,120(sp)
ffffffffc02045b2:	7b46                	ld	s6,112(sp)
ffffffffc02045b4:	7ba6                	ld	s7,104(sp)
ffffffffc02045b6:	7c06                	ld	s8,96(sp)
ffffffffc02045b8:	6ce6                	ld	s9,88(sp)
ffffffffc02045ba:	6d46                	ld	s10,80(sp)
ffffffffc02045bc:	6da6                	ld	s11,72(sp)
ffffffffc02045be:	854a                	mv	a0,s2
ffffffffc02045c0:	694a                	ld	s2,144(sp)
ffffffffc02045c2:	614d                	add	sp,sp,176
ffffffffc02045c4:	8082                	ret
ffffffffc02045c6:	5971                	li	s2,-4
ffffffffc02045c8:	bd65                	j	ffffffffc0204480 <do_execve+0x12c>
ffffffffc02045ca:	028a3603          	ld	a2,40(s4)
ffffffffc02045ce:	020a3783          	ld	a5,32(s4)
ffffffffc02045d2:	1ef66963          	bltu	a2,a5,ffffffffc02047c4 <do_execve+0x470>
ffffffffc02045d6:	004a2783          	lw	a5,4(s4)
ffffffffc02045da:	0017f713          	and	a4,a5,1
ffffffffc02045de:	0027f593          	and	a1,a5,2
ffffffffc02045e2:	0027169b          	sllw	a3,a4,0x2
ffffffffc02045e6:	8b91                	and	a5,a5,4
ffffffffc02045e8:	070a                	sll	a4,a4,0x2
ffffffffc02045ea:	c1f1                	beqz	a1,ffffffffc02046ae <do_execve+0x35a>
ffffffffc02045ec:	1a079d63          	bnez	a5,ffffffffc02047a6 <do_execve+0x452>
ffffffffc02045f0:	0026e693          	or	a3,a3,2
ffffffffc02045f4:	47dd                	li	a5,23
ffffffffc02045f6:	2681                	sext.w	a3,a3
ffffffffc02045f8:	ec3e                	sd	a5,24(sp)
ffffffffc02045fa:	c709                	beqz	a4,ffffffffc0204604 <do_execve+0x2b0>
ffffffffc02045fc:	67e2                	ld	a5,24(sp)
ffffffffc02045fe:	0087e793          	or	a5,a5,8
ffffffffc0204602:	ec3e                	sd	a5,24(sp)
ffffffffc0204604:	010a3583          	ld	a1,16(s4)
ffffffffc0204608:	4701                	li	a4,0
ffffffffc020460a:	8526                	mv	a0,s1
ffffffffc020460c:	fecfe0ef          	jal	ffffffffc0202df8 <mm_map>
ffffffffc0204610:	892a                	mv	s2,a0
ffffffffc0204612:	ed2d                	bnez	a0,ffffffffc020468c <do_execve+0x338>
ffffffffc0204614:	010a3b83          	ld	s7,16(s4)
ffffffffc0204618:	020a3903          	ld	s2,32(s4)
ffffffffc020461c:	008a3983          	ld	s3,8(s4)
ffffffffc0204620:	77fd                	lui	a5,0xfffff
ffffffffc0204622:	995e                	add	s2,s2,s7
ffffffffc0204624:	00fbfc33          	and	s8,s7,a5
ffffffffc0204628:	99d6                	add	s3,s3,s5
ffffffffc020462a:	052be963          	bltu	s7,s2,ffffffffc020467c <do_execve+0x328>
ffffffffc020462e:	a279                	j	ffffffffc02047bc <do_execve+0x468>
ffffffffc0204630:	6785                	lui	a5,0x1
ffffffffc0204632:	418b8533          	sub	a0,s7,s8
ffffffffc0204636:	9c3e                	add	s8,s8,a5
ffffffffc0204638:	41790633          	sub	a2,s2,s7
ffffffffc020463c:	01896463          	bltu	s2,s8,ffffffffc0204644 <do_execve+0x2f0>
ffffffffc0204640:	417c0633          	sub	a2,s8,s7
ffffffffc0204644:	000d3683          	ld	a3,0(s10)
ffffffffc0204648:	67c2                	ld	a5,16(sp)
ffffffffc020464a:	000cb583          	ld	a1,0(s9)
ffffffffc020464e:	40d406b3          	sub	a3,s0,a3
ffffffffc0204652:	8699                	sra	a3,a3,0x6
ffffffffc0204654:	96be                	add	a3,a3,a5
ffffffffc0204656:	7782                	ld	a5,32(sp)
ffffffffc0204658:	00f6f833          	and	a6,a3,a5
ffffffffc020465c:	06b2                	sll	a3,a3,0xc
ffffffffc020465e:	16b87563          	bgeu	a6,a1,ffffffffc02047c8 <do_execve+0x474>
ffffffffc0204662:	000b3803          	ld	a6,0(s6)
ffffffffc0204666:	85ce                	mv	a1,s3
ffffffffc0204668:	9bb2                	add	s7,s7,a2
ffffffffc020466a:	96c2                	add	a3,a3,a6
ffffffffc020466c:	9536                	add	a0,a0,a3
ffffffffc020466e:	e432                	sd	a2,8(sp)
ffffffffc0204670:	4cc010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc0204674:	6622                	ld	a2,8(sp)
ffffffffc0204676:	99b2                	add	s3,s3,a2
ffffffffc0204678:	052bf063          	bgeu	s7,s2,ffffffffc02046b8 <do_execve+0x364>
ffffffffc020467c:	6c88                	ld	a0,24(s1)
ffffffffc020467e:	6662                	ld	a2,24(sp)
ffffffffc0204680:	85e2                	mv	a1,s8
ffffffffc0204682:	edbfd0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204686:	842a                	mv	s0,a0
ffffffffc0204688:	f545                	bnez	a0,ffffffffc0204630 <do_execve+0x2dc>
ffffffffc020468a:	5971                	li	s2,-4
ffffffffc020468c:	8526                	mv	a0,s1
ffffffffc020468e:	8b3fe0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc0204692:	0184b983          	ld	s3,24(s1)
ffffffffc0204696:	bbf9                	j	ffffffffc0204474 <do_execve+0x120>
ffffffffc0204698:	854e                	mv	a0,s3
ffffffffc020469a:	8a7fe0ef          	jal	ffffffffc0202f40 <exit_mmap>
ffffffffc020469e:	0189b503          	ld	a0,24(s3)
ffffffffc02046a2:	afaff0ef          	jal	ffffffffc020399c <put_pgdir.isra.0>
ffffffffc02046a6:	854e                	mv	a0,s3
ffffffffc02046a8:	efefe0ef          	jal	ffffffffc0202da6 <mm_destroy>
ffffffffc02046ac:	bb25                	j	ffffffffc02043e4 <do_execve+0x90>
ffffffffc02046ae:	e7f5                	bnez	a5,ffffffffc020479a <do_execve+0x446>
ffffffffc02046b0:	47c5                	li	a5,17
ffffffffc02046b2:	86ba                	mv	a3,a4
ffffffffc02046b4:	ec3e                	sd	a5,24(sp)
ffffffffc02046b6:	b791                	j	ffffffffc02045fa <do_execve+0x2a6>
ffffffffc02046b8:	010a3903          	ld	s2,16(s4)
ffffffffc02046bc:	028a3683          	ld	a3,40(s4)
ffffffffc02046c0:	9936                	add	s2,s2,a3
ffffffffc02046c2:	078bfa63          	bgeu	s7,s8,ffffffffc0204736 <do_execve+0x3e2>
ffffffffc02046c6:	e17907e3          	beq	s2,s7,ffffffffc02044d4 <do_execve+0x180>
ffffffffc02046ca:	6505                	lui	a0,0x1
ffffffffc02046cc:	955e                	add	a0,a0,s7
ffffffffc02046ce:	41850533          	sub	a0,a0,s8
ffffffffc02046d2:	417909b3          	sub	s3,s2,s7
ffffffffc02046d6:	0d897e63          	bgeu	s2,s8,ffffffffc02047b2 <do_execve+0x45e>
ffffffffc02046da:	000d3683          	ld	a3,0(s10)
ffffffffc02046de:	67c2                	ld	a5,16(sp)
ffffffffc02046e0:	000cb603          	ld	a2,0(s9)
ffffffffc02046e4:	40d406b3          	sub	a3,s0,a3
ffffffffc02046e8:	8699                	sra	a3,a3,0x6
ffffffffc02046ea:	96be                	add	a3,a3,a5
ffffffffc02046ec:	00c69593          	sll	a1,a3,0xc
ffffffffc02046f0:	81b1                	srl	a1,a1,0xc
ffffffffc02046f2:	06b2                	sll	a3,a3,0xc
ffffffffc02046f4:	0cc5fa63          	bgeu	a1,a2,ffffffffc02047c8 <do_execve+0x474>
ffffffffc02046f8:	000b3803          	ld	a6,0(s6)
ffffffffc02046fc:	864e                	mv	a2,s3
ffffffffc02046fe:	4581                	li	a1,0
ffffffffc0204700:	96c2                	add	a3,a3,a6
ffffffffc0204702:	9536                	add	a0,a0,a3
ffffffffc0204704:	426010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0204708:	9bce                	add	s7,s7,s3
ffffffffc020470a:	03897463          	bgeu	s2,s8,ffffffffc0204732 <do_execve+0x3de>
ffffffffc020470e:	dd7903e3          	beq	s2,s7,ffffffffc02044d4 <do_execve+0x180>
ffffffffc0204712:	00003697          	auipc	a3,0x3
ffffffffc0204716:	dae68693          	add	a3,a3,-594 # ffffffffc02074c0 <default_pmm_manager+0xc20>
ffffffffc020471a:	00002617          	auipc	a2,0x2
ffffffffc020471e:	aee60613          	add	a2,a2,-1298 # ffffffffc0206208 <commands+0x450>
ffffffffc0204722:	25800593          	li	a1,600
ffffffffc0204726:	00003517          	auipc	a0,0x3
ffffffffc020472a:	bda50513          	add	a0,a0,-1062 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc020472e:	d45fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204732:	ff7c10e3          	bne	s8,s7,ffffffffc0204712 <do_execve+0x3be>
ffffffffc0204736:	d92bffe3          	bgeu	s7,s2,ffffffffc02044d4 <do_execve+0x180>
ffffffffc020473a:	56fd                	li	a3,-1
ffffffffc020473c:	00c6d793          	srl	a5,a3,0xc
ffffffffc0204740:	6985                	lui	s3,0x1
ffffffffc0204742:	e43e                	sd	a5,8(sp)
ffffffffc0204744:	a099                	j	ffffffffc020478a <do_execve+0x436>
ffffffffc0204746:	418b8533          	sub	a0,s7,s8
ffffffffc020474a:	9c4e                	add	s8,s8,s3
ffffffffc020474c:	41790633          	sub	a2,s2,s7
ffffffffc0204750:	01896463          	bltu	s2,s8,ffffffffc0204758 <do_execve+0x404>
ffffffffc0204754:	417c0633          	sub	a2,s8,s7
ffffffffc0204758:	000d3683          	ld	a3,0(s10)
ffffffffc020475c:	67c2                	ld	a5,16(sp)
ffffffffc020475e:	000cb583          	ld	a1,0(s9)
ffffffffc0204762:	40d406b3          	sub	a3,s0,a3
ffffffffc0204766:	8699                	sra	a3,a3,0x6
ffffffffc0204768:	96be                	add	a3,a3,a5
ffffffffc020476a:	67a2                	ld	a5,8(sp)
ffffffffc020476c:	00f6f833          	and	a6,a3,a5
ffffffffc0204770:	06b2                	sll	a3,a3,0xc
ffffffffc0204772:	04b87b63          	bgeu	a6,a1,ffffffffc02047c8 <do_execve+0x474>
ffffffffc0204776:	000b3803          	ld	a6,0(s6)
ffffffffc020477a:	9bb2                	add	s7,s7,a2
ffffffffc020477c:	4581                	li	a1,0
ffffffffc020477e:	96c2                	add	a3,a3,a6
ffffffffc0204780:	9536                	add	a0,a0,a3
ffffffffc0204782:	3a8010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0204786:	d52bf7e3          	bgeu	s7,s2,ffffffffc02044d4 <do_execve+0x180>
ffffffffc020478a:	6c88                	ld	a0,24(s1)
ffffffffc020478c:	6662                	ld	a2,24(sp)
ffffffffc020478e:	85e2                	mv	a1,s8
ffffffffc0204790:	dcdfd0ef          	jal	ffffffffc020255c <pgdir_alloc_page>
ffffffffc0204794:	842a                	mv	s0,a0
ffffffffc0204796:	f945                	bnez	a0,ffffffffc0204746 <do_execve+0x3f2>
ffffffffc0204798:	bdcd                	j	ffffffffc020468a <do_execve+0x336>
ffffffffc020479a:	0016e693          	or	a3,a3,1
ffffffffc020479e:	47cd                	li	a5,19
ffffffffc02047a0:	2681                	sext.w	a3,a3
ffffffffc02047a2:	ec3e                	sd	a5,24(sp)
ffffffffc02047a4:	bd99                	j	ffffffffc02045fa <do_execve+0x2a6>
ffffffffc02047a6:	0036e693          	or	a3,a3,3
ffffffffc02047aa:	47dd                	li	a5,23
ffffffffc02047ac:	2681                	sext.w	a3,a3
ffffffffc02047ae:	ec3e                	sd	a5,24(sp)
ffffffffc02047b0:	b5a9                	j	ffffffffc02045fa <do_execve+0x2a6>
ffffffffc02047b2:	417c09b3          	sub	s3,s8,s7
ffffffffc02047b6:	b715                	j	ffffffffc02046da <do_execve+0x386>
ffffffffc02047b8:	5975                	li	s2,-3
ffffffffc02047ba:	b3f5                	j	ffffffffc02045a6 <do_execve+0x252>
ffffffffc02047bc:	895e                	mv	s2,s7
ffffffffc02047be:	bdfd                	j	ffffffffc02046bc <do_execve+0x368>
ffffffffc02047c0:	5971                	li	s2,-4
ffffffffc02047c2:	b965                	j	ffffffffc020447a <do_execve+0x126>
ffffffffc02047c4:	5961                	li	s2,-8
ffffffffc02047c6:	b5d9                	j	ffffffffc020468c <do_execve+0x338>
ffffffffc02047c8:	00002617          	auipc	a2,0x2
ffffffffc02047cc:	11060613          	add	a2,a2,272 # ffffffffc02068d8 <default_pmm_manager+0x38>
ffffffffc02047d0:	06900593          	li	a1,105
ffffffffc02047d4:	00002517          	auipc	a0,0x2
ffffffffc02047d8:	12c50513          	add	a0,a0,300 # ffffffffc0206900 <default_pmm_manager+0x60>
ffffffffc02047dc:	c97fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02047e0:	00002617          	auipc	a2,0x2
ffffffffc02047e4:	16860613          	add	a2,a2,360 # ffffffffc0206948 <default_pmm_manager+0xa8>
ffffffffc02047e8:	27300593          	li	a1,627
ffffffffc02047ec:	00003517          	auipc	a0,0x3
ffffffffc02047f0:	b1450513          	add	a0,a0,-1260 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc02047f4:	c7ffb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02047f8:	00003697          	auipc	a3,0x3
ffffffffc02047fc:	de068693          	add	a3,a3,-544 # ffffffffc02075d8 <default_pmm_manager+0xd38>
ffffffffc0204800:	00002617          	auipc	a2,0x2
ffffffffc0204804:	a0860613          	add	a2,a2,-1528 # ffffffffc0206208 <commands+0x450>
ffffffffc0204808:	26e00593          	li	a1,622
ffffffffc020480c:	00003517          	auipc	a0,0x3
ffffffffc0204810:	af450513          	add	a0,a0,-1292 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204814:	c5ffb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204818:	00003697          	auipc	a3,0x3
ffffffffc020481c:	d7868693          	add	a3,a3,-648 # ffffffffc0207590 <default_pmm_manager+0xcf0>
ffffffffc0204820:	00002617          	auipc	a2,0x2
ffffffffc0204824:	9e860613          	add	a2,a2,-1560 # ffffffffc0206208 <commands+0x450>
ffffffffc0204828:	26d00593          	li	a1,621
ffffffffc020482c:	00003517          	auipc	a0,0x3
ffffffffc0204830:	ad450513          	add	a0,a0,-1324 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204834:	c3ffb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204838:	00003697          	auipc	a3,0x3
ffffffffc020483c:	d1068693          	add	a3,a3,-752 # ffffffffc0207548 <default_pmm_manager+0xca8>
ffffffffc0204840:	00002617          	auipc	a2,0x2
ffffffffc0204844:	9c860613          	add	a2,a2,-1592 # ffffffffc0206208 <commands+0x450>
ffffffffc0204848:	26c00593          	li	a1,620
ffffffffc020484c:	00003517          	auipc	a0,0x3
ffffffffc0204850:	ab450513          	add	a0,a0,-1356 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204854:	c1ffb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204858:	00003697          	auipc	a3,0x3
ffffffffc020485c:	ca868693          	add	a3,a3,-856 # ffffffffc0207500 <default_pmm_manager+0xc60>
ffffffffc0204860:	00002617          	auipc	a2,0x2
ffffffffc0204864:	9a860613          	add	a2,a2,-1624 # ffffffffc0206208 <commands+0x450>
ffffffffc0204868:	26b00593          	li	a1,619
ffffffffc020486c:	00003517          	auipc	a0,0x3
ffffffffc0204870:	a9450513          	add	a0,a0,-1388 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204874:	bfffb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0204878 <do_yield>:
ffffffffc0204878:	00013797          	auipc	a5,0x13
ffffffffc020487c:	d607b783          	ld	a5,-672(a5) # ffffffffc02175d8 <current>
ffffffffc0204880:	4705                	li	a4,1
ffffffffc0204882:	ef98                	sd	a4,24(a5)
ffffffffc0204884:	4501                	li	a0,0
ffffffffc0204886:	8082                	ret

ffffffffc0204888 <do_wait>:
ffffffffc0204888:	1101                	add	sp,sp,-32
ffffffffc020488a:	e822                	sd	s0,16(sp)
ffffffffc020488c:	e426                	sd	s1,8(sp)
ffffffffc020488e:	00013797          	auipc	a5,0x13
ffffffffc0204892:	d4a7b783          	ld	a5,-694(a5) # ffffffffc02175d8 <current>
ffffffffc0204896:	ec06                	sd	ra,24(sp)
ffffffffc0204898:	779c                	ld	a5,40(a5)
ffffffffc020489a:	842e                	mv	s0,a1
ffffffffc020489c:	84aa                	mv	s1,a0
ffffffffc020489e:	c599                	beqz	a1,ffffffffc02048ac <do_wait+0x24>
ffffffffc02048a0:	4685                	li	a3,1
ffffffffc02048a2:	4611                	li	a2,4
ffffffffc02048a4:	853e                	mv	a0,a5
ffffffffc02048a6:	815fe0ef          	jal	ffffffffc02030ba <user_mem_check>
ffffffffc02048aa:	c909                	beqz	a0,ffffffffc02048bc <do_wait+0x34>
ffffffffc02048ac:	85a2                	mv	a1,s0
ffffffffc02048ae:	6442                	ld	s0,16(sp)
ffffffffc02048b0:	60e2                	ld	ra,24(sp)
ffffffffc02048b2:	8526                	mv	a0,s1
ffffffffc02048b4:	64a2                	ld	s1,8(sp)
ffffffffc02048b6:	6105                	add	sp,sp,32
ffffffffc02048b8:	fc2ff06f          	j	ffffffffc020407a <do_wait.part.0>
ffffffffc02048bc:	60e2                	ld	ra,24(sp)
ffffffffc02048be:	6442                	ld	s0,16(sp)
ffffffffc02048c0:	64a2                	ld	s1,8(sp)
ffffffffc02048c2:	5575                	li	a0,-3
ffffffffc02048c4:	6105                	add	sp,sp,32
ffffffffc02048c6:	8082                	ret

ffffffffc02048c8 <do_kill>:
ffffffffc02048c8:	6789                	lui	a5,0x2
ffffffffc02048ca:	fff5071b          	addw	a4,a0,-1
ffffffffc02048ce:	17f9                	add	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02048d0:	06e7e963          	bltu	a5,a4,ffffffffc0204942 <do_kill+0x7a>
ffffffffc02048d4:	1141                	add	sp,sp,-16
ffffffffc02048d6:	e022                	sd	s0,0(sp)
ffffffffc02048d8:	45a9                	li	a1,10
ffffffffc02048da:	842a                	mv	s0,a0
ffffffffc02048dc:	2501                	sext.w	a0,a0
ffffffffc02048de:	e406                	sd	ra,8(sp)
ffffffffc02048e0:	5e1000ef          	jal	ffffffffc02056c0 <hash32>
ffffffffc02048e4:	02051793          	sll	a5,a0,0x20
ffffffffc02048e8:	01c7d513          	srl	a0,a5,0x1c
ffffffffc02048ec:	0000f797          	auipc	a5,0xf
ffffffffc02048f0:	c1478793          	add	a5,a5,-1004 # ffffffffc0213500 <hash_list>
ffffffffc02048f4:	953e                	add	a0,a0,a5
ffffffffc02048f6:	87aa                	mv	a5,a0
ffffffffc02048f8:	a029                	j	ffffffffc0204902 <do_kill+0x3a>
ffffffffc02048fa:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02048fe:	00870a63          	beq	a4,s0,ffffffffc0204912 <do_kill+0x4a>
ffffffffc0204902:	679c                	ld	a5,8(a5)
ffffffffc0204904:	fef51be3          	bne	a0,a5,ffffffffc02048fa <do_kill+0x32>
ffffffffc0204908:	5575                	li	a0,-3
ffffffffc020490a:	60a2                	ld	ra,8(sp)
ffffffffc020490c:	6402                	ld	s0,0(sp)
ffffffffc020490e:	0141                	add	sp,sp,16
ffffffffc0204910:	8082                	ret
ffffffffc0204912:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204916:	555d                	li	a0,-9
ffffffffc0204918:	00177693          	and	a3,a4,1
ffffffffc020491c:	f6fd                	bnez	a3,ffffffffc020490a <do_kill+0x42>
ffffffffc020491e:	4bd4                	lw	a3,20(a5)
ffffffffc0204920:	00176713          	or	a4,a4,1
ffffffffc0204924:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0204928:	0006c763          	bltz	a3,ffffffffc0204936 <do_kill+0x6e>
ffffffffc020492c:	4501                	li	a0,0
ffffffffc020492e:	60a2                	ld	ra,8(sp)
ffffffffc0204930:	6402                	ld	s0,0(sp)
ffffffffc0204932:	0141                	add	sp,sp,16
ffffffffc0204934:	8082                	ret
ffffffffc0204936:	f2878513          	add	a0,a5,-216
ffffffffc020493a:	02d000ef          	jal	ffffffffc0205166 <wakeup_proc>
ffffffffc020493e:	4501                	li	a0,0
ffffffffc0204940:	b7fd                	j	ffffffffc020492e <do_kill+0x66>
ffffffffc0204942:	5575                	li	a0,-3
ffffffffc0204944:	8082                	ret

ffffffffc0204946 <proc_init>:
ffffffffc0204946:	1101                	add	sp,sp,-32
ffffffffc0204948:	e426                	sd	s1,8(sp)
ffffffffc020494a:	00013797          	auipc	a5,0x13
ffffffffc020494e:	bb678793          	add	a5,a5,-1098 # ffffffffc0217500 <proc_list>
ffffffffc0204952:	ec06                	sd	ra,24(sp)
ffffffffc0204954:	e822                	sd	s0,16(sp)
ffffffffc0204956:	e04a                	sd	s2,0(sp)
ffffffffc0204958:	0000f497          	auipc	s1,0xf
ffffffffc020495c:	ba848493          	add	s1,s1,-1112 # ffffffffc0213500 <hash_list>
ffffffffc0204960:	e79c                	sd	a5,8(a5)
ffffffffc0204962:	e39c                	sd	a5,0(a5)
ffffffffc0204964:	00013717          	auipc	a4,0x13
ffffffffc0204968:	b9c70713          	add	a4,a4,-1124 # ffffffffc0217500 <proc_list>
ffffffffc020496c:	87a6                	mv	a5,s1
ffffffffc020496e:	e79c                	sd	a5,8(a5)
ffffffffc0204970:	e39c                	sd	a5,0(a5)
ffffffffc0204972:	07c1                	add	a5,a5,16
ffffffffc0204974:	fef71de3          	bne	a4,a5,ffffffffc020496e <proc_init+0x28>
ffffffffc0204978:	fa5fe0ef          	jal	ffffffffc020391c <alloc_proc>
ffffffffc020497c:	00013917          	auipc	s2,0x13
ffffffffc0204980:	c6c90913          	add	s2,s2,-916 # ffffffffc02175e8 <idleproc>
ffffffffc0204984:	00a93023          	sd	a0,0(s2)
ffffffffc0204988:	10050063          	beqz	a0,ffffffffc0204a88 <proc_init+0x142>
ffffffffc020498c:	4789                	li	a5,2
ffffffffc020498e:	e11c                	sd	a5,0(a0)
ffffffffc0204990:	00004797          	auipc	a5,0x4
ffffffffc0204994:	67078793          	add	a5,a5,1648 # ffffffffc0209000 <bootstack>
ffffffffc0204998:	0b450413          	add	s0,a0,180
ffffffffc020499c:	e91c                	sd	a5,16(a0)
ffffffffc020499e:	4785                	li	a5,1
ffffffffc02049a0:	ed1c                	sd	a5,24(a0)
ffffffffc02049a2:	4641                	li	a2,16
ffffffffc02049a4:	4581                	li	a1,0
ffffffffc02049a6:	8522                	mv	a0,s0
ffffffffc02049a8:	182010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc02049ac:	463d                	li	a2,15
ffffffffc02049ae:	00003597          	auipc	a1,0x3
ffffffffc02049b2:	c8a58593          	add	a1,a1,-886 # ffffffffc0207638 <default_pmm_manager+0xd98>
ffffffffc02049b6:	8522                	mv	a0,s0
ffffffffc02049b8:	184010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc02049bc:	00013717          	auipc	a4,0x13
ffffffffc02049c0:	c1470713          	add	a4,a4,-1004 # ffffffffc02175d0 <nr_process>
ffffffffc02049c4:	431c                	lw	a5,0(a4)
ffffffffc02049c6:	00093683          	ld	a3,0(s2)
ffffffffc02049ca:	4601                	li	a2,0
ffffffffc02049cc:	2785                	addw	a5,a5,1
ffffffffc02049ce:	4581                	li	a1,0
ffffffffc02049d0:	00000517          	auipc	a0,0x0
ffffffffc02049d4:	87c50513          	add	a0,a0,-1924 # ffffffffc020424c <init_main>
ffffffffc02049d8:	c31c                	sw	a5,0(a4)
ffffffffc02049da:	00013797          	auipc	a5,0x13
ffffffffc02049de:	bed7bf23          	sd	a3,-1026(a5) # ffffffffc02175d8 <current>
ffffffffc02049e2:	cfcff0ef          	jal	ffffffffc0203ede <kernel_thread>
ffffffffc02049e6:	842a                	mv	s0,a0
ffffffffc02049e8:	08a05463          	blez	a0,ffffffffc0204a70 <proc_init+0x12a>
ffffffffc02049ec:	6789                	lui	a5,0x2
ffffffffc02049ee:	fff5071b          	addw	a4,a0,-1
ffffffffc02049f2:	17f9                	add	a5,a5,-2 # 1ffe <kern_entry-0xffffffffc01fe002>
ffffffffc02049f4:	2501                	sext.w	a0,a0
ffffffffc02049f6:	02e7e463          	bltu	a5,a4,ffffffffc0204a1e <proc_init+0xd8>
ffffffffc02049fa:	45a9                	li	a1,10
ffffffffc02049fc:	4c5000ef          	jal	ffffffffc02056c0 <hash32>
ffffffffc0204a00:	02051713          	sll	a4,a0,0x20
ffffffffc0204a04:	01c75793          	srl	a5,a4,0x1c
ffffffffc0204a08:	00f486b3          	add	a3,s1,a5
ffffffffc0204a0c:	87b6                	mv	a5,a3
ffffffffc0204a0e:	a029                	j	ffffffffc0204a18 <proc_init+0xd2>
ffffffffc0204a10:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204a14:	04870b63          	beq	a4,s0,ffffffffc0204a6a <proc_init+0x124>
ffffffffc0204a18:	679c                	ld	a5,8(a5)
ffffffffc0204a1a:	fef69be3          	bne	a3,a5,ffffffffc0204a10 <proc_init+0xca>
ffffffffc0204a1e:	4781                	li	a5,0
ffffffffc0204a20:	0b478493          	add	s1,a5,180
ffffffffc0204a24:	4641                	li	a2,16
ffffffffc0204a26:	4581                	li	a1,0
ffffffffc0204a28:	00013417          	auipc	s0,0x13
ffffffffc0204a2c:	bb840413          	add	s0,s0,-1096 # ffffffffc02175e0 <initproc>
ffffffffc0204a30:	8526                	mv	a0,s1
ffffffffc0204a32:	e01c                	sd	a5,0(s0)
ffffffffc0204a34:	0f6010ef          	jal	ffffffffc0205b2a <memset>
ffffffffc0204a38:	463d                	li	a2,15
ffffffffc0204a3a:	00003597          	auipc	a1,0x3
ffffffffc0204a3e:	c2658593          	add	a1,a1,-986 # ffffffffc0207660 <default_pmm_manager+0xdc0>
ffffffffc0204a42:	8526                	mv	a0,s1
ffffffffc0204a44:	0f8010ef          	jal	ffffffffc0205b3c <memcpy>
ffffffffc0204a48:	00093783          	ld	a5,0(s2)
ffffffffc0204a4c:	cbb5                	beqz	a5,ffffffffc0204ac0 <proc_init+0x17a>
ffffffffc0204a4e:	43dc                	lw	a5,4(a5)
ffffffffc0204a50:	eba5                	bnez	a5,ffffffffc0204ac0 <proc_init+0x17a>
ffffffffc0204a52:	601c                	ld	a5,0(s0)
ffffffffc0204a54:	c7b1                	beqz	a5,ffffffffc0204aa0 <proc_init+0x15a>
ffffffffc0204a56:	43d8                	lw	a4,4(a5)
ffffffffc0204a58:	4785                	li	a5,1
ffffffffc0204a5a:	04f71363          	bne	a4,a5,ffffffffc0204aa0 <proc_init+0x15a>
ffffffffc0204a5e:	60e2                	ld	ra,24(sp)
ffffffffc0204a60:	6442                	ld	s0,16(sp)
ffffffffc0204a62:	64a2                	ld	s1,8(sp)
ffffffffc0204a64:	6902                	ld	s2,0(sp)
ffffffffc0204a66:	6105                	add	sp,sp,32
ffffffffc0204a68:	8082                	ret
ffffffffc0204a6a:	f2878793          	add	a5,a5,-216
ffffffffc0204a6e:	bf4d                	j	ffffffffc0204a20 <proc_init+0xda>
ffffffffc0204a70:	00003617          	auipc	a2,0x3
ffffffffc0204a74:	bd060613          	add	a2,a2,-1072 # ffffffffc0207640 <default_pmm_manager+0xda0>
ffffffffc0204a78:	38500593          	li	a1,901
ffffffffc0204a7c:	00003517          	auipc	a0,0x3
ffffffffc0204a80:	88450513          	add	a0,a0,-1916 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204a84:	9effb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204a88:	00003617          	auipc	a2,0x3
ffffffffc0204a8c:	b9860613          	add	a2,a2,-1128 # ffffffffc0207620 <default_pmm_manager+0xd80>
ffffffffc0204a90:	37700593          	li	a1,887
ffffffffc0204a94:	00003517          	auipc	a0,0x3
ffffffffc0204a98:	86c50513          	add	a0,a0,-1940 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204a9c:	9d7fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204aa0:	00003697          	auipc	a3,0x3
ffffffffc0204aa4:	bf068693          	add	a3,a3,-1040 # ffffffffc0207690 <default_pmm_manager+0xdf0>
ffffffffc0204aa8:	00001617          	auipc	a2,0x1
ffffffffc0204aac:	76060613          	add	a2,a2,1888 # ffffffffc0206208 <commands+0x450>
ffffffffc0204ab0:	38c00593          	li	a1,908
ffffffffc0204ab4:	00003517          	auipc	a0,0x3
ffffffffc0204ab8:	84c50513          	add	a0,a0,-1972 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204abc:	9b7fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0204ac0:	00003697          	auipc	a3,0x3
ffffffffc0204ac4:	ba868693          	add	a3,a3,-1112 # ffffffffc0207668 <default_pmm_manager+0xdc8>
ffffffffc0204ac8:	00001617          	auipc	a2,0x1
ffffffffc0204acc:	74060613          	add	a2,a2,1856 # ffffffffc0206208 <commands+0x450>
ffffffffc0204ad0:	38b00593          	li	a1,907
ffffffffc0204ad4:	00003517          	auipc	a0,0x3
ffffffffc0204ad8:	82c50513          	add	a0,a0,-2004 # ffffffffc0207300 <default_pmm_manager+0xa60>
ffffffffc0204adc:	997fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0204ae0 <cpu_idle>:
ffffffffc0204ae0:	1141                	add	sp,sp,-16
ffffffffc0204ae2:	e022                	sd	s0,0(sp)
ffffffffc0204ae4:	e406                	sd	ra,8(sp)
ffffffffc0204ae6:	00013417          	auipc	s0,0x13
ffffffffc0204aea:	af240413          	add	s0,s0,-1294 # ffffffffc02175d8 <current>
ffffffffc0204aee:	6018                	ld	a4,0(s0)
ffffffffc0204af0:	6f1c                	ld	a5,24(a4)
ffffffffc0204af2:	dffd                	beqz	a5,ffffffffc0204af0 <cpu_idle+0x10>
ffffffffc0204af4:	776000ef          	jal	ffffffffc020526a <schedule>
ffffffffc0204af8:	bfdd                	j	ffffffffc0204aee <cpu_idle+0xe>

ffffffffc0204afa <lab6_set_priority>:
ffffffffc0204afa:	1141                	add	sp,sp,-16
ffffffffc0204afc:	e022                	sd	s0,0(sp)
ffffffffc0204afe:	85aa                	mv	a1,a0
ffffffffc0204b00:	842a                	mv	s0,a0
ffffffffc0204b02:	00003517          	auipc	a0,0x3
ffffffffc0204b06:	bb650513          	add	a0,a0,-1098 # ffffffffc02076b8 <default_pmm_manager+0xe18>
ffffffffc0204b0a:	e406                	sd	ra,8(sp)
ffffffffc0204b0c:	e7efb0ef          	jal	ffffffffc020018a <cprintf>
ffffffffc0204b10:	00013797          	auipc	a5,0x13
ffffffffc0204b14:	ac87b783          	ld	a5,-1336(a5) # ffffffffc02175d8 <current>
ffffffffc0204b18:	e801                	bnez	s0,ffffffffc0204b28 <lab6_set_priority+0x2e>
ffffffffc0204b1a:	60a2                	ld	ra,8(sp)
ffffffffc0204b1c:	6402                	ld	s0,0(sp)
ffffffffc0204b1e:	4705                	li	a4,1
ffffffffc0204b20:	14e7a223          	sw	a4,324(a5)
ffffffffc0204b24:	0141                	add	sp,sp,16
ffffffffc0204b26:	8082                	ret
ffffffffc0204b28:	60a2                	ld	ra,8(sp)
ffffffffc0204b2a:	1487a223          	sw	s0,324(a5)
ffffffffc0204b2e:	6402                	ld	s0,0(sp)
ffffffffc0204b30:	0141                	add	sp,sp,16
ffffffffc0204b32:	8082                	ret

ffffffffc0204b34 <do_sleep>:
ffffffffc0204b34:	c539                	beqz	a0,ffffffffc0204b82 <do_sleep+0x4e>
ffffffffc0204b36:	7179                	add	sp,sp,-48
ffffffffc0204b38:	f022                	sd	s0,32(sp)
ffffffffc0204b3a:	f406                	sd	ra,40(sp)
ffffffffc0204b3c:	842a                	mv	s0,a0
ffffffffc0204b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0204b42:	8b89                	and	a5,a5,2
ffffffffc0204b44:	e3a9                	bnez	a5,ffffffffc0204b86 <do_sleep+0x52>
ffffffffc0204b46:	00013797          	auipc	a5,0x13
ffffffffc0204b4a:	a927b783          	ld	a5,-1390(a5) # ffffffffc02175d8 <current>
ffffffffc0204b4e:	0818                	add	a4,sp,16
ffffffffc0204b50:	c02a                	sw	a0,0(sp)
ffffffffc0204b52:	ec3a                	sd	a4,24(sp)
ffffffffc0204b54:	e83a                	sd	a4,16(sp)
ffffffffc0204b56:	e43e                	sd	a5,8(sp)
ffffffffc0204b58:	4705                	li	a4,1
ffffffffc0204b5a:	c398                	sw	a4,0(a5)
ffffffffc0204b5c:	80000737          	lui	a4,0x80000
ffffffffc0204b60:	840a                	mv	s0,sp
ffffffffc0204b62:	0709                	add	a4,a4,2 # ffffffff80000002 <kern_entry-0x401ffffe>
ffffffffc0204b64:	0ee7a623          	sw	a4,236(a5)
ffffffffc0204b68:	8522                	mv	a0,s0
ffffffffc0204b6a:	7c0000ef          	jal	ffffffffc020532a <add_timer>
ffffffffc0204b6e:	6fc000ef          	jal	ffffffffc020526a <schedule>
ffffffffc0204b72:	8522                	mv	a0,s0
ffffffffc0204b74:	07d000ef          	jal	ffffffffc02053f0 <del_timer>
ffffffffc0204b78:	70a2                	ld	ra,40(sp)
ffffffffc0204b7a:	7402                	ld	s0,32(sp)
ffffffffc0204b7c:	4501                	li	a0,0
ffffffffc0204b7e:	6145                	add	sp,sp,48
ffffffffc0204b80:	8082                	ret
ffffffffc0204b82:	4501                	li	a0,0
ffffffffc0204b84:	8082                	ret
ffffffffc0204b86:	aaffb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0204b8a:	00013797          	auipc	a5,0x13
ffffffffc0204b8e:	a4e7b783          	ld	a5,-1458(a5) # ffffffffc02175d8 <current>
ffffffffc0204b92:	0818                	add	a4,sp,16
ffffffffc0204b94:	c022                	sw	s0,0(sp)
ffffffffc0204b96:	e43e                	sd	a5,8(sp)
ffffffffc0204b98:	ec3a                	sd	a4,24(sp)
ffffffffc0204b9a:	e83a                	sd	a4,16(sp)
ffffffffc0204b9c:	4705                	li	a4,1
ffffffffc0204b9e:	c398                	sw	a4,0(a5)
ffffffffc0204ba0:	80000737          	lui	a4,0x80000
ffffffffc0204ba4:	0709                	add	a4,a4,2 # ffffffff80000002 <kern_entry-0x401ffffe>
ffffffffc0204ba6:	840a                	mv	s0,sp
ffffffffc0204ba8:	8522                	mv	a0,s0
ffffffffc0204baa:	0ee7a623          	sw	a4,236(a5)
ffffffffc0204bae:	77c000ef          	jal	ffffffffc020532a <add_timer>
ffffffffc0204bb2:	a7dfb0ef          	jal	ffffffffc020062e <intr_enable>
ffffffffc0204bb6:	bf65                	j	ffffffffc0204b6e <do_sleep+0x3a>

ffffffffc0204bb8 <switch_to>:
ffffffffc0204bb8:	00153023          	sd	ra,0(a0)
ffffffffc0204bbc:	00253423          	sd	sp,8(a0)
ffffffffc0204bc0:	e900                	sd	s0,16(a0)
ffffffffc0204bc2:	ed04                	sd	s1,24(a0)
ffffffffc0204bc4:	03253023          	sd	s2,32(a0)
ffffffffc0204bc8:	03353423          	sd	s3,40(a0)
ffffffffc0204bcc:	03453823          	sd	s4,48(a0)
ffffffffc0204bd0:	03553c23          	sd	s5,56(a0)
ffffffffc0204bd4:	05653023          	sd	s6,64(a0)
ffffffffc0204bd8:	05753423          	sd	s7,72(a0)
ffffffffc0204bdc:	05853823          	sd	s8,80(a0)
ffffffffc0204be0:	05953c23          	sd	s9,88(a0)
ffffffffc0204be4:	07a53023          	sd	s10,96(a0)
ffffffffc0204be8:	07b53423          	sd	s11,104(a0)
ffffffffc0204bec:	0005b083          	ld	ra,0(a1)
ffffffffc0204bf0:	0085b103          	ld	sp,8(a1)
ffffffffc0204bf4:	6980                	ld	s0,16(a1)
ffffffffc0204bf6:	6d84                	ld	s1,24(a1)
ffffffffc0204bf8:	0205b903          	ld	s2,32(a1)
ffffffffc0204bfc:	0285b983          	ld	s3,40(a1)
ffffffffc0204c00:	0305ba03          	ld	s4,48(a1)
ffffffffc0204c04:	0385ba83          	ld	s5,56(a1)
ffffffffc0204c08:	0405bb03          	ld	s6,64(a1)
ffffffffc0204c0c:	0485bb83          	ld	s7,72(a1)
ffffffffc0204c10:	0505bc03          	ld	s8,80(a1)
ffffffffc0204c14:	0585bc83          	ld	s9,88(a1)
ffffffffc0204c18:	0605bd03          	ld	s10,96(a1)
ffffffffc0204c1c:	0685bd83          	ld	s11,104(a1)
ffffffffc0204c20:	8082                	ret

ffffffffc0204c22 <stride_init>:
ffffffffc0204c22:	e508                	sd	a0,8(a0)
ffffffffc0204c24:	e108                	sd	a0,0(a0)
ffffffffc0204c26:	00053c23          	sd	zero,24(a0)
ffffffffc0204c2a:	00052823          	sw	zero,16(a0)
ffffffffc0204c2e:	8082                	ret

ffffffffc0204c30 <stride_pick_next>:
ffffffffc0204c30:	6d1c                	ld	a5,24(a0)
ffffffffc0204c32:	cf89                	beqz	a5,ffffffffc0204c4c <stride_pick_next+0x1c>
ffffffffc0204c34:	4fd0                	lw	a2,28(a5)
ffffffffc0204c36:	4f98                	lw	a4,24(a5)
ffffffffc0204c38:	ed878513          	add	a0,a5,-296
ffffffffc0204c3c:	400006b7          	lui	a3,0x40000
ffffffffc0204c40:	c219                	beqz	a2,ffffffffc0204c46 <stride_pick_next+0x16>
ffffffffc0204c42:	02c6d6bb          	divuw	a3,a3,a2
ffffffffc0204c46:	9f35                	addw	a4,a4,a3
ffffffffc0204c48:	cf98                	sw	a4,24(a5)
ffffffffc0204c4a:	8082                	ret
ffffffffc0204c4c:	4501                	li	a0,0
ffffffffc0204c4e:	8082                	ret

ffffffffc0204c50 <stride_proc_tick>:
ffffffffc0204c50:	1205a783          	lw	a5,288(a1)
ffffffffc0204c54:	00f05563          	blez	a5,ffffffffc0204c5e <stride_proc_tick+0xe>
ffffffffc0204c58:	37fd                	addw	a5,a5,-1
ffffffffc0204c5a:	12f5a023          	sw	a5,288(a1)
ffffffffc0204c5e:	e399                	bnez	a5,ffffffffc0204c64 <stride_proc_tick+0x14>
ffffffffc0204c60:	4785                	li	a5,1
ffffffffc0204c62:	ed9c                	sd	a5,24(a1)
ffffffffc0204c64:	8082                	ret

ffffffffc0204c66 <skew_heap_merge.constprop.0>:
ffffffffc0204c66:	7139                	add	sp,sp,-64
ffffffffc0204c68:	f822                	sd	s0,48(sp)
ffffffffc0204c6a:	fc06                	sd	ra,56(sp)
ffffffffc0204c6c:	f426                	sd	s1,40(sp)
ffffffffc0204c6e:	f04a                	sd	s2,32(sp)
ffffffffc0204c70:	ec4e                	sd	s3,24(sp)
ffffffffc0204c72:	e852                	sd	s4,16(sp)
ffffffffc0204c74:	e456                	sd	s5,8(sp)
ffffffffc0204c76:	e05a                	sd	s6,0(sp)
ffffffffc0204c78:	842e                	mv	s0,a1
ffffffffc0204c7a:	c52d                	beqz	a0,ffffffffc0204ce4 <skew_heap_merge.constprop.0+0x7e>
ffffffffc0204c7c:	892a                	mv	s2,a0
ffffffffc0204c7e:	cde1                	beqz	a1,ffffffffc0204d56 <skew_heap_merge.constprop.0+0xf0>
ffffffffc0204c80:	4d1c                	lw	a5,24(a0)
ffffffffc0204c82:	4d98                	lw	a4,24(a1)
ffffffffc0204c84:	40e786bb          	subw	a3,a5,a4
ffffffffc0204c88:	0606c963          	bltz	a3,ffffffffc0204cfa <skew_heap_merge.constprop.0+0x94>
ffffffffc0204c8c:	6984                	ld	s1,16(a1)
ffffffffc0204c8e:	0085ba03          	ld	s4,8(a1)
ffffffffc0204c92:	10048063          	beqz	s1,ffffffffc0204d92 <skew_heap_merge.constprop.0+0x12c>
ffffffffc0204c96:	4c98                	lw	a4,24(s1)
ffffffffc0204c98:	40e786bb          	subw	a3,a5,a4
ffffffffc0204c9c:	0a06cf63          	bltz	a3,ffffffffc0204d5a <skew_heap_merge.constprop.0+0xf4>
ffffffffc0204ca0:	0104b983          	ld	s3,16(s1)
ffffffffc0204ca4:	0084ba83          	ld	s5,8(s1)
ffffffffc0204ca8:	10098e63          	beqz	s3,ffffffffc0204dc4 <skew_heap_merge.constprop.0+0x15e>
ffffffffc0204cac:	0189a703          	lw	a4,24(s3) # 1018 <kern_entry-0xffffffffc01fefe8>
ffffffffc0204cb0:	9f99                	subw	a5,a5,a4
ffffffffc0204cb2:	0e07cc63          	bltz	a5,ffffffffc0204daa <skew_heap_merge.constprop.0+0x144>
ffffffffc0204cb6:	0109b583          	ld	a1,16(s3)
ffffffffc0204cba:	0089b903          	ld	s2,8(s3)
ffffffffc0204cbe:	fa9ff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204cc2:	00a9b423          	sd	a0,8(s3)
ffffffffc0204cc6:	0129b823          	sd	s2,16(s3)
ffffffffc0204cca:	c119                	beqz	a0,ffffffffc0204cd0 <skew_heap_merge.constprop.0+0x6a>
ffffffffc0204ccc:	01353023          	sd	s3,0(a0)
ffffffffc0204cd0:	0134b423          	sd	s3,8(s1)
ffffffffc0204cd4:	0154b823          	sd	s5,16(s1)
ffffffffc0204cd8:	0099b023          	sd	s1,0(s3)
ffffffffc0204cdc:	e404                	sd	s1,8(s0)
ffffffffc0204cde:	01443823          	sd	s4,16(s0)
ffffffffc0204ce2:	e080                	sd	s0,0(s1)
ffffffffc0204ce4:	8522                	mv	a0,s0
ffffffffc0204ce6:	70e2                	ld	ra,56(sp)
ffffffffc0204ce8:	7442                	ld	s0,48(sp)
ffffffffc0204cea:	74a2                	ld	s1,40(sp)
ffffffffc0204cec:	7902                	ld	s2,32(sp)
ffffffffc0204cee:	69e2                	ld	s3,24(sp)
ffffffffc0204cf0:	6a42                	ld	s4,16(sp)
ffffffffc0204cf2:	6aa2                	ld	s5,8(sp)
ffffffffc0204cf4:	6b02                	ld	s6,0(sp)
ffffffffc0204cf6:	6121                	add	sp,sp,64
ffffffffc0204cf8:	8082                	ret
ffffffffc0204cfa:	6904                	ld	s1,16(a0)
ffffffffc0204cfc:	00853a03          	ld	s4,8(a0)
ffffffffc0204d00:	c4a9                	beqz	s1,ffffffffc0204d4a <skew_heap_merge.constprop.0+0xe4>
ffffffffc0204d02:	4c9c                	lw	a5,24(s1)
ffffffffc0204d04:	40e7873b          	subw	a4,a5,a4
ffffffffc0204d08:	08074763          	bltz	a4,ffffffffc0204d96 <skew_heap_merge.constprop.0+0x130>
ffffffffc0204d0c:	0105b983          	ld	s3,16(a1)
ffffffffc0204d10:	0085ba83          	ld	s5,8(a1)
ffffffffc0204d14:	0c098563          	beqz	s3,ffffffffc0204dde <skew_heap_merge.constprop.0+0x178>
ffffffffc0204d18:	0189a703          	lw	a4,24(s3)
ffffffffc0204d1c:	9f99                	subw	a5,a5,a4
ffffffffc0204d1e:	0a07c563          	bltz	a5,ffffffffc0204dc8 <skew_heap_merge.constprop.0+0x162>
ffffffffc0204d22:	0109b583          	ld	a1,16(s3)
ffffffffc0204d26:	0089bb03          	ld	s6,8(s3)
ffffffffc0204d2a:	8526                	mv	a0,s1
ffffffffc0204d2c:	f3bff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204d30:	00a9b423          	sd	a0,8(s3)
ffffffffc0204d34:	0169b823          	sd	s6,16(s3)
ffffffffc0204d38:	c119                	beqz	a0,ffffffffc0204d3e <skew_heap_merge.constprop.0+0xd8>
ffffffffc0204d3a:	01353023          	sd	s3,0(a0)
ffffffffc0204d3e:	01343423          	sd	s3,8(s0)
ffffffffc0204d42:	01543823          	sd	s5,16(s0)
ffffffffc0204d46:	0089b023          	sd	s0,0(s3)
ffffffffc0204d4a:	00893423          	sd	s0,8(s2)
ffffffffc0204d4e:	01493823          	sd	s4,16(s2)
ffffffffc0204d52:	01243023          	sd	s2,0(s0)
ffffffffc0204d56:	854a                	mv	a0,s2
ffffffffc0204d58:	b779                	j	ffffffffc0204ce6 <skew_heap_merge.constprop.0+0x80>
ffffffffc0204d5a:	01053983          	ld	s3,16(a0)
ffffffffc0204d5e:	00853a83          	ld	s5,8(a0)
ffffffffc0204d62:	02098263          	beqz	s3,ffffffffc0204d86 <skew_heap_merge.constprop.0+0x120>
ffffffffc0204d66:	0189a783          	lw	a5,24(s3)
ffffffffc0204d6a:	9f99                	subw	a5,a5,a4
ffffffffc0204d6c:	0607cb63          	bltz	a5,ffffffffc0204de2 <skew_heap_merge.constprop.0+0x17c>
ffffffffc0204d70:	688c                	ld	a1,16(s1)
ffffffffc0204d72:	0084bb03          	ld	s6,8(s1)
ffffffffc0204d76:	854e                	mv	a0,s3
ffffffffc0204d78:	eefff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204d7c:	e488                	sd	a0,8(s1)
ffffffffc0204d7e:	0164b823          	sd	s6,16(s1)
ffffffffc0204d82:	c111                	beqz	a0,ffffffffc0204d86 <skew_heap_merge.constprop.0+0x120>
ffffffffc0204d84:	e104                	sd	s1,0(a0)
ffffffffc0204d86:	00993423          	sd	s1,8(s2)
ffffffffc0204d8a:	01593823          	sd	s5,16(s2)
ffffffffc0204d8e:	0124b023          	sd	s2,0(s1)
ffffffffc0204d92:	84ca                	mv	s1,s2
ffffffffc0204d94:	b7a1                	j	ffffffffc0204cdc <skew_heap_merge.constprop.0+0x76>
ffffffffc0204d96:	6888                	ld	a0,16(s1)
ffffffffc0204d98:	6480                	ld	s0,8(s1)
ffffffffc0204d9a:	ecdff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204d9e:	e488                	sd	a0,8(s1)
ffffffffc0204da0:	e880                	sd	s0,16(s1)
ffffffffc0204da2:	c111                	beqz	a0,ffffffffc0204da6 <skew_heap_merge.constprop.0+0x140>
ffffffffc0204da4:	e104                	sd	s1,0(a0)
ffffffffc0204da6:	8426                	mv	s0,s1
ffffffffc0204da8:	b74d                	j	ffffffffc0204d4a <skew_heap_merge.constprop.0+0xe4>
ffffffffc0204daa:	6908                	ld	a0,16(a0)
ffffffffc0204dac:	00893b03          	ld	s6,8(s2)
ffffffffc0204db0:	85ce                	mv	a1,s3
ffffffffc0204db2:	eb5ff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204db6:	00a93423          	sd	a0,8(s2)
ffffffffc0204dba:	01693823          	sd	s6,16(s2)
ffffffffc0204dbe:	c119                	beqz	a0,ffffffffc0204dc4 <skew_heap_merge.constprop.0+0x15e>
ffffffffc0204dc0:	01253023          	sd	s2,0(a0)
ffffffffc0204dc4:	89ca                	mv	s3,s2
ffffffffc0204dc6:	b729                	j	ffffffffc0204cd0 <skew_heap_merge.constprop.0+0x6a>
ffffffffc0204dc8:	6888                	ld	a0,16(s1)
ffffffffc0204dca:	0084bb03          	ld	s6,8(s1)
ffffffffc0204dce:	85ce                	mv	a1,s3
ffffffffc0204dd0:	e97ff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204dd4:	e488                	sd	a0,8(s1)
ffffffffc0204dd6:	0164b823          	sd	s6,16(s1)
ffffffffc0204dda:	c111                	beqz	a0,ffffffffc0204dde <skew_heap_merge.constprop.0+0x178>
ffffffffc0204ddc:	e104                	sd	s1,0(a0)
ffffffffc0204dde:	89a6                	mv	s3,s1
ffffffffc0204de0:	bfb9                	j	ffffffffc0204d3e <skew_heap_merge.constprop.0+0xd8>
ffffffffc0204de2:	0109b503          	ld	a0,16(s3)
ffffffffc0204de6:	0089bb03          	ld	s6,8(s3)
ffffffffc0204dea:	85a6                	mv	a1,s1
ffffffffc0204dec:	e7bff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204df0:	00a9b423          	sd	a0,8(s3)
ffffffffc0204df4:	0169b823          	sd	s6,16(s3)
ffffffffc0204df8:	c119                	beqz	a0,ffffffffc0204dfe <skew_heap_merge.constprop.0+0x198>
ffffffffc0204dfa:	01353023          	sd	s3,0(a0)
ffffffffc0204dfe:	84ce                	mv	s1,s3
ffffffffc0204e00:	b759                	j	ffffffffc0204d86 <skew_heap_merge.constprop.0+0x120>

ffffffffc0204e02 <stride_enqueue>:
ffffffffc0204e02:	7139                	add	sp,sp,-64
ffffffffc0204e04:	f04a                	sd	s2,32(sp)
ffffffffc0204e06:	01853903          	ld	s2,24(a0)
ffffffffc0204e0a:	f822                	sd	s0,48(sp)
ffffffffc0204e0c:	f426                	sd	s1,40(sp)
ffffffffc0204e0e:	fc06                	sd	ra,56(sp)
ffffffffc0204e10:	ec4e                	sd	s3,24(sp)
ffffffffc0204e12:	e852                	sd	s4,16(sp)
ffffffffc0204e14:	e456                	sd	s5,8(sp)
ffffffffc0204e16:	1205b423          	sd	zero,296(a1)
ffffffffc0204e1a:	1205bc23          	sd	zero,312(a1)
ffffffffc0204e1e:	1205b823          	sd	zero,304(a1)
ffffffffc0204e22:	842e                	mv	s0,a1
ffffffffc0204e24:	84aa                	mv	s1,a0
ffffffffc0204e26:	12858593          	add	a1,a1,296
ffffffffc0204e2a:	00090d63          	beqz	s2,ffffffffc0204e44 <stride_enqueue+0x42>
ffffffffc0204e2e:	14042703          	lw	a4,320(s0)
ffffffffc0204e32:	01892783          	lw	a5,24(s2)
ffffffffc0204e36:	9f99                	subw	a5,a5,a4
ffffffffc0204e38:	0207cd63          	bltz	a5,ffffffffc0204e72 <stride_enqueue+0x70>
ffffffffc0204e3c:	13243823          	sd	s2,304(s0)
ffffffffc0204e40:	00b93023          	sd	a1,0(s2)
ffffffffc0204e44:	12042783          	lw	a5,288(s0)
ffffffffc0204e48:	ec8c                	sd	a1,24(s1)
ffffffffc0204e4a:	48d8                	lw	a4,20(s1)
ffffffffc0204e4c:	c399                	beqz	a5,ffffffffc0204e52 <stride_enqueue+0x50>
ffffffffc0204e4e:	00f75463          	bge	a4,a5,ffffffffc0204e56 <stride_enqueue+0x54>
ffffffffc0204e52:	12e42023          	sw	a4,288(s0)
ffffffffc0204e56:	489c                	lw	a5,16(s1)
ffffffffc0204e58:	70e2                	ld	ra,56(sp)
ffffffffc0204e5a:	10943423          	sd	s1,264(s0)
ffffffffc0204e5e:	7442                	ld	s0,48(sp)
ffffffffc0204e60:	2785                	addw	a5,a5,1
ffffffffc0204e62:	c89c                	sw	a5,16(s1)
ffffffffc0204e64:	7902                	ld	s2,32(sp)
ffffffffc0204e66:	74a2                	ld	s1,40(sp)
ffffffffc0204e68:	69e2                	ld	s3,24(sp)
ffffffffc0204e6a:	6a42                	ld	s4,16(sp)
ffffffffc0204e6c:	6aa2                	ld	s5,8(sp)
ffffffffc0204e6e:	6121                	add	sp,sp,64
ffffffffc0204e70:	8082                	ret
ffffffffc0204e72:	01093983          	ld	s3,16(s2)
ffffffffc0204e76:	00893a03          	ld	s4,8(s2)
ffffffffc0204e7a:	00098b63          	beqz	s3,ffffffffc0204e90 <stride_enqueue+0x8e>
ffffffffc0204e7e:	0189a783          	lw	a5,24(s3)
ffffffffc0204e82:	9f99                	subw	a5,a5,a4
ffffffffc0204e84:	0007ce63          	bltz	a5,ffffffffc0204ea0 <stride_enqueue+0x9e>
ffffffffc0204e88:	13343823          	sd	s3,304(s0)
ffffffffc0204e8c:	00b9b023          	sd	a1,0(s3)
ffffffffc0204e90:	00b93423          	sd	a1,8(s2)
ffffffffc0204e94:	01493823          	sd	s4,16(s2)
ffffffffc0204e98:	0125b023          	sd	s2,0(a1)
ffffffffc0204e9c:	85ca                	mv	a1,s2
ffffffffc0204e9e:	b75d                	j	ffffffffc0204e44 <stride_enqueue+0x42>
ffffffffc0204ea0:	0109b503          	ld	a0,16(s3)
ffffffffc0204ea4:	0089ba83          	ld	s5,8(s3)
ffffffffc0204ea8:	dbfff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204eac:	00a9b423          	sd	a0,8(s3)
ffffffffc0204eb0:	0159b823          	sd	s5,16(s3)
ffffffffc0204eb4:	c119                	beqz	a0,ffffffffc0204eba <stride_enqueue+0xb8>
ffffffffc0204eb6:	01353023          	sd	s3,0(a0)
ffffffffc0204eba:	85ce                	mv	a1,s3
ffffffffc0204ebc:	bfd1                	j	ffffffffc0204e90 <stride_enqueue+0x8e>

ffffffffc0204ebe <stride_dequeue>:
ffffffffc0204ebe:	1085b783          	ld	a5,264(a1)
ffffffffc0204ec2:	7159                	add	sp,sp,-112
ffffffffc0204ec4:	f486                	sd	ra,104(sp)
ffffffffc0204ec6:	f0a2                	sd	s0,96(sp)
ffffffffc0204ec8:	eca6                	sd	s1,88(sp)
ffffffffc0204eca:	e8ca                	sd	s2,80(sp)
ffffffffc0204ecc:	e4ce                	sd	s3,72(sp)
ffffffffc0204ece:	e0d2                	sd	s4,64(sp)
ffffffffc0204ed0:	fc56                	sd	s5,56(sp)
ffffffffc0204ed2:	f85a                	sd	s6,48(sp)
ffffffffc0204ed4:	f45e                	sd	s7,40(sp)
ffffffffc0204ed6:	f062                	sd	s8,32(sp)
ffffffffc0204ed8:	ec66                	sd	s9,24(sp)
ffffffffc0204eda:	e86a                	sd	s10,16(sp)
ffffffffc0204edc:	e46e                	sd	s11,8(sp)
ffffffffc0204ede:	20a79a63          	bne	a5,a0,ffffffffc02050f2 <stride_dequeue+0x234>
ffffffffc0204ee2:	01052903          	lw	s2,16(a0)
ffffffffc0204ee6:	8b2a                	mv	s6,a0
ffffffffc0204ee8:	20090563          	beqz	s2,ffffffffc02050f2 <stride_dequeue+0x234>
ffffffffc0204eec:	1305b983          	ld	s3,304(a1)
ffffffffc0204ef0:	01853c03          	ld	s8,24(a0)
ffffffffc0204ef4:	1285ba03          	ld	s4,296(a1)
ffffffffc0204ef8:	1385b483          	ld	s1,312(a1)
ffffffffc0204efc:	842e                	mv	s0,a1
ffffffffc0204efe:	12098563          	beqz	s3,ffffffffc0205028 <stride_dequeue+0x16a>
ffffffffc0204f02:	10048c63          	beqz	s1,ffffffffc020501a <stride_dequeue+0x15c>
ffffffffc0204f06:	0189a783          	lw	a5,24(s3)
ffffffffc0204f0a:	4c98                	lw	a4,24(s1)
ffffffffc0204f0c:	40e786bb          	subw	a3,a5,a4
ffffffffc0204f10:	0a06c463          	bltz	a3,ffffffffc0204fb8 <stride_dequeue+0xfa>
ffffffffc0204f14:	0104ba83          	ld	s5,16(s1)
ffffffffc0204f18:	0084bc83          	ld	s9,8(s1)
ffffffffc0204f1c:	140a8963          	beqz	s5,ffffffffc020506e <stride_dequeue+0x1b0>
ffffffffc0204f20:	018aa703          	lw	a4,24(s5)
ffffffffc0204f24:	40e786bb          	subw	a3,a5,a4
ffffffffc0204f28:	1006c463          	bltz	a3,ffffffffc0205030 <stride_dequeue+0x172>
ffffffffc0204f2c:	010abb83          	ld	s7,16(s5)
ffffffffc0204f30:	008abd03          	ld	s10,8(s5)
ffffffffc0204f34:	160b8d63          	beqz	s7,ffffffffc02050ae <stride_dequeue+0x1f0>
ffffffffc0204f38:	018ba703          	lw	a4,24(s7)
ffffffffc0204f3c:	9f99                	subw	a5,a5,a4
ffffffffc0204f3e:	1407ca63          	bltz	a5,ffffffffc0205092 <stride_dequeue+0x1d4>
ffffffffc0204f42:	010bb583          	ld	a1,16(s7)
ffffffffc0204f46:	008bbd83          	ld	s11,8(s7)
ffffffffc0204f4a:	854e                	mv	a0,s3
ffffffffc0204f4c:	d1bff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204f50:	00abb423          	sd	a0,8(s7)
ffffffffc0204f54:	01bbb823          	sd	s11,16(s7)
ffffffffc0204f58:	c119                	beqz	a0,ffffffffc0204f5e <stride_dequeue+0xa0>
ffffffffc0204f5a:	01753023          	sd	s7,0(a0)
ffffffffc0204f5e:	017ab423          	sd	s7,8(s5)
ffffffffc0204f62:	01aab823          	sd	s10,16(s5)
ffffffffc0204f66:	015bb023          	sd	s5,0(s7)
ffffffffc0204f6a:	0154b423          	sd	s5,8(s1)
ffffffffc0204f6e:	0194b823          	sd	s9,16(s1)
ffffffffc0204f72:	009ab023          	sd	s1,0(s5)
ffffffffc0204f76:	0144b023          	sd	s4,0(s1)
ffffffffc0204f7a:	000a0b63          	beqz	s4,ffffffffc0204f90 <stride_dequeue+0xd2>
ffffffffc0204f7e:	008a3783          	ld	a5,8(s4)
ffffffffc0204f82:	12840413          	add	s0,s0,296
ffffffffc0204f86:	08878e63          	beq	a5,s0,ffffffffc0205022 <stride_dequeue+0x164>
ffffffffc0204f8a:	009a3823          	sd	s1,16(s4)
ffffffffc0204f8e:	84e2                	mv	s1,s8
ffffffffc0204f90:	70a6                	ld	ra,104(sp)
ffffffffc0204f92:	7406                	ld	s0,96(sp)
ffffffffc0204f94:	397d                	addw	s2,s2,-1
ffffffffc0204f96:	009b3c23          	sd	s1,24(s6)
ffffffffc0204f9a:	012b2823          	sw	s2,16(s6)
ffffffffc0204f9e:	64e6                	ld	s1,88(sp)
ffffffffc0204fa0:	6946                	ld	s2,80(sp)
ffffffffc0204fa2:	69a6                	ld	s3,72(sp)
ffffffffc0204fa4:	6a06                	ld	s4,64(sp)
ffffffffc0204fa6:	7ae2                	ld	s5,56(sp)
ffffffffc0204fa8:	7b42                	ld	s6,48(sp)
ffffffffc0204faa:	7ba2                	ld	s7,40(sp)
ffffffffc0204fac:	7c02                	ld	s8,32(sp)
ffffffffc0204fae:	6ce2                	ld	s9,24(sp)
ffffffffc0204fb0:	6d42                	ld	s10,16(sp)
ffffffffc0204fb2:	6da2                	ld	s11,8(sp)
ffffffffc0204fb4:	6165                	add	sp,sp,112
ffffffffc0204fb6:	8082                	ret
ffffffffc0204fb8:	0109ba83          	ld	s5,16(s3)
ffffffffc0204fbc:	0089bc83          	ld	s9,8(s3)
ffffffffc0204fc0:	040a8763          	beqz	s5,ffffffffc020500e <stride_dequeue+0x150>
ffffffffc0204fc4:	018aa783          	lw	a5,24(s5)
ffffffffc0204fc8:	40e7873b          	subw	a4,a5,a4
ffffffffc0204fcc:	0a074363          	bltz	a4,ffffffffc0205072 <stride_dequeue+0x1b4>
ffffffffc0204fd0:	0104bb83          	ld	s7,16(s1)
ffffffffc0204fd4:	0084bd03          	ld	s10,8(s1)
ffffffffc0204fd8:	100b8b63          	beqz	s7,ffffffffc02050ee <stride_dequeue+0x230>
ffffffffc0204fdc:	018ba703          	lw	a4,24(s7)
ffffffffc0204fe0:	9f99                	subw	a5,a5,a4
ffffffffc0204fe2:	0e07c863          	bltz	a5,ffffffffc02050d2 <stride_dequeue+0x214>
ffffffffc0204fe6:	010bb583          	ld	a1,16(s7)
ffffffffc0204fea:	008bbd83          	ld	s11,8(s7)
ffffffffc0204fee:	8556                	mv	a0,s5
ffffffffc0204ff0:	c77ff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0204ff4:	00abb423          	sd	a0,8(s7)
ffffffffc0204ff8:	01bbb823          	sd	s11,16(s7)
ffffffffc0204ffc:	c119                	beqz	a0,ffffffffc0205002 <stride_dequeue+0x144>
ffffffffc0204ffe:	01753023          	sd	s7,0(a0)
ffffffffc0205002:	0174b423          	sd	s7,8(s1)
ffffffffc0205006:	01a4b823          	sd	s10,16(s1)
ffffffffc020500a:	009bb023          	sd	s1,0(s7)
ffffffffc020500e:	0099b423          	sd	s1,8(s3)
ffffffffc0205012:	0199b823          	sd	s9,16(s3)
ffffffffc0205016:	0134b023          	sd	s3,0(s1)
ffffffffc020501a:	84ce                	mv	s1,s3
ffffffffc020501c:	0144b023          	sd	s4,0(s1)
ffffffffc0205020:	bfa9                	j	ffffffffc0204f7a <stride_dequeue+0xbc>
ffffffffc0205022:	009a3423          	sd	s1,8(s4)
ffffffffc0205026:	b7a5                	j	ffffffffc0204f8e <stride_dequeue+0xd0>
ffffffffc0205028:	d8a9                	beqz	s1,ffffffffc0204f7a <stride_dequeue+0xbc>
ffffffffc020502a:	0144b023          	sd	s4,0(s1)
ffffffffc020502e:	b7b1                	j	ffffffffc0204f7a <stride_dequeue+0xbc>
ffffffffc0205030:	0109bb83          	ld	s7,16(s3)
ffffffffc0205034:	0089bd03          	ld	s10,8(s3)
ffffffffc0205038:	020b8563          	beqz	s7,ffffffffc0205062 <stride_dequeue+0x1a4>
ffffffffc020503c:	018ba783          	lw	a5,24(s7)
ffffffffc0205040:	9f99                	subw	a5,a5,a4
ffffffffc0205042:	0607c863          	bltz	a5,ffffffffc02050b2 <stride_dequeue+0x1f4>
ffffffffc0205046:	010ab583          	ld	a1,16(s5)
ffffffffc020504a:	008abd83          	ld	s11,8(s5)
ffffffffc020504e:	855e                	mv	a0,s7
ffffffffc0205050:	c17ff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0205054:	00aab423          	sd	a0,8(s5)
ffffffffc0205058:	01bab823          	sd	s11,16(s5)
ffffffffc020505c:	c119                	beqz	a0,ffffffffc0205062 <stride_dequeue+0x1a4>
ffffffffc020505e:	01553023          	sd	s5,0(a0)
ffffffffc0205062:	0159b423          	sd	s5,8(s3)
ffffffffc0205066:	01a9b823          	sd	s10,16(s3)
ffffffffc020506a:	013ab023          	sd	s3,0(s5)
ffffffffc020506e:	8ace                	mv	s5,s3
ffffffffc0205070:	bded                	j	ffffffffc0204f6a <stride_dequeue+0xac>
ffffffffc0205072:	010ab503          	ld	a0,16(s5)
ffffffffc0205076:	008abb83          	ld	s7,8(s5)
ffffffffc020507a:	85a6                	mv	a1,s1
ffffffffc020507c:	bebff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc0205080:	00aab423          	sd	a0,8(s5)
ffffffffc0205084:	017ab823          	sd	s7,16(s5)
ffffffffc0205088:	c119                	beqz	a0,ffffffffc020508e <stride_dequeue+0x1d0>
ffffffffc020508a:	01553023          	sd	s5,0(a0)
ffffffffc020508e:	84d6                	mv	s1,s5
ffffffffc0205090:	bfbd                	j	ffffffffc020500e <stride_dequeue+0x150>
ffffffffc0205092:	0109b503          	ld	a0,16(s3)
ffffffffc0205096:	0089bd83          	ld	s11,8(s3)
ffffffffc020509a:	85de                	mv	a1,s7
ffffffffc020509c:	bcbff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc02050a0:	00a9b423          	sd	a0,8(s3)
ffffffffc02050a4:	01b9b823          	sd	s11,16(s3)
ffffffffc02050a8:	c119                	beqz	a0,ffffffffc02050ae <stride_dequeue+0x1f0>
ffffffffc02050aa:	01353023          	sd	s3,0(a0)
ffffffffc02050ae:	8bce                	mv	s7,s3
ffffffffc02050b0:	b57d                	j	ffffffffc0204f5e <stride_dequeue+0xa0>
ffffffffc02050b2:	010bb503          	ld	a0,16(s7)
ffffffffc02050b6:	008bbd83          	ld	s11,8(s7)
ffffffffc02050ba:	85d6                	mv	a1,s5
ffffffffc02050bc:	babff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc02050c0:	00abb423          	sd	a0,8(s7)
ffffffffc02050c4:	01bbb823          	sd	s11,16(s7)
ffffffffc02050c8:	c119                	beqz	a0,ffffffffc02050ce <stride_dequeue+0x210>
ffffffffc02050ca:	01753023          	sd	s7,0(a0)
ffffffffc02050ce:	8ade                	mv	s5,s7
ffffffffc02050d0:	bf49                	j	ffffffffc0205062 <stride_dequeue+0x1a4>
ffffffffc02050d2:	010ab503          	ld	a0,16(s5)
ffffffffc02050d6:	008abd83          	ld	s11,8(s5)
ffffffffc02050da:	85de                	mv	a1,s7
ffffffffc02050dc:	b8bff0ef          	jal	ffffffffc0204c66 <skew_heap_merge.constprop.0>
ffffffffc02050e0:	00aab423          	sd	a0,8(s5)
ffffffffc02050e4:	01bab823          	sd	s11,16(s5)
ffffffffc02050e8:	c119                	beqz	a0,ffffffffc02050ee <stride_dequeue+0x230>
ffffffffc02050ea:	01553023          	sd	s5,0(a0)
ffffffffc02050ee:	8bd6                	mv	s7,s5
ffffffffc02050f0:	bf09                	j	ffffffffc0205002 <stride_dequeue+0x144>
ffffffffc02050f2:	00002697          	auipc	a3,0x2
ffffffffc02050f6:	5de68693          	add	a3,a3,1502 # ffffffffc02076d0 <default_pmm_manager+0xe30>
ffffffffc02050fa:	00001617          	auipc	a2,0x1
ffffffffc02050fe:	10e60613          	add	a2,a2,270 # ffffffffc0206208 <commands+0x450>
ffffffffc0205102:	06300593          	li	a1,99
ffffffffc0205106:	00002517          	auipc	a0,0x2
ffffffffc020510a:	5f250513          	add	a0,a0,1522 # ffffffffc02076f8 <default_pmm_manager+0xe58>
ffffffffc020510e:	b64fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc0205112 <sched_init>:
ffffffffc0205112:	1141                	add	sp,sp,-16
ffffffffc0205114:	00007697          	auipc	a3,0x7
ffffffffc0205118:	f3c68693          	add	a3,a3,-196 # ffffffffc020c050 <default_sched_class>
ffffffffc020511c:	e022                	sd	s0,0(sp)
ffffffffc020511e:	e406                	sd	ra,8(sp)
ffffffffc0205120:	00012797          	auipc	a5,0x12
ffffffffc0205124:	41078793          	add	a5,a5,1040 # ffffffffc0217530 <timer_list>
ffffffffc0205128:	6690                	ld	a2,8(a3)
ffffffffc020512a:	00012717          	auipc	a4,0x12
ffffffffc020512e:	3e670713          	add	a4,a4,998 # ffffffffc0217510 <__rq>
ffffffffc0205132:	e79c                	sd	a5,8(a5)
ffffffffc0205134:	e39c                	sd	a5,0(a5)
ffffffffc0205136:	4795                	li	a5,5
ffffffffc0205138:	00012417          	auipc	s0,0x12
ffffffffc020513c:	4c040413          	add	s0,s0,1216 # ffffffffc02175f8 <sched_class>
ffffffffc0205140:	cb5c                	sw	a5,20(a4)
ffffffffc0205142:	853a                	mv	a0,a4
ffffffffc0205144:	e014                	sd	a3,0(s0)
ffffffffc0205146:	00012797          	auipc	a5,0x12
ffffffffc020514a:	4ae7b523          	sd	a4,1194(a5) # ffffffffc02175f0 <rq>
ffffffffc020514e:	9602                	jalr	a2
ffffffffc0205150:	601c                	ld	a5,0(s0)
ffffffffc0205152:	6402                	ld	s0,0(sp)
ffffffffc0205154:	60a2                	ld	ra,8(sp)
ffffffffc0205156:	638c                	ld	a1,0(a5)
ffffffffc0205158:	00002517          	auipc	a0,0x2
ffffffffc020515c:	5e050513          	add	a0,a0,1504 # ffffffffc0207738 <default_pmm_manager+0xe98>
ffffffffc0205160:	0141                	add	sp,sp,16
ffffffffc0205162:	828fb06f          	j	ffffffffc020018a <cprintf>

ffffffffc0205166 <wakeup_proc>:
ffffffffc0205166:	4118                	lw	a4,0(a0)
ffffffffc0205168:	1141                	add	sp,sp,-16
ffffffffc020516a:	e406                	sd	ra,8(sp)
ffffffffc020516c:	e022                	sd	s0,0(sp)
ffffffffc020516e:	478d                	li	a5,3
ffffffffc0205170:	0cf70163          	beq	a4,a5,ffffffffc0205232 <wakeup_proc+0xcc>
ffffffffc0205174:	842a                	mv	s0,a0
ffffffffc0205176:	100027f3          	csrr	a5,sstatus
ffffffffc020517a:	8b89                	and	a5,a5,2
ffffffffc020517c:	e7a9                	bnez	a5,ffffffffc02051c6 <wakeup_proc+0x60>
ffffffffc020517e:	4789                	li	a5,2
ffffffffc0205180:	06f70d63          	beq	a4,a5,ffffffffc02051fa <wakeup_proc+0x94>
ffffffffc0205184:	c11c                	sw	a5,0(a0)
ffffffffc0205186:	0e052623          	sw	zero,236(a0)
ffffffffc020518a:	00012797          	auipc	a5,0x12
ffffffffc020518e:	44e7b783          	ld	a5,1102(a5) # ffffffffc02175d8 <current>
ffffffffc0205192:	02f50663          	beq	a0,a5,ffffffffc02051be <wakeup_proc+0x58>
ffffffffc0205196:	00012797          	auipc	a5,0x12
ffffffffc020519a:	4527b783          	ld	a5,1106(a5) # ffffffffc02175e8 <idleproc>
ffffffffc020519e:	02f50063          	beq	a0,a5,ffffffffc02051be <wakeup_proc+0x58>
ffffffffc02051a2:	6402                	ld	s0,0(sp)
ffffffffc02051a4:	00012797          	auipc	a5,0x12
ffffffffc02051a8:	4547b783          	ld	a5,1108(a5) # ffffffffc02175f8 <sched_class>
ffffffffc02051ac:	60a2                	ld	ra,8(sp)
ffffffffc02051ae:	6b9c                	ld	a5,16(a5)
ffffffffc02051b0:	85aa                	mv	a1,a0
ffffffffc02051b2:	00012517          	auipc	a0,0x12
ffffffffc02051b6:	43e53503          	ld	a0,1086(a0) # ffffffffc02175f0 <rq>
ffffffffc02051ba:	0141                	add	sp,sp,16
ffffffffc02051bc:	8782                	jr	a5
ffffffffc02051be:	60a2                	ld	ra,8(sp)
ffffffffc02051c0:	6402                	ld	s0,0(sp)
ffffffffc02051c2:	0141                	add	sp,sp,16
ffffffffc02051c4:	8082                	ret
ffffffffc02051c6:	c6efb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02051ca:	4018                	lw	a4,0(s0)
ffffffffc02051cc:	4789                	li	a5,2
ffffffffc02051ce:	04f70563          	beq	a4,a5,ffffffffc0205218 <wakeup_proc+0xb2>
ffffffffc02051d2:	c01c                	sw	a5,0(s0)
ffffffffc02051d4:	0e042623          	sw	zero,236(s0)
ffffffffc02051d8:	00012797          	auipc	a5,0x12
ffffffffc02051dc:	4007b783          	ld	a5,1024(a5) # ffffffffc02175d8 <current>
ffffffffc02051e0:	00f40863          	beq	s0,a5,ffffffffc02051f0 <wakeup_proc+0x8a>
ffffffffc02051e4:	00012797          	auipc	a5,0x12
ffffffffc02051e8:	4047b783          	ld	a5,1028(a5) # ffffffffc02175e8 <idleproc>
ffffffffc02051ec:	06f41363          	bne	s0,a5,ffffffffc0205252 <wakeup_proc+0xec>
ffffffffc02051f0:	6402                	ld	s0,0(sp)
ffffffffc02051f2:	60a2                	ld	ra,8(sp)
ffffffffc02051f4:	0141                	add	sp,sp,16
ffffffffc02051f6:	c38fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc02051fa:	6402                	ld	s0,0(sp)
ffffffffc02051fc:	60a2                	ld	ra,8(sp)
ffffffffc02051fe:	00002617          	auipc	a2,0x2
ffffffffc0205202:	58a60613          	add	a2,a2,1418 # ffffffffc0207788 <default_pmm_manager+0xee8>
ffffffffc0205206:	04800593          	li	a1,72
ffffffffc020520a:	00002517          	auipc	a0,0x2
ffffffffc020520e:	56650513          	add	a0,a0,1382 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc0205212:	0141                	add	sp,sp,16
ffffffffc0205214:	ac6fb06f          	j	ffffffffc02004da <__warn>
ffffffffc0205218:	00002617          	auipc	a2,0x2
ffffffffc020521c:	57060613          	add	a2,a2,1392 # ffffffffc0207788 <default_pmm_manager+0xee8>
ffffffffc0205220:	04800593          	li	a1,72
ffffffffc0205224:	00002517          	auipc	a0,0x2
ffffffffc0205228:	54c50513          	add	a0,a0,1356 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc020522c:	aaefb0ef          	jal	ffffffffc02004da <__warn>
ffffffffc0205230:	b7c1                	j	ffffffffc02051f0 <wakeup_proc+0x8a>
ffffffffc0205232:	00002697          	auipc	a3,0x2
ffffffffc0205236:	51e68693          	add	a3,a3,1310 # ffffffffc0207750 <default_pmm_manager+0xeb0>
ffffffffc020523a:	00001617          	auipc	a2,0x1
ffffffffc020523e:	fce60613          	add	a2,a2,-50 # ffffffffc0206208 <commands+0x450>
ffffffffc0205242:	03c00593          	li	a1,60
ffffffffc0205246:	00002517          	auipc	a0,0x2
ffffffffc020524a:	52a50513          	add	a0,a0,1322 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc020524e:	a24fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc0205252:	00012797          	auipc	a5,0x12
ffffffffc0205256:	3a67b783          	ld	a5,934(a5) # ffffffffc02175f8 <sched_class>
ffffffffc020525a:	6b9c                	ld	a5,16(a5)
ffffffffc020525c:	85a2                	mv	a1,s0
ffffffffc020525e:	00012517          	auipc	a0,0x12
ffffffffc0205262:	39253503          	ld	a0,914(a0) # ffffffffc02175f0 <rq>
ffffffffc0205266:	9782                	jalr	a5
ffffffffc0205268:	b761                	j	ffffffffc02051f0 <wakeup_proc+0x8a>

ffffffffc020526a <schedule>:
ffffffffc020526a:	7179                	add	sp,sp,-48
ffffffffc020526c:	f406                	sd	ra,40(sp)
ffffffffc020526e:	f022                	sd	s0,32(sp)
ffffffffc0205270:	ec26                	sd	s1,24(sp)
ffffffffc0205272:	e84a                	sd	s2,16(sp)
ffffffffc0205274:	e44e                	sd	s3,8(sp)
ffffffffc0205276:	e052                	sd	s4,0(sp)
ffffffffc0205278:	100027f3          	csrr	a5,sstatus
ffffffffc020527c:	8b89                	and	a5,a5,2
ffffffffc020527e:	4a01                	li	s4,0
ffffffffc0205280:	e3cd                	bnez	a5,ffffffffc0205322 <schedule+0xb8>
ffffffffc0205282:	00012497          	auipc	s1,0x12
ffffffffc0205286:	35648493          	add	s1,s1,854 # ffffffffc02175d8 <current>
ffffffffc020528a:	608c                	ld	a1,0(s1)
ffffffffc020528c:	4789                	li	a5,2
ffffffffc020528e:	00012917          	auipc	s2,0x12
ffffffffc0205292:	36290913          	add	s2,s2,866 # ffffffffc02175f0 <rq>
ffffffffc0205296:	4198                	lw	a4,0(a1)
ffffffffc0205298:	0005bc23          	sd	zero,24(a1)
ffffffffc020529c:	00012997          	auipc	s3,0x12
ffffffffc02052a0:	35c98993          	add	s3,s3,860 # ffffffffc02175f8 <sched_class>
ffffffffc02052a4:	06f70263          	beq	a4,a5,ffffffffc0205308 <schedule+0x9e>
ffffffffc02052a8:	0009b783          	ld	a5,0(s3)
ffffffffc02052ac:	00093503          	ld	a0,0(s2)
ffffffffc02052b0:	739c                	ld	a5,32(a5)
ffffffffc02052b2:	9782                	jalr	a5
ffffffffc02052b4:	842a                	mv	s0,a0
ffffffffc02052b6:	c521                	beqz	a0,ffffffffc02052fe <schedule+0x94>
ffffffffc02052b8:	0009b783          	ld	a5,0(s3)
ffffffffc02052bc:	00093503          	ld	a0,0(s2)
ffffffffc02052c0:	85a2                	mv	a1,s0
ffffffffc02052c2:	6f9c                	ld	a5,24(a5)
ffffffffc02052c4:	9782                	jalr	a5
ffffffffc02052c6:	441c                	lw	a5,8(s0)
ffffffffc02052c8:	6098                	ld	a4,0(s1)
ffffffffc02052ca:	2785                	addw	a5,a5,1
ffffffffc02052cc:	c41c                	sw	a5,8(s0)
ffffffffc02052ce:	00870563          	beq	a4,s0,ffffffffc02052d8 <schedule+0x6e>
ffffffffc02052d2:	8522                	mv	a0,s0
ffffffffc02052d4:	f68fe0ef          	jal	ffffffffc0203a3c <proc_run>
ffffffffc02052d8:	000a1a63          	bnez	s4,ffffffffc02052ec <schedule+0x82>
ffffffffc02052dc:	70a2                	ld	ra,40(sp)
ffffffffc02052de:	7402                	ld	s0,32(sp)
ffffffffc02052e0:	64e2                	ld	s1,24(sp)
ffffffffc02052e2:	6942                	ld	s2,16(sp)
ffffffffc02052e4:	69a2                	ld	s3,8(sp)
ffffffffc02052e6:	6a02                	ld	s4,0(sp)
ffffffffc02052e8:	6145                	add	sp,sp,48
ffffffffc02052ea:	8082                	ret
ffffffffc02052ec:	7402                	ld	s0,32(sp)
ffffffffc02052ee:	70a2                	ld	ra,40(sp)
ffffffffc02052f0:	64e2                	ld	s1,24(sp)
ffffffffc02052f2:	6942                	ld	s2,16(sp)
ffffffffc02052f4:	69a2                	ld	s3,8(sp)
ffffffffc02052f6:	6a02                	ld	s4,0(sp)
ffffffffc02052f8:	6145                	add	sp,sp,48
ffffffffc02052fa:	b34fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc02052fe:	00012417          	auipc	s0,0x12
ffffffffc0205302:	2ea43403          	ld	s0,746(s0) # ffffffffc02175e8 <idleproc>
ffffffffc0205306:	b7c1                	j	ffffffffc02052c6 <schedule+0x5c>
ffffffffc0205308:	00012797          	auipc	a5,0x12
ffffffffc020530c:	2e07b783          	ld	a5,736(a5) # ffffffffc02175e8 <idleproc>
ffffffffc0205310:	f8f58ce3          	beq	a1,a5,ffffffffc02052a8 <schedule+0x3e>
ffffffffc0205314:	0009b783          	ld	a5,0(s3)
ffffffffc0205318:	00093503          	ld	a0,0(s2)
ffffffffc020531c:	6b9c                	ld	a5,16(a5)
ffffffffc020531e:	9782                	jalr	a5
ffffffffc0205320:	b761                	j	ffffffffc02052a8 <schedule+0x3e>
ffffffffc0205322:	b12fb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0205326:	4a05                	li	s4,1
ffffffffc0205328:	bfa9                	j	ffffffffc0205282 <schedule+0x18>

ffffffffc020532a <add_timer>:
ffffffffc020532a:	1141                	add	sp,sp,-16
ffffffffc020532c:	e022                	sd	s0,0(sp)
ffffffffc020532e:	e406                	sd	ra,8(sp)
ffffffffc0205330:	842a                	mv	s0,a0
ffffffffc0205332:	100027f3          	csrr	a5,sstatus
ffffffffc0205336:	8b89                	and	a5,a5,2
ffffffffc0205338:	4501                	li	a0,0
ffffffffc020533a:	e7bd                	bnez	a5,ffffffffc02053a8 <add_timer+0x7e>
ffffffffc020533c:	401c                	lw	a5,0(s0)
ffffffffc020533e:	cbad                	beqz	a5,ffffffffc02053b0 <add_timer+0x86>
ffffffffc0205340:	6418                	ld	a4,8(s0)
ffffffffc0205342:	c73d                	beqz	a4,ffffffffc02053b0 <add_timer+0x86>
ffffffffc0205344:	6c18                	ld	a4,24(s0)
ffffffffc0205346:	01040593          	add	a1,s0,16
ffffffffc020534a:	08e59363          	bne	a1,a4,ffffffffc02053d0 <add_timer+0xa6>
ffffffffc020534e:	00012617          	auipc	a2,0x12
ffffffffc0205352:	1e260613          	add	a2,a2,482 # ffffffffc0217530 <timer_list>
ffffffffc0205356:	6618                	ld	a4,8(a2)
ffffffffc0205358:	00c71863          	bne	a4,a2,ffffffffc0205368 <add_timer+0x3e>
ffffffffc020535c:	a805                	j	ffffffffc020538c <add_timer+0x62>
ffffffffc020535e:	6718                	ld	a4,8(a4)
ffffffffc0205360:	9f95                	subw	a5,a5,a3
ffffffffc0205362:	c01c                	sw	a5,0(s0)
ffffffffc0205364:	02c70463          	beq	a4,a2,ffffffffc020538c <add_timer+0x62>
ffffffffc0205368:	ff072683          	lw	a3,-16(a4)
ffffffffc020536c:	fed7f9e3          	bgeu	a5,a3,ffffffffc020535e <add_timer+0x34>
ffffffffc0205370:	9e9d                	subw	a3,a3,a5
ffffffffc0205372:	631c                	ld	a5,0(a4)
ffffffffc0205374:	fed72823          	sw	a3,-16(a4)
ffffffffc0205378:	e30c                	sd	a1,0(a4)
ffffffffc020537a:	e78c                	sd	a1,8(a5)
ffffffffc020537c:	ec18                	sd	a4,24(s0)
ffffffffc020537e:	e81c                	sd	a5,16(s0)
ffffffffc0205380:	c105                	beqz	a0,ffffffffc02053a0 <add_timer+0x76>
ffffffffc0205382:	6402                	ld	s0,0(sp)
ffffffffc0205384:	60a2                	ld	ra,8(sp)
ffffffffc0205386:	0141                	add	sp,sp,16
ffffffffc0205388:	aa6fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc020538c:	00012717          	auipc	a4,0x12
ffffffffc0205390:	1a470713          	add	a4,a4,420 # ffffffffc0217530 <timer_list>
ffffffffc0205394:	631c                	ld	a5,0(a4)
ffffffffc0205396:	e30c                	sd	a1,0(a4)
ffffffffc0205398:	e78c                	sd	a1,8(a5)
ffffffffc020539a:	ec18                	sd	a4,24(s0)
ffffffffc020539c:	e81c                	sd	a5,16(s0)
ffffffffc020539e:	f175                	bnez	a0,ffffffffc0205382 <add_timer+0x58>
ffffffffc02053a0:	60a2                	ld	ra,8(sp)
ffffffffc02053a2:	6402                	ld	s0,0(sp)
ffffffffc02053a4:	0141                	add	sp,sp,16
ffffffffc02053a6:	8082                	ret
ffffffffc02053a8:	a8cfb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc02053ac:	4505                	li	a0,1
ffffffffc02053ae:	b779                	j	ffffffffc020533c <add_timer+0x12>
ffffffffc02053b0:	00002697          	auipc	a3,0x2
ffffffffc02053b4:	3f868693          	add	a3,a3,1016 # ffffffffc02077a8 <default_pmm_manager+0xf08>
ffffffffc02053b8:	00001617          	auipc	a2,0x1
ffffffffc02053bc:	e5060613          	add	a2,a2,-432 # ffffffffc0206208 <commands+0x450>
ffffffffc02053c0:	06c00593          	li	a1,108
ffffffffc02053c4:	00002517          	auipc	a0,0x2
ffffffffc02053c8:	3ac50513          	add	a0,a0,940 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc02053cc:	8a6fb0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc02053d0:	00002697          	auipc	a3,0x2
ffffffffc02053d4:	40868693          	add	a3,a3,1032 # ffffffffc02077d8 <default_pmm_manager+0xf38>
ffffffffc02053d8:	00001617          	auipc	a2,0x1
ffffffffc02053dc:	e3060613          	add	a2,a2,-464 # ffffffffc0206208 <commands+0x450>
ffffffffc02053e0:	06d00593          	li	a1,109
ffffffffc02053e4:	00002517          	auipc	a0,0x2
ffffffffc02053e8:	38c50513          	add	a0,a0,908 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc02053ec:	886fb0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02053f0 <del_timer>:
ffffffffc02053f0:	1101                	add	sp,sp,-32
ffffffffc02053f2:	e822                	sd	s0,16(sp)
ffffffffc02053f4:	ec06                	sd	ra,24(sp)
ffffffffc02053f6:	e426                	sd	s1,8(sp)
ffffffffc02053f8:	842a                	mv	s0,a0
ffffffffc02053fa:	100027f3          	csrr	a5,sstatus
ffffffffc02053fe:	8b89                	and	a5,a5,2
ffffffffc0205400:	01050493          	add	s1,a0,16
ffffffffc0205404:	e7b9                	bnez	a5,ffffffffc0205452 <del_timer+0x62>
ffffffffc0205406:	6d1c                	ld	a5,24(a0)
ffffffffc0205408:	04f48063          	beq	s1,a5,ffffffffc0205448 <del_timer+0x58>
ffffffffc020540c:	4114                	lw	a3,0(a0)
ffffffffc020540e:	6918                	ld	a4,16(a0)
ffffffffc0205410:	ca85                	beqz	a3,ffffffffc0205440 <del_timer+0x50>
ffffffffc0205412:	00012617          	auipc	a2,0x12
ffffffffc0205416:	11e60613          	add	a2,a2,286 # ffffffffc0217530 <timer_list>
ffffffffc020541a:	4581                	li	a1,0
ffffffffc020541c:	02c78263          	beq	a5,a2,ffffffffc0205440 <del_timer+0x50>
ffffffffc0205420:	ff07a603          	lw	a2,-16(a5)
ffffffffc0205424:	9eb1                	addw	a3,a3,a2
ffffffffc0205426:	fed7a823          	sw	a3,-16(a5)
ffffffffc020542a:	e71c                	sd	a5,8(a4)
ffffffffc020542c:	e398                	sd	a4,0(a5)
ffffffffc020542e:	ec04                	sd	s1,24(s0)
ffffffffc0205430:	e804                	sd	s1,16(s0)
ffffffffc0205432:	c999                	beqz	a1,ffffffffc0205448 <del_timer+0x58>
ffffffffc0205434:	6442                	ld	s0,16(sp)
ffffffffc0205436:	60e2                	ld	ra,24(sp)
ffffffffc0205438:	64a2                	ld	s1,8(sp)
ffffffffc020543a:	6105                	add	sp,sp,32
ffffffffc020543c:	9f2fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc0205440:	e71c                	sd	a5,8(a4)
ffffffffc0205442:	e398                	sd	a4,0(a5)
ffffffffc0205444:	ec04                	sd	s1,24(s0)
ffffffffc0205446:	e804                	sd	s1,16(s0)
ffffffffc0205448:	60e2                	ld	ra,24(sp)
ffffffffc020544a:	6442                	ld	s0,16(sp)
ffffffffc020544c:	64a2                	ld	s1,8(sp)
ffffffffc020544e:	6105                	add	sp,sp,32
ffffffffc0205450:	8082                	ret
ffffffffc0205452:	9e2fb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0205456:	6c1c                	ld	a5,24(s0)
ffffffffc0205458:	fcf48ee3          	beq	s1,a5,ffffffffc0205434 <del_timer+0x44>
ffffffffc020545c:	4014                	lw	a3,0(s0)
ffffffffc020545e:	6818                	ld	a4,16(s0)
ffffffffc0205460:	ca81                	beqz	a3,ffffffffc0205470 <del_timer+0x80>
ffffffffc0205462:	00012617          	auipc	a2,0x12
ffffffffc0205466:	0ce60613          	add	a2,a2,206 # ffffffffc0217530 <timer_list>
ffffffffc020546a:	4585                	li	a1,1
ffffffffc020546c:	fac79ae3          	bne	a5,a2,ffffffffc0205420 <del_timer+0x30>
ffffffffc0205470:	e71c                	sd	a5,8(a4)
ffffffffc0205472:	e398                	sd	a4,0(a5)
ffffffffc0205474:	ec04                	sd	s1,24(s0)
ffffffffc0205476:	e804                	sd	s1,16(s0)
ffffffffc0205478:	bf75                	j	ffffffffc0205434 <del_timer+0x44>

ffffffffc020547a <run_timer_list>:
ffffffffc020547a:	7139                	add	sp,sp,-64
ffffffffc020547c:	fc06                	sd	ra,56(sp)
ffffffffc020547e:	f822                	sd	s0,48(sp)
ffffffffc0205480:	f426                	sd	s1,40(sp)
ffffffffc0205482:	f04a                	sd	s2,32(sp)
ffffffffc0205484:	ec4e                	sd	s3,24(sp)
ffffffffc0205486:	e852                	sd	s4,16(sp)
ffffffffc0205488:	e456                	sd	s5,8(sp)
ffffffffc020548a:	e05a                	sd	s6,0(sp)
ffffffffc020548c:	100027f3          	csrr	a5,sstatus
ffffffffc0205490:	8b89                	and	a5,a5,2
ffffffffc0205492:	4b01                	li	s6,0
ffffffffc0205494:	eff9                	bnez	a5,ffffffffc0205572 <run_timer_list+0xf8>
ffffffffc0205496:	00012997          	auipc	s3,0x12
ffffffffc020549a:	09a98993          	add	s3,s3,154 # ffffffffc0217530 <timer_list>
ffffffffc020549e:	0089b403          	ld	s0,8(s3)
ffffffffc02054a2:	07340a63          	beq	s0,s3,ffffffffc0205516 <run_timer_list+0x9c>
ffffffffc02054a6:	ff042783          	lw	a5,-16(s0)
ffffffffc02054aa:	ff040913          	add	s2,s0,-16
ffffffffc02054ae:	0e078663          	beqz	a5,ffffffffc020559a <run_timer_list+0x120>
ffffffffc02054b2:	fff7871b          	addw	a4,a5,-1
ffffffffc02054b6:	fee42823          	sw	a4,-16(s0)
ffffffffc02054ba:	ef31                	bnez	a4,ffffffffc0205516 <run_timer_list+0x9c>
ffffffffc02054bc:	00002a97          	auipc	s5,0x2
ffffffffc02054c0:	384a8a93          	add	s5,s5,900 # ffffffffc0207840 <default_pmm_manager+0xfa0>
ffffffffc02054c4:	00002a17          	auipc	s4,0x2
ffffffffc02054c8:	2aca0a13          	add	s4,s4,684 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc02054cc:	a005                	j	ffffffffc02054ec <run_timer_list+0x72>
ffffffffc02054ce:	0a07d663          	bgez	a5,ffffffffc020557a <run_timer_list+0x100>
ffffffffc02054d2:	8526                	mv	a0,s1
ffffffffc02054d4:	c93ff0ef          	jal	ffffffffc0205166 <wakeup_proc>
ffffffffc02054d8:	854a                	mv	a0,s2
ffffffffc02054da:	f17ff0ef          	jal	ffffffffc02053f0 <del_timer>
ffffffffc02054de:	03340c63          	beq	s0,s3,ffffffffc0205516 <run_timer_list+0x9c>
ffffffffc02054e2:	ff042783          	lw	a5,-16(s0)
ffffffffc02054e6:	ff040913          	add	s2,s0,-16
ffffffffc02054ea:	e795                	bnez	a5,ffffffffc0205516 <run_timer_list+0x9c>
ffffffffc02054ec:	00893483          	ld	s1,8(s2)
ffffffffc02054f0:	6400                	ld	s0,8(s0)
ffffffffc02054f2:	0ec4a783          	lw	a5,236(s1)
ffffffffc02054f6:	ffe1                	bnez	a5,ffffffffc02054ce <run_timer_list+0x54>
ffffffffc02054f8:	40d4                	lw	a3,4(s1)
ffffffffc02054fa:	8656                	mv	a2,s5
ffffffffc02054fc:	0a300593          	li	a1,163
ffffffffc0205500:	8552                	mv	a0,s4
ffffffffc0205502:	fd9fa0ef          	jal	ffffffffc02004da <__warn>
ffffffffc0205506:	8526                	mv	a0,s1
ffffffffc0205508:	c5fff0ef          	jal	ffffffffc0205166 <wakeup_proc>
ffffffffc020550c:	854a                	mv	a0,s2
ffffffffc020550e:	ee3ff0ef          	jal	ffffffffc02053f0 <del_timer>
ffffffffc0205512:	fd3418e3          	bne	s0,s3,ffffffffc02054e2 <run_timer_list+0x68>
ffffffffc0205516:	00012597          	auipc	a1,0x12
ffffffffc020551a:	0c25b583          	ld	a1,194(a1) # ffffffffc02175d8 <current>
ffffffffc020551e:	00012797          	auipc	a5,0x12
ffffffffc0205522:	0ca7b783          	ld	a5,202(a5) # ffffffffc02175e8 <idleproc>
ffffffffc0205526:	04f58363          	beq	a1,a5,ffffffffc020556c <run_timer_list+0xf2>
ffffffffc020552a:	00012797          	auipc	a5,0x12
ffffffffc020552e:	0ce7b783          	ld	a5,206(a5) # ffffffffc02175f8 <sched_class>
ffffffffc0205532:	779c                	ld	a5,40(a5)
ffffffffc0205534:	00012517          	auipc	a0,0x12
ffffffffc0205538:	0bc53503          	ld	a0,188(a0) # ffffffffc02175f0 <rq>
ffffffffc020553c:	9782                	jalr	a5
ffffffffc020553e:	000b1c63          	bnez	s6,ffffffffc0205556 <run_timer_list+0xdc>
ffffffffc0205542:	70e2                	ld	ra,56(sp)
ffffffffc0205544:	7442                	ld	s0,48(sp)
ffffffffc0205546:	74a2                	ld	s1,40(sp)
ffffffffc0205548:	7902                	ld	s2,32(sp)
ffffffffc020554a:	69e2                	ld	s3,24(sp)
ffffffffc020554c:	6a42                	ld	s4,16(sp)
ffffffffc020554e:	6aa2                	ld	s5,8(sp)
ffffffffc0205550:	6b02                	ld	s6,0(sp)
ffffffffc0205552:	6121                	add	sp,sp,64
ffffffffc0205554:	8082                	ret
ffffffffc0205556:	7442                	ld	s0,48(sp)
ffffffffc0205558:	70e2                	ld	ra,56(sp)
ffffffffc020555a:	74a2                	ld	s1,40(sp)
ffffffffc020555c:	7902                	ld	s2,32(sp)
ffffffffc020555e:	69e2                	ld	s3,24(sp)
ffffffffc0205560:	6a42                	ld	s4,16(sp)
ffffffffc0205562:	6aa2                	ld	s5,8(sp)
ffffffffc0205564:	6b02                	ld	s6,0(sp)
ffffffffc0205566:	6121                	add	sp,sp,64
ffffffffc0205568:	8c6fb06f          	j	ffffffffc020062e <intr_enable>
ffffffffc020556c:	4785                	li	a5,1
ffffffffc020556e:	ed9c                	sd	a5,24(a1)
ffffffffc0205570:	b7f9                	j	ffffffffc020553e <run_timer_list+0xc4>
ffffffffc0205572:	8c2fb0ef          	jal	ffffffffc0200634 <intr_disable>
ffffffffc0205576:	4b05                	li	s6,1
ffffffffc0205578:	bf39                	j	ffffffffc0205496 <run_timer_list+0x1c>
ffffffffc020557a:	00002697          	auipc	a3,0x2
ffffffffc020557e:	29e68693          	add	a3,a3,670 # ffffffffc0207818 <default_pmm_manager+0xf78>
ffffffffc0205582:	00001617          	auipc	a2,0x1
ffffffffc0205586:	c8660613          	add	a2,a2,-890 # ffffffffc0206208 <commands+0x450>
ffffffffc020558a:	0a000593          	li	a1,160
ffffffffc020558e:	00002517          	auipc	a0,0x2
ffffffffc0205592:	1e250513          	add	a0,a0,482 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc0205596:	eddfa0ef          	jal	ffffffffc0200472 <__panic>
ffffffffc020559a:	00002697          	auipc	a3,0x2
ffffffffc020559e:	26668693          	add	a3,a3,614 # ffffffffc0207800 <default_pmm_manager+0xf60>
ffffffffc02055a2:	00001617          	auipc	a2,0x1
ffffffffc02055a6:	c6660613          	add	a2,a2,-922 # ffffffffc0206208 <commands+0x450>
ffffffffc02055aa:	09a00593          	li	a1,154
ffffffffc02055ae:	00002517          	auipc	a0,0x2
ffffffffc02055b2:	1c250513          	add	a0,a0,450 # ffffffffc0207770 <default_pmm_manager+0xed0>
ffffffffc02055b6:	ebdfa0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02055ba <sys_getpid>:
ffffffffc02055ba:	00012797          	auipc	a5,0x12
ffffffffc02055be:	01e7b783          	ld	a5,30(a5) # ffffffffc02175d8 <current>
ffffffffc02055c2:	43c8                	lw	a0,4(a5)
ffffffffc02055c4:	8082                	ret

ffffffffc02055c6 <sys_pgdir>:
ffffffffc02055c6:	4501                	li	a0,0
ffffffffc02055c8:	8082                	ret

ffffffffc02055ca <sys_gettime>:
ffffffffc02055ca:	00012797          	auipc	a5,0x12
ffffffffc02055ce:	f7e7b783          	ld	a5,-130(a5) # ffffffffc0217548 <ticks>
ffffffffc02055d2:	0027951b          	sllw	a0,a5,0x2
ffffffffc02055d6:	9d3d                	addw	a0,a0,a5
ffffffffc02055d8:	0015151b          	sllw	a0,a0,0x1
ffffffffc02055dc:	8082                	ret

ffffffffc02055de <sys_lab6_set_priority>:
ffffffffc02055de:	4108                	lw	a0,0(a0)
ffffffffc02055e0:	1141                	add	sp,sp,-16
ffffffffc02055e2:	e406                	sd	ra,8(sp)
ffffffffc02055e4:	d16ff0ef          	jal	ffffffffc0204afa <lab6_set_priority>
ffffffffc02055e8:	60a2                	ld	ra,8(sp)
ffffffffc02055ea:	4501                	li	a0,0
ffffffffc02055ec:	0141                	add	sp,sp,16
ffffffffc02055ee:	8082                	ret

ffffffffc02055f0 <sys_putc>:
ffffffffc02055f0:	4108                	lw	a0,0(a0)
ffffffffc02055f2:	1141                	add	sp,sp,-16
ffffffffc02055f4:	e406                	sd	ra,8(sp)
ffffffffc02055f6:	bcbfa0ef          	jal	ffffffffc02001c0 <cputchar>
ffffffffc02055fa:	60a2                	ld	ra,8(sp)
ffffffffc02055fc:	4501                	li	a0,0
ffffffffc02055fe:	0141                	add	sp,sp,16
ffffffffc0205600:	8082                	ret

ffffffffc0205602 <sys_kill>:
ffffffffc0205602:	4108                	lw	a0,0(a0)
ffffffffc0205604:	ac4ff06f          	j	ffffffffc02048c8 <do_kill>

ffffffffc0205608 <sys_sleep>:
ffffffffc0205608:	4108                	lw	a0,0(a0)
ffffffffc020560a:	d2aff06f          	j	ffffffffc0204b34 <do_sleep>

ffffffffc020560e <sys_yield>:
ffffffffc020560e:	a6aff06f          	j	ffffffffc0204878 <do_yield>

ffffffffc0205612 <sys_exec>:
ffffffffc0205612:	6d14                	ld	a3,24(a0)
ffffffffc0205614:	6910                	ld	a2,16(a0)
ffffffffc0205616:	650c                	ld	a1,8(a0)
ffffffffc0205618:	6108                	ld	a0,0(a0)
ffffffffc020561a:	d3bfe06f          	j	ffffffffc0204354 <do_execve>

ffffffffc020561e <sys_wait>:
ffffffffc020561e:	650c                	ld	a1,8(a0)
ffffffffc0205620:	4108                	lw	a0,0(a0)
ffffffffc0205622:	a66ff06f          	j	ffffffffc0204888 <do_wait>

ffffffffc0205626 <sys_fork>:
ffffffffc0205626:	00012797          	auipc	a5,0x12
ffffffffc020562a:	fb27b783          	ld	a5,-78(a5) # ffffffffc02175d8 <current>
ffffffffc020562e:	73d0                	ld	a2,160(a5)
ffffffffc0205630:	4501                	li	a0,0
ffffffffc0205632:	6a0c                	ld	a1,16(a2)
ffffffffc0205634:	ccefe06f          	j	ffffffffc0203b02 <do_fork>

ffffffffc0205638 <sys_exit>:
ffffffffc0205638:	4108                	lw	a0,0(a0)
ffffffffc020563a:	8f5fe06f          	j	ffffffffc0203f2e <do_exit>

ffffffffc020563e <syscall>:
ffffffffc020563e:	715d                	add	sp,sp,-80
ffffffffc0205640:	fc26                	sd	s1,56(sp)
ffffffffc0205642:	00012497          	auipc	s1,0x12
ffffffffc0205646:	f9648493          	add	s1,s1,-106 # ffffffffc02175d8 <current>
ffffffffc020564a:	6098                	ld	a4,0(s1)
ffffffffc020564c:	e0a2                	sd	s0,64(sp)
ffffffffc020564e:	f84a                	sd	s2,48(sp)
ffffffffc0205650:	7340                	ld	s0,160(a4)
ffffffffc0205652:	e486                	sd	ra,72(sp)
ffffffffc0205654:	0ff00793          	li	a5,255
ffffffffc0205658:	05042903          	lw	s2,80(s0)
ffffffffc020565c:	0327ee63          	bltu	a5,s2,ffffffffc0205698 <syscall+0x5a>
ffffffffc0205660:	00391713          	sll	a4,s2,0x3
ffffffffc0205664:	00002797          	auipc	a5,0x2
ffffffffc0205668:	24478793          	add	a5,a5,580 # ffffffffc02078a8 <syscalls>
ffffffffc020566c:	97ba                	add	a5,a5,a4
ffffffffc020566e:	639c                	ld	a5,0(a5)
ffffffffc0205670:	c785                	beqz	a5,ffffffffc0205698 <syscall+0x5a>
ffffffffc0205672:	7028                	ld	a0,96(s0)
ffffffffc0205674:	742c                	ld	a1,104(s0)
ffffffffc0205676:	7834                	ld	a3,112(s0)
ffffffffc0205678:	7c38                	ld	a4,120(s0)
ffffffffc020567a:	6c30                	ld	a2,88(s0)
ffffffffc020567c:	e82a                	sd	a0,16(sp)
ffffffffc020567e:	ec2e                	sd	a1,24(sp)
ffffffffc0205680:	e432                	sd	a2,8(sp)
ffffffffc0205682:	f036                	sd	a3,32(sp)
ffffffffc0205684:	f43a                	sd	a4,40(sp)
ffffffffc0205686:	0028                	add	a0,sp,8
ffffffffc0205688:	9782                	jalr	a5
ffffffffc020568a:	60a6                	ld	ra,72(sp)
ffffffffc020568c:	e828                	sd	a0,80(s0)
ffffffffc020568e:	6406                	ld	s0,64(sp)
ffffffffc0205690:	74e2                	ld	s1,56(sp)
ffffffffc0205692:	7942                	ld	s2,48(sp)
ffffffffc0205694:	6161                	add	sp,sp,80
ffffffffc0205696:	8082                	ret
ffffffffc0205698:	8522                	mv	a0,s0
ffffffffc020569a:	98afb0ef          	jal	ffffffffc0200824 <print_trapframe>
ffffffffc020569e:	609c                	ld	a5,0(s1)
ffffffffc02056a0:	86ca                	mv	a3,s2
ffffffffc02056a2:	00002617          	auipc	a2,0x2
ffffffffc02056a6:	1be60613          	add	a2,a2,446 # ffffffffc0207860 <default_pmm_manager+0xfc0>
ffffffffc02056aa:	43d8                	lw	a4,4(a5)
ffffffffc02056ac:	07300593          	li	a1,115
ffffffffc02056b0:	0b478793          	add	a5,a5,180
ffffffffc02056b4:	00002517          	auipc	a0,0x2
ffffffffc02056b8:	1dc50513          	add	a0,a0,476 # ffffffffc0207890 <default_pmm_manager+0xff0>
ffffffffc02056bc:	db7fa0ef          	jal	ffffffffc0200472 <__panic>

ffffffffc02056c0 <hash32>:
ffffffffc02056c0:	9e3707b7          	lui	a5,0x9e370
ffffffffc02056c4:	2785                	addw	a5,a5,1 # ffffffff9e370001 <kern_entry-0x21e8ffff>
ffffffffc02056c6:	02a787bb          	mulw	a5,a5,a0
ffffffffc02056ca:	02000513          	li	a0,32
ffffffffc02056ce:	9d0d                	subw	a0,a0,a1
ffffffffc02056d0:	00a7d53b          	srlw	a0,a5,a0
ffffffffc02056d4:	8082                	ret

ffffffffc02056d6 <printnum>:
ffffffffc02056d6:	02069813          	sll	a6,a3,0x20
ffffffffc02056da:	7179                	add	sp,sp,-48
ffffffffc02056dc:	02085813          	srl	a6,a6,0x20
ffffffffc02056e0:	e052                	sd	s4,0(sp)
ffffffffc02056e2:	03067a33          	remu	s4,a2,a6
ffffffffc02056e6:	f022                	sd	s0,32(sp)
ffffffffc02056e8:	ec26                	sd	s1,24(sp)
ffffffffc02056ea:	e84a                	sd	s2,16(sp)
ffffffffc02056ec:	f406                	sd	ra,40(sp)
ffffffffc02056ee:	e44e                	sd	s3,8(sp)
ffffffffc02056f0:	84aa                	mv	s1,a0
ffffffffc02056f2:	892e                	mv	s2,a1
ffffffffc02056f4:	fff7041b          	addw	s0,a4,-1
ffffffffc02056f8:	2a01                	sext.w	s4,s4
ffffffffc02056fa:	03067f63          	bgeu	a2,a6,ffffffffc0205738 <printnum+0x62>
ffffffffc02056fe:	89be                	mv	s3,a5
ffffffffc0205700:	4785                	li	a5,1
ffffffffc0205702:	00e7d763          	bge	a5,a4,ffffffffc0205710 <printnum+0x3a>
ffffffffc0205706:	347d                	addw	s0,s0,-1
ffffffffc0205708:	85ca                	mv	a1,s2
ffffffffc020570a:	854e                	mv	a0,s3
ffffffffc020570c:	9482                	jalr	s1
ffffffffc020570e:	fc65                	bnez	s0,ffffffffc0205706 <printnum+0x30>
ffffffffc0205710:	1a02                	sll	s4,s4,0x20
ffffffffc0205712:	020a5a13          	srl	s4,s4,0x20
ffffffffc0205716:	00003797          	auipc	a5,0x3
ffffffffc020571a:	99278793          	add	a5,a5,-1646 # ffffffffc02080a8 <syscalls+0x800>
ffffffffc020571e:	97d2                	add	a5,a5,s4
ffffffffc0205720:	7402                	ld	s0,32(sp)
ffffffffc0205722:	0007c503          	lbu	a0,0(a5)
ffffffffc0205726:	70a2                	ld	ra,40(sp)
ffffffffc0205728:	69a2                	ld	s3,8(sp)
ffffffffc020572a:	6a02                	ld	s4,0(sp)
ffffffffc020572c:	85ca                	mv	a1,s2
ffffffffc020572e:	87a6                	mv	a5,s1
ffffffffc0205730:	6942                	ld	s2,16(sp)
ffffffffc0205732:	64e2                	ld	s1,24(sp)
ffffffffc0205734:	6145                	add	sp,sp,48
ffffffffc0205736:	8782                	jr	a5
ffffffffc0205738:	03065633          	divu	a2,a2,a6
ffffffffc020573c:	8722                	mv	a4,s0
ffffffffc020573e:	f99ff0ef          	jal	ffffffffc02056d6 <printnum>
ffffffffc0205742:	b7f9                	j	ffffffffc0205710 <printnum+0x3a>

ffffffffc0205744 <vprintfmt>:
ffffffffc0205744:	7119                	add	sp,sp,-128
ffffffffc0205746:	f4a6                	sd	s1,104(sp)
ffffffffc0205748:	f0ca                	sd	s2,96(sp)
ffffffffc020574a:	ecce                	sd	s3,88(sp)
ffffffffc020574c:	e8d2                	sd	s4,80(sp)
ffffffffc020574e:	e4d6                	sd	s5,72(sp)
ffffffffc0205750:	e0da                	sd	s6,64(sp)
ffffffffc0205752:	f862                	sd	s8,48(sp)
ffffffffc0205754:	fc86                	sd	ra,120(sp)
ffffffffc0205756:	f8a2                	sd	s0,112(sp)
ffffffffc0205758:	fc5e                	sd	s7,56(sp)
ffffffffc020575a:	f466                	sd	s9,40(sp)
ffffffffc020575c:	f06a                	sd	s10,32(sp)
ffffffffc020575e:	ec6e                	sd	s11,24(sp)
ffffffffc0205760:	892a                	mv	s2,a0
ffffffffc0205762:	84ae                	mv	s1,a1
ffffffffc0205764:	8c32                	mv	s8,a2
ffffffffc0205766:	8a36                	mv	s4,a3
ffffffffc0205768:	02500993          	li	s3,37
ffffffffc020576c:	05500b13          	li	s6,85
ffffffffc0205770:	00003a97          	auipc	s5,0x3
ffffffffc0205774:	964a8a93          	add	s5,s5,-1692 # ffffffffc02080d4 <syscalls+0x82c>
ffffffffc0205778:	000c4503          	lbu	a0,0(s8)
ffffffffc020577c:	001c0413          	add	s0,s8,1
ffffffffc0205780:	01350a63          	beq	a0,s3,ffffffffc0205794 <vprintfmt+0x50>
ffffffffc0205784:	cd0d                	beqz	a0,ffffffffc02057be <vprintfmt+0x7a>
ffffffffc0205786:	85a6                	mv	a1,s1
ffffffffc0205788:	0405                	add	s0,s0,1
ffffffffc020578a:	9902                	jalr	s2
ffffffffc020578c:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205790:	ff351ae3          	bne	a0,s3,ffffffffc0205784 <vprintfmt+0x40>
ffffffffc0205794:	02000d93          	li	s11,32
ffffffffc0205798:	4b81                	li	s7,0
ffffffffc020579a:	4601                	li	a2,0
ffffffffc020579c:	5d7d                	li	s10,-1
ffffffffc020579e:	5cfd                	li	s9,-1
ffffffffc02057a0:	00044683          	lbu	a3,0(s0)
ffffffffc02057a4:	00140c13          	add	s8,s0,1
ffffffffc02057a8:	fdd6859b          	addw	a1,a3,-35
ffffffffc02057ac:	0ff5f593          	zext.b	a1,a1
ffffffffc02057b0:	02bb6663          	bltu	s6,a1,ffffffffc02057dc <vprintfmt+0x98>
ffffffffc02057b4:	058a                	sll	a1,a1,0x2
ffffffffc02057b6:	95d6                	add	a1,a1,s5
ffffffffc02057b8:	4198                	lw	a4,0(a1)
ffffffffc02057ba:	9756                	add	a4,a4,s5
ffffffffc02057bc:	8702                	jr	a4
ffffffffc02057be:	70e6                	ld	ra,120(sp)
ffffffffc02057c0:	7446                	ld	s0,112(sp)
ffffffffc02057c2:	74a6                	ld	s1,104(sp)
ffffffffc02057c4:	7906                	ld	s2,96(sp)
ffffffffc02057c6:	69e6                	ld	s3,88(sp)
ffffffffc02057c8:	6a46                	ld	s4,80(sp)
ffffffffc02057ca:	6aa6                	ld	s5,72(sp)
ffffffffc02057cc:	6b06                	ld	s6,64(sp)
ffffffffc02057ce:	7be2                	ld	s7,56(sp)
ffffffffc02057d0:	7c42                	ld	s8,48(sp)
ffffffffc02057d2:	7ca2                	ld	s9,40(sp)
ffffffffc02057d4:	7d02                	ld	s10,32(sp)
ffffffffc02057d6:	6de2                	ld	s11,24(sp)
ffffffffc02057d8:	6109                	add	sp,sp,128
ffffffffc02057da:	8082                	ret
ffffffffc02057dc:	85a6                	mv	a1,s1
ffffffffc02057de:	02500513          	li	a0,37
ffffffffc02057e2:	9902                	jalr	s2
ffffffffc02057e4:	fff44703          	lbu	a4,-1(s0)
ffffffffc02057e8:	02500793          	li	a5,37
ffffffffc02057ec:	8c22                	mv	s8,s0
ffffffffc02057ee:	f8f705e3          	beq	a4,a5,ffffffffc0205778 <vprintfmt+0x34>
ffffffffc02057f2:	02500713          	li	a4,37
ffffffffc02057f6:	ffec4783          	lbu	a5,-2(s8)
ffffffffc02057fa:	1c7d                	add	s8,s8,-1
ffffffffc02057fc:	fee79de3          	bne	a5,a4,ffffffffc02057f6 <vprintfmt+0xb2>
ffffffffc0205800:	bfa5                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc0205802:	00144783          	lbu	a5,1(s0)
ffffffffc0205806:	4725                	li	a4,9
ffffffffc0205808:	fd068d1b          	addw	s10,a3,-48
ffffffffc020580c:	fd07859b          	addw	a1,a5,-48
ffffffffc0205810:	0007869b          	sext.w	a3,a5
ffffffffc0205814:	8462                	mv	s0,s8
ffffffffc0205816:	02b76563          	bltu	a4,a1,ffffffffc0205840 <vprintfmt+0xfc>
ffffffffc020581a:	4525                	li	a0,9
ffffffffc020581c:	00144783          	lbu	a5,1(s0)
ffffffffc0205820:	002d171b          	sllw	a4,s10,0x2
ffffffffc0205824:	01a7073b          	addw	a4,a4,s10
ffffffffc0205828:	0017171b          	sllw	a4,a4,0x1
ffffffffc020582c:	9f35                	addw	a4,a4,a3
ffffffffc020582e:	fd07859b          	addw	a1,a5,-48
ffffffffc0205832:	0405                	add	s0,s0,1
ffffffffc0205834:	fd070d1b          	addw	s10,a4,-48
ffffffffc0205838:	0007869b          	sext.w	a3,a5
ffffffffc020583c:	feb570e3          	bgeu	a0,a1,ffffffffc020581c <vprintfmt+0xd8>
ffffffffc0205840:	f60cd0e3          	bgez	s9,ffffffffc02057a0 <vprintfmt+0x5c>
ffffffffc0205844:	8cea                	mv	s9,s10
ffffffffc0205846:	5d7d                	li	s10,-1
ffffffffc0205848:	bfa1                	j	ffffffffc02057a0 <vprintfmt+0x5c>
ffffffffc020584a:	8db6                	mv	s11,a3
ffffffffc020584c:	8462                	mv	s0,s8
ffffffffc020584e:	bf89                	j	ffffffffc02057a0 <vprintfmt+0x5c>
ffffffffc0205850:	8462                	mv	s0,s8
ffffffffc0205852:	4b85                	li	s7,1
ffffffffc0205854:	b7b1                	j	ffffffffc02057a0 <vprintfmt+0x5c>
ffffffffc0205856:	4785                	li	a5,1
ffffffffc0205858:	008a0713          	add	a4,s4,8
ffffffffc020585c:	00c7c463          	blt	a5,a2,ffffffffc0205864 <vprintfmt+0x120>
ffffffffc0205860:	1a060263          	beqz	a2,ffffffffc0205a04 <vprintfmt+0x2c0>
ffffffffc0205864:	000a3603          	ld	a2,0(s4)
ffffffffc0205868:	46c1                	li	a3,16
ffffffffc020586a:	8a3a                	mv	s4,a4
ffffffffc020586c:	000d879b          	sext.w	a5,s11
ffffffffc0205870:	8766                	mv	a4,s9
ffffffffc0205872:	85a6                	mv	a1,s1
ffffffffc0205874:	854a                	mv	a0,s2
ffffffffc0205876:	e61ff0ef          	jal	ffffffffc02056d6 <printnum>
ffffffffc020587a:	bdfd                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc020587c:	000a2503          	lw	a0,0(s4)
ffffffffc0205880:	85a6                	mv	a1,s1
ffffffffc0205882:	0a21                	add	s4,s4,8
ffffffffc0205884:	9902                	jalr	s2
ffffffffc0205886:	bdcd                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc0205888:	4785                	li	a5,1
ffffffffc020588a:	008a0713          	add	a4,s4,8
ffffffffc020588e:	00c7c463          	blt	a5,a2,ffffffffc0205896 <vprintfmt+0x152>
ffffffffc0205892:	16060463          	beqz	a2,ffffffffc02059fa <vprintfmt+0x2b6>
ffffffffc0205896:	000a3603          	ld	a2,0(s4)
ffffffffc020589a:	46a9                	li	a3,10
ffffffffc020589c:	8a3a                	mv	s4,a4
ffffffffc020589e:	b7f9                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc02058a0:	03000513          	li	a0,48
ffffffffc02058a4:	85a6                	mv	a1,s1
ffffffffc02058a6:	9902                	jalr	s2
ffffffffc02058a8:	85a6                	mv	a1,s1
ffffffffc02058aa:	07800513          	li	a0,120
ffffffffc02058ae:	9902                	jalr	s2
ffffffffc02058b0:	0a21                	add	s4,s4,8
ffffffffc02058b2:	46c1                	li	a3,16
ffffffffc02058b4:	ff8a3603          	ld	a2,-8(s4)
ffffffffc02058b8:	bf55                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc02058ba:	85a6                	mv	a1,s1
ffffffffc02058bc:	02500513          	li	a0,37
ffffffffc02058c0:	9902                	jalr	s2
ffffffffc02058c2:	bd5d                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc02058c4:	000a2d03          	lw	s10,0(s4)
ffffffffc02058c8:	8462                	mv	s0,s8
ffffffffc02058ca:	0a21                	add	s4,s4,8
ffffffffc02058cc:	bf95                	j	ffffffffc0205840 <vprintfmt+0xfc>
ffffffffc02058ce:	4785                	li	a5,1
ffffffffc02058d0:	008a0713          	add	a4,s4,8
ffffffffc02058d4:	00c7c463          	blt	a5,a2,ffffffffc02058dc <vprintfmt+0x198>
ffffffffc02058d8:	10060c63          	beqz	a2,ffffffffc02059f0 <vprintfmt+0x2ac>
ffffffffc02058dc:	000a3603          	ld	a2,0(s4)
ffffffffc02058e0:	46a1                	li	a3,8
ffffffffc02058e2:	8a3a                	mv	s4,a4
ffffffffc02058e4:	b761                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc02058e6:	fffcc793          	not	a5,s9
ffffffffc02058ea:	97fd                	sra	a5,a5,0x3f
ffffffffc02058ec:	00fcf7b3          	and	a5,s9,a5
ffffffffc02058f0:	00078c9b          	sext.w	s9,a5
ffffffffc02058f4:	8462                	mv	s0,s8
ffffffffc02058f6:	b56d                	j	ffffffffc02057a0 <vprintfmt+0x5c>
ffffffffc02058f8:	000a3403          	ld	s0,0(s4)
ffffffffc02058fc:	008a0793          	add	a5,s4,8
ffffffffc0205900:	e43e                	sd	a5,8(sp)
ffffffffc0205902:	12040163          	beqz	s0,ffffffffc0205a24 <vprintfmt+0x2e0>
ffffffffc0205906:	0d905963          	blez	s9,ffffffffc02059d8 <vprintfmt+0x294>
ffffffffc020590a:	02d00793          	li	a5,45
ffffffffc020590e:	00140a13          	add	s4,s0,1
ffffffffc0205912:	12fd9863          	bne	s11,a5,ffffffffc0205a42 <vprintfmt+0x2fe>
ffffffffc0205916:	00044783          	lbu	a5,0(s0)
ffffffffc020591a:	0007851b          	sext.w	a0,a5
ffffffffc020591e:	cb9d                	beqz	a5,ffffffffc0205954 <vprintfmt+0x210>
ffffffffc0205920:	547d                	li	s0,-1
ffffffffc0205922:	05e00d93          	li	s11,94
ffffffffc0205926:	000d4563          	bltz	s10,ffffffffc0205930 <vprintfmt+0x1ec>
ffffffffc020592a:	3d7d                	addw	s10,s10,-1
ffffffffc020592c:	028d0263          	beq	s10,s0,ffffffffc0205950 <vprintfmt+0x20c>
ffffffffc0205930:	85a6                	mv	a1,s1
ffffffffc0205932:	0c0b8e63          	beqz	s7,ffffffffc0205a0e <vprintfmt+0x2ca>
ffffffffc0205936:	3781                	addw	a5,a5,-32
ffffffffc0205938:	0cfdfb63          	bgeu	s11,a5,ffffffffc0205a0e <vprintfmt+0x2ca>
ffffffffc020593c:	03f00513          	li	a0,63
ffffffffc0205940:	9902                	jalr	s2
ffffffffc0205942:	000a4783          	lbu	a5,0(s4)
ffffffffc0205946:	3cfd                	addw	s9,s9,-1
ffffffffc0205948:	0a05                	add	s4,s4,1
ffffffffc020594a:	0007851b          	sext.w	a0,a5
ffffffffc020594e:	ffe1                	bnez	a5,ffffffffc0205926 <vprintfmt+0x1e2>
ffffffffc0205950:	01905963          	blez	s9,ffffffffc0205962 <vprintfmt+0x21e>
ffffffffc0205954:	3cfd                	addw	s9,s9,-1
ffffffffc0205956:	85a6                	mv	a1,s1
ffffffffc0205958:	02000513          	li	a0,32
ffffffffc020595c:	9902                	jalr	s2
ffffffffc020595e:	fe0c9be3          	bnez	s9,ffffffffc0205954 <vprintfmt+0x210>
ffffffffc0205962:	6a22                	ld	s4,8(sp)
ffffffffc0205964:	bd11                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc0205966:	4785                	li	a5,1
ffffffffc0205968:	008a0b93          	add	s7,s4,8
ffffffffc020596c:	00c7c363          	blt	a5,a2,ffffffffc0205972 <vprintfmt+0x22e>
ffffffffc0205970:	ce2d                	beqz	a2,ffffffffc02059ea <vprintfmt+0x2a6>
ffffffffc0205972:	000a3403          	ld	s0,0(s4)
ffffffffc0205976:	08044e63          	bltz	s0,ffffffffc0205a12 <vprintfmt+0x2ce>
ffffffffc020597a:	8622                	mv	a2,s0
ffffffffc020597c:	8a5e                	mv	s4,s7
ffffffffc020597e:	46a9                	li	a3,10
ffffffffc0205980:	b5f5                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc0205982:	000a2783          	lw	a5,0(s4)
ffffffffc0205986:	4661                	li	a2,24
ffffffffc0205988:	41f7d71b          	sraw	a4,a5,0x1f
ffffffffc020598c:	8fb9                	xor	a5,a5,a4
ffffffffc020598e:	40e786bb          	subw	a3,a5,a4
ffffffffc0205992:	02d64663          	blt	a2,a3,ffffffffc02059be <vprintfmt+0x27a>
ffffffffc0205996:	00369713          	sll	a4,a3,0x3
ffffffffc020599a:	00003797          	auipc	a5,0x3
ffffffffc020599e:	95678793          	add	a5,a5,-1706 # ffffffffc02082f0 <error_string>
ffffffffc02059a2:	97ba                	add	a5,a5,a4
ffffffffc02059a4:	639c                	ld	a5,0(a5)
ffffffffc02059a6:	cf81                	beqz	a5,ffffffffc02059be <vprintfmt+0x27a>
ffffffffc02059a8:	86be                	mv	a3,a5
ffffffffc02059aa:	00000617          	auipc	a2,0x0
ffffffffc02059ae:	1ce60613          	add	a2,a2,462 # ffffffffc0205b78 <etext+0x24>
ffffffffc02059b2:	85a6                	mv	a1,s1
ffffffffc02059b4:	854a                	mv	a0,s2
ffffffffc02059b6:	0ea000ef          	jal	ffffffffc0205aa0 <printfmt>
ffffffffc02059ba:	0a21                	add	s4,s4,8
ffffffffc02059bc:	bb75                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc02059be:	00002617          	auipc	a2,0x2
ffffffffc02059c2:	70a60613          	add	a2,a2,1802 # ffffffffc02080c8 <syscalls+0x820>
ffffffffc02059c6:	85a6                	mv	a1,s1
ffffffffc02059c8:	854a                	mv	a0,s2
ffffffffc02059ca:	0d6000ef          	jal	ffffffffc0205aa0 <printfmt>
ffffffffc02059ce:	0a21                	add	s4,s4,8
ffffffffc02059d0:	b365                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc02059d2:	2605                	addw	a2,a2,1
ffffffffc02059d4:	8462                	mv	s0,s8
ffffffffc02059d6:	b3e9                	j	ffffffffc02057a0 <vprintfmt+0x5c>
ffffffffc02059d8:	00044783          	lbu	a5,0(s0)
ffffffffc02059dc:	00140a13          	add	s4,s0,1
ffffffffc02059e0:	0007851b          	sext.w	a0,a5
ffffffffc02059e4:	ff95                	bnez	a5,ffffffffc0205920 <vprintfmt+0x1dc>
ffffffffc02059e6:	6a22                	ld	s4,8(sp)
ffffffffc02059e8:	bb41                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc02059ea:	000a2403          	lw	s0,0(s4)
ffffffffc02059ee:	b761                	j	ffffffffc0205976 <vprintfmt+0x232>
ffffffffc02059f0:	000a6603          	lwu	a2,0(s4)
ffffffffc02059f4:	46a1                	li	a3,8
ffffffffc02059f6:	8a3a                	mv	s4,a4
ffffffffc02059f8:	bd95                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc02059fa:	000a6603          	lwu	a2,0(s4)
ffffffffc02059fe:	46a9                	li	a3,10
ffffffffc0205a00:	8a3a                	mv	s4,a4
ffffffffc0205a02:	b5ad                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc0205a04:	000a6603          	lwu	a2,0(s4)
ffffffffc0205a08:	46c1                	li	a3,16
ffffffffc0205a0a:	8a3a                	mv	s4,a4
ffffffffc0205a0c:	b585                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc0205a0e:	9902                	jalr	s2
ffffffffc0205a10:	bf0d                	j	ffffffffc0205942 <vprintfmt+0x1fe>
ffffffffc0205a12:	85a6                	mv	a1,s1
ffffffffc0205a14:	02d00513          	li	a0,45
ffffffffc0205a18:	9902                	jalr	s2
ffffffffc0205a1a:	8a5e                	mv	s4,s7
ffffffffc0205a1c:	40800633          	neg	a2,s0
ffffffffc0205a20:	46a9                	li	a3,10
ffffffffc0205a22:	b5a9                	j	ffffffffc020586c <vprintfmt+0x128>
ffffffffc0205a24:	01905663          	blez	s9,ffffffffc0205a30 <vprintfmt+0x2ec>
ffffffffc0205a28:	02d00793          	li	a5,45
ffffffffc0205a2c:	04fd9263          	bne	s11,a5,ffffffffc0205a70 <vprintfmt+0x32c>
ffffffffc0205a30:	00002a17          	auipc	s4,0x2
ffffffffc0205a34:	691a0a13          	add	s4,s4,1681 # ffffffffc02080c1 <syscalls+0x819>
ffffffffc0205a38:	02800513          	li	a0,40
ffffffffc0205a3c:	02800793          	li	a5,40
ffffffffc0205a40:	b5c5                	j	ffffffffc0205920 <vprintfmt+0x1dc>
ffffffffc0205a42:	85ea                	mv	a1,s10
ffffffffc0205a44:	8522                	mv	a0,s0
ffffffffc0205a46:	07a000ef          	jal	ffffffffc0205ac0 <strnlen>
ffffffffc0205a4a:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0205a4e:	01905963          	blez	s9,ffffffffc0205a60 <vprintfmt+0x31c>
ffffffffc0205a52:	2d81                	sext.w	s11,s11
ffffffffc0205a54:	3cfd                	addw	s9,s9,-1
ffffffffc0205a56:	85a6                	mv	a1,s1
ffffffffc0205a58:	856e                	mv	a0,s11
ffffffffc0205a5a:	9902                	jalr	s2
ffffffffc0205a5c:	fe0c9ce3          	bnez	s9,ffffffffc0205a54 <vprintfmt+0x310>
ffffffffc0205a60:	00044783          	lbu	a5,0(s0)
ffffffffc0205a64:	0007851b          	sext.w	a0,a5
ffffffffc0205a68:	ea079ce3          	bnez	a5,ffffffffc0205920 <vprintfmt+0x1dc>
ffffffffc0205a6c:	6a22                	ld	s4,8(sp)
ffffffffc0205a6e:	b329                	j	ffffffffc0205778 <vprintfmt+0x34>
ffffffffc0205a70:	85ea                	mv	a1,s10
ffffffffc0205a72:	00002517          	auipc	a0,0x2
ffffffffc0205a76:	64e50513          	add	a0,a0,1614 # ffffffffc02080c0 <syscalls+0x818>
ffffffffc0205a7a:	046000ef          	jal	ffffffffc0205ac0 <strnlen>
ffffffffc0205a7e:	40ac8cbb          	subw	s9,s9,a0
ffffffffc0205a82:	00002a17          	auipc	s4,0x2
ffffffffc0205a86:	63fa0a13          	add	s4,s4,1599 # ffffffffc02080c1 <syscalls+0x819>
ffffffffc0205a8a:	00002417          	auipc	s0,0x2
ffffffffc0205a8e:	63640413          	add	s0,s0,1590 # ffffffffc02080c0 <syscalls+0x818>
ffffffffc0205a92:	02800513          	li	a0,40
ffffffffc0205a96:	02800793          	li	a5,40
ffffffffc0205a9a:	fb904ce3          	bgtz	s9,ffffffffc0205a52 <vprintfmt+0x30e>
ffffffffc0205a9e:	b549                	j	ffffffffc0205920 <vprintfmt+0x1dc>

ffffffffc0205aa0 <printfmt>:
ffffffffc0205aa0:	715d                	add	sp,sp,-80
ffffffffc0205aa2:	02810313          	add	t1,sp,40
ffffffffc0205aa6:	f436                	sd	a3,40(sp)
ffffffffc0205aa8:	869a                	mv	a3,t1
ffffffffc0205aaa:	ec06                	sd	ra,24(sp)
ffffffffc0205aac:	f83a                	sd	a4,48(sp)
ffffffffc0205aae:	fc3e                	sd	a5,56(sp)
ffffffffc0205ab0:	e0c2                	sd	a6,64(sp)
ffffffffc0205ab2:	e4c6                	sd	a7,72(sp)
ffffffffc0205ab4:	e41a                	sd	t1,8(sp)
ffffffffc0205ab6:	c8fff0ef          	jal	ffffffffc0205744 <vprintfmt>
ffffffffc0205aba:	60e2                	ld	ra,24(sp)
ffffffffc0205abc:	6161                	add	sp,sp,80
ffffffffc0205abe:	8082                	ret

ffffffffc0205ac0 <strnlen>:
ffffffffc0205ac0:	4781                	li	a5,0
ffffffffc0205ac2:	e589                	bnez	a1,ffffffffc0205acc <strnlen+0xc>
ffffffffc0205ac4:	a811                	j	ffffffffc0205ad8 <strnlen+0x18>
ffffffffc0205ac6:	0785                	add	a5,a5,1
ffffffffc0205ac8:	00f58863          	beq	a1,a5,ffffffffc0205ad8 <strnlen+0x18>
ffffffffc0205acc:	00f50733          	add	a4,a0,a5
ffffffffc0205ad0:	00074703          	lbu	a4,0(a4)
ffffffffc0205ad4:	fb6d                	bnez	a4,ffffffffc0205ac6 <strnlen+0x6>
ffffffffc0205ad6:	85be                	mv	a1,a5
ffffffffc0205ad8:	852e                	mv	a0,a1
ffffffffc0205ada:	8082                	ret

ffffffffc0205adc <strcmp>:
ffffffffc0205adc:	00054783          	lbu	a5,0(a0)
ffffffffc0205ae0:	e791                	bnez	a5,ffffffffc0205aec <strcmp+0x10>
ffffffffc0205ae2:	a02d                	j	ffffffffc0205b0c <strcmp+0x30>
ffffffffc0205ae4:	00054783          	lbu	a5,0(a0)
ffffffffc0205ae8:	cf89                	beqz	a5,ffffffffc0205b02 <strcmp+0x26>
ffffffffc0205aea:	85b6                	mv	a1,a3
ffffffffc0205aec:	0005c703          	lbu	a4,0(a1)
ffffffffc0205af0:	0505                	add	a0,a0,1
ffffffffc0205af2:	00158693          	add	a3,a1,1
ffffffffc0205af6:	fef707e3          	beq	a4,a5,ffffffffc0205ae4 <strcmp+0x8>
ffffffffc0205afa:	0007851b          	sext.w	a0,a5
ffffffffc0205afe:	9d19                	subw	a0,a0,a4
ffffffffc0205b00:	8082                	ret
ffffffffc0205b02:	0015c703          	lbu	a4,1(a1)
ffffffffc0205b06:	4501                	li	a0,0
ffffffffc0205b08:	9d19                	subw	a0,a0,a4
ffffffffc0205b0a:	8082                	ret
ffffffffc0205b0c:	0005c703          	lbu	a4,0(a1)
ffffffffc0205b10:	4501                	li	a0,0
ffffffffc0205b12:	b7f5                	j	ffffffffc0205afe <strcmp+0x22>

ffffffffc0205b14 <strchr>:
ffffffffc0205b14:	00054783          	lbu	a5,0(a0)
ffffffffc0205b18:	c799                	beqz	a5,ffffffffc0205b26 <strchr+0x12>
ffffffffc0205b1a:	00f58763          	beq	a1,a5,ffffffffc0205b28 <strchr+0x14>
ffffffffc0205b1e:	00154783          	lbu	a5,1(a0)
ffffffffc0205b22:	0505                	add	a0,a0,1
ffffffffc0205b24:	fbfd                	bnez	a5,ffffffffc0205b1a <strchr+0x6>
ffffffffc0205b26:	4501                	li	a0,0
ffffffffc0205b28:	8082                	ret

ffffffffc0205b2a <memset>:
ffffffffc0205b2a:	ca01                	beqz	a2,ffffffffc0205b3a <memset+0x10>
ffffffffc0205b2c:	962a                	add	a2,a2,a0
ffffffffc0205b2e:	87aa                	mv	a5,a0
ffffffffc0205b30:	0785                	add	a5,a5,1
ffffffffc0205b32:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0205b36:	fec79de3          	bne	a5,a2,ffffffffc0205b30 <memset+0x6>
ffffffffc0205b3a:	8082                	ret

ffffffffc0205b3c <memcpy>:
ffffffffc0205b3c:	ca19                	beqz	a2,ffffffffc0205b52 <memcpy+0x16>
ffffffffc0205b3e:	962e                	add	a2,a2,a1
ffffffffc0205b40:	87aa                	mv	a5,a0
ffffffffc0205b42:	0005c703          	lbu	a4,0(a1)
ffffffffc0205b46:	0585                	add	a1,a1,1
ffffffffc0205b48:	0785                	add	a5,a5,1
ffffffffc0205b4a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205b4e:	fec59ae3          	bne	a1,a2,ffffffffc0205b42 <memcpy+0x6>
ffffffffc0205b52:	8082                	ret
