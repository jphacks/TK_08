//
//  OriginalTabBarController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/29.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

//タブバー設定
class OriginalTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///（kmdr,momoka）
        
        // 選択時のタブバーアイコン・テキストの色
        let selectedColor:UIColor = UIColor(red: 65.0/255.0, green: 168.0/255.0, blue: 186.0/255.0, alpha: 1)//水色

        ///ボタンをいいかんじに
        //let fontFamily: UIFont! = UIFont(name: "Hiragino Kaku Gothic ProN",size:10)
        let fontFamily: UIFont! = UIFont.systemFontOfSize(10)
        
        // 選択時・非選択時の文字色を変更する
        /// なぜか非選択時の文字色を指定すると文字が切れる（特に「g」の下のほう）
        let selectedAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: selectedColor]
        let nomalAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
        UITabBarItem.appearance().setTitleTextAttributes(nomalAttributes, forState: UIControlState.Normal)
        
        // 選択時のアイコンの色
        UITabBar.appearance().tintColor = selectedColor
        
        // 通常のアイコン
        var assets :Array<String> = ["TabBarListImage", "TabBarSearchImage", "TabBarAccountImage"]
        for (idx, item) in self.tabBar.items!.enumerate() {
//            if let image = item.image {
                item.image = UIImage(named: assets[idx])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//            }
        }

        
        // 背景色
        UITabBar.appearance().barTintColor = UIColor(red: 128/255.0, green: 204/255.0, blue: 223/255.0, alpha: 1.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
