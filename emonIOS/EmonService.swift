//
//  EmonService.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Alamofire
import SwiftyJSON

class EmonService {
    
    func getFeeds(url: String, parameters: [String:String], completionHandler: (JSON, NSError?) -> Void) {
        
        Alamofire.request(.GET, url, parameters: parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                    completionHandler(nil, error)
                } else {
                    NSLog("Success: \(url)")
                    var json = JSON(json!)
                    completionHandler(json, nil)
                }
        }
        
    }
    
}
