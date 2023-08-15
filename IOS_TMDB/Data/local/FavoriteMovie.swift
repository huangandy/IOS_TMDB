//
//  Favorite.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/14.
//
import Foundation
import RealmSwift

class FavoriteMovie: Object, Identifiable {

    @Persisted(primaryKey: true) var _id: String = UUID().uuidString {
        didSet {
            if _id.isEmpty { _id = UUID().uuidString }
        }
    }
    @Persisted  var movieId: Int
    @Persisted  var title: String
    @Persisted  var releaseDate: String
    @Persisted  var overview: String
    @Persisted  var backdropPath: String?
    
}

struct FavoriteMovieList {
    let page: Int
    let totalPages: Int
    let results: [FavoriteMovie]
}

extension FavoriteMovie {
    func toMovie() -> Movie {
        return Movie(id: self.movieId, title: self.title, backdropPath: self.backdropPath, overview: self.overview, voteAverage: 0, voteCount: 0, runtime: nil, releaseDate: self.releaseDate, genres: nil, credits: nil, videos: nil)
    }
}
