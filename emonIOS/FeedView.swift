//
//  FeedView.swift
//  emonIOS
//
//  Created by Allen Conquest on 26/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit

class FeedView: UIView {
    var label = UILabel()
    var value = UILabel()
    var viewFeed: Feed?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView(feed: Feed) {
        
        viewFeed = feed
        label.frame = CGRectMake(10, 10, 200, 50)
        label.textAlignment = NSTextAlignment.Center
        label.text = feed.name
        self.addSubview(label)

        if let feedValue = feed.value {
            value.frame = CGRectMake(200, 10, 200, 50)
            value.textAlignment = NSTextAlignment.Center
            value.text = "\(feedValue)"
            self.addSubview(value)
        }
    }
}