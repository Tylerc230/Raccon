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
                let series = try! Series([1, 2, 3, 4])
                expect(series[0]) == 1
                expect(series[3]) == 4
            }
            
            it("can be created from an array of Doubles") {
                let series = try! Series([1.0, 2.0, 3.0, 4.0])
                expect(series[0]) == 1.0
                expect(series[3]) == 4.0
            }
            
            it("can be created from an array of strings") {
                let series = try! Series(["one", "two", "three", "four"])
                expect(series[0]) == "one"
                expect(series[3]) == "four"
            }
        }
        
        describe("series indices") {
            it("can have strings as indices") {
                let series = try! Series([1, 2, 3], labels: ["first", "second", "third"])
                expect(series["first"]) == 1
                expect(series["third"]) == 3
            }
            
            it("can be modified via subscripting") {
                var series = try! Series([2, 4, 5])
                series[2] = 6
                expect(series[2]) == 6
            }
        }
        
        describe("range subscription") {
            it("can be accessed via range") {
                let series = try! Series([1, 2, 3, 4, 5])
                let slice = series[1..<3]!
                expect(slice.count) == 2
                expect(slice[1]) == 2
                expect(slice[2]) == 3
            }
            
            it("can be modified via range") {
                var series = try! Series([1, 2, 3, 4, 5])
                series[1..<3] = try! SeriesSlice([20, 30])
                expect(series[1]) == 20
                expect(series[2]) == 30
            }
            
            it("can be accessed via string range") {
                let series = try! Series([1, 2, 3, 4, 5], labels: ["a", "b", "c", "d", "e"])
                let slice = series["b"..<"d"]!
                expect(slice.count) == 2
                expect(slice["b"]) == 2
                expect(slice["c"]) == 3
                
            }
        }
        
        describe("vector operators") {
            let series1 = try! Series([1, 2, 3])
            let series2 = try! Series([4, 5, 6])
            let series3 = try! Series<Int, Int, Int>([7, 8], labels: [1, 2])

            it("adds all components of 2 series") {
                let sum = series1 + series2
                let expected = try! Series([5, 7, 9])
                expect(sum).to(haveSameKeysAndValues(expected))
            }
            
            it("sets values for labels that exist in one series but not the other to nil") {
                let sum = series1 + series3
                let expected = try! Series([nil, 9, 11])
                expect(sum).to(haveSameKeysAndValues(expected))
            }

            it("subtracts all components of 2 series") {
                let diff = series2 - series1
                let expected = try! Series([3, 3, 3])
                expect(diff).to(haveSameKeysAndValues(expected))
            }
            
            it("multiply all components of 2 series") {
                let product = series2 * series1
                let expected = try! Series([4, 10, 18])
                expect(product).to(haveSameKeysAndValues(expected))
            }
        }
    }
    
}
