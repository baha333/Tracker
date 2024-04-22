//
//  PlaceHolderView.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import UIKit

final class PlaceholderView: UIView {
    
    //MARK: - Private Properties
    private lazy var emptyTrackersImage: UIImageView = {
        let emptyTrackersImage = UIImageView()
        emptyTrackersImage.image = UIImage(named: "EmptyTrackerIcon")
        emptyTrackersImage.contentMode = .scaleToFill
        emptyTrackersImage.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptyTrackersImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return emptyTrackersImage
    } ()
    
    private lazy var questionLabel: UILabel = {
       let questionLabel = UILabel()
       questionLabel.translatesAutoresizingMaskIntoConstraints = false
       questionLabel.text = "Что будем отслеживать?"
       questionLabel.numberOfLines = 0
       questionLabel.textColor = .ypBlack
       questionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
       questionLabel.textAlignment = NSTextAlignment.center
       return questionLabel
    }()

    //MARK: - Functions
    func configureEmptyTrackerPlaceholder() {

        addSubview(questionLabel)
        addSubview(emptyTrackersImage)
        translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: emptyTrackersImage.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            emptyTrackersImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyTrackersImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
