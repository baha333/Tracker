//
//  EmojisAndColorsCell.swift
//  Tracker
//
//  Created by Bakhadir on 21.04.2024.
//

import UIKit

final class EmojisAndColorsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojisAndColorsCell"
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withEmoji emoji: String?, backgroundColor: UIColor?) {
        titleLabel.text = emoji
        self.backgroundColor = backgroundColor
    }
    
    private func configureCell() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
}
