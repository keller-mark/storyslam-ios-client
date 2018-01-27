//
//  SSOpenStoryRow.swift
//  StorySlam
//
//  Created by Mark Keller on 8/30/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSOpenStoryRow: UIView {
    
    static var rowPencilImage: UIImage = UIImage(named: "pencil-light_blue")!
    static var rowUserImage: UIImage = UIImage(named: "user-yellow")!
    static var rowClockImage: UIImage = UIImage(named: "clock-yellow")!
    static var rowGenreImage: UIImage = UIImage(named: "pencil-yellow")!
    static var rowTurnImage: UIImage = UIImage(named: "turn-yellow")!
    
    var rowHeight: CGFloat = 0
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rowPencilIcon : UIImageView? = UIImageView()
    var rowTurnIcon : UIImageView? = UIImageView()
    var rowUserIcon : UIImageView? = UIImageView()
    var rowClockIcon : UIImageView? = UIImageView()
    var rowGenreIcon : UIImageView? = UIImageView()
    
    var rowLblStoryTitle : UILabel? = UILabel()
    var rowLblInitiator : UILabel? = UILabel()
    var rowLblTurn : UILabel? = UILabel()
    var rowLblExpiration : UILabel? = UILabel()
    var rowLblGenre : UILabel? = UILabel()
    var rowLblNumSentences : UILabel? = UILabel()
    
    var rowTeamPills = [SSUserPill]()
    
    var finishedSetupFrames = false
    
    var open_story : OpenStory?
    var parent: SSHomeView?
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initialize(open_story: OpenStory, width: CGFloat, parent: SSHomeView) {
        dispatch_async(dispatch_get_main_queue(), {
            self.open_story = open_story
            self.parent = parent
            
            
            self.setupViews(width)
            
        })
        
        
        
        
    }
    
    func setupViews(width: CGFloat) {
        dispatch_async(dispatch_get_main_queue(), {
            self.backgroundColor = StorySlam.colorDarkPurple
            self.layer.cornerRadius = 20
            
            
            
            
            self.rowLblNumSentences!.text = self.open_story!.num_sentences
            self.rowLblNumSentences!.textAlignment = .Center
            if(self.open_story!.sentences_fulfilled!) {
                self.rowLblNumSentences!.textColor = StorySlam.colorLightGreen
            } else {
                self.rowLblNumSentences!.textColor = StorySlam.colorOrange
            }
            
            self.rowLblNumSentences!.font = UIFont(name: "OpenSans", size: 24)
            self.addSubview(self.rowLblNumSentences!)
            
            
            self.rowPencilIcon!.image = SSOpenStoryRow.rowPencilImage
            self.rowPencilIcon!.contentMode = .ScaleAspectFit
            self.userInteractionEnabled = true
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapPencil:")))
            
            self.addSubview(self.rowPencilIcon!)
            
            

            
            
            self.rowLblStoryTitle!.text = self.open_story!.title
            self.rowLblStoryTitle!.textAlignment = .Left
            self.rowLblStoryTitle!.textColor = StorySlam.colorYellow
            self.rowLblStoryTitle!.font = UIFont(name: "OpenSans", size: 14)
            self.addSubview(self.rowLblStoryTitle!)
            
            
            self.rowUserIcon!.image = SSOpenStoryRow.rowUserImage
            self.rowUserIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowUserIcon!)
            
            self.rowTurnIcon!.image = SSOpenStoryRow.rowTurnImage
            self.rowTurnIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowTurnIcon!)

            
            self.rowClockIcon!.image = SSOpenStoryRow.rowClockImage
            self.rowClockIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowClockIcon!)
            
            
            self.rowGenreIcon!.image = SSOpenStoryRow.rowGenreImage
            self.rowGenreIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowGenreIcon!)
            
            
            
            self.rowLblInitiator!.text = "Initiated by @\(self.open_story!.initiator.username)"
            self.rowLblInitiator!.textAlignment = .Left
            self.rowLblInitiator!.textColor = StorySlam.colorYellow
            self.rowLblInitiator!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblInitiator!)
            
            self.rowLblTurn!.text = self.open_story!.current_action_string
            self.rowLblTurn!.textAlignment = .Left
            self.rowLblTurn!.textColor = StorySlam.colorYellow
            self.rowLblTurn!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblTurn!)
            
            
            self.rowLblExpiration!.text = self.open_story!.expiration_string
            self.rowLblExpiration!.textAlignment = .Left
            self.rowLblExpiration!.textColor = StorySlam.colorYellow
            self.rowLblExpiration!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblExpiration!)
            
            
            self.rowLblGenre!.text = self.open_story!.genre
            self.rowLblGenre!.textAlignment = .Left
            self.rowLblGenre!.textColor = StorySlam.colorYellow
            self.rowLblGenre!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblGenre!)
            
            
            
            
            
            
            for user in self.open_story!.all_players! {
                
                let userPill = SSUserPill()
                userPill.initialize(user)
                userPill.setTitleColor(StorySlam.colorBlue, forState: .Normal)
                userPill.backgroundColor = StorySlam.colorLightBlue
                
                self.rowTeamPills.append(userPill)
                self.addSubview(userPill)
                print("adding user pill...")
                
            }
            
            
            if(!(self.open_story!.is_my_turn!)) {
                self.layer.opacity = 0.6
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
            
            
            self.rowTurnIcon!.frame = CGRect(x: 15+24+15, y: self.rowHeight, width: 12, height: 12)
            self.rowLblTurn!.frame = CGRect(x: 15+24+15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
            
            self.rowHeight += 18
            
            
            self.rowClockIcon!.frame = CGRect(x: 15+24+15+14, y: self.rowHeight, width: 12, height: 12)
            self.rowLblExpiration!.frame = CGRect(x: 15+24+15+12+8+14, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8-14, height: 18)
            
            self.rowHeight += 18
            
            self.rowGenreIcon!.frame = CGRect(x: 15+24+15, y: self.rowHeight, width: 12, height: 12)
            self.rowLblGenre!.frame = CGRect(x: 15+24+15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
            
            self.rowHeight += 18+10
            
            self.rowLblNumSentences!.frame = CGRect(x: 3, y: 0, width: 48, height: self.rowHeight)
            
            
            self.rowPencilIcon!.frame = CGRect(x: width-15-24, y: 0, width: 24, height: self.rowHeight)
            self.frame = CGRect(x: self.frame.minX , y: self.frame.minY, width: self.frame.width, height: self.rowHeight)
            self.finishedSetupFrames = true
        })
        
    }
    
    func tapPencil(sender: AnyObject) {
        print("going to open story page...")
        SSOpenStoryRow.appDelegate.mainViewController!.setHomeContentView(SSOpenStoryView(open_story: self.open_story!))
    }
    
    
    
    
}