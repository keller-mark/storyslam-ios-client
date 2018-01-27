//
//  Prompt.swift
//  StorySlam
//
//  Created by Mark Keller on 7/26/16.
//  Copyright © 2016 Mark Keller. All rights reserved.
//

import Foundation
import UIKit

class Prompt {
    var id: Int!
    var genre: Genre!
    var text: String!
    var author: Friend?
    
    init(id: Int, text: String, genre: Genre, author: Friend? = nil) {
        self.id = id
        self.text = text
        self.genre = genre
        self.author = author
    }
    
}