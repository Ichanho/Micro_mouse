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
int acc=0;
int acc_allow=0;
char rotateR[8] = {0b1001,0b0001,0b0101,0b0100,0b0110,0b0010,0b1010,0b1000};
char rotateL[8] = {0b1001,0b1000,0b1010,0b0010,0b0110,0b0100,0b0101,0b0001};
int LeftstepCount, RightstepCount;		// rotateR�� rotateL�� ���� ������ ���Ϳ� ������� �Էµǵ��� Count 
unsigned int VelocityLeftmotorTCNT1, VelocityRightmotorTCNT3;	// ���ʰ� ������ ������ TCNT �ӵ�     
int vel_counter_high_R,vel_counter_high_L;
unsigned char direction_control;		// ���ͷ�Ʈ ��ƾ�� ���������� �����ϱ� ���� �������� 
extern eeprom int StandardSensor[3], CenterStandardSensor[3];
int vel_counter_high=65380;
     
     struct {
          int nStep4perBlock;			// �� ��� �̵��� �ʿ��� ����ȸ�� ���� ����
          int nStep4Turn90;			// 90�� �� �̵��� �ʿ��� ����ȸ�� ���� ����
     } Information;
     struct {
          char LmotorRun;			// ���� ���Ͱ� ȸ���ߴ����� ���� Flag
          char RmotorRun;			// ������ ���Ͱ� ȸ���ߴ����� ���� Flag
     } Flag;

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
     switch(direction_control)
     {
          case LEFT:
               PORTD |= (rotateL[LeftstepCount]<<4);
               PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
               LeftstepCount--;
               if(LeftstepCount < 0)
                    LeftstepCount = sizeof(rotateL)-1;
               break;
          case RIGHT:
          case BACK:
          case FORWARD:
          case HALF:   
               PORTD |= (rotateL[LeftstepCount]<<4);
               PORTD &= ((rotateL[LeftstepCount]<<4)+0x0f);
               LeftstepCount++;
               LeftstepCount %= sizeof(rotateL);
               break;
     }
     Flag.LmotorRun = TRUE;

     TCNT1H = VelocityLeftmotorTCNT1 >> 8;
     TCNT1L = VelocityLeftmotorTCNT1 & 0xff;
}

interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
     switch(direction_control)
     {
          case RIGHT:
          case BACK:
               PORTE |= (rotateR[RightstepCount]<<4);
               PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
               RightstepCount--;
               if(RightstepCount < 0)
                    RightstepCount = sizeof(rotateR)-1;
               break;
          case FORWARD:
          case HALF:
          case LEFT:
               PORTE |= (rotateR[RightstepCount]<<4);
               PORTE &= ((rotateR[RightstepCount]<<4)+0x0f);
               RightstepCount++;
               RightstepCount %= sizeof(rotateR);
               break;
     }
     Flag.RmotorRun = TRUE;

     TCNT3H = VelocityRightmotorTCNT3 >> 8;
     TCNT3L = VelocityRightmotorTCNT3 & 0xff;
}

void InitializeStepMotor(void)
{
    
     float distance4perStep;

     PORTD&=0x0F;
     DDRD|=0xF0;

     PORTE&=0x0F;
     DDRE|=0xF0;

     TCCR1A=0x00;
     TCCR1B=0x04;
     TCNT1H=0x00;
     TCNT1L=0x00;
     ICR1H=0x00;
     ICR1L=0x00;
     OCR1AH=0x00;
     OCR1AL=0x00;
     OCR1BH=0x00;
     OCR1BL=0x00;
     OCR1CH=0x00;
     OCR1CL=0x00;

     TCCR3A=0x00;
     TCCR3B=0x04;
     TCNT3H=0x00;
     TCNT3L=0x00;
     ICR3H=0x00;
     ICR3L=0x00;
     OCR3AH=0x00;
     OCR3AL=0x00;
     OCR3BH=0x00;
     OCR3BL=0x00;
     OCR3CH=0x00;
     OCR3CL=0x00;

     TIMSK=0x04;
     ETIMSK=0x04;    
     
	distance4perStep = (float)(3.5 * TIRE_RAD / (float)MOTOR_STEP);
	Information.nStep4perBlock = (int)((float)205 / distance4perStep);
	Information.nStep4Turn90 = (int)((PI*MOUSE_WIDTH/3.41)/distance4perStep);
}

int adjustmouse(void)
{
	int adjLeftSensor,adjRightSensor;
	int adjflagcnt = 0;

	adjLeftSensor = readSensor(LEFT_SENSOR); 
	adjRightSensor = readSensor(RIGHT_SENSOR);

	vel_counter_high_L=VelocityLeftmotorTCNT1; 
    	vel_counter_high_R=VelocityRightmotorTCNT3;

	if((adjRightSensor < StandardSensor[2])		// ������ ���� �������� ���� ���
	|| (adjLeftSensor < StandardSensor[1]))		// ���� ���� �������� ���� ���
	{
		vel_counter_high_L = vel_counter_high;	// �ӵ��� �����ϰ� ����
		vel_counter_high_R = vel_counter_high;
		return 0;
	}                                   

	if(adjRightSensor < CenterStandardSensor[2])	// ������ ���� �� ���
	{
		vel_counter_high_L+=5;
		vel_counter_high_R-=5;
		if(vel_counter_high_L > vel_counter_high+35)
		{
			vel_counter_high_L = vel_counter_high+35; 
		}

		if(vel_counter_high_R < (vel_counter_high - 35))
		{
			vel_counter_high_R = (vel_counter_high - 35);
		}
	}
	else
	adjflagcnt++;

	if(adjLeftSensor < CenterStandardSensor[1])	// ���� ���� �� ���
	{
		vel_counter_high_L-=5;
		vel_counter_high_R+=5; 
		if(vel_counter_high_R > vel_counter_high+35)
		{
			vel_counter_high_R = vel_counter_high+35; 
		}
		if(vel_counter_high_L < (vel_counter_high - 35))
		{
			vel_counter_high_L = (vel_counter_high - 35);
		}
	}
	else
	adjflagcnt++;

	if(adjflagcnt == 2)				// ������ ���� ���� ���� �Ѵ� ���� ���� ���
	{							// �ӵ� �����ϰ�
		vel_counter_high_L = vel_counter_high;
		vel_counter_high_R = vel_counter_high;
		return 0;
	}
		return 1;
}

void Direction(int mode)
{
     int LStepCount = 0, RStepCount = 0;
     
     TCCR1B = 0x04;
     TCCR3B = 0x04;

     direction_control = mode;
     
     Flag.LmotorRun = FALSE;
     Flag.RmotorRun = FALSE;
     
     switch(mode)
     {
     case FORWARD:
          while(LStepCount<Information.nStep4perBlock || RStepCount<Information.nStep4perBlock)
          {
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          break;    

     case HALF:
          while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<(Information.nStep4perBlock>>1))
          {
               if(readSensor(FRONT_SENSOR) > CenterStandardSensor[0])
               {
                    break;
               }
               if(Flag.LmotorRun || Flag.RmotorRun)
               { 
                    adjustmouse(); 
                    VelocityLeftmotorTCNT1=vel_counter_high_L;
                    VelocityRightmotorTCNT3=vel_counter_high_R;                 
               }
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          
          break;    
     case LEFT:
          VelocityLeftmotorTCNT1 = 65350;	// ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65350;	// ������ ������ �ӵ� (65200 ~ 65535)
          while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
          {
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          break;
     case RIGHT:
          VelocityLeftmotorTCNT1 = 65350;	// ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65350;	// ������ ������ �ӵ� (65200 ~ 65535)
          while(LStepCount<Information.nStep4Turn90 || RStepCount<Information.nStep4Turn90)
          {
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          break;
     case BACK:
          VelocityLeftmotorTCNT1 = 65300;	// ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65300;	// ������ ������ �ӵ� (65200 ~ 65535)
          while(LStepCount<(Information.nStep4Turn90*2) || RStepCount<(Information.nStep4Turn90*2))
          {
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          break;
     case QUARTER:
          while(LStepCount<((Information.nStep4perBlock>>1)>>1) || RStepCount<((Information.nStep4perBlock>>1)>>1))
          {
               
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          
          break;
     case TURN_L:
          while( RStepCount<(Information.nStep4perBlock>>1))
          {
               
               
               if(Flag.RmotorRun)
               {
                    RStepCount++;
                    Flag.RmotorRun = FALSE;
               }
          }
          
          break;
     case TURN_R:
          while(LStepCount<(Information.nStep4perBlock>>1) )
          {
               
               if(Flag.LmotorRun)
               {
                    LStepCount++;
                    Flag.LmotorRun = FALSE;
               }
          }
          
          break;          
     }     
     TCCR1B = 0x00;
     TCCR3B = 0x00;
}
