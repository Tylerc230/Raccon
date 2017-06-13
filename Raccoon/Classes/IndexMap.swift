//
//  IndexMap.swift
//  Pods
//
//  Created by Tyler Casselman on 6/12/17.
//
//
struct IndexMap<I: DataFrameIndex> {
    typealias IndexMap = [I: Int]
    typealias ReverseIndexMap = [Int: I]
    fileprivate let indexMap: IndexMap
    fileprivate let reverseIndexMap: ReverseIndexMap
    init(fromIndex index: [I]) {
        indexMap = index
            .enumerated()
            .reduce(IndexMap()) { (result, next) in
                let (offset, element) = next
                var result = result
                result[element] = offset
                return result
        }
        
        reverseIndexMap = indexMap.reduce(ReverseIndexMap()) { (result, next)  in
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
}
