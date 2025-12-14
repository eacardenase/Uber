//
//  LocationInputView.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import UIKit

class LocationInputView: UIView {

    // MARK: - Properties

    private let pickupInput = LocationInputTextField(
        title: "Pickup",
        placeholder: "Pickup Location"
    )
    private let destinationInput = LocationInputTextField(
        title: "Destination",
        placeholder: "Where to?"
    )
    private let dividerView: UIView = {
        let view = UIView()

        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true

        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 120)
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 16
    }

}

// MARK: - Helpers

extension LocationInputView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            pickupInput, dividerView, destinationInput,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6

        addSubview(stackView)

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 40
            ),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
        ])
    }

}
