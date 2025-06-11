// Replace ContentView.swift with this dark mode supporting version

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeManager = RecipeManager()
    @StateObject private var imageAnalyzer = ImageAnalyzer()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        MainTabView()
            .environmentObject(recipeManager)
            .environmentObject(imageAnalyzer)
            .preferredColorScheme(isDarkMode ? .dark : .light) // This enables dark mode
            .onAppear {
                // Debug model loading when app starts
                print("📱 [APP] ContentView appeared - starting model validation")
                imageAnalyzer.validateModel()
                
                // Print app bundle info for debugging
                if let bundlePath = Bundle.main.resourcePath {
                    print("📂 [APP] Bundle path: \(bundlePath)")
                }
                
                print("📋 [APP] Available ML models in bundle:")
                if let bundleURL = Bundle.main.resourceURL {
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil)
                        for url in contents {
                            let fileName = url.lastPathComponent
                            if fileName.contains("ml") || fileName.lowercased().contains("model") {
                                print("   🤖 [APP] Found model file: \(fileName)")
                            }
                        }
                    } catch {
                        print("❌ [APP] Could not list bundle contents: \(error)")
                    }
                }
            }
    }
}

               

#Preview {
    ContentView()
}
