//
//  ViewController.swift
//  Dubrovnik Card
//
//  Created by Andrej Saric on 08/05/15.
//  Copyright (c) 2015 Andrej Saric. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var exploreBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var visitBtn: UIButton!
    
    let cardFont = DubrovnikCardFont.getFont(40)
    let colorBlue = UIColor(red:0.05, green:0.17, blue:0.31, alpha:1.0)
    let rectorsRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Rectors Palace")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exploreBtn.titleLabel?.font = cardFont
        mapBtn.titleLabel?.font = cardFont
        buyBtn.titleLabel?.font = cardFont
        visitBtn.titleLabel?.font  = cardFont
       
       
        exploreBtn.setTitle(DubrovnikCardFont.explore, forState: .Normal)
        mapBtn.setTitle(DubrovnikCardFont.map, forState: .Normal)
        buyBtn.setTitle(DubrovnikCardFont.buy, forState: .Normal)
        visitBtn.setTitle(DubrovnikCardFont.visit, forState: .Normal)
        
        
}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.93, green:0.11, blue:0.14, alpha:1.0)
        
        self.navigationController?.navigationBar.topItem?.title = "Dubrovnik Card"
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "to Explore" {
            
            if let destinationVC = segue.destinationViewController as? ExploreViewController {
                destinationVC.region = rectorsRegion
            }
            
        }
    }


}

