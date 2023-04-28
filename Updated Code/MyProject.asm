
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,9 :: 		void interrupt(void){
;MyProject.c,10 :: 		if(INTCON&0x04){// will get here every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;MyProject.c,11 :: 		if (NDFiveS == 5000){
	MOVF       _NDFiveS+1, 0
	XORLW      19
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt30
	MOVLW      136
	XORWF      _NDFiveS+0, 0
L__interrupt30:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;MyProject.c,13 :: 		if(!(PORTB & 0x10)) {   // first case => Sensor in the front sees the white line RB4=0
	BTFSC      PORTB+0, 4
	GOTO       L_interrupt2
;MyProject.c,17 :: 		PORTB = PORTB & 0x0A;          //Turn off RB0 and RB2
	MOVLW      10
	ANDWF      PORTB+0, 1
;MyProject.c,18 :: 		PORTB = PORTB | 0x0A;          //Turn on RB1 and RB3
	MOVLW      10
	IORWF      PORTB+0, 1
;MyProject.c,20 :: 		CCPR1L = 60;      // left motor goes (back) with (half) speed
	MOVLW      60
	MOVWF      CCPR1L+0
;MyProject.c,21 :: 		CCPR2L = 75;      // right motor goes (back) with (full) speed
	MOVLW      75
	MOVWF      CCPR2L+0
;MyProject.c,23 :: 		i=0;
	CLRF       R1+0
	CLRF       R1+1
;MyProject.c,24 :: 		while (i<2000){
L_interrupt3:
	MOVLW      7
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt31
	MOVLW      208
	SUBWF      R1+0, 0
L__interrupt31:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt4
;MyProject.c,25 :: 		i++;
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;MyProject.c,26 :: 		}
	GOTO       L_interrupt3
L_interrupt4:
;MyProject.c,27 :: 		}
	GOTO       L_interrupt5
L_interrupt2:
;MyProject.c,28 :: 		else if(!(PORTB & 0x20) ){    // second case => Sensor in the back sees the white line     RB5=0
	BTFSC      PORTB+0, 5
	GOTO       L_interrupt6
;MyProject.c,33 :: 		PORTB = PORTB & 0x05;          //Turn off RB1 and RB3
	MOVLW      5
	ANDWF      PORTB+0, 1
;MyProject.c,34 :: 		PORTB = PORTB | 0x05;          //Turn on RB0 and RB2
	MOVLW      5
	IORWF      PORTB+0, 1
;MyProject.c,36 :: 		CCPR1L = 75;       // left motor goes (front) with (full) speed
	MOVLW      75
	MOVWF      CCPR1L+0
;MyProject.c,37 :: 		CCPR2L = 75;       // right motor goes (front) with (full) speed
	MOVLW      75
	MOVWF      CCPR2L+0
;MyProject.c,38 :: 		i=0;
	CLRF       R1+0
	CLRF       R1+1
;MyProject.c,39 :: 		while (i<2000){
L_interrupt7:
	MOVLW      7
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt32
	MOVLW      208
	SUBWF      R1+0, 0
L__interrupt32:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt8
;MyProject.c,40 :: 		i++;
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;MyProject.c,41 :: 		}
	GOTO       L_interrupt7
L_interrupt8:
;MyProject.c,42 :: 		}
L_interrupt6:
L_interrupt5:
;MyProject.c,43 :: 		}
L_interrupt1:
;MyProject.c,44 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,45 :: 		Mcntr++;
	INCF       _Mcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Mcntr+1, 1
;MyProject.c,46 :: 		INTCON = INTCON & 0xFB; //clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;MyProject.c,47 :: 		}
L_interrupt0:
;MyProject.c,48 :: 		}
L_end_interrupt:
L__interrupt29:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,49 :: 		void main(void){
;MyProject.c,51 :: 		Mcntr=0;
	CLRF       _Mcntr+0
	CLRF       _Mcntr+1
;MyProject.c,52 :: 		TRISB = 0xF0; //first 4 bits are output, the rest are input (we need RB4 (Front sensor) and RB5 (Back sensor))
	MOVLW      240
	MOVWF      TRISB+0
;MyProject.c,53 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;MyProject.c,54 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;MyProject.c,55 :: 		PORTC = 0x00; //we choose RC1 for the right motor in pwm (CCP2) and RC2 for the left motor in pwm (CCP1)
	CLRF       PORTC+0
;MyProject.c,56 :: 		TRISD = 0x01;    // echo RD0 (input) , Trigger RD1  (output)
	MOVLW      1
	MOVWF      TRISD+0
;MyProject.c,57 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;MyProject.c,59 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,60 :: 		OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
	MOVLW      135
	MOVWF      OPTION_REG+0
;MyProject.c,61 :: 		INTCON = 0xA0; // GIE, T0IE and INTE (TMR) overflow interrupt and External Interrupt Enable)
	MOVLW      160
	MOVWF      INTCON+0
;MyProject.c,62 :: 		myDelay_ms(5000);
	MOVLW      136
	MOVWF      FARG_myDelay_ms_millisec+0
	MOVLW      19
	MOVWF      FARG_myDelay_ms_millisec+1
	CALL       _myDelay_ms+0
;MyProject.c,65 :: 		T2CON = 0x27;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
	MOVLW      39
	MOVWF      T2CON+0
;MyProject.c,66 :: 		CCP1CON = 0x0C;//enable PWM for CCP1 , signal on RC2
	MOVLW      12
	MOVWF      CCP1CON+0
;MyProject.c,67 :: 		CCP2CON = 0x0C;//enable PWM for CCP2  , signal on RC1
	MOVLW      12
	MOVWF      CCP2CON+0
;MyProject.c,68 :: 		PR2 = 250;// 250 counts =8uS *250 =2ms period
	MOVLW      250
	MOVWF      PR2+0
;MyProject.c,70 :: 		T1CON = 0x10;                 //Initialize Timer Module
	MOVLW      16
	MOVWF      T1CON+0
;MyProject.c,73 :: 		while(1){
L_main9:
;MyProject.c,74 :: 		Dcmotor();
	CALL       _Dcmotor+0
;MyProject.c,75 :: 		}
	GOTO       L_main9
;MyProject.c,77 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_Dcmotor:

;MyProject.c,79 :: 		void Dcmotor(void){
;MyProject.c,82 :: 		if(!(PORTB & 0x10)) {   // first case => Sensor in the front sees the white line RB4=0
	BTFSC      PORTB+0, 4
	GOTO       L_Dcmotor11
;MyProject.c,86 :: 		PORTB = PORTB & 0x0A;          //Turn off RB0 and RB2
	MOVLW      10
	ANDWF      PORTB+0, 1
;MyProject.c,87 :: 		PORTB = PORTB | 0x0A;          //Turn on RB1 and RB3
	MOVLW      10
	IORWF      PORTB+0, 1
;MyProject.c,89 :: 		CCPR1L = 60;      // left motor goes (back) with (half) speed
	MOVLW      60
	MOVWF      CCPR1L+0
;MyProject.c,90 :: 		CCPR2L = 75;      // right motor goes (back) with (full) speed
	MOVLW      75
	MOVWF      CCPR2L+0
;MyProject.c,91 :: 		myDelay_ms(10000);
	MOVLW      16
	MOVWF      FARG_myDelay_ms_millisec+0
	MOVLW      39
	MOVWF      FARG_myDelay_ms_millisec+1
	CALL       _myDelay_ms+0
;MyProject.c,92 :: 		}
	GOTO       L_Dcmotor12
L_Dcmotor11:
;MyProject.c,93 :: 		else if(!(PORTB & 0x20) ){    // second case => Sensor in the back sees the white line     RB5=0
	BTFSC      PORTB+0, 5
	GOTO       L_Dcmotor13
;MyProject.c,98 :: 		PORTB = PORTB & 0x05;          //Turn off RB1 and RB3
	MOVLW      5
	ANDWF      PORTB+0, 1
;MyProject.c,99 :: 		PORTB = PORTB | 0x05;          //Turn on RB0 and RB2
	MOVLW      5
	IORWF      PORTB+0, 1
;MyProject.c,101 :: 		CCPR1L = 75;       // left motor goes (front) with (full) speed
	MOVLW      75
	MOVWF      CCPR1L+0
;MyProject.c,102 :: 		CCPR2L = 75;       // right motor goes (front) with (full) speed
	MOVLW      75
	MOVWF      CCPR2L+0
;MyProject.c,103 :: 		myDelay_ms(10000);
	MOVLW      16
	MOVWF      FARG_myDelay_ms_millisec+0
	MOVLW      39
	MOVWF      FARG_myDelay_ms_millisec+1
	CALL       _myDelay_ms+0
;MyProject.c,104 :: 		}
	GOTO       L_Dcmotor14
L_Dcmotor13:
;MyProject.c,108 :: 		TMR1H = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1H+0
;MyProject.c,109 :: 		TMR1L = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1L+0
;MyProject.c,111 :: 		PORTD = PORTD | 0x02;      // Turn on Trigger pulse
	BSF        PORTD+0, 1
;MyProject.c,112 :: 		myDelay_ms(1);
	MOVLW      1
	MOVWF      FARG_myDelay_ms_millisec+0
	MOVLW      0
	MOVWF      FARG_myDelay_ms_millisec+1
	CALL       _myDelay_ms+0
;MyProject.c,113 :: 		PORTD = PORTD & 0x00;      // Turn off Trigger pulse
	MOVLW      0
	ANDWF      PORTD+0, 1
;MyProject.c,115 :: 		Mcntr = 0;
	CLRF       _Mcntr+0
	CLRF       _Mcntr+1
;MyProject.c,116 :: 		while(!(PORTD & 0x01)){    // if the echo pulse still don't receive a signal
L_Dcmotor15:
	BTFSC      PORTD+0, 0
	GOTO       L_Dcmotor16
;MyProject.c,117 :: 		if (Mcntr > 2){
	MOVF       _Mcntr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Dcmotor35
	MOVF       _Mcntr+0, 0
	SUBLW      2
L__Dcmotor35:
	BTFSC      STATUS+0, 0
	GOTO       L_Dcmotor17
;MyProject.c,118 :: 		break;
	GOTO       L_Dcmotor16
;MyProject.c,119 :: 		}
L_Dcmotor17:
;MyProject.c,120 :: 		}
	GOTO       L_Dcmotor15
L_Dcmotor16:
;MyProject.c,121 :: 		T1CON = T1CON & 0x11;//timer start
	MOVLW      17
	ANDWF      T1CON+0, 1
;MyProject.c,122 :: 		while(PORTD & 0x01);       //  wait for the ehco pulse to stop rceiving the signal
L_Dcmotor18:
	BTFSS      PORTD+0, 0
	GOTO       L_Dcmotor19
	GOTO       L_Dcmotor18
L_Dcmotor19:
;MyProject.c,123 :: 		T1CON = T1CON & 0x10;//timer end
	MOVLW      16
	ANDWF      T1CON+0, 1
;MyProject.c,125 :: 		Distance = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
;MyProject.c,126 :: 		Distance = Distance/58.82;                //Converts Time to Distance
	CALL       _word2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
;MyProject.c,127 :: 		Distance = Distance + 1;                  //Distance Calibration
	MOVF       R0+0, 0
	ADDLW      1
	MOVWF      R2+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      _Distance+0
	MOVF       R2+1, 0
	MOVWF      _Distance+1
;MyProject.c,129 :: 		if(Distance >= 2 && Distance <= 30)  {     // If the Distance between 2cm to 30cm
	MOVLW      0
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Dcmotor36
	MOVLW      2
	SUBWF      R2+0, 0
L__Dcmotor36:
	BTFSS      STATUS+0, 0
	GOTO       L_Dcmotor22
	MOVF       _Distance+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__Dcmotor37
	MOVF       _Distance+0, 0
	SUBLW      30
L__Dcmotor37:
	BTFSS      STATUS+0, 0
	GOTO       L_Dcmotor22
L__Dcmotor27:
;MyProject.c,130 :: 		PORTB = PORTB & 0x0A;          //Turn off RB0 and RB2
	MOVLW      10
	ANDWF      PORTB+0, 1
;MyProject.c,131 :: 		PORTB = PORTB | 0x0A;          //Turn on RB1 and RB3
	MOVLW      10
	IORWF      PORTB+0, 1
;MyProject.c,133 :: 		CCPR1L = 75;  // left motor goes (back) with (full) speed
	MOVLW      75
	MOVWF      CCPR1L+0
;MyProject.c,134 :: 		CCPR2L = 60;  // right motor goes (back) with (half) speed
	MOVLW      60
	MOVWF      CCPR2L+0
;MyProject.c,135 :: 		myDelay_ms(10000);
	MOVLW      16
	MOVWF      FARG_myDelay_ms_millisec+0
	MOVLW      39
	MOVWF      FARG_myDelay_ms_millisec+1
	CALL       _myDelay_ms+0
;MyProject.c,136 :: 		}
	GOTO       L_Dcmotor23
L_Dcmotor22:
;MyProject.c,138 :: 		PORTB = PORTB & 0x05;   //Turn off RB1 and RB3
	MOVLW      5
	ANDWF      PORTB+0, 1
;MyProject.c,139 :: 		PORTB = PORTB | 0x05;   //Turn on RB0 and RB2
	MOVLW      5
	IORWF      PORTB+0, 1
;MyProject.c,141 :: 		CCPR1L = 75;   // left motor goes (front) with (full) speed
	MOVLW      75
	MOVWF      CCPR1L+0
;MyProject.c,142 :: 		CCPR2L = 75;   // right motor goes (front) with (full) speed
	MOVLW      75
	MOVWF      CCPR2L+0
;MyProject.c,144 :: 		myDelay_ms(10000);
	MOVLW      16
	MOVWF      FARG_myDelay_ms_millisec+0
	MOVLW      39
	MOVWF      FARG_myDelay_ms_millisec+1
	CALL       _myDelay_ms+0
;MyProject.c,145 :: 		}
L_Dcmotor23:
;MyProject.c,146 :: 		}
L_Dcmotor14:
L_Dcmotor12:
;MyProject.c,147 :: 		}
L_end_Dcmotor:
	RETURN
; end of _Dcmotor

_myDelay_ms:

;MyProject.c,148 :: 		void myDelay_ms(unsigned int millisec){
;MyProject.c,149 :: 		Mcntr =0;
	CLRF       _Mcntr+0
	CLRF       _Mcntr+1
;MyProject.c,150 :: 		while(Mcntr<millisec);
L_myDelay_ms24:
	MOVF       FARG_myDelay_ms_millisec+1, 0
	SUBWF      _Mcntr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay_ms39
	MOVF       FARG_myDelay_ms_millisec+0, 0
	SUBWF      _Mcntr+0, 0
L__myDelay_ms39:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay_ms25
	GOTO       L_myDelay_ms24
L_myDelay_ms25:
;MyProject.c,151 :: 		if (millisec == 5000){
	MOVF       FARG_myDelay_ms_millisec+1, 0
	XORLW      19
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay_ms40
	MOVLW      136
	XORWF      FARG_myDelay_ms_millisec+0, 0
L__myDelay_ms40:
	BTFSS      STATUS+0, 2
	GOTO       L_myDelay_ms26
;MyProject.c,152 :: 		NDFiveS = 5000;
	MOVLW      136
	MOVWF      _NDFiveS+0
	MOVLW      19
	MOVWF      _NDFiveS+1
;MyProject.c,153 :: 		}
L_myDelay_ms26:
;MyProject.c,154 :: 		}
L_end_myDelay_ms:
	RETURN
; end of _myDelay_ms
