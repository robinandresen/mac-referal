//
//  StudyService.swift
//  MacResearch
//
//  Created by Billy on 1/26/17.
//  Copyright © 2017 Appitized. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class StudyService: NSObject {
    
    let imageDownloadQueue = "com.macResearch.image"
    
    static let sharedInstance = StudyService()
    
    let imageCache = AutoPurgingImageCache(memoryCapacity: 100 * 1024 * 1024,
                                           preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    static func getStudies(status: Status, completion: @escaping (Array<[String: AnyObject]>?, NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        
        var getStudyApiUrl: String
        
        switch status {
        case .live:
            getStudyApiUrl = apiURL + liveStudiesEndpoint
            break
        case .upcoming:
            getStudyApiUrl = apiURL + upcomingStudiesEndpoint
            break
        case .mine:
            getStudyApiUrl = apiURL + myStudiesEndpoint
            break
        }
        
        
        Alamofire.request(getStudyApiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(let response):
                if let res = response as? NSDictionary {
                    
                    if let json = res["errors"] as? [[String: AnyObject]],
                        let errors = json[0] as [String: AnyObject]?,
                        let status = errors["status"] as? NSNumber,
                        let messages = errors["messages"] as? [NSObject: AnyObject] {
                        
                        completion(nil ,NSError(domain: "StudyService", code: status.intValue, userInfo: messages))
                        
                    } else if let json = res["data"] as? Array<[String: AnyObject]> {
                        
                        completion(json, nil)
                        
                    } else {
                        
                        if let responseDict = response as? [String: String] {
                            completion(nil, NSError(domain: "StudyService", code: 0, userInfo: responseDict))
                        } else {
                            completion(nil, NSError(domain: "StudyService", code: 0, userInfo: nil))
                        }
                    }
                    
                }else{
                    completion(nil, NSError(domain: "StudyService", code: 0, userInfo: nil))
                }
            case.failure(let error):
                completion(nil, error as NSError)
                break
            }
            
        }
    }
    
    static func getStudyDetail(studyId: String, completion: @escaping ([String: AnyObject]?, NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        
        Alamofire.request(apiURL + getStudyDetailEndpoint + studyId, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(let response):
                if let res = response as? NSDictionary {
                    
                    if let json = res["errors"] as? [[String: AnyObject]],
                        let errors = json[0] as [String: AnyObject]?,
                        let status = errors["status"] as? NSNumber,
                        let messages = errors["messages"] as? [NSObject: AnyObject] {
                        
                        completion(nil, NSError(domain: "StudyService", code: status.intValue, userInfo: messages))
                        
                    } else if let json = res["data"] as? [String: AnyObject] {
                        
                        completion(json, nil)
                        
                    } else {
                        
                        if let responseDict = response as? [String: String] {
                            completion(nil, NSError(domain: "StudyService", code: 0, userInfo: responseDict))
                        } else {
                            completion(nil, NSError(domain: "StudyService", code: 0, userInfo: nil))
                        }
                    }
                    
                }else{
                    completion(nil, NSError(domain: "StudyService", code: 0, userInfo: nil))
                }
            case.failure(let error):
                completion(nil, error as NSError)
                break
            }
            
        }
    }
    
    static func registerInterest(studyId: String, completion: @escaping (NSError?)->()) {
        
        guard let token = UserService.sharedInstance.currentUser?.accessToken else {
            debugPrint("User has no token!")
            return
        }
        let registerInterestURL = apiURL + getStudyDetailEndpoint + studyId + registerInterestEndpoint
        
        Alamofire.request(registerInterestURL, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(token)", "Accept": "application/json", "Content-Type": "application/json"]).responseJSON {
            (response) in
            
            switch response.result {
                
            case .success(let response):
                if let res = response as? NSDictionary {
                    
                    if let _ = res["success"] as? [String: AnyObject] {
                        completion(nil)
                    }
                }else{
                    completion(NSError(domain: "StudyService", code: 0, userInfo: nil))
                }
            case.failure(let error):
                completion(error as NSError)
                break
            }
            
        }
    }
    
    static func getStudyMedia(study: Study, completion: @escaping (AnyObject?, NSError?)->()) {
        
        guard let urlString = study.imageUrl, urlString != "", let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Failed to retrieve study media", code: 0, userInfo: nil))
            return
        }
        
        if let cachedImage = sharedInstance.cachedImage(urlString: urlString) {
            study.image = cachedImage
            
            completion(cachedImage, nil)
        }else{
            
            let downloadQueue = DispatchQueue(label: sharedInstance.imageDownloadQueue, attributes: .concurrent)
            downloadQueue.async{
                
                if let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                    
                    study.image = image
                    sharedInstance.cacheImage(image: image, urlString: urlString)
                    completion(image, nil)
                    return
                    
                } else {
                    
                    completion(nil, NSError(domain: "Failed to retrieve memory media - bad url data", code: 0, userInfo: nil))
                    return
                }
            }
        }
        
    }
    
    func cacheImage(image: Image, urlString: String) {
        imageCache.add(image, withIdentifier: urlString)
    }
    
    func cachedImage(urlString: String) -> Image? {
        return imageCache.image(withIdentifier: urlString)
    }
    
}
