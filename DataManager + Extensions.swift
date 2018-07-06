//
//  DataManager + Extensions.swift
//  FTN
//
//  Created by Marko Stajic on 2/2/17.
//  Copyright © 2017 DMS. All rights reserved.
//

import Foundation
import CoreData

/// Core data communication.
extension DataManager {
    
    public func saveBloodPressureToCoreData(bloodPressureReading: BloodPressureReading, syncedWithServer: Bool){
        
        func saveToCoreData(){
            if let bpReadingEntity = NSEntityDescription.entity(forEntityName: "MOBloodPressureReading", in: managedContext) {
                
                if #available(iOS 10.0, *) {
                    let bpReadingInstance = MOBloodPressureReading(context: managedContext)
                    
                    bpReadingInstance.id = bloodPressureReading.id
                    bpReadingInstance.source = bloodPressureReading.source
                    bpReadingInstance.timestamp = bloodPressureReading.timestamp
                    bpReadingInstance.userId = bloodPressureReading.userId
                    bpReadingInstance.utcOffset = bloodPressureReading.utcOffset
                    bpReadingInstance.lastUpdated = bloodPressureReading.lastUpdated
                    bpReadingInstance.note = bloodPressureReading.note
                    bpReadingInstance.dateCreated = bloodPressureReading.dateCreated as NSDate?
                    bpReadingInstance.dateUpdated = bloodPressureReading.dateUpdated as NSDate?
                    bpReadingInstance.shortTimeCreated = bloodPressureReading.shortTimeCreated
                    bpReadingInstance.shortDateCreated = bloodPressureReading.shortDateCreated
                    bpReadingInstance.shortTimeUpdated = bloodPressureReading.shortTimeUpdated
                    bpReadingInstance.shortDateUpdated = bloodPressureReading.shortDateUpdated
                    bpReadingInstance.systolic = Int16(bloodPressureReading.systolic)
                    bpReadingInstance.diastolic = Int16(bloodPressureReading.diastolic)
                    bpReadingInstance.heartRate = Int16(bloodPressureReading.heartRate)
                    bpReadingInstance.activity = bloodPressureReading.activity
                    bpReadingInstance.mood = bloodPressureReading.mood
                    bpReadingInstance.metaIncomplete = bloodPressureReading.metaIncomplete
                    bpReadingInstance.validated = bloodPressureReading.validated
                    bpReadingInstance.syncedWithServer = syncedWithServer
                    
                } else {
                    // Fallback on earlier versions
                    let bpReadingInstance = NSManagedObject(entity: bpReadingEntity, insertInto: managedContext)
                    bpReadingInstance.setValue(bloodPressureReading.id, forKey: "id")
                    bpReadingInstance.setValue(bloodPressureReading.source, forKey: "source")
                    bpReadingInstance.setValue(bloodPressureReading.timestamp, forKey: "timestamp")
                    bpReadingInstance.setValue(bloodPressureReading.userId, forKey: "userId")
                    bpReadingInstance.setValue(bloodPressureReading.utcOffset, forKey: "utcOffset")
                    bpReadingInstance.setValue(bloodPressureReading.lastUpdated, forKey: "lastUpdated")
                    bpReadingInstance.setValue(bloodPressureReading.note, forKey: "note")
                    
                    bpReadingInstance.setValue(bloodPressureReading.dateCreated, forKey: "dateCreated")
                    bpReadingInstance.setValue(bloodPressureReading.dateUpdated, forKey: "dateUpdated")
                    bpReadingInstance.setValue(bloodPressureReading.shortTimeCreated, forKey: "shortTimeCreated")
                    bpReadingInstance.setValue(bloodPressureReading.shortDateCreated, forKey: "shortDateCreated")
                    bpReadingInstance.setValue(bloodPressureReading.shortTimeUpdated, forKey: "shortTimeUpdated")
                    bpReadingInstance.setValue(bloodPressureReading.shortDateUpdated, forKey: "shortDateUpdated")

                    
                    bpReadingInstance.setValue(bloodPressureReading.systolic, forKey: "systolic")
                    bpReadingInstance.setValue(bloodPressureReading.diastolic, forKey: "diastolic")
                    bpReadingInstance.setValue(bloodPressureReading.heartRate, forKey: "heartRate")
                    bpReadingInstance.setValue(bloodPressureReading.mood, forKey: "mood")
                    bpReadingInstance.setValue(bloodPressureReading.activity, forKey: "activity")
                    bpReadingInstance.setValue(bloodPressureReading.metaIncomplete, forKey: "metaIncomplete")
                    bpReadingInstance.setValue(bloodPressureReading.validated, forKey: "validated")
                    bpReadingInstance.setValue(syncedWithServer, forKey: "syncedWithServer")
                }
                
                
                do {
                    try managedContext.save()
                    
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                    managedContext.rollback()
                }
            }
        }
        
        if bloodPressureReading.id != "" {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
            fetchRequest.predicate = NSPredicate(format: "id = %@", bloodPressureReading.id)
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                if results.count == 0 {
                    saveToCoreData()
                }
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }else{
            saveToCoreData()
        }
        
    }
    public func getBloodPressureReadingsFromCoreData(date: Date) -> [BloodPressureReading] {
        var bloodPressureReadings = [BloodPressureReading]()
        var moBloodPressureReadingsObjects: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
        fetchRequest.predicate = NSPredicate(format: "%@ <= dateCreated", date as CVarArg)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            moBloodPressureReadingsObjects = results
            
            print("Core Data Blood pressure readings count: \(moBloodPressureReadingsObjects.count)")
            for i in moBloodPressureReadingsObjects {
                
                let bloodPressureReading = BloodPressureReading()
                bloodPressureReading.id = i.value(forKey: "id") as! String
                
                bloodPressureReading.source = i.value(forKey: "source") as? String
                bloodPressureReading.timestamp = i.value(forKey: "timestamp") as? String
                bloodPressureReading.userId = i.value(forKey: "userId") as! String
                bloodPressureReading.utcOffset = i.value(forKey: "utcOffset") as? String
                bloodPressureReading.lastUpdated = i.value(forKey: "lastUpdated") as? String
                bloodPressureReading.note = i.value(forKey: "note") as? String
                
                bloodPressureReading.dateCreated = i.value(forKey: "dateCreated") as! Date
                bloodPressureReading.dateUpdated = i.value(forKey: "dateUpdated") as? Date
                bloodPressureReading.shortDateCreated = i.value(forKey: "shortDateCreated") as? String
                bloodPressureReading.shortTimeCreated = i.value(forKey: "shortTimeCreated") as? String
                bloodPressureReading.shortDateUpdated = i.value(forKey: "shortDateUpdated") as? String
                bloodPressureReading.shortTimeUpdated = i.value(forKey: "shortTimeUpdated") as? String

                
                bloodPressureReading.diastolic = i.value(forKey: "diastolic") as! UInt
                bloodPressureReading.systolic = i.value(forKey: "systolic") as! UInt
                bloodPressureReading.heartRate = i.value(forKey: "heartRate") as! UInt
                bloodPressureReading.mood = i.value(forKey: "mood") as? String
                bloodPressureReading.activity = i.value(forKey: "activity") as? String
                bloodPressureReading.metaIncomplete = i.value(forKey: "metaIncomplete") as! Bool
                bloodPressureReading.validated = i.value(forKey: "validated") as! Bool
                bloodPressureReading.syncedWithServer = i.value(forKey: "syncedWithServer") as! Bool
                bloodPressureReadings.append(bloodPressureReading)
                bloodPressureReading.objectId = i.objectID
            }
            
            return bloodPressureReadings
            
        }catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return bloodPressureReadings
        }
        
    }
    public func getBloodPressureReadingsFromCoreData() -> [BloodPressureReading] {
        var bloodPressureReadings = [BloodPressureReading]()
        var moBloodPressureReadingsObjects: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            moBloodPressureReadingsObjects = results
            
            print("Core Data Blood pressure readings count: \(moBloodPressureReadingsObjects.count)")
            for i in moBloodPressureReadingsObjects {
                
                let bloodPressureReading = BloodPressureReading()
                bloodPressureReading.id = i.value(forKey: "id") as! String
                
                bloodPressureReading.source = i.value(forKey: "source") as? String
                bloodPressureReading.timestamp = i.value(forKey: "timestamp") as? String
                bloodPressureReading.userId = i.value(forKey: "userId") as! String
                bloodPressureReading.utcOffset = i.value(forKey: "utcOffset") as? String
                bloodPressureReading.lastUpdated = i.value(forKey: "lastUpdated") as? String
                bloodPressureReading.note = i.value(forKey: "note") as? String
                
                bloodPressureReading.dateCreated = i.value(forKey: "dateCreated") as! Date
                bloodPressureReading.dateUpdated = i.value(forKey: "dateUpdated") as? Date
                bloodPressureReading.shortDateCreated = i.value(forKey: "shortDateCreated") as? String
                bloodPressureReading.shortTimeCreated = i.value(forKey: "shortTimeCreated") as? String
                bloodPressureReading.shortDateUpdated = i.value(forKey: "shortDateUpdated") as? String
                bloodPressureReading.shortTimeUpdated = i.value(forKey: "shortTimeUpdated") as? String

                bloodPressureReading.diastolic = i.value(forKey: "diastolic") as! UInt
                bloodPressureReading.systolic = i.value(forKey: "systolic") as! UInt
                bloodPressureReading.heartRate = i.value(forKey: "heartRate") as! UInt
                bloodPressureReading.mood = i.value(forKey: "mood") as? String
                bloodPressureReading.activity = i.value(forKey: "activity") as? String
                bloodPressureReading.metaIncomplete = i.value(forKey: "metaIncomplete") as! Bool
                bloodPressureReading.validated = i.value(forKey: "validated") as! Bool
                bloodPressureReading.syncedWithServer = i.value(forKey: "syncedWithServer") as! Bool
                bloodPressureReading.objectId = i.objectID
                
                bloodPressureReadings.append(bloodPressureReading)
            }
            return bloodPressureReadings
            
        }catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return bloodPressureReadings
        }
        
    }
    public func getBloodPressureReadingsFromDateToDate(startDate: Date, endDate: Date) -> [BloodPressureReading] {
        
        print("\nCore data - Get bp readings from: \(startDate.getShortDate(utcOffset: nil)) to: \(endDate.getShortDate(utcOffset: nil))")
        let methodStart = Date()
        
        var bloodPressureReadings = [BloodPressureReading]()
        var moBloodPressureReadingsObjects: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
        fetchRequest.predicate = NSPredicate(format: "%@ <= dateCreated AND dateCreated <= %@", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            moBloodPressureReadingsObjects = results
            
            for i in moBloodPressureReadingsObjects {
                
                let bloodPressureReading = BloodPressureReading()
                bloodPressureReading.id = i.value(forKey: "id") as! String
                
                bloodPressureReading.source = i.value(forKey: "source") as? String
                bloodPressureReading.timestamp = i.value(forKey: "timestamp") as? String
                bloodPressureReading.userId = i.value(forKey: "userId") as! String
                bloodPressureReading.utcOffset = i.value(forKey: "utcOffset") as? String
                bloodPressureReading.lastUpdated = i.value(forKey: "lastUpdated") as? String
                bloodPressureReading.note = i.value(forKey: "note") as? String
                
                bloodPressureReading.dateCreated = i.value(forKey: "dateCreated") as! Date
                bloodPressureReading.dateUpdated = i.value(forKey: "dateUpdated") as? Date
                bloodPressureReading.shortDateCreated = i.value(forKey: "shortDateCreated") as? String
                bloodPressureReading.shortTimeCreated = i.value(forKey: "shortTimeCreated") as? String
                bloodPressureReading.shortDateUpdated = i.value(forKey: "shortDateUpdated") as? String
                bloodPressureReading.shortTimeUpdated = i.value(forKey: "shortTimeUpdated") as? String

                bloodPressureReading.diastolic = i.value(forKey: "diastolic") as! UInt
                bloodPressureReading.systolic = i.value(forKey: "systolic") as! UInt
                bloodPressureReading.heartRate = i.value(forKey: "heartRate") as! UInt
                bloodPressureReading.mood = i.value(forKey: "mood") as? String
                bloodPressureReading.activity = i.value(forKey: "activity") as? String
                bloodPressureReading.metaIncomplete = i.value(forKey: "metaIncomplete") as! Bool
                bloodPressureReading.validated = i.value(forKey: "validated") as! Bool
                bloodPressureReading.syncedWithServer = i.value(forKey: "syncedWithServer") as! Bool
                bloodPressureReading.objectId = i.objectID
                
                bloodPressureReadings.append(bloodPressureReading)
            }
            
            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            print("Execution time: \(executionTime)")
            return bloodPressureReadings
            
        }catch let error as NSError {
            
            print("Could not fetch \(error), \(error.userInfo)")
            return bloodPressureReadings
        }
        
    }
    public func updateBloodPressureReading(bloodPressureReading: BloodPressureReading) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
        fetchRequest.predicate = NSPredicate(format: "id = %@", bloodPressureReading.id)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count != 0 {
                
                let bpObjectToUpdate = results[0]
                bpObjectToUpdate.setValue(bloodPressureReading.source, forKey: "source")
                bpObjectToUpdate.setValue(bloodPressureReading.timestamp, forKey: "timestamp")
                bpObjectToUpdate.setValue(bloodPressureReading.userId, forKey: "userId")
                bpObjectToUpdate.setValue(bloodPressureReading.utcOffset, forKey: "utcOffset")
                bpObjectToUpdate.setValue(bloodPressureReading.lastUpdated, forKey: "lastUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.note, forKey: "note")
                
                bpObjectToUpdate.setValue(bloodPressureReading.dateCreated, forKey: "dateCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.dateUpdated, forKey: "dateUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortTimeCreated, forKey: "shortTimeCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortDateCreated, forKey: "shortDateCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortTimeUpdated, forKey: "shortTimeUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortDateUpdated, forKey: "shortDateUpdated")

                bpObjectToUpdate.setValue(bloodPressureReading.systolic, forKey: "systolic")
                bpObjectToUpdate.setValue(bloodPressureReading.diastolic, forKey: "diastolic")
                bpObjectToUpdate.setValue(bloodPressureReading.heartRate, forKey: "heartRate")
                bpObjectToUpdate.setValue(bloodPressureReading.mood, forKey: "mood")
                bpObjectToUpdate.setValue(bloodPressureReading.activity, forKey: "activity")
                bpObjectToUpdate.setValue(bloodPressureReading.metaIncomplete, forKey: "metaIncomplete")
                bpObjectToUpdate.setValue(bloodPressureReading.validated, forKey: "validated")
                bpObjectToUpdate.setValue(bloodPressureReading.syncedWithServer, forKey: "syncedWithServer")
                
                do {
                    try managedContext.save()
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    public func updateBloodPressureReading(bloodPressureReading: BloodPressureReading, syncedWithServer: Bool) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
        fetchRequest.predicate = NSPredicate(format: "id = %@", bloodPressureReading.id)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count != 0 {
                
                let bpObjectToUpdate = results[0]
                bpObjectToUpdate.setValue(bloodPressureReading.source, forKey: "source")
                bpObjectToUpdate.setValue(bloodPressureReading.timestamp, forKey: "timestamp")
                bpObjectToUpdate.setValue(bloodPressureReading.userId, forKey: "userId")
                bpObjectToUpdate.setValue(bloodPressureReading.utcOffset, forKey: "utcOffset")
                bpObjectToUpdate.setValue(bloodPressureReading.lastUpdated, forKey: "lastUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.note, forKey: "note")
                
                bpObjectToUpdate.setValue(bloodPressureReading.dateCreated, forKey: "dateCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.dateUpdated, forKey: "dateUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortTimeCreated, forKey: "shortTimeCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortDateCreated, forKey: "shortDateCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortTimeUpdated, forKey: "shortTimeUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortDateUpdated, forKey: "shortDateUpdated")

                bpObjectToUpdate.setValue(bloodPressureReading.systolic, forKey: "systolic")
                bpObjectToUpdate.setValue(bloodPressureReading.diastolic, forKey: "diastolic")
                bpObjectToUpdate.setValue(bloodPressureReading.heartRate, forKey: "heartRate")
                bpObjectToUpdate.setValue(bloodPressureReading.mood, forKey: "mood")
                bpObjectToUpdate.setValue(bloodPressureReading.activity, forKey: "activity")
                bpObjectToUpdate.setValue(bloodPressureReading.metaIncomplete, forKey: "metaIncomplete")
                bpObjectToUpdate.setValue(bloodPressureReading.validated, forKey: "validated")
                bpObjectToUpdate.setValue(syncedWithServer, forKey: "syncedWithServer")
                
                do {
                    try managedContext.save()
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    public func updateBloodPressureReadingByObjectID(_ objectID: NSManagedObjectID?, bloodPressureReading: BloodPressureReading, syncedWithServer: Bool) {
        
        if let objId = objectID {
            do {
                let bpObjectToUpdate = try managedContext.existingObject(with: objId)
                
                bpObjectToUpdate.setValue(bloodPressureReading.id, forKey: "id")
                bpObjectToUpdate.setValue(bloodPressureReading.source, forKey: "source")
                bpObjectToUpdate.setValue(bloodPressureReading.timestamp, forKey: "timestamp")
                bpObjectToUpdate.setValue(bloodPressureReading.userId, forKey: "userId")
                bpObjectToUpdate.setValue(bloodPressureReading.utcOffset, forKey: "utcOffset")
                bpObjectToUpdate.setValue(bloodPressureReading.lastUpdated, forKey: "lastUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.note, forKey: "note")
                
                bpObjectToUpdate.setValue(bloodPressureReading.dateCreated, forKey: "dateCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.dateUpdated, forKey: "dateUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortTimeCreated, forKey: "shortTimeCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortDateCreated, forKey: "shortDateCreated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortTimeUpdated, forKey: "shortTimeUpdated")
                bpObjectToUpdate.setValue(bloodPressureReading.shortDateUpdated, forKey: "shortDateUpdated")

                bpObjectToUpdate.setValue(bloodPressureReading.systolic, forKey: "systolic")
                bpObjectToUpdate.setValue(bloodPressureReading.diastolic, forKey: "diastolic")
                bpObjectToUpdate.setValue(bloodPressureReading.heartRate, forKey: "heartRate")
                bpObjectToUpdate.setValue(bloodPressureReading.mood, forKey: "mood")
                bpObjectToUpdate.setValue(bloodPressureReading.activity, forKey: "activity")
                bpObjectToUpdate.setValue(bloodPressureReading.metaIncomplete, forKey: "metaIncomplete")
                bpObjectToUpdate.setValue(bloodPressureReading.validated, forKey: "validated")
                bpObjectToUpdate.setValue(syncedWithServer, forKey: "syncedWithServer")
                
                do {
                    try managedContext.save()
                }catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    public func deleteBloodPressureReadingFromCoreData(readingId: String) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOBloodPressureReading")
        fetchRequest.predicate = NSPredicate(format: "id = %@", readingId)
        
        do {
            
            let results = try managedContext.fetch(fetchRequest)
            if results.count != 0 {
                
                for result in results {
                    managedContext.delete(result)
                }
            }
            
            do {
                try managedContext.save()
            }catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }catch let error as NSError {
            print("Could not delete reading with id: \(readingId) \(error), \(error.userInfo)")
        }
        
    }
    
    public func deleteAllFromCoreData(){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MOReading")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try managedContext.execute(deleteRequest)
            print("Deleted MOReading")
        } catch let error as NSError {
            // TODO: handle the error
            print("Error deleting MOReading: \(error.localizedDescription)")
        }
        
        do {
            try managedContext.save()
            
        }catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            managedContext.rollback()
        }
    }
}
