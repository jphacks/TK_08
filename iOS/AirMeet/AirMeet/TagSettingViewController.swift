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
    
    var tagDics = [String:String]()
    
    var selectIndex:NSIndexPath = NSIndexPath()
    
    var selectTextFiled:UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TagSettingTableView.delegate = self
        TagSettingTableView.dataSource = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        tagDics = defaults.objectForKey("tag") as! [String:String]
        
        //cellに設定する値の設定
        for (name,detail) in tagDics{
            let tagModel:TagModel = TagModel(name: name, detail: detail)
            tags.append(tagModel)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //キーボード
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        //キーボード
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
   
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //print("scroll")
        //スクロールをはじめたらキーボードを閉じる
        selectTextFiled.resignFirstResponder()
        //selectTextView.resignFirstResponder()
        
    }


    //自動スクロール
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let cell: SettingTagTableViewCell = TagSettingTableView.dequeueReusableCellWithIdentifier("TagSettingTableViewCell", forIndexPath: selectIndex) as! SettingTagTableViewCell
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        
        let txtLimit = cell.frame.origin.y + cell.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            TagSettingTableView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        TagSettingTableView.contentOffset.y = 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("TagSettingTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.setCell(tags[indexPath.row])
        //入力されたテキストを取得するタグとデリゲート
        cell.TagTextField.delegate = self
        cell.TagTextField.tag = indexPath.row
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    
    
    //UITextFieldが編集開始する直前に呼ばれる
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //選択されたindexを保存
        selectIndex = NSIndexPath(forRow: textField.tag, inSection: 0)
        //スクロールしたらキーボードが消える用
        selectTextFiled = textField
        return true
    }
    
    //UITextFieldが編集終了する直前に呼ばれる
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    
        //tag保存
        print("Save Tag Detail : \(textField.placeholder!) -> \(textField.text!)")
        tagDics.updateValue("\(textField.text!)", forKey: "\(textField.placeholder!)")
        
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
        selectTextFiled.resignFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tagDics, forKey: "tag")
        defaults.synchronize()
        
        //print("Save Tag\n")
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}





