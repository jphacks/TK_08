//
//  ParentViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ParentSettingViewController: UIViewController,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var EventNameTextField: UITextField!
    @IBOutlet weak var RoomNameTextField: UITextField!
    
    var eventName:String?
    var roomName:String?
    var eventDescription:String?

    @IBOutlet weak var MakeAirMeetButton: UIButton!
    
    
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
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //mainに戻る
        if appDelegate.isParent == true {
            self.navigationController?.popToRootViewControllerAnimated(true)
            appDelegate.isParent = false
        }
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
            print("EventDescription:\(textField.text!)")
            
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
            
            //backgroundSessionConfigurationWithIdentifier("defaultTask")
        // Sessionを生成.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        let post = "event_name=\(event)&room_name=\(room)&items=belong,hobby,presentation"
        let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url = NSURL(string: "http://airmeet.mybluemix.net/register_event")
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
        print("Start Session")
        task.resume()
        
        MakeAirMeetButton.enabled = false
        MakeAirMeetButton.alpha = 0.5
        
    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        //Json解析
        let json = JSON(data:data)
        
        let code:String = "\(json["code"])"
        let major = json["major"]
        let message = json["message"]
        
        print("code : \(json["code"])")
        //成功
        if code == "200"{
            
            appDelegate.parentID = "\(major)"
            appDelegate.isParent = true
            
            
            //画面遷移
            performSegueWithIdentifier("startSegue",sender: nil)
            
        //失敗
        }else{
            print(message)
            
            let alert = UIAlertController(title:"False Make AirMeet",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
            }
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            
            appDelegate.isParent = false
        }
        
        //self.MakeAirMeetButton.enabled = true
        //self.MakeAirMeetButton.alpha = 1.0
 
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

