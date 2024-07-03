//
//  HomeVideoListSection.swift
//  OTT
//
//  Created by Akash Sen on 30/06/24.
//

import Foundation

struct HomeVideoListSection: Codable {
    let sectionTitle, sectionType: String
    let videos: [Video]

    enum CodingKeys: String, CodingKey {
        case sectionTitle = "section_title"
        case sectionType = "section_type"
        case videos
    }
}
