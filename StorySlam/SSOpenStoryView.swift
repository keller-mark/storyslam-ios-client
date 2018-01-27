//
//  SSOpenStoryView.swift
//  StorySlam
//
//  Created by Mark Keller on 1/2/17.
//  Copyright © 2017 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSOpenStoryView: SSContentView, UITextViewDelegate {
    
    //main views
    var open_story: OpenStory?
    
    var lblTitle: UILabel?
    var imgBackIcon: UIImageView?
    
    static var clockIcon: UIImage = UIImage(named: "clock-yellow")!
    var imgClockIcon: UIImageView?
    
    var lblStoryTitle: UILabel?
    var lblStoryInfo: UIButton?
    var lblExpiration: UILabel?
    
    
    var lblStory: UITextView?
    var lblStoryHeight = CGFloat(30)
    
    var sentences = [Sentence]()
    
    // Your Turn Stuff
    var lblNextSentence: UILabel?
    var txtNextSentence: UITextView?
    var btnDone: UIButton?
    
    var lblOr: UILabel?
    var lineOr1: UIView?
    var lineOr2: UIView?
    
    var btnEndStory: UIButton?
    
    // Not Your Turn Stuff
    var lblCurrentAuthor: UILabel?
    var btnCurrentAuthor: UIButton?
    var lblNextAuthor: UILabel?
    var btnNextAuthor: UIButton?
    
    var current_author_index: Int?
    var next_author_index: Int?
    
    // Story Info Modal
    var info_all_authors = [Int:Friend]()
    var info_length: Int?
    var info_state: String?
    var info_created: String?
    
    
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
    var svSIM = UIScrollView()
    
    // End Story Modal
    var endStoryModal = UIView()
    var lblESMHeading = UILabel()
    var lblESMMessage = UILabel()
    var btnESMCancel = UIButton()
    var btnESMRequest = UIButton()
    var svESM = UIScrollView()
    
    //Sentence Details Modal
    var sentenceDetailsModal = UIView()
    var lblSDMHeading = UILabel()
    var lblSDMText = UILabel()
    var lblSDMAuthorKey = UILabel()
    var lblSDMAuthorVal = UIButton()
    var lblSDMDateKey = UILabel()
    var lblSDMDateVal = UILabel()
    var btnSDMClose = UIButton()
    var svSDM = UIScrollView()
    var sentenceAuthor: Friend?
    
    //Prompt Details Modal
    var promptDetailsModal = UIView()
    var lblPDMHeading = UILabel()
    var lblPDMText = UILabel()
    var lblPDMGenreKey = UILabel()
    var lblPDMGenreVal = UILabel()
    var btnPDMClose = UIButton()
    var svPDM = UIScrollView()
    
    static let unknown_author = Friend(id: 0, username: "deleted_user", firstname: "Deleted", lastname: "User")
    
    var lblLoadingError: UILabel?
    
    var currentUser: CurrentUser?
    
    var firstLoadScroll = false
    
    init(open_story: OpenStory) {
        super.init(nibName: nil, bundle: nil)
        
        self.open_story = open_story
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = StorySlam.getCurrentUser()
        
        self.setupViews()
        self.setupFrames()
        
        self.loadStory()
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
        
        self.scrollView!.backgroundColor = StorySlam.colorYellow
        
        self.lblTitle = UILabel()
        if(self.open_story!.is_my_turn!) {
            self.lblTitle!.text = "Your Turn"
        } else {
            self.lblTitle!.text = "Open Story"
        }
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
        
        
        self.imgClockIcon = UIImageView()
        self.imgClockIcon!.image = SSOpenStoryView.clockIcon
        self.imgClockIcon!.contentMode = .ScaleAspectFit
        self.view.addSubview(self.imgClockIcon!)
        
        self.lblExpiration = UILabel()
        self.lblExpiration!.textAlignment = .Center
        self.lblExpiration!.textColor = StorySlam.colorYellow
        self.lblExpiration!.text = self.open_story!.expiration_string_short
        self.lblExpiration!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblExpiration!)
        
        
        self.lblStoryTitle = UILabel()
        self.lblStoryTitle!.text = self.open_story!.title
        self.lblStoryTitle!.numberOfLines = 0
        self.lblStoryTitle!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStoryTitle!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblStoryTitle!)
        
        self.lblStoryInfo = UIButton()
        self.lblStoryInfo!.setTitle("i", forState: .Normal)
        self.lblStoryInfo!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.lblStoryInfo!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.lblStoryInfo!.backgroundColor = StorySlam.colorBlue
        self.lblStoryInfo!.layer.cornerRadius = 20
        self.lblStoryInfo!.addTarget(self, action: Selector("showStoryInfo:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.lblStoryInfo!)
        
        
        self.lblStory = UITextView()
        self.lblStory!.backgroundColor = StorySlam.colorYellow
        self.lblStory!.textAlignment = .Justified
        self.lblStory!.editable = false
        self.lblStory!.selectable = false
        self.lblStory!.scrollEnabled = false
        let tapStory = UITapGestureRecognizer(target: self, action: "storyTapped:")
        tapStory.numberOfTapsRequired = 1
        self.lblStory!.addGestureRecognizer(tapStory)
        self.lblStory!.font = UIFont(name: "OpenSans", size: 14)
        self.lblStory!.textColor = StorySlam.colorBlue
        self.scrollView!.addSubview(self.lblStory!)
        
        self.lblNextSentence = UILabel()
        self.lblNextSentence!.text = "Enter the next sentence:"
        self.lblNextSentence!.font = UIFont(name: "OpenSans", size: 12)
        self.lblNextSentence!.textColor = StorySlam.colorDarkPurple
        self.scrollView!.addSubview(self.lblNextSentence!)
        
        self.txtNextSentence = UITextView()
        self.txtNextSentence!.textColor = StorySlam.colorBlue
        self.txtNextSentence!.backgroundColor = StorySlam.colorWhite
        self.txtNextSentence!.font = UIFont(name: "OpenSans", size: 14)
        self.txtNextSentence!.layer.cornerRadius = 20
        self.txtNextSentence!.returnKeyType = .Default
        self.txtNextSentence!.tintColor = StorySlam.colorBlue
        self.txtNextSentence!.delegate = self
        self.txtNextSentence!.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        self.scrollView!.addSubview(self.txtNextSentence!)
        
        self.btnDone = UIButton()
        self.btnDone!.setTitle("Submit", forState: .Normal)
        self.btnDone!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnDone!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnDone!.backgroundColor = StorySlam.colorGold
        self.btnDone!.layer.cornerRadius = 20
        self.btnDone!.addTarget(self, action: Selector("submitNextSentence"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnDone!)
        
        self.lineOr1 = UIView()
        self.lineOr1!.backgroundColor = StorySlam.colorBlue
        self.lineOr1!.layer.cornerRadius = 1
        self.scrollView!.addSubview(self.lineOr1!)
        
        self.lineOr2 = UIView()
        self.lineOr2!.backgroundColor = StorySlam.colorBlue
        self.lineOr2!.layer.cornerRadius = 1
        self.scrollView!.addSubview(self.lineOr2!)
        
        self.lblOr = UILabel()
        self.lblOr!.text = "OR"
        self.lblOr!.font = UIFont(name: "OpenSans", size: 14)
        self.lblOr!.textColor = StorySlam.colorBlue
        self.lblOr!.textAlignment = .Center
        self.scrollView!.addSubview(self.lblOr!)
        
        self.btnEndStory = UIButton()
        self.btnEndStory!.setTitle("Submit & End", forState: .Normal)
        self.btnEndStory!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        self.btnEndStory!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnEndStory!.backgroundColor = StorySlam.colorOrange
        self.btnEndStory!.layer.cornerRadius = 20
        self.btnEndStory!.addTarget(self, action: Selector("showEndStoryModal:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnEndStory!)
        
        self.lblCurrentAuthor = UILabel()
        self.lblCurrentAuthor!.text = "Current Author"
        self.lblCurrentAuthor!.textColor = StorySlam.colorBlue
        self.lblCurrentAuthor!.font = UIFont(name: "OpenSans", size: 12)
        self.scrollView!.addSubview(self.lblCurrentAuthor!)
        
        self.btnCurrentAuthor = UIButton()
        self.btnCurrentAuthor!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnCurrentAuthor!.backgroundColor = StorySlam.colorWhite
        self.btnCurrentAuthor!.setTitleColor(StorySlam.colorBlue, forState: .Normal)
        self.btnCurrentAuthor!.layer.cornerRadius = 20
        self.btnCurrentAuthor!.addTarget(self, action: Selector("goToCurrentAuthor:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnCurrentAuthor!)
        
        self.lblNextAuthor = UILabel()
        self.lblNextAuthor!.text = "Next Author"
        self.lblNextAuthor!.textColor = StorySlam.colorGold
        self.lblNextAuthor!.font = UIFont(name: "OpenSans", size: 12)
        self.scrollView!.addSubview(self.lblNextAuthor!)
        
        self.btnNextAuthor = UIButton()
        self.btnNextAuthor!.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnNextAuthor!.backgroundColor = StorySlam.colorWhite
        self.btnNextAuthor!.setTitleColor(StorySlam.colorGold, forState: .Normal)
        self.btnNextAuthor!.layer.cornerRadius = 20
        self.btnNextAuthor!.addTarget(self, action: Selector("goToNextAuthor:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnNextAuthor!)
        
        
        
        
        self.lblLoadingError = UILabel()
        self.lblLoadingError!.text = "Loading..."
        self.lblLoadingError!.textAlignment = .Center
        self.lblLoadingError!.textColor = StorySlam.colorGray
        self.lblLoadingError!.font = UIFont(name: "OpenSans", size: 18)
        
        
        
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
        
        self.lblSIMTitleVal.text = self.open_story!.title
        self.lblSIMTitleVal.textColor = StorySlam.colorBlue
        self.lblSIMTitleVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMTitleVal)
        
        self.lblSIMAuthorsKey.text = "Authors"
        self.lblSIMAuthorsKey.textColor = StorySlam.colorBlue
        self.lblSIMAuthorsKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMAuthorsKey)
        
        for i in 1...5 {
            let lblSIMAuthorVal = UIButton()
            lblSIMAuthorVal.setTitleColor(StorySlam.colorBlue, forState: .Normal)
            lblSIMAuthorVal.titleLabel!.font = UIFont(name: "OpenSans", size: 12)
            lblSIMAuthorVal.tag = i
            lblSIMAuthorVal.contentHorizontalAlignment = .Left
            lblSIMAuthorVal.addTarget(self, action: Selector("goToAuthor:"), forControlEvents: .TouchUpInside)
            self.lblSIMAuthorsVals.append(lblSIMAuthorVal)
        }
        
        self.lblSIMGenreKey.text = "Genre"
        self.lblSIMGenreKey.textColor = StorySlam.colorBlue
        self.lblSIMGenreKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMGenreKey)
        
        self.lblSIMGenreVal.text = self.open_story!.genre
        self.lblSIMGenreVal.textColor = StorySlam.colorBlue
        self.lblSIMGenreVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMGenreVal)

        self.lblSIMLengthKey.text = "Length"
        self.lblSIMLengthKey.textColor = StorySlam.colorBlue
        self.lblSIMLengthKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMLengthKey)
        
        self.lblSIMLengthVal.text = "\(self.open_story!.num_sentences) sentence" + (Int(self.open_story!.num_sentences)! == 1 ? "" : "s")
        self.lblSIMLengthVal.textColor = StorySlam.colorBlue
        self.lblSIMLengthVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMLengthVal)
        
        self.lblSIMStateKey.text = "State"
        self.lblSIMStateKey.textColor = StorySlam.colorBlue
        self.lblSIMStateKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMStateKey)
        
        if(self.open_story!.sentences_fulfilled!) {
            self.lblSIMStateVal.text = "Length fulfilled"
        } else {
            self.lblSIMStateVal.text = "Length not yet fulfilled"
        }
        self.lblSIMStateVal.textColor = StorySlam.colorBlue
        self.lblSIMStateVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMStateVal)
        
        self.lblSIMCreatedKey.text = "Created"
        self.lblSIMCreatedKey.textColor = StorySlam.colorBlue
        self.lblSIMCreatedKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMCreatedKey)
        
        self.lblSIMCreatedVal.textColor = StorySlam.colorBlue
        self.lblSIMCreatedVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSIM.addSubview(self.lblSIMCreatedVal)
        
        self.btnSIMClose.setTitle("Close", forState: .Normal)
        self.btnSIMClose.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnSIMClose.backgroundColor = StorySlam.colorBlue
        self.btnSIMClose.layer.cornerRadius = 20
        self.btnSIMClose.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSIMClose.addTarget(self, action: Selector("hideStoryInfo"), forControlEvents: .TouchUpInside)
        self.storyInfoModal.addSubview(self.btnSIMClose)
        
        // Sentence Details Modal (SDM)
        self.sentenceDetailsModal.backgroundColor = StorySlam.colorYellow
        self.sentenceDetailsModal.layer.cornerRadius = 20
        
        self.sentenceDetailsModal.addSubview(self.svSDM)
        
        self.lblSDMHeading.text = "Sentence Details"
        self.lblSDMHeading.textColor = StorySlam.colorBlue
        self.lblSDMHeading.font = UIFont(name: "OpenSans", size: 24)
        self.sentenceDetailsModal.addSubview(self.lblSDMHeading)
        
        self.lblSDMText.textColor = StorySlam.colorBlue
        self.lblSDMText.font = UIFont(name: "OpenSans", size: 16)
        self.lblSDMText.numberOfLines = 0
        self.svSDM.addSubview(self.lblSDMText)
        
        self.lblSDMAuthorKey.text = "Author"
        self.lblSDMAuthorKey.textColor = StorySlam.colorBlue
        self.lblSDMAuthorKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSDM.addSubview(self.lblSDMAuthorKey)
        
        self.lblSDMAuthorVal.setTitleColor(StorySlam.colorBlue, forState: .Normal)
        self.lblSDMAuthorVal.titleLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.lblSDMAuthorVal.contentHorizontalAlignment = .Left
        self.lblSDMAuthorVal.addTarget(self, action: Selector("goToSentenceAuthor"), forControlEvents: .TouchUpInside)
        self.svSDM.addSubview(self.lblSDMAuthorVal)
        
        self.lblSDMDateKey.text = "Written"
        self.lblSDMDateKey.textColor = StorySlam.colorBlue
        self.lblSDMDateKey.font = UIFont(name: "OpenSans", size: 12)
        self.svSDM.addSubview(self.lblSDMDateKey)
        
        self.lblSDMDateVal.textColor = StorySlam.colorBlue
        self.lblSDMDateVal.font = UIFont(name: "OpenSans", size: 12)
        self.svSDM.addSubview(self.lblSDMDateVal)
        
        self.btnSDMClose.setTitle("Close", forState: .Normal)
        self.btnSDMClose.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnSDMClose.backgroundColor = StorySlam.colorBlue
        self.btnSDMClose.layer.cornerRadius = 20
        self.btnSDMClose.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnSDMClose.addTarget(self, action: Selector("hideSentenceDetailsModal"), forControlEvents: .TouchUpInside)
        self.sentenceDetailsModal.addSubview(self.btnSDMClose)
        
        
        // Prompt Details Modal (SDM)
        self.promptDetailsModal.backgroundColor = StorySlam.colorYellow
        self.promptDetailsModal.layer.cornerRadius = 20
        
        self.promptDetailsModal.addSubview(self.svPDM)
        
        self.lblPDMHeading.text = "Prompt Details"
        self.lblPDMHeading.textColor = StorySlam.colorBlue
        self.lblPDMHeading.font = UIFont(name: "OpenSans", size: 24)
        self.promptDetailsModal.addSubview(self.lblPDMHeading)
        
        self.lblPDMText.textColor = StorySlam.colorBlue
        self.lblPDMText.font = UIFont(name: "OpenSans", size: 16)
        self.lblPDMText.numberOfLines = 0
        self.svPDM.addSubview(self.lblPDMText)
        
        self.lblPDMGenreKey.text = "Genre"
        self.lblPDMGenreKey.textColor = StorySlam.colorBlue
        self.lblPDMGenreKey.font = UIFont(name: "OpenSans", size: 12)
        self.svPDM.addSubview(self.lblPDMGenreKey)
        
        self.lblPDMGenreVal.text = self.open_story!.genre
        self.lblPDMGenreVal.textColor = StorySlam.colorBlue
        self.lblPDMGenreVal.font = UIFont(name: "OpenSans", size: 12)
        self.svPDM.addSubview(self.lblPDMGenreVal)
        
        self.btnPDMClose.setTitle("Close", forState: .Normal)
        self.btnPDMClose.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnPDMClose.backgroundColor = StorySlam.colorBlue
        self.btnPDMClose.layer.cornerRadius = 20
        self.btnPDMClose.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnPDMClose.addTarget(self, action: Selector("hidePromptDetailsModal"), forControlEvents: .TouchUpInside)
        self.promptDetailsModal.addSubview(self.btnPDMClose)
        
        
        // End Story Modal (ESM)
        self.endStoryModal.backgroundColor = StorySlam.colorYellow
        self.endStoryModal.layer.cornerRadius = 20
        
        self.endStoryModal.addSubview(self.svESM)
        
        self.lblESMHeading.text = "End Story"
        self.lblESMHeading.textColor = StorySlam.colorBlue
        self.lblESMHeading.font = UIFont(name: "OpenSans", size: 24)
        self.endStoryModal.addSubview(self.lblESMHeading)
    
        self.lblESMMessage.text = "Are you sure?"
        self.lblESMMessage.numberOfLines = 0
        self.lblESMMessage.textColor = StorySlam.colorBlue
        self.lblESMMessage.font = UIFont(name: "OpenSans", size: 14)
        self.svESM.addSubview(self.lblESMMessage)
        
        self.btnESMCancel.setTitle("Cancel", forState: .Normal)
        self.btnESMCancel.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnESMCancel.backgroundColor = StorySlam.colorDarkGray
        self.btnESMCancel.layer.cornerRadius = 20
        self.btnESMCancel.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnESMCancel.addTarget(self, action: Selector("hideEndStoryModal"), forControlEvents: .TouchUpInside)
        self.endStoryModal.addSubview(self.btnESMCancel)
        

        self.btnESMRequest.setTitle("End", forState: .Normal)
        self.btnESMRequest.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnESMRequest.backgroundColor = StorySlam.colorOrange
        self.btnESMRequest.layer.cornerRadius = 20
        self.btnESMRequest.titleLabel!.font = UIFont(name: "OpenSans", size: 18)
        self.btnESMRequest.addTarget(self, action: Selector("requestEndStory"), forControlEvents: .TouchUpInside)
        self.endStoryModal.addSubview(self.btnESMRequest)
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: calculateHeight(46), width: self.myWidth!, height: 46)
        self.imgBackIcon!.frame = CGRect(x: 46-24, y: 0, width: 15, height: 46)
        self.imgClockIcon!.frame = CGRect(x: self.myWidth! - 18-10-32-2, y: 0, width: 18, height: 46)
        self.lblExpiration!.frame = CGRect(x: self.myWidth! - 10-32, y: 0, width: 32, height: 46)
        
        let lblTitleSize = self.lblStoryTitle!.sizeThatFits(CGSizeMake(self.myWidth!-30-18-5-40, CGFloat.max))
        self.lblStoryTitle!.frame = CGRect(x: 15, y: 16, width: self.myWidth!-30-18-5-40, height: lblTitleSize.height)
        var topMarginInfo = CGFloat(20)
        if(lblTitleSize.height > 40) {
            topMarginInfo = 20 + (lblTitleSize.height-40)/2
        }
        
        self.lblStoryInfo!.frame = CGRect(x: self.myWidth!-30-18-5, y: topMarginInfo, width: 40, height: 40)
        
        let lblStorySize = self.lblStory!.sizeThatFits(CGSizeMake(self.myWidth!-20, CGFloat.max))
        self.lblStoryHeight = lblStorySize.height
        
        self.lblStory!.frame = CGRect(x: 10, y: 16+lblTitleSize.height+20, width: self.myWidth!-20, height: self.lblStoryHeight)
        
        self.lblLoadingError!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20, width: self.myWidth!-30, height: 40)
     
        
        
        var bottomHeight: CGFloat = 0
        
        if(self.open_story!.is_my_turn!) {
            
            self.lblNextSentence!.frame = CGRect(x: 20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20, width: self.myWidth!-40, height: 14)
            
            self.txtNextSentence!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+14+2, width: self.myWidth!-30, height: 80)
            
            
            self.btnDone!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+14+2+80+10, width: self.myWidth!-30, height: 40)
            
            bottomHeight += 14+2+80+10+40
            
            if(self.open_story!.sentences_fulfilled!) {
                self.lineOr1!.frame = CGRect(x: 20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+bottomHeight+40, width: (self.myWidth!/2)-40, height: 2)
                self.lineOr2!.frame = CGRect(x: (self.myWidth!/2)+20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+bottomHeight+40, width: (self.myWidth!/2)-40, height: 2)
                self.lblOr!.frame = CGRect(x: (self.myWidth!/2)-20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+bottomHeight+40-7, width: 40, height: 14)
                bottomHeight += 40+2+40
                
                self.btnEndStory!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+bottomHeight, width: self.myWidth!-30, height: 40)
                bottomHeight += 40
               
            }
        } else {
            self.lblCurrentAuthor!.frame = CGRect(x: 20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20, width: self.myWidth!-40, height: 14)
            self.btnCurrentAuthor!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+14, width: self.myWidth!-30, height: 40)
            self.lblNextAuthor!.frame = CGRect(x: 20, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+14+40+10, width: self.myWidth!-40, height: 14)
            self.btnNextAuthor!.frame = CGRect(x: 15, y: 16+lblTitleSize.height+20+self.lblStoryHeight+20+14+40+10+14, width: self.myWidth!-30, height: 40)
            bottomHeight += 14+40+10+14+40
        }
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, 16+lblTitleSize.height+20+self.lblStoryHeight+20+bottomHeight+20)

        if(self.firstLoadScroll && self.scrollView!.contentSize.height > self.scrollView!.bounds.size.height) {
            let bottomOffset = CGPointMake(0, self.scrollView!.contentSize.height - self.scrollView!.bounds.size.height)
            self.scrollView!.setContentOffset(bottomOffset, animated: true)
            self.firstLoadScroll = false
        }
        
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
        for (index, _) in self.info_all_authors {
            lblSIMAuthorsVals[index-1].frame = CGRect(x: modalKeyColWidth+15, y: modalSIMContentHeight+(14*CGFloat(index-1)), width: modalValColWidth-30, height: 16)
        }
        modalSIMContentHeight += CGFloat(self.info_all_authors.count*14)+10
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
        modalSIMContentHeight += 14+10
        self.btnSIMClose.frame = CGRect(x: 15, y: modalSIMHeight-15-40, width: modalWidth-30, height: 40)
        self.svSIM.contentSize = CGSizeMake(modalWidth, modalSIMContentHeight)
        
        //Sentence Details Modal (SDM)
        var modalSDMContentHeight: CGFloat = 0
        
        self.sentenceDetailsModal.frame = CGRect(x: 30, y: 0, width: modalWidth, height: modalSIMHeight)
        self.lblSDMHeading.frame = CGRect(x: 15, y: 10, width: modalWidth-30, height: 30)
        self.svSDM.frame = CGRect(x: 0, y: 10+30+5, width: modalWidth, height: modalSIMHeight-45-40-20)
        
        let lblSDMTextSize = self.lblSDMText.sizeThatFits(CGSizeMake(modalWidth-30, CGFloat.max))
        self.lblSDMText.frame = CGRect(x: 15, y: 5, width: modalWidth-30, height: lblSDMTextSize.height)
        modalSDMContentHeight += 5+lblSDMTextSize.height+20
        
        self.lblSDMAuthorKey.frame = CGRect(x: 15, y: modalSDMContentHeight, width: modalKeyColWidth-15, height: 14)
        self.lblSDMAuthorVal.frame = CGRect(x: modalKeyColWidth+15, y: modalSDMContentHeight, width: modalValColWidth-30, height: 16)
        
        modalSDMContentHeight += 14+10
        
        self.lblSDMDateKey.frame = CGRect(x: 15, y: modalSDMContentHeight, width: modalKeyColWidth-15, height: 14)
        self.lblSDMDateVal.frame = CGRect(x: modalKeyColWidth+15, y: modalSDMContentHeight, width: modalValColWidth-30, height: 16)
        
        modalSDMContentHeight += 14+10
        
        self.btnSDMClose.frame = CGRect(x: 15, y: modalSIMHeight-15-40, width: modalWidth-30, height: 40)
        self.svSDM.contentSize = CGSizeMake(modalWidth, modalSDMContentHeight)
        
        //Prompt Details Modal (PDM)
        var modalPDMContentHeight: CGFloat = 0
        
        self.promptDetailsModal.frame = CGRect(x: 30, y: 0, width: modalWidth, height: modalSIMHeight)
        self.lblPDMHeading.frame = CGRect(x: 15, y: 10, width: modalWidth-30, height: 30)
        self.svPDM.frame = CGRect(x: 0, y: 10+30+5, width: modalWidth, height: modalSIMHeight-45-40-20)
        
        let lblPDMTextSize = self.lblPDMText.sizeThatFits(CGSizeMake(modalWidth-30, CGFloat.max))
        self.lblPDMText.frame = CGRect(x: 15, y: 5, width: modalWidth-30, height: lblPDMTextSize.height)
        modalPDMContentHeight += 5+lblPDMTextSize.height+20
        
        self.lblPDMGenreKey.frame = CGRect(x: 15, y: modalPDMContentHeight, width: modalKeyColWidth-15, height: 14)
        self.lblPDMGenreVal.frame = CGRect(x: modalKeyColWidth+15, y: modalPDMContentHeight, width: modalValColWidth-30, height: 16)
        
        modalPDMContentHeight += 14+10
    
        self.btnPDMClose.frame = CGRect(x: 15, y: modalSIMHeight-15-40, width: modalWidth-30, height: 40)
        self.svPDM.contentSize = CGSizeMake(modalWidth, modalPDMContentHeight)
        
        //End Story Modal (ESM)
        var modalESMContentHeight: CGFloat = 0
        
        self.endStoryModal.frame = CGRect(x: 30, y: 0, width: modalWidth, height: modalSIMHeight)
        self.lblESMHeading.frame = CGRect(x: 15, y: 10, width: modalWidth-30, height: 30)
        self.svESM.frame = CGRect(x: 0, y: 10+30+5, width: modalWidth, height: modalSIMHeight-45-40-20)
        
        let lblESMMessageSize = self.lblESMMessage.sizeThatFits(CGSizeMake(modalWidth-30, CGFloat.max))
        self.lblESMMessage.frame = CGRect(x: 15, y: 5, width: modalWidth-30, height: lblESMMessageSize.height)
        modalESMContentHeight += 5+lblESMMessageSize.height+20

        
        
        self.btnESMCancel.frame = CGRect(x: 15, y: modalSIMHeight-15-40, width: (modalWidth-30)/2-10, height: 40)
        self.btnESMRequest.frame = CGRect(x: (modalWidth-30)/2+10+15, y: modalSIMHeight-15-40, width: (modalWidth-30)/2-10, height: 40)
        self.svESM.contentSize = CGSizeMake(modalWidth, modalESMContentHeight)
        
    }
    
    
    override func tapRefresh(sender: AnyObject) {
        
        print("refresh tapped...")
        self.loadStory()
        appDelegate.mainViewController!.startRefreshButton()
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
    
    func loadError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.enableScrollview()
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            //show error message somehow
            self.lblLoadingError!.text = theTitle
        })
        
    }
    
    
    func loadStory() {
        dispatch_async(dispatch_get_main_queue(), {
            self.disableScrollview()
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
            self.lblStory!.removeFromSuperview()
            self.lblCurrentAuthor!.removeFromSuperview()
            self.btnCurrentAuthor!.removeFromSuperview()
            self.lblNextAuthor!.removeFromSuperview()
            self.btnNextAuthor!.removeFromSuperview()
            self.lblNextSentence!.removeFromSuperview()
            self.txtNextSentence!.removeFromSuperview()
            self.btnDone!.removeFromSuperview()
            self.lblOr!.removeFromSuperview()
            self.lineOr1!.removeFromSuperview()
            self.lineOr2!.removeFromSuperview()
            self.btnEndStory!.removeFromSuperview()
            
            
            for lblSIMAuthorVal in self.lblSIMAuthorsVals {
                lblSIMAuthorVal.removeFromSuperview()
            }
            
            self.lblLoadingError!.text = "Loading..."
            self.scrollView!.addSubview(self.lblLoadingError!)
            
            
            
        })
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "getOpenStory", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.open_story!.id)])
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
                            
                            
                           dispatch_async(dispatch_get_main_queue(), {
                            if(!result["data"]["finished"].boolValue) {
                                self.info_all_authors.removeAll()
                                for (index,subJson):(String, JSON) in result["data"]["info"]["authors"] {
                                    let author = Friend(id: subJson["id"].intValue, username: subJson["username"].stringValue, firstname: subJson["firstname"].stringValue, lastname: subJson["lastname"].stringValue)
                                    
                                    self.info_all_authors[Int(index)!] = author
                                    
                                    self.lblSIMAuthorsVals[Int(index)!-1].setTitle("@" + subJson["username"].stringValue, forState: .Normal)
                                    self.svSIM.addSubview(self.lblSIMAuthorsVals[Int(index)!-1])
                                }
                            
                                self.info_created = result["data"]["info"]["created"].stringValue
                                self.info_length = result["data"]["info"]["length"].intValue
                                self.info_state = result["data"]["info"]["state"].stringValue
                            
                                self.lblSIMCreatedVal.text = self.info_created
                                self.lblSIMLengthVal.text = "\(self.info_length!) sentence" + (self.info_length == 1 ? "" : "s")
                                self.lblSIMStateVal.text = self.info_state
                            
                                self.open_story!.current_action_string = result["data"]["info"]["current_action_string"].stringValue
                                self.open_story!.sentences_fulfilled = result["data"]["info"]["sentences_fulfilled"].boolValue
                                self.open_story!.expiration_string = result["data"]["info"]["expiration_string"].stringValue
                                self.open_story!.expiration_string_short = result["data"]["info"]["expiration_string_short"].stringValue
                                self.open_story!.is_my_turn = result["data"]["info"]["my_turn"].boolValue

                            
                            
                                self.current_author_index = result["data"]["info"]["current_author_index"].intValue
                                self.next_author_index = result["data"]["info"]["next_author_index"].intValue
                            
                                let current_author_username = self.info_all_authors[self.current_author_index!]!.username
                            
                                let next_author_username = self.info_all_authors[self.next_author_index!]!.username
                            
                            
                                self.btnCurrentAuthor!.setTitle("@\(current_author_username)", forState: .Normal)
                                self.btnNextAuthor!.setTitle("@\(next_author_username)", forState: .Normal)
                            
                            
                                self.sentences.removeAll()
                                var story_string: String = ""
                                var is_prompt = true
                                for (sentenceIndex,subJsonOuter):(String, JSON) in result["data"]["sentences"] {
                                    
                                    var author = SSOpenStoryView.unknown_author
                                    if(subJsonOuter["author_index"].intValue != 0) {
                                        author = self.info_all_authors[subJsonOuter["author_index"].intValue]!
                                    }
                                    
                                    
                                    let sentence = Sentence.init(id: subJsonOuter["id"].intValue, text: subJsonOuter["text"].stringValue, author: author, date: subJsonOuter["date"].stringValue, is_prompt: is_prompt)
                                    
                                    
                                    self.sentences.append(sentence)
                                    story_string.appendContentsOf(sentence.text)
                                    is_prompt = false
                                    
                                }
                            
                                self.lblLoadingError!.removeFromSuperview()
                                self.lblStory!.text = story_string
                                    
                                let lblStorySize = self.lblStory!.sizeThatFits(CGSizeMake(self.myWidth!-20, CGFloat.max))
                                self.lblStoryHeight = lblStorySize.height
                            
                                self.scrollView!.addSubview(self.lblStory!)
                            
                                if(self.open_story!.is_my_turn!) {
                                    
                                    self.scrollView!.addSubview(self.lblNextSentence!)
                                    self.scrollView!.addSubview(self.txtNextSentence!)
                                    self.scrollView!.addSubview(self.btnDone!)
                                    
                                    if(self.open_story!.sentences_fulfilled!) {
                                        
                                        self.scrollView!.addSubview(self.lineOr1!)
                                        self.scrollView!.addSubview(self.lineOr2!)
                                        self.scrollView!.addSubview(self.lblOr!)
                                        self.scrollView!.addSubview(self.btnEndStory!)
                                        
                                    }
                                } else {
                                    
                                    self.scrollView!.addSubview(self.lblCurrentAuthor!)
                                    self.scrollView!.addSubview(self.btnCurrentAuthor!)
                                    self.scrollView!.addSubview(self.lblNextAuthor!)
                                    self.scrollView!.addSubview(self.btnNextAuthor!)
                                    
                                }
                            
                                self.lblExpiration!.text = result["data"]["info"]["expiration_string_short"].stringValue

                                self.firstLoadScroll = true
                     
                                self.setupFrames()
                                
                                
                                self.enableScrollview()
                                self.appDelegate.mainViewController!.stopRefreshButton()
                                
                                //show error message somehow
                            } else {
                                self.hideEndStoryModal()
                                self.hideStoryInfo()
                                self.hideSentenceDetailsModal()
                                self.hidePromptDetailsModal()
                                SSUserPill.appDelegate.mainViewController!.setHomeContentView(SSHomeView())
                                
                            }
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
    
    
    
    
    func storyTapped(recognizer: UITapGestureRecognizer) {
        if let textView = recognizer.view as? UITextView {
            let layoutManager = textView.layoutManager
            var location: CGPoint = recognizer.locationInView(textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            
            let charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            self.showSentenceInfo(charIndex)
            
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
        
        
    }
    
    
    func showSentenceInfo(charIndex: Int) {
        var currentIndex = charIndex+1
        var selectedSentence: Sentence?
        var is_prompt = false
        for (index, sentence) in self.sentences.enumerate() {
            currentIndex -= sentence.text.characters.count
            if(currentIndex <= 0) {
                selectedSentence = sentence
                if(index == 0) {
                    is_prompt = true
                }
                break
            }
        }
        if selectedSentence != nil {
            if(is_prompt) {
                self.lblPDMText.text = selectedSentence!.text
                
                self.showPromptDetailsModal()
            } else {
                self.lblSDMText.text = selectedSentence!.text
                self.lblSDMAuthorVal.setTitle("@" + selectedSentence!.author!.username, forState: .Normal)
                self.lblSDMDateVal.text = selectedSentence!.date
                
                self.sentenceAuthor = selectedSentence!.author!
                
                self.showSentenceDetailsModal()
            }
        }
    }
    
    func goToCurrentAuthor(sender: AnyObject) {
        self.goToUser(self.info_all_authors[self.current_author_index!])
    }
    
    func goToNextAuthor(sender: AnyObject) {
        self.goToUser(self.info_all_authors[self.next_author_index!])
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
        self.goToUser(self.info_all_authors[sender.tag])
    }
    
    func showSentenceDetailsModal() {
        self.disableScrollview()
        
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.sentenceDetailsModal, atIndex: 15)
            })
        })
        
    }
    
    func hideSentenceDetailsModal() {
        self.sentenceAuthor = nil
        
        self.lblSDMDateVal.text = ""
        self.lblSDMAuthorVal.setTitle("", forState: .Normal)
        self.lblSDMText.text = ""

        
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.sentenceDetailsModal.removeFromSuperview()
        })
    }
    
    func showPromptDetailsModal() {
        self.disableScrollview()
        
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.promptDetailsModal, atIndex: 15)
            })
        })
        
    }
    
    func hidePromptDetailsModal() {
        
        self.lblPDMText.text = ""
        
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.promptDetailsModal.removeFromSuperview()
        })
    }
    
    func goToSentenceAuthor() {
        let author = self.sentenceAuthor
        self.hideSentenceDetailsModal()
        self.goToUser(author)
    }
    
    func showEndStoryModal(sender: AnyObject) {
        self.disableScrollview()
        
        appDelegate.mainViewController!.tintNavBar()
        appDelegate.hideMenuButton()
        
        
        //add modal to view and load
        dispatch_async(dispatch_get_main_queue(), {
            self.showTintLayer()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.endStoryModal, atIndex: 15)
            })
        })
    }
    
    func hideEndStoryModal() {
        
        self.enableScrollview()
        self.hideTintLayer()
        appDelegate.mainViewController!.untintNavBar()
        appDelegate.showMenuButton()
        
        
        //remove modal from view
        dispatch_async(dispatch_get_main_queue(), {
            self.endStoryModal.removeFromSuperview()
        })
    }
    
    
    
    func submitNextSentence() {
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
            self.btnEndStory!.enabled = false
            self.btnDone!.enabled = false
            self.txtNextSentence!.editable = false
            
        })
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "submitNextSentence", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.open_story!.id), "sentence": self.txtNextSentence!.text])
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
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.appDelegate.mainViewController!.stopRefreshButton()
                                self.loadStory()
                                self.btnEndStory!.enabled = true
                                self.btnDone!.enabled = true
                                self.txtNextSentence!.editable = true
                                self.txtNextSentence!.text = ""
                                
                            })
                            
                        } else {
                            self.nextSentenceError(result["message"].stringValue)
                        }
                    } else {
                        self.nextSentenceError("An error occurred.")

                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.nextSentenceError("An error occurred.")
            }
            
        } else {
            self.appDelegate.mainViewController!.logOut()
        }
       
        
    }
    
    func nextSentenceError(theTitle: String, theMessage: String = "Please try again.") {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.appDelegate.mainViewController!.stopRefreshButton()
            
            let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.btnEndStory!.enabled = true
            self.btnDone!.enabled = true
            self.txtNextSentence!.editable = true
            
        })
    }

    func requestEndStory() {
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_async(dispatch_get_main_queue(), {
                self.appDelegate.mainViewController!.startRefreshButton()
            })
            
            self.hideEndStoryModal()
            self.btnEndStory!.enabled = false
            self.btnDone!.enabled = false
            self.txtNextSentence!.editable = false
            
            
        })
        
        if(currentUser != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "requestEndStory", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "story_id": String(self.open_story!.id), "sentence": self.txtNextSentence!.text])
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
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.appDelegate.mainViewController!.stopRefreshButton()
                                SSUserPill.appDelegate.mainViewController!.setHomeContentView(SSMyFinishedStories())
                                
                            })
                            
                        } else {
                            self.nextSentenceError(result["message"].stringValue)
                        }
                    } else {
                        self.nextSentenceError("An error occurred.")
                        
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.nextSentenceError("An error occurred.")
            }
            
        } else {
            self.appDelegate.mainViewController!.logOut()
        }

    }
    
    
    
}
