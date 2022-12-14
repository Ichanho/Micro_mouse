#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <math.h>
#include "Sensor.h"
#include "StepMotor.h"
#include "LED.h"
#include "switch.h"
#include "UART1.h"
#include "Algorithm.h"

extern unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;
eeprom int StandardSensor[3], CenterStandardSensor[3];
extern unsigned char poutput;
void main(void)
{
    int i;
    int mode=0;
    
    poutput=USART1;
    InitializeSensor();
	InitializeStepMotor();
	InitializeLED();
	InitializeSwitch();
    
    UCSR1A=0x00;
    UCSR1B=0x18;
    UCSR1C=0x06;
    UBRR1H=0x00;
    UBRR1L=0x67;
    
    VelocityLeftmotorTCNT1=65380;
    VelocityRightmotorTCNT3=65380;  
   
    LED_OFF(LED2 | LED3 | LED4);
    
    #asm("sei");
    
    while (1)
    {
        if(SW1() == TRUE)
        {
            mode++;
            if(mode>6)
            {
                mode = 0;
            }
            LED_OFF(LED1 | LED2 | LED3 | LED4);
            switch(mode)
            {
                case 0: LED_ON(LED1); break;
                case 1: LED_ON(LED2); break;
                case 2: LED_ON(LED3); break;
                case 3: LED_ON(LED4); break;
                case 4: LED_ON(LED1|LED2); break;
                case 5: LED_ON(LED1|LED3); break;
                case 6: LED_ON(LED1|LED4); break;
            } 
        }
        if(SW2() == TRUE)
        {   
            LED_OFF(LED1 | LED2 | LED3 | LED4);
            switch(mode)
            {   
                case 0:   
                
                for(i = 0; i<8 ; i++)
                {
                    Direction(RIGHT);
                }     
                
                break;    
	            
                case 1:   
                while(1)
                {
                    printf("center : %d \t left : %d \t right : %d\r\n",readSensor(FRONT_SENSOR),readSensor(LEFT_SENSOR),readSensor(RIGHT_SENSOR));
	                delay_ms(50);
                }
                break;
                
                case 2:   
                for(i = 0; i<3 ; i++)
                {
                    Direction(FORWARD);
                } 
                break;
                
                case 3:   
                for(i = 0; i<8 ; i++)
                {
                    Direction(HALF);
                } 
                break; 
                
                case 4:
                //?????????? ???? ????, ?????? ???? ?????? ????????
                 LED_OFF(LED1 | LED2 | LED3 | LED4);
                 while(!SW2());
                 StandardSensor[0] = readSensor(FRONT_SENSOR);    // ???? ?? ????
                 LED_ON(LED1);         
                 while(!SW2());
                 StandardSensor[1] = readSensor(LEFT_SENSOR);    // ???? ?? ????
                 LED_ON(LED2);     
                 while(!SW2());
                 StandardSensor[2] = readSensor(RIGHT_SENSOR);    // ?????? ?? ????
                 LED_ON(LED3);
                 while(!SW2());
                 CenterStandardSensor[0] = readSensor(FRONT_SENSOR);
                 CenterStandardSensor[1] = readSensor(LEFT_SENSOR)-50;
                 CenterStandardSensor[2] = readSensor(RIGHT_SENSOR)-50;
                 LED_ON(LED4);
                 break; 
                 
               case 5:
               // ??????
               Direction(HALF);
               while (1)
               {    
                    if(readSensor(LEFT_SENSOR) < StandardSensor[1])
                    {
                         Direction(HALF);
                         Direction(LEFT);
                         Direction(HALF);
                    }
                    else if(readSensor(FRONT_SENSOR) > StandardSensor[0])
                    {
                         if(readSensor(RIGHT_SENSOR) < StandardSensor[2])
                         {
                              Direction(HALF);
                              Direction(RIGHT);
                              Direction(HALF);
                         }
                         else
                         { 
                              Direction(HALF);
                              Direction(LEFT);
                              Direction(LEFT);
                              Direction(HALF); 
                         }
                    } 
                    else 
                    {    
                        Direction(HALF);
                    } 
               }     
	           break;
            } 
        }
    }
}