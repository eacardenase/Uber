//
//  LocationInputActivation.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import UIKit

class LocationInputActivationView: UIView {

    // MARK: - Properties

    private let imageView: UIImageView = {
        let image = UIImage(
            systemName: "magnifyingglass",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )

        let _imageView = UIImageView(
            image: image
        )

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.tintColor = .label
        _imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return _imageView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Get a ride now"
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title2)

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .title3
        ).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0)
        }

        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        let cornerRadius: CGFloat = frame.height / 2

        layer.cornerRadius = cornerRadius

        addShadow(withCornerRadius: cornerRadius)
    }

}

// MARK: - Helpers

extension LocationInputActivationView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground

        addSubview(imageView)
        addSubview(placeholderLabel)

        // indicatorView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            imageView.centerYAnchor.constraint(
                equalTo: placeholderLabel.centerYAnchor
            ),
        ])

        // placeholderLabel
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: 8
            ),
            placeholderLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            placeholderLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
        ])
    }

    private func addShadow(withCornerRadius cornerRadius: CGFloat) {
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.22
        layer.shadowPath =
            UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }

}
