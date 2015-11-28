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
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //backView.layer.borderWidth = 3.0
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(childModel:ChildModel){
        
        self.imageImageView.image = childModel.image
        self.backImageView.image = childModel.backgroundImage
        self.nameLabel.text = childModel.name
    
    }
}
