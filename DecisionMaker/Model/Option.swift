//
//  Option.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 9/8/20.
//

import Foundation

struct Option: Identifiable, Codable {
    var id: String
    var title: String
}

extension Option: Hashable {
    static func == (lhs: Option, rhs: Option) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension Option {
    static let all: [Option] = [
        .macdonald,
        .pizzaHut,
        .burgerKing,
        .domino
    ]
    
    static let allIDs: [Option.ID] = all.map { $0.id }
    
    static let macdonald = Option(id: "macdonald", title: "MacDonald")
    
    static let pizzaHut = Option(id: "pizzahut", title: "Pizza Hut")

    static let burgerKing = Option(id: "burgerking", title: "Burger King")

    static let domino = Option(id: "domino", title: "Domino")

    
    init?(for id: Option.ID) {
        guard let option = Option.all.first(where: { $0.id == id }) else { return nil }
        self = option
    }
}
