//
//  AppDelegate.swift
//  Take Picture
//
//  Created by Eric on 2016-10-28.
//  Copyright © 2016 Eric. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let userDefault = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // CoreDataManager.manager.deleteAll()
        
        if let url: URL = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            print(url)
            userDefault.set(url, forKey: "importURL")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newRecipeComing"), object: nil)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        userDefault.set(url, forKey: "importURL")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newRecipeComing"), object: nil)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.manager.saveContext()
    }

   
}

