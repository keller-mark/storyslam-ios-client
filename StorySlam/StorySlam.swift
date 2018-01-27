//
//  StorySlam.swift
//  StorySlam
//
//  Created by Mark Keller on 7/9/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class StorySlam {
    
    static let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    static var colorDarkPurple: UIColor {
        return UIColor(red: 95/255.0, green: 62/255.0, blue: 124/255.0, alpha: 1)
    }
    static var colorLightPurple: UIColor {
        return UIColor(red: 158/255.0, green: 127/255.0, blue: 161/255.0, alpha: 1)
    }
    static var colorWhite: UIColor {
        return UIColor(red: 250/255.0, green: 244/255.0, blue: 245/255.0, alpha: 1)
    }
    static var colorOrange: UIColor {
        return UIColor(red: 235/255.0, green: 112/255.0, blue: 105/255.0, alpha: 1)
    }
    static var colorYellow: UIColor {
        return UIColor(red: 247/255.0, green: 242/255.0, blue: 152/255.0, alpha: 1)
    }
    
    static var colorDarkGray: UIColor {
        return UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1)
    }
    static var colorGold: UIColor {
        return UIColor(red: 175/255.0, green: 155/255.0, blue: 70/255.0, alpha: 1)
    }
    static var colorBlue: UIColor {
        return UIColor(red: 101/255.0, green: 119/255.0, blue: 196/255.0, alpha: 1)
    }
    static var colorGreen: UIColor {
        return UIColor(red: 90/255.0, green: 200/255.0, blue: 130/255.0, alpha: 1)
    }
    static var colorLightBlue: UIColor {
        return UIColor(red: 178/255.0, green: 228/255.0, blue: 248/255.0, alpha: 1)
    }
    static var colorLightOrange: UIColor {
        return UIColor(red: 255/255.0, green: 152/255.0, blue: 146/255.0, alpha: 1)
    }
    static var colorLightGray: UIColor {
        return UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1)
    }
    static var colorLightGreen: UIColor {
        return UIColor(red: 184/255.0, green: 233/255.0, blue: 134/255.0, alpha: 1)
    }
    static var colorGray: UIColor {
        return UIColor(red: 155/255.0, green: 155/255.0, blue: 155/255.0, alpha: 1)
    }
    static var colorFacebookBlue: UIColor {
        return UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
    }
    static var colorClear: UIColor {
        return UIColor.clearColor()
    }
    
    
    static var tintValue: CGFloat = 0.7
    
    static let baseURL = "http://markk.co/apps/storyslam"
    
    static let termsURL = StorySlam.baseURL + "/terms-and-conditions"
    static let eulaURL = StorySlam.baseURL + "/eula"
    static let websiteURL = StorySlam.baseURL + "/"
    
    static let actionURL = StorySlam.baseURL + "/app/action.php?from=app&a="
    
    static let preferences = NSUserDefaults.standardUserDefaults()
    
    static var loggedIn = false


    static var device_token: String?
   
    static func getCurrentUser() -> CurrentUser? {
        if(StorySlam.preferences.objectForKey("current_user") != nil) {
            let encodedObject = StorySlam.preferences.objectForKey("current_user") as! NSData
            let currentUser = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as! CurrentUser
            return currentUser
        } else {
            return nil
        }
    }
    
    static func hasAdBar() -> Bool {
        if(StorySlam.preferences.objectForKey("has_ads") != nil) {
            return StorySlam.preferences.boolForKey("has_ads")
        } else {
            return false
        }
    }
    
    static func setCurrentUser(user: CurrentUser) {
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(user)
        StorySlam.preferences.setObject(encodedData, forKey: "current_user")
        StorySlam.preferences.synchronize()
        
        if(StorySlam.appDelegate.menuViewController != nil) {
            StorySlam.appDelegate.menuViewController!.updateProfile()
        }
    }

    static func logOut() {
        let user = StorySlam.getCurrentUser()
        StorySlam.preferences.setValue(nil, forKey: "current_user")
        
        StorySlam.preferences.setBool(false, forKey: "has_ads")
        StorySlam.preferences.synchronize()
        
        print("logging out...")
        if(user != nil && user!.username != nil && user!.token != nil) {
            
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "logout", parameters: ["username":user!.username!, "token": user!.token!])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            print(result["message"].stringValue)
                            
                        } else {
                            print(result["message"].stringValue)                        }
                    } else {
                        print("An error occurred while logging out.")
                    }
                    
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
            
            
            
            
        } else {
            print("An error occurred while logging out: Username and token not present.")
        }

    }
    
   /* static func hasFinishedTutorial() -> Bool {
        let currentUser = StorySlam.getCurrentUser()
        if(currentUser != nil) {
            return currentUser!.hasFinishedTutorial
        } else {
            return false
        }
    }
    
    static func setFinishedTutorial() {
        let currentUser = StorySlam.getCurrentUser()
        currentUser!.hasFinishedTutorial = true
        StorySlam.setCurrentUser(currentUser!)
    }*/
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    static func sendDeviceToken() {
        let currentUser = StorySlam.getCurrentUser()
        
        if(StorySlam.device_token != nil && currentUser != nil) {
            do {
                let opt = try HTTP.POST(StorySlam.actionURL + "sendDeviceToken", parameters: ["username":currentUser!.username!, "token": currentUser!.token!, "device_token": StorySlam.device_token!])
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        return //also notify app of failure as needed
                    }
                    
                    let result = JSON(data: response.data)
                    if(result["message"].string != nil) {
                        if(result["success"].boolValue == true) {
                            
                            print("Device token sent!")

                        } else {
                            print("error: " + result["message"].stringValue)
                        }
                    } else {
                        print("error: " + "An error occurred.")
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }

        }
    }
    
    
    
    
    
    

    
    struct FriendState: OptionSetType {
        let rawValue : Int
        init(rawValue:Int){ self.rawValue = rawValue}
        
        static let Friends  = FriendState(rawValue:1)
        static let RequestSent  = FriendState(rawValue:2)
        static let RequestReceived = FriendState(rawValue:3)
        static let NotFriends = FriendState(rawValue:4)
    }
    
    
    

}