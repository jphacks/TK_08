//
//  AirMeetingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class AirMeetingViewController: UIViewController, CBPeripheralManagerDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate{
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // LocationManager.
    var myPheripheralManager:CBPeripheralManager!
    
    //くるくる
    let indicator:SpringIndicator = SpringIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigationbar色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //Navigationbar画像
        let titleImageView = UIImageView( image: UIImage(named: "AirMeet-white.png"))
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.navigationController!.navigationBar.frame.height*0.8)
        self.navigationItem.titleView = titleImageView
        
        //ぐるぐる
        indicator.frame = CGRectMake(self.view.frame.width/2-self.view.frame.width/8,self.view.frame.height/2-self.view.frame.width/8,self.view.frame.width/4,self.view.frame.width/4)
        indicator.lineWidth = 3
        
        // PeripheralManagerを定義.
        myPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        ///ここでpassがうけとれていることを確認
        print("PASS = \(appDelegate.parentPass!)")
        
        ///（kmdr,momoka）
        ///ずっとつきっぱなしのコード追加
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        // iBeaconのUUID.
        let myProximityUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-33333B57FE6D")
        
        // iBeaconのIdentifier.
        let myIdentifier = "AirMeet"
        
        let myMajor : CLBeaconMajorValue = UInt16(appDelegate.parentID!)!
        
        // BeaconRegionを定義.
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: myMajor, identifier: myIdentifier)
        
        // Advertisingのフォーマットを作成.
        let myBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralDataWithMeasuredPower(nil))
        
        // Advertisingを発信.
        myPheripheralManager.startAdvertising(myBeaconPeripheralData as? [String : AnyObject])
    }

    
    //終了
    @IBAction func ParentStopButton(sender: AnyObject) {
        
        ///（kmdr,momoka）
        ///保存されたpassとalertで入力した数値が一致したときに、以下の通信を実行するようにしてください
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
                
                if self.appDelegate.parentPass! == input_text{
                    
                    //成功をつたえるalert
                    let sucsessAlert: UIAlertController = UIAlertController(title: "PASS Sucsess", message: "", preferredStyle: .Alert)
                    self.presentViewController(sucsessAlert, animated: true) { () -> Void in
                        let delay = 2.0 * Double(NSEC_PER_SEC)
                        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                    
                    // 通信用のConfigを生成.
                    let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                    
                    // Sessionを生成.
                    let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
                    
                    let post = "major=\(self.appDelegate.parentID!)"
                    let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    //print(postData!)
                    
                    let url = NSURL(string: "http://airmeet.mybluemix.net/remove_event")
                    
                    let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
                    request.HTTPMethod = "POST"
                    request.HTTPBody = postData
                    
                    request.addValue("a", forHTTPHeaderField: "X-AccessToken")
                    //request.addValue(appDelegate.parentID!, forHTTPHeaderField: "major")
                    
                    let task:NSURLSessionDataTask = mySession.dataTaskWithRequest(request)
                    
                    print("Resume Task ↓")
                    //くるくるスタート
                    self.view.addSubview(self.indicator)
                    self.indicator.startAnimation()
                    
                    task.resume()
                }else{
                    //失敗をつたえるalert
                    let falseAlert: UIAlertController = UIAlertController(title: "PASS False", message: "", preferredStyle: .Alert)
                    self.presentViewController(falseAlert, animated: true) { () -> Void in
                        let delay = 2.0 * Double(NSEC_PER_SEC)
                        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                    print("false")
                    
                }
                
        })
        alert.addAction(okAction)
        //alert.addAction(cancelAction)
        //UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        print("\nDidReceiveData Task ↑")
        //セッションを終える
        session.invalidateAndCancel()
        
        //Json解析
        let json = JSON(data:data)
        print("JSON:\(json)\n")
        
        let code:String = "\(json["code"])"
        
        //成功
        if code == "200"{
            
            print("Sucsess Delete AirMeet : majorID -> [\(appDelegate.parentID!)]")
            appDelegate.parentID = nil
            self.myPheripheralManager.stopAdvertising()
            
            //非同期
            dispatch_async(dispatch_get_main_queue(), {
                
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                //画面遷移
                self.performSegueWithIdentifier("BackToMain", sender: nil)
                
            })

            
        //失敗
        }else{
            print("False Delete AirMeet : \(json["message"])")
            
            let alert = UIAlertController(title:"False Dlete AirMeet",message:"\(json["message"])",preferredStyle:UIAlertControllerStyle.Alert)
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
