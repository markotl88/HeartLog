//
//  BloodPressureStartVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/12/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit
import CoreBluetooth

final class BloodPressureStartVC: CommonVC, CBCentralManagerDelegate, StoryboardInitializable {

    @IBOutlet weak var buttonViewContainer: UIView!
    @IBOutlet weak var startLabel: TitleLabel!
    @IBOutlet weak var startButton: CustomButton!
    @IBOutlet weak var manualEntryLabel: TitleLabel!
    @IBOutlet weak var manualButton: CustomImageButton!
    @IBOutlet weak var historyButton: UIBarButtonItem!
    
    var managerBLE : CBCentralManager?
    var bluetoothOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
        updateViews()
//        addNavigationBackButton()
        addHomeBackButtonWhite()
        addTwoLineNavigationTitle(title: "Take a reading", subtitle: "Blood Pressure Monitor")
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(BloodPressureStartVC.goToHistory), name: NSNotification.Name(rawValue: NotificationNames.goToBloodPressureHistory), object: nil)
    }
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            bluetoothOn = true
        }else if central.state == .poweredOff {
            bluetoothOn = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: false)
        
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToManualEntry" {
            if let navVC = segue.destination as? UINavigationController {
                if let destVC = navVC.topViewController as? BPManualEntryVC {
                    destVC.delegate = self
                }
            }
        }
    }
    
    public func goToBloodPressureMeasuring(){
        if UserDefaultsHelper.isFirstMeasuringDone() {
            AppCoordinator.shared.showAutomaticBPMeasureViewController(viewController: self)
        } else {
            AppCoordinator.shared.showTipsForBPMeasuring(viewController: self)
        }
    }
    @IBAction func goToBloodPressureHistory(_ sender: UIBarButtonItem) {
        goToHistory()
    }
    
    func goToHistory(){
        self.dismiss(animated: true, completion: nil)
    }

    func updateViews(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        buttonViewContainer.layer.cornerRadius = buttonViewContainer.frame.size.width/2
        startLabel.updateFontSize(size: 24.0)
        startButton.layer.cornerRadius = startButton.frame.size.width/2
        manualEntryLabel.updateFontSize(size: 17)
        manualEntryLabel.updateTextColor(color: UIColor.dmsOffBlue)
        
        startButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        historyButton.tintColor = UIColor.white

        
    }
    @IBAction func manualEntryInput(_ sender: Any) {
        print("Manual")
        self.performSegue(withIdentifier: "goToManualEntry", sender: self)
    }
    
    @IBAction func startBloodPressureMeasuring(_ sender: CustomButton) {
        if bluetoothOn {
            goToBloodPressureMeasuring()
        }else{
            showBluetoothAlert()
        }
    }
    
    func showBluetoothAlert(){
        self.managerBLE = nil
        self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
}

extension BloodPressureStartVC : ShowHistoryDelegate {
    func showHistory() {
        self.performSegue(withIdentifier: "goToBPHistory", sender: self)
    }
}

extension BloodPressureStartVC : BPHistoryDelegate {
    func viewControllerPushed() {
        if let bpAngleVC = UIStoryboard(name: "BloodPressure", bundle: nil).instantiateViewController(withIdentifier: "bpAngleVC") as? BPAngleVC {
            self.navigationController?.pushViewController(bpAngleVC, animated: false)
        }
    }
}


