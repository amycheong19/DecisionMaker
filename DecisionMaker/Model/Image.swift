//
//  Image.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 28/8/20.
//

import Foundation

struct URLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct UnsplashPhoto: Codable {
    let id: String?
    let width: Int
    let height: Int
    let color: String?
    let user: PhotoUser?
    let urls: URLs
    let links: PhotoLinks?
}

struct PhotoUser: Codable {
    let name: String?
    let username: String?
    let portfolio_url: String?
}

struct PhotoLinks: Codable {
    let download_location: String
}

struct PhotoResults: Codable {
    let results: [UnsplashPhoto]
}

