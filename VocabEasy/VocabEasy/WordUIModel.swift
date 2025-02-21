//
//  WordUIModel.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 27.01.2025.
//

import Foundation

struct Word: Codable, Identifiable, Equatable {
    let id: UUID
    let word: String
    let meaning: String
    var isFavorite: Bool
    
    init(id: UUID = UUID(), word: String, meaning: String, isFavorite: Bool = false) {
        self.id = id
        self.word = word
        self.meaning = meaning
        self.isFavorite = isFavorite
    }

    // JSON'daki kelimeler için sadece word ve meaning kullanıyoruz
    private enum CodingKeys: String, CodingKey {
        case word, meaning
    }
    
    // JSON'dan decode ederken
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        word = try container.decode(String.self, forKey: .word)
        meaning = try container.decode(String.self, forKey: .meaning)
        id = UUID() // Her kelime için yeni bir ID
        isFavorite = false // Başlangıçta favori değil
    }
    
    // JSON'a encode ederken sadece word ve meaning
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(word, forKey: .word)
        try container.encode(meaning, forKey: .meaning)
    }
}
