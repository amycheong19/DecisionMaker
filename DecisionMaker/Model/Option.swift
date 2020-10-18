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
    
    static let macdonald = Option(id: "mcdonald1", title: "McDonald")
    
    
    static let pizzaHut = Option(id: "pizzahut", title: "Pizza Hut")

    static let burgerKing = Option(id: "burgerking", title: "Burger King",
                                   origin: UnsplashPhoto(id: "9H4ycSaekYg", width: 4480, height: 6720,
                                                         color: "#0F0F0E",
                                                         user: PhotoUser(name: "screenpost",
                                                                         username: "SCREEN POST",
                                                                         portfolio_url: "https://www.instagram.com/screen_post"),
                                                         urls: URLs(raw: "https://images.unsplash.com/photo-1589256972986-67e43d0e20dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjE2MTQzOH0",
                                                                    full: "https://images.unsplash.com/photo-1589256972986-67e43d0e20dd?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjE2MTQzOH0",
                                                                    regular: "https://images.unsplash.com/photo-1589256972986-67e43d0e20dd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjE2MTQzOH0",
                                                                    small: "https://images.unsplash.com/photo-1589256972986-67e43d0e20dd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjE2MTQzOH0",
                                                                    thumb: "https://images.unsplash.com/photo-1589256972986-67e43d0e20dd?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjE2MTQzOH0"),
                                                         links: PhotoLinks(download_location: "https://api.unsplash.com/photos/9H4ycSaekYg/download")),
                                   picked: 0)

    static let domino = Option(id: "domino", title: "Domino")
    
}
