//
//  ChildFirstSettingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildFirstSettingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var SettingTableView: UITableView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    let testTag = [["name": "age", "detail" :"22"],["name": "趣味", "detail" :"デレステ♪"],["name": "好きなキャラ", "detail" :"ジバニャン"],["name": "得意分野", "detail" :"アプリ開発"],["name": "好きな言語", "detail" :"Swift"]]
    var tagCount:Int = 0
    
    var sessionTag:Int = 0
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        SettingTableView.delegate = self
        SettingTableView.dataSource = self
        
        eventLabel.text = "\(appDelegate.selectEvent!.eventName)"
        roomLabel.text = "\(appDelegate.selectEvent!.roomName)"
        
        //アイコンまる
        imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.borderWidth = 3.0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        //画像
        let imageData:NSData = defaults.objectForKey("image") as! NSData
        imageImageView.image = UIImage(data:imageData)
        
        let backData:NSData = defaults.objectForKey("back") as! NSData
        backImageView.image = UIImage(data: backData)
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //mainに戻る
        if appDelegate.isChild == true {
            
            appDelegate.isChild = false
            appDelegate.childID = nil
            //画面遷移
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            //self.performSegueWithIdentifier("BackToMain", sender: nil)
            //画面遷移
            //self.performSegueWithIdentifier("ShowDetailChild",sender: nil)
            
            /*sessionTag = 1
            
            
            // 通信用のConfigを生成.
            let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            // Sessionを生成.
            let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
            
            let post = "id=\(appDelegate.childID)"
            let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
            
            let url = NSURL(string: "http://airmeet.mybluemix.net/remove_user")
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            
            request.addValue("a", forHTTPHeaderField: "X-AccessToken")
            
            let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
            print("Start Session")
            //くるくるスタート
            self.view.addSubview(indicator)
            self.indicator.startAnimation()
            
            task.resume()*/
           
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("SettingTagTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.TagDetailTextField.delegate = self
        
        // testTagの一行分の内容を入れる
        //let object = testTag[indexPath.row]

        cell.TagNameLabel?.text = appDelegate.selectEvent!.eventTag[indexPath.row]//object["name"]!
        cell.TagDetailTextField?.tag = indexPath.row
        //cell.TagDetailTextField?.text = object["detail"]!
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.selectEvent!.eventTag.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        // appDelegate.selectEvent = events[indexPath.row]
        
        // appDelegate.selectChild = childs[indexPath.row]
        
        //画面遷移
        // performSegueWithIdentifier("showDetail",sender: nil)
        
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
        
    }
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        print("EventName:\(textField.text!)")
        
        /*switch textField.tag{
        case 0:
            eventName = textField.text!
            print("EventName:\(textField.text!)")
            
        case 1:
            roomName = textField.text!
            print("RoomName:\(textField.text!)")
            
        case 2:
            eventDescription = textField.text!
            print("EventDescription:\(textField.text!)")
            
        default:
            break
        }*/
        
        
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    
    @IBAction func ChildStartButton(sender: AnyObject) {
        
        var tagString:String = "{"
        
        
        for tag in appDelegate.selectEvent!.eventTag{
            
            tagString = tagString + "'\(tag)'" + ":" + "'筑波',"
        }
        
        tagString = tagString + "}"
        
        // 通信用のConfigを生成.
        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // Sessionを生成.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        let post = "major=\(appDelegate.selectEvent!.eventID)&name=test&image=test&image_header=test&items=\(tagString)"
        let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url = NSURL(string: "http://airmeet.mybluemix.net/register_user")
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        request.addValue("a", forHTTPHeaderField: "X-AccessToken")
        
        let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
        print("Start Session")
        //くるくるスタート
        sessionTag = 0
        self.view.addSubview(indicator)
        self.indicator.startAnimation()
        
        task.resume()
        
    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        //Json解析
        let json = JSON(data:data)
        let code:String = "\(json["code"])"
        let message = json["message"]
        
        switch sessionTag{
        case 0:
            
            appDelegate.childID = "\(json["id"])"
            
            //成功
            if code == "200"{
                
                print("User Login Sucsess : \(json["message"])")
                
                //メインスレッドで表示
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    //画面遷移
                    self.performSegueWithIdentifier("ShowDetailChild",sender: nil)
                    
                })
                
                appDelegate.isChild = true
                
                //失敗
            }else{
                print("User Login Error : \(json["message"])")
                
                let alert = UIAlertController(title:"False Make AirMeet",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                }
                alert.addAction(okAction)
                //メインスレッドで表示
                dispatch_async(dispatch_get_main_queue(), {
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            break
        case 1:
            
            
            //成功
            if code == "200"{
                
                print("User Delete Sucsess : \(json["message"])")
                appDelegate.isChild = false
                appDelegate.childID = nil
                
                //非同期
                dispatch_async(dispatch_get_main_queue(), {
                    //くるくるストップ
                    self.indicator.stopAnimation(true, completion: nil)
                    self.indicator.removeFromSuperview()
                    self.navigationController?.popToRootViewControllerAnimated(true)
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

    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
