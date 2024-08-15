//
//  LoginViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var validLogin = true
    
    @MainActor
    func login() async throws {
        validLogin = true
        validLogin = try await AuthService.shared.login(
            withEmail: email,
            password: password
        )
    }
}
