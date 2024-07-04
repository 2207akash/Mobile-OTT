//
//  CDUser+CoreDataProperties.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var primaryKey: UUID?
    @NSManaged public var email: String?
    @NSManaged public var toVideoProgresses: Set<CDVideoProgress>?

}

// MARK: Generated accessors for toVideoProgresses
extension CDUser {

    @objc(addToVideoProgressesObject:)
    @NSManaged public func addToToVideoProgresses(_ value: CDVideoProgress)

    @objc(removeToVideoProgressesObject:)
    @NSManaged public func removeFromToVideoProgresses(_ value: CDVideoProgress)

    @objc(addToVideoProgresses:)
    @NSManaged public func addToToVideoProgresses(_ values: Set<CDVideoProgress>)

    @objc(removeToVideoProgresses:)
    @NSManaged public func removeFromToVideoProgresses(_ values: Set<CDVideoProgress>)

}

extension CDUser : Identifiable {

}
