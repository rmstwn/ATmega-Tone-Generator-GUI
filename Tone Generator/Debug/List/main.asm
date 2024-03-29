
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega162
;Program type           : Application
;Clock frequency        : 12,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega162
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	.EQU MCUCSR=0x34
	.EQU MCUCR=0x35
	.EQU EMCUCR=0x36
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _flag=R5
	.DEF _nada=R4
	.DEF _flagSerial=R7
	.DEF _count=R8
	.DEF _count_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _rx_wr_index1=R6
	.DEF _rx_rd_index1=R13
	.DEF _rx_counter1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x29:
	.DB  0x1,0x0,0x3,0x0,0x1,0x0,0x3,0x0
	.DB  0x4,0x0,0x5,0x0,0x5,0x0,0x0,0x0
	.DB  0x7,0x0,0x8,0x0,0x7,0x0,0x8,0x0
	.DB  0x7,0x0,0x5,0x0,0x58,0x0,0x0,0x0
	.DB  0x1,0x0,0x3,0x0,0x1,0x0,0x3,0x0
	.DB  0x4,0x0,0x5,0x0,0x5,0x0,0x0,0x0
	.DB  0x7,0x0,0x8,0x0,0x7,0x0,0x8,0x0
	.DB  0x7,0x0,0x5,0x0,0x58,0x0,0x1,0x0
	.DB  0x3,0x0,0x5,0x0,0x58,0x0,0x4,0x0
	.DB  0x4,0x0,0x5,0x0,0x4,0x0,0x3,0x0
	.DB  0x1,0x0,0x4,0x0,0x3,0x0,0x1,0x0
	.DB  0x58,0x0,0x0,0x0,0x1,0x0,0x3,0x0
	.DB  0x5,0x0,0x58,0x0,0x4,0x0,0x4,0x0
	.DB  0x5,0x0,0x4,0x0,0x3,0x0,0x1,0x0
	.DB  0x4,0x0,0x3,0x0,0x1,0x0,0x58,0x0
	.DB  0x0,0x0,0x63
_0x2A:
	.DB  0x1,0x0,0x1,0x0,0x5,0x0,0x5,0x0
	.DB  0x6,0x0,0x6,0x0,0x5,0x0,0x58,0x0
	.DB  0x4,0x0,0x4,0x0,0x3,0x0,0x3,0x0
	.DB  0x2,0x0,0x2,0x0,0x1,0x0,0x58,0x0
	.DB  0x5,0x0,0x5,0x0,0x4,0x0,0x4,0x0
	.DB  0x3,0x0,0x3,0x0,0x2,0x0,0x58,0x0
	.DB  0x5,0x0,0x5,0x0,0x4,0x0,0x4,0x0
	.DB  0x3,0x0,0x3,0x0,0x2,0x0,0x58,0x0
	.DB  0x1,0x0,0x1,0x0,0x5,0x0,0x5,0x0
	.DB  0x6,0x0,0x6,0x0,0x5,0x0,0x58,0x0
	.DB  0x4,0x0,0x4,0x0,0x3,0x0,0x3,0x0
	.DB  0x2,0x0,0x2,0x0,0x1,0x0,0x58,0x0
	.DB  0x63
_0x2B:
	.DB  0x1,0x0,0x2,0x0,0x3,0x0,0x4,0x0
	.DB  0x5,0x0,0x3,0x0,0x1,0x0,0x58,0x0
	.DB  0x6,0x0,0x8,0x0,0x7,0x0,0x6,0x0
	.DB  0x5,0x0,0x58,0x0,0x4,0x0,0x6,0x0
	.DB  0x5,0x0,0x4,0x0,0x3,0x0,0x1,0x0
	.DB  0x58,0x0,0x2,0x0,0x4,0x0,0x3,0x0
	.DB  0x2,0x0,0x1,0x0,0x58,0x0,0x4,0x0
	.DB  0x3,0x0,0x4,0x0,0x6,0x0,0x5,0x0
	.DB  0x6,0x0,0x5,0x0,0x3,0x0,0x1,0x0
	.DB  0x3,0x0,0x2,0x0,0x3,0x0,0x4,0x0
	.DB  0x5,0x0,0x3,0x0,0x58,0x0,0x4,0x0
	.DB  0x3,0x0,0x4,0x0,0x6,0x0,0x5,0x0
	.DB  0x6,0x0,0x5,0x0,0x3,0x0,0x1,0x0
	.DB  0x3,0x0,0x2,0x0,0x3,0x0,0x4,0x0
	.DB  0x5,0x0,0x3,0x0,0x58,0x0,0x63
_0x2C:
	.DB  0x2,0x0,0x3,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x2,0x0,0x3,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x2,0x0,0x3,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x5,0x0,0x58,0x0
	.DB  0x5,0x0,0x58,0x0,0x4,0x0,0x63
_0x2D:
	.DB  0x1,0x0,0x2,0x0,0x3,0x0,0x4,0x0
	.DB  0x5,0x0,0x6,0x0,0x7,0x0,0x8,0x0
	.DB  0x58,0x0,0x63

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x7B
	.DW  _gundulPacul
	.DW  _0x29*2

	.DW  0x61
	.DW  _Twinkle
	.DW  _0x2A*2

	.DW  0x77
	.DW  _ibuKitakartini
	.DW  _0x2B*2

	.DW  0x5F
	.DW  _babyShark
	.DW  _0x2C*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30
	OUT  EMCUCR,R30

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
	.ORG 0x200

	.CSEG
;/*******************************************************
; This program was created by the
; CodeWizardAVR V3.12 Advanced
; Automatic Program Generator
; � Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
; http://www.hpinfotech.com
;
; Project :
; Version :
; Date    : 04/11/2019
; Author  :
; Company :
; Comments:
;
;
; Chip type               : ATmega162
; Program type            : Application
; AVR Core Clock frequency: 12,000000 MHz
; Memory model            : Small
; External RAM size       : 0
; Data Stack size         : 256
; *******************************************************/
;
;#include <mega162.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif
;  #include <delay.h>
;  // Declare your global variables here
;
;  #define DATA_REGISTER_EMPTY (1<<UDRE0)
;  #define RX_COMPLETE (1<<RXC0)
;  #define FRAMING_ERROR (1<<FE0)
;  #define PARITY_ERROR (1<<UPE0)
;  #define DATA_OVERRUN (1<<DOR0)
;
;  //Bunyi nada : do re mi fa sol la si do
;  //Frekuensi : 264 297 330 352 396 440 495 528 hz
;  #define doFreq 262
;  #define reFreq 294
;  #define miFreq 330
;  #define faFreq 350
;  #define solFreq 392
;  #define laFreq 440
;  #define siFreq 494
;  #define DoFreq 528
;
;  #ifndef RXB8
;  #define RXB8 1
;  #endif
;
;  #ifndef TXB8
;  #define TXB8 0
;  #endif
;
;  #ifndef UPE
;  #define UPE 2
;  #endif
;
;  #ifndef DOR
;  #define DOR 3
;  #endif
;
;  #ifndef FE
;  #define FE 4
;  #endif
;
;  #ifndef UDRE
;  #define UDRE 5
;  #endif
;
;  #ifndef RXC
;  #define RXC 7
;  #endif
;
;  char flag, nada, flagSerial;
;int count, i;
;void putchar1(char c);
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 8
;  char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;  unsigned char rx_wr_index1=0, rx_rd_index1=0;
;#else
;  unsigned int rx_wr_index1=0, rx_rd_index1=0;
;#endif
;
;  #if RX_BUFFER_SIZE1 < 256
;  unsigned char rx_counter1=0;
;#else
;  unsigned int rx_counter1=0;
;#endif
;
;  // This flag is set on USART1 Receiver buffer overflow
;  bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 0062 {

	.CSEG
_usart1_rx_isr:
; .FSTART _usart1_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0063   char status, data;
; 0000 0064   status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,2
; 0000 0065   data=UDR1;
	IN   R16,3
; 0000 0066   nada=UDR1;
	IN   R4,3
; 0000 0067   if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0068   {
; 0000 0069     //   rx_buffer1[rx_wr_index1++]=data;
; 0000 006A 
; 0000 006B     //#if RX_BUFFER_SIZE1 == 256
; 0000 006C     //   // special case for receiver buffer size=256
; 0000 006D     //   if (++rx_counter1 == 0) rx_buffer_overflow1=1;
; 0000 006E     //#else
; 0000 006F     //   if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
; 0000 0070     //   if (++rx_counter1 == RX_BUFFER_SIZE1)
; 0000 0071     //      {
; 0000 0072     //      rx_counter1=0;
; 0000 0073     //      rx_buffer_overflow1=1;
; 0000 0074     //      }
; 0000 0075     //#endif
; 0000 0076     /*--------------------*/
; 0000 0077     if (data=='#')
	CPI  R16,35
	BRNE _0x4
; 0000 0078     {
; 0000 0079       flagSerial=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 007A       count=0;
	CLR  R8
	CLR  R9
; 0000 007B     } else {
	RJMP _0x5
_0x4:
; 0000 007C       rx_buffer1[count]=data;
	MOVW R30,R8
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 007D       count++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 007E     }
_0x5:
; 0000 007F 
; 0000 0080     if (data=='!'&&flagSerial==1) {//Input data
	CPI  R16,33
	BRNE _0x7
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 0081       flagSerial=0;
	CLR  R7
; 0000 0082       flag=rx_buffer1[0];
	LDS  R5,_rx_buffer1
; 0000 0083       nada=rx_buffer1[1];
	__GETBRMN 4,_rx_buffer1,1
; 0000 0084     }
; 0000 0085   }
_0x6:
; 0000 0086 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;  char getchar1(void)
; 0000 008B {
; 0000 008C   char data;
; 0000 008D   while (rx_counter1==0);
;	data -> R17
; 0000 008E   data=rx_buffer1[rx_rd_index1++];
; 0000 008F   #if RX_BUFFER_SIZE1 != 256
; 0000 0090     if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 0091   #endif
; 0000 0092     #asm("cli")
; 0000 0093     --rx_counter1;
; 0000 0094   #asm("sei")
; 0000 0095     return data;
; 0000 0096 }
;#pragma used-
;  // Write a character to the USART1 Transmitter
;  #pragma used+
;  void putchar1(char c)
; 0000 009B {
_putchar1:
; .FSTART _putchar1
; 0000 009C   while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
	ST   -Y,R26
;	c -> Y+0
_0xD:
	SBIS 0x2,5
	RJMP _0xD
; 0000 009D   UDR1=c;
	LD   R30,Y
	OUT  0x3,R30
; 0000 009E }
	RJMP _0x2000002
; .FEND
;#pragma used-
;  void delay_tone(char tone)
; 0000 00A1 {
_delay_tone:
; .FSTART _delay_tone
; 0000 00A2   //Rumus delay = (1/freq )*1000000/2;
; 0000 00A3   switch(tone)
	ST   -Y,R26
;	tone -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 00A4   {
; 0000 00A5   case 1 :
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x13
; 0000 00A6     {
; 0000 00A7       delay_us(1893);
	__DELAY_USW 5679
; 0000 00A8       break;
	RJMP _0x12
; 0000 00A9     }
; 0000 00AA   case 2 :
_0x13:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x14
; 0000 00AB     {
; 0000 00AC       delay_us(1683);
	__DELAY_USW 5049
; 0000 00AD       break;
	RJMP _0x12
; 0000 00AE     }
; 0000 00AF   case 3 :
_0x14:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x15
; 0000 00B0     {
; 0000 00B1       delay_us(1515);
	__DELAY_USW 4545
; 0000 00B2       break;
	RJMP _0x12
; 0000 00B3     }
; 0000 00B4   case 4 :
_0x15:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x16
; 0000 00B5     {
; 0000 00B6       delay_us(1420);
	__DELAY_USW 4260
; 0000 00B7       break;
	RJMP _0x12
; 0000 00B8     }
; 0000 00B9   case 5 :
_0x16:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x17
; 0000 00BA     {
; 0000 00BB       delay_us(1262);
	__DELAY_USW 3786
; 0000 00BC       break;
	RJMP _0x12
; 0000 00BD     }
; 0000 00BE   case 6 :
_0x17:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x18
; 0000 00BF     {
; 0000 00C0       delay_us(1136);
	__DELAY_USW 3408
; 0000 00C1       break;
	RJMP _0x12
; 0000 00C2     }
; 0000 00C3   case 7 :
_0x18:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x19
; 0000 00C4     {
; 0000 00C5       delay_us(1010);
	__DELAY_USW 3030
; 0000 00C6       break;
	RJMP _0x12
; 0000 00C7     }
; 0000 00C8   case 8 :
_0x19:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x1A
; 0000 00C9     {
; 0000 00CA       delay_us(946);
	__DELAY_USW 2838
; 0000 00CB       break;
	RJMP _0x12
; 0000 00CC     }
; 0000 00CD   case 88:
_0x1A:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x12
; 0000 00CE     {
; 0000 00CF       delay_us(800);
	__DELAY_USW 2400
; 0000 00D0       break;
; 0000 00D1     }
; 0000 00D2   }
_0x12:
; 0000 00D3 }
	RJMP _0x2000002
; .FEND
;
;
;void toneGenerator(char tone)
; 0000 00D7 {
_toneGenerator:
; .FSTART _toneGenerator
; 0000 00D8   if (tone!=88)
	ST   -Y,R26
;	tone -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x58)
	BREQ _0x1C
; 0000 00D9   {
; 0000 00DA     PORTB.0 =1;
	SBI  0x18,0
; 0000 00DB     delay_tone(tone);
	RCALL _delay_tone
; 0000 00DC     PORTB.0 =0;
; 0000 00DD     delay_tone(tone);
; 0000 00DE   } else {
_0x1C:
; 0000 00DF     PORTB.0 = 0;
_0x50:
	CBI  0x18,0
; 0000 00E0     delay_tone(tone);
	LD   R26,Y
	RCALL _delay_tone
; 0000 00E1   }
; 0000 00E2 }
_0x2000002:
	ADIW R28,1
	RET
; .FEND
;
;
;int Dur;
;void musicGenerator(char duration, char tone)
; 0000 00E7 {
_musicGenerator:
; .FSTART _musicGenerator
; 0000 00E8   for (Dur=0; Dur<=duration; Dur++)
	ST   -Y,R26
;	duration -> Y+1
;	tone -> Y+0
	LDI  R30,LOW(0)
	STS  _Dur,R30
	STS  _Dur+1,R30
_0x25:
	LDD  R30,Y+1
	LDS  R26,_Dur
	LDS  R27,_Dur+1
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x26
; 0000 00E9     toneGenerator(tone);
	LD   R26,Y
	RCALL _toneGenerator
	LDI  R26,LOW(_Dur)
	LDI  R27,HIGH(_Dur)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x25
_0x26:
; 0000 00EB PORTB.0=0;
	CBI  0x18,0
; 0000 00EC }
	RJMP _0x2000001
; .FEND
;
;
;int gundulPacul[] = {1, 3, 1, 3, 4, 5, 5, 0, 7, 8, 7, 8, 7, 5, 88, 0, 1,
;  3, 1, 3, 4, 5, 5, 0, 7, 8, 7, 8, 7, 5, 88, 1,
;  3, 5, 88, 4, 4, 5, 4, 3, 1, 4, 3, 1, 88, 0, 1,
;  3, 5, 88, 4, 4, 5, 4, 3, 1, 4, 3, 1, 88, 0,
;  99};

	.DSEG
;int Twinkle[]={
;  1, 1, 5, 5, 6, 6, 5, 88,
;  4, 4, 3, 3, 2, 2, 1, 88,
;  5, 5, 4, 4, 3, 3, 2, 88,
;  5, 5, 4, 4, 3, 3, 2, 88,
;  1, 1, 5, 5, 6, 6, 5, 88,
;  4, 4, 3, 3, 2, 2, 1, 88,
;  99
;};
;
;int ibuKitakartini[]={
;  1, 2, 3, 4, 5, 3, 1, 88,
;  6, 8, 7, 6, 5, 88,
;  4, 6, 5, 4, 3, 1, 88,
;  2, 4, 3, 2, 1, 88,
;  4, 3, 4, 6, 5, 6, 5, 3, 1, 3, 2, 3, 4, 5, 3, 88,
;  4, 3, 4, 6, 5, 6, 5, 3, 1, 3, 2, 3, 4, 5, 3, 88, 99
;} ;
;
;int babyShark[]={
;  2, 3, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88,
;  2, 3, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88,
;  2, 3, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88, 5, 88,
;  5, 88, 5, 88, 4, 99
;};
;
;int randomMusic[] =
;  {1, 2, 3, 4, 5, 6, 7, 8, 88, 99};
;
;int index=0;
;void musicPlayer(int music[])
; 0000 0113 {

	.CSEG
_musicPlayer:
; .FSTART _musicPlayer
; 0000 0114   while (music[index]!=99)
	ST   -Y,R27
	ST   -Y,R26
;	music -> Y+0
_0x2E:
	LDS  R30,_index
	LDS  R31,_index+1
	LD   R26,Y
	LDD  R27,Y+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BREQ _0x30
; 0000 0115   {
; 0000 0116     musicGenerator(70, music[index]);
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDS  R30,_index
	LDS  R31,_index+1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _musicGenerator
; 0000 0117     index++;
	LDI  R26,LOW(_index)
	LDI  R27,HIGH(_index)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0118   }
	RJMP _0x2E
_0x30:
; 0000 0119 
; 0000 011A   index=0;
	LDI  R30,LOW(0)
	STS  _index,R30
	STS  _index+1,R30
; 0000 011B   flag=0;
	CLR  R5
; 0000 011C }
_0x2000001:
	ADIW R28,2
	RET
; .FEND
;
;int i;
;
;void main(void)
; 0000 0121 {
_main:
; .FSTART _main
; 0000 0122   // Declare your local variables here
; 0000 0123 
; 0000 0124   // Crystal Oscillator division factor: 1
; 0000 0125   #pragma optsize-
; 0000 0126     CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0127   CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0128   #ifdef _OPTIMIZE_SIZE_
; 0000 0129     #pragma optsize+
; 0000 012A     #endif
; 0000 012B 
; 0000 012C     // Input/Output Ports initialization
; 0000 012D     // Port A initialization
; 0000 012E     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 012F     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	OUT  0x1A,R30
; 0000 0130   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0131   PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0132 
; 0000 0133   // Port B initialization
; 0000 0134   // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0135   DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0136   // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0137   PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0138 
; 0000 0139   // Port C initialization
; 0000 013A   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 013B   DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 013C   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 013D   PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 013E 
; 0000 013F   // Port D initialization
; 0000 0140   // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0141   DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0142   // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0143   PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0144 
; 0000 0145   // Port E initialization
; 0000 0146   // Function: Bit2=In Bit1=In Bit0=In
; 0000 0147   DDRE=(0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x6,R30
; 0000 0148   // State: Bit2=T Bit1=T Bit0=T
; 0000 0149   PORTE=(0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x7,R30
; 0000 014A 
; 0000 014B   // USART1 initialization
; 0000 014C   // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 014D   // USART1 Receiver: On
; 0000 014E   // USART1 Transmitter: On
; 0000 014F   // USART1 Mode: Asynchronous
; 0000 0150   // USART1 Baud Rate: 9600
; 0000 0151   UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
	OUT  0x2,R30
; 0000 0152   UCSR1B=(1<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(152)
	OUT  0x1,R30
; 0000 0153   UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
	LDI  R30,LOW(6)
	OUT  0x3C,R30
; 0000 0154   UBRR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0155   UBRR1L=0x4D;
	LDI  R30,LOW(77)
	OUT  0x0,R30
; 0000 0156 
; 0000 0157   // Global enable interrupts
; 0000 0158   #asm("sei")
	sei
; 0000 0159 
; 0000 015A     while (1)
_0x31:
; 0000 015B   {
; 0000 015C     // Place your code here
; 0000 015D     //char a = 'a';
; 0000 015E     //putchar1(nada);
; 0000 015F     //delay_ms(100);
; 0000 0160     //musicPlayer(randomMusic);
; 0000 0161     //flag = 1;
; 0000 0162     putchar1(nada);
	MOV  R26,R4
	RCALL _putchar1
; 0000 0163 
; 0000 0164     if (flag=='1') {
	LDI  R30,LOW(49)
	CP   R30,R5
	BRNE _0x34
; 0000 0165       if (nada=='1') {
	CP   R30,R4
	BRNE _0x35
; 0000 0166         musicPlayer(gundulPacul);
	LDI  R26,LOW(_gundulPacul)
	LDI  R27,HIGH(_gundulPacul)
	RJMP _0x51
; 0000 0167       } else if (nada=='2') {
_0x35:
	LDI  R30,LOW(50)
	CP   R30,R4
	BRNE _0x37
; 0000 0168         musicPlayer(Twinkle);
	LDI  R26,LOW(_Twinkle)
	LDI  R27,HIGH(_Twinkle)
	RJMP _0x51
; 0000 0169       } else if (nada=='3') {
_0x37:
	LDI  R30,LOW(51)
	CP   R30,R4
	BRNE _0x39
; 0000 016A         musicPlayer(ibuKitakartini);
	LDI  R26,LOW(_ibuKitakartini)
	LDI  R27,HIGH(_ibuKitakartini)
	RJMP _0x51
; 0000 016B       } else if (nada=='4') {
_0x39:
	LDI  R30,LOW(52)
	CP   R30,R4
	BRNE _0x3B
; 0000 016C         musicPlayer(babyShark);
	LDI  R26,LOW(_babyShark)
	LDI  R27,HIGH(_babyShark)
_0x51:
	RCALL _musicPlayer
; 0000 016D       }
; 0000 016E     } else if (flag=='2') {
_0x3B:
	RJMP _0x3C
_0x34:
	LDI  R30,LOW(50)
	CP   R30,R5
	BRNE _0x3D
; 0000 016F       if (nada=='1') {
	LDI  R30,LOW(49)
	CP   R30,R4
	BRNE _0x3E
; 0000 0170         toneGenerator(1);
	LDI  R26,LOW(1)
	RJMP _0x52
; 0000 0171       } else if (nada=='2') {
_0x3E:
	LDI  R30,LOW(50)
	CP   R30,R4
	BRNE _0x40
; 0000 0172         toneGenerator(2);
	LDI  R26,LOW(2)
	RJMP _0x52
; 0000 0173       } else if (nada=='3') {
_0x40:
	LDI  R30,LOW(51)
	CP   R30,R4
	BRNE _0x42
; 0000 0174         toneGenerator(3);
	LDI  R26,LOW(3)
	RJMP _0x52
; 0000 0175       } else if (nada=='4') {
_0x42:
	LDI  R30,LOW(52)
	CP   R30,R4
	BRNE _0x44
; 0000 0176         toneGenerator(4);
	LDI  R26,LOW(4)
	RJMP _0x52
; 0000 0177       } else if (nada=='5') {
_0x44:
	LDI  R30,LOW(53)
	CP   R30,R4
	BRNE _0x46
; 0000 0178         toneGenerator(5);
	LDI  R26,LOW(5)
	RJMP _0x52
; 0000 0179       } else if (nada=='6') {
_0x46:
	LDI  R30,LOW(54)
	CP   R30,R4
	BRNE _0x48
; 0000 017A         toneGenerator(6);
	LDI  R26,LOW(6)
	RJMP _0x52
; 0000 017B       } else if (nada=='7') {
_0x48:
	LDI  R30,LOW(55)
	CP   R30,R4
	BRNE _0x4A
; 0000 017C         toneGenerator(7);
	LDI  R26,LOW(7)
	RJMP _0x52
; 0000 017D       } else if (nada=='8') {
_0x4A:
	LDI  R30,LOW(56)
	CP   R30,R4
	BRNE _0x4C
; 0000 017E         toneGenerator(8);
	LDI  R26,LOW(8)
	RJMP _0x52
; 0000 017F       } else if (nada=='9') {
_0x4C:
	LDI  R30,LOW(57)
	CP   R30,R4
	BRNE _0x4E
; 0000 0180         toneGenerator(99);
	LDI  R26,LOW(99)
_0x52:
	RCALL _toneGenerator
; 0000 0181       }
; 0000 0182     }
_0x4E:
; 0000 0183   }
_0x3D:
_0x3C:
	RJMP _0x31
; 0000 0184 }
_0x4F:
	NOP
	RJMP _0x4F
; .FEND

	.DSEG
_rx_buffer1:
	.BYTE 0x8
_Dur:
	.BYTE 0x2
_gundulPacul:
	.BYTE 0x7C
_Twinkle:
	.BYTE 0x62
_ibuKitakartini:
	.BYTE 0x78
_babyShark:
	.BYTE 0x60
_index:
	.BYTE 0x2

	.CSEG

	.CSEG
__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
