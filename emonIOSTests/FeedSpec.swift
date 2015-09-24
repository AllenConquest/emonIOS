//
//  FeedSpec.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Quick
import Nimble
import emonIOS
import SwiftyJSON

class FeedSpec: QuickSpec {
    override func spec() {
        
//        var feed: Feed!
//        
//        beforeEach() {
//            feed = Feed()
//            feed.id = 1
//            feed.userid = 2
//            feed.name = "Test"
//        }
//
//        describe("intial state") {
//            it("has id") {
//                expect(feed.id).to(beGreaterThanOrEqualTo(1))
//            }
//            it("has userid") {
//                expect(feed.userid).to(beGreaterThanOrEqualTo(1))
//            }
//            it("has name") {
//                expect(feed.name).to(equal("Test"))
//            }
//            
//        }
        
        it("can be encode and decoded") {
            let json = JSON(["id":"101","userid":"202","name":"fred","datatype":"1","tag":"","public":"0","size":"12345","engine":"5","server":"1","time":"123","value":"123.456"])
            let test = Feed(item: json)
            NSKeyedArchiver.archiveRootObject(test, toFile: "/feed/data")
            let y = NSKeyedUnarchiver.unarchiveObjectWithFile("/feed/data") as? Feed
            print (y)
        }
        
    }
}
