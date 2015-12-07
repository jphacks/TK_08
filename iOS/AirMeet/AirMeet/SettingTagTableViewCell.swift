//
//  SettingTagTableView.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/29.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class SettingTagTableViewCell: UITableViewCell {

    
    @IBOutlet weak var TagTextField: HoshiTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
         //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(tagModel:TagModel){
        
        //TagNameLabel.text = "\(tagModel.name)"
        //TagDetailTextField.text = "\(tagModel.detail)"
        TagTextField.placeholder = "\(tagModel.name)"
        TagTextField.text = "\(tagModel.detail)"
   
        
        
    }
}
