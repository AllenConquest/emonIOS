//
//  AddLabelViewController.swift
//  emonIOS
//
//  Created by Allen Conquest on 26/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import UIKit

class AddLabelViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var feedPicker: UIPickerView!
    
    var account: EmonAccount?
    var pickerDataSource = [String]()
    var pickedFeed: Feed?
    
    override func viewDidLoad() {
        
        // Load datasource
        if  let feeds = account?.feeds {
            for feed in feeds {
                pickerDataSource.append(feed.name)
            }
        }
    }
    


    @IBAction func doSave(sender: UIBarButtonItem) {
    }
    
    @IBAction func doCancel(sender: UIBarButtonItem) {
        
        if let controller = presentingViewController {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedFeed = account?.feeds[row]
    }
}