import Foundation

typealias Binding<T> = (T) -> Void

//MARK: - CategoryViewModel
final class CategoryViewModel {
    
    //MARK: - Properties
    var onTrackerCategoriesChanged: Binding<Any?>?
    var onCategorySelected: Binding<TrackerCategory>?
    
    var selectedCategoryIndex: Int = -1
    var trackerCategories: [TrackerCategory] = [] {
        didSet {
            onTrackerCategoriesChanged?(nil)
        }
    }
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    init() {
        trackerCategoryStore.setDelegate(self)
    }
    
    // MARK: - Methods
    func fetchCategories() throws {
        do {
            trackerCategories = try trackerCategoryStore.getCategories()
        } catch {
            print("Fetch failed")
        }
    }
    
    func countCategories() -> Int {
        return trackerCategories.count
    }
    
    func getCategoryTitle(at indexPath: IndexPath) -> String {
        trackerCategories[indexPath.row].title
    }
    
    func selectCategory(at indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        
        let selectedCategory = trackerCategories[indexPath.row]
        
        onCategorySelected?(selectedCategory)
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        try? fetchCategories()
    }
}
