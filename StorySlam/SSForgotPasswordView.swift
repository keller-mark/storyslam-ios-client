//
//  SSForgotPasswordView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/15/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSForgotPasswordView: SSContentView {
    
    var btnSubmit: UIButton?
    var btnBack: UIButton?
    
    var txtEmail: SSTextField?

    
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
        self.lblTitle!.text = "Reset Your Password"
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.backgroundColor = StorySlam.colorClear
        self.scrollView!.addSubview(self.lblTitle!)
        
        
        
        
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
        self.scrollView!.addSubview(self.txtEmail!)
        
        
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
        self.btnSubmit!.addTarget(self, action: Selector("submitForgotPassword:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnSubmit!)
        
        
       
        

        
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        gradientLayer.frame = self.view.bounds
        
        self.lblTitle!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 15), width: self.myWidth!-30, height: 40)
        self.txtEmail!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10), width: self.myWidth!-30, height: 40)
        
        self.btnBack!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 20), width: (self.myWidth!-30)/2-5, height: 40)
        self.btnSubmit!.frame = CGRect(x: 15+(self.myWidth!-30)/2+5, y: calculateHeight(40, marginTop: 20, add:false), width: (self.myWidth!-30)/2-5, height: 40)
        

        
        
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false))
        
        
    }
    
    func addGradient() {
        
        let topColor = StorySlam.colorLightPurple.CGColor as CGColorRef
        let bottomColor = StorySlam.colorDarkPurple.CGColor as CGColorRef
        gradientLayer.colors = [topColor, bottomColor]
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    func submitForgotPassword(sender: AnyObject) {

        
        self.disableForm()
        
        let email = self.txtEmail!.text
        if(email != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "forgot_password", parameters: ["email":email!])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.formError("An error occurred.", theMessage: "Please check your connection and try again.")
                        return //also notify app of failure as needed
                    }
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            print("username: " + result["username"].stringValue)
                            print("token: " + result["token"].stringValue)
                            

                            self.formSuccess(result["message"].stringValue)
                            
                        } else {
                            self.formError(result["message"].stringValue)
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
    func formSuccess(theMessage: String) {
        
        
        print("success")
        dispatch_async(dispatch_get_main_queue(), {
            self.txtEmail!.text = ""
            
            let alert = UIAlertController(title: theMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.enableForm()}))
            self.presentViewController(alert, animated: true, completion: {
                self.appDelegate.mainViewController!.setHomeContentView(SSLoginView())
            })

            
     
        })
        
    }
    func disableForm() {
        self.btnBack!.enabled = false
        self.btnSubmit!.enabled = false
        self.txtEmail!.enabled = false
        showLoadingOverlay()
    }
    func enableForm() {
        self.btnBack!.enabled = true
        self.btnSubmit!.enabled = true
        self.txtEmail!.enabled = true
        hideLoadingOverlay()
    }
    
    
    func goToLogin(sender: AnyObject) {
        self.appDelegate.mainViewController!.setHomeContentView(SSLoginView())
    }
    
    
    
    
    
}