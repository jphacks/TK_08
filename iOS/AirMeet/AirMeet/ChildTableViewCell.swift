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

  
    @IBOutlet weak var backImageView: SABlurImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //backView.layer.borderWidth = 3.0
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(childModel:ChildModel){
        
        self.backImageView.image = childModel.backgroundImage
        self.backImageView.addBlurEffect(50)
        
        self.imageImageView.image = childModel.image
        //アイコンまる
        self.imageImageView.layer.cornerRadius = imageImageView.frame.size.width/2.0
        self.imageImageView.layer.masksToBounds = true
        self.imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageImageView.layer.borderWidth = 3.0
        
        self.nameLabel.text = childModel.name
        
        self.detailLabel.text = childModel.detail
        
    
    }
}
