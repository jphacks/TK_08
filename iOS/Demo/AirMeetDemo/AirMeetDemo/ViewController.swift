//
//  ViewController.swift
//  AirMeetDemo
//
//  Created by Go Sato on 2015/11/28.
//  Copyright © 2015年 go. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var uuid: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var minor: UILabel!
    @IBOutlet weak var accuracy: UILabel!
    @IBOutlet weak var rssi: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //UUIDからNSUUIDを作成
    //UUIDは送信機側とフォーマットも合わせる
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-33333B57FE6D")
    var region  = CLBeaconRegion()
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CLBeaconRegionを生成
        region = CLBeaconRegion(proximityUUID:proximityUUID!,identifier:"EstimoteRegion")
        
        //デリゲートの設定
        manager.delegate = self
        
        /*
        位置情報サービスへの認証状態を取得する
        NotDetermined   --  アプリ起動後、位置情報サービスへのアクセスを許可するかまだ選択されていない状態
        Restricted      --  設定 > 一般 > 機能制限により位置情報サービスの利用が制限中
        Denied          --  ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
        Authorized      --  位置情報サービスへのアクセスを許可している
        */
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            print("観測開始")
            self.status.text = "Starting Monitor"
            self.manager.startRangingBeaconsInRegion(self.region)
        case .NotDetermined:
            print("許可承認")
            self.status.text = "Starting Monitor"
            //デバイスに許可を促す
            
            /****** swift2.0で動くように変更 ******/
            let deviceVer = UIDevice.currentDevice().systemVersion
            //if(UIDevice.currentDevice().systemVersion.substringToIndex(1).toInt() >= 8){
            if(Int(deviceVer.substringToIndex(deviceVer.startIndex.advancedBy(1))) >= 8){
                /***********************************/
                
                //iOS8以降は許可をリクエストする関数をCallする
                self.manager.requestAlwaysAuthorization()
                print("OK")
            }else{
                self.manager.startRangingBeaconsInRegion(self.region)
            }
        case .Restricted, .Denied:
            //デバイスから拒否状態
            print("Restricted")
            self.status.text = "Restricted Monitor"
        }
    }
    
    
    //以下 CLLocationManagerデリゲートの実装---------------------------------------------->
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
    Parameters
    manager : The location manager object reporting the event.
    region  : The region that is being monitored.
    */
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        manager.requestStateForRegion(region)
        self.status.text = "Scanning..."
        
        manager.requestStateForRegion(self.region);
    }
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
    Parameters
    manager :The location manager object reporting the event.
    state   :The state of the specified region. For a list of possible values, see the CLRegionState type.
    region  :The region whose state was determined.
    */
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion) {
        
        print("locationManager")
        
        switch (state) {
            
        case .Inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            
            manager.startRangingBeaconsInRegion(region);
            // →(didRangeBeacons)で測定をはじめる
            print("Inside")
            break;
            
        case .Outside:
            
            print("Outside")
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        case .Unknown:
            
            print("Unknown")
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        default:
            
            break;
            
        }
    }
    
    /*
    リージョン監視失敗（bluetoosの設定を切り替えたりフライトモードを入切すると失敗するので１秒ほどのdelayを入れて、再トライするなど処理を入れること）
    - (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
    Parameters
    manager : The location manager object reporting the event.
    region  : The region for which the error occurred.
    error   : An error object containing the error code that indicates why region monitoring failed.
    */
    
    
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("monitoringDidFailForRegion \(error)")
        self.status.text = "Error :("
    }
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
    Parameters
    manager : The location manager object that was unable to retrieve the location.
    error   : The error object containing the reason the location or heading could not be retrieved.
    */
    //通信失敗
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        self.status.text = "Possible Match"
        sendLocalNotificationWithMessage("領域に入りました")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        reset()
        sendLocalNotificationWithMessage("領域から出ました")
    }
    
    /*
    beaconsを受信するデリゲートメソッド。複数あった場合はbeaconsに入る
    - (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
    Parameters
    manager : The location manager object reporting the event.
    beacons : An array of CLBeacon objects representing the beacons currently in range. You can use the information in these objects to determine the range of each beacon and its identifying information.
    region  : The region object containing the parameters that were used to locate the beacons
    */
    
    /****** swift2.0で動くように変更 ******/
    /*****  NSArray => [CLBeacon] *****/
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
//        if(beacons.count != 0){
//            print(beacons)
//            count = beacons.count
//        }
        
        if(beacons.count == 0) {
            return
        }
        //複数あった場合は一番先頭のものを処理する
        let beacon = beacons[0]
        
        if(beacon != 0){
            //setLocalNotification()
        }
        
        /*
        beaconから取得できるデータ
        proximityUUID   :   regionの識別子
        major           :   識別子１
        minor           :   識別子２
        proximity       :   相対距離
        accuracy        :   精度
        rssi            :   電波強度
        */
        if (beacon.proximity == CLProximity.Unknown) {
            self.distance.text = "Unknown Proximity"
            reset()
            return
        } else if (beacon.proximity == CLProximity.Immediate) {
            self.distance.text = "Immediate"
        } else if (beacon.proximity == CLProximity.Near) {
            self.distance.text = "Near"
        } else if (beacon.proximity == CLProximity.Far) {
            self.distance.text = "Far"
        }
        self.status.text   = "OK"
        self.uuid.text     = beacon.proximityUUID.UUIDString
        self.major.text    = "\(beacon.major)"
        self.minor.text    = "\(beacon.minor)"
        self.accuracy.text = "\(beacon.accuracy)"
        self.rssi.text     = "\(beacon.rssi)"
    }
    
    func reset(){
        self.status.text   = "none"
        self.uuid.text     = "none"
        self.major.text    = "none"
        self.minor.text    = "none"
        self.accuracy.text = "none"
        self.rssi.text     = "none"
    }
    
    //ローカル通知
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLocalNotification(){
        // push設定
        // 登録済みのスケジュールをすべてリセット
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.alertAction = "アプリに戻る"
        notification.alertBody = "Pushデモだよ"
        notification.fireDate = NSDate(timeIntervalSinceNow: 0.1)  // Test
        notification.soundName = UILocalNotificationDefaultSoundName
        // アイコンバッジに1を表示(アイコンバッジ：アイコンの右上につく未読などの数値)
        notification.applicationIconBadgeNumber = 1
        // あとのためにIdを割り振っておく
        notification.userInfo = ["notifyId": "ranking_update"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}