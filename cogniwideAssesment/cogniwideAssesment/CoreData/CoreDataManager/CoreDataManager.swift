//
//  CoreDataManager.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 15/05/21.
//  Copyright © 2021 cogniwide. Agll rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    static func shared() -> CoreDataManagerProtocol
    func saveContext ()
    func saveDataInBackground()
    func prepare(_ posts: [PostElement])
    func createEntity(from post: PostElement) -> PostItem?
    func fetchPostItems() -> [PostItem]
    func updatePostItem(for id: Int64, isFavourite: Bool)
}


class CoreDataManager: NSObject, CoreDataManagerProtocol {

    private override init() {
        super.init()
    }
    // Create a shared Instance
    static private let instance = CoreDataManager()
    
    // Shared Function
    static func shared() -> CoreDataManagerProtocol {
        return instance
    }
    
    // Get the location where the core data DB is stored
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1])
        return urls[urls.count-1]
    }()
    
    private func applicationLibraryDirectory() {
        print(applicationDocumentsDirectory)
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
    
    // MARK: - Core Data stack
    
    // Get the managed Object Context
    lazy private var managedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "cogniwideAssesment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Save Data in background
    func saveDataInBackground() {
        persistentContainer.performBackgroundTask { (context) in
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func prepare(_ posts: [PostElement]) {
        // loop through all the data received from the Web and then convert to managed object and save them
        deleteAllData("PostItem")
        _ = posts.map {
            self.createEntity(from: $0)
        }
        saveContext()
    }
        
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedObjectContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func createEntity(from post: PostElement) -> PostItem? {
        let postItem = PostItem(context: managedObjectContext)
        postItem.title = post.title
        postItem.body = post.body
        postItem.id = post.id
        postItem.favourite = post.favourite ?? false
        return postItem
    }
    func fetchPostItems() -> [PostItem] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PostItem")
        request.returnsObjectsAsFaults = false
        do {
            if let postItems = try managedObjectContext.fetch(request) as? [PostItem] {
                return postItems
            }
        } catch let error {
            print("Got an error and description \(error.localizedDescription)")
        }
        return [PostItem]()
    }
    
    func updatePostItem(for id: Int64, isFavourite:Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PostItem")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %lld", id)
        do {
            if let postItem = try managedObjectContext.fetch(request).first as? PostItem {
                postItem.favourite = isFavourite
                saveDataInBackground()
            }
        } catch let error {
            print("Got an error and description \(error.localizedDescription)")
        }
    }
}

