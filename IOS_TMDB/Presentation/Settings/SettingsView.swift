//
//  SettingsView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/13.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("UI Control")) {
                Picker("Sorting", selection: $viewModel.sorting) {
                    ForEach(SortingType.sortingTypes.indices, id: \.self) { index in
                        Text(SortingType.sortingTypes[index].name).tag(SortingType.sortingTypes[index].tag)
                    }
                }
                .onChange(of: viewModel.sorting) { tag in
                    UserDefaults.standard.set(tag, forKey: UserDefaultKeys.sorting.rawValue)
                }
                .pickerStyle(.automatic)
                
                Picker("Layout", selection: $viewModel.layout) {
                    ForEach(LayoutType.layoutTypes.indices, id: \.self) { index in
                        Text(LayoutType.layoutTypes[index].name).tag(LayoutType.layoutTypes[index].tag)
                    }
                }.onChange(of: viewModel.layout) { tag in
                    UserDefaults.standard.set(tag, forKey: UserDefaultKeys.layout.rawValue)
                }.pickerStyle(.automatic)
            }
        }
        .scrollDisabled(true)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}

