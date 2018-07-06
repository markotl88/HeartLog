//
//  BPSetupTwoVC.swift
//  FTN
//
//  Created by Marko Stajic on 3/16/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import UIKit

class BPSetupTwoVC: CommonVC {

    @IBOutlet weak var nextButton: CustomButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHomeBackButtonWhite()
        updateViews()
    }

    override func addHomeBackButtonWhite() {
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeWhite"), style: .plain, target: self, action: #selector(dismissViewController))
        homeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = homeButton
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews(){
        self.addTwoLineNavigationTitle(title: "Device Setup", subtitle: "Blood Pressure Monitor")
        self.view.backgroundColor = UIColor.white
        nextButton.updateEnabledButtonColors(backgroundColor: UIColor.dmsOffBlue, titleColor: UIColor.white)
        nextButton.setEnabled = true
    }
    @IBAction func continueWithMeasuring(_ sender: CustomButton) {
        AppCoordinator.shared.showAutomaticBPMeasureAfterTipsViewController()
    }
    
}
