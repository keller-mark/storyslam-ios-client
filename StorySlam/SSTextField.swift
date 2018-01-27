//
//  SSTextField.swift
//  StorySlam
//
//  Created by Mark Keller on 7/9/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSTextField: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 20
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}