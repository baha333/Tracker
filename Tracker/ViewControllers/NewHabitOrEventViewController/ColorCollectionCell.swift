
import Foundation
import UIKit

final class ColorCollectionCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let rectangerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(rectangerView)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Function
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rectangerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rectangerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rectangerView.widthAnchor.constraint(equalToConstant: 40),
            rectangerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(color: UIColor) {
        rectangerView.backgroundColor = color
    }
}
