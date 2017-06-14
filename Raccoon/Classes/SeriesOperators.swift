//
//  SeriesOperators.swift
//  Pods
//
//  Created by Tyler Casselman on 6/13/17.
//
//

extension Series where T: Numeric {
    public static func +(lhs: Series<T, I>, rhs: Series<T, I>) -> Series<T, I> {
        let commonIndicies = lhs.indexSet.intersecting(rhs.indexSet)
        let values = commonIndicies.map { index in
            return (lhs[index], rhs[index])
        }
        .map { $0.0 + $0.1 }
        return Series(values, indexMap: commonIndicies)
    }
}

