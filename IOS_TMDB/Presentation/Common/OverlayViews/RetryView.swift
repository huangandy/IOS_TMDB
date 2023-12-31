//
//  RetryView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

struct RetryView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .foregroundColor(Color.red)
                .frame(width: 100, height: 100)
            Text(text)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Retry")
                .font(.title)
            }
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(text: "An Error occured") {
            print("Retry Clicked")
        }
    }
}
