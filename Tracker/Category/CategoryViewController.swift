//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Bakhadir on 08.04.2024.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var categoriesDelegate: ShowCategoriesDelegate?
    private let tableView = UITableView()
    private var categories: [String] = ["Health", "Important"]
    private var selectedCategories: Set<String> = []
    
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Категория"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        setUpButton()
        initTableView()
    }
    
    private func setUpButton() {
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        
        view.addSubview(button)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func initTableView() {
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.prepareForReuse()
        cell.textLabel?.text = categories[indexPath.row]
        cell.layer.masksToBounds = true
        
        // first cell
        if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
        }
        
        // last cell
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedCategories.insert(cell.textLabel?.text ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
