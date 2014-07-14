//
//  BuildingsTableViewController.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/9/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import UIKit

class BuildingsTableViewController : UITableViewController {
    
    var buildings:[Building]
    var main:MainViewController?
    
    init(coder aDecoder: NSCoder!) {
        
        buildings = []
        buildings.append(TownHall())
        buildings.append(SmallHouse())
        buildings.append(LoggingCamp())
        buildings.append(Farm())
        super.init(coder: aDecoder)
    }

    @IBAction func close(sender:AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//MARK: DataSource
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    
        return buildings.count
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    
        var cellIdentifier = "BuildingCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as BuildingDescriptionCell
        
        var building:Building = buildings[indexPath.row]
        
        cell.buildingImage.image = building.image
        cell.nameLabel.text = building.name
        cell.setBuildingRequestment(building.buildingRequirement)
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1
    }


    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    
        var building = self.buildings[indexPath.row]
        var buildingClass = building.classForCoder as NSObject.Type
        var newBuilding = buildingClass()
        
        self.main?.buildABuilding(newBuilding as Building)
        self.dismissViewControllerAnimated(true, completion: {})
    }
}


class BuildingDescriptionCell : UITableViewCell {

    @IBOutlet var nameLabel: UILabel
    @IBOutlet var buildingImage: UIImageView
    @IBOutlet var levelLabel: UILabel
    @IBOutlet var radiusLabel: UILabel
    
    func setBuildingRequestment(buildingRequirement:BuildingRequirement) {
    
        levelLabel.text = "Level \(buildingRequirement.levelRequired)"
        radiusLabel.text = "Radius \(buildingRequirement.radius)"
        
        var i = 1
        
        for (cost,amount) in buildingRequirement.buildingCost {
            
            var label = viewWithTag(i) as UILabel
            switch(cost) {
            
                case "coin":
                    label.text = "💰 \(amount)"
                
                case "wood":
                    label.text = "🌲 \(amount)"
                
                case "lumber":
                    label.text = "✏ \(amount)"
                
                case "rock":
                    label.text = "🗿 \(amount)"
                
                case "cutstone":
                    label.text = "📏 \(amount)"
                
                case "wheat":
                    label.text = "🍚 \(amount)"

                case "wool":
                    label.text = "🐑 \(amount)"
                
                case "cloth":
                    label.text = "👔 \(amount)"

                default:
                    label.text = ""
            }
            i++;
        }
    }
}
