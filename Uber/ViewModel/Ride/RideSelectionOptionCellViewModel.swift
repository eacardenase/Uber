//
//  RideSelectionOptionCellViewModel.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/8/26.
//

import Foundation

class RideSelectionOptionCellViewModel: NSObject {

    // MARK: - Properties

    private let ride: Ride

    var rideTypeText: String {
        return ride.name
    }

    var rideDistanceText: String {
        return "5 min away"
    }

    var auxiliaryText: String {
        return ride.description
    }

    var rideAmountText: String? {
        let formatter = NumberFormatter()

        formatter.numberStyle = .decimal

        if let range = ride.priceRange {
            let minimumPrice = formatter.string(
                from: NSNumber(value: range.minimum)
            )!
            let maximumPrice = formatter.string(
                from: NSNumber(value: range.maximum)
            )!

            return "COP \(minimumPrice)-\(maximumPrice)"
        }

        if let price = ride.suggestedPrice {
            let suggestedPrice = formatter.string(
                from: NSNumber(value: price)
            )!

            return "sug. COP \(suggestedPrice)"
        }

        return nil
    }

    var isSelected: Bool = false

    // MARK: - Initializers

    init(ride: Ride) {
        self.ride = ride
    }

}
