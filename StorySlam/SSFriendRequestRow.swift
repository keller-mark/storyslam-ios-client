//
//  SSFriendRequestRow.swift
//  StorySlam
//
//  Created by Mark Keller on 7/25/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSFriendRequestRow: UIView {
    
    static var rowIconAccept: UIImage = UIImage(named: "check-green")!
    static var rowIconDecline: UIImage = UIImage(named: "x_bold-orange")!
    
    static var rowIconHeight: CGFloat = 24
    
    static let rowHeight: CGFloat = 40
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rowIconAcceptView : UIImageView?
    var rowIconDeclineView : UIImageView?
    var rowName : UILabel?
    var rowUsername : UILabel?
    var rowUnderline: UIView?
    
    var friend: Friend?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initialize(friend: Friend, width: CGFloat) {
        
        self.friend = friend

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
        
        self.rowIconAcceptView = UIImageView()
        self.rowIconAcceptView!.image = SSFriendRequestRow.rowIconAccept
        self.rowIconAcceptView!.contentMode = .ScaleAspectFit
        self.rowIconAcceptView!.userInteractionEnabled = true
        self.rowIconAcceptView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("acceptRequest:")))
        self.addSubview(self.rowIconAcceptView!)
        
        self.rowIconDeclineView = UIImageView()
        self.rowIconDeclineView!.image = SSFriendRequestRow.rowIconDecline
        self.rowIconDeclineView!.contentMode = .ScaleAspectFit
        self.rowIconDeclineView!.userInteractionEnabled = true
        self.rowIconDeclineView!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("declineRequest:")))
        self.addSubview(self.rowIconDeclineView!)
        
        self.rowUsername = UILabel()
        //self.rowUsername!.backgroundColor = StorySlam.colorBlue
        self.rowUsername!.text = "@" + self.friend!.username!
        self.rowUsername!.textColor = StorySlam.colorBlue
        self.rowUsername!.font = UIFont(name: "OpenSans", size: 12) //change to bold
        self.rowUsername!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("goToProfile:")))
        self.rowUsername!.userInteractionEnabled = true
        self.addSubview(self.rowUsername!)
        
        
        self.rowName = UILabel()
        //self.rowName!.backgroundColor = StorySlam.colorGold
        self.rowName!.text = self.friend!.firstname! + " " + self.friend!.lastname!
        self.rowName!.textColor = StorySlam.colorBlue
        self.rowName!.font = UIFont(name: "OpenSans", size: 12)
        self.rowName!.userInteractionEnabled = true
        self.rowName!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("goToProfile:")))
        self.addSubview(self.rowName!)
        
    }
    
    func setupFrames(width: CGFloat) {
        self.rowUnderline!.frame = CGRect(x: 0, y: SSFriendRequestRow.rowHeight - 1, width: width, height: 1)
        self.rowIconAcceptView!.frame = CGRect(x: 10, y: 8, width: 24, height: 24)
        self.rowIconDeclineView!.frame = CGRect(x: width-10-SSFriendRequestRow.rowIconHeight, y: 8, width: 24, height: 24)
        self.rowUsername!.frame = CGRect(x: 48, y: 2, width: width-48-20-24, height: 17)
        self.rowName!.frame = CGRect(x: 48, y: 2+17, width: width-48-20-24, height: 17)
        
    }
    
    
    
    func goToProfile(sender: AnyObject) {
        
        if(self.friend != nil) {
            print("going to profile...")
            SSFriendRow.appDelegate.mainViewController!.setHomeContentView(SSUserProfileView(user: self.friend!))
        }else{
            print("friend is nil")
        }
        
    }
    
    func acceptRequest(sender: AnyObject) {
        self.replyToRequest(true)
    }
    
    func declineRequest(sender: AnyObject) {
        self.replyToRequest(false)
    }
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            SSFriendRequestRow.appDelegate.mainViewController!.stopRefreshButton()
            
            //show error message somehow
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            SSFriendRequestRow.appDelegate.mainViewController!.contentView!.presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    
    func replyToRequest(accept: Bool) {
        self.rowIconAcceptView!.userInteractionEnabled = false
        self.rowIconDeclineView!.userInteractionEnabled = false
        dispatch_async(dispatch_get_main_queue(), {
            SSFriendRequestRow.appDelegate.mainViewController!.startRefreshButton()
        })
        
        let currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "replyToFriendRequest", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.friend!.id), "accept": (accept ? "1" : "0")])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.loadError("Could not connect to network.")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                //show error message somehow
                                SSFriendRequestRow.appDelegate.mainViewController!.stopRefreshButton()
                                let superview = SSFriendRequestRow.appDelegate.mainViewController!.contentView! as! SSFriendRequestsView
                                superview.loadFriendRequests()
                                
                            })
                            
                        } else {
                            self.loadError(result["message"].stringValue)
                        }
                    } else {
                        self.loadError("An error occurred.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.loadError("An error occurred.")
            }
        }

    }
    
    
}