
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	ffe50513          	addi	a0,a0,-2 # 80204008 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	00660613          	addi	a2,a2,6 # 80204018 <end>
    8020001a:	1141                	addi	sp,sp,-16
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	157000ef          	jal	ra,80200978 <memset>
    80200026:	00001517          	auipc	a0,0x1
    8020002a:	96a50513          	addi	a0,a0,-1686 # 80200990 <etext+0x6>
    8020002e:	080000ef          	jal	ra,802000ae <cputs>
    80200032:	10c000ef          	jal	ra,8020013e <idt_init>
    80200036:	102000ef          	jal	ra,80200138 <intr_enable>
    8020003a:	9002                	ebreak
    8020003c:	00001517          	auipc	a0,0x1
    80200040:	96c50513          	addi	a0,a0,-1684 # 802009a8 <etext+0x1e>
    80200044:	06a000ef          	jal	ra,802000ae <cputs>
    80200048:	30200073          	mret
    8020004c:	00001517          	auipc	a0,0x1
    80200050:	98450513          	addi	a0,a0,-1660 # 802009d0 <etext+0x46>
    80200054:	05a000ef          	jal	ra,802000ae <cputs>
    80200058:	096000ef          	jal	ra,802000ee <clock_init>
    8020005c:	a001                	j	8020005c <kern_init+0x52>

000000008020005e <cputch>:
    8020005e:	1141                	addi	sp,sp,-16
    80200060:	e022                	sd	s0,0(sp)
    80200062:	e406                	sd	ra,8(sp)
    80200064:	842e                	mv	s0,a1
    80200066:	0ca000ef          	jal	ra,80200130 <cons_putc>
    8020006a:	401c                	lw	a5,0(s0)
    8020006c:	60a2                	ld	ra,8(sp)
    8020006e:	2785                	addiw	a5,a5,1
    80200070:	c01c                	sw	a5,0(s0)
    80200072:	6402                	ld	s0,0(sp)
    80200074:	0141                	addi	sp,sp,16
    80200076:	8082                	ret

0000000080200078 <cprintf>:
    80200078:	711d                	addi	sp,sp,-96
    8020007a:	02810313          	addi	t1,sp,40 # 80204028 <end+0x10>
    8020007e:	8e2a                	mv	t3,a0
    80200080:	f42e                	sd	a1,40(sp)
    80200082:	f832                	sd	a2,48(sp)
    80200084:	fc36                	sd	a3,56(sp)
    80200086:	00000517          	auipc	a0,0x0
    8020008a:	fd850513          	addi	a0,a0,-40 # 8020005e <cputch>
    8020008e:	004c                	addi	a1,sp,4
    80200090:	869a                	mv	a3,t1
    80200092:	8672                	mv	a2,t3
    80200094:	ec06                	sd	ra,24(sp)
    80200096:	e0ba                	sd	a4,64(sp)
    80200098:	e4be                	sd	a5,72(sp)
    8020009a:	e8c2                	sd	a6,80(sp)
    8020009c:	ecc6                	sd	a7,88(sp)
    8020009e:	e41a                	sd	t1,8(sp)
    802000a0:	c202                	sw	zero,4(sp)
    802000a2:	504000ef          	jal	ra,802005a6 <vprintfmt>
    802000a6:	60e2                	ld	ra,24(sp)
    802000a8:	4512                	lw	a0,4(sp)
    802000aa:	6125                	addi	sp,sp,96
    802000ac:	8082                	ret

00000000802000ae <cputs>:
    802000ae:	1101                	addi	sp,sp,-32
    802000b0:	e822                	sd	s0,16(sp)
    802000b2:	ec06                	sd	ra,24(sp)
    802000b4:	e426                	sd	s1,8(sp)
    802000b6:	842a                	mv	s0,a0
    802000b8:	00054503          	lbu	a0,0(a0)
    802000bc:	c51d                	beqz	a0,802000ea <cputs+0x3c>
    802000be:	0405                	addi	s0,s0,1
    802000c0:	4485                	li	s1,1
    802000c2:	9c81                	subw	s1,s1,s0
    802000c4:	06c000ef          	jal	ra,80200130 <cons_putc>
    802000c8:	00044503          	lbu	a0,0(s0)
    802000cc:	008487bb          	addw	a5,s1,s0
    802000d0:	0405                	addi	s0,s0,1
    802000d2:	f96d                	bnez	a0,802000c4 <cputs+0x16>
    802000d4:	0017841b          	addiw	s0,a5,1
    802000d8:	4529                	li	a0,10
    802000da:	056000ef          	jal	ra,80200130 <cons_putc>
    802000de:	60e2                	ld	ra,24(sp)
    802000e0:	8522                	mv	a0,s0
    802000e2:	6442                	ld	s0,16(sp)
    802000e4:	64a2                	ld	s1,8(sp)
    802000e6:	6105                	addi	sp,sp,32
    802000e8:	8082                	ret
    802000ea:	4405                	li	s0,1
    802000ec:	b7f5                	j	802000d8 <cputs+0x2a>

00000000802000ee <clock_init>:
    802000ee:	1141                	addi	sp,sp,-16
    802000f0:	e406                	sd	ra,8(sp)
    802000f2:	02000793          	li	a5,32
    802000f6:	1047a7f3          	csrrs	a5,sie,a5
    802000fa:	c0102573          	rdtime	a0
    802000fe:	67e1                	lui	a5,0x18
    80200100:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200104:	953e                	add	a0,a0,a5
    80200106:	03d000ef          	jal	ra,80200942 <sbi_set_timer>
    8020010a:	60a2                	ld	ra,8(sp)
    8020010c:	00004797          	auipc	a5,0x4
    80200110:	ee07be23          	sd	zero,-260(a5) # 80204008 <ticks>
    80200114:	00001517          	auipc	a0,0x1
    80200118:	8e450513          	addi	a0,a0,-1820 # 802009f8 <etext+0x6e>
    8020011c:	0141                	addi	sp,sp,16
    8020011e:	bfa9                	j	80200078 <cprintf>

0000000080200120 <clock_set_next_event>:
    80200120:	c0102573          	rdtime	a0
    80200124:	67e1                	lui	a5,0x18
    80200126:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020012a:	953e                	add	a0,a0,a5
    8020012c:	0170006f          	j	80200942 <sbi_set_timer>

0000000080200130 <cons_putc>:
    80200130:	0ff57513          	andi	a0,a0,255
    80200134:	7f40006f          	j	80200928 <sbi_console_putchar>

0000000080200138 <intr_enable>:
    80200138:	100167f3          	csrrsi	a5,sstatus,2
    8020013c:	8082                	ret

000000008020013e <idt_init>:
    8020013e:	00000797          	auipc	a5,0x0
    80200142:	34678793          	addi	a5,a5,838 # 80200484 <__alltraps>
    80200146:	10579073          	csrw	stvec,a5
    8020014a:	8082                	ret

000000008020014c <print_regs>:
    8020014c:	610c                	ld	a1,0(a0)
    8020014e:	1141                	addi	sp,sp,-16
    80200150:	e022                	sd	s0,0(sp)
    80200152:	842a                	mv	s0,a0
    80200154:	00001517          	auipc	a0,0x1
    80200158:	8c450513          	addi	a0,a0,-1852 # 80200a18 <etext+0x8e>
    8020015c:	e406                	sd	ra,8(sp)
    8020015e:	f1bff0ef          	jal	ra,80200078 <cprintf>
    80200162:	640c                	ld	a1,8(s0)
    80200164:	00001517          	auipc	a0,0x1
    80200168:	8cc50513          	addi	a0,a0,-1844 # 80200a30 <etext+0xa6>
    8020016c:	f0dff0ef          	jal	ra,80200078 <cprintf>
    80200170:	680c                	ld	a1,16(s0)
    80200172:	00001517          	auipc	a0,0x1
    80200176:	8d650513          	addi	a0,a0,-1834 # 80200a48 <etext+0xbe>
    8020017a:	effff0ef          	jal	ra,80200078 <cprintf>
    8020017e:	6c0c                	ld	a1,24(s0)
    80200180:	00001517          	auipc	a0,0x1
    80200184:	8e050513          	addi	a0,a0,-1824 # 80200a60 <etext+0xd6>
    80200188:	ef1ff0ef          	jal	ra,80200078 <cprintf>
    8020018c:	700c                	ld	a1,32(s0)
    8020018e:	00001517          	auipc	a0,0x1
    80200192:	8ea50513          	addi	a0,a0,-1814 # 80200a78 <etext+0xee>
    80200196:	ee3ff0ef          	jal	ra,80200078 <cprintf>
    8020019a:	740c                	ld	a1,40(s0)
    8020019c:	00001517          	auipc	a0,0x1
    802001a0:	8f450513          	addi	a0,a0,-1804 # 80200a90 <etext+0x106>
    802001a4:	ed5ff0ef          	jal	ra,80200078 <cprintf>
    802001a8:	780c                	ld	a1,48(s0)
    802001aa:	00001517          	auipc	a0,0x1
    802001ae:	8fe50513          	addi	a0,a0,-1794 # 80200aa8 <etext+0x11e>
    802001b2:	ec7ff0ef          	jal	ra,80200078 <cprintf>
    802001b6:	7c0c                	ld	a1,56(s0)
    802001b8:	00001517          	auipc	a0,0x1
    802001bc:	90850513          	addi	a0,a0,-1784 # 80200ac0 <etext+0x136>
    802001c0:	eb9ff0ef          	jal	ra,80200078 <cprintf>
    802001c4:	602c                	ld	a1,64(s0)
    802001c6:	00001517          	auipc	a0,0x1
    802001ca:	91250513          	addi	a0,a0,-1774 # 80200ad8 <etext+0x14e>
    802001ce:	eabff0ef          	jal	ra,80200078 <cprintf>
    802001d2:	642c                	ld	a1,72(s0)
    802001d4:	00001517          	auipc	a0,0x1
    802001d8:	91c50513          	addi	a0,a0,-1764 # 80200af0 <etext+0x166>
    802001dc:	e9dff0ef          	jal	ra,80200078 <cprintf>
    802001e0:	682c                	ld	a1,80(s0)
    802001e2:	00001517          	auipc	a0,0x1
    802001e6:	92650513          	addi	a0,a0,-1754 # 80200b08 <etext+0x17e>
    802001ea:	e8fff0ef          	jal	ra,80200078 <cprintf>
    802001ee:	6c2c                	ld	a1,88(s0)
    802001f0:	00001517          	auipc	a0,0x1
    802001f4:	93050513          	addi	a0,a0,-1744 # 80200b20 <etext+0x196>
    802001f8:	e81ff0ef          	jal	ra,80200078 <cprintf>
    802001fc:	702c                	ld	a1,96(s0)
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	93a50513          	addi	a0,a0,-1734 # 80200b38 <etext+0x1ae>
    80200206:	e73ff0ef          	jal	ra,80200078 <cprintf>
    8020020a:	742c                	ld	a1,104(s0)
    8020020c:	00001517          	auipc	a0,0x1
    80200210:	94450513          	addi	a0,a0,-1724 # 80200b50 <etext+0x1c6>
    80200214:	e65ff0ef          	jal	ra,80200078 <cprintf>
    80200218:	782c                	ld	a1,112(s0)
    8020021a:	00001517          	auipc	a0,0x1
    8020021e:	94e50513          	addi	a0,a0,-1714 # 80200b68 <etext+0x1de>
    80200222:	e57ff0ef          	jal	ra,80200078 <cprintf>
    80200226:	7c2c                	ld	a1,120(s0)
    80200228:	00001517          	auipc	a0,0x1
    8020022c:	95850513          	addi	a0,a0,-1704 # 80200b80 <etext+0x1f6>
    80200230:	e49ff0ef          	jal	ra,80200078 <cprintf>
    80200234:	604c                	ld	a1,128(s0)
    80200236:	00001517          	auipc	a0,0x1
    8020023a:	96250513          	addi	a0,a0,-1694 # 80200b98 <etext+0x20e>
    8020023e:	e3bff0ef          	jal	ra,80200078 <cprintf>
    80200242:	644c                	ld	a1,136(s0)
    80200244:	00001517          	auipc	a0,0x1
    80200248:	96c50513          	addi	a0,a0,-1684 # 80200bb0 <etext+0x226>
    8020024c:	e2dff0ef          	jal	ra,80200078 <cprintf>
    80200250:	684c                	ld	a1,144(s0)
    80200252:	00001517          	auipc	a0,0x1
    80200256:	97650513          	addi	a0,a0,-1674 # 80200bc8 <etext+0x23e>
    8020025a:	e1fff0ef          	jal	ra,80200078 <cprintf>
    8020025e:	6c4c                	ld	a1,152(s0)
    80200260:	00001517          	auipc	a0,0x1
    80200264:	98050513          	addi	a0,a0,-1664 # 80200be0 <etext+0x256>
    80200268:	e11ff0ef          	jal	ra,80200078 <cprintf>
    8020026c:	704c                	ld	a1,160(s0)
    8020026e:	00001517          	auipc	a0,0x1
    80200272:	98a50513          	addi	a0,a0,-1654 # 80200bf8 <etext+0x26e>
    80200276:	e03ff0ef          	jal	ra,80200078 <cprintf>
    8020027a:	744c                	ld	a1,168(s0)
    8020027c:	00001517          	auipc	a0,0x1
    80200280:	99450513          	addi	a0,a0,-1644 # 80200c10 <etext+0x286>
    80200284:	df5ff0ef          	jal	ra,80200078 <cprintf>
    80200288:	784c                	ld	a1,176(s0)
    8020028a:	00001517          	auipc	a0,0x1
    8020028e:	99e50513          	addi	a0,a0,-1634 # 80200c28 <etext+0x29e>
    80200292:	de7ff0ef          	jal	ra,80200078 <cprintf>
    80200296:	7c4c                	ld	a1,184(s0)
    80200298:	00001517          	auipc	a0,0x1
    8020029c:	9a850513          	addi	a0,a0,-1624 # 80200c40 <etext+0x2b6>
    802002a0:	dd9ff0ef          	jal	ra,80200078 <cprintf>
    802002a4:	606c                	ld	a1,192(s0)
    802002a6:	00001517          	auipc	a0,0x1
    802002aa:	9b250513          	addi	a0,a0,-1614 # 80200c58 <etext+0x2ce>
    802002ae:	dcbff0ef          	jal	ra,80200078 <cprintf>
    802002b2:	646c                	ld	a1,200(s0)
    802002b4:	00001517          	auipc	a0,0x1
    802002b8:	9bc50513          	addi	a0,a0,-1604 # 80200c70 <etext+0x2e6>
    802002bc:	dbdff0ef          	jal	ra,80200078 <cprintf>
    802002c0:	686c                	ld	a1,208(s0)
    802002c2:	00001517          	auipc	a0,0x1
    802002c6:	9c650513          	addi	a0,a0,-1594 # 80200c88 <etext+0x2fe>
    802002ca:	dafff0ef          	jal	ra,80200078 <cprintf>
    802002ce:	6c6c                	ld	a1,216(s0)
    802002d0:	00001517          	auipc	a0,0x1
    802002d4:	9d050513          	addi	a0,a0,-1584 # 80200ca0 <etext+0x316>
    802002d8:	da1ff0ef          	jal	ra,80200078 <cprintf>
    802002dc:	706c                	ld	a1,224(s0)
    802002de:	00001517          	auipc	a0,0x1
    802002e2:	9da50513          	addi	a0,a0,-1574 # 80200cb8 <etext+0x32e>
    802002e6:	d93ff0ef          	jal	ra,80200078 <cprintf>
    802002ea:	746c                	ld	a1,232(s0)
    802002ec:	00001517          	auipc	a0,0x1
    802002f0:	9e450513          	addi	a0,a0,-1564 # 80200cd0 <etext+0x346>
    802002f4:	d85ff0ef          	jal	ra,80200078 <cprintf>
    802002f8:	786c                	ld	a1,240(s0)
    802002fa:	00001517          	auipc	a0,0x1
    802002fe:	9ee50513          	addi	a0,a0,-1554 # 80200ce8 <etext+0x35e>
    80200302:	d77ff0ef          	jal	ra,80200078 <cprintf>
    80200306:	7c6c                	ld	a1,248(s0)
    80200308:	6402                	ld	s0,0(sp)
    8020030a:	60a2                	ld	ra,8(sp)
    8020030c:	00001517          	auipc	a0,0x1
    80200310:	9f450513          	addi	a0,a0,-1548 # 80200d00 <etext+0x376>
    80200314:	0141                	addi	sp,sp,16
    80200316:	b38d                	j	80200078 <cprintf>

0000000080200318 <print_trapframe>:
    80200318:	1141                	addi	sp,sp,-16
    8020031a:	e022                	sd	s0,0(sp)
    8020031c:	85aa                	mv	a1,a0
    8020031e:	842a                	mv	s0,a0
    80200320:	00001517          	auipc	a0,0x1
    80200324:	9f850513          	addi	a0,a0,-1544 # 80200d18 <etext+0x38e>
    80200328:	e406                	sd	ra,8(sp)
    8020032a:	d4fff0ef          	jal	ra,80200078 <cprintf>
    8020032e:	8522                	mv	a0,s0
    80200330:	e1dff0ef          	jal	ra,8020014c <print_regs>
    80200334:	10043583          	ld	a1,256(s0)
    80200338:	00001517          	auipc	a0,0x1
    8020033c:	9f850513          	addi	a0,a0,-1544 # 80200d30 <etext+0x3a6>
    80200340:	d39ff0ef          	jal	ra,80200078 <cprintf>
    80200344:	10843583          	ld	a1,264(s0)
    80200348:	00001517          	auipc	a0,0x1
    8020034c:	a0050513          	addi	a0,a0,-1536 # 80200d48 <etext+0x3be>
    80200350:	d29ff0ef          	jal	ra,80200078 <cprintf>
    80200354:	11043583          	ld	a1,272(s0)
    80200358:	00001517          	auipc	a0,0x1
    8020035c:	a0850513          	addi	a0,a0,-1528 # 80200d60 <etext+0x3d6>
    80200360:	d19ff0ef          	jal	ra,80200078 <cprintf>
    80200364:	11843583          	ld	a1,280(s0)
    80200368:	6402                	ld	s0,0(sp)
    8020036a:	60a2                	ld	ra,8(sp)
    8020036c:	00001517          	auipc	a0,0x1
    80200370:	a0c50513          	addi	a0,a0,-1524 # 80200d78 <etext+0x3ee>
    80200374:	0141                	addi	sp,sp,16
    80200376:	b309                	j	80200078 <cprintf>

0000000080200378 <interrupt_handler>:
    80200378:	11853783          	ld	a5,280(a0)
    8020037c:	472d                	li	a4,11
    8020037e:	0786                	slli	a5,a5,0x1
    80200380:	8385                	srli	a5,a5,0x1
    80200382:	06f76763          	bltu	a4,a5,802003f0 <interrupt_handler+0x78>
    80200386:	00001717          	auipc	a4,0x1
    8020038a:	aba70713          	addi	a4,a4,-1350 # 80200e40 <etext+0x4b6>
    8020038e:	078a                	slli	a5,a5,0x2
    80200390:	97ba                	add	a5,a5,a4
    80200392:	439c                	lw	a5,0(a5)
    80200394:	97ba                	add	a5,a5,a4
    80200396:	8782                	jr	a5
    80200398:	00001517          	auipc	a0,0x1
    8020039c:	a5850513          	addi	a0,a0,-1448 # 80200df0 <etext+0x466>
    802003a0:	b9e1                	j	80200078 <cprintf>
    802003a2:	00001517          	auipc	a0,0x1
    802003a6:	a2e50513          	addi	a0,a0,-1490 # 80200dd0 <etext+0x446>
    802003aa:	b1f9                	j	80200078 <cprintf>
    802003ac:	00001517          	auipc	a0,0x1
    802003b0:	9e450513          	addi	a0,a0,-1564 # 80200d90 <etext+0x406>
    802003b4:	b1d1                	j	80200078 <cprintf>
    802003b6:	00001517          	auipc	a0,0x1
    802003ba:	9fa50513          	addi	a0,a0,-1542 # 80200db0 <etext+0x426>
    802003be:	b96d                	j	80200078 <cprintf>
    802003c0:	1141                	addi	sp,sp,-16
    802003c2:	e406                	sd	ra,8(sp)
    802003c4:	d5dff0ef          	jal	ra,80200120 <clock_set_next_event>
    802003c8:	00004697          	auipc	a3,0x4
    802003cc:	c4068693          	addi	a3,a3,-960 # 80204008 <ticks>
    802003d0:	629c                	ld	a5,0(a3)
    802003d2:	06400713          	li	a4,100
    802003d6:	0785                	addi	a5,a5,1
    802003d8:	02e7f733          	remu	a4,a5,a4
    802003dc:	e29c                	sd	a5,0(a3)
    802003de:	cb11                	beqz	a4,802003f2 <interrupt_handler+0x7a>
    802003e0:	60a2                	ld	ra,8(sp)
    802003e2:	0141                	addi	sp,sp,16
    802003e4:	8082                	ret
    802003e6:	00001517          	auipc	a0,0x1
    802003ea:	a3a50513          	addi	a0,a0,-1478 # 80200e20 <etext+0x496>
    802003ee:	b169                	j	80200078 <cprintf>
    802003f0:	b725                	j	80200318 <print_trapframe>
    802003f2:	60a2                	ld	ra,8(sp)
    802003f4:	06400593          	li	a1,100
    802003f8:	00001517          	auipc	a0,0x1
    802003fc:	a1850513          	addi	a0,a0,-1512 # 80200e10 <etext+0x486>
    80200400:	0141                	addi	sp,sp,16
    80200402:	b99d                	j	80200078 <cprintf>

0000000080200404 <trap>:
    80200404:	11853783          	ld	a5,280(a0)
    80200408:	0407cc63          	bltz	a5,80200460 <trap+0x5c>
    8020040c:	1141                	addi	sp,sp,-16
    8020040e:	e022                	sd	s0,0(sp)
    80200410:	e406                	sd	ra,8(sp)
    80200412:	470d                	li	a4,3
    80200414:	842a                	mv	s0,a0
    80200416:	04e78663          	beq	a5,a4,80200462 <trap+0x5e>
    8020041a:	02f76a63          	bltu	a4,a5,8020044e <trap+0x4a>
    8020041e:	4705                	li	a4,1
    80200420:	02f77363          	bgeu	a4,a5,80200446 <trap+0x42>
    80200424:	4709                	li	a4,2
    80200426:	02e79863          	bne	a5,a4,80200456 <trap+0x52>
    8020042a:	10853583          	ld	a1,264(a0)
    8020042e:	00001517          	auipc	a0,0x1
    80200432:	a4250513          	addi	a0,a0,-1470 # 80200e70 <etext+0x4e6>
    80200436:	4190                	lw	a2,0(a1)
    80200438:	c41ff0ef          	jal	ra,80200078 <cprintf>
    8020043c:	10843783          	ld	a5,264(s0)
    80200440:	0791                	addi	a5,a5,4
    80200442:	10f43423          	sd	a5,264(s0)
    80200446:	60a2                	ld	ra,8(sp)
    80200448:	6402                	ld	s0,0(sp)
    8020044a:	0141                	addi	sp,sp,16
    8020044c:	8082                	ret
    8020044e:	17f1                	addi	a5,a5,-4
    80200450:	471d                	li	a4,7
    80200452:	fef77ae3          	bgeu	a4,a5,80200446 <trap+0x42>
    80200456:	8522                	mv	a0,s0
    80200458:	6402                	ld	s0,0(sp)
    8020045a:	60a2                	ld	ra,8(sp)
    8020045c:	0141                	addi	sp,sp,16
    8020045e:	bd6d                	j	80200318 <print_trapframe>
    80200460:	bf21                	j	80200378 <interrupt_handler>
    80200462:	10853583          	ld	a1,264(a0)
    80200466:	00001517          	auipc	a0,0x1
    8020046a:	a4250513          	addi	a0,a0,-1470 # 80200ea8 <etext+0x51e>
    8020046e:	c0bff0ef          	jal	ra,80200078 <cprintf>
    80200472:	10843783          	ld	a5,264(s0)
    80200476:	60a2                	ld	ra,8(sp)
    80200478:	0789                	addi	a5,a5,2
    8020047a:	10f43423          	sd	a5,264(s0)
    8020047e:	6402                	ld	s0,0(sp)
    80200480:	0141                	addi	sp,sp,16
    80200482:	8082                	ret

0000000080200484 <__alltraps>:
    80200484:	14011073          	csrw	sscratch,sp
    80200488:	712d                	addi	sp,sp,-288
    8020048a:	e002                	sd	zero,0(sp)
    8020048c:	e406                	sd	ra,8(sp)
    8020048e:	ec0e                	sd	gp,24(sp)
    80200490:	f012                	sd	tp,32(sp)
    80200492:	f416                	sd	t0,40(sp)
    80200494:	f81a                	sd	t1,48(sp)
    80200496:	fc1e                	sd	t2,56(sp)
    80200498:	e0a2                	sd	s0,64(sp)
    8020049a:	e4a6                	sd	s1,72(sp)
    8020049c:	e8aa                	sd	a0,80(sp)
    8020049e:	ecae                	sd	a1,88(sp)
    802004a0:	f0b2                	sd	a2,96(sp)
    802004a2:	f4b6                	sd	a3,104(sp)
    802004a4:	f8ba                	sd	a4,112(sp)
    802004a6:	fcbe                	sd	a5,120(sp)
    802004a8:	e142                	sd	a6,128(sp)
    802004aa:	e546                	sd	a7,136(sp)
    802004ac:	e94a                	sd	s2,144(sp)
    802004ae:	ed4e                	sd	s3,152(sp)
    802004b0:	f152                	sd	s4,160(sp)
    802004b2:	f556                	sd	s5,168(sp)
    802004b4:	f95a                	sd	s6,176(sp)
    802004b6:	fd5e                	sd	s7,184(sp)
    802004b8:	e1e2                	sd	s8,192(sp)
    802004ba:	e5e6                	sd	s9,200(sp)
    802004bc:	e9ea                	sd	s10,208(sp)
    802004be:	edee                	sd	s11,216(sp)
    802004c0:	f1f2                	sd	t3,224(sp)
    802004c2:	f5f6                	sd	t4,232(sp)
    802004c4:	f9fa                	sd	t5,240(sp)
    802004c6:	fdfe                	sd	t6,248(sp)
    802004c8:	14001473          	csrrw	s0,sscratch,zero
    802004cc:	100024f3          	csrr	s1,sstatus
    802004d0:	14102973          	csrr	s2,sepc
    802004d4:	143029f3          	csrr	s3,stval
    802004d8:	14202a73          	csrr	s4,scause
    802004dc:	e822                	sd	s0,16(sp)
    802004de:	e226                	sd	s1,256(sp)
    802004e0:	e64a                	sd	s2,264(sp)
    802004e2:	ea4e                	sd	s3,272(sp)
    802004e4:	ee52                	sd	s4,280(sp)
    802004e6:	850a                	mv	a0,sp
    802004e8:	f1dff0ef          	jal	ra,80200404 <trap>

00000000802004ec <__trapret>:
    802004ec:	6492                	ld	s1,256(sp)
    802004ee:	6932                	ld	s2,264(sp)
    802004f0:	10049073          	csrw	sstatus,s1
    802004f4:	14191073          	csrw	sepc,s2
    802004f8:	60a2                	ld	ra,8(sp)
    802004fa:	61e2                	ld	gp,24(sp)
    802004fc:	7202                	ld	tp,32(sp)
    802004fe:	72a2                	ld	t0,40(sp)
    80200500:	7342                	ld	t1,48(sp)
    80200502:	73e2                	ld	t2,56(sp)
    80200504:	6406                	ld	s0,64(sp)
    80200506:	64a6                	ld	s1,72(sp)
    80200508:	6546                	ld	a0,80(sp)
    8020050a:	65e6                	ld	a1,88(sp)
    8020050c:	7606                	ld	a2,96(sp)
    8020050e:	76a6                	ld	a3,104(sp)
    80200510:	7746                	ld	a4,112(sp)
    80200512:	77e6                	ld	a5,120(sp)
    80200514:	680a                	ld	a6,128(sp)
    80200516:	68aa                	ld	a7,136(sp)
    80200518:	694a                	ld	s2,144(sp)
    8020051a:	69ea                	ld	s3,152(sp)
    8020051c:	7a0a                	ld	s4,160(sp)
    8020051e:	7aaa                	ld	s5,168(sp)
    80200520:	7b4a                	ld	s6,176(sp)
    80200522:	7bea                	ld	s7,184(sp)
    80200524:	6c0e                	ld	s8,192(sp)
    80200526:	6cae                	ld	s9,200(sp)
    80200528:	6d4e                	ld	s10,208(sp)
    8020052a:	6dee                	ld	s11,216(sp)
    8020052c:	7e0e                	ld	t3,224(sp)
    8020052e:	7eae                	ld	t4,232(sp)
    80200530:	7f4e                	ld	t5,240(sp)
    80200532:	7fee                	ld	t6,248(sp)
    80200534:	6142                	ld	sp,16(sp)
    80200536:	10200073          	sret

000000008020053a <printnum>:
    8020053a:	02069813          	slli	a6,a3,0x20
    8020053e:	7179                	addi	sp,sp,-48
    80200540:	02085813          	srli	a6,a6,0x20
    80200544:	e052                	sd	s4,0(sp)
    80200546:	03067a33          	remu	s4,a2,a6
    8020054a:	f022                	sd	s0,32(sp)
    8020054c:	ec26                	sd	s1,24(sp)
    8020054e:	e84a                	sd	s2,16(sp)
    80200550:	f406                	sd	ra,40(sp)
    80200552:	e44e                	sd	s3,8(sp)
    80200554:	84aa                	mv	s1,a0
    80200556:	892e                	mv	s2,a1
    80200558:	fff7041b          	addiw	s0,a4,-1
    8020055c:	2a01                	sext.w	s4,s4
    8020055e:	03067e63          	bgeu	a2,a6,8020059a <printnum+0x60>
    80200562:	89be                	mv	s3,a5
    80200564:	00805763          	blez	s0,80200572 <printnum+0x38>
    80200568:	347d                	addiw	s0,s0,-1
    8020056a:	85ca                	mv	a1,s2
    8020056c:	854e                	mv	a0,s3
    8020056e:	9482                	jalr	s1
    80200570:	fc65                	bnez	s0,80200568 <printnum+0x2e>
    80200572:	1a02                	slli	s4,s4,0x20
    80200574:	00001797          	auipc	a5,0x1
    80200578:	95478793          	addi	a5,a5,-1708 # 80200ec8 <etext+0x53e>
    8020057c:	020a5a13          	srli	s4,s4,0x20
    80200580:	9a3e                	add	s4,s4,a5
    80200582:	7402                	ld	s0,32(sp)
    80200584:	000a4503          	lbu	a0,0(s4)
    80200588:	70a2                	ld	ra,40(sp)
    8020058a:	69a2                	ld	s3,8(sp)
    8020058c:	6a02                	ld	s4,0(sp)
    8020058e:	85ca                	mv	a1,s2
    80200590:	87a6                	mv	a5,s1
    80200592:	6942                	ld	s2,16(sp)
    80200594:	64e2                	ld	s1,24(sp)
    80200596:	6145                	addi	sp,sp,48
    80200598:	8782                	jr	a5
    8020059a:	03065633          	divu	a2,a2,a6
    8020059e:	8722                	mv	a4,s0
    802005a0:	f9bff0ef          	jal	ra,8020053a <printnum>
    802005a4:	b7f9                	j	80200572 <printnum+0x38>

00000000802005a6 <vprintfmt>:
    802005a6:	7119                	addi	sp,sp,-128
    802005a8:	f4a6                	sd	s1,104(sp)
    802005aa:	f0ca                	sd	s2,96(sp)
    802005ac:	ecce                	sd	s3,88(sp)
    802005ae:	e8d2                	sd	s4,80(sp)
    802005b0:	e4d6                	sd	s5,72(sp)
    802005b2:	e0da                	sd	s6,64(sp)
    802005b4:	fc5e                	sd	s7,56(sp)
    802005b6:	f06a                	sd	s10,32(sp)
    802005b8:	fc86                	sd	ra,120(sp)
    802005ba:	f8a2                	sd	s0,112(sp)
    802005bc:	f862                	sd	s8,48(sp)
    802005be:	f466                	sd	s9,40(sp)
    802005c0:	ec6e                	sd	s11,24(sp)
    802005c2:	892a                	mv	s2,a0
    802005c4:	84ae                	mv	s1,a1
    802005c6:	8d32                	mv	s10,a2
    802005c8:	8a36                	mv	s4,a3
    802005ca:	02500993          	li	s3,37
    802005ce:	5b7d                	li	s6,-1
    802005d0:	00001a97          	auipc	s5,0x1
    802005d4:	92ca8a93          	addi	s5,s5,-1748 # 80200efc <etext+0x572>
    802005d8:	00001b97          	auipc	s7,0x1
    802005dc:	b00b8b93          	addi	s7,s7,-1280 # 802010d8 <error_string>
    802005e0:	000d4503          	lbu	a0,0(s10)
    802005e4:	001d0413          	addi	s0,s10,1
    802005e8:	01350a63          	beq	a0,s3,802005fc <vprintfmt+0x56>
    802005ec:	c121                	beqz	a0,8020062c <vprintfmt+0x86>
    802005ee:	85a6                	mv	a1,s1
    802005f0:	0405                	addi	s0,s0,1
    802005f2:	9902                	jalr	s2
    802005f4:	fff44503          	lbu	a0,-1(s0)
    802005f8:	ff351ae3          	bne	a0,s3,802005ec <vprintfmt+0x46>
    802005fc:	00044603          	lbu	a2,0(s0)
    80200600:	02000793          	li	a5,32
    80200604:	4c81                	li	s9,0
    80200606:	4881                	li	a7,0
    80200608:	5c7d                	li	s8,-1
    8020060a:	5dfd                	li	s11,-1
    8020060c:	05500513          	li	a0,85
    80200610:	4825                	li	a6,9
    80200612:	fdd6059b          	addiw	a1,a2,-35
    80200616:	0ff5f593          	andi	a1,a1,255
    8020061a:	00140d13          	addi	s10,s0,1
    8020061e:	04b56263          	bltu	a0,a1,80200662 <vprintfmt+0xbc>
    80200622:	058a                	slli	a1,a1,0x2
    80200624:	95d6                	add	a1,a1,s5
    80200626:	4194                	lw	a3,0(a1)
    80200628:	96d6                	add	a3,a3,s5
    8020062a:	8682                	jr	a3
    8020062c:	70e6                	ld	ra,120(sp)
    8020062e:	7446                	ld	s0,112(sp)
    80200630:	74a6                	ld	s1,104(sp)
    80200632:	7906                	ld	s2,96(sp)
    80200634:	69e6                	ld	s3,88(sp)
    80200636:	6a46                	ld	s4,80(sp)
    80200638:	6aa6                	ld	s5,72(sp)
    8020063a:	6b06                	ld	s6,64(sp)
    8020063c:	7be2                	ld	s7,56(sp)
    8020063e:	7c42                	ld	s8,48(sp)
    80200640:	7ca2                	ld	s9,40(sp)
    80200642:	7d02                	ld	s10,32(sp)
    80200644:	6de2                	ld	s11,24(sp)
    80200646:	6109                	addi	sp,sp,128
    80200648:	8082                	ret
    8020064a:	87b2                	mv	a5,a2
    8020064c:	00144603          	lbu	a2,1(s0)
    80200650:	846a                	mv	s0,s10
    80200652:	00140d13          	addi	s10,s0,1
    80200656:	fdd6059b          	addiw	a1,a2,-35
    8020065a:	0ff5f593          	andi	a1,a1,255
    8020065e:	fcb572e3          	bgeu	a0,a1,80200622 <vprintfmt+0x7c>
    80200662:	85a6                	mv	a1,s1
    80200664:	02500513          	li	a0,37
    80200668:	9902                	jalr	s2
    8020066a:	fff44783          	lbu	a5,-1(s0)
    8020066e:	8d22                	mv	s10,s0
    80200670:	f73788e3          	beq	a5,s3,802005e0 <vprintfmt+0x3a>
    80200674:	ffed4783          	lbu	a5,-2(s10)
    80200678:	1d7d                	addi	s10,s10,-1
    8020067a:	ff379de3          	bne	a5,s3,80200674 <vprintfmt+0xce>
    8020067e:	b78d                	j	802005e0 <vprintfmt+0x3a>
    80200680:	fd060c1b          	addiw	s8,a2,-48
    80200684:	00144603          	lbu	a2,1(s0)
    80200688:	846a                	mv	s0,s10
    8020068a:	fd06069b          	addiw	a3,a2,-48
    8020068e:	0006059b          	sext.w	a1,a2
    80200692:	02d86463          	bltu	a6,a3,802006ba <vprintfmt+0x114>
    80200696:	00144603          	lbu	a2,1(s0)
    8020069a:	002c169b          	slliw	a3,s8,0x2
    8020069e:	0186873b          	addw	a4,a3,s8
    802006a2:	0017171b          	slliw	a4,a4,0x1
    802006a6:	9f2d                	addw	a4,a4,a1
    802006a8:	fd06069b          	addiw	a3,a2,-48
    802006ac:	0405                	addi	s0,s0,1
    802006ae:	fd070c1b          	addiw	s8,a4,-48
    802006b2:	0006059b          	sext.w	a1,a2
    802006b6:	fed870e3          	bgeu	a6,a3,80200696 <vprintfmt+0xf0>
    802006ba:	f40ddce3          	bgez	s11,80200612 <vprintfmt+0x6c>
    802006be:	8de2                	mv	s11,s8
    802006c0:	5c7d                	li	s8,-1
    802006c2:	bf81                	j	80200612 <vprintfmt+0x6c>
    802006c4:	fffdc693          	not	a3,s11
    802006c8:	96fd                	srai	a3,a3,0x3f
    802006ca:	00ddfdb3          	and	s11,s11,a3
    802006ce:	00144603          	lbu	a2,1(s0)
    802006d2:	2d81                	sext.w	s11,s11
    802006d4:	846a                	mv	s0,s10
    802006d6:	bf35                	j	80200612 <vprintfmt+0x6c>
    802006d8:	000a2c03          	lw	s8,0(s4)
    802006dc:	00144603          	lbu	a2,1(s0)
    802006e0:	0a21                	addi	s4,s4,8
    802006e2:	846a                	mv	s0,s10
    802006e4:	bfd9                	j	802006ba <vprintfmt+0x114>
    802006e6:	4705                	li	a4,1
    802006e8:	008a0593          	addi	a1,s4,8
    802006ec:	01174463          	blt	a4,a7,802006f4 <vprintfmt+0x14e>
    802006f0:	1a088e63          	beqz	a7,802008ac <vprintfmt+0x306>
    802006f4:	000a3603          	ld	a2,0(s4)
    802006f8:	46c1                	li	a3,16
    802006fa:	8a2e                	mv	s4,a1
    802006fc:	2781                	sext.w	a5,a5
    802006fe:	876e                	mv	a4,s11
    80200700:	85a6                	mv	a1,s1
    80200702:	854a                	mv	a0,s2
    80200704:	e37ff0ef          	jal	ra,8020053a <printnum>
    80200708:	bde1                	j	802005e0 <vprintfmt+0x3a>
    8020070a:	000a2503          	lw	a0,0(s4)
    8020070e:	85a6                	mv	a1,s1
    80200710:	0a21                	addi	s4,s4,8
    80200712:	9902                	jalr	s2
    80200714:	b5f1                	j	802005e0 <vprintfmt+0x3a>
    80200716:	4705                	li	a4,1
    80200718:	008a0593          	addi	a1,s4,8
    8020071c:	01174463          	blt	a4,a7,80200724 <vprintfmt+0x17e>
    80200720:	18088163          	beqz	a7,802008a2 <vprintfmt+0x2fc>
    80200724:	000a3603          	ld	a2,0(s4)
    80200728:	46a9                	li	a3,10
    8020072a:	8a2e                	mv	s4,a1
    8020072c:	bfc1                	j	802006fc <vprintfmt+0x156>
    8020072e:	00144603          	lbu	a2,1(s0)
    80200732:	4c85                	li	s9,1
    80200734:	846a                	mv	s0,s10
    80200736:	bdf1                	j	80200612 <vprintfmt+0x6c>
    80200738:	85a6                	mv	a1,s1
    8020073a:	02500513          	li	a0,37
    8020073e:	9902                	jalr	s2
    80200740:	b545                	j	802005e0 <vprintfmt+0x3a>
    80200742:	00144603          	lbu	a2,1(s0)
    80200746:	2885                	addiw	a7,a7,1
    80200748:	846a                	mv	s0,s10
    8020074a:	b5e1                	j	80200612 <vprintfmt+0x6c>
    8020074c:	4705                	li	a4,1
    8020074e:	008a0593          	addi	a1,s4,8
    80200752:	01174463          	blt	a4,a7,8020075a <vprintfmt+0x1b4>
    80200756:	14088163          	beqz	a7,80200898 <vprintfmt+0x2f2>
    8020075a:	000a3603          	ld	a2,0(s4)
    8020075e:	46a1                	li	a3,8
    80200760:	8a2e                	mv	s4,a1
    80200762:	bf69                	j	802006fc <vprintfmt+0x156>
    80200764:	03000513          	li	a0,48
    80200768:	85a6                	mv	a1,s1
    8020076a:	e03e                	sd	a5,0(sp)
    8020076c:	9902                	jalr	s2
    8020076e:	85a6                	mv	a1,s1
    80200770:	07800513          	li	a0,120
    80200774:	9902                	jalr	s2
    80200776:	0a21                	addi	s4,s4,8
    80200778:	6782                	ld	a5,0(sp)
    8020077a:	46c1                	li	a3,16
    8020077c:	ff8a3603          	ld	a2,-8(s4)
    80200780:	bfb5                	j	802006fc <vprintfmt+0x156>
    80200782:	000a3403          	ld	s0,0(s4)
    80200786:	008a0713          	addi	a4,s4,8
    8020078a:	e03a                	sd	a4,0(sp)
    8020078c:	14040263          	beqz	s0,802008d0 <vprintfmt+0x32a>
    80200790:	0fb05763          	blez	s11,8020087e <vprintfmt+0x2d8>
    80200794:	02d00693          	li	a3,45
    80200798:	0cd79163          	bne	a5,a3,8020085a <vprintfmt+0x2b4>
    8020079c:	00044783          	lbu	a5,0(s0)
    802007a0:	0007851b          	sext.w	a0,a5
    802007a4:	cf85                	beqz	a5,802007dc <vprintfmt+0x236>
    802007a6:	00140a13          	addi	s4,s0,1
    802007aa:	05e00413          	li	s0,94
    802007ae:	000c4563          	bltz	s8,802007b8 <vprintfmt+0x212>
    802007b2:	3c7d                	addiw	s8,s8,-1
    802007b4:	036c0263          	beq	s8,s6,802007d8 <vprintfmt+0x232>
    802007b8:	85a6                	mv	a1,s1
    802007ba:	0e0c8e63          	beqz	s9,802008b6 <vprintfmt+0x310>
    802007be:	3781                	addiw	a5,a5,-32
    802007c0:	0ef47b63          	bgeu	s0,a5,802008b6 <vprintfmt+0x310>
    802007c4:	03f00513          	li	a0,63
    802007c8:	9902                	jalr	s2
    802007ca:	000a4783          	lbu	a5,0(s4)
    802007ce:	3dfd                	addiw	s11,s11,-1
    802007d0:	0a05                	addi	s4,s4,1
    802007d2:	0007851b          	sext.w	a0,a5
    802007d6:	ffe1                	bnez	a5,802007ae <vprintfmt+0x208>
    802007d8:	01b05963          	blez	s11,802007ea <vprintfmt+0x244>
    802007dc:	3dfd                	addiw	s11,s11,-1
    802007de:	85a6                	mv	a1,s1
    802007e0:	02000513          	li	a0,32
    802007e4:	9902                	jalr	s2
    802007e6:	fe0d9be3          	bnez	s11,802007dc <vprintfmt+0x236>
    802007ea:	6a02                	ld	s4,0(sp)
    802007ec:	bbd5                	j	802005e0 <vprintfmt+0x3a>
    802007ee:	4705                	li	a4,1
    802007f0:	008a0c93          	addi	s9,s4,8
    802007f4:	01174463          	blt	a4,a7,802007fc <vprintfmt+0x256>
    802007f8:	08088d63          	beqz	a7,80200892 <vprintfmt+0x2ec>
    802007fc:	000a3403          	ld	s0,0(s4)
    80200800:	0a044d63          	bltz	s0,802008ba <vprintfmt+0x314>
    80200804:	8622                	mv	a2,s0
    80200806:	8a66                	mv	s4,s9
    80200808:	46a9                	li	a3,10
    8020080a:	bdcd                	j	802006fc <vprintfmt+0x156>
    8020080c:	000a2783          	lw	a5,0(s4)
    80200810:	4719                	li	a4,6
    80200812:	0a21                	addi	s4,s4,8
    80200814:	41f7d69b          	sraiw	a3,a5,0x1f
    80200818:	8fb5                	xor	a5,a5,a3
    8020081a:	40d786bb          	subw	a3,a5,a3
    8020081e:	02d74163          	blt	a4,a3,80200840 <vprintfmt+0x29a>
    80200822:	00369793          	slli	a5,a3,0x3
    80200826:	97de                	add	a5,a5,s7
    80200828:	639c                	ld	a5,0(a5)
    8020082a:	cb99                	beqz	a5,80200840 <vprintfmt+0x29a>
    8020082c:	86be                	mv	a3,a5
    8020082e:	00000617          	auipc	a2,0x0
    80200832:	6ca60613          	addi	a2,a2,1738 # 80200ef8 <etext+0x56e>
    80200836:	85a6                	mv	a1,s1
    80200838:	854a                	mv	a0,s2
    8020083a:	0ce000ef          	jal	ra,80200908 <printfmt>
    8020083e:	b34d                	j	802005e0 <vprintfmt+0x3a>
    80200840:	00000617          	auipc	a2,0x0
    80200844:	6a860613          	addi	a2,a2,1704 # 80200ee8 <etext+0x55e>
    80200848:	85a6                	mv	a1,s1
    8020084a:	854a                	mv	a0,s2
    8020084c:	0bc000ef          	jal	ra,80200908 <printfmt>
    80200850:	bb41                	j	802005e0 <vprintfmt+0x3a>
    80200852:	00000417          	auipc	s0,0x0
    80200856:	68e40413          	addi	s0,s0,1678 # 80200ee0 <etext+0x556>
    8020085a:	85e2                	mv	a1,s8
    8020085c:	8522                	mv	a0,s0
    8020085e:	e43e                	sd	a5,8(sp)
    80200860:	0fc000ef          	jal	ra,8020095c <strnlen>
    80200864:	40ad8dbb          	subw	s11,s11,a0
    80200868:	01b05b63          	blez	s11,8020087e <vprintfmt+0x2d8>
    8020086c:	67a2                	ld	a5,8(sp)
    8020086e:	00078a1b          	sext.w	s4,a5
    80200872:	3dfd                	addiw	s11,s11,-1
    80200874:	85a6                	mv	a1,s1
    80200876:	8552                	mv	a0,s4
    80200878:	9902                	jalr	s2
    8020087a:	fe0d9ce3          	bnez	s11,80200872 <vprintfmt+0x2cc>
    8020087e:	00044783          	lbu	a5,0(s0)
    80200882:	00140a13          	addi	s4,s0,1
    80200886:	0007851b          	sext.w	a0,a5
    8020088a:	d3a5                	beqz	a5,802007ea <vprintfmt+0x244>
    8020088c:	05e00413          	li	s0,94
    80200890:	bf39                	j	802007ae <vprintfmt+0x208>
    80200892:	000a2403          	lw	s0,0(s4)
    80200896:	b7ad                	j	80200800 <vprintfmt+0x25a>
    80200898:	000a6603          	lwu	a2,0(s4)
    8020089c:	46a1                	li	a3,8
    8020089e:	8a2e                	mv	s4,a1
    802008a0:	bdb1                	j	802006fc <vprintfmt+0x156>
    802008a2:	000a6603          	lwu	a2,0(s4)
    802008a6:	46a9                	li	a3,10
    802008a8:	8a2e                	mv	s4,a1
    802008aa:	bd89                	j	802006fc <vprintfmt+0x156>
    802008ac:	000a6603          	lwu	a2,0(s4)
    802008b0:	46c1                	li	a3,16
    802008b2:	8a2e                	mv	s4,a1
    802008b4:	b5a1                	j	802006fc <vprintfmt+0x156>
    802008b6:	9902                	jalr	s2
    802008b8:	bf09                	j	802007ca <vprintfmt+0x224>
    802008ba:	85a6                	mv	a1,s1
    802008bc:	02d00513          	li	a0,45
    802008c0:	e03e                	sd	a5,0(sp)
    802008c2:	9902                	jalr	s2
    802008c4:	6782                	ld	a5,0(sp)
    802008c6:	8a66                	mv	s4,s9
    802008c8:	40800633          	neg	a2,s0
    802008cc:	46a9                	li	a3,10
    802008ce:	b53d                	j	802006fc <vprintfmt+0x156>
    802008d0:	03b05163          	blez	s11,802008f2 <vprintfmt+0x34c>
    802008d4:	02d00693          	li	a3,45
    802008d8:	f6d79de3          	bne	a5,a3,80200852 <vprintfmt+0x2ac>
    802008dc:	00000417          	auipc	s0,0x0
    802008e0:	60440413          	addi	s0,s0,1540 # 80200ee0 <etext+0x556>
    802008e4:	02800793          	li	a5,40
    802008e8:	02800513          	li	a0,40
    802008ec:	00140a13          	addi	s4,s0,1
    802008f0:	bd6d                	j	802007aa <vprintfmt+0x204>
    802008f2:	00000a17          	auipc	s4,0x0
    802008f6:	5efa0a13          	addi	s4,s4,1519 # 80200ee1 <etext+0x557>
    802008fa:	02800513          	li	a0,40
    802008fe:	02800793          	li	a5,40
    80200902:	05e00413          	li	s0,94
    80200906:	b565                	j	802007ae <vprintfmt+0x208>

0000000080200908 <printfmt>:
    80200908:	715d                	addi	sp,sp,-80
    8020090a:	02810313          	addi	t1,sp,40
    8020090e:	f436                	sd	a3,40(sp)
    80200910:	869a                	mv	a3,t1
    80200912:	ec06                	sd	ra,24(sp)
    80200914:	f83a                	sd	a4,48(sp)
    80200916:	fc3e                	sd	a5,56(sp)
    80200918:	e0c2                	sd	a6,64(sp)
    8020091a:	e4c6                	sd	a7,72(sp)
    8020091c:	e41a                	sd	t1,8(sp)
    8020091e:	c89ff0ef          	jal	ra,802005a6 <vprintfmt>
    80200922:	60e2                	ld	ra,24(sp)
    80200924:	6161                	addi	sp,sp,80
    80200926:	8082                	ret

0000000080200928 <sbi_console_putchar>:
    80200928:	4781                	li	a5,0
    8020092a:	00003717          	auipc	a4,0x3
    8020092e:	6d673703          	ld	a4,1750(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    80200932:	88ba                	mv	a7,a4
    80200934:	852a                	mv	a0,a0
    80200936:	85be                	mv	a1,a5
    80200938:	863e                	mv	a2,a5
    8020093a:	00000073          	ecall
    8020093e:	87aa                	mv	a5,a0
    80200940:	8082                	ret

0000000080200942 <sbi_set_timer>:
    80200942:	4781                	li	a5,0
    80200944:	00003717          	auipc	a4,0x3
    80200948:	6cc73703          	ld	a4,1740(a4) # 80204010 <SBI_SET_TIMER>
    8020094c:	88ba                	mv	a7,a4
    8020094e:	852a                	mv	a0,a0
    80200950:	85be                	mv	a1,a5
    80200952:	863e                	mv	a2,a5
    80200954:	00000073          	ecall
    80200958:	87aa                	mv	a5,a0
    8020095a:	8082                	ret

000000008020095c <strnlen>:
    8020095c:	4781                	li	a5,0
    8020095e:	e589                	bnez	a1,80200968 <strnlen+0xc>
    80200960:	a811                	j	80200974 <strnlen+0x18>
    80200962:	0785                	addi	a5,a5,1
    80200964:	00f58863          	beq	a1,a5,80200974 <strnlen+0x18>
    80200968:	00f50733          	add	a4,a0,a5
    8020096c:	00074703          	lbu	a4,0(a4)
    80200970:	fb6d                	bnez	a4,80200962 <strnlen+0x6>
    80200972:	85be                	mv	a1,a5
    80200974:	852e                	mv	a0,a1
    80200976:	8082                	ret

0000000080200978 <memset>:
    80200978:	ca01                	beqz	a2,80200988 <memset+0x10>
    8020097a:	962a                	add	a2,a2,a0
    8020097c:	87aa                	mv	a5,a0
    8020097e:	0785                	addi	a5,a5,1
    80200980:	feb78fa3          	sb	a1,-1(a5)
    80200984:	fec79de3          	bne	a5,a2,8020097e <memset+0x6>
    80200988:	8082                	ret
