//
//  CDVideoProgress+CoreDataProperties.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//
//

import Foundation
import CoreData


extension CDVideoProgress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDVideoProgress> {
        return NSFetchRequest<CDVideoProgress>(entityName: "CDVideoProgress")
    }

    @NSManaged public var primaryKey: UUID?
    @NSManaged public var id: String?
    @NSManaged public var lastPlayedTime: Float

}

extension CDVideoProgress : Identifiable {

}
