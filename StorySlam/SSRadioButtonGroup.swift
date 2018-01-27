//
//  SSRadioButtonGroup.swift
//  StorySlam
//
//  Created by Mark Keller on 7/28/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSRadioButtonGroup: UIView {
    
    static var imageOpen: UIImage = UIImage(named: "user_o-blue")!
    static var imageChosen: UIImage = UIImage(named: "globe-blue")!
    
    static let rowHeight: CGFloat = 30
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var parent: SSRadioButtonGroupParent?
    
    var buttons = [SSRadioButton]()
    
    var totalHeight: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initialize(data: [Int:String], width: CGFloat, parent: SSRadioButtonGroupParent) {
        dispatch_async(dispatch_get_main_queue(), {
            self.parent = parent
            self.userInteractionEnabled = true
            self.buttons.removeAll()
            for data_row in data.enumerate() {
                let button = SSRadioButton()
                dispatch_async(dispatch_get_main_queue(), {
                button.initialize(data_row.element.0, rowName: data_row.element.1, group: self, width: width)
                self.buttons.append(button)
                self.addSubview(button)
                })
            
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.setupFrames(width)
            })
        })
        
        
        
    }
    
    func setupFrames(width: CGFloat) {
        dispatch_async(dispatch_get_main_queue(), {
        for button in self.buttons.enumerate() {
            button.element.setupFrames(width)
            button.element.frame = CGRect(x: 0, y: CGFloat(button.index)*(SSRadioButton.rowHeight+5), width: width, height: SSRadioButton.rowHeight)
        }
     
        self.totalHeight = (CGFloat(self.buttons.count)*(SSRadioButton.rowHeight+5))
        })
    }
    
    func choose(button_id: Int) {
        dispatch_async(dispatch_get_main_queue(), {
        for button in self.buttons.enumerate() {
            if(button.element.rowID != nil) {
                if(button.element.rowID! == button_id) {
                    button.element.setChosen(true)
                    self.parent!.chooseRadioButton(self, rowID: button.element.rowID!, rowName: button.element.rowName!)
                    print("choosing \(button.element.rowID!)")
                } else {
                    button.element.setChosen(false)
                    print("not choosing \(button.element.rowID!)")
                }
            }
        }
        })
    }
    
    
    
}