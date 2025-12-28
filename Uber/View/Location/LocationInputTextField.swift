//
//  LocationInputTextField.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import UIKit

protocol LocationInputTextFieldDelegate: AnyObject {

    func executeSearch(for query: String)
    func inputTextFieldWantsToClearText()

}

class LocationInputTextField: UIView {

    // MARK: - Properties

    weak var delegate: LocationInputTextFieldDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)

        if let fontDescriptor: UIFontDescriptor = .preferredFontDescriptor(
            withTextStyle: .body
        ).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0)
        }

        return label
    }()

    var text: String? {
        didSet {
            inputTextField.text = text
        }
    }

    private lazy var inputTextField: UITextField = {
        let textField = UITextField()

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.font = .preferredFont(forTextStyle: .footnote)
        textField.autocorrectionType = .no
        textField.returnKeyType = .search
        textField.setContentHuggingPriority(
            UILayoutPriority(249),
            for: .horizontal
        )
        textField.addTarget(
            self,
            action: #selector(editingChanged),
            for: .editingChanged
        )

        return textField
    }()

    private lazy var clearInputButtom: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.setImage(
            UIImage(systemName: "xmark.circle.fill"),
            for: .highlighted
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.isHidden = true
        button.addTarget(
            self,
            action: #selector(clearInputButtomTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - Initializers

    init(title: String, placeholder: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        inputTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.preferredFont(forTextStyle: .footnote),
            ]
        )

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

extension LocationInputTextField {

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        addSubview(titleLabel)
        addSubview(inputTextField)
        addSubview(clearInputButtom)

        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        // inputTextField
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 4
            ),
            inputTextField.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        // clearInputButtom
        NSLayoutConstraint.activate([
            clearInputButtom.leadingAnchor.constraint(
                equalTo: inputTextField.trailingAnchor,
                constant: 8
            ),
            clearInputButtom.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -8
            ),
            clearInputButtom.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            clearInputButtom.heightAnchor.constraint(equalToConstant: 16),
            clearInputButtom.widthAnchor.constraint(
                equalTo: clearInputButtom.heightAnchor
            ),
        ])
    }

}

// MARK: - Actions

extension LocationInputTextField {

    @objc func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }

        clearInputButtom.isHidden = text.isEmpty
    }

    @objc func clearInputButtomTapped(_ sender: UIButton) {
        inputTextField.text = ""
        clearInputButtom.isHidden = true

        delegate?.inputTextFieldWantsToClearText()
    }

}

// MARK: - UITextFieldDelegate

extension LocationInputTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty == false else { return }

        DispatchQueue.main.async {
            self.clearInputButtom.isHidden = false

            textField.selectAll(nil)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        clearInputButtom.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty else { return false }

        delegate?.executeSearch(for: query)

        return true
    }

}
