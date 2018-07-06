//
//  BPMacroFile.h
//  BP_SDKDemo
//
//  Created by zhiwei jing on 14-2-25.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "HealthUser.h"

#ifndef BP_SDKDemo_BPMacroFile_h
#define BP_SDKDemo_BPMacroFile_h

typedef enum {
    BPError0 = 0,//Unable to take measurements due to arm/wrist movements.
    BPError1,//Failed to detect systolic pressure
    BPError2,//Failed to detect diastolic pressure
    BPError3,//Pneumatic system blocked or cuff is too tight during inflation
    BPError4,//Pneumatic system leakage or cuff is too loose during inflation
    BPError5,//Cuff pressure reached over 300mmHg
    BPError6,//Cuff pressure reached over 15 mmHg for more than 160 seconds
    BPError7,//Data retrieving error
    BPError8,//Data retrieving error
    BPError9,//Data retrieving error
    BPError10,//Data retrieving error
    BPError11,//Communication Error
    BPError12,//Communication Error
    BPError13,//Low battery
    BPError14,//Device bluetooth set failed
    BPError15,//Systolic exceeds 260mmHg or diastolic exceeds 199mmHg
    BPError16,//Systolic below 60mmHg or diastolic below 40mmHg
    BPError17,//Arm/wrist movement beyond range
    BPNormalError = 30,//device error, error message displayed automatically
    BPOverTimeError,//Abnormal communication
    BPNoRespondError,//Abnormal communication
    BPBeyondRangeError,//device is out of communication range.
    BPDidDisconnect,//device is disconnected.
    BPAskToStopMeasure,//measurement has been stopped.
    BPInputParameterError = 400,//Parameter input error.
    
}BPDeviceError;

typedef enum{
    ABIMeasureTypeArm = 0,
    ABIMeasureTypeAll
}ABIMeasureType;

typedef void (^BlockEnergyValue)(NSNumber *energyValue);
typedef void(^BlockError)(BPDeviceError error);
typedef void(^BlockDeviceFounction)(NSDictionary *dic);
typedef void(^BlockBlueSet)(BOOL isOpen);
typedef void(^BlockAngle)(NSDictionary *dic);
typedef void(^BlockPressure)(NSArray *pressureArr);
typedef void(^BlockXioaboWithHeart)(NSArray *xiaoboArr);
typedef void(^BlockXioaboNoHeart)(NSArray *xiaoboArr);
typedef void(^BlockZero)(BOOL isComplete);
typedef void(^BlockMesureResult)(NSDictionary *dic);

typedef void(^BlockBachCount)(NSNumber *num);
typedef void(^BlockBachProgress)(NSNumber *pregress);
typedef void(^BlockBachArray)(NSArray *array);
typedef void(^BlockBachFinished)(BOOL finishFlag);

typedef void(^BlockAskMeasureTime)(NSDictionary *measureTimeDic);
typedef void(^BlockSetMeasureTime)(NSDictionary *setResult);

typedef void(^BlockStopSuccess)();

typedef void (^BlockUserAuthentication)(UserAuthenResult result);//the result of userID verification
typedef void(^BlockSetUserID)(BOOL finishFlag);

typedef void(^BlockStopResult)(BOOL result);
typedef void(^BlockDelPortResult)(BOOL result);


#define BP3ConnectNoti @"BP3ConnectNoti"
#define BP3DisConnectNoti @"BP3DisConnectNoti"
#define BP5ConnectNoti @"BP5ConnectNoti"
#define BP5DisConnectNoti @"BP5DisConnectNoti"
#define BP7ConnectNoti @"BP7ConnectNoti"
#define BP7DisConnectNoti @"BP7DisConnectNoti"

#define BP3LDiscover        @"BP3LDiscover"
#define BP3LConnectFailed   @"BP3LConnectFailed"
#define BP3LConnectNoti @"BP3LConnectNoti"
#define BP3LDisConnectNoti @"BP3LDisConnectNoti"

#define BP7SDiscover        @"BP7SDiscover"
#define BP7SConnectFailed   @"BP7SConnectFailed"
#define BP7SConnectNoti @"BP7SConnectNoti"
#define BP7SDisConnectNoti @"BP7SDisConnectNoti"

#define KN550BTDiscover         @"KN550BTDiscover"
#define KN550BTConnectFailed   @"KN550BTConnectFailed"
#define KN550BTConnectNoti @"KN550BTConnectNoti"
#define KN550BTDisConnectNoti @"KN550BTDisConnectNoti"

#define KD926Discover        @"KD926Discover"
#define KD926ConnectFailed   @"KD926ConnectFailed"
#define KD926ConnectNoti @"KD926ConnectNoti"
#define KD926DisConnectNoti @"KD926DisConnectNoti"

#define KD723Discover        @"KD723Discover"
#define KD723ConnectFailed   @"KD723ConnectFailed"
#define KD723ConnectNoti @"KD723ConnectNoti"
#define KD723DisConnectNoti @"KD723DisConnectNoti"

#define ABPMDiscover        @"ABPMDiscover"
#define ABPMConnectFailed   @"ABPMConnectFailed"
#define ABPMConnectNoti @"ABPMConnectNoti"
#define ABPMDisConnectNoti @"ABPMDisConnectNoti"

#define ContinuaBPDiscover        @"ContinuaBPDiscover"
#define ContinuaBPConnectFailed   @"ContinuaBPConnectFailed"
#define ContinuaBPConnectNoti @"ContinuaBPConnectNoti"
#define ContinuaBPDisConnectNoti @"ContinuaBPDisConnectNoti"



#define BPDeviceID @"ID"
#define BPSDKRightApi  @"OpenApiBP"




#define ABIConnectNoti @"ABIConnectNoti"
#define ABIDisConnectNoti @"ABIDisConnectNoti"

#define ArmKey    @"ABI-ARM"
#define LegKey    @"ABI-Leg"


#define ArmConnectNoti @"ArmConnectNoti"
#define ArmDisConnectNoti @"ArmDisConnectNoti"






#endif
