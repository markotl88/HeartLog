//
//  ParseManager.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper

/// Class uses ObjectMapper, it maps JSON representation from server response to local data model.
public class ParseManager {
    
    // MARK: - Properties
    open static let sharedInstance = ParseManager()
    let defaults = UserDefaults.standard
    
    init() {
    }
    
    /**
     Parse error data.
     
     - Parameter data:   Error binary representation.
     - Returns:          DMSGenericError object or nil.
     
     */
    public func parseErrorDataToGenericError(data: Data) -> DMSGenericError? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            if let JSON = json {
                
                let genericError = self.parseGenericError(JSON)
                
                if let errors = JSON["errors"] as? [[String:Any]] {
                    genericError?.errors = self.parseDMSErrorArray(errors)
                    return genericError
                }
            }
        }catch let error as NSError {
            print(error)
        }
        return nil
    }
    /**
     Parse error data.
     
     - Parameter jsonDictionary:   Error JSON representation.
     - Returns:                    DMSGenericError object or nil.
     
     */
    open func parseGenericError(_ jsonDictionary: [String:Any]) -> DMSGenericError?{
        if let error = Mapper<DMSGenericError>().map(JSONObject: jsonDictionary){
            return error
        }else{
            return nil
        }
    }
    /**
     Parse DMSError data.
     
     - Parameter jsonDictionaryArray:   DmsError JSON representation array.
     - Returns:                    DmsError object array.
     
     */
    public func parseDMSErrorArray(_ jsonDictionaryArray: [[String:Any]]) -> [DmsError] {
        var errorsArray = [DmsError]()
        for jsonDictionary in jsonDictionaryArray {
            if let err = Mapper<DmsError>().map(JSONObject: jsonDictionary){
                errorsArray.append(err)
            }
        }
        return errorsArray
    }
    public func parseBloodPressureReadings(_ jsonDictionary: [String:Any]) -> BloodPressureReadingList? {
        if let bloodPressureReadingList = Mapper<BloodPressureReadingList>().map(JSONObject: jsonDictionary){
            return bloodPressureReadingList
        }else{
            return nil
        }
    }
    /**
     Parse Blood pressure reading data.
     
     - Parameter jsonDictionary:   BloodPressureReading JSON representation.
     - Returns:                    Single BloodPressureReading object or nil.
     
     */
    public func parseSingleBloodPressureReading(_ jsonDictionary: [String:Any]) -> BloodPressureReading? {
        if let bloodPressureReading = Mapper<BloodPressureReading>().map(JSONObject: jsonDictionary){
            return bloodPressureReading
        }else{
            return nil
        }
    }
}
