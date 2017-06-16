//
//  DataFrame.swift
//  Pods
//
//  Created by Tyler Casselman on 6/8/17.
//
//

public struct DataFrame<RowLabel: Label> {
    public enum Column {
        case intColumn(Series<Int, RowLabel>)
        case doubleColumn(Series<Double, RowLabel>)
        case stringColumn(Series<String, RowLabel>)
        
        init<D>(series: Series<D, RowLabel>) {
            switch series {
            case let intSeries as Series<Int, RowLabel>:
                self = .intColumn(intSeries)
            case let doubleSeries as Series<Double, RowLabel>:
                self = .doubleColumn(doubleSeries)
            case let stringSeries as Series<String, RowLabel>:
                self = .stringColumn(stringSeries)
            default:
                fatalError("Illegal type")
            }
        }
    }
    
    let columns: [Column]
    public init<D>(series: Series<D, RowLabel>) {
        let column = Column(series: series)
        self.init(columns: [column])
    }
    
    init(columns: [Column]) {
        self.columns = columns
    }
}

extension DataFrame: Collection {
    public subscript(position: Int) -> Column {
        return columns[position]
    }
    
    public func index(after i: Int) -> Int {
        return columns.index(after: i)
    }
    
    public var startIndex: Int {
        return columns.startIndex
    }
    
    public var endIndex: Int {
        return columns.endIndex
    }
    
    
}
