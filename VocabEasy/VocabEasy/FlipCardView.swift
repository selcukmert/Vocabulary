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

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: 300, height: 200)
                .shadow(radius: 4)

            if isFlipped {
                Text(word.meaning)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(16)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                Text(word.word)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(16)
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                isFlipped.toggle()
            }
        }
    }
}
