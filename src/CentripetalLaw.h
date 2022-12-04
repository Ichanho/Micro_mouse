/*
**********************구심법 기능***************************

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
          VelocityLeftmotorTCNT1 = 65462;    // 왼쪽 모터의 속도 (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65240;    // 오른쪽 모터의 속도 (65200 ~ 65535)
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
          VelocityLeftmotorTCNT1 = 65240;    // 왼쪽 모터의 속도 (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65460;    // 오른쪽 모터의 속도 (65200 ~ 65535)
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
          /////////////////////구심법/////////////////////
          if(dire==4)
          {
            dire=1;
          }
          else
          {
            dire++;
          }
          ///////////////////////////////////////////////
          VelocityLeftmotorTCNT1 = 65350;    // 왼쪽 모터의 속도 (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65350;    // 오른쪽 모터의 속도 (65200 ~ 65535)
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
          /////////////////////구심법/////////////////////
          if(dire==1)
          {
            dire=4;
          }
          else
          {
            dire--;
          }
          ///////////////////////////////////////////////
          VelocityLeftmotorTCNT1 = 65350;    // 왼쪽 모터의 속도 (65200 ~ 65535)
          VelocityRightmotorTCNT3 = 65350;    // 오른쪽 모터의 속도 (65200 ~ 65535)
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
//좌->x--,  우->x++
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
//3->위
//4->좌
//1->아래
//2->우

unsigned int dire;
unsigned int wv_a=0;
unsigned int wv_b=0;
unsigned int wv_c=0;





dire=init_dire;//초기 방향 입력





<기능별 정리>
************가중치 판별 기능************
if(dire==3)//마우스 상
{
    wv_a=arr[y-1][x+1];//우측 판별 y-1
    wv_b=arr[y-1][x-1];//좌측 판별 y-1
    wv_c=arr[x][y-2];//직진 판별y-2        
}
else if(dire==1)//마우스 하
{
    wv_a=arr[y+1][x-1];//우측 판별 y+1
    wv_b=arr[y+1][x+1];//좌측 판별 y+1
    wv_c=arr[y+2][x];//직진 판별
}
else if(dire==2)//마우스 우
{
    wv_a=arr[y+1][x+1];//우측 판별 y+1
    wv_b=arr[y-1][x+1];//좌측 판별 y-1
    wv_c=arr[y][x+2];//직진 판별y
}
else if(dire==4)//마우스 좌
{
    wv_a=arr[y-1][x-1];//우측 판별y-1 
    wv_b=arr[y+1][x-1];//좌측 판별y+1
    wv_c=arr[y][x-2];//직진 판별x-2    
}
//////////////////////////////////가중치 저장
//wv_a//우측 판별 
//wv_b//좌측 판별
//wv_c//직진 판별    

********************************************


***************직진 및 좌표 업데이트************
if(dire==3)//마우스 상
{
    x=x-2;      
}
else if(dire==1)//마우스 하
{
    x=x+2;    
}
else if(dire==2)//마우스 우
{
    y=y+2;    
}
else if(dire==4)//마우스 좌
{
    y=y-2;       
}
                         
Direction(HALF);
Direction(HALF);
wv_a=0;
wv_b=0;
wv_c=0;
********************************************

**************좌회전 및 좌표 업데이트***********
if(dire==3)//마우스 상////////////////////////////////
{
    x=x-1;
    y=y-1;      
}
else if(dire==1)//마우스 하
{
    x=x+1;
    y=y+1;    
}
else if(dire==2)//마우스 우
{
    x=x-1;
    y=y+1;        
}
else if(dire==4)//마우스 좌
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

************우회전 및 좌표 업데이트**************
if(dire==3)//마우스 상
{
    x=x-1;
    y=y+1;      
}
else if(dire==1)//마우스 하
{
    x=x+1;
    y=y-1;    
}
else if(dire==2)//마우스 우
{
    x=x+1;
    y=y+1;        
}
else if(dire==4)//마우스 좌
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

***************턴 및 좌표 업데이트***************
if(dire==3)//마우스 상
{
    x=x-1;     
}
else if(dire==1)//마우스 하
{
    x=x+1;    
}
else if(dire==2)//마우스 우
{
    y=y+1;        
}
else if(dire==4)//마우스 좌
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