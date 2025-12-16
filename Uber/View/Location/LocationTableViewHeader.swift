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
        _label.setContentHuggingPriority(.required, for: .vertical)

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
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        //        super.init(frame: frame)

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

        // imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: label.firstBaselineAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])

        // label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: 16
            ),
            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            label.bottomAnchor.constraint(
                equalTo: dividerView.topAnchor,
                constant: -8
            ),
        ])

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
