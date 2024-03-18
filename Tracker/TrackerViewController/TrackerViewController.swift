//
//  ViewController.swift
//  Tracker
//
//  Created by Bakhadir on 13.03.2024.
//

import UIKit

final class TrackerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var currentCategories: [TrackerCategory] = {
        filterCategoriesToshow()
    }()
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private var label = UILabel()
    private var navigationBar: UINavigationBar?
    private let datePicker = UIDatePicker()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initCollection()
        setUpNavigationBar()
    }
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        cell.counterDelegate = self
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        cell.trackerInfo = TrackerInfoCell(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            daysCount: calculateTimesTrackerWasCompleted(trackerId: tracker.id),
            currentDay: currentDate,
            state: tracker.state)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (currentCategories.count == 0) {
            showPlaceHolder()
        } else {
            collectionView.backgroundView = nil
        }
        return currentCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath) as? HeaderCollectionReusableView {
                
                sectionHeader.headerLabel.text = categories[indexPath.section].title
                return sectionHeader
            }
        }
        return UICollectionReusableView()
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 9
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    // MARK: - Collection Initialization
    
    private func initCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Private functions
    
    private func showPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: collectionView.frame)
        backgroundView.setUpNoTrackersState()
        collectionView.backgroundView = backgroundView
    }
    
    // MARK: - Setting Nav Bar
    
    private func setUpNavigationBar() {
        navigationBar = navigationController?.navigationBar
        
        let addButton = UIBarButtonItem(
            image: UIImage(named: "addButton") ?? UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addHabit))
        addButton.tintColor = .ypBlack
        navigationBar?.topItem?.leftBarButtonItem = addButton
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationBar?.topItem?.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationBar?.prefersLargeTitles = true
        navigationBar?.topItem?.title = "Трекеры"
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
    }
    
    private func filterCategoriesToshow() -> [TrackerCategory] {
        currentCategories = []
        let weekdayInt = Calendar.current.component(.weekday, from: currentDate)
        let day = (weekdayInt == 1) ? WeekDays(rawValue: 7) : WeekDays(rawValue: weekdayInt - 1)
        
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(day!)
            }
            
            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        
        return currentCategories
    }
    
    private func updateCollectionAccordingToDate() {
        currentCategories = filterCategoriesToshow()
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc
    private func addHabit() {
        let createTrackerViewController = NewTrackerViewController()
        createTrackerViewController.delegate = self
        let ncCreateTracker = UINavigationController(rootViewController: createTrackerViewController)
        
        navigationController?.present(ncCreateTracker, animated: true)
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        currentDate = selectedDate
        updateCollectionAccordingToDate()
    }
}

//MARK: - TrackerCounterDelegate

extension TrackerViewController: TrackerCounterDelegate {
    func calculateTimesTrackerWasCompleted(trackerId: UUID) -> Int {
        let contains = completedTrackers.filter {
            $0.id == trackerId
        }
        return contains.count
    }
    
    func checkIfTrackerWasCompletedAtCurrentDay(trackerId: UUID, date: Date) -> Bool {
        let contains = completedTrackers.filter {
            ($0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day))
        }.count > 0
        return contains
    }
    
    func increaseTrackerCounter(trackerId: UUID, date: Date) {
        completedTrackers.append(TrackerRecord(id: trackerId, date: date))
    }
    
    func decreaseTrackerCounter(trackerId: UUID, date: Date) {
        completedTrackers = completedTrackers.filter {
            if $0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day) {
                return false
            }
            return true
        }
    }
}

//MARK: - SearchController

extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text != "" {
            updateCollectionAccordingToSearchBarResults(enteredName: text)
        }
    }
    
    private func updateCollectionAccordingToSearchBarResults(enteredName: String) {
        currentCategories = []
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.name.contains(enteredName)
            }
            
            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        collectionView.reloadData()
    }
}

extension TrackerViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        updateCollectionAccordingToDate()
    }
}

// MARK: - TrackerCreationDelegate

extension TrackerViewController: TrackerCreationDelegate {
    func createTracker(tracker: Tracker, category: String) {
        let categoryFound = categories.filter{
            $0.title == category
        }
        
        var trackers: [Tracker] = []
        if categoryFound.count > 0 {
            categoryFound.forEach{
                trackers = trackers + $0.trackers
            }
            trackers.append(tracker)
            categories = categories.filter{
                $0.title != category
            }
            if !trackers.isEmpty {
                categories.append(TrackerCategory(title: category, trackers: trackers))
            }
        } else {
            categories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
        updateCollectionAccordingToDate()
    }
}
