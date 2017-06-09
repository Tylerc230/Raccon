//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public struct Series<T, I: DataFrameIndex> {
    fileprivate typealias IndexMap = [I: Int]
    fileprivate typealias ReverseIndexMap = [Int: I]
    fileprivate let data: [T]
    fileprivate let indexMap: IndexMap
    fileprivate let reverseIndexMap: ReverseIndexMap
    
    
    public init(_ data: [T], index: [I]) {
        let indexMap = Series.indexMap(fromIndex: index)
        self.init(data, indexMap: indexMap)
    }
    
    fileprivate init(_ data: [T], indexMap: IndexMap) {
        self.indexMap = indexMap
        self.reverseIndexMap = indexMap.reduce(ReverseIndexMap()) { (result, next)  in
            let (key, value) = next
            var result = result
            result[value] = key
            return result
        }
        self.data = data
    }
    
    fileprivate static func indexMap(fromIndex index: [I]) -> IndexMap {
        return index
            .enumerated()
            .reduce(IndexMap()) { (result, next) in
                let (offset, element) = next
                var result = result
                result[element] = offset
                return result
        }
    }
}

extension Series where I == Int {
    public init(_ data: [T])  {
        let indexMap = Series.indexMap(fromIndex: Array(0..<data.count))
        self.init(data, indexMap: indexMap)
    }
}


extension Series: Collection {
    public typealias Index = I
    public typealias Iterator = AnyIterator<T>
    public func makeIterator() -> Iterator {
        var iterator = data.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }

    public var startIndex: I {
        guard let index = reverseIndexMap[data.startIndex] else {
            fatalError("start index does not exist")
        }
        return index
    }
    
    public var endIndex: I {
        guard let index = reverseIndexMap[data.endIndex] else {
            fatalError("end index does not exist")
        }
        return index
    }
    
    public subscript (position: I) -> Iterator.Element {
        guard let offset = indexMap[position] else {
            fatalError("Subscript does not exist")
        }
        return data[offset]
    }
    
    public func index(after i: I) -> I {
        guard let offset = indexMap[i] else {
            fatalError("Index not found")
        }
        let offsetAfter = data.index(after: offset)
        guard let ret = reverseIndexMap[offsetAfter] else {
            fatalError("reverse index not found")
        }
        return ret
    }
}
