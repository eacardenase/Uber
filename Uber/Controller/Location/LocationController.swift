//
//  LocationController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import UIKit

class LocationController: UIViewController {

    // MARK: - Properties

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .label
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Plan your ride"
        label.font = .preferredFont(forTextStyle: .title3)

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .title3
        ).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0)
        }

        return label
    }()

    private let locationInputView = LocationInputView()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

    }

}

// MARK: - Helpers

extension LocationController {

    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(locationInputView)

        // backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            backButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
        ])

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // locationInputView
        NSLayoutConstraint.activate([
            locationInputView.topAnchor.constraint(
                equalTo: backButton.bottomAnchor,
                constant: 24
            ),
            locationInputView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            locationInputView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])
    }

}

// MARK: - Actions

extension LocationController {

    @objc func backButtonTapped(_ sender: UIButton) {
        print(#function)
    }

}
