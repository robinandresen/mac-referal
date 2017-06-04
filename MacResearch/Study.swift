//
//  Study.swift
//  MacResearch
//
//  Created by Billy on 1/27/17.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

enum Status {
    case live
    case upcoming
    case mine
}

class Study: NSObject {

    var id: String?
    var name: String?
    var studyDescription: String?
    var imageUrl: String?
    var location: String?
    
    var startDate: String?
    var endDate: String?
    var status: String?
    
    var exclusionCritera: String?
    var referralMade: String?
    var interest: String?
    
    var image: UIImage?
    
    init(json: [String: Any]) {
        
        super.init()
        
        id = json["id"] as? String
        name = json["name"]  as? String
        
        studyDescription = json["description"]  as? String
        imageUrl = json["image_url"]  as? String
        location = json["location"]  as? String
        
        startDate = json["start_date"]  as? String
        endDate = json["end_date"]  as? String
        status = json["status"]  as? String
        
        exclusionCritera = json["exclusion_critera"]  as? String
        referralMade = json["referral_made"]  as? String
        interest = json["expressed_interest"]  as? String        
        
    }
    
    init(id: String) {
        
        self.id = id
        
        super.init()
    }
    
    
    func toJSON() -> [String: String] {
        
        var json : [String: String] = [:]
        
        json["id"] = id
        json["name"] = name
        
        json["description"] = studyDescription
        json["image_url"] = imageUrl
        json["location"] = location
        
        json["start_date"] = startDate
        json["end_date"] = endDate
        json["status"] = status
        
        json["exclusion_critera"] = exclusionCritera
        json["referral_made"] = referralMade
        json["expressed_interest"] = interest
        
        return json
    }
}

