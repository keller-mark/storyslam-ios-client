//
//  HomeController.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class HomeController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var navBar: UIView? = nil
    var menuButtonBarHeight: CGFloat? = nil
    var navBarHeight: CGFloat = 80
    var menuButtonSize: CGFloat = 40
    var menuButtonLeftMargin: CGFloat = 15
    var imgTitle: UIImageView? = nil
    
    var loadingTintLayer = CALayer()
    var navBarIsTinted = false
    
    var btnRefresh: FLAnimatedImageView? = nil
    var gifRefresh: FLAnimatedImage? = nil
    
    //var refreshIcon: SVGKFastImageView? = nil
    
    
    var contentFrame: CGRect? = nil
    var contentView: SSContentView? = nil
    
    var contentViewHistory = [SSContentView]()
    
    var totalWidth: CGFloat? = nil
    var totalHeight: CGFloat? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeSideMenu()
        
        self.createNavBar()
        
        self.updateFrames()
        
        if(self.checkLogin()) {
            self.setHomeContentView(SSHomeView())
        
        } else {
            self.logOut()
        }
        
        
    }


    
    func initializeSideMenu() {
        if(appDelegate.sideMenuViewController == nil) {
            _ = appDelegate.setSideMenu(SSSideMenu(), mainViewController: self)
            
        }
    }
    /*override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //_ = appDelegate.clearSideMenu()
    }*/
    
    func createNavBar() {
        self.navBar = UIView()
        self.navBar!.backgroundColor = StorySlam.colorLightPurple

        
        
        self.imgTitle = UIImageView()
        self.imgTitle!.image = UIImage(named: "StorySlamTitle")
        self.imgTitle!.contentMode = .ScaleAspectFit
        self.navBar!.addSubview(self.imgTitle!)
        
        let tintColor = UIColor.blackColor().colorWithAlphaComponent(StorySlam.tintValue).CGColor as CGColorRef
        self.loadingTintLayer.backgroundColor = tintColor
        

        
        self.createRefreshButton()

        self.view.addSubview(self.navBar!)
        
        
    }

    
    

    
    func updateFrames() {
        self.totalWidth = self.view.bounds.width
        self.totalHeight = self.view.bounds.height
        
        
        
        self.navBar!.frame = CGRect(x: 0, y: 0, width: self.totalWidth!, height: navBarHeight)
        
        
        self.loadingTintLayer.frame = self.navBar!.frame
        
        
        //self.refreshIcon!.frame = CGRect(x: 0, y: self.totalWidth!-32-10, width: 32, height: 24)
    
        self.imgTitle!.frame = CGRect(x: self.menuButtonLeftMargin+self.menuButtonSize, y: 20, width: self.totalWidth!-2*(self.menuButtonLeftMargin+self.menuButtonSize), height: self.navBarHeight-25)
        self.contentFrame = CGRect(x: 0, y: self.navBarHeight, width: self.totalWidth!, height: self.totalHeight! - self.navBarHeight)
        
        if(self.btnRefresh != nil) {
            self.btnRefresh!.frame = CGRect(x: self.totalWidth!-36-12, y: self.navBarHeight-36-12, width: 36, height: 36)
        }
        
    }
    
    func setHomeContentView(theView: SSContentView, goingBack: Bool = false) {
        self.removeHomeContentView()
        
        if(!goingBack) {
            self.contentViewHistory.append(theView)
            print("adding view to history (\(self.contentViewHistory.count))...")
        }
        self.contentView = theView
        self.contentView!.view.frame = self.contentFrame!
        self.contentView!.setupFrames()
        self.addChildViewController(self.contentView!)
        self.view.addSubview(self.contentView!.view)
    }
    
    func removeHomeContentView() {
        if(self.contentView != nil) {
            self.contentView!.removeFromParentViewController()
            self.contentView!.view.removeFromSuperview()
        }
    }
    
    func backHomeContentView() {
        if(self.canGoBack()) {
            _ = self.contentViewHistory.removeLast() //current view
            let previousView = self.contentViewHistory.removeLast()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setHomeContentView(previousView)
                print("going back...")
            })
        }
    }
    
    func canGoBack() -> Bool {
        if(self.contentViewHistory.count >= 2) {
            let currentView = self.contentViewHistory[self.contentViewHistory.count - 1]
            let previousView = self.contentViewHistory[self.contentViewHistory.count - 2]
            
            if(!currentView.isLoginView && !previousView.isLoginView) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
    func createRefreshButton() {
        self.btnRefresh = FLAnimatedImageView()
        if let path =  NSBundle.mainBundle().pathForResource("refresh-yellow-animated", ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                self.gifRefresh = FLAnimatedImage(animatedGIFData: data)
                self.btnRefresh!.animatedImage = gifRefresh!
                self.btnRefresh!.stopAnimating()
                
                self.updateFrames()
                
                
            }
        }
    }
    
    func showRefreshButton(actionParent: AnyObject, action: String) {
        if(self.btnRefresh != nil) {
            dispatch_async(dispatch_get_main_queue(), {
            self.btnRefresh!.addGestureRecognizer(UITapGestureRecognizer.init(target: actionParent, action: Selector(action)))
            self.btnRefresh!.userInteractionEnabled = true
            self.navBar!.addSubview(self.btnRefresh!)
            self.btnRefresh!.stopAnimating()
            })
            
       
        }
    }
    
    func hideRefreshButton() {
        dispatch_async(dispatch_get_main_queue(), {
        if(self.btnRefresh != nil) {
            self.btnRefresh!.removeFromSuperview()
            self.stopRefreshButton()
            if(self.btnRefresh!.gestureRecognizers != nil) {
                for recognizer in self.btnRefresh!.gestureRecognizers! {
                    self.btnRefresh!.removeGestureRecognizer(recognizer)
                }
            }
        }
        })
    }
    
    func startRefreshButton() {
        if(self.btnRefresh != nil) {
            self.btnRefresh!.startAnimating()
            self.btnRefresh!.userInteractionEnabled = false
        }
    }
    func stopRefreshButton() {
        if(self.btnRefresh != nil) {
            self.btnRefresh!.stopAnimating()
            self.btnRefresh!.animatedImage = nil
            self.btnRefresh!.animatedImage = self.gifRefresh!
            self.btnRefresh!.stopAnimating()
            self.btnRefresh!.userInteractionEnabled = true
        }
    }
    
    func tintNavBar() {
        if(!self.navBarIsTinted) {
            self.navBar!.layer.insertSublayer(self.loadingTintLayer, atIndex: 10)
            self.navBarIsTinted = true
        }
    }
    func untintNavBar() {
        if(self.navBarIsTinted) {
            self.loadingTintLayer.removeFromSuperlayer()
            self.navBarIsTinted = false
        }
    }
    


    
    /*override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.updateFrames()
    }*/
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.updateFrames()
    }
    
    func checkLogin() -> Bool{
        print("checking...")
        if(StorySlam.getCurrentUser() != nil) {
            print("current user is set...")
            return true
        } else {
            return false
        }
    }
    
    
    func logOut() {
        StorySlam.logOut()
        
        appDelegate.hideMenuButton()
        self.hideRefreshButton()
        
        self.setHomeContentView(SSLoginView.init(nibName: nil, bundle: nil))
    }
    
    func refreshContent() {
        dispatch_async(dispatch_get_main_queue(), {
            self.contentView?.tapRefresh(self)
        })
    }
    
    
    
}