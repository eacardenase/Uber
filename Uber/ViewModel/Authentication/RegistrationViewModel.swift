//
//  RegistrationViewModel.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import Foundation

struct RegistrationViewModel: AuthenticationViewModelProtocol {

    var fullname: String?
    var email: String?
    var password: String?

    var formIsValid: Bool {
        return fullname?.isEmpty == false
            && email?.isEmpty == false
            && password?.isEmpty == false
    }

}
