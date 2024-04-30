//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Bakhadir on 21.04.2024.
//

import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func trackerDidCreate()
}

final class AddTrackerViewController: UIViewController {
    
    var screenTitle: String = ""
    weak var delegate: AddTrackerViewControllerDelegate?
        
    //MARK: - Private Properties

    private let habitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let irregularButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Нерегулярные событие", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupConstraints()
        setupButtons()
        view.backgroundColor = .ypWhite
    }
    
     //MARK: - Actions
   
       @objc private func habitButtonClicked() {
           let configureTrackerViewController = ConfigureTrackerViewController()
           configureTrackerViewController.isRepeat = true
           configureTrackerViewController.delegate = self
           let navigationController = UINavigationController(rootViewController: configureTrackerViewController)
           present(navigationController, animated: true)
       }
   
       @objc private func irregularButtonClicked() {
           let configureTrackerViewController = ConfigureTrackerViewController()
           configureTrackerViewController.isRepeat = false
           configureTrackerViewController.delegate = self
           let navigationController = UINavigationController(rootViewController: configureTrackerViewController)
           present(navigationController, animated: true)
       }
   
    //MARK: - Private Functions
   
       private func setupNavBar(){
           navigationItem.title = "Создание трека"
       }
   
       private func setupButtons() {
           habitButton.addTarget(self, action: #selector(habitButtonClicked), for: .touchUpInside)
           irregularButton.addTarget(self, action: #selector(irregularButtonClicked), for: .touchUpInside)
           stackView.addArrangedSubview(habitButton)
           stackView.addArrangedSubview(irregularButton)
       }
   
       private func setupConstraints() {
           view.addSubview(stackView)
   
           NSLayoutConstraint.activate([
               stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
               stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
               stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
               stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               stackView.heightAnchor.constraint(equalToConstant: 136)
           ])
       }
}

//MARK: - ConfigureTrackerViewControllerDelegate

extension AddTrackerViewController: ConfigureTrackerViewControllerDelegate {
    func trackerDidSaved() {
        dismiss(animated: true, completion: { self.delegate?.trackerDidCreate() })
    }
}
