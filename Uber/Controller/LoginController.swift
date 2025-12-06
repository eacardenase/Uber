//
//  LoginController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/5/25.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UBER"
        label.font = .preferredFont(forTextStyle: .largeTitle)

        return label
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension LoginController {

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

}
