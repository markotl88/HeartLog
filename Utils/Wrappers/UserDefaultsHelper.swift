//
//  UserDefaultsHelper.swift
//  Client
//
//  Created by Marko Stajic on 5/28/18.
//

import UIKit

class UserDefaultsHelper {

    static let userDefaults = UserDefaults.standard
    
    //Keys:
    static let firstMeasure = "firstMeasure"
    
    public class func isFirstMeasuringDone() -> Bool {
        return userDefaults.bool(forKey: firstMeasure)
    }
    
    public class func firstMeasureDone() {
        userDefaults.set(true, forKey: firstMeasure)
    }
}
