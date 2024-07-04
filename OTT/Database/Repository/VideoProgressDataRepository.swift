//
//  VideoProgressDataRepository.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation
import CoreData

protocol VideoProgressRepository: BaseRepository {
    
}

class VideoProgressDataRepository: VideoProgressRepository {
    
    typealias T = VideoProgress
    
    func create(record: VideoProgress) {
        let cdVideoProgress = CDVideoProgress(context: PersistentStorage.getInstance().context)
        
        cdVideoProgress.primaryKey = record.pKey
        cdVideoProgress.id = record.id
        cdVideoProgress.lastPlayedTime = record.lastPlayedTime
        
        PersistentStorage.getInstance().saveContext()
    }
    
    func getVideoProgressById(id: String) -> VideoProgress? {
        return getAll().filter { $0.id == id }.first
    }
    
    func getAll() -> [VideoProgress] {
        let records = PersistentStorage.getInstance().fetchManagedObject(managedObject: CDVideoProgress.self)
        
        // Check if any record exists in database or not
        guard let records = records, records.count != 0 else {
            return []
        }
        
        var results: [VideoProgress] = []
        records.forEach({ (cdVideoProgress) in
            results.append(cdVideoProgress.convertToVideoProgress())
        })
        
        return results
    }
    
    func get(by pKey: UUID) -> VideoProgress? {
        let cdVideoProgress = getCdVideoProgress(by: pKey)
        
        // Check if record exists in database or not
        guard let cdVideoProgress = cdVideoProgress else {
            return nil
        }
        
        return cdVideoProgress.convertToVideoProgress()
    }
    
    func update(record: VideoProgress) -> Bool {
        let cdVideoProgress = getCdVideoProgress(by: record.pKey)
        
        // Check if record exists in database or not
        guard let cdVideoProgress = cdVideoProgress else {
            return false
        }

        cdVideoProgress.id = record.id
        cdVideoProgress.lastPlayedTime = record.lastPlayedTime
        
        PersistentStorage.getInstance().saveContext()
        return true
    }
    
    func delete(by pKey: UUID) -> Bool {
        let cdHeadshotSet = getCdVideoProgress(by: pKey)
        
        // Check if record exists in database or not
        guard let cdHeadshotSet = cdHeadshotSet else {
            return false
        }
        
        PersistentStorage.getInstance().context.delete(cdHeadshotSet)
        PersistentStorage.getInstance().saveContext()
        
        return true
    }
    
}


extension VideoProgressDataRepository {
    
    // MARK: Fetch an object
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
