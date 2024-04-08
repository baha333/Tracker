//
//  CategoryCell.swift
//  Tracker
//
//  Created by Bakhadir on 08.04.2024.
//

import Foundation
import UIKit

final class CategoryCell: UITableViewCell {
    static let identifier = "CategoryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
