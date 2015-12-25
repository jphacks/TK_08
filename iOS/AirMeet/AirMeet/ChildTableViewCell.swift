//
//  ChildTableViewCell.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageImageView: UIImageView!

    //@IBOutlet weak var backImageView: SABlurImageView!
  
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var blackImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //backView.layer.borderWidth = 3.0
        
    }
    
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        //super.setHighlighted(highlighted, animated: animated)
        //self.blackImageView.backgroundColor = UIColor(white: 0.2, alpha: 0.1)
        
        if highlighted{
            self.blackImageView.backgroundColor = UIColor(white: 0.5, alpha: 0.3)
        }else{
            self.blackImageView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        //self.blackImageView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
    }
    
    func setCell(childModel:ChildModel){
        
        self.backImageView.image = childModel.backgroundImage
        
        self.backImageView.layer.cornerRadius = 3.0
        self.backImageView.layer.masksToBounds = true
        
        //self.blackImageView.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        
        //黒いのかぶせる
        //let backCoverView:UIView = UIView(frame: self.backImageView.frame)
        //backImageView.backgroundColor = UIColor(red: 128.0/255.0, green: 204.0/255.0, blue: 223.0/255.0, alpha: 1)
        //self.backImageView.addSubview(backCoverView)
        
        //ぶらー
        
        //let blurEffect = UIBlurEffect(style: .Light)
        //let lightBlurView = UIVisualEffectView(effect: blurEffect)
        //lightBlurView.frame = self.backImageView.bounds
        //self.backImageView.addSubview(lightBlurView)
        
        
        //self.backImageView.addBlurEffect(50)
        
        self.nameLabel.text = childModel.name
        self.detailLabel.text = childModel.detail
        
        //文字を擦ったかんじに
        /*
        let lightVibrancyView =
        vibrancyEffectView(
            fromBlurEffect: lightBlurView.effect as! UIBlurEffect,
            frame: backImageView.bounds)
        lightBlurView.contentView.addSubview(lightVibrancyView)
        
        lightVibrancyView.contentView.addSubview(self.nameLabel)
        lightVibrancyView.contentView.addSubview(self.detailLabel)

       */
        
        self.imageImageView.image = childModel.image
        //アイコンまる
        self.imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        self.imageImageView.layer.masksToBounds = true
        self.imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageImageView.layer.borderWidth = 3.0
        

        
    
    }
    
    // VibrancyエフェクトのViewを生成
    func vibrancyEffectView(fromBlurEffect effect: UIBlurEffect, frame: CGRect) -> UIVisualEffectView {
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: effect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = frame
        return vibrancyView
    }
    
}
