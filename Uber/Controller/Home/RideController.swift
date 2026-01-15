//
//  RideController.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/6/26.
//

import UIKit

class RideController: UIViewController {

    // MARK: - Properties

    private var availableRides = [RideSelectionOptionCellViewModel]()

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
        _tableView.showsVerticalScrollIndicator = false
        _tableView.bouncesVertically = false
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

    var isScrollEnable = true {
        didSet { tableView.isScrollEnabled = isScrollEnable }
    }

    var minHeight: CGFloat {
        let indexPath = selectedIndex
        let rect = tableView.rectForRow(at: indexPath)
        let tableViewPadding: CGFloat = 32

        return tableView.frame.origin.y
            + rect.height + tableViewPadding
            + ridePaymentView.frame.height
    }

    // MARK: - View Lifecycle

    override func loadView() {
        view = UIView()

        ridePaymentView.delegate = self

        setupViews()
    }

    override func viewDidLoad() {
        fetchRides()
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

    func scrollTableViewToSelectedIndex(animated: Bool) {
        let rect = tableView.rectForRow(at: selectedIndex)

        tableView.scrollRectToVisible(rect, animated: animated)
    }

}

// MARK: - UITableViewDataSource

extension RideController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return availableRides.count
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

        cell.viewModel = availableRides[indexPath.row]

        return cell
    }

}

// MARK: - UITableViewDelegate

extension RideController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let newSelectedRide = availableRides[indexPath.row]
        let viewModel = RidePaymentSelectionViewModel(
            ride: newSelectedRide.ride
        )

        ridePaymentView.viewModel = viewModel

        availableRides = availableRides.map { ride in
            ride.isSelected = false

            if ride == newSelectedRide {
                ride.isSelected = true
            }

            return ride
        }

        selectedIndex = indexPath

        scrollTableViewToSelectedIndex(animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.visibleCells.count == 2 {
            scrollTableViewToSelectedIndex(animated: false)
        }

    }

}

// MARK: - RidePaymentSelectionViewDelegate

extension RideController: RidePaymentSelectionViewDelegate {

    func storeTrip() {
        print(#function)
    }

}

// MARK: - API

extension RideController {

    private func fetchRides() {
        RideService.fetchAvailableRides { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let rides):
                self.availableRides = rides.map {
                    RideSelectionOptionCellViewModel(ride: $0)
                }

                if let firstAvailableRideViewModel = self.availableRides.first {
                    firstAvailableRideViewModel.isSelected = true

                    let viewModel = RidePaymentSelectionViewModel(
                        ride: firstAvailableRideViewModel.ride
                    )

                    ridePaymentView.viewModel = viewModel
                }

                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}
