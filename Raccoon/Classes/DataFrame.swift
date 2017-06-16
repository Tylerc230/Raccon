//
//  DataFrame.swift
//  Pods
//
//  Created by Tyler Casselman on 6/8/17.
//
//

struct DataFrame<RowLabel, ColumnLabel> {
    enum ColumnType {
        case intColumn(Series<RowLabel, Int>), doubleColumn(Series<RowLabel, Double>)
    }
    init() {}
}
