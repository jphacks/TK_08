//
//  ParentLockViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ParentLockSettingViewController: UIViewController, CBPeripheralManagerDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate{
    
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
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        
        // iBeaconのUUID.
        let myProximityUUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-33333B57FE6D")
        
        // iBeaconのIdentifier.
        let myIdentifier = "AirMeet"
        
        //サーバーからMajorを受けとり
        print("Make AirMeet Sucsess [ \(appDelegate.parentID!) ]")
        
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
        
        // 通信用のConfigを生成.
        let myConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // Sessionを生成.
        let mySession:NSURLSession = NSURLSession(configuration: myConfig, delegate: self, delegateQueue: nil)
        
        let post = "major=\(appDelegate.parentID!)"
        let postData = post.dataUsingEncoding(NSUTF8StringEncoding)
        
        //print(postData!)
        
        let url = NSURL(string: "http://airmeet.mybluemix.net/remove_event")
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        request.addValue("a", forHTTPHeaderField: "X-AccessToken")
        //request.addValue(appDelegate.parentID!, forHTTPHeaderField: "major")
        
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
            
            print("DELETE AirMeet Sucsess [ \(message) ]")
            //appDelegate.isParent = false
            
            //メインスレッドで表示
            dispatch_async(dispatch_get_main_queue(), {
                
                //くるくるストップ
                self.indicator.stopAnimation(true, completion: nil)
                self.indicator.removeFromSuperview()
                
            })

            
            //画面遷移
            self.performSegueWithIdentifier("BackToMain", sender: nil)
            //self.navigationController?.popToRootViewControllerAnimated(true)
            
            //失敗
        }else{
            print("DELETE AirMeet False [ \(message) ]")
            
            let alert = UIAlertController(title:"False Dlete AirMeet",message:"\(message)",preferredStyle:UIAlertControllerStyle.Alert)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
