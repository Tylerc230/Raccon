//
//  Index.swift
//  Pods
//
//  Created by Tyler Casselman on 6/8/17.
//
//

public protocol DataFrameIndex: Equatable, Hashable, Comparable {
    
}

extension Int: DataFrameIndex { }
extension String: DataFrameIndex { }