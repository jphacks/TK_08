//
//  ChildListDetailViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildListDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let testTag = [["name": "age", "detail" :"22"],["name": "趣味は", "detail" :"デレステだよん"],["name": "キャラクター", "detail" :"ジバニャン"],["name": "趣味は1", "detail" :"デレステだよん1"],["name": "キャラクター2", "detail" :"ジバニャン2"]]

    
    @IBOutlet weak var TagTableView: UITableView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var detail: UILabel!
    
    var tags:Dictionary<String,String>!
    
    var tagCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        backImageView.image = appDelegate.selectChild?.backgroundImage
        imageImageView.image = appDelegate.selectChild?.image
        nameLabel.text = appDelegate.selectChild?.name
        
        tags = appDelegate.selectChild?.tag
        
        detail.text = appDelegate.selectChild?.detail
        
        TagTableView.delegate = self
        TagTableView.dataSource = self
        
        
        //タグ表示
        /*var count:Int = 0
        
        for (tag, detail) in (appDelegate.selectChild?.tag)! {
            
            print("\(tag): \(detail)")
            let tagLabel:UILabel = UILabel(frame: CGRectMake(0,self.view.frame.height/2+50*CGFloat(count),self.view.frame.width,50))
            tagLabel.text = "\(tag): \(detail)"
            self.view.addSubview(tagLabel)
            
            count++
        }*/
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:TagTableViewCell = tableView.dequeueReusableCellWithIdentifier("TagTableViewCell", forIndexPath: indexPath) as! TagTableViewCell

       // appDelegate.selectChild?.
        
       // let tag =
        
       // appDelegate.selectChild?.tag.keys[Int(indexPath.row)]
        
       // let tag = Array(arrayLiteral: appDelegate.selectChild?.tag.keys)[indexPath.row]
       // print("aaa:\(tag)")
       
        
        // testTagの一行分の内容を入れる
        let object = testTag[indexPath.row]
        
        cell.TagNameLabel?.text = object["name"]!
        cell.TagDetailLabel?.text = object["detail"]!
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tags.count:\(appDelegate.selectChild?.tag.count)")
        return (appDelegate.selectChild?.tag.count)!
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        // appDelegate.selectEvent = events[indexPath.row]
        
       // appDelegate.selectChild = childs[indexPath.row]
        
        //画面遷移
       // performSegueWithIdentifier("showDetail",sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
