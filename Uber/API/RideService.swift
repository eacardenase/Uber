//
//  RideService.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/14/26.
//

import FirebaseFirestore
import Foundation

struct RideService {

    private init() {}

    static func fetchAvailableRides(
        completion: @escaping (Result<[Ride], NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("rides")
            .getDocuments { snapshot, error in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let snapshot else {
                    completion(
                        .failure(.serverError("Failed to get available rides."))
                    )

                    return
                }

                let rides = snapshot.documents.compactMap {
                    try? $0.data(as: Ride.self)
                }

                completion(.success(rides))
            }
    }

    static func storeRide() {
        print(#function)
    }

}
