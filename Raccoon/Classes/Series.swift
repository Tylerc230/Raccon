//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public struct Series<Value, L: Label> {
    public typealias SeriesEntry = Entry
    public struct Entry {
        let indexer: L
        let value: Value
    }
    
    private var data: [SeriesEntry]
    internal let indexSet: LabelMap<L>
    
    
    public init(_ data: [Value], index: [L]) throws {
        self.indexSet = LabelMap(withLabels: index)
        self.data = try Series.createEntries(data: data, index: index)
    }
    
    internal init(_ data: [SeriesEntry], indexMap: LabelMap<L>) {
        self.data = data
        self.indexSet = indexMap
    }
    
    public subscript (index: L) -> Value {
        get {
            let o = indexSet.index(forLabel: index)
            return data[o].value
        }
        set (newElement){
            let o = indexSet.index(forLabel: index)
            data[o] = SeriesEntry(indexer: index, value: newElement)
        }
    }
    
    public subscript(bounds: Range<L>) -> SubSequence {
        get {
            let offsetBounds = indexSet.indexRange(forLabelRange: bounds)
            let bounds = SeriesOffset(offsetBounds.lowerBound)..<SeriesOffset(offsetBounds.upperBound)
            return SeriesSlice(base: self, bounds: bounds)
        }
        set(newValue) {
            let range = indexSet.indexRange(forLabelRange: bounds)
            data[range] = ArraySlice(newValue.base.data)
        }
    }
    
    public func map<Transform>(_ transform: (SeriesEntry) throws -> Series<Transform, L>.Entry) rethrows -> Series<Transform, L> {
        let values: [Series<Transform, L>.Entry] = try map(transform)
        return Series<Transform, L>(values, indexMap: self.indexSet)
    }
    
    private static func createEntries(data: [Value], index: [L]) throws -> [SeriesEntry] {
        guard data.count == index.count else {
            throw Err("data and index must have the same length")
        }
        return zip(index, data).map {
            return Entry(indexer: $0.0, value: $0.1)
        }
    }
}

extension Series.Entry where Value: Equatable {
    public static func ==(lhs: Series.Entry, rhs: Series.Entry) -> Bool {
        return lhs.value == rhs.value && lhs.indexer == rhs.indexer
    }
}

extension Series where L == Int {
    public init(_ data: [Value]) {
        try! self.init(data, index: Array(0..<data.count))
    }
}

extension Series: CustomStringConvertible {
    public var description: String {
        let dataDesc = reduce("") { agg, next in
            let nextText = agg.isEmpty ? "\(next)" : ", \(next)"
            return agg + nextText
        }
        return "Series(\(dataDesc))"
    }
}

extension Series: MutableCollection {
    public typealias Iterator = AnyIterator<SeriesEntry>
    public typealias SubSequence = SeriesSlice<Value, L>
    public typealias Index = SeriesOffset
    
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
