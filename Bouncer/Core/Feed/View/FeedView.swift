//
//  FeedView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.events) { event in
                        EventCell(event: event)
                    }
                }
            }
            .refreshable {
                Task { try await viewModel.fetchEvents() }
            }
            .navigationTitle("Events")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
    
}
