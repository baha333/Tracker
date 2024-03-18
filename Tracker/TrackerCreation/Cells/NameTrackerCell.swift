//
//  NameTrackerCell.swift
//  Tracker
//
//  Created by Bakhadir on 18.03.2024.
//

import Foundation
import UIKit

protocol SaveNameTrackerDelegate: AnyObject {
    func textFieldWasChanged(text: String)
}

final class NameTrackerCell: UICollectionViewCell {
    
    static let identifier = "TrackerNameTextFieldCell"
    weak var delegate: SaveNameTrackerDelegate?
    
    let trackerNameTextField = UITextField()
    let xButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpNameTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = trackerNameTextField.text else { return }
        delegate?.textFieldWasChanged(text: text)
    }
    
    private func setUpNameTextField() {
        contentView.addSubview(trackerNameTextField)
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.backgroundColor = UIColor.ypLightGray.withAlphaComponent(0.3)
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameTextField.setLeftPaddingPoints(12)
        
        trackerNameTextField.clearButtonMode = .whileEditing
        
        trackerNameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingDidEnd)
        
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
