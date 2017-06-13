//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public struct Series<T, I: DataFrameIndex> {
    public typealias SeriesSlice = Slice<Series<T, I>>
    fileprivate var data: [T]
    fileprivate let indexMap: IndexMap<I>
    
    
    public init(_ data: [T], index: [I]) {
        self.indexMap = IndexMap(fromIndex: index)
        self.data = data
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
    public typealias SubSequence = SeriesSlice
    public func makeIterator() -> Iterator {
        var iterator = data.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }

    public var startIndex: I {
        return indexMap.index(forOffset: data.startIndex)
    }
    
    public var endIndex: I {
        return indexMap.index(forOffset: data.endIndex)
    }
    
    public subscript (index: I) -> Iterator.Element {
        get {
            let o = indexMap.offset(forIndex: index)
            return data[o]
        }
        set (newElement){
            let o = indexMap.offset(forIndex: index)
            data[o] = newElement
        }
    }
    
    public subscript(bounds: Range<I>) -> SubSequence {
        get {
            return SubSequence(base: self, bounds: bounds)
        }
        set(newValue) {
            let range = indexMap.offsetRange(forIndexRange: bounds)
            data[range] = ArraySlice(newValue.base.data)
        }
    }

    public func index(after i: I) -> I {
        let offset = indexMap.offset(forIndex: i)
        let offsetAfter = data.index(after: offset)
        return indexMap.index(forOffset: offsetAfter)
    }
}
