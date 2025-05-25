//
//  MainTabView.swift
//  SmartMeal1
//
//  Created by Ifrah Mohamed on 25.05.2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                    Text("Scan")
                }

            RecipesView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Recipes")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .accentColor(.orange)
    }
}
