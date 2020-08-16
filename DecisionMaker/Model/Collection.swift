//
//  Collection.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 10/8/20.
//

import Foundation

struct Collection: Identifiable, Codable {
    var id: String
    var title: String
    var options: [Option] = []
}

extension Collection: Hashable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Collection {
    static let all: [Collection] = [
        .restaurants
    ]
    
    static let restaurants = Collection(id: "restaurants_____",
                                        title: "Restaurants232323", options: Option.all)
    
    static let restaurants1 = Collection(id: "restaurants11",
                                        title: "Restaurants11", options: Option.all)
}
