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
        GeometryReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                Section(footer: footer()) {
                    LazyVGrid(columns: viewModel.colums, spacing: 10) {
                        ForEach(viewModel.results) { movie in
                            
                            NavigationLink(destination: MovieDetailView(movieId: movie.id, movieTitle: movie.title)) {
                                
                                MovieThumbnailView(
                                    movie: movie,
                                    titleFontSize: viewModel.titleFontSize,
                                    overviewFontSize: viewModel.overviewFontSize,
                                    dateFontSize: viewModel.dateFontSize
                                ).aspectRatio(viewModel.ratio, contentMode: .fill)
                                
                            }
                            .buttonStyle(.plain)
                            .onAppear {
                                if !viewModel.isEnd {
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        Task {
                                            await viewModel.next(result: movie)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
            }
        }
        .overlay(overlayView)
        .navigationTitle("Now Playing")
        .toolbar {
            Button(action: {
                self.showMovieSearch = true
            }) {
                Image(systemName: "magnifyingglass")
            }
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
    func footer() -> some View {
        if viewModel.isEnd {
            Text("End")
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
            
        case .empty:
            ProgressView()
        case .success(let values) where values.isEmpty:
            EmptyPlaceholderView(text: "No results", image: Image(systemName: "film"))
        case .failure(let values, let error) where values.isEmpty:
            RetryView(text: error.localizedDescription, retryAction: {
                viewModel.refreshMovies()
            })
        default: EmptyView()
        }
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
