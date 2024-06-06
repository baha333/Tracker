
import Foundation
import UIKit

protocol EditingCategoryViewControllerDelegate: AnyObject {
    func saveEditingCategory(editingCategory: String)
}

final class EditingCategoryViewController: UIViewController {
    //MARK: - Properties
    private lazy var categoryNameEditing: UITextField = {
        let textField = UITextField()
        textField.textColor = .ypBlack
        textField.tintColor = .ypBlack
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        button.addTarget(self, action: #selector(saveEditingCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    var editingCategory = ""
    weak var delegate: EditingCategoryViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        categoryNameEditing.text = editingCategory
        addElements()
        createNavigationBar()
        setupConstraints()
    }
    
    //MARK: - Private Function
    private func addElements(){
        view.addSubview(categoryNameEditing)
        view.addSubview(saveCategoryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryNameEditing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameEditing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameEditing.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameEditing.heightAnchor.constraint(equalToConstant: 75),
            
            saveCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "editingCategory.title".localized
    }
    
    //MARK: - @objc Function
    
    @objc private func saveEditingCategoryButtonTapped() {
        delegate?.saveEditingCategory(editingCategory: editingCategory)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension UITextFieldDelegate
extension EditingCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let newText = textField.text else {
            return
        }
        let isNameFilled = !newText.isEmpty
        saveCategoryButton.isEnabled = isNameFilled
        saveCategoryButton.backgroundColor = isNameFilled ? .ypBlack : .ypGray
        editingCategory = newText
    }
}

