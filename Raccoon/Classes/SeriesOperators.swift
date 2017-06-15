//
//  SeriesOperators.swift
//  Pods
//
//  Created by Tyler Casselman on 6/13/17.
//
//

extension Series where Value: Numeric {
    public static func +(lhs: Series<Value, L>, rhs: Series<Value, L>) -> Series<Value, L> {
        let labelMap = lhs.labelMap.union(rhs.labelMap)
        let sums = labelMap.map { label -> SeriesEntry in
            guard
                let lValue = lhs[label],
                let rValue = rhs[label]
                else {
                    return SeriesEntry(indexer: label, value: nil)
            }
            return SeriesEntry(indexer: label, value: lValue + rValue)
        }
        return Series(sums, labelMap: labelMap)
    }
}

extension Series where Value: Equatable {
    public static func ==(lhs: Series, rhs: Series) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        return zip(lhs, rhs).reduce(true) { agg, next in
            guard agg else {
                return false
            }
            return next.0 == next.1
        }
    }
}

