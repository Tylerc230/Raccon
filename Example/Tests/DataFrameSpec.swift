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
                let series = Series([1, 2, 3])
                let dataframe = DataFrame<Int>(series: series)
                let column = dataframe[0]
                if case let .intColumn(intSeries) = column {
                    expect(intSeries[0]) == 1
                }else {
                    fail("should return column of ints")
                }
                
            }
        }
    }
}
