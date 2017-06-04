//
//  UserService.swift
//  MacResearch
//
//  Created by Simon Rowlands on 17/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import Foundation
import Alamofire

class UserService: NSObject {
    
    static let sharedInstance = UserService()
    var currentUser: User?
    
    
    static func signIn(completion: @escaping (NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        
        Alamofire.request(apiURL + userEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(let response):
                if let res = response as? NSDictionary {

                    if let json = res["errors"] as? [[String: AnyObject]],
                    let errors = json[0] as [String: AnyObject]?,
                    let status = errors["status"] as? NSNumber,
                    let messages = errors["messages"] as? [NSObject: AnyObject] {
                        
                    completion(NSError(domain: "UserService", code: status.intValue, userInfo: messages))
                        
                    } else if let json = res["data"] as? [String: AnyObject] {
                        
                        sharedInstance.currentUser?.id = json["id"] as? String
                        sharedInstance.currentUser?.name = json["name"] as? String
                        sharedInstance.currentUser?.email = json["email"] as? String
                        
                        if let role = json["roles"] as? Array<String>{
                            if role.first == "healthcare_professional" {
                                sharedInstance.currentUser?.role = .healthCareProfessional
                            } else {
                                sharedInstance.currentUser?.role = .volunteer
                            }
                        }
                        
                        if let profileJson = json["profile"] as? [String:AnyObject], !profileJson.isEmpty {
                    
                            sharedInstance.currentUser?.address = profileJson["address"] as? String
                            sharedInstance.currentUser?.townCity = profileJson["town_city"] as? String
                            sharedInstance.currentUser?.county = profileJson["county"] as? String
                            sharedInstance.currentUser?.postcode = profileJson["postcode"] as? String
                            sharedInstance.currentUser?.telephoneNumber = profileJson["telephone_number"] as? String
                            sharedInstance.currentUser?.comments = profileJson["comments"] as? String
                            
                            if let jsonBool = profileJson["subscribed_to_newsletter"] as? Bool {
                                sharedInstance.currentUser?.subscribedToNewsletter = jsonBool
                            }
                            
                            if let jsonBool = profileJson["notification_settings"] as? Bool {
                                sharedInstance.currentUser?.notificationSetting = jsonBool
                            }

                        }
            
                        saveCurrentUser()
                        
                        completion(nil)
                        
                    } else {
                        
                        if let responseDict = response as? [String: String] {
                            completion(NSError(domain: "UserService", code: 0, userInfo: responseDict))
                        } else {
                            completion(NSError(domain: "UserService", code: 0, userInfo: nil))
                        }
                    }
                    
                }else{
                    completion(NSError(domain: "UserService", code: 0, userInfo: nil))
                }
            case.failure(let error):
                completion(error as NSError)
                break
            }
            
        }
        
    }
    
    static func updateUser(params: [String: Any], completion: @escaping (NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        
        Alamofire.request(apiURL + userUpdateEndpoint, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            response in
            
            switch response.result   {
            case .success(let response):
                
                if let res = response as? NSDictionary {
                   if let json = res["errors"] as? [[String: AnyObject]],
                        let errors = json[0] as [String: AnyObject]?,
                        let status = errors["status"] as? NSNumber,
                        let messages = errors["messages"] as? [NSObject: AnyObject] {
                    
                        completion(NSError(domain: "UserService", code: status.intValue, userInfo: messages))
                    
                    }else if let json = res["data"] as? [String: AnyObject] {
                    
                        sharedInstance.currentUser?.id = json["id"] as? String
                        sharedInstance.currentUser?.name = json["name"] as? String
                        sharedInstance.currentUser?.email = json["email"] as? String
                    
                        if let role = json["roles"] as? Array<String>{
                            if role.first == "healthcare_professional" {
                                sharedInstance.currentUser?.role = .healthCareProfessional
                            } else {
                                sharedInstance.currentUser?.role = .volunteer
                            }
                        }
                    
                        if let profileJson = json["profile"] as? [String:AnyObject], !profileJson.isEmpty {
                        
                            sharedInstance.currentUser?.address = profileJson["address"] as? String
                            sharedInstance.currentUser?.townCity = profileJson["town_city"] as? String
                            sharedInstance.currentUser?.county = profileJson["county"] as? String
                            sharedInstance.currentUser?.postcode = profileJson["postcode"] as? String
                            sharedInstance.currentUser?.telephoneNumber = profileJson["telephone_number"] as? String
                            sharedInstance.currentUser?.comments = profileJson["comments"] as? String
                        
                            if let jsonBool = profileJson["subscribed_to_newsletter"] as? Bool {
                                sharedInstance.currentUser?.subscribedToNewsletter = jsonBool
                            }
                        
                            if let jsonBool = profileJson["notification_settings"] as? Bool {
                                sharedInstance.currentUser?.notificationSetting = jsonBool
                            }
                        
                        }
                    
                        saveCurrentUser()
                    
                        completion(nil)

                   } else {
                    
                        if let responseDict = response as? [String: String] {
                            completion(NSError(domain: "UserService", code: 0, userInfo: responseDict))
                        } else {
                            completion(NSError(domain: "UserService", code: 0, userInfo: nil))
                        }
                   }
                    
                    
                } else{
                    completion(NSError(domain: "UserService", code: 0, userInfo: nil))
                }
                
                break
                
            case .failure(let error):
                
                completion(error as NSError?)
                debugPrint(error)
                
                break
            }
        }
    }
    
    static func getAccessToken(email: String, password:String, completion: @escaping (NSError?)->()) {
        
        let params: [String: Any] = [
            "grant_type": "password",
            "client_id": clientID,
            "client_secret": clientSecret,
            "username": email,
            "password": password,
            "scope": "*"
        ]
        
        Alamofire.request(oauthURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
            .responseJSON { response in
                
                switch response.result {
                case .success(let response):
                    
                    if let res = response as? NSDictionary {
                        if let json = res["error"] as? [[String: AnyObject]] {
                            let errors = json[0] as [String: AnyObject]?
                            let messages = errors?["message"] as? [NSObject: AnyObject]
                            let status = errors?["status"] as? NSNumber
                            
                            completion(NSError(domain: "UserService", code: status?.intValue ?? 0, userInfo: messages))
                            
                        } else if let json = res as? [String: AnyObject],
                            let accessToken = json["access_token"] as? String { /*,
                            let refreshToken = json["refresh_token"] as? String {
                            */
                            
                            sharedInstance.currentUser = User(email: email, accessToken: accessToken)//, refreshToken: refreshToken)
                            completion(nil)

                        } else {
                            if let responseDict = response as? [String: String] {
                                completion(NSError(domain: "UserService", code: 0, userInfo: responseDict))
                            } else {
                                completion(NSError(domain: "UserService", code: 0, userInfo: nil))
                            }
                        }
                    }
                    
                    break
                case .failure(let error):
                        
                    debugPrint(error)
                    break
                }
        }
    }
    
    static func registerUser(params: [String: Any], completion: @escaping (NSError?)->()) {
        
        Alamofire.request(apiURL + registerEndpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            response in
            
            switch response.result   {
            case .success(let response):
                
                if let res = response as? NSDictionary {
                    if let json = res["errors"] as? [[String: AnyObject]],
                        let errors = json[0] as [String: AnyObject]?,
                        let status = errors["status"] as? NSNumber,
                        let messages = errors["messages"] as? [NSObject: AnyObject] {
                        
                        completion(NSError(domain: "UserService", code: status.intValue, userInfo: messages))
                        
                    }else{
                        
                        if let res = response as? NSDictionary, let json = res["data"] as? [String: AnyObject], let id = json["id"] as? String {
                            UserService.sharedInstance.currentUser?.id = id
                            
                            sharedInstance.currentUser?.id = json["id"] as? String
                            sharedInstance.currentUser?.name = json["name"] as? String
                            sharedInstance.currentUser?.email = json["email"] as? String
                            
                            if let role = json["roles"] as? Array<String>{
                                if role.first == "healthcare_professional" {
                                    sharedInstance.currentUser?.role = .healthCareProfessional
                                } else {
                                    sharedInstance.currentUser?.role = .volunteer
                                }
                            }
                            
                            if let profileJson = json["profile"] as? [String:AnyObject], !profileJson.isEmpty {
                                
                                sharedInstance.currentUser?.address = profileJson["address"] as? String
                                sharedInstance.currentUser?.townCity = profileJson["town_city"] as? String
                                sharedInstance.currentUser?.county = profileJson["county"] as? String
                                sharedInstance.currentUser?.postcode = profileJson["postcode"] as? String
                                sharedInstance.currentUser?.telephoneNumber = profileJson["telephone_number"] as? String
                                sharedInstance.currentUser?.comments = profileJson["comments"] as? String
                                
                                if let jsonBool = profileJson["subscribed_to_newsletter"] as? Bool {
                                    sharedInstance.currentUser?.subscribedToNewsletter = jsonBool
                                }
                                
                                if let jsonBool = profileJson["notification_settings"] as? Bool {
                                    sharedInstance.currentUser?.notificationSetting = jsonBool
                                }
                                
                            }
                        
                            saveCurrentUser()

                        }
                        
                        UserService.getAccessToken(email: params["email"]! as! String, password: params["password"]! as! String, completion: {
                            (error) in
                            
                            if let error = error {
                                completion(error)
                                return
                            }else{
                                if let _ = sharedInstance.currentUser?.accessToken {
                                    UserService.signIn(completion: {
                                        (error) in
                                        if let error = error {
                                            completion(error)
                                            return
                                        }else{
                                            completion(nil)
                                            return
                                        }
                                    })
                                }
                            }
                        })
                        
                    }
                }
                
                break
                
            case .failure(let error):
                
                completion(error as NSError?)
                debugPrint(error)
                
                break
            }
        }
    }
}

extension UserService {
    
    static func saveCurrentUser() {
        
        UserDefaults.standard.setValue(UserService.sharedInstance.currentUser?.toJSON(), forKey: kSavedUser)
        UserDefaults.standard.synchronize()
    }
    
    static func loadCurrentUser() {
        
        if let json = UserDefaults.standard.value(forKey: kSavedUser) as? [String: String] {
            UserService.sharedInstance.currentUser = User(json: json)
        }
    }
    
    static func logOut() {
        
        UserService.sharedInstance.currentUser = nil
        saveCurrentUser()
    }
}
