//
//  DecoratedTextFieldContainerView.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/9/25.
//

import UIKit

protocol DecoratedTextFieldDelegate: AnyObject {

    func editingChanged(_ sender: DecoratedTextField)

}

class DecoratedTextField: UIView {

    // MARK: - Properties

    weak var delegate: DecoratedTextFieldDelegate?

    private let imageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.tintColor = .label.withAlphaComponent(0.8)
        _imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        _imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return _imageView
    }()

    private lazy var textField: UITextField = {
        let _textField = UITextField()

        _textField.translatesAutoresizingMaskIntoConstraints = false
        _textField.borderStyle = .none
        _textField.font = .preferredFont(forTextStyle: .body)
        _textField.textColor = .label
        _textField.keyboardAppearance = .dark
        _textField.autocapitalizationType = .none
        _textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )

        return _textField
    }()

    private let dividerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator

        return view
    }()

    var text: String? {
        return textField.text
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    // MARK: - Initializers

    init(
        imageResource: ImageResource,
        placeholder: String,
        isSecure: Bool = false
    ) {
        super.init(frame: .zero)

        imageView.image = UIImage(resource: imageResource)
            .withRenderingMode(.alwaysTemplate)

        textField.isSecureTextEntry = isSecure
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.preferredFont(forTextStyle: .body),
            ]
        )

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

extension DecoratedTextField {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(textField)
        addSubview(dividerView)

        // imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])

        // textField
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: 8
            ),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.centerYAnchor.constraint(
                equalTo: imageView.centerYAnchor
            ),
        ])

        // dividerView
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 8
            ),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
        ])
    }

}

// MARK: - Actions

extension DecoratedTextField {

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.editingChanged(self)
    }

}
