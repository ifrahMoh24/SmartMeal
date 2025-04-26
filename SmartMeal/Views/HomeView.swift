import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("SmartMeal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                NavigationLink(destination: Text("ScanView Placeholder")) {
                    Text("Scan Ingredients")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

