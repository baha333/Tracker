//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Bakhadir on 16.03.2024.
//

import UIKit

struct Statistics {
    var title: String
    var count: String
}

final class StatisticsViewController: UIViewController {

    private var completedTrackers: [TrackerRecord] = []
    private let trackerRecordStore = TrackerRecordStore.shared
    private var statistics: [Statistics] = []
    
    //MARK: - Private Properties
    private lazy var titleHeader: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics.title", comment: "")
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.register(
            StatisticsCell.self,
            forCellWithReuseIdentifier: StatisticsCell.identifier)
        return collectionView
    }()
    
    private let emptyStatisticsPlaceholderView = EmptyStatisticsPlaceholderView()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatisticScreen()
        emptyStatisticsPlaceholderView.configureEmptyStatisticsPlaceholder()
        checkEmptyStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? fetchStatistics()
        checkEmptyStatistics()
    }
    
    //MARK: - Private Functions
    
    private func checkEmptyStatistics() {
        if !completedTrackers.isEmpty {
            emptyStatisticsPlaceholderView.isHidden = true
            collectionView.isHidden = false
        } else {
            emptyStatisticsPlaceholderView.isHidden = false
            collectionView.isHidden = true
        }
        collectionView.reloadData()
    }
    
    private func fetchStatistics() throws {
        do {
            completedTrackers = try trackerRecordStore.fetchAllRecords()
            
            getStatisticsCalculation()
        } catch {
            print("Fetch tracker record failed")
        }
    }
    
    private func getStatisticsCalculation() {
        if completedTrackers.isEmpty {
            statistics.removeAll()
        } else {
            statistics = [
                Statistics(
                    title: NSLocalizedString("getStatisticsCalculation.text", comment: ""),
                    count: "\(completedTrackers.count)")
            ]
        }
    }
    
    private func configureStatisticScreen() {
        view.backgroundColor = .ypWhite
        addViews()
        setupConstraints()
    }
    
    private func addViews() {
        view.addSubview(titleHeader)
        view.addSubview(collectionView)
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 77),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - TrackerCategoryStoreDelegate
extension StatisticsViewController: TrackerRecordStoreDelegate { //to do
    func didUpdateData(in store: TrackerRecordStore) {
        try? fetchStatistics()
        checkEmptyStatistics()
    }
}

//MARK: - UICollectionViewDelegate
extension StatisticsViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }
}

//MARK: - UICollectionViewDataSource
extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        statistics.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StatisticsCell.identifier,
            for: indexPath
        ) as? StatisticsCell else {
            return UICollectionViewCell()
        }
        
        let newStatistics = statistics[indexPath.row]
        cell.configureCell(statistics: newStatistics)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
}
