//
//  RawMaterialBuildings.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/10/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation
import UIKit

class Farm : MaterialBuilding {
    
    init() {
    
        super.init()
        name = "Farm"
        imageName = "Farm.png"
        image = UIImage(named: imageName)
        
        buildingRequirement.needPeople = 4
        buildingRequirement.exp = 200
        buildingRequirement.buildingCost["coin"] = 75
        buildingRequirement.buildingCost["wood"] = 50
    }
    
    init(coder aDecoder: NSCoder!) {
    
        super.init(coder:aDecoder)
    }
}

class LoggingCamp : MaterialBuilding {

    init() {
    
        super.init()
        name = "Logging Camp"
        imageName = "LoggingCamp.png"
        image = UIImage(named: imageName)

        buildingRequirement.needPeople = 4
        buildingRequirement.exp = 200
        buildingRequirement.buildingCost["coin"] = 100
    }
}
