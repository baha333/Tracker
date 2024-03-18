//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var sheduleDelegate: ScheduleProtocol?
    var selectedDays: Set<WeekDays> = []
    
    private var tableView = UITableView()
    private let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Расписание"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        setUpSaveButton()
        initTableView()
    }
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.identifier, for: indexPath) as? ScheduleTableCell else {
            return UITableViewCell()
        }
        configureCell(cell: cell, cellForRowAt: indexPath)
        return cell
    }
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // MARK: - Actions
    
    @objc
    private func saveButtonPressed() {
        navigationController?.popViewController(animated: true)
        sheduleDelegate?.saveSelectedDays(selectedDays: selectedDays)
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            if let weekday = WeekDays(rawValue: sender.tag + 1) {
                selectedDays.insert(weekday)
            }
            
        } else {
            if let weekday = WeekDays(rawValue: sender.tag + 1) {
                selectedDays.remove(weekday)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func setUpSaveButton() {
        saveButton.setTitle("Готово", for: .normal)
        saveButton.backgroundColor = .ypBlack
        saveButton.layer.cornerRadius = 16
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        view.addSubview(saveButton)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureCell(cell: ScheduleTableCell, cellForRowAt indexPath: IndexPath) {
        guard let weekday = WeekDays(rawValue: indexPath.row + 1) else { return }
        cell.textLabel?.text = weekday.name
        cell.prepareForReuse()
        cell.switchButton.tag = indexPath.row
        cell.switchButton.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        if indexPath.row == 6 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
        } else if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 16
        }
        
        if selectedDays.contains(weekday) {
            cell.switchButton.setOn(true, animated: true)
        }
    }
    
    // MARK: - Table Initialization
    
    private func initTableView() {
        tableView.register(ScheduleTableCell.self, forCellReuseIdentifier: ScheduleTableCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
