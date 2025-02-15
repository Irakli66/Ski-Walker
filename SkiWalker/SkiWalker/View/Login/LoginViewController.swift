//
//  LoginViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    
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
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.text = NSLocalizedString("Sign in to your Account", comment: "")
        return label
    }()
    
    private let pageSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customGrey
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.text =  NSLocalizedString("Enter your email and password to log in", comment: "")
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let emailField = LabeledTextField(labelText: NSLocalizedString("Email", comment: ""), placeholderText: "Enter your email", isEmail: true)
    private let passwordField = LabeledTextField(labelText: NSLocalizedString("Password", comment: ""), placeholderText: "Enter your password", isSecure: true)
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Forgot Password ?", comment: ""), for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private let loginButton = CustomButton(buttonText: NSLocalizedString("Log in", comment: ""))
    
    private let googleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "google"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .customWhite
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
        
        return button
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "applelogo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
        button.tintColor = .white
        
        return button
    }()
    
    private let dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Don't have an account?", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customGrey
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let forgotPasswordStackView = UIStackView()
        forgotPasswordStackView.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordStackView.axis = .horizontal
        forgotPasswordStackView.alignment = .fill
        forgotPasswordStackView.distribution = .fill
        
        [ UIView(), forgotPasswordButton].forEach { forgotPasswordStackView.addArrangedSubview($0) }
        [emailField, passwordField, forgotPasswordStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            contentStackView.leftAnchor.constraint(equalTo: pageWrapperStakView.leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: pageWrapperStakView.rightAnchor),
        ])
        
        forgotPasswordButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupFooterStackView() {
        let dontHaveAccountStackView = UIStackView()
        dontHaveAccountStackView.translatesAutoresizingMaskIntoConstraints = false
        dontHaveAccountStackView.axis = .horizontal
        dontHaveAccountStackView.distribution = .equalSpacing
        
        let googleAppleSigninStackView = UIStackView()
        googleAppleSigninStackView.axis = .horizontal
        googleAppleSigninStackView.alignment = .center
        googleAppleSigninStackView.distribution = .fillEqually
        googleAppleSigninStackView.spacing = 10
        
        googleAppleSigninStackView.addArrangedSubview(googleButton)
        googleAppleSigninStackView.addArrangedSubview(appleButton)
        
        [dontHaveAccountLabel, signUpButton].forEach { dontHaveAccountStackView.addArrangedSubview($0) }
        [loginButton, googleAppleSigninStackView, dontHaveAccountStackView].forEach { contentStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            footerStackView.leftAnchor.constraint(equalTo: pageWrapperStakView.leftAnchor),
            footerStackView.rightAnchor.constraint(equalTo: pageWrapperStakView.rightAnchor),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
            appleButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        loginButton.addAction(UIAction(handler: { [weak self] action in
            self?.login()
        }), for: .touchUpInside)
        
        signUpButton.addAction(UIAction(handler: { [weak self] action in
            self?.didTapSignup()
        }), for: .touchUpInside)
    }
    
    private func login() {
        Task {
            do {
                let _ =  try await viewModel.login(email: emailField.getText(), password: passwordField.getText())
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let toast = ToastView(message: "Login successful!", type: .success)
                    toast.show(in: self.view)
                }
            } catch LoginError.invalidEmail {
                AlertManager.showAlert(message: "Invalid email, it should contain @")
            } catch LoginError.invalidPassword {
                AlertManager.showAlert(message: "Fill Password Field")
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else {return}
                    let toast = ToastView(message: error.localizedDescription, type: .error)
                    toast.show(in: self.view)
                }
            }
        }
    }
    
    
    private func didTapSignup() {
        let signupVC = SignupViewController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}


struct LoginView: UIViewControllerRepresentable {
    @EnvironmentObject var sessionManager: SessionManager
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let loginViewModel = LoginViewModel(sessionManager: sessionManager)
        
        let loginVC = LoginViewController(viewModel: loginViewModel)
        return UINavigationController(rootViewController: loginVC)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

