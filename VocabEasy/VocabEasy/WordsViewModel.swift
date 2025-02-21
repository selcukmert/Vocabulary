//
//  WordsViewModel.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 27.01.2025.
//

import Foundation
import AVFoundation
import Combine

class WordViewModel: ObservableObject {
    @Published var dicWords: [String: String] = [:]
    @Published var filteredWords: [String: String] = [:]
    private var searchCancellable: AnyCancellable?
    @Published var words: [Word] = []
    @Published var currentWordIndex: Int = 0 {
        didSet {
            saveCurrentWordIndex()
        }
    }
    @Published var isLoading: Bool = false
    @Published var isRandom: Bool = false
    @Published private(set) var favoriteWords: [Word] = []
    private var speechSynthesizer = AVSpeechSynthesizer()

    init() {
        loadWordsFromLocalJSON()
        loadFavorites()
        loadSavedWordIndex()
    }

    func loadWordsFromLocalJSON() {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
            print("❌ words.json bulunamadı!")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedWords = try JSONDecoder().decode([Word].self, from: data)
            DispatchQueue.main.async {
                self.words = decodedWords
            }
        } catch {
            print("❌ JSON okunurken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    func saveCurrentWordIndex() {
        UserDefaults.standard.set(currentWordIndex, forKey: "LastWordIndex")
    }

    func loadSavedWordIndex() {
        currentWordIndex = UserDefaults.standard.integer(forKey: "LastWordIndex")
    }

    func nextWord() {
        if isRandom {
            currentWordIndex = Int.random(in: 0..<words.count)
        } else {
            if !words.isEmpty {
                currentWordIndex = (currentWordIndex + 1) % words.count
            }
        }
    }

    func previousWord() {
        if !isRandom {
            if !words.isEmpty && currentWordIndex > 0 {
                currentWordIndex -= 1
            }
        }
    }
    
    func resetToFirstWord() {
        currentWordIndex = 0
        isRandom = false
        saveCurrentWordIndex()
    }

    func getCurrentWord() -> Word? {
        guard !words.isEmpty else { return nil }
        return words[currentWordIndex]
    }
    
    func speak(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }

    func loadDictionary() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "dictionary", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let json = try? JSONDecoder().decode([String: String].self, from: data) {
                DispatchQueue.main.async {
                    self.dicWords = json
                }
            }
        }
    }

    func search(query: String) {
        guard query.count >= 3 else {
            DispatchQueue.main.async { self.filteredWords = [:] }
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let results = self.dicWords.filter { $0.key.localizedCaseInsensitiveContains(query) }
            DispatchQueue.main.async {
                self.filteredWords = results
            }
        }
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.data(forKey: "FavoriteWords"),
           let decodedFavorites = try? JSONDecoder().decode([Word].self, from: savedFavorites) {
            favoriteWords = decodedFavorites
            
            // Ana listedeki kelimelerin favori durumlarını güncelle
            for (index, word) in words.enumerated() {
                if favoriteWords.contains(where: { $0.word == word.word }) {
                    words[index].isFavorite = true
                }
            }
        }
    }
    
    func toggleFavorite(_ word: Word) {
        // Önce favorilerde olup olmadığını kontrol et
        if let existingIndex = favoriteWords.firstIndex(where: { $0.word == word.word }) {
            // Favorilerden çıkar
            favoriteWords.remove(at: existingIndex)
            
            // Ana listedeki durumu güncelle
            if let mainIndex = words.firstIndex(where: { $0.word == word.word }) {
                words[mainIndex].isFavorite = false
            }
        } else {
            // Favorilere ekle
            var updatedWord = word
            updatedWord.isFavorite = true
            favoriteWords.append(updatedWord)
            
            // Ana listedeki durumu güncelle
            if let mainIndex = words.firstIndex(where: { $0.word == word.word }) {
                words[mainIndex].isFavorite = true
            }
        }
        
        saveFavorites()
        objectWillChange.send()
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteWords) {
            UserDefaults.standard.set(encoded, forKey: "FavoriteWords")
        }
    }

    func isFavorite(_ word: Word) -> Bool {
        // Sadece kelime eşleşmesine bak
        return favoriteWords.contains(where: { $0.word == word.word })
    }
}
