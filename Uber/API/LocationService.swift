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
        guard let currentLocation = LocationManager.shared.location else {
            completion(
                .failure(.serverError("Failed to get user location."))
            )

            return
        }

        let location = Location(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude
        )

        let userLocation = UserLocation(
            userId: user.uid,
            accountType: user.accountType,
            location: location
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

    static func fetchDriversNear(
        _ location: CLLocation?,
        completion: @escaping (Result<[UserLocation], NetworkingError>) -> Void
    ) {
        guard let location else { return }

        let maxDistanceKm: Double = 50
        let kmPerDegreeLatitude = 110.574
        let kmPerDegreeLongitude = 111.32

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let range = CLLocationCoordinate2D(
            latitude: maxDistanceKm / kmPerDegreeLatitude,
            longitude: maxDistanceKm
                / (kmPerDegreeLongitude * cos(latitude * .pi / 180))
        )

        let minLongitudeRange = longitude - range.longitude
        let maxLongitudeRange = longitude + range.longitude
        let minLatitudeRange = latitude - range.latitude
        let maxLatitudeRange = latitude + range.latitude
        
        let longitudeFieldPath = FieldPath(["location", "longitude"])
        let latitudeFieldPath = FieldPath(["location", "latitude"])

        let query = Firestore.firestore().collection("user-locations")
            .order(by: longitudeFieldPath)
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .whereField(longitudeFieldPath, isGreaterThanOrEqualTo: minLongitudeRange)
            .whereField(longitudeFieldPath, isLessThanOrEqualTo: maxLongitudeRange)
            .whereField(latitudeFieldPath, isGreaterThanOrEqualTo: minLatitudeRange)
            .whereField(latitudeFieldPath, isLessThanOrEqualTo: maxLatitudeRange)

        query.addSnapshotListener { snapshot, error in
            if let error {
                completion(
                    .failure(.serverError(error.localizedDescription))
                )

                return
            }

            guard let snapshot else {
                completion(
                    .failure(
                        .serverError("Failed to get drivers locations.")
                    )
                )

                return
            }

            let driversLocations = snapshot.documents.compactMap {
                try? $0.data(as: UserLocation.self)
            }

            completion(.success(driversLocations))
        }
    }

}
