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
        image = UIImage(named: "Farm.png")
        
        buildingRequirement.exp = 200
        buildingRequirement.buildingCost["coin"] = 75
        buildingRequirement.buildingCost["wood"] = 50
    }
}
