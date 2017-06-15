//
//  Index.swift
//  Pods
//
//  Created by Tyler Casselman on 6/8/17.
//
//

public protocol Label:  Hashable, Comparable {
    
}

extension Int: Label { }
extension String: Label { }
