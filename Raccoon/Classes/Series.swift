//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public struct Series<T, I: DataFrameIndex> {
    private var data: [T]
    internal let indexSet: IndexSet<I>
    
    
    public init(_ data: [T], index: [I]) {
        self.indexSet = IndexSet(fromIndex: index)
        self.data = data
    }
    
    internal init(_ data: [T], indexMap: IndexSet<I>) {
        self.data = data
        self.indexSet = indexMap
    }
    
    public subscript (index: I) -> Iterator.Element {
        get {
            let o = indexSet.offset(forIndex: index)
            return data[o]
        }
        set (newElement){
            let o = indexSet.offset(forIndex: index)
            data[o] = newElement
        }
    }
    
    public subscript(bounds: Range<I>) -> SubSequence {
        get {
            let offsetBounds = indexSet.offsetRange(forIndexRange: bounds)
            let bounds = SeriesOffset(offsetBounds.lowerBound)..<SeriesOffset(offsetBounds.upperBound)
            return SeriesSlice(base: self, bounds: bounds)
        }
        set(newValue) {
            let range = indexSet.offsetRange(forIndexRange: bounds)
            data[range] = ArraySlice(newValue.base.data)
        }
    }
    
    public func map<Transform>(_ transform: (T) throws -> Transform) rethrows -> Series<Transform, I> {
        let values: [Transform] = try map(transform)
        return Series<Transform, I>(values, indexMap: self.indexSet)
    }
}

extension Series where I == Int {
    public init(_ data: [T])  {
        self.init(data, index: Array(0..<data.count))
    }
}

extension Series: MutableCollection {
    public struct SeriesOffset: Comparable {
        let value: Int
        init(_ value: Int) {
            self.value = value
        }
        
        public static func ==(lhs: SeriesOffset, rhs: SeriesOffset) -> Bool {
            return lhs.value == rhs.value
        }
        
        public static func <(lhs: SeriesOffset, rhs: SeriesOffset) -> Bool {
            return lhs.value < rhs.value
        }
    }
    
    public typealias Iterator = AnyIterator<T>
    public typealias SubSequence = SeriesSlice<T, I>
    public typealias Index = SeriesOffset
    
    public func makeIterator() -> Iterator {
        var iterator = data.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }

    public var startIndex: Index {
        return SeriesOffset(data.startIndex)
    }
    
    public var endIndex: Index {
        return SeriesOffset(data.endIndex)
    }
    
    public subscript (offset: Index) -> Iterator.Element {
        get {
            return data[offset.value]
        }
        set (newElement) {
            data[offset.value] = newElement
        }
    }
    
    public subscript (offsetBounds: Range<Index>) -> SubSequence {
        get {
            return SeriesSlice(base: self, bounds: offsetBounds)
        }
        
        set(newSubsequence) {
            let bounds = offsetBounds.lowerBound.value..<offsetBounds.upperBound.value
            data[bounds] = ArraySlice(newSubsequence.base.data)
        }
    }
    
    public func index(after offset: Index) -> Index {
        return Index(data.index(after: offset.value))
    }
}
