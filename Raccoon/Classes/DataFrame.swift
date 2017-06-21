//
//  DataFrame.swift
//  Pods
//
//  Created by Tyler Casselman on 6/8/17.
//
//

public struct DataFrame<RowLabel: Label, ColumnLabel: Label> {
    public enum Column {
        case intColumn(Series<Int, RowLabel, ColumnLabel>)
        case doubleColumn(Series<Double, RowLabel, ColumnLabel>)
        case stringColumn(Series<String, RowLabel, ColumnLabel>)
        
        init<D>(series: Series<D, RowLabel, ColumnLabel>) {
            switch series {
            case let intSeries as Series<Int, RowLabel, ColumnLabel>:
                self = .intColumn(intSeries)
            case let doubleSeries as Series<Double, RowLabel, ColumnLabel>:
                self = .doubleColumn(doubleSeries)
            case let stringSeries as Series<String, RowLabel, ColumnLabel>:
                self = .stringColumn(stringSeries)
            default:
                fatalError("Illegal type")
            }
        }
        
        func name() throws -> ColumnLabel {
            let label: ColumnLabel?
            switch self {
            case .doubleColumn(let series):
                label = series.name
            case .intColumn(let series):
                label = series.name
            case .stringColumn(let series):
                label = series.name
            }
            guard let l = label else {
                throw Err("Columns must have series names")
            }
            return l
        }
    }
    let labelMap: LabelMap<ColumnLabel>
    let columns: [Column]
    public init<D>(series: Series<D, RowLabel, ColumnLabel>) throws {
        let column = Column(series: series)
        try self.init(columns: [column])
    }
    
    init(columns: [Column]) throws {
        self.columns = columns
        let labels = try columns.map { try $0.name()}
        self.labelMap = LabelMap(withLabels: labels)
    }
    
    public subscript(columnLabel: ColumnLabel) -> Column? {
        guard let offset = labelMap.index(forLabel: columnLabel) else {
            return nil
        }
        return self[offset]
    }
}

extension DataFrame: Collection {
    public typealias Index = ValueOffset
    public subscript(offset: Index) -> Column {
        return columns[offset.value]
    }
    
    public func index(after offset: Index) -> Index {
        let index = columns.index(after: offset.value)
        return ValueOffset(index)
    }
    
    public var startIndex: Index {
        return ValueOffset(columns.startIndex)
    }
    
    public var endIndex: Index {
        return ValueOffset(columns.endIndex)
    }
    
    
}
