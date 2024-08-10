//
//  CoreDataService.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import CoreData



final class CoreDataService {

    static let shared = CoreDataService()

    private init() {}

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Cannot load PersistentStore : \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    func saveContext() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
                print("Success")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func deleteObject(model: FavouriteNewsModel) {
        context.delete(model)
    }

}
