//
//  SSMyFeedView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/24/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSMyFeedView: SSContentView {
    
    //main views
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    var lblNumFound: UILabel?
    
    var lblLoadingError: UILabel?
    var currentUser: CurrentUser?
    
    var finished_stories_rows = [SSFinishedStoryRow]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
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
        
        self.loadFinishedStories()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.showRefreshButton(self, action: "tapRefresh:")
        })
        
    }
    
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()
        
        self.scrollView!.backgroundColor = StorySlam.colorLightGreen
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "My Feed"
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
        
        self.lblLoadingError = UILabel()
        self.lblLoadingError!.text = "Loading..."
        self.lblLoadingError!.textAlignment = .Center
        self.lblLoadingError!.textColor = StorySlam.colorGray
        self.lblLoadingError!.font = UIFont(name: "OpenSans", size: 18)
        
        self.lblNumFound = UILabel()
        self.lblNumFound!.text = ""
        self.lblNumFound!.textColor = StorySlam.colorBlue
        self.lblNumFound!.font = UIFont(name: "OpenSans", size: 12)
        self.lblNumFound!.textAlignment = .Center
        self.scrollView!.addSubview(self.lblNumFound!)
        
    }
    override func setupFrames() {
        dispatch_async(dispatch_get_main_queue(), {
            super.setupFrames()
            
            self.lblTitle!.frame = CGRect(x: 0, y: self.calculateHeight(46), width: self.myWidth!, height: 46)
            self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
            
            self.lblLoadingError!.frame = CGRect(x: 15, y: 30, width: self.myWidth!-30, height: 40)
            
            var finished_stories_height: CGFloat = 15
            
            if(self.finished_stories_rows.count > 0) {
                
                
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
            self.lblNumFound!.frame = CGRect(x: 15, y: finished_stories_height+5, width: self.myWidth!-30, height: 16)
            
            self.scrollView!.contentSize = CGSizeMake(self.myWidth!, finished_stories_height+5+16+15)

            
        })
    }
    
    
    override func tapRefresh(sender: AnyObject) {
        
        print("refresh tapped...")
        self.loadFinishedStories()
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
    
    
    func loadFinishedStories() {
        dispatch_async(dispatch_get_main_queue(), {
            self.disableScrollview()
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            self.lblNumFound!.text = ""
            self.lblLoadingError!.text = "Loading..."
            self.scrollView!.addSubview(self.lblLoadingError!)
            
            for old_finished_story_row in self.finished_stories_rows {
                
                old_finished_story_row.removeFromSuperview()
            }
            self.finished_stories_rows.removeAll()
            
            
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "getMyFriendsFinishedStories", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
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
                                
                                self.lblLoadingError!.removeFromSuperview()
                                
                                
                                var numFinishedStories = 0
                                
                                
                                for (index,subJson):(String, JSON) in result["data"]["my_friends_finished_stories"] {
                                    numFinishedStories += 1
                                    
                                    var authors = [Friend]()
                                    
                                    for (authorIndex, authorJson):(String, JSON) in subJson["authors"] {
                                        let author = Friend(id: authorJson["id"].intValue, username: authorJson["username"].stringValue, firstname: authorJson["firstname"].stringValue, lastname: authorJson["lastname"].stringValue)
                                        authors.append(author)
                                    }
                                    
                                    let finished_story = FinishedStory(id: subJson["id"].intValue, title: subJson["title"].stringValue, genre: subJson["genre"].stringValue, authors: authors, content: subJson["content"].stringValue, created_at: subJson["created_at"].stringValue, finished_at: subJson["finished_at"].stringValue, link: subJson["link"].stringValue, num_likes: subJson["num_likes"].intValue, random: subJson["random"].boolValue, length: subJson["length"].intValue, liked_by_me: subJson["liked_by_me"].boolValue)
                                    
                                    let finished_story_row = SSFinishedStoryRow()
                                    finished_story_row.initialize(finished_story, width: self.myWidth!-30, parent: self)
                                    
                                    self.finished_stories_rows.append(finished_story_row)
                                    self.scrollView!.addSubview(finished_story_row)
                                    self.setupFrames()
                                    
                                    
                                }
                                
                                self.lblNumFound!.text = "\(numFinishedStories) result" + (numFinishedStories == 1 ? "" : "s")
                                self.setupFrames()
                                
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
    
    
    
    override func viewWillLayoutSubviews() {
        for finished_story_row in self.finished_stories_rows {
            finished_story_row.finishedSetupFrames = false
        }
        super.viewWillLayoutSubviews()
    }
    
    
    
    
    
}