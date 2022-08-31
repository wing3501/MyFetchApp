//
//  CoreDataStack.swift
//  MyFetchApp
//
//  Created by styf on 2022/8/31.
//

import Foundation
import CoreData

class CoreDataStack {
    let modelName: String
    let inMemory: Bool

    public init(modelName: String,inMemory: Bool = false) {
        self.modelName = modelName
        self.inMemory = inMemory
    }
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }

    public func saveContext() {
        guard mainContext.hasChanges else { return }
        saveContext(mainContext)
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        if context != mainContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
            
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.saveContext(self.mainContext)
        }
    }
}
