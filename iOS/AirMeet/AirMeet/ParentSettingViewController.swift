//
//  ParentViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ParentSettingViewController: UIViewController,UITextFieldDelegate {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var EventNameTextField: UITextField!
    @IBOutlet weak var RoomNameTextField: UITextField!
    @IBOutlet weak var EventDescriptionTextField: UITextField!
    
    //ここに最初からつっこむとoptionalエラー
    //var event:EventModel?
    
    var eventName:String?
    var roomName:String?
    var eventDescription:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        
        self.EventNameTextField.delegate = self
        self.RoomNameTextField.delegate = self
        self.EventDescriptionTextField.delegate = self
        
        self.EventNameTextField.tag = 0
        self.RoomNameTextField.tag = 1
        self.EventDescriptionTextField.tag = 2
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //mainに戻る
        if appDelegate.isParent == true {
            self.navigationController?.popToRootViewControllerAnimated(true)
            appDelegate.isParent = false
        }
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
 
    }

    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        switch textField.tag{
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
        }

        
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    //親モード開始！
    @IBAction func ParentStartButton(sender: AnyObject) {
        //通信するお
        appDelegate.isParent = true
        
       
        
        
    }
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

