//
//  LoginVC.swift
//  FTN
//
//  Created by Marko Stajic on 11/14/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class LoginVC: CommonVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signInButton: CustomButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var loginSuccessfulView : LoginSuccessfulView!
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        addNavigationBackButton()
        setLoginView()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func setLoginView(){
        loginSuccessfulView = LoginSuccessfulView()
        loginSuccessfulView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginSuccessfulView)
        setExpandingConstraints(viewToExpand: loginSuccessfulView)
        //TODO:
        loginSuccessfulView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    func updateViews(){
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 169
        tableView.separatorStyle = .none
        
        signInButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        signInButton.setEnabled = true //false //true
    }
    func goToMainMenu(){
        timer.invalidate()
        AppCoordinator.shared.setBloodPressureListAsRoot()
    }
    
    func signInAction(){
        
        self.dismissKeyboard()
        self.removeNavigationBackButton()
        self.loginSuccessfulView.isHidden = false
        self.loginSuccessfulView.startAnimation()
        //                            self.expandingCircleAnimation(viewToAnimate: self.loginSuccessfulView, duration: 0.8)
        
        //Heap
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(LoginVC.goToMainMenu), userInfo: nil, repeats: false)
    }

    @IBAction func signIn(_ sender: Any) {
        signInAction()
    }
}

extension LoginVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        return defaultCell
    }
}

extension LoginVC {
    
    func keyboardWillShow(_ notification: Notification){
        
        if let userInfo = (notification as NSNotification).userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if let endFrame = endFrame{
                self.bottomConstraint.constant = endFrame.size.height
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func keyboardWillHide(_ notification: Notification){
        if let userInfo = (notification as NSNotification).userInfo {
            _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            self.bottomConstraint.constant = 0
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}



