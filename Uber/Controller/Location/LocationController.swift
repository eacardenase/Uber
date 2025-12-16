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

    private let locationSelectionLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a location"
        label.font = .preferredFont(forTextStyle: .body)

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .body
        ).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0)
        }

        return label
    }()

    private lazy var tableView: UITableView = {
        let _tableView = UITableView()

        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.tableHeaderView = LocationTableViewHeader()
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self)
        )

        return _tableView
    }()

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
        view.addSubview(locationSelectionLabel)
        view.addSubview(tableView)

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

        // locationSelectionLabel
        NSLayoutConstraint.activate([
            locationSelectionLabel.topAnchor.constraint(
                equalTo: locationInputView.bottomAnchor,
                constant: 16
            ),
            locationSelectionLabel.leadingAnchor.constraint(
                equalTo: locationInputView.leadingAnchor
            ),
        ])

        // tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: locationSelectionLabel.bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
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

// MARK: - UITableViewDataSource

extension LocationController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(UITableViewCell.self),
            for: indexPath
        )

        return cell
    }

}

// MARK: - UITableViewDelegate

extension LocationController: UITableViewDelegate {

}
