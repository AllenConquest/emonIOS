//
//  Feed.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import SwiftyJSON

class Feed: NSObject, NSCoding {
    
    var id: String!
    var userid: Int!
    var name: String!
    var datatype: Int!
    var tag: String!
    var pub: Bool!
    var size: Int!
    var engine: Int!
    var server: Int!
    var time: Int!
    var value: Float!
    var position: CGPoint!

    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as? String
        self.userid = aDecoder.decodeIntegerForKey("userid")
        self.name = aDecoder.decodeObjectForKey("name") as? String
        self.datatype = aDecoder.decodeIntegerForKey("datatype")
        self.tag = aDecoder.decodeObjectForKey("tag") as? String
        self.pub = aDecoder.decodeBoolForKey("pub")
        self.size = aDecoder.decodeIntegerForKey("size")
        self.engine = aDecoder.decodeIntegerForKey("engine")
        self.server = aDecoder.decodeIntegerForKey("server")
        self.time = aDecoder.decodeIntegerForKey("time")
        self.value = aDecoder.decodeFloatForKey("value")
        self.position = aDecoder.decodeCGPointForKey("position")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id");
        aCoder.encodeInteger(userid, forKey: "userid");
        aCoder.encodeObject(name, forKey: "name");
        aCoder.encodeInteger(datatype, forKey: "datatype");
        aCoder.encodeObject(tag, forKey: "tag");
        aCoder.encodeBool(pub, forKey: "pub");
        aCoder.encodeInteger(size, forKey: "size");
        aCoder.encodeInteger(engine, forKey: "engine");
        aCoder.encodeInteger(server, forKey: "server");
        aCoder.encodeInteger(time, forKey: "time");
        aCoder.encodeFloat(value, forKey: "value");
        aCoder.encodeCGPoint(position, forKey: "position")
    }
    
    init(item: JSON) {
        
        id = item["id"].stringValue
        userid = item["userid"].intValue
        name = item["name"].stringValue
        datatype = item["datatype"].intValue
        tag = item["tag"].stringValue
        pub = item["public"].boolValue
        size = item["size"].intValue
        engine = item["engine"].intValue
        server = item["server"].intValue
        time = item["time"].intValue
        value = item["value"].floatValue
    }
}