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
        VStack(spacing: 16) {
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

                            HStack {
                                Button(action: {
                                    withAnimation {
                                        viewModel.previousWord()
                                    }
                                }) {
                                    Text("Previous Word")
                                        .font(.headline)
                                        .padding()
                                        .frame(width: 150)
                                        .background(viewModel.isRandom || viewModel.currentWordIndex == 0 ? Color.gray : Color.blue)
                                                    .foregroundColor(viewModel.isRandom || viewModel.currentWordIndex == 0 ? Color.white.opacity(0.6) : Color.white)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                                .disabled(viewModel.isRandom || viewModel.currentWordIndex == 0)

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
                            }
                            .padding(.top, 16)

                            HStack {
                                Text(viewModel.isRandom ? "Random Word" : "Ordered Word")
                                    .foregroundColor(.black)
                                
                                Toggle("", isOn: $viewModel.isRandom)
                                    .labelsHidden()
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
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
        .overlay(
                    Button(action: {
                        withAnimation {
                            viewModel.resetToFirstWord()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                )
    }
}


#Preview {
    ContentView()
}
