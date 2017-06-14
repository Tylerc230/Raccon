//
//  SeriesSlice.swift
//  Pods
//
//  Created by Tyler Casselman on 6/12/17.
//
//

public struct SeriesSlice<T, I: DataFrameIndex>: MutableCollection {
    var base: Series<T, I>
    let bounds: Range<I>
    public typealias SubSequence = SeriesSlice<T, I>
    public init(base: Series<T, I>, bounds: Range<I>) {
        self.base = base
        self.bounds = bounds
    }
    public var startIndex: I {
        return bounds.lowerBound
    }
    
    public var endIndex: I {
        return bounds.upperBound
    }
    
    public subscript(index: I) -> T {
        get {
            return base[index]
        }
        set (newValue) {
            base[index] = newValue
        }
    }
    
    public func index(after i: I) -> I {
        return base.index(after: i)
    }
}

extension SeriesSlice where I == Int {
    public init(_ base: [T]) {
        self.base = Series(base)
        self.bounds = base.startIndex..<base.endIndex
    }
}
