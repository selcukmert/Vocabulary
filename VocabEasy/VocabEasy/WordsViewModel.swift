//
//  WordsViewModel.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 27.01.2025.
//

import Foundation

class WordViewModel: ObservableObject {
    @Published var words: [Word] = []
    @Published var currentWordIndex: Int = 0
    @Published var isLoading: Bool = false

    init() {
        loadWordsFromFirebase()
    }

    func loadWordsFromFirebase() {
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/cu2vw-12083.appspot.com/o/words.json?alt=media&token=49ffc997-93e5-4129-a14e-f0d971baad06") else {
            print("Invalid URL")
            return
        }

        isLoading = true
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                print("Failed to fetch data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedWords = try JSONDecoder().decode([Word].self, from: data)
                DispatchQueue.main.async {
                    self.words = decodedWords
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func nextWord() {
        if !words.isEmpty {
            currentWordIndex = (currentWordIndex + 1) % words.count
        }
    }

    func getCurrentWord() -> Word? {
        guard !words.isEmpty else { return nil }
        return words[currentWordIndex]
    }
}
