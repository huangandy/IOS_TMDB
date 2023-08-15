//
//  PosterGridViewModel.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/13.
//

import Foundation
import SwiftUI

class NowPlayingViewModel: ObservableObject {

    private let movieService: MovieService = MovieStore.shared
    var page = 1
    var isFetching = false
    @Published var isEnd = false
    @Published var results = [Movie]()
    
    @AppStorage(UserDefaultKeys.layout.rawValue) private var layout = 0
    @AppStorage(UserDefaultKeys.sorting.rawValue) private var sorting = 0
    
    var colums: [GridItem] { Array(repeating: GridItem(.flexible()), count: LayoutType.layoutTypes.filter({ $0.tag == layout}).first?.column ?? 1)}
    var titleFontSize: CGFloat { LayoutType.layoutTypes.filter({ $0.tag == layout}).first?.titleFontSize ?? 30}
    var overviewFontSize: CGFloat { LayoutType.layoutTypes.filter({ $0.tag == layout}).first?.overviewFontSize ?? 20}
    var dateFontSize: CGFloat { LayoutType.layoutTypes.filter({ $0.tag == layout}).first?.dateFontSize ?? 15}
    
    var ratio: CGFloat { return LayoutType.layoutTypes.filter({ $0.tag == layout}).first?.ratio ?? 1 }
    private var sortKey: SortingType.SortKey {
        return SortingType.sortingTypes.filter({ $0.tag == sorting }).first?.sortKey ?? .Default
    }
    private var previousSortKey: SortingType.SortKey = .Default
    
    init() {
        Task {
            await self.fetchResults()
        }
    }
    
    
    func fetchResults() async{
        if !isFetching {
            isFetching.toggle()
            do {
                let list = try await movieService.fetchMovies(from: MovieListEndpoint.nowPlaying, page: self.page)
                DispatchQueue.main.async {
                    self.isEnd = list.page >= list.totalPages
                    self.results.append(contentsOf: list.results)
                    self.page += 1
                    self.sortMovies(sortKey: self.sortKey)
                }
                isFetching.toggle()
            } catch {
                isFetching.toggle()
            }
        }
    }
    

    func sortMovies(sortKey: SortingType.SortKey) {
        guard sortKey != .Default else { return }
        self.results = self.results.sorted(by: {
            switch sortKey {
            case .Title:
                return $0.title < $1.title
            case .ReleaseDate:
                return Utils.dateFormatter.date(from: $0.releaseDate ?? "1970-01-02")! > Utils.dateFormatter.date(from: $1.releaseDate ?? "1970-01-02")!
            case .Rating:
                return $0.voteAverage > $1.voteAverage
            default:
                return $0.title < $1.title
            }
        })
    }
    
    func refreshMovies() {
        guard previousSortKey != self.sortKey else { return }
        if self.sortKey == .Default {
            self.results = []
            self.page = 1
            self.isFetching = false
            Task {
                await self.fetchResults()
            }
        } else {
            DispatchQueue.main.async {
                self.sortMovies(sortKey: self.sortKey)
            }
        }
        previousSortKey = self.sortKey
    }
    
    func next(result: Movie) async {
        if results.count >= 4, result == results[results.count - 3] {
            await fetchResults()
        }
    }
}
