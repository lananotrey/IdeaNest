import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Use")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    Text("Last updated: \(Date().formatted(date: .long, time: .omitted))")
                        .foregroundColor(.secondary)
                    
                    Text("Acceptance of Terms")
                        .font(.headline)
                    Text("By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.")
                    
                    Text("Use License")
                        .font(.headline)
                    Text("Permission is granted to temporarily download one copy of the application for personal, non-commercial transitory viewing only.")
                    
                    Text("Disclaimer")
                        .font(.headline)
                    Text("The materials within this application are provided on an 'as is' basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.")
                    
                    Text("Limitations")
                        .font(.headline)
                    Text("In no event shall we or our suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on our application.")
                }
                .padding(.bottom, 5)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}