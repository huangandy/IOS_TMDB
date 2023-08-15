//
//  Movie+Stub.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import Foundation

extension Movie {
    
    static var stubbedMovies: MovieList {
        let response: MovieList? = try? Bundle.main.loadAndDecodeJSON(filename: "now_playing")
        return response!
    }
    
    static var stubbedMovie: Movie {
        stubbedMovies.results[0]
    }
    
}

extension Bundle {
    
    func loadAndDecodeJSON<D: Decodable>(filename: String) throws -> D? {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            print("not found")
            return nil
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = Utils.jsonDecoder
        let decodedModel = try jsonDecoder.decode(D.self, from: data)
        return decodedModel
    }
}

