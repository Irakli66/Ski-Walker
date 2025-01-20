//
//  CartViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//

import SwiftUI

final class CartViewController: UIViewController {
    private let cartViewModel = CartViewModel()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customPurple
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "My Cart"
        return label
    }()
    
    private let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let cartDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.text = "Order Summary"
        return label
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
        setupCartDetailsStackView()
        setupCartTableView()
    }
    
    private func setupCartTableView() {
        view.addSubview(cartTableView)
        
        NSLayoutConstraint.activate([
            cartTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            cartTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            cartTableView.topAnchor.constraint(equalTo: pageTitleLabel.bottomAnchor, constant: 30),
            cartTableView.bottomAnchor.constraint(equalTo: cartDetailsStackView.topAnchor),
            
        ])
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
    }
    
    private func setupCartDetailsStackView() {
        view.addSubview(cartDetailsStackView)
        
        let numberOfProducts = LabelAndValueView(labelText: "Number of products", valueText: "2", isVertical: false)
        let totalPrice = LabelAndValueView(labelText: "Total Price", valueText: "260 ₾", isVertical: false)
        let checkoutButton = CustomButton(buttonText: "Checkout")
        
        [orderLabel, numberOfProducts, totalPrice, checkoutButton].forEach { cartDetailsStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            cartDetailsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            cartDetailsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            cartDetailsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        
        checkoutButton.addAction(UIAction(handler: {[weak self] _ in
            self?.checkout()
        }), for: .touchUpInside)
    }
    
    private func checkout() {
        print("checkout")
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate, CartTableViewCellDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartViewModel.getCartItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let currentItem = cartViewModel.getCartItem(at: indexPath.row)
        cell.delegate = self
        cell.configureCell(with: currentItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = cartViewModel.getCartItem(at: indexPath.row)
        
        let productDetailsView = ProductDetailsView(productId: currentItem.product.id)
        
        let hostingController = UIHostingController(rootView: productDetailsView)
        
        navigationController?.pushViewController(hostingController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func didChangeStepperValue(cell: CartTableViewCell, adjustedStepValue: Int) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        let currentItem = cartViewModel.getCartItem(at: indexPath.row)
        
        Task {
            do {
                print(adjustedStepValue)
                try await cartViewModel.updateProduct(productId: currentItem.product.id, count: adjustedStepValue)
                await cartViewModel.fetchCart()
                cartTableView.reloadData()
            } catch {
                print("Error updating cart: \(error.localizedDescription)")
            }
        }
    }
    
    func didTapDelete(cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        let currentItem = cartViewModel.getCartItem(at: indexPath.row)
        
        Task {
            do {
                try await cartViewModel.deleteCartItem(with: currentItem.id)
                await cartViewModel.fetchCart()
                cartTableView.reloadData()
            } catch {
                print("error deleting cart item: \(error.localizedDescription)")
            }
        }
        
        print(indexPath.row)
    }
    
    func didTapFavorite(cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        let currentItem = cartViewModel.getCartItem(at: indexPath.row)
        print(currentItem)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await cartViewModel.fetchCart()
        }
    }
    
}

struct CartView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: CartViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

