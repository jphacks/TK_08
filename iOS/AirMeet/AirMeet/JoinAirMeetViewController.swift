//
//  JoinAirMeetViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class JoinAirMeetViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate,UIScrollViewDelegate {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDetailLabel: UILabel!
    
    @IBOutlet weak var eventNumberLabel: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var TagSettingTableView: UITableView!
    
    var selectIndex:NSIndexPath = NSIndexPath()
    var selectTextFiled:UITextField = UITextField()
    
    var tags:[TagModel] = [TagModel]()
    
    var tagCount:Int = 0
    
    var tagDics = [String:String]()
    
    @IBOutlet weak var eventBackView: UIView!
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        TagSettingTableView.delegate = self
        TagSettingTableView.dataSource = self
        
        scrollView.delegate = self
        
        eventLabel.text = "\(appDelegate.selectEvent!.eventName)"
        roomLabel.text = "\(appDelegate.selectEvent!.roomName)"
        eventNumberLabel.text = "\(appDelegate.selectEvent!.childNumber)人"
        
        //アイコンまる
        imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.borderWidth = 3.0
        
        //event情報
        eventBackView.layer.cornerRadius = 3.0
        eventBackView.layer.masksToBounds = true
        eventBackView.layer.borderColor = UIColor.lightGrayColor().CGColor
        eventBackView.layer.borderWidth = 1.0
        
        //最初はデフォルトの情報いれる
        let defaults = NSUserDefaults.standardUserDefaults()
        userNameLabel.text = "\(defaults.stringForKey("name")!)"
        userDetailLabel.text = "\(defaults.stringForKey("detail")!)"
        
        //画像
        let imageData:NSData = defaults.objectForKey("image") as! NSData
        imageImageView.image = UIImage(data:imageData)
        let backData:NSData = defaults.objectForKey("back") as! NSData
        backImageView.image = UIImage(data: backData)
        
        //ぶらー
        let blurEffect = UIBlurEffect(style: .Light)
        let lightBlurView = UIVisualEffectView(effect: blurEffect)
        lightBlurView.frame = backImageView.bounds
        backImageView.addSubview(lightBlurView)
        
        //文字を擦ったかんじに
        let lightVibrancyView =
        vibrancyEffectView(
            fromBlurEffect: lightBlurView.effect as! UIBlurEffect,
            frame: backImageView.bounds)
        lightBlurView.contentView.addSubview(lightVibrancyView)
        
        lightVibrancyView.contentView.addSubview(userNameLabel)
        lightVibrancyView.contentView.addSubview(userDetailLabel)
        
        
        //戻るボタン設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
        tagDics = defaults.objectForKey("tag") as! [String:String]
        
        //tagテーブルに値いれる
        for name in appDelegate.selectEvent!.eventTag{
            
            if (tagDics["\(name)"] != nil){
                let tagModel:TagModel = TagModel(name: "\(name)", detail: "\(tagDics["\(name)"]!)")
                tags.append(tagModel)
                
            }else{
                let tagModel:TagModel = TagModel(name: "\(name)", detail: "")
                tags.append(tagModel)
            }
        }
        
        
    }
    
    // VibrancyエフェクトのViewを生成
    func vibrancyEffectView(fromBlurEffect effect: UIBlurEffect, frame: CGRect) -> UIVisualEffectView {
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: effect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = frame
        return vibrancyView
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        //キーボード
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        ///ここでは変更した内容を一時保存していれよう
        
        //とりあえずデフォルトの情報いれる
        let defaults = NSUserDefaults.standardUserDefaults()
        userNameLabel.text = "\(defaults.stringForKey("name")!)"
        userDetailLabel.text = "\(defaults.stringForKey("detail")!)"

        
        //mainに戻る
        if appDelegate.isChild == true {
            
            appDelegate.isChild = false
            appDelegate.childID = nil
            appDelegate.isBeacon = true
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        //キーボード
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //スクロールをはじめたらキーボードを閉じる
        selectTextFiled.resignFirstResponder()
        
    }
    
    
    //自動スクロール（にしゅうスクロール、可変にする？要検討）
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let cell: SettingTagTableViewCell = TagSettingTableView.dequeueReusableCellWithIdentifier("TagSettingTableViewCell", forIndexPath: selectIndex) as! SettingTagTableViewCell
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        
        let txtLimit = cell.frame.origin.y + cell.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        //scrollView.contentOffset.y = 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("TagSettingTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.setCell(tags[indexPath.row])
        //入力されたテキストを取得するタグとデリゲート
        cell.TagTextField.delegate = self
        cell.TagTextField.tag = indexPath.row
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    
    //UITextFieldが編集開始する直前に呼ばれる
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //選択されたindexを保存
        selectIndex = NSIndexPath(forRow: textField.tag, inSection: 0)
        //スクロールしたらキーボードが消える用
        selectTextFiled = textField
        return true
    }
    
    //UITextFieldが編集終了する直前に呼ばれる
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        //tag保存
        print("Save Tag Detail : \(textField.placeholder!) -> \(textField.text!)")
        tagDics.updateValue("\(textField.text!)", forKey: "\(textField.placeholder!)")

        
        return true
    }
    
    //改行ボタンが押された際に呼ばれる
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func JoinProfileSetting(sender: AnyObject) {
        
    }
    
    
    @IBAction func ChildStartButton(sender: AnyObject) {
        
        //初期の初期設定
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        //いい感じに配列にして渡す
        var tagString:String = "{"
        
        for tag in tags{
            
            tagString = tagString + "'\(tag.name)'" + ":" + "'\(tag.detail)',"
        }
        
        tagString = tagString + "}"
        
        //送信する画像
        let userImageData:NSData = NSData(data:UIImageJPEGRepresentation(imageImageView.image!, 1.0)!)
        let backImageData:NSData = NSData(data:UIImageJPEGRepresentation(backImageView.image!, 1.0)!)
        
        let url = NSURL(string: "http://airmeet.mybluemix.net/api/register_user")
        let urlRequest : NSMutableURLRequest = NSMutableURLRequest()
        
        if let u = url{
            urlRequest.URL = u
            urlRequest.HTTPMethod = "POST"
            urlRequest.timeoutInterval = 30.0
            urlRequest.addValue("a", forHTTPHeaderField: "X-AccessToken")
        }
        
        //bodyの作成
        //httpヘッダーの情報の登録
        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        let body: NSMutableData = NSMutableData()
        var postData :String = String()
        let boundary:String = "---------------------------\(uniqueId)"//境界、本体に含まれないようユニークにする
        
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type") //マルチパートのデータ
        
        //文字列のとこ
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"major\"\r\n\r\n"
        postData += "\(appDelegate.selectEvent!.eventID)\r\n"
        
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"name\"\r\n\r\n"
        postData += "\(defaults.stringForKey("name")!)\r\n"
        
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"profile\"\r\n\r\n"
        postData += "\(defaults.stringForKey("detail")!)\r\n"
        
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"items\"\r\n\r\n"
        postData += "\(tagString)\r\n"
        
        //画像のとこ
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"image\"; filename=\"UserImage.jpeg\"\r\n"
        postData += "Content-Type: image/jpeg\r\n\r\n"
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(userImageData)
        postData = String()
        postData += "\r\n"
        
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"image_header\"; filename=\"BackImage.jpeg\"\r\n"
        postData += "Content-Type: image/jpeg\r\n\r\n"
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(backImageData)
        postData = String()
        postData += "\r\n"
        
        postData += "\r\n--\(boundary)--\r\n"
        
        body.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!) //(3)
        
        urlRequest.HTTPBody = NSData(data:body)
        
        
        //リクエストを送信
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
      
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(urlRequest, completionHandler:
        {data, request, error in
        //結果出力
            print("\nDidReceiveData Task ↑")
            
            if (error != nil){
                
                print("False Join AirMeet : \(error)")
                
                let alert = UIAlertController(title:"False Join AirMeet",message:"\(error)",preferredStyle:UIAlertControllerStyle.Alert)
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
                
            }else{
                //print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
                self.EndMutableURLSession(data!)
            }
        
        })
        
        print("\nResume Task ↓")
        scrollView.contentOffset.y = -(self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height)
        
        self.view.addSubview(indicator)
        self.indicator.startAnimation()
        
        task.resume()

    }
    
    func EndMutableURLSession(data:NSData){
        
        //Json解析
        let json = JSON(data:data)
        let code:String = "\(json["code"])"
        let message = json["message"]
        
            
        appDelegate.childID = "\(json["id"])"
        
        //成功
        if code == "200"{
            
            print("Sucsess Join AirMeet : \(json["message"])")
            
            //メインスレッドで表示
            dispatch_async(dispatch_get_main_queue(), {
                
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                //画面遷移
                self.appDelegate.isChild = true
                self.performSegueWithIdentifier("ShowDetailChild",sender: nil)
                
            })
            
            
            
            //失敗
        }else{
            print("False Join AirMeet : \(json["message"])")
            
            let alert = UIAlertController(title:"False Join AirMeet",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
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
        
        
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}