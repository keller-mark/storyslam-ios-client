//
//  SSRadioButtonParent.swift
//  StorySlam
//
//  Created by Mark Keller on 7/28/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

protocol SSRadioButtonGroupParent {
    func chooseRadioButton(group: SSRadioButtonGroup, rowID: Int, rowName: String)
    
}