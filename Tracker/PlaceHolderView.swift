//
//  PlaceHolderView.swift
//  Tracker
//
//  Created by Bakhadir on 17.03.2024.
//

import Foundation
import UIKit

final class PlaceHolderView: UIView {
    
    private var imageView = UIImageView()
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func setUpNoTrackersState() {
        let image = UIImage(named: "star")
        imageView.image = image
        
        label.text = "Что будем отслеживать?"
    }
    
    func setUpNoSearchResultsState() {
        let image = UIImage(named: "NoResult")
        imageView.image = image
        
        label.text = "Ничего не найдено"
    }
    
    func setUpNoStatisticState() {
        
    }
}
