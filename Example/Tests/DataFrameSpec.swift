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
                let column = dataframe["a"]!
                if case let .intColumn(intSeries) = column {
                    expect(intSeries).to(haveSameKeysAndValues(series))
                }else {
                    fail("should return column of ints")
                }
            }
            
            it("can be created with column names") {
                let df = try! DataFrame(series: series, columnLabel: "A")
                let column = df["A"]!
                if case let .intColumn(intSeries) = column {
                    expect(intSeries).to(haveSameKeysAndValues(series))
                } else {
                    fail("should return column of ints")
                }
            }
        }
    }
}
