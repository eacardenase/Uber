//
//  User.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import Foundation

struct User: Codable {

    let uid: String
    let fullname: String
    let email: String
    let accountType: AccountType

}
