//
//  MovieDetailView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movieId: Int
    let movieTitle: String
    @StateObject private var viewModel = MovieDetailViewModel()
    
    var body: some View {
        List {
            if let movie = viewModel.movie {
                MovieDetailImage(imageURL: movie.backdropURL)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                
                MovieDetailListView(movie: movie)
            }
        }
        .listStyle(.plain)
        .overlay(DataFetchPhaseOverlayView(
            phase: viewModel.phase, skeleton: AnyView(SkeletonView()),
            retryAction: loadMovie)
        ).onAppear {
            loadMovie()
        }
        .navigationTitle(movieTitle)
        .toolbar {
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart").foregroundColor(.red)
            }
        }
    }
    
    @ViewBuilder
    func SkeletonView() -> some View {
        List {
            MovieDetailImage(imageURL: URL(string: "https://")!)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            
            MovieDetailListView(movie: Movie.stubbedMovie)
        }.redacted(reason: .placeholder)
    }
    
    private func loadMovie() {
        Task { await self.viewModel.loadMovie(id: self.movieId) }
    }
}

struct MovieDetailListView: View {
    
    let movie: Movie
    
    var body: some View {
        movieDescriptionSection.listRowSeparator(.visible)
        movieCastSection.listRowSeparator(.hidden)
    }
    
    private var movieDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(movieGenreYearDurationText)
                .font(.headline)
            Text(movie.overview)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundColor(.yellow)
                }
                Text(movie.scoreText)
            }
        }
        .padding(.vertical)
    }
    
    private var movieCastSection: some View {
        HStack(alignment: .top, spacing: 4) {
            if let cast = movie.cast, !cast.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Starring").font(.headline)
                    ForEach(cast.prefix(9)) { Text($0.name) }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                
            }
            
            if let crew = movie.crew, !crew.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    if let directors = movie.directors, !directors.isEmpty {
                        Text("Director(s)").font(.headline)
                        ForEach(directors.prefix(2)) { Text($0.name) }
                    }
                    
                    if let producers = movie.producers, !producers.isEmpty {
                        Text("Producer(s)").font(.headline)
                            .padding(.top)
                        ForEach(producers.prefix(2)) { Text($0.name) }
                    }
                    
                    if let screenwriters = movie.screenWriters, !screenwriters.isEmpty {
                        Text("Screenwriter(s)").font(.headline)
                            .padding(.top)
                        ForEach(screenwriters.prefix(2)) { Text($0.name) }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical)
    }
    
    private var movieGenreYearDurationText: String {
        "\(movie.genreText) · \(movie.yearText) · \(movie.durationText)"
    }
}

struct MovieDetailImage: View {
    
    @StateObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear { imageLoader.loadImage(with: imageURL) }
    }
}

extension URL: Identifiable {
    
    public var id: Self { self }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movieId: Movie.stubbedMovie.id, movieTitle: Movie.stubbedMovie.title)
        }
    }
}
