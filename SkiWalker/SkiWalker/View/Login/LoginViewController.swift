//
//  LoginViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    
    private let pageWrapperStakView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 32
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.text = "Sign in to your Account"
        return label
    }()
    
    private let pageSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customGrey
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text = "Enter your email and password to log in"
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let emailField = LabeledTextField(labelText: "Email", placeholderText: "Enter your email", isEmail: true)
    private let passwordField = LabeledTextField(labelText: "Password", placeholderText: "Enter your password", isSecure: true)
    
    private let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.text = "Forgot Password ?"
        label.textColor = .customBlue
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let loginButton = CustomButton(buttonText: "Login")
    
    private let googleButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "google")
        configuration.title = "Continue with Google"
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .label
        configuration.imagePadding = 10
        configuration.cornerStyle = .medium
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account ?"
        label.textColor = .customGrey
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupPageWrapperStackView()
        setupHeaderStackView()
        setupContentStackView()
        setupFooterStackView()
    }
    
    private func setupPageWrapperStackView() {
        view.addSubview(pageWrapperStakView)
        [headerStackView, contentStackView, footerStackView].forEach { pageWrapperStakView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            pageWrapperStakView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            pageWrapperStakView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            pageWrapperStakView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
        ])
    }
    
    private func setupHeaderStackView() {
        [logoImageView, pageTitleLabel, pageSubTitleLabel].forEach { headerStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            headerStackView.leftAnchor.constraint(equalTo: pageWrapperStakView.leftAnchor),
            headerStackView.rightAnchor.constraint(equalTo: pageWrapperStakView.rightAnchor),
            headerStackView.topAnchor.constraint(equalTo: pageWrapperStakView.topAnchor),
        ])
    }
    
    private func setupContentStackView() {
        [emailField, passwordField, forgotPasswordLabel].forEach { contentStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            contentStackView.leftAnchor.constraint(equalTo: pageWrapperStakView.leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: pageWrapperStakView.rightAnchor),
        ])
    }
    
    private func setupFooterStackView() {
        let dontHaveAccountStackView = UIStackView()
        dontHaveAccountStackView.translatesAutoresizingMaskIntoConstraints = false
        dontHaveAccountStackView.axis = .horizontal
        dontHaveAccountStackView.distribution = .equalSpacing
        
        [dontHaveAccountLabel, signUpButton].forEach { dontHaveAccountStackView.addArrangedSubview($0) }
        [loginButton, googleButton, dontHaveAccountStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            footerStackView.leftAnchor.constraint(equalTo: pageWrapperStakView.leftAnchor),
            footerStackView.rightAnchor.constraint(equalTo: pageWrapperStakView.rightAnchor),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        loginButton.addAction(UIAction(handler: { [weak self] action in
            self?.login()
        }), for: .touchUpInside)
    }
    
    private func login() {
        Task {
            do {
                let _ =  try await viewModel.login(email: emailField.getText() ?? "", password: passwordField.getText() ?? "")
            } catch LoginError.invalidEmail {
                AlertManager.showAlert(message: "Invalid email, it should contain @")
            } catch LoginError.invalidPassword {
                AlertManager.showAlert(message: "Fill Password Field")
            }
        }
    }
}

struct LoginView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        // empty for now
    }
}
