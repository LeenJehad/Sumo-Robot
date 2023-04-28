unsigned int Mcntr;
unsigned int Distance;
unsigned int NDFiveS = 0;


void myDelay_ms(unsigned int millisec);
void Dcmotor(void);

void interrupt(void){
  if(INTCON&0x04){// will get here every 1ms
                     if (NDFiveS == 5000){
                        unsigned int i;
                        if(!(PORTB & 0x10)) {   // first case => Sensor in the front sees the white line RB4=0

                                //  RC4 off   The robot goes back

                                PORTB = PORTB & 0x0A;          //Turn off RB0 and RB2
                                PORTB = PORTB | 0x0A;          //Turn on RB1 and RB3

                                CCPR1L = 60;      // left motor goes (back) with (half) speed
                                CCPR2L = 75;      // right motor goes (back) with (full) speed

                                i=0;
                                while (i<2000){
                                      i++;
                                }
                             }
                             else if(!(PORTB & 0x20) ){    // second case => Sensor in the back sees the white line     RB5=0


                                      //  RC5 off     The robot goes front

                                      PORTB = PORTB & 0x05;          //Turn off RB1 and RB3
                                      PORTB = PORTB | 0x05;          //Turn on RB0 and RB2

                                      CCPR1L = 75;       // left motor goes (front) with (full) speed
                                      CCPR2L = 75;       // right motor goes (front) with (full) speed
                                      i=0;
                                      while (i<2000){
                                            i++;
                                      }
                               }
                           }
                     TMR0=248;
                     Mcntr++;
                     INTCON = INTCON & 0xFB; //clear T0IF
  }
}
void main(void){

     Mcntr=0;
     TRISB = 0xF0; //first 4 bits are output, the rest are input (we need RB4 (Front sensor) and RB5 (Back sensor))
     PORTB = 0x00;
     TRISC = 0x00;
     PORTC = 0x00; //we choose RC1 for the right motor in pwm (CCP2) and RC2 for the left motor in pwm (CCP1)
     TRISD = 0x01;    // echo RD0 (input) , Trigger RD1  (output)
     PORTD = 0x00;

     TMR0=248;
     OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
     INTCON = 0xA0; // GIE, T0IE and INTE (TMR) overflow interrupt and External Interrupt Enable)
     myDelay_ms(5000);
      //Define PWM

      T2CON = 0x27;//enable Timer2 at Fosc/4 with 1:16 prescaler (8 uS percount 2000uS to count 250 counts)
      CCP1CON = 0x0C;//enable PWM for CCP1 , signal on RC2
      CCP2CON = 0x0C;//enable PWM for CCP2  , signal on RC1
      PR2 = 250;// 250 counts =8uS *250 =2ms period

      T1CON = 0x10;                 //Initialize Timer Module


      while(1){
               Dcmotor();
      }

}

void Dcmotor(void){
                       //on white the sensor output is low
                       //on black the sensor output is high
     if(!(PORTB & 0x10)) {   // first case => Sensor in the front sees the white line RB4=0

              //  RC4 off   The robot goes back

              PORTB = PORTB & 0x0A;          //Turn off RB0 and RB2
              PORTB = PORTB | 0x0A;          //Turn on RB1 and RB3

              CCPR1L = 60;      // left motor goes (back) with (half) speed
              CCPR2L = 75;      // right motor goes (back) with (full) speed
              myDelay_ms(10000);
     }
     else if(!(PORTB & 0x20) ){    // second case => Sensor in the back sees the white line     RB5=0


           //  RC5 off     The robot goes front

           PORTB = PORTB & 0x05;          //Turn off RB1 and RB3
           PORTB = PORTB | 0x05;          //Turn on RB0 and RB2

           CCPR1L = 75;       // left motor goes (front) with (full) speed
           CCPR2L = 75;       // right motor goes (front) with (full) speed
           myDelay_ms(10000);
     }

    else {   // third case => Sensor in the front and the back sees the black line     RB4 and RB5 = 1

             TMR1H = 0;                  //Sets the Initial Value of Timer
             TMR1L = 0;                  //Sets the Initial Value of Timer

             PORTD = PORTD | 0x02;      // Turn on Trigger pulse
             myDelay_ms(1);
             PORTD = PORTD & 0x00;      // Turn off Trigger pulse

             Mcntr = 0;
             while(!(PORTD & 0x01)){    // if the echo pulse still don't receive a signal
                        if (Mcntr > 2){
                              break;
                        }
             }
             T1CON = T1CON & 0x11;//timer start
             while(PORTD & 0x01);       //  wait for the ehco pulse to stop rceiving the signal
             T1CON = T1CON & 0x10;//timer end

             Distance = (TMR1L | (TMR1H<<8));   //Reads Timer Value
             Distance = Distance/58.82;                //Converts Time to Distance
             Distance = Distance + 1;                  //Distance Calibration

             if(Distance >= 2 && Distance <= 30)  {     // If the Distance between 2cm to 30cm
             PORTB = PORTB & 0x0A;          //Turn off RB0 and RB2
             PORTB = PORTB | 0x0A;          //Turn on RB1 and RB3

             CCPR1L = 75;  // left motor goes (back) with (full) speed
             CCPR2L = 60;  // right motor goes (back) with (half) speed
             myDelay_ms(10000);
           }
         else{  // Out of the range (do nothing)
              PORTB = PORTB & 0x05;   //Turn off RB1 and RB3
              PORTB = PORTB | 0x05;   //Turn on RB0 and RB2

              CCPR1L = 75;   // left motor goes (front) with (full) speed
              CCPR2L = 75;   // right motor goes (front) with (full) speed

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