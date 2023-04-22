
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00005117          	auipc	sp,0x5
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00005517          	auipc	a0,0x5
    8020000e:	ffe50513          	addi	a0,a0,-2 # 80205008 <free_area>
    80200012:	00005617          	auipc	a2,0x5
    80200016:	04660613          	addi	a2,a2,70 # 80205058 <end>
    8020001a:	1141                	addi	sp,sp,-16
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	606010ef          	jal	ra,80201628 <memset>
    80200026:	138000ef          	jal	ra,8020015e <cons_init>
    8020002a:	00001517          	auipc	a0,0x1
    8020002e:	61650513          	addi	a0,a0,1558 # 80201640 <etext+0x6>
    80200032:	086000ef          	jal	ra,802000b8 <cputs>
    80200036:	13e000ef          	jal	ra,80200174 <idt_init>
    8020003a:	05e010ef          	jal	ra,80201098 <pmm_init>
    8020003e:	136000ef          	jal	ra,80200174 <idt_init>
    80200042:	126000ef          	jal	ra,80200168 <intr_enable>
    80200046:	a001                	j	80200046 <kern_init+0x3c>

0000000080200048 <cputch>:
    80200048:	1141                	addi	sp,sp,-16
    8020004a:	e022                	sd	s0,0(sp)
    8020004c:	e406                	sd	ra,8(sp)
    8020004e:	842e                	mv	s0,a1
    80200050:	110000ef          	jal	ra,80200160 <cons_putc>
    80200054:	401c                	lw	a5,0(s0)
    80200056:	60a2                	ld	ra,8(sp)
    80200058:	2785                	addiw	a5,a5,1
    8020005a:	c01c                	sw	a5,0(s0)
    8020005c:	6402                	ld	s0,0(sp)
    8020005e:	0141                	addi	sp,sp,16
    80200060:	8082                	ret

0000000080200062 <vcprintf>:
    80200062:	1101                	addi	sp,sp,-32
    80200064:	862a                	mv	a2,a0
    80200066:	86ae                	mv	a3,a1
    80200068:	00000517          	auipc	a0,0x0
    8020006c:	fe050513          	addi	a0,a0,-32 # 80200048 <cputch>
    80200070:	006c                	addi	a1,sp,12
    80200072:	ec06                	sd	ra,24(sp)
    80200074:	c602                	sw	zero,12(sp)
    80200076:	1e0010ef          	jal	ra,80201256 <vprintfmt>
    8020007a:	60e2                	ld	ra,24(sp)
    8020007c:	4532                	lw	a0,12(sp)
    8020007e:	6105                	addi	sp,sp,32
    80200080:	8082                	ret

0000000080200082 <cprintf>:
    80200082:	711d                	addi	sp,sp,-96
    80200084:	02810313          	addi	t1,sp,40 # 80205028 <ticks>
    80200088:	8e2a                	mv	t3,a0
    8020008a:	f42e                	sd	a1,40(sp)
    8020008c:	f832                	sd	a2,48(sp)
    8020008e:	fc36                	sd	a3,56(sp)
    80200090:	00000517          	auipc	a0,0x0
    80200094:	fb850513          	addi	a0,a0,-72 # 80200048 <cputch>
    80200098:	004c                	addi	a1,sp,4
    8020009a:	869a                	mv	a3,t1
    8020009c:	8672                	mv	a2,t3
    8020009e:	ec06                	sd	ra,24(sp)
    802000a0:	e0ba                	sd	a4,64(sp)
    802000a2:	e4be                	sd	a5,72(sp)
    802000a4:	e8c2                	sd	a6,80(sp)
    802000a6:	ecc6                	sd	a7,88(sp)
    802000a8:	e41a                	sd	t1,8(sp)
    802000aa:	c202                	sw	zero,4(sp)
    802000ac:	1aa010ef          	jal	ra,80201256 <vprintfmt>
    802000b0:	60e2                	ld	ra,24(sp)
    802000b2:	4512                	lw	a0,4(sp)
    802000b4:	6125                	addi	sp,sp,96
    802000b6:	8082                	ret

00000000802000b8 <cputs>:
    802000b8:	1101                	addi	sp,sp,-32
    802000ba:	e822                	sd	s0,16(sp)
    802000bc:	ec06                	sd	ra,24(sp)
    802000be:	e426                	sd	s1,8(sp)
    802000c0:	842a                	mv	s0,a0
    802000c2:	00054503          	lbu	a0,0(a0)
    802000c6:	c51d                	beqz	a0,802000f4 <cputs+0x3c>
    802000c8:	0405                	addi	s0,s0,1
    802000ca:	4485                	li	s1,1
    802000cc:	9c81                	subw	s1,s1,s0
    802000ce:	092000ef          	jal	ra,80200160 <cons_putc>
    802000d2:	00044503          	lbu	a0,0(s0)
    802000d6:	008487bb          	addw	a5,s1,s0
    802000da:	0405                	addi	s0,s0,1
    802000dc:	f96d                	bnez	a0,802000ce <cputs+0x16>
    802000de:	0017841b          	addiw	s0,a5,1
    802000e2:	4529                	li	a0,10
    802000e4:	07c000ef          	jal	ra,80200160 <cons_putc>
    802000e8:	60e2                	ld	ra,24(sp)
    802000ea:	8522                	mv	a0,s0
    802000ec:	6442                	ld	s0,16(sp)
    802000ee:	64a2                	ld	s1,8(sp)
    802000f0:	6105                	addi	sp,sp,32
    802000f2:	8082                	ret
    802000f4:	4405                	li	s0,1
    802000f6:	b7f5                	j	802000e2 <cputs+0x2a>

00000000802000f8 <__panic>:
    802000f8:	00005317          	auipc	t1,0x5
    802000fc:	f2830313          	addi	t1,t1,-216 # 80205020 <is_panic>
    80200100:	00032e03          	lw	t3,0(t1)
    80200104:	715d                	addi	sp,sp,-80
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
    80200120:	103c                	addi	a5,sp,40
    80200122:	862e                	mv	a2,a1
    80200124:	85aa                	mv	a1,a0
    80200126:	00001517          	auipc	a0,0x1
    8020012a:	53250513          	addi	a0,a0,1330 # 80201658 <etext+0x1e>
    8020012e:	e43e                	sd	a5,8(sp)
    80200130:	f53ff0ef          	jal	ra,80200082 <cprintf>
    80200134:	65a2                	ld	a1,8(sp)
    80200136:	8522                	mv	a0,s0
    80200138:	f2bff0ef          	jal	ra,80200062 <vcprintf>
    8020013c:	00002517          	auipc	a0,0x2
    80200140:	95450513          	addi	a0,a0,-1708 # 80201a90 <etext+0x456>
    80200144:	f3fff0ef          	jal	ra,80200082 <cprintf>
    80200148:	026000ef          	jal	ra,8020016e <intr_disable>
    8020014c:	a001                	j	8020014c <__panic+0x54>

000000008020014e <clock_set_next_event>:
    8020014e:	c0102573          	rdtime	a0
    80200152:	67e1                	lui	a5,0x18
    80200154:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200158:	953e                	add	a0,a0,a5
    8020015a:	4980106f          	j	802015f2 <sbi_set_timer>

000000008020015e <cons_init>:
    8020015e:	8082                	ret

0000000080200160 <cons_putc>:
    80200160:	0ff57513          	andi	a0,a0,255
    80200164:	4740106f          	j	802015d8 <sbi_console_putchar>

0000000080200168 <intr_enable>:
    80200168:	100167f3          	csrrsi	a5,sstatus,2
    8020016c:	8082                	ret

000000008020016e <intr_disable>:
    8020016e:	100177f3          	csrrci	a5,sstatus,2
    80200172:	8082                	ret

0000000080200174 <idt_init>:
    80200174:	14005073          	csrwi	sscratch,0
    80200178:	00000797          	auipc	a5,0x0
    8020017c:	2e478793          	addi	a5,a5,740 # 8020045c <__alltraps>
    80200180:	10579073          	csrw	stvec,a5
    80200184:	8082                	ret

0000000080200186 <print_regs>:
    80200186:	610c                	ld	a1,0(a0)
    80200188:	1141                	addi	sp,sp,-16
    8020018a:	e022                	sd	s0,0(sp)
    8020018c:	842a                	mv	s0,a0
    8020018e:	00001517          	auipc	a0,0x1
    80200192:	4ea50513          	addi	a0,a0,1258 # 80201678 <etext+0x3e>
    80200196:	e406                	sd	ra,8(sp)
    80200198:	eebff0ef          	jal	ra,80200082 <cprintf>
    8020019c:	640c                	ld	a1,8(s0)
    8020019e:	00001517          	auipc	a0,0x1
    802001a2:	4f250513          	addi	a0,a0,1266 # 80201690 <etext+0x56>
    802001a6:	eddff0ef          	jal	ra,80200082 <cprintf>
    802001aa:	680c                	ld	a1,16(s0)
    802001ac:	00001517          	auipc	a0,0x1
    802001b0:	4fc50513          	addi	a0,a0,1276 # 802016a8 <etext+0x6e>
    802001b4:	ecfff0ef          	jal	ra,80200082 <cprintf>
    802001b8:	6c0c                	ld	a1,24(s0)
    802001ba:	00001517          	auipc	a0,0x1
    802001be:	50650513          	addi	a0,a0,1286 # 802016c0 <etext+0x86>
    802001c2:	ec1ff0ef          	jal	ra,80200082 <cprintf>
    802001c6:	700c                	ld	a1,32(s0)
    802001c8:	00001517          	auipc	a0,0x1
    802001cc:	51050513          	addi	a0,a0,1296 # 802016d8 <etext+0x9e>
    802001d0:	eb3ff0ef          	jal	ra,80200082 <cprintf>
    802001d4:	740c                	ld	a1,40(s0)
    802001d6:	00001517          	auipc	a0,0x1
    802001da:	51a50513          	addi	a0,a0,1306 # 802016f0 <etext+0xb6>
    802001de:	ea5ff0ef          	jal	ra,80200082 <cprintf>
    802001e2:	780c                	ld	a1,48(s0)
    802001e4:	00001517          	auipc	a0,0x1
    802001e8:	52450513          	addi	a0,a0,1316 # 80201708 <etext+0xce>
    802001ec:	e97ff0ef          	jal	ra,80200082 <cprintf>
    802001f0:	7c0c                	ld	a1,56(s0)
    802001f2:	00001517          	auipc	a0,0x1
    802001f6:	52e50513          	addi	a0,a0,1326 # 80201720 <etext+0xe6>
    802001fa:	e89ff0ef          	jal	ra,80200082 <cprintf>
    802001fe:	602c                	ld	a1,64(s0)
    80200200:	00001517          	auipc	a0,0x1
    80200204:	53850513          	addi	a0,a0,1336 # 80201738 <etext+0xfe>
    80200208:	e7bff0ef          	jal	ra,80200082 <cprintf>
    8020020c:	642c                	ld	a1,72(s0)
    8020020e:	00001517          	auipc	a0,0x1
    80200212:	54250513          	addi	a0,a0,1346 # 80201750 <etext+0x116>
    80200216:	e6dff0ef          	jal	ra,80200082 <cprintf>
    8020021a:	682c                	ld	a1,80(s0)
    8020021c:	00001517          	auipc	a0,0x1
    80200220:	54c50513          	addi	a0,a0,1356 # 80201768 <etext+0x12e>
    80200224:	e5fff0ef          	jal	ra,80200082 <cprintf>
    80200228:	6c2c                	ld	a1,88(s0)
    8020022a:	00001517          	auipc	a0,0x1
    8020022e:	55650513          	addi	a0,a0,1366 # 80201780 <etext+0x146>
    80200232:	e51ff0ef          	jal	ra,80200082 <cprintf>
    80200236:	702c                	ld	a1,96(s0)
    80200238:	00001517          	auipc	a0,0x1
    8020023c:	56050513          	addi	a0,a0,1376 # 80201798 <etext+0x15e>
    80200240:	e43ff0ef          	jal	ra,80200082 <cprintf>
    80200244:	742c                	ld	a1,104(s0)
    80200246:	00001517          	auipc	a0,0x1
    8020024a:	56a50513          	addi	a0,a0,1386 # 802017b0 <etext+0x176>
    8020024e:	e35ff0ef          	jal	ra,80200082 <cprintf>
    80200252:	782c                	ld	a1,112(s0)
    80200254:	00001517          	auipc	a0,0x1
    80200258:	57450513          	addi	a0,a0,1396 # 802017c8 <etext+0x18e>
    8020025c:	e27ff0ef          	jal	ra,80200082 <cprintf>
    80200260:	7c2c                	ld	a1,120(s0)
    80200262:	00001517          	auipc	a0,0x1
    80200266:	57e50513          	addi	a0,a0,1406 # 802017e0 <etext+0x1a6>
    8020026a:	e19ff0ef          	jal	ra,80200082 <cprintf>
    8020026e:	604c                	ld	a1,128(s0)
    80200270:	00001517          	auipc	a0,0x1
    80200274:	58850513          	addi	a0,a0,1416 # 802017f8 <etext+0x1be>
    80200278:	e0bff0ef          	jal	ra,80200082 <cprintf>
    8020027c:	644c                	ld	a1,136(s0)
    8020027e:	00001517          	auipc	a0,0x1
    80200282:	59250513          	addi	a0,a0,1426 # 80201810 <etext+0x1d6>
    80200286:	dfdff0ef          	jal	ra,80200082 <cprintf>
    8020028a:	684c                	ld	a1,144(s0)
    8020028c:	00001517          	auipc	a0,0x1
    80200290:	59c50513          	addi	a0,a0,1436 # 80201828 <etext+0x1ee>
    80200294:	defff0ef          	jal	ra,80200082 <cprintf>
    80200298:	6c4c                	ld	a1,152(s0)
    8020029a:	00001517          	auipc	a0,0x1
    8020029e:	5a650513          	addi	a0,a0,1446 # 80201840 <etext+0x206>
    802002a2:	de1ff0ef          	jal	ra,80200082 <cprintf>
    802002a6:	704c                	ld	a1,160(s0)
    802002a8:	00001517          	auipc	a0,0x1
    802002ac:	5b050513          	addi	a0,a0,1456 # 80201858 <etext+0x21e>
    802002b0:	dd3ff0ef          	jal	ra,80200082 <cprintf>
    802002b4:	744c                	ld	a1,168(s0)
    802002b6:	00001517          	auipc	a0,0x1
    802002ba:	5ba50513          	addi	a0,a0,1466 # 80201870 <etext+0x236>
    802002be:	dc5ff0ef          	jal	ra,80200082 <cprintf>
    802002c2:	784c                	ld	a1,176(s0)
    802002c4:	00001517          	auipc	a0,0x1
    802002c8:	5c450513          	addi	a0,a0,1476 # 80201888 <etext+0x24e>
    802002cc:	db7ff0ef          	jal	ra,80200082 <cprintf>
    802002d0:	7c4c                	ld	a1,184(s0)
    802002d2:	00001517          	auipc	a0,0x1
    802002d6:	5ce50513          	addi	a0,a0,1486 # 802018a0 <etext+0x266>
    802002da:	da9ff0ef          	jal	ra,80200082 <cprintf>
    802002de:	606c                	ld	a1,192(s0)
    802002e0:	00001517          	auipc	a0,0x1
    802002e4:	5d850513          	addi	a0,a0,1496 # 802018b8 <etext+0x27e>
    802002e8:	d9bff0ef          	jal	ra,80200082 <cprintf>
    802002ec:	646c                	ld	a1,200(s0)
    802002ee:	00001517          	auipc	a0,0x1
    802002f2:	5e250513          	addi	a0,a0,1506 # 802018d0 <etext+0x296>
    802002f6:	d8dff0ef          	jal	ra,80200082 <cprintf>
    802002fa:	686c                	ld	a1,208(s0)
    802002fc:	00001517          	auipc	a0,0x1
    80200300:	5ec50513          	addi	a0,a0,1516 # 802018e8 <etext+0x2ae>
    80200304:	d7fff0ef          	jal	ra,80200082 <cprintf>
    80200308:	6c6c                	ld	a1,216(s0)
    8020030a:	00001517          	auipc	a0,0x1
    8020030e:	5f650513          	addi	a0,a0,1526 # 80201900 <etext+0x2c6>
    80200312:	d71ff0ef          	jal	ra,80200082 <cprintf>
    80200316:	706c                	ld	a1,224(s0)
    80200318:	00001517          	auipc	a0,0x1
    8020031c:	60050513          	addi	a0,a0,1536 # 80201918 <etext+0x2de>
    80200320:	d63ff0ef          	jal	ra,80200082 <cprintf>
    80200324:	746c                	ld	a1,232(s0)
    80200326:	00001517          	auipc	a0,0x1
    8020032a:	60a50513          	addi	a0,a0,1546 # 80201930 <etext+0x2f6>
    8020032e:	d55ff0ef          	jal	ra,80200082 <cprintf>
    80200332:	786c                	ld	a1,240(s0)
    80200334:	00001517          	auipc	a0,0x1
    80200338:	61450513          	addi	a0,a0,1556 # 80201948 <etext+0x30e>
    8020033c:	d47ff0ef          	jal	ra,80200082 <cprintf>
    80200340:	7c6c                	ld	a1,248(s0)
    80200342:	6402                	ld	s0,0(sp)
    80200344:	60a2                	ld	ra,8(sp)
    80200346:	00001517          	auipc	a0,0x1
    8020034a:	61a50513          	addi	a0,a0,1562 # 80201960 <etext+0x326>
    8020034e:	0141                	addi	sp,sp,16
    80200350:	bb0d                	j	80200082 <cprintf>

0000000080200352 <print_trapframe>:
    80200352:	1141                	addi	sp,sp,-16
    80200354:	e022                	sd	s0,0(sp)
    80200356:	85aa                	mv	a1,a0
    80200358:	842a                	mv	s0,a0
    8020035a:	00001517          	auipc	a0,0x1
    8020035e:	61e50513          	addi	a0,a0,1566 # 80201978 <etext+0x33e>
    80200362:	e406                	sd	ra,8(sp)
    80200364:	d1fff0ef          	jal	ra,80200082 <cprintf>
    80200368:	8522                	mv	a0,s0
    8020036a:	e1dff0ef          	jal	ra,80200186 <print_regs>
    8020036e:	10043583          	ld	a1,256(s0)
    80200372:	00001517          	auipc	a0,0x1
    80200376:	61e50513          	addi	a0,a0,1566 # 80201990 <etext+0x356>
    8020037a:	d09ff0ef          	jal	ra,80200082 <cprintf>
    8020037e:	10843583          	ld	a1,264(s0)
    80200382:	00001517          	auipc	a0,0x1
    80200386:	62650513          	addi	a0,a0,1574 # 802019a8 <etext+0x36e>
    8020038a:	cf9ff0ef          	jal	ra,80200082 <cprintf>
    8020038e:	11043583          	ld	a1,272(s0)
    80200392:	00001517          	auipc	a0,0x1
    80200396:	62e50513          	addi	a0,a0,1582 # 802019c0 <etext+0x386>
    8020039a:	ce9ff0ef          	jal	ra,80200082 <cprintf>
    8020039e:	11843583          	ld	a1,280(s0)
    802003a2:	6402                	ld	s0,0(sp)
    802003a4:	60a2                	ld	ra,8(sp)
    802003a6:	00001517          	auipc	a0,0x1
    802003aa:	63250513          	addi	a0,a0,1586 # 802019d8 <etext+0x39e>
    802003ae:	0141                	addi	sp,sp,16
    802003b0:	b9c9                	j	80200082 <cprintf>

00000000802003b2 <interrupt_handler>:
    802003b2:	11853783          	ld	a5,280(a0)
    802003b6:	472d                	li	a4,11
    802003b8:	0786                	slli	a5,a5,0x1
    802003ba:	8385                	srli	a5,a5,0x1
    802003bc:	06f76c63          	bltu	a4,a5,80200434 <interrupt_handler+0x82>
    802003c0:	00001717          	auipc	a4,0x1
    802003c4:	6f870713          	addi	a4,a4,1784 # 80201ab8 <etext+0x47e>
    802003c8:	078a                	slli	a5,a5,0x2
    802003ca:	97ba                	add	a5,a5,a4
    802003cc:	439c                	lw	a5,0(a5)
    802003ce:	97ba                	add	a5,a5,a4
    802003d0:	8782                	jr	a5
    802003d2:	00001517          	auipc	a0,0x1
    802003d6:	67e50513          	addi	a0,a0,1662 # 80201a50 <etext+0x416>
    802003da:	b165                	j	80200082 <cprintf>
    802003dc:	00001517          	auipc	a0,0x1
    802003e0:	65450513          	addi	a0,a0,1620 # 80201a30 <etext+0x3f6>
    802003e4:	b979                	j	80200082 <cprintf>
    802003e6:	00001517          	auipc	a0,0x1
    802003ea:	60a50513          	addi	a0,a0,1546 # 802019f0 <etext+0x3b6>
    802003ee:	b951                	j	80200082 <cprintf>
    802003f0:	00001517          	auipc	a0,0x1
    802003f4:	68050513          	addi	a0,a0,1664 # 80201a70 <etext+0x436>
    802003f8:	b169                	j	80200082 <cprintf>
    802003fa:	1141                	addi	sp,sp,-16
    802003fc:	e406                	sd	ra,8(sp)
    802003fe:	d51ff0ef          	jal	ra,8020014e <clock_set_next_event>
    80200402:	00005697          	auipc	a3,0x5
    80200406:	c2668693          	addi	a3,a3,-986 # 80205028 <ticks>
    8020040a:	629c                	ld	a5,0(a3)
    8020040c:	06400713          	li	a4,100
    80200410:	0785                	addi	a5,a5,1
    80200412:	02e7f733          	remu	a4,a5,a4
    80200416:	e29c                	sd	a5,0(a3)
    80200418:	cf19                	beqz	a4,80200436 <interrupt_handler+0x84>
    8020041a:	60a2                	ld	ra,8(sp)
    8020041c:	0141                	addi	sp,sp,16
    8020041e:	8082                	ret
    80200420:	00001517          	auipc	a0,0x1
    80200424:	67850513          	addi	a0,a0,1656 # 80201a98 <etext+0x45e>
    80200428:	b9a9                	j	80200082 <cprintf>
    8020042a:	00001517          	auipc	a0,0x1
    8020042e:	5e650513          	addi	a0,a0,1510 # 80201a10 <etext+0x3d6>
    80200432:	b981                	j	80200082 <cprintf>
    80200434:	bf39                	j	80200352 <print_trapframe>
    80200436:	60a2                	ld	ra,8(sp)
    80200438:	06400593          	li	a1,100
    8020043c:	00001517          	auipc	a0,0x1
    80200440:	64c50513          	addi	a0,a0,1612 # 80201a88 <etext+0x44e>
    80200444:	0141                	addi	sp,sp,16
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
    80200460:	712d                	addi	sp,sp,-288
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
    802004c0:	f89ff0ef          	jal	ra,80200448 <trap>

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
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
    80200512:	00005797          	auipc	a5,0x5
    80200516:	af678793          	addi	a5,a5,-1290 # 80205008 <free_area>
    8020051a:	e79c                	sd	a5,8(a5)
    8020051c:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
    8020051e:	0007a823          	sw	zero,16(a5)
}
    80200522:	8082                	ret

0000000080200524 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
    80200524:	00005517          	auipc	a0,0x5
    80200528:	af456503          	lwu	a0,-1292(a0) # 80205018 <free_area+0x10>
    8020052c:	8082                	ret

000000008020052e <firstfit_check_final>:
    free_page(p2);
}


static void
firstfit_check_final(void) {
    8020052e:	715d                	addi	sp,sp,-80
    80200530:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
    80200532:	00005417          	auipc	s0,0x5
    80200536:	ad640413          	addi	s0,s0,-1322 # 80205008 <free_area>
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
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
    8020054e:	2c878763          	beq	a5,s0,8020081c <firstfit_check_final+0x2ee>
    int count = 0, total = 0;
    80200552:	4481                	li	s1,0
    80200554:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
    80200556:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
    8020055a:	8b09                	andi	a4,a4,2
    8020055c:	2c070463          	beqz	a4,80200824 <firstfit_check_final+0x2f6>
        count ++, total += p->property;
    80200560:	ff87a703          	lw	a4,-8(a5)
    80200564:	679c                	ld	a5,8(a5)
    80200566:	2905                	addiw	s2,s2,1
    80200568:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
    8020056a:	fe8796e3          	bne	a5,s0,80200556 <firstfit_check_final+0x28>
    }
    assert(total == nr_free_pages());
    8020056e:	89a6                	mv	s3,s1
    80200570:	2ef000ef          	jal	ra,8020105e <nr_free_pages>
    80200574:	71351863          	bne	a0,s3,80200c84 <firstfit_check_final+0x756>
    assert((p0 = alloc_page()) != NULL);
    80200578:	4505                	li	a0,1
    8020057a:	267000ef          	jal	ra,80200fe0 <alloc_pages>
    8020057e:	8a2a                	mv	s4,a0
    80200580:	44050263          	beqz	a0,802009c4 <firstfit_check_final+0x496>
    assert((p1 = alloc_page()) != NULL);
    80200584:	4505                	li	a0,1
    80200586:	25b000ef          	jal	ra,80200fe0 <alloc_pages>
    8020058a:	89aa                	mv	s3,a0
    8020058c:	70050c63          	beqz	a0,80200ca4 <firstfit_check_final+0x776>
    assert((p2 = alloc_page()) != NULL);
    80200590:	4505                	li	a0,1
    80200592:	24f000ef          	jal	ra,80200fe0 <alloc_pages>
    80200596:	8aaa                	mv	s5,a0
    80200598:	4a050663          	beqz	a0,80200a44 <firstfit_check_final+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    8020059c:	2b3a0463          	beq	s4,s3,80200844 <firstfit_check_final+0x316>
    802005a0:	2aaa0263          	beq	s4,a0,80200844 <firstfit_check_final+0x316>
    802005a4:	2aa98063          	beq	s3,a0,80200844 <firstfit_check_final+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
    802005a8:	000a2783          	lw	a5,0(s4)
    802005ac:	2a079c63          	bnez	a5,80200864 <firstfit_check_final+0x336>
    802005b0:	0009a783          	lw	a5,0(s3)
    802005b4:	2a079863          	bnez	a5,80200864 <firstfit_check_final+0x336>
    802005b8:	411c                	lw	a5,0(a0)
    802005ba:	2a079563          	bnez	a5,80200864 <firstfit_check_final+0x336>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
    802005be:	00005797          	auipc	a5,0x5
    802005c2:	a7a7b783          	ld	a5,-1414(a5) # 80205038 <pages>
    802005c6:	40fa0733          	sub	a4,s4,a5
    802005ca:	870d                	srai	a4,a4,0x3
    802005cc:	00002597          	auipc	a1,0x2
    802005d0:	c545b583          	ld	a1,-940(a1) # 80202220 <error_string+0x38>
    802005d4:	02b70733          	mul	a4,a4,a1
    802005d8:	00002617          	auipc	a2,0x2
    802005dc:	c5063603          	ld	a2,-944(a2) # 80202228 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
    802005e0:	00005697          	auipc	a3,0x5
    802005e4:	a506b683          	ld	a3,-1456(a3) # 80205030 <npage>
    802005e8:	06b2                	slli	a3,a3,0xc
    802005ea:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
    802005ec:	0732                	slli	a4,a4,0xc
    802005ee:	28d77b63          	bgeu	a4,a3,80200884 <firstfit_check_final+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
    802005f2:	40f98733          	sub	a4,s3,a5
    802005f6:	870d                	srai	a4,a4,0x3
    802005f8:	02b70733          	mul	a4,a4,a1
    802005fc:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
    802005fe:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
    80200600:	4cd77263          	bgeu	a4,a3,80200ac4 <firstfit_check_final+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
    80200604:	40f507b3          	sub	a5,a0,a5
    80200608:	878d                	srai	a5,a5,0x3
    8020060a:	02b787b3          	mul	a5,a5,a1
    8020060e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
    80200610:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
    80200612:	30d7f963          	bgeu	a5,a3,80200924 <firstfit_check_final+0x3f6>
    assert(alloc_page() == NULL);
    80200616:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
    80200618:	00043c03          	ld	s8,0(s0)
    8020061c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
    80200620:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
    80200624:	e400                	sd	s0,8(s0)
    80200626:	e000                	sd	s0,0(s0)
    nr_free = 0;
    80200628:	00005797          	auipc	a5,0x5
    8020062c:	9e07a823          	sw	zero,-1552(a5) # 80205018 <free_area+0x10>
    assert(alloc_page() == NULL);
    80200630:	1b1000ef          	jal	ra,80200fe0 <alloc_pages>
    80200634:	2c051863          	bnez	a0,80200904 <firstfit_check_final+0x3d6>
    free_page(p0);
    80200638:	4585                	li	a1,1
    8020063a:	8552                	mv	a0,s4
    8020063c:	1e3000ef          	jal	ra,8020101e <free_pages>
    free_page(p1);
    80200640:	4585                	li	a1,1
    80200642:	854e                	mv	a0,s3
    80200644:	1db000ef          	jal	ra,8020101e <free_pages>
    free_page(p2);
    80200648:	4585                	li	a1,1
    8020064a:	8556                	mv	a0,s5
    8020064c:	1d3000ef          	jal	ra,8020101e <free_pages>
    assert(nr_free == 3);
    80200650:	4818                	lw	a4,16(s0)
    80200652:	478d                	li	a5,3
    80200654:	28f71863          	bne	a4,a5,802008e4 <firstfit_check_final+0x3b6>
    assert((p0 = alloc_page()) != NULL);
    80200658:	4505                	li	a0,1
    8020065a:	187000ef          	jal	ra,80200fe0 <alloc_pages>
    8020065e:	89aa                	mv	s3,a0
    80200660:	26050263          	beqz	a0,802008c4 <firstfit_check_final+0x396>
    assert((p1 = alloc_page()) != NULL);
    80200664:	4505                	li	a0,1
    80200666:	17b000ef          	jal	ra,80200fe0 <alloc_pages>
    8020066a:	8aaa                	mv	s5,a0
    8020066c:	3a050c63          	beqz	a0,80200a24 <firstfit_check_final+0x4f6>
    assert((p2 = alloc_page()) != NULL);
    80200670:	4505                	li	a0,1
    80200672:	16f000ef          	jal	ra,80200fe0 <alloc_pages>
    80200676:	8a2a                	mv	s4,a0
    80200678:	38050663          	beqz	a0,80200a04 <firstfit_check_final+0x4d6>
    assert(alloc_page() == NULL);
    8020067c:	4505                	li	a0,1
    8020067e:	163000ef          	jal	ra,80200fe0 <alloc_pages>
    80200682:	36051163          	bnez	a0,802009e4 <firstfit_check_final+0x4b6>
    free_page(p0);
    80200686:	4585                	li	a1,1
    80200688:	854e                	mv	a0,s3
    8020068a:	195000ef          	jal	ra,8020101e <free_pages>
    assert(!list_empty(&free_list));
    8020068e:	641c                	ld	a5,8(s0)
    80200690:	20878a63          	beq	a5,s0,802008a4 <firstfit_check_final+0x376>
    assert((p = alloc_page()) == p0);
    80200694:	4505                	li	a0,1
    80200696:	14b000ef          	jal	ra,80200fe0 <alloc_pages>
    8020069a:	30a99563          	bne	s3,a0,802009a4 <firstfit_check_final+0x476>
    assert(alloc_page() == NULL);
    8020069e:	4505                	li	a0,1
    802006a0:	141000ef          	jal	ra,80200fe0 <alloc_pages>
    802006a4:	2e051063          	bnez	a0,80200984 <firstfit_check_final+0x456>
    assert(nr_free == 0);
    802006a8:	481c                	lw	a5,16(s0)
    802006aa:	2a079d63          	bnez	a5,80200964 <firstfit_check_final+0x436>
    free_page(p);
    802006ae:	854e                	mv	a0,s3
    802006b0:	4585                	li	a1,1
    free_list = free_list_store;
    802006b2:	01843023          	sd	s8,0(s0)
    802006b6:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
    802006ba:	01642823          	sw	s6,16(s0)
    free_page(p);
    802006be:	161000ef          	jal	ra,8020101e <free_pages>
    free_page(p1);
    802006c2:	4585                	li	a1,1
    802006c4:	8556                	mv	a0,s5
    802006c6:	159000ef          	jal	ra,8020101e <free_pages>
    free_page(p2);
    802006ca:	4585                	li	a1,1
    802006cc:	8552                	mv	a0,s4
    802006ce:	151000ef          	jal	ra,8020101e <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
    802006d2:	4515                	li	a0,5
    802006d4:	10d000ef          	jal	ra,80200fe0 <alloc_pages>
    802006d8:	89aa                	mv	s3,a0
    assert(p0 != NULL);
    802006da:	26050563          	beqz	a0,80200944 <firstfit_check_final+0x416>
    802006de:	651c                	ld	a5,8(a0)
    802006e0:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
    802006e2:	8b85                	andi	a5,a5,1
    802006e4:	54079063          	bnez	a5,80200c24 <firstfit_check_final+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
    802006e8:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
    802006ea:	00043b03          	ld	s6,0(s0)
    802006ee:	00843a83          	ld	s5,8(s0)
    802006f2:	e000                	sd	s0,0(s0)
    802006f4:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
    802006f6:	0eb000ef          	jal	ra,80200fe0 <alloc_pages>
    802006fa:	50051563          	bnez	a0,80200c04 <firstfit_check_final+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
    802006fe:	05098a13          	addi	s4,s3,80
    80200702:	8552                	mv	a0,s4
    80200704:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
    80200706:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
    8020070a:	00005797          	auipc	a5,0x5
    8020070e:	9007a723          	sw	zero,-1778(a5) # 80205018 <free_area+0x10>
    free_pages(p0 + 2, 3);
    80200712:	10d000ef          	jal	ra,8020101e <free_pages>
    assert(alloc_pages(4) == NULL);
    80200716:	4511                	li	a0,4
    80200718:	0c9000ef          	jal	ra,80200fe0 <alloc_pages>
    8020071c:	4c051463          	bnez	a0,80200be4 <firstfit_check_final+0x6b6>
    80200720:	0589b783          	ld	a5,88(s3)
    80200724:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    80200726:	8b85                	andi	a5,a5,1
    80200728:	48078e63          	beqz	a5,80200bc4 <firstfit_check_final+0x696>
    8020072c:	0609a703          	lw	a4,96(s3)
    80200730:	478d                	li	a5,3
    80200732:	48f71963          	bne	a4,a5,80200bc4 <firstfit_check_final+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
    80200736:	450d                	li	a0,3
    80200738:	0a9000ef          	jal	ra,80200fe0 <alloc_pages>
    8020073c:	8c2a                	mv	s8,a0
    8020073e:	46050363          	beqz	a0,80200ba4 <firstfit_check_final+0x676>
    assert(alloc_page() == NULL);
    80200742:	4505                	li	a0,1
    80200744:	09d000ef          	jal	ra,80200fe0 <alloc_pages>
    80200748:	42051e63          	bnez	a0,80200b84 <firstfit_check_final+0x656>
    assert(p0 + 2 == p1);
    8020074c:	418a1c63          	bne	s4,s8,80200b64 <firstfit_check_final+0x636>

    p2 = p0 + 1;
    free_page(p0);
    80200750:	4585                	li	a1,1
    80200752:	854e                	mv	a0,s3
    80200754:	0cb000ef          	jal	ra,8020101e <free_pages>
    free_pages(p1, 3);
    80200758:	458d                	li	a1,3
    8020075a:	8552                	mv	a0,s4
    8020075c:	0c3000ef          	jal	ra,8020101e <free_pages>
    80200760:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
    80200764:	02898c13          	addi	s8,s3,40
    80200768:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
    8020076a:	8b85                	andi	a5,a5,1
    8020076c:	3c078c63          	beqz	a5,80200b44 <firstfit_check_final+0x616>
    80200770:	0109a703          	lw	a4,16(s3)
    80200774:	4785                	li	a5,1
    80200776:	3cf71763          	bne	a4,a5,80200b44 <firstfit_check_final+0x616>
    8020077a:	008a3783          	ld	a5,8(s4)
    8020077e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
    80200780:	8b85                	andi	a5,a5,1
    80200782:	3a078163          	beqz	a5,80200b24 <firstfit_check_final+0x5f6>
    80200786:	010a2703          	lw	a4,16(s4)
    8020078a:	478d                	li	a5,3
    8020078c:	38f71c63          	bne	a4,a5,80200b24 <firstfit_check_final+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
    80200790:	4505                	li	a0,1
    80200792:	04f000ef          	jal	ra,80200fe0 <alloc_pages>
    80200796:	36a99763          	bne	s3,a0,80200b04 <firstfit_check_final+0x5d6>
    free_page(p0);
    8020079a:	4585                	li	a1,1
    8020079c:	083000ef          	jal	ra,8020101e <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
    802007a0:	4509                	li	a0,2
    802007a2:	03f000ef          	jal	ra,80200fe0 <alloc_pages>
    802007a6:	32aa1f63          	bne	s4,a0,80200ae4 <firstfit_check_final+0x5b6>

    free_pages(p0, 2);
    802007aa:	4589                	li	a1,2
    802007ac:	073000ef          	jal	ra,8020101e <free_pages>
    free_page(p2);
    802007b0:	4585                	li	a1,1
    802007b2:	8562                	mv	a0,s8
    802007b4:	06b000ef          	jal	ra,8020101e <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
    802007b8:	4515                	li	a0,5
    802007ba:	027000ef          	jal	ra,80200fe0 <alloc_pages>
    802007be:	89aa                	mv	s3,a0
    802007c0:	48050263          	beqz	a0,80200c44 <firstfit_check_final+0x716>
    assert(alloc_page() == NULL);
    802007c4:	4505                	li	a0,1
    802007c6:	01b000ef          	jal	ra,80200fe0 <alloc_pages>
    802007ca:	2c051d63          	bnez	a0,80200aa4 <firstfit_check_final+0x576>

    assert(nr_free == 0);
    802007ce:	481c                	lw	a5,16(s0)
    802007d0:	2a079a63          	bnez	a5,80200a84 <firstfit_check_final+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
    802007d4:	4595                	li	a1,5
    802007d6:	854e                	mv	a0,s3
    nr_free = nr_free_store;
    802007d8:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
    802007dc:	01643023          	sd	s6,0(s0)
    802007e0:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
    802007e4:	03b000ef          	jal	ra,8020101e <free_pages>
    return listelm->next;
    802007e8:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
    802007ea:	00878963          	beq	a5,s0,802007fc <firstfit_check_final+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    802007ee:	ff87a703          	lw	a4,-8(a5)
    802007f2:	679c                	ld	a5,8(a5)
    802007f4:	397d                	addiw	s2,s2,-1
    802007f6:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
    802007f8:	fe879be3          	bne	a5,s0,802007ee <firstfit_check_final+0x2c0>
    }
    assert(count == 0);
    802007fc:	26091463          	bnez	s2,80200a64 <firstfit_check_final+0x536>
    assert(total == 0);
    80200800:	46049263          	bnez	s1,80200c64 <firstfit_check_final+0x736>
}
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
    80200818:	6161                	addi	sp,sp,80
    8020081a:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
    8020081c:	4981                	li	s3,0
    int count = 0, total = 0;
    8020081e:	4481                	li	s1,0
    80200820:	4901                	li	s2,0
    80200822:	b3b9                	j	80200570 <firstfit_check_final+0x42>
        assert(PageProperty(p));
    80200824:	00001697          	auipc	a3,0x1
    80200828:	2c468693          	addi	a3,a3,708 # 80201ae8 <etext+0x4ae>
    8020082c:	00001617          	auipc	a2,0x1
    80200830:	2cc60613          	addi	a2,a2,716 # 80201af8 <etext+0x4be>
    80200834:	12200593          	li	a1,290
    80200838:	00001517          	auipc	a0,0x1
    8020083c:	2d850513          	addi	a0,a0,728 # 80201b10 <etext+0x4d6>
    80200840:	8b9ff0ef          	jal	ra,802000f8 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
    80200844:	00001697          	auipc	a3,0x1
    80200848:	36468693          	addi	a3,a3,868 # 80201ba8 <etext+0x56e>
    8020084c:	00001617          	auipc	a2,0x1
    80200850:	2ac60613          	addi	a2,a2,684 # 80201af8 <etext+0x4be>
    80200854:	0c100593          	li	a1,193
    80200858:	00001517          	auipc	a0,0x1
    8020085c:	2b850513          	addi	a0,a0,696 # 80201b10 <etext+0x4d6>
    80200860:	899ff0ef          	jal	ra,802000f8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
    80200864:	00001697          	auipc	a3,0x1
    80200868:	36c68693          	addi	a3,a3,876 # 80201bd0 <etext+0x596>
    8020086c:	00001617          	auipc	a2,0x1
    80200870:	28c60613          	addi	a2,a2,652 # 80201af8 <etext+0x4be>
    80200874:	0c200593          	li	a1,194
    80200878:	00001517          	auipc	a0,0x1
    8020087c:	29850513          	addi	a0,a0,664 # 80201b10 <etext+0x4d6>
    80200880:	879ff0ef          	jal	ra,802000f8 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
    80200884:	00001697          	auipc	a3,0x1
    80200888:	38c68693          	addi	a3,a3,908 # 80201c10 <etext+0x5d6>
    8020088c:	00001617          	auipc	a2,0x1
    80200890:	26c60613          	addi	a2,a2,620 # 80201af8 <etext+0x4be>
    80200894:	0c400593          	li	a1,196
    80200898:	00001517          	auipc	a0,0x1
    8020089c:	27850513          	addi	a0,a0,632 # 80201b10 <etext+0x4d6>
    802008a0:	859ff0ef          	jal	ra,802000f8 <__panic>
    assert(!list_empty(&free_list));
    802008a4:	00001697          	auipc	a3,0x1
    802008a8:	3f468693          	addi	a3,a3,1012 # 80201c98 <etext+0x65e>
    802008ac:	00001617          	auipc	a2,0x1
    802008b0:	24c60613          	addi	a2,a2,588 # 80201af8 <etext+0x4be>
    802008b4:	0dd00593          	li	a1,221
    802008b8:	00001517          	auipc	a0,0x1
    802008bc:	25850513          	addi	a0,a0,600 # 80201b10 <etext+0x4d6>
    802008c0:	839ff0ef          	jal	ra,802000f8 <__panic>
    assert((p0 = alloc_page()) != NULL);
    802008c4:	00001697          	auipc	a3,0x1
    802008c8:	28468693          	addi	a3,a3,644 # 80201b48 <etext+0x50e>
    802008cc:	00001617          	auipc	a2,0x1
    802008d0:	22c60613          	addi	a2,a2,556 # 80201af8 <etext+0x4be>
    802008d4:	0d600593          	li	a1,214
    802008d8:	00001517          	auipc	a0,0x1
    802008dc:	23850513          	addi	a0,a0,568 # 80201b10 <etext+0x4d6>
    802008e0:	819ff0ef          	jal	ra,802000f8 <__panic>
    assert(nr_free == 3);
    802008e4:	00001697          	auipc	a3,0x1
    802008e8:	3a468693          	addi	a3,a3,932 # 80201c88 <etext+0x64e>
    802008ec:	00001617          	auipc	a2,0x1
    802008f0:	20c60613          	addi	a2,a2,524 # 80201af8 <etext+0x4be>
    802008f4:	0d400593          	li	a1,212
    802008f8:	00001517          	auipc	a0,0x1
    802008fc:	21850513          	addi	a0,a0,536 # 80201b10 <etext+0x4d6>
    80200900:	ff8ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200904:	00001697          	auipc	a3,0x1
    80200908:	36c68693          	addi	a3,a3,876 # 80201c70 <etext+0x636>
    8020090c:	00001617          	auipc	a2,0x1
    80200910:	1ec60613          	addi	a2,a2,492 # 80201af8 <etext+0x4be>
    80200914:	0cf00593          	li	a1,207
    80200918:	00001517          	auipc	a0,0x1
    8020091c:	1f850513          	addi	a0,a0,504 # 80201b10 <etext+0x4d6>
    80200920:	fd8ff0ef          	jal	ra,802000f8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
    80200924:	00001697          	auipc	a3,0x1
    80200928:	32c68693          	addi	a3,a3,812 # 80201c50 <etext+0x616>
    8020092c:	00001617          	auipc	a2,0x1
    80200930:	1cc60613          	addi	a2,a2,460 # 80201af8 <etext+0x4be>
    80200934:	0c600593          	li	a1,198
    80200938:	00001517          	auipc	a0,0x1
    8020093c:	1d850513          	addi	a0,a0,472 # 80201b10 <etext+0x4d6>
    80200940:	fb8ff0ef          	jal	ra,802000f8 <__panic>
    assert(p0 != NULL);
    80200944:	00001697          	auipc	a3,0x1
    80200948:	39c68693          	addi	a3,a3,924 # 80201ce0 <etext+0x6a6>
    8020094c:	00001617          	auipc	a2,0x1
    80200950:	1ac60613          	addi	a2,a2,428 # 80201af8 <etext+0x4be>
    80200954:	12a00593          	li	a1,298
    80200958:	00001517          	auipc	a0,0x1
    8020095c:	1b850513          	addi	a0,a0,440 # 80201b10 <etext+0x4d6>
    80200960:	f98ff0ef          	jal	ra,802000f8 <__panic>
    assert(nr_free == 0);
    80200964:	00001697          	auipc	a3,0x1
    80200968:	36c68693          	addi	a3,a3,876 # 80201cd0 <etext+0x696>
    8020096c:	00001617          	auipc	a2,0x1
    80200970:	18c60613          	addi	a2,a2,396 # 80201af8 <etext+0x4be>
    80200974:	0e300593          	li	a1,227
    80200978:	00001517          	auipc	a0,0x1
    8020097c:	19850513          	addi	a0,a0,408 # 80201b10 <etext+0x4d6>
    80200980:	f78ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200984:	00001697          	auipc	a3,0x1
    80200988:	2ec68693          	addi	a3,a3,748 # 80201c70 <etext+0x636>
    8020098c:	00001617          	auipc	a2,0x1
    80200990:	16c60613          	addi	a2,a2,364 # 80201af8 <etext+0x4be>
    80200994:	0e100593          	li	a1,225
    80200998:	00001517          	auipc	a0,0x1
    8020099c:	17850513          	addi	a0,a0,376 # 80201b10 <etext+0x4d6>
    802009a0:	f58ff0ef          	jal	ra,802000f8 <__panic>
    assert((p = alloc_page()) == p0);
    802009a4:	00001697          	auipc	a3,0x1
    802009a8:	30c68693          	addi	a3,a3,780 # 80201cb0 <etext+0x676>
    802009ac:	00001617          	auipc	a2,0x1
    802009b0:	14c60613          	addi	a2,a2,332 # 80201af8 <etext+0x4be>
    802009b4:	0e000593          	li	a1,224
    802009b8:	00001517          	auipc	a0,0x1
    802009bc:	15850513          	addi	a0,a0,344 # 80201b10 <etext+0x4d6>
    802009c0:	f38ff0ef          	jal	ra,802000f8 <__panic>
    assert((p0 = alloc_page()) != NULL);
    802009c4:	00001697          	auipc	a3,0x1
    802009c8:	18468693          	addi	a3,a3,388 # 80201b48 <etext+0x50e>
    802009cc:	00001617          	auipc	a2,0x1
    802009d0:	12c60613          	addi	a2,a2,300 # 80201af8 <etext+0x4be>
    802009d4:	0bd00593          	li	a1,189
    802009d8:	00001517          	auipc	a0,0x1
    802009dc:	13850513          	addi	a0,a0,312 # 80201b10 <etext+0x4d6>
    802009e0:	f18ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_page() == NULL);
    802009e4:	00001697          	auipc	a3,0x1
    802009e8:	28c68693          	addi	a3,a3,652 # 80201c70 <etext+0x636>
    802009ec:	00001617          	auipc	a2,0x1
    802009f0:	10c60613          	addi	a2,a2,268 # 80201af8 <etext+0x4be>
    802009f4:	0da00593          	li	a1,218
    802009f8:	00001517          	auipc	a0,0x1
    802009fc:	11850513          	addi	a0,a0,280 # 80201b10 <etext+0x4d6>
    80200a00:	ef8ff0ef          	jal	ra,802000f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
    80200a04:	00001697          	auipc	a3,0x1
    80200a08:	18468693          	addi	a3,a3,388 # 80201b88 <etext+0x54e>
    80200a0c:	00001617          	auipc	a2,0x1
    80200a10:	0ec60613          	addi	a2,a2,236 # 80201af8 <etext+0x4be>
    80200a14:	0d800593          	li	a1,216
    80200a18:	00001517          	auipc	a0,0x1
    80200a1c:	0f850513          	addi	a0,a0,248 # 80201b10 <etext+0x4d6>
    80200a20:	ed8ff0ef          	jal	ra,802000f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
    80200a24:	00001697          	auipc	a3,0x1
    80200a28:	14468693          	addi	a3,a3,324 # 80201b68 <etext+0x52e>
    80200a2c:	00001617          	auipc	a2,0x1
    80200a30:	0cc60613          	addi	a2,a2,204 # 80201af8 <etext+0x4be>
    80200a34:	0d700593          	li	a1,215
    80200a38:	00001517          	auipc	a0,0x1
    80200a3c:	0d850513          	addi	a0,a0,216 # 80201b10 <etext+0x4d6>
    80200a40:	eb8ff0ef          	jal	ra,802000f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
    80200a44:	00001697          	auipc	a3,0x1
    80200a48:	14468693          	addi	a3,a3,324 # 80201b88 <etext+0x54e>
    80200a4c:	00001617          	auipc	a2,0x1
    80200a50:	0ac60613          	addi	a2,a2,172 # 80201af8 <etext+0x4be>
    80200a54:	0bf00593          	li	a1,191
    80200a58:	00001517          	auipc	a0,0x1
    80200a5c:	0b850513          	addi	a0,a0,184 # 80201b10 <etext+0x4d6>
    80200a60:	e98ff0ef          	jal	ra,802000f8 <__panic>
    assert(count == 0);
    80200a64:	00001697          	auipc	a3,0x1
    80200a68:	3cc68693          	addi	a3,a3,972 # 80201e30 <etext+0x7f6>
    80200a6c:	00001617          	auipc	a2,0x1
    80200a70:	08c60613          	addi	a2,a2,140 # 80201af8 <etext+0x4be>
    80200a74:	15700593          	li	a1,343
    80200a78:	00001517          	auipc	a0,0x1
    80200a7c:	09850513          	addi	a0,a0,152 # 80201b10 <etext+0x4d6>
    80200a80:	e78ff0ef          	jal	ra,802000f8 <__panic>
    assert(nr_free == 0);
    80200a84:	00001697          	auipc	a3,0x1
    80200a88:	24c68693          	addi	a3,a3,588 # 80201cd0 <etext+0x696>
    80200a8c:	00001617          	auipc	a2,0x1
    80200a90:	06c60613          	addi	a2,a2,108 # 80201af8 <etext+0x4be>
    80200a94:	14c00593          	li	a1,332
    80200a98:	00001517          	auipc	a0,0x1
    80200a9c:	07850513          	addi	a0,a0,120 # 80201b10 <etext+0x4d6>
    80200aa0:	e58ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200aa4:	00001697          	auipc	a3,0x1
    80200aa8:	1cc68693          	addi	a3,a3,460 # 80201c70 <etext+0x636>
    80200aac:	00001617          	auipc	a2,0x1
    80200ab0:	04c60613          	addi	a2,a2,76 # 80201af8 <etext+0x4be>
    80200ab4:	14a00593          	li	a1,330
    80200ab8:	00001517          	auipc	a0,0x1
    80200abc:	05850513          	addi	a0,a0,88 # 80201b10 <etext+0x4d6>
    80200ac0:	e38ff0ef          	jal	ra,802000f8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
    80200ac4:	00001697          	auipc	a3,0x1
    80200ac8:	16c68693          	addi	a3,a3,364 # 80201c30 <etext+0x5f6>
    80200acc:	00001617          	auipc	a2,0x1
    80200ad0:	02c60613          	addi	a2,a2,44 # 80201af8 <etext+0x4be>
    80200ad4:	0c500593          	li	a1,197
    80200ad8:	00001517          	auipc	a0,0x1
    80200adc:	03850513          	addi	a0,a0,56 # 80201b10 <etext+0x4d6>
    80200ae0:	e18ff0ef          	jal	ra,802000f8 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
    80200ae4:	00001697          	auipc	a3,0x1
    80200ae8:	30c68693          	addi	a3,a3,780 # 80201df0 <etext+0x7b6>
    80200aec:	00001617          	auipc	a2,0x1
    80200af0:	00c60613          	addi	a2,a2,12 # 80201af8 <etext+0x4be>
    80200af4:	14400593          	li	a1,324
    80200af8:	00001517          	auipc	a0,0x1
    80200afc:	01850513          	addi	a0,a0,24 # 80201b10 <etext+0x4d6>
    80200b00:	df8ff0ef          	jal	ra,802000f8 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
    80200b04:	00001697          	auipc	a3,0x1
    80200b08:	2cc68693          	addi	a3,a3,716 # 80201dd0 <etext+0x796>
    80200b0c:	00001617          	auipc	a2,0x1
    80200b10:	fec60613          	addi	a2,a2,-20 # 80201af8 <etext+0x4be>
    80200b14:	14200593          	li	a1,322
    80200b18:	00001517          	auipc	a0,0x1
    80200b1c:	ff850513          	addi	a0,a0,-8 # 80201b10 <etext+0x4d6>
    80200b20:	dd8ff0ef          	jal	ra,802000f8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
    80200b24:	00001697          	auipc	a3,0x1
    80200b28:	28468693          	addi	a3,a3,644 # 80201da8 <etext+0x76e>
    80200b2c:	00001617          	auipc	a2,0x1
    80200b30:	fcc60613          	addi	a2,a2,-52 # 80201af8 <etext+0x4be>
    80200b34:	14000593          	li	a1,320
    80200b38:	00001517          	auipc	a0,0x1
    80200b3c:	fd850513          	addi	a0,a0,-40 # 80201b10 <etext+0x4d6>
    80200b40:	db8ff0ef          	jal	ra,802000f8 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
    80200b44:	00001697          	auipc	a3,0x1
    80200b48:	23c68693          	addi	a3,a3,572 # 80201d80 <etext+0x746>
    80200b4c:	00001617          	auipc	a2,0x1
    80200b50:	fac60613          	addi	a2,a2,-84 # 80201af8 <etext+0x4be>
    80200b54:	13f00593          	li	a1,319
    80200b58:	00001517          	auipc	a0,0x1
    80200b5c:	fb850513          	addi	a0,a0,-72 # 80201b10 <etext+0x4d6>
    80200b60:	d98ff0ef          	jal	ra,802000f8 <__panic>
    assert(p0 + 2 == p1);
    80200b64:	00001697          	auipc	a3,0x1
    80200b68:	20c68693          	addi	a3,a3,524 # 80201d70 <etext+0x736>
    80200b6c:	00001617          	auipc	a2,0x1
    80200b70:	f8c60613          	addi	a2,a2,-116 # 80201af8 <etext+0x4be>
    80200b74:	13a00593          	li	a1,314
    80200b78:	00001517          	auipc	a0,0x1
    80200b7c:	f9850513          	addi	a0,a0,-104 # 80201b10 <etext+0x4d6>
    80200b80:	d78ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200b84:	00001697          	auipc	a3,0x1
    80200b88:	0ec68693          	addi	a3,a3,236 # 80201c70 <etext+0x636>
    80200b8c:	00001617          	auipc	a2,0x1
    80200b90:	f6c60613          	addi	a2,a2,-148 # 80201af8 <etext+0x4be>
    80200b94:	13900593          	li	a1,313
    80200b98:	00001517          	auipc	a0,0x1
    80200b9c:	f7850513          	addi	a0,a0,-136 # 80201b10 <etext+0x4d6>
    80200ba0:	d58ff0ef          	jal	ra,802000f8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
    80200ba4:	00001697          	auipc	a3,0x1
    80200ba8:	1ac68693          	addi	a3,a3,428 # 80201d50 <etext+0x716>
    80200bac:	00001617          	auipc	a2,0x1
    80200bb0:	f4c60613          	addi	a2,a2,-180 # 80201af8 <etext+0x4be>
    80200bb4:	13800593          	li	a1,312
    80200bb8:	00001517          	auipc	a0,0x1
    80200bbc:	f5850513          	addi	a0,a0,-168 # 80201b10 <etext+0x4d6>
    80200bc0:	d38ff0ef          	jal	ra,802000f8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    80200bc4:	00001697          	auipc	a3,0x1
    80200bc8:	15c68693          	addi	a3,a3,348 # 80201d20 <etext+0x6e6>
    80200bcc:	00001617          	auipc	a2,0x1
    80200bd0:	f2c60613          	addi	a2,a2,-212 # 80201af8 <etext+0x4be>
    80200bd4:	13700593          	li	a1,311
    80200bd8:	00001517          	auipc	a0,0x1
    80200bdc:	f3850513          	addi	a0,a0,-200 # 80201b10 <etext+0x4d6>
    80200be0:	d18ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_pages(4) == NULL);
    80200be4:	00001697          	auipc	a3,0x1
    80200be8:	12468693          	addi	a3,a3,292 # 80201d08 <etext+0x6ce>
    80200bec:	00001617          	auipc	a2,0x1
    80200bf0:	f0c60613          	addi	a2,a2,-244 # 80201af8 <etext+0x4be>
    80200bf4:	13600593          	li	a1,310
    80200bf8:	00001517          	auipc	a0,0x1
    80200bfc:	f1850513          	addi	a0,a0,-232 # 80201b10 <etext+0x4d6>
    80200c00:	cf8ff0ef          	jal	ra,802000f8 <__panic>
    assert(alloc_page() == NULL);
    80200c04:	00001697          	auipc	a3,0x1
    80200c08:	06c68693          	addi	a3,a3,108 # 80201c70 <etext+0x636>
    80200c0c:	00001617          	auipc	a2,0x1
    80200c10:	eec60613          	addi	a2,a2,-276 # 80201af8 <etext+0x4be>
    80200c14:	13000593          	li	a1,304
    80200c18:	00001517          	auipc	a0,0x1
    80200c1c:	ef850513          	addi	a0,a0,-264 # 80201b10 <etext+0x4d6>
    80200c20:	cd8ff0ef          	jal	ra,802000f8 <__panic>
    assert(!PageProperty(p0));
    80200c24:	00001697          	auipc	a3,0x1
    80200c28:	0cc68693          	addi	a3,a3,204 # 80201cf0 <etext+0x6b6>
    80200c2c:	00001617          	auipc	a2,0x1
    80200c30:	ecc60613          	addi	a2,a2,-308 # 80201af8 <etext+0x4be>
    80200c34:	12b00593          	li	a1,299
    80200c38:	00001517          	auipc	a0,0x1
    80200c3c:	ed850513          	addi	a0,a0,-296 # 80201b10 <etext+0x4d6>
    80200c40:	cb8ff0ef          	jal	ra,802000f8 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
    80200c44:	00001697          	auipc	a3,0x1
    80200c48:	1cc68693          	addi	a3,a3,460 # 80201e10 <etext+0x7d6>
    80200c4c:	00001617          	auipc	a2,0x1
    80200c50:	eac60613          	addi	a2,a2,-340 # 80201af8 <etext+0x4be>
    80200c54:	14900593          	li	a1,329
    80200c58:	00001517          	auipc	a0,0x1
    80200c5c:	eb850513          	addi	a0,a0,-328 # 80201b10 <etext+0x4d6>
    80200c60:	c98ff0ef          	jal	ra,802000f8 <__panic>
    assert(total == 0);
    80200c64:	00001697          	auipc	a3,0x1
    80200c68:	1dc68693          	addi	a3,a3,476 # 80201e40 <etext+0x806>
    80200c6c:	00001617          	auipc	a2,0x1
    80200c70:	e8c60613          	addi	a2,a2,-372 # 80201af8 <etext+0x4be>
    80200c74:	15800593          	li	a1,344
    80200c78:	00001517          	auipc	a0,0x1
    80200c7c:	e9850513          	addi	a0,a0,-360 # 80201b10 <etext+0x4d6>
    80200c80:	c78ff0ef          	jal	ra,802000f8 <__panic>
    assert(total == nr_free_pages());
    80200c84:	00001697          	auipc	a3,0x1
    80200c88:	ea468693          	addi	a3,a3,-348 # 80201b28 <etext+0x4ee>
    80200c8c:	00001617          	auipc	a2,0x1
    80200c90:	e6c60613          	addi	a2,a2,-404 # 80201af8 <etext+0x4be>
    80200c94:	12500593          	li	a1,293
    80200c98:	00001517          	auipc	a0,0x1
    80200c9c:	e7850513          	addi	a0,a0,-392 # 80201b10 <etext+0x4d6>
    80200ca0:	c58ff0ef          	jal	ra,802000f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
    80200ca4:	00001697          	auipc	a3,0x1
    80200ca8:	ec468693          	addi	a3,a3,-316 # 80201b68 <etext+0x52e>
    80200cac:	00001617          	auipc	a2,0x1
    80200cb0:	e4c60613          	addi	a2,a2,-436 # 80201af8 <etext+0x4be>
    80200cb4:	0be00593          	li	a1,190
    80200cb8:	00001517          	auipc	a0,0x1
    80200cbc:	e5850513          	addi	a0,a0,-424 # 80201b10 <etext+0x4d6>
    80200cc0:	c38ff0ef          	jal	ra,802000f8 <__panic>

0000000080200cc4 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
    80200cc4:	1141                	addi	sp,sp,-16
    80200cc6:	e406                	sd	ra,8(sp)
    assert(n > 0);
    80200cc8:	14058563          	beqz	a1,80200e12 <default_free_pages+0x14e>
    for (; p != base + n; p ++) {
    80200ccc:	00259693          	slli	a3,a1,0x2
    80200cd0:	96ae                	add	a3,a3,a1
    80200cd2:	068e                	slli	a3,a3,0x3
    80200cd4:	96aa                	add	a3,a3,a0
    80200cd6:	87aa                	mv	a5,a0
    80200cd8:	02d50263          	beq	a0,a3,80200cfc <default_free_pages+0x38>
    80200cdc:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
    80200cde:	8b05                	andi	a4,a4,1
    80200ce0:	10071963          	bnez	a4,80200df2 <default_free_pages+0x12e>
    80200ce4:	6798                	ld	a4,8(a5)
    80200ce6:	8b09                	andi	a4,a4,2
    80200ce8:	10071563          	bnez	a4,80200df2 <default_free_pages+0x12e>
        p->flags = 0;
    80200cec:	0007b423          	sd	zero,8(a5)
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
    80200cf0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
    80200cf4:	02878793          	addi	a5,a5,40
    80200cf8:	fed792e3          	bne	a5,a3,80200cdc <default_free_pages+0x18>
    base->property = n;
    80200cfc:	2581                	sext.w	a1,a1
    80200cfe:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
    80200d00:	4789                	li	a5,2
    80200d02:	00850713          	addi	a4,a0,8
    80200d06:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
    80200d0a:	00004617          	auipc	a2,0x4
    80200d0e:	2fe60613          	addi	a2,a2,766 # 80205008 <free_area>
    80200d12:	4a18                	lw	a4,16(a2)
    return list->next == list;
    80200d14:	661c                	ld	a5,8(a2)
    80200d16:	9db9                	addw	a1,a1,a4
    80200d18:	ca0c                	sw	a1,16(a2)
    if (list_empty(&free_list)) {
    80200d1a:	00c79763          	bne	a5,a2,80200d28 <default_free_pages+0x64>
    80200d1e:	a075                	j	80200dca <default_free_pages+0x106>
    return listelm->next;
    80200d20:	6794                	ld	a3,8(a5)
            } else if (list_next(le) == &free_list) {
    80200d22:	0ac68d63          	beq	a3,a2,80200ddc <default_free_pages+0x118>
    80200d26:	87b6                	mv	a5,a3
            struct Page* page = le2page(le, page_link);
    80200d28:	fe878713          	addi	a4,a5,-24
            if (base < page) {
    80200d2c:	fee57ae3          	bgeu	a0,a4,80200d20 <default_free_pages+0x5c>
        if(next - base == base->property){
    80200d30:	40a706b3          	sub	a3,a4,a0
    80200d34:	868d                	srai	a3,a3,0x3
    80200d36:	00001897          	auipc	a7,0x1
    80200d3a:	4ea8b883          	ld	a7,1258(a7) # 80202220 <error_string+0x38>
    80200d3e:	031686b3          	mul	a3,a3,a7
    __list_add(elm, listelm->prev, listelm);
    80200d42:	0007b803          	ld	a6,0(a5)
    80200d46:	4918                	lw	a4,16(a0)
                list_add_before(le, &(base->page_link));
    80200d48:	01850593          	addi	a1,a0,24
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
    80200d4c:	e38c                	sd	a1,0(a5)
    80200d4e:	00b83423          	sd	a1,8(a6)
        if(next - base == base->property){
    80200d52:	02071593          	slli	a1,a4,0x20
    elm->next = next;
    80200d56:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200d58:	01053c23          	sd	a6,24(a0)
    80200d5c:	9181                	srli	a1,a1,0x20
    80200d5e:	04b68563          	beq	a3,a1,80200da8 <default_free_pages+0xe4>
    return listelm->prev;
    80200d62:	87c2                	mv	a5,a6
    if (next_entry!=&free_list){
    80200d64:	02c78f63          	beq	a5,a2,80200da2 <default_free_pages+0xde>
    80200d68:	fe878713          	addi	a4,a5,-24
        if(base - next == next->property){
    80200d6c:	40e50733          	sub	a4,a0,a4
    80200d70:	870d                	srai	a4,a4,0x3
    80200d72:	03170733          	mul	a4,a4,a7
    80200d76:	ff87a683          	lw	a3,-8(a5)
    80200d7a:	02069613          	slli	a2,a3,0x20
    80200d7e:	9201                	srli	a2,a2,0x20
    80200d80:	02c71163          	bne	a4,a2,80200da2 <default_free_pages+0xde>
            next->property += base->property;
    80200d84:	4918                	lw	a4,16(a0)
    80200d86:	9eb9                	addw	a3,a3,a4
    80200d88:	fed7ac23          	sw	a3,-8(a5)
            base->property = 0;
    80200d8c:	00052823          	sw	zero,16(a0)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
    80200d90:	57f5                	li	a5,-3
    80200d92:	00850713          	addi	a4,a0,8
    80200d96:	60f7302f          	amoand.d	zero,a5,(a4)
    __list_del(listelm->prev, listelm->next);
    80200d9a:	6d18                	ld	a4,24(a0)
    80200d9c:	711c                	ld	a5,32(a0)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
    80200d9e:	e71c                	sd	a5,8(a4)
    next->prev = prev;
    80200da0:	e398                	sd	a4,0(a5)
}
    80200da2:	60a2                	ld	ra,8(sp)
    80200da4:	0141                	addi	sp,sp,16
    80200da6:	8082                	ret
            base->property += next->property;
    80200da8:	ff87a683          	lw	a3,-8(a5)
    80200dac:	9f35                	addw	a4,a4,a3
    80200dae:	c918                	sw	a4,16(a0)
            next->property = 0;
    80200db0:	fe07ac23          	sw	zero,-8(a5)
    80200db4:	5775                	li	a4,-3
    80200db6:	ff078693          	addi	a3,a5,-16
    80200dba:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
    80200dbe:	6398                	ld	a4,0(a5)
    80200dc0:	679c                	ld	a5,8(a5)
    prev->next = next;
    80200dc2:	e71c                	sd	a5,8(a4)
    next->prev = prev;
    80200dc4:	e398                	sd	a4,0(a5)
    return listelm->prev;
    80200dc6:	6d1c                	ld	a5,24(a0)
}
    80200dc8:	bf71                	j	80200d64 <default_free_pages+0xa0>
}
    80200dca:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
    80200dcc:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
    80200dd0:	e398                	sd	a4,0(a5)
    80200dd2:	e798                	sd	a4,8(a5)
    elm->next = next;
    80200dd4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200dd6:	ed1c                	sd	a5,24(a0)
}
    80200dd8:	0141                	addi	sp,sp,16
    80200dda:	8082                	ret
                list_add(le, &(base->page_link));
    80200ddc:	01850693          	addi	a3,a0,24
    prev->next = next->prev = elm;
    80200de0:	e794                	sd	a3,8(a5)
    80200de2:	e214                	sd	a3,0(a2)
    elm->next = next;
    80200de4:	f110                	sd	a2,32(a0)
    elm->prev = prev;
    80200de6:	ed1c                	sd	a5,24(a0)
    if (next_entry!=&free_list){
    80200de8:	00001897          	auipc	a7,0x1
    80200dec:	4388b883          	ld	a7,1080(a7) # 80202220 <error_string+0x38>
    80200df0:	bfb5                	j	80200d6c <default_free_pages+0xa8>
        assert(!PageReserved(p) && !PageProperty(p));
    80200df2:	00001697          	auipc	a3,0x1
    80200df6:	06668693          	addi	a3,a3,102 # 80201e58 <etext+0x81e>
    80200dfa:	00001617          	auipc	a2,0x1
    80200dfe:	cfe60613          	addi	a2,a2,-770 # 80201af8 <etext+0x4be>
    80200e02:	08300593          	li	a1,131
    80200e06:	00001517          	auipc	a0,0x1
    80200e0a:	d0a50513          	addi	a0,a0,-758 # 80201b10 <etext+0x4d6>
    80200e0e:	aeaff0ef          	jal	ra,802000f8 <__panic>
    assert(n > 0);
    80200e12:	00001697          	auipc	a3,0x1
    80200e16:	03e68693          	addi	a3,a3,62 # 80201e50 <etext+0x816>
    80200e1a:	00001617          	auipc	a2,0x1
    80200e1e:	cde60613          	addi	a2,a2,-802 # 80201af8 <etext+0x4be>
    80200e22:	08000593          	li	a1,128
    80200e26:	00001517          	auipc	a0,0x1
    80200e2a:	cea50513          	addi	a0,a0,-790 # 80201b10 <etext+0x4d6>
    80200e2e:	acaff0ef          	jal	ra,802000f8 <__panic>

0000000080200e32 <default_alloc_pages>:
    assert(n > 0);
    80200e32:	c959                	beqz	a0,80200ec8 <default_alloc_pages+0x96>
    if (n > nr_free) {
    80200e34:	00004597          	auipc	a1,0x4
    80200e38:	1d458593          	addi	a1,a1,468 # 80205008 <free_area>
    80200e3c:	0105a803          	lw	a6,16(a1)
    80200e40:	862a                	mv	a2,a0
    80200e42:	02081793          	slli	a5,a6,0x20
    80200e46:	9381                	srli	a5,a5,0x20
    80200e48:	00a7ee63          	bltu	a5,a0,80200e64 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
    80200e4c:	87ae                	mv	a5,a1
    80200e4e:	a801                	j	80200e5e <default_alloc_pages+0x2c>
        if (p->property >= n) {
    80200e50:	ff87a703          	lw	a4,-8(a5)
    80200e54:	02071693          	slli	a3,a4,0x20
    80200e58:	9281                	srli	a3,a3,0x20
    80200e5a:	00c6f763          	bgeu	a3,a2,80200e68 <default_alloc_pages+0x36>
    return listelm->next;
    80200e5e:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
    80200e60:	feb798e3          	bne	a5,a1,80200e50 <default_alloc_pages+0x1e>
        return NULL;
    80200e64:	4501                	li	a0,0
}
    80200e66:	8082                	ret
    return listelm->prev;
    80200e68:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
    80200e6c:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
    80200e70:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
    80200e74:	00060e1b          	sext.w	t3,a2
    prev->next = next;
    80200e78:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
    80200e7c:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
    80200e80:	02d67b63          	bgeu	a2,a3,80200eb6 <default_alloc_pages+0x84>
            struct Page *p = page + n;
    80200e84:	00261693          	slli	a3,a2,0x2
    80200e88:	96b2                	add	a3,a3,a2
    80200e8a:	068e                	slli	a3,a3,0x3
    80200e8c:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
    80200e8e:	41c7073b          	subw	a4,a4,t3
    80200e92:	ca98                	sw	a4,16(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
    80200e94:	00868613          	addi	a2,a3,8
    80200e98:	4709                	li	a4,2
    80200e9a:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
    80200e9e:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
    80200ea2:	01868613          	addi	a2,a3,24
        nr_free -= n;
    80200ea6:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
    80200eaa:	e310                	sd	a2,0(a4)
    80200eac:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
    80200eb0:	f298                	sd	a4,32(a3)
    elm->prev = prev;
    80200eb2:	0116bc23          	sd	a7,24(a3)
    80200eb6:	41c8083b          	subw	a6,a6,t3
    80200eba:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
    80200ebe:	5775                	li	a4,-3
    80200ec0:	17c1                	addi	a5,a5,-16
    80200ec2:	60e7b02f          	amoand.d	zero,a4,(a5)
}
    80200ec6:	8082                	ret
default_alloc_pages(size_t n) {
    80200ec8:	1141                	addi	sp,sp,-16
    assert(n > 0);
    80200eca:	00001697          	auipc	a3,0x1
    80200ece:	f8668693          	addi	a3,a3,-122 # 80201e50 <etext+0x816>
    80200ed2:	00001617          	auipc	a2,0x1
    80200ed6:	c2660613          	addi	a2,a2,-986 # 80201af8 <etext+0x4be>
    80200eda:	06200593          	li	a1,98
    80200ede:	00001517          	auipc	a0,0x1
    80200ee2:	c3250513          	addi	a0,a0,-974 # 80201b10 <etext+0x4d6>
default_alloc_pages(size_t n) {
    80200ee6:	e406                	sd	ra,8(sp)
    assert(n > 0);
    80200ee8:	a10ff0ef          	jal	ra,802000f8 <__panic>

0000000080200eec <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
    80200eec:	1141                	addi	sp,sp,-16
    80200eee:	e406                	sd	ra,8(sp)
    assert(n > 0);
    80200ef0:	c9e1                	beqz	a1,80200fc0 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
    80200ef2:	00259693          	slli	a3,a1,0x2
    80200ef6:	96ae                	add	a3,a3,a1
    80200ef8:	068e                	slli	a3,a3,0x3
    80200efa:	96aa                	add	a3,a3,a0
    80200efc:	87aa                	mv	a5,a0
    80200efe:	00d50f63          	beq	a0,a3,80200f1c <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
    80200f02:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
    80200f04:	8b05                	andi	a4,a4,1
    80200f06:	cf49                	beqz	a4,80200fa0 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
    80200f08:	0007a823          	sw	zero,16(a5)
    80200f0c:	0007b423          	sd	zero,8(a5)
    80200f10:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
    80200f14:	02878793          	addi	a5,a5,40
    80200f18:	fed795e3          	bne	a5,a3,80200f02 <default_init_memmap+0x16>
    base->property = n;
    80200f1c:	2581                	sext.w	a1,a1
    80200f1e:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
    80200f20:	4789                	li	a5,2
    80200f22:	00850713          	addi	a4,a0,8
    80200f26:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
    80200f2a:	00004697          	auipc	a3,0x4
    80200f2e:	0de68693          	addi	a3,a3,222 # 80205008 <free_area>
    80200f32:	4a98                	lw	a4,16(a3)
    return list->next == list;
    80200f34:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
    80200f36:	01850613          	addi	a2,a0,24
    nr_free += n;
    80200f3a:	9db9                	addw	a1,a1,a4
    80200f3c:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
    80200f3e:	04d78a63          	beq	a5,a3,80200f92 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
    80200f42:	fe878713          	addi	a4,a5,-24
    80200f46:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
    80200f4a:	4581                	li	a1,0
            if (base < page) {
    80200f4c:	00e56a63          	bltu	a0,a4,80200f60 <default_init_memmap+0x74>
    return listelm->next;
    80200f50:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
    80200f52:	02d70263          	beq	a4,a3,80200f76 <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
    80200f56:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
    80200f58:	fe878713          	addi	a4,a5,-24
            if (base < page) {
    80200f5c:	fee57ae3          	bgeu	a0,a4,80200f50 <default_init_memmap+0x64>
    80200f60:	c199                	beqz	a1,80200f66 <default_init_memmap+0x7a>
    80200f62:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
    80200f66:	6398                	ld	a4,0(a5)
}
    80200f68:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
    80200f6a:	e390                	sd	a2,0(a5)
    80200f6c:	e710                	sd	a2,8(a4)
    elm->next = next;
    80200f6e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200f70:	ed18                	sd	a4,24(a0)
    80200f72:	0141                	addi	sp,sp,16
    80200f74:	8082                	ret
    prev->next = next->prev = elm;
    80200f76:	e790                	sd	a2,8(a5)
    elm->next = next;
    80200f78:	f114                	sd	a3,32(a0)
    return listelm->next;
    80200f7a:	6798                	ld	a4,8(a5)
    elm->prev = prev;
    80200f7c:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
    80200f7e:	00d70663          	beq	a4,a3,80200f8a <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
    80200f82:	8832                	mv	a6,a2
    80200f84:	4585                	li	a1,1
    for (; p != base + n; p ++) {
    80200f86:	87ba                	mv	a5,a4
    80200f88:	bfc1                	j	80200f58 <default_init_memmap+0x6c>
}
    80200f8a:	60a2                	ld	ra,8(sp)
    80200f8c:	e290                	sd	a2,0(a3)
    80200f8e:	0141                	addi	sp,sp,16
    80200f90:	8082                	ret
    80200f92:	60a2                	ld	ra,8(sp)
    80200f94:	e390                	sd	a2,0(a5)
    80200f96:	e790                	sd	a2,8(a5)
    elm->next = next;
    80200f98:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
    80200f9a:	ed1c                	sd	a5,24(a0)
    80200f9c:	0141                	addi	sp,sp,16
    80200f9e:	8082                	ret
        assert(PageReserved(p));
    80200fa0:	00001697          	auipc	a3,0x1
    80200fa4:	ee068693          	addi	a3,a3,-288 # 80201e80 <etext+0x846>
    80200fa8:	00001617          	auipc	a2,0x1
    80200fac:	b5060613          	addi	a2,a2,-1200 # 80201af8 <etext+0x4be>
    80200fb0:	04900593          	li	a1,73
    80200fb4:	00001517          	auipc	a0,0x1
    80200fb8:	b5c50513          	addi	a0,a0,-1188 # 80201b10 <etext+0x4d6>
    80200fbc:	93cff0ef          	jal	ra,802000f8 <__panic>
    assert(n > 0);
    80200fc0:	00001697          	auipc	a3,0x1
    80200fc4:	e9068693          	addi	a3,a3,-368 # 80201e50 <etext+0x816>
    80200fc8:	00001617          	auipc	a2,0x1
    80200fcc:	b3060613          	addi	a2,a2,-1232 # 80201af8 <etext+0x4be>
    80200fd0:	04600593          	li	a1,70
    80200fd4:	00001517          	auipc	a0,0x1
    80200fd8:	b3c50513          	addi	a0,a0,-1220 # 80201b10 <etext+0x4d6>
    80200fdc:	91cff0ef          	jal	ra,802000f8 <__panic>

0000000080200fe0 <alloc_pages>:
    80200fe0:	100027f3          	csrr	a5,sstatus
    80200fe4:	8b89                	andi	a5,a5,2
    80200fe6:	e799                	bnez	a5,80200ff4 <alloc_pages+0x14>
    80200fe8:	00004797          	auipc	a5,0x4
    80200fec:	0587b783          	ld	a5,88(a5) # 80205040 <pmm_manager>
    80200ff0:	6f9c                	ld	a5,24(a5)
    80200ff2:	8782                	jr	a5
    80200ff4:	1141                	addi	sp,sp,-16
    80200ff6:	e406                	sd	ra,8(sp)
    80200ff8:	e022                	sd	s0,0(sp)
    80200ffa:	842a                	mv	s0,a0
    80200ffc:	972ff0ef          	jal	ra,8020016e <intr_disable>
    80201000:	00004797          	auipc	a5,0x4
    80201004:	0407b783          	ld	a5,64(a5) # 80205040 <pmm_manager>
    80201008:	6f9c                	ld	a5,24(a5)
    8020100a:	8522                	mv	a0,s0
    8020100c:	9782                	jalr	a5
    8020100e:	842a                	mv	s0,a0
    80201010:	958ff0ef          	jal	ra,80200168 <intr_enable>
    80201014:	60a2                	ld	ra,8(sp)
    80201016:	8522                	mv	a0,s0
    80201018:	6402                	ld	s0,0(sp)
    8020101a:	0141                	addi	sp,sp,16
    8020101c:	8082                	ret

000000008020101e <free_pages>:
    8020101e:	100027f3          	csrr	a5,sstatus
    80201022:	8b89                	andi	a5,a5,2
    80201024:	e799                	bnez	a5,80201032 <free_pages+0x14>
    80201026:	00004797          	auipc	a5,0x4
    8020102a:	01a7b783          	ld	a5,26(a5) # 80205040 <pmm_manager>
    8020102e:	739c                	ld	a5,32(a5)
    80201030:	8782                	jr	a5
    80201032:	1101                	addi	sp,sp,-32
    80201034:	ec06                	sd	ra,24(sp)
    80201036:	e822                	sd	s0,16(sp)
    80201038:	e426                	sd	s1,8(sp)
    8020103a:	842a                	mv	s0,a0
    8020103c:	84ae                	mv	s1,a1
    8020103e:	930ff0ef          	jal	ra,8020016e <intr_disable>
    80201042:	00004797          	auipc	a5,0x4
    80201046:	ffe7b783          	ld	a5,-2(a5) # 80205040 <pmm_manager>
    8020104a:	739c                	ld	a5,32(a5)
    8020104c:	85a6                	mv	a1,s1
    8020104e:	8522                	mv	a0,s0
    80201050:	9782                	jalr	a5
    80201052:	6442                	ld	s0,16(sp)
    80201054:	60e2                	ld	ra,24(sp)
    80201056:	64a2                	ld	s1,8(sp)
    80201058:	6105                	addi	sp,sp,32
    8020105a:	90eff06f          	j	80200168 <intr_enable>

000000008020105e <nr_free_pages>:
    8020105e:	100027f3          	csrr	a5,sstatus
    80201062:	8b89                	andi	a5,a5,2
    80201064:	e799                	bnez	a5,80201072 <nr_free_pages+0x14>
    80201066:	00004797          	auipc	a5,0x4
    8020106a:	fda7b783          	ld	a5,-38(a5) # 80205040 <pmm_manager>
    8020106e:	779c                	ld	a5,40(a5)
    80201070:	8782                	jr	a5
    80201072:	1141                	addi	sp,sp,-16
    80201074:	e406                	sd	ra,8(sp)
    80201076:	e022                	sd	s0,0(sp)
    80201078:	8f6ff0ef          	jal	ra,8020016e <intr_disable>
    8020107c:	00004797          	auipc	a5,0x4
    80201080:	fc47b783          	ld	a5,-60(a5) # 80205040 <pmm_manager>
    80201084:	779c                	ld	a5,40(a5)
    80201086:	9782                	jalr	a5
    80201088:	842a                	mv	s0,a0
    8020108a:	8deff0ef          	jal	ra,80200168 <intr_enable>
    8020108e:	60a2                	ld	ra,8(sp)
    80201090:	8522                	mv	a0,s0
    80201092:	6402                	ld	s0,0(sp)
    80201094:	0141                	addi	sp,sp,16
    80201096:	8082                	ret

0000000080201098 <pmm_init>:
    80201098:	00001797          	auipc	a5,0x1
    8020109c:	e1078793          	addi	a5,a5,-496 # 80201ea8 <default_pmm_manager>
    802010a0:	638c                	ld	a1,0(a5)
    802010a2:	1141                	addi	sp,sp,-16
    802010a4:	e022                	sd	s0,0(sp)
    802010a6:	00001517          	auipc	a0,0x1
    802010aa:	e3a50513          	addi	a0,a0,-454 # 80201ee0 <default_pmm_manager+0x38>
    802010ae:	00004417          	auipc	s0,0x4
    802010b2:	f9240413          	addi	s0,s0,-110 # 80205040 <pmm_manager>
    802010b6:	e406                	sd	ra,8(sp)
    802010b8:	e01c                	sd	a5,0(s0)
    802010ba:	fc9fe0ef          	jal	ra,80200082 <cprintf>
    802010be:	601c                	ld	a5,0(s0)
    802010c0:	679c                	ld	a5,8(a5)
    802010c2:	9782                	jalr	a5
    802010c4:	00001517          	auipc	a0,0x1
    802010c8:	e3450513          	addi	a0,a0,-460 # 80201ef8 <default_pmm_manager+0x50>
    802010cc:	00004797          	auipc	a5,0x4
    802010d0:	f607be23          	sd	zero,-132(a5) # 80205048 <va_pa_offset>
    802010d4:	faffe0ef          	jal	ra,80200082 <cprintf>
    802010d8:	46c5                	li	a3,17
    802010da:	06ee                	slli	a3,a3,0x1b
    802010dc:	40100613          	li	a2,1025
    802010e0:	16fd                	addi	a3,a3,-1
    802010e2:	07e005b7          	lui	a1,0x7e00
    802010e6:	0656                	slli	a2,a2,0x15
    802010e8:	00001517          	auipc	a0,0x1
    802010ec:	e2850513          	addi	a0,a0,-472 # 80201f10 <default_pmm_manager+0x68>
    802010f0:	f93fe0ef          	jal	ra,80200082 <cprintf>
    802010f4:	777d                	lui	a4,0xfffff
    802010f6:	00005797          	auipc	a5,0x5
    802010fa:	f6178793          	addi	a5,a5,-159 # 80206057 <end+0xfff>
    802010fe:	8ff9                	and	a5,a5,a4
    80201100:	00004517          	auipc	a0,0x4
    80201104:	f3050513          	addi	a0,a0,-208 # 80205030 <npage>
    80201108:	00088737          	lui	a4,0x88
    8020110c:	00004597          	auipc	a1,0x4
    80201110:	f2c58593          	addi	a1,a1,-212 # 80205038 <pages>
    80201114:	e118                	sd	a4,0(a0)
    80201116:	e19c                	sd	a5,0(a1)
    80201118:	4681                	li	a3,0
    8020111a:	4701                	li	a4,0
    8020111c:	4885                	li	a7,1
    8020111e:	fff80837          	lui	a6,0xfff80
    80201122:	a011                	j	80201126 <pmm_init+0x8e>
    80201124:	619c                	ld	a5,0(a1)
    80201126:	97b6                	add	a5,a5,a3
    80201128:	07a1                	addi	a5,a5,8
    8020112a:	4117b02f          	amoor.d	zero,a7,(a5)
    8020112e:	611c                	ld	a5,0(a0)
    80201130:	0705                	addi	a4,a4,1
    80201132:	02868693          	addi	a3,a3,40
    80201136:	01078633          	add	a2,a5,a6
    8020113a:	fec765e3          	bltu	a4,a2,80201124 <pmm_init+0x8c>
    8020113e:	6190                	ld	a2,0(a1)
    80201140:	00279693          	slli	a3,a5,0x2
    80201144:	96be                	add	a3,a3,a5
    80201146:	fec00737          	lui	a4,0xfec00
    8020114a:	9732                	add	a4,a4,a2
    8020114c:	068e                	slli	a3,a3,0x3
    8020114e:	96ba                	add	a3,a3,a4
    80201150:	40100713          	li	a4,1025
    80201154:	0756                	slli	a4,a4,0x15
    80201156:	06e6ee63          	bltu	a3,a4,802011d2 <pmm_init+0x13a>
    8020115a:	00004717          	auipc	a4,0x4
    8020115e:	eee73703          	ld	a4,-274(a4) # 80205048 <va_pa_offset>
    80201162:	45c5                	li	a1,17
    80201164:	8e99                	sub	a3,a3,a4
    80201166:	05ee                	slli	a1,a1,0x1b
    80201168:	02b6e463          	bltu	a3,a1,80201190 <pmm_init+0xf8>
    8020116c:	00001517          	auipc	a0,0x1
    80201170:	e3c50513          	addi	a0,a0,-452 # 80201fa8 <default_pmm_manager+0x100>
    80201174:	f0ffe0ef          	jal	ra,80200082 <cprintf>
    80201178:	601c                	ld	a5,0(s0)
    8020117a:	7b9c                	ld	a5,48(a5)
    8020117c:	9782                	jalr	a5
    8020117e:	6402                	ld	s0,0(sp)
    80201180:	60a2                	ld	ra,8(sp)
    80201182:	00001517          	auipc	a0,0x1
    80201186:	e3650513          	addi	a0,a0,-458 # 80201fb8 <default_pmm_manager+0x110>
    8020118a:	0141                	addi	sp,sp,16
    8020118c:	ef7fe06f          	j	80200082 <cprintf>
    80201190:	6705                	lui	a4,0x1
    80201192:	177d                	addi	a4,a4,-1
    80201194:	96ba                	add	a3,a3,a4
    80201196:	777d                	lui	a4,0xfffff
    80201198:	8ef9                	and	a3,a3,a4
    8020119a:	00c6d513          	srli	a0,a3,0xc
    8020119e:	00f57e63          	bgeu	a0,a5,802011ba <pmm_init+0x122>
    802011a2:	601c                	ld	a5,0(s0)
    802011a4:	982a                	add	a6,a6,a0
    802011a6:	00281513          	slli	a0,a6,0x2
    802011aa:	9542                	add	a0,a0,a6
    802011ac:	6b9c                	ld	a5,16(a5)
    802011ae:	8d95                	sub	a1,a1,a3
    802011b0:	050e                	slli	a0,a0,0x3
    802011b2:	81b1                	srli	a1,a1,0xc
    802011b4:	9532                	add	a0,a0,a2
    802011b6:	9782                	jalr	a5
    802011b8:	bf55                	j	8020116c <pmm_init+0xd4>
    802011ba:	00001617          	auipc	a2,0x1
    802011be:	dbe60613          	addi	a2,a2,-578 # 80201f78 <default_pmm_manager+0xd0>
    802011c2:	06f00593          	li	a1,111
    802011c6:	00001517          	auipc	a0,0x1
    802011ca:	dd250513          	addi	a0,a0,-558 # 80201f98 <default_pmm_manager+0xf0>
    802011ce:	f2bfe0ef          	jal	ra,802000f8 <__panic>
    802011d2:	00001617          	auipc	a2,0x1
    802011d6:	d6e60613          	addi	a2,a2,-658 # 80201f40 <default_pmm_manager+0x98>
    802011da:	06f00593          	li	a1,111
    802011de:	00001517          	auipc	a0,0x1
    802011e2:	d8a50513          	addi	a0,a0,-630 # 80201f68 <default_pmm_manager+0xc0>
    802011e6:	f13fe0ef          	jal	ra,802000f8 <__panic>

00000000802011ea <printnum>:
    802011ea:	02069813          	slli	a6,a3,0x20
    802011ee:	7179                	addi	sp,sp,-48
    802011f0:	02085813          	srli	a6,a6,0x20
    802011f4:	e052                	sd	s4,0(sp)
    802011f6:	03067a33          	remu	s4,a2,a6
    802011fa:	f022                	sd	s0,32(sp)
    802011fc:	ec26                	sd	s1,24(sp)
    802011fe:	e84a                	sd	s2,16(sp)
    80201200:	f406                	sd	ra,40(sp)
    80201202:	e44e                	sd	s3,8(sp)
    80201204:	84aa                	mv	s1,a0
    80201206:	892e                	mv	s2,a1
    80201208:	fff7041b          	addiw	s0,a4,-1
    8020120c:	2a01                	sext.w	s4,s4
    8020120e:	03067e63          	bgeu	a2,a6,8020124a <printnum+0x60>
    80201212:	89be                	mv	s3,a5
    80201214:	00805763          	blez	s0,80201222 <printnum+0x38>
    80201218:	347d                	addiw	s0,s0,-1
    8020121a:	85ca                	mv	a1,s2
    8020121c:	854e                	mv	a0,s3
    8020121e:	9482                	jalr	s1
    80201220:	fc65                	bnez	s0,80201218 <printnum+0x2e>
    80201222:	1a02                	slli	s4,s4,0x20
    80201224:	00001797          	auipc	a5,0x1
    80201228:	db478793          	addi	a5,a5,-588 # 80201fd8 <default_pmm_manager+0x130>
    8020122c:	020a5a13          	srli	s4,s4,0x20
    80201230:	9a3e                	add	s4,s4,a5
    80201232:	7402                	ld	s0,32(sp)
    80201234:	000a4503          	lbu	a0,0(s4)
    80201238:	70a2                	ld	ra,40(sp)
    8020123a:	69a2                	ld	s3,8(sp)
    8020123c:	6a02                	ld	s4,0(sp)
    8020123e:	85ca                	mv	a1,s2
    80201240:	87a6                	mv	a5,s1
    80201242:	6942                	ld	s2,16(sp)
    80201244:	64e2                	ld	s1,24(sp)
    80201246:	6145                	addi	sp,sp,48
    80201248:	8782                	jr	a5
    8020124a:	03065633          	divu	a2,a2,a6
    8020124e:	8722                	mv	a4,s0
    80201250:	f9bff0ef          	jal	ra,802011ea <printnum>
    80201254:	b7f9                	j	80201222 <printnum+0x38>

0000000080201256 <vprintfmt>:
    80201256:	7119                	addi	sp,sp,-128
    80201258:	f4a6                	sd	s1,104(sp)
    8020125a:	f0ca                	sd	s2,96(sp)
    8020125c:	ecce                	sd	s3,88(sp)
    8020125e:	e8d2                	sd	s4,80(sp)
    80201260:	e4d6                	sd	s5,72(sp)
    80201262:	e0da                	sd	s6,64(sp)
    80201264:	fc5e                	sd	s7,56(sp)
    80201266:	f06a                	sd	s10,32(sp)
    80201268:	fc86                	sd	ra,120(sp)
    8020126a:	f8a2                	sd	s0,112(sp)
    8020126c:	f862                	sd	s8,48(sp)
    8020126e:	f466                	sd	s9,40(sp)
    80201270:	ec6e                	sd	s11,24(sp)
    80201272:	892a                	mv	s2,a0
    80201274:	84ae                	mv	s1,a1
    80201276:	8d32                	mv	s10,a2
    80201278:	8a36                	mv	s4,a3
    8020127a:	02500993          	li	s3,37
    8020127e:	5b7d                	li	s6,-1
    80201280:	00001a97          	auipc	s5,0x1
    80201284:	d8ca8a93          	addi	s5,s5,-628 # 8020200c <default_pmm_manager+0x164>
    80201288:	00001b97          	auipc	s7,0x1
    8020128c:	f60b8b93          	addi	s7,s7,-160 # 802021e8 <error_string>
    80201290:	000d4503          	lbu	a0,0(s10)
    80201294:	001d0413          	addi	s0,s10,1
    80201298:	01350a63          	beq	a0,s3,802012ac <vprintfmt+0x56>
    8020129c:	c121                	beqz	a0,802012dc <vprintfmt+0x86>
    8020129e:	85a6                	mv	a1,s1
    802012a0:	0405                	addi	s0,s0,1
    802012a2:	9902                	jalr	s2
    802012a4:	fff44503          	lbu	a0,-1(s0)
    802012a8:	ff351ae3          	bne	a0,s3,8020129c <vprintfmt+0x46>
    802012ac:	00044603          	lbu	a2,0(s0)
    802012b0:	02000793          	li	a5,32
    802012b4:	4c81                	li	s9,0
    802012b6:	4881                	li	a7,0
    802012b8:	5c7d                	li	s8,-1
    802012ba:	5dfd                	li	s11,-1
    802012bc:	05500513          	li	a0,85
    802012c0:	4825                	li	a6,9
    802012c2:	fdd6059b          	addiw	a1,a2,-35
    802012c6:	0ff5f593          	andi	a1,a1,255
    802012ca:	00140d13          	addi	s10,s0,1
    802012ce:	04b56263          	bltu	a0,a1,80201312 <vprintfmt+0xbc>
    802012d2:	058a                	slli	a1,a1,0x2
    802012d4:	95d6                	add	a1,a1,s5
    802012d6:	4194                	lw	a3,0(a1)
    802012d8:	96d6                	add	a3,a3,s5
    802012da:	8682                	jr	a3
    802012dc:	70e6                	ld	ra,120(sp)
    802012de:	7446                	ld	s0,112(sp)
    802012e0:	74a6                	ld	s1,104(sp)
    802012e2:	7906                	ld	s2,96(sp)
    802012e4:	69e6                	ld	s3,88(sp)
    802012e6:	6a46                	ld	s4,80(sp)
    802012e8:	6aa6                	ld	s5,72(sp)
    802012ea:	6b06                	ld	s6,64(sp)
    802012ec:	7be2                	ld	s7,56(sp)
    802012ee:	7c42                	ld	s8,48(sp)
    802012f0:	7ca2                	ld	s9,40(sp)
    802012f2:	7d02                	ld	s10,32(sp)
    802012f4:	6de2                	ld	s11,24(sp)
    802012f6:	6109                	addi	sp,sp,128
    802012f8:	8082                	ret
    802012fa:	87b2                	mv	a5,a2
    802012fc:	00144603          	lbu	a2,1(s0)
    80201300:	846a                	mv	s0,s10
    80201302:	00140d13          	addi	s10,s0,1
    80201306:	fdd6059b          	addiw	a1,a2,-35
    8020130a:	0ff5f593          	andi	a1,a1,255
    8020130e:	fcb572e3          	bgeu	a0,a1,802012d2 <vprintfmt+0x7c>
    80201312:	85a6                	mv	a1,s1
    80201314:	02500513          	li	a0,37
    80201318:	9902                	jalr	s2
    8020131a:	fff44783          	lbu	a5,-1(s0)
    8020131e:	8d22                	mv	s10,s0
    80201320:	f73788e3          	beq	a5,s3,80201290 <vprintfmt+0x3a>
    80201324:	ffed4783          	lbu	a5,-2(s10)
    80201328:	1d7d                	addi	s10,s10,-1
    8020132a:	ff379de3          	bne	a5,s3,80201324 <vprintfmt+0xce>
    8020132e:	b78d                	j	80201290 <vprintfmt+0x3a>
    80201330:	fd060c1b          	addiw	s8,a2,-48
    80201334:	00144603          	lbu	a2,1(s0)
    80201338:	846a                	mv	s0,s10
    8020133a:	fd06069b          	addiw	a3,a2,-48
    8020133e:	0006059b          	sext.w	a1,a2
    80201342:	02d86463          	bltu	a6,a3,8020136a <vprintfmt+0x114>
    80201346:	00144603          	lbu	a2,1(s0)
    8020134a:	002c169b          	slliw	a3,s8,0x2
    8020134e:	0186873b          	addw	a4,a3,s8
    80201352:	0017171b          	slliw	a4,a4,0x1
    80201356:	9f2d                	addw	a4,a4,a1
    80201358:	fd06069b          	addiw	a3,a2,-48
    8020135c:	0405                	addi	s0,s0,1
    8020135e:	fd070c1b          	addiw	s8,a4,-48
    80201362:	0006059b          	sext.w	a1,a2
    80201366:	fed870e3          	bgeu	a6,a3,80201346 <vprintfmt+0xf0>
    8020136a:	f40ddce3          	bgez	s11,802012c2 <vprintfmt+0x6c>
    8020136e:	8de2                	mv	s11,s8
    80201370:	5c7d                	li	s8,-1
    80201372:	bf81                	j	802012c2 <vprintfmt+0x6c>
    80201374:	fffdc693          	not	a3,s11
    80201378:	96fd                	srai	a3,a3,0x3f
    8020137a:	00ddfdb3          	and	s11,s11,a3
    8020137e:	00144603          	lbu	a2,1(s0)
    80201382:	2d81                	sext.w	s11,s11
    80201384:	846a                	mv	s0,s10
    80201386:	bf35                	j	802012c2 <vprintfmt+0x6c>
    80201388:	000a2c03          	lw	s8,0(s4)
    8020138c:	00144603          	lbu	a2,1(s0)
    80201390:	0a21                	addi	s4,s4,8
    80201392:	846a                	mv	s0,s10
    80201394:	bfd9                	j	8020136a <vprintfmt+0x114>
    80201396:	4705                	li	a4,1
    80201398:	008a0593          	addi	a1,s4,8
    8020139c:	01174463          	blt	a4,a7,802013a4 <vprintfmt+0x14e>
    802013a0:	1a088e63          	beqz	a7,8020155c <vprintfmt+0x306>
    802013a4:	000a3603          	ld	a2,0(s4)
    802013a8:	46c1                	li	a3,16
    802013aa:	8a2e                	mv	s4,a1
    802013ac:	2781                	sext.w	a5,a5
    802013ae:	876e                	mv	a4,s11
    802013b0:	85a6                	mv	a1,s1
    802013b2:	854a                	mv	a0,s2
    802013b4:	e37ff0ef          	jal	ra,802011ea <printnum>
    802013b8:	bde1                	j	80201290 <vprintfmt+0x3a>
    802013ba:	000a2503          	lw	a0,0(s4)
    802013be:	85a6                	mv	a1,s1
    802013c0:	0a21                	addi	s4,s4,8
    802013c2:	9902                	jalr	s2
    802013c4:	b5f1                	j	80201290 <vprintfmt+0x3a>
    802013c6:	4705                	li	a4,1
    802013c8:	008a0593          	addi	a1,s4,8
    802013cc:	01174463          	blt	a4,a7,802013d4 <vprintfmt+0x17e>
    802013d0:	18088163          	beqz	a7,80201552 <vprintfmt+0x2fc>
    802013d4:	000a3603          	ld	a2,0(s4)
    802013d8:	46a9                	li	a3,10
    802013da:	8a2e                	mv	s4,a1
    802013dc:	bfc1                	j	802013ac <vprintfmt+0x156>
    802013de:	00144603          	lbu	a2,1(s0)
    802013e2:	4c85                	li	s9,1
    802013e4:	846a                	mv	s0,s10
    802013e6:	bdf1                	j	802012c2 <vprintfmt+0x6c>
    802013e8:	85a6                	mv	a1,s1
    802013ea:	02500513          	li	a0,37
    802013ee:	9902                	jalr	s2
    802013f0:	b545                	j	80201290 <vprintfmt+0x3a>
    802013f2:	00144603          	lbu	a2,1(s0)
    802013f6:	2885                	addiw	a7,a7,1
    802013f8:	846a                	mv	s0,s10
    802013fa:	b5e1                	j	802012c2 <vprintfmt+0x6c>
    802013fc:	4705                	li	a4,1
    802013fe:	008a0593          	addi	a1,s4,8
    80201402:	01174463          	blt	a4,a7,8020140a <vprintfmt+0x1b4>
    80201406:	14088163          	beqz	a7,80201548 <vprintfmt+0x2f2>
    8020140a:	000a3603          	ld	a2,0(s4)
    8020140e:	46a1                	li	a3,8
    80201410:	8a2e                	mv	s4,a1
    80201412:	bf69                	j	802013ac <vprintfmt+0x156>
    80201414:	03000513          	li	a0,48
    80201418:	85a6                	mv	a1,s1
    8020141a:	e03e                	sd	a5,0(sp)
    8020141c:	9902                	jalr	s2
    8020141e:	85a6                	mv	a1,s1
    80201420:	07800513          	li	a0,120
    80201424:	9902                	jalr	s2
    80201426:	0a21                	addi	s4,s4,8
    80201428:	6782                	ld	a5,0(sp)
    8020142a:	46c1                	li	a3,16
    8020142c:	ff8a3603          	ld	a2,-8(s4)
    80201430:	bfb5                	j	802013ac <vprintfmt+0x156>
    80201432:	000a3403          	ld	s0,0(s4)
    80201436:	008a0713          	addi	a4,s4,8
    8020143a:	e03a                	sd	a4,0(sp)
    8020143c:	14040263          	beqz	s0,80201580 <vprintfmt+0x32a>
    80201440:	0fb05763          	blez	s11,8020152e <vprintfmt+0x2d8>
    80201444:	02d00693          	li	a3,45
    80201448:	0cd79163          	bne	a5,a3,8020150a <vprintfmt+0x2b4>
    8020144c:	00044783          	lbu	a5,0(s0)
    80201450:	0007851b          	sext.w	a0,a5
    80201454:	cf85                	beqz	a5,8020148c <vprintfmt+0x236>
    80201456:	00140a13          	addi	s4,s0,1
    8020145a:	05e00413          	li	s0,94
    8020145e:	000c4563          	bltz	s8,80201468 <vprintfmt+0x212>
    80201462:	3c7d                	addiw	s8,s8,-1
    80201464:	036c0263          	beq	s8,s6,80201488 <vprintfmt+0x232>
    80201468:	85a6                	mv	a1,s1
    8020146a:	0e0c8e63          	beqz	s9,80201566 <vprintfmt+0x310>
    8020146e:	3781                	addiw	a5,a5,-32
    80201470:	0ef47b63          	bgeu	s0,a5,80201566 <vprintfmt+0x310>
    80201474:	03f00513          	li	a0,63
    80201478:	9902                	jalr	s2
    8020147a:	000a4783          	lbu	a5,0(s4)
    8020147e:	3dfd                	addiw	s11,s11,-1
    80201480:	0a05                	addi	s4,s4,1
    80201482:	0007851b          	sext.w	a0,a5
    80201486:	ffe1                	bnez	a5,8020145e <vprintfmt+0x208>
    80201488:	01b05963          	blez	s11,8020149a <vprintfmt+0x244>
    8020148c:	3dfd                	addiw	s11,s11,-1
    8020148e:	85a6                	mv	a1,s1
    80201490:	02000513          	li	a0,32
    80201494:	9902                	jalr	s2
    80201496:	fe0d9be3          	bnez	s11,8020148c <vprintfmt+0x236>
    8020149a:	6a02                	ld	s4,0(sp)
    8020149c:	bbd5                	j	80201290 <vprintfmt+0x3a>
    8020149e:	4705                	li	a4,1
    802014a0:	008a0c93          	addi	s9,s4,8
    802014a4:	01174463          	blt	a4,a7,802014ac <vprintfmt+0x256>
    802014a8:	08088d63          	beqz	a7,80201542 <vprintfmt+0x2ec>
    802014ac:	000a3403          	ld	s0,0(s4)
    802014b0:	0a044d63          	bltz	s0,8020156a <vprintfmt+0x314>
    802014b4:	8622                	mv	a2,s0
    802014b6:	8a66                	mv	s4,s9
    802014b8:	46a9                	li	a3,10
    802014ba:	bdcd                	j	802013ac <vprintfmt+0x156>
    802014bc:	000a2783          	lw	a5,0(s4)
    802014c0:	4719                	li	a4,6
    802014c2:	0a21                	addi	s4,s4,8
    802014c4:	41f7d69b          	sraiw	a3,a5,0x1f
    802014c8:	8fb5                	xor	a5,a5,a3
    802014ca:	40d786bb          	subw	a3,a5,a3
    802014ce:	02d74163          	blt	a4,a3,802014f0 <vprintfmt+0x29a>
    802014d2:	00369793          	slli	a5,a3,0x3
    802014d6:	97de                	add	a5,a5,s7
    802014d8:	639c                	ld	a5,0(a5)
    802014da:	cb99                	beqz	a5,802014f0 <vprintfmt+0x29a>
    802014dc:	86be                	mv	a3,a5
    802014de:	00001617          	auipc	a2,0x1
    802014e2:	b2a60613          	addi	a2,a2,-1238 # 80202008 <default_pmm_manager+0x160>
    802014e6:	85a6                	mv	a1,s1
    802014e8:	854a                	mv	a0,s2
    802014ea:	0ce000ef          	jal	ra,802015b8 <printfmt>
    802014ee:	b34d                	j	80201290 <vprintfmt+0x3a>
    802014f0:	00001617          	auipc	a2,0x1
    802014f4:	b0860613          	addi	a2,a2,-1272 # 80201ff8 <default_pmm_manager+0x150>
    802014f8:	85a6                	mv	a1,s1
    802014fa:	854a                	mv	a0,s2
    802014fc:	0bc000ef          	jal	ra,802015b8 <printfmt>
    80201500:	bb41                	j	80201290 <vprintfmt+0x3a>
    80201502:	00001417          	auipc	s0,0x1
    80201506:	aee40413          	addi	s0,s0,-1298 # 80201ff0 <default_pmm_manager+0x148>
    8020150a:	85e2                	mv	a1,s8
    8020150c:	8522                	mv	a0,s0
    8020150e:	e43e                	sd	a5,8(sp)
    80201510:	0fc000ef          	jal	ra,8020160c <strnlen>
    80201514:	40ad8dbb          	subw	s11,s11,a0
    80201518:	01b05b63          	blez	s11,8020152e <vprintfmt+0x2d8>
    8020151c:	67a2                	ld	a5,8(sp)
    8020151e:	00078a1b          	sext.w	s4,a5
    80201522:	3dfd                	addiw	s11,s11,-1
    80201524:	85a6                	mv	a1,s1
    80201526:	8552                	mv	a0,s4
    80201528:	9902                	jalr	s2
    8020152a:	fe0d9ce3          	bnez	s11,80201522 <vprintfmt+0x2cc>
    8020152e:	00044783          	lbu	a5,0(s0)
    80201532:	00140a13          	addi	s4,s0,1
    80201536:	0007851b          	sext.w	a0,a5
    8020153a:	d3a5                	beqz	a5,8020149a <vprintfmt+0x244>
    8020153c:	05e00413          	li	s0,94
    80201540:	bf39                	j	8020145e <vprintfmt+0x208>
    80201542:	000a2403          	lw	s0,0(s4)
    80201546:	b7ad                	j	802014b0 <vprintfmt+0x25a>
    80201548:	000a6603          	lwu	a2,0(s4)
    8020154c:	46a1                	li	a3,8
    8020154e:	8a2e                	mv	s4,a1
    80201550:	bdb1                	j	802013ac <vprintfmt+0x156>
    80201552:	000a6603          	lwu	a2,0(s4)
    80201556:	46a9                	li	a3,10
    80201558:	8a2e                	mv	s4,a1
    8020155a:	bd89                	j	802013ac <vprintfmt+0x156>
    8020155c:	000a6603          	lwu	a2,0(s4)
    80201560:	46c1                	li	a3,16
    80201562:	8a2e                	mv	s4,a1
    80201564:	b5a1                	j	802013ac <vprintfmt+0x156>
    80201566:	9902                	jalr	s2
    80201568:	bf09                	j	8020147a <vprintfmt+0x224>
    8020156a:	85a6                	mv	a1,s1
    8020156c:	02d00513          	li	a0,45
    80201570:	e03e                	sd	a5,0(sp)
    80201572:	9902                	jalr	s2
    80201574:	6782                	ld	a5,0(sp)
    80201576:	8a66                	mv	s4,s9
    80201578:	40800633          	neg	a2,s0
    8020157c:	46a9                	li	a3,10
    8020157e:	b53d                	j	802013ac <vprintfmt+0x156>
    80201580:	03b05163          	blez	s11,802015a2 <vprintfmt+0x34c>
    80201584:	02d00693          	li	a3,45
    80201588:	f6d79de3          	bne	a5,a3,80201502 <vprintfmt+0x2ac>
    8020158c:	00001417          	auipc	s0,0x1
    80201590:	a6440413          	addi	s0,s0,-1436 # 80201ff0 <default_pmm_manager+0x148>
    80201594:	02800793          	li	a5,40
    80201598:	02800513          	li	a0,40
    8020159c:	00140a13          	addi	s4,s0,1
    802015a0:	bd6d                	j	8020145a <vprintfmt+0x204>
    802015a2:	00001a17          	auipc	s4,0x1
    802015a6:	a4fa0a13          	addi	s4,s4,-1457 # 80201ff1 <default_pmm_manager+0x149>
    802015aa:	02800513          	li	a0,40
    802015ae:	02800793          	li	a5,40
    802015b2:	05e00413          	li	s0,94
    802015b6:	b565                	j	8020145e <vprintfmt+0x208>

00000000802015b8 <printfmt>:
    802015b8:	715d                	addi	sp,sp,-80
    802015ba:	02810313          	addi	t1,sp,40
    802015be:	f436                	sd	a3,40(sp)
    802015c0:	869a                	mv	a3,t1
    802015c2:	ec06                	sd	ra,24(sp)
    802015c4:	f83a                	sd	a4,48(sp)
    802015c6:	fc3e                	sd	a5,56(sp)
    802015c8:	e0c2                	sd	a6,64(sp)
    802015ca:	e4c6                	sd	a7,72(sp)
    802015cc:	e41a                	sd	t1,8(sp)
    802015ce:	c89ff0ef          	jal	ra,80201256 <vprintfmt>
    802015d2:	60e2                	ld	ra,24(sp)
    802015d4:	6161                	addi	sp,sp,80
    802015d6:	8082                	ret

00000000802015d8 <sbi_console_putchar>:
    802015d8:	4781                	li	a5,0
    802015da:	00004717          	auipc	a4,0x4
    802015de:	a2673703          	ld	a4,-1498(a4) # 80205000 <SBI_CONSOLE_PUTCHAR>
    802015e2:	88ba                	mv	a7,a4
    802015e4:	852a                	mv	a0,a0
    802015e6:	85be                	mv	a1,a5
    802015e8:	863e                	mv	a2,a5
    802015ea:	00000073          	ecall
    802015ee:	87aa                	mv	a5,a0
    802015f0:	8082                	ret

00000000802015f2 <sbi_set_timer>:
    802015f2:	4781                	li	a5,0
    802015f4:	00004717          	auipc	a4,0x4
    802015f8:	a5c73703          	ld	a4,-1444(a4) # 80205050 <SBI_SET_TIMER>
    802015fc:	88ba                	mv	a7,a4
    802015fe:	852a                	mv	a0,a0
    80201600:	85be                	mv	a1,a5
    80201602:	863e                	mv	a2,a5
    80201604:	00000073          	ecall
    80201608:	87aa                	mv	a5,a0
    8020160a:	8082                	ret

000000008020160c <strnlen>:
    8020160c:	4781                	li	a5,0
    8020160e:	e589                	bnez	a1,80201618 <strnlen+0xc>
    80201610:	a811                	j	80201624 <strnlen+0x18>
    80201612:	0785                	addi	a5,a5,1
    80201614:	00f58863          	beq	a1,a5,80201624 <strnlen+0x18>
    80201618:	00f50733          	add	a4,a0,a5
    8020161c:	00074703          	lbu	a4,0(a4)
    80201620:	fb6d                	bnez	a4,80201612 <strnlen+0x6>
    80201622:	85be                	mv	a1,a5
    80201624:	852e                	mv	a0,a1
    80201626:	8082                	ret

0000000080201628 <memset>:
    80201628:	ca01                	beqz	a2,80201638 <memset+0x10>
    8020162a:	962a                	add	a2,a2,a0
    8020162c:	87aa                	mv	a5,a0
    8020162e:	0785                	addi	a5,a5,1
    80201630:	feb78fa3          	sb	a1,-1(a5)
    80201634:	fec79de3          	bne	a5,a2,8020162e <memset+0x6>
    80201638:	8082                	ret
