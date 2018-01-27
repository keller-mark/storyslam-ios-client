//
//  SSFinishedStoryRow.swift
//  StorySlam
//
//  Created by Mark Keller on 8/30/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSFinishedStoryRow: UIView {
    
    static var rowRulerImage: UIImage = UIImage(named: "ruler-yellow")!
    static var rowClockImage: UIImage = UIImage(named: "clock-yellow")!
    static var rowGenreImage: UIImage = UIImage(named: "pencil-yellow")!
    static var rowLikeImage: UIImage = UIImage(named: "like-orange")!
    static var rowUnlikeImage: UIImage = UIImage(named: "like_o-orange")!
    
    var rowHeight: CGFloat = 0
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rowRulerIcon : UIImageView? = UIImageView()
    var rowClockIcon : UIImageView? = UIImageView()
    var rowGenreIcon : UIImageView? = UIImageView()
    var rowLikeIcon : UIImageView? = UIImageView()
    
    var rowLblStoryTitle : UILabel? = UILabel()
    var rowLblGenre : UILabel? = UILabel()
    var rowLblLength : UILabel? = UILabel()
    var rowLblDate : UILabel? = UILabel()
    var rowLblLikes : UILabel? = UILabel()
    
    var rowTeamPills = [SSUserPill]()
    
    var finishedSetupFrames = false
    
    var finished_story : FinishedStory?
    var parent: SSContentView?
    
    var current_profile_id: Int?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initialize(finished_story: FinishedStory, width: CGFloat, parent: SSContentView, current_profile_id: Int? = nil) {
        dispatch_async(dispatch_get_main_queue(), {
            self.finished_story = finished_story
            self.parent = parent
            
            self.current_profile_id = current_profile_id
            
            
            self.setupViews(width)
            
        })
        
        
        
        
    }
    
    func setupViews(width: CGFloat) {
        dispatch_async(dispatch_get_main_queue(), {
            self.backgroundColor = StorySlam.colorBlue
            self.layer.cornerRadius = 20
            
            self.userInteractionEnabled = true
            self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapPencil:")))
            
            
            if(self.finished_story!.liked_by_me!) {
                self.rowLikeIcon!.image = SSFinishedStoryRow.rowLikeImage
            } else {
                self.rowLikeIcon!.image = SSFinishedStoryRow.rowUnlikeImage
            }
            self.rowLikeIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowLikeIcon!)
            
            
            
            
            
            self.rowLblStoryTitle!.text = self.finished_story!.title
            self.rowLblStoryTitle!.textAlignment = .Left
            self.rowLblStoryTitle!.textColor = StorySlam.colorYellow
            self.rowLblStoryTitle!.font = UIFont(name: "OpenSans", size: 14)
            self.addSubview(self.rowLblStoryTitle!)
            
            
            self.rowGenreIcon!.image = SSFinishedStoryRow.rowGenreImage
            self.rowGenreIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowGenreIcon!)
            
            self.rowRulerIcon!.image = SSFinishedStoryRow.rowRulerImage
            self.rowRulerIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowRulerIcon!)
            
            
            self.rowClockIcon!.image = SSFinishedStoryRow.rowClockImage
            self.rowClockIcon!.contentMode = .ScaleAspectFit
            self.addSubview(self.rowClockIcon!)
            
            
            self.rowLblGenre!.text = self.finished_story!.genre
            self.rowLblGenre!.textAlignment = .Left
            self.rowLblGenre!.textColor = StorySlam.colorYellow
            self.rowLblGenre!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblGenre!)
            
            self.rowLblLength!.text = "\(self.finished_story!.length) sentences"
            self.rowLblLength!.textAlignment = .Left
            self.rowLblLength!.textColor = StorySlam.colorYellow
            self.rowLblLength!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblLength!)
            
            
            self.rowLblDate!.text = self.finished_story!.finished_at
            self.rowLblDate!.textAlignment = .Left
            self.rowLblDate!.textColor = StorySlam.colorYellow
            self.rowLblDate!.font = UIFont(name: "OpenSans", size: 12)
            self.addSubview(self.rowLblDate!)
            
            
            self.rowLblLikes!.text = "\(self.finished_story!.num_likes)"
            self.rowLblLikes!.textAlignment = .Center
            self.rowLblLikes!.textColor = StorySlam.colorOrange
            self.rowLblLikes!.font = UIFont(name: "OpenSans", size: 24)
            self.addSubview(self.rowLblLikes!)
            
            
            
            
            
            
            for user in self.finished_story!.authors {
                
                let userPill = SSUserPill()
                
                userPill.initialize(user, current_profile_id: self.current_profile_id)
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
            self.rowLblStoryTitle!.frame = CGRect(x: 15, y: 0, width: width-15-24-15-15-24-15, height: 30)
            
            self.rowHeight += 30
            
            
            let userPillsLeftMargin: CGFloat = 15
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
            
            self.rowGenreIcon!.frame = CGRect(x: 15, y: self.rowHeight, width: 12, height: 12)
            self.rowLblGenre!.frame = CGRect(x: 15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
            
            
            self.rowHeight += 18
            
            
            self.rowRulerIcon!.frame = CGRect(x: 15, y: self.rowHeight, width: 12, height: 12)
            self.rowLblLength!.frame = CGRect(x: 15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
            
            self.rowHeight += 18
            
            
            self.rowClockIcon!.frame = CGRect(x: 15, y: self.rowHeight, width: 12, height: 12)
            self.rowLblDate!.frame = CGRect(x: 15+12+8, y: self.rowHeight-4, width: width-15-24-15-15-24-15-12-8, height: 18)
            
            self.rowHeight += 18+10
            
            self.rowLikeIcon!.frame = CGRect(x: width-15-24, y: 0, width: 24, height: self.rowHeight-20)
            self.rowLblLikes!.frame = CGRect(x: width-15-24-12, y: (self.rowHeight/2), width: 48, height: 30)
            
            self.frame = CGRect(x: self.frame.minX , y: self.frame.minY, width: self.frame.width, height: self.rowHeight)
            self.finishedSetupFrames = true
        })
        
    }
    
    func tapPencil(sender: AnyObject) {
        print("going to finished story page...")
       SSFinishedStoryRow.appDelegate.mainViewController!.setHomeContentView(SSFinishedStoryView(finished_story: self.finished_story!))
    }
    
    
    
    
}