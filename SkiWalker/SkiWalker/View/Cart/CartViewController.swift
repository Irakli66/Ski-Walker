//
//  CartViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//

import SwiftUI

final class CartViewController: UIViewController {
    
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
    
    private func updateCart(quantity: Int) {
        print("cart update: \(quantity)")
    }
    
    private func checkout() {
        print("checkout")
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(quantity: 5)
        cell.onStepperValueChanged = { [weak self] adjustedStepValue in
            self?.updateCart(quantity: adjustedStepValue)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productId = "b4250b33-9f40-403c-995d-20136c333121"

        let productDetailsView = ProductDetailsView(productId: productId)

        let hostingController = UIHostingController(rootView: productDetailsView)

        navigationController?.pushViewController(hostingController, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

struct CartView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: CartViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
