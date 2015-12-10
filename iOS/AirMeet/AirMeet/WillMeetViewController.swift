//
//  WillMeetViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class WillMeetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate{
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var ChildTableView: UITableView!

    var childs:[ChildModel] = [ChildModel]()
        
    var refreshControl:UIRefreshControl!
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    var sessionTag:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        ChildTableView.delegate = self
        ChildTableView.dataSource = self
        
        //更新
        //ChildTableView.frame = CGRectMake(0, self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height)
        
        //let ChildTableViewWrapper = PullToBounceWrapper(scrollView: ChildTableView)
        //self.view.addSubview(ChildTableViewWrapper)
        //ChildTableViewWrapper.didPullToRefresh = {
        //    self.UserReload()
        //}
        
        //更新
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "UserReload", forControlEvents: UIControlEvents.ValueChanged)
        self.ChildTableView.addSubview(refreshControl)
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
        UserReload()
        
       // eventLabel.text = appDelegate.selectEvent?.eventName
       // roomLabels.text = appDelegate.selectEvent?.roomName
        
    }
    
    func UserReload(){
        
        print("\nReload\n")
        
        //からにする
        childs = []
        
        let eventID = appDelegate.selectEvent!.eventID
        var majorID = appDelegate.majorID
        var isInEvent:Bool = true
        
        //truefalseチェック
        //print("eventID : \(eventID)")
        //print("majorID : \(majorID)")
        
        //処理
        if(majorID.count != 0){
            for i in 0..<majorID.count{
                if(majorID[i] == eventID){
                    isInEvent = true
                    //print("match")
                    break
                }else{
                    //print("not macth")
                    isInEvent = false
                    
                }
            }
        }else{
            isInEvent = false
        }
        
        if isInEvent{
            print("stay")
            
            // 通信用のConfigを生成.
            let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            // Sessionを生成.
            let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
            
            let url = NSURL(string: "http://airmeet.mybluemix.net/api/participants?major=\(eventID)&id=\(appDelegate.childID!)")
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "GET"
            
            request.addValue("a", forHTTPHeaderField: "X-AccessToken")
            
            let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
            sessionTag = 0
            //くるくるスタート
            print("\nResume Task ↓")
            self.view.addSubview(self.indicator)
            self.indicator.startAnimation()
            
            task.resume()
            
            
        }else{
            
            if eventID == 34479{
                //てすとデータ
                
                // 通信用のConfigを生成.
                let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                // Sessionを生成.
                let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
                
                let url = NSURL(string: "http://airmeet.mybluemix.net/api/participants?major=\(eventID)&id=\(appDelegate.childID!)")
                
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                
                request.HTTPMethod = "GET"
                
                request.addValue("a", forHTTPHeaderField: "X-AccessToken")
                
                let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
                sessionTag = 0
                //くるくるスタート
                print("\nResume Task ↓")
                self.view.addSubview(self.indicator)
                self.indicator.startAnimation()
                
                task.resume()
                
            }else{
                print("left")
                
                //でーたからゆーざ消去
                // 通信用のConfigを生成.
                let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                
                // Sessionを生成.
                let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
                
                
                let post = "id=\(appDelegate.childID!)"
                let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
                
                let url = NSURL(string: "http://airmeet.mybluemix.net/api/remove_user")
                
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                
                request.addValue("a", forHTTPHeaderField: "X-AccessToken")
                
                let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
                
                print("Start Session")
                //くるくるスタート
                sessionTag = 1
                self.view.addSubview(indicator)
                self.indicator.startAnimation()
                
                //goがだしてるalertとぶつかる
                let alert = UIAlertController(title:"AirMeetを抜けました",message:"EventName : \(appDelegate.selectEvent!.eventName)\nRoomName : \(appDelegate.selectEvent!.roomName)",preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                        task.resume()
                }
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        print("\nDidReceiveData Task ↑")
        

        
        switch sessionTag{
        
        //追加
        case 0:
            
            //Json解析
            let json = JSON(data:data)
            
            let code:String = "\(json["code"])"
            let message = json["message"]
       
            //成功
            if code == "200"{
                
                print("Sucsess User Get : \(message)")
                
                
                //ユーザデータ解析
                for (id,detail) in json["users"]{
                    
                    print(id)
                    
                    let userJson = JSON(detail)
                    
                    print(userJson["name"])
                    print(userJson["profile"])
                               
                    var tagDics = [String:String]()
                    
                    for item in userJson["items"]{
                        tagDics["\(item.0)"] = "\(item.1)"
                    }
                    
                    
                    //画像を表示
                    let userImageUrl = NSURL(string: "\(userJson["image"])")
                    let backImageUrl = NSURL(string: "\(userJson["image_header"])")
                    var userImage = UIImage()
                    var backImage = UIImage()
                    
                    do{
                        let userImageData = try NSData(contentsOfURL: userImageUrl!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                        userImage = UIImage(data: userImageData)!
                        
                        let backImageData = try NSData(contentsOfURL: backImageUrl!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                        backImage = UIImage(data: backImageData)!
                    } catch{
                        print("False Image Get")
                        
                    }
                    
                    //参加しているユーザモデル作成
                    let child:ChildModel = ChildModel(image: userImage, backgroundImage:  backImage, name: "\(userJson["name"])", tag: tagDics,detail:"\(userJson["profile"])")
                    childs.append(child)
                    
                }
                
                
                //非同期
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    self.refreshControl.endRefreshing()
                    self.ChildTableView.reloadData()
                    
                })
                
            //失敗
            }else{
                
                print("False User Get : \(message)")
                
                let alert = UIAlertController(title:"False User Get",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                }
                alert.addAction(okAction)
                //非同期
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    self.refreshControl.endRefreshing()
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
            }
            break
        
        //消去
        case 1:
            
            
            //Json解析
            let json = JSON(data:data)
            let code:String = "\(json["code"])"
            let message = json["message"]
            
            //成功
            if code == "200"{
                
                print("User Delete Sucsess : \(json["message"])")
                
                
                //非同期
                dispatch_async(dispatch_get_main_queue(), {
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    //Exitからsegueを呼び出し
                    self.appDelegate.isChild = true
                    self.performSegueWithIdentifier("BackToMain", sender: nil)
                    //self.navigationController?.popToRootViewControllerAnimated(true)
                })
                //失敗
            }else{
                
                print("User Delete Error : \(json["message"])")
                
                let alert = UIAlertController(title:"False Delete User",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                }
                alert.addAction(okAction)
                
                //非同期
                dispatch_async(dispatch_get_main_queue(), {
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
                
            }
            
            break
        default:
            break
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:ChildTableViewCell = tableView.dequeueReusableCellWithIdentifier("ChildTableViewCell", forIndexPath: indexPath) as! ChildTableViewCell
        cell.setCell(childs[indexPath.row])
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childs.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Select User : \(indexPath.row)")
        
       // appDelegate.selectEvent = events[indexPath.row]
        
        appDelegate.selectChild = childs[indexPath.row]
        
        //画面遷移
        performSegueWithIdentifier("showDetail",sender: nil)
        
    }
    
    //イベントぬけたときに発動
    internal func isInEvent(){
        
       
        //self.performSegueWithIdentifier("BackToMain", sender: nil)

        
        /*let alert = UIAlertController(title:"AirMeetを抜けました",message:"",preferredStyle:.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                self.performSegueWithIdentifier("BackToMain", sender: nil)
                
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: false, completion: nil)*/
        
    }
    
    // Segueで遷移時の処理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetail") {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}