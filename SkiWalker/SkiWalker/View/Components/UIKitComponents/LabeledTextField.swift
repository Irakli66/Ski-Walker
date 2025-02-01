//
//  LabeledTextField.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//

import UIKit

final class LabeledTextField: UIView, UITextFieldDelegate {
    private weak var parentView: UIView?
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .customGrey
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .customWhite
        textField.layer.cornerRadius = 10
        textField.delegate = self
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftView = spacer
        textField.leftViewMode = .always
        
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 6
        textField.layer.masksToBounds = false
        textField.autocorrectionType = .no
        
        return textField
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private var isSecureEntry: Bool
    private var isEmail: Bool
    
    init(labelText: String, placeholderText: String, isSecure: Bool = false, isEmail: Bool = false, parentView: UIView? = nil) {
        self.isSecureEntry = isSecure
        self.isEmail = isEmail
        self.parentView = parentView
        super.init(frame: .zero)
        setupView(labelText: labelText, placeholderText: placeholderText)
        setupKeyboardNotifications()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(labelText: String, placeholderText: String) {
        label.text = labelText
        textField.placeholder = placeholderText
        textField.isSecureTextEntry = isSecureEntry
        textField.keyboardType = isEmail ? .emailAddress : .default
        
        addSubview(label)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        if isSecureEntry {
            addSubview(toggleButton)
            toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                toggleButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
                toggleButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -8),
                toggleButton.widthAnchor.constraint(equalToConstant: 24),
                toggleButton.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
    }
    
    @objc private func togglePasswordVisibility() {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let parentView = parentView else { return }
        guard let window = findKeyWindow() else { return }
        
        if textField.isFirstResponder {
            let keyboardHeight = keyboardFrame.height
            let textFieldFrame = self.convert(self.bounds, to: window)
            let bottomSpace = window.frame.height - textFieldFrame.maxY
            
            if bottomSpace < keyboardHeight {
                let offset = keyboardHeight - bottomSpace + 10
                UIView.animate(withDuration: 0.3) {
                    parentView.transform = CGAffineTransform(translationX: 0, y: -offset)
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.parentView?.transform = .identity
        }
    }
    
    private func findKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func clearText() {
        textField.text = ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
