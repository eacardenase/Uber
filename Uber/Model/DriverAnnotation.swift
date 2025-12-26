//
//  DriverAnnotation.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/25/25.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {

    // MARK: - Properties

    var uid: String
    dynamic var coordinate: CLLocationCoordinate2D

    // MARK: - Initializers

    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }

    // MARK: - Helpers

    func updatePosition(with location: CLLocationCoordinate2D) {
        UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
            self.coordinate = location
        }.startAnimation()
    }

}
