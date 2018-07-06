//
//  RegistrationStartVC.swift
//  FTN
//
//  Created by Marko Stajic on 11/8/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class RegistrationStartVC: CommonVC {

    @IBOutlet weak var welcomeMessage: TitleLabel!
    @IBOutlet weak var motivationalMessage: TitleLabel!
    @IBOutlet weak var startRegistrationButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        addNavigationBackButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.barStyle = .blackOpaque
//        setNavigation()
        
        UIApplication.shared.statusBarStyle = .default
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: false)
    }
    
    func setNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func updateViews(){
        
        welcomeMessage.updateFont(fontName: Font.GothamBook, size: 24)
        motivationalMessage.updateFont(fontName: Font.GothamBook, size: 17)
        
        startRegistrationButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        startRegistrationButton.setEnabled = true
        
        welcomeMessage.updateTextColor(color: UIColor.dmsLightNavy)
        motivationalMessage.updateTextColor(color: UIColor.dmsLightNavy)

    }
}
