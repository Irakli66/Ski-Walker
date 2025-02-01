//
//  OrderHistoryDetailsViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 13.01.25.
//

import UIKit

final class OrderHistoryDetailsViewController: UIViewController {
    var order: OrderResponse?
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        setupHeaderView()
        setupScrollView()
        setupUI()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.addSubview(navigateBackButton)
        headerView.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            navigateBackButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
            navigateBackButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            pageTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            pageTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
        ])
        
        navigateBackButton.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
    
    private func setupUI() {
        setupOrderDetails()
        setupOrderProductsTableView()
        setupOrderDescription()
    }
    
    private func setupOrderDetails() {
        guard let order else { return }
        
        contentView.addSubview(orderDetailsContainerView)
        orderDetailsContainerView.addSubview(orderDetailsStackView)
        
        let deliveryAddress = LabelAndValueView(labelText: "Delivery Address", valueText: order.shippingAddress.street)
        let orderStatus = LabelAndValueView(labelText: "Status", valueText: "\(order.status.displayName)")
        let orderId = LabelAndValueView(labelText: "Order ID", valueText: String(order.id.prefix(6)))
        let orderDate = LabelAndValueView(labelText: "Order Date", valueText: "\(DateFormatterHelper.formatDate(order.lastUpdatedAt))")
        
        [deliveryAddress, orderStatus, orderId, orderDate].forEach {
            orderDetailsStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            orderDetailsContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            orderDetailsContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            orderDetailsContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            orderDetailsStackView.topAnchor.constraint(equalTo: orderDetailsContainerView.topAnchor, constant: 10),
            orderDetailsStackView.bottomAnchor.constraint(equalTo: orderDetailsContainerView.bottomAnchor, constant: -10),
            orderDetailsStackView.leftAnchor.constraint(equalTo: orderDetailsContainerView.leftAnchor, constant: 10),
            orderDetailsStackView.rightAnchor.constraint(equalTo: orderDetailsContainerView.rightAnchor, constant: -10),
        ])
    }
    
    private func setupOrderProductsTableView() {
        contentView.addSubview(orderProductsTableView)
        
        let productCount = order?.products.count ?? 0
        let rowHeight: CGFloat = 120
        let tableViewHeight = min(CGFloat(productCount) * rowHeight, 350)
        
        NSLayoutConstraint.activate([
            orderProductsTableView.topAnchor.constraint(equalTo: orderDetailsContainerView.bottomAnchor, constant: 20),
            orderProductsTableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            orderProductsTableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            orderProductsTableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        ])
        
        orderProductsTableView.showsVerticalScrollIndicator = false
        orderProductsTableView.dataSource = self
        orderProductsTableView.register(
            OrderHistoryDetailsTableViewCell.self,
            forCellReuseIdentifier: OrderHistoryDetailsTableViewCell.identifier
        )
    }
    
    private func setupOrderDescription() {
        contentView.addSubview(orderDescriptionStackView)
        
        guard let order else { return }
        let productCount = LabelAndValueView(labelText: "Product (\(order.products.count))", valueText: "\(CurrencyFormatter.formatPriceToGEL(order.totalPrice))", isVertical: false)
        
        let paymentMethod = LabelAndValueView(labelText: "Method", valueText: "Card", isVertical: false)
        
        let orderTotal = LabelAndValueView(labelText: "Order Total", valueText: "\(CurrencyFormatter.formatPriceToGEL(order.totalPrice))", isVertical: false)
        
        [productCount, paymentMethod, orderTotal].forEach {
            orderDescriptionStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            orderDescriptionStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            orderDescriptionStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            orderDescriptionStackView.topAnchor.constraint(equalTo: orderProductsTableView.bottomAnchor, constant: 20),
            orderDescriptionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

extension OrderHistoryDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OrderHistoryDetailsTableViewCell.identifier
            ) as? OrderHistoryDetailsTableViewCell
        else {
            return UITableViewCell()
        }
        
        if let order = order {
            let currentProduct = order.products[indexPath.row]
            cell.configureCell(with: currentProduct)
        }
        return cell
    }
}
