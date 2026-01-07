//
//  RidePaymentSelectionView.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/6/26.
//

import UIKit

class RidePaymentSelectionView: UIView {

    // MARK: - Properties

    private let dividerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator

        return view
    }()

    private let rideSelectionButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose Taxi", for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)

        return button
    }()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 150)
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

extension RidePaymentSelectionView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        addSubview(dividerView)
        addSubview(rideSelectionButton)

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])

        // rideSelectionButton
        NSLayoutConstraint.activate([
            rideSelectionButton.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            rideSelectionButton.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            rideSelectionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            rideSelectionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

}
