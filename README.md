# Raccoon
[![Swift Version](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat)](http://cocoapods.org/pods/Raccoon)
[![Version](https://img.shields.io/cocoapods/v/Raccoon.svg?style=flat)](http://cocoapods.org/pods/Raccoon)
[![License](https://img.shields.io/cocoapods/l/Raccoon.svg?style=flat)](http://cocoapods.org/pods/Raccoon)
[![Platform](https://img.shields.io/cocoapods/p/Raccoon.svg?style=flat)](http://cocoapods.org/pods/Raccoon)

Raccoon is a data manipulation and analysis library written in Swift. The goal of this library is to be a simplified, strongly typed version of [Pandas](https://pandas.pydata.org/).

## Requirements

- iOS 11.0+
- Xcode 9.0


## Installation

Raccoon is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Raccoon"
```

## Usage
### Series
A `Series` is a one dimensional labeled array much like an ordered dictionary.  Currently `Series` can contain Int, Float or String as values. Label's can be any Hashable, Equatable type.
```swift
let series = try! Series([1, 2, 3], labels: ["first", "second", "third"])
series["first"] //1
series["third"] //3
```
`Series` supports slicing.
```swift
var series = try! Series([1, 2, 3, 4, 5])
series[1..<3] = try! SeriesSlice([20, 30])
series[1] //20
series[2] //30 
```
```swift
let series = try! Series([1, 2, 3, 4, 5], labels: ["a", "b", "c", "d", "e"])
let slice = series["b"..<"d"]!
slice["b"] //2
slice["c"] //3
```

`Series` supports vector operations
```Swift
let series1 = try! Series([1, 2, 3])
let series2 = try! Series([4, 5, 6])
let sum = series1 + series2 //Series([5, 7, 9])
```

### DataFrame
A `DataFrame` is a two dimensional labeled data structure with columns of potentially different types.
`DataFrame` supports indexing.
```swift
let series = try! Series([1, 2, 3], name: 0)
let df = try! DataFrame(series: series)
let result: Series<Int, Int, Int>? = df[0] //Series([1, 2, 3])
```

`DataFrame` supports vector arithmetic on columns.
```swift
let series1 = try! Series([1, 2, 3], name: 0)
let series2 = try! Series([4, 5, 6], name: 1)
let columns = [series1, series2].map (DataFrame.Column.init)
let df = try! DataFrame(columns: columns)
let result: Series<Int, Int, Int> = df[0]! + df[1]! //Series([5, 7, 9])
```




## Author

Tyler Casselman, tyler@13bit.io

## License

Raccoon is available under the MIT license. See the LICENSE file for more info.
