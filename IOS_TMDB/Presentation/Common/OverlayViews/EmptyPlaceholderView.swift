//
//  SwiftUIView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    
    let text: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if let image = image {
                image.imageScale(.large)
                    .font(.system(size: 52))
            }
            Text(text).font(.subheadline).multilineTextAlignment(.center).padding(.horizontal)
            Spacer()
        }
    }
}

struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No Movies", image: Image(systemName: "film"))
    }
}
