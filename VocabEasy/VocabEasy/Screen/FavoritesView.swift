import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var viewModel: WordViewModel
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Favorites")
                    .font(.largeTitle)
                    .padding(.top)
                
                if viewModel.favoriteWords.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No Favorite Words")
                            .font(.title2)
                            .foregroundColor(.black)
                        
                        Text("You haven't added any words to your favorites yet")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.favoriteWords) { word in
                                VStack(alignment: .leading) {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading) {
                                            Text(word.word)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text(word.meaning)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(2)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.toggleFavorite(word)
                                        }) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                }
            }
            .background(Color.white)
        }
        .preferredColorScheme(.light)
    }
} 