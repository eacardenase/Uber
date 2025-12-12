//
//  HomeController.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import MapKit
import UIKit

class HomeController: UIViewController {

    // MARK: - Properties

    private var user: User?
    private let locationManager = CLLocationManager()
    private lazy var mapView: MKMapView = {
        let _mapView = MKMapView()

        _mapView.showsUserLocation = true
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

        locationManager.requestWhenInUseAuthorization()
    }

}

// MARK: - Helpers

extension HomeController {

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

extension HomeController: AuthenticationDelegate {

    func authenticationComplete() {
        dismiss(animated: true)
    }

}

// MARK: - API

extension HomeController {

    private func authenticateUser() {
        AuthService.verifyLogin { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                self.user = user
                print(user)
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

extension HomeController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )

        mapView.setRegion(region, animated: true)
    }
}
