//
//  VideoProgressDataManager.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

struct VideoProgressDataManager {
    
    private let _videoProgressDataRepository = VideoProgressDataRepository()
    
    // MARK: CRUD
    func createVideoProgress(record: VideoProgress)
    {
        _videoProgressDataRepository.create(record: record)
    }
    
    func getVideoProgressById(id: String) -> VideoProgress?
    {
        return _videoProgressDataRepository.getVideoProgressById(id: id)
    }
    
    func get(by pKey: UUID) -> VideoProgress?
    {
        return _videoProgressDataRepository.get(by: pKey)
    }
    
    func getAll() -> [VideoProgress]
    {
        return _videoProgressDataRepository.getAll()
    }
    
    func update(record: VideoProgress) -> Bool
    {
        return _videoProgressDataRepository.update(record: record)
    }
    
    func delete(by pKey: UUID) -> Bool
    {
        return _videoProgressDataRepository.delete(by: pKey)
    }
    
}
