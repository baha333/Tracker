import Foundation
import UIKit
import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidCategory
}

struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate()
}

final class TrackerStore: NSObject {
    //MARK: - Properties
    
    private let context: NSManagedObjectContext
    private(set) var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!

    weak var delegate: TrackerStoreDelegate?
    private(set) var date: Date
    private(set) var text: String
    private(set) var completedFilter: Bool?
    
    var trackersCategories: [TrackerCategory] {
        var trackerCategories: [TrackerCategory] = []
        var trackerDictionary: [String: [Tracker]] = [:]
        var pinnedTrackers: [Tracker] = []
        
        guard let objects = fetchedResultsController.fetchedObjects else {
            return []
        }
        
        for object in objects {
            guard let categoryTitle = object.category?.title else {
                continue
            }
            let tracker = Tracker(
                id: object.id ?? UUID(),
                name: object.name ?? "",
                color: object.color ?? "Color selection 17",
                emoji: object.emoji ?? "",
                schedule: object.schedule?.components(separatedBy: ",").map { Weekdays(rawValue: $0) } ?? [],
                dateEvent: object.dateEvent
            )
            if object.isPinned {
                pinnedTrackers.append(tracker)
            } else {
                if var trackers = trackerDictionary[categoryTitle] {
                    trackers.append(tracker)
                    trackerDictionary[categoryTitle] = trackers
                } else {
                    trackerDictionary[categoryTitle] = [tracker]
                }
            }
        }
        
        if !pinnedTrackers.isEmpty {
                    trackerCategories.append(TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers))
                }
        
        let sortedCategories = trackerDictionary.keys.sorted().map { categoryTitle in
            TrackerCategory(title: categoryTitle, trackers: trackerDictionary[categoryTitle]!)
        }
        trackerCategories += sortedCategories
        return trackerCategories
    }
    
    //MARK: - Init
    
    convenience init(date: Date, text: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context, date: date, text: text)
    }
    
    init(context: NSManagedObjectContext, date: Date, text: String) throws {
        self.context = context
        self.date = date
        self.text = text
        super.init()
    
        fetchedResultsController = createFetchedResultsController()
        try? fetchedResultsController?.performFetch()
    }
    
    // MARK: - Private Function
    
    private func createPredicate() -> NSPredicate {
        guard date != Date.distantPast else { return NSPredicate(value: true) }
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: date)
        let filterWeekday = Weekdays.fromNumberValue(weekdayNumber)
        let weekdayPredicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(TrackerCoreData.schedule), filterWeekday)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.dateEvent), date as CVarArg)
        var finalPredicate = NSCompoundPredicate(type: .or, subpredicates: [datePredicate, weekdayPredicate])
        
        if completedFilter != nil {
            let filterPredicate = completedFilter! ?
            NSPredicate(format: "SUBQUERY(record, $record, $record.date == %@).@count > 0", date as CVarArg) :
            NSPredicate(format: "SUBQUERY(record, $record, $record.date == %@).@count == 0", date as CVarArg)
            finalPredicate = NSCompoundPredicate(type: .and, subpredicates: [filterPredicate, finalPredicate])
        }
        
        if text != "" {
            let textPredicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(TrackerCoreData.name), text)
            finalPredicate = NSCompoundPredicate(type: .and, subpredicates: [textPredicate, finalPredicate])
        }
        return finalPredicate
    }
    
    private func createFetchedResultsController() -> NSFetchedResultsController<TrackerCoreData>? {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = createPredicate()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "isPinned", ascending: false),
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }
    
    private func createNewTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        let scheduleString = tracker.schedule.compactMap { $0?.rawValue }.joined(separator: ",")
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleString
        trackerCoreData.dateEvent = tracker.dateEvent
        trackerCoreData.isPinned = false
    }
    
    private func fetchCategory(with title: String) throws -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            throw error
        }
    }
    
    private func fetchTracker(by id: UUID) throws -> TrackerCoreData {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let result = try context.fetch(fetchRequest)
        guard let trackerCoreData = result.first else { return TrackerCoreData(context: context) }
        return trackerCoreData
    }
    
    // MARK: - Internal Function
    
    func update(with date: Date, text: String?, completedFilter: Bool?) {
        self.date = date
        self.text = text ?? ""
        self.completedFilter = completedFilter
        fetchedResultsController?.fetchRequest.predicate = createPredicate()
        try? fetchedResultsController?.performFetch()
    }
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        try deleteTracker(tracker)
        let trackerCoreData = TrackerCoreData(context: context)
        createNewTracker(trackerCoreData, with: tracker)
        
        if let existingCategory = try fetchCategory(with: category.title) {
            existingCategory.addToTracker(trackerCoreData)
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = category.title
            newCategory.addToTracker(trackerCoreData)
        }
        try context.save()
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        let trackerCoreData = try fetchTracker(by: tracker.id)
        context.delete(trackerCoreData)
        try context.save()
    }
    
    func togglePin(_ tracker: Tracker) throws {
        let trackerCoreData = try fetchTracker(by: tracker.id)
        trackerCoreData.isPinned.toggle()
        try context.save()
    }
}

// MARK: - FetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

