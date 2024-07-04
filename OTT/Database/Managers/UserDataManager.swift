//
//  UserDataManager.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

struct UserDataManager {
    
    private let _userDataRepository = UserDataRepository()
    
    // MARK: CRUD
    func createUser(record: User)
    {
        _userDataRepository.create(record: record)
    }
    
    func getUserByEmail(email: String) -> User?
    {
        return _userDataRepository.getUserByEmail(email: email)
    }
    
    func get(by pKey: UUID) -> User?
    {
        return _userDataRepository.get(by: pKey)
    }
    
    func getAll() -> [User]
    {
        return _userDataRepository.getAll()
    }
    
    func update(record: User) -> Bool
    {
        return _userDataRepository.update(record: record)
    }
    
    func delete(by pKey: UUID) -> Bool
    {
        return _userDataRepository.delete(by: pKey)
    }
    
}


extension UserDataManager {
    
    // MARK: Relationships
    func addVideoProgressRelationToUser(videoProgresses: [VideoProgress], user: User)
    {
        return _userDataRepository.addVideoProgressesRelationToUser(
            videoProgresses: videoProgresses,
            user: user
        )
    }
    
}
