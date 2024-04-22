//
//  TrackerStore.swift
//  Tracker
//
//  Created by Bakhadir on 29.03.2024.
//

import UIKit
import CoreData

struct TrackerStoreUpdate {
    let insertedSections: IndexSet
    let insertedIndexPaths: [IndexPath]
}

private enum TrackerStoreError: Error {
    case decodingErrorInvalidID
}



// MARK: - Protocols

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidUpdate(_ update: TrackerStoreUpdate)
}

protocol TrackerStoreProtocol {
    func setDelegate(_ delegate: TrackerStoreDelegate)
    func fetchTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker
    func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory) throws
}

// MARK: - TrackerStore

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    // MARK: - Properties
    weak var delegate: TrackerStoreDelegate?
    private var insertedSections: IndexSet = []
    private var insertedIndexPaths: [IndexPath] = []
    private var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.convertToTracker(from: $0) })
        else { return [] }
        return trackers
    }
    private let uiColorMarshalling = UIColorMarshalling()
    
    private lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
        TrackerCategoryStore.shared
    }()
    
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: false)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        try? controller.performFetch()
        return controller
    }()
    
    // MARK: - Init
    
    private convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("UIApplication is not AppDelegate") }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Private functions
    
    private func convertToTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.idTracker,
              let title = trackerCoreData.title,
              let colorString = trackerCoreData.color,
              let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidID
        }
        
        let color = uiColorMarshalling.color(from: colorString)
        let schedule = Weekday.calculateScheduleArray(from: trackerCoreData.schedule)
        
        return Tracker(
            id: id,
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }
    
    private func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.idTracker = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = Weekday.calculateScheduleValue(for: tracker.schedule)
        trackerCoreData.category = trackerCategoryCoreData
        
        try saveContext()
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate(
            TrackerStoreUpdate(
                insertedSections: insertedSections,
                insertedIndexPaths: insertedIndexPaths
            )
        )
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}

// MARK: - TrackerStoreProtocol

extension TrackerStore: TrackerStoreProtocol {
    
    func setDelegate(_ delegate: TrackerStoreDelegate) {
        self.delegate = delegate
    }
    
    func fetchTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        try convertToTracker(from: trackerCoreData)
    }
    
    func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory) throws {
        try addTracker(tracker, to: category)
    }
}
