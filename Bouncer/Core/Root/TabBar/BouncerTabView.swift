//
//  BouncerTabView.swift
//  Bouncer
//
//  Created by Jose Campos on 8/8/24.
//

import SwiftUI

struct BouncerTabView: View {
    @State private var selectedTab = 0
    @State private var showCreateEventView = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            CreateEventView() {
                selectedTab = 0
            }
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            ScannerView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
            
            CurrentUserProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                }
                .onAppear { selectedTab = 4 }
                .tag(4)
        }
        .tint(.black)
    }
}

#Preview {
    BouncerTabView()
}
