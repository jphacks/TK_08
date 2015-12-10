//
//  ParentViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class MakeAirMeetViewController: UIViewController,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate,UITableViewDelegate,UITableViewDataSource {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var EventNameTextField: UITextField!
    @IBOutlet weak var RoomNameTextField: UITextField!
    
    var eventName:String?
    var roomName:String?
    var eventDescription:String?

    @IBOutlet weak var MakeAirMeetButton: UIButton!
    @IBOutlet weak var selectTagTableView: UITableView!
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    var tagDics = [String:String]()
    var tagArray = [String]()
    
    //  チェックされたセルの位置を保存しておく辞書をプロパティに宣言
    var selectedCells:[String:Bool]=[String:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        self.EventNameTextField.delegate = self
        self.RoomNameTextField.delegate = self
        
        self.EventNameTextField.tag = 0
        self.RoomNameTextField.tag = 1
        
        MakeAirMeetButton.enabled = false
        MakeAirMeetButton.alpha = 0.5
        
        //テーブルビューの設定
        selectTagTableView.allowsMultipleSelection = true
        selectTagTableView.delegate = self
        selectTagTableView.dataSource = self
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        tagDics = defaults.objectForKey("tag") as! [String:String]
        for (name,_) in tagDics{
            tagArray.append(name)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //mainに戻る
        if appDelegate.isParent == true {
            
            appDelegate.isParent = false
            appDelegate.isBeacon = true
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    //cellに値を設定
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectTagTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = tagArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 15)
        
        //選択時一瞬を灰色になるのを防ぐ
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 0.5)//水色
        cell.selectedBackgroundView = backgroundView
        
        //再利用のとき困らないように
        if (selectedCells["\(indexPath.row)"] == nil){
            cell.accessoryType=UITableViewCellAccessoryType.None
        }else{
            cell.accessoryType=UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagArray.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            
            //チェックしてないとき
            if (selectedCells["\(indexPath.row)"] == nil){
                cell.accessoryType = .Checkmark
                selectedCells["\(indexPath.row)"]=true
                
            //チェックしてるとき
            }else{
                cell.accessoryType = .None
                selectedCells.removeValueForKey("\(indexPath.row)")

            }

        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    //cellの選択がはずれたとき
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
       
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
 
    }

    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        switch textField.tag{
        case 0:
            eventName = textField.text!
            //print("EventName:\(textField.text!)")
            
        case 1:
            roomName = textField.text!
            //print("RoomName:\(textField.text!)")
            
        case 2:
            eventDescription = textField.text!
            //print("EventDescription:\(textField.text!)")
            
        default:
            break
        }
        
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if eventName == nil || eventName == ""{
           
            MakeAirMeetButton.enabled = false
            MakeAirMeetButton.alpha = 0.5
        }else{
           
            MakeAirMeetButton.enabled = true
            MakeAirMeetButton.alpha = 1.0
        }
        
        return true
    }

    
    //親モード開始！
    @IBAction func ParentStartButton(sender: AnyObject) {
        
        //文字コード
        let event:String = eventName!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let room:String
        if roomName != nil {
        
            room = roomName!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        }else{
            room = ""
        }
        
        // 通信用のConfigを生成.
        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()

        // Sessionを生成.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        // itemsをいい感じの文字列にして送る
        var tagArraytmp:[String] = []
        
        for selectedCell in selectedCells{
            
            tagArraytmp.append(tagArray[Int(selectedCell.0)!])

        }
        
        let tagArrayString = (tagArraytmp as NSArray).componentsJoinedByString(",")
        
        
        let post = "event_name=\(event)&room_name=\(room)&items=\(tagArrayString)"
        let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url = NSURL(string: "http://airmeet.mybluemix.net/api/register_event")
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        request.addValue("a", forHTTPHeaderField: "X-AccessToken")
        
        let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
        
        print("Resume Task ↓")
        //くるくるスタート
        self.view.addSubview(indicator)
        self.indicator.startAnimation()
        
        task.resume()
        
        MakeAirMeetButton.enabled = false
        MakeAirMeetButton.alpha = 0.5
        
    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        print("\nDidReceiveData Task ↑")
        //セッションを終える
        session.invalidateAndCancel()
        
        //Json解析
        let json = JSON(data:data)
        let code:String = "\(json["code"])"
        print("JSON:\(json)\n")
        //成功
        if code == "200"{
            
            let major = json["major"]

            print("Sucsess Make AirMeet : majorID -> [\(major)]")
            
            appDelegate.parentID = "\(major)"
            appDelegate.isParent = true
            
            ///（kmdr,momoka）
            ///アラート（デフォorオリジナル）だしてパスを入力してokを押したら画面遷移
            
            ////////こっから下だけいじった/////////////
            
            let alert: UIAlertController = UIAlertController(title:"パスコード設定",
                message: "パスコードを入力してください",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            //パスを入力してOK押す場合
            let okAction: UIAlertAction = UIAlertAction(title: "入力完了",
                style: UIAlertActionStyle.Default,
                handler:{
                    (action:UIAlertAction!) -> Void in
                    let textField = alert.textFields![0]
                    let input_text = textField.text

                    // 入力したパスコード保存(すみません：できてないかも)
                    self.appDelegate.parentPass = input_text
                    print("PASS = \(self.appDelegate.parentPass!)")
                    //画面遷移
                    self.performSegueWithIdentifier("startSegue",sender: nil)

            })
            
            ///とりあえずキャンセルなしでいいかな、部屋つくった後なので部屋消去する通信が必要（by神武）
            //キャンセルする場合(すみません：キャンセルしたあと、再度「Make AirMeet」ボタンが選択できない)
            /*
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
                style: UIAlertActionStyle.Cancel,
                handler:{
                    (action:UIAlertAction!) -> Void in
                    //self.setDefaultName()
            })
            */
            
            alert.addAction(okAction)
            //alert.addAction(cancelAction)
            //UIAlertControllerにtextFieldを追加
            alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            }
           
            ////////こっから上だけいじった/////////////
            
            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                //alert非同期で表示させるね（by神武）
                self.presentViewController(alert, animated: true, completion: nil)
                
            })
            
        //失敗
        }else{
            
            print("\nFalse Make AirMeet : \(json["message"])")
            
            appDelegate.parentID = nil
            appDelegate.isParent = false
            
            let alert = UIAlertController(title:"False Make AirMeet",message:"\(json["message"])",preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
            }
            alert.addAction(okAction)
            
            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                
                self.MakeAirMeetButton.enabled = true
                self.MakeAirMeetButton.alpha = 1.0
                
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

