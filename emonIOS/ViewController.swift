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

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {

    
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
        
        if error != nil {
            // TODO: improve error handling
            var alert = UIAlertController(title: "Error", message: "Could not load Data :( \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            print (json)
            if let feedArray = json.array {
                for item in feedArray {
                    let feed = Feed(item: item)
                    feeds.append(feed)
                    
                    if let unwrappedFeed = Persist.load(feed.name) as? Feed {
                        let view = addFeedView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appSettingsViewController = IASKAppSettingsViewController(style: UITableViewStyle.Grouped)
        appSettingsViewController.showDoneButton = false
        appSettingsViewController.showCreditsFooter = false
        
        account = EmonAccount(completion: processFeeds)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleResetTapGesture:")
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "settingDidChange:", name: kIASKAppSettingChanged, object: nil)
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
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == self.view {
            return true
        }
        return false
    }
    
    func handleResetTapGesture(sender: UIPanGestureRecognizer) {
        
        if sender.state == .Ended {
            for view in feedViews {
                view.stopJiggling()
            }
        }
    }

    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        //do some stuff from the popover
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

                        let view = self.addFeedView()
                        view.addCustomView(feed)
                        self.view.addSubview(view)
                        self.feedViews.append(view)
                        view.center = CGPointMake(40, 120)
                        feed.position = view.center
                        
                        let success = Persist.save(feed.name, object: feed)
                        println(success)
                        
                    }
                })
            }
        }
    }
    
    // Add drop shadow effect on custom view
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