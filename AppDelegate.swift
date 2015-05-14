//
//  AppDelegate.swift
//  FInalProject
//
//  Created by Budge on 5/1/15.
//  Copyright (c) 2015 Budge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var _loadStartViewController: LoadStartViewController! = nil;

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        _loadStartViewController = LoadStartViewController();
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        // set root view controller
        window?.rootViewController = UINavigationController(rootViewController: _loadStartViewController);
        window?.makeKeyAndVisible();
        
        return true
    }
}
