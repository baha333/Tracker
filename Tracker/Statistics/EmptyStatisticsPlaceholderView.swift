import UIKit
final class EmptyStatisticsPlaceholderView: UIView {
    
    //MARK: - Private Properties
    
    private lazy var emptyScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.image = UIImage(named: "ErrorSmile")
        launchScreenImage.contentMode = .scaleToFill
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        launchScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        launchScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return launchScreenImage
    } ()
    
    private lazy var emptyStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("emptyStatistics.text", comment: "")
        label.numberOfLines = 0
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    //MARK: - Functions
    
    func configureEmptyStatisticsPlaceholder() {

        addSubview(emptyStatisticsLabel)
        addSubview(emptyScreenImage)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyStatisticsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStatisticsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            emptyStatisticsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStatisticsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
