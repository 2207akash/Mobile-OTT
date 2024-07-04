//
//  UserDataRepository.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation
import CoreData

protocol UserRepository: BaseRepository {
    
}

class UserDataRepository: UserRepository {
    
    func create(record: User) {
        let cdUser = CDUser(context: PersistentStorage.getInstance().context)
        
        cdUser.primaryKey = record.pKey
        cdUser.email = record.email
        
        PersistentStorage.getInstance().saveContext()
    }
    
    func getUserByEmail(email: String) -> User? {
        return getAll().filter { $0.email == email }.first
    }
    
    func getAll() -> [User] {
        let records = PersistentStorage.getInstance().fetchManagedObject(managedObject: CDUser.self)
        
        // Check if any record exists in database or not
        guard let records = records, records.count != 0 else {
            return []
        }
        
        var results: [User] = []
        records.forEach({ (cdUser) in
            results.append(cdUser.convertToUser())
        })
        
        return results
    }
    
    func get(by pKey: UUID) -> User? {
        let cdUser = getCdUser(by: pKey)
        
        // Check if record exists in database or not
        guard let cdUser = cdUser else {
            return nil
        }
        
        return cdUser.convertToUser()
    }
    
    func update(record: User) -> Bool {
        let cdUser = getCdUser(by: record.pKey)
        
        // Check if record exists in database or not
        guard let cdUser = cdUser else {
            return false
        }

        cdUser.email = record.email
        
        PersistentStorage.getInstance().saveContext()
        return true
    }
    
    func delete(by pKey: UUID) -> Bool {
        let cdUser = getCdUser(by: pKey)
        
        // Check if record exists in database or not
        guard let cdUser = cdUser else {
            return false
        }
        
        PersistentStorage.getInstance().context.delete(cdUser)
        PersistentStorage.getInstance().saveContext()
        
        return true
    }
    
    
    typealias T = User
    
}


extension UserDataRepository {
    
    // MARK: Fetch an object
    private func getCdUser(by pKey: UUID) -> CDUser?
    {
        let fetchRequest = NSFetchRequest<CDUser>(entityName: "CDUser")
        let fetchById = NSPredicate(format: "primaryKey==%@", pKey as CVarArg)
        fetchRequest.predicate = fetchById
        
        let result = try! PersistentStorage.getInstance().context.fetch(fetchRequest)
        guard result.count != 0 else { return nil }
        
        return result.first
    }
    
    private func getCdVideoProgress(by pKey: UUID) -> CDVideoProgress?
    {
        let fetchRequest = NSFetchRequest<CDVideoProgress>(entityName: "CDVideoProgress")
        let fetchById = NSPredicate(format: "primaryKey==%@", pKey as CVarArg)
        fetchRequest.predicate = fetchById
        
        let result = try! PersistentStorage.getInstance().context.fetch(fetchRequest)
        guard result.count != 0 else { return nil }
        
        return result.first
    }
    
}


extension UserDataRepository {
    
    // MARK: Add relations
    func addVideoProgressesRelationToUser(videoProgresses: [VideoProgress], user: User) {
        let cdUser = getCdUser(by: user.pKey)
        guard let cdUser = cdUser else {
            return
        }
        if !videoProgresses.isEmpty {
            var videoProgressSets = Set<CDVideoProgress>()
            videoProgresses.forEach { videoProgress in
                if let cdVideoProgress = getCdVideoProgress(by: videoProgress.pKey) {
                    videoProgressSets.insert(cdVideoProgress)
                }
            }
            cdUser.addToToVideoProgresses(videoProgressSets)
            PersistentStorage.getInstance().saveContext()
            return
        }
        return
    }
    
}
