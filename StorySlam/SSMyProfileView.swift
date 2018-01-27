//
//  SSMyProfileView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSMyProfileView: SSContentView {
    
    //main views
    
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    var imgEditIcon: UIImageView?
    
    static var userIcon: UIImage = UIImage(named: "user_o-blue")!
    var imgUserIcon: UIImageView?
    let userIconHeight: CGFloat = 56
    
    var lblName: UILabel?
    var lblUsername: UILabel?
    
    var btnOpenStories: UIButton?
    var btnFinishedStories: UIButton?
    var btnFriends: UIButton?
    
    var profileEditViewFrame: CGRect?
   
    
    var totalRowLabel: UILabel?
    
    var editMode: Bool = false
    
    var currentUser: CurrentUser?
 
    
    //var finishedStoryRows = [SSFinishedStoryRow]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = StorySlam.getCurrentUser()
        
        self.setupViews()
        self.setupFrames()
        
        
        
        self.loadProfile()
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
        self.lblTitle!.text = "My Profile"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorBlue
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        self.imgBackIcon = UIImageView()
        self.imgBackIcon!.image = UIImage(named: "back_arrow-yellow")
        self.imgBackIcon!.contentMode = .ScaleAspectFit
        self.imgBackIcon!.userInteractionEnabled = true
        self.imgBackIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapBack:")))
        self.view.addSubview(self.imgBackIcon!)
        
        self.imgEditIcon = UIImageView()
        self.imgEditIcon!.image = UIImage(named: "pencil-yellow")
        self.imgEditIcon!.contentMode = .ScaleAspectFit
        self.imgEditIcon!.userInteractionEnabled = true
        self.imgEditIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapEdit:")))
        self.view.addSubview(self.imgEditIcon!)
        
        
        self.imgUserIcon = UIImageView()
        self.imgUserIcon!.image = SSUserProfileView.userIcon
        self.imgUserIcon!.contentMode = .ScaleAspectFit
        self.scrollView!.addSubview(self.imgUserIcon!)
        
        self.lblUsername = UILabel()
        self.lblUsername!.text = "@\(self.currentUser!.username!)"
        self.lblUsername!.font = UIFont(name: "OpenSans", size: 18)
        self.lblUsername!.textColor = StorySlam.colorBlue
        self.lblUsername!.textAlignment = .Center
        self.scrollView!.addSubview(self.lblUsername!)
        
        self.lblName = UILabel()
        self.lblName!.text = self.currentUser!.getFullname()
        self.lblName!.font = UIFont(name: "OpenSans", size: 18)
        self.lblName!.textColor = StorySlam.colorBlue
        self.lblName!.textAlignment = .Center
        self.scrollView!.addSubview(self.lblName!)
        
        
        self.btnOpenStories = UIButton()
        self.btnOpenStories!.layer.cornerRadius = 20
        self.btnOpenStories!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnOpenStories!.setTitle("My Open Stories", forState: .Normal)
        self.btnOpenStories!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnOpenStories!.backgroundColor = StorySlam.colorDarkPurple
        self.btnOpenStories!.addTarget(self, action: Selector("goToOpenStories:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnOpenStories!)
        
        self.btnFinishedStories = UIButton()
        self.btnFinishedStories!.layer.cornerRadius = 20
        self.btnFinishedStories!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnFinishedStories!.setTitle("My Finished Stories", forState: .Normal)
        self.btnFinishedStories!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnFinishedStories!.backgroundColor = StorySlam.colorDarkPurple
        self.btnFinishedStories!.addTarget(self, action: Selector("goToFinishedStories:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnFinishedStories!)
        
        self.btnFriends = UIButton()
        self.btnFriends!.layer.cornerRadius = 20
        self.btnFriends!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnFriends!.setTitle("My Friends", forState: .Normal)
        self.btnFriends!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnFriends!.backgroundColor = StorySlam.colorDarkPurple
        self.btnFriends!.addTarget(self, action: Selector("goToFriends:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnFriends!)
        
        
        
        
        
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
        self.imgEditIcon!.frame = CGRect(x: self.myWidth!-46, y: 0, width: 24, height: 46)
        
        self.imgUserIcon!.frame = CGRect(x: 15, y: 30, width: self.myWidth!-30, height: self.userIconHeight)
        
        self.lblName!.frame = CGRect(x: 15, y: 15+self.userIconHeight+20+6, width: self.myWidth!-30, height: 24)
        
        self.lblUsername!.frame = CGRect(x: 15, y: 30+self.userIconHeight+24+20, width: self.myWidth!-30, height: 24)
        
        self.btnOpenStories!.frame = CGRect(x: 18, y: 30+self.userIconHeight+24+20+24+20, width: self.myWidth!-(18*2), height: 40)
        
        self.btnFinishedStories!.frame = CGRect(x: 18, y: 30+self.userIconHeight+24+20+24+40+10+20, width: self.myWidth!-(18*2), height: 40)
        
        self.btnFriends!.frame = CGRect(x: 18, y: 30+self.userIconHeight+24+20+24+40+10+40+10+20, width: self.myWidth!-(18*2), height: 40)

        
        
        
        self.profileEditViewFrame = CGRect(x: 0, y: 0, width: self.myWidth!, height: self.myHeight!)
        
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 30+self.userIconHeight+24+20+24+40+10+40+10+40+20+20)
        
        
        
        
    }
    
    func goToOpenStories(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSHomeView())
    }
    
    func goToFinishedStories(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSMyFinishedStories())
    }
    func goToFriends(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSFriendsView())
    }
    
    override func tapRefresh(sender: AnyObject) {
        
        print("refresh tapped...")
        self.loadProfile()
        appDelegate.mainViewController!.startRefreshButton()
    }
    
    func tapBack(sender: AnyObject) {
        print("back tapped...")
        appDelegate.mainViewController!.backHomeContentView()
    }
    
    func tapEdit(sender: AnyObject) {
        let profileView = SSMyProfileEditView()
        profileView.view.frame = self.profileEditViewFrame!
        profileView.setupFrames()
        self.addChildViewController(profileView)
        self.view.addSubview(profileView.view)
    }
    
    
    func enableScrollview() {
        self.scrollView!.userInteractionEnabled = true
    }
    
    func disableScrollview() {
        self.scrollView!.userInteractionEnabled = false
    }
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.enableScrollview()
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            //show error message somehow
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
    }
    
    
    func loadProfile() {
        dispatch_async(dispatch_get_main_queue(), {
            self.disableScrollview()
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
            
            
            
        })
        
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "getUserProfile", parameters: ["username":self.currentUser!.username!, "token": self.currentUser!.token!, "user_id": String(self.currentUser!.user_id!)])
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
                            
                            //update profile info
                            if let new_username = result["data"]["username"].string {
                                self.currentUser!.username = new_username
                            }
                            if let new_firstname = result["data"]["firstname"].string {
                                self.currentUser!.firstname = new_firstname
                            }
                            if let new_lastname = result["data"]["lastname"].string {
                                self.currentUser!.lastname = new_lastname
                            }
                            
        
                            
                            var x = 0
                            
                            for (index,subJson):(String, JSON) in result["data"]["finished_stories"] {
                                //Do something you want
                                /*let friend = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                
                                let friendRow = SSFriendRow(frame: CGRect(x: 0, y: (SSFriendRow.rowHeight*CGFloat(x)), width: self.modalAddWidth-(18*2), height: SSFriendRow.rowHeight))
                                friendRow.initialize(friend, width: self.modalAddWidth, isSearchRow: true)
                                self.searchRows.append(friendRow)
                                dispatch_async(dispatch_get_main_queue(), {
                                self.modalScrollView!.addSubview(friendRow)
                                })
                                x = x + 1*/
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.lblUsername!.text = "@\(self.currentUser!.username!)"
                                self.lblName!.text = self.currentUser!.getFullname()
                                
                                //self.lblLoadingError!.removeFromSuperview()
                                
                               
                                
                                
                                self.enableScrollview()
                                self.appDelegate.mainViewController!.stopRefreshButton()
                                
                                //show error message somehow
                                
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