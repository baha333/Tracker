import UIKit
import CoreData

private enum TrackerRecordStoreError: Error {
    case failedToFetchTracker
    case failedToFetchRecord
}

// MARK: - TrackerRecordStoreProtocol
protocol TrackerRecordStoreProtocol {
    func recordsFetch(for tracker: Tracker) throws -> [TrackerRecord]
    func addRecord(with id: UUID, by date: Date) throws
    func deleteRecord(with id: UUID, by date: Date) throws
    func deleteAllRecordForID(for id: UUID) throws
}

//MARK: - TrackerRecordStoreDelegate
protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateData(in store: TrackerRecordStore)
}

// MARK: - TrackerRecordStore
final class TrackerRecordStore: NSObject {
    
    static let shared = TrackerRecordStore()
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    
    private convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("UIApplication is not AppDelegate") }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Functions
    
    func fetchRecords(_ tracker: Tracker) throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerRecordCoreData.trackerID), tracker.id as CVarArg
        )
        let objects = try context.fetch(request)
        let records = objects.compactMap { object -> TrackerRecord? in
            guard let date = object.date, let id = object.trackerID else { return nil }
            return TrackerRecord(trackerID: id, date: date)
        }
        return records
    }
    
    func fetchRecordsByTrackerId(_ trackerId: UUID) throws -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerRecordCoreData.trackerID), trackerId as CVarArg
        )
        let objects = try context.fetch(request)
        let records = objects.compactMap { object -> TrackerRecord? in
            guard let date = object.date, let id = object.trackerID else { return nil }
            return TrackerRecord(trackerID: id, date: date)
        }
        return records
    }
    
    func fetchAllRecords() throws -> [TrackerRecord] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("fetchAllRecords error")
            
            return []
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            let trackerRecordCoreDataArray = try managedContext.fetch(fetchRequest)
            let trackerRecords = trackerRecordCoreDataArray.map { trackerRecordCoreData in
                return TrackerRecord(
                    trackerID: trackerRecordCoreData.trackerID ?? UUID(),
                    date: trackerRecordCoreData.date ?? Date()
                )
            }
            return trackerRecords
            
        } catch {
            print("fetchAllRecords error")
            
            return []
        }
    }
    
    private func fetchTrackerCoreData(for id: UUID) throws -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerCoreData.idTracker),
            id as CVarArg
        )
        return try context.fetch(request).first
    }
    
    private func fetchTrackerRecordCoreData(for idTracker: UUID, and date: Date) throws -> TrackerRecordCoreData? {
        let request = TrackerRecordCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K = %@ AND %K = %@",
            #keyPath(TrackerRecordCoreData.trackers.idTracker), idTracker as CVarArg,
            #keyPath(TrackerRecordCoreData.date), date as CVarArg
        )
        return try context.fetch(request).first
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
    
    private func createNewRecord(id: UUID, date: Date) throws {
        guard let trackerCoreData = try fetchTrackerCoreData(for: id) else {
            throw TrackerRecordStoreError.failedToFetchTracker
        }
        
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerID = id
        trackerRecordCoreData.date = date
        trackerRecordCoreData.trackers = trackerCoreData
        
        try saveContext()
    }
    
    private func removeRecord(idTracker: UUID, date: Date) throws {
        guard let trackerRecordCoreData = try fetchTrackerRecordCoreData(for: idTracker, and: date) else {
            throw TrackerRecordStoreError.failedToFetchRecord
        }
        context.delete(trackerRecordCoreData)
        try saveContext()
    }
}

// MARK: - TrackerRecordStoreProtocol
extension TrackerRecordStore: TrackerRecordStoreProtocol {
    
    func recordsFetch(for tracker: Tracker) throws -> [TrackerRecord] {
        try fetchRecords(tracker)
    }
    
    func addRecord(with id: UUID, by date: Date) throws {
        guard let onlyDate = date.onlyDate else {
            print("Failed: addRecord")
            
            return
        }
        
        try createNewRecord(id: id, date: onlyDate)
    }
    
    func deleteRecord(with id: UUID, by date: Date) throws {
        guard let onlyDate = date.onlyDate else {
            print("Failed: deleteRecord")
            
            return
        }
        
        try removeRecord(idTracker: id, date: onlyDate)
    }
    
    func deleteAllRecordForID(for id: UUID) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerID == %@", id as CVarArg)
        guard let trackersRecords = try? context.fetch(request) else { return }
        trackersRecords.forEach {
            context.delete($0)
        }
        try context.save()
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}
