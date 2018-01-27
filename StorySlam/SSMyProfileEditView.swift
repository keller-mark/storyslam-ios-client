//
//  SSMyProfileEditView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/28/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSMyProfileEditView: SSContentView, UITextFieldDelegate {
    
    //main views
    
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    var imgEditIcon: UIImageView?
    
    var lblSubtitle: UILabel?
    
    var lblFirstname: UILabel?
    var txtFirstname: SSTextField?
    
    var lblLastname: UILabel?
    var txtLastname: SSTextField?
    
    var lblUsername: UILabel?
    var txtUsername: SSTextField?
    
    var lblEmail: UILabel?
    var txtEmail: SSTextField?
    
    
    var btnChangePassword: UIButton?
    
    var lblFacebookInfo: UILabel?
    
    
    var btnDone: UIButton?
    var btnDelete: UIButton?
    
    var profileEditViewFrame: CGRect?
    var isFromFacebook = false
    
    
    
    var totalRowLabel: UILabel?
    
    var editMode: Bool = false
    
    var currentUser: CurrentUser?
    
    var modalChangePassword: UIView?
    var modalChangePasswordLblTitle: UILabel?
    var modalChangePasswordLblCurrent: UILabel?
    var modalChangePasswordTxtCurrent: SSTextField?
    var modalChangePasswordLblNew: UILabel?
    var modalChangePasswordTxtNew: SSTextField?
    var modalChangePasswordLblNewRepeat: UILabel?
    var modalChangePasswordTxtNewRepeat: SSTextField?
    var modalChangePasswordBtnSubmit: UIButton?
    var modalChangePasswordBtnCancel: UIButton?
    var modalIsOpen = false
    var modalChangePasswordHeight: CGFloat = 0
    var modalChangePasswordWidth: CGFloat = 0
    var modalChangePasswordScrollView: UIScrollView?
    
    
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
        self.imgEditIcon!.image = UIImage(named: "x-yellow")
        self.imgEditIcon!.contentMode = .ScaleAspectFit
        self.imgEditIcon!.userInteractionEnabled = true
        self.imgEditIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapClose:")))
        self.view.addSubview(self.imgEditIcon!)
        
        
        self.lblSubtitle = UILabel()
        self.lblSubtitle!.text = "Edit"
        self.lblSubtitle!.font = UIFont(name: "OpenSans", size: 18)
        self.lblSubtitle!.textColor = StorySlam.colorBlue
        self.lblSubtitle!.textAlignment = .Center
        self.scrollView!.addSubview(self.lblSubtitle!)

        
        
        self.lblFirstname = UILabel()
        self.lblFirstname!.text = "First Name"
        self.lblFirstname!.font = UIFont(name: "OpenSans", size: 12)
        self.lblFirstname!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblFirstname!)
        
        
        
        self.lblLastname = UILabel()
        self.lblLastname!.text = "Last Name"
        self.lblLastname!.font = UIFont(name: "OpenSans", size: 12)
        self.lblLastname!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblLastname!)
        
        
        self.lblUsername = UILabel()
        self.lblUsername!.text = "Username"
        self.lblUsername!.font = UIFont(name: "OpenSans", size: 12)
        self.lblUsername!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblUsername!)
        
        self.lblEmail = UILabel()
        self.lblEmail!.text = "Email"
        self.lblEmail!.font = UIFont(name: "OpenSans", size: 12)
        self.lblEmail!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblEmail!)
        
        
        
        self.txtFirstname = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtFirstname!.backgroundColor = StorySlam.colorWhite
        self.txtFirstname!.tintColor = StorySlam.colorDarkPurple
        self.txtFirstname!.alpha = CGFloat(0.7)
        self.txtFirstname!.font = UIFont(name: "OpenSans", size: 14)
        self.txtFirstname!.autocorrectionType = .No
        self.txtFirstname!.autocapitalizationType = .Words
        self.txtFirstname!.spellCheckingType = .No
        self.txtFirstname!.delegate = self
        self.txtFirstname!.tag = 0
        self.txtFirstname!.returnKeyType = .Done
        self.txtFirstname!.text = self.currentUser!.firstname!
        self.scrollView!.addSubview(self.txtFirstname!)
        
        self.txtLastname = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtLastname!.backgroundColor = StorySlam.colorWhite
        self.txtLastname!.tintColor = StorySlam.colorDarkPurple
        self.txtLastname!.alpha = CGFloat(0.7)
        self.txtLastname!.font = UIFont(name: "OpenSans", size: 14)
        self.txtLastname!.autocorrectionType = .No
        self.txtLastname!.autocapitalizationType = .Words
        self.txtLastname!.spellCheckingType = .No
        self.txtLastname!.delegate = self
        self.txtLastname!.tag = 1
        self.txtLastname!.returnKeyType = .Done
        self.txtLastname!.text = self.currentUser!.lastname!
        self.scrollView!.addSubview(self.txtLastname!)
        
        
        
        self.txtUsername = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtUsername!.backgroundColor = StorySlam.colorWhite
        self.txtUsername!.tintColor = StorySlam.colorDarkPurple
        self.txtUsername!.alpha = CGFloat(0.7)
        self.txtUsername!.font = UIFont(name: "OpenSans", size: 14)
        self.txtUsername!.autocorrectionType = .No
        self.txtUsername!.autocapitalizationType = .None
        self.txtUsername!.spellCheckingType = .No
        self.txtUsername!.delegate = self
        self.txtUsername!.tag = 2
        self.txtUsername!.returnKeyType = .Done
        self.txtUsername!.text = self.currentUser!.username!
        self.scrollView!.addSubview(self.txtUsername!)
        
        
        
        
        self.txtEmail = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtEmail!.backgroundColor = StorySlam.colorWhite
        self.txtEmail!.tintColor = StorySlam.colorDarkPurple
        self.txtEmail!.alpha = CGFloat(0.7)
        self.txtEmail!.font = UIFont(name: "OpenSans", size: 14)
        self.txtEmail!.autocorrectionType = .No
        self.txtEmail!.autocapitalizationType = .None
        self.txtEmail!.spellCheckingType = .No
        self.txtEmail!.keyboardType = .EmailAddress
        self.txtEmail!.delegate = self
        self.txtEmail!.tag = 3
        self.txtEmail!.returnKeyType = .Done
        if(self.currentUser!.email != nil) {
            self.txtEmail!.text = self.currentUser!.email!
        }
        
        self.scrollView!.addSubview(self.txtEmail!)

        
        
        
        
        self.btnDone = UIButton()
        self.btnDone!.layer.cornerRadius = 20
        self.btnDone!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnDone!.setTitle("Save", forState: .Normal)
        self.btnDone!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnDone!.backgroundColor = StorySlam.colorGreen
        self.btnDone!.addTarget(self, action: Selector("saveProfile:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnDone!)
        
        
        self.btnChangePassword = UIButton()
        self.btnChangePassword!.layer.cornerRadius = 20
        self.btnChangePassword!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnChangePassword!.setTitle("Change Password", forState: .Normal)
        self.btnChangePassword!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnChangePassword!.backgroundColor = StorySlam.colorBlue
        self.btnChangePassword!.addTarget(self, action: Selector("showChangePasswordModal:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnChangePassword!)
        
        self.btnDelete = UIButton()
        self.btnDelete!.layer.cornerRadius = 20
        self.btnDelete!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnDelete!.setTitle("Delete My Account", forState: .Normal)
        self.btnDelete!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnDelete!.backgroundColor = StorySlam.colorOrange
        self.btnDelete!.addTarget(self, action: Selector("deleteProfile:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnDelete!)
        
       
        
        
        
        self.totalRowLabel = UILabel()
        self.totalRowLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.totalRowLabel!.text = ""
        self.totalRowLabel!.textColor = StorySlam.colorGray
        self.totalRowLabel!.textAlignment = .Center
        self.scrollView!.addSubview(self.totalRowLabel!)
        
        
        //CHANGE PASSWORD MODAL BELOW
        
        self.modalChangePassword = UIView()
        self.modalChangePassword!.backgroundColor = StorySlam.colorLightBlue
        self.modalChangePassword!.layer.cornerRadius = 20
        
        self.modalChangePasswordScrollView = UIScrollView()
        self.modalChangePasswordScrollView!.backgroundColor = StorySlam.colorClear
        self.modalChangePassword!.addSubview(self.modalChangePasswordScrollView!)
        
        
        self.modalChangePasswordLblTitle = UILabel()
        self.modalChangePasswordLblTitle!.text = "Change Password"
        self.modalChangePasswordLblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.modalChangePasswordLblTitle!.textColor = StorySlam.colorBlue
        self.modalChangePasswordLblTitle!.textAlignment = .Center
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordLblTitle!)
        
        self.modalChangePasswordLblCurrent = UILabel()
        self.modalChangePasswordLblCurrent!.text = "Current Password"
        self.modalChangePasswordLblCurrent!.font = UIFont(name: "OpenSans", size: 12)
        self.modalChangePasswordLblCurrent!.textColor = StorySlam.colorBlue
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordLblCurrent!)

        
        self.modalChangePasswordTxtCurrent = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.modalChangePasswordTxtCurrent!.backgroundColor = StorySlam.colorWhite
        self.modalChangePasswordTxtCurrent!.tintColor = StorySlam.colorDarkPurple
        self.modalChangePasswordTxtCurrent!.alpha = CGFloat(0.7)
        self.modalChangePasswordTxtCurrent!.font = UIFont(name: "OpenSans", size: 14)
        self.modalChangePasswordTxtCurrent!.autocorrectionType = .No
        self.modalChangePasswordTxtCurrent!.autocapitalizationType = .None
        self.modalChangePasswordTxtCurrent!.spellCheckingType = .No
        self.modalChangePasswordTxtCurrent!.secureTextEntry = true
        self.modalChangePasswordTxtCurrent!.delegate = self
        self.modalChangePasswordTxtCurrent!.tag = 10
        self.modalChangePasswordTxtCurrent!.returnKeyType = .Default
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordTxtCurrent!)
        
        self.modalChangePasswordLblNew = UILabel()
        self.modalChangePasswordLblNew!.text = "New Password"
        self.modalChangePasswordLblNew!.font = UIFont(name: "OpenSans", size: 12)
        self.modalChangePasswordLblNew!.textColor = StorySlam.colorBlue
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordLblNew!)
        
        
        self.modalChangePasswordTxtNew = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.modalChangePasswordTxtNew!.backgroundColor = StorySlam.colorWhite
        self.modalChangePasswordTxtNew!.tintColor = StorySlam.colorDarkPurple
        self.modalChangePasswordTxtNew!.alpha = CGFloat(0.7)
        self.modalChangePasswordTxtNew!.font = UIFont(name: "OpenSans", size: 14)
        self.modalChangePasswordTxtNew!.autocorrectionType = .No
        self.modalChangePasswordTxtNew!.autocapitalizationType = .None
        self.modalChangePasswordTxtNew!.spellCheckingType = .No
        self.modalChangePasswordTxtNew!.secureTextEntry = true
        self.modalChangePasswordTxtNew!.delegate = self
        self.modalChangePasswordTxtNew!.tag = 11
        self.modalChangePasswordTxtNew!.returnKeyType = .Default
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordTxtNew!)
        
        self.modalChangePasswordLblNewRepeat = UILabel()
        self.modalChangePasswordLblNewRepeat!.text = "New Password, again"
        self.modalChangePasswordLblNewRepeat!.font = UIFont(name: "OpenSans", size: 12)
        self.modalChangePasswordLblNewRepeat!.textColor = StorySlam.colorBlue
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordLblNewRepeat!)
        
        
        self.modalChangePasswordTxtNewRepeat = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.modalChangePasswordTxtNewRepeat!.backgroundColor = StorySlam.colorWhite
        self.modalChangePasswordTxtNewRepeat!.tintColor = StorySlam.colorDarkPurple
        self.modalChangePasswordTxtNewRepeat!.alpha = CGFloat(0.7)
        self.modalChangePasswordTxtNewRepeat!.font = UIFont(name: "OpenSans", size: 14)
        self.modalChangePasswordTxtNewRepeat!.autocorrectionType = .No
        self.modalChangePasswordTxtNewRepeat!.autocapitalizationType = .None
        self.modalChangePasswordTxtNewRepeat!.spellCheckingType = .No
        self.modalChangePasswordTxtNewRepeat!.secureTextEntry = true
        self.modalChangePasswordTxtNewRepeat!.delegate = self
        self.modalChangePasswordTxtNewRepeat!.tag = 12
        self.modalChangePasswordTxtNewRepeat!.returnKeyType = .Default
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordTxtNewRepeat!)

        
        self.modalChangePasswordBtnCancel = UIButton()
        self.modalChangePasswordBtnCancel!.backgroundColor = StorySlam.colorWhite
        self.modalChangePasswordBtnCancel!.layer.cornerRadius = 20
        self.modalChangePasswordBtnCancel!.setTitle("Close", forState: .Normal)
        self.modalChangePasswordBtnCancel!.setTitleColor(StorySlam.colorOrange, forState: .Normal)
        self.modalChangePasswordBtnCancel!.addTarget(self, action: Selector("hideChangePasswordModal:"), forControlEvents: .TouchUpInside)
        self.modalChangePasswordBtnCancel!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordBtnCancel!)
        
        self.modalChangePasswordBtnSubmit = UIButton()
        self.modalChangePasswordBtnSubmit!.backgroundColor = StorySlam.colorGreen
        self.modalChangePasswordBtnSubmit!.layer.cornerRadius = 20
        self.modalChangePasswordBtnSubmit!.setTitle("Save", forState: .Normal)
        self.modalChangePasswordBtnSubmit!.setTitle("Saving...", forState: .Disabled)
        self.modalChangePasswordBtnSubmit!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.modalChangePasswordBtnSubmit!.addTarget(self, action: Selector("changePasswordSubmit:"), forControlEvents: .TouchUpInside)
        self.modalChangePasswordBtnSubmit!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.modalChangePasswordScrollView!.addSubview(self.modalChangePasswordBtnSubmit!)
        
        
        
        
        
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: 0, width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        self.imgEditIcon!.frame = CGRect(x: self.myWidth!-46, y: 0, width: 24, height: 46)
        
        self.lblSubtitle!.frame = CGRect(x: 18, y: calculateHeight(40, marginTop: 5), width: self.myWidth!-(18*2), height: 40)
        
        self.lblFirstname!.frame = CGRect(x: 32, y: calculateHeight(14, marginTop: 5), width: self.myWidth!-(32*2), height: 14)
        self.txtFirstname!.frame = CGRect(x: 18, y: calculateHeight(40), width: self.myWidth!-(18*2), height: 40)
        
        self.lblLastname!.frame = CGRect(x: 32, y: calculateHeight(14, marginTop: 10), width: self.myWidth!-(32*2), height: 14)
        self.txtLastname!.frame = CGRect(x: 18, y: calculateHeight(40), width: self.myWidth!-(18*2), height: 40)
        
        self.lblUsername!.frame = CGRect(x: 32, y: calculateHeight(14, marginTop: 10), width: self.myWidth!-(32*2), height: 14)
        self.txtUsername!.frame = CGRect(x: 18, y: calculateHeight(40), width: self.myWidth!-(18*2), height: 40)
        
        self.lblEmail!.frame = CGRect(x: 32, y: calculateHeight(14, marginTop: 10), width: self.myWidth!-(32*2), height: 14)
        self.txtEmail!.frame = CGRect(x: 18, y: calculateHeight(40), width: self.myWidth!-(18*2), height: 40)
        
        
        
        self.btnDone!.frame = CGRect(x: 18, y: calculateHeight(40, marginTop: 15), width: self.myWidth!-(18*2), height: 40)
        
        self.btnChangePassword!.frame = CGRect(x: 18, y: calculateHeight(40, marginTop: 50), width: self.myWidth!-(18*2), height: 40)
        
        self.btnDelete!.frame = CGRect(x: 18, y: calculateHeight(40, marginTop: 50), width: self.myWidth!-(18*2), height: 40)
        
        
        self.profileEditViewFrame = CGRect(x: 0, y: 0, width: self.myWidth!, height: self.myHeight!)
        
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, calculateHeight(add: false)+20)
        
        
        
        self.modalChangePasswordHeight = self.myHeight! - appDelegate.navBarHeight
        let modalChangePasswordHeightMin = CGFloat(15+40+5+14+40+30+14+40+10+14+40+20+40+18)
        
        
        self.modalChangePassword!.frame = CGRect(x: (self.myWidth!-self.modalChangePasswordWidth)/2, y: 0, width: self.modalChangePasswordWidth, height: ((modalChangePasswordHeightMin > self.modalChangePasswordHeight) ? self.modalChangePasswordHeight : modalChangePasswordHeightMin))
        
        self.modalChangePasswordScrollView!.frame = CGRect(x: 0, y: 0, width: self.modalChangePasswordWidth, height: ((modalChangePasswordHeightMin > self.modalChangePasswordHeight) ? self.modalChangePasswordHeight : modalChangePasswordHeightMin))
        
        self.modalChangePasswordScrollView!.contentSize = CGSizeMake(self.modalChangePasswordWidth, modalChangePasswordHeightMin)
        
        
        self.modalChangePasswordWidth = self.myWidth!*0.8
        
        
        
        self.modalChangePasswordLblTitle!.frame = CGRect(x: 15, y: 15, width: self.modalChangePasswordWidth-30, height: 40)
        
        self.modalChangePasswordLblCurrent!.frame = CGRect(x: 32, y: 15+40+5, width: self.modalChangePasswordWidth-(32*2), height: 14)
        self.modalChangePasswordTxtCurrent!.frame = CGRect(x: 18, y: 15+40+5+14, width: self.modalChangePasswordWidth-(18*2), height: 40)
        
        self.modalChangePasswordLblNew!.frame = CGRect(x: 32, y: 15+40+5+14+40+30, width: self.modalChangePasswordWidth-(32*2), height: 14)
        self.modalChangePasswordTxtNew!.frame = CGRect(x: 18, y: 15+40+5+14+40+30+14, width: self.modalChangePasswordWidth-(18*2), height: 40)
        
        self.modalChangePasswordLblNewRepeat!.frame = CGRect(x: 32, y: 15+40+5+14+40+30+14+40+10, width: self.modalChangePasswordWidth-(32*2), height: 14)
        self.modalChangePasswordTxtNewRepeat!.frame = CGRect(x: 18, y: 15+40+5+14+40+30+14+40+10+14, width: self.modalChangePasswordWidth-(18*2), height: 40)
        
        self.modalChangePasswordBtnCancel!.frame = CGRect(x: 18, y: 15+40+5+14+40+30+14+40+10+14+40+20, width: (self.modalChangePasswordWidth-(18*2))/2-5, height: 40)
        self.modalChangePasswordBtnSubmit!.frame = CGRect(x: 18+(self.modalChangePasswordWidth-(18*2))/2+5, y: 15+40+5+14+40+30+14+40+10+14+40+20, width: (self.modalChangePasswordWidth-(18*2))/2-5, height: 40)
    }
    
    func showChangePasswordModal(sender: AnyObject) {
        if(!self.isFromFacebook) {
        //tint background
        self.modalIsOpen = true
        self.disableScrollview()
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.modalChangePassword!, atIndex: 15)
            })
        })
        }
    }
    
    func hideChangePasswordModal(sender: AnyObject) {
        //untint background
        self.modalIsOpen = false
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.modalChangePassword?.removeFromSuperview()
        })
    }
    
    func enableScrollview() {
        self.scrollView!.userInteractionEnabled = true
    }
    
    func disableScrollview() {
        self.scrollView!.userInteractionEnabled = false
    }
    

    
    
    func deleteProfile(sender: AnyObject) {
        var refreshAlert = UIAlertController(title: "Are you sure?", message: "This cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.deleteProfileConfirmed()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Cancel delete")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
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
    
    func tapClose(sender: AnyObject) {
        appDelegate.mainViewController!.setHomeContentView(SSMyProfileView(), goingBack: true)
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
    
    func modalLoadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {

            
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
        self.currentUser = StorySlam.getCurrentUser()
        
        if(self.currentUser != nil) {
            
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
                            
                            if let new_email = result["data"]["email"].string {
                                self.currentUser!.email = new_email
                            }
                            
                            self.isFromFacebook = result["data"]["is_from_facebook"].boolValue
                            
                            
                        
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.txtUsername!.text = self.currentUser!.username!
                                self.txtFirstname!.text = self.currentUser!.firstname!
                                self.txtLastname!.text = self.currentUser!.lastname!
                                self.txtEmail!.text = self.currentUser!.email!
                                
                                self.currentUser!.username = result["data"]["username"].string!
                                self.currentUser!.firstname = result["data"]["firstname"].string!
                                self.currentUser!.lastname = result["data"]["lastname"].string!
                                self.currentUser!.email = result["data"]["email"].stringValue
                                
                                StorySlam.setCurrentUser(self.currentUser!)
                                
                                //self.lblLoadingError!.removeFromSuperview()
                                
                                if(self.isFromFacebook) {
                                    self.btnChangePassword!.removeFromSuperview()
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
    
    func afterSaveProfile() {
        self.enableForm()
    }
    
    
    func saveProfile(sender: AnyObject) {
        
        
        self.disableForm()
        let firstname = self.txtFirstname!.text
        let lastname = self.txtLastname!.text
        let username = self.txtUsername!.text
        let email = self.txtEmail!.text
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(firstname != nil && lastname != nil && username != nil && email != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "update_profile", parameters: [
                    "username":currentUser!.username!,
                    "token": currentUser!.token!,
                    
                    "firstname": firstname!,
                    "lastname": lastname!,
                    "new_username": username!,
                    "email": email!
                    ])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.afterSaveProfile()
                        self.formError("An error occurred.", theMessage: "Please check your connection and try again.")
                        
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            self.currentUser!.username = username!
                            StorySlam.setCurrentUser(self.currentUser!)
                            
                            self.afterSaveProfile()
                            self.loadProfile()
                            
                        } else {
                            self.afterSaveProfile()
                            self.formError("An error occurred.", theMessage: result["message"].stringValue)
                        }
                    } else {
                        self.afterSaveProfile()
                        self.formError("An error occurred.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.afterSaveProfile()
                self.formError("An error occurred.")
            }
            
            
            
            
        } else {
            self.formError("All fields required.")
        }
        
    }
    
    func formError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.enableForm()}))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }

    func disableForm() {
        self.txtFirstname!.enabled = false
        self.txtLastname!.enabled = false
        self.txtUsername!.enabled = false
        self.txtEmail!.enabled = false
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.btnDone!.enabled = false
            self.showLoadingOverlay()
            self.appDelegate.hideMenuButton()
        })
    }
    func enableForm() {
        self.txtFirstname!.enabled = true
        self.txtLastname!.enabled = true
        self.txtUsername!.enabled = true
        self.txtEmail!.enabled = true

        
        dispatch_async(dispatch_get_main_queue(), {
            self.btnDone!.enabled = true
            self.hideLoadingOverlay()
            self.appDelegate.showMenuButton()
        })
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    func afterChangePasswordSubmit() {
        dispatch_async(dispatch_get_main_queue(), {
            self.modalChangePasswordTxtCurrent!.enabled = true
            self.modalChangePasswordTxtNew!.enabled = true
            self.modalChangePasswordTxtNewRepeat!.enabled = true
            self.modalChangePasswordBtnSubmit!.enabled = true
        })
        
    }
    
    func changePasswordSubmit(sender: AnyObject) {
        self.modalChangePasswordTxtCurrent!.enabled = false
        self.modalChangePasswordTxtNew!.enabled = false
        self.modalChangePasswordTxtNewRepeat!.enabled = false
        self.modalChangePasswordBtnSubmit!.enabled = false
        
        let current_password = self.modalChangePasswordTxtCurrent!.text
        let new_password = self.modalChangePasswordTxtNew!.text
        let new_password2 = self.modalChangePasswordTxtNewRepeat!.text
        
        
        
        if(current_password != nil && new_password != nil && new_password2 != nil) {
            
            self.currentUser = StorySlam.getCurrentUser()
            
            do {
                
                let opt = try HTTP.POST(StorySlam.actionURL + "change_password",
                    parameters: [
                        "username":currentUser!.username!,
                        "token": currentUser!.token!,
                        "current_password" : current_password!,
                        "new_password" : new_password!,
                        "new_password2" : new_password2!
                    ]
                )
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.afterChangePasswordSubmit()
                        self.modalLoadError("An error occurred.", theMessage: "Please check your connection and try again.")
                        return //also notify app of failure as needed
                    }
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.afterChangePasswordSubmit()
                                self.hideChangePasswordModal(self)
                            })
                            
                            
                        } else {
                            self.afterChangePasswordSubmit()
                            self.modalLoadError("An error occurred.", theMessage: result["message"].stringValue)
                        }
                    } else {
                        self.afterChangePasswordSubmit()
                        self.modalLoadError("An error occurred.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.afterChangePasswordSubmit()
                self.modalLoadError("An error occurred.")
            }
            
            
            
            
        } else {
            self.afterChangePasswordSubmit()
            self.modalLoadError("All fields required.")
        }
        

    }
    
    func deleteProfileConfirmed() {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.hideMenuButton()
            self.showLoadingOverlay()
        })
        
        self.currentUser = StorySlam.getCurrentUser()
        
        if(self.currentUser != nil && self.currentUser!.user_id != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "deleteUser", parameters: [
                    "username":self.currentUser!.username!,
                    "token": self.currentUser!.token!,
                    
                    "user_id": String(self.currentUser!.user_id!)
                    ])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")

                        self.formError("An error occurred.", theMessage: "Please check your connection and try again.")
                        
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.appDelegate.hideMenuButton()
                                self.showLoadingOverlay()
                                
                                self.appDelegate.mainViewController!.logOut()
                            })
                        } else {
                        
                            self.formError("An error occurred.", theMessage: result["message"].stringValue)
                        }
                    } else {
                
                        self.formError("An error occurred.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                
                self.formError("An error occurred.")
            }
            
            
            
            
        } else {
            self.formError("All fields required.")
        }
        

    }
    
    
    
}