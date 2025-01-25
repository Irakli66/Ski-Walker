//
//  OrderHistoryViewController.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 11.01.25.
//

import SwiftUI

final class OrderHistoryViewController: UIViewController {
    private let orderHistoryViewModel = OrderHistoryViewModel()
    var navigationHandler: (() -> Void)?
    
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
    
    private let orderHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupHeader()
        setupOrderHistoryTableView()
    }
    
    private func setupHeader() {
        view.addSubview(navigateBackButton)
        view.addSubview(pageTitleLabel)
        
        NSLayoutConstraint.activate([
            navigateBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            navigateBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            
            pageTitleLabel.centerYAnchor.constraint(equalTo: navigateBackButton.centerYAnchor),
            pageTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        navigateBackButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigationHandler?()
        }), for: .touchUpInside)
    }
    
    private func setupOrderHistoryTableView() {
        view.addSubview(orderHistoryTableView)
        
        NSLayoutConstraint.activate([
            orderHistoryTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            orderHistoryTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            orderHistoryTableView.topAnchor.constraint(equalTo: navigateBackButton.bottomAnchor, constant: 30),
            orderHistoryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        orderHistoryTableView.dataSource = self
        orderHistoryTableView.delegate = self
        orderHistoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrderCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Task {
            await orderHistoryViewModel.fetchOrders()
            orderHistoryTableView.reloadData()
        }
    }
}

extension OrderHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderHistoryViewModel.getOrderCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        
        let currentOrder = orderHistoryViewModel.getOrderAt(index: indexPath.row)
        
        cell.contentConfiguration = UIHostingConfiguration(content: {
            OrderHistoryCellView(order: currentOrder)
        })
        
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentOrder = orderHistoryViewModel.getOrderAt(index: indexPath.row)
        let vc = OrderHistoryDetailsViewController()
        vc.order = currentOrder
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


struct OrderHistoryView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let vc = OrderHistoryViewController()
        vc.navigationHandler = {
            dismiss()
        }
        return UINavigationController(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Empty for now
    }
}
