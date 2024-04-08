//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Bakhadir on 03.04.2024.
//

import Foundation
import CoreData
import UIKit

protocol TrackerRecordStoreDelegate: AnyObject {
    func recordUpdated()
}

final class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    
    var completedTrackers: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects
        else { return [] }
        var result: [TrackerRecord] = []
        do {
            result = try objects.map {
                try self.convertTrackerRecordFromCoreData(from: $0)
            }
        } catch { return [] }
        return result
    }
    
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
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
    
    func addRecord(trackerId: UUID, date: Date) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        let trackerStore = TrackerStore(context: context)
        do {
            let tracker = try trackerStore.fetchTracker(trackerId: trackerId)
            trackerRecordCoreData.tracker = tracker
        } catch {
            throw TrackerStoreError.decodingTrackerError
        }
        
        trackerRecordCoreData.trackerId = trackerId
        trackerRecordCoreData.date = date
        
        try context.save()
    }
    
    func deleteRecord(trackerId: UUID, date: Date) throws {
        do {
            let record = try fetchTrackerRecord(trackerId: trackerId, date: date)
            context.delete(record)
        } catch {
            throw TrackerRecordStoreError.fetchTrackerRecordError
        }
        
        try context.save()
    }
    
    private func fetchTrackerRecord(trackerId: UUID, date: Date) throws -> TrackerRecordCoreData {
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        let fromPredicate = NSPredicate(format: "%K >= %@",
                                        #keyPath(TrackerRecordCoreData.date), dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@",
                                      #keyPath(TrackerRecordCoreData.date), dateTo! as NSDate)
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), trackerId as CVarArg)
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, fromPredicate, toPredicate])
        
        let result = try context.fetch(request)
        
        guard let result = result.first else {
            throw TrackerRecordStoreError.fetchTrackerRecordError
        }
        return result
    }
    
    private func convertTrackerRecordFromCoreData(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let id = trackerRecordCoreData.trackerId,
            let date = trackerRecordCoreData.date else
        {
            throw TrackerRecordStoreError.decodingTrackerRecordError
        }
        
        return TrackerRecord(id: id, date: date)
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.recordUpdated()
    }
}
