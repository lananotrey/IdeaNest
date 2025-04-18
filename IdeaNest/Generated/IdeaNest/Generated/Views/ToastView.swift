import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.purple.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.top, 60)
    }
}