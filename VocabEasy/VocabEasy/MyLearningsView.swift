//
//  MyLearningsView.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 3.02.2025.
//
import SwiftUI

struct MyLearningsView: View {
    @StateObject private var viewModel = WordViewModel()
    
    var body: some View {
        VStack {
            Text("My Learnings")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}
