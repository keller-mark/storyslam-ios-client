//
//  OpenStory.swift
//  StorySlam
//
//  Created by Mark Keller on 8/30/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation

class OpenStory {
    var id: Int!
    var title: String!
    var genre: String!
    var initiator: Friend!
    var expiration_string: String!
    var expiration_string_short: String!
    var current_action_string: String!
    var num_sentences: String!
    var sentences_fulfilled: Bool!
    var is_my_turn: Bool!
    var is_initiator: Bool!
    var all_players: [Friend]?
    
    
    init(id: Int, title: String, genre: String, initiator: Friend, expiration_string: String, expiration_string_short: String, current_action_string: String, num_sentences: String, sentences_fulfilled: Bool, all_players: [Friend]?, is_my_turn: Bool, is_initiator: Bool) {
        self.id = id
        self.title = title
        self.genre = genre
        self.initiator = initiator
        self.expiration_string = expiration_string
        self.expiration_string_short = expiration_string_short
        self.current_action_string = current_action_string
        self.num_sentences = num_sentences
        self.sentences_fulfilled = sentences_fulfilled
        self.all_players = all_players
        self.is_my_turn = is_my_turn
        self.is_initiator = is_initiator
    }
    
}