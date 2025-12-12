//
//  RegistrationController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/10/25.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    private var viewModel = RegistrationViewModel()
    weak var delegate: AuthenticationDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UBER"
        label.font = .preferredFont(forTextStyle: .largeTitle)

        return label
    }()

    private let usernameTextField: DecoratedTextField = {
        let textField = DecoratedTextField(
            imageResource: .icPersonOutlineWhite2X,
            placeholder: "Full Name"
        )

        textField.autocapitalizationType = .words

        return textField
    }()

    private let emailTextField: DecoratedTextField = {
        let textField = DecoratedTextField(
            imageResource: .icMailOutlineWhite2X,
            placeholder: "Email"
        )

        textField.keyboardType = .emailAddress

        return textField
    }()

    private let passwordTextField = DecoratedTextField(
        imageResource: .icLockOutlineWhite2X,
        placeholder: "Password",
        isSecure: true
    )
    private let accountTypeSegmentedView = SegmentedControlView()

    private lazy var signUpButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Sign Up", for: .normal)
        button.addTarget(
            self,
            action: #selector(signUpButtonTapped),
            for: .touchUpInside
        )

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

        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
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

    @objc func signUpButtonTapped(_ sender: UIButton) {
        guard let fullname = viewModel.fullname,
            let email = viewModel.email,
            let password = viewModel.password
        else { return }

        let credentials = AuthCredentials(
            fullname: fullname,
            email: email,
            password: password
        )

        AuthService.createUser(with: credentials) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.delegate?.authenticationComplete()
            case .failure(let error):
                if case .serverError(let message) = error {
                    let alertController = UIAlertController(
                        title: "Error",
                        message: message,
                        preferredStyle: .alert
                    )

                    alertController.addAction(
                        UIAlertAction(title: "OK", style: .default)
                    )

                    self.present(alertController, animated: true)
                }
            }
        }
    }

    @objc func showLoginButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - PasswordTextFieldDelegate

extension RegistrationController: DecoratedTextFieldDelegate {

    func editingChanged(_ sender: DecoratedTextField) {
        if sender === usernameTextField {
            viewModel.fullname = sender.text
        } else if sender === emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }

        updateForm()
    }

}

// MARK: - AuthenticationProtocol

extension RegistrationController: AuthenticationProtocol {

    func updateForm() {
        signUpButton.isEnabled = viewModel.shouldEnableButton
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }

}
