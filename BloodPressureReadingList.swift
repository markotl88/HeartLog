//
//  BloodPressureReadingList.swift
//  FTN
//
//  Created by Marko Stajic on 12/20/16.
//  Copyright © 2018 FTN. All rights reserved.
//


import Foundation
import ObjectMapper

public class BloodPressureReadingList: ReadingList {
    
        var bloodPressureReadings : [BloodPressureReading] = [BloodPressureReading]()
    
        public required init?(map: Map) {
        super.init(map: map)
        }
    
        public override func mapping(map: Map) {
        super.mapping(map: map)
            bloodPressureReadings <- map["results"]
        }
}
