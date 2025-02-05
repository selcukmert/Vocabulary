//
//  VocabEasyApp.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 26.01.2025.
//

import SwiftUI
import Firebase

@main
struct VocabEasyApp: App {
    @StateObject private var viewModel = WordViewModel()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewModel)
        }
    }
}

