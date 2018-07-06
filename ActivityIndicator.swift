//
//  ActivityIndicator.swift
//  LitPix
//
//  Created by Marko Stajic on 8/9/16.
//  Copyright © 2016 NSWD_. All rights reserved.
//

import UIKit

open class ActivityIndicator {
    // MARK: - Properties
    open static let sharedInstance = ActivityIndicator()
    
    var tempView : UIView!
    var backgroundView : UIView!
    var activityLabel : ActivityLabel!
    
    var imgListArray : [UIImage] = []
    var imageView : UIImageView!
    
    // MARK: - Lifecycle
    init() {
        
        for countValue in 1...60 {
            let strImageName : String = "\(countValue)_Loader"
            let image  = UIImage(named:strImageName)
            imgListArray.append(image!)
        }

    }
    
    open func startIndicatorForPageMenu(view: UIView){
        
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        imageView.backgroundColor = UIColor.clear
        imageView.center = CGPoint(x: backgroundView.center.x, y: backgroundView.center.y - 64)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.animationImages = imgListArray
        self.imageView.animationDuration = 2.0
        
        tempView = view
        
        view.isUserInteractionEnabled = false
        backgroundView.addSubview(imageView)
        view.addSubview(backgroundView)
        
        self.imageView.startAnimating()
    }
    open func startIndicatorForPageMenuWithText(_ text: String, view: UIView){
        
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        imageView.backgroundColor = UIColor.clear
        imageView.center = CGPoint(x: backgroundView.center.x, y:backgroundView.center.y - 64)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.animationImages = imgListArray
        self.imageView.animationDuration = 2.0
        
        activityLabel = ActivityLabel(frame: CGRect(x: 20, y: self.imageView.frame.origin.y + 120, width: UIScreen.main.bounds.width - 40, height: 40))
        activityLabel.text = text
        tempView = view
        
        view.isUserInteractionEnabled = false
        backgroundView.addSubview(imageView)
        backgroundView.addSubview(activityLabel)
        view.addSubview(backgroundView)
        
        self.imageView.startAnimating()
    }
    open func stopIndicator(){
        
        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.navigationBar.isUserInteractionEnabled = true
        imageView.stopAnimating()
        backgroundView.removeFromSuperview()
        tempView.isUserInteractionEnabled = true
    }
    
    
    open func startIndicator(viewController: UIViewController, navigationInteractionEnabled: Bool = false){
        viewController.navigationController?.navigationBar.isUserInteractionEnabled = navigationInteractionEnabled
        
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        imageView.backgroundColor = UIColor.clear
        imageView.center.x = backgroundView.center.x
        imageView.center.y = backgroundView.center.y - 64.0
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.animationImages = imgListArray
        self.imageView.animationDuration = 2.0
        
        tempView = viewController.view
        
        viewController.view.isUserInteractionEnabled = false
        backgroundView.addSubview(imageView)
        viewController.view.addSubview(backgroundView)
        
        self.imageView.startAnimating()
    }
    open func startIndicatorForPageMenu(viewController: UIViewController){
        
        viewController.navigationController?.navigationBar.isUserInteractionEnabled = false
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        imageView.backgroundColor = UIColor.clear
        imageView.center = CGPoint(x: backgroundView.center.x, y: backgroundView.center.y - 64)
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.animationImages = imgListArray
        self.imageView.animationDuration = 2.0
        
        tempView = viewController.view
        
        viewController.view.isUserInteractionEnabled = false
        backgroundView.addSubview(imageView)
        viewController.view.addSubview(backgroundView)
        
        self.imageView.startAnimating()
    }
    open func startIndicatorWithText(_ text: String, viewController: UIViewController, navigationInteractionEnabled: Bool = false){
        
        viewController.navigationController?.navigationBar.isUserInteractionEnabled = navigationInteractionEnabled
        backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        
        imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        imageView.backgroundColor = UIColor.clear
        imageView.center = backgroundView.center
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.animationImages = imgListArray
        self.imageView.animationDuration = 2.0
        
        activityLabel = ActivityLabel(frame: CGRect(x: 20, y: self.imageView.frame.origin.y + 120, width: UIScreen.main.bounds.width - 40, height: 40))
        activityLabel.text = text
        tempView = viewController.view
        
        viewController.view.isUserInteractionEnabled = false
        backgroundView.addSubview(imageView)
        backgroundView.addSubview(activityLabel)
        viewController.view.addSubview(backgroundView)
        
        self.imageView.startAnimating()
    }
    open func stopIndicator(viewController: UIViewController){
        
        viewController.navigationController?.navigationBar.isUserInteractionEnabled = true
        imageView.stopAnimating()
        backgroundView.removeFromSuperview()
        tempView.isUserInteractionEnabled = true
    }

    func setExpandingConstraints(viewToExpand: UIView, view: UIView){
        
        let leadingConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        view.addConstraint(leadingConstraint)
        
        let trailingConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        view.addConstraint(trailingConstraint)
        
        let topConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 66)
        view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: viewToExpand, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
    }

}


