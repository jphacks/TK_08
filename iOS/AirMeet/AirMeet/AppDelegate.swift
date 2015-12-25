//
//  AppDelegate.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    var test: UIApplication?
    var notification = UILocalNotification()

    var isChild: Bool!//trueは子がeventからかえってきたとき
    var isParent: Bool!//trueは親がeventをたててるところからかえってきたとき
    var isBeacon: Bool!//trueはiBeconの監視をしたいとき
    
    var isInEvent: Bool!//イベントないにいるかいないか
    
    var selectEvent: EventModel?
    var selectChild: ChildModel?
    
    var allChilds:[ChildModel] = [ChildModel]()
    
    var childID: String?
    var parentID: String?
    
    var parentPass: String?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        //タッチ
        var config = Configuration()
        config.defaultSize = CGSize(width: 30, height: 30)
        Visualizer.start(config)
        
         //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        //Navigationbar色
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:
            [UIUserNotificationType.Sound,
                UIUserNotificationType.Alert], categories: nil))
        
        //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        //let mainViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Main")
        //self.window!.rootViewController = mainViewController
        //self.window?.makeKeyAndVisible()

        return true
    }

    
    // 使ってない
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        //ここに通知を受け取った時の処理を記述

    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

