//
//  Invitation.swift
//  StorySlam
//
//  Created by Mark Keller on 7/29/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation

class Invitation {
    var id: Int!
    var story_id: Int!
    var story_title: String!
    var story_genre: String!
    var initiator: Friend!
    var expiration_string: String!
    var all_players: [Friend]?
    
    
    init(id: Int, story_id: Int, story_title: String, story_genre: String, initiator: Friend, expiration_string: String, all_players: [Friend]?) {
        self.id = id
        self.story_id = story_id
        self.story_title = story_title
        self.story_genre = story_genre
        self.initiator = initiator
        self.expiration_string = expiration_string
        self.all_players = all_players
    }
    
}