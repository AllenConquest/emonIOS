//
//  FeedView.swift
//  emonIOS
//
//  Created by Allen Conquest on 26/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit

class FeedView: UIView, UIGestureRecognizerDelegate {
    var label = UILabel()
    var value = UILabel()
    var viewFeed: Feed?
    var imageView: UIImageView!
    var tapGestureRecognizer: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleCloseTap(sender: UIPanGestureRecognizer) {
        
        print("handleCloseTap")
        if sender.state == .Ended {
            self.removeFromSuperview()
            
            if let name = viewFeed?.name {
                Persist.delete(name)
            }
        }
    }
    
    func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .Began:
            print("Long Press Began")
            if let feedView = sender.view as? FeedView {
                feedView.smoothJiggle()
            }
        default:
            print("default")
        }
    }

    func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .Changed:
            sender.view?.center = sender.locationInView(sender.view?.superview)
        case .Ended:
            if let feedView = sender.view as? FeedView {
                if let feed = feedView.viewFeed {
                    feed.position = sender.view?.center
                    let success = Persist.save(feed.name, object: feed)
                    print(success)
                }
            }
        default:
            print("default")
        }
    }
    
    func addCustomView(feed: Feed) {
        
        imageView = UIImageView(image: UIImage(named: "delete32"))
        imageView.userInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleCloseTap:")
        tapGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(tapGestureRecognizer)
        viewFeed = feed
        label.frame = CGRectMake(10, 15, 180, 50)
        label.textAlignment = NSTextAlignment.Center
        label.text = feed.name
        addSubview(label)
        
        value.frame = CGRectMake(200, 15, 180, 50)
        value.textAlignment = NSTextAlignment.Center
        value.text = "\(feed.value)"
        imageView.hidden = true
        
        userInteractionEnabled = true
        let long = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        long.minimumPressDuration = 0.5
        long.enabled = true
        addGestureRecognizer(long)

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePanGesture:"))

        addSubview(imageView)
        addSubview(value)
    }
    
    /* Degrees to radians conversion */
    func degreesToRadians (degrees: CGFloat) -> CGFloat {
        return  CGFloat(Double(degrees) / 180.0 * M_PI)
    }
    
    func smoothJiggle() {
        
        imageView.hidden = false
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
        imageView.hidden = true
        layer.removeAllAnimations()
        transform = CGAffineTransformIdentity
        layer.anchorPoint = CGPointMake(0.5, 0.5)
    }

}