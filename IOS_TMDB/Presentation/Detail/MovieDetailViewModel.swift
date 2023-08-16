//
//  MovieDetailViewModel.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

@MainActor
class MovieDetailViewModel: ObservableObject {
    
    private let movieService: MovieService
    @Published private(set) var phase: DataFetchPhase<Movie?> = .empty
    @Published private(set) var isFavorite: Bool = false
    
    var movie: Movie? { phase.value ?? nil }
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) async {
        phase = .empty
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000) // Fake delay for demo skeleton
            let movie = try await self.movieService.fetchMovie(id: id)
            refreshFavorite(movie: movie)
            phase = .success(movie)
        } catch {
            phase = .failure(nil, error)
        }
    }
    
    func refreshFavorite(movie: Movie) {
        DispatchQueue.main.async {
            self.isFavorite = FavoriteRepository.shared.isFavorite(movie: movie)
            FavoriteRepository.shared.updateFavorite(movie: movie)
        }
    }

    
    func toggleFavorite() {
        if let target = self.movie {
            if isFavorite {
                FavoriteRepository.shared.deleteFavorite(movie: target)
            } else {
                FavoriteRepository.shared.addFavorite(movie: target)
            }
            isFavorite.toggle()
        }
    }
    
}
