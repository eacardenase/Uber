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

    private let inputActivationView = LocationInputActivationView()

    // MARK: - View Lifecycle

    override func loadView() {
        view = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateUser()
        // logout()
        setupViews()

        enableLocationServices()
    }

}

// MARK: - Helpers

extension HomeController {

    private func setupViews() {
        view.addSubview(inputActivationView)

        // locationInputView
        NSLayoutConstraint.activate([
            inputActivationView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 40
            ),
            inputActivationView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            inputActivationView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])
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

}

// MARK: - Location Services

extension HomeController {

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

extension HomeController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if case .authorizedWhenInUse = manager.authorizationStatus {
            locationManager.requestAlwaysAuthorization()
        }
    }

}
