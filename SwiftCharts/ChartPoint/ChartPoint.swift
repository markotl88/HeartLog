//
//  ChartPoint.swift
//  swift_charts
//
//  Created by ischuetz on 01/03/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

open class ChartPoint: Equatable, CustomStringConvertible {
    
    open let x: ChartAxisValue
    open let y: ChartAxisValue
    
    open var hoursAndMins: String?
    open var numberOfReadings : Int?
    open var last : Bool?
    open var dateStr: String?
    
    required public init(x: ChartAxisValue, y: ChartAxisValue) {
        self.x = x
        self.y = y
    }
    
    init(x: ChartAxisValue, y: ChartAxisValue, numberOfReadings: Int) {
        self.x = x
        self.y = y
        self.numberOfReadings = numberOfReadings
    }
    
    init(x: ChartAxisValue, y: ChartAxisValue, numberOfReadings: Int, hoursAndMins: String) {
        self.x = x
        self.y = y
        self.numberOfReadings = numberOfReadings
        self.hoursAndMins = hoursAndMins
    }
    
    init(x: ChartAxisValue, y: ChartAxisValue, numberOfReadings: Int, isLast: Bool, dateStr: String) {
        self.x = x
        self.y = y
        self.numberOfReadings = numberOfReadings
        self.last = isLast
        self.dateStr = dateStr
    }
    
    init(x: ChartAxisValue, y: ChartAxisValue, numberOfReadings: Int, isLast: Bool, hoursAndMins: String, dateStr: String) {
        self.x = x
        self.y = y
        self.numberOfReadings = numberOfReadings
        self.hoursAndMins = hoursAndMins
        self.last = isLast
        self.dateStr = dateStr
    }

    
    open var description: String {
        return "\(self.x), \(self.y)"
    }
}

public func ==(lhs: ChartPoint, rhs: ChartPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
