//
//  TrackerStore.swift
//  Tracker
//
//  Created by Bakhadir on 29.03.2024.
//

import Foundation
import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store(insertedIndexes: [IndexPath], deletedIndexes: IndexSet)
}

final class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: IndexSet?
    
    private let uiColorMarshalling = UIColorMarshalling()
    private let scheduleConvertor = ScheduleConvertor()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true),
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(tracker: Tracker, forCategory category: String) throws {
        let objects = self.fetchedResultsController.fetchedObjects
        
        let trackerCoreData = TrackerCoreData(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        
        do {
            let categoryData = try trackerCategoryStore.fetchCategory(name: category)
            trackerCoreData.category = categoryData
        } catch {
            throw CategoryStoreError.fetchingCategoryError
        }
        
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.title = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleConvertor.convertScheduleToUInt16(from: tracker.schedule)
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchTracker(trackerId: UUID) throws -> TrackerCoreData {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), trackerId as CVarArg)
        
        let result = try context.fetch(request)
        
        guard let result = result.first else {
            throw TrackerStoreError.fetchingTrackerError
        }
        return result
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(insertedIndexes: insertedIndexes!, deletedIndexes: deletedIndexes!)
        
        insertedIndexes?.removeAll()
        deletedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.append(indexPath)
        case .delete:
            guard let indexPath = newIndexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        @unknown default:
            break
        }
    }
}
