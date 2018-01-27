//
//  FinishedStory.swift
//  StorySlam
//
//  Created by Mark Keller on 1/5/17.
//  Copyright © 2017 Mark Keller. All rights reserved.
//

import Foundation

class FinishedStory {
    var id: Int!
    var title: String!
    var genre: String!
    var authors = [Friend]()
    var content: String!
    var created_at: String!
    var finished_at: String!
    var link: String!
    var num_likes: Int!
    var random: Bool!
    var length: Int!
    var liked_by_me: Bool!
    
    init(id: Int, title: String, genre: String, authors: [Friend], content: String, created_at: String, finished_at: String, link: String, num_likes: Int, random: Bool, length: Int, liked_by_me: Bool) {
        self.id = id
        self.title = title
        self.genre = genre
        self.authors = authors
        self.content = content.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.created_at = created_at
        self.finished_at = finished_at
        self.link = link
        self.num_likes = num_likes
        self.random = random
        self.length = length
        self.liked_by_me = liked_by_me
    }
    
    func getAuthorsText() -> String{
        var authorsText = "Written by "
        for (index, author) in self.authors.enumerate() {
            authorsText += "@" + author.username
            if(self.authors.count - 1 == index) {
                authorsText += "."
            }
            if(self.authors.count == 2) {
                if(index == 0) {
                    authorsText += " and "
                }
            } else if(self.authors.count > 2) {
                if(self.authors.count - 2 == index) {
                    authorsText += ", and "
                } else if(self.authors.count - 2 > index) {
                    authorsText += ", "
                }
            }
        }
        return authorsText
    }
    
}