//
//  NewEventCreationViewController.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import Foundation
import UIKit

final class NewEventCreationViewController: CreationTrackerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIDelegate = self
        configureUIDelegate?.setUpBackground()
    }
    
    @objc
    override func saveButtonPressed() {
        guard let name = trackerName,
              let color = selectedColor,
              let emoji = selectedEmoji
        else { return }
        let week = WeekDays.allCases
        let weekSet = Set(week)
        let tracker = Tracker(
            name: name,
            color: color,
            emoji: emoji,
            schedule: weekSet,
            state: .Event)
        
        creationDelegate?.createTracker(tracker: tracker, category: trackerCategory)
        dismiss(animated: true)
    }
}

//MARK: - ConfigureUIForTrackerCreationProtocol
extension NewEventCreationViewController: ConfigureUIForTrackerCreationProtocol {
    func configureButtonsCell(cell: ButtonsCell) {
        cell.prepareForReuse()
        cell.state = .Event
    }
    
    func setUpBackground() {
        self.title = "Новое нерегулярное событие"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    func calculateTableViewHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 75)
    }
    
    func checkIfSaveButtonCanBePressed() {
        if trackerName != nil,
           selectedEmoji != nil,
           selectedColor != nil,
           trackerCategory != nil
        {
            saveButtonCanBePressed = true
        } else {
            saveButtonCanBePressed = false
        }
    }
}
