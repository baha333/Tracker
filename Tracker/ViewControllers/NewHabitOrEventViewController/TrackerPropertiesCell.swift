
import Foundation
import UIKit

protocol TrackerPropertiesCellDelegate: AnyObject {
    func nextButtonTapped(at indexPath: IndexPath)
}

final class TrackerPropertiesCell: UITableViewCell {
    
    //MARK: - Properties
    private let propertiesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "categoryTitle".localized
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private  lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "chevron"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let properties = ["categoryTitle".localized, "scheduleTitle".localized]
    private var indexPath: IndexPath?
    weak var delegate: TrackerPropertiesCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  Helper
    func configure(indexPath: IndexPath) {
        self.indexPath = indexPath
        propertiesTitleLabel.text = properties[indexPath.row]
    }
    
    func setup(detailsText: String?) {
        detailsLabel.text = detailsText
        detailsLabel.isHidden = detailsText == nil
       }
    
    //MARK: - Private Function
    private func addElements() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(propertiesTitleLabel)
        stackView.addArrangedSubview(detailsLabel)
        
        contentView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.heightAnchor.constraint(equalToConstant: 46),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -46),
            
            nextButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 46),
            nextButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    //MARK: - @objc Function
    @objc private func nextButtonTapped(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        delegate?.nextButtonTapped(at: indexPath)
    }
}
