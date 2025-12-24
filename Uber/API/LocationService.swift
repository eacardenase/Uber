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
            accountType: user.accountType,
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

    static func fetchDriversNear(_ location: CLLocation?) {
        guard let location else { return }

        let maxDistanceKm: Double = 100
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

        print(
            """
            Query: .order(by: "longitude")
            .whereField("accountType", isEqualTo: 1)
            .whereField("longitude", isGreaterThanOrEqualTo: \(minLongitudeRange))
            .whereField("longitude", isLessThanOrEqualTo: \(maxLongitudeRange))
            .whereField("latitude", isGreaterThanOrEqualTo: \(minLatitudeRange))
            .whereField("latitude", isLessThanOrEqualTo: \(maxLatitudeRange))
            """
        )

        Firestore.firestore().collection("user-locations")
            .order(by: "longitude")
            .whereField("accountType", isEqualTo: 1)
            .whereField("longitude", isGreaterThanOrEqualTo: minLongitudeRange)
            .whereField("longitude", isLessThanOrEqualTo: maxLongitudeRange)
            .whereField("latitude", isGreaterThanOrEqualTo: minLatitudeRange)
            .whereField("latitude", isLessThanOrEqualTo: maxLatitudeRange)
            .getDocuments { snapshot, error in
                print(snapshot?.documents)
            }
    }

}
