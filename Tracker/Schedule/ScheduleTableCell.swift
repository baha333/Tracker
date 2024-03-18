//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import Foundation
import UIKit

final class ScheduleTableCell: UITableViewCell {
    static let identifier = "ScheduleTableCell"
    
    let switchButton = UISwitch(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        setUpSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSwitch() {
        switchButton.setOn(false, animated: true)
        self.accessoryView = switchButton
    }
}
