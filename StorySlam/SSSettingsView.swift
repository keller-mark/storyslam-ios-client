//
//  SSSettingsView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSSettingsView: SSContentView {
    
    var lblTitle: UILabel?
    
    
    var btnMyProfile: UIButton?
    var btnEditProfile: UIButton? = nil

    
    var btnWebsite: UIButton? = nil
    
    var btnLogOut: UIButton? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupFrames()
    }
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()

        self.scrollView!.backgroundColor = StorySlam.colorOrange
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Settings"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorDarkPurple
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        self.btnMyProfile = UIButton()
        self.btnMyProfile!.layer.cornerRadius = 20
        self.btnMyProfile!.backgroundColor = StorySlam.colorBlue
        self.btnMyProfile!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnMyProfile!.setTitle("My Profile", forState: .Normal)
        self.btnMyProfile!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnMyProfile!.addTarget(self, action: Selector("goToMyProfile:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnMyProfile!)
        
        self.btnEditProfile = UIButton()
        self.btnEditProfile!.layer.cornerRadius = 20
        self.btnEditProfile!.backgroundColor = StorySlam.colorBlue
        self.btnEditProfile!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnEditProfile!.setTitle("Edit Profile", forState: .Normal)
        self.btnEditProfile!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnEditProfile!.addTarget(self, action: Selector("goToEditProfile:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnEditProfile!)
        
        
        self.btnWebsite = UIButton()
        self.btnWebsite!.layer.cornerRadius = 20
        self.btnWebsite!.backgroundColor = StorySlam.colorGreen
        self.btnWebsite!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnWebsite!.setTitle("StorySlam Website", forState: .Normal)
        self.btnWebsite!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnWebsite!.addTarget(self, action: Selector("goToWebsite:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnWebsite!)
        
        
      
        
        self.btnLogOut = UIButton()
        self.btnLogOut!.layer.cornerRadius = 20
        self.btnLogOut!.backgroundColor = StorySlam.colorDarkPurple
        self.btnLogOut!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnLogOut!.setTitle("Log Out", forState: .Normal)
        self.btnLogOut!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnLogOut!.addTarget(self, action: Selector("logOut:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnLogOut!)
        

        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: 0, width: self.myWidth!, height: 46)
        
        self.btnMyProfile!.frame = CGRect(x: 10, y:  self.calculateHeight(40, marginTop: 20), width: self.myWidth!-20, height: 40)
        
        self.btnEditProfile!.frame = CGRect(x: 10, y:  self.calculateHeight(40, marginTop: 20), width: self.myWidth!-20, height: 40)
        
        self.btnWebsite!.frame = CGRect(x: 10, y:  self.calculateHeight(40, marginTop: 20), width: self.myWidth!-20, height: 40)
        
        self.btnLogOut!.frame = CGRect(x: 10, y:  self.calculateHeight(40, marginTop: 20), width: self.myWidth!-20, height: 40)
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false))
        
        
    }
    

    
    func logOut(sender: AnyObject) {
        self.appDelegate.mainViewController!.logOut()

    }
    
    func goToMyProfile(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSMyProfileView())
        
    }
    
    func goToEditProfile(sender: AnyObject) {
        
        appDelegate.mainViewController!.setHomeContentView(SSMyProfileView())
        let profileView = appDelegate.mainViewController!.contentView as! SSMyProfileView
        profileView.tapEdit(self)
        
        
    }
    
    func goToWebsite(sender: AnyObject) {
        if let url = NSURL(string: StorySlam.websiteURL){
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
   
    
    
    
}