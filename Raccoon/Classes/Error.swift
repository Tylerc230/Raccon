//
//  Error.swift
//  Nimble
//
//  Created by Tyler Casselman on 6/15/17.
//

struct Err: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}
