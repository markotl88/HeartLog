//
//  GraphData + Typealiases.swift
//  FTN
//
//  Created by Marko Stajic on 3/25/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import Foundation

struct GraphData {
    var date: Date
    var values: [Double]
    var countOfReadings:Int
    var average: Double
    var minimum: Double?
    var maximum: Double?
}

typealias BloodPressureGraphResults = (systolic: [GraphData], diastolic: [GraphData])

typealias GlucoseGraphResults = (premeal: [GraphData], aftermeal: [GraphData])

