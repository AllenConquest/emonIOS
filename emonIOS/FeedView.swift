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
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCustomView(feed: Feed) {
        
        viewFeed = feed
        label.frame = CGRectMake(10, 15, 200, 50)
        label.textAlignment = NSTextAlignment.Center
        label.text = feed.name
        self.addSubview(label)
        
        value.frame = CGRectMake(200, 15, 200, 50)
        value.textAlignment = NSTextAlignment.Center
        value.text = "\(feed.value)"
        self.addSubview(value)
    }
    
    /* Degrees to radians conversion */
    func degreesToRadians (degrees: CGFloat) -> CGFloat {
        return  CGFloat(Double(degrees) / 180.0 * M_PI)
    }
    
    func smoothJiggle() {
        
        let degrees: CGFloat = 5.0
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.6
        animation.cumulative = true
        animation.repeatCount = Float.infinity
        animation.values = [0.0,
            degreesToRadians(-degrees) * 0.25,
            0.0,
            degreesToRadians(degrees) * 0.5,
            0.0,
            degreesToRadians(-degrees),
            0.0,
            degreesToRadians(degrees),
            0.0,
            degreesToRadians(-degrees) * 0.5,
            0.0,
            degreesToRadians(degrees) * 0.25,
            0.0]
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.removedOnCompletion = true
        
        layer.addAnimation(animation, forKey: "wobble")
    }

    func stopJiggling() {
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransformIdentity
        self.layer.anchorPoint = CGPointMake(0.5, 0.5)
    }
    

}