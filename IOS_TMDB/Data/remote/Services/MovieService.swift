//
//  MovieService.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import Foundation

protocol MovieService {

    func fetchMovies(from endpoint: MovieListEndpoint, page: Int) async throws -> MovieList
    func fetchMovie(id: Int) async throws -> Movie
    func searchMovie(query: String, page: Int) async throws -> MovieList
}

enum MovieListEndpoint: String, CaseIterable, Identifiable {
    
    var id: String { rawValue }
    
    case nowPlaying = "now_playing"
    
    var description: String {
        switch self {
            case .nowPlaying: return "Now Playing"
        }
    }
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
