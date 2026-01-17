//
//  Trip.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/16/26.
//

import Foundation
import FirebaseCore

enum TripStatus: String, Codable {

    case requested
    case searchingDriver
    case accepted
    case inProgress
    case completed
    case cancelled

}

struct Trip: Codable {

    let userId: String
    let driverId: String?
    let startLocation: Location
    let endLocation: Location
    let status: TripStatus
    let product: RideProduct
    let createdAt: Timestamp

}
