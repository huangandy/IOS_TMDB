//
//  SettingViewModel.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/14.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var sorting = UserDefaults.standard.integer(forKey: UserDefaultKeys.sorting.rawValue)
    @Published var layout = UserDefaults.standard.integer(forKey: UserDefaultKeys.layout.rawValue)
    
}

struct SortingType: Hashable, Identifiable, Equatable {
    let name: String
    let tag: Int
    var id: SortingType { self }
    let sortKey: SortKey
    
    enum SortKey {
        case Default
        case Title
        case ReleaseDate
        case Rating
    }
    
    static let sortingTypes = [
        SortingType(name: "By Default", tag: 0, sortKey: .Default),
        SortingType(name: "By Title", tag: 1, sortKey: .Title),
        SortingType(name: "By Release Date", tag: 2, sortKey: .ReleaseDate),
        SortingType(name: "By Rating", tag: 3, sortKey: .Rating),
    ]
}

struct LayoutType: Hashable, Identifiable {
    let name: String
    let tag: Int
    var id: LayoutType { self }
    let column: Int
    let ratio: CGFloat
    
    let titleFontSize: CGFloat
    let overviewFontSize: CGFloat
    let dateFontSize: CGFloat
    
    static let layoutTypes = [
        LayoutType(name: "1 column", tag: 0, column: 1, ratio: 1, titleFontSize: 30, overviewFontSize: 20, dateFontSize: 15),
        LayoutType(name: "2 column", tag: 1, column: 2, ratio: 3/4, titleFontSize: 20, overviewFontSize: 10, dateFontSize: 10),
        LayoutType(name: "3 column", tag: 2, column: 3, ratio: 2/3, titleFontSize: 15, overviewFontSize: 10, dateFontSize: 10),
    ]
}


