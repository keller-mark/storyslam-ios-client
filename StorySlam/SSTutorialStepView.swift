//
//  SSTutorialStepView.swift
//  StorySlam
//
//  Created by Mark Keller on 7/13/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSTutorialStepView: UIView {
    
    var tutorialParent: SSTutorialView?
    
    var myWidth: CGFloat? = nil
    var myHeight: CGFloat? = nil
    
    var stepText: String?
    var stepIcon: String?
    
    var isFirstStep: Bool?
    var isLastStep: Bool?

    
    var imgIcon: UIImageView? = nil
    var lblText: UILabel? = nil
    var btnNext: UIButton? = nil
    var btnBack: UIButton? = nil
    var btnFinish: UIButton? = nil
    
    var verticalMargins = [CGFloat]()
    
    
    

    
    func initialize(parent: SSTutorialView, stepText: String, stepIcon: String, isFirstStep: Bool = false, isLastStep: Bool = false) {
        
        self.tutorialParent = parent
        
        self.stepText = stepText
        self.stepIcon = stepIcon
        self.isFirstStep = isFirstStep
        self.isLastStep = isLastStep
        
        
        
        self.setupViews()
        
    }
    
    func setupViews() {
        
   
        
        self.imgIcon = UIImageView()
        self.imgIcon!.image = UIImage(named: self.stepIcon!)
        self.imgIcon!.contentMode = .ScaleAspectFit
        
        self.lblText = UILabel()
        self.lblText!.numberOfLines = 0
        self.lblText!.text = self.stepText
        self.lblText!.textColor = StorySlam.colorDarkPurple
        self.lblText!.backgroundColor = StorySlam.colorClear
        self.lblText!.textAlignment = .Center
        self.lblText!.font = UIFont(name: "OpenSans", size: 14)
        
        
        
        
        
        self.btnNext = UIButton()
        self.btnNext!.layer.cornerRadius = 20
        self.btnNext!.backgroundColor = StorySlam.colorBlue
        self.btnNext!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
        if(!self.isLastStep!) {
            self.btnNext!.setTitle("Next", forState: .Normal)
        } else {
            self.btnNext!.setTitle("Done", forState: .Normal)
        }
        self.btnNext!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
        self.btnNext!.addTarget(self.tutorialParent!, action: Selector("nextStep:"), forControlEvents: .TouchUpInside)
        
        if(!self.isFirstStep!) {
            self.btnBack = UIButton()
            self.btnBack!.layer.cornerRadius = 20
            self.btnBack!.backgroundColor = StorySlam.colorBlue
            self.btnBack!.titleLabel!.font = UIFont(name: "OpenSans", size: 24)
          
            self.btnBack!.setTitle("Back", forState: .Normal)
         
            self.btnBack!.setTitleColor(StorySlam.colorYellow, forState: .Normal)
            self.btnBack!.addTarget(self.tutorialParent!, action: Selector("prevStep:"), forControlEvents: .TouchUpInside)
        }
        
        
        
        
        
    }
    func setupFrames(width: CGFloat) {
        self.verticalMargins.removeAll()
        
        self.myWidth = width
        self.myHeight = self.bounds.height
        
        self.imgIcon!.frame = CGRect(x: 15, y: calculateHeight(56, marginTop: 0, marginBottom: 25), width: self.myWidth!-30, height: 56)
        self.addSubviewIfNot(self.imgIcon!)
        
        let lblTextSize = self.lblText!.sizeThatFits(CGSizeMake(self.myWidth!-30, CGFloat.max))

        self.lblText!.frame = CGRect(x: 15, y: calculateHeight(lblTextSize.height, marginBottom: 20), width: self.myWidth!-30, height: lblTextSize.height)
        self.addSubviewIfNot(self.lblText!)
        
        if(self.isFirstStep!) {
            self.btnNext!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10, marginBottom: 10), width: self.myWidth!-30, height: 40)
        } else {
            self.btnBack!.frame = CGRect(x: 15, y: calculateHeight(40, marginTop: 10, marginBottom: 10), width: (self.myWidth!-30)/2-5, height: 40)
            self.btnNext!.frame = CGRect(x: 15+(self.myWidth!-30)/2+5, y: calculateHeight(40, marginTop: 10, marginBottom: 10, add: false), width: (self.myWidth!-30)/2-5, height: 40)
            
            self.addSubviewIfNot(self.btnBack!)
        }
        self.addSubviewIfNot(self.btnNext!)
            
        
        
    }
    
    func addSubviewIfNot(subview: UIView) {
        if(!self.subviews.contains(subview)) {
            self.addSubview(subview)
            print("Adding subview..")
        }
    }
 
    
    func calculateHeight(height: CGFloat = 0, marginTop: CGFloat = 0, marginBottom: CGFloat = 0, add: Bool = true) -> CGFloat {
        
        if(marginTop != 0) {
            if(add) {
                self.verticalMargins.append(marginTop)
            }
        }
        
        var totalHeight: CGFloat = 0
        for margin in self.verticalMargins {
            totalHeight += margin
        }
        if(add) {
            self.verticalMargins.append(height)
        }
        
        
        if(marginBottom != 0) {
            if(add) {
                self.verticalMargins.append(marginBottom)
            }
        }
        if(add) {
            return totalHeight
        } else {
            return totalHeight - height - marginTop
        }
    }
    
    
    

    
    
    
    
}