//
//  LoginViewModel.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import Foundation

struct LoginViewModel: AuthenticationViewModelProtocol {

    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }

}
