//
//  ContentView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI

// View depends on whether a user is logged in or not
struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                BouncerTabView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
