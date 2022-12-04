#ifndef _StepMotor_h_
#define _StepMotor_h_
#ifndef     TRUE
#define   TRUE        1
#endif

#ifndef     FALSE
#define   FALSE        0
#endif

#define   FORWARD     4
#define   LEFT        5
#define   RIGHT       6
#define   BACK        7
#define   HALF        8
#define   QUARTER     9
#define   TURN_R      10
#define   TURN_L      11


#define   TIRE_RAD      52.    // unit : mm
#define   MOUSE_WIDTH   90.    // unit : mm (타이어 중간)
#define   MOUSE_LENGTH  114.    // unit : mm
#define   MOTOR_STEP    395    // unit : step

 
	void InitializeStepMotor(void);
    void Direction(int mode);
#endif