//
//  Option.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation

public struct Option: Identifiable, Codable {
    public var id: String
    var title: String
    var picked = 0
    var origin: UnsplashPhoto?
    
    init(id: String, title: String, origin: UnsplashPhoto? = nil, picked: Int? = 0) {
        self.id = id
        self.title = title
        self.origin = origin
        self.picked = picked ?? 0
    }
    
    mutating func pickedIncrement() {
        picked += 1
    }
}

extension Option: Hashable {
    public static func == (lhs: Option, rhs: Option) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Option {
    var pluralizer: String { self.picked == 1 ? "" : "s" }
}


extension Option {
    static let all: [Option] = [
        .macdonald,
        .pizzaHut,
        .burgerKing,
        .domino
    ]

    static let allIDs: [Option.ID] = all.map { $0.id }
    
    static let macdonald = Option(id: "mcdonald", title: "McDonald")
//    Option(id: "mcdonald", title: "McDonald", origin: <#T##UnsplashPhoto?#>,
    
    
    static let pizzaHut = Option(id: "pizzahut", title: "Pizza Hut")

    static let burgerKing = Option(id: "burgerking", title: "Burger King")

    static let domino = Option(id: "domino", title: "Domino")
    
}
