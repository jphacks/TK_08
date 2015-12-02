//
//  ChildViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildSettingViewController: UIViewController {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
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
    }
    
    //離脱
    @IBAction func ChildStopButton(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


