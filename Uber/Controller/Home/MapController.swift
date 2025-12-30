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
    private var currentAnnotations = [DriverAnnotation]()

    private let locationController = LocationController()

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
        view = UIView()

        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        // mapView
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateUser()
        // logout()
        setupViews()

        LocationManager.shared.enableLocationServices()

        fetchDrivers()

        locationController.delegate = self
    }

}

// MARK: - Helpers

extension MapController {

    private func setupViews() {
        locationController.region = mapView.region
        locationController.view.frame = view.bounds

        addChild(locationController)
        view.addSubview(locationController.view)

        locationController.didMove(toParent: self)
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

    private func updateAnnotationsCoordinates(for locations: [UserLocation]) {
        for location in locations {
            let coordinate = CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            )

            let driverAnnotation = DriverAnnotation(
                uid: location.userId,
                coordinate: coordinate
            )

            let driverVisible = self.mapView.annotations.contains {
                mapAnnotation in

                guard let mapAnnotation = mapAnnotation as? DriverAnnotation
                else { return false }

                if mapAnnotation.uid == location.userId {
                    mapAnnotation.updatePosition(with: coordinate)

                    return true
                }

                return false
            }

            if !driverVisible {
                self.mapView.addAnnotation(driverAnnotation)
            }
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

        LocationService.fetchDriversNear(locationManager.location) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let locations):
                self.updateAnnotationsCoordinates(for: locations)
            }
        }
    }

}

// MARK: - MKMapViewDelegate

extension MapController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation)
        -> MKAnnotationView?
    {
        guard let annotation = annotation as? DriverAnnotation else {
            return nil
        }

        let view = MKAnnotationView(
            annotation: annotation,
            reuseIdentifier: NSStringFromClass(DriverAnnotation.self)
        )

        view.image = UIImage(systemName: "car.fill")

        return view
    }

}

// MARK: - LocationControllerDelegate

extension MapController: LocationControllerDelegate {

    func dismiss(_ controller: LocationController) {
        controller.willMove(toParent: nil)
        controller.removeFromParent()
        controller.view.removeFromSuperview()
    }

    func controllerWantsToPresentAnnotation(
        _ controller: LocationController,
        for searchCompletion: MKLocalSearchCompletion
    ) {
        dismiss(controller)

        let request = MKLocalSearch.Request(completion: searchCompletion)
        let search = MKLocalSearch(request: request)

        search.start { response, error in
            if let error {
                print(error.localizedDescription)

                return
            }

            guard let searchResult = response?.mapItems.first else {
                print(
                    "DEBUG: Failed to get search result from \(searchCompletion.title)"
                )

                return
            }

            let annotation = MKPointAnnotation(
                coordinate: searchResult.placemark.coordinate
            )

            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }

}
