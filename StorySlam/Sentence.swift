//
//  Sentence.swift
//  StorySlam
//
//  Created by Mark Keller on 1/3/17.
//  Copyright © 2017 Mark Keller. All rights reserved.
//

import Foundation

class Sentence {
    var id: Int!
    var text: String!
    var author: Friend?
    var is_prompt: Bool!
    var date: String!
    
    init(id: Int, text: String, author: Friend?, date: String, is_prompt: Bool = false) {
        self.id = id
        self.text = text.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.author = author
        self.date = date
        self.is_prompt = is_prompt
    }
    
}