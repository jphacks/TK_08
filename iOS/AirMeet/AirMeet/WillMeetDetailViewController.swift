//
//  WillMeetDetailViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class WillMeetDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var TagTableView: UITableView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    var tagDics = [String:String]()
    var tags:[TagModel] = [TagModel]()
    var tagArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        backImageView.image = appDelegate.selectChild?.backgroundImage
        imageImageView.image = appDelegate.selectChild?.image
        nameLabel.text = appDelegate.selectChild?.name
        
        tagDics = appDelegate.selectChild!.tag
        
        detail.text = appDelegate.selectChild?.detail
        
        TagTableView.delegate = self
        TagTableView.dataSource = self
        
        //アイコンまる
        imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.borderWidth = 3.0
        
        //タグ表示
        
        for (name,detail) in tagDics{
            let tagModel:TagModel = TagModel(name: "\(name)", detail: "\(detail)")
            tags.append(tagModel)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("TagTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.setCell(tags[indexPath.row])
        //入力されたテキストを取得するタグとデリゲート
        cell.TagTextField.tag = indexPath.row
        cell.TagTextField.enabled = false
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (appDelegate.selectChild?.tag.count)!
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
