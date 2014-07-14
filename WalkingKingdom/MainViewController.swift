//
//  FirstViewController.swift
//  WalkingKingdom
//
//  Created by pei hao on 7/5/14.
//  Copyright (c) 2014 pei hao. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController,MKMapViewDelegate,UIActionSheetDelegate {
                            
    var map: MKMapView?
    var game: Game?
    var annotation:MKAnnotation?
    var location:CLLocationCoordinate2D?
    
    @IBOutlet var infoView: UIView
    @IBOutlet var infoView2: UIView
    @IBOutlet var moneyLabel: UILabel
    @IBOutlet var woodLabel: UILabel
    @IBOutlet var lumberLabel: UILabel
    @IBOutlet var rockLabel: UILabel
    @IBOutlet var cutstoneLabel: UILabel
    @IBOutlet var wheatLabel: UILabel
    @IBOutlet var woolLabel: UILabel
    @IBOutlet var clothLabel: UILabel
    @IBOutlet var peopleAndEnergyLabel: UILabel
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        infoView.layer.borderWidth = 1
        infoView.layer.opacity = 0.7
        infoView2.layer.borderWidth = 1
        infoView2.layer.opacity = 0.7

        
        map?.setUserTrackingMode(MKUserTrackingMode.Follow,animated:true)
        game = Game.sharedGame()
        //game?.buildings.removeAll(keepCapacity: true)
            
        updateInfoView()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "coinOrEnergyChanging:", name: "coinOrEnergyChanging", object: nil)
        
        for building in game!.buildings {
            
            var buildingAnnation = BuildingAnnotation(coordinate:building.location!)
            buildingAnnation.building = building
            map?.addAnnotation(buildingAnnation)
        }
        
        var gesture = UITapGestureRecognizer(target:self, action: (selector: "clickOnMap:"))
        map?.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func crown(sender: AnyObject) {

        map?.setUserTrackingMode(MKUserTrackingMode.Follow,animated:true)
    }
    
    
    @IBAction func close(segue:UIStoryboardSegue) {
    
    }
    
    @IBAction func clickOnMap(sender: AnyObject) {
        
        var gesture:UITapGestureRecognizer = sender as UITapGestureRecognizer
        var point = gesture.locationInView(gesture.view)
        
        location = map?.convertPoint(point, toCoordinateFromView:map)
        self.annotation = MenuAnnotation(coordinate:location!)
        map?.addAnnotation(annotation)
        
        var menu = UIActionSheet(title: "build", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Build")
        
        menu.showInView(self.view)
    }
    
    func buildABuilding(building:Building) {
    
        var canBuild = game?.checkingBuildingPossible(building)
        if(canBuild!) {
            
            building.location = location
            
            game?.buildABuilding(building)
            
            var buildingAnnation = BuildingAnnotation(coordinate:building.location!)
            buildingAnnation.building = building
            map?.addAnnotation(buildingAnnation)
            
            updateInfoView()
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {

        map?.removeAnnotation(self.annotation)
        
        if(buttonIndex != 0) {
            
            return
        }
        
        var nav = self.storyboard.instantiateViewControllerWithIdentifier("BuildingsTableViewController") as UINavigationController
        var table = nav.topViewController as BuildingsTableViewController
        table.main = self
        self.presentViewController(nav , animated: true, completion: nil)
    }
    
    func coinOrEnergyChanging(notice:NSNotification) {
        
        updateInfoView()
    }
    
    func updateInfoView() {
    
        dispatch_async(dispatch_get_main_queue(), {

            self.moneyLabel.text     = "💰 \(self.game?.coin)"
            self.woodLabel.text      = "🌲 \(self.game?.wood)"
            self.lumberLabel.text    = "✏ \(self.game?.lumber)"
            self.rockLabel.text      = "🗿 \(self.game?.rock)"
            self.cutstoneLabel.text  = "📏 \(self.game?.cutstone)"
            self.wheatLabel.text     = "🍚 \(self.game?.wheat)"
            self.woolLabel.text      = "🐑 \(self.game?.wool)"
            self.clothLabel.text     = "👔 \(self.game?.cloth)"
            self.peopleAndEnergyLabel.text
                = "👨 \(self.game?.usedPeople)/\(self.game?.people) ⚡️ \(self.game?.energy)"
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if (annotation.isKindOfClass(MKUserLocation)) {
        
            var user = MKPinAnnotationView(annotation:annotation!, reuseIdentifier:"userlocation")
            return user
        } else if (annotation.isKindOfClass(MenuAnnotation)) {
            
            var menu = MKAnnotationView(annotation:annotation, reuseIdentifier:"Menu")
            menu.image = UIImage(named:"crown.png")
            return menu
        } else if (annotation.isKindOfClass(BuildingAnnotation)) {
        
            var buildingAV = MKAnnotationView(annotation:annotation, reuseIdentifier:"Building")
            NSLog("%f,%f", annotation.coordinate.latitude,annotation.coordinate.longitude)
            var buildingAnnotation = annotation as BuildingAnnotation
            buildingAV.image = UIImage(named: buildingAnnotation.building?.imageName)
            var building = buildingAnnotation.building
            NSLog("%@", buildingAV)
            return buildingAV
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    
    
    }

}

class MenuAnnotation:NSObject,MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    
    init(coordinate:CLLocationCoordinate2D) {
        
        self.coordinate  = coordinate
    }
}

class BuildingAnnotation:NSObject,MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var building:Building?
    init(coordinate:CLLocationCoordinate2D) {
        
        self.coordinate  = coordinate
    }
}
