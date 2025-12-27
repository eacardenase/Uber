//
//  LoginController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/5/25.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Properties

    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UBER"
        label.font = .preferredFont(forTextStyle: .largeTitle)

        return label
    }()

    private let emailTextField = DecoratedTextField(
        imageResource: .icMailOutlineWhite2X,
        placeholder: "Email"
    )
    private let passwordTextField = DecoratedTextField(
        imageResource: .icLockOutlineWhite2X,
        placeholder: "Password",
        isSecure: true
    )

    private lazy var loginButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Log In", for: .normal)
        button.addTarget(
            self,
            action: #selector(loginButtonTapped),
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

    private lazy var showRegistrationButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false

        let attributedText = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 16),
            ]
        )

        attributedText.append(
            NSAttributedString(
                string: "Sign Up",
                attributes: [
                    .foregroundColor: UIColor.systemBlue,
                    .font: UIFont.boldSystemFont(ofSize: 16),
                ]
            )
        )

        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(
            self,
            action: #selector(showRegistrationButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

}

// MARK: - Helpers

extension LoginController {

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField, passwordTextField, loginButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(showRegistrationButton)

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
            showRegistrationButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            showRegistrationButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }

}

// MARK: - Actions

extension LoginController {

    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let email = viewModel.email,
            let password = viewModel.password
        else { return }

        AuthService.logUserIn(withEmail: email, password: password) {
            [weak self] error in

            guard let self else { return }

            if let error {
                let alertController = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alertController.addAction(
                    UIAlertAction(title: "OK", style: .default)
                )

                self.present(alertController, animated: true)

                return
            }

            self.delegate?.authenticationComplete()
        }
    }

    @objc func showRegistrationButtonTapped(_ sender: UIButton) {
        let controller = RegistrationController()
        controller.delegate = delegate

        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - PasswordTextFieldDelegate

extension LoginController: DecoratedTextFieldDelegate {

    func editingChanged(_ sender: DecoratedTextField) {
        if sender === emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }

        updateForm()
    }

}

// MARK: - AuthenticationControllerProtocol

extension LoginController: AuthenticationProtocol {

    func updateForm() {
        loginButton.isEnabled = viewModel.shouldEnableButton
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }

}
