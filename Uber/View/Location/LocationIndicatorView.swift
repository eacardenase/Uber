//
//  CustomView.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/14/25.
//

import UIKit

class LocationIndicatorView: UIView {

    // MARK: - Properties

    private let startLocationIndicatorView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label

        return view
    }()

    private let startLocationAuxiliaryView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground

        return view
    }()

    private let linkingView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label

        return view
    }()

    private let destinationLocationIndicatorView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        view.layer.cornerRadius = 4

        return view
    }()

    private let destinationLocationAuxiliaryView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground

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

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        startLocationIndicatorView.layer.cornerRadius =
            startLocationIndicatorView.frame.height / 2
        startLocationAuxiliaryView.layer.cornerRadius =
            startLocationAuxiliaryView.frame.height / 2
    }

}

// MARK: - Helpers

extension LocationIndicatorView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(startLocationIndicatorView)
        addSubview(startLocationAuxiliaryView)
        addSubview(linkingView)
        addSubview(destinationLocationIndicatorView)
        addSubview(destinationLocationAuxiliaryView)

        // startLocationAuxiliaryView
        NSLayoutConstraint.activate([
            startLocationAuxiliaryView.centerXAnchor.constraint(
                equalTo: startLocationIndicatorView.centerXAnchor
            ),
            startLocationAuxiliaryView.centerYAnchor.constraint(
                equalTo: startLocationIndicatorView.centerYAnchor
            ),
            startLocationAuxiliaryView.heightAnchor.constraint(
                equalToConstant: 4
            ),
            startLocationAuxiliaryView.widthAnchor.constraint(
                equalTo: startLocationAuxiliaryView.heightAnchor
            ),
        ])

        // destinationLocationAuxiliaryView
        NSLayoutConstraint.activate([
            destinationLocationAuxiliaryView.centerXAnchor.constraint(
                equalTo: destinationLocationIndicatorView.centerXAnchor
            ),
            destinationLocationAuxiliaryView.centerYAnchor.constraint(
                equalTo: destinationLocationIndicatorView.centerYAnchor
            ),
            destinationLocationAuxiliaryView.heightAnchor.constraint(
                equalToConstant: 4
            ),
            destinationLocationAuxiliaryView.widthAnchor.constraint(
                equalTo: destinationLocationAuxiliaryView.heightAnchor
            ),
        ])

        // startLocationIndicatorView
        NSLayoutConstraint.activate([
            startLocationIndicatorView.topAnchor.constraint(equalTo: topAnchor),
            startLocationIndicatorView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            startLocationIndicatorView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            startLocationIndicatorView.heightAnchor.constraint(
                equalToConstant: 16
            ),
            startLocationIndicatorView.widthAnchor.constraint(
                equalTo: startLocationIndicatorView.heightAnchor
            ),
        ])

        // linkingView
        NSLayoutConstraint.activate([
            linkingView.topAnchor.constraint(
                equalTo: startLocationIndicatorView.bottomAnchor,
                constant: 1
            ),
            linkingView.widthAnchor.constraint(equalToConstant: 1.5),
            linkingView.centerXAnchor.constraint(
                equalTo: startLocationIndicatorView.centerXAnchor
            ),
            linkingView.bottomAnchor.constraint(
                equalTo: destinationLocationIndicatorView.topAnchor,
                constant: -1
            ),

        ])

        // destinationLocationIndicatorView
        NSLayoutConstraint.activate([
            destinationLocationIndicatorView.leadingAnchor.constraint(
                equalTo: startLocationIndicatorView.leadingAnchor
            ),
            destinationLocationIndicatorView.trailingAnchor.constraint(
                equalTo: startLocationIndicatorView.trailingAnchor
            ),
            destinationLocationIndicatorView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            destinationLocationIndicatorView.heightAnchor.constraint(
                equalTo: startLocationIndicatorView.heightAnchor
            ),
            destinationLocationIndicatorView.widthAnchor.constraint(
                equalTo: startLocationIndicatorView.widthAnchor
            ),
        ])
    }

}
