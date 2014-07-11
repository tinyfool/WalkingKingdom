//
//  house.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/7/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Building:NSObject,NSCoding {

    var buildTime:NSDate?
    var image:UIImage?
    var imageName:String = ""
    var radius = 50
    var name = ""
    var location:CLLocationCoordinate2D?
    
    var buildingRequirement:BuildingRequirement
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
        aCoder.encodeObject(buildTime, forKey:"buildTime")
        aCoder.encodeObject(imageName, forKey: "imageName")
        aCoder.encodeInteger(radius, forKey: "radius")
        aCoder.encodeObject(name, forKey: "name")
        if(location) {
            
            aCoder.encodeDouble(location!.latitude, forKey: "lat")
            aCoder.encodeDouble(location!.longitude, forKey: "long")
        }
    }
    
    init(coder aDecoder: NSCoder!) {
        
        buildTime = aDecoder.decodeObjectForKey("buildTime") as? NSDate
        var tempimageName = aDecoder.decodeObjectForKey("imageName") as? String
        if(tempimageName) {
        
            imageName = tempimageName!
        }
        
        radius = aDecoder.decodeIntegerForKey("radius")
        var name1 = aDecoder.decodeObjectForKey("name") as? String
        if(name1) {

            name = name1!
        }
        var lat = aDecoder.decodeDoubleForKey("lat")
        var long = aDecoder.decodeDoubleForKey("long")
        location = CLLocationCoordinate2DMake(lat, long)
        buildingRequirement = BuildingRequirement()
    }

    init(){
        
        buildTime = NSDate.date()
        buildingRequirement = BuildingRequirement()
    }
 
}

class BuildingRequirement:NSObject {

    var levelRequired = 1
    var buildingCost:Dictionary<String,Int> = Dictionary<String,Int>()
    var buildingTime = 0
    var radius = 50
    var exp = 0
    var needPeople = 0
}

class House:Building {

    var people = 0
    var hourTax = 0
    var lastCollectTime:NSDate?
    
    override func encodeWithCoder(aCoder: NSCoder!) {
        
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(lastCollectTime, forKey: "lastCollectTime")
    }
    
    init() {
    
        lastCollectTime = NSDate.date()
        super.init()
    }
    
    init(coder aDecoder: NSCoder!) {
        
        lastCollectTime = aDecoder.decodeObjectForKey("lastCollectTime") as? NSDate
        super.init(coder:aDecoder)
    }
}

class AuthorityBuilding:House {
    
    
    init() {
    
        super.init()
    }
    
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder:aDecoder)
    }

}

class MaterialBuilding:Building {

    var workPlans = NSDictionary()
    var working:Workplan?
    var startTime:NSDate?
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder:aDecoder)
    }
    
    init() {
        
        super.init()
    }
}

class Workplan:NSObject,NSCoding {

    var resource = ""
    var resourceAmount = 0
    var production = ""
    var productionAmount = 0
    var produceTime = 0
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
    }
    
    init(coder aDecoder: NSCoder!) {
        
    }
}