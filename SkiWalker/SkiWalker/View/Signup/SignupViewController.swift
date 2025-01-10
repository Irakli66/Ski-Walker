//
//  SignupViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class SignupViewController: UIViewController {
    
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
        label.text = "Register"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private let pageSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create an account to continue!"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Customer", "Vendor"])
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
    
    // Customer Fields
    private let firstNameField = LabeledTextField(labelText: "First Name", placeholderText: "Enter your first name")
    private let lastNameField = LabeledTextField(labelText: "Last Name", placeholderText: "Enter your last name")
    
    // Vendor Fields
    private let companyNameField = LabeledTextField(labelText: "Company Name", placeholderText: "Enter your company name")
    private let companyIDField = LabeledTextField(labelText: "Company ID", placeholderText: "Enter your company ID")
    
    private let emailField = LabeledTextField(labelText: "Email", placeholderText: "Enter your email", isEmail: true)
    private let passwordField = LabeledTextField(labelText: "Password", placeholderText: "Enter your password", isSecure: true)
    private let confirmPasswordField = LabeledTextField(labelText: "Confirm Password", placeholderText: "Repeat the password", isSecure: true)
    
    private let registerButton = CustomButton(buttonText: "Register")
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

struct SignupView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SignupViewController {
        SignupViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignupViewController, context: Context) {}
}

enum UserRole: String, Hashable {
    case customer = "Customer"
    case vendor = "Vendor"
}
