//
//  MOReading+CoreDataProperties.swift
//  FTN
//
//  Created by Marko Stajic on 3/12/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import Foundation
import CoreData


extension MOReading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOReading> {
        return NSFetchRequest<MOReading>(entityName: "MOReading");
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var dateUpdated: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var lastUpdated: String?
    @NSManaged public var note: String?
    @NSManaged public var shortDateCreated: String?
    @NSManaged public var shortTimeCreated: String?
    @NSManaged public var source: String?
    @NSManaged public var syncedWithServer: Bool
    @NSManaged public var timestamp: String?
    @NSManaged public var userId: String?
    @NSManaged public var utcOffset: String?
    @NSManaged public var shortDateUpdated: String?
    @NSManaged public var shortTimeUpdated: String?

}
