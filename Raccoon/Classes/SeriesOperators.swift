//
//  SeriesOperators.swift
//  Pods
//
//  Created by Tyler Casselman on 6/13/17.
//
//

extension Series where Value: Numeric {
//    public static func +(lhs: Series<Value, L>, rhs: Series<Value, L>) -> Series<Value, L> {
//    }
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

