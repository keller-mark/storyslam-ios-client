//
//  SSSideMenu.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSSideMenu: UIViewController, UIScrollViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var scrollView: UIScrollView? = nil
    
    var menuWidth: CGFloat? = nil
    
    var myProfile: UIView? = nil
    var lblProfile: UILabel? = nil
    var lblProfile2: UILabel? = nil
    var imgProfile: UIImageView? = nil
    var myProfileX: CGFloat = 20
    
    var btnHome: UIButton? = nil
    var btnHomeIndex = 0
    var btnNewStory: UIButton? = nil
    var btnNewStoryIndex = 1
    var btnFinishedStories: UIButton? = nil
    var btnFinishedStoriesIndex = 2
    var btnMyFeed: UIButton? = nil
    var btnMyFeedIndex = 3
    var btnGlobalFeed: UIButton? = nil
    var btnGlobalFeedIndex = 4
    var btnFriends: UIButton? = nil
    var btnFriendsIndex = 5
    var btnSubmitPrompt: UIButton? = nil
    var btnSubmitPromptIndex = 6
    var btnSettings: UIButton? = nil
    var btnSettingsIndex = 7
    
    var numButtons: CGFloat = 8
    
    
    var menuBtnX: CGFloat = 10
    var menuBtnY: CGFloat = 100
    var menuBtnSpace: CGFloat = 40
    var menuBtnHeight: CGFloat = 30
    
    var adHeight: CGFloat = 70
    var adTopMargin: CGFloat = 20
    
    var marginTop: CGFloat = 90
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuWidth = self.view.bounds.width * (1-(0.5634*0.5634))
        
        self.setMenuStyle()
        self.setMenuElements()
        
        self.setFrames()
    }
    
    func setMenuStyle() {
        
        self.view.backgroundColor = StorySlam.colorDarkPurple
        self.scrollView = UIScrollView()
        self.scrollView!.delegate = self
        self.scrollView!.userInteractionEnabled = true
        self.scrollView!.scrollEnabled = true
        self.scrollView!.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.scrollView!)
        
        
        
        
    }
    func updateProfile() {
        if let currentUser = StorySlam.getCurrentUser() {
            if let firstname = currentUser.firstname {
                if let lastname = currentUser.lastname {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.lblProfile!.text = "\(firstname) \(lastname)"
                    })
                    print("updating side menu profile...")
                }
            }
            if let username = currentUser.username {
                dispatch_async(dispatch_get_main_queue(), {
                    self.lblProfile2!.text = "@\(username)"
                })
            }
        }
    }
    func setMenuElements() {
        
        myProfile = UIView()
        myProfile!.backgroundColor = UIColor.clearColor()
        myProfile!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapMyProfile:")))
        self.scrollView!.addSubview(myProfile!)
        
        imgProfile = UIImageView()
        imgProfile!.image = UIImage(named: "user_o-yellow")
        imgProfile!.contentMode = .ScaleAspectFit
        self.myProfile!.addSubview(imgProfile!)
        

        
        lblProfile = UILabel()

        //lblProfile!.backgroundColor = UIColor.redColor()
        lblProfile!.textColor = StorySlam.colorYellow
        //lblProfile!.textAlignment = .Left
        lblProfile!.font = UIFont(name: "OpenSans", size: 12)
        self.myProfile!.addSubview(lblProfile!)
        
        lblProfile2 = UILabel()
        
        //lblProfile2!.backgroundColor = UIColor.redColor()
        lblProfile2!.textColor = StorySlam.colorYellow
        //lblProfile2!.textAlignment = .Left
        lblProfile2!.font = UIFont(name: "OpenSans", size: 12)
        
        self.myProfile!.addSubview(lblProfile2!)
        
        self.updateProfile()
        
        
        
        
        btnHome = self.createMenuButton(btnHomeIndex, title: "Home", tapSelector: "tapHome:")
        self.scrollView!.addSubview(btnHome!)
        
        btnNewStory = self.createMenuButton(btnNewStoryIndex, title: "New Story", tapSelector: "tapNewStory:")
        self.scrollView!.addSubview(btnNewStory!)
        
        btnFinishedStories = self.createMenuButton(btnFinishedStoriesIndex, title: "Finished Stories", tapSelector: "tapFinishedStories:")
        self.scrollView!.addSubview(btnFinishedStories!)
        
        btnMyFeed = self.createMenuButton(btnMyFeedIndex, title: "My Feed", tapSelector: "tapMyFeed:")
        self.scrollView!.addSubview(btnMyFeed!)
        
        btnGlobalFeed = self.createMenuButton(btnGlobalFeedIndex, title: "StorySlam Feed", tapSelector: "tapGlobalFeed:")
        self.scrollView!.addSubview(btnGlobalFeed!)
        
        btnFriends = self.createMenuButton(btnFriendsIndex, title: "My Friends", tapSelector: "tapMyFriends:")
        self.scrollView!.addSubview(btnFriends!)
        
        btnSubmitPrompt = self.createMenuButton(btnSubmitPromptIndex, title: "Submit Prompt", tapSelector: "tapSubmitPrompt:")
        self.scrollView!.addSubview(btnSubmitPrompt!)
        
        btnSettings = self.createMenuButton(btnSettingsIndex, title: "Settings", tapSelector: "tapSettings:")
        self.scrollView!.addSubview(btnSettings!)
        
    
    }
    
    
    func tapMyProfile(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSMyProfileView())
        self.menuToggle()
    }
    
    func tapHome(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSHomeView())
        self.menuToggle()
    }
    func tapNewStory(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSNewStoryViewStep1())
        self.menuToggle()
    }
    func tapSettings(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSSettingsView())
        self.menuToggle()
    }
    func tapMyFriends(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSFriendsView())
        self.menuToggle()
    }
    
    func tapSubmitPrompt(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSSubmitPromptView())
        self.menuToggle()
    }
    
    func tapFinishedStories(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSMyFinishedStories())
        self.menuToggle()
    }
    func tapMyFeed(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSMyFeedView())
        self.menuToggle()
    }
    
    func tapGlobalFeed(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSStorySlamFeedView())
        self.menuToggle()
    }
    
    
    
    
    func menuToggle() {
        appDelegate.sideMenuViewController!.toggleMenuAnimated(true, completion: {(success: Bool!) in print("menu toggle")})
    }
    
    func createMenuButton(index: Int, title: String, tapSelector: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        button.addTarget(self, action: Selector(tapSelector), forControlEvents: .TouchUpInside)
        button.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        button.contentHorizontalAlignment = .Left;
        
        return button
    }
    
    func setFrames() {
        self.menuWidth = self.view.bounds.width * (1-(0.5634*0.5634))
        
        self.scrollView!.frame = CGRect(x:0, y: 0, width: self.menuWidth!+20, height: self.view.bounds.height)
        
        let scrollViewHeight = menuBtnY + menuBtnSpace * numButtons + adHeight + adTopMargin
        
        if(scrollViewHeight < self.view.bounds.height) {
            self.marginTop = (self.view.bounds.height - scrollViewHeight)/2
            self.menuBtnX = 10
            self.myProfileX = 20
        } else {
            self.marginTop = 40
            self.menuBtnX = 50
            self.myProfileX = self.menuBtnX + 20
        }
        
        self.scrollView!.contentSize = CGSizeMake(self.menuWidth! + 20, scrollViewHeight+self.marginTop)
        
        btnHome!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnHomeIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnNewStory!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnNewStoryIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnFinishedStories!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnFinishedStoriesIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnMyFeed!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnMyFeedIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnGlobalFeed!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnGlobalFeedIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnFriends!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnFriendsIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnSubmitPrompt!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnSubmitPromptIndex)), width: self.menuWidth!, height: menuBtnHeight)
        btnSettings!.frame = CGRect(x: menuBtnX, y: marginTop+menuBtnY+(menuBtnSpace*CGFloat(btnSettingsIndex)), width: self.menuWidth!, height: menuBtnHeight)
        
        myProfile!.frame = CGRect(x: myProfileX, y: self.marginTop, width: self.menuWidth!-10, height: 90)
        imgProfile!.frame = CGRect(x: 0, y: 10, width: 70, height: 70)
        lblProfile!.frame = CGRect(x: 80, y: 25, width: self.menuWidth!-90, height: 20)
        lblProfile2!.frame = CGRect(x: 80, y: 45, width: self.menuWidth!-90, height: 20)
        
        
    }
    
    /*override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.setFrames()
    }*/
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setFrames()
    }
    
}