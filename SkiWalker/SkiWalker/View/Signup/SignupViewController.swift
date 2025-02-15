//
//  SignupViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class SignupViewController: UIViewController {
    private let signupViewModel = SignupViewModel()
    private var currentCategory: UserRole = .customer
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageWrapperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25
        return stackView
    }()
    
    private let navigateBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Register", comment: "")
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let pageSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Create an account to continue!", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [NSLocalizedString("Customer", comment: ""), NSLocalizedString("Vendor", comment: "")])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let firstNameField = LabeledTextField(labelText: NSLocalizedString("First Name", comment: ""), placeholderText: NSLocalizedString("Enter your first name", comment: ""))
    private let lastNameField = LabeledTextField(labelText: NSLocalizedString("Last Name", comment: ""), placeholderText: NSLocalizedString("Enter your last name", comment: ""))
    
    private let companyNameField = LabeledTextField(labelText: NSLocalizedString("Company Name", comment: ""), placeholderText: NSLocalizedString("Enter your company name", comment: ""))
    private let companyIDField = LabeledTextField(labelText: NSLocalizedString("Company ID", comment: ""), placeholderText: NSLocalizedString("Enter your company ID", comment: ""))
    
    private let emailField = LabeledTextField(labelText: NSLocalizedString("Email", comment: ""), placeholderText: "Enter your email", isEmail: true)
    private let passwordField = LabeledTextField(labelText: NSLocalizedString("Password", comment: ""), placeholderText: NSLocalizedString("Enter your password", comment: ""), isSecure: true)
    private let confirmPasswordField = LabeledTextField(labelText: NSLocalizedString("Confirm Password", comment: ""), placeholderText: NSLocalizedString("Repeat the password", comment: ""), isSecure: true)
    
    private let registerButton = CustomButton(buttonText: NSLocalizedString("Register", comment: ""))
    
    private let alreadyHaveAccLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Already have an account?", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customGrey
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Log in", comment: ""), for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        registerButton.addAction(UIAction(handler: { [weak self] action in
            self?.register()
        }), for: .touchUpInside)
        updateFormFields()
    }
    
    private func setupUI() {
        view.backgroundColor = .customBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(pageWrapperStackView)
        view.addSubview(navigateBackButton)
        
        pageWrapperStackView.addArrangedSubview(headerStackView)
        headerStackView.addArrangedSubview(pageTitleLabel)
        headerStackView.addArrangedSubview(pageSubTitleLabel)
        pageWrapperStackView.addArrangedSubview(segmentControl)
        pageWrapperStackView.addArrangedSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            navigateBackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            navigateBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            scrollView.topAnchor.constraint(equalTo: navigateBackButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            pageWrapperStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            pageWrapperStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pageWrapperStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            pageWrapperStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        [loginButton, navigateBackButton].forEach {
            $0.addAction(UIAction(handler: { [weak self] action in
                self?.navigationController?.popViewController(animated: true)
            }), for: .touchUpInside)
        }
    }
    
    @objc private func segmentChanged() {
        currentCategory = segmentControl.selectedSegmentIndex == 0 ? .customer : .vendor
        updateFormFields()
    }
    
    private func updateFormFields() {
        let alreadyHaveAccStackView = UIStackView()
        alreadyHaveAccStackView.translatesAutoresizingMaskIntoConstraints = false
        alreadyHaveAccStackView.axis = .horizontal
        alreadyHaveAccStackView.distribution = .equalSpacing
        [alreadyHaveAccLabel, loginButton].forEach { alreadyHaveAccStackView.addArrangedSubview($0) }
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if currentCategory == .customer {
            contentStackView.addArrangedSubview(firstNameField)
            contentStackView.addArrangedSubview(lastNameField)
        } else {
            contentStackView.addArrangedSubview(companyNameField)
            contentStackView.addArrangedSubview(companyIDField)
        }
        
        [emailField, passwordField, confirmPasswordField, registerButton, alreadyHaveAccStackView].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func register() {
        registerButton.isEnabled = false
        Task {
            do {
                if currentCategory == .customer {
                    try await signupViewModel.register(
                        firstName: firstNameField.getText(),
                        lastName: lastNameField.getText(),
                        email: emailField.getText(),
                        password: passwordField.getText(),
                        confirmPassword: confirmPasswordField.getText(),
                        userRole: .customer
                    )
                } else {
                    try await signupViewModel.register(
                        companyName: companyNameField.getText(),
                        companyID: companyIDField.getText(),
                        email: emailField.getText(),
                        password: passwordField.getText(),
                        confirmPassword: confirmPasswordField.getText(),
                        userRole: .vendor
                    )
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let toast = ToastView(message: "Signup successful!", type: .success)
                    toast.show(in: self.view)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
                resetFields()
            } catch {
                handleSignupError(error)
            }
            registerButton.isEnabled = true
        }
    }
    
    private func resetFields() {
        firstNameField.clearText()
        lastNameField.clearText()
        companyNameField.clearText()
        companyIDField.clearText()
        emailField.clearText()
        passwordField.clearText()
        confirmPasswordField.clearText()
    }
    
    private func handleSignupError(_ error: Error) {
        if let signupError = error as? SignupErrors {
            AlertManager.showAlert(message: signupError.localizedDescription)
        } else {
            AlertManager.showAlert(message: error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
