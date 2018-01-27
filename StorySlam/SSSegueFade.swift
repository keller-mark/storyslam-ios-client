//
//  SSSegueFade.swift
//  StorySlam
//
//  Created by Mark Keller on 7/9/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit


class SSSegueFade: UIStoryboardSegue {
    
    override func perform() {
        let source = sourceViewController as UIViewController
        let destination = destinationViewController as UIViewController
        let window = UIApplication.sharedApplication().keyWindow!
        
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            source.view.alpha = 0.0
            destination.view.alpha = 1.0
            }) { (finished) -> Void in
                source.view.alpha = 1.0
                source.presentViewController(destination, animated: false, completion: nil)
        }
    }
}