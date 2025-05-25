import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
            .environmentObject(RecipeManager())
            .environmentObject(ImageAnalyzer())
    }
}

#Preview {
    ContentView()
}
