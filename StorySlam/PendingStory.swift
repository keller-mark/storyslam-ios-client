//
//  PendingStory.swift
//  StorySlam
//
//  Created by Mark Keller on 8/30/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation

class PendingStory {
    var id: Int!
    var title: String!
    var genre: String!
    var initiator: Friend!
    var expiration_string: String!
    var all_players: [Friend]?
    var pending_players: [Friend]?
    
    init(id: Int, title: String, genre: String, initiator: Friend, expiration_string: String, all_players: [Friend]?, pending_players: [Friend]?) {
        self.id = id
        self.title = title
        self.genre = genre
        self.initiator = initiator
        self.expiration_string = expiration_string
        self.all_players = all_players
        self.pending_players = pending_players

    }
    
}