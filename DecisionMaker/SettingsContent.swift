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
        case about
        
        var title: String {
            switch self {
            case .privacyPolicy: return "Privacy Policy"
            case .termsAndConditions: return "Terms & Conditions"
            case .about: return "About this app"
            }
        }
        
        var iconString: String {
            switch self {
            case .privacyPolicy: return "hand.raised"
            case .termsAndConditions: return "t.bubble.fill"
            case .about: return "doc.append"
            }
        }
        
        var link: String {
            switch self {
            case .privacyPolicy: return "https://pickr.flycricket.io/privacy.html"
            case .termsAndConditions: return "https://pickr.flycricket.io/terms.html"
            case .about: return "https://bit.ly/3jndKBx"
            }
        }
    }

}
