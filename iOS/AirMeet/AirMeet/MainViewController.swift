//
//  ViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit
import CoreLocation
//

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,CLLocationManagerDelegate,ENSideMenuDelegate{
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //UUIDは送信機側とフォーマットも合わせる
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-33333B57FE6D")
    var region  = CLBeaconRegion()
    var manager = CLLocationManager()
    
    //majorIDリスト用のグローバル変数
    var majorIDList:[NSNumber] = []
    var majorIDListOld:[NSNumber] = []
    
    var tags:[TagModel] = [TagModel]()
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var EventTableView: UITableView!
    
    @IBOutlet weak var profileChangeButton: UIButton!
    
    @IBOutlet weak var faceLinkLabel: UILabel!
    @IBOutlet weak var twitterLinkLabel: UILabel!
    
    
    @IBOutlet weak var MenuBarButtonItem: UIBarButtonItem!
    var events:[EventModel] = [EventModel]()
    
    class Event {
        var eventName:String!
        var roomName:String!
        var childNumber:Int!
        var eventDescription:String!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        //Navigationbar色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //Navigationbar画像
        let titleImageView = UIImageView( image: UIImage(named: "AirMeet-white.png"))
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.navigationController!.navigationBar.frame.height*0.8)
        self.navigationItem.titleView = titleImageView
        
        appDelegate.isChild = false
        appDelegate.isParent = false
        
        EventTableView.delegate = self
        EventTableView.dataSource = self
        
        //アイコンまる
        imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.borderWidth = 3.0
        
        profileChangeButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        profileChangeButton.layer.borderWidth = 1.0
        
        //戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        //テストデータ
        let event = EventModel(eventName: "testEvent", roomName: "testRoom", childNumber: 0, eventDescription: "testDescription",eventID: 100)
        events.append(event)
    
        
        //iBecon
        //Beacon領域生成
        region = CLBeaconRegion(proximityUUID:proximityUUID!,identifier:"AirMeet")
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        
        case .Authorized, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            print("iBecon Start")
            //self.manager.startRangingBeaconsInRegion(self.region)
            self.manager.startMonitoringForRegion(self.region)
        
        case .NotDetermined:
            print("iBecon No Permit")
            //デバイスに許可を促す
            let deviceVer = UIDevice.currentDevice().systemVersion
            
            if(Int(deviceVer.substringToIndex(deviceVer.startIndex.advancedBy(1))) >= 8){
                self.manager.requestAlwaysAuthorization()
                //print("iBecon OK?")
               // self.manager.startMonitoringForRegion(self.region)
            }else{
                //self.manager.startRangingBeaconsInRegion(self.region)
                self.manager.startMonitoringForRegion(self.region)
            }
            
        case .Restricted, .Denied:
            //デバイスから拒否状態
            print("iBecon Restricted")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Profile Reload")
        
        
        //プロフィール更新
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("name") == nil || defaults.stringForKey("facebook") == nil || defaults.objectForKey("image") == nil{
            print("First Launch")
            
            //デフォルト
            defaults.setObject("空気 出会い", forKey: "name")
            defaults.setObject("よろしくおねがいします", forKey: "detail")
            defaults.setObject("空気出会い", forKey: "facebook")
            defaults.setObject("@AirMeet", forKey: "twitter")
            
            defaults.setObject(UIImagePNGRepresentation(imageImageView.image!), forKey: "image")
            defaults.setObject(UIImagePNGRepresentation(backImageView.image!), forKey: "back")
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: NSBundle.mainBundle())
            let profileViewController: ProfileViewController = storyboard.instantiateInitialViewController() as! ProfileViewController
            
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
        }else{
            //名前
            nameLabel.text = "\(defaults.stringForKey("name")!)"
            //自己紹介
            detailLabel.text = "\(defaults.stringForKey("detail")!)"
            //facebook
            faceLinkLabel.text = "\(defaults.stringForKey("facebook")!)"
            //twitter
            twitterLinkLabel.text = "\(defaults.stringForKey("twitter")!)"
            
            //画像
            let imageData:NSData = defaults.objectForKey("image") as! NSData
            imageImageView.image = UIImage(data:imageData)
            
            let backData:NSData = defaults.objectForKey("back") as! NSData
            backImageView.image = UIImage(data: backData)
        }
        
    }
    
    @IBAction func MenuButton(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    //観測開始後に呼ばれる、領域内にいるかどうか判定する
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch (state) {
            
        case .Inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            self.manager.startRangingBeaconsInRegion(self.region)
            // →(didRangeBeacons)で測定をはじめる
            break;
            
        case .Outside:
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        case .Unknown:
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            break;
        }
    }
    
    //領域に入った時
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter")
        
        // →(didRangeBeacons)で測定をはじめる
        self.manager.startRangingBeaconsInRegion(self.region)
        
        //ローカル通知
        //sendLocalNotificationWithMessage("領域に入りました")
        //AppDelegate().pushControll()
        //sendPush("AirMeet領域に入りました")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit")
        
        //測定を停止する
        self.manager.stopRangingBeaconsInRegion(self.region)
        
        //sendLocalNotificationWithMessage("領域から出ました")
        //AppDelegate().pushControll()
        //sendPush("AirMeet領域から出ました")
    }
    
    //観測失敗
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        
        print("monitoringDidFailForRegion \(error)")
    }
    
    //通信失敗
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("didFailWithError \(error)")
    }
    
    //領域内にいるので測定をする
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region:CLBeaconRegion) {
        
        //親モード
        if (appDelegate.isParent == true){
            print("\(NSDate()) : Parent Made")
            //self.manager.stopRangingBeaconsInRegion(self.region)
            
        }else{
            print("\(NSDate()) : Child Made")
        
            majorIDList = []
            
            if(beacons.count == 0) {
                //受信していない
                print("No AirMeet")
                appDelegate.majorID = []
                //変更があったとき
                if(majorIDList.count != majorIDListOld.count){
                    print("\(NSDate()) : Change AirMeet")
                    sendPush("AirMeet領域から出たよ")
                    events = []
                    EventTableView.reloadData()
                }
                
                majorIDListOld = majorIDList
                
                return
            }else{
                //sendPush("AirMeet領域にいます")
            }
            
            for i in 0..<beacons.count{
                majorIDList.append(beacons[i].major)
            }
        
            //重複捨て
            if(beacons.count != 0){
                let set = NSOrderedSet(array: majorIDList)
                majorIDList = set.array as! [NSNumber]
            }
            
            majorIDList = majorIDList.reverse()
            
            //変更があったときの処理
            if(majorIDList.count != majorIDListOld.count){
                print("\(NSDate()) : Change AirMeet")
                if(majorIDList.count > majorIDListOld.count){
                    sendPush("AirMeet領域に入ったよ")
                }else{
                    sendPush("AirMeet領域から出たよ")
                }
                print(majorIDList)
                
                //AppDelegate().pushControll()
                events = []
                
                //サーバーに接続
                for majorID in majorIDList{

                    let json = JSON(url: "http://airmeet.mybluemix.net/event_info?major=\(majorID)")
                    print("Server Reserve Code = \(json["code"])")
                    
                    //失敗
                    if String(json["code"]) == "400"{
                        
                        print("Server Connection Error[\(majorID)]：\(json["message"])")
                    
                    //成功
                    }else{
                        
                        let event = EventModel(eventName: "\(json["event_name"])", roomName: "\(json["room_name"])", childNumber: 0, eventDescription: "\(json["description"])",eventID: majorID)
                        events.append(event)
                        
                        print("Server Connection Sucsess[\(majorID)]：\(json["event_name"]) - \(json["room_name"])")
                    
                    }
                }

                EventTableView.reloadData()
                
                appDelegate.majorID = majorIDList
                majorIDListOld = majorIDList
                
                
            }else{
                //print("same")
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
        }
    }
    
    //プッシュ通知(forground)
    func sendPush(message: String){
        
        let alert = UIAlertController(title:"\(message)",message:nil,preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) {
            action in
        }
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //ローカル通知(現状機能してない)
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.setCell(events[indexPath.row])
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Select Event : \(indexPath.row)")
        
        appDelegate.selectEvent = events[indexPath.row]
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Child", bundle: NSBundle.mainBundle())
        let childViewController: ChildFirstSettingViewController = storyboard.instantiateInitialViewController() as! ChildFirstSettingViewController
        
        self.navigationController?.pushViewController(childViewController, animated: true)
        
    }
    
    //親
    @IBAction func ParentButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Parent", bundle: NSBundle.mainBundle())
        let parentViewController: ParentSettingViewController = storyboard.instantiateInitialViewController() as! ParentSettingViewController
        
        self.navigationController?.pushViewController(parentViewController, animated: true)
    }
    
    //子
    @IBAction func ChildButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Child", bundle: NSBundle.mainBundle())
        let childViewController: ChildFirstSettingViewController = storyboard.instantiateInitialViewController() as! ChildFirstSettingViewController
        
        self.navigationController?.pushViewController(childViewController, animated: true)
        
    }
    
    //Meet
    @IBAction func MeetButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Meet", bundle: NSBundle.mainBundle())
        let meetViewController: MeetListViewController = storyboard.instantiateInitialViewController() as! MeetListViewController
        
        self.navigationController?.pushViewController(meetViewController, animated: true)
    }
    
    //プロフィール
    @IBAction func ProfileButton(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: NSBundle.mainBundle())
        let profileViewController: ProfileViewController = storyboard.instantiateInitialViewController() as! ProfileViewController
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


