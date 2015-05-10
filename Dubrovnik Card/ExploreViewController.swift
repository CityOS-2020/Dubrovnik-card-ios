//
//  ExploreViewController.swift
//  Dubrovnik Card
//
//  Created by Andrej Saric on 09/05/15.
//  Copyright (c) 2015 Andrej Saric. All rights reserved.
//

import UIKit
import CoreLocation

class ExploreViewController: UIViewController, CLLocationManagerDelegate {
    
    var region:CLBeaconRegion?
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var exploreImg: UIImageView!
    @IBOutlet weak var exploreTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.startRangingBeaconsInRegion(region!)
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.05, green:0.17, blue:0.31, alpha:1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = false
        layerView.hidden = true
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ExploreViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        var message = " "
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        if(knownBeacons.count > 0) {
            let nearestBeacon:CLBeacon = knownBeacons[0] as! CLBeacon
            
            switch nearestBeacon.proximity {
            case CLProximity.Immediate:
                println("immediate")
                if nearestBeacon.minor == 64711 {
                   presentInfo()
                    locationManager.stopRangingBeaconsInRegion(region)
                }
            default:
                return
            }
        }
    }
    
    func presentInfo() {
        self.navigationController?.navigationBarHidden = true
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        layerView.hidden = false
        exploreTextView.text = "Miho Pracat was a rich seaman from the Island of Lopud, who left his wealth to the Republic. This powerful ship-owner and accomplished merchant was shown the way to success by a little tenacious lizard. Watching its two attempts to climb the wall of his fathers house, two downfalls and eventually the third successful climbing to the top, Pracat realised the importance of persistence. This encouraged him to make a new start after his business repeatedly collapsed and his ships and their cargo ended up at the bottom of the sea."
        exploreTextView.font = UIFont.systemFontOfSize(18)
        exploreImg.image = UIImage(named: "miho_pracat")
    }

    
}