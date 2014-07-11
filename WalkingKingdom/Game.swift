//
//  Game.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/6/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import Foundation

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
            if(NSFileManager.defaultManager().fileExistsAtPath(url.path)) {
                
                NSLog("%@", url)
                var data = NSData.dataWithContentsOfURL(url, options: .DataReadingMappedIfSafe, error: nil)
                NSLog("%@", data)
                var object:AnyObject? =  NSKeyedUnarchiver.unarchiveObjectWithData(data)
                if(object) {
                    
                    Static.game = object! as? Game
                    if(!Static.game) {
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
    
    @required init() {
        
        stepCollected = Dictionary<NSDate,Int>()
        buildings = []
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        
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
        
        aCoder.encodeObject(buildings, forKey: "buildings")
    }
    
    init(coder aDecoder: NSCoder!) {
        
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
        if(!stepCollected[today]) {
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
        return zeroDate
    }
    
    func buildABuilding(building:Building) {
    
    }
    
    func checkingBuildingPossible(building:Building) -> Bool {
        
        if(building.isKindOfClass(AuthorityBuilding)) {
            
            if(checkingAuthorityBuildingExisted()) {
                return false
            }
        }
        
        
        return false
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