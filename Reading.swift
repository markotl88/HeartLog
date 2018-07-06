//
//  Reading.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

public class Reading: NSObject, Mappable, NSCopying {
    var id : String = ""
    var source : String?
    var timestamp : String?
    var userId : String = ""
    var utcOffset : String?
    var lastUpdated : String?
    var note : String?
    var dateCreated : Date = Date()
    var dateUpdated : Date?
    var shortDateCreated : String?
    var shortTimeCreated : String?
    var objectId : NSManagedObjectID?
    
    var syncedWithServer : Bool = false
    
    var shortDateUpdated : String?
    var shortTimeUpdated : String?

    override init() {
        
    }
    
    init(id: String, source: String?, timestamp: String?, userId: String, utcOffset: String?, lastUpdated: String?,  note: String?, dateCreated: Date?, dateUpdated: Date?, shortDateCreated: String?, shortTimeCreated: String?, objectId: NSManagedObjectID?, syncedWithServer: Bool?, shortDateUpdated: String?, shortTimeUpdated: String?) {
        self.id = id
        self.source = source
        self.timestamp = timestamp
        self.userId = userId
        self.utcOffset = utcOffset
        self.lastUpdated = lastUpdated
        self.note = note
        self.dateCreated = dateCreated  ?? Date()
        self.dateUpdated = dateUpdated
        self.shortDateCreated = shortDateCreated
        self.shortTimeCreated = shortTimeCreated
        self.objectId = objectId
        self.syncedWithServer = syncedWithServer ?? false
        self.shortTimeUpdated = shortTimeUpdated
        self.shortDateUpdated = shortDateUpdated
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        
        id <- map["id"]
        source <- map["source"]
        timestamp <- map["timestamp"]
        userId <- map["user"]
        utcOffset <- map["utc_offset"]
        lastUpdated <- map["last_updated"]
        note <- map["note"]
        
        dateCreated = timestamp?.getLocalTimeFromUTCTimestamp() ?? Date() //If there's no date in reading put current date instead
        dateUpdated = lastUpdated?.getLocalTimeFromUTCTimestamp() ?? dateCreated
        
        shortDateCreated = dateCreated.getLocalShortDate()
        shortTimeCreated = dateCreated.getLocalShortTime()
        shortDateUpdated = dateUpdated?.getLocalShortDate()
        shortTimeUpdated = dateUpdated?.getLocalShortTime()
        
        print("• • • • • • • • • • • • • •")
        print("Timestamp: \(timestamp)")
        print("UTC Offset: \(utcOffset)")
        print("Date created: \(dateCreated)")
        print("Short Date Created: \(shortDateCreated)")
        print("Short Time Created: \(shortTimeCreated)")
        print("Date updated: \(dateUpdated)")
        print("Short Date Updated: \(shortDateUpdated)")
        print("Short Time Updated: \(shortTimeUpdated)")


    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Reading(id: id, source: source, timestamp: timestamp, userId: userId, utcOffset: utcOffset, lastUpdated: lastUpdated, note: note, dateCreated: dateCreated, dateUpdated: dateUpdated, shortDateCreated: shortDateCreated, shortTimeCreated: shortTimeCreated, objectId: objectId, syncedWithServer: syncedWithServer, shortDateUpdated: shortDateUpdated, shortTimeUpdated: shortTimeUpdated)
        return copy
    }
    
    public func toString() -> String{
        return "\nReading ID: \(id)"
    }
    
    public func patchJSON() -> [String: Any] {
        
        var json = [String:Any]()
        json = self.toJSON()
        
        if let note = self.note {
            json["note"] = note
        }
        if let lastUpdated = self.lastUpdated {
            json["last_updated"] = lastUpdated
        }
        
        return json
    }
    

}
