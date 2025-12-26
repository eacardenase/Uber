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
    var coordinate: CLLocationCoordinate2D

    // MARK: - Initializers

    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }

}
