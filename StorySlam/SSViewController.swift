//
//  SSViewController.swift
//  StorySlam
//
//  Created by Mark Keller on 7/10/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class SSViewController: UIViewController {
    
    var ssLoadingOpen = false
    var ssTintOpen = false
    var ssLoadingTintLayer = UIView()
    var ssLoadingView: UIView? = nil
    var ssLoadingActivityIndicator: UIActivityIndicatorView? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tintColor = UIColor.blackColor().colorWithAlphaComponent(StorySlam.tintValue)
        self.ssLoadingTintLayer.backgroundColor = tintColor
        
        self.setSSLoaderFrames()
        
    }
    
    func showTintLayer() {
        dispatch_async(dispatch_get_main_queue(), {
    
            self.view.insertSubview(self.ssLoadingTintLayer, atIndex: 12)

            self.ssTintOpen = true
            
        })
    }
    func hideTintLayer() {
        dispatch_async(dispatch_get_main_queue(), {
            
            if(self.ssTintOpen) {
                self.ssLoadingTintLayer.removeFromSuperview()
            }
            self.ssTintOpen = false
        })
    }
    
    func showLoadingOverlay() {
        dispatch_async(dispatch_get_main_queue(), {
            self.ssLoadingOpen = true
            
            self.showTintLayer()
            
            
            
            self.ssLoadingView = UIView()
            
            self.ssLoadingView!.backgroundColor = UIColor.clearColor()
            
            self.ssLoadingActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            
            self.ssLoadingActivityIndicator!.startAnimating()
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.ssLoadingActivityIndicator!, atIndex: 13)
            })
            
            dispatch_async(dispatch_get_main_queue(), {
                self.view.insertSubview(self.ssLoadingView!, atIndex: 11)
            })
            
            self.setSSLoaderFrames()
        })

    }
    
    func hideLoadingOverlay() {
        dispatch_async(dispatch_get_main_queue(), {
        
            if(self.ssLoadingOpen) {
                self.ssLoadingActivityIndicator!.stopAnimating()
                self.ssLoadingView!.removeFromSuperview()
                self.hideTintLayer()
            }
            self.ssLoadingOpen = false
        })
        
    }
    
    func setSSLoaderFrames() {
        if(self.ssLoadingOpen) {
            ssLoadingTintLayer.frame = self.view.bounds
            ssLoadingView!.frame = self.view.bounds
            ssLoadingActivityIndicator!.frame = self.view.bounds
        }
    }
    
    
    func setSSTintFrame() {
        if(self.ssTintOpen) {
            ssLoadingTintLayer.frame = self.view.bounds
        }
    }
   /* override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.setSSLoaderFrames()
    }*/
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setSSLoaderFrames()
        self.setSSTintFrame()
    }
    
    
}