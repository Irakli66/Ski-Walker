//
//  ForgotPasswordViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import UIKit

final class ForgotPasswordViewController: UIViewController {
    private let forgotPasswordViewModel = ForgotPasswordViewModel()
    private let pageWrapperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let navigateBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.text = NSLocalizedString("Recover Password", comment: "")
        return label
    }()
    
    private let pageSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customGrey
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text =  NSLocalizedString("Enter email to recover your password", comment: "")
        return label
    }()
    
    private let emailField = LabeledTextField(labelText: NSLocalizedString("Email", comment: ""), placeholderText: "Enter your email", isEmail: true)
    
    private let sendButton = CustomButton(buttonText: NSLocalizedString("Send", comment: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(navigateBackButton)
        view.addSubview(pageWrapperStackView)
        
        [pageTitleLabel, pageSubTitleLabel, emailField, sendButton].forEach { pageWrapperStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            navigateBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            navigateBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            pageWrapperStackView.topAnchor.constraint(equalTo: navigateBackButton.bottomAnchor, constant: 20),
            pageWrapperStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageWrapperStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        navigateBackButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        sendButton.addAction(UIAction(handler: { [weak self] action in
            self?.sendMailCode()
        }), for: .touchUpInside)
    }
    
    private func sendMailCode() {
        Task {
            do {
                let _ = try await forgotPasswordViewModel.sendMailCode(with: emailField.getText())
            } catch {
                AlertManager.showAlert(message: error.localizedDescription)
            }
            let vc = SetNewPasswordViewController()
            vc.email = emailField.getText()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
