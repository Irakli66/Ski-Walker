//
//  OrderHistoryViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 11.01.25.
//

import SwiftUI

final class OrderHistoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}



struct OrderHistoryView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let loginVC = OrderHistoryViewController()
        return UINavigationController(rootViewController: loginVC)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Empty for now
    }
}
