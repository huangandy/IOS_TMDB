//
//  DataFetchOverlayView.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import SwiftUI

protocol EmptyData {
    var isEmpty: Bool { get }
}

struct DataFetchPhaseOverlayView<V: EmptyData>: View {
    
    let phase: DataFetchPhase<V>
    let skeleton: AnyView
    let retryAction: () -> ()
    
    var body: some View {
        switch phase {
        case .empty:
            skeleton
        case .success(let value) where value.isEmpty:
            EmptyPlaceholderView(text: "No Data", image: Image(systemName: "tv"))
        case .failure(_, let error):
            RetryView(text: error.localizedDescription, retryAction: retryAction)
        default:
            EmptyView()
        }
        
    }
}

extension Array: EmptyData {}
extension Optional: EmptyData {
    
    var isEmpty: Bool {
        if case .none = self {
            return true
        }
        return false
    }
    
}

struct DataFetchPhaseOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataFetchPhaseOverlayView(phase: .success([]), skeleton: AnyView(ProgressView())) {
                print("Retry")
            }
            
            DataFetchPhaseOverlayView<Movie?>(phase: .failure(nil, MovieError.invalidResponse), skeleton: AnyView(ProgressView())) {
                print("Retry")
            }
            
            DataFetchPhaseOverlayView<[Movie]>(phase: .empty, skeleton: AnyView(ProgressView())) {
                print("Retry")
            }
        }
        
    }
}
