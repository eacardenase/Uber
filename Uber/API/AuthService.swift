//
//  AuthService.swift
//  Uber
//
//  Created by Edwin Cardenas on 12/12/25.
//

import FirebaseAuth

enum NetworkingError: Error {
    case decodingError
    case serverError(String)
}

struct AuthCredentials {
    let fullname: String
    let email: String
    let password: String
    let accountType: AccountType
}

struct AuthService {

    private init() {}

    static func createUser(
        with credentials: AuthCredentials,
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        Auth.auth().createUser(
            withEmail: credentials.email,
            password: credentials.password
        ) { result, error in

            if let error {
                completion(
                    .failure(.serverError(error.localizedDescription))
                )

                return
            }

            guard let uid = result?.user.uid else {
                completion(
                    .failure(.serverError("Failed to get user id."))
                )

                return
            }

            let user = User(
                uid: uid,
                fullname: credentials.fullname,
                email: credentials.email,
                accountType: credentials.accountType
            )

            UserService.store(
                user,
                completion: completion
            )
        }
    }

    static func logUserIn(
        withEmail email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {
            result,
            error in

            if let error {
                completion(error)

                return
            }

            completion(nil)
        }
    }

    static func verifyLogin(
        completion: @escaping (Result<User, NetworkingError>) -> Void
    ) {
        guard
            let currentUserId = Auth.auth().currentUser?.uid
        else {
            completion(
                .failure(
                    .serverError("Failed to get user, current user is nil.")
                )
            )

            return
        }

        UserService.fetchUser(withId: currentUserId, completion: completion)
    }

    static func logUserOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()

            completion(nil)
        } catch {
            completion(error)
        }
    }

}
