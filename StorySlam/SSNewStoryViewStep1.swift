//
//  SSNewStoryView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSNewStoryViewStep1: SSContentView {
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    var lblStepTitle: UILabel?
    
    var choiceFriends: UIView?
    var choiceFriendsIcon: UIImageView?
    var choiceFriendsLabel: UILabel?
    var choiceFriendsDesc: UILabel?
    
    var choiceFriendsLine: UIView?
    
    
    
    var choiceRandom: UIView?
    var choiceRandomIcon: UIImageView?
    var choiceRandomLabel: UILabel?
    var choiceRandomDesc: UILabel?
    
    var choiceRandomLine: UIView?
    
    var btnNext: UIButton?
    
    var btnNextEnabled: Bool = false
    
    var choice: Int = 0 // 1: Friends, 2: Random
    
    var currentUser: CurrentUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupFrames()
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
        self.lblStepTitle!.text = "1. Choose Type"
        self.lblStepTitle!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStepTitle!.textColor = StorySlam.colorBlue
        self.lblStepTitle!.textAlignment = .Left
        self.scrollView!.addSubview(self.lblStepTitle!)
        
        self.choiceFriends = UIView()
        self.choiceFriends!.backgroundColor = StorySlam.colorLightBlue
        self.choiceFriends!.layer.cornerRadius = 20
        self.choiceFriends!.userInteractionEnabled = true
        self.choiceFriends!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("chooseFriends:")))
        self.scrollView!.addSubview(self.choiceFriends!)
        
        self.choiceFriendsIcon = UIImageView()
        self.choiceFriendsIcon!.image = UIImage(named: "team-blue")
        self.choiceFriendsIcon!.contentMode = .ScaleAspectFit
        self.choiceFriends!.addSubview(self.choiceFriendsIcon!)
        
        self.choiceFriendsLine = UIView()
        self.choiceFriendsLine!.backgroundColor = StorySlam.colorBlue
        self.choiceFriendsLine!.layer.cornerRadius = 2
        self.choiceFriendsLine!.alpha = 0.0
        self.choiceFriends!.addSubview(self.choiceFriendsLine!)
        
        self.choiceFriendsLabel = UILabel()
        self.choiceFriendsLabel!.text = "Friends"
        self.choiceFriendsLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.choiceFriendsLabel!.textColor = StorySlam.colorBlue
        self.choiceFriendsLabel!.textAlignment = .Center
        self.choiceFriends!.addSubview(self.choiceFriendsLabel!)
        
        self.choiceFriendsDesc = UILabel()
        self.choiceFriendsDesc!.text = "Initiate a new story with up to four friends."
        self.choiceFriendsDesc!.font = UIFont(name: "OpenSans", size: 12)
        self.choiceFriendsDesc!.textColor = StorySlam.colorBlue
        self.choiceFriendsDesc!.textAlignment = .Left
        self.choiceFriendsDesc!.numberOfLines = 0
        self.choiceFriends!.addSubview(self.choiceFriendsDesc!)
        
        
        
        
        self.choiceRandom = UIView()
        self.choiceRandom!.backgroundColor = StorySlam.colorLightBlue
        self.choiceRandom!.layer.cornerRadius = 20
        self.choiceRandom!.userInteractionEnabled = true
        self.choiceRandom!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("chooseRandom:")))
        self.scrollView!.addSubview(self.choiceRandom!)
        
        self.choiceRandomLine = UIView()
        self.choiceRandomLine!.backgroundColor = StorySlam.colorBlue
        self.choiceRandomLine!.layer.cornerRadius = 2
        self.choiceRandomLine!.alpha = 0.0
        self.choiceRandom!.addSubview(self.choiceRandomLine!)
        
        self.choiceRandomIcon = UIImageView()
        self.choiceRandomIcon!.image = UIImage(named: "globe-blue")
        self.choiceRandomIcon!.contentMode = .ScaleAspectFit
        self.choiceRandom!.addSubview(self.choiceRandomIcon!)
        
        self.choiceRandomLabel = UILabel()
        self.choiceRandomLabel!.text = "Random"
        self.choiceRandomLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.choiceRandomLabel!.textColor = StorySlam.colorBlue
        self.choiceRandomLabel!.textAlignment = .Center
        self.choiceRandom!.addSubview(self.choiceRandomLabel!)
        
        self.choiceRandomDesc = UILabel()
        self.choiceRandomDesc!.text = "Begin a new story with up to four random users."
        self.choiceRandomDesc!.font = UIFont(name: "OpenSans", size: 12)
        self.choiceRandomDesc!.textColor = StorySlam.colorBlue
        self.choiceRandomDesc!.textAlignment = .Left
        self.choiceRandomDesc!.numberOfLines = 0
        self.choiceRandom!.addSubview(self.choiceRandomDesc!)
        
        
        self.btnNext = UIButton()
        self.btnNext!.layer.cornerRadius = 20
        self.btnNext!.backgroundColor = StorySlam.colorGold
        self.btnNext!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnNext!.setTitle("Next", forState: .Normal)
        self.btnNext!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnNext!.addTarget(self, action: Selector("nextTap:"), forControlEvents: .TouchUpInside)
        self.btnNext!.userInteractionEnabled = false
        self.scrollView!.addSubview(self.btnNext!)
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: calculateHeight(46), width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        
        self.lblStepTitle!.frame = CGRect(x: 16, y: 10, width: self.myWidth!-(16*2), height: 32)
        
        let choiceWidth:CGFloat = (self.myWidth!-(16*2))/2-6
        
        self.choiceFriends!.frame = CGRect(x: 16, y: 46, width: choiceWidth, height: 240)
        self.choiceRandom!.frame = CGRect(x: 16+choiceWidth+12, y: 46, width: choiceWidth, height: 240)
        
        self.btnNext!.frame = CGRect(x: 16, y: 298, width: self.myWidth!-(16*2), height: 40)
        
        self.choiceFriendsIcon!.frame = CGRect(x: 0, y: 36, width: choiceWidth, height: 50)
        self.choiceRandomIcon!.frame = CGRect(x: 0, y: 24, width: choiceWidth, height: 74)
        
        self.choiceFriendsLabel!.frame = CGRect(x: 0, y: 106, width: choiceWidth, height: 32)
        self.choiceRandomLabel!.frame = CGRect(x: 0, y: 106, width: choiceWidth, height: 32)
        
        let choiceFriendsDescSize = self.choiceFriendsDesc!.sizeThatFits(CGSizeMake(choiceWidth-30, CGFloat.max))
        self.choiceFriendsDesc!.frame = CGRect(x: 15, y: 150, width: choiceWidth-30, height: choiceFriendsDescSize.height)
        
        let choiceRandomDescSize = self.choiceRandomDesc!.sizeThatFits(CGSizeMake(choiceWidth-30, CGFloat.max))
        self.choiceRandomDesc!.frame = CGRect(x: 15, y: 150, width: choiceWidth-30, height: choiceRandomDescSize.height)
        
        self.choiceFriendsLine!.frame = CGRect(x: choiceWidth*0.2, y: 138, width: choiceWidth*0.6, height: 4)
        self.choiceRandomLine!.frame = CGRect(x: choiceWidth*0.2, y: 138, width: choiceWidth*0.6, height: 4)
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 338+20)
        
        
    }
    
    func tapBack(sender: AnyObject) {
        print("back tapped...")
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.backHomeContentView()
        })
    }
    
    func chooseFriends(sender: AnyObject) {
        print("friends tapped...")
        dispatch_async(dispatch_get_main_queue(), {
            self.choiceRandomLine!.alpha = 0.0
            self.enableNextButton()
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.choiceFriendsLine!.alpha = 1.0
                }) { (finished) -> Void in
                    
                    self.choice = 1
            }
        })
        

    }
    
    func chooseRandom(sender: AnyObject) {
        print("random tapped...")
        self.enableNextButton()
        dispatch_async(dispatch_get_main_queue(), {
            self.choiceFriendsLine!.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.choiceRandomLine!.alpha = 1.0
                }) { (finished) -> Void in
                    self.choice = 2
            }
        })
    }
    
    func enableNextButton() {
        if(!self.btnNextEnabled) {
            dispatch_async(dispatch_get_main_queue(), {
                self.btnNext!.userInteractionEnabled = true
                
                self.btnNext!.backgroundColor = StorySlam.colorBlue
                
                self.btnNextEnabled = true
            })
        }
    }
    
    func nextTap(sender: AnyObject) {
        if(self.choice == 1) { //go to step 2 friends
            print("going to step 2: friends")
            appDelegate.mainViewController!.setHomeContentView(SSNewStoryViewStep2Friends())
        }else if(self.choice == 2) { //go to step 2 random
            print("going to step 2: random")
            self.newRandomStory()
        }
    }
    
    
    
    func newRandomStory() {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.showLoadingOverlay()
            self.appDelegate.mainViewController!.tintNavBar()
            self.appDelegate.hideMenuButton()
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        do {
            
            let opt = try HTTP.POST(StorySlam.actionURL + "newRandomStory", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterNewRandomStory()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        
                        if(result["data"]["create_story"].boolValue == true) {
                            let the_genre = Genre(id: result["data"]["genre"]["id"].intValue, name: result["data"]["genre"]["name"].stringValue)
                            let the_prompt = Prompt(id: result["data"]["prompt"]["id"].intValue, text: result["data"]["prompt"]["text"].stringValue, genre: the_genre)
                            
                            var other_genres = [Genre]()
                            
                            
                            for (index,subJson):(String, JSON) in result["data"]["other_genres"] {
                                //Do something you want
                                let other_genre = Genre(id: subJson["id"].intValue, name: subJson["name"].stringValue)
                                other_genres.append(other_genre)
                                
                            }
                            
                            var random_users = [Int?]()
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let nextStepView = SSNewStoryViewStep3()
                                nextStepView.initialize(random_users, prompt: the_prompt, other_genres: other_genres, random: true)
                                
                                self.afterNewRandomStory()
                                self.appDelegate.mainViewController!.setHomeContentView(nextStepView)
                            })

                        } else {
                            print("going to wait for other random users...")
                            
                            var other_players = [Friend]()
                            
                            dispatch_async(dispatch_get_main_queue(), {
                            for (index,subJson):(String, JSON) in result["data"]["other_players"] {
                                //Do something you want
                                let other_player = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                other_players.append(other_player)
                                
                            }

                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let nextStepView = SSNewStoryViewStep2Random()
                                nextStepView.initialize(other_players, story_id: result["data"]["story_id"].intValue)
                                
                                self.afterNewRandomStory()
                                self.appDelegate.mainViewController!.setHomeContentView(nextStepView)
                            })
                            })

                        }
                        
                        
                        
                    } else {
                        self.afterNewRandomStory()
                        self.loadError(result["message"].stringValue)
                    }
                } else {
                    self.afterNewRandomStory()
                    self.loadError("An error occurred.")
                    
                }
                
                
                
                
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.afterNewRandomStory()
            self.loadError("An error occurred.")
            
            
        }
        
        
        
    }
    
    func afterNewRandomStory() {
        dispatch_async(dispatch_get_main_queue(), {
            self.hideLoadingOverlay()
            self.appDelegate.mainViewController!.untintNavBar()
            self.appDelegate.showMenuButton()
        })
    }
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    
    
}