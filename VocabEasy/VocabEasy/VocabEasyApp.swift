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
            SplashScreenView() // Uygulama açılışında SplashScreenView gösterilir
                .environmentObject(viewModel) // ViewModel'i tüm alt görünümlere ilet
        }
    }
}

