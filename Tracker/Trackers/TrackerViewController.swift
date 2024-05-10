import UIKit
import CloudKit

protocol TrackersViewControllerDelegate: AnyObject {
    func createdTracker(tracker: Tracker, categoryTitle: String)
    func updateTracker(tracker: Tracker, to category: TrackerCategory)
}

final class TrackersViewController: UIViewController {
    var selectedFilter: Filter = .all
    
    //MARK: - Private Properties
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "AddTracker"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        button.tintColor = .ypBlack
        return button
    }()
    
    private let titleHeader: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers.title", comment: "")
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 8
        picker.backgroundColor = .ypBackgroundDate
        picker.tintColor = .ypBlue
        picker.contentHorizontalAlignment = .center
        picker.textColor = UIColor.BlackAnyAppearance
        
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = formattedDate(from: Date())
        dateLabel.backgroundColor = .ypBackgroundDate
        dateLabel.textColor = .BlackAnyAppearance
        dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        dateLabel.textAlignment = NSTextAlignment.center
        dateLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true
        return dateLabel
    }()
    
    private let searchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypBlack
        textField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypGray
        ]
        
        let attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("searchTextField.placeholder", comment: ""),
            attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("cancelButton.text", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.widthAnchor.constraint(equalToConstant: 83).isActive = true
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        let textTitle = NSLocalizedString("filterButton.text", comment: "")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(textTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelConstraint: NSLayoutConstraint = {
        return searchTextField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -5)
    }()
    private lazy var noCancelConstraint: NSLayoutConstraint = {
        return searchTextField.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor, constant: -5)
    }()
    
    private let placeholderView = PlaceholderView()
    private let emptySearchPlaceholderView = EmptySearchPlaceholderView()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let params = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = .init()
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore.shared
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore.shared
    private let analyticsService = AnalyticsService.shared
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.report(event: "close", params: ["screen" : "Main"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        configureView()
        addElements()
        setupConstraints()
        configureCollectionView()
        placeholderView.configureEmptyTrackerPlaceholder()
        emptySearchPlaceholderView.configureEmptySearchPlaceholder()
        emptySearchPlaceholderView.isHidden = true
        addTapGestureToHideKeyboard()
        
        trackerStore.setDelegate(self)
        datePicker.setValue(UIColor.BlackAnyAppearance, forKeyPath: "textColor")
    }
    
    
    //MARK: - Functions
    private func configureView() {
        view.backgroundColor = .ypWhite
        searchTextField.returnKeyType = .done
    }
    
    private func reloadData() {
        do {
            categories = try trackerCategoryStore.getCategories()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
        }
        
        let trackers = categories.flatMap { category in
            category.trackers
        }
        
        let records = trackers.map { tracker -> [TrackerRecord] in
            var records: [TrackerRecord] = []
            
            do {
                records = try trackerRecordStore.recordsFetch(for: tracker)
            } catch {
                assertionFailure()
            }
            
            return records
        }
        
        completedTrackers = records.flatMap { $0 }
        filteredCategories = categories
        dateChanged()
    }
    
    private func addElements() {
        view.addSubview(headerView)
        view.addSubview(placeholderView)
        view.addSubview(emptySearchPlaceholderView)
        view.addSubview(collectionView)
        view.addSubview(filterButton)
        
        headerView.addSubview(plusButton)
        headerView.addSubview(titleHeader)
        headerView.addSubview(datePicker)
        headerView.addSubview(dateLabel)
        headerView.addSubview(searchStackView)
        searchStackView.addSubview(searchTextField)
        searchStackView.addSubview(cancelButton)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.identifier
        )
        collectionView.register(
            HeaderSectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderSectionView.identifier
        )
        collectionView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 138),
            
            plusButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            titleHeader.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleHeader.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            
            dateLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            
            datePicker.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 95),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            
            searchStackView.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 7),
            searchStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            searchStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            searchStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),
            
            emptySearchPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptySearchPlaceholderView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 220),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor),
            noCancelConstraint,
            
            cancelButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addTask() {
        let createTrackerVC = AddTrackerViewController()
        createTrackerVC.delegate = self
        let navVC = UINavigationController(rootViewController: createTrackerVC)
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "add_track"])
        present(navVC, animated: true)
    }
    
    @objc private func cancelSearch() {
        cancelButton.isHidden = true
        cancelConstraint.isActive = false
        noCancelConstraint.isActive = true
        searchTextField.text = ""
        reloadFilteredCategories(text: searchTextField.text, date: currentDate)
    }
    
    @objc private func dateChanged() {
        currentDate = datePicker.date
        if selectedFilter == .today {
            selectedFilter = .all
        }
        
        reloadFilteredCategories(text: searchTextField.text, date: currentDate)
    }
    
    @objc private func hideKeyboard() {
        searchTextField.endEditing(true)
    }
    
    @objc private func didTapFilterButton() {
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        filtersViewController.selectedFilter = selectedFilter
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "filter"])
        present(filtersViewController, animated: true)
    }
    
    private func filteringTrackers(completed: Bool) {
        filteredCategories = filteredCategories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                completed ? isTrackerCompletedToday(id: tracker.id)
                : !isTrackerCompletedToday(id: tracker.id)
            }
            if trackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
    
    private func reloadFilteredCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filteredWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        
        switch selectedFilter {
        case .all:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.title.lowercased().contains(filterText)
                    
                    let dateCondition = tracker.schedule.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) == true || tracker.schedule.isEmpty
                    
                    return textCondition && dateCondition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title, trackers: trackers)
            }
        case .today:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.title.lowercased().contains(filterText)
                    
                    let dateCondition = tracker.schedule.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) == true || tracker.schedule.isEmpty
                    
                    return textCondition && dateCondition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title, trackers: trackers)
            }
        case .completed:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.title.lowercased().contains(filterText)
                    
                    let dateCondition = tracker.schedule.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) == true || tracker.schedule.isEmpty
                    
                    let completedCondition = try? trackerRecordStore
                        .recordsFetch(for: tracker)
                        .contains(where: { record in
                            record.trackerID == tracker.id &&
                            Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                        })
                    
                    return textCondition && dateCondition && (completedCondition ?? false)
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title, trackers: trackers)
            }
            
        case .uncompleted:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.title.lowercased().contains(filterText)
                    
                    let dateCondition = tracker.schedule.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) == true || tracker.schedule.isEmpty
                    
                    let completedCondition = try? !trackerRecordStore
                        .recordsFetch(for: tracker)
                        .contains(where: { record in
                            record.trackerID == tracker.id &&
                            Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                        })
                    
                    return textCondition && dateCondition && (completedCondition ?? false)
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title, trackers: trackers)
            }
            
        default: break
            
        }
        
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        let isPlaceholderVisible = filteredCategories.isEmpty && (searchTextField.text ?? "").isEmpty &&
        selectedFilter == .all
        
        placeholderView.isHidden = !isPlaceholderVisible
        filterButton.isHidden = isPlaceholderVisible
        
        let isEmptySearchVisible = filteredCategories.isEmpty &&
        (!(searchTextField.text ?? "").isEmpty ||
         selectedFilter != .all)
        
        emptySearchPlaceholderView.isHidden = !isEmptySearchVisible
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func reloadPinTrackers() {
        categories = []
        var pinnedTrackers: [Tracker] = []
        
        for category in trackerCategoryStore.trackerCategory {
            let trackers = category.trackers
            let pinnedTrackersForCategory = trackers.filter { $0.isPinned }
            let unpinnedTrackers = trackers.filter { !$0.isPinned }
            pinnedTrackers.append(contentsOf: pinnedTrackersForCategory)
            
            if !unpinnedTrackers.isEmpty {
                let unpinnedCategory = TrackerCategory(title: category.title, trackers: unpinnedTrackers)
                categories.append(unpinnedCategory)
            }
        }
        
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(
                title: NSLocalizedString("pinnedTrackers.title", comment: ""),
                trackers: pinnedTrackers)
            categories.insert(pinnedCategory, at: 0)
        }
    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
    
    private func updateDateLabelTitle(with date: Date) {
        let dateString = formattedDate(from: date)
        dateLabel.text = dateString
    }
}

//MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadFilteredCategories(text: textField.text, date: datePicker.date)
        cancelButton.isHidden = false
        cancelConstraint.isActive = true
        noCancelConstraint.isActive = false
        return true
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSectionView.identifier, for: indexPath) as? HeaderSectionView else { return UICollectionReusableView() }
        
        let titleCategory = filteredCategories[indexPath.section].title
        view.configure(titleCategory)
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = filteredCategories[section].trackers
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.identifier,
            for: indexPath
        ) as? TrackerCell else { return UICollectionViewCell() }
        
        let cellData = filteredCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        
        let completedDays = completedTrackers.filter {
            $0.trackerID == tracker.id
        }.count
        
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains {
            isMatchRecord(model: $0, with: id)
        }
    }
    
    private func isMatchRecord(model: TrackerRecord, with trackerID: UUID) -> Bool {
        return model.trackerID == trackerID && Calendar.current.isDate(model.date, inSameDayAs: currentDate)
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.trackerID == id && isSameDay
    }
}

// MARK: - TrackersViewCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    
    func updateTrackerPinAction(tracker: Tracker) {
        try? self.pinTracker(tracker)
    }
    
    func editTrackerAction(tracker: Tracker) {
        self.editingTrackers(tracker: tracker)
    }
    
    func deleteTrackerAction(tracker: Tracker) {
        self.showDeleteAlert(tracker: tracker)
    }
    
    
    func completedTracker(id: UUID, at indexPath: IndexPath) {
        guard currentDate <= Date() else {
            return
        }
        
        do {
            try trackerRecordStore.addRecord(with: id, by: currentDate)
            
            let trackerRecord = TrackerRecord(trackerID: id, date: currentDate)
            completedTrackers.append(trackerRecord)
            collectionView.reloadItems(at: [indexPath])
        } catch {
            print("Complete task failed")
        }
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "track"])
    }
    
    func uncompletedTracker(id: UUID, at indexPath: IndexPath) {
        do {
            try trackerRecordStore.deleteRecord(with: id, by: currentDate)
            
            completedTrackers.removeAll { trackerRecord in
                return isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
            }
            collectionView.reloadItems(at: [indexPath])
        } catch {
            print("Remove task failed: \(error)")
        }
    }
    
    private func pinTracker(_ tracker: Tracker) throws {
        do {
            try trackerStore.pinTrackerCoreData(tracker)
            try fetchCategories()
            reloadFilteredCategories(text: searchTextField.text, date: currentDate)
        } catch {
            print("Pin tracker failed")
        }
    }
    
    private func deleteTrackerInCategory(tracker: Tracker) throws {
        do {
            trackerStore.deleteTrackers(tracker: tracker)
            try trackerRecordStore.deleteAllRecordForID(for: tracker.id)
            try fetchCategories()
            reloadFilteredCategories(text: searchTextField.text, date: currentDate)
        } catch {
            print("Delete tracker is failed")
        }
    }
    
    private func fetchCategories() throws {
        do {
            let coreDataCategories = try trackerCategoryStore.fetchAllCategories()
            categories = try coreDataCategories.compactMap { coreDataCategory in
                return try trackerCategoryStore.convertToTrackerCategory(from: coreDataCategory)
            }
            reloadPinTrackers()
        } catch {
            print("fetchCategories error")
        }
    }
}

//MARK: - UICollectionViewFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: 46)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: CGFloat(148))
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return CGFloat(params.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
}

// MARK: - ddTrackerViewControllerDelegate
extension TrackersViewController: AddTrackerViewControllerDelegate {
    
    func trackerDidCreate() {
        reloadData()
        collectionView.reloadData()
    }
}

// MARK: - TrackersViewControllerDelegate

extension TrackersViewController: TrackersViewControllerDelegate {
    
    func createdTracker(tracker: Tracker, categoryTitle: String) {
        reloadData()
        collectionView.reloadData()
    }
}

// MARK: - TrackerStoreDelegate

extension TrackersViewController: TrackerStoreDelegate {
    func trackerStoreDidUpdate(_ update: TrackerStoreUpdate) {
        collectionView.performBatchUpdates {
            collectionView.insertSections(update.insertedSections)
            collectionView.insertItems(at: update.insertedIndexPaths)
        }
    }
}

// MARK: - Extension Edit tracker
extension TrackersViewController {
    private func editingTrackers(tracker: Tracker) {
        let daysCount = completedTrackers.filter { $0.trackerID == tracker.id }.count
        let configureTrackerViewController = ConfigureTrackerViewController()
        configureTrackerViewController.typeOfTracker = .edit
        configureTrackerViewController.daysCount = daysCount
        configureTrackerViewController.editTracker = tracker
        configureTrackerViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: configureTrackerViewController)
        present(navigationController, animated: true)
    }
}

//MARK: - FiltersViewControllerDelegate
extension TrackersViewController: FiltersViewControllerDelegate {
    func filterSelected(filter: Filter) {
        selectedFilter = filter
        searchTextField.text = ""
        
        switch filter {
        case .all:
            filterButton.setTitleColor(.ypWhite, for: .normal)
            
        case .today:
            datePicker.setDate(Date(), animated: false)
            currentDate = datePicker.date
            filterButton.setTitleColor(.ypWhite, for: .normal)
            
        case .completed:
            filterButton.setTitleColor(.ypWhite, for: .normal)
            
        case .uncompleted:
            filterButton.setTitleColor(.ypWhite, for: .normal)
        }
        
        reloadFilteredCategories(text: searchTextField.text, date: currentDate)
    }
}

// MARK: - Extension Alert
extension TrackersViewController {
    private func showDeleteAlert(tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("showDeleteAlert.text", comment: ""),
            preferredStyle: .actionSheet
        )
        let deleteButton = UIAlertAction(
            title: NSLocalizedString("delete.text", comment: ""),
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                do {
                    try self.deleteTrackerInCategory(tracker: tracker)
                } catch {
                    print("Error deleting tracker: \(error)")
                }
            }
        let cencelButton = UIAlertAction(
            title: NSLocalizedString("cancelButton.text", comment: ""),
            style: .cancel
        )
        alert.addAction(deleteButton)
        alert.addAction(cencelButton)
        self.present(alert, animated: true)
    }
}

extension UIDatePicker {
    
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
}

//MARK: - ConfigureViewControllerDelegate
extension TrackersViewController: ConfigureTrackerViewControllerDelegate {
    func trackerDidSaved() {
        print("save")
    }
    
    func updateTracker(tracker: Tracker, to category: TrackerCategory) {
        print("Updated")
        
        try? trackerStore.updateTracker(tracker, to: category)
        try? fetchCategories()
        reloadFilteredCategories(text: searchTextField.text, date: currentDate)
    }
}
