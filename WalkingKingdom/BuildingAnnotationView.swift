//
//  BuildingAnnotationView.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/14/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class BuildingAnnotationView : MKAnnotationView {

    var building:Building?
    var buildingLabel:UILabel
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        buildingLabel = UILabel(frame: CGRectMake(0, 0, 200, 30))

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        buildingLabel.layer.borderWidth = 1
        buildingLabel.layer.backgroundColor = UIColor.whiteColor().CGColor

        self.addSubview(buildingLabel)
        
    }
    
    override init(frame: CGRect) {
        
        buildingLabel = UILabel(frame: CGRectMake(0, 0, 200, 30))
        super.init(frame:frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateStatus() {
    
        if((building) != nil){
        
            let theBuilding = building!
            let game = Game.sharedGame()
            if(theBuilding.complete==0) {
                
                NSLog("%d", theBuilding.buildCostTime)
                buildingLabel.hidden = false
                let timeDiff = theBuilding.buildTime?.timeIntervalSinceNow
                NSLog("%d", Int(timeDiff!))
                let remainTime = theBuilding.buildCostTime + Int(timeDiff!)
                buildingLabel.text = "still need \(remainTime) second!"
                if(remainTime<0) {
                    
                    theBuilding.complete = 1
                    buildingLabel.hidden = true
                    theBuilding.buildResult(game)
                }
            }else {
                
                buildingLabel.hidden = true
            }
        }
    }
}