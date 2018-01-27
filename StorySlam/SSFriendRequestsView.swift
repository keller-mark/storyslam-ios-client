//
//  SSFriendRequestsView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/25/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSFriendRequestsView: SSContentView {
    
    //main views

    var friendRequestRows = [SSFriendRequestRow]()
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    

    
    var totalRowLabel: UILabel?
    
    
    var currentUser: CurrentUser?
    
    //var finishedStoryRows = [SSFinishedStoryRow]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupFrames()
        
        self.loadFriendRequests()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.showRefreshButton(self, action: "tapRefresh:")
        })
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.appDelegate.mainViewController!.hideRefreshButton()
    }
    
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()
        
        self.scrollView!.backgroundColor = StorySlam.colorLightBlue
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Friend Requests"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorDarkPurple
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        self.imgBackIcon = UIImageView()
        self.imgBackIcon!.image = UIImage(named: "back_arrow-yellow")
        self.imgBackIcon!.contentMode = .ScaleAspectFit
        self.imgBackIcon!.userInteractionEnabled = true
        self.imgBackIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapBack:")))
        self.view.addSubview(self.imgBackIcon!)
        
        
        self.totalRowLabel = UILabel()
        self.totalRowLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.totalRowLabel!.text = ""
        self.totalRowLabel!.textColor = StorySlam.colorGray
        self.totalRowLabel!.textAlignment = .Center
        self.scrollView!.addSubview(self.totalRowLabel!)
        
        
        
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: calculateHeight(46), width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        
        for friendRequestRow in self.friendRequestRows {
            friendRequestRow.setupFrames(self.myWidth!-(18*2))
        }
        self.totalRowLabel!.frame = CGRect(x: 18, y: 5+(SSFriendRequestRow.rowHeight*CGFloat(self.friendRequestRows.count)), width: self.myWidth!-(18*2), height: 15)
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 20+(SSFriendRequestRow.rowHeight*CGFloat(self.friendRequestRows.count))+15+30)
        
        
        
        
    }
    
    
    override func tapRefresh(sender: AnyObject) {
        
        print("refresh tapped...")
        self.loadFriendRequests()
        appDelegate.mainViewController!.startRefreshButton()
    }
    
    func tapBack(sender: AnyObject) {
        print("back tapped...")
        appDelegate.mainViewController!.backHomeContentView()
    }
    
    
    
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            //show error message somehow
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    
    
    func loadFriendRequests() {
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
  
            
            
            
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "getFriendRequests", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
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
                                self.appDelegate.mainViewController!.stopRefreshButton()
                                for friendRequestRow in self.friendRequestRows {
                        
                                        friendRequestRow.removeFromSuperview()
                      
                                }
                                self.friendRequestRows.removeAll()

                                var x = 0
                                
                                for (index,subJson):(String, JSON) in result["data"]["friend_requests"] {
                                    //Do something you want
                                    let friend = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                    
                                    let friendRow = SSFriendRequestRow(frame: CGRect(x: 18, y: (SSFriendRequestRow.rowHeight*CGFloat(x)), width: self.myWidth!-(18*2), height: SSFriendRequestRow.rowHeight))
                                    friendRow.initialize(friend, width: self.myWidth!-(18*2))
                                    self.friendRequestRows.append(friendRow)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.scrollView!.addSubview(friendRow)
                                    })
                                    x = x + 1
                                    
                                }
                                
                                
                                if(x == 0) {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.tapBack(self)
                                        self.appDelegate.mainViewController!.refreshContent()
                                    })
                                }
                            
                            
                                
                                self.totalRowLabel!.text = String(self.friendRequestRows.count)  + " friend request" + (self.friendRequestRows.count != 1 ? "s" : "")
                                self.totalRowLabel!.frame = CGRect(x: 18, y: 5+(SSFriendRequestRow.rowHeight*CGFloat(self.friendRequestRows.count)), width: self.myWidth!-(18*2), height: 15)
                                self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 20+(SSFriendRequestRow.rowHeight*CGFloat(self.friendRequestRows.count))+15+30) //30 is just bottom padding
                                
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
            
            
            
            
        } else {
            self.appDelegate.mainViewController!.logOut()
        }
        
    }
    
    
    
        
    
    
    
    
    
    
}