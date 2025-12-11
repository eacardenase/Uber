//
//  SegmentedControlView.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/11/25.
//

import UIKit

class SegmentedControlView: UIView {

    // MARK: - Properties

    private let segmentedControl: UISegmentedControl = {
        let _segmentedControl = UISegmentedControl(items: ["Rider", "Driver"])

        _segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        _segmentedControl.selectedSegmentIndex = 0
        _segmentedControl.backgroundColor = .systemBackground

        return _segmentedControl
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

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}

// MARK: - Helpers

extension SegmentedControlView {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(segmentedControl)
        addSubview(dividerView)

        // segmentedControl
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: 16
            ),
            dividerView.leadingAnchor.constraint(
                equalTo: segmentedControl.leadingAnchor
            ),
            dividerView.trailingAnchor.constraint(
                equalTo: segmentedControl.trailingAnchor
            ),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
        ])
    }

}
