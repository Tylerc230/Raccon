//
//  IndexMap.swift
//  Pods
//
//  Created by Tyler Casselman on 6/12/17.
//
//
struct LabelMap<L: Label> {
    fileprivate let labels: [L]
    private let labelIndexMap: [L: Int]
    public let startIndex: Int
    public let endIndex: Int
    init(withLabels labels: [L]) {
        self.labels = labels
        startIndex = labels.startIndex
        endIndex = labels.endIndex
        labelIndexMap = labels
            .enumerated()
            .reduce([:]) { (result, next) in
                let (offset, element) = next
                var result = result
                result[element] = offset
                return result
        }        
    }
    
    func index(forLabel label: L) -> Int {
        guard let offset = labelIndexMap[label] else {
            fatalError("Invalid index")
        }
        return offset
    }
    
    func indexRange(forLabelRange labelRange: Range<L>) -> Range<Int> {
        let lower = index(forLabel: labelRange.lowerBound)
        let upper = index(forLabel: labelRange.upperBound)
        return lower..<upper
    }
    
    func getIndex(after: Int) -> Int {
        return labels.index(after: after)
    }
}

extension LabelMap: Collection {
    public subscript (offset: Int) -> L {
        return labels[offset]
    }
    
    public func index(after: Int) -> Int {
        return getIndex(after: after)
    }
}