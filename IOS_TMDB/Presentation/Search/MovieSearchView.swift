//
//  MovieSearchView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

struct MovieSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = MovieSearchViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 200)), count: 1), spacing: 10) {
                ForEach(viewModel.results) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id, movieTitle: movie.title)) {
                        MovieThumbnailView(movie: movie, titleFontSize: 30, overviewFontSize: 20, dateFontSize: 15)
                            .aspectRatio(1, contentMode: .fill)
                 
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
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
        }
        .searchable(text: $viewModel.query, prompt: String(localized: "search_movie"))
        .overlay(overlayView)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .onAppear {
            self.viewModel.startObserve()
        }
        .navigationBarTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: btnBack)
        
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
            
        case .empty:
            if viewModel.trimmedQuery.isEmpty {
                EmptyPlaceholderView(text: "Search your favorite movie", image: Image(systemName: "magnifyingglass"))
            } else {
                ProgressView()
            }
            
        case .success(let values) where values.isEmpty:
            EmptyPlaceholderView(text: "No results", image: Image(systemName: "film"))
            
        case .failure(_, let error):
            RetryView(text: error.localizedDescription, retryAction: {
                Task {
                    await viewModel.search(query: viewModel.query)
                }
            })
            
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func footer() -> some View {
        if viewModel.isEnd {
            Text("End")
        } else {
            ProgressView()
        }
    }
    
    private var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image(systemName: "xmark.circle")
                .aspectRatio(contentMode: .fit)
            }
        }
    }
}




struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieSearchView()
        }
    }
}
