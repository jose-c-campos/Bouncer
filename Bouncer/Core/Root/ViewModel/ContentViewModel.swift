//
//  ContentViewModel.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth

class ContentViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    // Listen for when userSession receives value from AuthService
    // This determines the ContentView Model (login or main page)
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        } .store(in: &cancellables)
    }
}
