//
//  SSFriendRow.swift
//  StorySlam
//
//  Created by Mark Keller on 7/17/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSFriendRow: UIView {
    
    static var rowIconImage: UIImage = UIImage(named: "user_o-blue")!
    static var searchRowIconImage: UIImage = UIImage(named: "globe-blue")!
    static let rowHeight: CGFloat = 40
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rowIcon : UIImageView?
    var rowName : UILabel?
    var rowUsername : UILabel?
    var rowUnderline: UIView?
    
    var friend: Friend?
    
    var isSearchRow: Bool = false
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    func initialize(friend: Friend, width: CGFloat, isSearchRow: Bool = false) {
        
        self.friend = friend
        self.isSearchRow = isSearchRow
        
        //self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("goToProfile:")))
        dispatch_async(dispatch_get_main_queue(), {
            self.setupViews()
            dispatch_async(dispatch_get_main_queue(), {
                 self.setupFrames(width)
            })
        })
       
        
        
        
    }
    
    func setupViews() {
        self.rowUnderline = UIView()
        self.rowUnderline!.backgroundColor = StorySlam.colorBlue
        self.addSubview(self.rowUnderline!)
        
        self.rowIcon = UIImageView()
        if(self.isSearchRow) {
            self.rowIcon!.image = SSFriendRow.searchRowIconImage
        } else {
            self.rowIcon!.image = SSFriendRow.rowIconImage
        }
        
        self.rowIcon!.contentMode = .ScaleAspectFit
        self.addSubview(self.rowIcon!)
        
        self.rowUsername = UILabel()
        self.rowUsername!.text = "@" + self.friend!.username!
        self.rowUsername!.textColor = StorySlam.colorBlue
        self.rowUsername!.font = UIFont(name: "OpenSans", size: 12) //change to bold
        self.addSubview(self.rowUsername!)
        
        
        self.rowName = UILabel()
        self.rowName!.text = self.friend!.firstname! + " " + self.friend!.lastname!
        self.rowName!.textColor = StorySlam.colorBlue
        self.rowName!.font = UIFont(name: "OpenSans", size: 12)
        self.addSubview(self.rowName!)
        
    }
    
    func setupFrames(width: CGFloat) {
        self.rowUnderline!.frame = CGRect(x: 0, y: SSFriendRow.rowHeight - 1, width: width, height: 1)
        self.rowIcon!.frame = CGRect(x: 10, y: 8, width: 24, height: 24)
        self.rowUsername!.frame = CGRect(x: 48, y: 2, width: width-48, height: 17)
        self.rowName!.frame = CGRect(x: 48, y: 2+17, width: width-48, height: 17)
        
    }
    
   
    
    func goToProfile(sender: AnyObject) {
        
        if(self.friend != nil) {
            print("going to profile...")
            SSFriendRow.appDelegate.mainViewController!.setHomeContentView(SSUserProfileView(user: self.friend!))
        }else{
            print("friend is nil")
        }
        
    }
    
}