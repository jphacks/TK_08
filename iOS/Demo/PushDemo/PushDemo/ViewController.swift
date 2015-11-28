//
//  ViewController.swift
//  PushDemo
//
//  Created by Go Sato on 2015/11/28.
//  Copyright © 2015年 go. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //バックグラウンドにいったときに行う処理
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterBackground", name: "applicationDidEnterBackground", object: nil)
        //フォアグラウンドにいったときに行う処理
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterForground", name: "applicationDidForBackground", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

