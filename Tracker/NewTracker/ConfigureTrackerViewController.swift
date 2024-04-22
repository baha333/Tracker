//
//  ConfigureTrackerViewController.swift
//  Tracker
//
//  Created by Bakhadir on 21.04.2024.
//

import UIKit

protocol ConfigureTrackerViewControllerDelegate {
    func trackerDidSaved()
}

final class ConfigureTrackerViewController: UIViewController {
    
    //MARK: - Properties
    
    var isRepeat: Bool = false
    var delegate: ConfigureTrackerViewControllerDelegate?
    let titlesForTableView = ["Категория", "Расписание"]
    
    var emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    var colors: [UIColor] = [
        .color1, .color2, .color3,
        .color4, .color5, .color6,
        .color7, .color8, .color9,
        .color10, .color11, .color12,
        .color13, .color14, .color15,
        .color16, .color17, .color18
    ]
    
    var selectedEmoji: String?
    var selectedEmojiIndex: Int?
    var selectedColor: UIColor?
    var selectedColorIndex: Int?
    
    private let trackerStore = TrackerStore.shared
    private var selectedSchedule: [Weekday] = []
    private var switchStates: [Int: Bool] = [:]
    private var selectedTrackerCategory: TrackerCategory?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.smartInsertDeleteType = .no
        textField.addLeftPadding(16)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.register(
            ActivityTableCell.self,
            forCellReuseIdentifier: ActivityTableCell.reuseIdentifier
        )
        return tableView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhite, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return createButton
    }()
    
    private lazy var emojisAndColorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        collectionView.isScrollEnabled = false
        collectionView.register(EmojisAndColorsCell.self, forCellWithReuseIdentifier: EmojisAndColorsCell.reuseIdentifier)
        collectionView.register(EmojisAndColorsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojisAndColorsHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 200)
    }
    
    private enum CollectionViewSections: Int, CaseIterable {
        case emojiSection = 0
        case colorSection = 1
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = .ypWhite
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [textField,
         tableView,
         emojisAndColorsCollectionView,
         stackView
        ].forEach { scrollView.addSubview($0) }
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
        
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        emojisAndColorsCollectionView.dataSource = self
        emojisAndColorsCollectionView.delegate = self
        
        addTapGestureToHideKeyboard()
        checkButtonActivation()
    }
    
    //MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let categoryTitle = selectedTrackerCategory?.title else { return }
        guard let selectedEmoji = selectedEmoji else { return }
        guard let selectedColor = selectedColor else { return }
        
        if isRepeat {
            addTracker(
                title: textField.text ?? "",
                categoryTitle: categoryTitle,
                schedule: selectedSchedule,
                emoji: selectedEmoji,
                color: selectedColor
            )
            
        } else {
            let currentDate = Date()
            let currentWeekday = Calendar.current.component(.weekday, from: currentDate)
            let newSchedule = Schedule(value: Weekday(rawValue: currentWeekday) ?? .sunday, isOn: true)
            let scheduleArray = [newSchedule]
            let weekdayArray = scheduleArray.map { $0.value }
            
            addTracker(
                title: textField.text ?? "",
                categoryTitle: categoryTitle,
                schedule: weekdayArray,
                emoji: selectedEmoji,
                color: selectedColor
            )
        }
        
        dismiss(animated: true, completion: { self.delegate?.trackerDidSaved() })
    }
    
    @objc private func hideKeyboard() {
        textField.endEditing(true)
    }
    
    //MARK: - Private Functions
    
    private func setupNavBar(){
        if isRepeat {
            navigationItem.title = "Новая привычка"
        } else {
            navigationItem.title = "Новое нерегулярное событие"
        }
    }
    
    private func setupConstraints() {
        if isRepeat {
            tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        } else {
            tableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            
            emojisAndColorsCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojisAndColorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emojisAndColorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojisAndColorsCollectionView.heightAnchor.constraint(equalToConstant: 460),
            
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.topAnchor.constraint(equalTo: emojisAndColorsCollectionView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
        
    }
    
    private func checkButtonActivation() {
        let isAvailable: Bool
        
        if(isRepeat) {
            isAvailable = !selectedSchedule.isEmpty && selectedTrackerCategory != nil
        } else {
            isAvailable = selectedTrackerCategory != nil
        }
        createButton.isEnabled = isAvailable
        
        if isAvailable {
            createButton.backgroundColor = .ypBlack
        } else {
            createButton.backgroundColor = .ypGray
        }
    }
    
    private func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func addTracker(
        title: String,
        categoryTitle: String,
        schedule: [Weekday],
        emoji: String,
        color: UIColor
    ) {
        guard let selectedTrackerCategory = selectedTrackerCategory else { return }
        
        let tracker = Tracker(
            id: UUID(),
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
        
        do {
            try trackerStore.addTracker(
                tracker,
                toCategory: selectedTrackerCategory
            )
        } catch {
            print("Save tracker failed")
        }
    }
}


// MARK: - UITableViewDataSource,Delegate

extension ConfigureTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRepeat {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableCell.reuseIdentifier, for: indexPath) as? ActivityTableCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        if indexPath.row == 0 {
            
            if isRepeat {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
            else { cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)}
            
            cell.titleLabel.text = titlesForTableView[indexPath.row]
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.titleLabel.text = titlesForTableView[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ConfigureTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            navigationController?.pushViewController(categoryViewController, animated: true)
        } else if indexPath.row == 1 {
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            scheduleViewController.switchStates = switchStates
            navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
}

//MARK: - ScheduleViewControllerDelegate

extension ConfigureTrackerViewController: ScheduleViewControllerDelegate {
    func updateScheduleInfo(_ selectedDays: [Weekday], _ switchStates: [Int: Bool]) {
        self.switchStates = switchStates
        self.selectedSchedule = selectedDays
        
        let subText: String
        if selectedDays.count == Weekday.allCases.count {
            subText = "Каждый день"
        } else {
            subText = selectedDays.map { $0.shortValue }.joined(separator: ", ")
        }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ActivityTableCell else {
            return
        }
        cell.set(subText: subText)
        
        checkButtonActivation()
        tableView.reloadData()
    }
}


//MARK: - CategoryViewControllerDelegate

extension ConfigureTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(_ category: TrackerCategory) {
        self.selectedTrackerCategory = category
        
        let subText = selectedTrackerCategory?.title ?? ""
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ActivityTableCell else {
            return
        }
        cell.set(subText: subText)
        tableView.reloadData()
        checkButtonActivation()
    }
}

// MARK: - UICollectionViewDataSource

extension ConfigureTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case CollectionViewSections.emojiSection.rawValue:
            return emojis.count
        case CollectionViewSections.colorSection.rawValue:
            return colors.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojisAndColorsCell.reuseIdentifier, for: indexPath) as? EmojisAndColorsCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case CollectionViewSections.emojiSection.rawValue:
            let emoji = emojis[indexPath.row]
            cell.titleLabel.text = emoji
        case CollectionViewSections.colorSection.rawValue:
            let color = colors[indexPath.row]
            cell.titleLabel.backgroundColor = color
        default:
            break
        }
        
        cell.titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: EmojisAndColorsHeaderView.reuseIdentifier,
            for: indexPath
        ) as? EmojisAndColorsHeaderView else { return UICollectionReusableView() }
        
        switch indexPath.section {
        case CollectionViewSections.emojiSection.rawValue:
            view.titleLabel.text = "Emoji"
        case CollectionViewSections.colorSection.rawValue:
            view.titleLabel.text = "Цвет"
        default:
            return UICollectionReusableView()
        }
        return view
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ConfigureTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 40, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case CollectionViewSections.emojiSection.rawValue:
            if let selectedEmojiIndex = selectedEmojiIndex {
                let previousSelectedIndexPath = IndexPath(item: selectedEmojiIndex, section: 0)
                if let cell = collectionView.cellForItem(at: previousSelectedIndexPath) as? EmojisAndColorsCell {
                    cell.backgroundColor = .clear
                }
            }
            setEmojiHighlight(indexPath, collectionView)
            
        case CollectionViewSections.colorSection.rawValue:
            if let selectedColorIndex = selectedColorIndex {
                let previousSelectedIndexPath = IndexPath(item: selectedColorIndex, section: 1)
                if let cell = collectionView.cellForItem(at: previousSelectedIndexPath) as? EmojisAndColorsCell {
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.borderWidth = 0
                }
            }
            setColorHighlight(indexPath, collectionView)
            
        default:
            return
        }
        checkButtonActivation()
    }
    
    func setEmojiHighlight(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojisAndColorsCell else { return }
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.backgroundColor = .ypLightGray
        selectedEmoji = emojis[indexPath.row]
        selectedEmojiIndex = indexPath.row
    }
    
    func setColorHighlight(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojisAndColorsCell else { return }
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.borderColor = colors[indexPath.row].cgColor.copy(alpha: 0.3)
        cell.layer.borderWidth = 3
        selectedColor = colors[indexPath.row]
        selectedColorIndex = indexPath.row
    }
}
