//
//  CategoryCell.swift
//  Tracker
//
//  Created by Bakhadir on 08.04.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryTableViewCell"
    
    // MARK: - Private Properties
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setupViews() {
        contentView.addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
