//
//  ToastNotification.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 15.01.25.
//
import UIKit

final class ToastView: UIView {
    
    private let messageLabel = UILabel()
    private let iconImageView = UIImageView()
    
    init(message: String, type: ToastType) {
        super.init(frame: .zero)
        setupView(message: message, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(message: String, type: ToastType) {
        backgroundColor = type.backgroundColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        iconImageView.image = type.icon
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, messageLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func show(in view: UIView, duration: TimeInterval = 2.0) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -60)
        ])
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 50)
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                UIView.animate(withDuration: 0.5, animations: {
                    self?.transform = .identity
                }) { _ in
                    self?.removeFromSuperview()
                }
            }
        }
    }
}

enum ToastType {
    case success
    case error
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return UIColor.systemGreen
        case .error:
            return UIColor.systemRed
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle")
        case .error:
            return UIImage(systemName: "xmark.octagon")
        }
    }
}
