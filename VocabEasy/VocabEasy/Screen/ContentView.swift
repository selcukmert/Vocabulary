//
//  ContentView.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 26.01.2025.
//
import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = WordViewModel()
    @StateObject private var keyboard = KeyboardObserver()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                FlashcardView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Flash Cards")
                    }
                
                DictionaryView()
                    .tabItem {
                        Image(systemName: "text.book.closed.fill")
                        Text("Dictionary")
                    }
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
            }
            .tint(Color(hex: "60a4a8"))
            .onAppear {
                // Sadece deaktif tab item rengini ayarla
                UITabBar.appearance().unselectedItemTintColor = UIColor.gray.withAlphaComponent(0.5)
            }
            
            if !keyboard.isKeyboardVisible {
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: -3)
                        .padding(.bottom, 54)
                }
                .allowsHitTesting(false)
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            keyboard.startObserving()
        }
        .onDisappear {
            keyboard.stopObserving()
        }
    }
}

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        startObserving()
    }

    func startObserving() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { _ in self.isKeyboardVisible = true }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in self.isKeyboardVisible = false }
            .store(in: &cancellables)
    }

    func stopObserving() {
        cancellables.removeAll()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WordViewModel())
    }
}
