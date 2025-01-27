//
//  ContentView.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 26.01.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WordViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.blue
                    .ignoresSafeArea(edges: .top)

                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .offset(y: UIScreen.main.bounds.height * 0.4)

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .font(.headline)
                        .foregroundColor(.blue)
                } else {
                    VStack {
                        Spacer()

                        if let currentWord = viewModel.getCurrentWord() {
                            FlipCardView(word: currentWord)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                            Text("\(viewModel.currentWordIndex + 1) / \(viewModel.words.count)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .padding(.top, 8)

                            Button(action: {
                                withAnimation {
                                    viewModel.nextWord()
                                }
                            }) {
                                Text("Next Word")
                                    .font(.headline)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                
                                    .cornerRadius(15)
                            }
                            .padding(.top, 16)
                        } else {
                            Text("No words available")
                                .font(.title)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
