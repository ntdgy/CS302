
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	00650513          	addi	a0,a0,6 # 80204010 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	00e60613          	addi	a2,a2,14 # 80204020 <end>
    8020001a:	1141                	addi	sp,sp,-16
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	165000ef          	jal	ra,80200986 <memset>
    80200026:	00001517          	auipc	a0,0x1
    8020002a:	97250513          	addi	a0,a0,-1678 # 80200998 <etext>
    8020002e:	072000ef          	jal	ra,802000a0 <cputs>
    80200032:	0fe000ef          	jal	ra,80200130 <idt_init>
    80200036:	0f4000ef          	jal	ra,8020012a <intr_enable>
    8020003a:	00001517          	auipc	a0,0x1
    8020003e:	97650513          	addi	a0,a0,-1674 # 802009b0 <etext+0x18>
    80200042:	05e000ef          	jal	ra,802000a0 <cputs>
    80200046:	10b000ef          	jal	ra,80200950 <sbi_shutdown>
    8020004a:	096000ef          	jal	ra,802000e0 <clock_init>
    8020004e:	a001                	j	8020004e <kern_init+0x44>

0000000080200050 <cputch>:
    80200050:	1141                	addi	sp,sp,-16
    80200052:	e022                	sd	s0,0(sp)
    80200054:	e406                	sd	ra,8(sp)
    80200056:	842e                	mv	s0,a1
    80200058:	0ca000ef          	jal	ra,80200122 <cons_putc>
    8020005c:	401c                	lw	a5,0(s0)
    8020005e:	60a2                	ld	ra,8(sp)
    80200060:	2785                	addiw	a5,a5,1
    80200062:	c01c                	sw	a5,0(s0)
    80200064:	6402                	ld	s0,0(sp)
    80200066:	0141                	addi	sp,sp,16
    80200068:	8082                	ret

000000008020006a <cprintf>:
    8020006a:	711d                	addi	sp,sp,-96
    8020006c:	02810313          	addi	t1,sp,40 # 80204028 <end+0x8>
    80200070:	8e2a                	mv	t3,a0
    80200072:	f42e                	sd	a1,40(sp)
    80200074:	f832                	sd	a2,48(sp)
    80200076:	fc36                	sd	a3,56(sp)
    80200078:	00000517          	auipc	a0,0x0
    8020007c:	fd850513          	addi	a0,a0,-40 # 80200050 <cputch>
    80200080:	004c                	addi	a1,sp,4
    80200082:	869a                	mv	a3,t1
    80200084:	8672                	mv	a2,t3
    80200086:	ec06                	sd	ra,24(sp)
    80200088:	e0ba                	sd	a4,64(sp)
    8020008a:	e4be                	sd	a5,72(sp)
    8020008c:	e8c2                	sd	a6,80(sp)
    8020008e:	ecc6                	sd	a7,88(sp)
    80200090:	e41a                	sd	t1,8(sp)
    80200092:	c202                	sw	zero,4(sp)
    80200094:	506000ef          	jal	ra,8020059a <vprintfmt>
    80200098:	60e2                	ld	ra,24(sp)
    8020009a:	4512                	lw	a0,4(sp)
    8020009c:	6125                	addi	sp,sp,96
    8020009e:	8082                	ret

00000000802000a0 <cputs>:
    802000a0:	1101                	addi	sp,sp,-32
    802000a2:	e822                	sd	s0,16(sp)
    802000a4:	ec06                	sd	ra,24(sp)
    802000a6:	e426                	sd	s1,8(sp)
    802000a8:	842a                	mv	s0,a0
    802000aa:	00054503          	lbu	a0,0(a0)
    802000ae:	c51d                	beqz	a0,802000dc <cputs+0x3c>
    802000b0:	0405                	addi	s0,s0,1
    802000b2:	4485                	li	s1,1
    802000b4:	9c81                	subw	s1,s1,s0
    802000b6:	06c000ef          	jal	ra,80200122 <cons_putc>
    802000ba:	00044503          	lbu	a0,0(s0)
    802000be:	008487bb          	addw	a5,s1,s0
    802000c2:	0405                	addi	s0,s0,1
    802000c4:	f96d                	bnez	a0,802000b6 <cputs+0x16>
    802000c6:	0017841b          	addiw	s0,a5,1
    802000ca:	4529                	li	a0,10
    802000cc:	056000ef          	jal	ra,80200122 <cons_putc>
    802000d0:	60e2                	ld	ra,24(sp)
    802000d2:	8522                	mv	a0,s0
    802000d4:	6442                	ld	s0,16(sp)
    802000d6:	64a2                	ld	s1,8(sp)
    802000d8:	6105                	addi	sp,sp,32
    802000da:	8082                	ret
    802000dc:	4405                	li	s0,1
    802000de:	b7f5                	j	802000ca <cputs+0x2a>

00000000802000e0 <clock_init>:
    802000e0:	1141                	addi	sp,sp,-16
    802000e2:	e406                	sd	ra,8(sp)
    802000e4:	02000793          	li	a5,32
    802000e8:	1047a7f3          	csrrs	a5,sie,a5
    802000ec:	c0102573          	rdtime	a0
    802000f0:	67e1                	lui	a5,0x18
    802000f2:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    802000f6:	953e                	add	a0,a0,a5
    802000f8:	03f000ef          	jal	ra,80200936 <sbi_set_timer>
    802000fc:	60a2                	ld	ra,8(sp)
    802000fe:	00004797          	auipc	a5,0x4
    80200102:	f007b923          	sd	zero,-238(a5) # 80204010 <ticks>
    80200106:	00001517          	auipc	a0,0x1
    8020010a:	8c250513          	addi	a0,a0,-1854 # 802009c8 <etext+0x30>
    8020010e:	0141                	addi	sp,sp,16
    80200110:	bfa9                	j	8020006a <cprintf>

0000000080200112 <clock_set_next_event>:
    80200112:	c0102573          	rdtime	a0
    80200116:	67e1                	lui	a5,0x18
    80200118:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020011c:	953e                	add	a0,a0,a5
    8020011e:	0190006f          	j	80200936 <sbi_set_timer>

0000000080200122 <cons_putc>:
    80200122:	0ff57513          	andi	a0,a0,255
    80200126:	7f60006f          	j	8020091c <sbi_console_putchar>

000000008020012a <intr_enable>:
    8020012a:	100167f3          	csrrsi	a5,sstatus,2
    8020012e:	8082                	ret

0000000080200130 <idt_init>:
    80200130:	00000797          	auipc	a5,0x0
    80200134:	34878793          	addi	a5,a5,840 # 80200478 <__alltraps>
    80200138:	10579073          	csrw	stvec,a5
    8020013c:	8082                	ret

000000008020013e <print_regs>:
    8020013e:	610c                	ld	a1,0(a0)
    80200140:	1141                	addi	sp,sp,-16
    80200142:	e022                	sd	s0,0(sp)
    80200144:	842a                	mv	s0,a0
    80200146:	00001517          	auipc	a0,0x1
    8020014a:	8a250513          	addi	a0,a0,-1886 # 802009e8 <etext+0x50>
    8020014e:	e406                	sd	ra,8(sp)
    80200150:	f1bff0ef          	jal	ra,8020006a <cprintf>
    80200154:	640c                	ld	a1,8(s0)
    80200156:	00001517          	auipc	a0,0x1
    8020015a:	8aa50513          	addi	a0,a0,-1878 # 80200a00 <etext+0x68>
    8020015e:	f0dff0ef          	jal	ra,8020006a <cprintf>
    80200162:	680c                	ld	a1,16(s0)
    80200164:	00001517          	auipc	a0,0x1
    80200168:	8b450513          	addi	a0,a0,-1868 # 80200a18 <etext+0x80>
    8020016c:	effff0ef          	jal	ra,8020006a <cprintf>
    80200170:	6c0c                	ld	a1,24(s0)
    80200172:	00001517          	auipc	a0,0x1
    80200176:	8be50513          	addi	a0,a0,-1858 # 80200a30 <etext+0x98>
    8020017a:	ef1ff0ef          	jal	ra,8020006a <cprintf>
    8020017e:	700c                	ld	a1,32(s0)
    80200180:	00001517          	auipc	a0,0x1
    80200184:	8c850513          	addi	a0,a0,-1848 # 80200a48 <etext+0xb0>
    80200188:	ee3ff0ef          	jal	ra,8020006a <cprintf>
    8020018c:	740c                	ld	a1,40(s0)
    8020018e:	00001517          	auipc	a0,0x1
    80200192:	8d250513          	addi	a0,a0,-1838 # 80200a60 <etext+0xc8>
    80200196:	ed5ff0ef          	jal	ra,8020006a <cprintf>
    8020019a:	780c                	ld	a1,48(s0)
    8020019c:	00001517          	auipc	a0,0x1
    802001a0:	8dc50513          	addi	a0,a0,-1828 # 80200a78 <etext+0xe0>
    802001a4:	ec7ff0ef          	jal	ra,8020006a <cprintf>
    802001a8:	7c0c                	ld	a1,56(s0)
    802001aa:	00001517          	auipc	a0,0x1
    802001ae:	8e650513          	addi	a0,a0,-1818 # 80200a90 <etext+0xf8>
    802001b2:	eb9ff0ef          	jal	ra,8020006a <cprintf>
    802001b6:	602c                	ld	a1,64(s0)
    802001b8:	00001517          	auipc	a0,0x1
    802001bc:	8f050513          	addi	a0,a0,-1808 # 80200aa8 <etext+0x110>
    802001c0:	eabff0ef          	jal	ra,8020006a <cprintf>
    802001c4:	642c                	ld	a1,72(s0)
    802001c6:	00001517          	auipc	a0,0x1
    802001ca:	8fa50513          	addi	a0,a0,-1798 # 80200ac0 <etext+0x128>
    802001ce:	e9dff0ef          	jal	ra,8020006a <cprintf>
    802001d2:	682c                	ld	a1,80(s0)
    802001d4:	00001517          	auipc	a0,0x1
    802001d8:	90450513          	addi	a0,a0,-1788 # 80200ad8 <etext+0x140>
    802001dc:	e8fff0ef          	jal	ra,8020006a <cprintf>
    802001e0:	6c2c                	ld	a1,88(s0)
    802001e2:	00001517          	auipc	a0,0x1
    802001e6:	90e50513          	addi	a0,a0,-1778 # 80200af0 <etext+0x158>
    802001ea:	e81ff0ef          	jal	ra,8020006a <cprintf>
    802001ee:	702c                	ld	a1,96(s0)
    802001f0:	00001517          	auipc	a0,0x1
    802001f4:	91850513          	addi	a0,a0,-1768 # 80200b08 <etext+0x170>
    802001f8:	e73ff0ef          	jal	ra,8020006a <cprintf>
    802001fc:	742c                	ld	a1,104(s0)
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	92250513          	addi	a0,a0,-1758 # 80200b20 <etext+0x188>
    80200206:	e65ff0ef          	jal	ra,8020006a <cprintf>
    8020020a:	782c                	ld	a1,112(s0)
    8020020c:	00001517          	auipc	a0,0x1
    80200210:	92c50513          	addi	a0,a0,-1748 # 80200b38 <etext+0x1a0>
    80200214:	e57ff0ef          	jal	ra,8020006a <cprintf>
    80200218:	7c2c                	ld	a1,120(s0)
    8020021a:	00001517          	auipc	a0,0x1
    8020021e:	93650513          	addi	a0,a0,-1738 # 80200b50 <etext+0x1b8>
    80200222:	e49ff0ef          	jal	ra,8020006a <cprintf>
    80200226:	604c                	ld	a1,128(s0)
    80200228:	00001517          	auipc	a0,0x1
    8020022c:	94050513          	addi	a0,a0,-1728 # 80200b68 <etext+0x1d0>
    80200230:	e3bff0ef          	jal	ra,8020006a <cprintf>
    80200234:	644c                	ld	a1,136(s0)
    80200236:	00001517          	auipc	a0,0x1
    8020023a:	94a50513          	addi	a0,a0,-1718 # 80200b80 <etext+0x1e8>
    8020023e:	e2dff0ef          	jal	ra,8020006a <cprintf>
    80200242:	684c                	ld	a1,144(s0)
    80200244:	00001517          	auipc	a0,0x1
    80200248:	95450513          	addi	a0,a0,-1708 # 80200b98 <etext+0x200>
    8020024c:	e1fff0ef          	jal	ra,8020006a <cprintf>
    80200250:	6c4c                	ld	a1,152(s0)
    80200252:	00001517          	auipc	a0,0x1
    80200256:	95e50513          	addi	a0,a0,-1698 # 80200bb0 <etext+0x218>
    8020025a:	e11ff0ef          	jal	ra,8020006a <cprintf>
    8020025e:	704c                	ld	a1,160(s0)
    80200260:	00001517          	auipc	a0,0x1
    80200264:	96850513          	addi	a0,a0,-1688 # 80200bc8 <etext+0x230>
    80200268:	e03ff0ef          	jal	ra,8020006a <cprintf>
    8020026c:	744c                	ld	a1,168(s0)
    8020026e:	00001517          	auipc	a0,0x1
    80200272:	97250513          	addi	a0,a0,-1678 # 80200be0 <etext+0x248>
    80200276:	df5ff0ef          	jal	ra,8020006a <cprintf>
    8020027a:	784c                	ld	a1,176(s0)
    8020027c:	00001517          	auipc	a0,0x1
    80200280:	97c50513          	addi	a0,a0,-1668 # 80200bf8 <etext+0x260>
    80200284:	de7ff0ef          	jal	ra,8020006a <cprintf>
    80200288:	7c4c                	ld	a1,184(s0)
    8020028a:	00001517          	auipc	a0,0x1
    8020028e:	98650513          	addi	a0,a0,-1658 # 80200c10 <etext+0x278>
    80200292:	dd9ff0ef          	jal	ra,8020006a <cprintf>
    80200296:	606c                	ld	a1,192(s0)
    80200298:	00001517          	auipc	a0,0x1
    8020029c:	99050513          	addi	a0,a0,-1648 # 80200c28 <etext+0x290>
    802002a0:	dcbff0ef          	jal	ra,8020006a <cprintf>
    802002a4:	646c                	ld	a1,200(s0)
    802002a6:	00001517          	auipc	a0,0x1
    802002aa:	99a50513          	addi	a0,a0,-1638 # 80200c40 <etext+0x2a8>
    802002ae:	dbdff0ef          	jal	ra,8020006a <cprintf>
    802002b2:	686c                	ld	a1,208(s0)
    802002b4:	00001517          	auipc	a0,0x1
    802002b8:	9a450513          	addi	a0,a0,-1628 # 80200c58 <etext+0x2c0>
    802002bc:	dafff0ef          	jal	ra,8020006a <cprintf>
    802002c0:	6c6c                	ld	a1,216(s0)
    802002c2:	00001517          	auipc	a0,0x1
    802002c6:	9ae50513          	addi	a0,a0,-1618 # 80200c70 <etext+0x2d8>
    802002ca:	da1ff0ef          	jal	ra,8020006a <cprintf>
    802002ce:	706c                	ld	a1,224(s0)
    802002d0:	00001517          	auipc	a0,0x1
    802002d4:	9b850513          	addi	a0,a0,-1608 # 80200c88 <etext+0x2f0>
    802002d8:	d93ff0ef          	jal	ra,8020006a <cprintf>
    802002dc:	746c                	ld	a1,232(s0)
    802002de:	00001517          	auipc	a0,0x1
    802002e2:	9c250513          	addi	a0,a0,-1598 # 80200ca0 <etext+0x308>
    802002e6:	d85ff0ef          	jal	ra,8020006a <cprintf>
    802002ea:	786c                	ld	a1,240(s0)
    802002ec:	00001517          	auipc	a0,0x1
    802002f0:	9cc50513          	addi	a0,a0,-1588 # 80200cb8 <etext+0x320>
    802002f4:	d77ff0ef          	jal	ra,8020006a <cprintf>
    802002f8:	7c6c                	ld	a1,248(s0)
    802002fa:	6402                	ld	s0,0(sp)
    802002fc:	60a2                	ld	ra,8(sp)
    802002fe:	00001517          	auipc	a0,0x1
    80200302:	9d250513          	addi	a0,a0,-1582 # 80200cd0 <etext+0x338>
    80200306:	0141                	addi	sp,sp,16
    80200308:	b38d                	j	8020006a <cprintf>

000000008020030a <print_trapframe>:
    8020030a:	1141                	addi	sp,sp,-16
    8020030c:	e022                	sd	s0,0(sp)
    8020030e:	85aa                	mv	a1,a0
    80200310:	842a                	mv	s0,a0
    80200312:	00001517          	auipc	a0,0x1
    80200316:	9d650513          	addi	a0,a0,-1578 # 80200ce8 <etext+0x350>
    8020031a:	e406                	sd	ra,8(sp)
    8020031c:	d4fff0ef          	jal	ra,8020006a <cprintf>
    80200320:	8522                	mv	a0,s0
    80200322:	e1dff0ef          	jal	ra,8020013e <print_regs>
    80200326:	10043583          	ld	a1,256(s0)
    8020032a:	00001517          	auipc	a0,0x1
    8020032e:	9d650513          	addi	a0,a0,-1578 # 80200d00 <etext+0x368>
    80200332:	d39ff0ef          	jal	ra,8020006a <cprintf>
    80200336:	10843583          	ld	a1,264(s0)
    8020033a:	00001517          	auipc	a0,0x1
    8020033e:	9de50513          	addi	a0,a0,-1570 # 80200d18 <etext+0x380>
    80200342:	d29ff0ef          	jal	ra,8020006a <cprintf>
    80200346:	11043583          	ld	a1,272(s0)
    8020034a:	00001517          	auipc	a0,0x1
    8020034e:	9e650513          	addi	a0,a0,-1562 # 80200d30 <etext+0x398>
    80200352:	d19ff0ef          	jal	ra,8020006a <cprintf>
    80200356:	11843583          	ld	a1,280(s0)
    8020035a:	6402                	ld	s0,0(sp)
    8020035c:	60a2                	ld	ra,8(sp)
    8020035e:	00001517          	auipc	a0,0x1
    80200362:	9ea50513          	addi	a0,a0,-1558 # 80200d48 <etext+0x3b0>
    80200366:	0141                	addi	sp,sp,16
    80200368:	b309                	j	8020006a <cprintf>

000000008020036a <interrupt_handler>:
    8020036a:	11853783          	ld	a5,280(a0)
    8020036e:	472d                	li	a4,11
    80200370:	0786                	slli	a5,a5,0x1
    80200372:	8385                	srli	a5,a5,0x1
    80200374:	06f76763          	bltu	a4,a5,802003e2 <interrupt_handler+0x78>
    80200378:	00001717          	auipc	a4,0x1
    8020037c:	a9870713          	addi	a4,a4,-1384 # 80200e10 <etext+0x478>
    80200380:	078a                	slli	a5,a5,0x2
    80200382:	97ba                	add	a5,a5,a4
    80200384:	439c                	lw	a5,0(a5)
    80200386:	97ba                	add	a5,a5,a4
    80200388:	8782                	jr	a5
    8020038a:	00001517          	auipc	a0,0x1
    8020038e:	a3650513          	addi	a0,a0,-1482 # 80200dc0 <etext+0x428>
    80200392:	b9e1                	j	8020006a <cprintf>
    80200394:	00001517          	auipc	a0,0x1
    80200398:	a0c50513          	addi	a0,a0,-1524 # 80200da0 <etext+0x408>
    8020039c:	b1f9                	j	8020006a <cprintf>
    8020039e:	00001517          	auipc	a0,0x1
    802003a2:	9c250513          	addi	a0,a0,-1598 # 80200d60 <etext+0x3c8>
    802003a6:	b1d1                	j	8020006a <cprintf>
    802003a8:	00001517          	auipc	a0,0x1
    802003ac:	9d850513          	addi	a0,a0,-1576 # 80200d80 <etext+0x3e8>
    802003b0:	b96d                	j	8020006a <cprintf>
    802003b2:	1141                	addi	sp,sp,-16
    802003b4:	e406                	sd	ra,8(sp)
    802003b6:	d5dff0ef          	jal	ra,80200112 <clock_set_next_event>
    802003ba:	00004697          	auipc	a3,0x4
    802003be:	c5668693          	addi	a3,a3,-938 # 80204010 <ticks>
    802003c2:	629c                	ld	a5,0(a3)
    802003c4:	06400713          	li	a4,100
    802003c8:	0785                	addi	a5,a5,1
    802003ca:	02e7f733          	remu	a4,a5,a4
    802003ce:	e29c                	sd	a5,0(a3)
    802003d0:	cb11                	beqz	a4,802003e4 <interrupt_handler+0x7a>
    802003d2:	60a2                	ld	ra,8(sp)
    802003d4:	0141                	addi	sp,sp,16
    802003d6:	8082                	ret
    802003d8:	00001517          	auipc	a0,0x1
    802003dc:	a1850513          	addi	a0,a0,-1512 # 80200df0 <etext+0x458>
    802003e0:	b169                	j	8020006a <cprintf>
    802003e2:	b725                	j	8020030a <print_trapframe>
    802003e4:	60a2                	ld	ra,8(sp)
    802003e6:	06400593          	li	a1,100
    802003ea:	00001517          	auipc	a0,0x1
    802003ee:	9f650513          	addi	a0,a0,-1546 # 80200de0 <etext+0x448>
    802003f2:	0141                	addi	sp,sp,16
    802003f4:	b99d                	j	8020006a <cprintf>

00000000802003f6 <trap>:
    802003f6:	11853783          	ld	a5,280(a0)
    802003fa:	0407cc63          	bltz	a5,80200452 <trap+0x5c>
    802003fe:	1141                	addi	sp,sp,-16
    80200400:	e022                	sd	s0,0(sp)
    80200402:	e406                	sd	ra,8(sp)
    80200404:	470d                	li	a4,3
    80200406:	842a                	mv	s0,a0
    80200408:	04e78663          	beq	a5,a4,80200454 <trap+0x5e>
    8020040c:	02f76a63          	bltu	a4,a5,80200440 <trap+0x4a>
    80200410:	4705                	li	a4,1
    80200412:	02f77363          	bgeu	a4,a5,80200438 <trap+0x42>
    80200416:	4709                	li	a4,2
    80200418:	02e79863          	bne	a5,a4,80200448 <trap+0x52>
    8020041c:	10853583          	ld	a1,264(a0)
    80200420:	00001517          	auipc	a0,0x1
    80200424:	a2050513          	addi	a0,a0,-1504 # 80200e40 <etext+0x4a8>
    80200428:	4190                	lw	a2,0(a1)
    8020042a:	c41ff0ef          	jal	ra,8020006a <cprintf>
    8020042e:	10843783          	ld	a5,264(s0)
    80200432:	0791                	addi	a5,a5,4
    80200434:	10f43423          	sd	a5,264(s0)
    80200438:	60a2                	ld	ra,8(sp)
    8020043a:	6402                	ld	s0,0(sp)
    8020043c:	0141                	addi	sp,sp,16
    8020043e:	8082                	ret
    80200440:	17f1                	addi	a5,a5,-4
    80200442:	471d                	li	a4,7
    80200444:	fef77ae3          	bgeu	a4,a5,80200438 <trap+0x42>
    80200448:	8522                	mv	a0,s0
    8020044a:	6402                	ld	s0,0(sp)
    8020044c:	60a2                	ld	ra,8(sp)
    8020044e:	0141                	addi	sp,sp,16
    80200450:	bd6d                	j	8020030a <print_trapframe>
    80200452:	bf21                	j	8020036a <interrupt_handler>
    80200454:	10853583          	ld	a1,264(a0)
    80200458:	00001517          	auipc	a0,0x1
    8020045c:	a2050513          	addi	a0,a0,-1504 # 80200e78 <etext+0x4e0>
    80200460:	c0bff0ef          	jal	ra,8020006a <cprintf>
    80200464:	10843783          	ld	a5,264(s0)
    80200468:	60a2                	ld	ra,8(sp)
    8020046a:	0789                	addi	a5,a5,2
    8020046c:	10f43423          	sd	a5,264(s0)
    80200470:	6402                	ld	s0,0(sp)
    80200472:	0141                	addi	sp,sp,16
    80200474:	8082                	ret
	...

0000000080200478 <__alltraps>:
    80200478:	14011073          	csrw	sscratch,sp
    8020047c:	712d                	addi	sp,sp,-288
    8020047e:	e002                	sd	zero,0(sp)
    80200480:	e406                	sd	ra,8(sp)
    80200482:	ec0e                	sd	gp,24(sp)
    80200484:	f012                	sd	tp,32(sp)
    80200486:	f416                	sd	t0,40(sp)
    80200488:	f81a                	sd	t1,48(sp)
    8020048a:	fc1e                	sd	t2,56(sp)
    8020048c:	e0a2                	sd	s0,64(sp)
    8020048e:	e4a6                	sd	s1,72(sp)
    80200490:	e8aa                	sd	a0,80(sp)
    80200492:	ecae                	sd	a1,88(sp)
    80200494:	f0b2                	sd	a2,96(sp)
    80200496:	f4b6                	sd	a3,104(sp)
    80200498:	f8ba                	sd	a4,112(sp)
    8020049a:	fcbe                	sd	a5,120(sp)
    8020049c:	e142                	sd	a6,128(sp)
    8020049e:	e546                	sd	a7,136(sp)
    802004a0:	e94a                	sd	s2,144(sp)
    802004a2:	ed4e                	sd	s3,152(sp)
    802004a4:	f152                	sd	s4,160(sp)
    802004a6:	f556                	sd	s5,168(sp)
    802004a8:	f95a                	sd	s6,176(sp)
    802004aa:	fd5e                	sd	s7,184(sp)
    802004ac:	e1e2                	sd	s8,192(sp)
    802004ae:	e5e6                	sd	s9,200(sp)
    802004b0:	e9ea                	sd	s10,208(sp)
    802004b2:	edee                	sd	s11,216(sp)
    802004b4:	f1f2                	sd	t3,224(sp)
    802004b6:	f5f6                	sd	t4,232(sp)
    802004b8:	f9fa                	sd	t5,240(sp)
    802004ba:	fdfe                	sd	t6,248(sp)
    802004bc:	14001473          	csrrw	s0,sscratch,zero
    802004c0:	100024f3          	csrr	s1,sstatus
    802004c4:	14102973          	csrr	s2,sepc
    802004c8:	143029f3          	csrr	s3,stval
    802004cc:	14202a73          	csrr	s4,scause
    802004d0:	e822                	sd	s0,16(sp)
    802004d2:	e226                	sd	s1,256(sp)
    802004d4:	e64a                	sd	s2,264(sp)
    802004d6:	ea4e                	sd	s3,272(sp)
    802004d8:	ee52                	sd	s4,280(sp)
    802004da:	850a                	mv	a0,sp
    802004dc:	f1bff0ef          	jal	ra,802003f6 <trap>

00000000802004e0 <__trapret>:
    802004e0:	6492                	ld	s1,256(sp)
    802004e2:	6932                	ld	s2,264(sp)
    802004e4:	10049073          	csrw	sstatus,s1
    802004e8:	14191073          	csrw	sepc,s2
    802004ec:	60a2                	ld	ra,8(sp)
    802004ee:	61e2                	ld	gp,24(sp)
    802004f0:	7202                	ld	tp,32(sp)
    802004f2:	72a2                	ld	t0,40(sp)
    802004f4:	7342                	ld	t1,48(sp)
    802004f6:	73e2                	ld	t2,56(sp)
    802004f8:	6406                	ld	s0,64(sp)
    802004fa:	64a6                	ld	s1,72(sp)
    802004fc:	6546                	ld	a0,80(sp)
    802004fe:	65e6                	ld	a1,88(sp)
    80200500:	7606                	ld	a2,96(sp)
    80200502:	76a6                	ld	a3,104(sp)
    80200504:	7746                	ld	a4,112(sp)
    80200506:	77e6                	ld	a5,120(sp)
    80200508:	680a                	ld	a6,128(sp)
    8020050a:	68aa                	ld	a7,136(sp)
    8020050c:	694a                	ld	s2,144(sp)
    8020050e:	69ea                	ld	s3,152(sp)
    80200510:	7a0a                	ld	s4,160(sp)
    80200512:	7aaa                	ld	s5,168(sp)
    80200514:	7b4a                	ld	s6,176(sp)
    80200516:	7bea                	ld	s7,184(sp)
    80200518:	6c0e                	ld	s8,192(sp)
    8020051a:	6cae                	ld	s9,200(sp)
    8020051c:	6d4e                	ld	s10,208(sp)
    8020051e:	6dee                	ld	s11,216(sp)
    80200520:	7e0e                	ld	t3,224(sp)
    80200522:	7eae                	ld	t4,232(sp)
    80200524:	7f4e                	ld	t5,240(sp)
    80200526:	7fee                	ld	t6,248(sp)
    80200528:	6142                	ld	sp,16(sp)
    8020052a:	10200073          	sret

000000008020052e <printnum>:
    8020052e:	02069813          	slli	a6,a3,0x20
    80200532:	7179                	addi	sp,sp,-48
    80200534:	02085813          	srli	a6,a6,0x20
    80200538:	e052                	sd	s4,0(sp)
    8020053a:	03067a33          	remu	s4,a2,a6
    8020053e:	f022                	sd	s0,32(sp)
    80200540:	ec26                	sd	s1,24(sp)
    80200542:	e84a                	sd	s2,16(sp)
    80200544:	f406                	sd	ra,40(sp)
    80200546:	e44e                	sd	s3,8(sp)
    80200548:	84aa                	mv	s1,a0
    8020054a:	892e                	mv	s2,a1
    8020054c:	fff7041b          	addiw	s0,a4,-1
    80200550:	2a01                	sext.w	s4,s4
    80200552:	03067e63          	bgeu	a2,a6,8020058e <printnum+0x60>
    80200556:	89be                	mv	s3,a5
    80200558:	00805763          	blez	s0,80200566 <printnum+0x38>
    8020055c:	347d                	addiw	s0,s0,-1
    8020055e:	85ca                	mv	a1,s2
    80200560:	854e                	mv	a0,s3
    80200562:	9482                	jalr	s1
    80200564:	fc65                	bnez	s0,8020055c <printnum+0x2e>
    80200566:	1a02                	slli	s4,s4,0x20
    80200568:	00001797          	auipc	a5,0x1
    8020056c:	93078793          	addi	a5,a5,-1744 # 80200e98 <etext+0x500>
    80200570:	020a5a13          	srli	s4,s4,0x20
    80200574:	9a3e                	add	s4,s4,a5
    80200576:	7402                	ld	s0,32(sp)
    80200578:	000a4503          	lbu	a0,0(s4)
    8020057c:	70a2                	ld	ra,40(sp)
    8020057e:	69a2                	ld	s3,8(sp)
    80200580:	6a02                	ld	s4,0(sp)
    80200582:	85ca                	mv	a1,s2
    80200584:	87a6                	mv	a5,s1
    80200586:	6942                	ld	s2,16(sp)
    80200588:	64e2                	ld	s1,24(sp)
    8020058a:	6145                	addi	sp,sp,48
    8020058c:	8782                	jr	a5
    8020058e:	03065633          	divu	a2,a2,a6
    80200592:	8722                	mv	a4,s0
    80200594:	f9bff0ef          	jal	ra,8020052e <printnum>
    80200598:	b7f9                	j	80200566 <printnum+0x38>

000000008020059a <vprintfmt>:
    8020059a:	7119                	addi	sp,sp,-128
    8020059c:	f4a6                	sd	s1,104(sp)
    8020059e:	f0ca                	sd	s2,96(sp)
    802005a0:	ecce                	sd	s3,88(sp)
    802005a2:	e8d2                	sd	s4,80(sp)
    802005a4:	e4d6                	sd	s5,72(sp)
    802005a6:	e0da                	sd	s6,64(sp)
    802005a8:	fc5e                	sd	s7,56(sp)
    802005aa:	f06a                	sd	s10,32(sp)
    802005ac:	fc86                	sd	ra,120(sp)
    802005ae:	f8a2                	sd	s0,112(sp)
    802005b0:	f862                	sd	s8,48(sp)
    802005b2:	f466                	sd	s9,40(sp)
    802005b4:	ec6e                	sd	s11,24(sp)
    802005b6:	892a                	mv	s2,a0
    802005b8:	84ae                	mv	s1,a1
    802005ba:	8d32                	mv	s10,a2
    802005bc:	8a36                	mv	s4,a3
    802005be:	02500993          	li	s3,37
    802005c2:	5b7d                	li	s6,-1
    802005c4:	00001a97          	auipc	s5,0x1
    802005c8:	908a8a93          	addi	s5,s5,-1784 # 80200ecc <etext+0x534>
    802005cc:	00001b97          	auipc	s7,0x1
    802005d0:	adcb8b93          	addi	s7,s7,-1316 # 802010a8 <error_string>
    802005d4:	000d4503          	lbu	a0,0(s10)
    802005d8:	001d0413          	addi	s0,s10,1
    802005dc:	01350a63          	beq	a0,s3,802005f0 <vprintfmt+0x56>
    802005e0:	c121                	beqz	a0,80200620 <vprintfmt+0x86>
    802005e2:	85a6                	mv	a1,s1
    802005e4:	0405                	addi	s0,s0,1
    802005e6:	9902                	jalr	s2
    802005e8:	fff44503          	lbu	a0,-1(s0)
    802005ec:	ff351ae3          	bne	a0,s3,802005e0 <vprintfmt+0x46>
    802005f0:	00044603          	lbu	a2,0(s0)
    802005f4:	02000793          	li	a5,32
    802005f8:	4c81                	li	s9,0
    802005fa:	4881                	li	a7,0
    802005fc:	5c7d                	li	s8,-1
    802005fe:	5dfd                	li	s11,-1
    80200600:	05500513          	li	a0,85
    80200604:	4825                	li	a6,9
    80200606:	fdd6059b          	addiw	a1,a2,-35
    8020060a:	0ff5f593          	andi	a1,a1,255
    8020060e:	00140d13          	addi	s10,s0,1
    80200612:	04b56263          	bltu	a0,a1,80200656 <vprintfmt+0xbc>
    80200616:	058a                	slli	a1,a1,0x2
    80200618:	95d6                	add	a1,a1,s5
    8020061a:	4194                	lw	a3,0(a1)
    8020061c:	96d6                	add	a3,a3,s5
    8020061e:	8682                	jr	a3
    80200620:	70e6                	ld	ra,120(sp)
    80200622:	7446                	ld	s0,112(sp)
    80200624:	74a6                	ld	s1,104(sp)
    80200626:	7906                	ld	s2,96(sp)
    80200628:	69e6                	ld	s3,88(sp)
    8020062a:	6a46                	ld	s4,80(sp)
    8020062c:	6aa6                	ld	s5,72(sp)
    8020062e:	6b06                	ld	s6,64(sp)
    80200630:	7be2                	ld	s7,56(sp)
    80200632:	7c42                	ld	s8,48(sp)
    80200634:	7ca2                	ld	s9,40(sp)
    80200636:	7d02                	ld	s10,32(sp)
    80200638:	6de2                	ld	s11,24(sp)
    8020063a:	6109                	addi	sp,sp,128
    8020063c:	8082                	ret
    8020063e:	87b2                	mv	a5,a2
    80200640:	00144603          	lbu	a2,1(s0)
    80200644:	846a                	mv	s0,s10
    80200646:	00140d13          	addi	s10,s0,1
    8020064a:	fdd6059b          	addiw	a1,a2,-35
    8020064e:	0ff5f593          	andi	a1,a1,255
    80200652:	fcb572e3          	bgeu	a0,a1,80200616 <vprintfmt+0x7c>
    80200656:	85a6                	mv	a1,s1
    80200658:	02500513          	li	a0,37
    8020065c:	9902                	jalr	s2
    8020065e:	fff44783          	lbu	a5,-1(s0)
    80200662:	8d22                	mv	s10,s0
    80200664:	f73788e3          	beq	a5,s3,802005d4 <vprintfmt+0x3a>
    80200668:	ffed4783          	lbu	a5,-2(s10)
    8020066c:	1d7d                	addi	s10,s10,-1
    8020066e:	ff379de3          	bne	a5,s3,80200668 <vprintfmt+0xce>
    80200672:	b78d                	j	802005d4 <vprintfmt+0x3a>
    80200674:	fd060c1b          	addiw	s8,a2,-48
    80200678:	00144603          	lbu	a2,1(s0)
    8020067c:	846a                	mv	s0,s10
    8020067e:	fd06069b          	addiw	a3,a2,-48
    80200682:	0006059b          	sext.w	a1,a2
    80200686:	02d86463          	bltu	a6,a3,802006ae <vprintfmt+0x114>
    8020068a:	00144603          	lbu	a2,1(s0)
    8020068e:	002c169b          	slliw	a3,s8,0x2
    80200692:	0186873b          	addw	a4,a3,s8
    80200696:	0017171b          	slliw	a4,a4,0x1
    8020069a:	9f2d                	addw	a4,a4,a1
    8020069c:	fd06069b          	addiw	a3,a2,-48
    802006a0:	0405                	addi	s0,s0,1
    802006a2:	fd070c1b          	addiw	s8,a4,-48
    802006a6:	0006059b          	sext.w	a1,a2
    802006aa:	fed870e3          	bgeu	a6,a3,8020068a <vprintfmt+0xf0>
    802006ae:	f40ddce3          	bgez	s11,80200606 <vprintfmt+0x6c>
    802006b2:	8de2                	mv	s11,s8
    802006b4:	5c7d                	li	s8,-1
    802006b6:	bf81                	j	80200606 <vprintfmt+0x6c>
    802006b8:	fffdc693          	not	a3,s11
    802006bc:	96fd                	srai	a3,a3,0x3f
    802006be:	00ddfdb3          	and	s11,s11,a3
    802006c2:	00144603          	lbu	a2,1(s0)
    802006c6:	2d81                	sext.w	s11,s11
    802006c8:	846a                	mv	s0,s10
    802006ca:	bf35                	j	80200606 <vprintfmt+0x6c>
    802006cc:	000a2c03          	lw	s8,0(s4)
    802006d0:	00144603          	lbu	a2,1(s0)
    802006d4:	0a21                	addi	s4,s4,8
    802006d6:	846a                	mv	s0,s10
    802006d8:	bfd9                	j	802006ae <vprintfmt+0x114>
    802006da:	4705                	li	a4,1
    802006dc:	008a0593          	addi	a1,s4,8
    802006e0:	01174463          	blt	a4,a7,802006e8 <vprintfmt+0x14e>
    802006e4:	1a088e63          	beqz	a7,802008a0 <vprintfmt+0x306>
    802006e8:	000a3603          	ld	a2,0(s4)
    802006ec:	46c1                	li	a3,16
    802006ee:	8a2e                	mv	s4,a1
    802006f0:	2781                	sext.w	a5,a5
    802006f2:	876e                	mv	a4,s11
    802006f4:	85a6                	mv	a1,s1
    802006f6:	854a                	mv	a0,s2
    802006f8:	e37ff0ef          	jal	ra,8020052e <printnum>
    802006fc:	bde1                	j	802005d4 <vprintfmt+0x3a>
    802006fe:	000a2503          	lw	a0,0(s4)
    80200702:	85a6                	mv	a1,s1
    80200704:	0a21                	addi	s4,s4,8
    80200706:	9902                	jalr	s2
    80200708:	b5f1                	j	802005d4 <vprintfmt+0x3a>
    8020070a:	4705                	li	a4,1
    8020070c:	008a0593          	addi	a1,s4,8
    80200710:	01174463          	blt	a4,a7,80200718 <vprintfmt+0x17e>
    80200714:	18088163          	beqz	a7,80200896 <vprintfmt+0x2fc>
    80200718:	000a3603          	ld	a2,0(s4)
    8020071c:	46a9                	li	a3,10
    8020071e:	8a2e                	mv	s4,a1
    80200720:	bfc1                	j	802006f0 <vprintfmt+0x156>
    80200722:	00144603          	lbu	a2,1(s0)
    80200726:	4c85                	li	s9,1
    80200728:	846a                	mv	s0,s10
    8020072a:	bdf1                	j	80200606 <vprintfmt+0x6c>
    8020072c:	85a6                	mv	a1,s1
    8020072e:	02500513          	li	a0,37
    80200732:	9902                	jalr	s2
    80200734:	b545                	j	802005d4 <vprintfmt+0x3a>
    80200736:	00144603          	lbu	a2,1(s0)
    8020073a:	2885                	addiw	a7,a7,1
    8020073c:	846a                	mv	s0,s10
    8020073e:	b5e1                	j	80200606 <vprintfmt+0x6c>
    80200740:	4705                	li	a4,1
    80200742:	008a0593          	addi	a1,s4,8
    80200746:	01174463          	blt	a4,a7,8020074e <vprintfmt+0x1b4>
    8020074a:	14088163          	beqz	a7,8020088c <vprintfmt+0x2f2>
    8020074e:	000a3603          	ld	a2,0(s4)
    80200752:	46a1                	li	a3,8
    80200754:	8a2e                	mv	s4,a1
    80200756:	bf69                	j	802006f0 <vprintfmt+0x156>
    80200758:	03000513          	li	a0,48
    8020075c:	85a6                	mv	a1,s1
    8020075e:	e03e                	sd	a5,0(sp)
    80200760:	9902                	jalr	s2
    80200762:	85a6                	mv	a1,s1
    80200764:	07800513          	li	a0,120
    80200768:	9902                	jalr	s2
    8020076a:	0a21                	addi	s4,s4,8
    8020076c:	6782                	ld	a5,0(sp)
    8020076e:	46c1                	li	a3,16
    80200770:	ff8a3603          	ld	a2,-8(s4)
    80200774:	bfb5                	j	802006f0 <vprintfmt+0x156>
    80200776:	000a3403          	ld	s0,0(s4)
    8020077a:	008a0713          	addi	a4,s4,8
    8020077e:	e03a                	sd	a4,0(sp)
    80200780:	14040263          	beqz	s0,802008c4 <vprintfmt+0x32a>
    80200784:	0fb05763          	blez	s11,80200872 <vprintfmt+0x2d8>
    80200788:	02d00693          	li	a3,45
    8020078c:	0cd79163          	bne	a5,a3,8020084e <vprintfmt+0x2b4>
    80200790:	00044783          	lbu	a5,0(s0)
    80200794:	0007851b          	sext.w	a0,a5
    80200798:	cf85                	beqz	a5,802007d0 <vprintfmt+0x236>
    8020079a:	00140a13          	addi	s4,s0,1
    8020079e:	05e00413          	li	s0,94
    802007a2:	000c4563          	bltz	s8,802007ac <vprintfmt+0x212>
    802007a6:	3c7d                	addiw	s8,s8,-1
    802007a8:	036c0263          	beq	s8,s6,802007cc <vprintfmt+0x232>
    802007ac:	85a6                	mv	a1,s1
    802007ae:	0e0c8e63          	beqz	s9,802008aa <vprintfmt+0x310>
    802007b2:	3781                	addiw	a5,a5,-32
    802007b4:	0ef47b63          	bgeu	s0,a5,802008aa <vprintfmt+0x310>
    802007b8:	03f00513          	li	a0,63
    802007bc:	9902                	jalr	s2
    802007be:	000a4783          	lbu	a5,0(s4)
    802007c2:	3dfd                	addiw	s11,s11,-1
    802007c4:	0a05                	addi	s4,s4,1
    802007c6:	0007851b          	sext.w	a0,a5
    802007ca:	ffe1                	bnez	a5,802007a2 <vprintfmt+0x208>
    802007cc:	01b05963          	blez	s11,802007de <vprintfmt+0x244>
    802007d0:	3dfd                	addiw	s11,s11,-1
    802007d2:	85a6                	mv	a1,s1
    802007d4:	02000513          	li	a0,32
    802007d8:	9902                	jalr	s2
    802007da:	fe0d9be3          	bnez	s11,802007d0 <vprintfmt+0x236>
    802007de:	6a02                	ld	s4,0(sp)
    802007e0:	bbd5                	j	802005d4 <vprintfmt+0x3a>
    802007e2:	4705                	li	a4,1
    802007e4:	008a0c93          	addi	s9,s4,8
    802007e8:	01174463          	blt	a4,a7,802007f0 <vprintfmt+0x256>
    802007ec:	08088d63          	beqz	a7,80200886 <vprintfmt+0x2ec>
    802007f0:	000a3403          	ld	s0,0(s4)
    802007f4:	0a044d63          	bltz	s0,802008ae <vprintfmt+0x314>
    802007f8:	8622                	mv	a2,s0
    802007fa:	8a66                	mv	s4,s9
    802007fc:	46a9                	li	a3,10
    802007fe:	bdcd                	j	802006f0 <vprintfmt+0x156>
    80200800:	000a2783          	lw	a5,0(s4)
    80200804:	4719                	li	a4,6
    80200806:	0a21                	addi	s4,s4,8
    80200808:	41f7d69b          	sraiw	a3,a5,0x1f
    8020080c:	8fb5                	xor	a5,a5,a3
    8020080e:	40d786bb          	subw	a3,a5,a3
    80200812:	02d74163          	blt	a4,a3,80200834 <vprintfmt+0x29a>
    80200816:	00369793          	slli	a5,a3,0x3
    8020081a:	97de                	add	a5,a5,s7
    8020081c:	639c                	ld	a5,0(a5)
    8020081e:	cb99                	beqz	a5,80200834 <vprintfmt+0x29a>
    80200820:	86be                	mv	a3,a5
    80200822:	00000617          	auipc	a2,0x0
    80200826:	6a660613          	addi	a2,a2,1702 # 80200ec8 <etext+0x530>
    8020082a:	85a6                	mv	a1,s1
    8020082c:	854a                	mv	a0,s2
    8020082e:	0ce000ef          	jal	ra,802008fc <printfmt>
    80200832:	b34d                	j	802005d4 <vprintfmt+0x3a>
    80200834:	00000617          	auipc	a2,0x0
    80200838:	68460613          	addi	a2,a2,1668 # 80200eb8 <etext+0x520>
    8020083c:	85a6                	mv	a1,s1
    8020083e:	854a                	mv	a0,s2
    80200840:	0bc000ef          	jal	ra,802008fc <printfmt>
    80200844:	bb41                	j	802005d4 <vprintfmt+0x3a>
    80200846:	00000417          	auipc	s0,0x0
    8020084a:	66a40413          	addi	s0,s0,1642 # 80200eb0 <etext+0x518>
    8020084e:	85e2                	mv	a1,s8
    80200850:	8522                	mv	a0,s0
    80200852:	e43e                	sd	a5,8(sp)
    80200854:	116000ef          	jal	ra,8020096a <strnlen>
    80200858:	40ad8dbb          	subw	s11,s11,a0
    8020085c:	01b05b63          	blez	s11,80200872 <vprintfmt+0x2d8>
    80200860:	67a2                	ld	a5,8(sp)
    80200862:	00078a1b          	sext.w	s4,a5
    80200866:	3dfd                	addiw	s11,s11,-1
    80200868:	85a6                	mv	a1,s1
    8020086a:	8552                	mv	a0,s4
    8020086c:	9902                	jalr	s2
    8020086e:	fe0d9ce3          	bnez	s11,80200866 <vprintfmt+0x2cc>
    80200872:	00044783          	lbu	a5,0(s0)
    80200876:	00140a13          	addi	s4,s0,1
    8020087a:	0007851b          	sext.w	a0,a5
    8020087e:	d3a5                	beqz	a5,802007de <vprintfmt+0x244>
    80200880:	05e00413          	li	s0,94
    80200884:	bf39                	j	802007a2 <vprintfmt+0x208>
    80200886:	000a2403          	lw	s0,0(s4)
    8020088a:	b7ad                	j	802007f4 <vprintfmt+0x25a>
    8020088c:	000a6603          	lwu	a2,0(s4)
    80200890:	46a1                	li	a3,8
    80200892:	8a2e                	mv	s4,a1
    80200894:	bdb1                	j	802006f0 <vprintfmt+0x156>
    80200896:	000a6603          	lwu	a2,0(s4)
    8020089a:	46a9                	li	a3,10
    8020089c:	8a2e                	mv	s4,a1
    8020089e:	bd89                	j	802006f0 <vprintfmt+0x156>
    802008a0:	000a6603          	lwu	a2,0(s4)
    802008a4:	46c1                	li	a3,16
    802008a6:	8a2e                	mv	s4,a1
    802008a8:	b5a1                	j	802006f0 <vprintfmt+0x156>
    802008aa:	9902                	jalr	s2
    802008ac:	bf09                	j	802007be <vprintfmt+0x224>
    802008ae:	85a6                	mv	a1,s1
    802008b0:	02d00513          	li	a0,45
    802008b4:	e03e                	sd	a5,0(sp)
    802008b6:	9902                	jalr	s2
    802008b8:	6782                	ld	a5,0(sp)
    802008ba:	8a66                	mv	s4,s9
    802008bc:	40800633          	neg	a2,s0
    802008c0:	46a9                	li	a3,10
    802008c2:	b53d                	j	802006f0 <vprintfmt+0x156>
    802008c4:	03b05163          	blez	s11,802008e6 <vprintfmt+0x34c>
    802008c8:	02d00693          	li	a3,45
    802008cc:	f6d79de3          	bne	a5,a3,80200846 <vprintfmt+0x2ac>
    802008d0:	00000417          	auipc	s0,0x0
    802008d4:	5e040413          	addi	s0,s0,1504 # 80200eb0 <etext+0x518>
    802008d8:	02800793          	li	a5,40
    802008dc:	02800513          	li	a0,40
    802008e0:	00140a13          	addi	s4,s0,1
    802008e4:	bd6d                	j	8020079e <vprintfmt+0x204>
    802008e6:	00000a17          	auipc	s4,0x0
    802008ea:	5cba0a13          	addi	s4,s4,1483 # 80200eb1 <etext+0x519>
    802008ee:	02800513          	li	a0,40
    802008f2:	02800793          	li	a5,40
    802008f6:	05e00413          	li	s0,94
    802008fa:	b565                	j	802007a2 <vprintfmt+0x208>

00000000802008fc <printfmt>:
    802008fc:	715d                	addi	sp,sp,-80
    802008fe:	02810313          	addi	t1,sp,40
    80200902:	f436                	sd	a3,40(sp)
    80200904:	869a                	mv	a3,t1
    80200906:	ec06                	sd	ra,24(sp)
    80200908:	f83a                	sd	a4,48(sp)
    8020090a:	fc3e                	sd	a5,56(sp)
    8020090c:	e0c2                	sd	a6,64(sp)
    8020090e:	e4c6                	sd	a7,72(sp)
    80200910:	e41a                	sd	t1,8(sp)
    80200912:	c89ff0ef          	jal	ra,8020059a <vprintfmt>
    80200916:	60e2                	ld	ra,24(sp)
    80200918:	6161                	addi	sp,sp,80
    8020091a:	8082                	ret

000000008020091c <sbi_console_putchar>:
    8020091c:	4781                	li	a5,0
    8020091e:	00003717          	auipc	a4,0x3
    80200922:	6e273703          	ld	a4,1762(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    80200926:	88ba                	mv	a7,a4
    80200928:	852a                	mv	a0,a0
    8020092a:	85be                	mv	a1,a5
    8020092c:	863e                	mv	a2,a5
    8020092e:	00000073          	ecall
    80200932:	87aa                	mv	a5,a0
    80200934:	8082                	ret

0000000080200936 <sbi_set_timer>:
    80200936:	4781                	li	a5,0
    80200938:	00003717          	auipc	a4,0x3
    8020093c:	6e073703          	ld	a4,1760(a4) # 80204018 <SBI_SET_TIMER>
    80200940:	88ba                	mv	a7,a4
    80200942:	852a                	mv	a0,a0
    80200944:	85be                	mv	a1,a5
    80200946:	863e                	mv	a2,a5
    80200948:	00000073          	ecall
    8020094c:	87aa                	mv	a5,a0
    8020094e:	8082                	ret

0000000080200950 <sbi_shutdown>:
    80200950:	4781                	li	a5,0
    80200952:	00003717          	auipc	a4,0x3
    80200956:	6b673703          	ld	a4,1718(a4) # 80204008 <SBI_SHUTDOWN>
    8020095a:	88ba                	mv	a7,a4
    8020095c:	853e                	mv	a0,a5
    8020095e:	85be                	mv	a1,a5
    80200960:	863e                	mv	a2,a5
    80200962:	00000073          	ecall
    80200966:	87aa                	mv	a5,a0
    80200968:	8082                	ret

000000008020096a <strnlen>:
    8020096a:	4781                	li	a5,0
    8020096c:	e589                	bnez	a1,80200976 <strnlen+0xc>
    8020096e:	a811                	j	80200982 <strnlen+0x18>
    80200970:	0785                	addi	a5,a5,1
    80200972:	00f58863          	beq	a1,a5,80200982 <strnlen+0x18>
    80200976:	00f50733          	add	a4,a0,a5
    8020097a:	00074703          	lbu	a4,0(a4)
    8020097e:	fb6d                	bnez	a4,80200970 <strnlen+0x6>
    80200980:	85be                	mv	a1,a5
    80200982:	852e                	mv	a0,a1
    80200984:	8082                	ret

0000000080200986 <memset>:
    80200986:	ca01                	beqz	a2,80200996 <memset+0x10>
    80200988:	962a                	add	a2,a2,a0
    8020098a:	87aa                	mv	a5,a0
    8020098c:	0785                	addi	a5,a5,1
    8020098e:	feb78fa3          	sb	a1,-1(a5)
    80200992:	fec79de3          	bne	a5,a2,8020098c <memset+0x6>
    80200996:	8082                	ret
