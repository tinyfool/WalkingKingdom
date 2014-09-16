//
//  Game.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/6/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation
import UIKit

class Game :NSObject,NSCoding {

    var energy:Int = 20
    
    //resources in Game
    var coin:Int = 30000
    var wood:Int = 0
    var lumber:Int = 0
    var rock:Int = 0
    var cutstone:Int = 0
    var wheat:Int = 0
    var wool:Int = 0
    var cloth:Int = 0
    var exp:Int = 0
    
    var people = 0
    var usedPeople = 0
    
    var level = 1
    
    var stepCollected:Dictionary<NSDate,Int>
    
    var buildings:[Building]
    
    class func sharedGame()->Game {
        struct Static {
            
            static var game: Game? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            
            var url:NSURL = Game.saveUrl()
            if(NSFileManager.defaultManager().fileExistsAtPath(url.path!)) {
                
                NSLog("%@", url)
                var data = NSData.dataWithContentsOfURL(url, options: .DataReadingMappedIfSafe, error: nil)
                NSLog("%@", data)
                var object:AnyObject? =  NSKeyedUnarchiver.unarchiveObjectWithData(data)
                if((object) != nil) {
                    
                    Static.game = object! as? Game
                    if((Static.game) == nil) {
                        Static.game = self()
                    }
                }else {
                    Static.game = self()
                }
            }else {
                Static.game = self()
            }
        }

        return Static.game!
    }
    
    required override init() {
        
        stepCollected = Dictionary<NSDate,Int>()
        buildings = []
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(stepCollected, forKey: "stepCollected")
        aCoder.encodeInteger(energy, forKey: "energy")
        
        aCoder.encodeInteger(coin, forKey: "coin")
        aCoder.encodeInteger(wood, forKey: "wood")
        aCoder.encodeInteger(lumber, forKey: "lumber")
        aCoder.encodeInteger(rock, forKey: "rock")
        aCoder.encodeInteger(cutstone, forKey: "cutstone")
        aCoder.encodeInteger(wheat, forKey: "wheat")
        aCoder.encodeInteger(wool, forKey: "wool")
        aCoder.encodeInteger(cloth, forKey: "cloth")
        
        aCoder.encodeInteger(exp, forKey: "exp")
        aCoder.encodeInteger(level, forKey: "level")
        
        aCoder.encodeInteger(people, forKey: "people")
        aCoder.encodeInteger(usedPeople, forKey: "usedPeople")

        aCoder.encodeObject(buildings, forKey: "buildings")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        stepCollected = aDecoder.decodeObjectForKey("stepCollected") as Dictionary<NSDate,Int>
        energy = aDecoder.decodeIntegerForKey("energy")
        
        coin = aDecoder.decodeIntegerForKey("coin")
        wood = aDecoder.decodeIntegerForKey("wood")
        lumber = aDecoder.decodeIntegerForKey("lumber")
        rock = aDecoder.decodeIntegerForKey("rock")
        cutstone = aDecoder.decodeIntegerForKey("cutstone")
        wheat = aDecoder.decodeIntegerForKey("weat")
        wool = aDecoder.decodeIntegerForKey("wool")
        cloth = aDecoder.decodeIntegerForKey("cloth")
        
        exp = aDecoder.decodeIntegerForKey("exp")
        level = aDecoder.decodeIntegerForKey("level")
        if(level<1) {
            level = 1
        }
        people = aDecoder.decodeIntegerForKey("people")
        usedPeople = aDecoder.decodeIntegerForKey("usedPeople")
        
        buildings = aDecoder.decodeObjectForKey("buildings") as [Building]
        
        NSLog("%@", buildings)
    }

    func notifyChange() {
        
        NSNotificationCenter.defaultCenter().postNotificationName("coinOrEnergyChanging",object:self)
    }
    
    func todayStepCollected() ->Int {
    
        initStepCollectedTodayIfNeed()
        var today = Game.dayZeroOclock(NSDate.date())
        return stepCollected[today]!
    }
    
    func initStepCollectedTodayIfNeed() {
    
        var today = Game.dayZeroOclock(NSDate.date())
        if(stepCollected.indexForKey(today)==nil) {
            stepCollected[today] = 0
        }
    }
    
    func collect2Coin(allStep:Int) {
    
        var remainStep = allStep - todayStepCollected()
        if(remainStep>=100) {
            
            coin += 10
            initStepCollectedTodayIfNeed()
            var today = Game.dayZeroOclock(NSDate.date())
            stepCollected[today] = stepCollected[today]! + 100
        }
        notifyChange()
    }
    
    func collect2Energy(allStep:Int) {
        
        var remainStep = allStep - todayStepCollected()
        if(remainStep>=1000) {
            
            energy += 1
            initStepCollectedTodayIfNeed()
            var today = Game.dayZeroOclock(NSDate.date())
            stepCollected[today] = stepCollected[today]! + 1000
        }
        notifyChange()
    }
    
    class func saveUrl() -> NSURL{
    
        var fileMgr = NSFileManager.defaultManager()
        var file = fileMgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        var url:NSURL = file[0] as NSURL
        url = url.URLByAppendingPathComponent("game.sav")
        return url
    }
    
    func save() {
    
        var data = NSKeyedArchiver.archivedDataWithRootObject(self)
        data.writeToURL(Game.saveUrl(), atomically: true)
    }
    
    
    class func dayZeroOclock(date: NSDate) -> NSDate{
        
        var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        calendar.timeZone = NSTimeZone.localTimeZone()
        let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        var dateComponents = calendar.components(flags, fromDate: date)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        var zeroDate = calendar.dateFromComponents(dateComponents)
        return zeroDate!
    }
    
    func buildABuilding(building:Building) {
    
        makeBuildingCost(building)
        buildings.append(building)
    }
    
    func checkingBuildingPossible(building:Building) -> Bool {
        
        
        var message:NSString

        if(building.isKindOfClass(AuthorityBuilding)) {
            
            if(checkingAuthorityBuildingExisted()) {
                
                message = "You already have an Authority Building, you can only update it, can't build more."
                alertForBuildingRequirement(message)
                return false
            }
        }
        
        var br = building.buildingRequirement
        
        if(br.needPeople > people - usedPeople) {
        
            message = "Need more people, make more house..."
            alertForBuildingRequirement(message)
            return false
        }
        
        for (cost,amount) in br.buildingCost {
            
            switch(cost) {
            
                case "coin":
                    if(amount>self.coin) {
                        
                        message = "Need 💰 \(amount) and you only have 💰 \(self.coin)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "wood":
                    if(amount>self.wood) {
                    
                        message = "Need 🌲 \(amount) coin and you only have 🌲 \(self.wood)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "lumber":
                    if(amount>self.lumber) {
                    
                        message = "Need ✏ \(amount) and you only have ✏ \(self.lumber)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "rock":
                    if(amount>self.rock) {
                    
                        message = "Need 🗿 \(amount) coin and you only have 🗿 \(self.rock)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "cutstone":
                    if(amount>self.cutstone) {
                    
                        message = "Need 📏 \(amount) and you only have 📏 \(self.cutstone)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "wheat":
                    if(amount>self.wheat) {
                    
                        message = "Need 🍚 \(amount) coin and you only have 🍚 \(self.wheat)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "wool":
                    if(amount>self.wool) {
                    
                        message = "Need 🐑 \(amount) and you only have 🐑 \(self.wool)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                case "cloth":
                    if(amount>self.cloth) {
                    
                        message = "Need 👔 \(amount) coin and you only have 👔 \(self.cloth)"
                        alertForBuildingRequirement(message)
                        return false
                    }
                
                default:
                    NSLog("%@", cost)
            }
        }
        return true
    }
    
    func makeBuildingCost(building:Building) -> Bool {
        
        var br = building.buildingRequirement
        self.usedPeople += br.needPeople
        self.exp += br.exp
        building.buildCostTime = building.buildingRequirement.buildCostTime
        
        for (cost,amount) in br.buildingCost {
            
            switch(cost) {
                
            case "coin":
                self.coin -= amount;
                
            case "wood":
                self.wood -= amount;
                
            case "lumber":
                self.lumber -= amount;

            case "rock":
                self.rock -= amount;

            case "cutstone":
                self.cutstone -= amount;
                
            case "wheat":
                self.wheat -= amount;
                
            case "wool":
                self.wool -= amount;
                
            case "cloth":
                self.cloth -= amount;
                
            default:
                NSLog("%@", cost)
            }
        }
        return false
    }

    
    func alertForBuildingRequirement(message:NSString) {
    
        var alert = UIAlertView(
            title: "You can't build!",
            message: message,
            delegate: nil,
            cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func checkingAuthorityBuildingExisted() -> Bool {
    
        for  building in buildings {
            if(building.isKindOfClass(AuthorityBuilding)) {
                return true
            }
        }
        return false
    }
}