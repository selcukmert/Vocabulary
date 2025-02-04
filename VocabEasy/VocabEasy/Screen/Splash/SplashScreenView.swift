//
//  SplashScreenView.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 3.02.2025.
//
import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @EnvironmentObject var viewModel: WordViewModel

    var body: some View {
        if isActive {
            ContentView()
                .environmentObject(viewModel)
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.mint, Color(hex: "#B0D5D8")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    LottieView(animationName: "loadingAnimation")
                        .frame(width: 150, height: 150)
                    
                    Text("VocabEasy")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
