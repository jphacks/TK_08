//
//  ChildTagViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildTagViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var TagTableView: UITableView!
    
    //@IBOutlet weak var TagTableView: UITableView!
    
    var tagDics = [String:String]()
    var tags:[TagModel] = [TagModel]()
    var sortTags:[TagModel] = [TagModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()

        TagTableView.delegate = self
        TagTableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //tagDics = [String:String]()
        //tags = [TagModel]()
        
        for child in appDelegate.allChilds{
            
            tagDics = child.tag
            
            for (name,detail) in tagDics{

                    if detail == ""{
                        
                    }else{
                        let tagModel:TagModel = TagModel(name: "\(name)", detail: "\(detail)")
                        tags.append(tagModel)
                    }

            }
            

            tagDics = [:]
            
        }
        
        //そーと
        var tagNames:[String] = [String]()
        for tag in tags{
            
            tagNames.append(tag.name)
            
        }
        
        tagNames = tagNames.sort({$0 < $1})
        
        for tagName in tagNames {
            for tag:TagModel in tags {
                if tagName == tag.name {
                    print("\(tag.name):\(tag.detail)")
                    sortTags.append(tag)
                }
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("TagTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.setCell(sortTags[indexPath.row])
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
        return sortTags.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


