
import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectWeekdays(_ weekdays: [Weekdays])
}

final class ScheduleViewController: UIViewController {
    
    //MARK: - Properties
    private  lazy var saveDaysButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("readyButton.Title".localized, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveDaysButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let weekdays: [Weekdays] = Weekdays.allCases
    private var switches = [UISwitch]()
    private var selectedWeekdays: [Weekdays] = []
    var initialSelectedWeekdays: [Weekdays?]?
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        scheduleView.dataSource = self
        scheduleView.delegate = self
        addElements()
        createNavigationBar()
        setupConstraints()
        setupSwitches()
    }
    
    //MARK: - Private Function
    private func addElements(){
        view.addSubview(saveDaysButton)
        view.addSubview(scheduleView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scheduleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            scheduleView.heightAnchor.constraint(equalToConstant: 525),
            
            saveDaysButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveDaysButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveDaysButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveDaysButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "scheduleTitle".localized
    }
    
    private func setupSwitches() {
        for day in weekdays {
            let switchControl = UISwitch()
            switchControl.onTintColor = .ypBlue
            switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            switches.append(switchControl)
            
            guard let initialSelectedWeekdays = initialSelectedWeekdays else { return }
            let isSelected = initialSelectedWeekdays.contains(day)
            switchControl.isOn = isSelected
            switchControl.sendActions(for: .valueChanged)
        }
    }
    
    //MARK: - @objc Function
    @objc private func switchValueChanged(_ sender: UISwitch) {
        if let index = switches.firstIndex(of: sender) {
            let dayOfWeek = weekdays[index]
            if sender.isOn {
                selectedWeekdays.append(dayOfWeek)
                initialSelectedWeekdays?.append(dayOfWeek)
            } else {
                if let indexToRemove = selectedWeekdays.firstIndex(of: dayOfWeek) {
                    selectedWeekdays.remove(at: indexToRemove)
                }
                if let indexToRemove = initialSelectedWeekdays!.firstIndex(of: dayOfWeek) {
                    initialSelectedWeekdays?.remove(at: indexToRemove)
                }
            }
        }
    }
    
    @objc private func saveDaysButtonTapped() {
        delegate?.didSelectWeekdays(selectedWeekdays)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        if indexPath.row == 6 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        cell.textLabel?.text = weekdays[indexPath.row].rawValue.localized
        cell.accessoryView = switches[indexPath.row]
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }
}

