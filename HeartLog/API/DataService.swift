//
//  DataService.swift
//  DPS
//
//  Created by Qidenus on 1/10/18.
//  Copyright © 2018 Qidenus. All rights reserved.
//

import UIKit

let UNAUTHORIZED = "Unauthorized"
let FAKE_AUTHORIZATION_TOKEN = "FAKE_AUTHORIZATION_TOKEN"

struct Endpoint {
    
    // Live server:
    static let baseUrl = "http://192.168.64.217:3000/"
    static let posts = baseUrl + "posts/%d"
    static let comments = baseUrl + "comments"
    static let profile = baseUrl + "profile"
}

class DataService {
    
    static var authToken: String = "Basic SUM2SkVtOXJNeW1uTlhld3EyY0lTUXMwWDp2MWY4dWd5RG1sbUlJeDF4bWhJZmdIdVRZ"
    static var authorizedUserToken: String?
    static var sessionKey: String?
    static var translateDictionary: [String:Any]?
    
    //Shared data
    
    static func getPostWithId(id: Int, completion: @escaping (_ post: Post?, _ errorMessage: String) -> ()) {
        
        let url = String(format: Endpoint.posts, id)
        
        RestManager(token: self.authToken, authorizedUserToken: authorizedUserToken).get(url: url) { (success, data) in
            if success, let data = data {
                let post = Post(data: data)
                completion(post, "getPostWithId - success!")
            }else {
                completion(nil, "getPostWithId - error!")
            }
        }
    }
}
