//
//  LocationManager.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/22/25.
//

import CoreLocation
import MapKit
import UIKit

enum LocationError: Error {

    case fetchFailed(String)
    case reverseGeocodeFailed(String)

}

class LocationManager: NSObject {

    // MARK: - Properties

    static let shared = LocationManager()

    let manager = CLLocationManager()

    var location: CLLocation? {
        return manager.location
    }

    // MARK: - Initializers

    private override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

}

// MARK: - Helpers

extension LocationManager {

    func enableLocationServices() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        default:
            break
        }
    }

    func requestLocationName(
        completion: @escaping (Result<String, LocationError>) -> Void
    ) {
        guard let location = LocationManager.shared.location else {
            completion(.failure(.reverseGeocodeFailed("Location is nil.")))

            return
        }

        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error {
                completion(
                    .failure(.reverseGeocodeFailed(error.localizedDescription))
                )

                return
            }

            guard let placemark = placemarks?.first,
                let locationName = placemark.name
            else {
                completion(
                    .failure(
                        .reverseGeocodeFailed("Failed to get location name.")
                    )
                )

                return
            }

            completion(.success(locationName))
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if case .authorizedWhenInUse = manager.authorizationStatus {
            self.manager.requestAlwaysAuthorization()
        }
    }

}
