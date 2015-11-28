//
//  ChildRoomViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildRoomViewController: UIViewController {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var RoomNameLabel: UILabel!
    @IBOutlet weak var EventDescriptionLabel: UILabel!
    @IBOutlet weak var ChildNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //選択された情報
        self.EventNameLabel.text = appDelegate.selectEvent!.eventName
        self.RoomNameLabel.text = appDelegate.selectEvent!.roomName
        self.EventDescriptionLabel.text = appDelegate.selectEvent!.eventDescription
        self.ChildNumberLabel.text = String(appDelegate.selectEvent!.childNumber)
        
    }
    
    @IBAction func EventOKButton(sender: AnyObject) {
        //会場情報を送信して入力情報取得
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

