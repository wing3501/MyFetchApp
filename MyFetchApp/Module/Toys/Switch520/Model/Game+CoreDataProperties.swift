//
//  Game+CoreDataProperties.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/11.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var datetime: String?
    @NSManaged public var downloadAdress: String?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var category: NSOrderedSet?

}

// MARK: Generated accessors for category
extension Game {

    @objc(insertObject:inCategoryAtIndex:)
    @NSManaged public func insertIntoCategory(_ value: GameCategory, at idx: Int)

    @objc(removeObjectFromCategoryAtIndex:)
    @NSManaged public func removeFromCategory(at idx: Int)

    @objc(insertCategory:atIndexes:)
    @NSManaged public func insertIntoCategory(_ values: [GameCategory], at indexes: NSIndexSet)

    @objc(removeCategoryAtIndexes:)
    @NSManaged public func removeFromCategory(at indexes: NSIndexSet)

    @objc(replaceObjectInCategoryAtIndex:withObject:)
    @NSManaged public func replaceCategory(at idx: Int, with value: GameCategory)

    @objc(replaceCategoryAtIndexes:withCategory:)
    @NSManaged public func replaceCategory(at indexes: NSIndexSet, with values: [GameCategory])

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: GameCategory)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: GameCategory)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSOrderedSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSOrderedSet)

}

extension Game : Identifiable {

}
