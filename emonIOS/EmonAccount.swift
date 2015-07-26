//
//  emonAccount.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SwiftyJSON

class EmonAccount {
  
    var apiKey: String = "1db10447b3dcf65fe313e2a1f522d4db"
    var feeds = [Feed]()
 
    init() {
        
        let emonService = EmonService()
        emonService.getFeeds("http://emoncms.org/feed/list.json", parameters: ["apikey":apiKey], completionHandler: processFeeds)
    }
    
    func processFeeds(json: JSON, error: NSError?) {
        
        if error != nil
        {
            // TODO: improved error handling
            var alert = UIAlertController(title: "Error", message: "Could not load MetaData :( \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            print (json)
            var names = [String]()
            if let feedArray = json.array {
                for item in feedArray {
                    let feed = Feed(item: item)
                    feeds.append(feed)
                }
            }
        }
    }

    func refreshFeed(feed: String, completion: (JSON, NSError?) -> Void) {

        let emonService = EmonService()
        emonService.getFeeds("http://emoncms.org/feed/value.json", parameters: ["id":feed, "apikey":apiKey]) {
            (json, error) in
            print (json)
            completion(json, error)
        }

    }
    
}