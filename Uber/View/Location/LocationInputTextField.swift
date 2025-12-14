//
//  LocationInputTextField.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import UIKit

class LocationInputTextField: UIView {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .body
        ).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0)
        }

        return label
    }()

    private lazy var inputTextField: UITextField = {
        let textField = UITextField()

        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    // MARK: - Initializers

    init(title: String, placeholder: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.preferredFont(forTextStyle: .caption1),
            ]
        )

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

extension LocationInputTextField {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        addSubview(titleLabel)
        addSubview(inputTextField)

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        // inputTextField
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 4
            ),
            inputTextField.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            inputTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8
            ),
            inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
