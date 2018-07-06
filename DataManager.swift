//
//  DataManager.swift
//  FTN
//
//  Created by Marko Stajic on 11/15/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

/// Class uses RestManager, for REST API. One endpoint - one method in class.
/// Class is also layer between server and CoreData - it synchronizes data on remote server and in local database.
public typealias CompletionHandlerClosureType = (_ success: Bool) -> ()

public class DataManager {

    // MARK: - Properties
    let queue:DispatchQueue	= DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    let group:DispatchGroup	= DispatchGroup()
    
    open static let sharedInstance = DataManager()
    let defaults = UserDefaults.standard
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    init() {
    }
    
    /**
     Get blood pressure readings list from server.
     
     - Parameter url:           Endpoint url, required for paging.
     - Parameter completion:    Function that is called after response has been received.
     
     */
    public func getBloodPressureReadings(url: String?, completion: @escaping (BloodPressureReadingsResponse)->Void){
        
        let url = url ?? RestUrl.bloodPressureReadings
        RestManager.sharedInstance.get(url: url, completion: { (json, data, success) in
            
            if success {
                if let jsonData = json, let json = jsonData as? [String : Any], let bloodPressureList = ParseManager.sharedInstance.parseBloodPressureReadings(json) {
                    
                    completion(BloodPressureReadingsResponse(success: true, bloodPressureReadings: bloodPressureList, error: nil, message: ErrorMessages.noError))
                }else{
                    completion(BloodPressureReadingsResponse(success: false, bloodPressureReadings: nil, error: nil, message: ErrorMessages.parsingError))
                }
            }else{
                if let errorData = data {
                    completion(BloodPressureReadingsResponse(success: false, bloodPressureReadings: nil, error: ParseManager.sharedInstance.parseErrorDataToGenericError(data: errorData), message: ErrorMessages.knownError))
                }else{
                    completion(BloodPressureReadingsResponse(success: false, bloodPressureReadings: nil, error: nil, message: ErrorMessages.unknownError))
                }
            }
        })
    }
    /**
     Add blood pressure reading on server.
     
     - Parameter bloodPressureReading: Blood pressure reading object.
     - Parameter update:               If update is true it means that reading was previously saved in core data, but not uploaded to server, so it needs to be updated with reading's id in core data.
     - Parameter completion:           Function that is called after response has been received.
     
     */
    public func postBloodPressureReading(bloodPressureReading: BloodPressureReading, update: Bool=false, completion: @escaping (SingleBloodPressureReadingResponse)->Void){
        let url = RestUrl.bloodPressureReadings
        let parameters = bloodPressureReading.patchJSON()
        
        RestManager.sharedInstance.post(url: url, parameters: parameters) { (json, data, success) in
            if success {
                if let jsonData = json, let json = jsonData as? [String : Any], let bloodPressure = ParseManager.sharedInstance.parseSingleBloodPressureReading(json) {
                    
                    if update {
                        self.updateBloodPressureReadingByObjectID(bloodPressureReading.objectId,bloodPressureReading: bloodPressure, syncedWithServer: true)
                    }else{
                        self.saveBloodPressureToCoreData(bloodPressureReading: bloodPressure, syncedWithServer: true)
                    }
                    completion(SingleBloodPressureReadingResponse(success: true, bloodPressureReading: bloodPressure, error: nil, message: ErrorMessages.noError))
                }else{
                    
                    self.saveBloodPressureToCoreData(bloodPressureReading: bloodPressureReading, syncedWithServer: false)
                    completion(SingleBloodPressureReadingResponse(success: false, bloodPressureReading: nil, error: nil, message: ErrorMessages.parsingError))
                }
            }else{
                if let errorData = data {
                    
                    self.saveBloodPressureToCoreData(bloodPressureReading: bloodPressureReading, syncedWithServer: false)
                    completion(SingleBloodPressureReadingResponse(success: false, bloodPressureReading: nil, error: ParseManager.sharedInstance.parseErrorDataToGenericError(data: errorData), message: ErrorMessages.knownError))
                }else{
                    
                    self.saveBloodPressureToCoreData(bloodPressureReading: bloodPressureReading, syncedWithServer: false)
                    completion(SingleBloodPressureReadingResponse(success: false, bloodPressureReading: nil, error: nil, message: ErrorMessages.unknownError))
                }
            }
        }

    }
    /**
     Edit blood pressure reading on server.
     
     - Parameter bloodPressureReading: Blood pressure reading object.
     - Parameter completion:           Function that is called after response has been received.
     
     */
    public func editBloodPressureReading(bloodPressureReading: BloodPressureReading, completion: @escaping (SingleBloodPressureReadingResponse)->Void){
        let url = RestUrl.bloodPressureReadings + ("/\(bloodPressureReading.id)")
        
        var parameters : [String:Any]!
        
        if bloodPressureReading.validated {
            parameters = bloodPressureReading.patchJSONForAutomaticReading()
        }else{
            parameters = bloodPressureReading.patchJSON()
        }
        
        RestManager.sharedInstance.patch(url: url, parameters: parameters) { (json, data, success) in
            if success {
                if let jsonData = json, let json = jsonData as? [String : Any], let bloodPressure = ParseManager.sharedInstance.parseSingleBloodPressureReading(json) {
                    
                    self.updateBloodPressureReading(bloodPressureReading: bloodPressure, syncedWithServer: true)
                    completion(SingleBloodPressureReadingResponse(success: true, bloodPressureReading: bloodPressure, error: nil, message: ErrorMessages.noError))
                }else{
                    
                    self.updateBloodPressureReading(bloodPressureReading: bloodPressureReading, syncedWithServer: false)
                    completion(SingleBloodPressureReadingResponse(success: false, bloodPressureReading: nil, error: nil, message: ErrorMessages.parsingError))
                }
            }else{
                if let errorData = data {
                    
                    self.updateBloodPressureReading(bloodPressureReading: bloodPressureReading, syncedWithServer: false)
                    completion(SingleBloodPressureReadingResponse(success: false, bloodPressureReading: nil, error: ParseManager.sharedInstance.parseErrorDataToGenericError(data: errorData), message: ErrorMessages.knownError))
                }else{
                    
                    self.updateBloodPressureReading(bloodPressureReading: bloodPressureReading, syncedWithServer: false)
                    completion(SingleBloodPressureReadingResponse(success: false, bloodPressureReading: nil, error: nil, message: ErrorMessages.unknownError))
                }
            }
        }
    }
    /**
     Delete blood pressure reading from server.
     
     - Parameter readingId:     Blood pressure reading ID.
     - Parameter completion:    Function that is called after response has been received.
     
     */
    public func deleteBloodPressureReading(readingId: String, completion: @escaping(GeneralResponse)->Void){
        let url = RestUrl.bloodPressureReadings + ("/\(readingId)")
        
        RestManager.sharedInstance.delete(url: url) { (json, data, success) in
            if success {
                self.deleteBloodPressureReadingFromCoreData(readingId: readingId)
                completion(GeneralResponse(success: true, error: nil, message: "Blood pressure reading deleted!"))
            }else{
                if let errorData = data {
                    completion(GeneralResponse(success: false, error: ParseManager.sharedInstance.parseErrorDataToGenericError(data: errorData), message: ErrorMessages.knownError))
                }else{
                    completion(GeneralResponse(success: false, error: nil, message: ErrorMessages.unknownError))
                }
            }
        }
    }
}

extension DataManager {
    public func getAllBloodPressureFromServer(url: String?, readings: [BloodPressureReading]?, completionHandler: CompletionHandlerClosureType?) {
        var breadings = readings ?? [BloodPressureReading]()
        
        group.enter()
        self.getBloodPressureReadings(url: url) { (completion) in
            
            self.group.leave()
            if completion.success {
                
                for i in completion.bloodPressureReadings!.bloodPressureReadings {
                    breadings.append(i)
                }
                
                if let nextUrl = completion.bloodPressureReadings!.next {
                    print("Next BP url: \(nextUrl)")
                    let next = nextUrl.replacingOccurrences(of: "http://", with: "https://")
                    self.getAllBloodPressureFromServer(url: next, readings: breadings, completionHandler: completionHandler)
                }else{
                    print("BP Readings count: \(breadings.count)")
                    for (_, r) in breadings.enumerated() {
                        self.saveBloodPressureToCoreData(bloodPressureReading: r, syncedWithServer: true)
                        
                    }
                    self.group.notify(queue: self.queue) {
                        // This closure will be executed when all tasks are complete
                        print("All tasks complete - ALL BLOOD PRESSURE RESULTS FETCHED")
                        completionHandler?(true)
                    }
                }
            }else{
                self.group.notify(queue: self.queue) {
                    // This closure will be executed when all tasks are complete
                    print("All tasks NOT complete - NOT ALL BLOOD PRESSURE RESULTS FETCHED")
                    completionHandler?(false)
                }
            }
        }
        
    }
}
