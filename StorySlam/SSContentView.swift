//
//  SSContentView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class SSContentView: SSViewController {
    
    var verticalMargins = [CGFloat]()
    
    var myWidth: CGFloat? = nil
    var myHeight: CGFloat? = nil
    
    var scrollView: UIScrollView? = nil
    
    var hasTitleBar = false
    var isLoginView = false
    
    var keyboardHeight: CGFloat = 0
    
    var adView: GADBannerView?

    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillAppear(notification: NSNotification){
        // Do something here
        dispatch_async(dispatch_get_main_queue(), {
            
            let userInfo:NSDictionary = notification.userInfo!
            let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRectangle = keyboardFrame.CGRectValue()
            let keyboardHeight = keyboardRectangle.height
            
            self.keyboardHeight = keyboardHeight
            self.setupFrames()
            
            
        })
        
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        // Do something here
        self.keyboardHeight = 0
        self.setupFrames()
    }
    
    
    
    
    
    
    
    
    func setupViews() {
        
        self.scrollView = UIScrollView()
        self.view.addSubview(self.scrollView!)
        
        if(StorySlam.hasAdBar()) {
            self.adView = GADBannerView(adSize: kGADAdSizeBanner)
            self.adView!.adUnitID = "ca-app-pub-869-your-code-here"
            self.adView!.rootViewController = self
            self.adView!.backgroundColor = StorySlam.colorLightGray
            let request = GADRequest()
            request.tagForChildDirectedTreatment(false)
            request.testDevices = [kGADSimulatorID]
            self.adView!.loadRequest(request)
            self.view.addSubview(self.adView!)
        }
    }
    

    func setupFrames() {
        
        self.setSSLoaderFrames()
        self.verticalMargins.removeAll()
        
        self.myWidth = self.view.bounds.width
        self.myHeight = self.view.bounds.height
        
        var bottomMargin: CGFloat = 0
        if(StorySlam.hasAdBar()) {
            if(self.keyboardHeight == 0) {
                bottomMargin = 60
            }
            if(self.adView != nil) {
                self.adView!.frame = CGRect(x: 0, y: self.myHeight!-bottomMargin-self.keyboardHeight, width: self.myWidth!, height: bottomMargin)
            }
            
            
        }
        
        
        
        if(self.hasTitleBar) {
            self.scrollView!.frame = CGRect(x: 0, y: 46, width: self.myWidth!, height: self.myHeight!-46-bottomMargin-self.keyboardHeight)
        } else {
            self.scrollView!.frame = CGRect(x: 0, y: 0, width: self.myWidth!, height: self.myHeight!-bottomMargin-self.keyboardHeight)
        }
        
        
        
        
        
    }
    
    override func showLoadingOverlay() {
        super.showLoadingOverlay()
        appDelegate.mainViewController!.tintNavBar()
    }
    override func hideLoadingOverlay() {
        super.hideLoadingOverlay()
        appDelegate.mainViewController!.untintNavBar()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFrames()
    }
    
   /* override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        setupFrames()
    }*/
    
    func calculateHeight(height: CGFloat = 0, marginTop: CGFloat = 0, marginBottom: CGFloat = 0, add: Bool = true) -> CGFloat {
        
        if(marginTop != 0) {
            if(add) {
                self.verticalMargins.append(marginTop)
            }
        }
        
        var totalHeight: CGFloat = 0
        for margin in self.verticalMargins {
            totalHeight += margin
        }
        if(add) {
            self.verticalMargins.append(height)
        }
        
        
        if(marginBottom != 0) {
            if(add) {
                self.verticalMargins.append(marginBottom)
            }
        }
        if(add) {
            return totalHeight
        } else {
            return totalHeight - height
        }
    }
    
    func tapRefresh(sender: AnyObject) {
        print("nothing to refresh")
    }
    
    
}