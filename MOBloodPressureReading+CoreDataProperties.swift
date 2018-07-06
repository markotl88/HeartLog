//
//  MOBloodPressureReading+CoreDataProperties.swift
//  FTN
//
//  Created by Marko Stajic on 3/12/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import Foundation
import CoreData


extension MOBloodPressureReading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOBloodPressureReading> {
        return NSFetchRequest<MOBloodPressureReading>(entityName: "MOBloodPressureReading");
    }

    @NSManaged public var activity: String?
    @NSManaged public var diastolic: Int16
    @NSManaged public var heartRate: Int16
    @NSManaged public var metaIncomplete: Bool
    @NSManaged public var mood: String?
    @NSManaged public var systolic: Int16
    @NSManaged public var validated: Bool

}
