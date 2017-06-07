//
//  SeriesSpec.swift
//  Raccoon
//
//  Created by Tyler Casselman on 6/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Raccoon
class SeriesSpec: QuickSpec {
    override func spec() {
        describe("an object describing a one dimensional array of numbers") {
            it("can be created from an array") {
                let series = Series([1, 2, 3, 4])
                expect(series[0]) == 1
                expect(series[3]) == 4
            }
        }
    }
    
}
