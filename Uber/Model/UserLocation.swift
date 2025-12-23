//
//  UserLocation.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/22/25.
//

import Foundation

struct UserLocation: Codable {

    let userId: String
    let accountType: AccountType
    let latitude: Double
    let longitude: Double

}
