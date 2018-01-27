//
//  SSTutorialView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/13/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSTutorialView: SSContentView {
    
    var currentStep: Int?
    
    var steps = [SSTutorialStepView]()
    
    var lblTitle: UILabel? = nil
    var lblFraction: UILabel? = nil
    
    var btnSkip: UIButton? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setupViews()
        self.setupFrames()
        
        appDelegate.hideMenuButton()
    }
    override func setupViews() {
        self.hasTitleBar = true
        super.setupViews()
        
        
        self.scrollView!.backgroundColor = StorySlam.colorYellow
        
        self.lblTitle = UILabel()
        self.lblTitle!.text = "Tutorial"
        self.lblTitle!.textAlignment = .Center
        self.lblTitle!.textColor = StorySlam.colorYellow
        self.lblTitle!.backgroundColor = StorySlam.colorDarkPurple
        self.lblTitle!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblTitle!)
        
        
        
        self.lblFraction = UILabel()
        self.lblFraction!.text = ""
        self.lblFraction!.textAlignment = .Center
        self.lblFraction!.textColor = StorySlam.colorYellow
        self.lblFraction!.backgroundColor = StorySlam.colorClear
        self.lblFraction!.font = UIFont(name: "OpenSans", size: 18)
        self.view.addSubview(self.lblFraction!)
        
        self.steps.removeAll()
        
        self.steps.append(SSTutorialStepView())
        let step1Text = "Stories in StorySlam consist of at least 10 sentences, written by two to five authors.\n\nEach story begins with a prompt of a specific genre chosen by spinning the prompt wheel.\n\nThe initiator of the story creates the story title and spins the prompt wheel."
        self.steps[0].initialize(self, stepText: step1Text, stepIcon: "story-dark_purple", isFirstStep: true)
        
        
        self.steps.append(SSTutorialStepView())
        let step2Text = "Sentences are written in turns, beginning with the author who initiated the Story.\n\nAuthors have up to 24 hours to complete each turn."
        self.steps[1].initialize(self, stepText: step2Text, stepIcon: "rocket-dark_purple")
        
        self.steps.append(SSTutorialStepView())
        let step3Text = "If an author fails to complete their turn within 24 hours, the turn will pass to the next author.\n\nAdditionally, if a story invitation does not receive a reply within 24 hours, the receiving author will not be added to the story."
        self.steps[2].initialize(self, stepText: step3Text, stepIcon: "clock-dark_purple", isLastStep:true)
        
        
 
        
        
        self.btnSkip = UIButton()
        self.btnSkip!.setTitle("Skip Tutorial", forState: .Normal)
        self.btnSkip!.setTitleColor(StorySlam.colorDarkPurple, forState: .Normal)
        self.btnSkip!.titleLabel!.font = UIFont(name: "OpenSans", size: 12)
        self.btnSkip!.backgroundColor = StorySlam.colorClear
        self.btnSkip!.addTarget(self, action: Selector("skipTutorial:"), forControlEvents: .TouchUpInside)
        self.scrollView!.addSubview(self.btnSkip!)
        
        
        self.step(0)
        
        
    }
    override func setupFrames() {
        super.setupFrames()
        
        self.lblTitle!.frame = CGRect(x: 0, y: 0, width: self.myWidth!, height: 46)
        self.lblFraction!.frame = CGRect(x: self.myWidth!-60, y: 0, width: 40, height: 46)
        
        for step in self.steps {
            step.setupFrames(self.myWidth!)
            step.frame = CGRect(x: 0, y: 46, width: self.myWidth!, height: step.calculateHeight())
        }
        
        
        self.btnSkip!.frame = CGRect(x: 0, y: 46+self.steps[self.currentStep!].calculateHeight()+10, width: self.myWidth!, height: 16)
        
        
        
        self.scrollView!.contentSize = CGSizeMake(self.myWidth!, self.calculateHeight(add: false))
        
        
    }
    
    func nextStep(sender: AnyObject) {
        if(self.currentStep != nil) {
            if(self.currentStep! != self.steps.count - 1) {
                self.step(self.currentStep! + 1)
            } else {
                self.done()
            }
        }
    }
    func prevStep(sender: AnyObject) {
        if(self.currentStep != nil) {
            if(self.currentStep! != 0) {
                self.step(self.currentStep! - 1)
            }
        }
    }
    
    func step(num: Int) {
        self.currentStep = num
        
        for (index, step) in self.steps.enumerate() {
            if(index != num) {
                step.removeFromSuperview()
            } else if(!self.view.subviews.contains(step) && index == num) {
                self.scrollView!.addSubview(step)
            }
        }
        self.lblFraction!.text = String(num+1) + "/" + String(self.steps.count)
        self.setupFrames()
        
        
    }

    func done() {
        print("Tutorial done.")
        self.goToHome(nil)
        
    }
    
    func skipTutorial(sender: AnyObject) {
        self.done()
    }
    
    override func calculateHeight(height: CGFloat = 0, marginTop: CGFloat = 0, marginBottom: CGFloat = 0, add: Bool = true) -> CGFloat {
        return 46+self.steps[self.currentStep!].calculateHeight()+10+30
    }
    
    func goToHome(sender: AnyObject?) {
        appDelegate.showMenuButton()
        appDelegate.mainViewController!.setHomeContentView(SSHomeView())
    }
    
    
    
    
}