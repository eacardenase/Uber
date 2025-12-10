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

    private let emailTextField = DecoratedTextFieldContainerView(
        imageResource: .icMailOutlineWhite2X,
        placeholder: "Email"
    )
    private let passwordTextField = DecoratedTextFieldContainerView(
        imageResource: .icLockOutlineWhite2X,
        placeholder: "Password",
        isSecure: true
    )

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

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField, passwordTextField,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(titleLabel)
        view.addSubview(stackView)

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 32
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
        ])
    }

}
