//
//  CartTableViewCell.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 19.01.25.
//

import UIKit

protocol FavoritesTableViewCellDelegate: AnyObject {
    func addToCartButtonTapped(cell: FavoriteTableViewCell)
    func didTapFavorite(cell: FavoriteTableViewCell)
}

class FavoriteTableViewCell: UITableViewCell {
    weak var delegate: FavoritesTableViewCellDelegate?
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.imageFrom(url: URL(string: "https://api.gargar.dev:8088/Products/b4250b33-9f40-403c-995d-20136c333121/1.png")!)
        return imageView
    }()
    
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
        label.text = "Test Product"
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.text = "130"
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        setupProductImageView()
        setupProductDetailsStackView()
        setupProductNameAndPriceStackView()
        setupActionButtonsStackView()
    }
    
    private func setupProductImageView() {
        contentView.addSubview(productImageView)
        
        NSLayoutConstraint.activate([
            productImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 100),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
        ])
    }
    
    private func setupProductDetailsStackView() {
        contentView.addSubview(productDetailsStackView)
        
        NSLayoutConstraint.activate([
            productDetailsStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20),
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
        
        favoritesButton.addAction(UIAction(handler: {[weak self] _ in
            self?.favoriteButtonTapped()
        }), for: .touchUpInside)
        addToCartButton.addAction(UIAction(handler: {[weak self] _ in
            self?.addToCartButtonTapped()
        }), for: .touchUpInside)
    }

    
    private func addToCartButtonTapped() {
        delegate?.addToCartButtonTapped(cell: self)
    }
    
    private func favoriteButtonTapped() {
        delegate?.didTapFavorite(cell: self)
    }
    
    func configureCell(with cartItem: CartItem) {
        productImageView.imageFrom(url:  URL(string: "cartItem.product.photos[0].url")!)
        productNameLabel.text = cartItem.product.name
        productPriceLabel.text = "\(cartItem.product.finalPrice)"
    }
}
