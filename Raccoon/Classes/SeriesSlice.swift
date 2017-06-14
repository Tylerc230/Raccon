//
//  SeriesSlice.swift
//  Pods
//
//  Created by Tyler Casselman on 6/12/17.
//
//

public struct SeriesSlice<T, I: DataFrameIndex> {
    var base: Series<T, I>
    let bounds: Range<Index>
    
    public init(base: Series<T, I>, bounds: Range<Index>) {
        self.base = base
        self.bounds = bounds
    }
    
    public subscript(index: I) -> T {
        get {
            return base[index]
        }
        set (newValue) {
            base[index] = newValue
        }
    }
}

extension SeriesSlice: MutableCollection {
    public typealias Index = Series<T, I>.SeriesOffset
    public typealias SubSequence = SeriesSlice<T, I>
    
    public var startIndex: Index {
        return bounds.lowerBound
    }
    
    public var endIndex: Index {
        return bounds.upperBound
    }
    
    public func index(after i: Index) -> Index {
        return base.index(after: i)
    }
    
    public subscript(offset: Index) -> T {
        get {
            return base[offset]
        }
        set (newElement){
            base[offset]  = newElement
        }
    }
}

extension SeriesSlice where I == Int {
    public init(_ base: [T]) {
        self.base = Series(base)
        self.bounds = Index(base.startIndex)..<Index(base.endIndex)
    }
}

extension SeriesSlice: CustomStringConvertible {
    public var description: String {
        let dataDesc = reduce("") { agg, next in
            let nextText = agg.isEmpty ? "\(next)" : ", \(next)"
            return agg + nextText
        }
        return "SeriesSlice(\(dataDesc))"
    }
}



