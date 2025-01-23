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
    
    private let emptyCartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "emptyCart")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let cartDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var numberOfProducts = LabelAndValueView(labelText: "Number of products", valueText: "2", isVertical: false)
    private lazy var totalPrice = LabelAndValueView(labelText: "Total Price", valueText: "260 ₾", isVertical: false)
    private lazy var checkoutButton = CustomButton(buttonText: "Checkout")
    
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
        cartViewModel.doneFetching = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
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
        let checkoutView = CheckoutView(productId: nil, quantity: nil)
        
        let hostingController = UIHostingController(rootView: checkoutView)
        
        navigationController?.pushViewController(hostingController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func updateUI() {
        numberOfProducts.updateValue("\(cartViewModel.getCartTotalItemCount())")
        totalPrice.updateValue(cartViewModel.getTotalPriceFormatted())
        
        if cartViewModel.getCartItemsCount() < 1 {
            view.addSubview(emptyCartImageView)
            NSLayoutConstraint.activate([
                emptyCartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyCartImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyCartImageView.heightAnchor.constraint(equalToConstant: 200),
                emptyCartImageView.widthAnchor.constraint(equalTo: emptyCartImageView.heightAnchor),
            ])
            
            cartTableView.removeFromSuperview()
            cartDetailsStackView.removeFromSuperview()
        } else {
            emptyCartImageView.removeFromSuperview()
        }
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
                try await cartViewModel.updateProduct(productId: currentItem.product.id, count: adjustedStepValue)
                await cartViewModel.fetchCart()
                DispatchQueue.main.async { [weak self] in
                    self?.cartTableView.reloadRows(at: [indexPath], with: .none)
                }
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
        
    }
    
    func didTapFavorite(cell: CartTableViewCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        let currentItem = cartViewModel.getCartItem(at: indexPath.row)
        
        Task {
            if currentItem.product.favorite {
                await cartViewModel.removeFromFavorites(with: currentItem.product.id)
            } else {
                await cartViewModel.addToFavorites(with: currentItem.product.id)
            }
            await cartViewModel.fetchCart()
            DispatchQueue.main.async { [weak self] in
                self?.cartTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await cartViewModel.fetchCart()
            cartTableView.reloadData()
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

