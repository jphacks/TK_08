//
//  ViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet weak var EventTableView: UITableView!
    
    var events:[EventModel] = [EventModel]()
    
    class Event {
        var eventName:String!
        var roomName:String!
        var childNumber:Int!
        var eventDescription:String!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Navigationbar色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //Navigationbar画像
        let titleImageView = UIImageView( image: UIImage(named: "AirMeet-white.png"))
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.navigationController!.navigationBar.frame.height*0.7)
        self.navigationItem.titleView = titleImageView
        
        appDelegate.isChild = false
        appDelegate.isParent = false
        
        EventTableView.delegate = self
        EventTableView.dataSource = self
        
        //会場追加
        let event:EventModel = EventModel(eventName: "JPHacks", roomName: "東大", childNumber: 50, eventDescription: "aaa")
        events.append(event)
 
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: EventTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath) as! EventTableViewCell
        cell.setCell(events[indexPath.row])
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("events.count:\(events.count)")
        return events.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // selectGroup = appDelegate.groupArray[indexPath.row] as! String
        //画面遷移
        //performSegueWithIdentifier("showGroup",sender: nil)
        
        print(indexPath.row)
        
        appDelegate.selectEvent = events[indexPath.row]
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Child", bundle: NSBundle.mainBundle())
        let childViewController: ChildRoomViewController = storyboard.instantiateInitialViewController() as! ChildRoomViewController
        
        self.navigationController?.pushViewController(childViewController, animated: true)
        
    }
    
    
    
    //親
    @IBAction func ParentButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Parent", bundle: NSBundle.mainBundle())
        let parentViewController: ParentSettingViewController = storyboard.instantiateInitialViewController() as! ParentSettingViewController
        
        self.navigationController?.pushViewController(parentViewController, animated: true)
    }

    //子
    @IBAction func ChildButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Child", bundle: NSBundle.mainBundle())
        let childViewController: ChildRoomViewController = storyboard.instantiateInitialViewController() as! ChildRoomViewController
        
        self.navigationController?.pushViewController(childViewController, animated: true)
        
    }

    //Meet
    @IBAction func MeetButton(sender: AnyObject) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Meet", bundle: NSBundle.mainBundle())
        let meetViewController: MeetListViewController = storyboard.instantiateInitialViewController() as! MeetListViewController
        
        self.navigationController?.pushViewController(meetViewController, animated: true)
    }
    
    //プロフィール
    @IBAction func ProfileButton(sender: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: NSBundle.mainBundle())
        let profileViewController: ProfileViewController = storyboard.instantiateInitialViewController() as! ProfileViewController
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

