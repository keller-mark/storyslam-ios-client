//
//  AppDelegate.swift
//  StorySlam
//
//  Created by Mark Keller on 7/9/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TWTSideMenuViewControllerDelegate {

    var window: UIWindow?
    
    var menuButton: UIView? = nil
    var menuViewController: SSSideMenu? = nil
    var mainViewController: HomeController? = nil
    var sideMenuViewController: SSSideMenuViewController? = nil
    var line1: UIView? = nil
    var line2: UIView? = nil
    var line3: UIView? = nil
    var menuButtonBarHeight: CGFloat? = nil
    var menuButtonIsX = false
    var navBarHeight: CGFloat = 80
    var menuButtonSize: CGFloat = 40
    var menuButtonLeftMargin: CGFloat = 15
    



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        registerForPushNotifications(application)
        
        GADMobileAds.configureWithApplicationID("ca-app-pub-000000000-your-number-here")
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setSideMenu(menuViewController: SSSideMenu, mainViewController: HomeController) {
        
        self.menuViewController = menuViewController
        self.mainViewController = mainViewController
        
        self.sideMenuViewController = SSSideMenuViewController.init(menuViewController: self.menuViewController!, mainViewController: self.mainViewController!)
        
        // specify the shadow color to use behind the main view controller when it is scaled down.
        self.sideMenuViewController!.shadowColor = UIColor.blackColor()
        
        // specify a UIOffset to offset the open position of the menu
        self.sideMenuViewController!.edgeOffset = UIOffsetMake(18.0, 0.0)
        //self.sideMenuViewController!.animationType = TWTSideMenuAnimationType.FadeIn
        //self.sideMenuViewController!.animationSwapDuration = 0.0
        //self.sideMenuViewController!.animationDuration = 0.0
        
        self.sideMenuViewController!.delegate = self
        
        
        
        // specify a scale to zoom the interface — the scale is 0.0 (scaled to 0% of it's size) to 1.0 (not scaled at all). The example here specifies that it zooms so that the main view is 56.34% of it's size in open mode.
        self.sideMenuViewController!.zoomScale = 0.5634
        
        
        self.createMenuButton()
        self.sideMenuViewController!.view.addSubview(self.menuButton!)
        
        // set the side menu controller as the root view controller
        
        
        self.window!.rootViewController = self.sideMenuViewController!
    }
    
    func clearSideMenu() {
        self.menuViewController = nil
        self.mainViewController = nil
        self.sideMenuViewController = nil
    }
    
    func sideMenuViewControllerWillOpenMenu(sideMenuViewController: TWTSideMenuViewController!) {
        //self.mainViewController!.menuButtonToggleX()
        self.menuButtonToggleX()
    }
    
    func sideMenuViewControllerWillCloseMenu(sideMenuViewController: TWTSideMenuViewController!) {
        //self.mainViewController!.menuButtonToggleX()
        self.menuButtonToggleX()
    }
    
    func createMenuButton() {
        self.menuButton = UIView()
        self.menuButton!.frame = CGRect(x: self.menuButtonLeftMargin, y: 30, width: self.menuButtonSize, height: self.menuButtonSize)
        self.menuButton!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapMenuButton:")))
        
        
        self.line1 = UIView()
        self.line2 = UIView()
        self.line3 = UIView()
        
        self.menuButtonBarHeight = menuButtonSize/11
        
        let menuButtonBarColor = StorySlam.colorYellow
        let menuButtonBarRadius = menuButtonBarHeight!/2
        
        
        line1!.frame = CGRect(x: 0, y: menuButtonBarHeight!*2, width: menuButtonSize, height: menuButtonBarHeight!)
        line2!.frame = CGRect(x: 0, y: menuButtonBarHeight!*5, width: menuButtonSize, height: menuButtonBarHeight!)
        line3!.frame = CGRect(x: 0, y: menuButtonBarHeight!*8, width: menuButtonSize, height: menuButtonBarHeight!)
        
        line1!.backgroundColor = menuButtonBarColor
        line2!.backgroundColor = menuButtonBarColor
        line3!.backgroundColor = menuButtonBarColor
        
        line1!.layer.cornerRadius = menuButtonBarRadius
        line2!.layer.cornerRadius = menuButtonBarRadius
        line3!.layer.cornerRadius = menuButtonBarRadius
        
        self.menuButton!.addSubview(line1!)
        self.menuButton!.addSubview(line2!)
        self.menuButton!.addSubview(line3!)
        
        //self.menuButton!.backgroundColor = UIColor.blackColor()
        
    }
    func hideMenuButton() {
        if(self.menuButton != nil) {
            self.menuButton!.removeFromSuperview()
        }
    }
    func showMenuButton() {
        if(self.menuButton != nil) {
            self.sideMenuViewController!.view.addSubview(self.menuButton!)
        }
    }
    
    func tapMenuButton(sender: AnyObject) {
        self.mainViewController!.stopRefreshButton()
        self.sideMenuViewController!.toggleMenuAnimated(true, completion: {(success: Bool!) in print("menu toggle")})
    }
    func menuButtonToggleX() {
        
        self.menuButton!.userInteractionEnabled = false
        if(self.mainViewController != nil && self.mainViewController!.view != nil) {
            self.mainViewController!.view.userInteractionEnabled = false
        }
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            //put your code which should be executed with a delay here
            self.menuButton!.userInteractionEnabled = true
            if(!self.menuButtonIsX && self.mainViewController != nil && self.mainViewController!.view != nil) {
                self.mainViewController!.view.userInteractionEnabled = true
            }
            
        }
        
        if(self.menuButtonIsX) {
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.line1!.transform = CGAffineTransformIdentity
                self.line3!.transform = CGAffineTransformIdentity
                
                self.line2!.backgroundColor = StorySlam.colorYellow
            })
            
            self.menuButtonIsX = false
            
        } else {
            if(self.mainViewController != nil && self.mainViewController!.contentView != nil && self.mainViewController!.contentView!.view != nil) {
                self.mainViewController!.contentView!.view!.endEditing(true)
            }
            
            var t1 = CGAffineTransformIdentity
            t1 = CGAffineTransformTranslate(t1, 0, menuButtonBarHeight!*3)
            t1 = CGAffineTransformRotate(t1, CGFloat(M_PI_2/2))
            
            var t3 = CGAffineTransformIdentity
            t3 = CGAffineTransformTranslate(t3, 0, -menuButtonBarHeight!*3)
            t3 = CGAffineTransformRotate(t3, CGFloat(-M_PI_2/2))
            
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.line1!.transform = t1
                self.line3!.transform = t3
                
                self.line2!.backgroundColor = UIColor.clearColor()
            })
            
            self.menuButtonIsX = true
        }
        
    }
    
    
    //push notification stuff
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert],
            categories: nil
        )
        application.registerUserNotificationSettings(notificationSettings)
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token: ", tokenString)
        StorySlam.device_token = tokenString
        StorySlam.sendDeviceToken()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        
        print("\(userInfo)")
        
        if(application.applicationState == UIApplicationState.Active) {
            application.applicationIconBadgeNumber = 0
            
            if let info = userInfo["aps"] as? Dictionary<String, AnyObject> {
                if  let alert_message = info["alert"] as? String {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let alert = UIAlertController(title: "StorySlam Notification", message: alert_message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.mainViewController!.refreshContent()}))
                        self.mainViewController!.presentViewController(alert, animated: true, completion: nil)
                        
                    })
                }
            }

        } else {
            application.applicationIconBadgeNumber++
        }
    }
    
    


}

