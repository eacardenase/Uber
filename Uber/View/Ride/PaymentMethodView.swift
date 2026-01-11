//
//  PaymentMethodView.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/7/26.
//

import UIKit

class PaymentMethodView: UIView {

    // MARK: - Properties

    private let paymentMethodImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "creditcard")
        imageView.tintColor = .label
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(
            .required,
            for: .vertical
        )

        return imageView
    }()

    private let paymentMethodNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Edwin Cardenas ••••1234"
        label.font = .preferredFont(forTextStyle: .body)

        return label
    }()

    private let actionImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label

        return imageView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(changePaymentMethod)
        )

        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension PaymentMethodView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(paymentMethodImageView)
        addSubview(paymentMethodNameLabel)
        addSubview(actionImageView)

        // paymentMethodImageView
        NSLayoutConstraint.activate([
            paymentMethodImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8
            ),
            paymentMethodImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            paymentMethodImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
        ])

        // paymentMethodNameLabel
        NSLayoutConstraint.activate([
            paymentMethodNameLabel.centerYAnchor.constraint(
                equalTo: paymentMethodImageView.centerYAnchor
            ),
            paymentMethodNameLabel.leadingAnchor.constraint(
                equalTo: paymentMethodImageView.trailingAnchor,
                constant: 16
            ),
        ])

        // actionImageView
        NSLayoutConstraint.activate([
            actionImageView.centerYAnchor.constraint(
                equalTo: paymentMethodImageView.centerYAnchor
            ),
            actionImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

}

// MARK: - Actions

extension PaymentMethodView {

    @objc func changePaymentMethod(_ sender: UITapGestureRecognizer) {
        print(#function)
    }

}
