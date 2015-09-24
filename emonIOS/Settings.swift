//
//  Settings.swift
//  emonIOS
//
//  Created by Allen Conquest on 26/07/2015.
//  Copyright (c) 2015 Allen Conquest. All rights reserved.
//

import InAppSettingsKit

func processDefaultSettings() {
    
    let defaults = IASKSettingsStoreUserDefaults().defaults
    
    // settings files to process
    var preferenceFiles = [String]()
    
    // begin with Root file
    preferenceFiles.append("Root")
    
    // as other settings files are discovered will be added to preferencesFiles
    while !preferenceFiles.isEmpty {
        
        // init IASKSettingsReader for current settings file
        let file = preferenceFiles.last
        let settingsReader = IASKSettingsReader(file: file)
        preferenceFiles.removeLast()
        
        // extract preference specifiers
        if let preferenceSpecfiers = settingsReader.settingsDictionary[kIASKPreferenceSpecifiers] as? NSArray {
            
            // process each specifier in the current settings file
            for specifier in preferenceSpecfiers {
                
                print(specifier.debugDescription)
                // get type of current specifier
                let type = specifier[kIASKType] as! String
                
                // need to check child pane specifier for additional file
                if type == kIASKPSChildPaneSpecifier {
                    preferenceFiles.append(specifier[kIASKFile] as! String)
                }
                else {
                    // check if current specifier has a default value
                    if let defaultValue: AnyObject = specifier[kIASKDefaultValue] as AnyObject? {
                        
                        // get key from specifier and current stored preference value
                        if let key = specifier[kIASKKey] as? String {
                            
                            if let value: AnyObject = defaults.objectForKey(key) {
                                // Nothing to do - already set
                            }
                            else {
                                let appDefaults = [key: defaultValue]
                                defaults.registerDefaults(appDefaults)
                            }
                        }
                    }
                }
            }
        }
        // synchornize stored preference values
        defaults.synchronize()
    }
}
