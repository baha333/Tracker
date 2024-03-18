//
//  HeaderCollectionReusableView.swift
//  Tracker
//
//  Created by Bakhadir on 15.03.2024.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "Header"
    
    var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        
        headerLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
