//
//  SSHomeView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSHomeView: SSContentView {
    
    var currentUser: CurrentUser?
    
    var btnNewStory: UIButton? = nil
    
    var lblOpenInvitations: UILabel? = nil
    var lblOpenInvitationsNone: UILabel? = nil
    
    var lblPendingStories: UILabel? = nil
    
    var lblOpenStories: UILabel? = nil
    var lblOpenStoriesNone: UILabel? = nil
    
    var invitation_rows = [SSInvitationRow]()
    
    var pending_stories_rows = [SSPendingStoryRow]()
    
    var open_stories_rows = [SSOpenStoryRow]()

    var requests = 0
    var finished_requests = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.tapRefresh(self)
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
        super.setupViews()
        
        
        self.scrollView!.backgroundColor = StorySlam.colorYellow

        self.btnNewStory = UIButton()
        self.btnNewStory!.layer.cornerRadius = 20
        self.btnNewStory!.backgroundColor = StorySlam.colorGreen
        self.btnNewStory!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnNewStory!.setTitle("New Story", forState: .Normal)
        self.btnNewStory!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnNewStory!.addTarget(self, action: Selector("goToNewStory:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnNewStory!)
        
        
        
        self.lblOpenInvitations = UILabel()
        self.lblOpenInvitations!.text = "Invitations"
        self.lblOpenInvitations!.textAlignment = .Left
        self.lblOpenInvitations!.font = UIFont(name: "OpenSans", size: 18)
        self.lblOpenInvitations!.textColor = StorySlam.colorDarkPurple
        self.scrollView!.addSubview(self.lblOpenInvitations!)
        
        self.lblOpenInvitationsNone = UILabel()
        self.lblOpenInvitationsNone!.numberOfLines = 0
        self.lblOpenInvitationsNone!.text = "You have no new story invitations at this time."
        self.lblOpenInvitationsNone!.textAlignment = .Center
        self.lblOpenInvitationsNone!.font = UIFont(name: "OpenSans", size: 12)
        self.lblOpenInvitationsNone!.textColor = StorySlam.colorGray
        self.scrollView!.addSubview(self.lblOpenInvitationsNone!)
        
        
        
        self.lblPendingStories = UILabel()
        self.lblPendingStories!.text = "Pending Stories"
        self.lblPendingStories!.textAlignment = .Left
        self.lblPendingStories!.font = UIFont(name: "OpenSans", size: 18)
        self.lblPendingStories!.textColor = StorySlam.colorDarkPurple
        self.scrollView!.addSubview(self.lblPendingStories!)
     
        
        
        
        self.lblOpenStories = UILabel()
        self.lblOpenStories!.text = "Open Stories"
        self.lblOpenStories!.textAlignment = .Left
        self.lblOpenStories!.font = UIFont(name: "OpenSans", size: 18)
        self.lblOpenStories!.textColor = StorySlam.colorDarkPurple
        self.scrollView!.addSubview(self.lblOpenStories!)
        
        self.lblOpenStoriesNone = UILabel()
        self.lblOpenStoriesNone!.numberOfLines = 0
        self.lblOpenStoriesNone!.text = "You have no open stories at this time.\n\nBegin a new story to get started."
        self.lblOpenStoriesNone!.textAlignment = .Center
        self.lblOpenStoriesNone!.font = UIFont(name: "OpenSans", size: 12)
        self.lblOpenStoriesNone!.textColor = StorySlam.colorGray
        self.scrollView!.addSubview(self.lblOpenStoriesNone!)
        
        self.setupFrames()
    }
    override func setupFrames() {
        dispatch_async(dispatch_get_main_queue(), {
        
        super.setupFrames()
        
        self.btnNewStory!.frame = CGRect(x: 15, y: self.calculateHeight(40, marginTop: 10), width: self.myWidth!-30, height: 40)
        self.lblOpenInvitations!.frame = CGRect(x: 15, y: self.calculateHeight(40, marginTop: 20), width: self.myWidth!-30, height: 40)
        
        let lblTextSize1 = self.lblOpenInvitationsNone!.sizeThatFits(CGSizeMake(self.myWidth!-30, CGFloat.max))
       
        if(self.invitation_rows.count == 0) {
            self.lblOpenInvitationsNone!.frame = CGRect(x: 15, y: self.calculateHeight(lblTextSize1.height, marginTop: 20, marginBottom: 20), width: self.myWidth!-30, height: lblTextSize1.height)
        } else {
            
            for invitation_row in self.invitation_rows {
                
                if(invitation_row.finishedSetupFrames == true) {
                    invitation_row.frame = CGRect(x: 15, y:  self.calculateHeight(invitation_row.rowHeight, marginTop: 10), width: self.myWidth!-30, height: invitation_row.rowHeight)
                } else {
                    invitation_row.setupFrames(self.myWidth!-30)
                    self.setupFrames()
                    
                }
                
            }
            
            
        }
        if(self.pending_stories_rows.count > 0) {
        
            self.lblPendingStories!.frame = CGRect(x: 15, y: self.calculateHeight(40, marginTop: 30), width: self.myWidth!-30, height: 40)
            
            for pending_story_row in self.pending_stories_rows {
                
                if(pending_story_row.finishedSetupFrames == true) {
                    pending_story_row.frame = CGRect(x: 15, y:  self.calculateHeight(pending_story_row.rowHeight, marginTop: 10), width: self.myWidth!-30, height: pending_story_row.rowHeight)
                } else {
                    pending_story_row.setupFrames(self.myWidth!-30)
                    self.setupFrames()
                    
                }
                
            }
            
            
        } else {
            self.lblPendingStories!.removeFromSuperview()
        }
            
        self.lblOpenStories!.frame = CGRect(x: 15, y: self.calculateHeight(40, marginTop: 30), width: self.myWidth!-30, height: 40)
            
        if(self.open_stories_rows.count > 0) {
            
            self.lblOpenStoriesNone!.removeFromSuperview()
            
            for open_story_row in self.open_stories_rows {
                
                if(open_story_row.finishedSetupFrames == true) {
                    open_story_row.frame = CGRect(x: 15, y:  self.calculateHeight(open_story_row.rowHeight, marginTop: 10), width: self.myWidth!-30, height: open_story_row.rowHeight)
                } else {
                    open_story_row.setupFrames(self.myWidth!-30)
                    self.setupFrames()
                    
                }
                
            }
            
            
        } else {
            let lblTextSize2 = self.lblOpenStoriesNone!.sizeThatFits(CGSizeMake(self.myWidth!-30, CGFloat.max))
            self.lblOpenStoriesNone!.frame = CGRect(x: 15, y: self.calculateHeight(lblTextSize2.height, marginTop: 20, marginBottom: 20), width: self.myWidth!-30, height: lblTextSize2.height)
        }
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false) + 30)
        
        })
        
    }
    
    
    
    func goToNewStory(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSNewStoryViewStep1())
    }
    override func tapRefresh(sender: AnyObject) {
        
        print("refresh tapped...")
        dispatch_async(dispatch_get_main_queue(), {
        self.appDelegate.mainViewController!.startRefreshButton()
        
        self.loadInvitations()
        self.loadOpenStories()
        self.loadPendingStories()
            
        })
        
    }
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func afterRequest() {
        self.finished_requests += 1
        if(self.requests <= self.finished_requests) {
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.stopRefreshButton()
                self.setupFrames()
            })
        }
    }
    
    func acceptInvitation(invitation: Invitation) {
        print("accept invitation on home view...")
        self.replyToInvitation(self, invitation: invitation, accepted: true)
    }
    
    func declineInvitation(invitation: Invitation) {
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to decline this invitation?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                self.declineInvitationConfirmed(invitation)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
    
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
    }
    
    func declineInvitationConfirmed(invitation: Invitation) {
        print("decline of invitation confirmed.")
        
        self.replyToInvitation(self, invitation: invitation, accepted: false)
    }
    
    func loadInvitations() {
        
        self.requests += 1
        
        self.currentUser = StorySlam.getCurrentUser()
        
        do {
            
            let opt = try HTTP.POST(StorySlam.actionURL + "getInvitations", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterRequest()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        dispatch_async(dispatch_get_main_queue(), {
                        self.afterRequest()
                        
                            for old_invitation_row in self.invitation_rows {
                                old_invitation_row.removeFromSuperview()
                            }
                            self.invitation_rows.removeAll()
                            
                            var numInvitations = 0
                            for (indexOuter,subJsonOuter):(String, JSON) in result["data"]["invitations"] {
                            
                            
                            numInvitations += 1
                            
                            
                            
                            let initiator = Friend.init(id: subJsonOuter["initiator"]["id"].intValue, username: subJsonOuter["initiator"]["username"].stringValue, firstname: subJsonOuter["initiator"]["firstname"].stringValue, lastname: subJsonOuter["initiator"]["lastname"].stringValue)
                            
                            var all_players = [Friend]()
                            
                            all_players.append(Friend(id: self.currentUser!.user_id!, username: self.currentUser!.username!, firstname: self.currentUser!.firstname!, lastname: self.currentUser!.lastname!))
                            
                            all_players.append(initiator)
                            
                            
                            
                            for (index,subJson):(String, JSON) in subJsonOuter["others_invited"] {
                                //Do something you want
                                
                                let other_player = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                
                                all_players.append(other_player)
                                
                            }
                            
                            let invitation = Invitation.init(id: subJsonOuter["id"].intValue, story_id: subJsonOuter["story_id"].intValue, story_title: subJsonOuter["story_title"].stringValue, story_genre: subJsonOuter["story_genre"].stringValue, initiator: initiator, expiration_string: subJsonOuter["expiration_string"].stringValue, all_players: all_players)
                            
                            let invitation_row = SSInvitationRow()
                            
                           
                            invitation_row.initialize(invitation, width: self.myWidth! - 30, parent: self)
                            self.invitation_rows.append(invitation_row)
                            
                            self.scrollView!.addSubview(invitation_row)
                            self.setupFrames()
                              
                            
                               
                          
                               
                            }
                            
                            
                            if(numInvitations == 0) {
                                self.scrollView!.addSubview(self.lblOpenInvitationsNone!)
                            } else {
                                self.lblOpenInvitationsNone?.removeFromSuperview()
                            }
                            self.setupFrames()
                        
                        
                        })
                        
                        
                    } else {
                        self.loadError(result["message"].stringValue)
                        self.afterRequest()
                    }
                } else {
                    self.loadError("An error occurred.")
                    self.afterRequest()
                    
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.loadError("An error occurred.")
            self.afterRequest()
        }
    } // END LOAD INVITATIONS
    
    
    func loadPendingStories() {
        
        self.requests += 1
        
        self.currentUser = StorySlam.getCurrentUser()
        
        do {
            
            let opt = try HTTP.POST(StorySlam.actionURL + "getPendingStories", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterRequest()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.afterRequest()
                            
                            for old_pending_story_row in self.pending_stories_rows {
                                
                                old_pending_story_row.removeFromSuperview()
                            }
                            self.pending_stories_rows.removeAll()
                            
                            var numPendingStories = 0
                            for (indexOuter,subJsonOuter):(String, JSON) in result["data"]["pending_stories"] {
                                
                                
                                numPendingStories += 1
                                
                                
                                
                                let initiator = Friend.init(id: subJsonOuter["initiator"]["id"].intValue, username: subJsonOuter["initiator"]["username"].stringValue, firstname: subJsonOuter["initiator"]["firstname"].stringValue, lastname: subJsonOuter["initiator"]["lastname"].stringValue)
                                
                                var all_players = [Friend]()
                                
                                var pending_players = [Friend]()
                      
                                
                                for (index,subJson):(String, JSON) in subJsonOuter["all_players"] {
                                    //Do something you want
                                    
                                    let other_player = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                    
                                    all_players.append(other_player)
                                    
                                }
                                
                                for (index,subJson):(String, JSON) in subJsonOuter["pending_players"] {
                                    //Do something you want
                                    
                                    let other_player = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                    
                                    pending_players.append(other_player)
                                    
                                }
                                
                                let pending_story = PendingStory.init(id: subJsonOuter["id"].intValue, title: subJsonOuter["title"].stringValue, genre: subJsonOuter["genre"].stringValue, initiator: initiator, expiration_string: subJsonOuter["expiration_string"].stringValue, all_players: all_players, pending_players: pending_players)
                                
                                
                                let pending_story_row = SSPendingStoryRow()
                                
                                
                                pending_story_row.initialize(pending_story, width: self.myWidth! - 30, parent: self)
                                self.pending_stories_rows.append(pending_story_row)
                                
                                self.scrollView!.addSubview(pending_story_row)
                                self.setupFrames()
                                

                                
                            }
                            
                            
                            if(numPendingStories == 0) {
                                self.lblPendingStories?.removeFromSuperview()
                            } else {
                               self.scrollView!.addSubview(self.lblPendingStories!)
                            }
                            
                            
                        })
                        
                        
                    } else {
                        self.loadError(result["message"].stringValue)
                        self.afterRequest()
                    }
                } else {
                    self.loadError("An error occurred.")
                    self.afterRequest()
                    
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.loadError("An error occurred.")
            self.afterRequest()
        }
        
    } //END LOAD PENDING STORIES
    
    
    
    
    func loadOpenStories() {
        self.requests += 1
        
        self.currentUser = StorySlam.getCurrentUser()
        
        do {
            
            let opt = try HTTP.POST(StorySlam.actionURL + "getOpenStories", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterRequest()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.afterRequest()
                            
                            for old_open_story_row in self.open_stories_rows {
                                
                                old_open_story_row.removeFromSuperview()
                            }
                            self.open_stories_rows.removeAll()
                            
                            var numOpenStories = 0
                            for (indexOuter,subJsonOuter):(String, JSON) in result["data"]["open_stories"] {
                                
                                
                                numOpenStories += 1
                                
                                
                                
                                let initiator = Friend.init(id: subJsonOuter["initiator"]["id"].intValue, username: subJsonOuter["initiator"]["username"].stringValue, firstname: subJsonOuter["initiator"]["firstname"].stringValue, lastname: subJsonOuter["initiator"]["lastname"].stringValue)
                                
                                var all_players = [Friend]()
                     
                                
                                
                                for (index,subJson):(String, JSON) in subJsonOuter["all_players"] {
                                    //Do something you want
                                    
                                    let other_player = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                    
                                    all_players.append(other_player)
                                    
                                }
                                
           
                                
                                
                                let open_story = OpenStory.init(id: subJsonOuter["id"].intValue, title: subJsonOuter["title"].stringValue, genre: subJsonOuter["genre"].stringValue, initiator: initiator, expiration_string: subJsonOuter["expiration_string"].stringValue, expiration_string_short: subJsonOuter["expiration_string_short"].stringValue, current_action_string: subJsonOuter["current_action_string"].stringValue, num_sentences: subJsonOuter["num_sentences"].stringValue, sentences_fulfilled: subJsonOuter["sentences_fulfilled"].boolValue, all_players: all_players, is_my_turn: subJsonOuter["my_turn"].boolValue, is_initiator: subJsonOuter["is_initiator"].boolValue)
                                
                                
                                let open_story_row = SSOpenStoryRow()
                                
                                
                                open_story_row.initialize(open_story, width: self.myWidth! - 30, parent: self)
                                self.open_stories_rows.append(open_story_row)
                                
                                self.scrollView!.addSubview(open_story_row)
                                self.setupFrames()
                                
                                
                                
                            }
                            
                            if(numOpenStories == 0) {
                                self.scrollView!.addSubview(self.lblOpenStoriesNone!)
                            } else {
                                self.lblOpenStoriesNone!.removeFromSuperview()
                            }
                            
                            self.setupFrames()
                            
                            
                            
                            
                            
                        })
                        
                        
                    } else {
                        self.loadError(result["message"].stringValue)
                        self.afterRequest()
                    }
                } else {
                    self.loadError("An error occurred.")
                    self.afterRequest()
                    
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.loadError("An error occurred.")
            self.afterRequest()
        }
        
    } //END LOAD OPEN STORIES
    
    
    func replyToInvitation(sender: AnyObject, invitation: Invitation, accepted: Bool) {
        print("replying to invitation....")
        
        if(self.requests <= self.finished_requests) {
        
        self.requests += 1
        
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.startRefreshButton()
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
       
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "replyToInvitation", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "invitation_id" : String(invitation.id), "accept" : (accepted ? "1" : "0")])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                        self.afterRequest()
                        return //also notify app of failure as needed
                    }
                    print(response.description)

                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            self.tapRefresh(self)
                            self.afterRequest()
                            
                        } else {
                            self.loadError(result["message"].stringValue)
                            self.afterRequest()
                        }
                    } else {
                        self.loadError("An error occurred.")
                        self.afterRequest()
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.loadError("An error occurred.")
                self.afterRequest()
            }
            
        }
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        for invitation_row in self.invitation_rows {
            invitation_row.finishedSetupFrames = false
        }
        for pending_story_row in self.pending_stories_rows {
            pending_story_row.finishedSetupFrames = false
        }
        for open_story_row in self.open_stories_rows {
            open_story_row.finishedSetupFrames = false
        }
        
        super.viewWillLayoutSubviews()
    }
    
    
}