//
//  FlipCardView.swift
//  VocabEasy
//
//  Created by Mert Selçuk on 27.01.2025.
//

import SwiftUI

struct FlipCardView: View {
    let word: Word
    @State private var isFlipped = false
    @EnvironmentObject private var viewModel: WordViewModel

    var body: some View {
        ZStack {
            // Ana kart yapısı
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 300, height: 200)
                    .shadow(radius: 4)

                VStack {
                    Spacer()
                    
                    Text(isFlipped ? word.meaning : word.word)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        let textToSpeak = isFlipped ? word.meaning : word.word
                        let language = isFlipped ? "tr-TR" : "en-US"
                        viewModel.speak(text: textToSpeak, language: language)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: "60a4a8"))
                            .padding()
                    }
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    
                    Spacer()
                }
            }
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            
            // Favori butonu ayrı bir katmanda
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.toggleFavorite(word)
                    }) {
                        Image(systemName: viewModel.isFavorite(word) ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite(word) ? .red : Color(hex: "60a4a8"))
                            .font(.system(size: 22))
                    }
                }
                .padding([.top, .trailing], 16)
                Spacer()
            }
            .frame(width: 300, height: 200)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                isFlipped.toggle()
            }
        }
    }
}



