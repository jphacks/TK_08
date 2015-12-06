//
//  ChildListViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDataDelegate{
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var ChildTableView: UITableView!
    
    //@IBOutlet weak var roomLabels: UILabel!
    //@IBOutlet weak var eventLabel: UILabel!
    var childs:[ChildModel] = [ChildModel]()
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
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
        
        let tag1:Dictionary<String,String> = ["年齢":"22","所属":"筑波大学","趣味":"モンハン"]
        let tag2:Dictionary<String,String> = ["年齢":"21","所属":"東京大学","趣味":"スクフェス"]
        let tag3:Dictionary<String,String> = ["年齢":"24","所属":"早稲田大学","趣味":"デレステ"]
        
        //子追加
        let child1:ChildModel = ChildModel(image: UIImage(named: "go_face.png")!, backgroundImage:  UIImage(named: "go_back.png")!, name: "さとうごう", tag: tag1,detail:"がんばるぞ〜！！今日も可愛い女の子ゲットするぞ〜！！LINEもってる〜？？")
        let child2:ChildModel = ChildModel(image: UIImage(named: "IMG_9004.JPG")!, backgroundImage:  UIImage(named: "IMG_9003.JPG")!, name: "こーたけ", tag: tag2,detail:"今日はよろしくお願いします！ピカチュウが大好きです♪")
        let child3:ChildModel = ChildModel(image: UIImage(named: "IMG_8996.JPG")!, backgroundImage:  UIImage(named: "IMG_9002.JPG")!, name: "うぉるこふ", tag: tag3,detail:"Unity使ってます。筑波大学の3年生です。")
        
        childs.append(child1)
        childs.append(child2)
        childs.append(child3)
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
       // eventLabel.text = appDelegate.selectEvent?.eventName
       // roomLabels.text = appDelegate.selectEvent?.roomName
        
    }
    
    //再読み込み
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Reload")
        
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
            print("stay in")
            
            // 通信用のConfigを生成.
            let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            // Sessionを生成.
            let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
            
            let url = NSURL(string: "http://airmeet.mybluemix.net/participants?major=\(eventID)&id=\(appDelegate.childID!)")
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "GET"
            
            request.addValue("a", forHTTPHeaderField: "X-AccessToken")
            
            let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
            
            //くるくるスタート
            self.view.addSubview(self.indicator)
            self.indicator.startAnimation()
            
            print("Start Session")
            task.resume()
            
        }else{
            print("left")
            
            
            //goがだしてるalertとぶつかる、セグエをswich caseで呼び出してくか、こっちで書くかなやましい
            let alert = UIAlertController(title:"AirMeetを抜けました",message:"EventName : \(appDelegate.selectEvent!.eventName)\nRoomName : \(appDelegate.selectEvent!.roomName)",preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                //Exitからsegueを呼び出し
                self.performSegueWithIdentifier("BackToMain", sender: nil)
            }
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        //Json解析
        let json = JSON(data:data)
        
        let code:String = "\(json["code"])"
        let message = json["message"]
       

        //成功
        if code == "200"{
            
            print("User Get Sucsess : \(message)")
            
            let users = json["users"]
            print("Users : \(users)")
            
            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                
            })
            
            
            //失敗
        }else{
            
            print("User Get False : \(message)")
            
            let alert = UIAlertController(title:"False Make AirMeet",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
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
    
    // Segueで遷移時の処理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetail") {
           // let GroupVC : ChildListDetailViewController = (segue.destinationViewController as? ChildListDetailViewController)!
           // GroupVC.groupName = selectGroup
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}