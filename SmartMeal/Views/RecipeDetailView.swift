import SwiftUI

struct RecipeDetailView: View {
    let recipeName: String

    var body: some View {
        VStack(spacing: 20) {
            Text(recipeName)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Recipe details will go here.")
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
