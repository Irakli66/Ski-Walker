//
//  OrderHistoryDetailsTableViewCell.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 14.01.25.
//

import UIKit
import SwiftUI

final class OrderHistoryDetailsTableViewCell: UITableViewCell {
    static let identifier = "OrderHistoryDetailsTableViewCell"
    
    private let productImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var hostingController: UIHostingController<ReusableAsyncImageView>?
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let productDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var productStatus = LabelAndValueView(labelText: "Status:", valueText: "", isVertical: false)
    private lazy var productQuantity = LabelAndValueView(labelText: "Quantity:", valueText: "", isVertical: false)
    private lazy var productPrice = LabelAndValueView(labelText: "Price:", valueText: "", isVertical: false)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupProductImageView()
        setupProductDetails()
    }
    
    private func setupProductImageView() {
        contentView.addSubview(productImageContainer)
        
        NSLayoutConstraint.activate([
            productImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageContainer.widthAnchor.constraint(equalToConstant: 100),
            productImageContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupProductDetails() {
        contentView.addSubview(productDetailsStackView)
        
        [productNameLabel, productStatus, productQuantity, productPrice].forEach { productDetailsStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            productDetailsStackView.leadingAnchor.constraint(equalTo: productImageContainer.trailingAnchor, constant: 10),
            productDetailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productDetailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            productDetailsStackView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureCell(with product: CartItem) {
        productNameLabel.text = product.product.name
        productStatus.updateValue("In Progress")
        productQuantity.updateValue("\(product.count)")
        productPrice.updateValue("\(CurrencyFormatter.formatPriceToGEL(product.product.finalPrice))")
        setupSwiftUIImage(url: product.product.photos[0].url)
    }
    
    private func setupSwiftUIImage(url: String) {
        hostingController?.view.removeFromSuperview()
        hostingController = nil
        
        let swiftUIImage = ReusableAsyncImageView(url: url, width: 100, height: 100, cornerRadius: 10)
        let hostingController = UIHostingController(rootView: swiftUIImage)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        productImageContainer.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: productImageContainer.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: productImageContainer.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: productImageContainer.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: productImageContainer.trailingAnchor),
        ])
        
        self.hostingController = hostingController
    }
}
