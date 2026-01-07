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
        backgroundColor = .systemPink
    }

}
