//
//  LocationManager.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/22/25.
//

import CoreLocation
import UIKit

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

}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if case .authorizedWhenInUse = manager.authorizationStatus {
            self.manager.requestAlwaysAuthorization()
        }
    }

}
