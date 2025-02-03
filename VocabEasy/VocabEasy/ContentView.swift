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
        ZStack(alignment: .bottom) {
            TabView {
                FlashcardView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                MyLearningsView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("My Learnings")
                    }
            }.tint(Color(hex: "60a4a8"))
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(height: 0.5)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: -3)
                    .padding(.bottom, 55)
            }
            .preferredColorScheme(.light)
            .allowsHitTesting(false)
        }
    }
}

func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowImage = UIImage()
    appearance.backgroundEffect = UIBlurEffect(style: .light)
    
    // Üst kısmına gölge ekleyelim
    appearance.backgroundColor = UIColor.white
    appearance.shadowColor = UIColor.black.withAlphaComponent(0.3) // Hafif gölge
    appearance.shadowImage = UIImage() // Shadow için

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}

struct FlashcardView: View {
    @EnvironmentObject var viewModel: WordViewModel

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Color(hex: "60a4a8")
                    .ignoresSafeArea(edges: .top)

                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .offset(y: UIScreen.main.bounds.height * 0.32)

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("60a4a8")))
                        .font(.headline)
                        .foregroundColor(.mint)
                } else {
                    VStack {
                        Spacer()

                        if let currentWord = viewModel.getCurrentWord() {
                            FlipCardView(word: currentWord)
                                .environmentObject(viewModel)
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
                                        .background(viewModel.isRandom || viewModel.currentWordIndex == 0 ? Color.gray : Color(hex: "60a4a8"))
                                        .foregroundColor(viewModel.isRandom || viewModel.currentWordIndex == 0 ? Color.white.opacity(0.6) : Color.white)
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
                                        .background(Color(hex: "60a4a8"))
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
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "60a4a8")))
                            }
                        } else {
                            Text("No words available")
                                .font(.title)
                                .foregroundColor(.black)
                        }

                        Spacer()
                    }
                }
            }
        }
        .environmentObject(viewModel)
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
                    .foregroundColor(Color(hex: "60a4a8"))
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
