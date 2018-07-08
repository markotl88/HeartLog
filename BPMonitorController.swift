//
//  BPMonitorController.swift
//  Dms
//
//  Created by Marko Stajic on 7/8/18.
//  Copyright © 2018 DMS. All rights reserved.
//

import UIKit

enum BPMonitorState {
    case NotConnected
    case Connected
    case GettingAngle
    case Disconnected
    case MeasuringDone
    case MeasuringStopped
    case MeasuringNonFatalError
}

protocol BPMonitorDelegate: class {
    func bpController(didSetState state: BPMonitorState, angle: Int?, errorMessage: String?, bloodPressureResult: BloodPressureReading?)
}

final class BPMonitorController {
    
    let clientId: String!
    let clientSecret: String!
    let userId: String!
    
    var bpDeviceInstance : BP7?
    var bpController = BP7Controller.share()
    var connectDeviceController = ConnectDeviceController.commandGetInstance()
    
    var bpState = BPMonitorState.NotConnected 
    
    weak var delegate: BPMonitorDelegate?
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDiscovered(info:)), name: NSNotification.Name(rawValue: BP7ConnectNoti), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDisconnected(info:)), name: NSNotification.Name(rawValue: BP7DisConnectNoti), object: nil)
    }
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BP7ConnectNoti), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BP7DisConnectNoti), object: nil)
    }
    
    init(clientId: String, clientSecret: String, userId: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.userId = userId
        addNotificationObservers()
    }
    
    func start() {
        tryToConnectBPDevice()
        addNotificationObservers()
        startScanningForBPDevices()
    }
    func stop() {
        stopScanningForBPDevices()
        if let bpDevice = bpDeviceInstance {
            bpDevice.stopBPMeassureErrorBlock({
                print("BP Device stopped")
            }, errorBlock: { (error) in
                self.delegate?.bpController(didSetState: BPMonitorState.Disconnected, angle: nil, errorMessage: self.handleError(error: error), bloodPressureResult: nil)
            })
        }
    }
    
    deinit {
        removeNotificationObservers()
    }
    
    func tryToConnectBPDevice(){
        if let bpDevices = bpController?.getAllCurrentBP7Instace() as? [BP7] {
            if bpDevices.count != 0 {
                bpDeviceInstance = bpDevices.first
                stopScanningForBPDevices()
                self.delegate?.bpController(didSetState: BPMonitorState.Connected, angle: nil, errorMessage: nil, bloodPressureResult: nil)
            }else{
                //TODO: Print something
            }
        }else{
            //TODO: Print something
        }
    }
    func bpDeviceConnected(){
        if let bpDevices = bpController?.getAllCurrentBP7Instace() as? [BP7] {
            if bpDevices.count != 0 {
                stopScanningForBPDevices()
                bpDeviceInstance = bpDevices.first
                self.delegate?.bpController(didSetState: BPMonitorState.Connected, angle: nil, errorMessage: nil, bloodPressureResult: nil)
                
            }else{
                //TODO: Print something
            }
        }else{
            //TODO: Print something
        }
    }
    @objc func deviceDiscovered(info: Notification){
        
        stopScanningForBPDevices()
        print("BP7 Device Connected")
        if let bp7Cont = info.object as? BP7Controller {
            self.bpController = bp7Cont
            
            if let bpDevs = bp7Cont.getAllCurrentBP7Instace() as? [BP7] {
                if let bpDev = bpDevs.first {
                    print("BP Device UUID: \(bpDev.currentUUID)")
                    print("BP Device SN: \(bpDev.serialNumber)")
                    self.connectDeviceController?.commandContectDevice(with: HealthDeviceType_BP7S, andSerialNub: bpDev.serialNumber)
                }
            }
        }
        self.bpDeviceConnected()
    }
    @objc func deviceDisconnected(info: Notification){
        print("BP7 Device Disconnected")
    }
    func startScanningForBPDevices() {
        ScanDeviceController.commandGetInstance().commandScanDeviceType(HealthDeviceType_BP7S)
    }
    func stopScanningForBPDevices(){
        ScanDeviceController.commandGetInstance().commandStopScanDeviceType(HealthDeviceType_BP7S)
    }
    @objc func iHealthAuthenticationTimedOut() {
        self.delegate?.bpController(didSetState: BPMonitorState.NotConnected, angle: nil, errorMessage: "Connection to BP7 timed out", bloodPressureResult: nil)
    }
    
    func startGettingAngle(){
        if let bpDevice = bpDeviceInstance {
            
            bpDevice.commandEnergy({ (batteryLevel: NSNumber?) in
                
            }, errorBlock: { (error) in
                print("BP7 Energy level error: \(error)")
                self.delegate?.bpController(didSetState: BPMonitorState.Disconnected, angle: nil, errorMessage: self.handleError(error: error), bloodPressureResult: nil)
            })
            
            let authTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(iHealthAuthenticationTimedOut), userInfo: nil, repeats: false)
            bpDevice.commandStartGetAngle(withUser: self.userId, clientID: self.clientId, clientSecret: self.clientSecret, authentication: { (UserAuthenResult) in
                
                authTimer.invalidate()
                print("Authentication: \(UserAuthenResult)")
                
                //                *  1. UserAuthen_RegisterSuccess, New-user registration succeeded.
                //                *  2. UserAuthen_LoginSuccess， User login succeeded.
                //                *  3. UserAuthen_CombinedSuccess, The user is iHealth user as well, measurement via SDK has been activated, and the data from the measurement belongs to the user.
                //                *  4. UserAuthen_TrySuccess, testing without Internet connection succeeded.
                //                *  5. UserAuthen_InvalidateUserInfo, Userid/clientID/clientSecret verification failed.
                //                *  6. UserAuthen_SDKInvalidateRight, SDK has not been authorized.
                //                *  7. UserAuthen_UserInvalidateRight,User has not been authorized.
                //                *  8. UserAuthen_InternetError, Internet error, verification failed.
                
                switch UserAuthenResult {
                case UserAuthen_RegisterSuccess, UserAuthen_LoginSuccess, UserAuthen_CombinedSuccess, UserAuthen_TrySuccess:
                    break
                case UserAuthen_InvalidateUserInfo, UserAuthen_SDKInvalidateRight, UserAuthen_UserInvalidateRight, UserAuthen_InternetError:
                    break
                default:
                    break
                }
                
            }, angle: { (dict: [AnyHashable : Any]?) in
                
                let angle = dict?["angle"] as! Int
                DispatchQueue.main.async {
                    self.delegate?.bpController(didSetState: BPMonitorState.GettingAngle, angle: angle, errorMessage: nil, bloodPressureResult: nil)
                }
                
            }, errorBlock: { (error) in
                self.delegate?.bpController(didSetState: BPMonitorState.Disconnected, angle: nil, errorMessage: self.handleError(error: error), bloodPressureResult: nil)
            })
        }
    }
    
    func startBPMeasure() {
        if let bpDevice = bpDeviceInstance {
            bpDevice.commandStartMeasure({ (press: [Any]?) in
            }, xiaoboWithHeart: { (heart: [Any]?) in
            }, xiaoboNoHeart: { (noHeart: [Any]?) in
            }, result: { (res: [AnyHashable : Any]?) in
                
                if let result = res, let sys = result["sys"] as? UInt, let dia = result["dia"] as? UInt, let heartRate = result["heartRate"] as? UInt {
                    
                    DispatchQueue.main.async {
                        let bloodPressureResult = BloodPressureReading(systolic: sys, diastolic: dia, heartRate: heartRate, time: nil)
                        self.delegate?.bpController(didSetState: BPMonitorState.MeasuringDone, angle: nil, errorMessage: nil, bloodPressureResult: bloodPressureResult)
                    }
                }
                
            }) { (error) in
                self.delegate?.bpController(didSetState: BPMonitorState.Disconnected, angle: nil, errorMessage: self.handleError(error: error), bloodPressureResult: nil)
            }
        }
    }
    
    func stopBPMeasure() {
        if let bpDevice = bpDeviceInstance {
            bpDevice.stopBPMeassureErrorBlock({
                
                DispatchQueue.main.async {
                    self.delegate?.bpController(didSetState: BPMonitorState.MeasuringStopped, angle: nil, errorMessage: "Measure stopped", bloodPressureResult: nil)
                }
                
            }, errorBlock: { (error) in
                
                if error == BPOverTimeError || error == BPNoRespondError {
                    self.delegate?.bpController(didSetState: BPMonitorState.MeasuringNonFatalError, angle: nil, errorMessage: self.handleError(error: error), bloodPressureResult: nil)
                } else {
                    self.delegate?.bpController(didSetState: BPMonitorState.Disconnected, angle: nil, errorMessage: self.handleError(error: error), bloodPressureResult: nil)
                }
            })
        }
    }

    func handleError(error: BPDeviceError) -> String{
        
        var bpErrorMessage = ""
        
        switch error {
        case BPError0: bpErrorMessage = "Unable to take measurements due to arm/wrist movements."
        case BPError1: bpErrorMessage = "Failed to detect systolic pressure"
        case BPError2: bpErrorMessage = "Failed to detect diastolic pressure"
        case BPError3: bpErrorMessage = "Pneumatic system blocked or cuff is too tight"
        case BPError4: bpErrorMessage = "Pneumatic system leakage or cuff is too loose"
        case BPError5: bpErrorMessage = "Cuff pressure reached over 300mmHg"
        case BPError6: bpErrorMessage = "Cuff pressure reached over 15 mmHg for more than 160 seconds"
        case BPError7: bpErrorMessage = "Data retrieving error"
        case BPError8: bpErrorMessage = "Data retrieving error"
        case BPError9: bpErrorMessage = "Data retrieving error"
        case BPError10: bpErrorMessage = "Data retrieving error"
        case BPError11: bpErrorMessage = "Communication Error"
        case BPError12: bpErrorMessage = "Communication Error"
        case BPError13: bpErrorMessage = "Low battery"
        case BPError14: bpErrorMessage = "Device bluetooth set failed"
        case BPError15: bpErrorMessage = "Systolic exceeds 260mmHg or diastolic exceeds 199mmHg"
        case BPError16: bpErrorMessage = "Systolic below 60mmHg or diastolic below 40mmHg"
        case BPError17: bpErrorMessage = "Arm/wrist movement beyond range"
        case BPNormalError: bpErrorMessage = "device error, error message displayed automatically"
        case BPOverTimeError: bpErrorMessage = "Abnormal communication"
        case BPNoRespondError: bpErrorMessage = "Abnormal communication"
        case BPBeyondRangeError: bpErrorMessage = "Device is out of communication range."
        case BPDidDisconnect: bpErrorMessage = "Device is disconnected."
        case BPAskToStopMeasure: bpErrorMessage = "Measurement has been stopped."
        case BPInputParameterError: bpErrorMessage = "Parameter input error."
        default:
            bpErrorMessage = "Unknown error"
        }
        return bpErrorMessage
    }
}
