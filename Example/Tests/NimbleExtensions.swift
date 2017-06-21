//
//  NimbleExtensions.swift
//  Raccoon_Tests
//
//  Created by Tyler Casselman on 6/14/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//
import Raccoon
import Quick
import Nimble

public func equal<T: Equatable, I, Name>(_ expectedValue: Series<T, I, Name>) -> MatcherFunc<Series<T, I, Name>> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal \(expectedValue)"
        guard let actualValue = try actualExpression.evaluate() else {
            return false
        }
        return expectedValue == actualValue
    }
}

public func haveSameKeysAndValues<T: Equatable, I, Name>(_ expectedValue: Series<T, I, Name>) -> MatcherFunc<Series<T, I, Name>> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "have same keys and values as \(expectedValue)"
        guard let actualValue = try actualExpression.evaluate() else {
            return false
        }
        return actualValue.hasSameKeysAndValues(as: expectedValue)
    }
}
