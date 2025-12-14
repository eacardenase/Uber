//
//  LocationInputView.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import UIKit

class LocationInputView: UIView {

    // MARK: - Properties

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 150)
    }

}

// MARK: - Helpers

extension LocationInputView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1.5
        layer.cornerRadius = 16
    }

}
