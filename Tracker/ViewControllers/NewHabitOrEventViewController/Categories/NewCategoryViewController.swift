
import Foundation
import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func addNewCategory(newCategory: String)
}

final class NewCategoryViewController: UIViewController {
    //MARK: - Properties
    private lazy var categoryNameInput: UITextField = {
        let textField = UITextField()
        textField.textColor = .ypBlack
        textField.tintColor = .ypBlack
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "inputCategory.placeholder".localized
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .ypLightGray.withAlphaComponent(0.3)
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 16
        textField.delegate = self
        return textField
    }()
    
    private  lazy var saveCategoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypGray
        button.setTitle("readyButton.Title".localized, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    var newCategory = ""
    weak var delegate: NewCategoryViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        addElements()
        createNavigationBar()
        setupConstraints()
    }
    
    //MARK: - Private Function
    private func addElements(){
        view.addSubview(categoryNameInput)
        view.addSubview(saveCategoryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryNameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameInput.heightAnchor.constraint(equalToConstant: 75),
            
            saveCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "newCategory".localized
    }
    
    //MARK: - @objc Function
    
    @objc private func saveCategoryButtonTapped() {
        delegate?.addNewCategory(newCategory: newCategory)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension UITextFieldDelegate
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let newText = textField.text else {
            return
        }
        let isNewNameFilled = !newText.isEmpty
        saveCategoryButton.isEnabled = isNewNameFilled
        saveCategoryButton.backgroundColor = isNewNameFilled ? .ypBlack : .ypGray
        newCategory = newText
    }
}



