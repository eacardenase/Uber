//
//  AuthButton.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/10/25.
//

import UIKit

class AuthButton: UIButton {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        backgroundColor = .systemBlue.withAlphaComponent(0.5)
        isEnabled = false
        layer.cornerRadius = 5

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .body
        ).withSymbolicTraits(.traitBold) {
            titleLabel?.font = UIFont(
                descriptor: fontDescriptor,
                size: 0
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50)
    }

}
