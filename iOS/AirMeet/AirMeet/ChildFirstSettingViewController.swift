//
//  ChildFirstSettingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildFirstSettingViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate  {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var SettingTableView: UITableView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    let testTag = [["name": "age", "detail" :"22"],["name": "趣味は", "detail" :"デレステだよん"],["name": "キャラクター", "detail" :"ジバニャン"],["name": "趣味は1", "detail" :"デレステだよん1"],["name": "キャラクター2", "detail" :"ジバニャン2"]]
    var tagCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        SettingTableView.delegate = self
        SettingTableView.dataSource = self
        
        eventLabel.text = "\(appDelegate.selectEvent!.eventName)"
        roomLabel.text = "\(appDelegate.selectEvent!.roomName)"
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //mainに戻る
        if appDelegate.isChild == true {
            self.navigationController?.popToRootViewControllerAnimated(true)
            appDelegate.isChild = false
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell:SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("SettingTagTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.tagDetailTextField.delegate = self
        
        // testTagの一行分の内容を入れる
        let object = testTag[indexPath.row]

        cell.TagNameLabel?.text = object["name"]!
        cell.tagDetailTextField?.text = object["detail"]!
        
        return cell
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tags.count:\(testTag.count)")
        return testTag.count
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        // appDelegate.selectEvent = events[indexPath.row]
        
        // appDelegate.selectChild = childs[indexPath.row]
        
        //画面遷移
        // performSegueWithIdentifier("showDetail",sender: nil)
        
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
        
    }
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        print("EventName:\(textField.text!)")
        
        /*switch textField.tag{
        case 0:
            eventName = textField.text!
            print("EventName:\(textField.text!)")
            
        case 1:
            roomName = textField.text!
            print("RoomName:\(textField.text!)")
            
        case 2:
            eventDescription = textField.text!
            print("EventDescription:\(textField.text!)")
            
        default:
            break
        }*/
        
        
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    
    @IBAction func ChildStartButton(sender: AnyObject) {
        
        appDelegate.isChild = true
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
