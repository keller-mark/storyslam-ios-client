//
//  SSLoginView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/15/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit


class SSLoginView: SSContentView, UITextFieldDelegate {
    
    var btnForgotPassword: UIButton?
    var btnLogin: UIButton?
    var btnCreateAccount: UIButton?
    
    var btnLoginWithFacebook: UIButton?

    
    var lblOr: UILabel?
    var lineOr: UIView?
    
    var txtUsernameEmail: SSTextField?
    var txtPassword: SSTextField?
    
    var lblTitle: UILabel?
    
    
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isLoginView = true
        
        appDelegate.mainViewController!.untintNavBar()
        
        self.setupViews()
        self.setupFrames()
    }
    override func setupViews() {
        super.setupViews()
        
        self.addGradient()
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Log In with StorySlam"
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.backgroundColor = StorySlam.colorClear
        self.scrollView!.addSubview(self.lblTitle!)
        
        
        self.btnCreateAccount = UIButton()
        self.btnCreateAccount!.titleLabel!.font = UIFont(name: "OpenSans", size: 14)
        self.btnCreateAccount!.setTitle("Create StorySlam Account", forState: .Normal)
        self.btnCreateAccount!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnCreateAccount!.backgroundColor = StorySlam.colorClear
        self.btnCreateAccount!.addTarget(self, action: Selector("goToCreateAccount:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnCreateAccount!)
        
        self.btnLoginWithFacebook = UIButton()
        self.btnLoginWithFacebook!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnLoginWithFacebook!.layer.cornerRadius = 20
        self.btnLoginWithFacebook!.backgroundColor = StorySlam.colorFacebookBlue
        self.btnLoginWithFacebook!.setTitle("Log In with Facebook", forState: .Normal)
        self.btnLoginWithFacebook!.setTitleColor(StorySlam.colorWhite, forState: .Normal)
        self.btnLoginWithFacebook!.addTarget(self, action: Selector("submitLoginFacebook:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnLoginWithFacebook!)
        
        self.lblOr = UILabel()
        self.lblOr!.text = "OR"
        self.lblOr!.backgroundColor = StorySlam.colorWhite
        self.lblOr!.textColor = StorySlam.colorDarkPurple
        self.lblOr!.textAlignment = .Center
        self.lblOr!.font = UIFont(name: "OpenSans", size: 14)
        self.lblOr!.layer.cornerRadius = 20
        self.lblOr!.clipsToBounds = true
        self.scrollView!.addSubview(self.lblOr!)
        
        self.lineOr = UIView()
        self.lineOr!.backgroundColor = StorySlam.colorWhite
        self.lineOr!.layer.cornerRadius = 2

        self.scrollView!.insertSubview(self.lineOr!, belowSubview: self.lblOr!)
        

        
        
        
        
        
        self.txtUsernameEmail = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtUsernameEmail!.placeholder = "Username or Email"
        self.txtUsernameEmail!.backgroundColor = StorySlam.colorWhite
        self.txtUsernameEmail!.tintColor = StorySlam.colorDarkPurple
        self.txtUsernameEmail!.alpha = CGFloat(0.7)
        self.txtUsernameEmail!.font = UIFont(name: "OpenSans", size: 14)
        self.txtUsernameEmail!.autocorrectionType = .No
        self.txtUsernameEmail!.autocapitalizationType = .None
        self.txtUsernameEmail!.spellCheckingType = .No
        self.txtUsernameEmail!.keyboardType = .EmailAddress
        self.txtUsernameEmail!.returnKeyType = .Next
        self.txtUsernameEmail!.delegate = self
        self.txtUsernameEmail!.tag = 0
        self.scrollView!.addSubview(self.txtUsernameEmail!)
        
        
        self.btnForgotPassword = UIButton()
        self.btnForgotPassword!.setTitle("Forgot Password?", forState: .Normal)
        self.btnForgotPassword!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnForgotPassword!.titleLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.btnForgotPassword!.backgroundColor = StorySlam.colorClear
        self.btnForgotPassword!.contentHorizontalAlignment = .Left
        self.btnForgotPassword!.addTarget(self, action: Selector("goToForgotPassword:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnForgotPassword!)
        
        
        self.btnLogin = UIButton()
        self.btnLogin!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnLogin!.layer.cornerRadius = 20
        self.btnLogin!.backgroundColor = StorySlam.colorYellow
        self.btnLogin!.setTitle("Submit", forState: .Normal)
        self.btnLogin!.setTitleColor(StorySlam.colorDarkPurple, forState: .Normal)
        self.btnLogin!.addTarget(self, action: Selector("submitLogin:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnLogin!)
        
        
        self.txtPassword = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtPassword!.placeholder = "Password"
        self.txtPassword!.backgroundColor = StorySlam.colorWhite
        self.txtPassword!.tintColor = StorySlam.colorDarkPurple
        self.txtPassword!.alpha = CGFloat(0.7)
        self.txtPassword!.font = UIFont(name: "OpenSans", size: 14)
        self.txtPassword!.autocorrectionType = .No
        self.txtPassword!.autocapitalizationType = .None
        self.txtPassword!.spellCheckingType = .No
        self.txtPassword!.secureTextEntry = true
        self.txtPassword!.returnKeyType = .Go
        self.txtPassword!.delegate = self
        self.txtPassword!.tag = 1
        self.scrollView!.addSubview(self.txtPassword!)
        
        
        
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        gradientLayer.frame = self.view.bounds
        
        
        
        self.btnLoginWithFacebook!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 20), width: self.myWidth!-30, height: 40)
        
        self.lblOr!.frame = CGRect(x: (self.myWidth!/2)-20, y: calculateHeight(40, marginTop: 40), width: 40, height: 40)
        self.lineOr!.frame = CGRect(x: 60, y: calculateHeight(4, add: false)-18, width: self.myWidth!-120, height: 4)

        self.lblTitle!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 20), width: self.myWidth!-30, height: 40)

        
        self.txtUsernameEmail!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 5), width: self.myWidth!-30, height: 40)
        self.txtPassword!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 20), width: self.myWidth!-30, height: 40)
        self.btnForgotPassword!.frame = CGRect(x: 15, y: calculateHeight(14, marginTop: 4), width: self.myWidth!-30, height: 14)
        self.btnLogin!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 20), width: self.myWidth!-30, height: 40)
        
        self.btnCreateAccount!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 20, marginBottom: 20), width: self.myWidth!-30, height: 40)
        

        
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false))
        
        
    }
    
    func addGradient() {
        
        let topColor = StorySlam.colorLightPurple.CGColor as CGColorRef
        let bottomColor = StorySlam.colorDarkPurple.CGColor as CGColorRef
        gradientLayer.colors = [topColor, bottomColor]
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }

    func submitLogin(sender: AnyObject) {
        StorySlam.logOut()
        
        self.disableLogin()
        
        let usernameOrEmail = self.txtUsernameEmail!.text
        let password = self.txtPassword!.text
        if(usernameOrEmail != nil && password != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "login", parameters: ["username":usernameOrEmail!, "password": password!])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.loginError("An error occurred.", theMessage: "Please check your connection and try again.")
                        return //also notify app of failure as needed
                    }
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            print("username: " + result["data"]["username"].stringValue)
                            print("token: " + result["data"]["token"].stringValue)
                            
                            let currentUser = CurrentUser()
                            
                            currentUser.user_id = result["data"]["id"].intValue
                            currentUser.token = result["data"]["token"].string!
                            currentUser.username = result["data"]["username"].string!
                            currentUser.firstname = result["data"]["firstname"].string!
                            currentUser.lastname = result["data"]["lastname"].string!
                            currentUser.email = result["data"]["email"].stringValue
                            currentUser.has_agreed_eula = result["data"]["has_agreed_eula"].boolValue
                            
                            StorySlam.preferences.setBool(result["data"]["has_ads"].boolValue, forKey: "has_ads")
                            StorySlam.preferences.synchronize()
                            
                            StorySlam.setCurrentUser(currentUser)
                            StorySlam.sendDeviceToken()
                            
                            self.loginSuccess()
                            
                        } else {
                            self.loginError(result["message"].stringValue)
                        }
                    } else {
                        self.loginError("An error occurred.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.loginError("An error occurred.")
            }
            
            
            
            
        } else {
            self.loginError("All fields required.")
        }

    }
    
    func loginError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.enableLogin()}))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    func loginSuccess() {
        
        self.enableLogin()
        dispatch_async(dispatch_get_main_queue(), {
            let currentUser: CurrentUser? = StorySlam.getCurrentUser()
            if(currentUser != nil && currentUser!.has_agreed_eula!) {
                self.appDelegate.mainViewController!.setHomeContentView(SSHomeView())
                self.appDelegate.showMenuButton()
            } else if(currentUser != nil) {
                self.appDelegate.mainViewController!.setHomeContentView(SSAgreementView())
            }
            
        })
        
    }
    
    func disableLogin() {
        self.btnLogin!.enabled = false
        self.btnLoginWithFacebook!.enabled = false
        self.btnForgotPassword!.enabled = false
        self.btnCreateAccount!.enabled = false
        dispatch_async(dispatch_get_main_queue(), {
            self.showLoadingOverlay()
        })
    }
    func enableLogin() {
        self.btnLogin!.enabled = true
        self.btnLoginWithFacebook!.enabled = true
        self.btnForgotPassword!.enabled = true
        self.btnCreateAccount!.enabled = true
        dispatch_async(dispatch_get_main_queue(), {
            self.hideLoadingOverlay()
        })
    }
    
    func goToForgotPassword(sender: AnyObject) {
        self.appDelegate.mainViewController!.setHomeContentView(SSForgotPasswordView())
    }
    func goToCreateAccount(sender: AnyObject) {
        self.appDelegate.mainViewController!.setHomeContentView(SSCreateAccountView())
    }
    
    
    func submitLoginFacebook(sender: AnyObject) {
        StorySlam.logOut()
        FBSDKLoginManager().logOut()
        
        self.disableLogin()
        
        
        let permissions_wanted = ["public_profile", "email", "user_friends"]
        
        let login = FBSDKLoginManager.init()
        login.logInWithReadPermissions(permissions_wanted, fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                //According to Facebook:
                //Errors will rarely occur in the typical login flow because the login dialog
                //presented by Facebook via single sign on will guide the users to resolve any errors.
                
                // Process error
                FBSDKLoginManager().logOut()
                self.loginError(error.description)
            } else if result.isCancelled {
                // Handle cancellations
                FBSDKLoginManager().logOut()
                self.loginError("Facebook Login was cancelled.")
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                var allPermsGranted = true
                
                //result.grantedPermissions returns an array of _NSCFString pointers
                
                for permission in permissions_wanted {
                    if(result.declinedPermissions.contains(permission)) {
                        allPermsGranted = false
                        break
                    }
                }
                if allPermsGranted {
                    // Do work
                    let fbToken = result.token.tokenString
                    let fbUserID = result.token.userID
                    print(fbToken)
                    print(fbUserID)
                    
                    // SEND LOGIN WITH FACEBOOK TO STORYSLAM SERVER
                    do {
                        let opt = try HTTP.POST(StorySlam.actionURL + "loginWithFacebook", parameters: ["fbToken":fbToken, "fbUserID": fbUserID])
                        opt.start { response in
                            if let err = response.error {
                                print("error: \(err.localizedDescription)")
                                self.loginError("An error occurred.", theMessage: "Please check your connection and try again.")
                                return //also notify app of failure as needed
                            }
                            
                            let result = JSON(data: response.data)
                            
                            print(response.description)
                            
                            if(result["message"].string != nil) {
                                if(result["success"].boolValue == true) {
                                    
                                    
                                   let currentUser = CurrentUser()
                                    
                                    currentUser.user_id = result["data"]["id"].intValue
                                    currentUser.token = result["data"]["token"].string!
                                    currentUser.username = result["data"]["username"].string!
                                    currentUser.firstname = result["data"]["firstname"].string!
                                    currentUser.lastname = result["data"]["lastname"].string!
                                    currentUser.email = result["data"]["email"].stringValue
                                    currentUser.has_agreed_eula = result["data"]["has_agreed_eula"].boolValue
                                    
                                    let is_new_user = result["data"]["isNewUser"].boolValue
                                    
                                    StorySlam.preferences.setBool(result["data"]["has_ads"].boolValue, forKey: "has_ads")
                                    StorySlam.preferences.synchronize()
                                    
                                    StorySlam.setCurrentUser(currentUser)
                                    StorySlam.sendDeviceToken()
                                    self.loginSuccess()
                                    
                                    
                                } else {
                                    self.loginError(result["message"].stringValue)
                                }
                            } else {
                                self.loginError("An error occurred.")
                            }
                            
                        }
                    } catch let error {
                        print("got an error creating the request: \(error)")
                        self.loginError("An error occurred.")
                    }
                    
                    // END SEND LOGIN WITH FACEBOOK TO STORYSLAM SERVER
                    
                    
                } else {
                    //The user did not grant all permissions requested
                    //Discover which permissions are granted
                    //and if you can live without the declined ones
                    
                    self.loginError("Permissions were declined.")
                }
            }
        })
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            if(textField == self.txtPassword) {
                self.submitLogin(self)
            }
        }
        return false // We do not want UITextField to insert line-breaks.
    }

    
    

    
    
    
    
}