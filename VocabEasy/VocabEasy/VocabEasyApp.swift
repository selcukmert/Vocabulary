//
//  VocabEasyApp.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 26.01.2025.
//

import SwiftUI

@main
struct VocabEasyApp: App {
    @StateObject private var viewModel = WordViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
