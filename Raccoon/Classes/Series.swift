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
}

extension Series where I == Int {
    public init(_ data: [T])  {
        self.init(data, index: Array(0..<data.count))
    }
}


extension Series: MutableCollection {
    public typealias Index = I
    public typealias Iterator = AnyIterator<T>
    public typealias SubSequence = SeriesSlice<T, I>
    public func makeIterator() -> Iterator {
        var iterator = data.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }

    public var startIndex: I {
        return indexSet.index(forOffset: data.startIndex)
    }
    
    public var endIndex: I {
        return indexSet.index(forOffset: data.endIndex)
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
            return SeriesSlice(base: self, bounds: bounds)
        }
        set(newValue) {
            let range = indexSet.offsetRange(forIndexRange: bounds)
            data[range] = ArraySlice(newValue.base.data)
        }
    }

    public func index(after i: I) -> I {
        let offset = indexSet.offset(forIndex: i)
        let offsetAfter = data.index(after: offset)
        return indexSet.index(forOffset: offsetAfter)
    }
    
    public func map<Transform>(_ transform: (T) throws -> Transform) rethrows -> Series<Transform, I> {
        let values: [Transform] = try map(transform)
        return Series<Transform, I>(values, indexMap: self.indexSet)
    }
}
