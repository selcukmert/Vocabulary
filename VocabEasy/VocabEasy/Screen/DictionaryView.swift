//
//  MyLearningsView.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 3.02.2025.
//
import SwiftUI

struct DictionaryView: View {
    @StateObject private var viewModel = WordViewModel()
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        NavigationView {
            VStack {
                Text("Dictionary")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.black)

                TextField("Search word...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isSearchFocused)
                    .onChange(of: searchText) { newValue in
                        viewModel.search(query: newValue)
                    }

                if !viewModel.filteredWords.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.filteredWords.sorted(by: { $0.key < $1.key }), id: \.key) { word in
                                VStack(alignment: .leading) {
                                    Text(word.key)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text(word.value)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color.myMint)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text(searchText.count >= 3 ? "No results found." : "")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            }
            .onAppear { viewModel.loadDictionary() }
            .padding(5)
            .background(Color.white)
            .onTapGesture {
                isSearchFocused = false
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.light)
    }
}
