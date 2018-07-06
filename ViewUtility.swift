//
//  ViewUtility.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 4/11/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit
import Foundation

class ViewUtility {

    static func getVisibleViewController() -> UIViewController? {
        
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            
            if let navigationController = topController as? UINavigationController {
                return navigationController.visibleViewController
            }
            else if let tabBarController = topController as? UITabBarController {
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    return navigationController.visibleViewController
                }
                else {
                    return topController
                }
            }
            else {
                return topController
            }
        }
        else {
            return nil
        }
        
    }
    
    static func showAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertAndDismiss(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            viewController.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }

    
    static func showAlertAndGoBack(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            viewController.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func setStatusBarColor(dark: Bool) {
        if dark {
            UIApplication.shared.statusBarStyle = .default
        }
        else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

}
