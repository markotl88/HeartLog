 //
//  CommonVC.swift
//  Lilly
//
//  Created by Marko Stajic on 11/14/16.
//  Copyright © 2016 NSWD_. All rights reserved.
//

import UIKit
import Reachability

class CommonVC: UIViewController, UIGestureRecognizerDelegate {
    
    var noMoreReadings = false
    
    var nViewControllers = 1
    let toastMessageDuration = 2.5
    
    var heightViewConstraint : NSLayoutConstraint!
    var topViewConstraint : NSLayoutConstraint!
    
    var topLabelConstraint: NSLayoutConstraint!
    var bottomLabelConstraint: NSLayoutConstraint!
    
    static var errorMessageActive = false
    var deleteButton : UIBarButtonItem!
    var reach = Reachability.forInternetConnection()
    
    var errorMessageView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    var errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
    var errorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
    
    let loaderIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var syncingStarted = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard()
        CommonVC.errorMessageActive = false
    }
    
    let calendar = NSCalendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = UIColor.dmsOffBlue
        containerView.alpha = 0.80
        containerView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        containerView.layer.cornerRadius = 50
        loaderIndicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        updateErrorView()
    }
    
    func updateErrorView(){
        errorImageView.image = nil
        errorImageView.contentMode = .scaleAspectFit
        errorImageView.clipsToBounds = false
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageView.addSubview(self.errorLabel)
        errorMessageView.addSubview(self.errorImageView)
        errorMessageView.backgroundColor = UIColor.dmsTomato
        errorLabel.numberOfLines = 0
        errorLabel.textColor = UIColor.white
        errorLabel.font = UIFont(name: Font.GothamMedium, size: 14.0)
        view.addSubview(self.errorMessageView)
        updateErrorMessageConstraints()
        
    }
    
    func enableNavigationBarButtons(enable: Bool){
        self.navigationItem.leftBarButtonItem?.isEnabled = enable
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func startLoading(){
        
        guard let reachable = reach?.isReachable(), reachable == true else {
            self.showError(errorMessage: "Please check your internet connection")
            return
        }
        
        ActivityIndicator.sharedInstance.startIndicator(viewController: self)
    }
    func stopLoading(){
        ActivityIndicator.sharedInstance.stopIndicator(viewController: self)
//        ActivityIndicator.sharedInstance.stopIndicator(viewController: self)
//        loaderIndicator.stopAnimating()
//        loaderIndicator.removeFromSuperview()
//        containerView.removeFromSuperview()
    }

//    @IBAction func start(_ sender: Any) {
//        showError(errorMessage: "NEKI STRING")
//    }
//    
    func expandingCircleAnimation(viewToAnimate: UIView, duration: Double){
        // Define the initial point (and rectangle) from where the circle will start to expand
        let midPoint = CGPoint(x: viewToAnimate.frame.midX, y: viewToAnimate.frame.midY)
        let initialSize = CGSize(width: 1, height: 1)
        let initialRect = CGRect(origin: midPoint, size: initialSize)
        
        // Calculate how much should circle expand (final circle size)
        let a = viewToAnimate.frame.width/2
        let b = viewToAnimate.frame.height/2
        let c = sqrt(a*a + b*b)
        
        // Define initial and final sizes/positionas of circle
        let circleMaskPathInitial = UIBezierPath(ovalIn: initialRect)
        let circleMaskPathFinal = UIBezierPath(ovalIn: viewToAnimate.frame.insetBy(dx: -c, dy: -c))
        
        // Add mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        viewToAnimate.layer.mask = maskLayer
        
        // Animate with that mask
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = CFTimeInterval(duration)
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func popNViewControllersBack(nViewControllers: Int, animated: Bool = true){
        
        if self.navigationController != nil {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            _ = self.navigationController?.popToViewController(viewControllers[viewControllers.count - (nViewControllers+1)], animated: animated);
        }
    }
    
    func backN(){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        _ = self.navigationController?.popToViewController(viewControllers[viewControllers.count - (self.nViewControllers+1)], animated: true);
    }
    
    func addCustomNavigationBackButton(nViewControllers: Int){
        self.nViewControllers = nViewControllers
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"), style: .plain, target: self, action: #selector(CommonVC.backN))
        newBackButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = newBackButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

    }
    
    func addCustomNavigationHomeBackButton(nViewControllers: Int){
        self.nViewControllers = nViewControllers
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeWhite"), style: .plain, target: self, action: #selector(CommonVC.backN))
        newBackButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = newBackButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    func disableGestureBack(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    func enableGestureBack(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func addDeleteButton(tintColor: UIColor = UIColor.white){
        
        let deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "iconTrash"), style: .plain, target: self, action: #selector(CommonVC.deleteReading))
        deleteButton.tintColor = tintColor
        self.navigationItem.rightBarButtonItem = deleteButton
        
    }
    
    func deleteReading(){
        
    }
    
    func addTwoLineNavigationTitle(title: String, subtitle: String?, navTextColor: UIColor = UIColor.white){
        let customNavTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 154, height: 44))
        let navTitleLabel = UserAttributeLabel(frame: CGRect(x: 0, y: 4, width: 154, height: 18))
        let navSubtitleLabel = UserAttributeLabel(frame: CGRect(x: 0, y: 22, width: 154, height: 18))
        
        navTitleLabel.backgroundColor = UIColor.clear
        navTitleLabel.updateTextColor(color: navTextColor)
        navSubtitleLabel.backgroundColor = UIColor.clear
        navSubtitleLabel.updateTextColor(color: navTextColor)
        navSubtitleLabel.updateFont(size: 11.0)
        navTitleLabel.textAlignment = NSTextAlignment.center
        navSubtitleLabel.textAlignment = NSTextAlignment.center
        
        navTitleLabel.adjustsFontSizeToFitWidth = true
        navSubtitleLabel.adjustsFontSizeToFitWidth = true
        navTitleLabel.minimumScaleFactor = 0.5
        navSubtitleLabel.minimumScaleFactor = 0.5
        
        customNavTitleView.addSubview(navTitleLabel)
        customNavTitleView.addSubview(navSubtitleLabel)
        
        navTitleLabel.text = title
        navSubtitleLabel.text = subtitle
        self.navigationItem.titleView = customNavTitleView
    }
    
    func addNavigationBackButton(tintColor: UIColor = UIColor.dmsMetallicBlue){
        
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "arrowBack"), style: .plain, target: self, action: #selector(CommonVC.back))
        newBackButton.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = newBackButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    func addHomeBackButtonWhite(){
        
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeWhite"), style: .plain, target: self, action: #selector(CommonVC.backToHome))
        newBackButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = newBackButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }

    func addHomeBackButtonGreen(){
        
        let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "homeGreen"), style: .plain, target: self, action: #selector(CommonVC.backToHome))
        newBackButton.tintColor = UIColor.dmsMetallicBlue
        self.navigationItem.leftBarButtonItem = newBackButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    func backToHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    func addAddEntryButton(tintColor: UIColor = UIColor.white){
        
        let addEntryButton = UIBarButtonItem(image: #imageLiteral(resourceName: "iconHeaderPlus"), style: .plain, target: self, action: #selector(CommonVC.addEntry))
        addEntryButton.tintColor = tintColor
        self.navigationItem.rightBarButtonItem = addEntryButton
    }

    func addEntry(){
        
    }
    
    func addCancelButton(tintColor: UIColor = UIColor.white) {
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CommonVC.dismissModalController))
        cancelButton.tintColor = tintColor
        if let font = UIFont(name: Font.GothamMedium, size: 17) {
            cancelButton.setTitleTextAttributes([NSFontAttributeName: font], for: UIControlState.normal)
        }

        self.navigationItem.leftBarButtonItem = cancelButton
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func dismissModalController(){
        dismiss(animated: true, completion: nil)
    }
    
    func getNavigationDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return dateFormatter.string(from: date)
        
    }
    
    func removeNavigationBackButton(){
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem?.isEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    func setExpandingConstraints(viewToExpand: UIView){
        
        let leadingConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.view.addConstraint(leadingConstraint)
        
        let trailingConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.view.addConstraint(trailingConstraint)
        
        let topConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 66)
        self.view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottomConstraint)
    }
    
    func setTotalExpandingConstraints(viewToExpand: UIView){
        
        let leadingConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.view.addConstraint(leadingConstraint)
        
        let trailingConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.view.addConstraint(trailingConstraint)
        
        let topConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottomConstraint)
    }

    func addNotificationObservers(){
        
    }
    
    func removeNotificationObservers(){
        
    }
    
    func updateErrorMessageConstraints() {
        
        // Error view constraints
        let leadingViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.view.addConstraint(leadingViewConstraint)
        
        self.topViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.view.addConstraint(self.topViewConstraint)
        
        let trailingViewConstraint = NSLayoutConstraint(item: errorMessageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.view.addConstraint(trailingViewConstraint)
        
        //         Error label constraints
        let leadingLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 15)
        self.view.addConstraint(leadingLabelConstraint)
        
        let trailingLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -15)
        self.view.addConstraint(trailingLabelConstraint)
        
        topLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        self.view.addConstraint(topLabelConstraint)
        
        bottomLabelConstraint = NSLayoutConstraint(item: errorLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottomLabelConstraint)
        
        //         Error image constraints
        let trailingImageConstraint = NSLayoutConstraint(item: errorImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: errorMessageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -15)
        self.view.addConstraint(trailingImageConstraint)
        
        let horizontalImageConstraint = NSLayoutConstraint(item: errorImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: errorLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(horizontalImageConstraint)
        
        let heightImageConstraint = NSLayoutConstraint(item: errorImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 16)
        self.view.addConstraint(heightImageConstraint)
        
        let widthImageConstraint = NSLayoutConstraint(item: errorImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 16)
        self.view.addConstraint(widthImageConstraint)
        
    }
    
    func showError(errorMessage: String, backgroundColor: UIColor? = UIColor.dmsTomato){
        
        if CommonVC.errorMessageActive == false {
            
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            self.topViewConstraint.constant = 0
            errorImageView.image = #imageLiteral(resourceName: "iconInfo")
            self.view.layoutIfNeeded()
            errorLabel.text = errorMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                
                let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: false)
            })
            
        }
    }
    
    func showErrorAndBackToRoot(errorMessage: String, backgroundColor: UIColor? = UIColor.dmsTomato){
        
        if CommonVC.errorMessageActive == false {
            errorImageView.image = #imageLiteral(resourceName: "iconInfo")
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            self.topViewConstraint.constant = 0
            self.view.layoutIfNeeded()

            errorLabel.text = errorMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                
                let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHideAndPop), userInfo: nil, repeats: false)
            })
        }
    }
    
    func showErrorForTransparentNavigation(errorMessage: String, backgroundColor: UIColor? = UIColor.dmsTomato){
        
        if CommonVC.errorMessageActive == false {
            
            errorImageView.image = #imageLiteral(resourceName: "iconInfo")
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            self.topViewConstraint.constant = 64
            self.view.layoutIfNeeded()
            
            errorLabel.text = errorMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: false)
            })
            
        }
    }
    
    func animateHideAndPop(){
        self.topLabelConstraint.constant = 0
        self.bottomLabelConstraint.constant = 0
        self.errorLabel.text = ""
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (Bool) in
            self.errorImageView.image = nil
            CommonVC.errorMessageActive = false
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func animateHide(){
        self.topLabelConstraint.constant = 0
        self.bottomLabelConstraint.constant = 0
        self.errorLabel.text = ""
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (Bool) in
            self.errorImageView.image = nil
            CommonVC.errorMessageActive = false
        })
    }
    
    func showInfo(infoMessage: String, backgroundColor: UIColor? = UIColor.dmsLightNavy){
        
        if CommonVC.errorMessageActive == false {
            
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            errorImageView.image = nil
            self.topViewConstraint.constant = 0
            self.view.layoutIfNeeded()

            errorLabel.text = infoMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8

            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                CommonVC.errorMessageActive = false
            })
            
        }else{
            self.errorMessageView.backgroundColor = backgroundColor
            self.errorLabel.text = infoMessage
        }
    }
    
    func showInfoWithHide(infoMessage: String, backgroundColor: UIColor? = UIColor.dmsLightNavy){
        
        if CommonVC.errorMessageActive == false {
            
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            self.topViewConstraint.constant = 0
            errorImageView.image = nil
            self.view.layoutIfNeeded()

            errorLabel.text = infoMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion:
                { (Bool) in
                    let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: false)
            })
            
        }else{
            self.errorMessageView.backgroundColor = backgroundColor
            self.errorLabel.text = infoMessage
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: false)
            })
        }
    }
    
    func showInfoForTransparentNavigation(infoMessage: String, backgroundColor: UIColor? = UIColor.dmsLightNavy){
        
        if CommonVC.errorMessageActive == false {
            
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            self.topViewConstraint.constant = 64
            errorImageView.image = nil
            self.view.layoutIfNeeded()

            errorLabel.text = infoMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8

            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                CommonVC.errorMessageActive = false
            })
        }else{
            self.errorMessageView.backgroundColor = backgroundColor
            self.errorLabel.text = infoMessage
        }
    }
    
    func showInfoForTransparentNavigationWithHide(infoMessage: String, backgroundColor: UIColor? = UIColor.dmsLightNavy){
        
        if CommonVC.errorMessageActive == false {
            
            CommonVC.errorMessageActive = true
            errorMessageView.backgroundColor = backgroundColor
            self.topViewConstraint.constant = 64
            errorImageView.image = nil
            self.view.layoutIfNeeded()

            errorLabel.text = infoMessage
            topLabelConstraint.constant = 8
            bottomLabelConstraint.constant = -8

            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                
                let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: false)

            })
        }else{
            self.errorMessageView.backgroundColor = backgroundColor
            self.errorLabel.text = infoMessage
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {
                (Bool) in
                let _ = Timer.scheduledTimer(timeInterval: self.toastMessageDuration, target: self, selector: #selector(self.animateHide), userInfo: nil, repeats: false)
            })
        }
    }

    
    func hideInfo(withDelay: Double? = 0.0, force: Bool? = false){
        
        if force == true {
            CommonVC.errorMessageActive = false
            errorLabel.text = ""
            topLabelConstraint.constant = 0
            bottomLabelConstraint.constant = 0
            self.view.layoutIfNeeded()
        }else{
            if CommonVC.errorMessageActive == true {
                errorLabel.text = ""
                topLabelConstraint.constant = 0
                bottomLabelConstraint.constant = 0
                UIView.animate(withDuration: 0.5, delay: withDelay!, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: {
                    (Bool) in
                    CommonVC.errorMessageActive = false
                })
            }
        }
    }
    
    func back(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    func resizeImage(image: UIImage, targetHeight: CGFloat) -> UIImage? {
        
        let ratio = targetHeight / image.size.height
        let targetWidth = image.size.width * ratio
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        newSize = CGSize(width: targetWidth, height: targetHeight)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func resizeImage(image: UIImage, targetWidth: CGFloat) -> UIImage? {
        
        let ratio = targetWidth / image.size.width
        let targetHeight = image.size.height * ratio
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        newSize = CGSize(width: targetWidth, height: targetHeight)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func getNextDate(startDate: Date) -> Date {
        let nextDay = calendar.date(byAdding: Calendar.Component.day, value: +1, to: startDate) ?? Date()
        return cutDateToMidnight(dateToCut: nextDay, utcOffset: nil) ?? Date()
    }
    
    // Get starting date for fetching blood pressure readings from CoreData
    func getStartDate(interval: Int, endDate: Date) -> Date {
        
        let pastDay = calendar.date(byAdding: Calendar.Component.day, value: -interval, to: endDate) ?? Date()
        return cutDateToMidnight(dateToCut: pastDay, utcOffset: nil) ?? Date()
        
    }
    // Convert date to same date, but time is 00:00
    func cutDateToMidnight(dateToCut: Date, utcOffset: String?) -> Date?{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(abbreviation: utcOffset ?? "GMT+0:00")
        let dateString = df.string(from: dateToCut)
        df.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return df.date(from: dateString)
    }
    
    func cutDateToUTCMidnight(dateToCut: Date) -> Date?{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: dateToCut)
        return df.date(from: dateString)
    }
    
    
}

extension UITableViewCell {
    func cutDateToUTCMidnight(dateToCut: Date) -> Date?{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString = df.string(from: dateToCut)
        return df.date(from: dateString)
    }
}
