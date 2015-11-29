//
//  ChildModel.swift
//  AirMeet
//
//  Created by koooootake on 2015/11/28.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import Foundation
import UIKit

class ChildModel : NSObject {
    
    
    var image:UIImage
    var backgroundImage:UIImage
    var name:String
    var tag:Dictionary<String,String>
    var detail:String
    
    
    init(image:UIImage,backgroundImage:UIImage,name:String,tag:Dictionary<String,String>,detail:String) {
        
        self.image = image
        self.backgroundImage = backgroundImage
        self.name = name
        self.tag = tag
        self.detail = detail
        
    }
    
}

