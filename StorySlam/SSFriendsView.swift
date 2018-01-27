//
//  SSFriendsView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/17/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSFriendsView: SSContentView, UITextFieldDelegate {
    
    //main views
    var lblTitle: UILabel?
    var imgPlusIcon: UIImageView?
    
    var friendRows = [SSFriendRow]()
    var searchRows = [SSFriendRow]()
    
    var imgSearchIcon: UIImageView?
    var txtSearch: SSSearchField?
    var lineSearch: UIView?
    var searchBackground: UIView?
    
    var totalRowLabel: UILabel?
    
    var requestsButton: UIButton?
    var hasRequests: Bool = false
    
    
    //modal and its subviews
    var modalIsOpen = false
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
        self.loadFriends()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.showRefreshButton(self, action: "tapRefresh:")
        })
        
        if(self.modalIsOpen) {
            appDelegate.mainViewController!.tintNavBar()
            appDelegate.hideMenuButton()
        }
        
        
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
        self.lblTitle!.text = "My Friends"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorDarkPurple
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        self.imgPlusIcon = UIImageView()
        self.imgPlusIcon!.image = UIImage(named: "plus-yellow")
        self.imgPlusIcon!.contentMode = .ScaleAspectFit
        self.imgPlusIcon!.userInteractionEnabled = true
        self.imgPlusIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapPlus:")))
        self.view.addSubview(self.imgPlusIcon!)
        
        self.imgSearchIcon = UIImageView()
        self.imgSearchIcon!.image = UIImage(named: "search-blue")
        self.imgSearchIcon!.contentMode = .ScaleAspectFit
        self.view.addSubview(self.imgSearchIcon!)
        
        self.txtSearch = SSSearchField()
        self.txtSearch!.backgroundColor = StorySlam.colorClear
        self.txtSearch!.tintColor = StorySlam.colorBlue
        self.txtSearch!.textColor = StorySlam.colorBlue
        self.txtSearch!.font = UIFont(name: "OpenSans", size: 14)
        self.txtSearch!.returnKeyType = .Go
        self.txtSearch!.delegate = self
        self.txtSearch!.clearButtonMode = .Always
        self.txtSearch!.attributedPlaceholder = NSAttributedString(string:"Search...", attributes:[NSForegroundColorAttributeName: StorySlam.colorBlue])
        self.view.addSubview(self.txtSearch!)
        
        self.totalRowLabel = UILabel()
        self.totalRowLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.totalRowLabel!.text = ""
        self.totalRowLabel!.textColor = StorySlam.colorGray
        self.totalRowLabel!.textAlignment = .Center
        self.scrollView!.addSubview(self.totalRowLabel!)
        
        self.lineSearch = UIView()
        self.lineSearch!.backgroundColor = StorySlam.colorBlue
        self.view.addSubview(self.lineSearch!)
        
        self.searchBackground = UIView()
        self.searchBackground!.backgroundColor = StorySlam.colorLightBlue
        self.view.insertSubview(self.searchBackground!, belowSubview: self.imgSearchIcon!)
        
        self.requestsButton = UIButton()
        self.requestsButton!.layer.cornerRadius = 20
        self.requestsButton!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.requestsButton!.setTitle("0 New Friend Requests", forState: .Normal)
        self.requestsButton!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.requestsButton!.backgroundColor = StorySlam.colorBlue
        self.requestsButton!.addTarget(self, action: Selector("goToFriendRequests:"), forControlEvents: .TouchUpInside)
        
        
        
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
        self.imgPlusIcon!.frame = CGRect(x: self.myWidth!-46, y: 0, width: 24, height: 46)
        
        
        self.imgSearchIcon!.frame = CGRect(x: 30, y: calculateHeight(38), width: 18, height: 38)
        self.txtSearch!.frame = CGRect(x: 30+18, y: calculateHeight(38, add: false), width: self.myWidth!-60-6, height: 38)
        self.lineSearch!.frame = CGRect(x: 18, y: calculateHeight(3), width: self.myWidth!-(18*2), height: 3)
        self.searchBackground!.frame = CGRect(x: 0, y: calculateHeight(41, add: false), width: self.myWidth!, height: 41)
        
        
        
        
        
        
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
        
        for friendRow in self.friendRows {
            friendRow.setupFrames(self.myWidth!-(18*2))
        }
        
        var requestsButtonHeight:CGFloat = 0
        if self.hasRequests {
            requestsButtonHeight = 50
        }
        self.requestsButton!.frame = CGRect(x: 18, y: 41+5, width: self.myWidth!-(18*2), height: 40)
        self.totalRowLabel!.frame = CGRect(x: 18, y: 41+requestsButtonHeight+(SSFriendRow.rowHeight*CGFloat(self.friendRows.count)), width: self.myWidth!-(18*2), height: 15)
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 41+requestsButtonHeight+(SSFriendRow.rowHeight*CGFloat(self.friendRows.count))+15+30)
        
        
        
        
    }
    
    
    override func tapRefresh(sender: AnyObject) {
        
        print("refresh tapped...")
        self.loadFriends()
        appDelegate.mainViewController!.startRefreshButton()
    }
    
    func tapPlus(sender: AnyObject) {
        print("plus tapped...")
        
        self.showAddModal()
            
    }
    
    
    func showAddModal() {
        //tint background
        self.modalIsOpen = true
        self.disableScrollview()
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        self.imgPlusIcon!.userInteractionEnabled = false
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.modalAdd!, atIndex: 15)
            })
        })
    }
    
    func hideAddModal(sender: AnyObject) {
        //untint background
        self.modalIsOpen = false
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        self.imgPlusIcon!.userInteractionEnabled = true
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.modalAdd?.removeFromSuperview()
        })
    }
    
    func enableScrollview() {
        self.scrollView!.userInteractionEnabled = true
        self.txtSearch!.userInteractionEnabled = true
    }
    
    func disableScrollview() {
        self.scrollView!.userInteractionEnabled = false
        self.txtSearch!.userInteractionEnabled = false
    }
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.enableScrollview()
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.disableScrollview()}))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    func loadSuccess() {
        dispatch_async(dispatch_get_main_queue(), {
            self.enableScrollview()
            self.appDelegate.mainViewController!.stopRefreshButton()
        })
        
        if(self.currentUser != nil) {
            
            var requestsButtonHeight:CGFloat = 0
            if self.hasRequests {
                requestsButtonHeight = 50
            }
            
            for (index,friend) in self.currentUser!.friends.enumerate() {
                print("friend \(index): "+friend.username)
                let friendRow = SSFriendRow(frame: CGRect(x: 18, y: 41+requestsButtonHeight+(SSFriendRow.rowHeight*CGFloat(index)), width: self.myWidth!-(18*2), height: SSFriendRow.rowHeight))
                friendRow.initialize(friend, width: self.myWidth!-(18*2))
                friendRow.addGestureRecognizer(UITapGestureRecognizer.init(target: friendRow, action: Selector("goToProfile:")))
                self.friendRows.append(friendRow)
                dispatch_async(dispatch_get_main_queue(), {
                    self.scrollView!.addSubview(friendRow)
                })
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.totalRowLabel!.text = String(self.friendRows.count)  + " result" + (self.friendRows.count != 1 ? "s" : "")
                self.totalRowLabel!.frame = CGRect(x: 18, y: 41+requestsButtonHeight+(SSFriendRow.rowHeight*CGFloat(self.friendRows.count)), width: self.myWidth!-(18*2), height: 15)
            })
            self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 41+requestsButtonHeight+(SSFriendRow.rowHeight*CGFloat(self.friendRows.count))+15+30) //30 is just bottom padding
        }
        
    }
    
    func loadFriends(search: String? = nil) {
        dispatch_async(dispatch_get_main_queue(), {
            self.disableScrollview()
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            
            do {
                
                var query_action = "getFriends"
                var the_parameters = ["username":currentUser!.username!, "token": currentUser!.token!]
                var result_key = "friends"
                
                if(search != nil) {
                    query_action = "searchFriends"
                    the_parameters["user_query"] = search!
                    result_key = "search_result"
                }
                
                
                let opt = try HTTP.POST(StorySlam.actionURL + query_action, parameters: the_parameters)
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            self.currentUser!.friends.removeAll()
                            
                            for friendRow in self.friendRows {
                                dispatch_async(dispatch_get_main_queue(), {
                                    friendRow.removeFromSuperview()
                                })
                            }
                            self.friendRows.removeAll()
                            
                            for (index,subJson):(String, JSON) in result["data"][result_key] {
                                //Do something you want
                                let friend = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                
                                self.currentUser!.friends.append(friend)
                            }
                            
                            StorySlam.setCurrentUser(self.currentUser!)
                            
                            let friend_requests_total = result["data"]["total_requests"].intValue
                            if(friend_requests_total > 0) {
                                self.hasRequests = true
                                if(friend_requests_total == 1) {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.requestsButton!.setTitle("1 Friend Request", forState: .Normal)
                                    })
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.requestsButton!.setTitle("\(friend_requests_total) Friend Requests", forState: .Normal)
                                    })
                                }
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.scrollView!.addSubview(self.requestsButton!)
                                })
                            } else {
                                self.hasRequests = false
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.requestsButton!.removeFromSuperview()
                                })
                            }
                            
                            
                            self.loadSuccess()
                            
                            
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

    
    //MODAL FUNCTIONS BELOW
  
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtSearch { //friends search
            textField.resignFirstResponder()
            if(textField.text != nil) {
                self.loadFriends(textField.text!)
                
            }
            return false
        } else if textField == self.modalTxtSearch { //all users search
            textField.resignFirstResponder()
            if(textField.text != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.searchAllUsers(textField.text!, searchID: self.modalLatestSearchID + 1)
                })

                
            }
            return false
        }
        return true
    }
    
    func searchAllUsers(query_string: String, searchID: Int) {
        //remove user rows from modal
        
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
            let opt = try HTTP.POST(StorySlam.actionURL + "searchUsers", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "user_query": query_string])
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
                            
                            for (index,subJson):(String, JSON) in result["data"]["search_result"] {
                                //Do something you want
                                let friend = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                
                                let friendRow = SSFriendRow(frame: CGRect(x: 0, y: (SSFriendRow.rowHeight*CGFloat(x)), width: self.modalAddWidth-(18*2), height: SSFriendRow.rowHeight))
                                friendRow.initialize(friend, width: self.modalAddWidth, isSearchRow: true)
                                friendRow.addGestureRecognizer(UITapGestureRecognizer.init(target: friendRow, action: Selector("goToProfile:")))
                                self.searchRows.append(friendRow)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.modalScrollView!.addSubview(friendRow)
                                })
                                x = x + 1
                                
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
    
    
    func goToFriendRequests(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSFriendRequestsView())
    }
    
    
}