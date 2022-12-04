/*
**********************���ɹ� ���***************************

<stepmotor.c>
{          
          
          
          extern unsigned int init_dire;
          extern unsigned int dire;
          
          
          case RST:
          if(dire==1)
          {
            dire=4;
          }
          else
          {
            dire--;
          }
          while(LStepCount<(Information.nStep4perBlock>>1) || RStepCount<Information.nStep4perBlock>>2)
          {
          VelocityLeftmotorTCNT1 = 65462;    // ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65240;    // ������ ������ �ӵ� (65200 ~ 65535)
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
     case LST:
          if(dire==4)
          {
            dire=1;
          }
          else
          {
            dire++;
          }
          while(LStepCount<Information.nStep4perBlock>>2 || RStepCount<(Information.nStep4perBlock>>1))
          {
          VelocityLeftmotorTCNT1 = 65240;    // ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65460;    // ������ ������ �ӵ� (65200 ~ 65535)
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
          LED_OFF(LED1 | LED2 | LED3 | LED4);
          LED_ON(LED1);
          /////////////////////���ɹ�/////////////////////
          if(dire==4)
          {
            dire=1;
          }
          else
          {
            dire++;
          }
          ///////////////////////////////////////////////
          VelocityLeftmotorTCNT1 = 65350;    // ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65350;    // ������ ������ �ӵ� (65200 ~ 65535)
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
          direc++;
          if(direc>4)
          {
                direc=1;
          }
          break;
     case RIGHT:
          LED_OFF(LED1 | LED2 | LED3 | LED4);
          LED_ON(LED4);
          /////////////////////���ɹ�/////////////////////
          if(dire==1)
          {
            dire=4;
          }
          else
          {
            dire--;
          }
          ///////////////////////////////////////////////
          VelocityLeftmotorTCNT1 = 65350;    // ���� ������ �ӵ� (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65350;    // ������ ������ �ӵ� (65200 ~ 65535)
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
          direc--;
          if(direc<1)
          {
                direc=4;
          }
          break;
}

<Algorithm.c>
{
unsigned x=5;
unsigned y=1;
//��->x--,  ��->x++
//up->y--,  down->y++
unsigned int arr[7][7]=
{
{0, 0, 0, 0, 0, 0, 0},
{0, 5, 6, 7, 8, 9, 0},
{0, 4, 5, 6, 7, 8, 0},
{0, 3, 4, 5, 6, 7, 0},
{0, 2, 3, 4, 5, 6, 0},
{0, 1, 2, 3, 4, 5, 0},
{0, 0, 0, 0, 0, 0, 0}
};

unsigned int init_dire=3;
//3->��
//4->��
//1->�Ʒ�
//2->��

unsigned int dire;
unsigned int wv_a=0;
unsigned int wv_b=0;
unsigned int wv_c=0;





dire=init_dire;//�ʱ� ���� �Է�





<��ɺ� ����>
************����ġ �Ǻ� ���************
if(dire==3)//���콺 ��
{
    wv_a=arr[y-1][x+1];//���� �Ǻ� y-1
    wv_b=arr[y-1][x-1];//���� �Ǻ� y-1
    wv_c=arr[x][y-2];//���� �Ǻ�y-2        
}
else if(dire==1)//���콺 ��
{
    wv_a=arr[y+1][x-1];//���� �Ǻ� y+1
    wv_b=arr[y+1][x+1];//���� �Ǻ� y+1
    wv_c=arr[y+2][x];//���� �Ǻ�
}
else if(dire==2)//���콺 ��
{
    wv_a=arr[y+1][x+1];//���� �Ǻ� y+1
    wv_b=arr[y-1][x+1];//���� �Ǻ� y-1
    wv_c=arr[y][x+2];//���� �Ǻ�y
}
else if(dire==4)//���콺 ��
{
    wv_a=arr[y-1][x-1];//���� �Ǻ�y-1 
    wv_b=arr[y+1][x-1];//���� �Ǻ�y+1
    wv_c=arr[y][x-2];//���� �Ǻ�x-2    
}
//////////////////////////////////����ġ ����
//wv_a//���� �Ǻ� 
//wv_b//���� �Ǻ�
//wv_c//���� �Ǻ�    

********************************************


***************���� �� ��ǥ ������Ʈ************
if(dire==3)//���콺 ��
{
    x=x-2;      
}
else if(dire==1)//���콺 ��
{
    x=x+2;    
}
else if(dire==2)//���콺 ��
{
    y=y+2;    
}
else if(dire==4)//���콺 ��
{
    y=y-2;       
}
                         
Direction(HALF);
Direction(HALF);
wv_a=0;
wv_b=0;
wv_c=0;
********************************************

**************��ȸ�� �� ��ǥ ������Ʈ***********
if(dire==3)//���콺 ��////////////////////////////////
{
    x=x-1;
    y=y-1;      
}
else if(dire==1)//���콺 ��
{
    x=x+1;
    y=y+1;    
}
else if(dire==2)//���콺 ��
{
    x=x-1;
    y=y+1;        
}
else if(dire==4)//���콺 ��
{
    x=x+1;
    y=y-1;         
}
Direction(HALF);
Direction(LEFT);
Direction(HALF);
wv_a=0;
wv_b=0;
wv_c=0;
*********************************************

************��ȸ�� �� ��ǥ ������Ʈ**************
if(dire==3)//���콺 ��
{
    x=x-1;
    y=y+1;      
}
else if(dire==1)//���콺 ��
{
    x=x+1;
    y=y-1;    
}
else if(dire==2)//���콺 ��
{
    x=x+1;
    y=y+1;        
}
else if(dire==4)//���콺 ��
{
    x=x-1;
    y=y-1;         
}    
                            
Direction(HALF);
Direction(RIGHT);
Direction(HALF);
wv_a=0;
wv_b=0;
wv_c=0;
*********************************************

***************�� �� ��ǥ ������Ʈ***************
if(dire==3)//���콺 ��
{
    x=x-1;     
}
else if(dire==1)//���콺 ��
{
    x=x+1;    
}
else if(dire==2)//���콺 ��
{
    y=y+1;        
}
else if(dire==4)//���콺 ��
{
    y=y-1;         
}
Direction(HALF);
Direction(LEFT);
Direction(LEFT);
Direction(HALF);
wv_a=0;
wv_b=0;
wv_c=0;
*********************************************
                                
                                
                                                               
**********************************************************
*/