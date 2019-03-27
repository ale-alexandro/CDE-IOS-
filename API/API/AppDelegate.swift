//
//  AppDelegate.swift
//  API
//
//  Created by 4lex@ndr0 on 2019-02-19.
//  Copyright © 2019 4lex@ndr0. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //TODO: Check that login and passwd saved in UserDefaults.
        //if true => going to tabbedNavVC and init DESession
        //else => going to login scene to get creditinals 
        
        let defaults = UserDefaults.init(suiteName: "group.alexandro.cde")!
        
        //defaults.set("265469", forKey: "login")
        //defaults.set("XrTILHx3", forKey: "password")
        //defaults.synchronize()
        
        if defaults.string(forKey: "login") == nil || defaults.string(forKey: "password") == nil {
            let rvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login_screen")
            window?.rootViewController = rvc
            self.window?.makeKeyAndVisible()
        }
        else {
            let login = defaults.string(forKey: "login")!
            let password = defaults.string(forKey: "password")!
            do {
                let _ = try CDESession(login: login, passwd: password)
            } catch let error {
                //By the way we cannot get exception with wrong login/password, only we can get "CDEError.NetworkProblems"
                print(error)
            }
            // After this moment we deep link to rootVC
        }
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

    }


    func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }


    func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

