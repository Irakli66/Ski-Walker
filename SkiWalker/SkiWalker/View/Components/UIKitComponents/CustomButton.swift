//
//  CustomButton.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import UIKit

final class CustomButton: UIButton {
    
    init(buttonText: String) {
        super.init(frame: .zero)
        setupButton(buttonText: buttonText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(buttonText: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .customPurple
        self.setTitle(buttonText, for: .normal)
        self.setTitleColor(.customWhite, for: .normal)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 6
        self.layer.masksToBounds = false
    }
}
