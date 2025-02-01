//
//  CartTableViewCell.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 19.01.25.
//

import UIKit
import SwiftUI

protocol CartTableViewCellDelegate: AnyObject {
    func didChangeStepperValue(cell: CartTableViewCell, adjustedStepValue: Int)
    func didTapDelete(cell: CartTableViewCell)
    func didTapFavorite(cell: CartTableViewCell)
}

final class CartTableViewCell: UITableViewCell {
    weak var delegate: CartTableViewCellDelegate?
    private var lastStepperValue: Double = 1
    
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
        stackView.alignment = .center
        return stackView
    }()
    
    private let favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        productNameLabel.text = cartItem.product.name
        productPriceLabel.text = CurrencyFormatter.formatPriceToGEL(cartItem.product.finalPrice)
        quantityStepper.value = Double(cartItem.count)
        lastStepperValue = Double(cartItem.count)
        quantityLabel.text = "\(cartItem.count)"
        quantityStepper.maximumValue = Double(cartItem.product.stock)
        favoritesButton.setImage(UIImage(systemName: cartItem.product.favorite ? "heart.fill" : "heart"), for: .normal)
        setupSwiftUIImage(url: cartItem.product.photos[0].url)
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
