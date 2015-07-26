//
//  Feed.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SwiftyJSON

class Feed {
    
    var id: String?
    var userid: Int?
    var name: String?
    var datatype: Int?
    var tag: String?
    var pub: Bool?
    var size: Int?
    var engine: Int?
    var server: Int?
    var time: Int?
    var value: Float?
    
    init(item: JSON) {
        
        id = item["id"].string
        userid = item["userid"].intValue
        name = item["name"].string
        datatype = item["datatype"].intValue
        tag = item["tag"].string
        pub = item["public"].boolValue
        size = item["size"].intValue
        engine = item["engine"].intValue
        server = item["server"].intValue
        time = item["time"].intValue
        value = item["value"].floatValue
        
        
    }
    
    
    
    
}