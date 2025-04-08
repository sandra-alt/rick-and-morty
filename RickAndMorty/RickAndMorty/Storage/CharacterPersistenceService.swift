//
//  CharacterPersistenceService.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 08.04.2025.
//

import Foundation
import CoreData

class CharacterPersistenceService {
    
    private let persistentContainer: NSPersistentContainer

    init(containerName: String = "RickAndMorty") {
        self.persistentContainer = NSPersistentContainer(name: containerName)
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("\(error.userInfo)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("\(nserror.userInfo)")
            }
        }
    }
}
