//
//  CoreDataStack.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import CoreData

class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        return context
    }()
    
    func saveWriteContext() {
        guard writeContext.hasChanges else { return }
        
        do {
            try writeContext.save()
        } catch {
            fatalError("Failed to save write context: \(error)")
        }
        
        saveMainContext()
    }
    
    func saveMainContext() {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch {
            fatalError("Failed to save main context: \(error)")
        }
    }
}

