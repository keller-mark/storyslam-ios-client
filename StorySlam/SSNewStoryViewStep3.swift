//
//  SSNewStoryViewStep3.swift
//  StorySlam
//
//  Created by Mark Keller on 7/26/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSNewStoryViewStep3: SSContentView, UITextFieldDelegate {
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    var lblStepTitle: UILabel?
    
    
    var lblEnterTitle: UILabel?
    var txtEnterTitle: SSTextField?
    
    var lblSpin: UILabel?
    var spinnerTriangle: UIImageView?
    
    var spinner: UIView?
    var spinnerImage: UIImageView?
    var spinnerGenreLabels = [SSGenreLabel]()
    
    var spinnerAngle: CGFloat = 51.42857142
    
    var lblPrompt: UILabel?
    var lblPromptWrapper: UIView?
    
    var btnNext: UIButton?
    
    var btnNextEnabled: Bool = false
    
    var isRandom: Bool = false
    
    var didSpin: Bool = false
    
    var randomNum: Int = 0
    var firstSetupFrames = true
    
    var spinAngle: CGFloat?
    
    var spinTransform: CGAffineTransform?
    
    var prompt: Prompt?
    var friend_ids = [Int?]()
    
    
    var currentUser: CurrentUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupViews()
        self.setupFrames()
    }
    
    func initialize(friend_ids: [Int?], prompt: Prompt, other_genres: [Genre], random: Bool = false) {
        self.isRandom = random
        
        self.prompt = prompt
        self.friend_ids = friend_ids
        
        let promptGenreLabel = SSGenreLabel()
        promptGenreLabel.genre = prompt.genre
        
        self.randomNum = prompt.genre.id % 7
        
        let deg2rad: CGFloat = CGFloat(M_PI/180.0)
        
        let turns: CGFloat = 360.0*10.0
        let custom_turn: CGFloat = CGFloat(CGFloat(self.randomNum)*self.spinnerAngle)
        let full_turn: CGFloat = turns+custom_turn
        
        print("randomNum: \(self.randomNum)")
        print("customTurn: \(custom_turn)")
        
            self.spinAngle = abs(CGFloat(full_turn*deg2rad))
            self.spinTransform = CGAffineTransformMakeRotation(self.spinAngle!)
            print("set spin transform..")
        
        
        
        if(self.randomNum == 0) {
            self.spinnerGenreLabels.append(promptGenreLabel)
        }
        
    
        for i in 0..<other_genres.count {
            
            let genreLabel = SSGenreLabel()
            genreLabel.genre = other_genres[i]
            self.spinnerGenreLabels.append(genreLabel)
            
            if(self.randomNum == i+1) {
                self.spinnerGenreLabels.append(promptGenreLabel)
            }
        }
        
        if(self.randomNum == 7) {
            self.spinnerGenreLabels.append(promptGenreLabel)
        }
        
    
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
        if(isRandom) {
            self.lblStepTitle!.text = "2. Create"
        } else {
            self.lblStepTitle!.text = "3. Create"
        }
        self.lblStepTitle!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStepTitle!.textColor = StorySlam.colorBlue
        self.lblStepTitle!.textAlignment = .Left
        self.scrollView!.addSubview(self.lblStepTitle!)
        
        self.lblEnterTitle = UILabel()
        self.lblEnterTitle!.text = "Enter a title:"
        self.lblEnterTitle!.textAlignment = .Left
        self.lblEnterTitle!.textColor = StorySlam.colorBlue
        self.lblEnterTitle!.font = UIFont(name: "OpenSans", size: 12)
        self.scrollView!.addSubview(self.lblEnterTitle!)
        
        self.txtEnterTitle = SSTextField()
        self.txtEnterTitle!.layer.cornerRadius = 20
        self.txtEnterTitle!.returnKeyType = .Done
        self.txtEnterTitle!.delegate = self
        self.txtEnterTitle!.backgroundColor = StorySlam.colorWhite
        self.txtEnterTitle!.alpha = 1.0
        self.txtEnterTitle!.tintColor = StorySlam.colorBlue
        self.txtEnterTitle!.textColor = StorySlam.colorDarkPurple
        self.txtEnterTitle!.font = UIFont(name: "OpenSans", size: 14)
        self.scrollView!.addSubview(self.txtEnterTitle!)
        
        
        
        
        self.spinner = UIView()
        self.spinner!.backgroundColor = StorySlam.colorClear
        self.spinner!.autoresizesSubviews = false
        self.spinner!.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: Selector("dragSpinner:")))
        self.scrollView!.addSubview(self.spinner!)
        
        self.lblSpin = UILabel()
        self.lblSpin!.text = "Spin to select\na prompt:"
        self.lblSpin!.font = UIFont(name: "OpenSans", size: 12)
        self.lblSpin!.textAlignment = .Left
        self.lblSpin!.textColor = StorySlam.colorBlue
        self.lblSpin!.numberOfLines = 0
        self.scrollView!.addSubview(self.lblSpin!)
    
        
        
        self.spinnerTriangle = UIImageView()
        self.spinnerTriangle!.image = UIImage(named: "spinner_triangle-dark_purple")
        self.spinnerTriangle!.contentMode = .ScaleAspectFit
        self.spinnerTriangle!.alpha = 0.0
        self.scrollView!.addSubview(self.spinnerTriangle!)
        
        self.spinnerImage = UIImageView()
        self.spinnerImage!.image = UIImage(named: "wheel")
        self.spinnerImage!.contentMode = .ScaleAspectFit
        
        self.spinner!.addSubview(self.spinnerImage!)
        
        for i in 0..<self.spinnerGenreLabels.count {
            
            self.spinnerGenreLabels[i].spinnerWrapper = UIView()
            self.spinnerGenreLabels[i].spinnerWrapper!.backgroundColor = StorySlam.colorClear
            self.spinner!.addSubview(self.spinnerGenreLabels[i].spinnerWrapper!)
            
            
            
            self.spinnerGenreLabels[i].text = self.spinnerGenreLabels[i].genre!.name
            self.spinnerGenreLabels[i].font = UIFont(name: "OpenSans", size: 12)
            self.spinnerGenreLabels[i].textAlignment = .Center
            self.spinnerGenreLabels[i].textColor = StorySlam.colorWhite
            self.spinnerGenreLabels[i].layer.masksToBounds = false
            self.spinnerGenreLabels[i].layer.shadowColor = UIColor.blackColor().CGColor
            self.spinnerGenreLabels[i].layer.shadowOffset = CGSizeMake(1,1)
            self.spinnerGenreLabels[i].layer.shadowRadius = 8
            self.spinnerGenreLabels[i].layer.shadowOpacity = 0.7
         
      
            self.spinnerGenreLabels[i].spinnerWrapper!.addSubview(self.spinnerGenreLabels[i])
            
        
        }
        
        
        self.lblPromptWrapper = UIView()
        self.lblPromptWrapper!.backgroundColor = StorySlam.colorWhite
        self.lblPromptWrapper!.layer.cornerRadius = 20
        self.lblPromptWrapper!.alpha = 0.0
        self.scrollView!.addSubview(self.lblPromptWrapper!)
        
        self.lblPrompt = UILabel()
        self.lblPrompt!.text = self.prompt!.text
        self.lblPrompt!.font = UIFont(name: "OpenSans", size: 12)
        self.lblPrompt!.textAlignment = .Left
        self.lblPrompt!.textColor = StorySlam.colorDarkPurple
        self.lblPrompt!.numberOfLines = 0
        self.lblPromptWrapper!.addSubview(self.lblPrompt!)
        
        
        
        self.btnNext = UIButton()
        self.btnNext!.layer.cornerRadius = 20
        self.btnNext!.backgroundColor = StorySlam.colorGold
        self.btnNext!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnNext!.setTitle("Begin", forState: .Normal)
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
        
        self.lblEnterTitle!.frame = CGRect(x: 32, y: 10+32+10, width: self.myWidth!-(32*2), height: 14)
        self.txtEnterTitle!.frame = CGRect(x: 18, y: 10+32+10+14, width: self.myWidth!-(18*2), height: 40)
        
        //let spinnerSize = (self.myWidth! < self.myHeight! ? self.myWidth! : self.myHeight!)-74
        
        let spinnerSize: CGFloat = 320
        
        self.spinner!.frame = CGRect(x: (self.myWidth!-spinnerSize)/2, y: 10+32+10+14+40+26, width: spinnerSize, height: spinnerSize)
        self.spinner!.layer.cornerRadius = spinnerSize/2
        self.spinnerImage!.frame = CGRect(x: 0, y: 0, width: spinnerSize, height: spinnerSize)
        self.spinnerTriangle!.frame = CGRect(x: (self.myWidth!-40)/2, y: 10+32+10+14+40+22, width: 40, height: 40)
        
        
        self.spinner!.layer.anchorPoint = CGPointMake(0.5,0.5)
        
        let lblTextSize = self.lblSpin!.sizeThatFits(CGSizeMake(76, CGFloat.max))
        self.lblSpin!.frame = CGRect(x: 32, y: 10+32+10+14+40+22, width: 76, height: lblTextSize.height)
        
        let lblPromptSize = self.lblPrompt!.sizeThatFits(CGSizeMake(self.myWidth!-(18*4), CGFloat.max))
        
        self.lblPromptWrapper!.frame = CGRect(x: 18, y: 10+32+10+14+40+26+spinnerSize-(lblPromptSize.height+40), width: self.myWidth!-(18*2), height: lblPromptSize.height+40)
        self.lblPrompt!.frame = CGRect(x: 18, y: 20, width: lblPromptSize.width, height: lblPromptSize.height)
        
        self.btnNext!.frame = CGRect(x: 16, y: 10+32+10+14+40+26+spinnerSize+10+30, width: self.myWidth!-(16*2), height: 40)
        
        
            dispatch_async(dispatch_get_main_queue(), {
                for i in 0..<self.spinnerGenreLabels.count {
                    let lblSpinnerSize = self.spinnerGenreLabels[i].sizeThatFits(CGSizeMake(CGFloat.max, 16))
                    
                    self.spinnerGenreLabels[i].frame = CGRect(x: (spinnerSize-lblSpinnerSize.width)/2, y: spinnerSize*0.1, width: lblSpinnerSize.width, height: 16)
                    self.spinnerGenreLabels[i].spinnerWrapper!.frame = CGRect(x: 0, y: 0, width: spinnerSize, height: spinnerSize)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let spinnerAngleRadians = (Double(self.spinnerAngle) * Double(i) / 180) * M_PI
                        
                        let transform = CGAffineTransformMakeRotation(CGFloat(-spinnerAngleRadians))
                        
                        
                        
                        self.spinnerGenreLabels[i].spinnerWrapper!.layer.anchorPoint = CGPointMake(0.5,0.5)
                        if(self.firstSetupFrames) {
                            self.spinnerGenreLabels[i].spinnerWrapper!.transform = transform
                            dispatch_async(dispatch_get_main_queue(), {
                                self.firstSetupFrames = false
                            })
                        }
                    
                        
                            
                     
                    })
                
                }
            })
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!,10+32+10+14+40+26+spinnerSize+10+30+40+20)
        
        
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
                self.btnNext!.userInteractionEnabled = true
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.btnNext!.backgroundColor = StorySlam.colorBlue
                    }) { (finished) -> Void in
                        self.btnNextEnabled = true
                }
            })
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
        print("finishing...")
        dispatch_async(dispatch_get_main_queue(), {
            self.beginStory()
        })
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtEnterTitle { //all users search
            textField.resignFirstResponder()
            self.checkNext()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.unrotateSpinnerLabels()
        
        setupFrames()
    }
    
    func unrotateSpinnerLabels() {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let spinnerSize: CGFloat = 320
            
            for i in 0..<self.spinnerGenreLabels.count {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinnerGenreLabels[i].spinnerWrapper!.alpha = 0.0
                    
                    
                    
                    self.spinnerGenreLabels[i].spinnerWrapper!.transform = CGAffineTransformIdentity
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        self.spinnerGenreLabels[i].spinnerWrapper!.transform = CGAffineTransformIdentity
                        dispatch_async(dispatch_get_main_queue(), {
                            let lblSpinnerSize = self.spinnerGenreLabels[i].sizeThatFits(CGSizeMake(CGFloat.max, 16))
                            
                            self.spinnerGenreLabels[i].frame = CGRect(x: (spinnerSize-lblSpinnerSize.width)/2, y: spinnerSize*0.1, width: lblSpinnerSize.width, height: 16)
                            self.spinnerGenreLabels[i].spinnerWrapper!.frame = CGRect(x: 0, y: 0, width: spinnerSize, height: spinnerSize)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                let spinnerAngleRadians = (Double(self.spinnerAngle) * Double(i) / 180) * M_PI
                                
                                let transform = CGAffineTransformMakeRotation(CGFloat(-spinnerAngleRadians))
                                
                                self.spinnerGenreLabels[i].spinnerWrapper!.layer.anchorPoint = CGPointMake(0.5,0.5)
                                
                                    self.spinnerGenreLabels[i].spinnerWrapper!.transform = transform
                                    self.spinnerGenreLabels[i].spinnerWrapper!.alpha = 1.0
                                
                                
                                
                                
                                
                            })

                        })
                    })
                    
                    
                    
                })
                
            }
        })

    }
    

    
    func dragSpinner(gestureRecognizer: UIPanGestureRecognizer) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
                
                if(!self.didSpin) {
                    print("spinning...\(self.spinAngle)")
                    
                    self.spinner!.layer.anchorPoint = CGPointMake(0.5,0.5)
                   
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({
                        self.showPrompt()
                    })

                    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                    
                    rotationAnimation.fromValue = 0.0
                    rotationAnimation.toValue = self.spinAngle!
                    rotationAnimation.duration = 1.5
                    rotationAnimation.cumulative = true
                    rotationAnimation.repeatCount = 1.0
                    rotationAnimation.removedOnCompletion = false
                    rotationAnimation.fillMode = kCAFillModeForwards
                    rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                    //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                    
                    self.spinner!.layer.addAnimation(rotationAnimation, forKey: nil)
                    
                    self.didSpin = true
                    CATransaction.commit()
                    
                    UIView.animateWithDuration(0.3, delay: 1.4, options: [], animations: { () -> Void in
                        self.spinnerTriangle!.alpha = 1.0
                        }) { (finished) -> Void in
                            
                    }
                    
                    //remove gesture recognizer
                    self.spinner!.removeGestureRecognizer(gestureRecognizer)
                    
                    
                }
                
            }
        })
    }
    
    func showPrompt() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.lblPromptWrapper!.alpha = 1.0
        })
        self.checkNext()
    }
    
    func checkNext() {
        if(self.txtEnterTitle!.text != nil && self.txtEnterTitle!.text!.characters.count > 2 && self.didSpin) {
            let trimmedString = self.txtEnterTitle!.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            
            if(trimmedString.characters.count > 2) {
                self.enableNextButton()
                return
            }
        }
        self.disableNextButton()
    }

    func beginStory() {
        dispatch_async(dispatch_get_main_queue(), {
            self.showLoadingOverlay()
            self.appDelegate.mainViewController!.tintNavBar()
            self.appDelegate.hideMenuButton()
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        let trimmedTitle = self.txtEnterTitle!.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        var the_parameters = ["username":currentUser!.username!, "token": currentUser!.token!]
        
        the_parameters["random"] = (self.isRandom ? "1" : "0")
        
        the_parameters["prompt_id"] = String(self.prompt!.id)
        the_parameters["title"] = trimmedTitle
        
        var x = 1
        for i in 0..<self.friend_ids.count {
            if(self.friend_ids[i] != nil && self.friend_ids[i]! > 0) {
                x = x + 1
                the_parameters["player\(x)_id"] = String(self.friend_ids[i]!)
            }
        }
        
        do {
            
            let opt = try HTTP.POST(StorySlam.actionURL + "beginNewStory", parameters: the_parameters)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    self.afterBeginStory()
                    self.loadError("An error occurred.", theMessage: "Please check your connection and try again.")
                    
                    return //also notify app of failure as needed
                }
                
                print(response.description)
                
                let result = JSON(data: response.data)
                
                
                
                if(result["message"].string != nil) {
                    if(result["success"].boolValue == true) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.afterBeginStory()
                            self.appDelegate.mainViewController!.setHomeContentView(SSHomeView())
                        })
                        
                        
                    } else {
                        self.afterBeginStory()
                        self.loadError(result["message"].stringValue)
                    }
                } else {
                    self.afterBeginStory()
                    self.loadError("An error occurred.")
                    
                }
                
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            self.afterBeginStory()
            self.loadError("An error occurred.")
        }

    }
    
    func afterBeginStory() {
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
            self.presentViewController(alert, animated: true, completion: {() in self.unrotateSpinnerLabels() })
            
        })
        
    }
    
    
}