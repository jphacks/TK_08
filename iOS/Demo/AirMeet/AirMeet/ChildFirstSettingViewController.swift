//
//  ChildFirstSettingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildFirstSettingViewController: UIViewController {
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //mainに戻る
        if appDelegate.isChild == true {
            self.navigationController?.popToRootViewControllerAnimated(true)
            appDelegate.isChild = false
        }
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
