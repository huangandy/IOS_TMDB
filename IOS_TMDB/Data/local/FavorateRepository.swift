//
//  FavorateRepository.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/14.
//

import Foundation

protocol FavoriteAPI {

    func addFavorite(movie: Movie)
    func getAllFavorites() -> [FavoriteMovie]
    func deleteFavorite(movie: Movie)
    func updateFavorite(movie: Movie)
    func isFavorite(movie: Movie) -> Bool
}

class FavoriteRepository: FavoriteAPI {
    
    static let shared = FavoriteRepository()
    
    private init() {}
    
    func isFavorite(movie: Movie) -> Bool {
        return !RealmHelper.shared.realm.objects(FavoriteMovie.self).filter { $0.movieId == movie.id }.isEmpty
    }
    
    func addFavorite(movie: Movie) {
        let favorite = FavoriteMovie()
        favorite.movieId = movie.id
        favorite.title = movie.title
        favorite.releaseDate = movie.releaseDate ?? ""
        favorite.overview = movie.overview
        favorite.backdropPath = movie.backdropPath
        RealmHelper.shared.addOrUpdateObject(favorite)
    }
    
    func getAllFavorites() -> [FavoriteMovie] {
        return Array(RealmHelper.shared.getAllObjects(type: FavoriteMovie.self))
    }
    
    func deleteFavorite(movie: Movie) {
        let favorite = RealmHelper.shared.realm.objects(FavoriteMovie.self)
            .filter {
                $0.movieId == movie.id
            }
        RealmHelper.shared.deleteObject(favorite.first)
    }
    
    func updateFavorite(movie: Movie) {
        let favorites = Array(RealmHelper.shared.realm.objects(FavoriteMovie.self)
            .filter {
                $0.movieId == movie.id
            })
        if let favorite = favorites.first {
            try! RealmHelper.shared.realm.write {
                favorite.movieId = movie.id
                favorite.title = movie.title
                favorite.releaseDate = movie.releaseDate ?? ""
                favorite.overview = movie.overview
                favorite.backdropPath = movie.backdropPath
            }
        }
    }
}
