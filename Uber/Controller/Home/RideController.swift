//
//  RideController.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/6/26.
//

import UIKit

class RideController: UIViewController {

    // MARK: - Properties

    private var rideTypes = [
        RideSelectionOptionCellViewModel(
            rideTypeText: "Taxi 1",
            rideDistanceText: "5 min away",
            auxiliaryText: "In partnership with TaxExpress",
            rideAmountText: "COP 10,459-12,494",
            isSelected: true
        ),
        RideSelectionOptionCellViewModel(
            rideTypeText: "Taxi 2",
            rideDistanceText: "15 min away",
            auxiliaryText: "In partnership with TaxExpress",
            rideAmountText: "COP 10,459-12,494",
            isSelected: false
        ),
        RideSelectionOptionCellViewModel(
            rideTypeText: "Taxi 3",
            rideDistanceText: "10 min away",
            auxiliaryText: "In partnership with TaxExpress",
            rideAmountText: "COP 10,459-12,494",
            isSelected: false
        ),
        RideSelectionOptionCellViewModel(
            rideTypeText: "Taxi 4",
            rideDistanceText: "25 min away",
            auxiliaryText: "In partnership with TaxExpress",
            rideAmountText: "COP 10,459-12,494",
            isSelected: false
        ),
    ]

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose a ride"
        label.font = .preferredFont(forTextStyle: .headline)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return label
    }()

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
        _tableView.separatorStyle = .none
        _tableView.register(
            RideSelectionOptionCell.self,
            forCellReuseIdentifier: NSStringFromClass(
                RideSelectionOptionCell.self
            )
        )

        return _tableView
    }()

    private var selectedIndex = IndexPath(row: 0, section: 0) {
        didSet { tableView.reloadData() }
    }
    private let ridePaymentView = RidePaymentSelectionView()

    var minHeight: CGFloat {
        let indexPath = IndexPath(row: 0, section: 0)
        let rect = tableView.rectForRow(at: indexPath)

        return tableView.frame.origin.y
            + rect.height + 32
            + ridePaymentView.frame.height
    }

    // MARK: - View Lifecycle

    override func loadView() {
        view = UIView()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.selectRow(
            at: selectedIndex,
            animated: true,
            scrollPosition: .top
        )
    }

}

// MARK: - Helpers

extension RideController {

    private func setupViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(dividerView)
        view.addSubview(tableView)
        view.addSubview(ridePaymentView)

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 16
            ),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
        ])

        // tableView

        let tableViewLeadingAnchor = tableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 8
        )
        let tableViewTrailingAnchor = tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -8
        )
        let tableViewBottomAnchor = tableView.bottomAnchor.constraint(
            equalTo: ridePaymentView.topAnchor,
            constant: -16
        )

        tableViewLeadingAnchor.priority = UILayoutPriority(900)
        tableViewTrailingAnchor.priority = UILayoutPriority(900)
        tableViewBottomAnchor.priority = UILayoutPriority(900)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor,
                constant: 16
            ),
            tableViewLeadingAnchor,
            tableViewTrailingAnchor,
            tableViewBottomAnchor,
        ])

        // ridePaymentView
        NSLayoutConstraint.activate([
            ridePaymentView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            ridePaymentView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
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
        return rideTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(RideSelectionOptionCell.self),
                for: indexPath
            ) as? RideSelectionOptionCell
        else {
            fatalError("Failed to instantiate RideSelectionOptionCell")
        }

        cell.viewModel = rideTypes[indexPath.row]

        return cell
    }

}

// MARK: - UITableViewDelegate

extension RideController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        for (index, cell) in tableView.visibleCells.enumerated() {
            guard
                let cell = cell
                    as? RideSelectionOptionCell
            else { return }

            if index == indexPath.row {
                cell.addSelectedBorder()
            } else {
                cell.removeSelectedBorder()
            }
        }
    }

}
