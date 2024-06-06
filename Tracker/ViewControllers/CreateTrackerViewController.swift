
import Foundation
import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func addNewTracker(newTracker: TrackerCategory)
}

final class CreateTrackerViewController: UIViewController {
    
    //MARK: - Properties
    private  lazy var habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("buttonНabit.title".localized, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private  lazy var irregularEventsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("buttonEvent.title".localized, for: .normal)
        button.tintColor = .ypWhite
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(irregularEventsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        addElements()
        createNavigationBar()
        setupConstraints()
    }
    
    // MARK: - Private Function
    private func addElements(){
        view.addSubview(habitButton)
        view.addSubview(irregularEventsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            irregularEventsButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularEventsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            irregularEventsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "createTrackers.title".localized
    }
    
    // MARK: - @objc Function
    @objc private func habitButtonTapped() {
        let newHabitVC = NewHabitOrEventViewController()
        newHabitVC.eventMode = false
        newHabitVC.delegate = self
        let navVC = UINavigationController(rootViewController: newHabitVC)
        present(navVC, animated: true)
    }
    
    @objc private func irregularEventsButtonTapped() {
        let newHabitVC = NewHabitOrEventViewController()
        newHabitVC.eventMode = true
        newHabitVC.delegate = self
        let navVC = UINavigationController(rootViewController: newHabitVC)
        present(navVC, animated: true)
    }
}

// MARK: - Extension NewHabitOrEventViewControllerDelegate
extension CreateTrackerViewController: NewHabitOrEventViewControllerDelegate {
    func addNewTracker(newTracker: TrackerCategory) {
        delegate?.addNewTracker(newTracker: newTracker)
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
    }
}
