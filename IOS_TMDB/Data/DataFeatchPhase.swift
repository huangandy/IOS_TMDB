//
//  DataFeatchPhase.swift
//  IOS_TMDB
//
//  Created by huangtengwei on 2023/8/12.
//

import Foundation

enum DataFetchPhase<V> {
    case empty
    case success(V)
    case failure(Error)
    
    var value: V? {
        if case .success(let v) = self {
            return v
        }
        return nil
    }
    
    
}
