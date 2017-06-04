//
//  User.swift
//  MacResearch
//
//  Created by Simon Rowlands on 17/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

enum Role {
    case volunteer
    case healthCareProfessional
}

class User: NSObject {
    
    var email: String?
    var accessToken: String?
    
    var id: String?
    var name: String?
    
    var address: String?
    var townCity: String?
    var county: String?
    var postcode: String?
    var telephoneNumber: String?
    var comments: String?
    var subscribedToNewsletter: Bool?
    var notificationSetting: Bool?
    
    var role: Role = .volunteer
    
    init(json: [String: String]) {
        
        email = json["email"]
        accessToken = json["access_token"]
        
        id = json["id"]
        name = json["name"]
        address = json["address"]
        townCity = json["town_city"]
        county = json["county"]
        postcode = json["postcode"]
        telephoneNumber = json["telephone_number"]
        comments = json["comments"]
        
        if json["subscribed_to_newsletter"] == "false" {
            subscribedToNewsletter = false
        }else{
            subscribedToNewsletter = true
        }
        
        if json["notification_settings"] == "false" {
            notificationSetting = false
        }else{
            notificationSetting = true
        }
        
        super.init()
    }
    
    init(email: String, accessToken: String) {
        
        self.email = email
        self.accessToken = accessToken
        
        super.init()
    }
    
    func toJSON() -> [String: String] {
        
        var json : [String: String] = [:]
        
        json["email"] = email
        json["access_token"] = accessToken
        
        json["id"] = id
        json["name"] = name
        json["address"] = address
        json["town_city"] = townCity
        json["county"] = county
        json["postcode"] = postcode
        json["telephone_number"] = telephoneNumber
        json["comments"] = comments
        
        json["subscribed_to_newsletter"] = "\(subscribedToNewsletter)"
        
        json["notification_settings"] = "\(notificationSetting)"
        
        return json
    }
}
