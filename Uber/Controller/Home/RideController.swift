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

    private lazy var tableView: UITableView = {
        let _tableView = UITableView()

        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.rowHeight = 80
        _tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self)
        )

        return _tableView
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
        view.addSubview(tableView)
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

        // tableView

        let tableViewBottomAnchor = tableView.bottomAnchor.constraint(
            equalTo: ridePaymentView.topAnchor,
            constant: -16
        )

        tableViewBottomAnchor.priority = UILayoutPriority(900)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor,
                constant: 16
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            tableViewBottomAnchor,
        ])

        // ridePaymentView
        NSLayoutConstraint.activate([
            ridePaymentView.leadingAnchor.constraint(
                equalTo: tableView.leadingAnchor
            ),
            ridePaymentView.trailingAnchor.constraint(
                equalTo: tableView.trailingAnchor
            ),
            ridePaymentView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
        ])
    }

}

// MARK: - UITableViewDataSource

extension RideController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return 5
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

extension RideController: UITableViewDelegate {

}
