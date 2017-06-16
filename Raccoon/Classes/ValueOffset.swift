//
//  ValueOffset.swift
//  Nimble
//
//  Created by Tyler Casselman on 6/16/17.
//

public struct ValueOffset: Comparable {
    let value: Int
    init(_ value: Int) {
        self.value = value
    }
    
    public static func ==(lhs: ValueOffset, rhs: ValueOffset) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func <(lhs: ValueOffset, rhs: ValueOffset) -> Bool {
        return lhs.value < rhs.value
    }
}

