//
//  MoviePosterCard.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

struct MovieThumbnailView: View {
    
    let movie: Movie
    @StateObject var imageLoader = ImageLoader()
    let titleFontSize: CGFloat
    let overviewFontSize: CGFloat
    let dateFontSize: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Rectangle()
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(content: {
                    imageView
                })
                .clipped()
                .cornerRadius(8)
                .shadow(radius: 4)
            
            Text(movie.title)
                .font(.system(size: titleFontSize, design: .rounded))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
     
      
            Text(movie.overview)
                .font(.system(size: overviewFontSize, design: .rounded))
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
         
            if let releaseDate = movie.releaseDate {
                Text(releaseDate)
                    .font(.system(size: dateFontSize, design: .rounded))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Spacer()
       
        }
        .onAppear {
            imageLoader.loadImage(with: movie.backdropURL)
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        ZStack(alignment: .top) {
            Color.gray.opacity(0.3)
            ProgressView()//TODO: should hide after 30s
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()

            }
        }
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

struct MoviePosterCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieThumbnailView(movie: Movie.stubbedMovie, titleFontSize: 30, overviewFontSize: 20, dateFontSize: 15)
                
        }
    }
}
