//
//  GameCategory+CoreDataProperties.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/11.
//
//

import Foundation
import CoreData


extension GameCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameCategory> {
        return NSFetchRequest<GameCategory>(entityName: "GameCategory")
    }

    @NSManaged public var name: String?
    @NSManaged public var game: Game?

}

extension GameCategory : Identifiable {

}
