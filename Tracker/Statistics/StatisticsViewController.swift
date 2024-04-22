//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Bakhadir on 16.03.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var titleHeader: UILabel = {
        let label = UILabel()
        label.text = "Cтатистика"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var emptyScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.image = UIImage(named: "ErrorSmile")
        launchScreenImage.contentMode = .scaleToFill
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        launchScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        launchScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return launchScreenImage
    } ()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Анализировать пока нечего"
        label.numberOfLines = 0
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatisticScreen()
        view.backgroundColor = .ypWhite
    }
    
    //MARK: - Private Functions
    private func configureStatisticScreen() {
        
        view.addSubview(label)
        view.addSubview(emptyScreenImage)
        view.addSubview(titleHeader)
        
        NSLayoutConstraint.activate([
            
            titleHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -105),
            titleHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
    }
}
