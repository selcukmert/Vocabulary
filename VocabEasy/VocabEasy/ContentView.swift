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
        FlashcardView()
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
