//
//  EventTableViewCell.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var RoomNameLabel: UILabel!
    
    @IBOutlet weak var ChildNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //backView.layer.borderWidth = 3.0
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
       // super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(eventModel:EventModel){
        
        self.EventNameLabel.text = eventModel.eventName
        self.RoomNameLabel.text = eventModel.roomName
        self.ChildNumberLabel.text = String(eventModel.childNumber)
        
    }
}

