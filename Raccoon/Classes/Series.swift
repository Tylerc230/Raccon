//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public struct Series<Value, L: Label> {
    public typealias SeriesEntry = Entry
    public struct Entry: CustomStringConvertible {
        let indexer: L
        let value: Value?
        public var description: String {
            let valueString = value.map { "\($0)" } ?? "Nan"
            return "<\(indexer): \(valueString)>"
        }
    }
    
    private var data: [SeriesEntry]
    internal let labelMap: LabelMap<L>
    
    
    public init(_ data: [Value?], labels: [L]) throws {
        self.labelMap = LabelMap(withLabels: labels)
        self.data = try Series.createEntries(data: data, labels: labels)
    }
    
    internal init(_ data: [SeriesEntry], labelMap: LabelMap<L>) {
        self.data = data
        self.labelMap = labelMap
    }
    
    public subscript (label: L) -> Value? {
        get {
            guard let o = labelMap.index(forLabel: label) else {
                return nil
            }
            return data[o].value
        }
        set (newElement){
            if let o = labelMap.index(forLabel: label) {
                data[o] = SeriesEntry(indexer: label, value: newElement!)
            }
            
        }
    }
    
    public subscript(bounds: Range<L>) -> SubSequence? {
        get {
            guard let offsetBounds = labelMap.indexRange(forLabelRange: bounds) else {
                return nil
            }
            let bounds = SeriesOffset(offsetBounds.lowerBound)..<SeriesOffset(offsetBounds.upperBound)
            return SeriesSlice(base: self, bounds: bounds)
        }
        set(newValue) {
            guard
                let range = labelMap.indexRange(forLabelRange: bounds),
                let newValue = newValue
                else {
                    return
            }
            data[range] = ArraySlice(newValue.base.data)
        }
    }
    
    public func map<Transform>(_ transform: (SeriesEntry) throws -> Series<Transform, L>.Entry) rethrows -> Series<Transform, L> {
        let values: [Series<Transform, L>.Entry] = try map(transform)
        return Series<Transform, L>(values, labelMap: self.labelMap)
    }
    
    private static func createEntries(data: [Value?], labels: [L]) throws -> [SeriesEntry] {
        guard data.count == labels.count else {
            throw Err("data and index must have the same length")
        }
        return zip(labels, data).map {
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
    public init(_ data: [Value?]) {
        try! self.init(data, labels: Array(0..<data.count))
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
