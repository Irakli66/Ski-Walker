//
//  LabelAndValueView.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 14.01.25.
//
import UIKit

final class LabelAndValueView: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(labelText: String, valueText: String, isVertical: Bool = true) {
        super.init(frame: .zero)
        setupView(labelText: labelText, valueText: valueText, isVertical: isVertical)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(labelText: String, valueText: String, isVertical: Bool) {
        axis = isVertical ? .vertical : .horizontal
        if isVertical {
            spacing = 5
        } else {
            distribution = .equalSpacing
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = labelText
        valueLabel.text = valueText
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(valueLabel)
    }
    
    func updateValue(_ newValue: String) {
        valueLabel.text = newValue
    }
}
