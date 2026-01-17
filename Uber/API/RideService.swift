//
//  RideService.swift
//  Uber
//
//  Created by Edwin Cardenas on 1/14/26.
//

import CoreLocation
import FirebaseAuth
import FirebaseFirestore

struct RideService {

    private init() {}

    static func fetchAvailableRides(
        completion: @escaping (Result<[RideProduct], NetworkingError>) -> Void
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
                    try? $0.data(as: RideProduct.self)
                }

                completion(.success(rides))
            }
    }

    static func requestRide(
        product: RideProduct,
        startLocation: Location,
        endLocation: Location,
        completion: @escaping (Result<Trip, NetworkingError>) -> Void
    ) {
        guard let currentUserId = AuthService.currentUser?.uid else {
            completion(.failure(.notAuthenticated))

            return
        }

        let trip = Trip(
            userId: currentUserId,
            driverId: nil,
            startLocation: startLocation,
            endLocation: endLocation,
            status: .requested,
            product: product,
            createdAt: Timestamp()
        )

        do {
            try Firestore.firestore().collection("trips")
                .addDocument(from: trip)

            DispatchQueue.main.async {
                completion(.success(trip))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(.encodingError(error.localizedDescription)))
            }
        }
    }

}
