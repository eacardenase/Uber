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

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()

        manager.delegate = self

        return manager
    }()

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

        // authenticateUser()
        logout()
        setupViews()

        enableLocationServices()
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
                print("DEBUG: \(error.localizedDescription)")

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

}

// MARK: - MKMapViewDelegate

extension MapController: MKMapViewDelegate {

}

// MARK: - Location Services

extension MapController {

    private func enableLocationServices() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension MapController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if case .authorizedWhenInUse = manager.authorizationStatus {
            locationManager.requestAlwaysAuthorization()
        }
    }

}
