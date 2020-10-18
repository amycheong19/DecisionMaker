//
//  URL+UnSplash.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 28/8/20.
//

import Foundation

struct PhotoConfiguration {
    static var shared: UnsplashPhotoConfiguration = UnsplashPhotoConfiguration()
}

/// Encapsulates configuration information for the behavior of UnsplashPhotoPicker.
public struct UnsplashPhotoConfiguration {

    /// Your application’s access key.
    public var accessKey = "Client-ID eAuZQdNO50kyz1haJeAlMS_sKa5J0JCBrvWUsLbKACA"

    public var scheme = "https"
    
    public var host = "api.unsplash.com"

    public var path = "/search/photos"

    public var queryItems = [
        URLQueryItem(name: "page", value: "1"),
        URLQueryItem(name: "per_page", value: "3"),
        URLQueryItem(name: "fit", value: "crop"),
        URLQueryItem(name: "w", value: "96"),
        URLQueryItem(name: "h", value: "96")
    ]

    
    init() {}

}


extension URL {

    
    static func with(query: String? = nil) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = PhotoConfiguration.shared.scheme
        urlComponents.host = PhotoConfiguration.shared.host
        urlComponents.path = PhotoConfiguration.shared.path
        var items = PhotoConfiguration.shared.queryItems
        items.append(URLQueryItem(name: "query", value: query))
        urlComponents.queryItems = items
        
        return urlComponents.url!
    }
    
}
