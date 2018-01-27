//
//  SSNewStoryViewStep2Friends.swift
//  StorySlam
//
//  Created by Mark Keller on 7/25/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSNewStoryViewStep2Friends: SSContentView, UITextFieldDelegate {
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    var lblStepTitle: UILabel?
    
    var playerChoiceViews = [Dictionary<String, UIView>]()
    var numPlayerChoiceViews = 4
    
    
    var btnNext: UIButton?
    
    var btnNextEnabled: Bool = false
    
    var selectedFriends = [Int?]()
    
    
    //modal and its subviews
    
    var searchRows = [SSFriendRow]()
    
    var modalIsOpen = false
    var modalIsOpenFor: Int?
    var modalAdd: UIView?
    var modalAddHeight: CGFloat = 0
    var modalAddWidth: CGFloat = 0
    var modalBtnClose: UIButton?
    
    var modalImgSearchIcon: UIImageView?
    var modalTxtSearch: SSSearchField?
    var modalScrollView: UIScrollView?
    var modalLineSearch: UIView?
    var modalLoadingIndicator: UIActivityIndicatorView?
    var modalLatestSearchID = 0
    var modalTotalRowLabel: UILabel?
    
    
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
        self.lblStepTitle!.text = "2. Choose up to 4 Friends"
        self.lblStepTitle!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStepTitle!.textColor = StorySlam.colorBlue
        self.lblStepTitle!.textAlignment = .Left
        self.scrollView!.addSubview(self.lblStepTitle!)
        
        
        self.playerChoiceViews.removeAll()
        self.selectedFriends.removeAll()
        for i in 0..<self.numPlayerChoiceViews {
            print(i)
            
            self.selectedFriends.append(nil)
            
            self.playerChoiceViews.append([
                "main" : UIView(),
                "plusIcon" : UIImageView(),
                "usernameLabel" : UILabel(),
                "nameLabel" : UILabel(),
                "closeIcon" : UIImageView()
                ])
            self.playerChoiceViews[i]["main"]!.backgroundColor = StorySlam.colorLightGray
            self.playerChoiceViews[i]["main"]!.layer.cornerRadius = 20
            self.playerChoiceViews[i]["main"]!.userInteractionEnabled = true
            self.playerChoiceViews[i]["main"]!.tag = i
            let gestureRecognizer = SSTapGestureRecognizer.init(target: self, action: Selector("tapPlus:"))
                gestureRecognizer.tag = i
            self.playerChoiceViews[i]["plusIcon"]!.addGestureRecognizer(gestureRecognizer)
            self.scrollView!.addSubview(self.playerChoiceViews[i]["main"]!)
            
            let plusIcon = self.playerChoiceViews[i]["plusIcon"]! as! UIImageView
            plusIcon.image = UIImage(named: "plus-yellow")
            plusIcon.contentMode = .ScaleAspectFit
            plusIcon.userInteractionEnabled = true
            self.playerChoiceViews[i]["main"]!.addSubview(plusIcon)
            
            let closeIcon = self.playerChoiceViews[i]["closeIcon"]! as! UIImageView
            closeIcon.image = UIImage(named: "x-yellow")
            closeIcon.contentMode = .ScaleAspectFit
            let gestureRecognizer2 = SSTapGestureRecognizer.init(target: self, action: Selector("tapClose:"))
            gestureRecognizer2.tag = i
            closeIcon.userInteractionEnabled = false
            closeIcon.addGestureRecognizer(gestureRecognizer2)
            
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
        self.btnNext!.backgroundColor = StorySlam.colorGold
        self.btnNext!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnNext!.setTitle("Next", forState: .Normal)
        self.btnNext!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnNext!.addTarget(self, action: Selector("nextTap:"), forControlEvents: .TouchUpInside)
        self.btnNext!.userInteractionEnabled = false
        self.scrollView!.addSubview(self.btnNext!)
        
        
        
        
        
        
        //modal and subviews below
        self.modalAdd = UIView()
        self.modalAdd!.backgroundColor = StorySlam.colorLightBlue
        self.modalAdd!.layer.cornerRadius = 20
        
        self.modalBtnClose = UIButton()
        self.modalBtnClose!.backgroundColor = StorySlam.colorYellow
        self.modalBtnClose!.layer.cornerRadius = 20
        self.modalBtnClose!.setTitle("Done", forState: .Normal)
        self.modalBtnClose!.setTitleColor(StorySlam.colorBlue, forState: .Normal)
        self.modalBtnClose!.addTarget(self, action: Selector("hideAddModal:"), forControlEvents: .TouchUpInside)
        self.modalBtnClose!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.modalAdd!.addSubview(self.modalBtnClose!)
        
        self.modalImgSearchIcon = UIImageView()
        self.modalImgSearchIcon!.image = UIImage(named: "search-blue")
        self.modalImgSearchIcon!.contentMode = .ScaleAspectFit
        self.modalAdd!.addSubview(self.modalImgSearchIcon!)
        
        self.modalTxtSearch = SSSearchField()
        self.modalTxtSearch!.backgroundColor = StorySlam.colorClear
        self.modalTxtSearch!.tintColor = StorySlam.colorBlue
        self.modalTxtSearch!.textColor = StorySlam.colorBlue
        self.modalTxtSearch!.font = UIFont(name: "OpenSans", size: 14)
        self.modalTxtSearch!.returnKeyType = .Go
        self.modalTxtSearch!.delegate = self
        self.modalTxtSearch!.clearButtonMode = .Always
        self.modalTxtSearch!.attributedPlaceholder = NSAttributedString(string:"Search...", attributes:[NSForegroundColorAttributeName: StorySlam.colorBlue])
        self.modalAdd!.addSubview(self.modalTxtSearch!)
        
        
        
        self.modalLineSearch = UIView()
        self.modalLineSearch!.backgroundColor = StorySlam.colorBlue
        self.modalAdd!.addSubview(self.modalLineSearch!)
        
        self.modalLoadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        
        self.modalScrollView = UIScrollView()
        self.modalScrollView!.backgroundColor = StorySlam.colorClear
        self.modalAdd!.addSubview(self.modalScrollView!)
        
        self.modalTotalRowLabel = UILabel()
        self.modalTotalRowLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.modalTotalRowLabel!.text = ""
        self.modalTotalRowLabel!.textColor = StorySlam.colorGray
        self.modalTotalRowLabel!.textAlignment = .Center
        self.modalScrollView!.addSubview(self.modalTotalRowLabel!)
        
        
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
                self.playerChoiceViews[i]["plusIcon"]!.frame = CGRect(x: (choiceWidth-48)/2, y: 0, width: 48, height: 200)
                
                self.playerChoiceViews[i]["closeIcon"]!.frame = CGRect(x: choiceWidth-24-10, y: 10, width: 24, height: 24)
                
                self.playerChoiceViews[i]["usernameLabel"]!.frame = CGRect(x: 10, y: 100+24+12, width: choiceWidth-20, height: 18)
                
                self.playerChoiceViews[i]["nameLabel"]!.frame = CGRect(x: 10, y: 100+24+12+18, width: choiceWidth-20, height: 18)
            }
            
            
        }
        
        self.modalAddHeight = self.myHeight! - appDelegate.navBarHeight
        self.modalAddWidth = self.myWidth!*0.8
        
        self.modalAdd!.frame = CGRect(x: (self.myWidth!-self.modalAddWidth)/2, y: 0, width: self.modalAddWidth, height: self.modalAddHeight)
        self.modalBtnClose!.frame = CGRect(x: 15, y: self.modalAddHeight - 40 - 15, width: self.modalAddWidth - 30, height: 40)
        
        
        self.modalImgSearchIcon!.frame = CGRect(x: 14, y: 10, width: 18, height: 18)
        self.modalTxtSearch!.frame = CGRect(x: 14+18, y: 0, width: self.modalAddWidth - 14-18-5, height: 38)
        self.modalLineSearch!.frame = CGRect(x: 0, y: 38, width: self.modalAddWidth, height: 3)
        self.modalScrollView!.frame = CGRect(x: 0, y: 41, width: self.modalAddWidth, height: self.modalAddHeight - 41-40-15)
        self.modalLoadingIndicator!.frame = CGRect(x: 0, y: 41, width: self.modalAddWidth, height: self.modalAddHeight - 41-40-15)
        
        for searchRow in self.searchRows {
            searchRow.setupFrames(self.modalAddWidth)
        }
        
        self.modalTotalRowLabel!.frame = CGRect(x: 0, y: (SSFriendRow.rowHeight*CGFloat(self.searchRows.count)), width: self.modalAddWidth, height: 15)
        self.modalScrollView!.contentSize = CGSizeMake(self.modalAddWidth, (SSFriendRow.rowHeight*CGFloat(self.searchRows.count))+15+30)
        
        self.btnNext!.frame = CGRect(x: 16, y: 46+200+12+200+12, width: self.myWidth!-(16*2), height: 40)
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 46+200+12+200+12+40+20)
        
        
    }
    
    func tapBack(sender: AnyObject) {
        print("back tapped...")
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.backHomeContentView()
        })
    }
    
    
    func enableNextButton() {
        if(!self.btnNextEnabled) {
            dispatch_async(dispatch_get_main_queue(), {
                self.btnNext!.backgroundColor = StorySlam.colorBlue
            })
            self.btnNext!.userInteractionEnabled = true
            self.btnNextEnabled = true
        }
    }
    
    func disableNextButton() {
        if(self.btnNextEnabled) {
            dispatch_async(dispatch_get_main_queue(), {
                self.btnNext!.backgroundColor = StorySlam.colorGold
            })
            self.btnNext!.userInteractionEnabled = false
            self.btnNextEnabled = false
        }
    }
    
    func nextTap(sender: AnyObject) {
        
        self.getPrompt()
        
        
    }
    
    
    
    
    func tapPlus(sender: AnyObject) {
        
        let gestureRecognizer = sender as! SSTapGestureRecognizer
        
        self.showAddModal(gestureRecognizer.tag!)
        
        print("plus (\(gestureRecognizer.tag!)) tapped...")
        
    }
    
    
    func showAddModal(choiceViewIndex: Int) {
        //tint background
        self.modalIsOpen = true
        dispatch_async(dispatch_get_main_queue(), {
            self.modalIsOpenFor = choiceViewIndex
        })
        
        for searchRow in self.searchRows {
            dispatch_async(dispatch_get_main_queue(), {
                searchRow.removeFromSuperview()
            })
        }
        self.searchRows.removeAll()
        dispatch_async(dispatch_get_main_queue(), {
            self.modalTotalRowLabel!.text = ""
        })
        
        print("modalIsOpenFor set to \(self.modalIsOpenFor)")
        self.showTintLayer()
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.view.insertSubview(self.modalAdd!, atIndex: 15)
            dispatch_async(dispatch_get_main_queue(), {
                self.searchFriends(nil, searchID: self.modalLatestSearchID + 1)
            })
        })
    }
    
    func hideAddModal(sender: AnyObject) {
        //untint background
        self.modalIsOpen = false
        dispatch_async(dispatch_get_main_queue(), {
            self.modalIsOpenFor = nil
        })
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.modalAdd?.removeFromSuperview()
        })
    }
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.modalTxtSearch { //all users search
            textField.resignFirstResponder()
            if(textField.text != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.searchFriends(textField.text!, searchID: self.modalLatestSearchID + 1)
                })
                
                
            }
            return false
        }
        return true
    }
    

    func searchFriends(query_string: String?, searchID: Int) {
        //remove user rows from modal
        
        self.currentUser = StorySlam.getCurrentUser()
        
        for searchRow in self.searchRows {
            dispatch_async(dispatch_get_main_queue(), {
                searchRow.removeFromSuperview()
            })
        }
        self.searchRows.removeAll()
        dispatch_async(dispatch_get_main_queue(), {
            self.modalTotalRowLabel!.text = ""
        })
        
        self.modalLoadingIndicator!.startAnimating()
        self.modalAdd!.insertSubview(self.modalLoadingIndicator!, aboveSubview: self.modalScrollView!)
        
        do {
            
            var query_action = "getFriends"
            var the_parameters = ["username":currentUser!.username!, "token": currentUser!.token!]
            var result_key = "friends"
            
            if(query_string != nil) {
                query_action = "searchFriends"
                the_parameters["user_query"] = query_string!
                result_key = "search_result"
            }
            let opt = try HTTP.POST(StorySlam.actionURL + query_action, parameters: the_parameters)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterModalSearch()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                if(searchID > self.modalLatestSearchID) {
                    self.modalLatestSearchID += 1
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            var x = 0
                            
                            for (index,subJson):(String, JSON) in result["data"][result_key] {
                                //Do something you want
                                
                                let friend = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                
                                var friendAlreadySelected = false
                                
                                for i in 0..<self.selectedFriends.count {
                                    if(self.selectedFriends[i] == friend.id) {
                                        friendAlreadySelected = true
                                    }
                                }
                                
                                if(!friendAlreadySelected) {
                                    let friendRow = SSFriendRow(frame: CGRect(x: 0, y: (SSFriendRow.rowHeight*CGFloat(x)), width: self.modalAddWidth-(18*2), height: SSFriendRow.rowHeight))
                                    friendRow.initialize(friend, width: self.modalAddWidth)
                                    
                                    let gestureRecognizer = SSTapGestureRecognizer.init(target: self, action: Selector("chooseFriend:"))
                                    gestureRecognizer.user = friend
                                    friendRow.addGestureRecognizer(gestureRecognizer)
                                    
                                    self.searchRows.append(friendRow)
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.modalScrollView!.addSubview(friendRow)
                                    })
                                    x = x + 1
                                }
                                
                            }
                            
                            
                            self.afterModalSearch()
                            
                            
                        } else {
                            self.loadError(result["message"].stringValue)
                            self.afterModalSearch()
                        }
                    } else {
                        self.loadError("An error occurred.")
                        self.afterModalSearch()
                    }
                    
                    
                    
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.loadError("An error occurred.")
            self.afterModalSearch()
            
        }
        
        
        
    }
    


    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func afterModalSearch() {
        dispatch_async(dispatch_get_main_queue(), {
            self.modalLoadingIndicator!.stopAnimating()
            self.modalLoadingIndicator!.removeFromSuperview()
            
            if(self.searchRows.count == 1) {
                self.modalTotalRowLabel!.text = "\(self.searchRows.count) result"
            } else {
                self.modalTotalRowLabel!.text = "\(self.searchRows.count) results"
            }
            self.modalTotalRowLabel!.frame = CGRect(x: 0, y: (SSFriendRow.rowHeight*CGFloat(self.searchRows.count)), width: self.modalAddWidth, height: 15)
        })
        self.modalScrollView!.contentSize = CGSizeMake(self.modalAddWidth, (SSFriendRow.rowHeight*CGFloat(self.searchRows.count))+15+30)
    }
    
    
    
    func chooseFriend(sender: AnyObject) {
        
        let gestureRecognizer = sender as! SSTapGestureRecognizer
        
        let friend:Friend = gestureRecognizer.user!
        
        print("friend (\(friend.id)) chosen...")
        
        self.setFriendChoice(friend, choice_index: self.modalIsOpenFor)
        
        self.hideAddModal(self)
        
    }
    
    func setFriendChoice(friend: Friend, choice_index: Int?) {
        

        dispatch_async(dispatch_get_main_queue(), {
            if(choice_index != nil) {
                
                self.selectedFriends[choice_index!] = friend.id
                
                self.playerChoiceViews[choice_index!]["main"]!.backgroundColor = StorySlam.colorBlue
                
                let plusIcon = self.playerChoiceViews[choice_index!]["plusIcon"]! as! UIImageView
                plusIcon.image = UIImage(named: "user_o-yellow")
                plusIcon.userInteractionEnabled = false
                
                self.playerChoiceViews[choice_index!]["closeIcon"]!.userInteractionEnabled = true
                
                let usernameLabel = self.playerChoiceViews[choice_index!]["usernameLabel"]! as! UILabel
                usernameLabel.text = "@\(friend.username)"
                
                let nameLabel = self.playerChoiceViews[choice_index!]["nameLabel"]! as! UILabel
                nameLabel.text = friend.getFullname()
                
                
                self.playerChoiceViews[choice_index!]["main"]!.addSubview(self.playerChoiceViews[choice_index!]["closeIcon"]!)
                self.playerChoiceViews[choice_index!]["main"]!.addSubview(self.playerChoiceViews[choice_index!]["usernameLabel"]!)
                self.playerChoiceViews[choice_index!]["main"]!.addSubview(self.playerChoiceViews[choice_index!]["nameLabel"]!)
                
                self.checkNext()
                
            }
            
        })
        
        
        self.hideAddModal(self)
        
    }

    
    func tapClose(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            let gestureRecognizer = sender as! SSTapGestureRecognizer
            
            
            print("close (\(gestureRecognizer.tag!)) tapped...")
            
            self.selectedFriends[gestureRecognizer.tag!] = nil
            
            self.playerChoiceViews[gestureRecognizer.tag!]["main"]!.backgroundColor = StorySlam.colorLightGray
            
            let plusIcon = self.playerChoiceViews[gestureRecognizer.tag!]["plusIcon"]! as! UIImageView
            plusIcon.image = UIImage(named: "plus-yellow")
            plusIcon.userInteractionEnabled = true
            
            self.playerChoiceViews[gestureRecognizer.tag!]["closeIcon"]!.removeFromSuperview()
            self.playerChoiceViews[gestureRecognizer.tag!]["usernameLabel"]!.removeFromSuperview()
            self.playerChoiceViews[gestureRecognizer.tag!]["nameLabel"]!.removeFromSuperview()

            
            let usernameLabel = self.playerChoiceViews[gestureRecognizer.tag!]["usernameLabel"]! as! UILabel
            usernameLabel.text = ""
            
            let nameLabel = self.playerChoiceViews[gestureRecognizer.tag!]["nameLabel"]! as! UILabel
            nameLabel.text = ""
            
            self.checkNext()
        })
        
    }
    
    func checkNext() {
        var canEnable = false
        for i in 0..<self.selectedFriends.count {
            if(self.selectedFriends[i] != nil) {
                print("selectedFriends[\(i)]: \(self.selectedFriends[i])")
                canEnable = true
            }
        }
        if(canEnable) {
            self.enableNextButton()
        } else {
            self.disableNextButton()
        }
    }
    
    func getPrompt() {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.showLoadingOverlay()
            self.appDelegate.mainViewController!.tintNavBar()
            self.appDelegate.hideMenuButton()
        })
        
         self.currentUser = StorySlam.getCurrentUser()
        
        do {
            
            let opt = try HTTP.POST(StorySlam.actionURL + "getRandomPrompt", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterGetPrompt()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                
                    self.modalLatestSearchID += 1
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            
                            let the_genre = Genre(id: result["data"]["genre"]["id"].intValue, name: result["data"]["genre"]["name"].stringValue)
                            let the_prompt = Prompt(id: result["data"]["prompt"]["id"].intValue, text: result["data"]["prompt"]["text"].stringValue, genre: the_genre)
                            
                            var other_genres = [Genre]()
                            
                            
                            for (index,subJson):(String, JSON) in result["data"]["other_genres"] {
                                //Do something you want
                                let other_genre = Genre(id: subJson["id"].intValue, name: subJson["name"].stringValue)
                                other_genres.append(other_genre)
                                
                            }
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let nextStepView = SSNewStoryViewStep3()
                                nextStepView.initialize(self.selectedFriends, prompt: the_prompt, other_genres: other_genres)
                                
                                self.afterGetPrompt()
                                self.appDelegate.mainViewController!.setHomeContentView(nextStepView)
                            })
                            
                            
                        } else {
                            self.afterGetPrompt()
                            self.loadError(result["message"].stringValue)
                        }
                    } else {
                        self.afterGetPrompt()
                        self.loadError("An error occurred.")
                        
                    }
                    
                    
                    
                
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.afterGetPrompt()
            self.loadError("An error occurred.")
            
            
        }
        
        
        
    }
    
    func afterGetPrompt() {
        dispatch_async(dispatch_get_main_queue(), {
            self.hideLoadingOverlay()
            self.appDelegate.mainViewController!.untintNavBar()
            self.appDelegate.showMenuButton()
        })
    }
    
    
    
}