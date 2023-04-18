
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00005117          	auipc	sp,0x5
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00005517          	auipc	a0,0x5
    8020000e:	ffe50513          	add	a0,a0,-2 # 80205008 <free_area>
    80200012:	00005617          	auipc	a2,0x5
    80200016:	04660613          	add	a2,a2,70 # 80205058 <end>
    8020001a:	1141                	add	sp,sp,-16 # 80204ff0 <bootstack+0x1ff0>
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	608010ef          	jal	8020162a <memset>
    80200026:	138000ef          	jal	8020015e <cons_init>
    8020002a:	00001517          	auipc	a0,0x1
    8020002e:	61650513          	add	a0,a0,1558 # 80201640 <etext+0x4>
    80200032:	086000ef          	jal	802000b8 <cputs>
    80200036:	13e000ef          	jal	80200174 <idt_init>
    8020003a:	062010ef          	jal	8020109c <pmm_init>
    8020003e:	136000ef          	jal	80200174 <idt_init>
    80200042:	126000ef          	jal	80200168 <intr_enable>
    80200046:	a001                	j	80200046 <kern_init+0x3c>

0000000080200048 <cputch>:
    80200048:	1141                	add	sp,sp,-16
    8020004a:	e022                	sd	s0,0(sp)
    8020004c:	e406                	sd	ra,8(sp)
    8020004e:	842e                	mv	s0,a1
    80200050:	110000ef          	jal	80200160 <cons_putc>
    80200054:	401c                	lw	a5,0(s0)
    80200056:	60a2                	ld	ra,8(sp)
    80200058:	2785                	addw	a5,a5,1
    8020005a:	c01c                	sw	a5,0(s0)
    8020005c:	6402                	ld	s0,0(sp)
    8020005e:	0141                	add	sp,sp,16
    80200060:	8082                	ret

0000000080200062 <vcprintf>:
    80200062:	1101                	add	sp,sp,-32
    80200064:	862a                	mv	a2,a0
    80200066:	86ae                	mv	a3,a1
    80200068:	00000517          	auipc	a0,0x0
    8020006c:	fe050513          	add	a0,a0,-32 # 80200048 <cputch>
    80200070:	006c                	add	a1,sp,12
    80200072:	ec06                	sd	ra,24(sp)
    80200074:	c602                	sw	zero,12(sp)
    80200076:	1e8010ef          	jal	8020125e <vprintfmt>
    8020007a:	60e2                	ld	ra,24(sp)
    8020007c:	4532                	lw	a0,12(sp)
    8020007e:	6105                	add	sp,sp,32
    80200080:	8082                	ret

0000000080200082 <cprintf>:
    80200082:	711d                	add	sp,sp,-96
    80200084:	02810313          	add	t1,sp,40
    80200088:	8e2a                	mv	t3,a0
    8020008a:	f42e                	sd	a1,40(sp)
    8020008c:	f832                	sd	a2,48(sp)
    8020008e:	fc36                	sd	a3,56(sp)
    80200090:	00000517          	auipc	a0,0x0
    80200094:	fb850513          	add	a0,a0,-72 # 80200048 <cputch>
    80200098:	004c                	add	a1,sp,4
    8020009a:	869a                	mv	a3,t1
    8020009c:	8672                	mv	a2,t3
    8020009e:	ec06                	sd	ra,24(sp)
    802000a0:	e0ba                	sd	a4,64(sp)
    802000a2:	e4be                	sd	a5,72(sp)
    802000a4:	e8c2                	sd	a6,80(sp)
    802000a6:	ecc6                	sd	a7,88(sp)
    802000a8:	e41a                	sd	t1,8(sp)
    802000aa:	c202                	sw	zero,4(sp)
    802000ac:	1b2010ef          	jal	8020125e <vprintfmt>
    802000b0:	60e2                	ld	ra,24(sp)
    802000b2:	4512                	lw	a0,4(sp)
    802000b4:	6125                	add	sp,sp,96
    802000b6:	8082                	ret

00000000802000b8 <cputs>:
    802000b8:	1101                	add	sp,sp,-32
    802000ba:	ec06                	sd	ra,24(sp)
    802000bc:	e822                	sd	s0,16(sp)
    802000be:	e426                	sd	s1,8(sp)
    802000c0:	87aa                	mv	a5,a0
    802000c2:	00054503          	lbu	a0,0(a0)
    802000c6:	c51d                	beqz	a0,802000f4 <cputs+0x3c>
    802000c8:	00178493          	add	s1,a5,1
    802000cc:	8426                	mv	s0,s1
    802000ce:	092000ef          	jal	80200160 <cons_putc>
    802000d2:	00044503          	lbu	a0,0(s0)
    802000d6:	87a2                	mv	a5,s0
    802000d8:	0405                	add	s0,s0,1
    802000da:	f975                	bnez	a0,802000ce <cputs+0x16>
    802000dc:	9f85                	subw	a5,a5,s1
    802000de:	0027841b          	addw	s0,a5,2
    802000e2:	4529                	li	a0,10
    802000e4:	07c000ef          	jal	80200160 <cons_putc>
    802000e8:	60e2                	ld	ra,24(sp)
    802000ea:	8522                	mv	a0,s0
    802000ec:	6442                	ld	s0,16(sp)
    802000ee:	64a2                	ld	s1,8(sp)
    802000f0:	6105                	add	sp,sp,32
    802000f2:	8082                	ret
    802000f4:	4405                	li	s0,1
    802000f6:	b7f5                	j	802000e2 <cputs+0x2a>

00000000802000f8 <__panic>:
    802000f8:	00005317          	auipc	t1,0x5
    802000fc:	f2830313          	add	t1,t1,-216 # 80205020 <is_panic>
    80200100:	00032e03          	lw	t3,0(t1)
    80200104:	715d                	add	sp,sp,-80
    80200106:	ec06                	sd	ra,24(sp)
    80200108:	e822                	sd	s0,16(sp)
    8020010a:	f436                	sd	a3,40(sp)
    8020010c:	f83a                	sd	a4,48(sp)
    8020010e:	fc3e                	sd	a5,56(sp)
    80200110:	e0c2                	sd	a6,64(sp)
    80200112:	e4c6                	sd	a7,72(sp)
    80200114:	020e1a63          	bnez	t3,80200148 <__panic+0x50>
    80200118:	4785                	li	a5,1
    8020011a:	00f32023          	sw	a5,0(t1)
    8020011e:	8432                	mv	s0,a2
    80200120:	103c                	add	a5,sp,40
    80200122:	862e                	mv	a2,a1
    80200124:	85aa                	mv	a1,a0
    80200126:	00001517          	auipc	a0,0x1
    8020012a:	53250513          	add	a0,a0,1330 # 80201658 <etext+0x1c>
    8020012e:	e43e                	sd	a5,8(sp)
    80200130:	f53ff0ef          	jal	80200082 <cprintf>
    80200134:	65a2                	ld	a1,8(sp)
    80200136:	8522                	mv	a0,s0
    80200138:	f2bff0ef          	jal	80200062 <vcprintf>
    8020013c:	00002517          	auipc	a0,0x2
    80200140:	95450513          	add	a0,a0,-1708 # 80201a90 <etext+0x454>
    80200144:	f3fff0ef          	jal	80200082 <cprintf>
    80200148:	026000ef          	jal	8020016e <intr_disable>
    8020014c:	a001                	j	8020014c <__panic+0x54>

000000008020014e <clock_set_next_event>:
    8020014e:	c0102573          	rdtime	a0
    80200152:	67e1                	lui	a5,0x18
    80200154:	6a078793          	add	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200158:	953e                	add	a0,a0,a5
    8020015a:	49a0106f          	j	802015f4 <sbi_set_timer>

000000008020015e <cons_init>:
    8020015e:	8082                	ret

0000000080200160 <cons_putc>:
    80200160:	0ff57513          	zext.b	a0,a0
    80200164:	4760106f          	j	802015da <sbi_console_putchar>

0000000080200168 <intr_enable>:
    80200168:	100167f3          	csrrs	a5,sstatus,2
    8020016c:	8082                	ret

000000008020016e <intr_disable>:
    8020016e:	100177f3          	csrrc	a5,sstatus,2
    80200172:	8082                	ret

0000000080200174 <idt_init>:
    80200174:	14005073          	csrw	sscratch,0
    80200178:	00000797          	auipc	a5,0x0
    8020017c:	2e478793          	add	a5,a5,740 # 8020045c <__alltraps>
    80200180:	10579073          	csrw	stvec,a5
    80200184:	8082                	ret

0000000080200186 <print_regs>:
    80200186:	610c                	ld	a1,0(a0)
    80200188:	1141                	add	sp,sp,-16
    8020018a:	e022                	sd	s0,0(sp)
    8020018c:	842a                	mv	s0,a0
    8020018e:	00001517          	auipc	a0,0x1
    80200192:	4ea50513          	add	a0,a0,1258 # 80201678 <etext+0x3c>
    80200196:	e406                	sd	ra,8(sp)
    80200198:	eebff0ef          	jal	80200082 <cprintf>
    8020019c:	640c                	ld	a1,8(s0)
    8020019e:	00001517          	auipc	a0,0x1
    802001a2:	4f250513          	add	a0,a0,1266 # 80201690 <etext+0x54>
    802001a6:	eddff0ef          	jal	80200082 <cprintf>
    802001aa:	680c                	ld	a1,16(s0)
    802001ac:	00001517          	auipc	a0,0x1
    802001b0:	4fc50513          	add	a0,a0,1276 # 802016a8 <etext+0x6c>
    802001b4:	ecfff0ef          	jal	80200082 <cprintf>
    802001b8:	6c0c                	ld	a1,24(s0)
    802001ba:	00001517          	auipc	a0,0x1
    802001be:	50650513          	add	a0,a0,1286 # 802016c0 <etext+0x84>
    802001c2:	ec1ff0ef          	jal	80200082 <cprintf>
    802001c6:	700c                	ld	a1,32(s0)
    802001c8:	00001517          	auipc	a0,0x1
    802001cc:	51050513          	add	a0,a0,1296 # 802016d8 <etext+0x9c>
    802001d0:	eb3ff0ef          	jal	80200082 <cprintf>
    802001d4:	740c                	ld	a1,40(s0)
    802001d6:	00001517          	auipc	a0,0x1
    802001da:	51a50513          	add	a0,a0,1306 # 802016f0 <etext+0xb4>
    802001de:	ea5ff0ef          	jal	80200082 <cprintf>
    802001e2:	780c                	ld	a1,48(s0)
    802001e4:	00001517          	auipc	a0,0x1
    802001e8:	52450513          	add	a0,a0,1316 # 80201708 <etext+0xcc>
    802001ec:	e97ff0ef          	jal	80200082 <cprintf>
    802001f0:	7c0c                	ld	a1,56(s0)
    802001f2:	00001517          	auipc	a0,0x1
    802001f6:	52e50513          	add	a0,a0,1326 # 80201720 <etext+0xe4>
    802001fa:	e89ff0ef          	jal	80200082 <cprintf>
    802001fe:	602c                	ld	a1,64(s0)
    80200200:	00001517          	auipc	a0,0x1
    80200204:	53850513          	add	a0,a0,1336 # 80201738 <etext+0xfc>
    80200208:	e7bff0ef          	jal	80200082 <cprintf>
    8020020c:	642c                	ld	a1,72(s0)
    8020020e:	00001517          	auipc	a0,0x1
    80200212:	54250513          	add	a0,a0,1346 # 80201750 <etext+0x114>
    80200216:	e6dff0ef          	jal	80200082 <cprintf>
    8020021a:	682c                	ld	a1,80(s0)
    8020021c:	00001517          	auipc	a0,0x1
    80200220:	54c50513          	add	a0,a0,1356 # 80201768 <etext+0x12c>
    80200224:	e5fff0ef          	jal	80200082 <cprintf>
    80200228:	6c2c                	ld	a1,88(s0)
    8020022a:	00001517          	auipc	a0,0x1
    8020022e:	55650513          	add	a0,a0,1366 # 80201780 <etext+0x144>
    80200232:	e51ff0ef          	jal	80200082 <cprintf>
    80200236:	702c                	ld	a1,96(s0)
    80200238:	00001517          	auipc	a0,0x1
    8020023c:	56050513          	add	a0,a0,1376 # 80201798 <etext+0x15c>
    80200240:	e43ff0ef          	jal	80200082 <cprintf>
    80200244:	742c                	ld	a1,104(s0)
    80200246:	00001517          	auipc	a0,0x1
    8020024a:	56a50513          	add	a0,a0,1386 # 802017b0 <etext+0x174>
    8020024e:	e35ff0ef          	jal	80200082 <cprintf>
    80200252:	782c                	ld	a1,112(s0)
    80200254:	00001517          	auipc	a0,0x1
    80200258:	57450513          	add	a0,a0,1396 # 802017c8 <etext+0x18c>
    8020025c:	e27ff0ef          	jal	80200082 <cprintf>
    80200260:	7c2c                	ld	a1,120(s0)
    80200262:	00001517          	auipc	a0,0x1
    80200266:	57e50513          	add	a0,a0,1406 # 802017e0 <etext+0x1a4>
    8020026a:	e19ff0ef          	jal	80200082 <cprintf>
    8020026e:	604c                	ld	a1,128(s0)
    80200270:	00001517          	auipc	a0,0x1
    80200274:	58850513          	add	a0,a0,1416 # 802017f8 <etext+0x1bc>
    80200278:	e0bff0ef          	jal	80200082 <cprintf>
    8020027c:	644c                	ld	a1,136(s0)
    8020027e:	00001517          	auipc	a0,0x1
    80200282:	59250513          	add	a0,a0,1426 # 80201810 <etext+0x1d4>
    80200286:	dfdff0ef          	jal	80200082 <cprintf>
    8020028a:	684c                	ld	a1,144(s0)
    8020028c:	00001517          	auipc	a0,0x1
    80200290:	59c50513          	add	a0,a0,1436 # 80201828 <etext+0x1ec>
    80200294:	defff0ef          	jal	80200082 <cprintf>
    80200298:	6c4c                	ld	a1,152(s0)
    8020029a:	00001517          	auipc	a0,0x1
    8020029e:	5a650513          	add	a0,a0,1446 # 80201840 <etext+0x204>
    802002a2:	de1ff0ef          	jal	80200082 <cprintf>
    802002a6:	704c                	ld	a1,160(s0)
    802002a8:	00001517          	auipc	a0,0x1
    802002ac:	5b050513          	add	a0,a0,1456 # 80201858 <etext+0x21c>
    802002b0:	dd3ff0ef          	jal	80200082 <cprintf>
    802002b4:	744c                	ld	a1,168(s0)
    802002b6:	00001517          	auipc	a0,0x1
    802002ba:	5ba50513          	add	a0,a0,1466 # 80201870 <etext+0x234>
    802002be:	dc5ff0ef          	jal	80200082 <cprintf>
    802002c2:	784c                	ld	a1,176(s0)
    802002c4:	00001517          	auipc	a0,0x1
    802002c8:	5c450513          	add	a0,a0,1476 # 80201888 <etext+0x24c>
    802002cc:	db7ff0ef          	jal	80200082 <cprintf>
    802002d0:	7c4c                	ld	a1,184(s0)
    802002d2:	00001517          	auipc	a0,0x1
    802002d6:	5ce50513          	add	a0,a0,1486 # 802018a0 <etext+0x264>
    802002da:	da9ff0ef          	jal	80200082 <cprintf>
    802002de:	606c                	ld	a1,192(s0)
    802002e0:	00001517          	auipc	a0,0x1
    802002e4:	5d850513          	add	a0,a0,1496 # 802018b8 <etext+0x27c>
    802002e8:	d9bff0ef          	jal	80200082 <cprintf>
    802002ec:	646c                	ld	a1,200(s0)
    802002ee:	00001517          	auipc	a0,0x1
    802002f2:	5e250513          	add	a0,a0,1506 # 802018d0 <etext+0x294>
    802002f6:	d8dff0ef          	jal	80200082 <cprintf>
    802002fa:	686c                	ld	a1,208(s0)
    802002fc:	00001517          	auipc	a0,0x1
    80200300:	5ec50513          	add	a0,a0,1516 # 802018e8 <etext+0x2ac>
    80200304:	d7fff0ef          	jal	80200082 <cprintf>
    80200308:	6c6c                	ld	a1,216(s0)
    8020030a:	00001517          	auipc	a0,0x1
    8020030e:	5f650513          	add	a0,a0,1526 # 80201900 <etext+0x2c4>
    80200312:	d71ff0ef          	jal	80200082 <cprintf>
    80200316:	706c                	ld	a1,224(s0)
    80200318:	00001517          	auipc	a0,0x1
    8020031c:	60050513          	add	a0,a0,1536 # 80201918 <etext+0x2dc>
    80200320:	d63ff0ef          	jal	80200082 <cprintf>
    80200324:	746c                	ld	a1,232(s0)
    80200326:	00001517          	auipc	a0,0x1
    8020032a:	60a50513          	add	a0,a0,1546 # 80201930 <etext+0x2f4>
    8020032e:	d55ff0ef          	jal	80200082 <cprintf>
    80200332:	786c                	ld	a1,240(s0)
    80200334:	00001517          	auipc	a0,0x1
    80200338:	61450513          	add	a0,a0,1556 # 80201948 <etext+0x30c>
    8020033c:	d47ff0ef          	jal	80200082 <cprintf>
    80200340:	7c6c                	ld	a1,248(s0)
    80200342:	6402                	ld	s0,0(sp)
    80200344:	60a2                	ld	ra,8(sp)
    80200346:	00001517          	auipc	a0,0x1
    8020034a:	61a50513          	add	a0,a0,1562 # 80201960 <etext+0x324>
    8020034e:	0141                	add	sp,sp,16
    80200350:	bb0d                	j	80200082 <cprintf>

0000000080200352 <print_trapframe>:
    80200352:	1141                	add	sp,sp,-16
    80200354:	e022                	sd	s0,0(sp)
    80200356:	85aa                	mv	a1,a0
    80200358:	842a                	mv	s0,a0
    8020035a:	00001517          	auipc	a0,0x1
    8020035e:	61e50513          	add	a0,a0,1566 # 80201978 <etext+0x33c>
    80200362:	e406                	sd	ra,8(sp)
    80200364:	d1fff0ef          	jal	80200082 <cprintf>
    80200368:	8522                	mv	a0,s0
    8020036a:	e1dff0ef          	jal	80200186 <print_regs>
    8020036e:	10043583          	ld	a1,256(s0)
    80200372:	00001517          	auipc	a0,0x1
    80200376:	61e50513          	add	a0,a0,1566 # 80201990 <etext+0x354>
    8020037a:	d09ff0ef          	jal	80200082 <cprintf>
    8020037e:	10843583          	ld	a1,264(s0)
    80200382:	00001517          	auipc	a0,0x1
    80200386:	62650513          	add	a0,a0,1574 # 802019a8 <etext+0x36c>
    8020038a:	cf9ff0ef          	jal	80200082 <cprintf>
    8020038e:	11043583          	ld	a1,272(s0)
    80200392:	00001517          	auipc	a0,0x1
    80200396:	62e50513          	add	a0,a0,1582 # 802019c0 <etext+0x384>
    8020039a:	ce9ff0ef          	jal	80200082 <cprintf>
    8020039e:	11843583          	ld	a1,280(s0)
    802003a2:	6402                	ld	s0,0(sp)
    802003a4:	60a2                	ld	ra,8(sp)
    802003a6:	00001517          	auipc	a0,0x1
    802003aa:	63250513          	add	a0,a0,1586 # 802019d8 <etext+0x39c>
    802003ae:	0141                	add	sp,sp,16
    802003b0:	b9c9                	j	80200082 <cprintf>

00000000802003b2 <interrupt_handler>:
    802003b2:	11853783          	ld	a5,280(a0)
    802003b6:	472d                	li	a4,11
    802003b8:	0786                	sll	a5,a5,0x1
    802003ba:	8385                	srl	a5,a5,0x1
    802003bc:	06f76c63          	bltu	a4,a5,80200434 <interrupt_handler+0x82>
    802003c0:	00001717          	auipc	a4,0x1
    802003c4:	6f870713          	add	a4,a4,1784 # 80201ab8 <etext+0x47c>
    802003c8:	078a                	sll	a5,a5,0x2
    802003ca:	97ba                	add	a5,a5,a4
    802003cc:	439c                	lw	a5,0(a5)
    802003ce:	97ba                	add	a5,a5,a4
    802003d0:	8782                	jr	a5
    802003d2:	00001517          	auipc	a0,0x1
    802003d6:	67e50513          	add	a0,a0,1662 # 80201a50 <etext+0x414>
    802003da:	b165                	j	80200082 <cprintf>
    802003dc:	00001517          	auipc	a0,0x1
    802003e0:	65450513          	add	a0,a0,1620 # 80201a30 <etext+0x3f4>
    802003e4:	b979                	j	80200082 <cprintf>
    802003e6:	00001517          	auipc	a0,0x1
    802003ea:	60a50513          	add	a0,a0,1546 # 802019f0 <etext+0x3b4>
    802003ee:	b951                	j	80200082 <cprintf>
    802003f0:	00001517          	auipc	a0,0x1
    802003f4:	68050513          	add	a0,a0,1664 # 80201a70 <etext+0x434>
    802003f8:	b169                	j	80200082 <cprintf>
    802003fa:	1141                	add	sp,sp,-16
    802003fc:	e406                	sd	ra,8(sp)
    802003fe:	d51ff0ef          	jal	8020014e <clock_set_next_event>
    80200402:	00005697          	auipc	a3,0x5
    80200406:	c2668693          	add	a3,a3,-986 # 80205028 <ticks>
    8020040a:	629c                	ld	a5,0(a3)
    8020040c:	06400713          	li	a4,100
    80200410:	0785                	add	a5,a5,1
    80200412:	02e7f733          	remu	a4,a5,a4
    80200416:	e29c                	sd	a5,0(a3)
    80200418:	cf19                	beqz	a4,80200436 <interrupt_handler+0x84>
    8020041a:	60a2                	ld	ra,8(sp)
    8020041c:	0141                	add	sp,sp,16
    8020041e:	8082                	ret
    80200420:	00001517          	auipc	a0,0x1
    80200424:	67850513          	add	a0,a0,1656 # 80201a98 <etext+0x45c>
    80200428:	b9a9                	j	80200082 <cprintf>
    8020042a:	00001517          	auipc	a0,0x1
    8020042e:	5e650513          	add	a0,a0,1510 # 80201a10 <etext+0x3d4>
    80200432:	b981                	j	80200082 <cprintf>
    80200434:	bf39                	j	80200352 <print_trapframe>
    80200436:	60a2                	ld	ra,8(sp)
    80200438:	06400593          	li	a1,100
    8020043c:	00001517          	auipc	a0,0x1
    80200440:	64c50513          	add	a0,a0,1612 # 80201a88 <etext+0x44c>
    80200444:	0141                	add	sp,sp,16
    80200446:	b935                	j	80200082 <cprintf>

0000000080200448 <trap>:
    80200448:	11853783          	ld	a5,280(a0)
    8020044c:	0007c763          	bltz	a5,8020045a <trap+0x12>
    80200450:	472d                	li	a4,11
    80200452:	00f76363          	bltu	a4,a5,80200458 <trap+0x10>
    80200456:	8082                	ret
    80200458:	bded                	j	80200352 <print_trapframe>
    8020045a:	bfa1                	j	802003b2 <interrupt_handler>

000000008020045c <__alltraps>:
    8020045c:	14011073          	csrw	sscratch,sp
    80200460:	712d                	add	sp,sp,-288
    80200462:	e002                	sd	zero,0(sp)
    80200464:	e406                	sd	ra,8(sp)
    80200466:	ec0e                	sd	gp,24(sp)
    80200468:	f012                	sd	tp,32(sp)
    8020046a:	f416                	sd	t0,40(sp)
    8020046c:	f81a                	sd	t1,48(sp)
    8020046e:	fc1e                	sd	t2,56(sp)
    80200470:	e0a2                	sd	s0,64(sp)
    80200472:	e4a6                	sd	s1,72(sp)
    80200474:	e8aa                	sd	a0,80(sp)
    80200476:	ecae                	sd	a1,88(sp)
    80200478:	f0b2                	sd	a2,96(sp)
    8020047a:	f4b6                	sd	a3,104(sp)
    8020047c:	f8ba                	sd	a4,112(sp)
    8020047e:	fcbe                	sd	a5,120(sp)
    80200480:	e142                	sd	a6,128(sp)
    80200482:	e546                	sd	a7,136(sp)
    80200484:	e94a                	sd	s2,144(sp)
    80200486:	ed4e                	sd	s3,152(sp)
    80200488:	f152                	sd	s4,160(sp)
    8020048a:	f556                	sd	s5,168(sp)
    8020048c:	f95a                	sd	s6,176(sp)
    8020048e:	fd5e                	sd	s7,184(sp)
    80200490:	e1e2                	sd	s8,192(sp)
    80200492:	e5e6                	sd	s9,200(sp)
    80200494:	e9ea                	sd	s10,208(sp)
    80200496:	edee                	sd	s11,216(sp)
    80200498:	f1f2                	sd	t3,224(sp)
    8020049a:	f5f6                	sd	t4,232(sp)
    8020049c:	f9fa                	sd	t5,240(sp)
    8020049e:	fdfe                	sd	t6,248(sp)
    802004a0:	14001473          	csrrw	s0,sscratch,zero
    802004a4:	100024f3          	csrr	s1,sstatus
    802004a8:	14102973          	csrr	s2,sepc
    802004ac:	143029f3          	csrr	s3,stval
    802004b0:	14202a73          	csrr	s4,scause
    802004b4:	e822                	sd	s0,16(sp)
    802004b6:	e226                	sd	s1,256(sp)
    802004b8:	e64a                	sd	s2,264(sp)
    802004ba:	ea4e                	sd	s3,272(sp)
    802004bc:	ee52                	sd	s4,280(sp)
    802004be:	850a                	mv	a0,sp
    802004c0:	f89ff0ef          	jal	80200448 <trap>

00000000802004c4 <__trapret>:
    802004c4:	6492                	ld	s1,256(sp)
    802004c6:	6932                	ld	s2,264(sp)
    802004c8:	10049073          	csrw	sstatus,s1
    802004cc:	14191073          	csrw	sepc,s2
    802004d0:	60a2                	ld	ra,8(sp)
    802004d2:	61e2                	ld	gp,24(sp)
    802004d4:	7202                	ld	tp,32(sp)
    802004d6:	72a2                	ld	t0,40(sp)
    802004d8:	7342                	ld	t1,48(sp)
    802004da:	73e2                	ld	t2,56(sp)
    802004dc:	6406                	ld	s0,64(sp)
    802004de:	64a6                	ld	s1,72(sp)
    802004e0:	6546                	ld	a0,80(sp)
    802004e2:	65e6                	ld	a1,88(sp)
    802004e4:	7606                	ld	a2,96(sp)
    802004e6:	76a6                	ld	a3,104(sp)
    802004e8:	7746                	ld	a4,112(sp)
    802004ea:	77e6                	ld	a5,120(sp)
    802004ec:	680a                	ld	a6,128(sp)
    802004ee:	68aa                	ld	a7,136(sp)
    802004f0:	694a                	ld	s2,144(sp)
    802004f2:	69ea                	ld	s3,152(sp)
    802004f4:	7a0a                	ld	s4,160(sp)
    802004f6:	7aaa                	ld	s5,168(sp)
    802004f8:	7b4a                	ld	s6,176(sp)
    802004fa:	7bea                	ld	s7,184(sp)
    802004fc:	6c0e                	ld	s8,192(sp)
    802004fe:	6cae                	ld	s9,200(sp)
    80200500:	6d4e                	ld	s10,208(sp)
    80200502:	6dee                	ld	s11,216(sp)
    80200504:	7e0e                	ld	t3,224(sp)
    80200506:	7eae                	ld	t4,232(sp)
    80200508:	7f4e                	ld	t5,240(sp)
    8020050a:	7fee                	ld	t6,248(sp)
    8020050c:	6142                	ld	sp,16(sp)
    8020050e:	10200073          	sret

0000000080200512 <default_init>:
    80200512:	00005797          	auipc	a5,0x5
    80200516:	af678793          	add	a5,a5,-1290 # 80205008 <free_area>
    8020051a:	e79c                	sd	a5,8(a5)
    8020051c:	e39c                	sd	a5,0(a5)
    8020051e:	0007a823          	sw	zero,16(a5)
    80200522:	8082                	ret

0000000080200524 <default_nr_free_pages>:
    80200524:	00005517          	auipc	a0,0x5
    80200528:	af456503          	lwu	a0,-1292(a0) # 80205018 <free_area+0x10>
    8020052c:	8082                	ret

000000008020052e <firstfit_check_final>:
    8020052e:	715d                	add	sp,sp,-80
    80200530:	e0a2                	sd	s0,64(sp)
    80200532:	00005417          	auipc	s0,0x5
    80200536:	ad640413          	add	s0,s0,-1322 # 80205008 <free_area>
    8020053a:	641c                	ld	a5,8(s0)
    8020053c:	e486                	sd	ra,72(sp)
    8020053e:	fc26                	sd	s1,56(sp)
    80200540:	f84a                	sd	s2,48(sp)
    80200542:	f44e                	sd	s3,40(sp)
    80200544:	f052                	sd	s4,32(sp)
    80200546:	ec56                	sd	s5,24(sp)
    80200548:	e85a                	sd	s6,16(sp)
    8020054a:	e45e                	sd	s7,8(sp)
    8020054c:	e062                	sd	s8,0(sp)
    8020054e:	2c878763          	beq	a5,s0,8020081c <firstfit_check_final+0x2ee>
    80200552:	4481                	li	s1,0
    80200554:	4901                	li	s2,0
    80200556:	ff07b703          	ld	a4,-16(a5)
    8020055a:	8b09                	and	a4,a4,2
    8020055c:	2c070463          	beqz	a4,80200824 <firstfit_check_final+0x2f6>
    80200560:	ff87a703          	lw	a4,-8(a5)
    80200564:	679c                	ld	a5,8(a5)
    80200566:	2905                	addw	s2,s2,1
    80200568:	9cb9                	addw	s1,s1,a4
    8020056a:	fe8796e3          	bne	a5,s0,80200556 <firstfit_check_final+0x28>
    8020056e:	89a6                	mv	s3,s1
    80200570:	2f3000ef          	jal	80201062 <nr_free_pages>
    80200574:	71351863          	bne	a0,s3,80200c84 <firstfit_check_final+0x756>
    80200578:	4505                	li	a0,1
    8020057a:	26b000ef          	jal	80200fe4 <alloc_pages>
    8020057e:	8a2a                	mv	s4,a0
    80200580:	44050263          	beqz	a0,802009c4 <firstfit_check_final+0x496>
    80200584:	4505                	li	a0,1
    80200586:	25f000ef          	jal	80200fe4 <alloc_pages>
    8020058a:	89aa                	mv	s3,a0
    8020058c:	70050c63          	beqz	a0,80200ca4 <firstfit_check_final+0x776>
    80200590:	4505                	li	a0,1
    80200592:	253000ef          	jal	80200fe4 <alloc_pages>
    80200596:	8aaa                	mv	s5,a0
    80200598:	4a050663          	beqz	a0,80200a44 <firstfit_check_final+0x516>
    8020059c:	2b3a0463          	beq	s4,s3,80200844 <firstfit_check_final+0x316>
    802005a0:	2aaa0263          	beq	s4,a0,80200844 <firstfit_check_final+0x316>
    802005a4:	2aa98063          	beq	s3,a0,80200844 <firstfit_check_final+0x316>
    802005a8:	000a2783          	lw	a5,0(s4)
    802005ac:	2a079c63          	bnez	a5,80200864 <firstfit_check_final+0x336>
    802005b0:	0009a783          	lw	a5,0(s3)
    802005b4:	2a079863          	bnez	a5,80200864 <firstfit_check_final+0x336>
    802005b8:	411c                	lw	a5,0(a0)
    802005ba:	2a079563          	bnez	a5,80200864 <firstfit_check_final+0x336>
    802005be:	00005797          	auipc	a5,0x5
    802005c2:	a8a7b783          	ld	a5,-1398(a5) # 80205048 <pages>
    802005c6:	40fa0733          	sub	a4,s4,a5
    802005ca:	870d                	sra	a4,a4,0x3
    802005cc:	00002597          	auipc	a1,0x2
    802005d0:	c445b583          	ld	a1,-956(a1) # 80202210 <error_string+0x38>
    802005d4:	02b70733          	mul	a4,a4,a1
    802005d8:	00002617          	auipc	a2,0x2
    802005dc:	c4063603          	ld	a2,-960(a2) # 80202218 <nbase>
    802005e0:	00005697          	auipc	a3,0x5
    802005e4:	a606b683          	ld	a3,-1440(a3) # 80205040 <npage>
    802005e8:	06b2                	sll	a3,a3,0xc
    802005ea:	9732                	add	a4,a4,a2
    802005ec:	0732                	sll	a4,a4,0xc
    802005ee:	28d77b63          	bgeu	a4,a3,80200884 <firstfit_check_final+0x356>
    802005f2:	40f98733          	sub	a4,s3,a5
    802005f6:	870d                	sra	a4,a4,0x3
    802005f8:	02b70733          	mul	a4,a4,a1
    802005fc:	9732                	add	a4,a4,a2
    802005fe:	0732                	sll	a4,a4,0xc
    80200600:	4cd77263          	bgeu	a4,a3,80200ac4 <firstfit_check_final+0x596>
    80200604:	40f507b3          	sub	a5,a0,a5
    80200608:	878d                	sra	a5,a5,0x3
    8020060a:	02b787b3          	mul	a5,a5,a1
    8020060e:	97b2                	add	a5,a5,a2
    80200610:	07b2                	sll	a5,a5,0xc
    80200612:	30d7f963          	bgeu	a5,a3,80200924 <firstfit_check_final+0x3f6>
    80200616:	4505                	li	a0,1
    80200618:	00043c03          	ld	s8,0(s0)
    8020061c:	00843b83          	ld	s7,8(s0)
    80200620:	01042b03          	lw	s6,16(s0)
    80200624:	e400                	sd	s0,8(s0)
    80200626:	e000                	sd	s0,0(s0)
    80200628:	00005797          	auipc	a5,0x5
    8020062c:	9e07a823          	sw	zero,-1552(a5) # 80205018 <free_area+0x10>
    80200630:	1b5000ef          	jal	80200fe4 <alloc_pages>
    80200634:	2c051863          	bnez	a0,80200904 <firstfit_check_final+0x3d6>
    80200638:	4585                	li	a1,1
    8020063a:	8552                	mv	a0,s4
    8020063c:	1e7000ef          	jal	80201022 <free_pages>
    80200640:	4585                	li	a1,1
    80200642:	854e                	mv	a0,s3
    80200644:	1df000ef          	jal	80201022 <free_pages>
    80200648:	4585                	li	a1,1
    8020064a:	8556                	mv	a0,s5
    8020064c:	1d7000ef          	jal	80201022 <free_pages>
    80200650:	4818                	lw	a4,16(s0)
    80200652:	478d                	li	a5,3
    80200654:	28f71863          	bne	a4,a5,802008e4 <firstfit_check_final+0x3b6>
    80200658:	4505                	li	a0,1
    8020065a:	18b000ef          	jal	80200fe4 <alloc_pages>
    8020065e:	89aa                	mv	s3,a0
    80200660:	26050263          	beqz	a0,802008c4 <firstfit_check_final+0x396>
    80200664:	4505                	li	a0,1
    80200666:	17f000ef          	jal	80200fe4 <alloc_pages>
    8020066a:	8aaa                	mv	s5,a0
    8020066c:	3a050c63          	beqz	a0,80200a24 <firstfit_check_final+0x4f6>
    80200670:	4505                	li	a0,1
    80200672:	173000ef          	jal	80200fe4 <alloc_pages>
    80200676:	8a2a                	mv	s4,a0
    80200678:	38050663          	beqz	a0,80200a04 <firstfit_check_final+0x4d6>
    8020067c:	4505                	li	a0,1
    8020067e:	167000ef          	jal	80200fe4 <alloc_pages>
    80200682:	36051163          	bnez	a0,802009e4 <firstfit_check_final+0x4b6>
    80200686:	4585                	li	a1,1
    80200688:	854e                	mv	a0,s3
    8020068a:	199000ef          	jal	80201022 <free_pages>
    8020068e:	641c                	ld	a5,8(s0)
    80200690:	20878a63          	beq	a5,s0,802008a4 <firstfit_check_final+0x376>
    80200694:	4505                	li	a0,1
    80200696:	14f000ef          	jal	80200fe4 <alloc_pages>
    8020069a:	30a99563          	bne	s3,a0,802009a4 <firstfit_check_final+0x476>
    8020069e:	4505                	li	a0,1
    802006a0:	145000ef          	jal	80200fe4 <alloc_pages>
    802006a4:	2e051063          	bnez	a0,80200984 <firstfit_check_final+0x456>
    802006a8:	481c                	lw	a5,16(s0)
    802006aa:	2a079d63          	bnez	a5,80200964 <firstfit_check_final+0x436>
    802006ae:	854e                	mv	a0,s3
    802006b0:	4585                	li	a1,1
    802006b2:	01843023          	sd	s8,0(s0)
    802006b6:	01743423          	sd	s7,8(s0)
    802006ba:	01642823          	sw	s6,16(s0)
    802006be:	165000ef          	jal	80201022 <free_pages>
    802006c2:	4585                	li	a1,1
    802006c4:	8556                	mv	a0,s5
    802006c6:	15d000ef          	jal	80201022 <free_pages>
    802006ca:	4585                	li	a1,1
    802006cc:	8552                	mv	a0,s4
    802006ce:	155000ef          	jal	80201022 <free_pages>
    802006d2:	4515                	li	a0,5
    802006d4:	111000ef          	jal	80200fe4 <alloc_pages>
    802006d8:	89aa                	mv	s3,a0
    802006da:	26050563          	beqz	a0,80200944 <firstfit_check_final+0x416>
    802006de:	651c                	ld	a5,8(a0)
    802006e0:	8385                	srl	a5,a5,0x1
    802006e2:	8b85                	and	a5,a5,1
    802006e4:	54079063          	bnez	a5,80200c24 <firstfit_check_final+0x6f6>
    802006e8:	4505                	li	a0,1
    802006ea:	00043b03          	ld	s6,0(s0)
    802006ee:	00843a83          	ld	s5,8(s0)
    802006f2:	e000                	sd	s0,0(s0)
    802006f4:	e400                	sd	s0,8(s0)
    802006f6:	0ef000ef          	jal	80200fe4 <alloc_pages>
    802006fa:	50051563          	bnez	a0,80200c04 <firstfit_check_final+0x6d6>
    802006fe:	05098a13          	add	s4,s3,80
    80200702:	8552                	mv	a0,s4
    80200704:	458d                	li	a1,3
    80200706:	01042b83          	lw	s7,16(s0)
    8020070a:	00005797          	auipc	a5,0x5
    8020070e:	9007a723          	sw	zero,-1778(a5) # 80205018 <free_area+0x10>
    80200712:	111000ef          	jal	80201022 <free_pages>
    80200716:	4511                	li	a0,4
    80200718:	0cd000ef          	jal	80200fe4 <alloc_pages>
    8020071c:	4c051463          	bnez	a0,80200be4 <firstfit_check_final+0x6b6>
    80200720:	0589b783          	ld	a5,88(s3)
    80200724:	8385                	srl	a5,a5,0x1
    80200726:	8b85                	and	a5,a5,1
    80200728:	48078e63          	beqz	a5,80200bc4 <firstfit_check_final+0x696>
    8020072c:	0609a703          	lw	a4,96(s3)
    80200730:	478d                	li	a5,3
    80200732:	48f71963          	bne	a4,a5,80200bc4 <firstfit_check_final+0x696>
    80200736:	450d                	li	a0,3
    80200738:	0ad000ef          	jal	80200fe4 <alloc_pages>
    8020073c:	8c2a                	mv	s8,a0
    8020073e:	46050363          	beqz	a0,80200ba4 <firstfit_check_final+0x676>
    80200742:	4505                	li	a0,1
    80200744:	0a1000ef          	jal	80200fe4 <alloc_pages>
    80200748:	42051e63          	bnez	a0,80200b84 <firstfit_check_final+0x656>
    8020074c:	418a1c63          	bne	s4,s8,80200b64 <firstfit_check_final+0x636>
    80200750:	4585                	li	a1,1
    80200752:	854e                	mv	a0,s3
    80200754:	0cf000ef          	jal	80201022 <free_pages>
    80200758:	458d                	li	a1,3
    8020075a:	8552                	mv	a0,s4
    8020075c:	0c7000ef          	jal	80201022 <free_pages>
    80200760:	0089b783          	ld	a5,8(s3)
    80200764:	02898c13          	add	s8,s3,40
    80200768:	8385                	srl	a5,a5,0x1
    8020076a:	8b85                	and	a5,a5,1
    8020076c:	3c078c63          	beqz	a5,80200b44 <firstfit_check_final+0x616>
    80200770:	0109a703          	lw	a4,16(s3)
    80200774:	4785                	li	a5,1
    80200776:	3cf71763          	bne	a4,a5,80200b44 <firstfit_check_final+0x616>
    8020077a:	008a3783          	ld	a5,8(s4)
    8020077e:	8385                	srl	a5,a5,0x1
    80200780:	8b85                	and	a5,a5,1
    80200782:	3a078163          	beqz	a5,80200b24 <firstfit_check_final+0x5f6>
    80200786:	010a2703          	lw	a4,16(s4)
    8020078a:	478d                	li	a5,3
    8020078c:	38f71c63          	bne	a4,a5,80200b24 <firstfit_check_final+0x5f6>
    80200790:	4505                	li	a0,1
    80200792:	053000ef          	jal	80200fe4 <alloc_pages>
    80200796:	36a99763          	bne	s3,a0,80200b04 <firstfit_check_final+0x5d6>
    8020079a:	4585                	li	a1,1
    8020079c:	087000ef          	jal	80201022 <free_pages>
    802007a0:	4509                	li	a0,2
    802007a2:	043000ef          	jal	80200fe4 <alloc_pages>
    802007a6:	32aa1f63          	bne	s4,a0,80200ae4 <firstfit_check_final+0x5b6>
    802007aa:	4589                	li	a1,2
    802007ac:	077000ef          	jal	80201022 <free_pages>
    802007b0:	4585                	li	a1,1
    802007b2:	8562                	mv	a0,s8
    802007b4:	06f000ef          	jal	80201022 <free_pages>
    802007b8:	4515                	li	a0,5
    802007ba:	02b000ef          	jal	80200fe4 <alloc_pages>
    802007be:	89aa                	mv	s3,a0
    802007c0:	48050263          	beqz	a0,80200c44 <firstfit_check_final+0x716>
    802007c4:	4505                	li	a0,1
    802007c6:	01f000ef          	jal	80200fe4 <alloc_pages>
    802007ca:	2c051d63          	bnez	a0,80200aa4 <firstfit_check_final+0x576>
    802007ce:	481c                	lw	a5,16(s0)
    802007d0:	2a079a63          	bnez	a5,80200a84 <firstfit_check_final+0x556>
    802007d4:	4595                	li	a1,5
    802007d6:	854e                	mv	a0,s3
    802007d8:	01742823          	sw	s7,16(s0)
    802007dc:	01643023          	sd	s6,0(s0)
    802007e0:	01543423          	sd	s5,8(s0)
    802007e4:	03f000ef          	jal	80201022 <free_pages>
    802007e8:	641c                	ld	a5,8(s0)
    802007ea:	00878963          	beq	a5,s0,802007fc <firstfit_check_final+0x2ce>
    802007ee:	ff87a703          	lw	a4,-8(a5)
    802007f2:	679c                	ld	a5,8(a5)
    802007f4:	397d                	addw	s2,s2,-1
    802007f6:	9c99                	subw	s1,s1,a4
    802007f8:	fe879be3          	bne	a5,s0,802007ee <firstfit_check_final+0x2c0>
    802007fc:	26091463          	bnez	s2,80200a64 <firstfit_check_final+0x536>
    80200800:	46049263          	bnez	s1,80200c64 <firstfit_check_final+0x736>
    80200804:	60a6                	ld	ra,72(sp)
    80200806:	6406                	ld	s0,64(sp)
    80200808:	74e2                	ld	s1,56(sp)
    8020080a:	7942                	ld	s2,48(sp)
    8020080c:	79a2                	ld	s3,40(sp)
    8020080e:	7a02                	ld	s4,32(sp)
    80200810:	6ae2                	ld	s5,24(sp)
    80200812:	6b42                	ld	s6,16(sp)
    80200814:	6ba2                	ld	s7,8(sp)
    80200816:	6c02                	ld	s8,0(sp)
    80200818:	6161                	add	sp,sp,80
    8020081a:	8082                	ret
    8020081c:	4981                	li	s3,0
    8020081e:	4481                	li	s1,0
    80200820:	4901                	li	s2,0
    80200822:	b3b9                	j	80200570 <firstfit_check_final+0x42>
    80200824:	00001697          	auipc	a3,0x1
    80200828:	2c468693          	add	a3,a3,708 # 80201ae8 <etext+0x4ac>
    8020082c:	00001617          	auipc	a2,0x1
    80200830:	2cc60613          	add	a2,a2,716 # 80201af8 <etext+0x4bc>
    80200834:	11c00593          	li	a1,284
    80200838:	00001517          	auipc	a0,0x1
    8020083c:	2d850513          	add	a0,a0,728 # 80201b10 <etext+0x4d4>
    80200840:	8b9ff0ef          	jal	802000f8 <__panic>
    80200844:	00001697          	auipc	a3,0x1
    80200848:	36468693          	add	a3,a3,868 # 80201ba8 <etext+0x56c>
    8020084c:	00001617          	auipc	a2,0x1
    80200850:	2ac60613          	add	a2,a2,684 # 80201af8 <etext+0x4bc>
    80200854:	0bf00593          	li	a1,191
    80200858:	00001517          	auipc	a0,0x1
    8020085c:	2b850513          	add	a0,a0,696 # 80201b10 <etext+0x4d4>
    80200860:	899ff0ef          	jal	802000f8 <__panic>
    80200864:	00001697          	auipc	a3,0x1
    80200868:	36c68693          	add	a3,a3,876 # 80201bd0 <etext+0x594>
    8020086c:	00001617          	auipc	a2,0x1
    80200870:	28c60613          	add	a2,a2,652 # 80201af8 <etext+0x4bc>
    80200874:	0c000593          	li	a1,192
    80200878:	00001517          	auipc	a0,0x1
    8020087c:	29850513          	add	a0,a0,664 # 80201b10 <etext+0x4d4>
    80200880:	879ff0ef          	jal	802000f8 <__panic>
    80200884:	00001697          	auipc	a3,0x1
    80200888:	38c68693          	add	a3,a3,908 # 80201c10 <etext+0x5d4>
    8020088c:	00001617          	auipc	a2,0x1
    80200890:	26c60613          	add	a2,a2,620 # 80201af8 <etext+0x4bc>
    80200894:	0c200593          	li	a1,194
    80200898:	00001517          	auipc	a0,0x1
    8020089c:	27850513          	add	a0,a0,632 # 80201b10 <etext+0x4d4>
    802008a0:	859ff0ef          	jal	802000f8 <__panic>
    802008a4:	00001697          	auipc	a3,0x1
    802008a8:	3f468693          	add	a3,a3,1012 # 80201c98 <etext+0x65c>
    802008ac:	00001617          	auipc	a2,0x1
    802008b0:	24c60613          	add	a2,a2,588 # 80201af8 <etext+0x4bc>
    802008b4:	0db00593          	li	a1,219
    802008b8:	00001517          	auipc	a0,0x1
    802008bc:	25850513          	add	a0,a0,600 # 80201b10 <etext+0x4d4>
    802008c0:	839ff0ef          	jal	802000f8 <__panic>
    802008c4:	00001697          	auipc	a3,0x1
    802008c8:	28468693          	add	a3,a3,644 # 80201b48 <etext+0x50c>
    802008cc:	00001617          	auipc	a2,0x1
    802008d0:	22c60613          	add	a2,a2,556 # 80201af8 <etext+0x4bc>
    802008d4:	0d400593          	li	a1,212
    802008d8:	00001517          	auipc	a0,0x1
    802008dc:	23850513          	add	a0,a0,568 # 80201b10 <etext+0x4d4>
    802008e0:	819ff0ef          	jal	802000f8 <__panic>
    802008e4:	00001697          	auipc	a3,0x1
    802008e8:	3a468693          	add	a3,a3,932 # 80201c88 <etext+0x64c>
    802008ec:	00001617          	auipc	a2,0x1
    802008f0:	20c60613          	add	a2,a2,524 # 80201af8 <etext+0x4bc>
    802008f4:	0d200593          	li	a1,210
    802008f8:	00001517          	auipc	a0,0x1
    802008fc:	21850513          	add	a0,a0,536 # 80201b10 <etext+0x4d4>
    80200900:	ff8ff0ef          	jal	802000f8 <__panic>
    80200904:	00001697          	auipc	a3,0x1
    80200908:	36c68693          	add	a3,a3,876 # 80201c70 <etext+0x634>
    8020090c:	00001617          	auipc	a2,0x1
    80200910:	1ec60613          	add	a2,a2,492 # 80201af8 <etext+0x4bc>
    80200914:	0cd00593          	li	a1,205
    80200918:	00001517          	auipc	a0,0x1
    8020091c:	1f850513          	add	a0,a0,504 # 80201b10 <etext+0x4d4>
    80200920:	fd8ff0ef          	jal	802000f8 <__panic>
    80200924:	00001697          	auipc	a3,0x1
    80200928:	32c68693          	add	a3,a3,812 # 80201c50 <etext+0x614>
    8020092c:	00001617          	auipc	a2,0x1
    80200930:	1cc60613          	add	a2,a2,460 # 80201af8 <etext+0x4bc>
    80200934:	0c400593          	li	a1,196
    80200938:	00001517          	auipc	a0,0x1
    8020093c:	1d850513          	add	a0,a0,472 # 80201b10 <etext+0x4d4>
    80200940:	fb8ff0ef          	jal	802000f8 <__panic>
    80200944:	00001697          	auipc	a3,0x1
    80200948:	39c68693          	add	a3,a3,924 # 80201ce0 <etext+0x6a4>
    8020094c:	00001617          	auipc	a2,0x1
    80200950:	1ac60613          	add	a2,a2,428 # 80201af8 <etext+0x4bc>
    80200954:	12400593          	li	a1,292
    80200958:	00001517          	auipc	a0,0x1
    8020095c:	1b850513          	add	a0,a0,440 # 80201b10 <etext+0x4d4>
    80200960:	f98ff0ef          	jal	802000f8 <__panic>
    80200964:	00001697          	auipc	a3,0x1
    80200968:	36c68693          	add	a3,a3,876 # 80201cd0 <etext+0x694>
    8020096c:	00001617          	auipc	a2,0x1
    80200970:	18c60613          	add	a2,a2,396 # 80201af8 <etext+0x4bc>
    80200974:	0e100593          	li	a1,225
    80200978:	00001517          	auipc	a0,0x1
    8020097c:	19850513          	add	a0,a0,408 # 80201b10 <etext+0x4d4>
    80200980:	f78ff0ef          	jal	802000f8 <__panic>
    80200984:	00001697          	auipc	a3,0x1
    80200988:	2ec68693          	add	a3,a3,748 # 80201c70 <etext+0x634>
    8020098c:	00001617          	auipc	a2,0x1
    80200990:	16c60613          	add	a2,a2,364 # 80201af8 <etext+0x4bc>
    80200994:	0df00593          	li	a1,223
    80200998:	00001517          	auipc	a0,0x1
    8020099c:	17850513          	add	a0,a0,376 # 80201b10 <etext+0x4d4>
    802009a0:	f58ff0ef          	jal	802000f8 <__panic>
    802009a4:	00001697          	auipc	a3,0x1
    802009a8:	30c68693          	add	a3,a3,780 # 80201cb0 <etext+0x674>
    802009ac:	00001617          	auipc	a2,0x1
    802009b0:	14c60613          	add	a2,a2,332 # 80201af8 <etext+0x4bc>
    802009b4:	0de00593          	li	a1,222
    802009b8:	00001517          	auipc	a0,0x1
    802009bc:	15850513          	add	a0,a0,344 # 80201b10 <etext+0x4d4>
    802009c0:	f38ff0ef          	jal	802000f8 <__panic>
    802009c4:	00001697          	auipc	a3,0x1
    802009c8:	18468693          	add	a3,a3,388 # 80201b48 <etext+0x50c>
    802009cc:	00001617          	auipc	a2,0x1
    802009d0:	12c60613          	add	a2,a2,300 # 80201af8 <etext+0x4bc>
    802009d4:	0bb00593          	li	a1,187
    802009d8:	00001517          	auipc	a0,0x1
    802009dc:	13850513          	add	a0,a0,312 # 80201b10 <etext+0x4d4>
    802009e0:	f18ff0ef          	jal	802000f8 <__panic>
    802009e4:	00001697          	auipc	a3,0x1
    802009e8:	28c68693          	add	a3,a3,652 # 80201c70 <etext+0x634>
    802009ec:	00001617          	auipc	a2,0x1
    802009f0:	10c60613          	add	a2,a2,268 # 80201af8 <etext+0x4bc>
    802009f4:	0d800593          	li	a1,216
    802009f8:	00001517          	auipc	a0,0x1
    802009fc:	11850513          	add	a0,a0,280 # 80201b10 <etext+0x4d4>
    80200a00:	ef8ff0ef          	jal	802000f8 <__panic>
    80200a04:	00001697          	auipc	a3,0x1
    80200a08:	18468693          	add	a3,a3,388 # 80201b88 <etext+0x54c>
    80200a0c:	00001617          	auipc	a2,0x1
    80200a10:	0ec60613          	add	a2,a2,236 # 80201af8 <etext+0x4bc>
    80200a14:	0d600593          	li	a1,214
    80200a18:	00001517          	auipc	a0,0x1
    80200a1c:	0f850513          	add	a0,a0,248 # 80201b10 <etext+0x4d4>
    80200a20:	ed8ff0ef          	jal	802000f8 <__panic>
    80200a24:	00001697          	auipc	a3,0x1
    80200a28:	14468693          	add	a3,a3,324 # 80201b68 <etext+0x52c>
    80200a2c:	00001617          	auipc	a2,0x1
    80200a30:	0cc60613          	add	a2,a2,204 # 80201af8 <etext+0x4bc>
    80200a34:	0d500593          	li	a1,213
    80200a38:	00001517          	auipc	a0,0x1
    80200a3c:	0d850513          	add	a0,a0,216 # 80201b10 <etext+0x4d4>
    80200a40:	eb8ff0ef          	jal	802000f8 <__panic>
    80200a44:	00001697          	auipc	a3,0x1
    80200a48:	14468693          	add	a3,a3,324 # 80201b88 <etext+0x54c>
    80200a4c:	00001617          	auipc	a2,0x1
    80200a50:	0ac60613          	add	a2,a2,172 # 80201af8 <etext+0x4bc>
    80200a54:	0bd00593          	li	a1,189
    80200a58:	00001517          	auipc	a0,0x1
    80200a5c:	0b850513          	add	a0,a0,184 # 80201b10 <etext+0x4d4>
    80200a60:	e98ff0ef          	jal	802000f8 <__panic>
    80200a64:	00001697          	auipc	a3,0x1
    80200a68:	3cc68693          	add	a3,a3,972 # 80201e30 <etext+0x7f4>
    80200a6c:	00001617          	auipc	a2,0x1
    80200a70:	08c60613          	add	a2,a2,140 # 80201af8 <etext+0x4bc>
    80200a74:	15100593          	li	a1,337
    80200a78:	00001517          	auipc	a0,0x1
    80200a7c:	09850513          	add	a0,a0,152 # 80201b10 <etext+0x4d4>
    80200a80:	e78ff0ef          	jal	802000f8 <__panic>
    80200a84:	00001697          	auipc	a3,0x1
    80200a88:	24c68693          	add	a3,a3,588 # 80201cd0 <etext+0x694>
    80200a8c:	00001617          	auipc	a2,0x1
    80200a90:	06c60613          	add	a2,a2,108 # 80201af8 <etext+0x4bc>
    80200a94:	14600593          	li	a1,326
    80200a98:	00001517          	auipc	a0,0x1
    80200a9c:	07850513          	add	a0,a0,120 # 80201b10 <etext+0x4d4>
    80200aa0:	e58ff0ef          	jal	802000f8 <__panic>
    80200aa4:	00001697          	auipc	a3,0x1
    80200aa8:	1cc68693          	add	a3,a3,460 # 80201c70 <etext+0x634>
    80200aac:	00001617          	auipc	a2,0x1
    80200ab0:	04c60613          	add	a2,a2,76 # 80201af8 <etext+0x4bc>
    80200ab4:	14400593          	li	a1,324
    80200ab8:	00001517          	auipc	a0,0x1
    80200abc:	05850513          	add	a0,a0,88 # 80201b10 <etext+0x4d4>
    80200ac0:	e38ff0ef          	jal	802000f8 <__panic>
    80200ac4:	00001697          	auipc	a3,0x1
    80200ac8:	16c68693          	add	a3,a3,364 # 80201c30 <etext+0x5f4>
    80200acc:	00001617          	auipc	a2,0x1
    80200ad0:	02c60613          	add	a2,a2,44 # 80201af8 <etext+0x4bc>
    80200ad4:	0c300593          	li	a1,195
    80200ad8:	00001517          	auipc	a0,0x1
    80200adc:	03850513          	add	a0,a0,56 # 80201b10 <etext+0x4d4>
    80200ae0:	e18ff0ef          	jal	802000f8 <__panic>
    80200ae4:	00001697          	auipc	a3,0x1
    80200ae8:	30c68693          	add	a3,a3,780 # 80201df0 <etext+0x7b4>
    80200aec:	00001617          	auipc	a2,0x1
    80200af0:	00c60613          	add	a2,a2,12 # 80201af8 <etext+0x4bc>
    80200af4:	13e00593          	li	a1,318
    80200af8:	00001517          	auipc	a0,0x1
    80200afc:	01850513          	add	a0,a0,24 # 80201b10 <etext+0x4d4>
    80200b00:	df8ff0ef          	jal	802000f8 <__panic>
    80200b04:	00001697          	auipc	a3,0x1
    80200b08:	2cc68693          	add	a3,a3,716 # 80201dd0 <etext+0x794>
    80200b0c:	00001617          	auipc	a2,0x1
    80200b10:	fec60613          	add	a2,a2,-20 # 80201af8 <etext+0x4bc>
    80200b14:	13c00593          	li	a1,316
    80200b18:	00001517          	auipc	a0,0x1
    80200b1c:	ff850513          	add	a0,a0,-8 # 80201b10 <etext+0x4d4>
    80200b20:	dd8ff0ef          	jal	802000f8 <__panic>
    80200b24:	00001697          	auipc	a3,0x1
    80200b28:	28468693          	add	a3,a3,644 # 80201da8 <etext+0x76c>
    80200b2c:	00001617          	auipc	a2,0x1
    80200b30:	fcc60613          	add	a2,a2,-52 # 80201af8 <etext+0x4bc>
    80200b34:	13a00593          	li	a1,314
    80200b38:	00001517          	auipc	a0,0x1
    80200b3c:	fd850513          	add	a0,a0,-40 # 80201b10 <etext+0x4d4>
    80200b40:	db8ff0ef          	jal	802000f8 <__panic>
    80200b44:	00001697          	auipc	a3,0x1
    80200b48:	23c68693          	add	a3,a3,572 # 80201d80 <etext+0x744>
    80200b4c:	00001617          	auipc	a2,0x1
    80200b50:	fac60613          	add	a2,a2,-84 # 80201af8 <etext+0x4bc>
    80200b54:	13900593          	li	a1,313
    80200b58:	00001517          	auipc	a0,0x1
    80200b5c:	fb850513          	add	a0,a0,-72 # 80201b10 <etext+0x4d4>
    80200b60:	d98ff0ef          	jal	802000f8 <__panic>
    80200b64:	00001697          	auipc	a3,0x1
    80200b68:	20c68693          	add	a3,a3,524 # 80201d70 <etext+0x734>
    80200b6c:	00001617          	auipc	a2,0x1
    80200b70:	f8c60613          	add	a2,a2,-116 # 80201af8 <etext+0x4bc>
    80200b74:	13400593          	li	a1,308
    80200b78:	00001517          	auipc	a0,0x1
    80200b7c:	f9850513          	add	a0,a0,-104 # 80201b10 <etext+0x4d4>
    80200b80:	d78ff0ef          	jal	802000f8 <__panic>
    80200b84:	00001697          	auipc	a3,0x1
    80200b88:	0ec68693          	add	a3,a3,236 # 80201c70 <etext+0x634>
    80200b8c:	00001617          	auipc	a2,0x1
    80200b90:	f6c60613          	add	a2,a2,-148 # 80201af8 <etext+0x4bc>
    80200b94:	13300593          	li	a1,307
    80200b98:	00001517          	auipc	a0,0x1
    80200b9c:	f7850513          	add	a0,a0,-136 # 80201b10 <etext+0x4d4>
    80200ba0:	d58ff0ef          	jal	802000f8 <__panic>
    80200ba4:	00001697          	auipc	a3,0x1
    80200ba8:	1ac68693          	add	a3,a3,428 # 80201d50 <etext+0x714>
    80200bac:	00001617          	auipc	a2,0x1
    80200bb0:	f4c60613          	add	a2,a2,-180 # 80201af8 <etext+0x4bc>
    80200bb4:	13200593          	li	a1,306
    80200bb8:	00001517          	auipc	a0,0x1
    80200bbc:	f5850513          	add	a0,a0,-168 # 80201b10 <etext+0x4d4>
    80200bc0:	d38ff0ef          	jal	802000f8 <__panic>
    80200bc4:	00001697          	auipc	a3,0x1
    80200bc8:	15c68693          	add	a3,a3,348 # 80201d20 <etext+0x6e4>
    80200bcc:	00001617          	auipc	a2,0x1
    80200bd0:	f2c60613          	add	a2,a2,-212 # 80201af8 <etext+0x4bc>
    80200bd4:	13100593          	li	a1,305
    80200bd8:	00001517          	auipc	a0,0x1
    80200bdc:	f3850513          	add	a0,a0,-200 # 80201b10 <etext+0x4d4>
    80200be0:	d18ff0ef          	jal	802000f8 <__panic>
    80200be4:	00001697          	auipc	a3,0x1
    80200be8:	12468693          	add	a3,a3,292 # 80201d08 <etext+0x6cc>
    80200bec:	00001617          	auipc	a2,0x1
    80200bf0:	f0c60613          	add	a2,a2,-244 # 80201af8 <etext+0x4bc>
    80200bf4:	13000593          	li	a1,304
    80200bf8:	00001517          	auipc	a0,0x1
    80200bfc:	f1850513          	add	a0,a0,-232 # 80201b10 <etext+0x4d4>
    80200c00:	cf8ff0ef          	jal	802000f8 <__panic>
    80200c04:	00001697          	auipc	a3,0x1
    80200c08:	06c68693          	add	a3,a3,108 # 80201c70 <etext+0x634>
    80200c0c:	00001617          	auipc	a2,0x1
    80200c10:	eec60613          	add	a2,a2,-276 # 80201af8 <etext+0x4bc>
    80200c14:	12a00593          	li	a1,298
    80200c18:	00001517          	auipc	a0,0x1
    80200c1c:	ef850513          	add	a0,a0,-264 # 80201b10 <etext+0x4d4>
    80200c20:	cd8ff0ef          	jal	802000f8 <__panic>
    80200c24:	00001697          	auipc	a3,0x1
    80200c28:	0cc68693          	add	a3,a3,204 # 80201cf0 <etext+0x6b4>
    80200c2c:	00001617          	auipc	a2,0x1
    80200c30:	ecc60613          	add	a2,a2,-308 # 80201af8 <etext+0x4bc>
    80200c34:	12500593          	li	a1,293
    80200c38:	00001517          	auipc	a0,0x1
    80200c3c:	ed850513          	add	a0,a0,-296 # 80201b10 <etext+0x4d4>
    80200c40:	cb8ff0ef          	jal	802000f8 <__panic>
    80200c44:	00001697          	auipc	a3,0x1
    80200c48:	1cc68693          	add	a3,a3,460 # 80201e10 <etext+0x7d4>
    80200c4c:	00001617          	auipc	a2,0x1
    80200c50:	eac60613          	add	a2,a2,-340 # 80201af8 <etext+0x4bc>
    80200c54:	14300593          	li	a1,323
    80200c58:	00001517          	auipc	a0,0x1
    80200c5c:	eb850513          	add	a0,a0,-328 # 80201b10 <etext+0x4d4>
    80200c60:	c98ff0ef          	jal	802000f8 <__panic>
    80200c64:	00001697          	auipc	a3,0x1
    80200c68:	1dc68693          	add	a3,a3,476 # 80201e40 <etext+0x804>
    80200c6c:	00001617          	auipc	a2,0x1
    80200c70:	e8c60613          	add	a2,a2,-372 # 80201af8 <etext+0x4bc>
    80200c74:	15200593          	li	a1,338
    80200c78:	00001517          	auipc	a0,0x1
    80200c7c:	e9850513          	add	a0,a0,-360 # 80201b10 <etext+0x4d4>
    80200c80:	c78ff0ef          	jal	802000f8 <__panic>
    80200c84:	00001697          	auipc	a3,0x1
    80200c88:	ea468693          	add	a3,a3,-348 # 80201b28 <etext+0x4ec>
    80200c8c:	00001617          	auipc	a2,0x1
    80200c90:	e6c60613          	add	a2,a2,-404 # 80201af8 <etext+0x4bc>
    80200c94:	11f00593          	li	a1,287
    80200c98:	00001517          	auipc	a0,0x1
    80200c9c:	e7850513          	add	a0,a0,-392 # 80201b10 <etext+0x4d4>
    80200ca0:	c58ff0ef          	jal	802000f8 <__panic>
    80200ca4:	00001697          	auipc	a3,0x1
    80200ca8:	ec468693          	add	a3,a3,-316 # 80201b68 <etext+0x52c>
    80200cac:	00001617          	auipc	a2,0x1
    80200cb0:	e4c60613          	add	a2,a2,-436 # 80201af8 <etext+0x4bc>
    80200cb4:	0bc00593          	li	a1,188
    80200cb8:	00001517          	auipc	a0,0x1
    80200cbc:	e5850513          	add	a0,a0,-424 # 80201b10 <etext+0x4d4>
    80200cc0:	c38ff0ef          	jal	802000f8 <__panic>

0000000080200cc4 <default_free_pages>:
    80200cc4:	1141                	add	sp,sp,-16
    80200cc6:	e406                	sd	ra,8(sp)
    80200cc8:	14058763          	beqz	a1,80200e16 <default_free_pages+0x152>
    80200ccc:	00259693          	sll	a3,a1,0x2
    80200cd0:	96ae                	add	a3,a3,a1
    80200cd2:	068e                	sll	a3,a3,0x3
    80200cd4:	96aa                	add	a3,a3,a0
    80200cd6:	87aa                	mv	a5,a0
    80200cd8:	02d50263          	beq	a0,a3,80200cfc <default_free_pages+0x38>
    80200cdc:	6798                	ld	a4,8(a5)
    80200cde:	8b05                	and	a4,a4,1
    80200ce0:	10071b63          	bnez	a4,80200df6 <default_free_pages+0x132>
    80200ce4:	6798                	ld	a4,8(a5)
    80200ce6:	8b09                	and	a4,a4,2
    80200ce8:	10071763          	bnez	a4,80200df6 <default_free_pages+0x132>
    80200cec:	0007b423          	sd	zero,8(a5)
    80200cf0:	0007a023          	sw	zero,0(a5)
    80200cf4:	02878793          	add	a5,a5,40
    80200cf8:	fed792e3          	bne	a5,a3,80200cdc <default_free_pages+0x18>
    80200cfc:	2581                	sext.w	a1,a1
    80200cfe:	c90c                	sw	a1,16(a0)
    80200d00:	4789                	li	a5,2
    80200d02:	00850713          	add	a4,a0,8
    80200d06:	40f7302f          	amoor.d	zero,a5,(a4)
    80200d0a:	00004817          	auipc	a6,0x4
    80200d0e:	2fe80813          	add	a6,a6,766 # 80205008 <free_area>
    80200d12:	01082783          	lw	a5,16(a6)
    80200d16:	00883703          	ld	a4,8(a6)
    80200d1a:	9fad                	addw	a5,a5,a1
    80200d1c:	00f82823          	sw	a5,16(a6)
    80200d20:	07070c63          	beq	a4,a6,80200d98 <default_free_pages+0xd4>
    80200d24:	fe870613          	add	a2,a4,-24
    80200d28:	ff872883          	lw	a7,-8(a4)
    80200d2c:	4e81                	li	t4,0
    80200d2e:	01850313          	add	t1,a0,24
    80200d32:	02d60863          	beq	a2,a3,80200d62 <default_free_pages+0x9e>
    80200d36:	02089593          	sll	a1,a7,0x20
    80200d3a:	9181                	srl	a1,a1,0x20
    80200d3c:	00259793          	sll	a5,a1,0x2
    80200d40:	97ae                	add	a5,a5,a1
    80200d42:	078e                	sll	a5,a5,0x3
    80200d44:	97b2                	add	a5,a5,a2
    80200d46:	06f50263          	beq	a0,a5,80200daa <default_free_pages+0xe6>
    80200d4a:	06c56c63          	bltu	a0,a2,80200dc2 <default_free_pages+0xfe>
    80200d4e:	671c                	ld	a5,8(a4)
    80200d50:	03078863          	beq	a5,a6,80200d80 <default_free_pages+0xbc>
    80200d54:	873e                	mv	a4,a5
    80200d56:	fe870613          	add	a2,a4,-24
    80200d5a:	ff872883          	lw	a7,-8(a4)
    80200d5e:	fcd61ce3          	bne	a2,a3,80200d36 <default_free_pages+0x72>
    80200d62:	000e8463          	beqz	t4,80200d6a <default_free_pages+0xa6>
    80200d66:	01c83023          	sd	t3,0(a6)
    80200d6a:	491c                	lw	a5,16(a0)
    80200d6c:	6314                	ld	a3,0(a4)
    80200d6e:	6718                	ld	a4,8(a4)
    80200d70:	011787bb          	addw	a5,a5,a7
    80200d74:	c91c                	sw	a5,16(a0)
    80200d76:	60a2                	ld	ra,8(sp)
    80200d78:	e698                	sd	a4,8(a3)
    80200d7a:	e314                	sd	a3,0(a4)
    80200d7c:	0141                	add	sp,sp,16
    80200d7e:	8082                	ret
    80200d80:	00673423          	sd	t1,8(a4)
    80200d84:	03053023          	sd	a6,32(a0)
    80200d88:	671c                	ld	a5,8(a4)
    80200d8a:	ed18                	sd	a4,24(a0)
    80200d8c:	8e1a                	mv	t3,t1
    80200d8e:	07078163          	beq	a5,a6,80200df0 <default_free_pages+0x12c>
    80200d92:	4e85                	li	t4,1
    80200d94:	873e                	mv	a4,a5
    80200d96:	b7c1                	j	80200d56 <default_free_pages+0x92>
    80200d98:	60a2                	ld	ra,8(sp)
    80200d9a:	01850793          	add	a5,a0,24
    80200d9e:	e31c                	sd	a5,0(a4)
    80200da0:	e71c                	sd	a5,8(a4)
    80200da2:	f118                	sd	a4,32(a0)
    80200da4:	ed18                	sd	a4,24(a0)
    80200da6:	0141                	add	sp,sp,16
    80200da8:	8082                	ret
    80200daa:	000e8463          	beqz	t4,80200db2 <default_free_pages+0xee>
    80200dae:	01c83023          	sd	t3,0(a6)
    80200db2:	491c                	lw	a5,16(a0)
    80200db4:	60a2                	ld	ra,8(sp)
    80200db6:	011787bb          	addw	a5,a5,a7
    80200dba:	fef72c23          	sw	a5,-8(a4)
    80200dbe:	0141                	add	sp,sp,16
    80200dc0:	8082                	ret
    80200dc2:	000e8463          	beqz	t4,80200dca <default_free_pages+0x106>
    80200dc6:	01c83023          	sd	t3,0(a6)
    80200dca:	631c                	ld	a5,0(a4)
    80200dcc:	01850313          	add	t1,a0,24
    80200dd0:	00673023          	sd	t1,0(a4)
    80200dd4:	0067b423          	sd	t1,8(a5)
    80200dd8:	00883783          	ld	a5,8(a6)
    80200ddc:	60a2                	ld	ra,8(sp)
    80200dde:	0067b023          	sd	t1,0(a5)
    80200de2:	00683423          	sd	t1,8(a6)
    80200de6:	f11c                	sd	a5,32(a0)
    80200de8:	01053c23          	sd	a6,24(a0)
    80200dec:	0141                	add	sp,sp,16
    80200dee:	8082                	ret
    80200df0:	00683023          	sd	t1,0(a6)
    80200df4:	b7d5                	j	80200dd8 <default_free_pages+0x114>
    80200df6:	00001697          	auipc	a3,0x1
    80200dfa:	06268693          	add	a3,a3,98 # 80201e58 <etext+0x81c>
    80200dfe:	00001617          	auipc	a2,0x1
    80200e02:	cfa60613          	add	a2,a2,-774 # 80201af8 <etext+0x4bc>
    80200e06:	08700593          	li	a1,135
    80200e0a:	00001517          	auipc	a0,0x1
    80200e0e:	d0650513          	add	a0,a0,-762 # 80201b10 <etext+0x4d4>
    80200e12:	ae6ff0ef          	jal	802000f8 <__panic>
    80200e16:	00001697          	auipc	a3,0x1
    80200e1a:	03a68693          	add	a3,a3,58 # 80201e50 <etext+0x814>
    80200e1e:	00001617          	auipc	a2,0x1
    80200e22:	cda60613          	add	a2,a2,-806 # 80201af8 <etext+0x4bc>
    80200e26:	08400593          	li	a1,132
    80200e2a:	00001517          	auipc	a0,0x1
    80200e2e:	ce650513          	add	a0,a0,-794 # 80201b10 <etext+0x4d4>
    80200e32:	ac6ff0ef          	jal	802000f8 <__panic>

0000000080200e36 <default_alloc_pages>:
    80200e36:	c959                	beqz	a0,80200ecc <default_alloc_pages+0x96>
    80200e38:	00004617          	auipc	a2,0x4
    80200e3c:	1d060613          	add	a2,a2,464 # 80205008 <free_area>
    80200e40:	4a0c                	lw	a1,16(a2)
    80200e42:	86aa                	mv	a3,a0
    80200e44:	02059793          	sll	a5,a1,0x20
    80200e48:	9381                	srl	a5,a5,0x20
    80200e4a:	00a7eb63          	bltu	a5,a0,80200e60 <default_alloc_pages+0x2a>
    80200e4e:	87b2                	mv	a5,a2
    80200e50:	a029                	j	80200e5a <default_alloc_pages+0x24>
    80200e52:	ff87e703          	lwu	a4,-8(a5)
    80200e56:	00d77763          	bgeu	a4,a3,80200e64 <default_alloc_pages+0x2e>
    80200e5a:	679c                	ld	a5,8(a5)
    80200e5c:	fec79be3          	bne	a5,a2,80200e52 <default_alloc_pages+0x1c>
    80200e60:	4501                	li	a0,0
    80200e62:	8082                	ret
    80200e64:	6798                	ld	a4,8(a5)
    80200e66:	0007b803          	ld	a6,0(a5)
    80200e6a:	ff87a883          	lw	a7,-8(a5)
    80200e6e:	fe878513          	add	a0,a5,-24
    80200e72:	00e83423          	sd	a4,8(a6)
    80200e76:	01073023          	sd	a6,0(a4)
    80200e7a:	02089713          	sll	a4,a7,0x20
    80200e7e:	9301                	srl	a4,a4,0x20
    80200e80:	0006831b          	sext.w	t1,a3
    80200e84:	02e6fc63          	bgeu	a3,a4,80200ebc <default_alloc_pages+0x86>
    80200e88:	00269713          	sll	a4,a3,0x2
    80200e8c:	9736                	add	a4,a4,a3
    80200e8e:	070e                	sll	a4,a4,0x3
    80200e90:	972a                	add	a4,a4,a0
    80200e92:	406888bb          	subw	a7,a7,t1
    80200e96:	01172823          	sw	a7,16(a4)
    80200e9a:	4689                	li	a3,2
    80200e9c:	00870593          	add	a1,a4,8
    80200ea0:	40d5b02f          	amoor.d	zero,a3,(a1)
    80200ea4:	00883683          	ld	a3,8(a6)
    80200ea8:	01870893          	add	a7,a4,24
    80200eac:	4a0c                	lw	a1,16(a2)
    80200eae:	0116b023          	sd	a7,0(a3)
    80200eb2:	01183423          	sd	a7,8(a6)
    80200eb6:	f314                	sd	a3,32(a4)
    80200eb8:	01073c23          	sd	a6,24(a4)
    80200ebc:	406585bb          	subw	a1,a1,t1
    80200ec0:	ca0c                	sw	a1,16(a2)
    80200ec2:	5775                	li	a4,-3
    80200ec4:	17c1                	add	a5,a5,-16
    80200ec6:	60e7b02f          	amoand.d	zero,a4,(a5)
    80200eca:	8082                	ret
    80200ecc:	1141                	add	sp,sp,-16
    80200ece:	00001697          	auipc	a3,0x1
    80200ed2:	f8268693          	add	a3,a3,-126 # 80201e50 <etext+0x814>
    80200ed6:	00001617          	auipc	a2,0x1
    80200eda:	c2260613          	add	a2,a2,-990 # 80201af8 <etext+0x4bc>
    80200ede:	06700593          	li	a1,103
    80200ee2:	00001517          	auipc	a0,0x1
    80200ee6:	c2e50513          	add	a0,a0,-978 # 80201b10 <etext+0x4d4>
    80200eea:	e406                	sd	ra,8(sp)
    80200eec:	a0cff0ef          	jal	802000f8 <__panic>

0000000080200ef0 <default_init_memmap>:
    80200ef0:	1141                	add	sp,sp,-16
    80200ef2:	e406                	sd	ra,8(sp)
    80200ef4:	c9e1                	beqz	a1,80200fc4 <default_init_memmap+0xd4>
    80200ef6:	00259713          	sll	a4,a1,0x2
    80200efa:	972e                	add	a4,a4,a1
    80200efc:	070e                	sll	a4,a4,0x3
    80200efe:	00e506b3          	add	a3,a0,a4
    80200f02:	87aa                	mv	a5,a0
    80200f04:	cf11                	beqz	a4,80200f20 <default_init_memmap+0x30>
    80200f06:	6798                	ld	a4,8(a5)
    80200f08:	8b05                	and	a4,a4,1
    80200f0a:	cf49                	beqz	a4,80200fa4 <default_init_memmap+0xb4>
    80200f0c:	0007a823          	sw	zero,16(a5)
    80200f10:	0007b423          	sd	zero,8(a5)
    80200f14:	0007a023          	sw	zero,0(a5)
    80200f18:	02878793          	add	a5,a5,40
    80200f1c:	fed795e3          	bne	a5,a3,80200f06 <default_init_memmap+0x16>
    80200f20:	2581                	sext.w	a1,a1
    80200f22:	c90c                	sw	a1,16(a0)
    80200f24:	4789                	li	a5,2
    80200f26:	00850713          	add	a4,a0,8
    80200f2a:	40f7302f          	amoor.d	zero,a5,(a4)
    80200f2e:	00004697          	auipc	a3,0x4
    80200f32:	0da68693          	add	a3,a3,218 # 80205008 <free_area>
    80200f36:	4a98                	lw	a4,16(a3)
    80200f38:	669c                	ld	a5,8(a3)
    80200f3a:	9f2d                	addw	a4,a4,a1
    80200f3c:	ca98                	sw	a4,16(a3)
    80200f3e:	04d78663          	beq	a5,a3,80200f8a <default_init_memmap+0x9a>
    80200f42:	fe878713          	add	a4,a5,-24
    80200f46:	4581                	li	a1,0
    80200f48:	01850613          	add	a2,a0,24
    80200f4c:	00e56a63          	bltu	a0,a4,80200f60 <default_init_memmap+0x70>
    80200f50:	6798                	ld	a4,8(a5)
    80200f52:	02d70263          	beq	a4,a3,80200f76 <default_init_memmap+0x86>
    80200f56:	87ba                	mv	a5,a4
    80200f58:	fe878713          	add	a4,a5,-24
    80200f5c:	fee57ae3          	bgeu	a0,a4,80200f50 <default_init_memmap+0x60>
    80200f60:	c199                	beqz	a1,80200f66 <default_init_memmap+0x76>
    80200f62:	0106b023          	sd	a6,0(a3)
    80200f66:	6398                	ld	a4,0(a5)
    80200f68:	60a2                	ld	ra,8(sp)
    80200f6a:	e390                	sd	a2,0(a5)
    80200f6c:	e710                	sd	a2,8(a4)
    80200f6e:	f11c                	sd	a5,32(a0)
    80200f70:	ed18                	sd	a4,24(a0)
    80200f72:	0141                	add	sp,sp,16
    80200f74:	8082                	ret
    80200f76:	e790                	sd	a2,8(a5)
    80200f78:	f114                	sd	a3,32(a0)
    80200f7a:	6798                	ld	a4,8(a5)
    80200f7c:	ed1c                	sd	a5,24(a0)
    80200f7e:	8832                	mv	a6,a2
    80200f80:	00d70e63          	beq	a4,a3,80200f9c <default_init_memmap+0xac>
    80200f84:	4585                	li	a1,1
    80200f86:	87ba                	mv	a5,a4
    80200f88:	bfc1                	j	80200f58 <default_init_memmap+0x68>
    80200f8a:	60a2                	ld	ra,8(sp)
    80200f8c:	01850713          	add	a4,a0,24
    80200f90:	e398                	sd	a4,0(a5)
    80200f92:	e798                	sd	a4,8(a5)
    80200f94:	f11c                	sd	a5,32(a0)
    80200f96:	ed1c                	sd	a5,24(a0)
    80200f98:	0141                	add	sp,sp,16
    80200f9a:	8082                	ret
    80200f9c:	60a2                	ld	ra,8(sp)
    80200f9e:	e290                	sd	a2,0(a3)
    80200fa0:	0141                	add	sp,sp,16
    80200fa2:	8082                	ret
    80200fa4:	00001697          	auipc	a3,0x1
    80200fa8:	edc68693          	add	a3,a3,-292 # 80201e80 <etext+0x844>
    80200fac:	00001617          	auipc	a2,0x1
    80200fb0:	b4c60613          	add	a2,a2,-1204 # 80201af8 <etext+0x4bc>
    80200fb4:	04f00593          	li	a1,79
    80200fb8:	00001517          	auipc	a0,0x1
    80200fbc:	b5850513          	add	a0,a0,-1192 # 80201b10 <etext+0x4d4>
    80200fc0:	938ff0ef          	jal	802000f8 <__panic>
    80200fc4:	00001697          	auipc	a3,0x1
    80200fc8:	e8c68693          	add	a3,a3,-372 # 80201e50 <etext+0x814>
    80200fcc:	00001617          	auipc	a2,0x1
    80200fd0:	b2c60613          	add	a2,a2,-1236 # 80201af8 <etext+0x4bc>
    80200fd4:	04c00593          	li	a1,76
    80200fd8:	00001517          	auipc	a0,0x1
    80200fdc:	b3850513          	add	a0,a0,-1224 # 80201b10 <etext+0x4d4>
    80200fe0:	918ff0ef          	jal	802000f8 <__panic>

0000000080200fe4 <alloc_pages>:
    80200fe4:	100027f3          	csrr	a5,sstatus
    80200fe8:	8b89                	and	a5,a5,2
    80200fea:	e799                	bnez	a5,80200ff8 <alloc_pages+0x14>
    80200fec:	00004797          	auipc	a5,0x4
    80200ff0:	0447b783          	ld	a5,68(a5) # 80205030 <pmm_manager>
    80200ff4:	6f9c                	ld	a5,24(a5)
    80200ff6:	8782                	jr	a5
    80200ff8:	1141                	add	sp,sp,-16
    80200ffa:	e406                	sd	ra,8(sp)
    80200ffc:	e022                	sd	s0,0(sp)
    80200ffe:	842a                	mv	s0,a0
    80201000:	96eff0ef          	jal	8020016e <intr_disable>
    80201004:	00004797          	auipc	a5,0x4
    80201008:	02c7b783          	ld	a5,44(a5) # 80205030 <pmm_manager>
    8020100c:	6f9c                	ld	a5,24(a5)
    8020100e:	8522                	mv	a0,s0
    80201010:	9782                	jalr	a5
    80201012:	842a                	mv	s0,a0
    80201014:	954ff0ef          	jal	80200168 <intr_enable>
    80201018:	60a2                	ld	ra,8(sp)
    8020101a:	8522                	mv	a0,s0
    8020101c:	6402                	ld	s0,0(sp)
    8020101e:	0141                	add	sp,sp,16
    80201020:	8082                	ret

0000000080201022 <free_pages>:
    80201022:	100027f3          	csrr	a5,sstatus
    80201026:	8b89                	and	a5,a5,2
    80201028:	e799                	bnez	a5,80201036 <free_pages+0x14>
    8020102a:	00004797          	auipc	a5,0x4
    8020102e:	0067b783          	ld	a5,6(a5) # 80205030 <pmm_manager>
    80201032:	739c                	ld	a5,32(a5)
    80201034:	8782                	jr	a5
    80201036:	1101                	add	sp,sp,-32
    80201038:	ec06                	sd	ra,24(sp)
    8020103a:	e822                	sd	s0,16(sp)
    8020103c:	e426                	sd	s1,8(sp)
    8020103e:	842a                	mv	s0,a0
    80201040:	84ae                	mv	s1,a1
    80201042:	92cff0ef          	jal	8020016e <intr_disable>
    80201046:	00004797          	auipc	a5,0x4
    8020104a:	fea7b783          	ld	a5,-22(a5) # 80205030 <pmm_manager>
    8020104e:	739c                	ld	a5,32(a5)
    80201050:	85a6                	mv	a1,s1
    80201052:	8522                	mv	a0,s0
    80201054:	9782                	jalr	a5
    80201056:	6442                	ld	s0,16(sp)
    80201058:	60e2                	ld	ra,24(sp)
    8020105a:	64a2                	ld	s1,8(sp)
    8020105c:	6105                	add	sp,sp,32
    8020105e:	90aff06f          	j	80200168 <intr_enable>

0000000080201062 <nr_free_pages>:
    80201062:	100027f3          	csrr	a5,sstatus
    80201066:	8b89                	and	a5,a5,2
    80201068:	e799                	bnez	a5,80201076 <nr_free_pages+0x14>
    8020106a:	00004797          	auipc	a5,0x4
    8020106e:	fc67b783          	ld	a5,-58(a5) # 80205030 <pmm_manager>
    80201072:	779c                	ld	a5,40(a5)
    80201074:	8782                	jr	a5
    80201076:	1141                	add	sp,sp,-16
    80201078:	e406                	sd	ra,8(sp)
    8020107a:	e022                	sd	s0,0(sp)
    8020107c:	8f2ff0ef          	jal	8020016e <intr_disable>
    80201080:	00004797          	auipc	a5,0x4
    80201084:	fb07b783          	ld	a5,-80(a5) # 80205030 <pmm_manager>
    80201088:	779c                	ld	a5,40(a5)
    8020108a:	9782                	jalr	a5
    8020108c:	842a                	mv	s0,a0
    8020108e:	8daff0ef          	jal	80200168 <intr_enable>
    80201092:	60a2                	ld	ra,8(sp)
    80201094:	8522                	mv	a0,s0
    80201096:	6402                	ld	s0,0(sp)
    80201098:	0141                	add	sp,sp,16
    8020109a:	8082                	ret

000000008020109c <pmm_init>:
    8020109c:	00001797          	auipc	a5,0x1
    802010a0:	e0c78793          	add	a5,a5,-500 # 80201ea8 <default_pmm_manager>
    802010a4:	638c                	ld	a1,0(a5)
    802010a6:	1141                	add	sp,sp,-16
    802010a8:	e406                	sd	ra,8(sp)
    802010aa:	e022                	sd	s0,0(sp)
    802010ac:	00001517          	auipc	a0,0x1
    802010b0:	e3450513          	add	a0,a0,-460 # 80201ee0 <default_pmm_manager+0x38>
    802010b4:	00004417          	auipc	s0,0x4
    802010b8:	f7c40413          	add	s0,s0,-132 # 80205030 <pmm_manager>
    802010bc:	e01c                	sd	a5,0(s0)
    802010be:	fc5fe0ef          	jal	80200082 <cprintf>
    802010c2:	601c                	ld	a5,0(s0)
    802010c4:	679c                	ld	a5,8(a5)
    802010c6:	9782                	jalr	a5
    802010c8:	00001517          	auipc	a0,0x1
    802010cc:	e3050513          	add	a0,a0,-464 # 80201ef8 <default_pmm_manager+0x50>
    802010d0:	00004797          	auipc	a5,0x4
    802010d4:	f607b423          	sd	zero,-152(a5) # 80205038 <va_pa_offset>
    802010d8:	fabfe0ef          	jal	80200082 <cprintf>
    802010dc:	46c5                	li	a3,17
    802010de:	06ee                	sll	a3,a3,0x1b
    802010e0:	40100613          	li	a2,1025
    802010e4:	16fd                	add	a3,a3,-1
    802010e6:	0656                	sll	a2,a2,0x15
    802010e8:	07e005b7          	lui	a1,0x7e00
    802010ec:	00001517          	auipc	a0,0x1
    802010f0:	e2450513          	add	a0,a0,-476 # 80201f10 <default_pmm_manager+0x68>
    802010f4:	f8ffe0ef          	jal	80200082 <cprintf>
    802010f8:	777d                	lui	a4,0xfffff
    802010fa:	00005797          	auipc	a5,0x5
    802010fe:	f5d78793          	add	a5,a5,-163 # 80206057 <end+0xfff>
    80201102:	8ff9                	and	a5,a5,a4
    80201104:	00004517          	auipc	a0,0x4
    80201108:	f3c50513          	add	a0,a0,-196 # 80205040 <npage>
    8020110c:	00004597          	auipc	a1,0x4
    80201110:	f3c58593          	add	a1,a1,-196 # 80205048 <pages>
    80201114:	00088737          	lui	a4,0x88
    80201118:	e118                	sd	a4,0(a0)
    8020111a:	e19c                	sd	a5,0(a1)
    8020111c:	4705                	li	a4,1
    8020111e:	07a1                	add	a5,a5,8
    80201120:	40e7b02f          	amoor.d	zero,a4,(a5)
    80201124:	02800693          	li	a3,40
    80201128:	4885                	li	a7,1
    8020112a:	fff80837          	lui	a6,0xfff80
    8020112e:	619c                	ld	a5,0(a1)
    80201130:	97b6                	add	a5,a5,a3
    80201132:	07a1                	add	a5,a5,8
    80201134:	4117b02f          	amoor.d	zero,a7,(a5)
    80201138:	611c                	ld	a5,0(a0)
    8020113a:	0705                	add	a4,a4,1 # 88001 <kern_entry-0x80177fff>
    8020113c:	02868693          	add	a3,a3,40
    80201140:	01078633          	add	a2,a5,a6
    80201144:	fec765e3          	bltu	a4,a2,8020112e <pmm_init+0x92>
    80201148:	6190                	ld	a2,0(a1)
    8020114a:	00279693          	sll	a3,a5,0x2
    8020114e:	96be                	add	a3,a3,a5
    80201150:	fec00737          	lui	a4,0xfec00
    80201154:	9732                	add	a4,a4,a2
    80201156:	068e                	sll	a3,a3,0x3
    80201158:	96ba                	add	a3,a3,a4
    8020115a:	40100713          	li	a4,1025
    8020115e:	0756                	sll	a4,a4,0x15
    80201160:	06e6ec63          	bltu	a3,a4,802011d8 <pmm_init+0x13c>
    80201164:	00004717          	auipc	a4,0x4
    80201168:	ed473703          	ld	a4,-300(a4) # 80205038 <va_pa_offset>
    8020116c:	45c5                	li	a1,17
    8020116e:	8e99                	sub	a3,a3,a4
    80201170:	05ee                	sll	a1,a1,0x1b
    80201172:	00b6ee63          	bltu	a3,a1,8020118e <pmm_init+0xf2>
    80201176:	601c                	ld	a5,0(s0)
    80201178:	7b9c                	ld	a5,48(a5)
    8020117a:	9782                	jalr	a5
    8020117c:	6402                	ld	s0,0(sp)
    8020117e:	60a2                	ld	ra,8(sp)
    80201180:	00001517          	auipc	a0,0x1
    80201184:	e2850513          	add	a0,a0,-472 # 80201fa8 <default_pmm_manager+0x100>
    80201188:	0141                	add	sp,sp,16
    8020118a:	ef9fe06f          	j	80200082 <cprintf>
    8020118e:	6705                	lui	a4,0x1
    80201190:	177d                	add	a4,a4,-1 # fff <kern_entry-0x801ff001>
    80201192:	96ba                	add	a3,a3,a4
    80201194:	777d                	lui	a4,0xfffff
    80201196:	8ef9                	and	a3,a3,a4
    80201198:	00c6d713          	srl	a4,a3,0xc
    8020119c:	02f77263          	bgeu	a4,a5,802011c0 <pmm_init+0x124>
    802011a0:	00043803          	ld	a6,0(s0)
    802011a4:	fff807b7          	lui	a5,0xfff80
    802011a8:	97ba                	add	a5,a5,a4
    802011aa:	00279513          	sll	a0,a5,0x2
    802011ae:	953e                	add	a0,a0,a5
    802011b0:	01083783          	ld	a5,16(a6) # fffffffffff80010 <end+0xffffffff7fd7afb8>
    802011b4:	8d95                	sub	a1,a1,a3
    802011b6:	050e                	sll	a0,a0,0x3
    802011b8:	81b1                	srl	a1,a1,0xc
    802011ba:	9532                	add	a0,a0,a2
    802011bc:	9782                	jalr	a5
    802011be:	bf65                	j	80201176 <pmm_init+0xda>
    802011c0:	00001617          	auipc	a2,0x1
    802011c4:	db860613          	add	a2,a2,-584 # 80201f78 <default_pmm_manager+0xd0>
    802011c8:	06f00593          	li	a1,111
    802011cc:	00001517          	auipc	a0,0x1
    802011d0:	dcc50513          	add	a0,a0,-564 # 80201f98 <default_pmm_manager+0xf0>
    802011d4:	f25fe0ef          	jal	802000f8 <__panic>
    802011d8:	00001617          	auipc	a2,0x1
    802011dc:	d6860613          	add	a2,a2,-664 # 80201f40 <default_pmm_manager+0x98>
    802011e0:	06f00593          	li	a1,111
    802011e4:	00001517          	auipc	a0,0x1
    802011e8:	d8450513          	add	a0,a0,-636 # 80201f68 <default_pmm_manager+0xc0>
    802011ec:	f0dfe0ef          	jal	802000f8 <__panic>

00000000802011f0 <printnum>:
    802011f0:	02069813          	sll	a6,a3,0x20
    802011f4:	7179                	add	sp,sp,-48
    802011f6:	02085813          	srl	a6,a6,0x20
    802011fa:	e052                	sd	s4,0(sp)
    802011fc:	03067a33          	remu	s4,a2,a6
    80201200:	f022                	sd	s0,32(sp)
    80201202:	ec26                	sd	s1,24(sp)
    80201204:	e84a                	sd	s2,16(sp)
    80201206:	f406                	sd	ra,40(sp)
    80201208:	e44e                	sd	s3,8(sp)
    8020120a:	84aa                	mv	s1,a0
    8020120c:	892e                	mv	s2,a1
    8020120e:	fff7041b          	addw	s0,a4,-1 # ffffffffffffefff <end+0xffffffff7fdf9fa7>
    80201212:	2a01                	sext.w	s4,s4
    80201214:	03067f63          	bgeu	a2,a6,80201252 <printnum+0x62>
    80201218:	89be                	mv	s3,a5
    8020121a:	4785                	li	a5,1
    8020121c:	00e7d763          	bge	a5,a4,8020122a <printnum+0x3a>
    80201220:	347d                	addw	s0,s0,-1
    80201222:	85ca                	mv	a1,s2
    80201224:	854e                	mv	a0,s3
    80201226:	9482                	jalr	s1
    80201228:	fc65                	bnez	s0,80201220 <printnum+0x30>
    8020122a:	1a02                	sll	s4,s4,0x20
    8020122c:	020a5a13          	srl	s4,s4,0x20
    80201230:	00001797          	auipc	a5,0x1
    80201234:	d9878793          	add	a5,a5,-616 # 80201fc8 <default_pmm_manager+0x120>
    80201238:	97d2                	add	a5,a5,s4
    8020123a:	7402                	ld	s0,32(sp)
    8020123c:	0007c503          	lbu	a0,0(a5)
    80201240:	70a2                	ld	ra,40(sp)
    80201242:	69a2                	ld	s3,8(sp)
    80201244:	6a02                	ld	s4,0(sp)
    80201246:	85ca                	mv	a1,s2
    80201248:	87a6                	mv	a5,s1
    8020124a:	6942                	ld	s2,16(sp)
    8020124c:	64e2                	ld	s1,24(sp)
    8020124e:	6145                	add	sp,sp,48
    80201250:	8782                	jr	a5
    80201252:	03065633          	divu	a2,a2,a6
    80201256:	8722                	mv	a4,s0
    80201258:	f99ff0ef          	jal	802011f0 <printnum>
    8020125c:	b7f9                	j	8020122a <printnum+0x3a>

000000008020125e <vprintfmt>:
    8020125e:	7119                	add	sp,sp,-128
    80201260:	f4a6                	sd	s1,104(sp)
    80201262:	f0ca                	sd	s2,96(sp)
    80201264:	ecce                	sd	s3,88(sp)
    80201266:	e8d2                	sd	s4,80(sp)
    80201268:	e4d6                	sd	s5,72(sp)
    8020126a:	e0da                	sd	s6,64(sp)
    8020126c:	f862                	sd	s8,48(sp)
    8020126e:	fc86                	sd	ra,120(sp)
    80201270:	f8a2                	sd	s0,112(sp)
    80201272:	fc5e                	sd	s7,56(sp)
    80201274:	f466                	sd	s9,40(sp)
    80201276:	f06a                	sd	s10,32(sp)
    80201278:	ec6e                	sd	s11,24(sp)
    8020127a:	892a                	mv	s2,a0
    8020127c:	84ae                	mv	s1,a1
    8020127e:	8c32                	mv	s8,a2
    80201280:	8a36                	mv	s4,a3
    80201282:	02500993          	li	s3,37
    80201286:	05500b13          	li	s6,85
    8020128a:	00001a97          	auipc	s5,0x1
    8020128e:	d72a8a93          	add	s5,s5,-654 # 80201ffc <default_pmm_manager+0x154>
    80201292:	000c4503          	lbu	a0,0(s8)
    80201296:	001c0413          	add	s0,s8,1
    8020129a:	01350a63          	beq	a0,s3,802012ae <vprintfmt+0x50>
    8020129e:	cd0d                	beqz	a0,802012d8 <vprintfmt+0x7a>
    802012a0:	85a6                	mv	a1,s1
    802012a2:	0405                	add	s0,s0,1
    802012a4:	9902                	jalr	s2
    802012a6:	fff44503          	lbu	a0,-1(s0)
    802012aa:	ff351ae3          	bne	a0,s3,8020129e <vprintfmt+0x40>
    802012ae:	02000d93          	li	s11,32
    802012b2:	4b81                	li	s7,0
    802012b4:	4601                	li	a2,0
    802012b6:	5d7d                	li	s10,-1
    802012b8:	5cfd                	li	s9,-1
    802012ba:	00044683          	lbu	a3,0(s0)
    802012be:	00140c13          	add	s8,s0,1
    802012c2:	fdd6859b          	addw	a1,a3,-35
    802012c6:	0ff5f593          	zext.b	a1,a1
    802012ca:	02bb6663          	bltu	s6,a1,802012f6 <vprintfmt+0x98>
    802012ce:	058a                	sll	a1,a1,0x2
    802012d0:	95d6                	add	a1,a1,s5
    802012d2:	4198                	lw	a4,0(a1)
    802012d4:	9756                	add	a4,a4,s5
    802012d6:	8702                	jr	a4
    802012d8:	70e6                	ld	ra,120(sp)
    802012da:	7446                	ld	s0,112(sp)
    802012dc:	74a6                	ld	s1,104(sp)
    802012de:	7906                	ld	s2,96(sp)
    802012e0:	69e6                	ld	s3,88(sp)
    802012e2:	6a46                	ld	s4,80(sp)
    802012e4:	6aa6                	ld	s5,72(sp)
    802012e6:	6b06                	ld	s6,64(sp)
    802012e8:	7be2                	ld	s7,56(sp)
    802012ea:	7c42                	ld	s8,48(sp)
    802012ec:	7ca2                	ld	s9,40(sp)
    802012ee:	7d02                	ld	s10,32(sp)
    802012f0:	6de2                	ld	s11,24(sp)
    802012f2:	6109                	add	sp,sp,128
    802012f4:	8082                	ret
    802012f6:	85a6                	mv	a1,s1
    802012f8:	02500513          	li	a0,37
    802012fc:	9902                	jalr	s2
    802012fe:	fff44703          	lbu	a4,-1(s0)
    80201302:	02500793          	li	a5,37
    80201306:	8c22                	mv	s8,s0
    80201308:	f8f705e3          	beq	a4,a5,80201292 <vprintfmt+0x34>
    8020130c:	02500713          	li	a4,37
    80201310:	ffec4783          	lbu	a5,-2(s8)
    80201314:	1c7d                	add	s8,s8,-1
    80201316:	fee79de3          	bne	a5,a4,80201310 <vprintfmt+0xb2>
    8020131a:	bfa5                	j	80201292 <vprintfmt+0x34>
    8020131c:	00144783          	lbu	a5,1(s0)
    80201320:	4725                	li	a4,9
    80201322:	fd068d1b          	addw	s10,a3,-48
    80201326:	fd07859b          	addw	a1,a5,-48
    8020132a:	0007869b          	sext.w	a3,a5
    8020132e:	8462                	mv	s0,s8
    80201330:	02b76563          	bltu	a4,a1,8020135a <vprintfmt+0xfc>
    80201334:	4525                	li	a0,9
    80201336:	00144783          	lbu	a5,1(s0)
    8020133a:	002d171b          	sllw	a4,s10,0x2
    8020133e:	01a7073b          	addw	a4,a4,s10
    80201342:	0017171b          	sllw	a4,a4,0x1
    80201346:	9f35                	addw	a4,a4,a3
    80201348:	fd07859b          	addw	a1,a5,-48
    8020134c:	0405                	add	s0,s0,1
    8020134e:	fd070d1b          	addw	s10,a4,-48
    80201352:	0007869b          	sext.w	a3,a5
    80201356:	feb570e3          	bgeu	a0,a1,80201336 <vprintfmt+0xd8>
    8020135a:	f60cd0e3          	bgez	s9,802012ba <vprintfmt+0x5c>
    8020135e:	8cea                	mv	s9,s10
    80201360:	5d7d                	li	s10,-1
    80201362:	bfa1                	j	802012ba <vprintfmt+0x5c>
    80201364:	8db6                	mv	s11,a3
    80201366:	8462                	mv	s0,s8
    80201368:	bf89                	j	802012ba <vprintfmt+0x5c>
    8020136a:	8462                	mv	s0,s8
    8020136c:	4b85                	li	s7,1
    8020136e:	b7b1                	j	802012ba <vprintfmt+0x5c>
    80201370:	4785                	li	a5,1
    80201372:	008a0713          	add	a4,s4,8
    80201376:	00c7c463          	blt	a5,a2,8020137e <vprintfmt+0x120>
    8020137a:	1a060263          	beqz	a2,8020151e <vprintfmt+0x2c0>
    8020137e:	000a3603          	ld	a2,0(s4)
    80201382:	46c1                	li	a3,16
    80201384:	8a3a                	mv	s4,a4
    80201386:	000d879b          	sext.w	a5,s11
    8020138a:	8766                	mv	a4,s9
    8020138c:	85a6                	mv	a1,s1
    8020138e:	854a                	mv	a0,s2
    80201390:	e61ff0ef          	jal	802011f0 <printnum>
    80201394:	bdfd                	j	80201292 <vprintfmt+0x34>
    80201396:	000a2503          	lw	a0,0(s4)
    8020139a:	85a6                	mv	a1,s1
    8020139c:	0a21                	add	s4,s4,8
    8020139e:	9902                	jalr	s2
    802013a0:	bdcd                	j	80201292 <vprintfmt+0x34>
    802013a2:	4785                	li	a5,1
    802013a4:	008a0713          	add	a4,s4,8
    802013a8:	00c7c463          	blt	a5,a2,802013b0 <vprintfmt+0x152>
    802013ac:	16060463          	beqz	a2,80201514 <vprintfmt+0x2b6>
    802013b0:	000a3603          	ld	a2,0(s4)
    802013b4:	46a9                	li	a3,10
    802013b6:	8a3a                	mv	s4,a4
    802013b8:	b7f9                	j	80201386 <vprintfmt+0x128>
    802013ba:	03000513          	li	a0,48
    802013be:	85a6                	mv	a1,s1
    802013c0:	9902                	jalr	s2
    802013c2:	85a6                	mv	a1,s1
    802013c4:	07800513          	li	a0,120
    802013c8:	9902                	jalr	s2
    802013ca:	0a21                	add	s4,s4,8
    802013cc:	46c1                	li	a3,16
    802013ce:	ff8a3603          	ld	a2,-8(s4)
    802013d2:	bf55                	j	80201386 <vprintfmt+0x128>
    802013d4:	85a6                	mv	a1,s1
    802013d6:	02500513          	li	a0,37
    802013da:	9902                	jalr	s2
    802013dc:	bd5d                	j	80201292 <vprintfmt+0x34>
    802013de:	000a2d03          	lw	s10,0(s4)
    802013e2:	8462                	mv	s0,s8
    802013e4:	0a21                	add	s4,s4,8
    802013e6:	bf95                	j	8020135a <vprintfmt+0xfc>
    802013e8:	4785                	li	a5,1
    802013ea:	008a0713          	add	a4,s4,8
    802013ee:	00c7c463          	blt	a5,a2,802013f6 <vprintfmt+0x198>
    802013f2:	10060c63          	beqz	a2,8020150a <vprintfmt+0x2ac>
    802013f6:	000a3603          	ld	a2,0(s4)
    802013fa:	46a1                	li	a3,8
    802013fc:	8a3a                	mv	s4,a4
    802013fe:	b761                	j	80201386 <vprintfmt+0x128>
    80201400:	fffcc793          	not	a5,s9
    80201404:	97fd                	sra	a5,a5,0x3f
    80201406:	00fcf7b3          	and	a5,s9,a5
    8020140a:	00078c9b          	sext.w	s9,a5
    8020140e:	8462                	mv	s0,s8
    80201410:	b56d                	j	802012ba <vprintfmt+0x5c>
    80201412:	000a3403          	ld	s0,0(s4)
    80201416:	008a0793          	add	a5,s4,8
    8020141a:	e43e                	sd	a5,8(sp)
    8020141c:	12040163          	beqz	s0,8020153e <vprintfmt+0x2e0>
    80201420:	0d905963          	blez	s9,802014f2 <vprintfmt+0x294>
    80201424:	02d00793          	li	a5,45
    80201428:	00140a13          	add	s4,s0,1
    8020142c:	12fd9863          	bne	s11,a5,8020155c <vprintfmt+0x2fe>
    80201430:	00044783          	lbu	a5,0(s0)
    80201434:	0007851b          	sext.w	a0,a5
    80201438:	cb9d                	beqz	a5,8020146e <vprintfmt+0x210>
    8020143a:	547d                	li	s0,-1
    8020143c:	05e00d93          	li	s11,94
    80201440:	000d4563          	bltz	s10,8020144a <vprintfmt+0x1ec>
    80201444:	3d7d                	addw	s10,s10,-1
    80201446:	028d0263          	beq	s10,s0,8020146a <vprintfmt+0x20c>
    8020144a:	85a6                	mv	a1,s1
    8020144c:	0c0b8e63          	beqz	s7,80201528 <vprintfmt+0x2ca>
    80201450:	3781                	addw	a5,a5,-32
    80201452:	0cfdfb63          	bgeu	s11,a5,80201528 <vprintfmt+0x2ca>
    80201456:	03f00513          	li	a0,63
    8020145a:	9902                	jalr	s2
    8020145c:	000a4783          	lbu	a5,0(s4)
    80201460:	3cfd                	addw	s9,s9,-1
    80201462:	0a05                	add	s4,s4,1
    80201464:	0007851b          	sext.w	a0,a5
    80201468:	ffe1                	bnez	a5,80201440 <vprintfmt+0x1e2>
    8020146a:	01905963          	blez	s9,8020147c <vprintfmt+0x21e>
    8020146e:	3cfd                	addw	s9,s9,-1
    80201470:	85a6                	mv	a1,s1
    80201472:	02000513          	li	a0,32
    80201476:	9902                	jalr	s2
    80201478:	fe0c9be3          	bnez	s9,8020146e <vprintfmt+0x210>
    8020147c:	6a22                	ld	s4,8(sp)
    8020147e:	bd11                	j	80201292 <vprintfmt+0x34>
    80201480:	4785                	li	a5,1
    80201482:	008a0b93          	add	s7,s4,8
    80201486:	00c7c363          	blt	a5,a2,8020148c <vprintfmt+0x22e>
    8020148a:	ce2d                	beqz	a2,80201504 <vprintfmt+0x2a6>
    8020148c:	000a3403          	ld	s0,0(s4)
    80201490:	08044e63          	bltz	s0,8020152c <vprintfmt+0x2ce>
    80201494:	8622                	mv	a2,s0
    80201496:	8a5e                	mv	s4,s7
    80201498:	46a9                	li	a3,10
    8020149a:	b5f5                	j	80201386 <vprintfmt+0x128>
    8020149c:	000a2783          	lw	a5,0(s4)
    802014a0:	4619                	li	a2,6
    802014a2:	41f7d71b          	sraw	a4,a5,0x1f
    802014a6:	8fb9                	xor	a5,a5,a4
    802014a8:	40e786bb          	subw	a3,a5,a4
    802014ac:	02d64663          	blt	a2,a3,802014d8 <vprintfmt+0x27a>
    802014b0:	00369713          	sll	a4,a3,0x3
    802014b4:	00001797          	auipc	a5,0x1
    802014b8:	d2478793          	add	a5,a5,-732 # 802021d8 <error_string>
    802014bc:	97ba                	add	a5,a5,a4
    802014be:	639c                	ld	a5,0(a5)
    802014c0:	cf81                	beqz	a5,802014d8 <vprintfmt+0x27a>
    802014c2:	86be                	mv	a3,a5
    802014c4:	00001617          	auipc	a2,0x1
    802014c8:	b3460613          	add	a2,a2,-1228 # 80201ff8 <default_pmm_manager+0x150>
    802014cc:	85a6                	mv	a1,s1
    802014ce:	854a                	mv	a0,s2
    802014d0:	0ea000ef          	jal	802015ba <printfmt>
    802014d4:	0a21                	add	s4,s4,8
    802014d6:	bb75                	j	80201292 <vprintfmt+0x34>
    802014d8:	00001617          	auipc	a2,0x1
    802014dc:	b1060613          	add	a2,a2,-1264 # 80201fe8 <default_pmm_manager+0x140>
    802014e0:	85a6                	mv	a1,s1
    802014e2:	854a                	mv	a0,s2
    802014e4:	0d6000ef          	jal	802015ba <printfmt>
    802014e8:	0a21                	add	s4,s4,8
    802014ea:	b365                	j	80201292 <vprintfmt+0x34>
    802014ec:	2605                	addw	a2,a2,1
    802014ee:	8462                	mv	s0,s8
    802014f0:	b3e9                	j	802012ba <vprintfmt+0x5c>
    802014f2:	00044783          	lbu	a5,0(s0)
    802014f6:	00140a13          	add	s4,s0,1
    802014fa:	0007851b          	sext.w	a0,a5
    802014fe:	ff95                	bnez	a5,8020143a <vprintfmt+0x1dc>
    80201500:	6a22                	ld	s4,8(sp)
    80201502:	bb41                	j	80201292 <vprintfmt+0x34>
    80201504:	000a2403          	lw	s0,0(s4)
    80201508:	b761                	j	80201490 <vprintfmt+0x232>
    8020150a:	000a6603          	lwu	a2,0(s4)
    8020150e:	46a1                	li	a3,8
    80201510:	8a3a                	mv	s4,a4
    80201512:	bd95                	j	80201386 <vprintfmt+0x128>
    80201514:	000a6603          	lwu	a2,0(s4)
    80201518:	46a9                	li	a3,10
    8020151a:	8a3a                	mv	s4,a4
    8020151c:	b5ad                	j	80201386 <vprintfmt+0x128>
    8020151e:	000a6603          	lwu	a2,0(s4)
    80201522:	46c1                	li	a3,16
    80201524:	8a3a                	mv	s4,a4
    80201526:	b585                	j	80201386 <vprintfmt+0x128>
    80201528:	9902                	jalr	s2
    8020152a:	bf0d                	j	8020145c <vprintfmt+0x1fe>
    8020152c:	85a6                	mv	a1,s1
    8020152e:	02d00513          	li	a0,45
    80201532:	9902                	jalr	s2
    80201534:	8a5e                	mv	s4,s7
    80201536:	40800633          	neg	a2,s0
    8020153a:	46a9                	li	a3,10
    8020153c:	b5a9                	j	80201386 <vprintfmt+0x128>
    8020153e:	01905663          	blez	s9,8020154a <vprintfmt+0x2ec>
    80201542:	02d00793          	li	a5,45
    80201546:	04fd9263          	bne	s11,a5,8020158a <vprintfmt+0x32c>
    8020154a:	00001a17          	auipc	s4,0x1
    8020154e:	a97a0a13          	add	s4,s4,-1385 # 80201fe1 <default_pmm_manager+0x139>
    80201552:	02800513          	li	a0,40
    80201556:	02800793          	li	a5,40
    8020155a:	b5c5                	j	8020143a <vprintfmt+0x1dc>
    8020155c:	85ea                	mv	a1,s10
    8020155e:	8522                	mv	a0,s0
    80201560:	0ae000ef          	jal	8020160e <strnlen>
    80201564:	40ac8cbb          	subw	s9,s9,a0
    80201568:	01905963          	blez	s9,8020157a <vprintfmt+0x31c>
    8020156c:	2d81                	sext.w	s11,s11
    8020156e:	3cfd                	addw	s9,s9,-1
    80201570:	85a6                	mv	a1,s1
    80201572:	856e                	mv	a0,s11
    80201574:	9902                	jalr	s2
    80201576:	fe0c9ce3          	bnez	s9,8020156e <vprintfmt+0x310>
    8020157a:	00044783          	lbu	a5,0(s0)
    8020157e:	0007851b          	sext.w	a0,a5
    80201582:	ea079ce3          	bnez	a5,8020143a <vprintfmt+0x1dc>
    80201586:	6a22                	ld	s4,8(sp)
    80201588:	b329                	j	80201292 <vprintfmt+0x34>
    8020158a:	85ea                	mv	a1,s10
    8020158c:	00001517          	auipc	a0,0x1
    80201590:	a5450513          	add	a0,a0,-1452 # 80201fe0 <default_pmm_manager+0x138>
    80201594:	07a000ef          	jal	8020160e <strnlen>
    80201598:	40ac8cbb          	subw	s9,s9,a0
    8020159c:	00001a17          	auipc	s4,0x1
    802015a0:	a45a0a13          	add	s4,s4,-1467 # 80201fe1 <default_pmm_manager+0x139>
    802015a4:	00001417          	auipc	s0,0x1
    802015a8:	a3c40413          	add	s0,s0,-1476 # 80201fe0 <default_pmm_manager+0x138>
    802015ac:	02800513          	li	a0,40
    802015b0:	02800793          	li	a5,40
    802015b4:	fb904ce3          	bgtz	s9,8020156c <vprintfmt+0x30e>
    802015b8:	b549                	j	8020143a <vprintfmt+0x1dc>

00000000802015ba <printfmt>:
    802015ba:	715d                	add	sp,sp,-80
    802015bc:	02810313          	add	t1,sp,40
    802015c0:	f436                	sd	a3,40(sp)
    802015c2:	869a                	mv	a3,t1
    802015c4:	ec06                	sd	ra,24(sp)
    802015c6:	f83a                	sd	a4,48(sp)
    802015c8:	fc3e                	sd	a5,56(sp)
    802015ca:	e0c2                	sd	a6,64(sp)
    802015cc:	e4c6                	sd	a7,72(sp)
    802015ce:	e41a                	sd	t1,8(sp)
    802015d0:	c8fff0ef          	jal	8020125e <vprintfmt>
    802015d4:	60e2                	ld	ra,24(sp)
    802015d6:	6161                	add	sp,sp,80
    802015d8:	8082                	ret

00000000802015da <sbi_console_putchar>:
    802015da:	4781                	li	a5,0
    802015dc:	00004717          	auipc	a4,0x4
    802015e0:	a2473703          	ld	a4,-1500(a4) # 80205000 <SBI_CONSOLE_PUTCHAR>
    802015e4:	88ba                	mv	a7,a4
    802015e6:	852a                	mv	a0,a0
    802015e8:	85be                	mv	a1,a5
    802015ea:	863e                	mv	a2,a5
    802015ec:	00000073          	ecall
    802015f0:	87aa                	mv	a5,a0
    802015f2:	8082                	ret

00000000802015f4 <sbi_set_timer>:
    802015f4:	4781                	li	a5,0
    802015f6:	00004717          	auipc	a4,0x4
    802015fa:	a5a73703          	ld	a4,-1446(a4) # 80205050 <SBI_SET_TIMER>
    802015fe:	88ba                	mv	a7,a4
    80201600:	852a                	mv	a0,a0
    80201602:	85be                	mv	a1,a5
    80201604:	863e                	mv	a2,a5
    80201606:	00000073          	ecall
    8020160a:	87aa                	mv	a5,a0
    8020160c:	8082                	ret

000000008020160e <strnlen>:
    8020160e:	4781                	li	a5,0
    80201610:	e589                	bnez	a1,8020161a <strnlen+0xc>
    80201612:	a811                	j	80201626 <strnlen+0x18>
    80201614:	0785                	add	a5,a5,1
    80201616:	00f58863          	beq	a1,a5,80201626 <strnlen+0x18>
    8020161a:	00f50733          	add	a4,a0,a5
    8020161e:	00074703          	lbu	a4,0(a4)
    80201622:	fb6d                	bnez	a4,80201614 <strnlen+0x6>
    80201624:	85be                	mv	a1,a5
    80201626:	852e                	mv	a0,a1
    80201628:	8082                	ret

000000008020162a <memset>:
    8020162a:	ca01                	beqz	a2,8020163a <memset+0x10>
    8020162c:	962a                	add	a2,a2,a0
    8020162e:	87aa                	mv	a5,a0
    80201630:	0785                	add	a5,a5,1
    80201632:	feb78fa3          	sb	a1,-1(a5)
    80201636:	fec79de3          	bne	a5,a2,80201630 <memset+0x6>
    8020163a:	8082                	ret
