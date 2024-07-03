//
//  Video.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import Foundation

struct Video: Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let thumb: String
    let url: String
    let movieTags: [String]
    
    enum CodingKeys: String, CodingKey {
        case description, id, thumb, title, url
        case movieTags = "movie_tags"
    }
    
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.id == rhs.id
    }
}
