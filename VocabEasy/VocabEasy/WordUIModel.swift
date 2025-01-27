//
//  WordUIModel.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 27.01.2025.
//

import Foundation

struct Word: Codable, Identifiable {
    let id = UUID()
    let word: String
    let meaning: String

    private enum CodingKeys: String, CodingKey {
        case word, meaning
    }
}
