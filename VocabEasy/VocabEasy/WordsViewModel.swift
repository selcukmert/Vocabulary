//
//  WordsViewModel.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 27.01.2025.
//

import Foundation
import AVFoundation

class WordViewModel: ObservableObject {
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
        loadSavedWordIndex() // Son pozisyonu yükle
        loadWordsFromFirebase()
    }

    func loadWordsFromFirebase() {
        guard let url = getFirebaseURL() else {
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

    func getFirebaseToken() -> String? {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "FirebaseToken") as? String else {
            print("Firebase token not found in Info.plist")
            return nil
        }
        return token
    }

    func getFirebaseURL() -> URL? {
        let baseURL = "https://firebasestorage.googleapis.com/v0/b/cu2vw-12083.appspot.com/o/words.json?alt=media&token="
        if let token = getFirebaseToken() {
            return URL(string: baseURL + token)
        }
        return nil
    }
    
    func speak(text: String, language: String) {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            utterance.rate = 0.5

            speechSynthesizer.speak(utterance)
        }
}
