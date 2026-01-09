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

    private let locationController = LocationController()
    private let rideController = RideController()
    private var route: MKRoute?
    private var ridesNavigationController: UINavigationController?
    private var smallDetent: UISheetPresentationController.Detent?

    private lazy var mapView: MKMapView = {
        let _mapView = MKMapView()

        _mapView.translatesAutoresizingMaskIntoConstraints = false
        _mapView.showsUserLocation = true
        _mapView.userTrackingMode = .follow
        _mapView.delegate = self
        _mapView.preferredConfiguration = MKStandardMapConfiguration()

        return _mapView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .label
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - View Lifecycle

    override func loadView() {
        view = UIView()

        view.addSubview(mapView)
        view.addSubview(backButton)

        // mapView
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            backButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 32
            ),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
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

    private func removeAnnotations() {
        for annotation in mapView.annotations
        where annotation is MKPointAnnotation {
            mapView.removeAnnotation(annotation)
        }
    }

    private func generatePolyline(to destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile

        let directionRequest = MKDirections(request: request)

        directionRequest.calculate { response, error in
            if let error {
                print(
                    "DEBUG: Failed to calculate directions with error: \(error.localizedDescription)"
                )

                return
            }

            guard let response else {
                print("DEBUG: Failed to get directions response.")

                return
            }

            self.route = response.routes.first

            guard let polyline = self.route?.polyline else {
                print("DEBUG: Failed to get polyline from route.")

                return
            }

            self.mapView.addOverlay(polyline)
        }
    }

    private func removePolyline(for route: MKRoute?) {
        if let route {
            mapView.removeOverlay(route.polyline)
        }
    }

    private func removeAnnotationsAndPolyline() {
        removePolyline(for: route)
        removeAnnotations()
    }

    private func presentRidesController() {
        rideController.view.layoutIfNeeded()

        if let sheet = rideController.sheetPresentationController {
            smallDetent = UISheetPresentationController.Detent.custom {
                [weak self] _ in
                guard let self else { return 0 }

                return self.rideController.minHeight
            }

            guard let smallDetent else { return }

            sheet.detents = [smallDetent, .medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.delegate = self
        }

        rideController.isModalInPresentation = true

        present(rideController, animated: true)
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

    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let destination = MKMapItem(placemark: placemark)

        removePolyline(for: route)

        generatePolyline(to: destination)

        let annotations = mapView.annotations.filter {
            !$0.isKind(of: DriverAnnotation.self)
        }

        mapView.showAnnotations(annotations, animated: true)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay)
        -> MKOverlayRenderer
    {
        guard let route else { fatalError("Failed to render route.") }

        let polyline = route.polyline
        let lineRenderer = MKPolylineRenderer(polyline: polyline)
        lineRenderer.strokeColor = .label
        lineRenderer.lineWidth = 4

        return lineRenderer

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

            guard let response else {
                print(
                    "DEBUG: Failed to get search result from \(searchCompletion.title)"
                )

                return
            }

            let results = response.mapItems.compactMap {
                MKPointAnnotation(
                    coordinate: $0.placemark.coordinate
                )
            }

            self.mapView.addAnnotations(results)

            if let firstAnnotation = results.first {
                self.mapView.selectAnnotation(firstAnnotation, animated: true)
            }
        }

        presentRidesController()
    }

}

// MARK: - Actions

extension MapController {

    @objc func backButtonTapped(_ sender: UIButton) {
        guard let ridesNavigationController else { return }

        ridesNavigationController.dismiss(animated: true) {
            self.removeAnnotationsAndPolyline()

            self.mapView.showAnnotations(
                self.mapView.annotations,
                animated: true
            )
        }
    }

}

// MARK: - UISheetPresentationControllerDelegate

extension MapController: UISheetPresentationControllerDelegate {

    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
        _ sheetPresentationController: UISheetPresentationController
    ) {
        guard let smallDetent else { return }

        let selectedDetentIdentifier = sheetPresentationController
            .selectedDetentIdentifier
        let isSmallDetent = selectedDetentIdentifier == smallDetent.identifier

        rideController.isScrollEnable = !isSmallDetent

        rideController.scrollToSelectedIndex(animated: true)
    }

}
