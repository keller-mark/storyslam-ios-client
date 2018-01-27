//
//  SSFinishedStoryView.swift
//  StorySlam
//
//  Created by Mark Keller on 1/2/17.
//  Copyright © 2017 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSFinishedStoryView: SSContentView {
    
    //main views
    var finished_story: FinishedStory?
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    static var shareIcon: UIImage = UIImage(named: "share-yellow")!
    var imgShareIcon: UIImageView?
    
    static var likeIcon: UIImage = UIImage(named: "like-orange")!
    static var likeIconYellow: UIImage = UIImage(named: "like-yellow")!
    static var unlikeIcon: UIImage = UIImage(named: "like_o-orange")!
    var imgLikeIcon: UIImageView?
    
    var lblStoryTitle: UILabel?
    var lblStoryLikes: UIButton?
    
    
    var lblStory: UITextView?
    var lblStoryHeight = CGFloat(30)
    
    var lblTheEnd: UILabel?
    
    var lblAuthors: UILabel?
    var lblStoryInfo: UIButton?
    
    // Story Info Modal
    
    var storyInfoModal = UIView()
    var lblSIMHeading = UILabel()
    var lblSIMTitleKey = UILabel()
    var lblSIMTitleVal = UILabel()
    var lblSIMAuthorsKey = UILabel()
    var lblSIMAuthorsVals = [UIButton]()
    var lblSIMGenreKey = UILabel()
    var lblSIMGenreVal = UILabel()
    var lblSIMLengthKey = UILabel()
    var lblSIMLengthVal = UILabel()
    var lblSIMStateKey = UILabel()
    var lblSIMStateVal = UILabel()
    var lblSIMCreatedKey = UILabel()
    var lblSIMCreatedVal = UILabel()
    var btnSIMClose = UIButton()
    var btnSIMReport = UIButton()
    var svSIM = UIScrollView()
    
    // Likes Modal
    
    var storyLikesModal = UIView()
    var lblSLMHeading = UILabel()
    var lblSLMNumLikes = UILabel()
    var imgSLMLike = UIImageView()
    var lblSLMUsernames = UITextView()
    var btnSLMClose = UIButton()
    
    var currentUser: CurrentUser?
    
    init(finished_story: FinishedStory) {
        super.init(nibName: nil, bundle: nil)
        
        self.finished_story = finished_story
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = StorySlam.getCurrentUser()
        
        self.setupViews()
        self.setupFrames()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.hideRefreshButton()
        })
        
    }
    
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()
        
        self.scrollView!.backgroundColor = StorySlam.colorYellow
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Story"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorDarkPurple
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        self.imgBackIcon = UIImageView()
        self.imgBackIcon!.image = UIImage(named: "back_arrow-yellow")
        self.imgBackIcon!.contentMode = .ScaleAspectFit
        self.imgBackIcon!.userInteractionEnabled = true
        self.imgBackIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapBack:")))
        self.view.addSubview(self.imgBackIcon!)
        
        
        self.imgShareIcon = UIImageView()
        self.imgShareIcon!.image = SSFinishedStoryView.shareIcon
        self.imgShareIcon!.contentMode = .ScaleAspectFit
        self.imgShareIcon!.userInteractionEnabled = true
        self.imgShareIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("showShareModal:")))
        self.view.addSubview(self.imgShareIcon!)
        
        
        self.lblStoryTitle = UILabel()
        self.lblStoryTitle!.text = self.finished_story!.title
        self.lblStoryTitle!.numberOfLines = 0
        self.lblStoryTitle!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStoryTitle!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblStoryTitle!)
        
        self.lblStoryLikes = UIButton()
        self.lblStoryLikes!.setTitle("\(self.finished_story!.num_likes)", forState: .Normal)
        self.lblStoryLikes!.setTitleColor(StorySlam.colorOrange, forState: .Normal)
        self.lblStoryLikes!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.lblStoryLikes!.addTarget(self, action: Selector("showLikesModal:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.lblStoryLikes!)
        
        self.imgLikeIcon = UIImageView()
        if(self.finished_story!.liked_by_me!) {
            self.imgLikeIcon!.image = SSFinishedStoryView.likeIcon
        } else {
            self.imgLikeIcon!.image = SSFinishedStoryView.unlikeIcon
        }
        self.imgLikeIcon!.contentMode = .ScaleAspectFit
        self.imgLikeIcon!.userInteractionEnabled = true
        self.imgLikeIcon!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("submitLike:")))
        self.scrollView!.addSubview(self.imgLikeIcon!)
        
        
        self.lblStory = UITextView()
        self.lblStory!.backgroundColor = StorySlam.colorYellow
        self.lblStory!.textAlignment = .Justified
        self.lblStory!.editable = false
        self.lblStory!.selectable = false
        self.lblStory!.scrollEnabled = false
        self.lblStory!.text = self.finished_story!.content
        self.lblStory!.font = UIFont(name: "OpenSans", size: 14)
        self.lblStory!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblStory!)
        
        self.lblTheEnd = UILabel()
        self.lblTheEnd!.text = "THE END"
        self.lblTheEnd!.font = UIFont(name: "OpenSans", size: 18)
        self.lblTheEnd!.textColor = StorySlam.colorGold
        self.lblTheEnd!.textAlignment = .Center
        self.scrollView!.addSubview(self.lblTheEnd!)
        
        

        self.lblAuthors = UILabel()
        self.lblAuthors!.text = self.finished_story!.getAuthorsText()
        self.lblAuthors!.font = UIFont(name: "OpenSans", size: 14)
        self.lblAuthors!.textColor = StorySlam.colorBlue
        self.lblAuthors!.textAlignment = .Center
        self.lblAuthors!.userInteractionEnabled = true
        self.lblAuthors!.numberOfLines = 0
        self.lblAuthors!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("showStoryInfo:")))
        self.scrollView!.addSubview(self.lblAuthors!)
        
        self.lblStoryInfo = UIButton()
        self.lblStoryInfo!.setTitle("i", forState: .Normal)
        self.lblStoryInfo!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStoryInfo!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.lblStoryInfo!.backgroundColor = StorySlam.colorBlue
        self.lblStoryInfo!.layer.cornerRadius = 20
        self.lblStoryInfo!.addTarget(self, action: Selector("showStoryInfo:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.lblStoryInfo!)
        
        
        // Story Info Modal (SIM)
        self.storyInfoModal.backgroundColor = StorySlam.colorYellow
        self.storyInfoModal.layer.cornerRadius = 20
        
        self.storyInfoModal.addSubview(self.svSIM)
        
        self.lblSIMHeading.text = "Story Details"
        self.lblSIMHeading.textColor = StorySlam.colorBlue
        self.lblSIMHeading.font = UIFont(name: "OpenSans", size: 24)
        self.storyInfoModal.addSubview(self.lblSIMHeading)
        
        self.lblSIMTitleKey.text = "Title"
        self.lblSIMTitleKey.textColor = StorySlam.colorBlue
        self.lblSIMTitleKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMTitleKey)
        
        self.lblSIMTitleVal.text = self.finished_story!.title
        self.lblSIMTitleVal.textColor = StorySlam.colorBlue
        self.lblSIMTitleVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMTitleVal)
        
        self.lblSIMAuthorsKey.text = "Authors"
        self.lblSIMAuthorsKey.textColor = StorySlam.colorBlue
        self.lblSIMAuthorsKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMAuthorsKey)
        
        for (index, author) in self.finished_story!.authors.enumerate() {
            let lblSIMAuthorVal = UIButton()
            lblSIMAuthorVal.setTitle("@" + author.username, forState: .Normal)
            lblSIMAuthorVal.setTitleColor(StorySlam.colorBlue, forState: .Normal)
            lblSIMAuthorVal.titleLabel!.font = UIFont(name: "OpenSans", size: 12)
            lblSIMAuthorVal.tag = index
            lblSIMAuthorVal.contentHorizontalAlignment = .Left
            lblSIMAuthorVal.addTarget(self, action: Selector("goToAuthor:"), forControlEvents: .TouchUpInside)
            self.svSIM.addSubview(lblSIMAuthorVal)
            self.lblSIMAuthorsVals.append(lblSIMAuthorVal)
        }
        
        self.lblSIMGenreKey.text = "Genre"
        self.lblSIMGenreKey.textColor = StorySlam.colorBlue
        self.lblSIMGenreKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMGenreKey)
        
        self.lblSIMGenreVal.text = self.finished_story!.genre
        self.lblSIMGenreVal.textColor = StorySlam.colorBlue
        self.lblSIMGenreVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMGenreVal)
        
        self.lblSIMLengthKey.text = "Length"
        self.lblSIMLengthKey.textColor = StorySlam.colorBlue
        self.lblSIMLengthKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMLengthKey)
        
        self.lblSIMLengthVal.text = "\(self.finished_story!.length) sentences"
        self.lblSIMLengthVal.textColor = StorySlam.colorBlue
        self.lblSIMLengthVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMLengthVal)
        
        self.lblSIMStateKey.text = "State"
        self.lblSIMStateKey.textColor = StorySlam.colorBlue
        self.lblSIMStateKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMStateKey)
        
        
        self.lblSIMStateVal.text = "Finished"
        self.lblSIMStateVal.textColor = StorySlam.colorBlue
        self.lblSIMStateVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMStateVal)
        
        self.lblSIMCreatedKey.text = "Finished"
        self.lblSIMCreatedKey.textColor = StorySlam.colorBlue
        self.lblSIMCreatedKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMCreatedKey)
        
        self.lblSIMCreatedVal.text = self.finished_story!.finished_at
        self.lblSIMCreatedVal.textColor = StorySlam.colorBlue
        self.lblSIMCreatedVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMCreatedVal)
        
        self.btnSIMReport.setTitle("Report as offensive", forState: .Normal)
        self.btnSIMReport.setTitle("Reporting...", forState: .Disabled)
        self.btnSIMReport.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnSIMReport.backgroundColor = StorySlam.colorOrange
        self.btnSIMReport.titleLabel!.font = UIFont(name: "OpenSans", size: 14)
        self.btnSIMReport.layer.cornerRadius = 15
        self.btnSIMReport.addTarget(self, action: Selector("reportStory:"), forControlEvents: .TouchUpInside)
        self.svSIM.addSubview(self.btnSIMReport)
        
        self.btnSIMClose.setTitle("Close", forState: .Normal)
        self.btnSIMClose.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnSIMClose.backgroundColor = StorySlam.colorBlue
        self.btnSIMClose.layer.cornerRadius = 20
        self.btnSIMClose.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSIMClose.addTarget(self, action: Selector("hideStoryInfo"), forControlEvents: .TouchUpInside)
        self.storyInfoModal.addSubview(self.btnSIMClose)
        
        // Story Likes Modal (SLM)
        self.storyLikesModal.backgroundColor = StorySlam.colorOrange
        self.storyLikesModal.layer.cornerRadius = 20
        
        self.lblSLMHeading.text = "Likes"
        self.lblSLMHeading.textColor = StorySlam.colorYellow
        self.lblSLMHeading.font = UIFont(name: "OpenSans", size: 24)
        self.storyLikesModal.addSubview(self.lblSLMHeading)
        
        self.lblSLMNumLikes.textColor = StorySlam.colorYellow
        self.lblSLMNumLikes.font = UIFont(name: "OpenSans", size: 18)
        self.lblSLMNumLikes.text = "\(self.finished_story!.num_likes)"
        self.storyLikesModal.addSubview(self.lblSLMNumLikes)
        
        self.lblSLMUsernames.text = ""
        self.lblSLMUsernames.backgroundColor = StorySlam.colorOrange
        self.lblSLMUsernames.textAlignment = .Left
        self.lblSLMUsernames.editable = false
        self.lblSLMUsernames.selectable = false
        self.lblSLMUsernames.scrollEnabled = true
        self.lblSLMUsernames.font = UIFont(name: "OpenSans", size: 14)
        self.lblSLMUsernames.textColor = StorySlam.colorYellow
        self.storyLikesModal.addSubview(self.lblSLMUsernames)
        
        self.imgSLMLike = UIImageView()
        self.imgSLMLike.image = SSFinishedStoryView.likeIconYellow
        self.imgSLMLike.contentMode = .ScaleAspectFit
        self.storyLikesModal.addSubview(self.imgSLMLike)
        
        self.btnSLMClose.setTitle("Close", forState: .Normal)
        self.btnSLMClose.setTitleColor(StorySlam.colorOrange, forState: .Normal)
        self.btnSLMClose.backgroundColor = StorySlam.colorYellow
        self.btnSLMClose.layer.cornerRadius = 20
        self.btnSLMClose.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSLMClose.addTarget(self, action: Selector("hideLikesModal"), forControlEvents: .TouchUpInside)
        self.storyLikesModal.addSubview(self.btnSLMClose)
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: calculateHeight(46), width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        self.imgShareIcon!.frame = CGRect(x: self.myWidth! - 18-26, y: 0, width: 26, height: 46)
        
        let lblTitleSize = self.lblStoryTitle!.sizeThatFits(CGSizeMake(self.myWidth!-30-18-5-40, CGFloat.max))
        self.lblStoryTitle!.frame = CGRect(x: 15, y: 16, width: self.myWidth!-30-18-5-40, height: lblTitleSize.height)
        var topMarginInfo = CGFloat(10)
        if(lblTitleSize.height > 40) {
            topMarginInfo = 10 + (lblTitleSize.height-40)/2
        }
        
        self.imgLikeIcon!.frame = CGRect(x: self.myWidth!-30-18-5, y: topMarginInfo, width: 40, height: 40)
        self.lblStoryLikes!.frame = CGRect(x: self.myWidth!-30-18-5, y: topMarginInfo+30, width: 40, height: 40)
        
        let lblStorySize = self.lblStory!.sizeThatFits(CGSizeMake(self.myWidth!-20, CGFloat.max))
        self.lblStoryHeight = lblStorySize.height
        
        self.lblStory!.frame = CGRect(x: 10, y: 16+lblTitleSize.height+20, width: self.myWidth!-20, height: self.lblStoryHeight)
        
        
        self.lblTheEnd!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20+self.lblStoryHeight+30, width: self.myWidth!-30, height: 24)
        
        let lblAuthorsSize = self.lblAuthors!.sizeThatFits(CGSizeMake(self.myWidth!-140, CGFloat.max))
        self.lblAuthors!.frame = CGRect(x: 70, y: 16+lblTitleSize.height+20+self.lblStoryHeight+30+24+20, width: self.myWidth!-140, height: lblAuthorsSize.height)
        
        self.lblStoryInfo!.frame = CGRect(x: self.myWidth!/2-20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+30+24+20+lblAuthorsSize.height+15, width: 40, height: 40)
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 16+lblTitleSize.height+20+self.lblStoryHeight+30+24+30+lblAuthorsSize.height+15+40+20)
        
        
        let modalWidth: CGFloat = self.myWidth!-60
        let modalSIMHeight = self.myHeight!*0.75
        let modalKeyColWidth = modalWidth*0.35
        let modalValColWidth = modalWidth*0.65
        var modalSIMContentHeight: CGFloat = 0
        
        //Story Info Modal (SIM)
        self.storyInfoModal.frame = CGRect(x: 30, y: 0, width: modalWidth, height: modalSIMHeight)
        self.lblSIMHeading.frame = CGRect(x: 15, y: 10, width: modalWidth-30, height: 30)
        self.svSIM.frame = CGRect(x: 0, y: 10+30+5, width: modalWidth, height: modalSIMHeight-45-40-20)
        
        self.lblSIMTitleKey.frame = CGRect(x: 15, y: 5, width: modalKeyColWidth-15, height: 14)
        let lblSIMTitleValSize = self.lblSIMTitleKey.sizeThatFits(CGSizeMake(modalValColWidth-30, CGFloat.max))
        self.lblSIMTitleVal.frame = CGRect(x: modalKeyColWidth+15, y: 5, width: modalValColWidth-30, height: lblSIMTitleValSize.height)
        modalSIMContentHeight += 5+lblSIMTitleValSize.height+10
        self.lblSIMAuthorsKey.frame = CGRect(x: 15, y: modalSIMContentHeight, width: modalKeyColWidth-15, height: 14)
        for (index, authorButton) in self.lblSIMAuthorsVals.enumerate() {
            authorButton.frame = CGRect(x: modalKeyColWidth+15, y: modalSIMContentHeight+(14*CGFloat(index)), width: modalValColWidth-30, height: 16)
        }
        modalSIMContentHeight += CGFloat(self.finished_story!.authors.count*14)+10
        self.lblSIMGenreKey.frame = CGRect(x: 15, y: modalSIMContentHeight, width: modalKeyColWidth-15, height: 14)
        self.lblSIMGenreVal.frame = CGRect(x: modalKeyColWidth+15, y: modalSIMContentHeight, width: modalValColWidth-30, height: 16)
        modalSIMContentHeight += 14+10
        self.lblSIMLengthKey.frame = CGRect(x: 15, y: modalSIMContentHeight, width: modalKeyColWidth-15, height: 16)
        self.lblSIMLengthVal.frame = CGRect(x: modalKeyColWidth+15, y: modalSIMContentHeight, width: modalValColWidth-30, height: 14)
        modalSIMContentHeight += 14+10
        self.lblSIMStateKey.frame = CGRect(x: 15, y: modalSIMContentHeight, width: modalKeyColWidth-15, height: 14)
        self.lblSIMStateVal.frame = CGRect(x: modalKeyColWidth+15, y: modalSIMContentHeight, width: modalValColWidth-30, height: 16)
        modalSIMContentHeight += 14+10
        self.lblSIMCreatedKey.frame = CGRect(x: 15, y: modalSIMContentHeight, width: modalKeyColWidth-15, height: 14)
        self.lblSIMCreatedVal.frame = CGRect(x: modalKeyColWidth+15, y: modalSIMContentHeight, width: modalValColWidth-30, height: 16)
        modalSIMContentHeight += 14+20
        
        self.btnSIMReport.frame = CGRect(x: 15, y: modalSIMContentHeight, width: modalWidth - 30, height: 30)
        modalSIMContentHeight += 30+20
        
        self.btnSIMClose.frame = CGRect(x: 15, y: modalSIMHeight-15-40, width: modalWidth-30, height: 40)
        self.svSIM.contentSize = CGSizeMake(modalWidth, modalSIMContentHeight)
        
        //Story Likes Modal (SLM)
        
        self.storyLikesModal.frame = CGRect(x: 30, y: 0, width: modalWidth, height: modalSIMHeight)
        self.lblSLMHeading.frame = CGRect(x: 10, y: 10, width: modalWidth-20, height: 30)
        
        self.imgSLMLike.frame = CGRect(x: 15, y: 10+30+10, width: 22, height: 30)
        self.lblSLMNumLikes.frame = CGRect(x: 15+22+10, y: 10+30+10, width: modalWidth-15-22-10-15, height: 30)
        
        self.lblSLMUsernames.frame = CGRect(x: 10, y: 10+30+10+30+10, width: modalWidth-20, height: modalSIMHeight-45-40-20-45)
        
        self.btnSLMClose.frame = CGRect(x: 15, y: modalSIMHeight-15-40, width: modalWidth-30, height: 40)
        
    }
    
    
    func tapBack(sender: AnyObject) {
        print("back tapped...")
        appDelegate.mainViewController!.backHomeContentView()
    }
    
    
    
    func enableScrollview() {
        self.scrollView!.userInteractionEnabled = true
    }
    
    func disableScrollview() {
        self.scrollView!.userInteractionEnabled = false
    }
    
    func goToUser(user: Friend?) {
        if(user != nil && self.currentUser != nil) {
            if(self.currentUser!.user_id! == user!.id) {
                SSUserPill.appDelegate.mainViewController!.setHomeContentView(SSMyProfileView())
            } else {
                SSUserPill.appDelegate.mainViewController!.setHomeContentView(SSUserProfileView(user: user!))
            }
        }
    }
    
    func showStoryInfo(sender: AnyObject) {
        self.disableScrollview()
        
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.storyInfoModal, atIndex: 15)
            })
        })
        
    }
    
    func hideStoryInfo() {
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.storyInfoModal.removeFromSuperview()
        })
        
    }
    
    func goToAuthor(sender: UIButton) {
        self.hideStoryInfo()
        for (index, author) in self.finished_story!.authors.enumerate() {
            if(sender.tag == index) {
                self.goToUser(author)
            }
        }
    }
    
    func showShareModal(sender: AnyObject) {
        let share_url = NSURL(string: self.finished_story!.link)
        guard let url = share_url else {
            return
        }
        
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) {
            self.presentViewController(activityViewController, animated: true, completion: nil)
        } else {
            let popup = UIPopoverController.init(contentViewController: activityViewController)
            popup.presentPopoverFromRect(CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func showLikesModal(sender: AnyObject) {
        self.disableScrollview()
        
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        self.loadLikes()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.storyLikesModal, atIndex: 15)
            })
        })

    }
    
    func hideLikesModal() {
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.storyLikesModal.removeFromSuperview()
        })
    }
    
    func submitLike(sender: AnyObject) {
        
        if(!self.finished_story!.liked_by_me!) {
            dispatch_async(dispatch_get_main_queue(), {
                self.lblStoryLikes!.setTitle("\(self.finished_story!.num_likes+1)", forState: .Normal)
                self.lblSLMNumLikes.text = "\(self.finished_story!.num_likes+1)"
                self.imgLikeIcon!.image = SSFinishedStoryView.likeIcon
                self.finished_story!.num_likes = self.finished_story!.num_likes+1
            })
        } else if(self.finished_story!.num_likes-1 >= 0) {
            dispatch_async(dispatch_get_main_queue(), {
                self.lblStoryLikes!.setTitle("\(self.finished_story!.num_likes-1)", forState: .Normal)
                self.lblSLMNumLikes.text = "\(self.finished_story!.num_likes-1)"
                self.imgLikeIcon!.image = SSFinishedStoryView.unlikeIcon
                self.finished_story!.num_likes = self.finished_story!.num_likes-1
            })
        }
        
        
        if(currentUser != nil) {
            
            do {
                var link = "likeStory"
                if(self.finished_story!.liked_by_me!) {
                    link = "unlikeStory"
                }
                self.finished_story!.liked_by_me = !self.finished_story!.liked_by_me!
                
                let opt = try HTTP.POST(StorySlam.actionURL + link, parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.finished_story!.id)])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            print("successfully liked")
                        }
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
        } else {
            self.appDelegate.mainViewController!.logOut()
        }

    }
    
    func loadLikes() {
        dispatch_async(dispatch_get_main_queue(), {
            self.lblSLMUsernames.text = "Loading..."
            self.lblSLMUsernames.textAlignment = .Center
            self.lblSLMUsernames.font = UIFont(name: "OpenSans", size: 18)
            self.lblSLMUsernames.textColor = StorySlam.colorWhite
            
        })
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "getLikes", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.finished_story!.id)])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.likesError("Could not connect to network.")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.lblSLMUsernames.text = result["data"]["usernames"].stringValue
                                self.lblSLMUsernames.textAlignment = .Left
                                self.lblSLMUsernames.font = UIFont(name: "OpenSans", size: 14)
                                self.lblSLMUsernames.textColor = StorySlam.colorYellow
                                
                                self.finished_story!.num_likes = result["data"]["num_likes"].intValue
                                
                                self.lblSLMNumLikes.text = "\(self.finished_story!.num_likes)"
                                self.lblStoryLikes!.setTitle("\(self.finished_story!.num_likes)", forState: .Normal)
                                
                            })
                            
                        } else {
                            self.likesError(result["message"].stringValue)
                        }
                    } else {
                        self.likesError("An error occurred.")
                        
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.likesError("An error occurred.")
            }
            
        } else {
            self.appDelegate.mainViewController!.logOut()
        }

    }
    
    func likesError(error_text: String) {
        self.lblSLMUsernames.text = error_text
    }
    
    func reportStory(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.btnSIMReport.enabled = false
        })
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "reportStory", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.finished_story!.id)])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        self.reportStoryError("Could not connect to network.")
                        return //also notify app of failure as needed
                    }
                    
                    print(response.description)
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.hideStoryInfo()
                                self.tapBack(self)
                                self.appDelegate.mainViewController!.refreshContent()
                            })
                            
                        } else {
                            self.reportStoryError(result["message"].stringValue)
                        }
                    } else {
                        self.reportStoryError("An error occurred.")
                        
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.reportStoryError("An error occurred.")
            }
            
        } else {
            self.appDelegate.mainViewController!.logOut()
        }

    }
    
    func reportStoryError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.btnSIMReport.enabled = true
            
        })
    }

    
    
    
}
