//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public typealias Label = Hashable & Comparable
public struct Series<Value: DataType, L: Label, Name: Label> {
    public struct Entry: CustomStringConvertible {
        let indexer: L
        let value: Value?
        public var description: String {
            let valueString = value.map { "\($0)" } ?? "Nan"
            return "<\(indexer): \(valueString)>"
        }
    }
    public let name: Name?
    private var data: [Entry]
    internal let labelMap: LabelMap<L>
    
    
    public init(_ data: [Value?], labels: [L], name: Name?) throws {
        let labelMap = LabelMap(withLabels: labels)
        let data = try Series.createEntries(data: data, labels: labels)
        self.init(data, labelMap: labelMap, name: name)
    }
    
    internal init(_ data: [Entry], labelMap: LabelMap<L>, name: Name?) {
        self.name = name
        self.data = data
        self.labelMap = labelMap
    }
    
    public subscript (label: L) -> Value? {
        get {
            guard let o = labelMap.index(forLabel: label) else {
                return nil
            }
            return self[o].value
        }
        set (newElement){
            if let o = labelMap.index(forLabel: label) {
                self[o] = Entry(indexer: label, value: newElement!)
            }
            
        }
    }
    
    public subscript(bounds: Range<L>) -> SubSequence? {
        get {
            guard let dataRange = labelMap.indexRange(forLabelRange: bounds) else {
                return nil
            }
            return SeriesSlice(base: self, bounds: dataRange)
        }
        set(newValue) {
            guard
                let range = labelMap.indexRange(forLabelRange: bounds),
                let newValue = newValue
                else {
                    return
            }
            self[range] = newValue
        }
    }
    
    public func map<Transform>(_ transform: (Entry) throws -> Series<Transform, L, Name>.Entry) rethrows -> Series<Transform, L, Name> {
        let values: [Series<Transform, L, Name>.Entry] = try map(transform)
        return Series<Transform, L, Name>(values, labelMap: self.labelMap, name: self.name)
    }
    
    private static func createEntries(data: [Value?], labels: [L]) throws -> [Entry] {
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
    public init(_ data: [Value?], name: Name?) throws {
        try self.init(data, labels: Array(0..<data.count), name: name)
    }
}

extension Series where Name == Int {
    public init(_ data: [Value?], labels: [L]) throws {
        try self.init(data, labels: labels, name: nil)
    }
}

extension Series where Name == Int, L == Int {
    public init(_ data: [Value?]) throws {
        try self.init(data, labels: Array(0..<data.count), name: nil)
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
    public typealias Iterator = AnyIterator<Entry>
    public typealias SubSequence = SeriesSlice<Value, L, Name>
    public typealias Index = ValueOffset
    
    public func makeIterator() -> Iterator {
        var iterator = data.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }

    public var startIndex: Index {
        return ValueOffset(data.startIndex)
    }
    
    public var endIndex: Index {
        return ValueOffset(data.endIndex)
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
