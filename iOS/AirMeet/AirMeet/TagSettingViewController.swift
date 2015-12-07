//
//  TagSettingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/12/07.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class TagSettingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate  {
    
    let defaultColor:UIColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
    
    var tags:[TagModel] = [TagModel]()
    
    @IBOutlet weak var TagSettingTableView: UITableView!
    
    let tagNames = ["所属名","住んでいる都道府県","趣味","専門分野","特技","発表内容","性別","年齢"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TagSettingTableView.delegate = self
        TagSettingTableView.dataSource = self
        
        //cellに設定する値の設定
        for tag in tagNames{
            let tagModel:TagModel = TagModel(name: tag, detail: "")
            tags.append(tagModel)
        }
        
    }
    
    
    
    /*
    func tableViewScrollToBottom(animated: Bool) {
    
    let delay = 0.1 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
    dispatch_after(time, dispatch_get_main_queue(), {
    
    let numberOfSections = self.SettingTableView.numberOfSections
    let numberOfRows = self.SettingTableView.numberOfRowsInSection(numberOfSections-1)
    
    if numberOfRows > 0 {
    let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
    self.SettingTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    })
    }
    */

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("TagSettingTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.setCell(tags[indexPath.row])
        //入力されたテキストを取得するタグとデリゲート
        cell.TagTextField.delegate = self
        cell.TagTextField.tag = indexPath.row
        
        return cell
    }

    /*
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    //print(indexPath.row)
    //SettingTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPosition.Bottom , animated: true)
    
    tableViewScrollToBottom(true)
    
    }
    */
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    /*
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField) {
    
    let delay = 0.1 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
    dispatch_after(time, dispatch_get_main_queue(), {
    
    let indexPath = NSIndexPath(forRow: textField.tag, inSection: 0)
    self.SettingTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    })
    }
    */
    
    //UITextViewが終了する直前に呼ばれる
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        //自己紹介保存
        //print("Save UserDetail : \(textView.text!)")
        //userDetailString = textView.text
        
        return true
    }
    
    //UITextFieldが編集終了する直前に呼ばれる
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        //ユーザ名保存
        //print("Save UserName : \(textField.text!)")
        //userNameString = textField.text!
        
        return true
    }
    
    //改行ボタンが押された際に呼ばれる
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //画面が消去するときに呼ばれる
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.synchronize()
        
        print("\nSave Profile\n")
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

