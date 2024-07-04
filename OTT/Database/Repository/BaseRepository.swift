//
//  BaseRepository.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

protocol BaseRepository {
    
    associatedtype T
    
    func create(record: T)
    func getAll() -> [T]
    func get(by pKey: UUID) -> T?
    func update(record: T) -> Bool
    func delete(by pKey: UUID) -> Bool
    
}
