//
//  FTNGenericError.swift
//  FTN
//
//  Created by Marko Stajic on 11/15/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper

public class DMSGenericError: Mappable {
    
    var errorType : String = ""
    var errors : [DmsError] = [DmsError]()
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        errorType <- map["error_type"]
    }
    
    func toString() -> String {
        
        var message = ""
        for error in errors {
            message += "\n" + error.errorField + " • " + error.errorMessage
        }
        
        return "\nError type: \(errorType) \(message)"
    }

}

