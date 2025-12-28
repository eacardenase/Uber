//
//  LocationSearchResultCell.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/16/25.
//

import UIKit

class LocationSearchResultCell: UITableViewCell {

    // MARK: - Properties

    var viewModel: LocationSearchResultCellViewModel? {
        didSet { configure() }
    }

    private let locationImageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.image = UIImage(systemName: "mappin.and.ellipse")
        _imageView.tintColor = .label
        _imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        _imageView.widthAnchor.constraint(equalTo: _imageView.heightAnchor)
            .isActive = true

        return _imageView
    }()

    private let imageTooltipLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "8.2 mi"
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .caption2)

        label.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )
        label.setContentHuggingPriority(.required, for: .horizontal)

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .subheadline)

        return label
    }()

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

extension LocationSearchResultCell {

    private func setupViews() {
        let labelStackView = UIStackView(arrangedSubviews: [
            titleLabel, addressLabel,
        ])

        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.spacing = 2
        labelStackView.setContentHuggingPriority(
            UILayoutPriority(249),
            for: .horizontal
        )

        contentView.addSubview(locationImageView)
        contentView.addSubview(imageTooltipLabel)
        contentView.addSubview(labelStackView)

        // locationImageView
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(
                equalTo: titleLabel.topAnchor
            ),
            locationImageView.centerXAnchor.constraint(
                equalTo: imageTooltipLabel.centerXAnchor
            ),
        ])

        // imageTooltipLabel
        NSLayoutConstraint.activate([
            imageTooltipLabel.topAnchor.constraint(
                equalTo: locationImageView.bottomAnchor,
                constant: 2
            ),
            imageTooltipLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8
            ),
        ])

        // labelStackView
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            labelStackView.leadingAnchor.constraint(
                equalTo: imageTooltipLabel.trailingAnchor,
                constant: 8
            ),
            labelStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8
            ),
            labelStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
        ])
    }

    private func configure() {
        guard let viewModel else { return }

        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.subtitle
    }

}
