//
//  SettingsViewController.swift
//  emonIOS
//
//  Created by Allen Conquest on 26/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit
import InAppSettingsKit

class SettingsViewController: UIViewController, IASKSettingsDelegate {
    
    override func viewDidLoad() {
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showSettingsPopover")
        }
        
    }
    
    // MARK: IASKAppSettingsViewControllerDelegate protocol
    func settingsViewControllerDidEnd(sender: IASKAppSettingsViewController!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // your code here to reconfigure the app for changed settings
    }
    
    
}