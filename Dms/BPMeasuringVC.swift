//
//  BPMeasuring.swift
//  FTN
//
//  Created by Marko Stajic on 12/13/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

final class BPMeasuringVC: CommonVC, StoryboardInitializable {

    var bpDeviceInstance : BP7!
    var bloodPressureReading : BloodPressureReading!
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet var borderLine: UIView!
    @IBOutlet weak var iconHeart: UIImageView!
    @IBOutlet weak var iconHeartView: UIView!
    @IBOutlet weak var circleTimerView: CircleTimer!
    
    var timer : Timer?
    
    var waveImageView1 : UIImageView!
    var waveImageView2 : UIImageView!

    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView : UIVisualEffectView!
    
    var stopImage : UIImage!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var stopButton: CustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        removeNavigationBackButton()
        updateViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViews(){
        
        borderLine.backgroundColor = UIColor.dmsCloudyBlue
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.main.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        iconHeartView.backgroundColor = UIColor.white
        iconHeartView.layer.borderWidth = 3.0
        iconHeartView.layer.borderColor = UIColor.dmsMetallicBlue.cgColor
        
        contView.backgroundColor = UIColor.white
        contView.layer.borderWidth = 3.0
        contView.layer.borderColor = UIColor.dmsPaleGrey.cgColor
        circleTimerView.startAngle = 86.0
        
        stopImage = #imageLiteral(resourceName: "measurementWaveFlatSpot")
        stopImage = resizeImage(image: stopImage, targetHeight: self.contView.frame.size.width)!

        waveImageView1 = UIImageView(image: stopImage)
        waveImageView2 = UIImageView(image: stopImage)
        
        waveImageView1.frame = CGRect(x: 0, y: self.contView.frame.size.height/2.0, width: self.contView.frame.size.width, height: self.contView.frame.size.height)
        waveImageView2.frame = CGRect(x: waveImageView1.frame.size.width , y: self.contView.frame.size.height/2.0, width: self.contView.frame.size.width, height: self.contView.frame.height)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startMeasuring()
    }
    
    func startMeasuring(){
        if let bpDevice = bpDeviceInstance{
            
            startTimerAnimation()
            startPulseAnimation()
            flatHeartWave()
            _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(animateHeartWave), userInfo: nil, repeats: false)
            
            
//            UIView.animate(withDuration: 50.0, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
//
//                
//                DispatchQueue.main.async {
//                    print("Graph image view width: \(self.graphImageView.frame.size.width)")
//                    print("Scroll view width: \(self.graphImageView.frame.size.width)")
//
//                }
//                
//                self.scrollView.setContentOffset(CGPoint(x: self.graphImageView.frame.size.width - self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y), animated: false)
//                
//            }, completion: nil)

            bpDevice.commandStartMeasure({ (press: [Any]?) in
            }, xiaoboWithHeart: { (heart: [Any]?) in
            }, xiaoboNoHeart: { (noHeart: [Any]?) in
            }, result: { (res: [AnyHashable : Any]?) in
                
                print("Result: \(res)")
                
                if let result = res, let sys = result["sys"] as? UInt, let dia = result["dia"] as? UInt, let heartRate = result["heartRate"] as? UInt {
                    
                    DispatchQueue.main.async {
                        self.bloodPressureReading = BloodPressureReading(systolic: sys, diastolic: dia, heartRate: heartRate, time: nil)
                        
                        print(sys)
                        print(dia)
                        print(heartRate)
                        
                        self.iconHeart.layer.removeAllAnimations()
                        self.stopHeartWaveAnimation()
                        self.viewResult()
                    }
                }
                
            }) { (error) in
                print("Error measure: \(BPDeviceError(rawValue: error.rawValue))")
                self.handleError(error: error)
                
            }
        }
    }
    
    func viewResult(){
        UserDefaultsHelper.firstMeasureDone()
        AppCoordinator.shared.showBPResultViewController(bloodPressureReading: self.bloodPressureReading)
    }
    
    override func viewDidLayoutSubviews() {
        iconHeartView.layer.cornerRadius = iconHeartView.frame.width/2
        contView.layer.cornerRadius = contView.frame.width/2
    }
    @IBAction func stopBloodPressureMeasure(_ sender: UIButton) {
        showStopMeasureDialog()
    }
    
    func stopBPMeasure() {
        if let bpDevice = bpDeviceInstance {
            bpDevice.stopBPMeassureErrorBlock({
                
                print("BP Device stopped")
                DispatchQueue.main.async {
                    self.iconHeart.layer.removeAllAnimations()
                    self.stopHeartWaveAnimation()
                    self.timer?.invalidate()
                    self.circleTimerView.startAngle = 90
                    self.circleTimerView.setNeedsDisplay()
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
                
            }, errorBlock: { (error) in
                
                self.hideInfo(force: true)
                self.handleError(error: error)

            })
        }
    }
    
    func showStopMeasureDialog(){
        let stopMeasureDialog = StopMeasureVC()
        stopMeasureDialog.delegate = self
        self.view.addSubview(blurEffectView)
        self.present(stopMeasureDialog, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: false)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.dmsLightNavy, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        self.title = "Measuring Blood Pressure"
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: false)
        
        blurEffectView.removeFromSuperview()
        
        stopButton.updateEnabledButtonColors(backgroundColor: UIColor.white, titleColor: UIColor.dmsTomato, highlightedColor: UIColor.dmsHighlightedWhite)
        stopButton.setEnabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    func startTimerAnimation(){
        timer = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(BPMeasuringVC.animateBorder), userInfo: nil, repeats: true)
    }
    
    func animateBorder(){
        if circleTimerView.startAngle > -266 {
//            circleTimerView.startAngle = 90
            
            circleTimerView.startAngle -= 0.25
            circleTimerView.setNeedsDisplay()

        }else{
            timer?.invalidate()
        }
        
    }
    
    func startPulseAnimation(){
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.8
        pulseAnimation.toValue = NSNumber(value: 1.20)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        self.iconHeart.layer.add(pulseAnimation, forKey: nil)
    }
    
    func flatHeartWave(){

        waveImageView1.frame = CGRect(x: 0, y: self.contView.frame.size.height/2.0, width: self.contView.frame.size.width, height: self.contView.frame.size.height)
        waveImageView2.frame = CGRect(x: waveImageView1.frame.size.width , y: self.contView.frame.size.height/2.0, width: self.contView.frame.size.width, height: self.contView.frame.height)
        
        self.contView.addSubview(waveImageView1)
        self.contView.addSubview(waveImageView2)
        
        waveImageView1.image = stopImage
        waveImageView2.image = stopImage

    }
    
    func stopHeartWaveAnimation(){
        waveImageView1.layer.removeAllAnimations()
        waveImageView2.layer.removeAllAnimations()
        
        waveImageView1.frame = CGRect(x: 0, y: self.contView.frame.size.height/2.0, width: self.contView.frame.size.width, height: self.contView.frame.size.height)
        waveImageView2.frame = CGRect(x: waveImageView1.frame.size.width , y: self.contView.frame.size.height/2.0, width: self.contView.frame.size.width, height: self.contView.frame.height)
        
        waveImageView1.image = stopImage
        waveImageView2.image = stopImage
    }
    
    func animateHeartWave() {
        let animationOptions : UIViewAnimationOptions = [ UIViewAnimationOptions.repeat, UIViewAnimationOptions.curveLinear ]
        var waveImage = #imageLiteral(resourceName: "measurementWave")
        
        
        waveImage = resizeImage(image: waveImage, targetHeight: self.contView.frame.size.height)!
        
        // UIImageView 1
        waveImageView1.image = waveImage
        waveImageView1.frame = CGRect(x: 0, y: self.contView.frame.size.height/3.0, width: waveImage.size.width, height: self.contView.frame.size.height)
        
        // UIImageView 2
        waveImageView2.image = waveImage
        waveImageView2.frame = CGRect(x: waveImageView1.frame.size.width-1.5, y: self.contView.frame.size.height/3.0, width: waveImage.size.width, height: self.contView.frame.height)
        
        
        //         Animate background
        UIView.animate(withDuration: 8.0, delay: 0.0, options: animationOptions, animations: {
            self.waveImageView1.frame = self.waveImageView1.frame.offsetBy(dx: -1 * self.waveImageView1.frame.size.width, dy: 0.0)
            self.waveImageView2.frame = self.waveImageView2.frame.offsetBy(dx: -1 * self.waveImageView2.frame.size.width, dy: 0.0)
        }, completion: nil)
    }
    
    func stopMeasuring(errorString: String){
        print("• Error handled: \(errorString)")
//        self.showError(errorMessage: errorString)
        self.stopHeartWaveAnimation()
        self.iconHeart.layer.removeAllAnimations()
        timer?.invalidate()
        self.circleTimerView.startAngle = 90
        self.circleTimerView.setNeedsDisplay()
        
        showErrorVC(error: errorString)
        
    }
    
    func showErrorVC(error: String){
        let errorDialog = ErrorVC()
        errorDialog.error = error
        errorDialog.delegate = self
        self.view.addSubview(blurEffectView)
        self.present(errorDialog, animated: true, completion: nil)
    }
    
    func showError(errorString: String){
        print("• Error handled: \(errorString)")
        //TODO: self.showError(errorMessage: errorString)
    }
    
    func handleError(error: BPDeviceError){
        switch error {
        case BPError0: stopMeasuring(errorString: "Unable to take measurements due to arm/wrist movements.")
        case BPError1: stopMeasuring(errorString: "Failed to detect systolic pressure")
        case BPError2: stopMeasuring(errorString: "Failed to detect diastolic pressure")
        case BPError3: stopMeasuring(errorString: "Pneumatic system blocked or cuff is too tight")
        case BPError4: stopMeasuring(errorString: "Pneumatic system leakage or cuff is too loose")
        case BPError5: stopMeasuring(errorString: "Cuff pressure reached over 300mmHg")
        case BPError6: stopMeasuring(errorString: "Cuff pressure reached over 15 mmHg for more than 160 seconds")
        case BPError7: stopMeasuring(errorString: "Data retrieving error")
        case BPError8: stopMeasuring(errorString: "Data retrieving error")
        case BPError9: stopMeasuring(errorString: "Data retrieving error")
        case BPError10: stopMeasuring(errorString: "Data retrieving error")
        case BPError11: stopMeasuring(errorString: "Communication Error")
        case BPError12: stopMeasuring(errorString: "Communication Error")
        case BPError13: stopMeasuring(errorString: "Low battery")
        case BPError14: stopMeasuring(errorString: "Device bluetooth set failed")
        case BPError15: stopMeasuring(errorString: "Systolic exceeds 260mmHg or diastolic exceeds 199mmHg")
        case BPError16: stopMeasuring(errorString: "Systolic below 60mmHg or diastolic below 40mmHg")
        case BPError17: stopMeasuring(errorString: "Arm/wrist movement beyond range")
        case BPNormalError: stopMeasuring(errorString: "device error, error message displayed automatically")
        case BPOverTimeError: showError(errorString: "Abnormal communication")
        case BPNoRespondError: showError(errorString: "Abnormal communication")
        case BPBeyondRangeError: stopMeasuring(errorString: "Device is out of communication range.")
        case BPDidDisconnect: stopMeasuring(errorString: "Device is disconnected.")
        case BPAskToStopMeasure: stopMeasuring(errorString: "Measurement has been stopped.")
        case BPInputParameterError: stopMeasuring(errorString: "Parameter input error.")
        default:
            return stopMeasuring(errorString: "Unknown error")
        }
    }
    
    
}

extension BPMeasuringVC : ErrorDelegate {
    func cancelError() {
        blurEffectView.removeFromSuperview()
    }
    func restartMeasuring() {
        blurEffectView.removeFromSuperview()
        _ = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector:  #selector(restartMeasure), userInfo: nil, repeats: false)
    }
    func restartMeasure(){
        if UserDefaults.standard.bool(forKey: UserDefaultsStrings.bloodPressureDeviceSet) {
            self.popNViewControllersBack(nViewControllers: 1)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension BPMeasuringVC : StopMeasureDelegate {
    
    func cancelStopping() {
        blurEffectView.removeFromSuperview()
    }
    func stopMeasuring() {
        blurEffectView.removeFromSuperview()
        stopBPMeasure()
    }
    
}
