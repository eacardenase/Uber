//
//  UserLocationService.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/22/25.
//

import FirebaseFirestore

struct UserLocationService {

    private init() {}

    static func store(
        _ location: UserLocation,
        completion: @escaping (NetworkingError?) -> Void
    ) {
        do {
            try Firestore
                .firestore()
                .collection("user-locations")
                .addDocument(from: location)

            completion(nil)
        } catch {
            completion(.serverError(error.localizedDescription))
        }
    }

}
