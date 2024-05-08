//
//  EmptySearchPlaceholderView.swift
//  Tracker
//
//  Created by Bakhadir on 21.04.2024.
//

import UIKit

final class EmptySearchPlaceholderView: UIView {
    
    //MARK: - Private Properties
    private lazy var emptySearchImage: UIImageView = {
        let emptySearchImage = UIImageView()
        emptySearchImage.image = UIImage(named: "EmptySearch")
        emptySearchImage.contentMode = .scaleToFill
        emptySearchImage.translatesAutoresizingMaskIntoConstraints = false
        emptySearchImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptySearchImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return emptySearchImage
    } ()
    
    private lazy var textLabel: UILabel = {
       let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = NSLocalizedString("emptySearch.text", comment: "")
        textLabel.numberOfLines = 0
        textLabel.textColor = .ypBlack
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textAlignment = NSTextAlignment.center
       return textLabel
    }()

    //MARK: - Functions
    func configureEmptySearchPlaceholder() {

        addSubview(textLabel)
        addSubview(emptySearchImage)
        translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: emptySearchImage.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            emptySearchImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptySearchImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
