//
//  ReadingList.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation
import ObjectMapper

public class ReadingList: Mappable {
    
    var count : UInt = 0
    var next : String?
    var previous : String?
    
    public required init?(map: Map) {

    }
    
    public func mapping(map: Map) {
        
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        
    }
    
}
