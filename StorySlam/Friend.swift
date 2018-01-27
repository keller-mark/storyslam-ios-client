//
//  Friend.swift
//  StorySlam
//
//  Created by Mark Keller on 7/18/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
class Friend: NSObject, NSCoding{
    var id: Int!
    var username: String!
    var firstname: String!
    var lastname: String!


    init(id: Int, username: String, firstname: String, lastname: String) {
        self.id = id
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
    }
    
    required convenience init(coder decoder: NSCoder) {
        //decode vars
        let id = decoder.decodeObjectForKey("id") as! Int?
        let username = decoder.decodeObjectForKey("username") as! String?
        let firstname = decoder.decodeObjectForKey("firstname") as! String?
        let lastname = decoder.decodeObjectForKey("lastname") as! String?

        
        
        //initialize object
        self.init(id: id!, username: username!, firstname: firstname!, lastname: lastname!)
        
        
        
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(username, forKey: "username")
        encoder.encodeObject(firstname, forKey: "firstname")
        encoder.encodeObject(lastname, forKey: "lastname")

        
        
    }
    
    func getFullname() -> String{
        return "\(self.firstname) \(self.lastname)"
    }
    
}