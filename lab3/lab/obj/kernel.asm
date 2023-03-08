
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00003117          	auipc	sp,0x3
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00003517          	auipc	a0,0x3
    8020000e:	ffe50513          	addi	a0,a0,-2 # 80203008 <edata>
    80200012:	00003617          	auipc	a2,0x3
    80200016:	ff660613          	addi	a2,a2,-10 # 80203008 <edata>
    8020001a:	1141                	addi	sp,sp,-16
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	0e4000ef          	jal	ra,80200106 <memset>
    80200026:	00000517          	auipc	a0,0x0
    8020002a:	0f250513          	addi	a0,a0,242 # 80200118 <etext>
    8020002e:	02a000ef          	jal	ra,80200058 <cputs>
    80200032:	00000517          	auipc	a0,0x0
    80200036:	0fe50513          	addi	a0,a0,254 # 80200130 <etext+0x18>
    8020003a:	01e000ef          	jal	ra,80200058 <cputs>
    8020003e:	00000517          	auipc	a0,0x0
    80200042:	0f250513          	addi	a0,a0,242 # 80200130 <etext+0x18>
    80200046:	052000ef          	jal	ra,80200098 <double_puts>
    8020004a:	00000517          	auipc	a0,0x0
    8020004e:	10650513          	addi	a0,a0,262 # 80200150 <etext+0x38>
    80200052:	046000ef          	jal	ra,80200098 <double_puts>
    80200056:	a001                	j	80200056 <kern_init+0x4c>

0000000080200058 <cputs>:
    80200058:	1101                	addi	sp,sp,-32
    8020005a:	e822                	sd	s0,16(sp)
    8020005c:	ec06                	sd	ra,24(sp)
    8020005e:	e426                	sd	s1,8(sp)
    80200060:	842a                	mv	s0,a0
    80200062:	00054503          	lbu	a0,0(a0)
    80200066:	c51d                	beqz	a0,80200094 <cputs+0x3c>
    80200068:	0405                	addi	s0,s0,1
    8020006a:	4485                	li	s1,1
    8020006c:	9c81                	subw	s1,s1,s0
    8020006e:	078000ef          	jal	ra,802000e6 <cons_putc>
    80200072:	00044503          	lbu	a0,0(s0)
    80200076:	008487bb          	addw	a5,s1,s0
    8020007a:	0405                	addi	s0,s0,1
    8020007c:	f96d                	bnez	a0,8020006e <cputs+0x16>
    8020007e:	0017841b          	addiw	s0,a5,1
    80200082:	4529                	li	a0,10
    80200084:	062000ef          	jal	ra,802000e6 <cons_putc>
    80200088:	60e2                	ld	ra,24(sp)
    8020008a:	8522                	mv	a0,s0
    8020008c:	6442                	ld	s0,16(sp)
    8020008e:	64a2                	ld	s1,8(sp)
    80200090:	6105                	addi	sp,sp,32
    80200092:	8082                	ret
    80200094:	4405                	li	s0,1
    80200096:	b7f5                	j	80200082 <cputs+0x2a>

0000000080200098 <double_puts>:
    80200098:	1101                	addi	sp,sp,-32
    8020009a:	e426                	sd	s1,8(sp)
    8020009c:	ec06                	sd	ra,24(sp)
    8020009e:	e822                	sd	s0,16(sp)
    802000a0:	e04a                	sd	s2,0(sp)
    802000a2:	84aa                	mv	s1,a0
    802000a4:	00054503          	lbu	a0,0(a0)
    802000a8:	cd0d                	beqz	a0,802000e2 <double_puts+0x4a>
    802000aa:	0485                	addi	s1,s1,1
    802000ac:	4901                	li	s2,0
    802000ae:	0005041b          	sext.w	s0,a0
    802000b2:	8522                	mv	a0,s0
    802000b4:	032000ef          	jal	ra,802000e6 <cons_putc>
    802000b8:	8522                	mv	a0,s0
    802000ba:	02c000ef          	jal	ra,802000e6 <cons_putc>
    802000be:	0004c503          	lbu	a0,0(s1)
    802000c2:	0485                	addi	s1,s1,1
    802000c4:	87ca                	mv	a5,s2
    802000c6:	2909                	addiw	s2,s2,2
    802000c8:	f17d                	bnez	a0,802000ae <double_puts+0x16>
    802000ca:	0037841b          	addiw	s0,a5,3
    802000ce:	4529                	li	a0,10
    802000d0:	016000ef          	jal	ra,802000e6 <cons_putc>
    802000d4:	60e2                	ld	ra,24(sp)
    802000d6:	8522                	mv	a0,s0
    802000d8:	6442                	ld	s0,16(sp)
    802000da:	64a2                	ld	s1,8(sp)
    802000dc:	6902                	ld	s2,0(sp)
    802000de:	6105                	addi	sp,sp,32
    802000e0:	8082                	ret
    802000e2:	4405                	li	s0,1
    802000e4:	b7ed                	j	802000ce <double_puts+0x36>

00000000802000e6 <cons_putc>:
    802000e6:	0ff57513          	andi	a0,a0,255
    802000ea:	a009                	j	802000ec <sbi_console_putchar>

00000000802000ec <sbi_console_putchar>:
    802000ec:	4781                	li	a5,0
    802000ee:	00003717          	auipc	a4,0x3
    802000f2:	f1273703          	ld	a4,-238(a4) # 80203000 <SBI_CONSOLE_PUTCHAR>
    802000f6:	88ba                	mv	a7,a4
    802000f8:	852a                	mv	a0,a0
    802000fa:	85be                	mv	a1,a5
    802000fc:	863e                	mv	a2,a5
    802000fe:	00000073          	ecall
    80200102:	87aa                	mv	a5,a0
    80200104:	8082                	ret

0000000080200106 <memset>:
    80200106:	ca01                	beqz	a2,80200116 <memset+0x10>
    80200108:	962a                	add	a2,a2,a0
    8020010a:	87aa                	mv	a5,a0
    8020010c:	0785                	addi	a5,a5,1
    8020010e:	feb78fa3          	sb	a1,-1(a5)
    80200112:	fec79de3          	bne	a5,a2,8020010c <memset+0x6>
    80200116:	8082                	ret
