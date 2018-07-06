//
//  JoyrideState.swift
//  FTN
//
//  Created by Marko Stajic on 4/25/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import Foundation

enum JoyrideState: Int {
    
    //Welcome screen
    case start
    
    //Activity tracker
    case activityIntro
    case activityHistory
    case activityAdd
    case activityFinished
    
    //Blood pressure
    case bpIntro
    case bpSetup
    case bpStart
    case bpResult
    case bpHistory
    
    //Glucose
    case bgIntro
    case bgSetup
    case bgStart
    case bgResult
    case bgHistory
    
    //Home screen
    case settings
    case healthPartner
    case ready
    
    case finished
    
}

struct DeviceListState {
    static var cardiology: Bool = false
    static var glycemic: Bool = false
    static var lifestyle: Bool = false
}
