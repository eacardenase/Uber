//
//  LocationTableViewHeader.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/15/25.
//

import UIKit

class LocationTableViewHeader: UIView {

    // MARK: - Properties

    private let imageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.image = UIImage(systemName: "star")
        _imageView.tintColor = .label

        return _imageView
    }()

    private let label: UILabel = {
        let _label = UILabel()

        _label.translatesAutoresizingMaskIntoConstraints = false
        _label.text = "Saved Places"
        _label.font = .preferredFont(forTextStyle: .callout)

        return _label
    }()

    private let dividerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator

        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helpers

extension LocationTableViewHeader {

    private func setupViews() {
        addSubview(imageView)
        addSubview(label)
        addSubview(dividerView)

        let imageViewHeightAnchor = imageView.heightAnchor.constraint(
            equalToConstant: 16
        )
        imageViewHeightAnchor.priority = UILayoutPriority(900)

        let imageViewWidthAnchor = imageView.widthAnchor.constraint(
            equalToConstant: imageViewHeightAnchor.constant
        )
        imageViewWidthAnchor.priority = UILayoutPriority(900)

        // imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: label.topAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            imageViewHeightAnchor,
            imageViewWidthAnchor,
        ])

        let labelLeadingAnchor = label.leadingAnchor.constraint(
            equalTo: imageView.trailingAnchor,
            constant: 16
        )
        labelLeadingAnchor.priority = .defaultHigh

        // label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            labelLeadingAnchor,
            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

        ])

        let dividerViewBottomConstraint = dividerView.bottomAnchor.constraint(
            equalTo: bottomAnchor
        )
        dividerViewBottomConstraint.priority = .defaultHigh

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: label.bottomAnchor,
                constant: 16
            ),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerViewBottomConstraint,
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

}
