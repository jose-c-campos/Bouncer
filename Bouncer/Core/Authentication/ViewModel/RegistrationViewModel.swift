//
//  RegistrationViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    @Published var errorMessage = ""
    
    @MainActor
    func createUser() async throws -> String {
        errorMessage = ""
        errorMessage = try await AuthService.shared.createUser(
            withEmail: email,
            password: password,
            fullname: fullname,
            username: username
        )
        return errorMessage
    }
}
