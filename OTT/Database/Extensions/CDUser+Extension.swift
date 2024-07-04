//
//  CDUser+Extension.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

extension CDUser {
    
    func convertToUser() -> User
    {
        return User(
            pKey: self.primaryKey!,
            email: self.email!
        )
    }
    
    // MARK: Helper methods
    private func convertToVideoProgresses() -> [VideoProgress] {
        guard self.toVideoProgresses != nil else {
            return []
        }
        
        var videoProgresses = [VideoProgress]()
        
        self.toVideoProgresses?.forEach({ (cdVideoProgress) in
            videoProgresses.append(cdVideoProgress.convertToVideoProgress())
        })
        
        return videoProgresses
    }
    
}
