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
    case failure(V, Error)
    
    var value: V? {
        if case .success(let v) = self{
            return v
        }
        if case .failure(let v, _) = self{
            return v
        }
        return nil
    }
    
    
}
