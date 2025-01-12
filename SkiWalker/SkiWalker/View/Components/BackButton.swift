//
//  BackButton.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 12.01.25.
//
import UIKit

class BackButton: UIButton {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        super.init(frame: .zero)
        self.navigationController = navigationController
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(systemName: "chevron.left"), for: .normal)
        tintColor = .label
        addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
}
