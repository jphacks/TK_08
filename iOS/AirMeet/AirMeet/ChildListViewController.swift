//
//  ChildListViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var ChildTableView: UITableView!
    
    var childs:[ChildModel] = [ChildModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        ChildTableView.delegate = self
        ChildTableView.dataSource = self
        
        let tag:Dictionary<String,String> = ["age":"22","趣味":"デレステ"]
        let tag2:Dictionary<String,String> = ["age":"40","趣味":"みゅーず"]
        
        //子追加
        let child1:ChildModel = ChildModel(image: UIImage(named: "go_face.png")!, backgroundImage:  UIImage(named: "go_back.png")!, name: "go", tag: tag)
        let child2:ChildModel = ChildModel(image: UIImage(named: "go_face.png")!, backgroundImage:  UIImage(named: "go_back.png")!, name: "goooo", tag: tag2)
        let child3:ChildModel = ChildModel(image: UIImage(named: "go_face.png")!, backgroundImage:  UIImage(named: "go_back.png")!, name: "goooooo", tag: tag)
        
        childs.append(child1)
        childs.append(child2)
        childs.append(child3)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:ChildTableViewCell = tableView.dequeueReusableCellWithIdentifier("ChildTableViewCell", forIndexPath: indexPath) as! ChildTableViewCell
       cell.setCell(childs[indexPath.row])
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("events.count:\(childs.count)")
        return childs.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
       // appDelegate.selectEvent = events[indexPath.row]
        
        appDelegate.selectChild = childs[indexPath.row]
        
        //画面遷移
        performSegueWithIdentifier("showDetail",sender: nil)
        
    }
    
    // Segueで遷移時の処理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showDetail") {
           // let GroupVC : ChildListDetailViewController = (segue.destinationViewController as? ChildListDetailViewController)!
           // GroupVC.groupName = selectGroup
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}