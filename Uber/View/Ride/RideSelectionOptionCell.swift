//
//  RideSelectionOptionCell.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/7/26.
//

import UIKit

class RideSelectionOptionCell: UITableViewCell {

    // MARK: - Properties

    var viewModel: RideSelectionOptionCellViewModel? {
        didSet { configure() }
    }

    static let rowHeight: CGFloat = 80

    private let rideTypeImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .uberXIcon)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let rideTypeLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    private let rideDistanceLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)

        return label
    }()

    private let auxiliaryLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray

        return label
    }()

    private let rideAmountLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
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

        contentView.addSubview(rideTypeImageView)
        contentView.addSubview(rideTypeLabel)
        contentView.addSubview(rideDistanceLabel)
        contentView.addSubview(auxiliaryLabel)
        contentView.addSubview(rideAmountLabel)

        // rideTypeImageView
        NSLayoutConstraint.activate([
            rideTypeImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            rideTypeImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            rideTypeImageView.widthAnchor.constraint(equalToConstant: 80),
        ])

        // rideTypeLabel
        NSLayoutConstraint.activate([
            rideTypeLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            rideTypeLabel.leadingAnchor.constraint(
                equalTo: rideTypeImageView.trailingAnchor
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

    private func configure() {
        guard let viewModel else { return }

        rideTypeLabel.text = viewModel.rideTypeText
        rideDistanceLabel.text = viewModel.rideDistanceText
        auxiliaryLabel.text = viewModel.auxiliaryText
        rideAmountLabel.text = viewModel.rideAmountText

        if viewModel.isSelected {
            layer.cornerRadius = 8
            layer.borderWidth = 2
            layer.borderColor = UIColor.label.cgColor
        } else {
            layer.cornerRadius = 0
            layer.borderWidth = 0
            layer.borderColor = UIColor.systemBackground.cgColor
        }
    }

}
