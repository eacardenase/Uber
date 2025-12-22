//
//  UserService.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import CoreLocation
import FirebaseFirestore

struct UserService {

    private init() {}

    static func store(
        _ user: User,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        do {
            try Firestore
                .firestore()
                .collection("users")
                .document(user.uid)
                .setData(from: user)

            guard let location = LocationManager.shared.location else {
                completion(
                    .failure(.serverError("Failed to get user location."))
                )

                return
            }

            let userLocation = UserLocation(
                userId: user.uid,
                latitude: location.coordinate.latitude.magnitude,
                longitude: location.coordinate.longitude.magnitude
            )

            UserLocationService.store(userLocation) { error in
                if let error {
                    completion(
                        .failure(error)
                    )

                    return
                }

                completion(.success(user))
            }

        } catch {
            completion(.failure(.serverError(error.localizedDescription)))
        }
    }

    static func fetchUser(
        withId userId: String,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        Firestore.firestore().collection("users").document(userId).getDocument {
            (snapshot, error) in

            if let error {
                completion(
                    .failure(.serverError(error.localizedDescription))
                )

                return
            }

            guard let snapshot else {
                completion(
                    .failure(.serverError("Failed to get user data."))
                )

                return
            }

            do {
                let user = try snapshot.data(as: User.self)

                completion(.success(user))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }

}
