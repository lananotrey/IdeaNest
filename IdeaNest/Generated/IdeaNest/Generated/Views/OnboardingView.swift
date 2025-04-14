import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Capture Your Ideas",
            description: "Save and organize all your brilliant ideas in one place with easy-to-use cards",
            imageName: "lightbulb.fill",
            color: .purple
        ),
        OnboardingPage(
            title: "Quick Add & Share",
            description: "Quickly add new ideas and share them with others using our intuitive interface",
            imageName: "square.and.arrow.up.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Customize & Organize",
            description: "Personalize your ideas with icons, set durations, and keep everything organized",
            imageName: "slider.horizontal.3",
            color: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Image(systemName: pages[index].imageName)
                                .font(.system(size: 100))
                                .foregroundColor(pages[index].color)
                                .symbolEffect(.bounce, options: .repeating)
                            
                            Text(pages[index].title)
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                            
                            Text(pages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 32)
                        }
                        .tag(index)
                        .padding()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Button(action: {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                        } else {
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            showOnboarding = false
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(pages[currentPage].color)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}