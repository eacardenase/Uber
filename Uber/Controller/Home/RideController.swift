//
//  RideController.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/6/26.
//

import UIKit

class RideController: UIViewController {

    // MARK: - Properties

    private let dividerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator

        return view
    }()

    let ridePaymentView = RidePaymentSelectionView()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Choose a ride"

        setupViews()
    }

}

// MARK: - Helpers

extension RideController {

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(dividerView)
        view.addSubview(ridePaymentView)

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
        ])

        // ridePaymentView
        NSLayoutConstraint.activate([
            ridePaymentView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            ridePaymentView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            ridePaymentView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
        ])
    }

}
