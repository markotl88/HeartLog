//
//  FTNError.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper

public class DmsError : Mappable {
    
    var errorMessage : String = ""
    var errorField : String = ""
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        errorMessage <- map["message"]
        errorField <- map["field"]
    }
    
    func toString() -> String {
        return "\nError message: \(errorMessage)\nError field: \(errorField)"
    }
}

