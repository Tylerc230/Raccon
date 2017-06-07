//
//  Series.swift
//  Pods
//
//  Created by Tyler Casselman on 6/6/17.
//
//
public struct Series<T: SignedNumber> {
    fileprivate let data: [T]
    public init(_ data: [T]) {
        self.data = data
    }
}

extension Series: Collection {
    public typealias Iterator = AnyIterator<T>
    public func makeIterator() -> Iterator {
        var iterator = data.makeIterator()
        return AnyIterator {
            return iterator.next()
        }
    }

    public typealias Index = Int
    public var startIndex: Index {
        return data.startIndex
    }
    
    public var endIndex: Index {
        return data.endIndex
    }
    
    public subscript (position: Index) -> Iterator.Element {
        return data[position]
    }
    
    public func index(after i: Int) -> Int {
        return data.index(after: i)
    }
}
