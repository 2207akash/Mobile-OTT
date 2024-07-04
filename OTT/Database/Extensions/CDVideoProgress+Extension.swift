//
//  CDVideoProgress+Extension.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

extension CDVideoProgress {
    
    func convertToVideoProgress() -> VideoProgress
    {
        return VideoProgress(
            pKey: self.primaryKey!,
            id: self.id!,
            lastPlayedTime: self.lastPlayedTime
        )
    }
    
}
