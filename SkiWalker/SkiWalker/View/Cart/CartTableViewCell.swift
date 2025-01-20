//
//  CartTableViewCell.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 19.01.25.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didChangeStepperValue(cell: CartTableViewCell, adjustedStepValue: Int)
    func didTapDelete(cell: CartTableViewCell)
    func didTapFavorite(cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    weak var delegate: CartTableViewCellDelegate?
    private var lastStepperValue: Double = 1
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
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
        return stackView
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "1"
        return label
    }()
    
    private let quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = 1
        return stepper
    }()
    
    private let favoritesAndDeleteButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .trailing
        return stackView
    }()
    
    private let favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "favorites"), for: .normal)
        button.tintColor = .customGrey
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
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
        
        actionButtonsStackView.addArrangedSubview(quantityStepper)
        actionButtonsStackView.addArrangedSubview(quantityLabel)
        actionButtonsStackView.addArrangedSubview(favoritesAndDeleteButtonsStackView)
        
        favoritesAndDeleteButtonsStackView.addArrangedSubview(favoritesButton)
        favoritesAndDeleteButtonsStackView.addArrangedSubview(deleteButton)
        
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        favoritesButton.addAction(UIAction(handler: {[weak self] _ in
            self?.favoriteButtonTapped()
        }), for: .touchUpInside)
        deleteButton.addAction(UIAction(handler: {[weak self] _ in
            self?.deleteButtonTapped()
        }), for: .touchUpInside)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let stepValue = sender.value - lastStepperValue
        lastStepperValue = sender.value
        
        let adjustedStepValue = stepValue > 0 ? 1 : -1
        quantityLabel.text = "\(Int(sender.value))"
        
        delegate?.didChangeStepperValue(cell: self, adjustedStepValue: adjustedStepValue)
    }
    
    private func deleteButtonTapped() {
        delegate?.didTapDelete(cell: self)
    }
    
    private func favoriteButtonTapped() {
        delegate?.didTapFavorite(cell: self)
    }
    
    func configureCell(with cartItem: CartItem) {
        productImageView.imageFrom(url:  URL(string: cartItem.product.photos[0].url)!)
        productNameLabel.text = cartItem.product.name
        productPriceLabel.text = "\(cartItem.product.finalPrice)"
        quantityStepper.value = Double(cartItem.count)
        lastStepperValue = Double(cartItem.count)
        quantityLabel.text = "\(cartItem.count)"
    }
}
