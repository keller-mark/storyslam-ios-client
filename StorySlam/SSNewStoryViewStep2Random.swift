//
//  SSNewStoryViewStep2Random.swift
//  StorySlam
//
//  Created by Mark Keller on 7/27/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSNewStoryViewStep2Random: SSContentView {
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    var lblStepTitle: UILabel?
    
    var playerChoiceViews = [Dictionary<String, UIView>]()
    var numPlayerChoiceViews = 4
    
    
    var btnNext: UIButton?
    
    var btnNextEnabled: Bool = false
    
    var other_players = [Friend]()
    var story_id: Int?
    
    
    var currentUser: CurrentUser?
    
    var checkTimer: NSTimer?
    
    
    
    func initialize(other_players: [Friend], story_id: Int) {
        self.other_players = other_players
        self.story_id = story_id
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupViews()
        self.setupFrames()
        
        self.checkTimer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("updateChoices"), userInfo: nil, repeats: true)

    }
    
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()
        
        self.scrollView!.backgroundColor = StorySlam.colorYellow
        self.appDelegate.mainViewController!.hideRefreshButton()
        
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "New Story"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorGreen
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        self.imgBackIcon = UIImageView()
        self.imgBackIcon!.image = UIImage(named: "back_arrow-yellow")
        self.imgBackIcon!.contentMode = .ScaleAspectFit
        self.imgBackIcon!.userInteractionEnabled = true
        self.imgBackIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapBack:")))
        if(self.appDelegate.mainViewController!.canGoBack()) {
            self.view.addSubview(self.imgBackIcon!)
        }
        
        
        self.lblStepTitle = UILabel()
        self.lblStepTitle!.text = "2. Wait for others to join"
        self.lblStepTitle!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStepTitle!.textColor = StorySlam.colorBlue
        self.lblStepTitle!.textAlignment = .Left
        self.scrollView!.addSubview(self.lblStepTitle!)
        
        
        self.playerChoiceViews.removeAll()
  
        for i in 0..<self.numPlayerChoiceViews {
            print(i)
            
            
            self.playerChoiceViews.append([
                "main" : UIView(),
                "plusIcon" : UIImageView(),
                "usernameLabel" : UILabel(),
                "nameLabel" : UILabel(),
                "activityIndicator" : UIActivityIndicatorView(activityIndicatorStyle: .Gray )
                ])
            
            self.playerChoiceViews[i]["main"]!.backgroundColor = StorySlam.colorLightGray
            self.playerChoiceViews[i]["main"]!.layer.cornerRadius = 20
            self.playerChoiceViews[i]["main"]!.userInteractionEnabled = false
            self.playerChoiceViews[i]["main"]!.tag = i
            self.scrollView!.addSubview(self.playerChoiceViews[i]["main"]!)
            
            let plusIcon = self.playerChoiceViews[i]["plusIcon"]! as! UIImageView
            plusIcon.image = UIImage(named: "user_o-yellow")
            plusIcon.contentMode = .ScaleAspectFit
            plusIcon.userInteractionEnabled = true
            //self.playerChoiceViews[i]["main"]!.addSubview(plusIcon)
            
            
            let usernameLabel = self.playerChoiceViews[i]["usernameLabel"]! as! UILabel
            usernameLabel.text = ""
            usernameLabel.textAlignment = .Center
            usernameLabel.textColor = StorySlam.colorYellow
            usernameLabel.font = UIFont(name: "OpenSans", size: 14)
            
            let nameLabel = self.playerChoiceViews[i]["nameLabel"]! as! UILabel
            nameLabel.text = ""
            nameLabel.textAlignment = .Center
            nameLabel.textColor = StorySlam.colorYellow
            nameLabel.font = UIFont(name: "OpenSans", size: 14)
            
        }
        
        
        
        self.btnNext = UIButton()
        self.btnNext!.layer.cornerRadius = 20
        self.btnNext!.backgroundColor = StorySlam.colorBlue
        self.btnNext!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnNext!.setTitle("Done", forState: .Normal)
        self.btnNext!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnNext!.addTarget(self, action: Selector("doneTap:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnNext!)
        
        self.fillChoices()

    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: calculateHeight(46), width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        
        self.lblStepTitle!.frame = CGRect(x: 16, y: 10, width: self.myWidth!-(16*2), height: 32)
        
        let choiceWidth:CGFloat = (self.myWidth!-(16*2))/2-6
        
        if self.playerChoiceViews.count == self.numPlayerChoiceViews {
            
            self.playerChoiceViews[0]["main"]!.frame = CGRect(x: 16, y: 46, width: choiceWidth, height: 200)
            self.playerChoiceViews[1]["main"]!.frame = CGRect(x: 16+choiceWidth+12, y: 46, width: choiceWidth, height: 200)
            
            self.playerChoiceViews[2]["main"]!.frame = CGRect(x: 16, y: 46+200+12, width: choiceWidth, height: 200)
            self.playerChoiceViews[3]["main"]!.frame = CGRect(x: 16+choiceWidth+12, y: 46+200+12, width: choiceWidth, height: 200)
            
            for i in 0..<self.numPlayerChoiceViews {
                self.playerChoiceViews[i]["plusIcon"]!.frame = CGRect(x: (choiceWidth-48)/2, y: 0, width: 48, height: 180)
                
                self.playerChoiceViews[i]["activityIndicator"]!.frame = CGRect(x: (choiceWidth-48)/2, y: 0, width: 48, height: 200)
                
                self.playerChoiceViews[i]["usernameLabel"]!.frame = CGRect(x: 10, y: 100+24+12, width: choiceWidth-20, height: 18)
                
                self.playerChoiceViews[i]["nameLabel"]!.frame = CGRect(x: 10, y: 100+24+12+18, width: choiceWidth-20, height: 18)
            }
            
            
        }
        
       
        
        self.btnNext!.frame = CGRect(x: 16, y: 46+200+12+200+12, width: self.myWidth!-(16*2), height: 40)
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 46+200+12+200+12+40+20)
        
        
    }
    
    func fillChoices() {
        if(self.other_players.count < 4) {
            for i in 0..<self.numPlayerChoiceViews {
                if(self.other_players.count > i) {
                    
                    
                    let activityIndicator = self.playerChoiceViews[i]["activityIndicator"]! as! UIActivityIndicatorView
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    self.playerChoiceViews[i]["main"]!.backgroundColor = StorySlam.colorBlue
                    
                    let plusIcon = self.playerChoiceViews[i]["plusIcon"]! as! UIImageView
                    plusIcon.image = UIImage(named: "user_o-yellow")
                    
                    let usernameLabel = self.playerChoiceViews[i]["usernameLabel"]! as! UILabel
                    usernameLabel.text = "@\(self.other_players[i].username)"
                    
                    let nameLabel = self.playerChoiceViews[i]["nameLabel"]! as! UILabel
                    nameLabel.text = self.other_players[i].getFullname()
                    
                    
                    self.playerChoiceViews[i]["main"]!.addSubview(self.playerChoiceViews[i]["plusIcon"]!)
                    self.playerChoiceViews[i]["main"]!.addSubview(self.playerChoiceViews[i]["usernameLabel"]!)
                    self.playerChoiceViews[i]["main"]!.addSubview(self.playerChoiceViews[i]["nameLabel"]!)
                    
                } else {
                    self.playerChoiceViews[i]["plusIcon"]!.removeFromSuperview()
                    self.playerChoiceViews[i]["usernameLabel"]!.removeFromSuperview()
                    self.playerChoiceViews[i]["nameLabel"]!.removeFromSuperview()
                    
                    self.playerChoiceViews[i]["main"]!.backgroundColor = StorySlam.colorLightGray
                    
                    let activityIndicator = self.playerChoiceViews[i]["activityIndicator"]! as! UIActivityIndicatorView
                    activityIndicator.startAnimating()
                    self.playerChoiceViews[i]["main"]!.addSubview(activityIndicator)
                    
                }
            }
        } else {
            self.doneTap(self)
        }
        
    }
    
    func tapBack(sender: AnyObject) {
        print("back tapped...")
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.backHomeContentView()
        })
    }
    
    
    func doneTap(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.setHomeContentView(SSHomeView())
        })
        
        
    }
    
    
    
    

    

    
    
   
    
    

    
    
  /*  func chooseFriend(sender: AnyObject) {
        
        let gestureRecognizer = sender as! SSTapGestureRecognizer
        
        let friend:Friend = gestureRecognizer.user!
        
        print("friend (\(friend.id)) chosen...")
        dispatch_async(dispatch_get_main_queue(), {
            if(self.modalIsOpenFor != nil) {
                
                self.selectedFriends[self.modalIsOpenFor!] = friend.id
                
                self.playerChoiceViews[self.modalIsOpenFor!]["main"]!.backgroundColor = StorySlam.colorBlue
                
                let plusIcon = self.playerChoiceViews[self.modalIsOpenFor!]["plusIcon"]! as! UIImageView
                plusIcon.image = UIImage(named: "user_o-yellow")
                plusIcon.userInteractionEnabled = false
                
                self.playerChoiceViews[self.modalIsOpenFor!]["closeIcon"]!.userInteractionEnabled = true
                
                let usernameLabel = self.playerChoiceViews[self.modalIsOpenFor!]["usernameLabel"]! as! UILabel
                usernameLabel.text = "@\(friend.username)"
                
                let nameLabel = self.playerChoiceViews[self.modalIsOpenFor!]["nameLabel"]! as! UILabel
                nameLabel.text = friend.getFullname()
                
                
                self.playerChoiceViews[self.modalIsOpenFor!]["main"]!.addSubview(self.playerChoiceViews[self.modalIsOpenFor!]["closeIcon"]!)
                self.playerChoiceViews[self.modalIsOpenFor!]["main"]!.addSubview(self.playerChoiceViews[self.modalIsOpenFor!]["usernameLabel"]!)
                self.playerChoiceViews[self.modalIsOpenFor!]["main"]!.addSubview(self.playerChoiceViews[self.modalIsOpenFor!]["nameLabel"]!)
                
                self.checkNext()
                
            }
            
        })
        
        
        self.hideAddModal(self)
        
    }*/
    
    
   
    
    func updateChoices() {
        if(appDelegate.mainViewController != nil && appDelegate.mainViewController!.contentView != nil && appDelegate.mainViewController!.contentView! == self) {
        
            self.currentUser = StorySlam.getCurrentUser()
            
            do {
                
                let opt = try HTTP.POST(StorySlam.actionURL + "checkNewRandomStory", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.story_id!)])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            

                            var new_other_players = [Friend]()
                            
                            for (index,subJson):(String, JSON) in result["data"]["other_players"] {
                                //Do something you want
                                
                                let other_player = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                
                                new_other_players.append(other_player)
                                
                            }
                                
                            self.other_players = new_other_players
                            dispatch_async(dispatch_get_main_queue(), {
                                self.fillChoices()
                            })
                                
                    
                            
                            
                        } else {
                            print(result["message"].stringValue)
                        }
                    } else {
                        print("An error occurred.")
                        
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
           
                
            }
            
        } else {
            self.checkTimer!.invalidate()
        }
        
        
        
    }
    
    
    
    
    
    
    
}