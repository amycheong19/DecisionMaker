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

extension Collection {
    init?(for id: Collection.ID) {
        guard let collection = Collection.all.first(where: { $0.id == id }) else { return nil }
        self = collection
    }
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
    
    static let restaurants = Collection(id: "fastfoods",
                                        title: "Fast Foods",
                                        options: Option.all)
        
}
