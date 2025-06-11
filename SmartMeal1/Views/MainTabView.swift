// Replace MainTabView.swift with this version

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
            GroceryFinderView()
                  .tabItem {
                      Image(systemName: "location")
                      Text("Stores")
                  }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                                }
        }
        .accentColor(.orange)
    }
}
