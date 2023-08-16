//
//  NowPlayingView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/13.
//

import SwiftUI

struct NowPlayingView: View {
    
    @StateObject private var viewModel: NowPlayingViewModel
    @State private var showMovieSearch = false
    
    init() {
        self._viewModel = StateObject<NowPlayingViewModel>(wrappedValue: .init())
    }
        
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Section(footer: Footer()) {
                LazyVGrid(columns: viewModel.colums, spacing: 10) {
                    ForEach(viewModel.results) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id, movieTitle: movie.title)) {
                            
                            MovieThumbnailView(
                                movie: movie,
                                titleFontSize: viewModel.titleFontSize,
                                overviewFontSize: viewModel.overviewFontSize,
                                dateFontSize: viewModel.dateFontSize
                            ).aspectRatio(viewModel.ratio, contentMode: .fill)
                            .accessibilityIdentifier("item_\(movie.id)")
                            
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            if viewModel.fetchStatus != .END{
                                DispatchQueue.global(qos: .userInitiated).async {
                                    Task {
                                        await viewModel.next(result: movie)
                                    }
                                }
                            }
                        }
                    }
                }
                .accessibilityIdentifier("now_playing_grid")
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
        }
        .refreshable {
            viewModel.refreshMovies()
        }
        .overlay(overlayView)
        .navigationTitle("Now Playing")
        .toolbar {
            searchButton
        }
        .fullScreenCover(isPresented: $showMovieSearch) {
            NavigationView {
                MovieSearchView()
            }
        }.onAppear {
            viewModel.resortingMovies()
        }
    }
        
    @ViewBuilder
    func Footer() -> some View {
        if case .END = viewModel.fetchStatus {
            Text("End")
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
        case .empty:
            SkeletonView()
        case .success(let values) where values.isEmpty:
            EmptyPlaceholderView(text: "No results", image: Image(systemName: "film"))
        case .failure(let values, let error) where values.isEmpty:
            RetryView(text: error.localizedDescription, retryAction: {
                viewModel.refreshMovies()
            })
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func SkeletonView() -> some View {
        ScrollView([], showsIndicators: false) {
            LazyVGrid(columns: viewModel.colums, spacing: 10) {
                ForEach(1...16, id: \.self) { _ in
                    MovieThumbnailView(
                        movie: Movie.stubbedMovie,
                        titleFontSize: viewModel.titleFontSize,
                        overviewFontSize: viewModel.overviewFontSize,
                        dateFontSize: viewModel.dateFontSize
                    ).aspectRatio(viewModel.ratio, contentMode: .fill)
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
        }
    }
}

extension NowPlayingView {
    var searchButton: some View {
        Button(action: {
            self.showMovieSearch = true
        }) {
            Image(systemName: "magnifyingglass")
        }
        .accessibilityIdentifier("now_play_search_btn")
    }
}

extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            NavigationView {
                NowPlayingView()
            }.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro")) .previewDisplayName("iPhone 12 Pro Portrait")
            
            NavigationView {
                NowPlayingView()
            }.navigationViewStyle(StackNavigationViewStyle()).previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
                .previewDisplayName("iPad Air")
            
            NavigationView {
                NowPlayingView()
            }.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro")) .previewDisplayName("iPhone 12 Pro") .previewInterfaceOrientation(.landscapeRight)
        }
        
    }
}

