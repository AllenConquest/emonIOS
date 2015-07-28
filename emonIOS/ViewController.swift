//
//  DetailViewController.swift
//  emonIOS
//
//  Created by Allen Conquest on 25/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit
import SwiftyJSON
import InAppSettingsKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    
    var account: EmonAccount!
    var feedViews = [FeedView]()
    var feeds = [Feed]()
    var timer = NSTimer()
    var appSettingsViewController: IASKAppSettingsViewController!


    @IBAction func displaySettings(sender: UIBarButtonItem) {
        println("This will display the settings window")
        
        var aNavController = UINavigationController(rootViewController: appSettingsViewController)
        self.navigationController?.pushViewController(appSettingsViewController, animated:true)
    }
    
    @IBAction func addButton(sender: UIBarButtonItem) {
        
    }
    
    func processFeeds(json: JSON, error: NSError?) {
        
        if error != nil
        {
            // TODO: improved error handling
            var alert = UIAlertController(title: "Error", message: "Could not load Data :( \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            print (json)
            if let feedArray = json.array {
                for item in feedArray {
                    let feed = Feed(item: item)
                    feeds.append(feed)
                    
                    if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/\(feed.name).bin")) {
                        let unarchiveFeed = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Feed
                        if let unwrappedFeed = unarchiveFeed {
                            
                            let view = addFeedView()
                            
                            view.userInteractionEnabled = true
                            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePanGesture:"))
                            let tap = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
                            tap.numberOfTapsRequired = 2
                            view.addGestureRecognizer(tap)
                            let long = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
                            long.minimumPressDuration = 0.5
                            long.enabled = true
                            view.addGestureRecognizer(long)
                            view.addCustomView(feed)
                            feed.position = unwrappedFeed.position
                            view.center = feed.position
                            self.view.addSubview(view)
                            self.feedViews.append(view)
                            
                        }
                    }

                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appSettingsViewController = IASKAppSettingsViewController(style: UITableViewStyle.Grouped)
        appSettingsViewController.showDoneButton = false
        appSettingsViewController.showCreditsFooter = false
        
        account = EmonAccount(completion: processFeeds)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingDidChange:", name: kIASKAppSettingChanged, object: nil)

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleResetTapGesture:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        let timeInterval = IASKSettingsStoreUserDefaults().doubleForKey("refresh_preference")
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "updateInfo:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: kIASKAppSettingChanged notification
    
    func settingDidChange(notification: NSNotification)
    {
        let key = notification.object as! String
        
        switch key {
//        case "refresh_preference":
//            let timeInterval = IASKSettingsStoreUserDefaults().doubleForKey("refresh_preference")
//            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "updateInfo:", userInfo: nil, repeats: true)
        default:
            println("Change key: \(key)")
        }
    }
    
    func updateInfo(timer: NSTimer) {
        
        for view in feedViews {
            account.refreshFeed(view.viewFeed!.id, completion: {
                (json, error) in
                println("\(view.viewFeed?.name): \(json)")
                view.value.text = "\(json)"
            })
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
                    var filename = NSHomeDirectory().stringByAppendingString("/Documents/\(feed.name).bin")
                    let data = NSKeyedArchiver.archivedDataWithRootObject(feed)
                    let success = data.writeToFile(filename, atomically: true)
                    println(success)
                }
            }
        default:
            println("default")
        }
    }

    func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .Began:
            println("Long Press Began")
            if let feedView = sender.view as? FeedView {
                feedView.smoothJiggle()
            }
        default:
            println("default")
        }
    }
    
    func handleTapGesture(sender: UIPanGestureRecognizer) {
        
        if sender.state == .Ended {
            // TODO - pop up window allowing selection of feed
            if let view = sender.view as? FeedView {
                account.refreshFeed(view.viewFeed!.id, completion: {
                (json, error) in
                    println(json)
                    view.value.text = "\(json)"
                })
            }
        }
    }

    func handleResetTapGesture(sender: UIPanGestureRecognizer) {
        
        if sender.state == .Ended {
            for view in feedViews {
                view.stopJiggling()
            }
        }
    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //do som stuff from the popover
        print ("Popover closing")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAddLabel" {
            if let controller = segue.destinationViewController as? UIViewController {
                if let content = controller.popoverPresentationController?.presentedViewController {
                    if let contentVC = (content as! UINavigationController).topViewController as? AddLabelViewController {
                        contentVC.account = account
                        contentVC.feeds = feeds
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        
        if segue.sourceViewController .isKindOfClass(AddLabelViewController) {            
            if let controller = segue.sourceViewController as? AddLabelViewController {
                controller.dismissViewControllerAnimated(true, completion: {
                    
                    if let feed = controller.pickedFeed {

                        let view = FeedView(frame: CGRectMake(20, 80, 400, 75))
                        view.userInteractionEnabled = true
                        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePanGesture:"))
                        let tap = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
                        tap.numberOfTapsRequired = 2
                        view.addGestureRecognizer(tap)
                        let long = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
                        long.minimumPressDuration = 1
                        long.enabled = true
                        view.addGestureRecognizer(long)
                        view.addCustomView(feed)
                        self.view.addSubview(view)
                        self.feedViews.append(view)
                        feed.position = view.center
                        
                        var filename = NSHomeDirectory().stringByAppendingString("/Documents/\(feed.name).bin")
                        let data = NSKeyedArchiver.archivedDataWithRootObject(feed)
                        let success = data.writeToFile(filename, atomically: true)
                        println(success)
                        
                    }
                })
            }
        }
    }
    
    func addFeedView() -> FeedView {
    
        let superview = FeedView(frame: CGRectMake(0, 0, 420, 80))
        
        let shadowView = UIView(frame: CGRectMake(10, 10, 400, 60))
        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowView.layer.shadowOffset = CGSizeZero
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 5
        
        let view = UIView(frame: shadowView.bounds)
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 10.0
        view.layer.borderColor = UIColor.grayColor().CGColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        
        shadowView.addSubview(view)
        superview.addSubview(shadowView)
        return superview
    }
}
