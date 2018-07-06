//
//  KD926.h
//  testShareCommunication
//
//  Created by my on 8/10/13.
//  Copyright (c) 2013年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPMacroFile.h"
#import <UIKit/UIKit.h>
//#define ProductType_KD926 0xA1

@interface KD926 : NSObject{
    
    BlockEnergyValue _blockEnergyValue;
    BlockError _blockError;
    BlockDeviceFounction _blockFounction;
    BlockBlueSet _blockBlueSet;
    BlockAngle _blockAngle;
    
    BlockXioaboWithHeart _blockXiaoboArr;
    BlockXioaboNoHeart _blockXiaoboArrNoHeart;
    BlockPressure _blockPressureArr;
    BlockMesureResult _blockMesureResult;
    
    BlockBachCount _blockBachCount;
    BlockBachProgress _blockBachProgress;
    BlockBachArray _blockBachArray;
    BlockStopSuccess _blockStopSuccess;
    
    BlockUserAuthentication _blockUserAnthen;
    
    BOOL isCompleteZero;
    int totalBatchCount;
    BOOL isResived;
    int uploadCountSum;
    BOOL uploadOfflineNumFlg;
    
    //功能标志位
    BOOL upAirMeasureFlg;    //上气、下气测量标志位
    BOOL armMeasureFlg;    //腕式、臂式
    BOOL haveAngleSensorFlg;       //是否带角度
    BOOL haveOfflineFlg;     //是否有离线数据
    BOOL haveHSDFlg;         //是否有HSD
    BOOL mutableUploadFlg;   //记忆组别
    BOOL haveAngleSetFlg;   //是否带手腕角度设置
    BOOL selfUpdateFlg;      //是否自升级
    
    NSString *thirdUserID;
    
    NSString *clientSDKUserName;
    NSString *clientSDKID;
    NSString *clientSDKSecret;
    
    NSMutableArray *totalHistoryArray;
        
}
@property (strong, nonatomic)UIAlertView * Erroralert;

@property (strong, nonatomic) NSString *currentUUID;
@property (strong, nonatomic) NSString *serialNumber;
@property (strong, nonatomic) NSTimer *startMeasureTimer;


#pragma mark - Hypogenous query
/**
 * Synchronize time and judge if the device supports the function of up Air Measurement, arm Measurement, Angle Sensor, Angle Setting, HSD, Offline Memory, mutable Groups Upload, Self Upgrade. ‘True’ means yes or on, ‘False’ means no or off.
 * @param Function  A block to return the function and states that the device supports.
 * @param error  A block to refer ‘error’ in ‘Establish measurement connection’ in KD926.
 */
-(void)commandFounction:(BlockDeviceFounction)founction errorBlock:(BlockError)error;

/**
 * Query battery remaining energy.
 * @param energyValue  A block to return the device battery remaining energy percentage, ‘80’ stands for 80%.
 * @param error  A block to return the error in ‘Establish measurement connection’
 */
-(void)commandEnergy:(BlockEnergyValue)energyValue errorBlock:(BlockError)error;


/**
 * Upload offline data.
 * @param userID  the only identification for the user，by the form of email or cell phone #(cell-phone-# form is not supported temperately).
 * @param clientID  see bellow.
 * @param clientsecret  ‘clientID’ and ‘clientsecret’ are the only identification for user of SDK, are required registration from iHealth administrator, please email: lvjincan@ihealthlabs.com.cn.com for more information.
 * @param disposeAuthenticationBlock   A block to return parameter of ‘userid’, ’clientID’, ’clientSecret’ after the verification.
 * The interpretation for the verification:
 *  1. UserAuthen_RegisterSuccess, New-user registration succeeded.
 *  2. UserAuthen_LoginSuccess， User login succeeded.
 *  3. UserAuthen_CombinedSuccess, The user is iHealth user as well, measurement via SDK has been activated, and the data from the measurement belongs to the user.
 *  4. UserAuthen_TrySuccess, testing without Internet connection succeeded.
 *  5. UserAuthen_InvalidateUserInfo, Userid/clientID/clientSecret verification failed.
 *  6. UserAuthen_SDKInvalidateRight, SDK has not been authorized.
 *  7. UserAuthen_UserInvalidateRight,User has not been authorized.
 *  8. UserAuthen_InternetError, Internet error, verification failed.
 *  --PS:
 *  The measurement via SDK will be operated in the case of 1-4, and will be terminated if any of 5-8 occurs. The interface needs to be re-called after analyzing the return parameters.
 *  @Notice   By the first time of new user register via SDK, ‘iHealth disclaimer’ will pop up automatically, and require the user agrees to continue. SDK application requires Internet connection; there is 10-day tryout if SDK cannot connect Internet, SDK is fully functional during tryout period, but will be terminated without verification through Internet after 10 days.
 * @param  groupNumber: the group number to upload in multiple groups memery situation,its number is either @1 or @2.
 * @param  TotalCount: item quantity of total data
 * @param  Progress: upload completion ratio , from 0.0 to 1.0 or 0%~100％, 100% means upload completed.
 * @param  UploadDataArray:	offline data set, including measurement time, systolic pressure, diastolic pressure, pulse rate, irregular judgment. corresponding KEY as time, sys, dia, heartRate, irregular.
 * @param error   error codes.
 * Specification:
 *   1.  BPError0 = 0: Unable to take measurements due to arm/wrist movements.
 *   2.  BPError1:  Failed to detect systolic pressure.
 *   3.  BPError2:  Failed to detect diastolic pressure.
 *   4.  BPError3:  Pneumatic system blocked or cuff is too tight during inflation.
 *   5.  BPError4:  Pneumatic system leakage or cuff is too loose during inflation.
 *   6.  BPError5:  Cuff pressure reached over 300mmHg.
 *   7.  BPError6:  Cuff pressure reached over 15 mmHg for more than 160 seconds.
 *   8.  BPError7:  Data retrieving error.
 *   9.  BPError8:  Data retrieving error.
 *   10.  BPError9:  Data retrieving error.
 *   11.  BPError10:  Data retrieving error.
 *   12.  BPError11:  Communication Error.
 *   13.  BPError12:  Communication Error.
 *   14.  BPError13:  Low battery.
 *   15.  BPError14:  Device bluetooth set failed.
 *   16.  BPError15:  Systolic exceeds 260mmHg or diastolic exceeds 199mmHg.
 *   17.  BPError16:  Systolic below 60mmHg or diastolic below 40mmHg.
 *   18.  BPError17:  Arm/wrist movement beyond range.
 *   19.  BPNormalError=30:  device error, error message displayed automatically.
 *   20.  BPOverTimeError:  Abnormal communication.
 *   21.  BPNoRespondError:  Abnormal communication.
 *   22.  BPBeyondRangeError:  device is out of communication range.
 *   23.  BPDidDisconnect:  device is disconnected.
 *   24.  BPAskToStopMeasure:  measurement has been stopped.
 *   25.  BPInputParameterError=400:  Parameter input error.
 */
-(void)commandTransferMemoryDataWithUser:(NSString *)userID clientID:(NSString *)clientID clientSecret:(NSString *)clientSecret Authentication:(BlockUserAuthentication)disposeAuthenticationBlock withGroupNumber:(NSNumber *)groupNumber totalCount:(BlockBachCount)totalCount pregress:(BlockBachProgress)progress dataArray:(BlockBachArray)uploadDataArray errorBlock:(BlockError)error;

/**
 * Upload offline data total Count.
 * @param  TotalCount: item quantity of total data
 * @param  groupNumber: the group number to upload in multiple groups memery situation,its number is either @1 or @2.
 * @param error  A block to return the error
 */

-(void)commandTransferMemorytotalCount:(BlockBachCount)totalCount withGroupNumber:(NSNumber *)groupNumber errorBlock:(BlockError)error;

/**
 * upload offline data finished.
 * After receiving all the requested data call this method,you must call this method to notify the device uploading offline data has been completed.
 */
-(void)commandBatchUploadFinish;

/**
 * Disconnect current device.
 */
-(void)commandDisconnectDevice;

@end
