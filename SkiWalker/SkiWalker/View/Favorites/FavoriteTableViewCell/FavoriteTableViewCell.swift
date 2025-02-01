//
//  CartTableViewCell.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 19.01.25.
//

import UIKit
import SwiftUI

protocol FavoritesTableViewCellDelegate: AnyObject {
    func addToCartButtonTapped(cell: FavoriteTableViewCell)
    func deleteButtonTapped(cell: FavoriteTableViewCell)
}

final class FavoriteTableViewCell: UITableViewCell {
    weak var delegate: FavoritesTableViewCellDelegate?
    
    private let productImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var hostingController: UIHostingController<ReusableAsyncImageView>?
    
    private let productDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let productNameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let actionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let favoritesAndAddButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "Add"
        config.image = UIImage(named: "cart")
        config.imagePadding = 8
        config.baseForegroundColor = .customWhite
        config.baseBackgroundColor = .customPurple
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        button.configuration = config
        return button
    }()
    
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
        setupProductDetailsStackView()
        setupProductNameAndPriceStackView()
        setupActionButtonsStackView()
    }
    
    private func setupProductImageView() {
        contentView.addSubview(productImageContainer)
        
        NSLayoutConstraint.activate([
            productImageContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            productImageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageContainer.heightAnchor.constraint(equalToConstant: 100),
            productImageContainer.widthAnchor.constraint(equalTo: productImageContainer.heightAnchor),
        ])
    }
    
    private func setupProductDetailsStackView() {
        contentView.addSubview(productDetailsStackView)
        
        NSLayoutConstraint.activate([
            productDetailsStackView.leadingAnchor.constraint(equalTo: productImageContainer.trailingAnchor, constant: 20),
            productDetailsStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            productDetailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productDetailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupProductNameAndPriceStackView() {
        productDetailsStackView.addArrangedSubview(productNameAndPriceStackView)
        productNameAndPriceStackView.addArrangedSubview(productNameLabel)
        productNameAndPriceStackView.addArrangedSubview(productPriceLabel)
    }
    
    private func setupActionButtonsStackView() {
        productDetailsStackView.addArrangedSubview(actionButtonsStackView)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        actionButtonsStackView.addArrangedSubview(spacer)
        actionButtonsStackView.addArrangedSubview(favoritesAndAddButtonsStackView)
        
        favoritesAndAddButtonsStackView.addArrangedSubview(favoritesButton)
        favoritesAndAddButtonsStackView.addArrangedSubview(addToCartButton)
        
        favoritesButton.addAction(UIAction(handler: { [weak self] _ in
            self?.deleteButtonTapped()
        }), for: .touchUpInside)
        
        addToCartButton.addAction(UIAction(handler: { [weak self] _ in
            self?.addToCartButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func addToCartButtonTapped() {
        delegate?.addToCartButtonTapped(cell: self)
    }
    
    private func deleteButtonTapped() {
        delegate?.deleteButtonTapped(cell: self)
    }
    
    func configureCell(with product: Product) {
        productNameLabel.text = product.name
        productPriceLabel.text = CurrencyFormatter.formatPriceToGEL(product.finalPrice)
        setupSwiftUIImage(url: product.photos[0].url)
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
