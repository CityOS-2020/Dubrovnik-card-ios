//
//  ValidationViewController.swift
//  Dubrovnik Card
//
//  Created by Andrej Saric on 09/05/15.
//  Copyright (c) 2015 Andrej Saric. All rights reserved.
//

import UIKit
import CoreLocation

class ValidationViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var lastProximity: CLProximity?
    var region:CLBeaconRegion?
    
    @IBOutlet weak var exploreBtn: UIButton!
    @IBOutlet weak var validationImageView: UIImageView!
    @IBOutlet weak var validationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        exploreBtn.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.05, green:0.17, blue:0.31, alpha:1.0)
        exploreBtn.backgroundColor = UIColor(red:0.05, green:0.17, blue:0.31, alpha:1.0)
        
        locationManager.startRangingBeaconsInRegion(region!)
        
        locationManager.startUpdatingLocation()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "to Explore" {
            
            if let destinationVC = segue.destinationViewController as? ExploreViewController {
                destinationVC.region = region
            }
            
        }
    }
    

}

extension ValidationViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        var message = " "
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if(knownBeacons.count > 0) {
            
            let nearestBeacon:CLBeacon = knownBeacons[0] as! CLBeacon
            
            switch nearestBeacon.proximity {
            
            case CLProximity.Immediate:
                
                if nearestBeacon.minor == 43620 {
                    validationMsg()
                    locationManager.stopRangingBeaconsInRegion(region)
                }
                
            default:
                return
            }
        }
    }
    
    func validationMsg(){
        
        if userDefaults.boolForKey(region!.identifier) {
         
            validationImageView.image = UIImage(named: "valid")
            
            validationLabel.text = "Your card was successfully validated"
            
            userDefaults.setBool(false, forKey: region!.identifier)
            
        }else {
            
            let alert = UIAlertController(title: region?.identifier, message: "This card was already used!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}//end extension
