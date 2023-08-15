//
//  FavoriteView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/13.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 200)), count: 1), spacing: 10) {
                    ForEach(viewModel.results) { favorite in
                        NavigationLink(destination: MovieDetailView(movieId: favorite.movieId, movieTitle: favorite.title)) {
                            MovieThumbnailView(movie: favorite.toMovie(), titleFontSize: 30, overviewFontSize: 20, dateFontSize: 15)
                                .aspectRatio(1, contentMode: .fill)
                     
                        }
                        .buttonStyle(.plain)
                    }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
        }
        .overlay(overlayView)
        .onAppear {
            Task {
                await viewModel.fetchFavorites()
            }
        }
        .navigationTitle("Favorites")
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
        case .empty:
                EmptyPlaceholderView(text: "You can add your favorite movie from movie detail page", image: Image(systemName: "heart"))
        case .success(let values) where values.isEmpty: EmptyView()
        case .failure(_): EmptyView()
        default: EmptyView()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoriteView()
        }
    }
}
