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
    var picked = 0
    var imageURLString: String?
    
    
    init(id: String, title: String, imageURLString: String? = nil, picked: Int? = 0) {
        self.id = id
        self.title = title
        self.imageURLString = imageURLString
        self.picked = picked ?? 0
    }
    
    mutating func pickedIncrement() {
        picked += 1
    }
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
    
    static let dominoooo: [Option] = [
        .domino
    ]
    
    static let allIDs: [Option.ID] = all.map { $0.id }
    
    static let macdonald = Option(id: "mcdonald", title: "McDonald")
    
    static let pizzaHut = Option(id: "pizzahut", title: "Pizza Hut")

    static let burgerKing = Option(id: "burgerking", title: "Burger King")

    static let domino = Option(id: "domino", title: "Domino")
    
}
