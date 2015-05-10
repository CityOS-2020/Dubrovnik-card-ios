//
//  AppDelegate.swift
//  Dubrovnik Card
//
//  Created by Andrej Saric on 08/05/15.
//  Copyright (c) 2015 Andrej Saric. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager:CLLocationManager?
    var lastRegion:CLBeaconRegion?
    
    let rectorsRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Rectors Palace")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "Rectors Palace")
        
        locationManager = CLLocationManager()
        
        if locationManager!.respondsToSelector("requestAlwaysAuthorization")
        {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            
            let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        locationManager!.startMonitoringForRegion(rectorsRegion)
        locationManager!.startUpdatingLocation()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: CLLocationManagerDelegate {
    
    enum SendType {
        case Present, Schedule
    }
    
    func sendLocalNotification(message: String, type: SendType) {
        
        let app = UIApplication.sharedApplication()
        
        let notification = UILocalNotification()
        
        notification.alertBody = message
        
        notification.soundName = UILocalNotificationDefaultSoundName
        
        type == .Schedule ? app.scheduleLocalNotification(notification) : app.presentLocalNotificationNow(notification)
    }
    
    func sendNotification(region: CLRegion) {
        
        locationManager!.startUpdatingLocation()
        
        switch UIApplication.sharedApplication().applicationState
        {
        case .Background:
            sendLocalNotification("You are near \(region.identifier)", type: .Schedule)
        case .Active:
            sendLocalNotification("You are near \(region.identifier)", type: .Present)
        default:
            return
        }
        
        lastRegion = region as? CLBeaconRegion
        
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        
        if state == CLRegionState.Inside  && NSUserDefaults.standardUserDefaults().boolForKey(region.identifier){
            
            sendNotification(region)
            
        }else {
            
            locationManager?.startMonitoringForRegion(region)
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey(region.identifier) {
            
            sendNotification(region)
        }
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        if UIApplication.sharedApplication().applicationState == .Active {
        
            let alert = UIAlertController(title: "Sight Nearby", message: "You are near \(lastRegion!.identifier)", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default, handler: { bool in if self.lastRegion != nil { self.transitionToValidateViewController() } }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func transitionToValidateViewController() {
        
        var validationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ValidateCard") as! ValidationViewController
        
        validationViewController.region = lastRegion
        
        self.window?.rootViewController?.showViewController(validationViewController, sender: self.window?.rootViewController)

    }

}








