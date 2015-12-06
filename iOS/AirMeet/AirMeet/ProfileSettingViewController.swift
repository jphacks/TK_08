//
//  ProfileSettingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    @IBOutlet weak var SettingTableView: UITableView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var settingImageButton: UIButton!

    var tags:[TagModel] = [TagModel]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //アイコンまる
        imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        imageImageView.layer.masksToBounds = true
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.borderWidth = 3.0
        
        settingImageButton.layer.cornerRadius = settingImageButton.frame.size.width/2.0
        settingImageButton.layer.masksToBounds = true
        
        SettingTableView.delegate = self
        SettingTableView.dataSource = self
        //SettingTableView.scrollEnabled = true
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //設定
        let tag1:TagModel = TagModel(name:"アカウント名",detail: "\(defaults.stringForKey("name")!)")
        let tag2:TagModel = TagModel(name:"自己紹介",detail: "\(defaults.stringForKey("detail")!)")
        let tag3:TagModel = TagModel(name:"FaceBook",detail: "\(defaults.stringForKey("facebook")!)")
        let tag4:TagModel = TagModel(name:"Twitter", detail: "\(defaults.stringForKey("twitter")!)")
        
        tags.append(tag1)
        tags.append(tag2)
        tags.append(tag3)
        tags.append(tag4)
        
        let imageData:NSData = defaults.objectForKey("image") as! NSData
        imageImageView.image = UIImage(data:imageData)
        
        let backData:NSData = defaults.objectForKey("back") as! NSData
        backImageView.image = UIImage(data: backData)
        
    }
    
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        let cell: SettingTagTableViewCell = tableView.dequeueReusableCellWithIdentifier("SettingTagTableViewCell", forIndexPath: indexPath) as! SettingTagTableViewCell
        
        cell.setCell(tags[indexPath.row])
        cell.TagDetailTextField.delegate = self
        cell.TagDetailTextField.tag = indexPath.row
        
        return cell
    }
    
    //cellが選択されたとき
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row)
        //SettingTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPosition.Bottom , animated: true)
        
        tableViewScrollToBottom(true)
        
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        print("index : \(textField.tag)")
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
        
            let indexPath = NSIndexPath(forRow: textField.tag, inSection: 0)
            self.SettingTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        })
        
    }
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        tags[textField.tag].detail = textField.text!
        
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(tags[0].detail, forKey: "name")
        defaults.setObject(tags[1].detail, forKey: "detail")
        defaults.setObject(tags[2].detail, forKey: "facebook")
        defaults.setObject(tags[3].detail, forKey: "twitter")
        
        defaults.synchronize()
        
        print("Save")
    }
    //顔画像
    @IBAction func settingImageButton(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.view.tag = 0
        pickerController.allowsEditing = true
        pickerController.navigationBar.translucent = false
        pickerController.navigationBar.backgroundColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
       
        pickerController.navigationBar.barTintColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        pickerController.navigationBar.tintColor = UIColor.whiteColor()

        UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    //背景画像読み込み
    @IBAction func settingBackButton(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.view.tag = 1
        
        //正方形トリミング
        pickerController.allowsEditing = true
        pickerController.navigationBar.translucent = false
        pickerController.navigationBar.backgroundColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        
        pickerController.navigationBar.barTintColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        pickerController.navigationBar.tintColor = UIColor.whiteColor()
        
        UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    // 画像が選択されたとき
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // アルバム画面を閉じる
        picker.dismissViewControllerAnimated(true, completion: nil);
        
        // 画像をリサイズを呼び出したい
        switch picker.view.tag{
        case 0:
            imageImageView.image = image
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(UIImagePNGRepresentation(image), forKey: "image")
            break
        case 1:
            backImageView.image = image
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(UIImagePNGRepresentation(image), forKey: "back")
            break
        default:
            break
        }
        
    }
    
    // 画像をリサイズしたい
    func resize(image: UIImage, width: Int, height: Int) -> UIImage {
        //let imageRef: CGImageRef = image.CGImage!
        //let sourceWidth: Int = CGImageGetWidth(imageRef)
        //let sourceHeight: Int = CGImageGetHeight(imageRef)
        
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
