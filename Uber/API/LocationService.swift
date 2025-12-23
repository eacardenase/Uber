//
//  UserLocationService.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/22/25.
//

import CoreLocation
import FirebaseFirestore

struct LocationService {

    private init() {}

    static func storeLocation(
        for user: User,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        guard let location = LocationManager.shared.location else {
            completion(
                .failure(.serverError("Failed to get user location."))
            )

            return
        }

        let userLocation = UserLocation(
            userId: user.uid,
            latitude: location.coordinate.latitude.magnitude,
            longitude: location.coordinate.longitude.magnitude
        )

        do {
            try Firestore
                .firestore()
                .collection("user-locations")
                .addDocument(from: userLocation)

            completion(.success(user))
        } catch {
            completion(.failure(.serverError(error.localizedDescription)))
        }
    }

}
