//
//  FavoriteViewModel.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/14.
//

import Foundation


class FavoriteViewModel: ObservableObject {
    
    @Published var results = [FavoriteMovie]()
    @Published private(set) var phase: DataFetchPhase<[FavoriteMovie]> = .empty

    
    func fetchFavorites() async {
        DispatchQueue.main.async {
            self.results = FavoriteRepository.shared.getAllFavorites()
            if self.results.isEmpty {
                self.phase = .empty
            } else {
                self.phase = .success(self.results)
            }
        }
    }
    
}
