//
//  SSAgreementView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/13/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSAgreementView: SSContentView, UIWebViewDelegate {
    
    var lblTitle: UILabel?
    
    var webView: UIWebView?
    var activityIndicator: UIActivityIndicatorView?
    
    var btnAgree: UIButton?
    var btnDecline: UIButton?
    var btnBackground: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupViews()
        self.setupFrames()
        
        appDelegate.hideMenuButton()
        self.loadAgreement()
    }
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()
        
        
        self.scrollView!.backgroundColor = UIColor.whiteColor()
        self.scrollView!.removeFromSuperview()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "End User License Agreement"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorDarkPurple
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        
        self.webView = UIWebView()
        self.webView!.delegate = self
        self.webView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.webView!)
        
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator!.activityIndicatorViewStyle = .Gray
        self.view.addSubview(self.activityIndicator!)
        
        self.btnBackground = UIView()
        self.btnBackground!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.btnBackground!)
        
        
        self.btnAgree = UIButton()
        self.btnAgree!.setTitle("Agree", forState: .Normal)
        self.btnAgree!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnAgree!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnAgree!.backgroundColor = StorySlam.colorDarkPurple
        self.btnAgree!.layer.cornerRadius = 20
        self.btnAgree!.addTarget(self, action: Selector("agree:"), forControlEvents: .TouchUpInside)
        
        self.btnDecline = UIButton()
        self.btnDecline!.setTitle("Decline", forState: .Normal)
        self.btnDecline!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnDecline!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnDecline!.backgroundColor = StorySlam.colorDarkPurple
        self.btnDecline!.layer.cornerRadius = 20
        self.btnDecline!.addTarget(self, action: Selector("decline:"), forControlEvents: .TouchUpInside)
        
        
        
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: 0, width: self.myWidth!, height: 46)
        self.webView!.frame = CGRect(x: 0, y: 46, width: self.myWidth!, height: self.myHeight!-46-60)
        self.btnBackground!.frame = CGRect(x: 0, y: self.myHeight!-60, width: self.myWidth!, height: 60)
        self.activityIndicator!.frame = CGRect(x: 0, y: 46, width: self.myWidth!, height: self.myHeight!-46-60)
        self.btnAgree!.frame = CGRect(x: 15, y: 10, width: self.myWidth!/2-15-10, height: 40)
        self.btnDecline!.frame = CGRect(x: self.myWidth!/2+10, y: 10, width: self.myWidth!/2-15-10, height: 40)
        
        
        
    }
    
    

    
    func goToHome(sender: AnyObject?) {
        appDelegate.showMenuButton()
        appDelegate.mainViewController!.setHomeContentView(SSHomeView())
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //Check here if still webview is loding the content
        if(self.webView!.loading) {
            return
        } else {
            self.showButtons()
        }
        
    }
    
    func loadAgreement() {
        let url = NSURL(string: StorySlam.eulaURL);
        let requestObj = NSURLRequest(URL: url!)
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator!.startAnimating()
            self.webView!.loadRequest(requestObj)
        })
        
    }
    
    func showButtons() {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.removeFromSuperview()
            self.btnBackground!.addSubview(self.btnAgree!)
            self.btnBackground!.addSubview(self.btnDecline!)
        })
    }
    
    func agree(sender: AnyObject) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.btnAgree!.enabled = false
            self.btnDecline!.enabled = false
            self.btnAgree!.setTitle("Loading...", forState: .Normal)
        })
        
        let currentUser = StorySlam.getCurrentUser()
        
        if(currentUser != nil) {
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "agreeEULA", parameters: ["username":currentUser!.username!, "token": currentUser!.token!])
                opt.start { response in
                    if let err = response.error {
                        self.afterAgree()
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.appDelegate.mainViewController!.setHomeContentView(SSTutorialView())
                            })
                            
                        } else {
                            self.afterAgree()
                            print("error: " + result["message"].stringValue)
                        }
                    } else {
                        self.afterAgree()
                        print("error: " + "An error occurred.")
                    }
                }
            } catch let error {
                self.afterAgree()
                print("got an error creating the request: \(error)")
            }
            
        }

    }
    
    func decline(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.logOut()
        })
    }
    
    func afterAgree() {
        dispatch_async(dispatch_get_main_queue(), {
            self.btnAgree!.enabled = true
            self.btnDecline!.enabled = true
            self.btnAgree!.setTitle("Agree", forState: .Normal)
        })
    }
    
    
    
    
}