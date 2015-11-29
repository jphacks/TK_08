//
//  ViewController.swift
//  iBeaconDemo
//
//  Created by Go Sato on 2015/11/21.
//  Copyright © 2015年 go. All rights reserved.
//  
//  Thank you Fumitoshi Ogata's code
//  https://github.com/oggata/iBeaconDemo/blob/master/iBeaconDemo/ViewController.swift
//

import UIKit
//------go
import CoreLocation
//

class ViewController: UIViewController,CLLocationManagerDelegate{
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var uuid: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var accuracy: UILabel!
    @IBOutlet weak var rssi: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var isChange:Bool = false
    
    //--------go
    //UUIDは送信機側とフォーマットも合わせる
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-33333B57FE6D")
    var region  = CLBeaconRegion()
    //ロケーションマネージャー作成
    var manager = CLLocationManager()
    
    //majorIDリスト用のグローバル変数
    var majorIDList:[NSNumber] = []
    var majorIDListOld:[NSNumber] = []
    //-----------
    
    var trackLocationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //------go
        //Beacon領域の生成
        region = CLBeaconRegion(proximityUUID:proximityUUID!,identifier:"AirMeet")
        //デリゲートの設定
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            print("観測開始")
            //self.status.text = "Starting Monitor"
            self.manager.startRangingBeaconsInRegion(self.region)
        case .NotDetermined:
            print("許可承認")
            //self.status.text = "Starting Monitor"
            //デバイスに許可を促す
            
            let deviceVer = UIDevice.currentDevice().systemVersion
            if(Int(deviceVer.substringToIndex(deviceVer.startIndex.advancedBy(1))) >= 8){
                
                //iOS8以降は許可をリクエストする関数をCallする
                self.manager.requestAlwaysAuthorization()
                print("OK")
            }else{
                self.manager.startRangingBeaconsInRegion(self.region)
            }
        case .Restricted, .Denied:
            //デバイスから拒否状態
            print("Restricted")
            //self.status.text = "Restricted Monitor"
        }
        
    }
    
    
    ///-----go
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region:CLBeaconRegion) {
        
        majorIDList = []
        
        if(beacons.count == 0) {
            //リストに何も受信していないことを表示
            print("nothing")
            return
        }
        //複数あった場合は一番先頭のものを処理する
        let beacon = beacons[0]
        
        //ここでつっこみ
        for i in 0..<beacons.count{
            majorIDList.append(beacons[i].major)
        }
        
        //重複捨て
        if(beacons.count != 0){
            let set = NSOrderedSet(array: majorIDList)
            majorIDList = set.array as! [NSNumber]
        }
        
        //-------go
        //ここで変更があったか検証します
        //サーバーにアクセス
        if(majorIDList.count != majorIDListOld.count){
            print("change list")
            print(majorIDList)
            majorIDListOld = majorIDList
            
            isChange = true
            
            
        }else{
            print("same")
            isChange = false
        }
        
        /*
        beaconから取得できるデータ
        proximityUUID   :   regionの識別子(アプリで予め決定)
        major           :   識別子１(イベント情報登録後にサーバーから発行)
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
        self.accuracy.text = "\(beacon.accuracy)"
        self.rssi.text     = "\(beacon.rssi)"
    }
    
    func reset(){
        self.status.text   = "none"
        self.uuid.text     = "none"
        self.major.text    = "none"
        self.accuracy.text = "none"
        self.rssi.text     = "none"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}