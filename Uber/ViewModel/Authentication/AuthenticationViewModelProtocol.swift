//
//  AuthenticationViewModelProtocol.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {

    func authenticationComplete()

}

protocol AuthenticationProtocol {

    func updateForm()

}

protocol AuthenticationViewModelProtocol {

    var formIsValid: Bool { get }
    var shouldEnableButton: Bool { get }
    var buttonTitleColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }

}

extension AuthenticationViewModelProtocol {

    var shouldEnableButton: Bool {
        return formIsValid
    }

    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.5)
    }

    var buttonBackgroundColor: UIColor {
        return formIsValid
            ? .systemBlue : .systemBlue.withAlphaComponent(0.5)
    }

}
