//
//  RestManager.swift
//  FTN
//
//  Created by Marko Stajic on 11/15/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Alamofire
import ObjectMapper

/// Class communicates with server. Contains all functions needed for communication with server.
/// It is used by DataManager.swift
public class RestManager {
    
    static let sharedInstance = RestManager()
    private let manager: Alamofire.SessionManager
    var headers : HTTPHeaders!
    var authorizationToken = "8f1328321a26a71dee05e0b66fe8ecfb4f2c9fc5"
    
    // MARK: - Lifecycle
    init() {
        
        // Alamofire request configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        let cooks = HTTPCookieStorage.shared
        
        configuration.httpCookieStorage = cooks
        configuration.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        manager = Alamofire.SessionManager(configuration: configuration)
        
        headers = [
            "Accept": "application/json"
        ]
        
    }
    
    // MARK: - HTTP Request
    /**
     Update authorization token, from this moment all server calls will have this token in header.
     
     - Parameter token:    New authorization token, without "Token" prefix.
     
     */
    public func updateAuthToken(token: String) {
        authorizationToken = token
        
        headers = [
            "Authorization": "Token " + authorizationToken,
            "Accept": "application/json"
        ]
        print("Headers: \(headers)")
    }
    
    /**
     Post HTTP request.
     
     - Parameter url:           Endpoint url.
     - Parameter parameters:    JSON Parameters - body.
     - Parameter completion:    Function that is called after response has been received, json - json data if response is successful, errorData - if respnse is not successful, success - response successful or not.
     
     */
    public func post(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        self.manager.request(encodedUrl!, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful!\nError: \(error.localizedDescription)")
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    /**
     Get HTTP request.
     
     - Parameter url:           Endpoint url.
     - Parameter completion:    Function that is called after response has been received, json - json data if response is successful, errorData - if respnse is not successful, success - response successful or not.
     
     */
    public func get(url: String, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        self.manager.request(encodedUrl!, method: HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).validate().debugLog()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful!\nError: \(error)")
                    
                    
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    /**
     Patch HTTP request.
     
     - Parameter url:           Endpoint url.
     - Parameter parameters:    JSON Parameters - body.
     - Parameter completion:    Function that is called after response has been received, json - json data if response is successful, errorData - if respnse is not successful, success - response successful or not.
     
     */
    public func patch(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        self.manager.request(encodedUrl!, method: HTTPMethod.patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful!\nError: \(error)")
                    
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    /**
     Delete HTTP request.
     
     - Parameter url:           Endpoint url.
     - Parameter completion:    Function that is called after response has been received, json - json data if response is successful, errorData - if respnse is not successful, success - response successful or not.
     
     */
    public func delete(url: String, completion: @escaping (_ json: Any?, _ errorData: Data?, _ success: Bool) -> ()) {
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        self.manager.request(encodedUrl!, method: HTTPMethod.delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON(completionHandler: { (response) -> Void in
                
                switch response.result {
                case .success:
                    print("Alamofire Automatic validation successful for deletion")
                    completion(response.result.value, nil, true)
                    
                case .failure(let error):
                    
                    print("Alamofire Automatic validation not successful for deletion!\nError: \(error)")
                    
                    if let data = response.data {
                        completion(nil, data, false)
                    }else{
                        completion(nil, nil, false)
                    }
                }
            })
    }
    
    
    
}

