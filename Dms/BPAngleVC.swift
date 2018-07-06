//
//  BPAngleVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/13/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit
import CoreBluetooth

final class BPAngleVC: CommonVC, StoryboardInitializable {

    @IBOutlet weak var btConnectView: UIView!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var circleTimerView: CircleTimer!
    
    @IBOutlet weak var btImage01: UIImageView!
    @IBOutlet weak var btImage02: UIImageView!
    @IBOutlet weak var btImage03: UIImageView!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var btErrorImage: UIImageView!
    @IBOutlet weak var btErrorLabel: BTErrorLabel!
    
    @IBOutlet weak var handAngleImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var bpDeviceInstance : BP7?
    var bpController = BP7Controller.share()
    var connectDeviceController = ConnectDeviceController.commandGetInstance()
    var measureStarted = false
    var defaults = UserDefaults.standard
    var managerBLE : CBCentralManager?
    var circleTimer : Timer?
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        addHomeBackButtonWhite()
        addTwoLineNavigationTitle(title: "Take a reading", subtitle: "Blood Pressure Monitor")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: false)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        measureStarted = false
        startAnimation()
        tryToConnectBPDevice()
        addNotificationObservers()
        startScanningForBPDevices()
        
        self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        circleTimer?.invalidate()
        removeNotificationObservers()
        stopScanningForBPDevices()

        if measureStarted == false {
            
            if let bpDevice = bpDeviceInstance{
                bpDevice.stopBPMeassureErrorBlock({
                    print("BP Device stopped")
                    
                }, errorBlock: { (error) in
                    
                    self.hideInfo(force: true)
                    self.handleError(error: error)
                })
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(BPAngleVC.deviceDiscovered(info:)), name: NSNotification.Name(rawValue: BP7ConnectNoti), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BPAngleVC.deviceDisconnected(info:)), name: NSNotification.Name(rawValue: BP7DisConnectNoti), object: nil)
    }
    override func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BP7ConnectNoti), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BP7DisConnectNoti), object: nil)
    }
    
    func updateViews(){
        nextButton.isEnabled = false
        contView.backgroundColor = UIColor.white
        contView.layer.borderWidth = 3.0
        contView.layer.borderColor = UIColor.dmsPaleGrey.cgColor
        contView.layer.cornerRadius = 140
        circleTimerView.layer.cornerRadius = 140
    }
    override func dismissModalController() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iHealthAuthenticationTimedOut(){
//        self.showErrorAndBackToRoot(errorMessage: "Can't connect to iHealth. Please try later.")
    }

    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startGettingAngle(){
        if let bpDevice = bpDeviceInstance {
            
//            self.showInfo(infoMessage: "Please wait for user authentication")
            bpDevice.commandEnergy({ (batteryLevel: NSNumber?) in
                
                if let batteryLevel = batteryLevel as? Int {
                    print("BP7 Energy level: \(batteryLevel)")
                    UserDefaults.standard.setValue(batteryLevel, forKey: UserDefaultsStrings.bloodPressureBatteryLevel)
                }
                
            }, errorBlock: { (error) in
                print("BP7 Energy level error: \(error)")
            })
            
            let authTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(iHealthAuthenticationTimedOut), userInfo: nil, repeats: false)
            //            self.hideInfo(withDelay: 1.5, force: false)
            bpDevice.commandStartGetAngle(withUser: iHealthCredentials.userId, clientID: iHealthCredentials.clientId, clientSecret: iHealthCredentials.clientSecret, authentication: { (UserAuthenResult) in
                
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
//                    self.showInfo(infoMessage: "Please put your hand in the propper position")
                case UserAuthen_InvalidateUserInfo, UserAuthen_SDKInvalidateRight, UserAuthen_UserInvalidateRight, UserAuthen_InternetError:
//                    self.showErrorAndBackToRoot(errorMessage: "Authentication failed. Please try again later.")
                    break
                default:
                    break
//                    self.showErrorAndBackToRoot(errorMessage: "Authentication failed. Please try again later.")
                }
                
            }, angle: { (dict: [AnyHashable : Any]?) in
                
                DispatchQueue.main.async {
                    //                    self.showInfo(infoMessage: "Searching for right angle")
                }
                
                let angDig = dict?["angle"] as! Int
                
                if angDig > 10 && angDig < 30 {
                    
                    DispatchQueue.main.async {
                        self.handAngleImage.image = #imageLiteral(resourceName: "armAlignCorrectB")
                        if self.nextButton.isEnabled == false {
                            self.nextButton.isEnabled = true
                        }
                        //                        self.showInfo(infoMessage: "Angle is good to start measuring!")
                    }
                    
                    
                }else{
                    if angDig < 10 {
                        DispatchQueue.main.async {
                            self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign01Low")
                        }
                    } else if angDig > 30 && angDig < 40 {
                        DispatchQueue.main.async {
                            self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign03MidHigh")
                        }
                        
                    } else if angDig > 40 && angDig < 50 {
                        DispatchQueue.main.async {
                            self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign04High")
                        }
                        
                    } else if angDig > 50 {
                        DispatchQueue.main.async {
                            self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign05TooHigh")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if self.nextButton.isEnabled == true {
                            self.nextButton.isEnabled = false
                        }
                        //                        self.showInfo(infoMessage: "Searching for right angle...")
                    }
                }
                
            }, errorBlock: { (error) in
                self.hideInfo(force: true)
                self.handleError(error: error)
                
            })
        }
    }
    @IBAction func startMeasuring(_ sender: UIButton) {
        
        self.hideInfo()
        self.measureStarted = true
        AppCoordinator.shared.showBPMeasuringViewController(bpDeviceInstance: self.bpDeviceInstance)
    }
    
    func showError(errorString: String){
        print("• Error handled: \(errorString)")
//        TODO:
        self.showError(errorMessage: errorString)
    }
    func handleError(error: BPDeviceError){
        switch error {
        case BPError0: showError(errorString: "Unable to take measurements due to arm/wrist movements.")
        case BPError1: showError(errorString: "Failed to detect systolic pressure")
        case BPError2: showError(errorString: "Failed to detect diastolic pressure")
        case BPError3: showError(errorString: "Pneumatic system blocked or cuff is too tight")
        case BPError4: showError(errorString: "Pneumatic system leakage or cuff is too loose")
        case BPError5: showError(errorString: "Cuff pressure reached over 300mmHg")
        case BPError6: showError(errorString: "Cuff pressure reached over 15 mmHg for more than 160 seconds")
        case BPError7: showError(errorString: "Data retrieving error")
        case BPError8: showError(errorString: "Data retrieving error")
        case BPError9: showError(errorString: "Data retrieving error")
        case BPError10: showError(errorString: "Data retrieving error")
        case BPError11: showError(errorString: "Communication Error")
        case BPError12: showError(errorString: "Communication Error")
        case BPError13: showError(errorString: "Low battery")
        case BPError14: showError(errorString: "Device bluetooth set failed")
        case BPError15: showError(errorString: "Systolic exceeds 260mmHg or diastolic exceeds 199mmHg")
        case BPError16: showError(errorString: "Systolic below 60mmHg or diastolic below 40mmHg")
        case BPError17: showError(errorString: "Arm/wrist movement beyond range")
        case BPNormalError: showError(errorString: "device error, error message displayed automatically")
        case BPOverTimeError: showError(errorString: "Abnormal communication")
        case BPNoRespondError: showError(errorString: "Abnormal communication")
        case BPBeyondRangeError: showError(errorString: "Device is out of communication range.")
        case BPDidDisconnect: showError(errorString: "Device is disconnected.")
        case BPAskToStopMeasure: showError(errorString: "Measurement has been stopped.")
        case BPInputParameterError: showError(errorString: "Parameter input error.")
        default:
            return showError(errorString: "Unknown error")
        }
        nextButton.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backToRoot), userInfo: nil, repeats: false)
    }
}

extension BPAngleVC {
    func tryToConnectBPDevice(){
//        self.showInfo(infoMessage: "Trying to connect to device")
        if let bpDevices = bpController?.getAllCurrentBP7Instace() as? [BP7] {
            if bpDevices.count != 0 {
                bpDeviceInstance = bpDevices.first
                stopScanningForBPDevices()
//                startGettingAngle()
                finishAnimation()
            }else{
                //TODO: Print something
            }
        }else{
            //TODO: Print something
        }
    }
    func bpDeviceConnected(){
//        self.showInfo(infoMessage: "Trying to connect to device")
        if let bpDevices = bpController?.getAllCurrentBP7Instace() as? [BP7] {
            if bpDevices.count != 0 {
                stopScanningForBPDevices()
                bpDeviceInstance = bpDevices.first
//                startGettingAngle()
                finishAnimation()

            }else{
                //TODO: Print something
            }
        }else{
            //TODO: Print something
        }
    }
    func deviceDiscovered(info: Notification){
        
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
    func deviceDisconnected(info: Notification){
        print("BP7 Device Disconnected")
    }
    func startScanningForBPDevices() {
//        self.showInfo(infoMessage: "Please turn your device on and connect to bluetooth")
        ScanDeviceController.commandGetInstance().commandScanDeviceType(HealthDeviceType_BP7S)
    }
    func stopScanningForBPDevices(){
//        self.showInfo(infoMessage: "Stopped searching for device")
        ScanDeviceController.commandGetInstance().commandStopScanDeviceType(HealthDeviceType_BP7S)
    }
}

extension BPAngleVC {
    func startAnimation(){
        circleTimerView.startAngle = 90
        startCircleAnimation()
        animateImage()
    }
    func startCircleAnimation(){
        circleTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(BPMeasuringVC.animateBorder), userInfo: nil, repeats: true)
    }
    func animateBorder(){
        if circleTimerView.startAngle > -270 {
            //            circleTimerView.startAngle = 90
            
            circleTimerView.startAngle -= 0.25
            circleTimerView.setNeedsDisplay()
            
        }else{
            circleTimer?.invalidate()
            self.deviceNeverConnected()
        }
        
    }
    func animateImage(){
        
        let beginTime = CACurrentMediaTime()
        let myDelay = 0.2
        
        let alphaAnimation01: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation01.beginTime = beginTime
        alphaAnimation01.duration = 0.4
        alphaAnimation01.toValue = 0
        alphaAnimation01.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        alphaAnimation01.autoreverses = true
        alphaAnimation01.repeatCount = FLT_MAX
        
        let alphaAnimation02: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation02.beginTime = beginTime + myDelay
        alphaAnimation02.duration = 0.4
        alphaAnimation02.toValue = 0
        alphaAnimation02.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        alphaAnimation02.autoreverses = true
        alphaAnimation02.repeatCount = FLT_MAX
        
        self.btImage02.layer.add(alphaAnimation01, forKey: nil)
        self.btImage03.layer.add(alphaAnimation02, forKey: nil)
    }
    func finishAnimation(){
        
        circleTimer?.invalidate()
//        self.showInfoWithHide(infoMessage: "Device connected")
        btImage01.isHidden = true
        btImage02.isHidden = true
        btImage03.isHidden = true
        
        circleTimerView.startAngle = -270
        circleTimerView.setNeedsDisplay()
        checkmarkImage.isHidden = false

        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(deviceConnected), userInfo: nil, repeats: false)
    }
    func deviceConnected(){
        defaults.set(true, forKey: UserDefaultsStrings.bloodPressureDeviceSet)
        self.btConnectView.isHidden = true
        startGettingAngle()

    }
    func deviceNeverConnected(){
        self.btImage02.layer.removeAllAnimations()
        self.btImage03.layer.removeAllAnimations()
        
        circleTimerView.isHidden = true
        contView.isHidden = true
        btImage01.isHidden = true
        btImage02.isHidden = true
        btImage03.isHidden = true
        checkmarkImage.isHidden = true
        
        btErrorLabel.isHidden = false
        btErrorImage.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backToRoot), userInfo: nil, repeats: false)
        
        //        let noDeviceAlert = UIAlertController(title: "Device not connected", message: "Make sure that your device is turned on and connected in Bluetooth settings on your iPhone. If this is reccuring problem, try to 'forget' device in settings and then connect to it again.", preferredStyle: UIAlertControllerStyle.alert)
        //        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
        //            _ = self.navigationController?.popToRootViewController(animated: true)
        //        }
        //        noDeviceAlert.addAction(okAction)
        //        self.present(noDeviceAlert, animated: true, completion: nil)
    }
    func backToRoot(){
        timer?.invalidate()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

extension BPAngleVC : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state
        {
        case .poweredOff:
            print("Powered Off")
            self.showError(errorMessage: "Please turn bluetooth on and try again")
            self.deviceNeverConnected()
        case .poweredOn:
            print("Powered On")
        case .unsupported:
            print("Unsupported")
        case .resetting:
            print("Resetting")
            fallthrough
        case .unauthorized:
            print("Unauthorized")
        case .unknown:
            print("Unknown")
        }
    }
}
