//
//  SetNewPasswordViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import UIKit

final class SetNewPasswordViewController: UIViewController {
    private let setNewPasswordViewModel = SetNewPasswordViewModel()
    var email: String?
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
        label.text = NSLocalizedString("Set New Password", comment: "")
        return label
    }()
    
    private let pageSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customGrey
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text =  NSLocalizedString("Check your mail for a code", comment: "")
        return label
    }()
    
    private let mailCodeField = LabeledTextField(labelText: NSLocalizedString("Mail Code", comment: ""), placeholderText: "Enter your code from mail", isEmail: true)
    private let passwordField = LabeledTextField(labelText: NSLocalizedString("Password", comment: ""), placeholderText: NSLocalizedString("Enter your password", comment: ""), isSecure: true)
    private let confirmPasswordField = LabeledTextField(labelText: NSLocalizedString("Confirm Password", comment: ""), placeholderText: NSLocalizedString("Repeat the password", comment: ""), isSecure: true)
    
    private let saveButton = CustomButton(buttonText: NSLocalizedString("Save", comment: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(navigateBackButton)
        view.addSubview(pageWrapperStackView)
        
        [pageTitleLabel, pageSubTitleLabel, mailCodeField, passwordField, confirmPasswordField, saveButton].forEach { pageWrapperStackView.addArrangedSubview($0) }
        
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
        
        saveButton.addAction(UIAction(handler: { [weak self] action in
            self?.updatePassword()
        }), for: .touchUpInside)
    }
    
    private func updatePassword() {
        Task {
            do {
                let _ = try await setNewPasswordViewModel.updatePassword(email: email ?? "", mailCode: mailCodeField.getText(), password: passwordField.getText(), confirmPassword: confirmPasswordField.getText())
            } catch {
                AlertManager.showAlert(message: error.localizedDescription)
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
