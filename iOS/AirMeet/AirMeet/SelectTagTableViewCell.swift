//
//  SelectTagTableViewCell.swift
//  AirMeet
//
//  Created by koooootake on 2015/12/04.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class SelectTagTableViewCell: UITableViewCell {
    
    
    //@IBOutlet weak var TagNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            //self.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        //if highlighted{
        //    self.backgroundColor = UIColor.whiteColor()
        //}
       
    }
    
    
    
    func setCell(tagName:String){
        //TagNameLabel.text = tagName
    }
}

