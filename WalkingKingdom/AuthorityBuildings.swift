//
//  RealBuilding.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/7/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation
import UIKit

class TownHall:AuthorityBuilding {

    init() {
    
        super.init()
        name = "Town Hall"
        imageName = "TownHall.png"
        image = UIImage(named: imageName)
        
        buildingRequirement.exp = 200
        buildingRequirement.buildingCost["coin"] = 300
    }
    
    init(coder aDecoder: NSCoder!) {
        
        super.init(coder:aDecoder)
    }
    
    override func buildResult(game: Game) {
        
        
    }

}

