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
            .responseJSON { (request, response, result) in

                // TODO add error handling
                
                switch result {
                case .Success:
                    print("Successful")
                    
                    let json = JSON(result.value!)
                    completionHandler(json, nil)
                case .Failure(let error):
                    print(error)
                    completionHandler(nil, nil)
                }
        }
    }
}
