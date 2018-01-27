//
//  SSForgotPasswordView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/15/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSCreateAccountView: SSContentView, UITextFieldDelegate, UIWebViewDelegate {
    
    var btnSubmit: UIButton?
    var btnBack: UIButton?
    
    var btnTerms: UILabel?
    
    var modalTerms: UIView?
    var modalTermsWebView: UIWebView?
    var modalTermsClose: UIButton?
    
    var modalTermsHeight: CGFloat = 0
    var modalTermsWidth: CGFloat = 0
    
    
    var txtFirstname: SSTextField?
    var txtLastname: SSTextField?
    var txtUsername: SSTextField?
    var txtEmail: SSTextField?
    var txtPassword: SSTextField?
    
    
    var lblTitle: UILabel?

    
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isLoginView = true
        
        self.setupViews()
        self.setupFrames()
    }
    override func setupViews() {
        super.setupViews()
        
        self.addGradient()
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Create Account"
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.backgroundColor = StorySlam.colorClear
        self.scrollView!.addSubview(self.lblTitle!)
        
        
        self.txtFirstname = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtFirstname!.placeholder = "First Name"
        self.txtFirstname!.backgroundColor = StorySlam.colorWhite
        self.txtFirstname!.tintColor = StorySlam.colorDarkPurple
        self.txtFirstname!.alpha = CGFloat(0.7)
        self.txtFirstname!.font = UIFont(name: "OpenSans", size: 14)
        self.txtFirstname!.autocorrectionType = .No
        self.txtFirstname!.autocapitalizationType = .Words
        self.txtFirstname!.spellCheckingType = .No
        self.txtFirstname!.delegate = self
        self.txtFirstname!.tag = 0
        self.txtFirstname!.returnKeyType = .Next
        self.scrollView!.addSubview(self.txtFirstname!)
        
        self.txtLastname = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtLastname!.placeholder = "Last Name"
        self.txtLastname!.backgroundColor = StorySlam.colorWhite
        self.txtLastname!.tintColor = StorySlam.colorDarkPurple
        self.txtLastname!.alpha = CGFloat(0.7)
        self.txtLastname!.font = UIFont(name: "OpenSans", size: 14)
        self.txtLastname!.autocorrectionType = .No
        self.txtLastname!.autocapitalizationType = .Words
        self.txtLastname!.spellCheckingType = .No
        self.txtLastname!.delegate = self
        self.txtLastname!.tag = 1
        self.txtLastname!.returnKeyType = .Next
        self.scrollView!.addSubview(self.txtLastname!)
        
        
        
        self.txtUsername = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtUsername!.placeholder = "Username"
        self.txtUsername!.backgroundColor = StorySlam.colorWhite
        self.txtUsername!.tintColor = StorySlam.colorDarkPurple
        self.txtUsername!.alpha = CGFloat(0.7)
        self.txtUsername!.font = UIFont(name: "OpenSans", size: 14)
        self.txtUsername!.autocorrectionType = .No
        self.txtUsername!.autocapitalizationType = .None
        self.txtUsername!.spellCheckingType = .No
        self.txtUsername!.delegate = self
        self.txtUsername!.tag = 2
        self.txtUsername!.returnKeyType = .Next
        self.scrollView!.addSubview(self.txtUsername!)
        
        
        
        
        self.txtEmail = SSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.txtEmail!.placeholder = "Email"
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
        self.txtEmail!.returnKeyType = .Next
        self.scrollView!.addSubview(self.txtEmail!)
        
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
        self.txtPassword!.delegate = self
        self.txtPassword!.tag = 4
        self.txtPassword!.returnKeyType = .Go
        self.scrollView!.addSubview(self.txtPassword!)
        
        self.btnTerms = UILabel()
        self.btnTerms!.text = "By creating an account, you agree to StorySlam's Terms and Conditions."
        self.btnTerms!.textColor = StorySlam.colorYellow
        self.btnTerms!.font = UIFont(name: "OpenSans", size: 12)
        self.btnTerms!.backgroundColor = StorySlam.colorClear
        self.btnTerms!.textAlignment = .Left
        self.btnTerms!.numberOfLines = 0
        self.btnTerms!.userInteractionEnabled = true
        self.btnTerms!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("loadTermsModal:")))
        self.scrollView!.addSubview(self.btnTerms!)
        
        
        self.btnBack = UIButton()
        self.btnBack!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnBack!.layer.cornerRadius = 20
        self.btnBack!.backgroundColor = StorySlam.colorWhite
        self.btnBack!.setTitle("Cancel", forState: .Normal)
        self.btnBack!.setTitleColor(StorySlam.colorDarkPurple, forState: .Normal)
        self.btnBack!.addTarget(self, action: Selector("goToLogin:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnBack!)
        
        
        
        self.btnSubmit = UIButton()
        self.btnSubmit!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSubmit!.layer.cornerRadius = 20
        self.btnSubmit!.backgroundColor = StorySlam.colorYellow
        self.btnSubmit!.setTitle("Submit", forState: .Normal)
        self.btnSubmit!.setTitleColor(StorySlam.colorDarkPurple, forState: .Normal)
        self.btnSubmit!.addTarget(self, action: Selector("submitCreateAccount:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnSubmit!)
        
        
        self.modalTerms = UIView()
        self.modalTerms!.backgroundColor = UIColor.whiteColor()
        self.modalTerms!.layer.cornerRadius = 20
        
        self.modalTermsClose = UIButton()
        self.modalTermsClose!.layer.cornerRadius = 20
        self.modalTermsClose!.setTitle("Close", forState: .Normal)
        self.modalTermsClose!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.modalTermsClose!.setTitleColor(StorySlam.colorWhite, forState: .Normal)
        self.modalTermsClose!.backgroundColor = StorySlam.colorDarkPurple
        self.modalTermsClose!.addTarget(self, action: Selector("hideTermsModal:"), forControlEvents: .TouchUpInside)
        self.modalTerms!.addSubview(self.modalTermsClose!)
        
        self.modalTermsWebView = UIWebView()
        self.modalTermsWebView!.delegate = self
        self.modalTermsWebView!.backgroundColor = UIColor.whiteColor()
        self.modalTerms!.addSubview(self.modalTermsWebView!)
        
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //Check here if still webview is loding the content
        if(self.modalTermsWebView!.loading) {
            return
        } else {
            self.showTermsModal()
        }
        
    }
    
    func loadTermsModal(sender: AnyObject) {
        let url = NSURL(string: StorySlam.termsURL);
        let requestObj = NSURLRequest(URL: url!)
        
        self.modalTermsWebView!.loadRequest(requestObj)
        dispatch_async(dispatch_get_main_queue(), {
            self.disableForm()
        })
        
        
        
    }

    func showTermsModal() {
        dispatch_async(dispatch_get_main_queue(), {
            self.view.addSubview(self.modalTerms!)
        })
    }
    
    func hideTermsModal(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.modalTerms!.removeFromSuperview()
            self.enableForm()
        })
    }
    
    override func setupFrames() {
        super.setupFrames()
        
        gradientLayer.frame = self.view.bounds
        
        self.lblTitle!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 15), width: self.myWidth!-30, height: 40)
        
        self.txtFirstname!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10), width: (self.myWidth!-30)/2-5, height: 40)
        self.txtLastname!.frame = CGRect(x: 15+(self.myWidth!-30)/2+5, y: calculateHeight(40, marginTop: 10, add:false), width: (self.myWidth!-30)/2-5, height: 40)
        
        self.txtUsername!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10), width: self.myWidth!-30, height: 40)
        
        self.txtEmail!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10), width: self.myWidth!-30, height: 40)
        
        self.txtPassword!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10), width: self.myWidth!-30, height: 40)
        
        let lblTextSize = self.btnTerms!.sizeThatFits(CGSizeMake(self.myWidth!-30, CGFloat.max))
        self.btnTerms!.frame = CGRect(x: 15, y: calculateHeight(lblTextSize.height, marginTop: 5), width: self.myWidth!-30, height: lblTextSize.height)

        self.btnBack!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10), width: (self.myWidth!-30)/2-5, height: 40)
        self.btnSubmit!.frame = CGRect(x: 15+(self.myWidth!-30)/2+5, y: calculateHeight(40, marginTop: 10, add:false), width: (self.myWidth!-30)/2-5, height: 40)
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false)+200)
        
        self.modalTermsHeight = self.myHeight! - appDelegate.navBarHeight
        self.modalTermsWidth = self.myWidth!-30
        
        self.modalTerms!.frame = CGRect(x: (self.myWidth!-self.modalTermsWidth)/2, y: 0, width: self.modalTermsWidth, height: self.modalTermsHeight)
        self.modalTermsWebView!.frame = CGRect(x: 0, y: 20, width: self.modalTermsWidth, height: self.modalTermsHeight-40-15-20-5)
        self.modalTermsClose!.frame = CGRect(x: 15, y: self.modalTermsHeight - 40 - 15, width: self.modalTermsWidth - 30, height: 40)
        
        
        
    }
    
    func addGradient() {
        
        let topColor = StorySlam.colorLightPurple.CGColor as CGColorRef
        let bottomColor = StorySlam.colorDarkPurple.CGColor as CGColorRef
        gradientLayer.colors = [topColor, bottomColor]
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func submitCreateAccount(sender: AnyObject) {
        
        
        self.disableForm()
        let firstname = self.txtFirstname!.text
        let lastname = self.txtLastname!.text
        let username = self.txtUsername!.text
        let email = self.txtEmail!.text
        let password = self.txtPassword!.text
        
        
        
        if(firstname != nil && lastname != nil && username != nil && email != nil && password != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "signup", parameters: [
                    "firstname": firstname!,
                    "lastname": lastname!,
                    "username": username!,
                    "email": email!,
                    "password": password!
                    ])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.formError("An error occurred.", theMessage: "Please check your connection and try again.")
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
                            
                            StorySlam.setCurrentUser(currentUser)
                            
                            StorySlam.preferences.setBool(result["data"]["has_ads"].boolValue, forKey: "has_ads")
                            StorySlam.preferences.synchronize()
                            StorySlam.sendDeviceToken()
                            
                            self.formSuccess()
                            
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
    
    func formError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.enableForm()}))
            self.presentViewController(alert, animated: true, completion: nil)
            
        })
        
    }
    func formSuccess() {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.enableForm()
            self.appDelegate.mainViewController!.setHomeContentView(SSAgreementView())
        })
        
    }
    func disableForm() {
        self.txtFirstname!.enabled = false
        self.txtLastname!.enabled = false
        self.txtUsername!.enabled = false
        self.txtEmail!.enabled = false
        self.txtPassword!.enabled = false
        
        self.btnBack!.enabled = false
        self.btnSubmit!.enabled = false
        self.btnTerms!.enabled = false
        dispatch_async(dispatch_get_main_queue(), {
            self.showLoadingOverlay()
        })
    }
    func enableForm() {
        self.txtFirstname!.enabled = true
        self.txtLastname!.enabled = true
        self.txtUsername!.enabled = true
        self.txtEmail!.enabled = true
        self.txtPassword!.enabled = true
        
        self.btnBack!.enabled = true
        self.btnSubmit!.enabled = true
        self.btnTerms!.enabled = true
        dispatch_async(dispatch_get_main_queue(), {
            self.hideLoadingOverlay()
        })
    }
    
    
    func goToLogin(sender: AnyObject) {
        self.appDelegate.mainViewController!.setHomeContentView(SSLoginView())
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
                self.submitCreateAccount(self)
            }
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    
    
    
}