//
//  ViewController.swift
//  Tracker
//
//  Created by Bakhadir on 13.03.2024.
//

import UIKit
import CloudKit

protocol TrackersViewControllerDelegate: AnyObject {
    func createdTracker(tracker: Tracker, categoryTitle: String)
}

final class TrackersViewController: UIViewController {
    
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
        label.text = "Трекеры"
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
        
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
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
            string: "Поиск",
            attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.widthAnchor.constraint(equalToConstant: 83).isActive = true
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
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
    
    //MARK: - Lifecycle
    
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
        
        headerView.addSubview(plusButton)
        headerView.addSubview(titleHeader)
        headerView.addSubview(datePicker)
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
            
            cancelButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor)
        ])
    }
    
    @objc private func addTask() {
        let createTrackerVC = AddTrackerViewController()
        createTrackerVC.delegate = self
        let navVC = UINavigationController(rootViewController: createTrackerVC)
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
        reloadFilteredCategories(text: searchTextField.text, date: currentDate)
    }
    
    @objc private func hideKeyboard() {
        searchTextField.endEditing(true)
    }
    
    
    private func reloadFilteredCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filteredWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        
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
        
        collectionView.reloadData()
        reloadPlaceholder()
        emptySearchPlaceholderView.isHidden = !filteredCategories.isEmpty || (searchTextField.text ?? "").isEmpty
    }
    
    private func reloadPlaceholder() {
        placeholderView.isHidden = check() || !(searchTextField.text ?? "").isEmpty
    }
    
    private func check() -> Bool {
        return categories.contains(where: { category in
            !category.trackers.isEmpty
        })
        
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
    }
    
    func uncompletedTracker(id: UUID, at indexPath: IndexPath) {
        do {
            try trackerRecordStore.deleteRecord(with: id, by: currentDate)
            
            completedTrackers.removeAll { trackerRecord in
                isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
                let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate)
                return trackerRecord.trackerID == id && isSameDay
            }
            collectionView.reloadItems(at: [indexPath])
        } catch {
            print("Remove task failed")
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

