//
//  ProfileSettingViewController.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    let defaultColor:UIColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var settingImageButton: UIButton!
    
    @IBOutlet weak var userDetailTextView: UITextView!
    @IBOutlet weak var userNameTextField: HoshiTextField!
    
    var userNameString:String?
    var userDetailString:String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバーの色
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
        //アイコンまる
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2.0
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userImageView.layer.borderWidth = 3.0
        
        settingImageButton.layer.cornerRadius = settingImageButton.frame.size.width/2.0
        settingImageButton.layer.masksToBounds = true
        
        userNameTextField.delegate = self
        
        userDetailTextView.layer.borderColor = defaultColor.CGColor
        userDetailTextView.layer.borderWidth = 2.0
        userDetailTextView.layer.cornerRadius = 3.0
        userDetailTextView.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        userNameTextField.text = "\(defaults.stringForKey("name")!)"
        userNameTextField.tag = 0
        userNameString = "\(defaults.stringForKey("name")!)"
        
        userDetailTextView.text = "\(defaults.stringForKey("detail")!)"
        userDetailString = "\(defaults.stringForKey("detail")!)"
        
        //戻るボタン設定
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        let imageData:NSData = defaults.objectForKey("image") as! NSData
        userImageView.image = UIImage(data:imageData)
        
        let backData:NSData = defaults.objectForKey("back") as! NSData
        backImageView.image = UIImage(data: backData)
        
    }
    
    //UITextViewが終了する直前に呼ばれる
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        //自己紹介保存
        print("Save UserDetail : \(textView.text!)")
        userDetailString = textView.text
        
        return true
    }
    
    //UITextFieldが編集終了する直前に呼ばれる
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        //ユーザ名保存
        print("Save UserName : \(textField.text!)")
        userNameString = textField.text!
        
        return true
    }
    
    //改行ボタンが押された際に呼ばれる
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //画面が消える前に呼び出し（保存するタイミングあとでチェック）
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(userNameString, forKey: "name")
        defaults.setObject(userDetailString, forKey: "detail")
        
        defaults.synchronize()
        
        print("\nSave Profile\n")
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
        
        ///（kmdr,momoka）
        ///正方形トリミングを指定した縦幅トリミングに(w:self.view.frame.width, h:120?)とか
        pickerController.allowsEditing = true
        
        pickerController.navigationBar.translucent = false
        pickerController.navigationBar.backgroundColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        
        pickerController.navigationBar.barTintColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)//水色
        pickerController.navigationBar.tintColor = UIColor.whiteColor()
        
        UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    // 画像が選択されたとき呼び出される
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // アルバム画面を閉じる
        picker.dismissViewControllerAnimated(true, completion: nil);
        
        switch picker.view.tag{
        //ユーザ画像
        case 0:
            userImageView.image = image
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(UIImagePNGRepresentation(image), forKey: "image")
            break
        //背景画像
        case 1:
            
            ///トリミング終了した画像をここにSet
            backImageView.image = image
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(UIImagePNGRepresentation(image), forKey: "back")
            break
        default:
            break
        }
        
    }
    
    // 画像をリサイズしたい（つかってない）
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
