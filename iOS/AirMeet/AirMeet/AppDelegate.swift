//
//  AppDelegate.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    var test: UIApplication?
    var notification = UILocalNotification()

    var isChild: Bool!
    var isParent:Bool!
    
    var selectEvent: EventModel?
    var selectChild: ChildModel?
    
    var parentID: String?
    
    var majorID:[NSNumber] = []
    var majorIDOld:[NSNumber] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
        
        // アプリに登録されている全ての通知を削除
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        return true
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
//        print("notification")
//        let alert = UIAlertController(title:"\(notification.alertBody!)",message:nil,preferredStyle:UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction(title: "OK", style: .Default) {
//            action in
//        }
//        alert.addAction(okAction)
//        
//        self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)

    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        notification.alertAction = "AirMeet"
//        notification.alertBody = "iBeacon範囲に入りました"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        // あとのためにIdを割り振っておく
//        notification.userInfo = ["notifyId": "AirMeet"]
//        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
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

    func pushControll(){
        // push設定
        // 登録済みのスケジュールをすべてリセット
        print("push")
        //application!.cancelAllLocalNotifications()
        
        
//        notification.alertAction = "AirMeet"
//        notification.alertBody = "iBeacon範囲に入りました"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        // あとのためにIdを割り振っておく
//        notification.userInfo = ["notifyId": "AirMeet"]
//        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        notification.alertBody = "AirMeet圏内"
        
        let alert = UIAlertController(title:"\(notification.alertBody!)",message:nil,preferredStyle:UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) {
            action in
        }
        alert.addAction(okAction)
        
        //presentViewController(alert, animated: true, completion: nil)
        
    }


}

