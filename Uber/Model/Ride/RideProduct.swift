//
//  RideProduct.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/14/26.
//

import Foundation

struct PriceRange: Codable {

    let minimum: Double
    let maximum: Double

}

struct RideProduct: Codable {

    let uid: String
    let name: String
    let description: String
    let priceRange: PriceRange?
    let suggestedPrice: Double?

}
