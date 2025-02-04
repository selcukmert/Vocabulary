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
                        Text("Flashcards")
                    }
                
                DictionaryView()
                    .tabItem {
                        Image(systemName: "graduationcap.fill")
                        Text("Dictionary")
                    }
            }
            .tint(Color(hex: "60a4a8"))
            
            if !keyboard.isKeyboardVisible { // Klavye açıldığında gizle
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: -3)
                        .padding(.bottom, 55)
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
