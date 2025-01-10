//
//  FavoritesViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class FavoritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }
}

struct FavoritesView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FavoritesViewController {
        return FavoritesViewController()
    }

    func updateUIViewController(_ uiViewController: FavoritesViewController, context: Context) {
        // empty for now
    }
}
