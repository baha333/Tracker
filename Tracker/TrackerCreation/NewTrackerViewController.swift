//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import Foundation
import UIKit

final class NewTrackerViewController: UIViewController {
    weak var delegate: TrackerCreationDelegate?
    
    private var newHabbitButton = UIButton()
    private var newEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Создание трекера"
        
        view.backgroundColor = .white
        setUpNewHabbitButton()
        setUpNewEventButton()
    }
    
    @objc
    private func newHabbitPressed() {
        let vc = NewHabitCreationViewController()
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func newEventPressed() {
        let vc = NewEventCreationViewController()
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpNewEventButton() {
        view.addSubview(newEventButton)
        
        newEventButton.setTitle("Нерегулярное событие", for: .normal)
        newEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newEventButton.titleLabel?.textColor = .white
        newEventButton.backgroundColor = UIColor.ypBlack
        newEventButton.layer.cornerRadius = 16
        newEventButton.addTarget(self, action: #selector(newEventPressed), for: .touchUpInside)
        
        newEventButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newEventButton.heightAnchor.constraint(equalToConstant: 60),
            newEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newEventButton.topAnchor.constraint(equalTo: newHabbitButton.bottomAnchor, constant: 16)
        ])
    }
    
    private func setUpNewHabbitButton() {
        view.addSubview(newHabbitButton)
        
        newHabbitButton.setTitle("Привычка", for: .normal)
        newHabbitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newHabbitButton.titleLabel?.textColor = .white
        newHabbitButton.backgroundColor = UIColor.ypBlack
        newHabbitButton.layer.cornerRadius = 16
        newHabbitButton.addTarget(self, action: #selector(newHabbitPressed), for: .touchUpInside)
        
        newHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            newHabbitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newHabbitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newHabbitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
