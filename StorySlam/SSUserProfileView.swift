//
//  SSUserProfileView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/24/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSUserProfileView: SSContentView {
    
    //main views
    var user: Friend?
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    static var userIcon: UIImage = UIImage(named: "user_o-blue")!
    var imgUserIcon: UIImageView?
    let userIconHeight: CGFloat = 56
    
    var lblName: UILabel?
    var lblFinishedStories: UILabel?
    var lblLoadingError: UILabel?
    
    var btnSendFriendRequest: UIButton?
    
    var btnFriendRequestApprove: UIButton?
    var btnFriendRequestDecline: UIButton?
    
    var btnNewStory: UIButton?
    var btnUnfriend: UIButton?
    
    var btnBlock: UIButton?
    var btnReportLine: UIView?
    var btnReport: UIButton?
    var hasBeenBlocked: Bool = false
    
    var totalRowLabel: UILabel?
    
    var friend_state: StorySlam.FriendState?
    
    var currentUser: CurrentUser?
    var twoButtons: Bool = false
    
    var finished_stories_rows = [SSFinishedStoryRow]()
    
    init(user: Friend) {
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
        print(user.id)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupFrames()
        
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
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
        self.lblTitle!.text = "@\(self.user!.username)"
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
        
        
        self.imgUserIcon = UIImageView()
        self.imgUserIcon!.image = SSUserProfileView.userIcon
        self.imgUserIcon!.contentMode = .ScaleAspectFit
        self.scrollView!.addSubview(self.imgUserIcon!)
        
        self.lblName = UILabel()
        self.lblName!.text = self.user!.getFullname()
        self.lblName!.font = UIFont(name: "OpenSans", size: 18)
        self.lblName!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblName!)
        
        self.btnSendFriendRequest = UIButton()
        self.btnSendFriendRequest!.layer.cornerRadius = 20
        self.btnSendFriendRequest!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSendFriendRequest!.setTitle("Send Friend Request", forState: .Normal)
        self.btnSendFriendRequest!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnSendFriendRequest!.backgroundColor = StorySlam.colorBlue
        self.btnSendFriendRequest!.addTarget(self, action: Selector("sendFriendRequest:"), forControlEvents: .TouchUpInside)
        
        self.btnFriendRequestApprove = UIButton()
        self.btnFriendRequestApprove!.layer.cornerRadius = 20
        self.btnFriendRequestApprove!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnFriendRequestApprove!.setTitle("Approve Friend Request", forState: .Normal)
        self.btnFriendRequestApprove!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnFriendRequestApprove!.backgroundColor = StorySlam.colorGreen
        self.btnFriendRequestApprove!.addTarget(self, action: Selector("acceptRequest:"), forControlEvents: .TouchUpInside)
        
        self.btnFriendRequestDecline = UIButton()
        self.btnFriendRequestDecline!.layer.cornerRadius = 20
        self.btnFriendRequestDecline!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnFriendRequestDecline!.setTitle("Decline Friend Request", forState: .Normal)
        self.btnFriendRequestDecline!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnFriendRequestDecline!.backgroundColor = StorySlam.colorOrange
        self.btnFriendRequestDecline!.addTarget(self, action: Selector("declineRequest:"), forControlEvents: .TouchUpInside)
        
        self.btnNewStory = UIButton()
        self.btnNewStory!.layer.cornerRadius = 20
        self.btnNewStory!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnNewStory!.setTitle("New Story with \(self.user!.firstname)", forState: .Normal)
        self.btnNewStory!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnNewStory!.backgroundColor = StorySlam.colorGreen
        self.btnNewStory!.addTarget(self, action: Selector("newStory:"), forControlEvents: .TouchUpInside)
        
        self.btnUnfriend = UIButton()
        self.btnUnfriend!.layer.cornerRadius = 20
        self.btnUnfriend!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnUnfriend!.setTitle("Unfriend", forState: .Normal)
        self.btnUnfriend!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnUnfriend!.backgroundColor = StorySlam.colorOrange
        self.btnUnfriend!.addTarget(self, action: Selector("unfriend:"), forControlEvents: .TouchUpInside)
        
        self.btnBlock = UIButton()
        self.btnBlock!.titleLabel!.font = UIFont(name: "OpenSans", size: 14)
        self.btnBlock!.setTitleColor(StorySlam.colorOrange, forState: .Normal)
        self.btnBlock!.addTarget(self, action: Selector("blockUser:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnBlock!)
        
        self.btnReportLine = UIView()
        self.btnReportLine!.backgroundColor = StorySlam.colorLightOrange
        self.btnReportLine!.layer.cornerRadius = 1
        
        self.btnReport = UIButton()
        self.btnReport!.titleLabel!.font = UIFont(name: "OpenSans", size: 14)
        self.btnReport!.setTitleColor(StorySlam.colorOrange, forState: .Normal)
        self.btnReport!.addTarget(self, action: Selector("reportUser:"), forControlEvents: .TouchUpInside)
        
        self.lblFinishedStories = UILabel()
        self.lblFinishedStories!.text = "Finished Stories"
        self.lblFinishedStories!.font = UIFont(name: "OpenSans", size: 18)
        self.lblFinishedStories!.backgroundColor = StorySlam.colorClear
        self.lblFinishedStories!.textAlignment = .Left
        self.lblFinishedStories!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblFinishedStories!)
        
        self.lblLoadingError = UILabel()
        self.lblLoadingError!.text = "Loading..."
        self.lblLoadingError!.textAlignment = .Center
        self.lblLoadingError!.textColor = StorySlam.colorGray
        self.lblLoadingError!.font = UIFont(name: "OpenSans", size: 18)
        
        
        
        self.totalRowLabel = UILabel()
        self.totalRowLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.totalRowLabel!.text = ""
        self.totalRowLabel!.textColor = StorySlam.colorGray
        self.totalRowLabel!.textAlignment = .Center
        self.scrollView!.addSubview(self.totalRowLabel!)

    
        
        
        
    }
    override func setupFrames() {
        dispatch_async(dispatch_get_main_queue(), {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: self.calculateHeight(46), width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        
        self.imgUserIcon!.frame = CGRect(x: 30, y: 30, width: self.userIconHeight, height: self.userIconHeight)
        self.lblName!.frame = CGRect(x: 30+self.userIconHeight+18, y: 63, width: self.myWidth!-30-self.userIconHeight-18-5, height: 24)
        
        self.btnSendFriendRequest!.frame = CGRect(x: 15, y: 30+self.userIconHeight+20, width: self.myWidth!-30, height: 40)
        self.btnNewStory!.frame = CGRect(x: 15, y: 30+self.userIconHeight+20, width: self.myWidth!-30, height: 40)
        self.btnFriendRequestApprove!.frame = CGRect(x: 15, y: 30+self.userIconHeight+20, width: self.myWidth!-30, height: 40)
        self.btnFriendRequestDecline!.frame = CGRect(x: 15, y: 30+self.userIconHeight+20+40+10, width: self.myWidth!-30, height: 40)
        
        var twoButtonHeight: CGFloat = 0
        if(self.twoButtons) {
            twoButtonHeight = 10+40
        }
        
        self.lblLoadingError!.frame = CGRect(x: 15, y: 30+self.userIconHeight+20, width: self.myWidth!-30, height: 40)
        
        var finished_stories_height: CGFloat = 30+self.userIconHeight+20+40+20+twoButtonHeight
        
        if(self.finished_stories_rows.count > 0) {
            
             self.lblFinishedStories!.frame = CGRect(x: 15, y: finished_stories_height, width: self.myWidth!-30, height: 24)
            
            finished_stories_height += 24+10
            
            for finished_story_row in self.finished_stories_rows {
                
                if(finished_story_row.finishedSetupFrames == true) {
                    finished_story_row.frame = CGRect(x: 15, y:  finished_stories_height, width: self.myWidth!-30, height: finished_story_row.rowHeight)
                    
                    finished_stories_height += finished_story_row.rowHeight+10
                } else {
                    finished_story_row.setupFrames(self.myWidth!-30)
                    self.setupFrames()
                    
                }
                
            }
            
            
        }
        

        
        
        self.btnUnfriend!.frame = CGRect(x: 15, y: finished_stories_height+20, width: self.myWidth!-30, height: 40)
            
        self.btnBlock!.frame = CGRect(x: 15, y: finished_stories_height+20+40+20, width: self.myWidth!-30, height: 20)
        if(self.hasBeenBlocked) {
            
            self.btnReport!.frame = CGRect(x: 15, y: finished_stories_height+20+40+20-40-20, width: self.myWidth!-30, height: 20)
            
            self.btnReportLine!.frame = CGRect(x: self.myWidth!/2-30, y: finished_stories_height+20+40+20-21, width: 60, height: 2)
        

        }
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, finished_stories_height+20+40+10+20+20+20)
        
        
        
        })
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
            self.lblLoadingError!.text = theTitle
        })
        
    }
    
    
    func loadProfile() {
        dispatch_async(dispatch_get_main_queue(), {
            self.disableScrollview()
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
            self.btnSendFriendRequest!.removeFromSuperview()
            self.btnFriendRequestApprove!.removeFromSuperview()
            self.btnFriendRequestDecline!.removeFromSuperview()
            self.btnNewStory!.removeFromSuperview()
            self.btnUnfriend!.removeFromSuperview()
            
            self.lblLoadingError!.text = "Loading..."
            self.scrollView!.addSubview(self.lblLoadingError!)
            
            
            
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil && self.user != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "getUserProfile", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.user!.id)])
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
                                self.user!.username = new_username
                            }
                            if let new_firstname = result["data"]["firstname"].string {
                                self.user!.firstname = new_firstname
                            }
                            if let new_lastname = result["data"]["lastname"].string {
                                self.user!.lastname = new_lastname
                            }
                    
                            if let friend_state_int = result["data"]["friend_state"].int {
                                self.friend_state = StorySlam.FriendState(rawValue: friend_state_int)
                             
                            }
                            
                            
                         
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.lblTitle!.text = "@\(self.user!.username)"
                                self.lblName!.text = self.user!.getFullname()
                                
                                
                                //self.lblLoadingError!.removeFromSuperview()
                                
                                if(self.friend_state != nil) {
                                    if(self.friend_state! == StorySlam.FriendState.NotFriends) {
                                        self.scrollView!.addSubview(self.btnSendFriendRequest!)
                                        self.twoButtons = false
                                        self.lblLoadingError!.removeFromSuperview()
                                    }else if(self.friend_state! == StorySlam.FriendState.RequestSent) {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.lblLoadingError!.text = "Friend Request Sent"
                                        })
                                        self.twoButtons = false
                                    }else if(self.friend_state! == StorySlam.FriendState.RequestReceived) {
                                        self.scrollView!.addSubview(self.btnFriendRequestApprove!)
                                        self.scrollView!.addSubview(self.btnFriendRequestDecline!)
                                        self.twoButtons = true
                                        self.lblLoadingError!.removeFromSuperview()
                                    }else if(self.friend_state! == StorySlam.FriendState.Friends) {
                                        self.scrollView!.addSubview(self.btnNewStory!)
                                        self.scrollView!.addSubview(self.btnUnfriend!)
                                        self.twoButtons = false
                                        self.lblLoadingError!.removeFromSuperview()
                                    }
                                    
                                    self.hasBeenBlocked = result["data"]["has_been_blocked"].boolValue
                                    
                                    if(self.hasBeenBlocked) {
                                        self.btnSendFriendRequest!.removeFromSuperview()
                                        self.btnBlock!.setTitle("Unblock this user", forState: .Normal)
                                        
                                        //add report button
                                        if(result["data"]["has_been_reported"].boolValue) {
                                            self.btnReport!.setTitle("Reported as offensive", forState: .Normal)
                                            self.btnReport!.enabled = false
                                        } else {
                                            self.btnReport!.setTitle("Report as offensive", forState: .Normal)
                                            self.btnReport!.enabled = true
                                        }
                                        
                                        self.scrollView!.addSubview(self.btnReportLine!)
                                        self.scrollView!.addSubview(self.btnReport!)
                                        
                                        
                                        
                                    } else {
                                        self.btnBlock!.setTitle("Block this user", forState: .Normal)
                                        //remove report button
                                        self.btnReportLine!.removeFromSuperview()
                                        self.btnReport!.removeFromSuperview()
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    for old_finished_story_row in self.finished_stories_rows {
                                        
                                        old_finished_story_row.removeFromSuperview()
                                    }
                                    self.finished_stories_rows.removeAll()
                                    
                                    var numFinishedStories = 0
                                    
                                    
                                    for (index,subJson):(String, JSON) in result["data"]["finished_stories"] {
                                        numFinishedStories += 1
                                        
                                        var authors = [Friend]()
                                        
                                        for (authorIndex, authorJson):(String, JSON) in subJson["authors"] {
                                            let author = Friend(id: authorJson["id"].intValue, username: authorJson["username"].stringValue, firstname: authorJson["firstname"].stringValue, lastname: authorJson["lastname"].stringValue)
                                            authors.append(author)
                                        }
                                        
                                        let finished_story = FinishedStory(id: subJson["id"].intValue, title: subJson["title"].stringValue, genre: subJson["genre"].stringValue, authors: authors, content: subJson["content"].stringValue, created_at: subJson["created_at"].stringValue, finished_at: subJson["finished_at"].stringValue, link: subJson["link"].stringValue, num_likes: subJson["num_likes"].intValue, random: subJson["random"].boolValue, length: subJson["length"].intValue, liked_by_me: subJson["liked_by_me"].boolValue)
                                        
                                        let finished_story_row = SSFinishedStoryRow()
                                        finished_story_row.initialize(finished_story, width: self.myWidth!-30, parent: self, current_profile_id: self.user!.id)
                                        
                                        self.finished_stories_rows.append(finished_story_row)
                                        self.scrollView!.addSubview(finished_story_row)
                                        self.setupFrames()
                                        
                                        
                                    }
                                    
                                    if(numFinishedStories == 0) {
                                        self.lblFinishedStories!.removeFromSuperview()
                                    } else {
                                        self.scrollView!.addSubview(self.lblFinishedStories!)
                                    }
                                    
                                    
                                    
                                    self.setupFrames()

                                }
                                
                                
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
    
    
    
    func sendFriendRequest(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.startRefreshButton()
            self.btnSendFriendRequest!.removeFromSuperview()
            self.lblLoadingError!.text = "Sending Friend Request..."
            self.scrollView!.addSubview(self.lblLoadingError!)
        })
        
        do {
            let opt = try HTTP.POST(StorySlam.actionURL + "friendRequest", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.user!.id)])
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
                            
                           self.lblLoadingError!.text = "Friend Request Sent"
                            
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
        
    }
    
    
    
    func acceptRequest(sender: AnyObject) {
        self.replyToRequest(true)
    }
    
    func declineRequest(sender: AnyObject) {
        self.replyToRequest(false)
    }
    
    func newStory(sender: AnyObject) {
        let newStep2 = SSNewStoryViewStep2Friends()
        newStep2.setFriendChoice(self.user!, choice_index: 0)
        appDelegate.mainViewController!.setHomeContentView(newStep2)
    }
    
    
    func replyToRequest(accept: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.disableScrollview()
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
            self.btnFriendRequestApprove!.removeFromSuperview()
            self.btnFriendRequestDecline!.removeFromSuperview()
            
            self.lblLoadingError!.text = "Loading..."
            self.scrollView!.addSubview(self.lblLoadingError!)
            
            
            
        })
        let currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "replyToFriendRequest", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.user!.id), "accept": (accept ? "1" : "0")])
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
                                self.appDelegate.mainViewController!.stopRefreshButton()
                                self.loadProfile()
                                
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
  
    
    override func viewWillLayoutSubviews() {
        for finished_story_row in self.finished_stories_rows {
            finished_story_row.finishedSetupFrames = false
        }
        super.viewWillLayoutSubviews()
    }
    
    func unfriend(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.startRefreshButton()
            
            self.btnUnfriend!.enabled = false
            self.btnUnfriend!.setTitle("Loading...", forState: .Normal)

        })
        
        do {
            let opt = try HTTP.POST(StorySlam.actionURL + "unfriend", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.user!.id)])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.btnUnfriend!.enabled = true
                    self.btnUnfriend!.setTitle("Unfriend", forState: .Normal)
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.btnUnfriend!.enabled = true
                            self.btnUnfriend!.setTitle("Unfriend", forState: .Normal)
                            
                            self.loadProfile()
                            
                            //show error message somehow
                            
                        })
                        
                    } else {
                        self.btnUnfriend!.enabled = true
                        self.btnUnfriend!.setTitle("Unfriend", forState: .Normal)
                    }
                } else {
                    self.btnUnfriend!.enabled = true
                    self.btnUnfriend!.setTitle("Unfriend", forState: .Normal)
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.btnUnfriend!.enabled = true
            self.btnUnfriend!.setTitle("Unfriend", forState: .Normal)
        }
        
        

    }
    
    func blockUser(sender: AnyObject) {
        if(self.hasBeenBlocked) {
            self.blockUserRequest()
        } else {
            self.blockUserConfirm()
        }
    }
    
    func blockUserConfirm() {
      
        let refreshAlert = UIAlertController(title: "Are you sure you want to block \(self.user!.firstname)?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.blockUserRequest()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Cancel delete")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)

        
    }
    
    func blockUserRequest() {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.startRefreshButton()
            
            self.btnUnfriend!.enabled = false
            self.btnBlock!.enabled = false
            self.btnBlock!.setTitle("Loading...", forState: .Normal)
        })
        
        do {
            let opt = try HTTP.POST(StorySlam.actionURL + "blockUserToggle", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.user!.id)])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterBlockUser()
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.hasBeenBlocked = !self.hasBeenBlocked
                            self.afterBlockUser()
                            self.loadProfile()
                            
                            //show error message somehow
                            
                        })
                        
                    } else {
                        self.afterBlockUser()
                    }
                } else {
                    self.afterBlockUser()
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.afterBlockUser()
        }
        
    }
    
    func afterBlockUser() {
        dispatch_async(dispatch_get_main_queue(), {
            self.btnBlock!.enabled = true
            self.btnUnfriend!.enabled = true
            
            if(self.hasBeenBlocked) {
                self.btnBlock!.setTitle("Unblock this user", forState: .Normal)
            } else {
                self.btnBlock!.setTitle("Block this user", forState: .Normal)
            }
        })
        
    }
    
    func reportUser(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.startRefreshButton()
            
            self.btnBlock!.enabled = false
            self.btnReport!.enabled = false
            self.btnReport!.setTitle("Loading...", forState: .Normal)
        })
        
        do {
            let opt = try HTTP.POST(StorySlam.actionURL + "reportUser", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_id": String(self.user!.id)])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterReportUser()
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.afterReportUser()
                            self.btnReport!.setTitle("Reported", forState: .Normal)
                            self.btnReport!.enabled = false
                            self.loadProfile()
                            
                            //show error message somehow
                            
                        })
                        
                    } else {
                        self.afterReportUser()
                    }
                } else {
                    self.afterReportUser()
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.afterReportUser()
        }

    }

    func afterReportUser() {
        dispatch_async(dispatch_get_main_queue(), {
            self.btnBlock!.enabled = true
            self.btnReport!.enabled = true
            self.btnReport!.setTitle("Report as offensive", forState: .Normal)
        })
        
    }
    
    
    
}