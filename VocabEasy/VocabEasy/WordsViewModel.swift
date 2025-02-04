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
    @Published var filteredWords: [(key: String, value: String)] = []
    private var searchCancellable: AnyCancellable?
    @Published var words: [Word] = []
    @Published var currentWordIndex: Int = 0 {
        didSet {
            saveCurrentWordIndex()
        }
    }
    @Published var isLoading: Bool = false
    @Published var isRandom: Bool = false
    private var speechSynthesizer = AVSpeechSynthesizer()

    init() {
        loadSavedWordIndex()
        loadWordsFromLocalJSON()
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
            if let url = Bundle.main.url(forResource: "dictionary", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    dicWords = try JSONDecoder().decode([String: String].self, from: data)
                } catch {
                    print("Error loading dictionary: \(error)")
                }
            } else {
                print("⚠️ dictionary.json not found in bundle!")
            }
        }
        
    func search(query: String) {
            searchCancellable?.cancel()
            
            guard query.count >= 3 else {
                DispatchQueue.main.async {
                    self.filteredWords = []
                }
                return
            }
        
        let filtered = self.dicWords
            .filter { $0.key.lowercased().contains(query.lowercased()) }
            .map { ($0.key, $0.value) }
        filteredWords = filtered
        
    }
}
