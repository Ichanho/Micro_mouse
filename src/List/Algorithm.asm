
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _acc=R4
	.DEF _acc_allow=R6
	.DEF _LeftstepCount=R8
	.DEF _RightstepCount=R10
	.DEF _vel_counter_high_R=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x63,0x65,0x6E,0x74,0x65,0x72,0x20,0x3A
	.DB  0x20,0x25,0x64,0x20,0x9,0x20,0x6C,0x65
	.DB  0x66,0x74,0x20,0x3A,0x20,0x25,0x64,0x20
	.DB  0x9,0x20,0x72,0x69,0x67,0x68,0x74,0x20
	.DB  0x3A,0x20,0x25,0x64,0xD,0xA,0x0
_0x40003:
	.DB  0x9,0x1,0x5,0x4,0x6,0x2,0xA,0x8
_0x40004:
	.DB  0x9,0x8,0xA,0x2,0x6,0x4,0x5,0x1
_0x40005:
	.DB  0x64,0xFF
_0x4006C:
	.DB  0x0,0x0,0x0,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  _rotateR
	.DW  _0x40003*2

	.DW  0x08
	.DW  _rotateL
	.DW  _0x40004*2

	.DW  0x02
	.DW  _vel_counter_high
	.DW  _0x40005*2

	.DW  0x04
	.DW  0x04
	.DW  _0x4006C*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "UART1.h"
;#include "Algorithm.h"
;
;extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
;eeprom int StandardSensor[3], CenterStandardSensor[3];
;extern unsigned char poutput;
;void main(void)
; 0000 0010 {

	.CSEG
_main:
; 0000 0011     int i;
; 0000 0012     int mode=0;
; 0000 0013 
; 0000 0014     poutput=USART1;
;	i -> R16,R17
;	mode -> R18,R19
	__GETWRN 18,19,0
	LDI  R30,LOW(1)
	STS  _poutput,R30
; 0000 0015     InitializeSensor();
	RCALL _InitializeSensor
; 0000 0016 	InitializeStepMotor();
	CALL _InitializeStepMotor
; 0000 0017 	InitializeLED();
	CALL _InitializeLED
; 0000 0018 	InitializeSwitch();
	CALL _InitializeSwitch
; 0000 0019 
; 0000 001A     UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 001B     UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 001C     UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 001D     UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 001E     UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 001F 
; 0000 0020     VelocityLeftmotorTCNT1=65380;
	LDI  R30,LOW(65380)
	LDI  R31,HIGH(65380)
	CALL SUBOPT_0x0
; 0000 0021     VelocityRightmotorTCNT3=65380;
	LDI  R30,LOW(65380)
	LDI  R31,HIGH(65380)
	CALL SUBOPT_0x1
; 0000 0022 
; 0000 0023     LED_OFF(LED2 | LED3 | LED4);
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x2
; 0000 0024 
; 0000 0025     #asm("sei");
	sei
; 0000 0026 
; 0000 0027     while (1)
_0x3:
; 0000 0028     {
; 0000 0029         if(SW1() == TRUE)
	CALL _SW1
	CPI  R30,LOW(0x1)
	BRNE _0x6
; 0000 002A         {
; 0000 002B             mode++;
	__ADDWRN 18,19,1
; 0000 002C             if(mode>6)
	__CPWRN 18,19,7
	BRLT _0x7
; 0000 002D             {
; 0000 002E                 mode = 0;
	__GETWRN 18,19,0
; 0000 002F             }
; 0000 0030             LED_OFF(LED1 | LED2 | LED3 | LED4);
_0x7:
	CALL SUBOPT_0x3
; 0000 0031             switch(mode)
	MOVW R30,R18
; 0000 0032             {
; 0000 0033                 case 0: LED_ON(LED1); break;
	SBIW R30,0
	BRNE _0xB
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x3E
; 0000 0034                 case 1: LED_ON(LED2); break;
_0xB:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RJMP _0x3E
; 0000 0035                 case 2: LED_ON(LED3); break;
_0xC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP _0x3E
; 0000 0036                 case 3: LED_ON(LED4); break;
_0xD:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0x3E
; 0000 0037                 case 4: LED_ON(LED1|LED2); break;
_0xE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xF
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RJMP _0x3E
; 0000 0038                 case 5: LED_ON(LED1|LED3); break;
_0xF:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x10
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x3E
; 0000 0039                 case 6: LED_ON(LED1|LED4); break;
_0x10:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xA
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _LED_ON
; 0000 003A             }
_0xA:
; 0000 003B         }
; 0000 003C         if(SW2() == TRUE)
_0x6:
	CALL _SW2
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x12
; 0000 003D         {
; 0000 003E             LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x3
; 0000 003F             switch(mode)
	MOVW R30,R18
; 0000 0040             {
; 0000 0041                 case 0:
	SBIW R30,0
	BRNE _0x16
; 0000 0042 
; 0000 0043                 for(i = 0; i<8 ; i++)
	__GETWRN 16,17,0
_0x18:
	__CPWRN 16,17,8
	BRGE _0x19
; 0000 0044                 {
; 0000 0045                     Direction(RIGHT);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x4
; 0000 0046                 }
	__ADDWRN 16,17,1
	RJMP _0x18
_0x19:
; 0000 0047 
; 0000 0048                 break;
	RJMP _0x15
; 0000 0049 
; 0000 004A                 case 1:
_0x16:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1A
; 0000 004B                 while(1)
_0x1B:
; 0000 004C                 {
; 0000 004D                     printf("center : %d \t left : %d \t right : %d\r\n",readSensor(FRONT_SENSOR),readSensor(LEFT_SENSOR),readSensor(RIGHT_SENSOR));
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
	LDI  R24,12
	CALL _printf
	ADIW R28,14
; 0000 004E 	                delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x9
; 0000 004F                 }
	RJMP _0x1B
; 0000 0050                 break;
; 0000 0051 
; 0000 0052                 case 2:
_0x1A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1E
; 0000 0053                 for(i = 0; i<3 ; i++)
	__GETWRN 16,17,0
_0x20:
	__CPWRN 16,17,3
	BRGE _0x21
; 0000 0054                 {
; 0000 0055                     Direction(FORWARD);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x4
; 0000 0056                 }
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 0057                 break;
	RJMP _0x15
; 0000 0058 
; 0000 0059                 case 3:
_0x1E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x22
; 0000 005A                 for(i = 0; i<8 ; i++)
	__GETWRN 16,17,0
_0x24:
	__CPWRN 16,17,8
	BRGE _0x25
; 0000 005B                 {
; 0000 005C                     Direction(HALF);
	CALL SUBOPT_0xA
; 0000 005D                 }
	__ADDWRN 16,17,1
	RJMP _0x24
_0x25:
; 0000 005E                 break;
	RJMP _0x15
; 0000 005F 
; 0000 0060                 case 4:
_0x22:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x26
; 0000 0061                 //스탠다드는 약간 멀리, 센터는 약간 가까이 측정할것
; 0000 0062                  LED_OFF(LED1 | LED2 | LED3 | LED4);
	CALL SUBOPT_0x3
; 0000 0063                  while(!SW2());
_0x27:
	CALL _SW2
	CPI  R30,0
	BREQ _0x27
; 0000 0064                  StandardSensor[0] = readSensor(FRONT_SENSOR);    // 전방 벽 정보
	CALL SUBOPT_0x5
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL __EEPROMWRW
; 0000 0065                  LED_ON(LED1);
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0xB
; 0000 0066                  while(!SW2());
_0x2A:
	CALL _SW2
	CPI  R30,0
	BREQ _0x2A
; 0000 0067                  StandardSensor[1] = readSensor(LEFT_SENSOR);    // 왼쪽 벽 정보
	__POINTW1MN _StandardSensor,2
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 0068                  LED_ON(LED2);
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0xB
; 0000 0069                  while(!SW2());
_0x2D:
	CALL _SW2
	CPI  R30,0
	BREQ _0x2D
; 0000 006A                  StandardSensor[2] = readSensor(RIGHT_SENSOR);    // 오른쪽 벽 정보
	__POINTW1MN _StandardSensor,4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 006B                  LED_ON(LED3);
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0xB
; 0000 006C                  while(!SW2());
_0x30:
	CALL _SW2
	CPI  R30,0
	BREQ _0x30
; 0000 006D                  CenterStandardSensor[0] = readSensor(FRONT_SENSOR);
	CALL SUBOPT_0x5
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	CALL __EEPROMWRW
; 0000 006E                  CenterStandardSensor[1] = readSensor(LEFT_SENSOR)-50;
	__POINTW1MN _CenterStandardSensor,2
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	SBIW R30,50
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 006F                  CenterStandardSensor[2] = readSensor(RIGHT_SENSOR)-50;
	__POINTW1MN _CenterStandardSensor,4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	SBIW R30,50
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 0070                  LED_ON(LED4);
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0xB
; 0000 0071                  break;
	RJMP _0x15
; 0000 0072 
; 0000 0073                case 5:
_0x26:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x15
; 0000 0074                // 좌수법
; 0000 0075                Direction(HALF);
	CALL SUBOPT_0xA
; 0000 0076                while (1)
_0x34:
; 0000 0077                {
; 0000 0078                     if(readSensor(LEFT_SENSOR) < StandardSensor[1])
	CALL SUBOPT_0x7
	MOVW R0,R30
	__POINTW2MN _StandardSensor,2
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x37
; 0000 0079                     {
; 0000 007A                          Direction(HALF);
	CALL SUBOPT_0xA
; 0000 007B                          Direction(LEFT);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
; 0000 007C                          Direction(HALF);
	RJMP _0x3F
; 0000 007D                     }
; 0000 007E                     else if(readSensor(FRONT_SENSOR) > StandardSensor[0])
_0x37:
	CALL SUBOPT_0x5
	MOVW R0,R30
	LDI  R26,LOW(_StandardSensor)
	LDI  R27,HIGH(_StandardSensor)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x39
; 0000 007F                     {
; 0000 0080                          if(readSensor(RIGHT_SENSOR) < StandardSensor[2])
	CALL SUBOPT_0x8
	MOVW R0,R30
	__POINTW2MN _StandardSensor,4
	CALL __EEPROMRDW
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x3A
; 0000 0081                          {
; 0000 0082                               Direction(HALF);
	CALL SUBOPT_0xA
; 0000 0083                               Direction(RIGHT);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x40
; 0000 0084                               Direction(HALF);
; 0000 0085                          }
; 0000 0086                          else
_0x3A:
; 0000 0087                          {
; 0000 0088                               Direction(HALF);
	CALL SUBOPT_0xA
; 0000 0089                               Direction(LEFT);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
; 0000 008A                               Direction(LEFT);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x40:
	ST   -Y,R31
	ST   -Y,R30
	CALL _Direction
; 0000 008B                               Direction(HALF);
	CALL SUBOPT_0xA
; 0000 008C                          }
; 0000 008D                     }
; 0000 008E                     else
	RJMP _0x3C
_0x39:
; 0000 008F                     {
; 0000 0090                         Direction(HALF);
_0x3F:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x4
; 0000 0091                     }
_0x3C:
; 0000 0092                }
	RJMP _0x34
; 0000 0093 	           break;
; 0000 0094             }
_0x15:
; 0000 0095         }
; 0000 0096     }
_0x12:
	RJMP _0x3
; 0000 0097 }
_0x3D:
	RJMP _0x3D
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "UART1.h"
;#include "Algorithm.h"
;
;void InitializeSensor(void)
; 0001 000D {

	.CSEG
_InitializeSensor:
; 0001 000E      // 발광센서 PORTB 5,6,7
; 0001 000F      PORTB &= 0x1f;
	IN   R30,0x18
	ANDI R30,LOW(0x1F)
	OUT  0x18,R30
; 0001 0010      DDRB |= 0xe0;
	IN   R30,0x17
	ORI  R30,LOW(0xE0)
	OUT  0x17,R30
; 0001 0011      // 수광센서 PORTF 0,1,2
; 0001 0012      PORTF &= 0xf8;
	LDS  R30,98
	ANDI R30,LOW(0xF8)
	STS  98,R30
; 0001 0013      DDRF |= 0xf8;
	LDS  R30,97
	ORI  R30,LOW(0xF8)
	STS  97,R30
; 0001 0014 
; 0001 0015      ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0001 0016      ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0001 0017 }
	RET
;
;unsigned int read_adc(unsigned char adc_input)
; 0001 001A {
_read_adc:
; 0001 001B     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0001 001C     // Delay needed for the stabilization of the ADC input voltage
; 0001 001D     delay_us(10);
	__DELAY_USB 53
; 0001 001E     // Start the AD conversion
; 0001 001F     ADCSRA|=0x40;
	SBI  0x6,6
; 0001 0020     // Wait for the AD conversion to complete
; 0001 0021     while ((ADCSRA & 0x10)==0);
_0x20003:
	SBIS 0x6,4
	RJMP _0x20003
; 0001 0022     ADCSRA|=0x10;
	SBI  0x6,4
; 0001 0023     return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20A0002
; 0001 0024 }
;
;unsigned int readSensor(char si)
; 0001 0027 {
_readSensor:
; 0001 0028      unsigned int ret;
; 0001 0029 
; 0001 002A      switch(si)
	ST   -Y,R17
	ST   -Y,R16
;	si -> Y+2
;	ret -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
; 0001 002B      {
; 0001 002C           case FRONT_SENSOR:
	SBIW R30,0
	BRNE _0x20009
; 0001 002D                PORTB.5=1;
	SBI  0x18,5
; 0001 002E                delay_us(30);
	CALL SUBOPT_0xC
; 0001 002F                ret = read_adc(si);
; 0001 0030                PORTB.5=0;
	CBI  0x18,5
; 0001 0031                break;
	RJMP _0x20008
; 0001 0032           case LEFT_SENSOR:
_0x20009:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2000E
; 0001 0033                PORTB.6=1;
	SBI  0x18,6
; 0001 0034                delay_us(30);
	CALL SUBOPT_0xC
; 0001 0035                ret = read_adc(si);
; 0001 0036                PORTB.6=0;
	CBI  0x18,6
; 0001 0037                break;
	RJMP _0x20008
; 0001 0038           case RIGHT_SENSOR:
_0x2000E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20008
; 0001 0039                PORTB.7=1;
	SBI  0x18,7
; 0001 003A                delay_us(30);
	CALL SUBOPT_0xC
; 0001 003B                ret = read_adc(si);
; 0001 003C                PORTB.7=0;
	CBI  0x18,7
; 0001 003D                break;
; 0001 003E      }
_0x20008:
; 0001 003F      return ret;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0001
; 0001 0040 }
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "UART1.h"
;#include "Algorithm.h"
;int acc=0;
;int acc_allow=0;
;char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};

	.DSEG
;char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
;int LeftstepCount, RightstepCount;		// rotateR과 rotateL의 각각 스텝이 모터에 순서대로 입력되도록 Count
;unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;	// 왼쪽과 오른쪽 모터의 TCNT 속도
;int vel_counter_high_R,vel_counter_high_L;
;unsigned char direction_control;		// 인터럽트 루틴에 방향정보를 전달하기 위한 전역변수
;extern eeprom int StandardSensor[3], CenterStandardSensor[3];
;int vel_counter_high=65380;
;
;     struct {
;          int nStep4perBlock;			// 한 블록 이동시 필요한 모터회전 스텝 정보
;          int nStep4Turn90;			// 90도 턴 이동시 필요한 모터회전 스텝 정보
;     } Information;
;     struct {
;          char LmotorRun;			// 왼쪽 모터가 회전했는지에 대한 Flag
;          char RmotorRun;			// 오른쪽 모터가 회전했는지에 대한 Flag
;     } Flag;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0002 0020 {

	.CSEG
_timer1_ovf_isr:
	CALL SUBOPT_0xD
; 0002 0021      switch(direction_control)
; 0002 0022      {
; 0002 0023           case LEFT:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40009
; 0002 0024                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0xE
	OR   R30,R0
	OUT  0x12,R30
; 0002 0025                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0xE
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0002 0026                LeftstepCount--;
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0002 0027                if(LeftstepCount < 0)
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRGE _0x4000A
; 0002 0028                     LeftstepCount = sizeof(rotateL)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R8,R30
; 0002 0029                break;
_0x4000A:
	RJMP _0x40008
; 0002 002A           case RIGHT:
_0x40009:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x4000C
; 0002 002B           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x4000D
_0x4000C:
; 0002 002C           case FORWARD:
	RJMP _0x4000E
_0x4000D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4000F
_0x4000E:
; 0002 002D           case HALF:
	RJMP _0x40010
_0x4000F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x40008
_0x40010:
; 0002 002E                PORTD |= (rotateL[LeftstepCount]<<4);
	CALL SUBOPT_0xE
	OR   R30,R0
	OUT  0x12,R30
; 0002 002F                PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
	CALL SUBOPT_0xE
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x12,R30
; 0002 0030                LeftstepCount++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0002 0031                LeftstepCount %= sizeof(rotateL);
	MOVW R26,R8
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R8,R30
; 0002 0032                break;
; 0002 0033      }
_0x40008:
; 0002 0034      Flag.LmotorRun = TRUE;
	LDI  R30,LOW(1)
	STS  _Flag,R30
; 0002 0035 
; 0002 0036      TCNT1H = VelocityLeftmotorTCNT1 >> 8;
	LDS  R30,_VelocityLeftmotorTCNT1+1
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0002 0037      TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
	LDS  R30,_VelocityLeftmotorTCNT1
	OUT  0x2C,R30
; 0002 0038 }
	RJMP _0x4006B
;
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0002 003B {
_timer3_ovf_isr:
	CALL SUBOPT_0xD
; 0002 003C      switch(direction_control)
; 0002 003D      {
; 0002 003E           case RIGHT:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ _0x40016
; 0002 003F           case BACK:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x40017
_0x40016:
; 0002 0040                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0xF
	OR   R30,R0
	OUT  0x3,R30
; 0002 0041                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0xF
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0002 0042                RightstepCount--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
; 0002 0043                if(RightstepCount < 0)
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRGE _0x40018
; 0002 0044                     RightstepCount = sizeof(rotateR)-1;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R10,R30
; 0002 0045                break;
_0x40018:
	RJMP _0x40014
; 0002 0046           case FORWARD:
_0x40017:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x4001A
; 0002 0047           case HALF:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4001B
_0x4001A:
; 0002 0048           case LEFT:
	RJMP _0x4001C
_0x4001B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40014
_0x4001C:
; 0002 0049                PORTE |= (rotateR[RightstepCount]<<4);
	CALL SUBOPT_0xF
	OR   R30,R0
	OUT  0x3,R30
; 0002 004A                PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
	CALL SUBOPT_0xF
	SUBI R30,-LOW(15)
	AND  R30,R0
	OUT  0x3,R30
; 0002 004B                RightstepCount++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0002 004C                RightstepCount %= sizeof(rotateR);
	MOVW R26,R10
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R10,R30
; 0002 004D                break;
; 0002 004E      }
_0x40014:
; 0002 004F      Flag.RmotorRun = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Flag,1
; 0002 0050 
; 0002 0051      TCNT3H = VelocityRightmotorTCNT3 >> 8;
	LDS  R30,_VelocityRightmotorTCNT3+1
	STS  137,R30
; 0002 0052      TCNT3L = VelocityRightmotorTCNT3 & 0xff;
	LDS  R30,_VelocityRightmotorTCNT3
	STS  136,R30
; 0002 0053 }
_0x4006B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void InitializeStepMotor(void)
; 0002 0056 {
_InitializeStepMotor:
; 0002 0057 
; 0002 0058      float distance4perStep;
; 0002 0059 
; 0002 005A      PORTD&=0x0F;
	SBIW R28,4
;	distance4perStep -> Y+0
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0002 005B      DDRD|=0xF0;
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
; 0002 005C 
; 0002 005D      PORTE&=0x0F;
	IN   R30,0x3
	ANDI R30,LOW(0xF)
	OUT  0x3,R30
; 0002 005E      DDRE|=0xF0;
	IN   R30,0x2
	ORI  R30,LOW(0xF0)
	OUT  0x2,R30
; 0002 005F 
; 0002 0060      TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0002 0061      TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0002 0062      TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0002 0063      TCNT1L=0x00;
	OUT  0x2C,R30
; 0002 0064      ICR1H=0x00;
	OUT  0x27,R30
; 0002 0065      ICR1L=0x00;
	OUT  0x26,R30
; 0002 0066      OCR1AH=0x00;
	OUT  0x2B,R30
; 0002 0067      OCR1AL=0x00;
	OUT  0x2A,R30
; 0002 0068      OCR1BH=0x00;
	OUT  0x29,R30
; 0002 0069      OCR1BL=0x00;
	OUT  0x28,R30
; 0002 006A      OCR1CH=0x00;
	STS  121,R30
; 0002 006B      OCR1CL=0x00;
	STS  120,R30
; 0002 006C 
; 0002 006D      TCCR3A=0x00;
	STS  139,R30
; 0002 006E      TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0002 006F      TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0002 0070      TCNT3L=0x00;
	STS  136,R30
; 0002 0071      ICR3H=0x00;
	STS  129,R30
; 0002 0072      ICR3L=0x00;
	STS  128,R30
; 0002 0073      OCR3AH=0x00;
	STS  135,R30
; 0002 0074      OCR3AL=0x00;
	STS  134,R30
; 0002 0075      OCR3BH=0x00;
	STS  133,R30
; 0002 0076      OCR3BL=0x00;
	STS  132,R30
; 0002 0077      OCR3CH=0x00;
	STS  131,R30
; 0002 0078      OCR3CL=0x00;
	STS  130,R30
; 0002 0079 
; 0002 007A      TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0002 007B      ETIMSK=0x04;
	STS  125,R30
; 0002 007C 
; 0002 007D 	distance4perStep = (float)(3.5 * TIRE_RAD / (float)MOTOR_STEP);
	__GETD1N 0x3EEBE8AB
	CALL __PUTD1S0
; 0002 007E 	Information.nStep4perBlock = (int)((float)205 / distance4perStep);
	__GETD2N 0x434D0000
	CALL __DIVF21
	CALL __CFD1
	STS  _Information,R30
	STS  _Information+1,R31
; 0002 007F 	Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/3.41)/distance4perStep);
	CALL __GETD1S0
	__GETD2N 0x42A5D4F5
	CALL __DIVF21
	CALL __CFD1
	__PUTW1MN _Information,2
; 0002 0080 }
	ADIW R28,4
	RET
;
;int adjustmouse(void)
; 0002 0083 {
_adjustmouse:
; 0002 0084 	int adjLeftSensor,adjRightSensor;
; 0002 0085 	int adjflagcnt = 0;
; 0002 0086 
; 0002 0087 	adjLeftSensor = readSensor(LEFT_SENSOR);
	CALL __SAVELOCR6
;	adjLeftSensor -> R16,R17
;	adjRightSensor -> R18,R19
;	adjflagcnt -> R20,R21
	__GETWRN 20,21,0
	CALL SUBOPT_0x7
	MOVW R16,R30
; 0002 0088 	adjRightSensor = readSensor(RIGHT_SENSOR);
	CALL SUBOPT_0x8
	MOVW R18,R30
; 0002 0089 
; 0002 008A 	vel_counter_high_L=VelocityLeftmotorTCNT1;
	LDS  R30,_VelocityLeftmotorTCNT1
	LDS  R31,_VelocityLeftmotorTCNT1+1
	CALL SUBOPT_0x10
; 0002 008B     	vel_counter_high_R=VelocityRightmotorTCNT3;
	__GETWRMN 12,13,0,_VelocityRightmotorTCNT3
; 0002 008C 
; 0002 008D 	if((adjRightSensor < StandardSensor[2])		// 오른쪽 벽이 존재하지 않을 경우
; 0002 008E 	|| (adjLeftSensor < StandardSensor[1]))		// 왼쪽 벽이 존재하지 않을 경우
	__POINTW2MN _StandardSensor,4
	CALL __EEPROMRDW
	CP   R18,R30
	CPC  R19,R31
	BRLT _0x4001F
	__POINTW2MN _StandardSensor,2
	CALL __EEPROMRDW
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x4001E
_0x4001F:
; 0002 008F 	{
; 0002 0090 		vel_counter_high_L = vel_counter_high;	// 속도를 같게하고 리턴
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0002 0091 		vel_counter_high_R = vel_counter_high;
; 0002 0092 		return 0;
	RJMP _0x20A0005
; 0002 0093 	}
; 0002 0094 
; 0002 0095 	if(adjRightSensor < CenterStandardSensor[2])	// 오른쪽 벽이 멀 경우
_0x4001E:
	__POINTW2MN _CenterStandardSensor,4
	CALL __EEPROMRDW
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x40021
; 0002 0096 	{
; 0002 0097 		vel_counter_high_L+=5;
	CALL SUBOPT_0x13
	ADIW R30,5
	CALL SUBOPT_0x10
; 0002 0098 		vel_counter_high_R-=5;
	MOVW R30,R12
	SBIW R30,5
	MOVW R12,R30
; 0002 0099 		if(vel_counter_high_L > vel_counter_high+35)
	CALL SUBOPT_0x11
	ADIW R30,35
	LDS  R26,_vel_counter_high_L
	LDS  R27,_vel_counter_high_L+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x40022
; 0002 009A 		{
; 0002 009B 			vel_counter_high_L = vel_counter_high+35;
	CALL SUBOPT_0x11
	ADIW R30,35
	CALL SUBOPT_0x10
; 0002 009C 		}
; 0002 009D 
; 0002 009E 		if(vel_counter_high_R < (vel_counter_high - 35))
_0x40022:
	CALL SUBOPT_0x11
	SBIW R30,35
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x40023
; 0002 009F 		{
; 0002 00A0 			vel_counter_high_R = (vel_counter_high - 35);
	CALL SUBOPT_0x11
	SBIW R30,35
	MOVW R12,R30
; 0002 00A1 		}
; 0002 00A2 	}
_0x40023:
; 0002 00A3 	else
	RJMP _0x40024
_0x40021:
; 0002 00A4 	adjflagcnt++;
	__ADDWRN 20,21,1
; 0002 00A5 
; 0002 00A6 	if(adjLeftSensor < CenterStandardSensor[1])	// 왼쪽 벽이 멀 경우
_0x40024:
	__POINTW2MN _CenterStandardSensor,2
	CALL __EEPROMRDW
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x40025
; 0002 00A7 	{
; 0002 00A8 		vel_counter_high_L-=5;
	CALL SUBOPT_0x13
	SBIW R30,5
	CALL SUBOPT_0x10
; 0002 00A9 		vel_counter_high_R+=5;
	MOVW R30,R12
	ADIW R30,5
	MOVW R12,R30
; 0002 00AA 		if(vel_counter_high_R > vel_counter_high+35)
	CALL SUBOPT_0x11
	ADIW R30,35
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x40026
; 0002 00AB 		{
; 0002 00AC 			vel_counter_high_R = vel_counter_high+35;
	CALL SUBOPT_0x11
	ADIW R30,35
	MOVW R12,R30
; 0002 00AD 		}
; 0002 00AE 		if(vel_counter_high_L < (vel_counter_high - 35))
_0x40026:
	CALL SUBOPT_0x11
	SBIW R30,35
	LDS  R26,_vel_counter_high_L
	LDS  R27,_vel_counter_high_L+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x40027
; 0002 00AF 		{
; 0002 00B0 			vel_counter_high_L = (vel_counter_high - 35);
	CALL SUBOPT_0x11
	SBIW R30,35
	CALL SUBOPT_0x10
; 0002 00B1 		}
; 0002 00B2 	}
_0x40027:
; 0002 00B3 	else
	RJMP _0x40028
_0x40025:
; 0002 00B4 	adjflagcnt++;
	__ADDWRN 20,21,1
; 0002 00B5 
; 0002 00B6 	if(adjflagcnt == 2)				// 오른쪽 벽과 왼쪽 벽이 둘다 멀지 않을 경우
_0x40028:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x40029
; 0002 00B7 	{							// 속도 동일하게
; 0002 00B8 		vel_counter_high_L = vel_counter_high;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
; 0002 00B9 		vel_counter_high_R = vel_counter_high;
; 0002 00BA 		return 0;
	RJMP _0x20A0005
; 0002 00BB 	}
; 0002 00BC 		return 1;
_0x40029:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __LOADLOCR6
	RJMP _0x20A0005
; 0002 00BD }
;
;void Direction(int mode)
; 0002 00C0 {
_Direction:
; 0002 00C1      int LStepCount = 0, RStepCount = 0;
; 0002 00C2 
; 0002 00C3      TCCR1B = 0x04;
	CALL __SAVELOCR4
;	mode -> Y+4
;	LStepCount -> R16,R17
;	RStepCount -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0002 00C4      TCCR3B = 0x04;
	STS  138,R30
; 0002 00C5 
; 0002 00C6      direction_control = mode;
	LDD  R30,Y+4
	STS  _direction_control,R30
; 0002 00C7 
; 0002 00C8      Flag.LmotorRun = FALSE;
	LDI  R30,LOW(0)
	STS  _Flag,R30
; 0002 00C9      Flag.RmotorRun = FALSE;
	__PUTB1MN _Flag,1
; 0002 00CA 
; 0002 00CB      switch(mode)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
; 0002 00CC      {
; 0002 00CD      case FORWARD:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4002D
; 0002 00CE           while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
_0x4002E:
	CALL SUBOPT_0x14
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x40031
	CALL SUBOPT_0x14
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x40030
_0x40031:
; 0002 00CF           {
; 0002 00D0                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x40033
; 0002 00D1                {
; 0002 00D2                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 00D3                     Flag.LmotorRun = FALSE;
; 0002 00D4                }
; 0002 00D5                if(Flag.RmotorRun)
_0x40033:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40034
; 0002 00D6                {
; 0002 00D7                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 00D8                     Flag.RmotorRun = FALSE;
; 0002 00D9                }
; 0002 00DA           }
_0x40034:
	RJMP _0x4002E
_0x40030:
; 0002 00DB           break;
	RJMP _0x4002C
; 0002 00DC 
; 0002 00DD      case HALF:
_0x4002D:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x40035
; 0002 00DE           while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
_0x40036:
	CALL SUBOPT_0x17
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x40039
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x40038
_0x40039:
; 0002 00DF           {
; 0002 00E0                if(readSensor(FRONT_SENSOR) > CenterStandardSensor[0])
	CALL SUBOPT_0x5
	MOVW R0,R30
	LDI  R26,LOW(_CenterStandardSensor)
	LDI  R27,HIGH(_CenterStandardSensor)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BRLO _0x40038
; 0002 00E1                {
; 0002 00E2                     break;
; 0002 00E3                }
; 0002 00E4                if(Flag.LmotorRun || Flag.RmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BRNE _0x4003D
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x4003C
_0x4003D:
; 0002 00E5                {
; 0002 00E6                     adjustmouse();
	RCALL _adjustmouse
; 0002 00E7                     VelocityLeftmotorTCNT1=vel_counter_high_L;
	CALL SUBOPT_0x13
	CALL SUBOPT_0x0
; 0002 00E8                     VelocityRightmotorTCNT3=vel_counter_high_R;
	__PUTWMRN _VelocityRightmotorTCNT3,0,12,13
; 0002 00E9                }
; 0002 00EA                if(Flag.LmotorRun)
_0x4003C:
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x4003F
; 0002 00EB                {
; 0002 00EC                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 00ED                     Flag.LmotorRun = FALSE;
; 0002 00EE                }
; 0002 00EF                if(Flag.RmotorRun)
_0x4003F:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40040
; 0002 00F0                {
; 0002 00F1                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 00F2                     Flag.RmotorRun = FALSE;
; 0002 00F3                }
; 0002 00F4           }
_0x40040:
	RJMP _0x40036
_0x40038:
; 0002 00F5 
; 0002 00F6           break;
	RJMP _0x4002C
; 0002 00F7      case LEFT:
_0x40035:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x40041
; 0002 00F8           VelocityLeftmotorTCNT1 = 65350;	// 왼쪽 모터의 속도 (65200 ~ 65535)
	CALL SUBOPT_0x18
; 0002 00F9           VelocityRightmotorTCNT3 = 65350;	// 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 00FA           while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
_0x40042:
	CALL SUBOPT_0x19
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x40045
	CALL SUBOPT_0x19
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x40044
_0x40045:
; 0002 00FB           {
; 0002 00FC                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x40047
; 0002 00FD                {
; 0002 00FE                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 00FF                     Flag.LmotorRun = FALSE;
; 0002 0100                }
; 0002 0101                if(Flag.RmotorRun)
_0x40047:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40048
; 0002 0102                {
; 0002 0103                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 0104                     Flag.RmotorRun = FALSE;
; 0002 0105                }
; 0002 0106           }
_0x40048:
	RJMP _0x40042
_0x40044:
; 0002 0107           break;
	RJMP _0x4002C
; 0002 0108      case RIGHT:
_0x40041:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x40049
; 0002 0109           VelocityLeftmotorTCNT1 = 65350;	// 왼쪽 모터의 속도 (65200 ~ 65535)
	CALL SUBOPT_0x18
; 0002 010A           VelocityRightmotorTCNT3 = 65350;	// 오른쪽 모터의 속도 (65200 ~ 65535)
; 0002 010B           while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
_0x4004A:
	CALL SUBOPT_0x19
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x4004D
	CALL SUBOPT_0x19
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x4004C
_0x4004D:
; 0002 010C           {
; 0002 010D                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x4004F
; 0002 010E                {
; 0002 010F                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 0110                     Flag.LmotorRun = FALSE;
; 0002 0111                }
; 0002 0112                if(Flag.RmotorRun)
_0x4004F:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40050
; 0002 0113                {
; 0002 0114                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 0115                     Flag.RmotorRun = FALSE;
; 0002 0116                }
; 0002 0117           }
_0x40050:
	RJMP _0x4004A
_0x4004C:
; 0002 0118           break;
	RJMP _0x4002C
; 0002 0119      case BACK:
_0x40049:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x40051
; 0002 011A           VelocityLeftmotorTCNT1 = 65300;	// 왼쪽 모터의 속도 (65200 ~ 65535)
	LDI  R30,LOW(65300)
	LDI  R31,HIGH(65300)
	CALL SUBOPT_0x0
; 0002 011B           VelocityRightmotorTCNT3 = 65300;	// 오른쪽 모터의 속도 (65200 ~ 65535)
	LDI  R30,LOW(65300)
	LDI  R31,HIGH(65300)
	CALL SUBOPT_0x1
; 0002 011C           while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
_0x40052:
	__GETW2MN _Information,2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MULW12
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x40055
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x40054
_0x40055:
; 0002 011D           {
; 0002 011E                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x40057
; 0002 011F                {
; 0002 0120                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 0121                     Flag.LmotorRun = FALSE;
; 0002 0122                }
; 0002 0123                if(Flag.RmotorRun)
_0x40057:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40058
; 0002 0124                {
; 0002 0125                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 0126                     Flag.RmotorRun = FALSE;
; 0002 0127                }
; 0002 0128           }
_0x40058:
	RJMP _0x40052
_0x40054:
; 0002 0129           break;
	RJMP _0x4002C
; 0002 012A      case QUARTER:
_0x40051:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x40059
; 0002 012B           while(LStepCount<((Information.nStep4perBlock>>1)>>1) || RStepCount<((Information.nStep4perBlock>>1)>>1))
_0x4005A:
	CALL SUBOPT_0x17
	ASR  R31
	ROR  R30
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x4005D
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x4005C
_0x4005D:
; 0002 012C           {
; 0002 012D 
; 0002 012E                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x4005F
; 0002 012F                {
; 0002 0130                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 0131                     Flag.LmotorRun = FALSE;
; 0002 0132                }
; 0002 0133                if(Flag.RmotorRun)
_0x4005F:
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40060
; 0002 0134                {
; 0002 0135                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 0136                     Flag.RmotorRun = FALSE;
; 0002 0137                }
; 0002 0138           }
_0x40060:
	RJMP _0x4005A
_0x4005C:
; 0002 0139 
; 0002 013A           break;
	RJMP _0x4002C
; 0002 013B      case TURN_L:
_0x40059:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x40061
; 0002 013C           while( RStepCount<(Information.nStep4perBlock>>1))
_0x40062:
	CALL SUBOPT_0x17
	CP   R18,R30
	CPC  R19,R31
	BRGE _0x40064
; 0002 013D           {
; 0002 013E 
; 0002 013F 
; 0002 0140                if(Flag.RmotorRun)
	__GETB1MN _Flag,1
	CPI  R30,0
	BREQ _0x40065
; 0002 0141                {
; 0002 0142                     RStepCount++;
	CALL SUBOPT_0x16
; 0002 0143                     Flag.RmotorRun = FALSE;
; 0002 0144                }
; 0002 0145           }
_0x40065:
	RJMP _0x40062
_0x40064:
; 0002 0146 
; 0002 0147           break;
	RJMP _0x4002C
; 0002 0148      case TURN_R:
_0x40061:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x4002C
; 0002 0149           while(LStepCount<(Information.nStep4perBlock>>1) )
_0x40067:
	CALL SUBOPT_0x17
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x40069
; 0002 014A           {
; 0002 014B 
; 0002 014C                if(Flag.LmotorRun)
	LDS  R30,_Flag
	CPI  R30,0
	BREQ _0x4006A
; 0002 014D                {
; 0002 014E                     LStepCount++;
	CALL SUBOPT_0x15
; 0002 014F                     Flag.LmotorRun = FALSE;
; 0002 0150                }
; 0002 0151           }
_0x4006A:
	RJMP _0x40067
_0x40069:
; 0002 0152 
; 0002 0153           break;
; 0002 0154      }
_0x4002C:
; 0002 0155      TCCR1B = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0002 0156      TCCR3B = 0x00;
	STS  138,R30
; 0002 0157 }
	CALL __LOADLOCR4
_0x20A0005:
	ADIW R28,6
	RET
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "Algorithm.h"
;#include <delay.h>
;
;struct Buttons
;{
;    char SW1;
;    char SW2;
;} ;
; struct Buttons Button;
;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0003 0012 {

	.CSEG
_ext_int0_isr:
	CALL SUBOPT_0x1A
; 0003 0013     delay_ms(200);
; 0003 0014     Button.SW1 = TRUE;
	LDI  R30,LOW(1)
	STS  _Button,R30
; 0003 0015 }
	RJMP _0x60003
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0003 0018 {
_ext_int1_isr:
	CALL SUBOPT_0x1A
; 0003 0019     delay_ms(200);
; 0003 001A     Button.SW2 = TRUE;
	LDI  R30,LOW(1)
	__PUTB1MN _Button,1
; 0003 001B }
_0x60003:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;void InitializeSwitch(void)
; 0003 001E {
_InitializeSwitch:
; 0003 001F //스위치 PORTD 0,1
; 0003 0020 	PORTD &= 0xfc;
	IN   R30,0x12
	ANDI R30,LOW(0xFC)
	OUT  0x12,R30
; 0003 0021 	DDRD &= 0xfc;
	IN   R30,0x11
	ANDI R30,LOW(0xFC)
	OUT  0x11,R30
; 0003 0022     EICRA=0x0A;
	LDI  R30,LOW(10)
	STS  106,R30
; 0003 0023     EICRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3A,R30
; 0003 0024     EIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0003 0025     EIFR=0x03;
	OUT  0x38,R30
; 0003 0026 }
	RET
;
;char SW1(void)
; 0003 0029 {
_SW1:
; 0003 002A     char ret;
; 0003 002B     ret=Button.SW1;
	ST   -Y,R17
;	ret -> R17
	LDS  R17,_Button
; 0003 002C     Button.SW1=FALSE;
	LDI  R30,LOW(0)
	STS  _Button,R30
; 0003 002D     return ret;
	RJMP _0x20A0004
; 0003 002E }
;
;char SW2(void)
; 0003 0031 {
_SW2:
; 0003 0032     char ret;
; 0003 0033     ret=Button.SW2;
	ST   -Y,R17
;	ret -> R17
	__GETBRMN 17,_Button,1
; 0003 0034     Button.SW2=FALSE;
	LDI  R30,LOW(0)
	__PUTB1MN _Button,1
; 0003 0035     return ret;
_0x20A0004:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0003 0036 }
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "UART1.h"
;#include "Algorithm.h"
;
;void InitializeLED(void)
; 0004 000D {

	.CSEG
_InitializeLED:
; 0004 000E     //LED-PORTF 4,5,6,7
; 0004 000F     PORTF &= 0x0F;
	LDS  R30,98
	ANDI R30,LOW(0xF)
	STS  98,R30
; 0004 0010     DDRF |= 0xF0;
	LDS  R30,97
	ORI  R30,LOW(0xF0)
	STS  97,R30
; 0004 0011 }
	RET
;
;void LED_OFF(int nLED)
; 0004 0014 {
_LED_OFF:
; 0004 0015 	PORTF |= nLED;
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R30,X
	LD   R26,Y
	OR   R30,R26
	RJMP _0x20A0003
; 0004 0016 }
;
;void LED_ON(int nLED)
; 0004 0019 {
_LED_ON:
; 0004 001A 	PORTF &= ~(nLED);
;	nLED -> Y+0
	LDI  R26,LOW(98)
	LDI  R27,HIGH(98)
	MOV  R0,R26
	LD   R26,X
	LD   R30,Y
	COM  R30
	AND  R30,R26
_0x20A0003:
	MOV  R26,R0
	ST   X,R30
; 0004 001B }
	ADIW R28,2
	RET
;
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <math.h>
;#include "Sensor.h"
;#include "StepMotor.h"
;#include "LED.h"
;#include "switch.h"
;#include "UART1.h"
;#include "Algorithm.h"
;
;unsigned char poutput;
;
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0005 0012 {

	.CSEG
; 0005 0013 char status,data;
; 0005 0014 while (1)
;	status -> R17
;	data -> R16
; 0005 0015 {
; 0005 0016 while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0005 0017 data=UDR1;
; 0005 0018 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0005 0019 return data;
; 0005 001A };
; 0005 001B }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0005 0021 {
; 0005 0022 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0005 0023 UDR1=c;
; 0005 0024 }
;#pragma used-
;
;void putchar(char c)
; 0005 0028 {
_putchar:
; 0005 0029 switch (poutput)
;	c -> Y+0
	LDS  R30,_poutput
	LDI  R31,0
; 0005 002A {
; 0005 002B case USART0: // the output will be directed to USART0
	SBIW R30,0
	BRNE _0xA0010
; 0005 002C while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0xA0011:
	SBIS 0xB,5
	RJMP _0xA0011
; 0005 002D UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0005 002E break;
	RJMP _0xA000F
; 0005 002F 
; 0005 0030 case USART1: // the output will be directed to USART1
_0xA0010:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA000F
; 0005 0031 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
_0xA0015:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0xA0015
; 0005 0032 UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0005 0033 };
_0xA000F:
; 0005 0034 }
_0x20A0002:
	ADIW R28,1
	RET
;
;unsigned char getchar(void)
; 0005 0037 {
; 0005 0038 switch (poutput)
; 0005 0039 {
; 0005 003A case USART0: // the input will be directed to USART0
; 0005 003B while ((UCSR0A & RX_COMPLETE)==0);
; 0005 003C return UDR0;
; 0005 003D break;
; 0005 003E 
; 0005 003F case USART1: // the input will be directed to USART1
; 0005 0040 while ((UCSR1A & RX_COMPLETE)==0);
; 0005 0041 return UDR1;
; 0005 0042 };
; 0005 0043 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0001:
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x1B
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x1B
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x1C
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1D
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1E
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x1B
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1D
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1D
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_VelocityLeftmotorTCNT1:
	.BYTE 0x2
_VelocityRightmotorTCNT3:
	.BYTE 0x2

	.ESEG
_StandardSensor:
	.BYTE 0x6
_CenterStandardSensor:
	.BYTE 0x6

	.DSEG
_poutput:
	.BYTE 0x1
_rotateR:
	.BYTE 0x8
_rotateL:
	.BYTE 0x8
_vel_counter_high_L:
	.BYTE 0x2
_direction_control:
	.BYTE 0x1
_vel_counter_high:
	.BYTE 0x2
_Information:
	.BYTE 0x4
_Flag:
	.BYTE 0x2
_Button:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	STS  _VelocityLeftmotorTCNT1,R30
	STS  _VelocityLeftmotorTCNT1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	STS  _VelocityRightmotorTCNT3,R30
	STS  _VelocityRightmotorTCNT3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_OFF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Direction

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _readSensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _LED_ON

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	__DELAY_USB 160
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _read_adc
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_direction_control
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE:
	IN   R0,18
	LDI  R26,LOW(_rotateL)
	LDI  R27,HIGH(_rotateL)
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	IN   R0,3
	LDI  R26,LOW(_rotateR)
	LDI  R27,HIGH(_rotateR)
	ADD  R26,R10
	ADC  R27,R11
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	STS  _vel_counter_high_L,R30
	STS  _vel_counter_high_L+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11:
	LDS  R30,_vel_counter_high
	LDS  R31,_vel_counter_high+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0x10
	__GETWRMN 12,13,0,_vel_counter_high
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __LOADLOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDS  R30,_vel_counter_high_L
	LDS  R31,_vel_counter_high_L+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	LDS  R30,_Information
	LDS  R31,_Information+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	STS  _Flag,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x16:
	__ADDWRN 18,19,1
	LDI  R30,LOW(0)
	__PUTB1MN _Flag,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x14
	ASR  R31
	ROR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(65350)
	LDI  R31,HIGH(65350)
	RCALL SUBOPT_0x0
	LDI  R30,LOW(65350)
	LDI  R31,HIGH(65350)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__GETW1MN _Information,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1A:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1B:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
