//
//  BloodPressureReading.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

public class BloodPressureReading: Reading {
    
    var systolic : UInt = 0
    var diastolic : UInt = 0
    var heartRate : UInt = 0
    var mood : String?
    var activity : String?
    var metaIncomplete : Bool = true
    var validated : Bool = true
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override init() {
        super.init()
    }
    
    init(id: String, source: String?, timestamp: String?, userId: String, utcOffset: String?, lastUpdated: String?,  note: String?, dateCreated: Date?, dateUpdated: Date?, shortDateCreated: String?, shortTimeCreated: String?, objectId: NSManagedObjectID?, syncedWithServer: Bool?, systolic: UInt, diastolic: UInt, mood: String?, activity: String?, heartRate: UInt, metaIncomplete: Bool?, validated: Bool?) {
        
        super.init()
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
        
        self.systolic = systolic
        self.diastolic = diastolic
        self.mood = mood
        self.activity = activity
        self.heartRate = heartRate
        self.metaIncomplete = metaIncomplete ?? true
        self.validated = validated ?? true
    }

    public override func copy(with zone: NSZone?) -> Any {
        let copy = BloodPressureReading(id: id, source: source, timestamp: timestamp, userId: userId, utcOffset: utcOffset, lastUpdated: lastUpdated, note: note, dateCreated: dateCreated, dateUpdated: dateUpdated, shortDateCreated: shortDateCreated, shortTimeCreated: shortTimeCreated, objectId: objectId, syncedWithServer: syncedWithServer, systolic: systolic, diastolic: diastolic, mood: mood, activity: activity, heartRate: heartRate, metaIncomplete: metaIncomplete, validated: validated)
        return copy
    }

    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        systolic <- map["systolic"]
        diastolic <- map["diastolic"]
        heartRate <- map["resting_heartrate"]
        mood <- map["mood"]
        activity <- map["activity_category"]
        metaIncomplete <- map["meta_incomplete"]
        validated <- map["validated"]
        
    }
    
    
    init(systolic: UInt, diastolic: UInt, heartRate: UInt, time: String?) {
        
        super.init()
        self.systolic = systolic
        self.diastolic = diastolic
        self.heartRate = heartRate
        self.timestamp = time
    }
    
    public override func toString() -> String{
        return "\nReading ID: \(id)\nSystolic: \(systolic)\nDiastolic: \(diastolic)\nHeart rate: \(heartRate)\nTimestamp: \(timestamp)\nUTC offset: \(utcOffset)\nActivity: \(activity)\nMood: \(mood)\nNote: \(note)\nIncomplete: \(metaIncomplete)\nValidated: \(validated)"
    }
    
    public override func patchJSON() -> [String: Any] {
        var json = super.patchJSON()
        
        json["systolic"] = self.systolic
        json["diastolic"] = self.diastolic
        json["resting_heartrate"] = self.heartRate
        json["validated"] = self.validated

        if let mood = self.mood {
            json["mood"] = mood
        }
        if let activity = self.activity {
            json["activity_category"] = activity
        }
        
        return json
    }
    
    public func patchJSONForAutomaticReading() -> [String : Any] {
        var json = super.patchJSON()
        
        json["validated"] = self.validated
        
        if let mood = self.mood {
            json["mood"] = mood
        }
        if let activity = self.activity {
            json["activity_category"] = activity
        }
        
        _ = json.removeValue(forKey: "systolic") as? Int
        _ = json.removeValue(forKey: "diastolic") as? Int
        _ = json.removeValue(forKey: "resting_heartrate") as? Int
        
        return json
    }


}
