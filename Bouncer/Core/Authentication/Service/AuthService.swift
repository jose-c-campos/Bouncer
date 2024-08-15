//
//  AuthService.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    @Published var userSession: FirebaseAuth.User?  // Checks if user is authentic: used to route pages
    @Published var errorMessage = ""
    let usernameIsTakenErrorMessage = "Username is already taken"
    let emailIncorrectFormatErrorMessage = "Email is incorrectly formatted"
    
    
    static let shared = AuthService()
    
    // Checks if somebody is currently logged in
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws -> Bool {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email,
                password: password
            )
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
            return true
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            return false
        }
    }
    
    @MainActor
    func createUser(
        withEmail email: String,
        password: String,
        fullname: String,
        username: String
    ) async throws -> String {
        do {
            // Check if username already exists
           let usernameExists = try await checkIfUsernameExists(username)
           if usernameExists {
               errorMessage = usernameIsTakenErrorMessage
               return usernameIsTakenErrorMessage
           }
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            self.userSession = result.user
            try  await uploadUserData(
                withEmail: email,
                fullname: fullname,
                username: username,
                id: result.user.uid
            )
            print("DEBUG: Created users \(result.user.uid)")
           return ""
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            return error.localizedDescription
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()    // Sign out on backend
        self.userSession = nil        // Clears session locally and reroutes to Login
        UserService.shared.reset()    // Resets current user object to nil for next user profile
    }
    
    // Do not store password
    private func uploadUserData(
        withEmail email: String,
        fullname: String,
        username: String, 
        id: String
    ) async throws {
        let user = User(
            id: id,
            fullname: fullname,
            email: email,
            username: username
        )
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(userData)
        UserService.shared.currentUser = user
    }
    
    // Check if the username already exists in the Firestore collection
    private func checkIfUsernameExists(_ username: String) async throws -> Bool {
        let querySnapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        return !querySnapshot.documents.isEmpty
    }
}

