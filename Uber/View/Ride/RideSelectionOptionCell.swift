//
//  RideSelectionOptionCell.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/7/26.
//

import UIKit

class RideSelectionOptionCell: UITableViewCell {

    // MARK: - Properties

    static let rowHeight: CGFloat = 80

    private let rideTypeLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taxi"
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    private let rideDistanceLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 min away"
        label.font = .preferredFont(forTextStyle: .subheadline)

        return label
    }()

    private let auxiliaryLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "In partnership with TaxExpress"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray

        return label
    }()

    private let rideAmountLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "COP 10,459-12,494"
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()

        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension RideSelectionOptionCell {

    private func setupViews() {
        backgroundColor = .systemBackground

        contentView.addSubview(rideTypeLabel)
        contentView.addSubview(rideDistanceLabel)
        contentView.addSubview(auxiliaryLabel)
        contentView.addSubview(rideAmountLabel)

        // rideTypeLabel
        NSLayoutConstraint.activate([
            rideTypeLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            rideTypeLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
        ])

        // rideDistanceLabel
        NSLayoutConstraint.activate([
            rideDistanceLabel.topAnchor.constraint(
                equalTo: rideTypeLabel.bottomAnchor,
                constant: 4
            ),
            rideDistanceLabel.leadingAnchor.constraint(
                equalTo: rideTypeLabel.leadingAnchor
            ),
        ])

        // auxiliaryLabel
        NSLayoutConstraint.activate([
            auxiliaryLabel.topAnchor.constraint(
                equalTo: rideDistanceLabel.bottomAnchor,
                constant: 4
            ),
            auxiliaryLabel.leadingAnchor.constraint(
                equalTo: rideTypeLabel.leadingAnchor
            ),
            auxiliaryLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
        ])

        // rideAmountLabel
        NSLayoutConstraint.activate([
            rideAmountLabel.topAnchor.constraint(
                equalTo: rideTypeLabel.topAnchor
            ),
            rideAmountLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
        ])

    }

    func removeSelectedBorder() {
        layer.cornerRadius = 0
        layer.borderWidth = 0
        layer.borderColor = UIColor.systemBackground.cgColor
    }

    func addSelectedBorder() {
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.label.cgColor
    }

}
