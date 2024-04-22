//
//  ButtonTableViewCell.swift
//  Tracker
//
//  Created by Bakhadir on 18.03.2024.
//

import Foundation
import UIKit

final class ButtonTableViewCell: UITableViewCell {
    
    static let identifier = "ButtonTableViewCell"
    let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "YP Gray")?.withAlphaComponent(0.3)
        accessoryType = .disclosureIndicator
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        setUpTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubtitleLabel(text: String) {
        if (text.count > 0) {
            subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            subtitleLabel.text = text
            subtitleLabel.textColor = .gray
            
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subtitleLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
            stackView.addArrangedSubview(subtitleLabel)
        } else {
            subtitleLabel.text = ""
            stackView.removeArrangedSubview(subtitleLabel)
        }
    }
    
    private func setUpTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(titleLabel)
        stackView.distribution = UIStackView.Distribution.fillEqually
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
