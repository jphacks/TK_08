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
        
        //let ud = NSUserDefaults.standardUserDefaults()
        
        //ud.setObject(tags[0].detail, forKey: "name")
        //ud.setObject(tags[1].detail, forKey: "detail")

        
        //会場追加
        //let event:EventModel = EventModel(eventName: "JPHacks-東京会場", roomName: "東京大学 本郷キャンパス215教室", childNumber: 50, eventDescription: "aaa",eventID:203)
        //events.append(event)
        
        //------iBecon
        //CLBeaconRegionを生成
        region = CLBeaconRegion(proximityUUID:proximityUUID!,identifier:"AirMeet")
        //デリゲートの設定
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            print("iBecon Start")
            self.manager.startRangingBeaconsInRegion(self.region)
        case .NotDetermined:
            print("iBecon No Permit")
            //デバイスに許可を促す
            let deviceVer = UIDevice.currentDevice().systemVersion
            
            if(Int(deviceVer.substringToIndex(deviceVer.startIndex.advancedBy(1))) >= 8){
                //iOS8以降は許可をリクエストする関数をCallする
                self.manager.requestAlwaysAuthorization()
                print("iBecon OK")
            }else{
                self.manager.startRangingBeaconsInRegion(self.region)
            }
            
        case .Restricted, .Denied:
            //デバイスから拒否状態
            print("iBecon Restricted")
        }
        
        //---------------
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Profile Reload")
        
       // if self.manager.requestStateForRegion(self.region){
            
            
        //}
        
        //プロフィール更新
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("name") == nil || defaults.stringForKey("facebook") == nil || defaults.objectForKey("image") == nil{
            print("First Launch")
            
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
    
    //iBecon
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region:CLBeaconRegion) {
        
        if (appDelegate.isParent == true){
            print("Parent Made")
            //self.manager.stopRangingBeaconsInRegion(self.region)
            
        }else{
            print("Child Made")
        
            majorIDList = []
            
            
            if(beacons.count == 0) {
                //受信していない
                print("\(NSDate()) : No AirMeet")
                appDelegate.majorID = []
                //変更があったとき
                if(majorIDList.count != majorIDListOld.count){
                    print("\(NSDate()) : Change AirMeet")
                    events = []
                   // let event = EventModel(eventName: "nil", roomName: "nil", childNumber: 0, eventDescription: "nil",eventID:0)
                   // events.append(event)
                   // EventTableView.deleteRowsAtIndexPaths([NSIndexPath(index: 0)], withRowAnimation: .Automatic)
                    
                    EventTableView.reloadData()
                    
                }
                
                majorIDListOld = majorIDList
                
                return
            }
            
            //複数あった場合は一番先頭のものを処理する
            let beacon = beacons[0]
            
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
                print(majorIDList)
                
                AppDelegate().pushControll()
                events = []
                
                //サーバーに接続
                for majorID in majorIDList{

                    let json = JSON(url: "http://airmeet.mybluemix.net/event_info?major=\(majorID)")

                    print("Server Reserve Code = \(json["code"])")
                    
                    //失敗
                    if String(json["code"]) == "400"{
                        
                        //event = EventModel(eventName: "nil", roomName: "nil", childNumber: 0, eventDescription: "nil",eventID: majorID)
                        print("Server Connection Error[\(majorID)]：\(json["event_name"])")
                    
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
                print("same")
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
                //self.distance.text = "Unknown Proximity"
                reset()
                return
            } else if (beacon.proximity == CLProximity.Immediate) {
                //self.distance.text = "Immediate"
            } else if (beacon.proximity == CLProximity.Near) {
                //self.distance.text = "Near"
            } else if (beacon.proximity == CLProximity.Far) {
                //self.distance.text = "Far"
            }
            //self.status.text   = "OK"
            //self.uuid.text     = beacon.proximityUUID.UUIDString
            //self.major.text    = "\(beacon.major)"
            //self.minor.text    = "\(beacon.minor)"
            //self.accuracy.text = "\(beacon.accuracy)"
            //self.rssi.text     = "\(beacon.rssi)"
            
        }
    }
    
    func reset(){
        //self.status.text   = "none"
        //self.uuid.text     = "none"
        //self.major.text    = "none"
        //self.minor.text    = "none"
        //self.accuracy.text = "none"
        //self.rssi.text     = "none"
    }
    ///-----
    
    
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
        
        print(indexPath.row)
        
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


