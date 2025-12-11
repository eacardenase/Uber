//
//  RegistrationController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/10/25.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UBER"
        label.font = .preferredFont(forTextStyle: .largeTitle)

        return label
    }()

    private let usernameTextField = DecoratedTextFieldContainerView(
        imageResource: .icPersonOutlineWhite2X,
        placeholder: "Full Name"
    )
    private let emailTextField = DecoratedTextFieldContainerView(
        imageResource: .icMailOutlineWhite2X,
        placeholder: "Email"
    )
    private let passwordTextField = DecoratedTextFieldContainerView(
        imageResource: .icLockOutlineWhite2X,
        placeholder: "Password",
        isSecure: true
    )
    private let accountTypeSegmentedView = SegmentedControlView()

    private lazy var signUpButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Sign Up", for: .normal)

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .body
        ).withSymbolicTraits(.traitBold) {
            button.titleLabel?.font = UIFont(
                descriptor: fontDescriptor,
                size: 0
            )
        }

        return button
    }()

    private lazy var showLoginButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false

        let attributedText = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 16),
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: "Sign In",
                attributes: [
                    .foregroundColor: UIColor.systemBlue,
                    .font: UIFont.boldSystemFont(ofSize: 16),
                ]
            )
        )

        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(
            self,
            action: #selector(showLoginButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

// MARK: - Helpers

extension RegistrationController {

    private func setupViews() {
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            usernameTextField,
            emailTextField,
            passwordTextField,
            accountTypeSegmentedView,
            signUpButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(showLoginButton)

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

        // showRegistrationButton
        NSLayoutConstraint.activate([
            showLoginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            showLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }

}

// MARK: - Actions

extension RegistrationController {

    @objc func showLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
