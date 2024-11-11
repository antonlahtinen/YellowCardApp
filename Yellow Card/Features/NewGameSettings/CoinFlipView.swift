import SwiftUI

struct CoinFlipView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isFlipping = false
    @State private var rotation: Double = 0
    @State private var result: String?
    @State private var showResult = false
    
    let homeTeam: String
    let awayTeam: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.black]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                
                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "soccerball.inverse")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.2)
                            .foregroundColor(.white)
                        
                        Text("Determine Who Starts")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text("Tap the question mark")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    // Coin Animation
                    ZStack {
                        
                        Image(systemName: showResult ? (result == homeTeam ? "house.fill" : "airplane") : "questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.2)
                            .rotation3DEffect(
                                .degrees(rotation),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                            .contentTransition(.symbolEffect(.replace))
                            .animation(.easeInOut(duration: 1), value: rotation)
                    }
                    .onTapGesture {
                        flipCoin()
                    }
                    .padding(.vertical)
                    
                    // Result and Done Button
                    VStack(spacing: 20) {
                        // Result Text
                        if showResult {
                            Text("\(result ?? "") starts!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .transition(.opacity)
                        }
                        
                        // Done Button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                        .opacity(showResult ? 1 : 0)
                        .animation(.easeIn(duration: 0.5), value: showResult)
                    }
                    .padding(.bottom, 40)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
            }
            
        }
    }
    
    private func flipCoin() {
        guard !isFlipping else { return }
        
        isFlipping = true
        showResult = false
        result = Bool.random() ? homeTeam : awayTeam
        
        // Animate coin flip
        withAnimation(Animation.easeInOut(duration: 1)) {
            rotation += 1080
        }
        
        // Show result after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showResult = true
            isFlipping = false
        }
    }
}

#Preview {
    CoinFlipView(homeTeam: "Arsenal", awayTeam: "Chelsea")
}
