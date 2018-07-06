//
//  BPSetupOneVCViewController.swift
//  FTN
//
//  Created by Marko Stajic on 3/15/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

final class BPSetupOneVC: CommonVC, StoryboardInitializable {

    @IBOutlet weak var nextButton: CustomButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHomeBackButtonWhite()
        updateViews()
        
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeWhite"), style: .plain, target: self, action: #selector(dismissViewController))
        homeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = homeButton
    }
    
    override func addHomeBackButtonWhite() {
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeWhite"), style: .plain, target: self, action: #selector(dismissViewController))
        homeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = homeButton
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViews(){
        
        (UIApplication.shared.delegate as! AppDelegate).setStatusBarColor(light: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.dmsLightNavy
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: Font.GothamMedium, size: 17)!]
        self.addTwoLineNavigationTitle(title: "Device Setup", subtitle: "Blood Pressure Monitor")
        self.view.backgroundColor = UIColor.white
        nextButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        nextButton.setEnabled = true
    }
}
