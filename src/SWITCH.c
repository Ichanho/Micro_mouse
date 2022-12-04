
#include <mega128.h>
#include "Sensor.h"
#include "StepMotor.h"
#include "LED.h"
#include "switch.h"
#include "Algorithm.h"
#include <delay.h>

struct Buttons
{
    char SW1;
    char SW2;
} ;
 struct Buttons Button; 

interrupt [EXT_INT0] void ext_int0_isr(void)
{
    delay_ms(200);
    Button.SW1 = TRUE;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    delay_ms(200);
    Button.SW2 = TRUE;
}

void InitializeSwitch(void)
{
//½ºÀ§Ä¡ PORTD 0,1
	PORTD &= 0xfc;
	DDRD &= 0xfc;
    EICRA=0x0A;
    EICRB=0x00;
    EIMSK=0x03;
    EIFR=0x03;    
}

char SW1(void)
{
    char ret;
    ret=Button.SW1;
    Button.SW1=FALSE;
    return ret;
}
    
char SW2(void)
{
    char ret;
    ret=Button.SW2;
    Button.SW2=FALSE;
    return ret;
}
   
