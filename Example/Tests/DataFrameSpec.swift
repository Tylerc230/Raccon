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
            it("is creatable from a series") {
                let series = try! Series([1, 2, 3], name: 0)
                let dataframe = try! DataFrame<Int, Int>(series: series)
                let column = dataframe[0]!
                if case let .intColumn(intSeries) = column {
                    expect(intSeries).to(haveSameKeysAndValues(series))
                }else {
                    fail("should return column of ints")
                }
                
            }
        }
    }
}
