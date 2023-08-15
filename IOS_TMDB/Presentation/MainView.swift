//
//  MainView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView { NowPlayingView() }.tabItem {
                VStack {
                    Image(systemName: "tv")
                    Text("Now Playing")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(0)
            
            NavigationView { FavoriteView() }.tabItem {
                VStack {
                    Image(systemName: "heart")
                    Text("Favorite")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(1)
            
            NavigationView { SettingsView() }.tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(2)

        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
           
            MainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro")) .previewDisplayName("iPhone 12 Pro Portrait")
            
            
            MainView()
            .navigationViewStyle(StackNavigationViewStyle()).previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
                .previewDisplayName("iPad Air")
            
            
            MainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro")) .previewDisplayName("iPhone 12 Pro") .previewInterfaceOrientation(.landscapeRight)
        }
        
    }
}
