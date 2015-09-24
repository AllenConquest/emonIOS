//
//  Persist.swift
//  emonIOS
//
//  Created by Allen Conquest on 02/08/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import Foundation

struct Persist {
    
    static func save(name: String, object: AnyObject) -> Bool {
        
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/\(name).bin")
        let data = NSKeyedArchiver.archivedDataWithRootObject(object)
        let success = data.writeToFile(filename, atomically: true)
        return success
    }
    
    static func load(name: String) -> AnyObject? {
        if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/\(name).bin")) {
            let unarchiveObject: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            return unarchiveObject
        }
        return nil
    }
    
    static func delete(name: String) {
        
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/\(name).bin")
        var error: NSError?
        let success: Bool
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filename)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        if !success {
            print(error)
        }
    }
}