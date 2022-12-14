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

void InitializeSensor(void)
{
     // ?߱????? PORTB 5,6,7
     PORTB &= 0x1f;
     DDRB |= 0xe0;
     // ???????? PORTF 0,1,2
     PORTF &= 0xf8;
     DDRF |= 0xf8;
     
     ADMUX=ADC_VREF_TYPE;
     ADCSRA=0x87;
}

unsigned int read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
    // Delay needed for the stabilization of the ADC input voltage
    delay_us(10);
    // Start the AD conversion
    ADCSRA|=0x40;
    // Wait for the AD conversion to complete
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    return ADCW;
}

unsigned int readSensor(char si)
{
     unsigned int ret;
               
     switch(si)
     {
          case FRONT_SENSOR:
               PORTB.5=1;
               delay_us(30);
               ret = read_adc(si);
               PORTB.5=0;
               break;
          case LEFT_SENSOR:
               PORTB.6=1;
               delay_us(30);
               ret = read_adc(si);
               PORTB.6=0;
               break;
          case RIGHT_SENSOR:
               PORTB.7=1;
               delay_us(30);
               ret = read_adc(si);
               PORTB.7=0;
               break;
     }
     return ret;
}
