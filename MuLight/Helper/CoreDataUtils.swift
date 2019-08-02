//
//  CoreDataUtils.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataStack {
    static func createMuLightContainer(completion: @escaping (NSPersistentContainer?) -> ()) {
        let container = NSPersistentContainer(name: "MuLight")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                print("we might have an upgrade database issue.")
                DPrint("Failed to load store: \(error!)")
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
}

protocol MuLightContext {
    var muLightContext: NSManagedObjectContext { get }
}

extension MuLightContext {
    var muLightContext: NSManagedObjectContext {
        return AppDelegate.instance.persistentContainer.viewContext
    }
}

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.fetchBatchSize = 25
        request.returnsObjectsAsFaults = false
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name! }
}

extension NSManagedObjectContext {
    func insertObject<Object: NSManagedObject>() -> Object where Object: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: Object.entityName, into: self) as? Object else {
            fatalError("Wrong object type")
        }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            print(error)
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
