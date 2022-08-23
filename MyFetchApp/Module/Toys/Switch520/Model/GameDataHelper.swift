//
//  GameDataHelper.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/10.
//

import Foundation
import CoreData
import UIKit

class GameDataHelper {
    
    static let shared = GameDataHelper()
    
    init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Game520")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // NSManagedObjectModel表示数据模型中的每种对象类型，它们的属性以及之间的关系。Core Data stack的其他部分使用它来创建对象、存储属性、保存数据
    // NSPersistentStore使用不同的存储方式进行读写数据。NSQLiteStoreType、NSXMLStoreType（OSX特有）、NSBinaryStoreType、NSInMemoryStoreType
    // NSPersistentStoreCoordinator 是 NSManagedObjectModel 和 NSPersistentStore之间的桥梁。它了解NSManagedObjectModel，并发送数据给Store,也从Store抓取数据。
            //也隐藏了一些底层细节。比如NSManagedObjectContext不需要了解它使用的是哪种存储。针对不同的NSPersistentStore，提供了统一的接口去操作NSManagedObjectContext
    // NSManagedObjectContext是一个内存草稿箱。所有Core Data objects都在一个上下文中。
            // 1 NSManagedObjectContext 管理着 NSManagedObject的生命周期，无论是创建的，还是抓取的
            // 2 NSManagedObjectContext 和 NSManagedObject 关系非常耦合  game.managedObjectContext
            // 3 NSManagedObject一旦与某个上下文关联，则整个生命周期都保持这种关联
            // 4 一个应用可以使用多个上下文。因为NSManagedObjectContext是内存暂存器、草稿箱，所以把相同的数据对象加载到不同的上下文
            // 5 NSManagedObjectContext 和 NSManagedObject都不是线程安全的
    // NSPersistentContainer iOS10新增的一个组件，协调上面四个Core Data Stack类。它是一个将所有内容放在一起的容器。您不必浪费时间编写样板代码来将所有四个堆栈组件连接在一起，只需初始化NSPersistentContainer，加载其持久存储，就可以了。
    
    
    func save(_ games: [Switch520Game]) -> [Game] {
        let managedContext = persistentContainer.viewContext
        
        //新增的方式1
//        let entity = NSEntityDescription.entity(forEntityName: "Game", in: managedContext)!
//        var game = NSManagedObject(entity: entity, insertInto: managedContext)
//        game.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        
        //新增的方式2
//        var game = Game(context: managedContext)
        
        //新增的方式3
//        let game = NSEntityDescription.insertNewObject(forEntityName: "Game", into: managedContext)
        
        var results: [Game] = []
        for gameObj in games {
            let categorys = gameObj.category.map { name in
                let category = GameCategory(context: managedContext)
                category.name = name
                return category
            }
            
            let game = Game(context: managedContext)
            Switch520Game.game(from: gameObj, to: game)
            game.addToCategory(NSOrderedSet(array: categorys))
            
            results.append(game)
        }
        
        try? managedContext.save()
        return results
    }
    
    func fetch() -> [Game] {
        let managedContext = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
//        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        let fetchRequest = Game.fetchRequest()
        //条数
//        let count = try! managedContext.count(for: fetch)
        
        //过滤
//        fetchRequest.predicate = NSPredicate(format: "title != nil")
//        fetchRequest.predicate = NSPredicate(
//            format: "%K = %@",
//            argumentArray: [#keyPath(Game.title), firstTitle])
        
        let games = (try? managedContext.fetch(fetchRequest)) ?? []
        return games
    }
}
