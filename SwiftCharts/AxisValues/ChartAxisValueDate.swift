//
//  ChartAxisValueDate.swift
//  swift_charts
//
//  Created by ischuetz on 01/03/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

open class ChartAxisValueDate: ChartAxisValue {
  
    fileprivate let formatter: (Date) -> String

    open var date: Date {
        return ChartAxisValueDate.dateFromScalar(self.scalar)
    }

    public init(date: Date, formatter: @escaping (Date) -> String, labelSettings: ChartLabelSettings = ChartLabelSettings()) {
        self.formatter = formatter
        super.init(scalar: ChartAxisValueDate.scalarFromDate(date), labelSettings: labelSettings)
    }

    convenience public init(date: Date, formatter: DateFormatter, labelSettings: ChartLabelSettings = ChartLabelSettings()) {
        self.init(date: date, formatter: { formatter.string(from: $0) }, labelSettings: labelSettings)
    }
    
    convenience public init(isFirstOrLast: Bool, date: Date, formatter: DateFormatter, labelSettings: ChartLabelSettings = ChartLabelSettings()) {
        if isFirstOrLast {
            self.init(date: date, formatter: { _ in "" }, labelSettings: labelSettings)
        }else{
            self.init(date: date, formatter: { formatter.string(from: $0) }, labelSettings: labelSettings)
        }
    }
    
    open class func dateFromScalar(_ scalar: Double) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(scalar))
    }
    
    open class func scalarFromDate(_ date: Date) -> Double {
        return Double(date.timeIntervalSince1970)
    }

    // MARK: CustomStringConvertible

    override open var description: String {
        return self.formatter(self.date)
    }
}

