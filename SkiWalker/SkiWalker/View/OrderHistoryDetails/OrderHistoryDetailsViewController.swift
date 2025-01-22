//
//  OrderHistoryDetailsViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 13.01.25.
//

import UIKit

final class OrderHistoryDetailsViewController: UIViewController {
    let orderId: String = ""
    var order: Order?
    private let navigateBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customPurple
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "My Orders"
        return label
    }()
    
    private let orderDetailsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customWhite
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let orderDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.backgroundColor = .customWhite
        return stackView
    }()
    
    private let orderProductsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let orderDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackground
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationButtonAndTitle()
        setupOrderDetails()
        setupOrderProductsTableView()
        setupOrderDescription()
    }
    
    private func setupNavigationButtonAndTitle() {
        view.addSubview(navigateBackButton)
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            navigateBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            navigateBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            
            pageTitleLabel.centerYAnchor.constraint(equalTo: navigateBackButton.centerYAnchor),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        navigateBackButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupOrderDetails() {
        guard let order else { return }
        view.addSubview(orderDetailsContainerView)
        orderDetailsContainerView.addSubview(orderDetailsStackView)
        
        let deliveryAddress = LabelAndValueView(labelText: "Delivery Address", valueText: order.deliveryAddress)
        let orderStatus = LabelAndValueView(labelText: "Status", valueText: "\(order.status)")
        let orderId = LabelAndValueView(labelText: "Order ID", valueText: order.id)
        let orderDate = LabelAndValueView(labelText: "Order Date", valueText: "\(order.date)")
        
        [deliveryAddress, orderStatus, orderId, orderDate].forEach { orderDetailsStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            orderDetailsContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            orderDetailsContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            orderDetailsContainerView.topAnchor.constraint(equalTo: navigateBackButton.bottomAnchor, constant: 20),
            
            orderDetailsStackView.topAnchor.constraint(equalTo: orderDetailsContainerView.topAnchor, constant: 10),
            orderDetailsStackView.bottomAnchor.constraint(equalTo: orderDetailsContainerView.bottomAnchor, constant: -10),
            orderDetailsStackView.leftAnchor.constraint(equalTo: orderDetailsContainerView.leftAnchor, constant: 10),
            orderDetailsStackView.rightAnchor.constraint(equalTo: orderDetailsContainerView.rightAnchor, constant: -10),
        ])
    }
    
    private func setupOrderProductsTableView() {
        view.addSubview(orderProductsTableView)
        
        NSLayoutConstraint.activate([
            orderProductsTableView.topAnchor.constraint(equalTo: orderDetailsContainerView.bottomAnchor, constant: 20),
            orderProductsTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            orderProductsTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            orderProductsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
        orderProductsTableView.dataSource = self
        orderProductsTableView.register(OrderHistoryDetailsTableViewCell.self, forCellReuseIdentifier: OrderHistoryDetailsTableViewCell.identifier)
        
    }
    
    private func setupOrderDescription() {
        view.addSubview(orderDescriptionStackView)
        
        guard let order else { return }
        let productCount = LabelAndValueView(labelText: "Product (\(order.products.count))", valueText: "\(order.totalPrice) ₾", isVertical: false)
        let paymentMethod = LabelAndValueView(labelText: "Method \(order.products.count)", valueText: order.payment, isVertical: false)
        let orderTotal = LabelAndValueView(labelText: "Order Total", valueText: "\(order.totalPrice)", isVertical: false)
        
        [productCount, paymentMethod, orderTotal].forEach { orderDescriptionStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            orderDescriptionStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            orderDescriptionStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            orderDescriptionStackView.topAnchor.constraint(equalTo: orderProductsTableView.bottomAnchor, constant: 20),
        ])
    }
    
}

extension OrderHistoryDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryDetailsTableViewCell.identifier) as? OrderHistoryDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        if let order = order {
            let currentProduct = order.products[indexPath.row]
            cell.configureCell(with: currentProduct)
        }
        return cell
    }
    
    
}
