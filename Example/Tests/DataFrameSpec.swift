//
//  DataFrameSpec.swift
//  Raccoon_Tests
//
//  Created by Tyler Casselman on 6/16/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Nimble
import Quick
import Raccoon
class DataFrameSpec: QuickSpec {
    override func spec() {
        describe("data frame creation") {
            let series = try! Series([1, 2, 3], name: "a")
            it("is creatable from a series") {
                let dataframe = try! DataFrame(series: series)
                let intSeries = dataframe["a"]!
                expect(intSeries).to(haveSameKeysAndValues(series))
            }
            
            it("can be created with column names") {
                let df = try! DataFrame(series: series, columnLabel: "A")
                let intSeries = df["A"]!
                expect(intSeries).to(haveSameKeysAndValues(series))
            }
        }
        describe("data frame access") {
            it("subscripting returns the proper type of series") {
                let series = try! Series([1, 2, 3], name: 0)
                let df = try! DataFrame(series: series)
                let result: Series<Int, Int, Int> = df[0]!
                expect(result).to(haveSameKeysAndValues(series))
            }
        }
        describe("arithmetic on 2 columns") {
            it("adds 2 columns of the same type") {
                let series1 = try! Series([1, 2, 3], name: 0)
                let series2 = try! Series([4, 5, 6], name: 1)
                let columns = [series1, series2].map (DataFrame.Column.init)
                let df = try! DataFrame(columns: columns)
                let result = df[0]! + df[1]!
                expect(result).to(haveSameKeysAndValues(try! Series([5, 7, 9])))
            }
            
        }
    }
}
