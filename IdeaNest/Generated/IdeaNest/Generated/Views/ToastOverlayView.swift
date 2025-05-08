import SwiftUI

struct ToastOverlayView: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            if toastManager.isShowing {
                VStack {
                    Spacer()
                    HStack(spacing: 12) {
                        Image(systemName: toastManager.type.icon)
                            .foregroundColor(.white)
                        Text(toastManager.message)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(toastManager.type.backgroundColor)
                            .opacity(0.95)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
}