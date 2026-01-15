//
//  RidePaymentSelectionView.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/6/26.
//

import UIKit

protocol RidePaymentSelectionViewDelegate: AnyObject {

    func storeTrip()

}

class RidePaymentSelectionView: UIView {

    // MARK: - Properties

    weak var delegate: RidePaymentSelectionViewDelegate?

    var viewModel: RidePaymentSelectionViewModel? {
        didSet { configure() }
    }

    private let dividerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator

        return view
    }()

    private let paymentMethodView = PaymentMethodView()

    private lazy var rideSelectionButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose Taxi", for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .label
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.addTarget(
            self,
            action: #selector(rideSelectionButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

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
        addSubview(paymentMethodView)
        addSubview(rideSelectionButton)

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])

        NSLayoutConstraint.activate([
            paymentMethodView.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor,
                constant: 16
            ),
            paymentMethodView.leadingAnchor.constraint(
                equalTo: rideSelectionButton.leadingAnchor
            ),
            paymentMethodView.trailingAnchor.constraint(
                equalTo: rideSelectionButton.trailingAnchor
            ),
        ])

        // rideSelectionButton

        let selectionButtonLeadingAnchor = rideSelectionButton.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
        let selectionButtonTrailingAnchor = rideSelectionButton.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -16)

        selectionButtonLeadingAnchor.priority = UILayoutPriority(900)
        selectionButtonTrailingAnchor.priority = UILayoutPriority(900)

        NSLayoutConstraint.activate([
            rideSelectionButton.topAnchor.constraint(
                equalTo: paymentMethodView.bottomAnchor,
                constant: 16
            ),
            selectionButtonLeadingAnchor,
            selectionButtonTrailingAnchor,
            rideSelectionButton.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
            rideSelectionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func configure() {
        guard let viewModel else { return }

        rideSelectionButton.setTitle(viewModel.rideName, for: .normal)
    }

}

// MARK: - Actions

extension RidePaymentSelectionView {

    @objc func rideSelectionButtonTapped(_ sender: UIButton) {
        delegate?.storeTrip()
    }

}
