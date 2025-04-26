import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
           

            VStack(spacing: 30) {
                Spacer()

                Text("Help your path to health goals with happiness")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                Button(action: {
                    // Handle login action
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Button(action: {
                    // Handle create account action
                }) {
                    Text("Create New Account")
                        .foregroundColor(.white)
                        .underline()
                }

                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
