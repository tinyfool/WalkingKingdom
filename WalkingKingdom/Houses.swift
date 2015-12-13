//
//  Houses.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/14/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation
import UIKit

class SmallHouse : House {
    
    override init() {
        
        super.init()
        name = "Small House"
        imageName = "SmallHouse.png"
        image = UIImage(named: imageName)
        
        buildingRequirement.exp = 200
        buildingRequirement.buildingCost["coin"] = 100
        buildingRequirement.buildCostTime = 100
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)!
    }
    
    override func buildResult(game: Game) {
        
        game.people += 5
    }
    
}
