//
//  MovieSearchViewModel.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MovieSearchViewModel: ObservableObject {
    
    var page = 1
    @Published var isEnd = false
    @Published var query = ""
    @Published var results = [Movie]()
    @Published private(set) var phase: DataFetchPhase<[Movie]> = .empty
    
    private var cancellables = Set<AnyCancellable>()
    private let movieService: MovieService
    
    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
        self.phase = .empty
    }
    
    func startObserve() {
        guard cancellables.isEmpty else { return }
        
        $query
            .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.page = 1
                self.results = []
                self.phase = .empty
            }
            .store(in: &cancellables)
        
        $query
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { query in
                Task { [weak self] in
                    guard let self = self else { return }
                    self.page = 1
                    self.results = []
                    self.phase = .empty
                    await self.search(query: query)
                }
            }
            .store(in: &cancellables)
    }

    
    func search(query: String) async {
        if Task.isCancelled {
            return
        }
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else { return }
        
        do {
            let list = try await movieService.searchMovie(query: trimmedQuery, page: page)
            self.isEnd = list.page >= list.totalPages
            self.results.append(contentsOf: list.results)
            self.page += 1
            if Task.isCancelled {
                return
            }
            guard trimmedQuery == self.trimmedQuery else { return }
            phase = .success(list.results)
        } catch {
            if Task.isCancelled {
                return
            }
            guard trimmedQuery == self.trimmedQuery else { return }
            phase = .failure(error)
        }
    }
    
    func next(result: Movie) async {
        if results.count >= 4, result == results[results.count - 3] {
            await search(query: query)
        }
    }
}
