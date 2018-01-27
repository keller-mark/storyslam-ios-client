//
//  CurrentUser.swift
//  StorySlam
//
//  Created by Mark Keller on 7/16/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation

class CurrentUser: NSObject, NSCoding {
    var user_id: Int?
    var token: String?
    var username: String?
    var firstname: String?
    var lastname: String?
    var friends = [Friend]()
    var email: String?
    var has_agreed_eula: Bool?

    
    required convenience init(coder decoder: NSCoder) {
        //decode vars
        let user_id = decoder.decodeObjectForKey("user_id") as! Int?
        let token = decoder.decodeObjectForKey("token") as! String?
        let username = decoder.decodeObjectForKey("username") as! String?
        let firstname = decoder.decodeObjectForKey("firstname") as! String?
        let lastname = decoder.decodeObjectForKey("lastname") as! String?
        let friends = decoder.decodeObjectForKey("friends") as! [Friend]
        let email = decoder.decodeObjectForKey("email") as! String?
        let has_agreed_eula = decoder.decodeObjectForKey("has_agreed_eula") as! Bool?

        
        //initialize object
        self.init()
        self.user_id = user_id
        self.token = token
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.friends = friends
        self.email = email
        self.has_agreed_eula = has_agreed_eula

        
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(user_id, forKey: "user_id")
        encoder.encodeObject(token, forKey: "token")
        encoder.encodeObject(username, forKey: "username")
        encoder.encodeObject(firstname, forKey: "firstname")
        encoder.encodeObject(lastname, forKey: "lastname")
        encoder.encodeObject(friends, forKey: "friends")
        encoder.encodeObject(email, forKey: "email")
        encoder.encodeObject(has_agreed_eula, forKey: "has_agreed_eula")

        
    }
    
    func getFullname() -> String{
        return "\(self.firstname!) \(self.lastname!)"
    }


    
}