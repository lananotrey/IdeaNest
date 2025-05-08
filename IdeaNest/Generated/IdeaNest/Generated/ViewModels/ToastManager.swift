import SwiftUI

@MainActor
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isShowing = false
    @Published var message = ""
    @Published var type: ToastType = .success
    
    enum ToastType {
        case success
        case error
        
        var backgroundColor: Color {
            switch self {
            case .success:
                return .green
            case .error:
                return .red
            }
        }
        
        var icon: String {
            switch self {
            case .success:
                return "checkmark.circle.fill"
            case .error:
                return "xmark.circle.fill"
            }
        }
    }
    
    private init() {}
    
    func show(message: String, type: ToastType = .success) {
        self.message = message
        self.type = type
        withAnimation {
            self.isShowing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}