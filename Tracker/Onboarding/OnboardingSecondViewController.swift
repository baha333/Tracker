
import Foundation
import UIKit

final class OnboardingSecondViewController: UIViewController {
    var pageViewController: PageViewController?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode  = .scaleAspectFill
        imageView.image = UIImage(named: "onboarding2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Даже если это не литры воды и йога"
        label.textColor = .ypBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private  lazy var transitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Вот это технологии!", for: .normal)
        button.tintColor = .ypWhite
        button.titleLabel?.textColor = .ypWhite
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        addElements()
        setupConstraints()
        pageViewController = PageViewController()
    }
    
    private func addElements(){
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(transitButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 114),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            transitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            transitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            transitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func transitButtonTapped() {
        pageViewController?.transitButtonTapped()
    }
}
