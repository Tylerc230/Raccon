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
        describe("available series data types") {
            it("can be created from an array of Ints") {
                let series = Series([1, 2, 3, 4])
                expect(series[0]) == 1
                expect(series[3]) == 4
            }
            
            it("can be created from an array of Doubles") {
                let series = Series([1.0, 2.0, 3.0, 4.0])
                expect(series[0]) == 1.0
                expect(series[3]) == 4.0
            }
            
            it("can be created from an array of strings") {
                let series = Series(["one", "two", "three", "four"])
                expect(series[0]) == "one"
                expect(series[3]) == "four"
            }
        }
        
        describe("series indices") {
            it("can have strings as indices") {
                let series = Series([1, 2, 3], index: ["first", "second", "third"])
                expect(series["first"]) == 1
                expect(series["third"]) == 3
            }
            
            it("can be modified via subscripting") {
                var series = Series([2, 4, 5])
                series[2] = 6
                expect(series[2]) == 6
            }
        }
        
        describe("range subscription") {
            it("can be accessed via range") {
                let series = Series([1, 2, 3, 4, 5])
                let slice = series[1..<3]
                expect(slice.count) == 2
                expect(slice[1]) == 2
                expect(slice[2]) == 3
            }
            
            it("can be modified via range") {
                var series = Series([1, 2, 3, 4, 5])
                series[1..<3] = Series.SeriesSlice(base: Series([20, 30]), bounds: 0..<2)
                expect(series[1]) == 20
                expect(series[2]) == 30
            }
            
            it("can me accessed via string range") {
                let series = Series([1, 2, 3, 4, 5], index: ["a", "b", "c", "d", "e"])
                let slice = series["b"..<"d"]
                expect(slice.count) == 2
                expect(slice["b"]) == 2
                expect(slice["c"]) == 3
                
            }
        }
    }
    
}
