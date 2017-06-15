//
//  Index.swift
//  Pods
//
//  Created by Tyler Casselman on 6/8/17.
//
//

public protocol Indexer:  Hashable, Comparable {
    
}

extension Int: Indexer { }
extension String: Indexer { }
