#line 1 "C:/Users/Lenovo/Desktop/Edit pwm ,5s delay/MyProject.c"
unsigned int Mcntr;
unsigned int Distance;
unsigned int NDFiveS = 0;


void myDelay_ms(unsigned int millisec);
void Dcmotor(void);

void interrupt(void){
 if(INTCON&0x04){
 if (NDFiveS == 5000){
 unsigned int i;
 if(!(PORTB & 0x10)) {



 PORTB = PORTB & 0x0A;
 PORTB = PORTB | 0x0A;

 CCPR1L = 60;
 CCPR2L = 75;

 i=0;
 while (i<2000){
 i++;
 }
 }
 else if(!(PORTB & 0x20) ){




 PORTB = PORTB & 0x05;
 PORTB = PORTB | 0x05;

 CCPR1L = 75;
 CCPR2L = 75;
 i=0;
 while (i<2000){
 i++;
 }
 }
 }
 TMR0=248;
 Mcntr++;
 INTCON = INTCON & 0xFB;
 }
}
void main(void){

 Mcntr=0;
 TRISB = 0xF0;
 PORTB = 0x00;
 TRISC = 0x00;
 PORTC = 0x00;
 TRISD = 0x01;
 PORTD = 0x00;

 TMR0=248;
 OPTION_REG = 0x87;
 INTCON = 0xA0;
 myDelay_ms(5000);


 T2CON = 0x27;
 CCP1CON = 0x0C;
 CCP2CON = 0x0C;
 PR2 = 250;

 T1CON = 0x10;


 while(1){
 Dcmotor();
 }

}

void Dcmotor(void){


 if(!(PORTB & 0x10)) {



 PORTB = PORTB & 0x0A;
 PORTB = PORTB | 0x0A;

 CCPR1L = 60;
 CCPR2L = 75;
 myDelay_ms(10000);
 }
 else if(!(PORTB & 0x20) ){




 PORTB = PORTB & 0x05;
 PORTB = PORTB | 0x05;

 CCPR1L = 75;
 CCPR2L = 75;
 myDelay_ms(10000);
 }

 else {

 TMR1H = 0;
 TMR1L = 0;

 PORTD = PORTD | 0x02;
 myDelay_ms(1);
 PORTD = PORTD & 0x00;

 Mcntr = 0;
 while(!(PORTD & 0x01)){
 if (Mcntr > 2){
 break;
 }
 }
 T1CON = T1CON & 0x11;
 while(PORTD & 0x01);
 T1CON = T1CON & 0x10;

 Distance = (TMR1L | (TMR1H<<8));
 Distance = Distance/58.82;
 Distance = Distance + 1;

 if(Distance >= 2 && Distance <= 30) {
 PORTB = PORTB & 0x0A;
 PORTB = PORTB | 0x0A;

 CCPR1L = 75;
 CCPR2L = 60;
 myDelay_ms(10000);
 }
 else{
 PORTB = PORTB & 0x05;
 PORTB = PORTB | 0x05;

 CCPR1L = 75;
 CCPR2L = 75;

 myDelay_ms(10000);
 }
 }
}
void myDelay_ms(unsigned int millisec){
 Mcntr =0;
 while(Mcntr<millisec);
 if (millisec == 5000){
 NDFiveS = 5000;
 }
}
