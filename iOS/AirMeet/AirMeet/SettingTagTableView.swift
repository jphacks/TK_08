//
//  SettingTagTableView.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/29.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class SettingTagTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var TagNameLabel: UILabel!
    @IBOutlet weak var tagDetailTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //backView.layer.borderWidth = 3.0
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(name:String,detail:String){
        
        TagNameLabel.text = "\(name)"
        tagDetailTextField.text = "\(detail)"
   
        
        
    }
}
