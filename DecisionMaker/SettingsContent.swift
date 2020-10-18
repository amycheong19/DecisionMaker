//
//  SettingsContent.swift
//  Pickr
//
//  Created by Amy Cheong on 20/9/20.
//

import Foundation

struct SettingsContent {
    enum Info {
        case privacyPolicy
        case termsAndConditions
        
        var title: String {
            switch self {
            case .privacyPolicy: return "Privacy Policy"
            case .termsAndConditions: return "Terms & Conditions"
            }
        }
        
        var iconString: String {
            switch self {
            case .privacyPolicy: return "hand.raised"
            case .termsAndConditions: return "t.bubble.fill"
            }
        }
        
        var link: String {
            switch self {
            case .privacyPolicy: return "https://pickr.flycricket.io/privacy.html"
            case .termsAndConditions: return "https://pickr.flycricket.io/terms.html"
            }
        }
    }

}
