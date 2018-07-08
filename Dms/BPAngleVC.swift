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
    
    var managerBLE : CBCentralManager?
    
    var measureStarted = false
    var defaults = UserDefaults.standard
    var circleTimer : Timer?
    var timer : Timer?
    
    lazy var bpMonitorController = BPMonitorController(clientId: iHealthCredentials.clientId, clientSecret: iHealthCredentials.clientSecret, userId: iHealthCredentials.userId)
    
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
        
        bpMonitorController.delegate = self
        bpMonitorController.startConnection()
        
        self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        circleTimer?.invalidate()
        removeNotificationObservers()
        
        if measureStarted == false {
            bpMonitorController.stopConnection()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateAngle(angDig: Int) {
        if angDig > 10 && angDig < 30 {
            self.handAngleImage.image = #imageLiteral(resourceName: "armAlignCorrectB")
            if self.nextButton.isEnabled == false {
                self.nextButton.isEnabled = true
            }
            
        }else{
            if angDig < 10 {
                self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign01Low")
            } else if angDig > 30 && angDig < 40 {
                self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign03MidHigh")
                
            } else if angDig > 40 && angDig < 50 {
                self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign04High")
                
            } else if angDig > 50 {
                self.handAngleImage.image = #imageLiteral(resourceName: "dmsArmAlign05TooHigh")
            }
            if self.nextButton.isEnabled == true {
                self.nextButton.isEnabled = false
            }
        }
    }
    
    @IBAction func startMeasuring(_ sender: UIButton) {
        
        self.hideInfo()
        self.measureStarted = true
        AppCoordinator.shared.showBPMeasuringViewController(bpMonitorController: self.bpMonitorController)
    }
    
    func showError(errorString: String){
        
        self.hideInfo(withDelay: nil, force: true)
        self.showError(errorMessage: errorString)
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
        alphaAnimation01.repeatCount = .greatestFiniteMagnitude
        
        let alphaAnimation02: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation02.beginTime = beginTime + myDelay
        alphaAnimation02.duration = 0.4
        alphaAnimation02.toValue = 0
        alphaAnimation02.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        alphaAnimation02.autoreverses = true
        alphaAnimation02.repeatCount = .greatestFiniteMagnitude
        
        self.btImage02.layer.add(alphaAnimation01, forKey: nil)
        self.btImage03.layer.add(alphaAnimation02, forKey: nil)
    }
    func finishAnimation(){
        
        circleTimer?.invalidate()
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
        bpMonitorController.prepareForMeasure()
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
    }
    func backToRoot(){
        timer?.invalidate()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

extension BPAngleVC: BPMonitorControllerDelegate {
    func bpController(didSetState state: BPMonitorState, angle: Int?, errorMessage: String?, bloodPressureResult: BloodPressureReading?) {
        switch state {
        case .NotConnected:
            showError(errorString: errorMessage ?? "Unknown error")
        case .Connected:
            self.finishAnimation()
        case .GettingAngle:
            animateAngle(angDig: angle ?? 0)
        case .Disconnected:
            nextButton.isEnabled = false
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(backToRoot), userInfo: nil, repeats: false)
            showError(errorString: errorMessage ?? "Unknown error")
        default:
            break
        }
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
