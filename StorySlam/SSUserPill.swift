//
//  SSUserPill.swift
//  StorySlam
//
//  Created by Mark Keller on 7/29/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSUserPill : UIButton {
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var user : Friend?
    var isCurrentUser : Bool?
    var current_profile_id: Int?
    static var currentUser: CurrentUser?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if(SSUserPill.currentUser == nil) {
            SSUserPill.currentUser = StorySlam.getCurrentUser()
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        if(SSUserPill.currentUser == nil) {
            SSUserPill.currentUser = StorySlam.getCurrentUser()
        }
    }
    func initialize(user: Friend, isCurrentUser: Bool = false, current_profile_id: Int? = nil) {
        
        self.user = user
        self.isCurrentUser = isCurrentUser
        self.current_profile_id = current_profile_id
   

            if(self.user!.id == SSUserPill.currentUser!.user_id!) {
                self.isCurrentUser = true
            }
        
        
        
        
        self.addTarget(self, action: Selector("goToProfile:"), forControlEvents: .TouchUpInside)
        
        self.setTitle("@\(user.username)", forState: .Normal)
        
        
        self.titleLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.layer.cornerRadius = 8
        
    }
    
    func goToProfile(sender: AnyObject) {
        if(self.user != nil && self.isCurrentUser != nil) {
            print("going to profile...")
            if(self.isCurrentUser!) {
                SSUserPill.appDelegate.mainViewController!.setHomeContentView(SSMyProfileView())
            } else {
                print("current profile id = \(self.current_profile_id)")
                if(!(self.current_profile_id != nil && self.current_profile_id! == self.user!.id)) {
                 SSUserPill.appDelegate.mainViewController!.setHomeContentView(SSUserProfileView(user: self.user!))   
                }
            }
        }else{
            print("user is nil")
        }
    }
}