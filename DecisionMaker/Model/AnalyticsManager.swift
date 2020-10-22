//
//  AnalyticsManager.swift
//  Pickr
//
//  Created by Amy Cheong on 21/10/20.
//

import Foundation
import Mixpanel

struct AnalyticsManager {
    static let shared: MixpanelInstance = {
        #if DEBUG
        return Mixpanel.initialize(token: "1bc5ba8a12b0d0da473d9a0c1f33a422")
        #endif
        return Mixpanel.initialize(token: "93122dbd6b3ce331c4c2255ad5db213a")
    }()
    
    enum Tag: String {
        case collectionID
        case collectionName
        case collectionCount
        case optionsCount
    }
    
    static func setCollection(collection: Collection) -> [String: MixpanelType] {
        return [AnalyticsManager.Tag.collectionID.rawValue: "\(collection.id)",
                AnalyticsManager.Tag.collectionName.rawValue: "\(collection.title)",
                AnalyticsManager.Tag.optionsCount.rawValue: "\(collection.options.count)"]
    }
    
    static func setCollectionCount(collections: [Collection]) -> [String: MixpanelType] {
        return [AnalyticsManager.Tag.collectionCount.rawValue: "\(collections.count)"]
    }
}
