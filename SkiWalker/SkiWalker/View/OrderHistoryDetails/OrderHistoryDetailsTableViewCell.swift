//
//  OrderHistoryDetailsTableViewCell.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 14.01.25.
//

import UIKit

final class OrderHistoryDetailsTableViewCell: UITableViewCell {
    static let identifier = "OrderHistoryDetailsTableViewCell"
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        setupProductImageView()
        setupProductDetails()
    }
    
    private func setupProductImageView() {
        contentView.addSubview(productImageView)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupProductDetails() {
        contentView.addSubview(productDetailsStackView)
        
        [productNameLabel, productStatus, productQuantity, productPrice].forEach { productDetailsStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            productDetailsStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productDetailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productDetailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureCell(with product: CartProduct) {
        productImageView.image = UIImage(systemName: product.photos[0].url)
        productNameLabel.text = product.name
        productStatus.updateValue("In Progress")
        productQuantity.updateValue("1")
        productPrice.updateValue("\(product.finalPrice)")
    }
}
