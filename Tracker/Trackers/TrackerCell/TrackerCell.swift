import UIKit

//MARK: - Protocol

protocol TrackerCellDelegate: AnyObject {
    func completedTracker(id: UUID, at indexPath: IndexPath)
    func uncompletedTracker(id: UUID, at indexPath: IndexPath)
    func updateTrackerPinAction(tracker: Tracker)
    func editTrackerAction(tracker: Tracker)
    func deleteTrackerAction(tracker: Tracker)
}

//MARK: - TrackerCell

final class TrackerCell: UICollectionViewCell {
    
    static let identifier = "taskCellIdentifier"
    weak var delegate: TrackerCellDelegate?
    let pointSize = UIImage.SymbolConfiguration(pointSize: 11)
    
    //MARK: - Private Properties
    
    var mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .ypWhite.withAlphaComponent(0.3)
        label.clipsToBounds = true
        label.layer.cornerRadius = 24 / 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let counterDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus", withConfiguration: pointSize)
        button.setImage(image, for: .normal)
        button.tintColor = .ypWhite
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 34 / 2
        button.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pinnedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Pin")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var isCompletedToday: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var tracker: Tracker?
    private var trackerCompletedDaysCount: Int = 0
    
    //MARK: - Actions
    
    @objc private func trackButtonTapped() {
        guard let trackerID = trackerID, let indexPath = indexPath else {
            assertionFailure("no tracker id")
            return
        }
        
        if isCompletedToday {
            delegate?.uncompletedTracker(id: trackerID, at: indexPath)
        } else {
            delegate?.completedTracker(id: trackerID, at: indexPath)
        }
    }
    
    //MARK: - Functions
    
    func configure(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.tracker = tracker
        self.trackerID = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        self.trackerCompletedDaysCount = completedDays
        
        let color = tracker.color
        addElements()
        configureContentMenu()
        setupConstraints()
        
        mainView.backgroundColor = color
        taskTitleLabel.text = tracker.title
        emojiLabel.text = tracker.emoji
        
        pinnedImage.isHidden = !tracker.isPinned
        
        counterDayLabel.text = formatDaysText(forDays: completedDays)
        
        let image = isCompletedToday ? UIImage(systemName: "checkmark", withConfiguration: pointSize) : UIImage(systemName: "plus", withConfiguration: pointSize)
        plusButton.backgroundColor = color
        plusButton.alpha = isCompletedToday ? 0.3 : 1
        plusButton.setImage(image, for: .normal)
        
    }
    
    func updateRecord(days: Int, isCompleted: Bool) {
        counterDayLabel.text = formatDaysText(forDays: days)
    }
    
    private func addElements() {
        contentView.addSubview(mainView)
        contentView.addSubview(stackView)
        
        mainView.addSubview(emojiLabel)
        mainView.addSubview(taskTitleLabel)
        mainView.addSubview(pinnedImage
        )
        stackView.addSubview(counterDayLabel)
        stackView.addSubview(plusButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            taskTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            taskTitleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            taskTitleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            pinnedImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -4),
            pinnedImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            pinnedImage.widthAnchor.constraint(equalToConstant: 24),
            pinnedImage.heightAnchor.constraint(equalToConstant: 24),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
            
            counterDayLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 16),
            counterDayLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 12),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func updateCounterLabelText(completedDays: Int) {
        counterDayLabel.text = formatDaysText(forDays: completedDays)
    }
    
    private func formatDaysText(forDays days: Int) -> String {
        let daysCounter = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "numberOfDays"), days)
        return daysCounter
    }
    
    private func configureContextMenu() {
        let contextMenu = UIContextMenuInteraction(delegate: self)
        mainView.addInteraction(contextMenu)
    }
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let unpinTracker = NSLocalizedString("unpinTracker.text", comment: "")
        let pinTracker = NSLocalizedString("pinTracker.text", comment: "")
        
        let titleTextIsPinned = (self.tracker?.isPinned ?? false) ? unpinTracker : pinTracker
        
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider:  { suggestedActions in
            
            let pinAction = UIAction(title: titleTextIsPinned) { action in
                guard let tracker = self.tracker else { return }
                
                self.delegate?.updateTrackerPinAction(tracker: tracker)
            }
            
            let editAction = UIAction(title: "Редактировать") { action in
                guard let tracker = self.tracker else { return }
                
                self.delegate?.editTrackerAction(tracker: tracker)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { action in
                guard let tracker = self.tracker else { return }
                
                self.delegate?.deleteTrackerAction(tracker: tracker)
            }
            
            return UIMenu(children: [pinAction, editAction, deleteAction])
        })
    }
}
