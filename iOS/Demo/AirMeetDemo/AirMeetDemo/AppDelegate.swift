//
//  AppDelegate.swift
//  AirMeetDemo
//
//  Created by Go Sato on 2015/11/28.
//  Copyright © 2015年 go. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //バックグラウンド
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // ユーザのpush通知許可をもらうための設定
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes:
                [UIUserNotificationType.Sound,
                    UIUserNotificationType.Badge,
                    UIUserNotificationType.Alert], categories: nil)
        )
    
        return true
    }
    
    
    
    // 位置情報使用許可の認証状態が変わったタイミングで呼ばれるデリゲートメソッド
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            let uuid: NSUUID! = NSUUID(UUIDString:"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
            let message = "居酒屋『ヤキトリー』が近くにあります"
            
            // ビーコン領域をトリガーとした通知を作成(後述)
            let notification = createRegionNotification(uuid, message: message)
            // 通知を登録する
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    private func createRegionNotification(uuid: NSUUID, message: String) -> UILocalNotification {
        
        // ## ビーコン領域を作成 ##
        var beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "RegionId")
        beaconRegion.notifyEntryStateOnDisplay = false
        beaconRegion.notifyOnEntry = true
        // 領域に入ったときにも出たときにも通知される
        // 今回は領域から出たときの通知はRegion側でOFFにしておく
        beaconRegion.notifyOnExit = false
        
        // ## 通知を作成し、領域を設定 ##
        let notification = UILocalNotification()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = message
        
        // 通知の対象となる領域 *今回のポイント
        notification.region = beaconRegion
        // 一度だけの通知かどうか
        notification.regionTriggersOnce = false
        // 後述するボタン付き通知のカテゴリ名を指定
        notification.category = "NOTIFICATION_CATEGORY_INTERACTIVE"
        
        return notification
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
    
    //アプリがフォアグラウンド状態
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
//        if (application.applicationState == UIApplicationState.Active) {
//            // foreground時のlocal notification
//            print("active")
//            var alert = UIAlertView()
//            alert.title = "Foreground"
//            alert.message = notification.alertBody
//            alert.addButtonWithTitle(notification.alertAction!)
//            alert.show()
//        } else {
//            // background時のlocal notification
//            print("background")
//            var alert = UIAlertView()
//            alert.title = "Background"
//            alert.message = notification.alertBody
//            alert.addButtonWithTitle(notification.alertAction!)
//            alert.show()
//        }
        
    }
    
    
}