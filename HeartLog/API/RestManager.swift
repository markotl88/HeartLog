//
//  RestManager.swift
//  DPS
//
//  Created by Qidenus on 1/8/18.
//  Copyright © 2018 Qidenus. All rights reserved.
//

import Alamofire
import EVReflection

/// Class communicates with server. Contains all functions needed for communication with server.
/// It is used by DataManager.swift
class RestManager {
    
    private let manager: Alamofire.SessionManager
    var headers : HTTPHeaders!
    var token: String = ""
    var authToken: String = ""
    
    // MARK: - Lifcycle
    init(token: String?, authorizedUserToken: String?) {
        
        // Alamofire request configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 180
        let cooks = HTTPCookieStorage.shared
        
        configuration.httpCookieStorage = cooks
        configuration.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        manager = Alamofire.SessionManager(configuration: configuration)
        
        if let token = token {
            self.headers = ["Auth":token]
            self.token = token
        }else{
            self.headers = [String:String]()
        }
        
        if let token = authorizedUserToken, token != FAKE_AUTHORIZATION_TOKEN {
            self.authToken = token
            self.headers["Authorization"] = token
        }
    }
    
    /**
     Get HTTP request.
     
     - Parameter url:           Endpoint url.
     - Parameter completion:    Function that is called after response has been received, json - json data if response is successful, errorData - if respnse is not successful, success - response successful or not.
     
     */
    func get(url: String, encode:Bool?=true, completion: @escaping (_ success: Bool, _ jsonResponse: Data?) -> ()) {
        
        guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed), let encodedUrl = URL(string: encodedUrlString) else {
            completion(false, nil)
            print("RestManager error GET - URL not valid: \(url)")
            return
        }
        
        let u = Alamofire.request(encodedUrl, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers).debugLog().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                completion(true, response.data)
            case .failure(let error):
                print("Validation Not Successful")
                print(error)
                completion(false, nil)
            }
            }
        print("cURL: \(String(describing: u.request?.cURL))")
    }
    
    /**
     Post HTTP request.
     
     - Parameter url:           Endpoint url.
     - Parameter parameters:    JSON Parameters - body.
     - Parameter completion:    Function that is called after response has been received, json - json data if response is successful, errorData - if respnse is not successful, success - response successful or not.
     
     */
    
    func post(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ success: Bool, _ jsonResponse: Data?) -> ()) {
        
        guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed), let encodedUrl = URL(string: encodedUrlString) else {
            completion(false, nil)
            print("RestManager error POST - URL not valid: \(url)")
            return
        }
        
        let u = Alamofire.request(encodedUrl, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).debugLog().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                completion(true, response.data)
            case .failure(let error):
                print("Validation Not Successful")
                print(error)
                completion(false, nil)
            }
            }
        print("cURL: \(String(describing: u.request?.cURL))")

    }
    
    func put(url: String, parameters: [String:Any]?=nil, completion: @escaping (_ success: Bool, _ jsonResponse: Data?) -> ()) {
        
        guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed), let encodedUrl = URL(string: encodedUrlString) else {
            completion(false, nil)
            print("RestManager error PUT - URL not valid: \(url)")
            return
        }
        
        Alamofire.request(encodedUrl, method: HTTPMethod.put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                completion(true, response.data)
            case .failure(let error):
                print("Validation Not Successful")
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func download(url:String, progCompletion: @escaping (_ progress: Double)->Void, completion: @escaping (_ fileName: URL?, _ success: Bool) -> Void) {
        
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) else {
            print("Download link invalid!")
            return
        }
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        self.manager.download(encodedUrl, to: destination)
            .downloadProgress { progress in
                progCompletion(progress.fractionCompleted)
            }
            .responseData { (response) in
                
                print("Response: \(response)")
                switch response.result {
                case .success( _):
                    completion(response.destinationURL, true)
                case .failure:
                    completion(nil, false)
                }
                
        }
    }
    
    func temporaryPayment(url: String, packageId: Int, priceId: Int, username: String, completion: @escaping (_ success: Bool, _ jsonResponse: Data?) -> ()) {
        
        let headers = [
            "Auth": self.token,
            "Authorization": self.authToken,
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache"
        ]
        
        let postData = NSMutableData(data: "package_id=\(packageId)".data(using: String.Encoding.utf8)!)
        postData.append("&package_price_id=\(priceId)".data(using: String.Encoding.utf8)!)
        postData.append("&msisdn=\(username)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            print("cURL for payment: \((request as URLRequest).cURL)")
            
            if (error != nil) {
                print("Error: \(error?.localizedDescription ?? "")")
                completion(false, nil)
            } else {
                if let data = data {
                    completion(true, data)
                }else{
                    completion(false, nil)
                }
                let httpResponse = response as? HTTPURLResponse
                print("Http response: \(String(describing: httpResponse))")
            }
        })
        
        dataTask.resume()
    }
    
    func temporaryChangePassword(url: String, currentPassword: String, newPassword: String, completion: @escaping (_ success: Bool, _ jsonResponse: Data?) -> ()) {
        
        let headers = [
            "Auth": self.token,
            "Authorization": self.authToken,
            "Content-Type": "application/x-www-form-urlencoded",
            "Cache-Control": "no-cache"
        ]
        
        let postData = NSMutableData(data: "old_password=\(currentPassword)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(newPassword)".data(using: String.Encoding.utf8)!)
        postData.append("&repeat_password=\(newPassword)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            print("cURL for payment: \((request as URLRequest).cURL)")
            
            if (error != nil) {
                print("Error: \(error?.localizedDescription ?? "")")
                completion(false, nil)
            } else {
                if let data = data {
                    completion(true, data)
                }else{
                    completion(false, nil)
                }
                let httpResponse = response as? HTTPURLResponse
                print("Http response: \(String(describing: httpResponse))")
            }
        })
        
        dataTask.resume()
    }

}

extension Request {
    public func debugLog() -> Self {
        debugPrint(self)
        return self
    }
}

