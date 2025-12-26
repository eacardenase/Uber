//
//  MapController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/13/25.
//

import MapKit
import UIKit

class MapController: UIViewController {

    // MARK: - Properties

    private var user: User?

    private lazy var mapView: MKMapView = {
        let _mapView = MKMapView()

        _mapView.showsUserLocation = true
        _mapView.userTrackingMode = .follow
        _mapView.delegate = self
        _mapView.preferredConfiguration = MKStandardMapConfiguration()

        return _mapView
    }()

    // MARK: - View Lifecycle

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateUser()
        // logout()
        setupViews()

        LocationManager.shared.enableLocationServices()

        fetchDrivers()
    }

}

// MARK: - Helpers

extension MapController {

    private func setupViews() {

    }

    private func presentLoginController() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let loginController = LoginController()
            loginController.delegate = self

            let navController = UINavigationController(
                rootViewController: loginController
            )

            navController.modalPresentationStyle = .fullScreen

            self.present(navController, animated: true)
        }
    }

}

// MARK: - AuthenticationDelegate

extension MapController: AuthenticationDelegate {

    func authenticationComplete() {
        dismiss(animated: true)
    }

}

// MARK: - API

extension MapController {

    private func authenticateUser() {
        AuthService.verifyLogin { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print("DEBUG: \(error)")

                self.presentLoginController()
            }
        }
    }

    private func logout() {
        AuthService.logUserOut { [weak self] error in
            guard let self else { return }

            if let error {
                print(
                    "DEBUG: Failed to log out with error: \(error.localizedDescription)"
                )
            }

            self.presentLoginController()
        }
    }

    private func fetchDrivers() {
        let locationManager = LocationManager.shared

        print(locationManager.location)

        LocationService.fetchDriversNear(locationManager.location) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let locations):
                let driversAnnotations = locations.map { location in
                    let coordinate = CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )

                    return DriverAnnotation(
                        uid: location.userId,
                        coordinate: coordinate
                    )
                }

                self.mapView.addAnnotations(driversAnnotations)
            }
        }
    }

}

// MARK: - MKMapViewDelegate

extension MapController: MKMapViewDelegate {

}
