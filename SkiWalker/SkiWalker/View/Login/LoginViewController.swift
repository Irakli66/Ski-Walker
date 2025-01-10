//
//  LoginViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class LoginViewController: UIViewController {
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
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Sign in to your Account"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
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
