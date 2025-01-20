//
//  FavoritesViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class FavoritesViewController: UIViewController {
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customPurple
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Favorites"
        return label
    }()
    
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            pageTitleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        setupFavoritesTableView()
    }
    
    private func setupFavoritesTableView() {
        view.addSubview(favoritesTableView)
        
        NSLayoutConstraint.activate([
            favoritesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            favoritesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            favoritesTableView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 30),
            favoritesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteTableViewCell")
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate, FavoritesTableViewCellDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = "b4250b33-9f40-403c-995d-20136c333121"
        
        let productDetailsView = ProductDetailsView(productId: id)
        
        let hostingController = UIHostingController(rootView: productDetailsView)
        
        navigationController?.pushViewController(hostingController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addToCartButtonTapped(cell: FavoriteTableViewCell) {
        guard let indexPath = favoritesTableView.indexPath(for: cell) else { return }
        print(indexPath.row)
    }
    
    func didTapFavorite(cell: FavoriteTableViewCell) {
        guard let indexPath = favoritesTableView.indexPath(for: cell) else { return }
        print(indexPath.row)
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
