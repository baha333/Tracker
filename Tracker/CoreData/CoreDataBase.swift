//
//  CoreData.swift
//  Tracker
//
//  Created by Bakhadir on 28.03.2024.
//

//import Foundation
//import CoreData
//
//enum DataBaseError: Error {
//    case someError
//}
//
//final class CoreDataBase {
//    
//    private let modelName = "TrackerCoreData"
//    var context: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//    
//    private init() {
//        _ = persistentContainer
//    }
//    
//    static let shared = CoreDataBase()
//    
//    // MARK: - CoreDataStack
//    
//    private lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: modelName)
//        container.loadPersistentStores(completionHandler: { (storeDesciption, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//    
//    // MARK: - CoreDataSaving
//    
//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//}
