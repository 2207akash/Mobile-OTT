//
//  VideoProgress.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

struct VideoProgress {
    let pKey: UUID
    var id: String
    var lastPlayedTime: Float
    
    init(pKey: UUID, id: String, lastPlayedTime: Float) {
        self.pKey = pKey
        self.id = id
        self.lastPlayedTime = lastPlayedTime
    }
}
