//
//  FavoritesViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import SwiftUI

final class FavoritesViewController: UIViewController {
    private let favoritesViewModel = FavoritesViewModel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await favoritesViewModel.fetchFavorites()
            favoritesTableView.reloadData()
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate, FavoritesTableViewCellDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritesViewModel.getFavoritesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let currentFavoriteProduct = favoritesViewModel.getFavorite(at: indexPath.row)
        cell.delegate = self
        cell.configureCell(with: currentFavoriteProduct)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentFavoriteProduct = favoritesViewModel.getFavorite(at: indexPath.row)
        
        let productDetailsView = ProductDetailsView(productId: currentFavoriteProduct.id)
        
        let hostingController = UIHostingController(rootView: productDetailsView)
        
        navigationController?.pushViewController(hostingController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addToCartButtonTapped(cell: FavoriteTableViewCell) {
        guard let indexPath = favoritesTableView.indexPath(for: cell) else { return }
        let currentFavoriteProduct = favoritesViewModel.getFavorite(at: indexPath.row)
        
        Task {
            try await favoritesViewModel.addProductToCart(productId: currentFavoriteProduct.id)
            let toast = ToastView(message: "added to cart", type: .success)
            toast.show(in: self.view)
        }
    }
    
    func deleteButtonTapped(cell: FavoriteTableViewCell) {
        guard let indexPath = favoritesTableView.indexPath(for: cell) else { return }
        let currentFavoriteProduct = favoritesViewModel.getFavorite(at: indexPath.row)
        
        Task {
            await favoritesViewModel.deleFavorite(with: currentFavoriteProduct.id)
            await favoritesViewModel.fetchFavorites()
            let toast = ToastView(message: "removed from favorites", type: .success)
            toast.show(in: self.view)
            favoritesTableView.reloadData()
        }
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
