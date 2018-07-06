//
//  StoryboardInitializable.swift
//  DPS
//
//  Created by Marko Stajic on 12/25/17.
//  Copyright © 2017 Marko Stajic. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var loginStoryboardName: String { get }
    static var mainStoryboardName: String { get }

    static var storyboardBundle: Bundle? { get }
    
    static func makeFromLoginStoryboard() -> Self
    static func makeFromHomeStoryboard() -> Self

    func embedInNavigationController() -> UINavigationController
    func embedInNavigationController(navBarClass: AnyClass?) -> UINavigationController
}

extension StoryboardInitializable where Self : UIViewController {
    static var loginStoryboardName: String {
        return "Onboarding"
    }
    
    static var mainStoryboardName: String {
        return "BloodPressure"
    }
    
    static var storyboardBundle: Bundle? {
        return nil
    }
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func makeFromLoginStoryboard() -> Self {
        let storyboard = UIStoryboard(name: loginStoryboardName, bundle: storyboardBundle)
        return storyboard.instantiateViewController(
            withIdentifier: storyboardIdentifier) as! Self
    }
    
    static func makeFromHomeStoryboard() -> Self {
        let storyboard = UIStoryboard(name: mainStoryboardName, bundle: storyboardBundle)
        return storyboard.instantiateViewController(
            withIdentifier: storyboardIdentifier) as! Self
    }

    func embedInNavigationController() -> UINavigationController {
        return embedInNavigationController(navBarClass: nil)
    }
    
    func embedInNavigationController(navBarClass: AnyClass?) -> UINavigationController {
        let nav = UINavigationController(navigationBarClass: navBarClass, toolbarClass: nil)
        nav.viewControllers = [self]
        return nav
    }
}
