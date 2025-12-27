//
//  LocationInputView.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import MapKit
import UIKit

protocol LocationInputViewDelegate: LocationInputTextFieldDelegate {

}

class LocationInputView: UIView {

    // MARK: - Properties

    weak var delegate: LocationInputTextFieldDelegate?

    private let locationIndicatorView = LocationIndicatorView()

    private let pickupInput = LocationInputTextField(
        title: "Pickup",
        placeholder: "Pickup Location"
    )
    private let destinationInput = LocationInputTextField(
        title: "Destination",
        placeholder: "Where to?"
    )
    private let dividerView: UIView = {
        let view = UIView()

        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true

        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        pickupInput.delegate = self
        destinationInput.delegate = self

        setupViews()
        setupPickLocation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 16
    }

}

// MARK: - Helpers

extension LocationInputView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            pickupInput, dividerView, destinationInput,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8

        addSubview(stackView)
        addSubview(locationIndicatorView)

        // locationIndicatorView
        NSLayoutConstraint.activate([
            locationIndicatorView.topAnchor.constraint(
                equalTo: pickupInput.centerYAnchor,
                constant: -8
            ),
            locationIndicatorView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            locationIndicatorView.bottomAnchor.constraint(
                equalTo: destinationInput.centerYAnchor,
                constant: 8
            ),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(
                equalTo: locationIndicatorView.trailingAnchor,
                constant: 16
            ),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
        ])
    }

    private func setupPickLocation() {
        guard let location = LocationManager.shared.location else { return }

        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                return
            }

            self.pickupInput.text = placemark.name
        }
    }

}

// MARK: - LocationInputTextFieldDelegate

extension LocationInputView: LocationInputTextFieldDelegate {

    func executeSearch(for query: String) {
        delegate?.executeSearch(for: query)
    }

}
