//
//  SeriesOperators.swift
//  Pods
//
//  Created by Tyler Casselman on 6/13/17.
//
//

//extension Series where Value: Numeric {
//    public static func +(lhs: Series<Value, I>, rhs: Series<Value, I>) -> Series<Value, I> {
//        let commonIndicies = lhs.indexSet.intersecting(rhs.indexSet)
//        let values = commonIndicies.map { index in
//            return (lhs[index], rhs[index])
//        }
//        .map { $0.0 + $0.1 }
//        return Series(values, indexMap: commonIndicies)
//    }
//}

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

