//
//  HomeController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import UIKit

class HomeController: UIViewController {

    // MARK: - Properties

    private let inputActivationView = LocationInputActivationView()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension HomeController {

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(inputActivationView)

        // locationInputView
        NSLayoutConstraint.activate([
            inputActivationView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            inputActivationView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            inputActivationView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])
    }

}
