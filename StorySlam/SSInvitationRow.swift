//
//  SSInvitationRow.swift
//  StorySlam
//
//  Created by Mark Keller on 7/29/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSInvitationRow: UIView {
    
    static var rowPlusImage: UIImage = UIImage(named: "plus-light_blue")!
    static var rowCheckImage: UIImage = UIImage(named: "check-light_green")!
    static var rowCloseImage: UIImage = UIImage(named: "x_bold-orange")!
    
    static var rowUserImage: UIImage = UIImage(named: "user-yellow")!
    static var rowClockImage: UIImage = UIImage(named: "clock-yellow")!
    static var rowGenreImage: UIImage = UIImage(named: "pencil-yellow")!
    
    var rowHeight: CGFloat = 0
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rowPlusIcon : UIImageView? = UIImageView()
    var rowCheckIcon : UIImageView? = UIImageView()
    var rowCloseIcon : UIImageView? = UIImageView()
    var rowUserIcon : UIImageView? = UIImageView()
    var rowClockIcon : UIImageView? = UIImageView()
    var rowGenreIcon : UIImageView? = UIImageView()
    
    var rowLblStoryTitle : UILabel? = UILabel()
    var rowLblInitiator : UILabel? = UILabel()
    var rowLblExpiration : UILabel? = UILabel()
    var rowLblGenre : UILabel? = UILabel()
    var rowLblOr: UILabel? = UILabel()
    
    var rowTeamPills = [SSUserPill]()
    
    var finishedSetupFrames = false
    
    
    var invitation : Invitation?
    var parent: SSHomeView?
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initialize(invitation: Invitation, width: CGFloat, parent: SSHomeView) {
        dispatch_async(dispatch_get_main_queue(), {
        self.invitation = invitation
        self.parent = parent
        
        
            self.setupViews(width)
            
        })
        
        
        
        
    }
    
    func setupViews(width: CGFloat) {
        dispatch_async(dispatch_get_main_queue(), {
        self.backgroundColor = StorySlam.colorBlue
        self.layer.cornerRadius = 20
        

        self.rowPlusIcon!.image = SSInvitationRow.rowPlusImage
        self.rowPlusIcon!.contentMode = .ScaleAspectFit
        self.addSubview(self.rowPlusIcon!)
        
        
        self.rowLblStoryTitle!.text = self.invitation!.story_title
        self.rowLblStoryTitle!.textAlignment = .Left
        self.rowLblStoryTitle!.textColor = StorySlam.colorYellow
        self.rowLblStoryTitle!.font = UIFont(name: "OpenSans", size: 14)
        self.addSubview(self.rowLblStoryTitle!)
        
    
        self.rowUserIcon!.image = SSInvitationRow.rowUserImage
        self.rowUserIcon!.contentMode = .ScaleAspectFit
        self.addSubview(self.rowUserIcon!)
        
       
        self.rowClockIcon!.image = SSInvitationRow.rowClockImage
        self.rowClockIcon!.contentMode = .ScaleAspectFit
        self.addSubview(self.rowClockIcon!)
        
      
        self.rowGenreIcon!.image = SSInvitationRow.rowGenreImage
        self.rowGenreIcon!.contentMode = .ScaleAspectFit
        self.addSubview(self.rowGenreIcon!)
        
        
    
        self.rowLblInitiator!.text = "Invited by @\(self.invitation!.initiator.username)"
        self.rowLblInitiator!.textAlignment = .Left
        self.rowLblInitiator!.textColor = StorySlam.colorYellow
        self.rowLblInitiator!.font = UIFont(name: "OpenSans", size: 12)
        self.addSubview(self.rowLblInitiator!)
        
       
        self.rowLblExpiration!.text = self.invitation!.expiration_string
        self.rowLblExpiration!.textAlignment = .Left
        self.rowLblExpiration!.textColor = StorySlam.colorYellow
        self.rowLblExpiration!.font = UIFont(name: "OpenSans", size: 12)
        self.addSubview(self.rowLblExpiration!)
        
       
        self.rowLblGenre!.text = self.invitation!.story_genre
        self.rowLblGenre!.textAlignment = .Left
        self.rowLblGenre!.textColor = StorySlam.colorYellow
        self.rowLblGenre!.font = UIFont(name: "OpenSans", size: 12)
        self.addSubview(self.rowLblGenre!)
        
        
      
        self.rowLblOr!.text = "or"
        self.rowLblOr!.textAlignment = .Center
        self.rowLblOr!.textColor = StorySlam.colorYellow
        self.rowLblOr!.font = UIFont(name: "OpenSans", size: 12)
        self.addSubview(self.rowLblOr!)
        
        
        
        self.rowCheckIcon!.image = SSInvitationRow.rowCheckImage
        self.rowCheckIcon!.contentMode = .ScaleAspectFit
        self.rowCheckIcon!.userInteractionEnabled = true
        self.rowCheckIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapAccept:")))
        self.addSubview(self.rowCheckIcon!)
        
   
        self.rowCloseIcon!.image = SSInvitationRow.rowCloseImage
        self.rowCloseIcon!.contentMode = .ScaleAspectFit
        self.rowCloseIcon!.userInteractionEnabled = true
        self.rowCloseIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapDecline:")))
        self.addSubview(self.rowCloseIcon!)
        
        for user in self.invitation!.all_players! {
            
            let userPill = SSUserPill()
            userPill.initialize(user)
            userPill.setTitleColor(StorySlam.colorBlue, forState: .Normal)
            userPill.backgroundColor = StorySlam.colorLightBlue
            
            self.rowTeamPills.append(userPill)
            self.addSubview(userPill)
            print("adding user pill...")
           
        }
            dispatch_async(dispatch_get_main_queue(), {
            self.setupFrames(width)
            })
        })
        
        
        
    }
    
    func setupFrames(width: CGFloat) {
        dispatch_async(dispatch_get_main_queue(), {
            self.finishedSetupFrames = false
        self.rowHeight = 0
        self.rowLblStoryTitle!.frame = CGRect(x: 15+24+15, y: 0, width: width-15-24-15-15-24-15, height: 30)
        
        self.rowHeight += 30
        
        
        let userPillsLeftMargin: CGFloat = 15+24+15
        let userPillsTopMargin: CGFloat = 26
        let userPillsLineMaxWidth: CGFloat = width-15-24-15-15-24-15
        var userPillsNumLines: CGFloat = 0
        var userPillsCurrentLineWidth: CGFloat = 0
        
        
        for userPill in self.rowTeamPills.enumerate() {
            let pillSize = userPill.element.titleLabel!.sizeThatFits(CGSizeMake(userPillsLineMaxWidth, CGFloat.max))
            var pillSizeWidth = pillSize.width + 6
            
            userPillsCurrentLineWidth += pillSizeWidth
            
            if(userPillsCurrentLineWidth >= userPillsLineMaxWidth) {
                
                //needs new line
                userPillsNumLines += 1
                userPillsCurrentLineWidth = 0
                if(pillSizeWidth >= userPillsLineMaxWidth) {
                    pillSizeWidth = userPillsLineMaxWidth
                }
                
                userPill.element.frame = CGRect(x: userPillsLeftMargin, y: userPillsTopMargin+((userPillsNumLines)*20), width: pillSizeWidth, height: 16)
                
                userPillsCurrentLineWidth = pillSizeWidth
                

                print("setting frame for user pill...")
                
                
            } else {
                if((userPillsCurrentLineWidth-pillSizeWidth) != 0) {
                    userPillsCurrentLineWidth += 6
                }
                userPill.element.frame = CGRect(x: userPillsLeftMargin+(userPillsCurrentLineWidth-pillSizeWidth), y: userPillsTopMargin+(userPillsNumLines*20), width: pillSizeWidth, height: 16)
            }
            if(userPill.index == self.rowTeamPills.count-1) {
                userPillsNumLines += 1
            }
        }
        
        
        let userPillsTotalHeight: CGFloat = userPillsNumLines * 20
        
        self.rowHeight += userPillsTotalHeight
        
        self.rowUserIcon!.frame = CGRect(x: 15+24+15, y: self.rowHeight, width: 12, height: 12)
        self.rowLblInitiator!.frame = CGRect(x: 15+24+15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
        
        
        self.rowHeight += 18
        
        self.rowClockIcon!.frame = CGRect(x: 15+24+15, y: self.rowHeight, width: 12, height: 12)
        self.rowLblExpiration!.frame = CGRect(x: 15+24+15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
        
        self.rowHeight += 18
        
        self.rowGenreIcon!.frame = CGRect(x: 15+24+15, y: self.rowHeight, width: 12, height: 12)
        self.rowLblGenre!.frame = CGRect(x: 15+24+15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
        
        self.rowHeight += 18+10
        
        let topOfAcceptIcons: CGFloat = (self.rowHeight-(20+2+18+2+20))/2
        
        self.rowCheckIcon!.frame = CGRect(x: width-15-24, y: topOfAcceptIcons, width: 24, height: 20)
        self.rowCloseIcon!.frame = CGRect(x: width-15-24, y: topOfAcceptIcons+20+2+18+2, width: 24, height: 20)
        self.rowLblOr!.frame = CGRect(x: width-15-24, y: topOfAcceptIcons+20+2, width: 24, height: 18)
        
        self.rowPlusIcon!.frame = CGRect(x: 15, y: 0, width: 24, height: self.rowHeight)
            self.frame = CGRect(x: self.frame.minX , y: self.frame.minY, width: self.frame.width, height: self.rowHeight)
           self.finishedSetupFrames = true
        })
        
    }
    
    
    
    func tapAccept(sender: AnyObject) {
        
        if(self.invitation != nil && self.parent != nil) {
            self.parent!.acceptInvitation(self.invitation!)
        }else{
            print("invitation is nil")
        }
        
    }
    func tapDecline(sender: AnyObject) {
        
        if(self.invitation != nil && self.parent != nil) {
            self.parent!.declineInvitation(self.invitation!)
        }else{
            print("invitation is nil")
        }
        
    }
    
}