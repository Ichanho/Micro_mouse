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

unsigned char poutput;


// Get a character from the USART1 Receiver
#pragma used+
char getchar1(void)
{
char status,data;
while (1)
{
while (((status=UCSR1A) & RX_COMPLETE)==0);
data=UDR1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
return data;
};
}
#pragma used-

// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-

void putchar(char c)
{
switch (poutput)
{
case USART0: // the output will be directed to USART0
while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
UDR0=c;
break;

case USART1: // the output will be directed to USART1
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
};
}

unsigned char getchar(void)
{
switch (poutput)
{
case USART0: // the input will be directed to USART0
while ((UCSR0A & RX_COMPLETE)==0);
return UDR0;
break;

case USART1: // the input will be directed to USART1
while ((UCSR1A & RX_COMPLETE)==0);
return UDR1;
};
}