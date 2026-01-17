//
//  RidePaymentSelectionViewModel.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/14/26.
//

import Foundation

struct RidePaymentSelectionViewModel {

    // MARK: - Properties

    private let ride: RideProduct

    var rideName: String {
        return "Choose \(ride.name)"
    }

    // MARK: - Initializers

    init(ride: RideProduct) {
        self.ride = ride
    }

}
