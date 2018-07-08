//
//  ViewController.swift
//  FTN
//
//  Created by Marko Stajic on 11/7/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit
import LocalAuthentication

final class HomeViewController: CommonVC, StoryboardInitializable {

    @IBOutlet weak var returningUserButton: CustomButton!
    @IBOutlet weak var createAccountButton: CustomButton!
    @IBOutlet weak var logoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoLabel.font = UIFont(name: Font.GothamMedium, size: 48)
        logoLabel.text = "HeartLog"
        
        updateViews()
    }
    
    @IBAction func signIn(_ sender: CustomButton) {
        authenticateUser()
    }
    
    func authenticateUser() {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please identify yourself"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.startLoading()
                        (UIApplication.shared.delegate as! AppDelegate).fillCoreData()
                    } else if let authenticationError = authenticationError as? LAError {
                        
                        print("Auth error: \(authenticationError.localizedDescription)")
                        
                        if Int32(authenticationError.code.rawValue) != kLAErrorUserCancel && Int32(authenticationError.code.rawValue) != kLAErrorUserFallback && Int32(authenticationError.code.rawValue) != kLAErrorSystemCancel {
                            let ac = UIAlertController(title: "Authentification failed!", message: authenticationError.localizedDescription, preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(ac, animated: true)
                        }
                        
                    } else {
                        let ac = UIAlertController(title: "Error", message: "Authentification failed!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Error", message:  error?.localizedDescription ?? "TouchId not available!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: true)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFinished), name: NSNotification.Name(rawValue: NotificationNames.fetchFinished), object: nil)

    }
    
    func fetchFinished() {
        self.stopLoading()
        AppCoordinator.shared.setBloodPressureListAsRoot()
    }
    
    func setNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func updateViews(){
            
        self.view.backgroundColor = UIColor.dmsLightNavy

        returningUserButton.updateEnabledButtonColors(backgroundColor: UIColor.white, titleColor: UIColor.dmsOffBlue, highlightedColor: UIColor.dmsHighlightedWhite)
        createAccountButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)

        returningUserButton.setEnabled = true
        createAccountButton.setEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func register(_ sender: CustomButton) {
        DialogUtils.showWarningDialog(self, title: "Sorry, this feature has not been implemented yet", message: nil, completion: nil)
    }
}

