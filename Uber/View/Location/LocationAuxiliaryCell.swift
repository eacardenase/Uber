//
//  LocationAuxiliaryCell.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/15/25.
//

import UIKit

class LocationAuxiliaryCell: UITableViewCell {

    // MARK: - Properties

    var viewModel: LocationAuxiliaryCellViewModel? {
        didSet { configure() }
    }

    private let imageContainer: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground

        return view
    }()

    private let containerImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        imageContainer.layer.cornerRadius = imageContainer.frame.height / 2
    }

}

// MARK: - Helpers

extension LocationAuxiliaryCell {

    private func setupViews() {
        addSubview(imageContainer)
        addSubview(containerImageView)
        addSubview(titleLabel)

        // imageContainer
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8
            ),
            imageContainer.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 8
            ),
            imageContainer.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
            imageContainer.heightAnchor.constraint(equalToConstant: 32),
            imageContainer.widthAnchor.constraint(
                equalTo: imageContainer.heightAnchor
            ),
        ])

        // imageView
        NSLayoutConstraint.activate([
            containerImageView.centerXAnchor.constraint(
                equalTo: imageContainer.centerXAnchor
            ),
            containerImageView.centerYAnchor.constraint(
                equalTo: imageContainer.centerYAnchor
            ),
            containerImageView.heightAnchor.constraint(equalToConstant: 16),
            containerImageView.widthAnchor.constraint(
                equalTo: containerImageView.heightAnchor
            ),
        ])

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: imageContainer.trailingAnchor,
                constant: 8
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: imageContainer.centerYAnchor
            ),
        ])
    }

    private func configure() {
        guard let viewModel else { return }

        containerImageView.image = UIImage(systemName: viewModel.imageName)
        titleLabel.text = viewModel.titleText
    }

}
