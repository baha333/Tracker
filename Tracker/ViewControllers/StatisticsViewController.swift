
import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
    private var bestPeriod = 0
    private var idealDays = 0
    private var trackersCompleted = 0
    private var averageValue = 0
    let trackerRecordStore = TrackerRecordStore()
    
    //MARK: - UI
    private lazy var stubImageView: UIImageView = {
        let image = UIImage(named: "stub2")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = "statisticsStubLabel.text".localized
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fistGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bestPeriodNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bestPeriodTextLabel: UILabel = {
        let label = UILabel()
        label.text = "bestPeriodTextLabel".localized
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let idealDaysNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idealDaysTextLabel: UILabel = {
        let label = UILabel()
        label.text = "idealDaysTextLabel".localized
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thirdGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackersCompletedNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackersCompletedTextLabel: UILabel = {
        let label = UILabel()
        label.text = "trackersCompletedTextLabel".localized
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fourthGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let averageValueNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let averageValueTextLabel: UILabel = {
        let label = UILabel()
        label.text = "averageValueTextLabel".localized
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = navigationController?.navigationBar ?? UINavigationBar()
        navigationBar.topItem?.title = "statistics.title".localized
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statCalculation()
        conditionStubs()
        showStatistics()
    }
    
    private func setupView(){
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(navigationBar)
        
        view.addSubview(fistGradientImageView)
        fistGradientImageView.addSubview(bestPeriodNumberLabel)
        fistGradientImageView.addSubview(bestPeriodTextLabel)
        
        view.addSubview(secondGradientImageView)
        secondGradientImageView.addSubview(idealDaysNumberLabel)
        secondGradientImageView.addSubview(idealDaysTextLabel)
        
        view.addSubview(thirdGradientImageView)
        thirdGradientImageView.addSubview(trackersCompletedNumberLabel)
        thirdGradientImageView.addSubview(trackersCompletedTextLabel)
        
        view.addSubview(fourthGradientImageView)
        fourthGradientImageView.addSubview(averageValueNumberLabel)
        fourthGradientImageView.addSubview(averageValueTextLabel)
        
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
        stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        stubImageView.widthAnchor.constraint(equalToConstant: 80),
        stubImageView.heightAnchor.constraint(equalToConstant: 80),
        
        stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
        stubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
        stubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        stubLabel.heightAnchor.constraint(equalToConstant: 18),
        
        fistGradientImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 64),
        fistGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        fistGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        fistGradientImageView.heightAnchor.constraint(equalToConstant: 90),
        
        bestPeriodNumberLabel.topAnchor.constraint(equalTo: fistGradientImageView.topAnchor, constant: 12),
        bestPeriodNumberLabel.leadingAnchor.constraint(equalTo: fistGradientImageView.leadingAnchor, constant: 12),
        bestPeriodNumberLabel.trailingAnchor.constraint(equalTo: fistGradientImageView.trailingAnchor, constant: -12),
        bestPeriodNumberLabel.heightAnchor.constraint(equalToConstant: 41),
        
        bestPeriodTextLabel.bottomAnchor.constraint(equalTo: fistGradientImageView.bottomAnchor, constant: -12),
        bestPeriodTextLabel.leadingAnchor.constraint(equalTo: fistGradientImageView.leadingAnchor, constant: 12),
        bestPeriodTextLabel.trailingAnchor.constraint(equalTo: fistGradientImageView.trailingAnchor, constant: -12),
        bestPeriodTextLabel.heightAnchor.constraint(equalToConstant: 18),
        
        secondGradientImageView.topAnchor.constraint(equalTo: fistGradientImageView.bottomAnchor, constant: 12),
        secondGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        secondGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        secondGradientImageView.heightAnchor.constraint(equalToConstant: 90),
        
        idealDaysNumberLabel.topAnchor.constraint(equalTo: secondGradientImageView.topAnchor, constant: 12),
        idealDaysNumberLabel.leadingAnchor.constraint(equalTo: secondGradientImageView.leadingAnchor, constant: 12),
        idealDaysNumberLabel.trailingAnchor.constraint(equalTo: secondGradientImageView.trailingAnchor, constant: -12),
        idealDaysNumberLabel.heightAnchor.constraint(equalToConstant: 41),
        
        idealDaysTextLabel.bottomAnchor.constraint(equalTo: secondGradientImageView.bottomAnchor, constant: -12),
        idealDaysTextLabel.leadingAnchor.constraint(equalTo: secondGradientImageView.leadingAnchor, constant: 12),
        idealDaysTextLabel.trailingAnchor.constraint(equalTo: secondGradientImageView.trailingAnchor, constant: -12),
        idealDaysTextLabel.heightAnchor.constraint(equalToConstant: 18),
        
        thirdGradientImageView.topAnchor.constraint(equalTo: secondGradientImageView.bottomAnchor, constant: 12),
        thirdGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        thirdGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        thirdGradientImageView.heightAnchor.constraint(equalToConstant: 90),
        
        trackersCompletedNumberLabel.topAnchor.constraint(equalTo: thirdGradientImageView.topAnchor, constant: 12),
        trackersCompletedNumberLabel.leadingAnchor.constraint(equalTo: thirdGradientImageView.leadingAnchor, constant: 12),
        trackersCompletedNumberLabel.trailingAnchor.constraint(equalTo: thirdGradientImageView.trailingAnchor, constant: -12),
        trackersCompletedNumberLabel.heightAnchor.constraint(equalToConstant: 41),
        
        trackersCompletedTextLabel.bottomAnchor.constraint(equalTo: thirdGradientImageView.bottomAnchor, constant: -12),
        trackersCompletedTextLabel.leadingAnchor.constraint(equalTo: thirdGradientImageView.leadingAnchor, constant: 12),
        trackersCompletedTextLabel.trailingAnchor.constraint(equalTo: thirdGradientImageView.trailingAnchor, constant: -12),
        trackersCompletedTextLabel.heightAnchor.constraint(equalToConstant: 18),
        
        fourthGradientImageView.topAnchor.constraint(equalTo: thirdGradientImageView.bottomAnchor, constant: 12),
        fourthGradientImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        fourthGradientImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        fourthGradientImageView.heightAnchor.constraint(equalToConstant: 90),
        
        averageValueNumberLabel.topAnchor.constraint(equalTo: fourthGradientImageView.topAnchor, constant: 12),
        averageValueNumberLabel.leadingAnchor.constraint(equalTo: fourthGradientImageView.leadingAnchor, constant: 12),
        averageValueNumberLabel.trailingAnchor.constraint(equalTo: fourthGradientImageView.trailingAnchor, constant: -12),
        averageValueNumberLabel.heightAnchor.constraint(equalToConstant: 41),
        
        averageValueTextLabel.bottomAnchor.constraint(equalTo: fourthGradientImageView.bottomAnchor, constant: -12),
        averageValueTextLabel.leadingAnchor.constraint(equalTo: fourthGradientImageView.leadingAnchor, constant: 12),
        averageValueTextLabel.trailingAnchor.constraint(equalTo: fourthGradientImageView.trailingAnchor, constant: -12),
        averageValueTextLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func conditionStubs() {
        if trackersCompleted == 0 {
            fistGradientImageView.isHidden = true
            secondGradientImageView.isHidden = true
            thirdGradientImageView.isHidden = true
            fourthGradientImageView.isHidden = true
            stubLabel.isHidden = false
            stubImageView.isHidden = false
        } else {
            fistGradientImageView.isHidden = false
            secondGradientImageView.isHidden = false
            thirdGradientImageView.isHidden = false
            fourthGradientImageView.isHidden = false
            stubLabel.isHidden = true
            stubImageView.isHidden = true
        }
    }
    
    private func statCalculation() {
        (bestPeriod, idealDays, trackersCompleted) = (0, 0, 0)
        var weekdaysCount: [Int: Int] = [:]
        var completedCount: [Date: Int] = [:]
        var eventArray:[Date] = []
        var currentBestPeriod = 0
        let calendar = Calendar.current
        
        guard
            let allTrackers = try? trackerRecordStore.fetchAllTrackers(),
            let startDate = try? trackerRecordStore.fetchMinDate()
        else { return }
        
        for tracker in allTrackers {
            if !tracker.completedAt.isEmpty {
                trackersCompleted += 1
                for date in tracker.completedAt {
                    completedCount[date, default: 0] += 1
                }
            }
            if !tracker.schedule.isEmpty {
                for weekday in tracker.schedule {
                    guard let weekdayNumber = weekday?.numberValue else { return }
                    weekdaysCount[weekdayNumber, default: 0] += 1
                }
            } else {
                eventArray.append(tracker.dateEvent ?? startDate - 1)
            }
        }
    
        averageValue = Int(Double((completedCount.reduce(0) {$0 + $1.value} / completedCount.count)).rounded())
        
        let endDay = Date().dateWithoutTime()
        var currentDate = startDate
        
        while currentDate <= endDay {
            let filterWeekday = calendar.component(.weekday, from: currentDate)
            let allHabitNumber = weekdaysCount[filterWeekday] ?? 0
            let allEventNumber = eventArray.filter { $0 == currentDate }.count
            if completedCount[currentDate] == allHabitNumber + allEventNumber {
                idealDays += 1
                currentBestPeriod += 1
            } else {
                bestPeriod = currentBestPeriod > bestPeriod ? currentBestPeriod : bestPeriod
                currentBestPeriod = 0
            }
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
    }
    
    private func showStatistics() {
        bestPeriodNumberLabel.text = "\(bestPeriod)"
        idealDaysNumberLabel.text = "\(idealDays)"
        trackersCompletedNumberLabel.text = "\(trackersCompleted)"
        averageValueNumberLabel.text = "\(averageValue)"
    }
}
