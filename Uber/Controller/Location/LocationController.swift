//
//  LocationController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import MapKit
import UIKit

class LocationController: UIViewController {

    // MARK: - Properties

    var region: MKCoordinateRegion?

    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()

        completer.delegate = self

        return completer
    }()

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

    private let headerView = LocationTableViewHeader()

    private lazy var tableView: UITableView = {
        let _tableView = UITableView()

        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.tableHeaderView = headerView
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(
            LocationSearchResultCell.self,
            forCellReuseIdentifier: NSStringFromClass(
                LocationSearchResultCell.self
            )
        )
        _tableView.register(
            LocationAuxiliaryCell.self,
            forCellReuseIdentifier: NSStringFromClass(
                LocationAuxiliaryCell.self
            )
        )

        return _tableView
    }()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationInputView.delegate = self

        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = tableView.bounds.width
        let headerSize = headerView.systemLayoutSizeFitting(
            CGSize(
                width: width,
                height: UIView.layoutFittingCompressedSize.height
            )
        )

        if headerView.frame.height != headerSize.height {
            headerView.frame = CGRect(
                x: 0,
                y: 0,
                width: headerSize.width,
                height: headerSize.height
            )
            tableView.tableHeaderView = headerView
        }
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
                constant: 32
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
                equalTo: locationSelectionLabel.bottomAnchor,
                constant: 8
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return LocationSections.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        guard let section = LocationSections(rawValue: section) else {
            fatalError("Could not create LocationSections from raw value.")
        }

        switch section {
        case .searchResults: return 3
        case .changeSearchLocation: return 1
        case .noResults: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard let section = LocationSections(rawValue: indexPath.section) else {
            fatalError("Could not create LocationSections from raw value.")
        }

        let cell: UITableViewCell

        switch section {
        case .searchResults:
            cell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(
                    LocationSearchResultCell.self
                ),
                for: indexPath
            )

            return cell
        default:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: NSStringFromClass(
                        LocationAuxiliaryCell.self
                    ),
                    for: indexPath
                ) as? LocationAuxiliaryCell
            else {
                fatalError("Failed to initialize LocationAuxiliaryCell.")
            }

            let viewModel: LocationAuxiliaryCellViewModel

            if case .changeSearchLocation = section {
                viewModel = LocationAuxiliaryCellViewModel(
                    imageName: "globe",
                    titleText: "Search in a different city"
                )
            } else {
                viewModel = LocationAuxiliaryCellViewModel(
                    imageName: "magnifyingglass",
                    titleText: "Get more results for..."
                )
            }

            cell.viewModel = viewModel

            return cell
        }
    }

}

// MARK: - UITableViewDelegate

extension LocationController: UITableViewDelegate {

}

// MARK: - LocationInputViewDelegate

extension LocationController: LocationInputViewDelegate {

    func executeSearch(for query: String) {
        searchCompleter.queryFragment = query
    }

}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        for result in completer.results {
            print(result)
        }
    }

    func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: any Error
    ) {
        print(error)
    }

}
