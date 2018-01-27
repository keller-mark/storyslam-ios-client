//
//  SSSubmitPromptView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/28/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSSubmitPromptView: SSContentView, SSRadioButtonGroupParent, UITextViewDelegate {
    
    var lblTitle: UILabel?
    
    var lblPrompt: UILabel?
    var txtPrompt: UITextView?
    
    var lblGenre: UILabel?
    var btnGenre: UIButton?
    
    var btnSubmit: UIButton?
    
    var modalGenres: UIView?
    var modalIsOpen = false
    var modalGenresLblTitle: UILabel?
    var modalGenresScrollView: UIScrollView?
    var modalGenresRadioButtonGroup: SSRadioButtonGroup?
    var modalGenresChoiceID: Int?
    var modalGenresBtnClose: UIButton?
    var modalGenresActivityIndicator: UIActivityIndicatorView?
    
    var modalGenresHeight: CGFloat = 0
    var modalGenresWidth: CGFloat = 0
    
    var genres = [Genre]()
    var genre_data = [Int:String]()
    
    var selectedGenreID = 0
    
    
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
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Submit Prompt"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorGreen
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        
        self.lblPrompt = UILabel()
        self.lblPrompt!.text = "Enter your prompt:"
        self.lblPrompt!.textAlignment = .Left
        self.lblPrompt!.textColor = StorySlam.colorBlue
        self.lblPrompt!.font = UIFont(name: "OpenSans", size: 12)
        self.scrollView!.addSubview(self.lblPrompt!)
        
        self.txtPrompt = UITextView()
        self.txtPrompt!.layer.cornerRadius = 20
        self.txtPrompt!.font = UIFont(name: "OpenSans", size: 14)
        self.txtPrompt!.backgroundColor = StorySlam.colorWhite
        self.txtPrompt!.returnKeyType = .Default
        self.txtPrompt!.textColor = StorySlam.colorDarkPurple
        self.txtPrompt!.tintColor = StorySlam.colorBlue
        self.txtPrompt!.delegate = self
        self.txtPrompt!.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        self.scrollView!.addSubview(self.txtPrompt!)
        
        
        
        
        
        
        
        
        self.lblGenre = UILabel()
        self.lblGenre!.text = "Choose a genre:"
        self.lblGenre!.textAlignment = .Left
        self.lblGenre!.textColor = StorySlam.colorBlue
        self.lblGenre!.font = UIFont(name: "OpenSans", size: 12)
        self.scrollView!.addSubview(self.lblGenre!)
        
        self.btnGenre = UIButton()
        self.btnGenre!.layer.cornerRadius = 20
        self.btnGenre!.backgroundColor = StorySlam.colorWhite
        self.btnGenre!.titleLabel!.font = UIFont(name: "OpenSans", size: 14)
        self.btnGenre!.setTitle("", forState: .Normal)
        self.btnGenre!.setTitleColor(StorySlam.colorDarkPurple, forState: .Normal)
        self.btnGenre!.addTarget(self, action: Selector("showGenreModal:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnGenre!)
        
        
        self.btnSubmit = UIButton()
        self.btnSubmit!.layer.cornerRadius = 20
        self.btnSubmit!.backgroundColor = StorySlam.colorGreen
        self.btnSubmit!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSubmit!.setTitle("Submit", forState: .Normal)
        self.btnSubmit!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnSubmit!.addTarget(self, action: Selector("submitPrompt:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnSubmit!)
        
        
        //modal below
        self.modalGenres = UIView()
        self.modalGenres!.backgroundColor = StorySlam.colorYellow
        self.modalGenres!.layer.cornerRadius = 20
        
        self.modalGenresActivityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
        
        
        self.modalGenresLblTitle = UILabel()
        self.modalGenresLblTitle!.text = "Choose a genre:"
        self.modalGenresLblTitle!.textAlignment = .Center
        self.modalGenresLblTitle!.textColor = StorySlam.colorBlue
        self.modalGenresLblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.modalGenres!.addSubview(self.modalGenresLblTitle!)
        
        self.modalGenresScrollView = UIScrollView()
        self.modalGenresScrollView!.backgroundColor = StorySlam.colorClear
        self.modalGenres!.addSubview(self.modalGenresScrollView!)
        
        self.modalGenresBtnClose = UIButton()
        self.modalGenresBtnClose!.backgroundColor = StorySlam.colorLightBlue
        self.modalGenresBtnClose!.layer.cornerRadius = 20
        self.modalGenresBtnClose!.setTitle("Close", forState: .Normal)
        self.modalGenresBtnClose!.setTitleColor(StorySlam.colorBlue, forState: .Normal)
        self.modalGenresBtnClose!.addTarget(self, action: Selector("hideGenreModal:"), forControlEvents: .TouchUpInside)
        self.modalGenresBtnClose!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.modalGenres!.addSubview(self.modalGenresBtnClose!)


       
        
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: 0, width: self.myWidth!, height: 46)
        
        self.lblPrompt!.frame = CGRect(x: 32, y: calculateHeight(16, marginTop: 20), width: self.myWidth!-(32*2), height: 16)
        self.txtPrompt!.frame = CGRect(x: 18, y: calculateHeight(80, marginTop: 0), width: self.myWidth!-(18*2), height: 80)
        
        
        self.lblGenre!.frame = CGRect(x: 32, y: calculateHeight(16, marginTop: 30), width: self.myWidth!-(32*2), height: 16)
        self.btnGenre!.frame = CGRect(x: 18, y:  self.calculateHeight(40, marginTop: 0), width: self.myWidth!-(18*2), height: 40)
        
        self.btnSubmit!.frame = CGRect(x: 18, y:  self.calculateHeight(40, marginTop: 30), width: self.myWidth!-(18*2), height: 40)
        
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false))
        
        // modal below
        self.modalGenresHeight = self.myHeight! - appDelegate.navBarHeight
        self.modalGenresWidth = self.myWidth!*0.8
        
        self.modalGenres!.frame = CGRect(x: (self.myWidth!-self.modalGenresWidth)/2, y: 0, width: self.modalGenresWidth, height: self.modalGenresHeight)
        self.modalGenresBtnClose!.frame = CGRect(x: 15, y: self.modalGenresHeight - 40 - 15, width: self.modalGenresWidth - 30, height: 40)
        self.modalGenresLblTitle!.frame = CGRect(x: 15, y: 15, width: self.modalGenresWidth - 30, height: 40)
        self.modalGenresScrollView!.frame = CGRect(x: 0, y: 15+40+5, width: self.modalGenresWidth, height: self.modalGenresHeight-40-15-15-40-5-5)
        self.modalGenresActivityIndicator!.frame = CGRect(x: 0, y: 15+40+5, width: self.modalGenresWidth, height: self.modalGenresHeight-40-15-15-40-5-5)
        
        if(self.modalGenresRadioButtonGroup != nil) {
            dispatch_async(dispatch_get_main_queue(), {
            self.modalGenresRadioButtonGroup!.setupFrames(self.modalGenresWidth)
                dispatch_async(dispatch_get_main_queue(), {
            self.modalGenresRadioButtonGroup!.frame = CGRect(x: 0, y: 0, width: self.modalGenresWidth, height: self.modalGenresRadioButtonGroup!.totalHeight)
            self.modalGenresScrollView!.contentSize = CGSizeMake(self.modalGenresWidth, self.modalGenresRadioButtonGroup!.totalHeight+20)
                })
            })
            
        }
        
    }
    
    
    func chooseRadioButton(group: SSRadioButtonGroup, rowID: Int, rowName: String) {
        print("radio button chosen \(rowID)")
        //self.hideGenreModal(self)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.selectedGenreID = rowID
        self.btnGenre!.setTitle(rowName, forState: .Normal)
        })
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true

    
    }
    
    func showGenreModal(sender: AnyObject) {
        //tint background
        self.modalIsOpen = true
        self.txtPrompt!.userInteractionEnabled = false
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.tintNavBar()
            self.appDelegate.hideMenuButton()
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.loadGenres()
                dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.modalGenres!, atIndex: 15)
                self.modalGenres!.addSubview(self.modalGenresActivityIndicator!)
                self.modalGenresActivityIndicator!.startAnimating()
                })
                
            })
        })
    }
    
    func hideGenreModal(sender: AnyObject) {
        //untint background
        self.modalIsOpen = false
        self.txtPrompt!.userInteractionEnabled = true
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.untintNavBar()
            self.hideTintLayer()
            
            self.appDelegate.showMenuButton()
            self.modalGenres!.removeFromSuperview()
        })
    }
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    
    func loadSuccess() {
        dispatch_async(dispatch_get_main_queue(), {
            self.modalGenresActivityIndicator!.stopAnimating()
            self.modalGenresActivityIndicator!.removeFromSuperview()
        })
    }
    
    func loadGenres() {
        if(self.modalGenresRadioButtonGroup != nil) {
            dispatch_async(dispatch_get_main_queue(), {
            self.modalGenresRadioButtonGroup!.removeFromSuperview()
            })
        }
        self.currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            
            do {
                
                
                let opt = try HTTP.POST(StorySlam.actionURL + "getGenres", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
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
                            
                            self.loadSuccess()
                            self.genres.removeAll()
                            self.genre_data.removeAll()
                            for (index,subJson):(String, JSON) in result["data"]["genres"] {
                                //Do something you want
                                let genre = Genre(id: subJson["id"].intValue, name: subJson["name"].stringValue)
                                self.genres.append(genre)
                                self.genre_data[genre.id] = genre.name
                                
                            }
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.modalGenresRadioButtonGroup = SSRadioButtonGroup()
                                dispatch_async(dispatch_get_main_queue(), {
                                self.modalGenresRadioButtonGroup!.initialize(self.genre_data, width: self.modalGenresWidth, parent: self)
                                self.modalGenresRadioButtonGroup!.setupFrames(self.modalGenresWidth)
                                self.modalGenresScrollView!.addSubview(self.modalGenresRadioButtonGroup!)
                                     dispatch_async(dispatch_get_main_queue(), {
                                        self.setupFrames()
                                    })
                                })
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

    func submitPrompt(sender: AnyObject) {
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.tintNavBar()
                self.appDelegate.hideMenuButton()
                self.showLoadingOverlay()
            })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            
            print("selected genre: \(self.selectedGenreID)")
            print("prompt text: \(self.txtPrompt!.text)")
            
            if(self.selectedGenreID != 0 && self.txtPrompt!.text != nil) {
            do {
                
                
                let opt = try HTTP.POST(StorySlam.actionURL + "submitPrompt", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "genreID" : String(self.selectedGenreID), "text" : self.txtPrompt!.text!])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.afterSubmitPrompt()
                        self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            dispatch_async(dispatch_get_main_queue(), {
                            self.txtPrompt!.text = ""
                            self.selectedGenreID = 0
                            self.btnGenre!.setTitle("", forState: .Normal)
                                })
                            
                            self.afterSubmitPrompt()
                            self.loadError(result["message"].stringValue, theMessage: " ")
                            
                            
                        } else {
                            self.afterSubmitPrompt()
                            self.loadError(result["message"].stringValue)
                            
                        }
                    } else {
                        self.afterSubmitPrompt()
                        self.loadError("An error occurred.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.afterSubmitPrompt()
                self.loadError("An error occurred.")
            }
            
            } else {
                self.afterSubmitPrompt()
                self.loadError("All fields required.")
            }
            
            
        } else {
            self.afterSubmitPrompt()
            self.appDelegate.mainViewController!.logOut()
        }
    }
    
    func afterSubmitPrompt() {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.untintNavBar()
            self.appDelegate.showMenuButton()
            self.hideLoadingOverlay()
        })
    }
    
    
    
}