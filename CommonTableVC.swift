//
//  CommonTableVC.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import UIKit

class CommonTableVC: UITableViewController, UIGestureRecognizerDelegate {
    
    //    let reloadIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let loaderIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    let errorMessageView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    
    var heightViewConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = UIColor.dmsOffBlue
        containerView.alpha = 0.80
        containerView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        containerView.layer.cornerRadius = 50
        loaderIndicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        updateErrorView()
        
        // Do any additional setup after loading the view.
    }
    
    func startLoading(){
        self.view.addSubview(containerView)
        self.view.addSubview(loaderIndicator)
        loaderIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    func stopLoading(){
        loaderIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        loaderIndicator.removeFromSuperview()
        containerView.removeFromSuperview()
        
    }
    
    func updateErrorView(){
        errorMessageView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageView.addSubview(errorLabel)
        errorMessageView.backgroundColor = UIColor.dmsTomato
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont(name: Font.GothamMedium, size: 12)
        errorLabel.text = "Offline"
        view.addSubview(errorMessageView)
        updateErrorMessageConstraints()
        
    }
    func showError(errorMessage: String){
        self.errorLabel.text = errorMessage
        self.heightViewConstraint.constant = 32
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (Bool) in
            self.heightViewConstraint.constant = 0
            UIView.animate(withDuration: 0.5, delay: 2.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    fileprivate func updateErrorMessageConstraints() {
        
        // Error view constraints
        let leadingViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.tableView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.view.addConstraint(leadingViewConstraint)
        
        let topViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.view.addConstraint(topViewConstraint)
        
        let widthViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width)
        self.view.addConstraint(widthViewConstraint)

        heightViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
        self.view.addConstraint(heightViewConstraint)
        
        //         Error label constraints
        let leadingLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 15)
        self.view.addConstraint(leadingLabelConstraint)
        
        let trailingLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -15)
        self.view.addConstraint(trailingLabelConstraint)
        
        let topLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 9)
        topLabelConstraint.priority = 990
        self.view.addConstraint(topLabelConstraint)
        
        let bottomLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -9)
        self.view.addConstraint(bottomLabelConstraint)
        
    }

    @IBAction func start(_ sender: Any) {
        self.showError(errorMessage: "Error")
    }

    
    func addNavigationBackButton(){
        
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"), style: .plain, target: self, action: #selector(CommonVC.back))
        newBackButton.tintColor = UIColor.dmsMetallicBlue
        self.navigationItem.leftBarButtonItem = newBackButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    func back(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //    func addRefreshItem(){
    //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(CommonVC.refreshAction))
    //    }
    //
    //    func refreshAction(){
    //        reloadIndicator.hidesWhenStopped = true
    //        reloadIndicator.startAnimating()
    //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reloadIndicator)
    //    }
    
    
}
