//
//  LocationTableViewFooter.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/15/25.
//

import UIKit

class LocationTableViewFooter: UIView {

    // MARK: - Properties

    private let imageContainer: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground

        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "globe"))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search in a different city"
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

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

extension LocationTableViewFooter {

    private func setupViews() {
        addSubview(imageContainer)
        addSubview(imageView)
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
            imageView.centerXAnchor.constraint(
                equalTo: imageContainer.centerXAnchor
            ),
            imageView.centerYAnchor.constraint(
                equalTo: imageContainer.centerYAnchor
            ),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
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

}
