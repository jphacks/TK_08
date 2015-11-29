//
//  EventModel.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import Foundation

class EventModel : NSObject {
    
    var eventName:String
    var roomName:String
    var childNumber:Int
    var eventDescription:String
    var eventID:NSNumber
    
    
    init(eventName: String, roomName: String, childNumber:Int, eventDescription: String,eventID:NSNumber) {
        
        self.eventName = eventName
        self.roomName = roomName
        self.childNumber = childNumber
        self.eventDescription = eventDescription
        self.eventID = eventID
        
    }
    
}
