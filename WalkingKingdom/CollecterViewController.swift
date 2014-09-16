//
//  CollecterViewController.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/6/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import UIKit
import CoreMotion

class CollecterViewController: UIViewController {

    @IBOutlet var CountingLabel: UILabel?
    @IBOutlet var alreadyLabel: UILabel?
    @IBOutlet var remainLabel: UILabel?
    @IBOutlet var inforLabel: UILabel?
    @IBOutlet var loading: UILabel?
    
    var motionActivityMgr: CMMotionActivityManager?
    var pedometer: CMPedometer?
    var availability: Bool = false
    var step = 0
    var game:Game

    
    required init(coder aDecoder: NSCoder) {
        
        game = Game.sharedGame()
        motionActivityMgr = CMMotionActivityManager()
        pedometer = CMPedometer()

        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateLabels()
        availability = checkStepCoutingAvailability()
        if(!availability) {
            return
        }
        
        var now = NSDate.date()
        var zeroHour = Game.dayZeroOclock(now)
        queryData(zeroHour,toDate:now)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func close(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true,{})
    }

    
    
    func checkAuthorization() {
        
        var now = NSDate.date()
        pedometer?.queryPedometerDataFromDate(now, toDate: now, withHandler: {data, error in
            
            
            })
    }
    
    func queryData(startDate:NSDate, toDate:NSDate) {
        
        motionActivityMgr?.queryActivityStartingFromDate(
            startDate,
            toDate: toDate,
            toQueue: NSOperationQueue.mainQueue(),
            withHandler:{activities, error in
                
                if((error) != nil) {
                    
                } else {
                    
                    self.pedometer?.queryPedometerDataFromDate(          startDate,
                        toDate: toDate,
                        withHandler: {data, error in
                            
                            if((error) != nil) {
                                
                            }else {
                                
                                self.step = data.numberOfSteps.integerValue
                                dispatch_async(dispatch_get_main_queue(), {
                                    
                                    NSLog("%@", data)
                                    self.loading!.hidden = true
                                    self.updateLabels()
                                    })
                            }
                        })
                    
                }
            }
        )
    }
    
    func checkStepCoutingAvailability() -> Bool {
        
        var sentinel:dispatch_once_t = 0
        var available:Bool = true
        
        dispatch_once(&sentinel,{
            
            if(!CMMotionActivityManager.isActivityAvailable()){
                
                available = false
            }
            
            if(!CMPedometer.isStepCountingAvailable()) {
                available = false
            }
            });
        return available
    }
    
    @IBAction func collectEnergy(sender: AnyObject) {
        
        game.collect2Energy(self.step)
        updateLabels()
    }
    
    
    @IBAction func collectCoin(sender: AnyObject) {
    
        game.collect2Coin(self.step)
        updateLabels()
    }
    
    func updateLabels() {
    
        self.CountingLabel!.text = "\(self.step) 👣"
        inforLabel!.text = "💰 \(game.coin) ⚡️ \(game.energy)"
        var alreadyCollect = game.todayStepCollected()
        var remainSteps = self.step - alreadyCollect
        alreadyLabel!.text = "Already collect \(alreadyCollect) 👣"
        remainLabel!.text = "Reamin \(remainSteps) 👣"
    }
    
}

