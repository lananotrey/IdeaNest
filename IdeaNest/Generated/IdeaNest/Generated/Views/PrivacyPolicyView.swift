import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    Text("Last updated: \(Date().formatted(.dateTime.day().month().year()))")
                        .foregroundColor(.secondary)
                    
                    Text("Information Collection and Use")
                        .font(.headline)
                    Text("We collect several different types of information for various purposes to provide and improve our Service to you.")
                    
                    Text("Types of Data Collected")
                        .font(.headline)
                    Text("Personal Data")
                        .font(.subheadline)
                        .bold()
                    Text("While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to:")
                    
                    HStack {
                        Text("•")
                        Text("Your name")
                    }
                    HStack {
                        Text("•")
                        Text("Usage data")
                    }
                    
                    Text("Security")
                        .font(.headline)
                    Text("The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure.")
                    
                    Text("Changes to This Privacy Policy")
                        .font(.headline)
                    Text("We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.")
                }
                .padding(.bottom, 5)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}