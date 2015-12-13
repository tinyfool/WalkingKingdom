//
//  house.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/7/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

// http://tradenations.wikia.com/wiki/Trade_Nations_Wiki
import Foundation
import UIKit
import MapKit

class Building:NSObject,NSCoding {

    var buildTime:NSDate?
    
    var buildCostTime:Int
    
    var image:UIImage?
    var imageName:String = ""
    var radius = 50
    var name = ""
    var location:CLLocationCoordinate2D?
    var complete = 0
    
    var buildingRequirement:BuildingRequirement
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(buildTime!, forKey:"buildTime")
        aCoder.encodeObject(imageName, forKey: "imageName")
        aCoder.encodeInteger(radius, forKey: "radius")
        aCoder.encodeObject(name, forKey: "name")
        if((location) != nil) {
            
            aCoder.encodeDouble(location!.latitude, forKey: "lat")
            aCoder.encodeDouble(location!.longitude, forKey: "long")
        }
        
        aCoder.encodeInteger(complete, forKey: "complete")
        aCoder.encodeInteger(buildCostTime, forKey: "buildCostTime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        buildTime = aDecoder.decodeObjectForKey("buildTime") as? NSDate
        let tempimageName = aDecoder.decodeObjectForKey("imageName") as? String
        if((tempimageName) != nil) {
        
            imageName = tempimageName!
        }
        
        radius = aDecoder.decodeIntegerForKey("radius")
        let name1 = aDecoder.decodeObjectForKey("name") as? String
        if((name1) != nil) {

            name = name1!
        }
        let lat = aDecoder.decodeDoubleForKey("lat")
        let long = aDecoder.decodeDoubleForKey("long")
        location = CLLocationCoordinate2DMake(lat, long)
        buildingRequirement = BuildingRequirement()
        
        complete = aDecoder.decodeIntegerForKey("complete")
        buildCostTime = aDecoder.decodeIntegerForKey("buildCostTime")
    }

    override init(){
        
        buildTime = NSDate()
        buildingRequirement = BuildingRequirement()
        buildCostTime = 0
    }
 
    func buildResult(game:Game) {
    
    }
}

class BuildingRequirement:NSObject {

    var levelRequired = 1
    var buildingCost:Dictionary<String,Int> = Dictionary<String,Int>()
    var buildCostTime = 300
    var radius = 50
    var exp = 0
    var needPeople = 0
}

class House:Building {

    var people = 0
    var hourTax = 0
    var lastCollectTime:NSDate?
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(lastCollectTime!, forKey: "lastCollectTime")
    }
    
    override init() {
    
        lastCollectTime = NSDate()
        super.init()
    }
    
    required  init?(coder aDecoder: NSCoder) {
        
        lastCollectTime = aDecoder.decodeObjectForKey("lastCollectTime") as? NSDate
        super.init(coder:aDecoder)
    }
}

class AuthorityBuilding:House {
    
    
    override init() {
    
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
    }

}

class MaterialBuilding:Building {

    var workPlans = NSDictionary()
    var working:Workplan?
    var startTime:NSDate?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
    }
    
    override init() {
        
        super.init()
    }
}

class Workplan:NSObject,NSCoding {

    var resource = ""
    var resourceAmount = 0
    var production = ""
    var productionAmount = 0
    var produceTime = 0

    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
}