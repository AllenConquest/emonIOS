//
//  emonAccount.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SwiftyJSON
import InAppSettingsKit

class EmonAccount {
  
    var apiKey: String?
    var emonUrl: String?
    var feeds = [Feed]()
 
    init(completion: (JSON, NSError?) -> Void) {
        
        apiKey = IASKSettingsStoreUserDefaults().objectForKey("apikey_preference") as? String
        emonUrl = IASKSettingsStoreUserDefaults().objectForKey("url_preference") as? String
        if let key = apiKey, url = emonUrl where !key.isEmpty && !url.isEmpty {
            let emonService = EmonService()
            emonService.getFeeds("\(url)/feed/list.json", parameters: ["apikey":key], completionHandler: completion)
        } else {
            completion(nil, NSError(domain: "emonAccount", code: 01, userInfo: nil))
        }
    }
    
    func processFeeds(json: JSON, error: NSError?) {
        
        if error != nil
        {
            // TODO: improved error handling
            var alert = UIAlertController(title: "Error", message: "Could not load Data :( \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            print (json)
            if let feedArray = json.array {
                for item in feedArray {
                    let feed = Feed(item: item)
                    feeds.append(feed)
                }
            }
        }
    }

    func refreshFeed(feed: String, completion: (JSON, NSError?) -> Void) {

        if let key = apiKey, url = emonUrl {
            let emonService = EmonService()
            emonService.getFeeds("\(url)/feed/value.json", parameters: ["id":feed, "apikey":key]) {
                (json, error) in
                print (json)
                completion(json, error)
            }
        }
    }
    
}