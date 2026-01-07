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

        // Option + 8: ••••

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

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension PaymentMethodView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        addSubview(paymentMethodImageView)

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
    }

}
