//
//  IndexMap.swift
//  Pods
//
//  Created by Tyler Casselman on 6/12/17.
//
//
struct IndexSet<I: DataFrameIndex> {
    fileprivate let indicies: [I]
    private let indexMap: [I: Int]
    private let reverseIndexMap: [Int: I]
    public let startIndex: Int
    public let endIndex: Int
    init(fromIndex index: [I]) {
        self.indicies = index
        startIndex = index.startIndex
        endIndex = index.endIndex
        indexMap = index
            .enumerated()
            .reduce([:]) { (result, next) in
                let (offset, element) = next
                var result = result
                result[element] = offset
                return result
        }
        
        reverseIndexMap = indexMap.reduce([:]) { (result, next)  in
            let (key, value) = next
            var result = result
            result[value] = key
            return result
        }
    }
    
    func offset(forIndex index: I) -> Int {
        guard let offset = indexMap[index] else {
            fatalError("Invalid index")
        }
        return offset
    }
    
    func index(forOffset offset: Int) -> I {
        guard let index = reverseIndexMap[offset] else {
            fatalError("Invalid offset")
        }
        return index
    }
    
    func offsetRange(forIndexRange indexRange: Range<I>) -> Range<Int> {
        let lower = offset(forIndex: indexRange.lowerBound)
        let upper = offset(forIndex: indexRange.upperBound)
        return lower..<upper
    }
    
    func indexRange(forOffsetRange offsetRange: Range<Int>) -> Range<I> {
        let lower = index(forOffset: offsetRange.lowerBound)
        let upper = index(forOffset: offsetRange.upperBound)
        return lower..<upper
    }
    
    func intersecting(_ other: IndexSet) -> IndexSet {
        let indices = Set(indicies)
        let otherIndicies = Set(other.indicies)
        let intersect = indices.intersection(otherIndicies)
        return IndexSet(fromIndex: Array(intersect))
    }
    
    func getIndex(after: Int) -> Int {
        return indicies.index(after: after)
    }
}

extension IndexSet: Collection {
    public subscript (offset: Int) -> I {
        return indicies[offset]
    }
    
    public func index(after: Int) -> Int {
        return getIndex(after: after)
    }
}
