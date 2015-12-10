//
//  ViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource ,CLLocationManagerDelegate,ENSideMenuDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate{
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let defaultColor:UIColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
    
    //送信機側と合わせるUUID
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-33333B57FE6D")
    var region  = CLBeaconRegion()//UUIDの設定
    var manager = CLLocationManager()//iBeconを操作
    
    //majorIDリスト
    var majorIDList:[NSNumber] = []
    var majorIDListOld:[NSNumber] = []
    
    @IBOutlet weak var backImageView: UIImageView!//背景画像
    @IBOutlet weak var userImageView: UIImageView!//ユーザ画像
    
    @IBOutlet weak var facebookImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!//ユーザ名
    @IBOutlet weak var detailLabel: UILabel!//自己紹介
    
    @IBOutlet weak var profileChangeButton: UIButton!
    
    //@IBOutlet weak var facebookLinkLabel: UILabel!
    //@IBOutlet weak var twitterLinkLabel: UILabel!
    
    @IBOutlet weak var MenuBarButtonItem: UIBarButtonItem!//保留
    
    @IBOutlet weak var EventTableView: UITableView!
    var events:[EventModel] = [EventModel]()
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    //Viewの初回読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //よこからメニューのdelegate
        self.sideMenuController()?.sideMenu?.delegate = self
        
        //Navigationbar色
        self.navigationController?.navigationBar.barTintColor = defaultColor
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //Navigationbar画像
        let titleImageView = UIImageView( image: UIImage(named: "AirMeet-white.png"))
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.navigationController!.navigationBar.frame.height*0.8)
        self.navigationItem.titleView = titleImageView
        
        //子供モード、親モードか否か
        appDelegate.isChild = false
        appDelegate.isParent = false
        appDelegate.isBeacon = true
        
        EventTableView.delegate = self
        EventTableView.dataSource = self
        
        //アイコンまるく
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2.0
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.layer.borderWidth = 3.0
        
        //Facebook,Twitterアイコンまるく
        facebookImageView.layer.cornerRadius = 5.0//facebookImageView.frame.size.width/2.0
        facebookImageView.layer.masksToBounds = true
        facebookImageView.layer.borderColor = defaultColor.CGColor
        facebookImageView.layer.borderWidth = 1.0
        twitterImageView.layer.cornerRadius = 5.0//twitterImageView.frame.size.width/2.0
        twitterImageView.layer.masksToBounds = true
        twitterImageView.layer.borderColor = defaultColor.CGColor
        twitterImageView.layer.borderWidth = 1.0
        
        //プロフィール変更ボタン
        profileChangeButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        profileChangeButton.layer.borderWidth = 1.0
        
        //戻るボタン設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        ///（kmdr,momoka）
        ///おしゃれに（SpringIndicator）
        //ぐるぐる設定
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
        //テストデータ（仮）
        let event = EventModel(eventName: "TestEvent", roomName: "TestRoom", childNumber: 5, eventDescription: "TestDescription",eventTag:["趣味","所属"], eventID: 34479)
        events.append(event)
    
        //iBeacon領域生成
        region = CLBeaconRegion(proximityUUID:proximityUUID!,identifier:"AirMeet")
        manager.delegate = self
        
        //iBeacon初期設定
        switch CLLocationManager.authorizationStatus() {
        
            case .Authorized, .AuthorizedWhenInUse:
                print("iBeacon Permit")
                
                // バックグラウンドで入室を知らせる通知の登録
                sendLocalNotificationWithMessage("AirMeeeeet")
            
            case .NotDetermined:
                print("iBeacon No Permit")
                //デバイスに許可を促す
                let deviceVer = UIDevice.currentDevice().systemVersion
                
                if(Int(deviceVer.substringToIndex(deviceVer.startIndex.advancedBy(1))) >= 8){
                    self.manager.requestAlwaysAuthorization()
                }else{
                    self.manager.startMonitoringForRegion(self.region)
                }
                
            case .Restricted, .Denied:
                //デバイスから拒否状態
                print("iBeacon Restricted")
            
        }
        
    }
    
    //main画面が呼ばれるたびに呼ばれるよ
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Profile Reload")
        
        //初期の初期設定
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("name") == nil ||  defaults.objectForKey("image") == nil{
            print("First Launch")
            
            //デフォルト
            defaults.setObject("空気 会太郎", forKey: "name")
            defaults.setObject("よろしくおねがいします", forKey: "detail")
            
            let tagDics = ["所属名":"","住んでいる都道府県":"","趣味":"","専門分野":"","特技":"","発表内容":"","性別":"","年齢":""]
            defaults.setObject(tagDics, forKey: "tag")
            
            defaults.setObject(UIImagePNGRepresentation(userImageView.image!), forKey: "image")
            defaults.setObject(UIImagePNGRepresentation(backImageView.image!), forKey: "back")
            
            //iBeaconによる領域観測を開始する
            print("iBeacon Start\n　|\n　∨")
            self.manager.startMonitoringForRegion(self.region)
            
            //プロフィール設定画面に遷移
            let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: NSBundle.mainBundle())
            let profileViewController: ProfileSettingViewController = storyboard.instantiateInitialViewController() as! ProfileSettingViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        
        //プロフィール更新
        }else{
            
            //iBeconの監視を再開したいとき
            if (appDelegate.isBeacon == true && appDelegate.selectEvent == nil){
                
                //iBeaconによる領域観測を開始する
                //self.manager.delegate = self
                print("iBeacon Start\n　|\n　∨")
                self.manager.startMonitoringForRegion(self.region)
            }
            
            //Event登録画面からの帰還時はうごきっぱなし
            
            //Eventのselectを空にする
            appDelegate.selectEvent = nil
            
            //名前
            nameLabel.text = "\(defaults.stringForKey("name")!)"
            //自己紹介
            detailLabel.text = "\(defaults.stringForKey("detail")!)"
            
            //画像
            let imageData:NSData = defaults.objectForKey("image") as! NSData
            userImageView.image = UIImage(data:imageData)
            let backData:NSData = defaults.objectForKey("back") as! NSData
            backImageView.image = UIImage(data: backData)
        }
        
    }
    
    //LocationManagerがモニタリングを開始したというイベントを受け取る
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
    
        //ここですでにリージョン内にいるかを問い合わせる！！！これが大事
        manager.requestStateForRegion(region);
    }
    
    //観測開始後に呼ばれる、領域内にいるかどうか判定する
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch (state) {
            
        case .Inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            print("Enter　↓")
            //測定を開始する
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
        print("Enter　↓")
        //測定を開始する
        self.manager.startRangingBeaconsInRegion(self.region)
        
    }
    
    //領域から抜けた時
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit　↑")
        //測定を停止する
        self.manager.stopRangingBeaconsInRegion(self.region)
        
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
        
        //現在時刻取得
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        if appDelegate.selectEvent == nil{
        
            
            print("\(dateFormatter.stringFromDate(now)) : List \(majorIDList)")
        
            majorIDList = []
            
            //ibeconがないとき
            if(beacons.count == 0) {
                
                //最後の1つだったとき
                if(majorIDList.count != majorIDListOld.count){
                    print("\n\(dateFormatter.stringFromDate(now))  : Left AirMeet")
                    print("left major -> [\(majorIDListOld[0])]\n")
                    //競合するので、保留
                    //sendPush("AirMeet領域から出たよ")
                    events = []
                    
                    //テストデータ（仮）
                    let event = EventModel(eventName: "TestEvent", roomName: "TestRoom", childNumber: 5, eventDescription: "TestDescription",eventTag:["趣味","所属"], eventID: 34479)
                    events.append(event)
                    
                    EventTableView.reloadData()
                }
                
                appDelegate.majorID = []
                majorIDListOld = majorIDList
                
                return
            }
            
            //ibeconがあるとき、配列にする
            for i in 0..<beacons.count{
                majorIDList.append(beacons[i].major)
            }
            
            //重複捨て
            if(beacons.count != 0){
                let set = NSOrderedSet(array: majorIDList)
                majorIDList = set.array as! [NSNumber]
            }
            
            //1つ前の観測から変更があったとき
            if(majorIDList.count != majorIDListOld.count){
                
                //増えたとき
                if(majorIDList.count > majorIDListOld.count){
                    print("\n\(dateFormatter.stringFromDate(now))  : Add AirMeet")
                    //sendLocalNotificationWithMessage("領域に入りました")
                    sendPush("AirMeet領域に入ったよ")
                    
                    // 通信用のConfigを生成.
                    let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                    
                    // Sessionを生成.
                    let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
                    
                    var task:NSURLSessionDataTask!
                    
                    //新しく入ったやつを抽出
                    for newMajor in majorIDList.except(majorIDListOld){
                        print("new major -> [\(newMajor)]\n")
                        
                        let url = NSURL(string: "http://airmeet.mybluemix.net/api/event_info?major=\(newMajor)")
                        
                        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                        request.HTTPMethod = "GET"
                        request.addValue("a", forHTTPHeaderField: "X-AccessToken")
                        
                        task = mySession.dataTaskWithRequest(request)
                        
                        //測定を停止する
                        print("Exit　↑")
                        self.manager.stopRangingBeaconsInRegion(self.region)
                        //iBecon停止
                        print("　∧\n　|\niBeacon Stop\n")
                        self.manager.stopMonitoringForRegion(self.region)
                        
                        print("Resume Task ↓")
                        //くるくるスタート
                        self.view.addSubview(self.indicator)
                        self.indicator.startAnimation()
                        
                        task.resume()
                    }
                    
                //減った時（まだ他にもAirMeetがあるとき）
                }else{
                    print("\n\(dateFormatter.stringFromDate(now))  : Left AirMeet")
                    //sendPush("AirMeet領域から出たよ")
                    for leftMajor in majorIDListOld.except(majorIDList){
                        print("left major -> [\(leftMajor)]\n")
                        for (index,event) in  events.enumerate(){
                            if event.eventID == leftMajor{
                                 events.removeAtIndex(index)
                                 EventTableView.reloadData()
                                
                            }
                        }
                        
                    }

                }
                

                appDelegate.majorID = majorIDList
                majorIDListOld = majorIDList
            }
            
        //イベントを選択しているとき
        }else{
            
            print("\(dateFormatter.stringFromDate(now)) : SelectEvent -> \(appDelegate.selectEvent!.eventID)")
            
            var isInEvent:Bool = true
            majorIDList = []
            
            if(beacons.count == 0) {
                isInEvent = false
            }else{
                //ibeconがあるとき、配列にする
                for i in 0..<beacons.count{
                    majorIDList.append(beacons[i].major)
                }
                
                for majorID in majorIDList{
                    if majorID == appDelegate.selectEvent!.eventID{
                        isInEvent = true
                    }else{
                        isInEvent = false
                        appDelegate.selectEvent = nil
                        
                        
                        
                    }
                }
            }
            
            //選択したイベントにいたら
            if isInEvent{
                print("isInEvent : true")
            //いなかったら
            }else{
                print("isInEvent : false")
                
                //let willMeetViewController = WillMeetViewController()
                self.appDelegate.selectEvent = nil
                //willMeetViewController.isInEvent()
                
                
                
            }
            
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
    
    //データ転送中の状況
    //func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        //print( bytesSent/totalBytesSent * 100 )
        
    //}
    
    //転送が完了したとき
    //func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
    //}
    
    //データを取得したとき
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        print("\nDidReceiveData Task ↑")
        //セッションを終える
        session.invalidateAndCancel()

        // print(data)
        let json = JSON(data:data)
        //print("JSON:\(json)\n")
        
        //失敗
        if String(json["code"]) == "400" || String(json["code"]) == "500"{
            
            print("\nFalse Server Connection : \(json["message"])\n")
            
            let alert = UIAlertController(title:"False Get AirMeet",message:"\(json["message"])",preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
            }
            alert.addAction(okAction)
            
            //iBeconStart
            //self.manager.startMonitoringForRegion(self.region)
            session.invalidateAndCancel()
            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                self.presentViewController(alert, animated: true, completion: nil)
                
            })
            
        //成功
        }else{
            
            let majorString:String = "\(json["major"])"
            let majorInt:Int = Int(majorString)!
            let majorNumber:NSNumber = majorInt as NSNumber
            
            let countInt:Int = Int("\(json["count"])")!
        
            var itemArray:[String] = []// = json["items"] as Array
            
            for item in json["items"]{
                //0:index 1:中身
                itemArray.append("\(item.1)")
            }
            
            print("\nSucsess Server Connection\n EventName -> \(json["event_name"]) \n RoomName  -> \(json["room_name"])")
            print(" items     -> \(itemArray)\n")
            
            //eventモデルを生成してtableviewに追加
            let event = EventModel(eventName: "\(json["event_name"])", roomName: "\(json["room_name"])", childNumber: countInt, eventDescription: "\(json["description"])",eventTag:itemArray, eventID: majorNumber)
            self.events.append(event)
            
            //iBeconをStartする
            print("iBeacon Start\n　|\n　∨")
            self.manager.startMonitoringForRegion(self.region)

            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                self.EventTableView.reloadData()

            })
            
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
    
    //ローカル通知(background)
    func sendLocalNotificationWithMessage(message: String!) {
        
        let notificationSettings =  UIUserNotificationSettings(forTypes:
            [UIUserNotificationType.Sound,
                UIUserNotificationType.Alert], categories: nil)
        
        // アプリケーションに通知設定を登録
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        // ビーコン領域をトリガーとした通知を作成
        let notification = createRegionNotification(proximityUUID!, message: message)
        // 通知を登録する
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    // バックグラウンドでの入室監視
    private func createRegionNotification(uuid: NSUUID, message: String) -> UILocalNotification {
        
        // ビーコン領域を作成
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "RegionId")
        beaconRegion.notifyEntryStateOnDisplay = false
        beaconRegion.notifyOnEntry = true
        // 領域に入ったときにも出たときにも通知される
        // 今回は領域から出たときの通知はRegion側でOFFにしておく
        beaconRegion.notifyOnExit = false
        
        // 通知を作成し、領域を設定
        let notification = UILocalNotification()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = message
        
        // 通知の対象となる領域
        notification.region = beaconRegion
        // 一度だけの通知かどうか
        notification.regionTriggersOnce = false
        
        return notification
    }


    //会場情報を入れるtableViewのcellセット
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.setCell(events[indexPath.row])
        
        return cell
    }
    
    //tableViewセクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //tableViewセクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    //[子]tableViewのcell（event）が選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //eventが選択されたとき、それ以外の観測をやめたい
        print("\nSelect Event : \(events[indexPath.row].eventName)\n")
        
        //選択したEvent情報を保持して
        appDelegate.selectEvent = events[indexPath.row]
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Child", bundle: NSBundle.mainBundle())
        let childViewController: JoinAirMeetViewController = storyboard.instantiateInitialViewController() as! JoinAirMeetViewController
        
        //子モードに遷移
        self.navigationController?.pushViewController(childViewController, animated: true)
        
    }
    
    //[親]AirMeet設定画面に遷移
    @IBAction func ParentButton(sender: AnyObject) {
        
        //appDelegate.isBeacon = false
        print("Parent Made\n")
        
        //測定を停止する
        print("Exit　↑")
        self.manager.stopRangingBeaconsInRegion(self.region)
        //iBecon停止
        print("　∧\n　|\niBeacon Stop\n")
        self.manager.stopMonitoringForRegion(self.region)
        
        //空にする
        events = []
        EventTableView.reloadData()
        majorIDListOld = []
        majorIDList = []
        appDelegate.majorID = []
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Parent", bundle: NSBundle.mainBundle())
        let parentViewController: MakeAirMeetViewController = storyboard.instantiateInitialViewController() as! MakeAirMeetViewController
        self.navigationController?.pushViewController(parentViewController, animated: true)
        
    }
    
    //子
    @IBAction func ChildButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Child", bundle: NSBundle.mainBundle())
        let childViewController: JoinAirMeetViewController = storyboard.instantiateInitialViewController() as! JoinAirMeetViewController
        
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
        let profileViewController: ProfileSettingViewController = storyboard.instantiateInitialViewController() as! ProfileSettingViewController
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
    
    @IBAction func MenuButton(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//arrayを拡張、要素の比較
extension Array {
    
    mutating func remove<T : Equatable>(obj : T) -> Array {
        self = self.filter({$0 as? T != obj})
        return self;
    }
    
    func contains<T : Equatable>(obj : T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
    func except<T : Equatable>(obj: [T]) -> [T] {
        var ret = [T]()
        
        for x in self {
            if !obj.contains(x as! T) {
                ret.append(x as! T)
            }
        }
        return ret
    }
    
}


