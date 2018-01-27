//
//  SSRadioButton.swift
//  StorySlam
//
//  Created by Mark Keller on 7/28/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSRadioButton: UIView {
    
    static var imageOpen: UIImage = UIImage(named: "circle_o-blue")!
    static var imageChosen: UIImage = UIImage(named: "circle-blue")!
    
    static let rowHeight: CGFloat = 30
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var rowID: Int?
    var rowName: String?
    var parent: SSContentView?
    var group: SSRadioButtonGroup?
    
    var rowImageView: UIImageView?
    var rowLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initialize(rowID: Int, rowName: String, group: SSRadioButtonGroup, width: CGFloat) {
        
        self.rowID = rowID
        self.rowName = rowName
        self.group = group
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: Selector("tapSelf:")))
        dispatch_async(dispatch_get_main_queue(), {
            self.setupViews()
            dispatch_async(dispatch_get_main_queue(), {
                self.setupFrames(width)
            })
        })
        
        
        
        
    }
    
    func setupViews() {
        dispatch_async(dispatch_get_main_queue(), {
        self.rowImageView = UIImageView()
        self.rowImageView!.image = SSRadioButton.imageOpen
        self.rowImageView!.contentMode = .ScaleAspectFit
        self.addSubview(self.rowImageView!)
        
        self.rowLabel = UILabel()
        if(self.rowName != nil) {
            self.rowLabel!.text = self.rowName!
        }
        self.rowLabel!.textColor = StorySlam.colorBlue
        self.rowLabel!.font = UIFont(name: "OpenSans", size: 14)
        self.rowLabel!.textAlignment = .Left
        self.addSubview(self.rowLabel!)
        })
    }
    
    func setupFrames(width: CGFloat) {
        if(self.rowImageView != nil) {
            self.rowImageView!.frame = CGRect(x: 20, y: 5, width: SSRadioButton.rowHeight-10, height: SSRadioButton.rowHeight-10)
            self.rowLabel!.frame = CGRect(x: 58, y: 0, width: width-58, height: SSRadioButton.rowHeight)
        }
        
        
    }
    
    
    
    func tapSelf(sender: AnyObject) {
        
        self.group!.choose(self.rowID!)
        
    }
    
    func setChosen(chosen: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
        if(chosen) {
            self.rowImageView!.image = SSRadioButton.imageChosen
        } else {
            self.rowImageView!.image = nil
            self.rowImageView!.image = SSRadioButton.imageOpen
        }
        })
    }
    
}