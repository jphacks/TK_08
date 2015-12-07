//
//  ChildViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildSettingViewController: UIViewController,NSURLSessionDelegate,NSURLSessionDataDelegate  {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        eventLabel.text = appDelegate.selectEvent?.eventName
        roomLabel.text = appDelegate.selectEvent?.roomName
        
        //アイコンまる
        imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.borderWidth = 3.0
        
        //ここはあとで、サーバーにおくった一時的なものに変更
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
    
    //離脱
    @IBAction func ChildStopButton(sender: AnyObject) {
        
        // 通信用のConfigを生成.
        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        // Sessionを生成.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        let post = "id=\(appDelegate.childID!)"
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
        
        task.resume()

    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        //Json解析
        let json = JSON(data:data)
        let code:String = "\(json["code"])"
        let message = json["message"]
        
        //成功
        if code == "200"{
            
            print("User Delete Sucsess : \(json["message"])")
            appDelegate.isChild = true
            
            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                //Exitからsegueを呼び出し
                self.performSegueWithIdentifier("BackSettingToMain", sender: nil)
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
            
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


