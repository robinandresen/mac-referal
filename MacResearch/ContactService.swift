//
//  ContactService.swift
//  MacResearch
//
//  Created by Billy on 2/2/17.
//  Copyright © 2017 Appitized. All rights reserved.
//

import Foundation
import Alamofire

class ContactService: NSObject {
    
    static func getContactArray(completion: @escaping (Array<[String: AnyObject]>?, NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        
        
        Alamofire.request(apiURL + contactEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(let response):
                if let res = response as? NSDictionary {
                    
                    if let json = res["errors"] as? [[String: AnyObject]],
                        let errors = json[0] as [String: AnyObject]?,
                        let status = errors["status"] as? NSNumber,
                        let messages = errors["messages"] as? [NSObject: AnyObject] {
                        
                        completion(nil ,NSError(domain: "ContactService", code: status.intValue, userInfo: messages))
                        
                    } else if let json = res["data"] as? Array<[String: AnyObject]> {
                        
                        completion(json, nil)
                        
                    } else {
                        
                        if let responseDict = response as? [String: String] {
                            completion(nil, NSError(domain: "ContactService", code: 0, userInfo: responseDict))
                        } else {
                            completion(nil, NSError(domain: "ContactService", code: 0, userInfo: nil))
                        }
                    }
                    
                }else{
                    completion(nil, NSError(domain: "ContactService", code: 0, userInfo: nil))
                }
            case.failure(let error):
                completion(nil, error as NSError)
                break
            }
            
        }
    }
    
    static func addNewContact(contact: User, completion: @escaping ([String: AnyObject]?, NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        
        var json : [String: String] = [:]
        
        json["email"] = contact.email
        
        Alamofire.request(apiURL + contactEndpoint, method: .post, parameters: json, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            (response) in
       
            
            switch response.result {
                
            case .success(let response):
                if let res = response as? NSDictionary {
                    
                    if let error = res["error"] as? [String: AnyObject]
                        {
                        
                        completion(nil ,NSError(domain: "ContactService", code: 422, userInfo: error))
                        
                    } else if let json = res["data"] as? [String: AnyObject] {
                        
                        completion(json, nil)
                        
                    } else {
                        
                        if let error = res["error"] as? [String: String] {
                            completion(nil, NSError(domain: "ContactService", code: 409, userInfo: error))
                        } else {
                            completion(nil, NSError(domain: "ContactService", code: 0, userInfo: nil))
                        }
                    }
                    
                }else{
                    completion(nil, NSError(domain: "ContactService", code: 0, userInfo: nil))
                }
            case.failure(let error):
                completion(nil, error as NSError)
                break
            }
            
        }
    }

    
    
}

