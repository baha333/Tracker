import UIKit

//MARK: - TypeOfCategory
enum TypeOfCategory {
    case create
    case edit
}

//MARK: - NewCategoryViewControllerDelegate
protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategories(category: String)
    func reloadCategories()
}


final class NewCategoryViewController: UIViewController {
    
    
    weak var delegate: NewCategoryViewControllerDelegate?
    var editingCategoryName: String?
    var typeOfCategory: TypeOfCategory?
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    private var categoryName: String = ""
    
    // MARK: - Private Properties
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .LightGray.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = NSLocalizedString("newCategoryTextField.placeholder", comment: "")
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.smartInsertDeleteType = .no
        textField.addLeftPadding(16)
        return textField
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .Black
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle(NSLocalizedString("doneButton.text", comment: ""), for: .normal)
        button.setTitleColor(.White, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(pushDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .White
        setupNavBar()
        setupView()
        setupConstraints()
        doneButton.isEnabled = false
        doneButton.backgroundColor = .Gray
    }
    
    // MARK: - Actions
    
    @objc private func pushDoneButton() {
        if let text = textField.text, !text.isEmpty {
            let category = TrackerCategory(title: text, trackers: [])
            
            do {
                try trackerCategoryStore.addCategory(category)
            } catch {
                print("Save category failed")
            }
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        navigationItem.title = NSLocalizedString("newCategory.title", comment: "")
    }
    
    private func setupView() {
        [textField,
         doneButton
        ].forEach {
            view.addSubview($0)
        }
        textField.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, !text.isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .Black
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .Gray
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Extension
@objc extension NewCategoryViewController {
    func didTapCreateCategoryButton() {
        if typeOfCategory == .create {
            delegate?.addNewCategories(category: categoryName)
            
        } else if typeOfCategory == .edit {
            guard let editingCategoryName = editingCategoryName else { return }
            delegate?.reloadCategories()
        }
        dismiss(animated: true)
    }
}

