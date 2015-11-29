//
//  AppDelegate.swift
//  iBeaconDemo
//
//  Created by Go Sato on 2015/11/21.
//  Copyright © 2015年 go. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var test: UIApplication?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
       
        
        // アプリに登録されている全ての通知を削除
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:
            [UIUserNotificationType.Sound,
                UIUserNotificationType.Alert], categories: nil))
        
        //pushControll(application)
        
        return true
    }
    
    func pushControll(application:UIApplication){
        print(ViewController().isChange)
        if(ViewController().isChange){
        // push設定
        // 登録済みのスケジュールをすべてリセット
        print("push")
        //application!.cancelAllLocalNotifications()
        
        var notification = UILocalNotification()
        notification.alertAction = "AirMeet"
        notification.alertBody = "iBeacon範囲に入りました"
        notification.soundName = UILocalNotificationDefaultSoundName
        // あとのためにIdを割り振っておく
        notification.userInfo = ["notifyId": "AirMeet"]
        application.scheduleLocalNotification(notification)
        }
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

